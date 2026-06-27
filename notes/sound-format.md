# Bongo sound engine & data format

How Bongo's music and sound effects work, from the chip up to the byte layout of
the song data. All symbol/address references are to `bongo.asm`.

## TL;DR — is it a standard format?

Two layers, two answers:

- **The hardware is 100% standard.** Sound is a **General Instrument AY-3-8910**
  PSG (3 square-wave tone channels + 1 noise generator + a hardware envelope
  generator). It's driven through the chip's normal *latch-address / write-data*
  protocol and its standard register map. Nothing exotic.
- **The music/SFX data format is bespoke.** The byte layout of songs → voices →
  patterns → note/duration pairs, the `$EE` loop opcode, the `$FF` terminators,
  the note-index lookup table, and the *software* volume envelope are all a
  custom in-house sound driver. There is no industry-standard "AY music format" —
  every game rolled its own, and this is Bongo's.

Two things stand out as non-obvious design choices: the driver **doesn't use the
AY's hardware envelope generator at all** (volume decay is done in software by
decrementing the amplitude register), and the **noise channel is disabled
entirely** (tone only). The note→pitch table was, per the author's comments,
hand-tuned by ear and contains mistakes.

---

## 1. The chip: AY-3-8910 (standard)

Accessed via three Z80 I/O ports (`bongo.asm` ~line 414):

| Port | Symbol | Use |
|------|--------|-----|
| `$00` | `aysnd_write_0` | **latch**: select which AY register to write |
| `$01` | `aysnd_write_1` | **data**: value written to the latched register |
| `$02` | `aysnd_read`    | read back the latched register |

**Write protocol** (standard AY): output the register number to `$00`, then the
value to `$01`. Every write in the engine is this pair, e.g. `write_aysnd_chA_all`
(~8311):

```
ld a,ay_chA_tone   ; = $01  (register number)
out (aysnd_write_0),a
ld a,(hl)          ; coarse period byte
out (aysnd_write_1),a
```

**Register map used** (`bongo.asm` ~418):

| Reg | Symbol | Meaning |
|-----|--------|---------|
| `$00/$01` | `ay_chA_tone_fine` / `ay_chA_tone` | channel A tone period (12-bit: 8 fine + 4 coarse) |
| `$02/$03` | chB tone fine/coarse | channel B tone period |
| `$04/$05` | chC tone fine/coarse | channel C tone period |
| `$06` | `ay_noise_period` | noise period (**unused** — noise disabled) |
| `$07` | `ay_enable` | mixer: tone/noise enable per channel |
| `$08/$09/$0A` | `ay_chA/B/C_env_vol` | channel amplitude (bit5 = use HW envelope; **never set** here) |
| `$0B–$0D` | env period / shape | hardware envelope (**unused**) |
| `$0E` | `ay_port_a` | parallel I/O port A — used by the game to *read inputs/DSW*, not for sound |

**Mixer init** (`init_aysnd`, ~4564): writes R7 = `$38` = `0011 1000`. Decoding
the standard R7 bit layout (0 = enable, 1 = disable):

```
bit 5/4/3 (noise C/B/A) = 1,1,1  -> noise OFF on all channels
bit 2/1/0 (tone  C/B/A) = 0,0,0  -> tone  ON  on all channels
```

So it's **tone on / noise off, all three channels**. (The in-source comment
"all channels noise on" is mislabeled — it's the opposite.)

**Tone pitch.** AY tone frequency = `f_clock / (16 × period)`, where `period` is
the 12-bit value `(coarse << 8) | fine`. Higher pitch = smaller period — which is
exactly how the lookup table is ordered.

---

## 2. Per-frame driver

`audio_system` (~5186) is called once per frame from the NMI handler. Order:

1. `write_aysnd_data_chA` → push channel A's current state to the AY.
2. `write_aysnd_data_chB`, `write_aysnd_data_chC` → same for B and C.
3. `tick_all_songs_or_load_new` (~9314) → advance the sequencer(s): either load a
   newly-requested song or tick the currently-playing one, stepping note timers
   and loading the next note when due.

(The calls go through a `jmp_hl_plus_4k` indirection because the routines live in
a different 4K ROM bank — a banking quirk, not part of the format.)

So each frame: **emit current notes to hardware, then advance the sequence.**

---

## 3. Two structures: songs vs. channels

The design decouples *sequences* from *hardware channels*. There are two
separate sets of RAM structs:

### Song / sequencer struct — 24 bytes each
`sng1_base $82B8`, `sng2_base $82D0`, `sng3_base $82E8`. Holds where each of up to
**3 concurrent songs** is in its sequence (`bongo.asm` ~207):

| Offset | Meaning |
|--------|---------|
| `+01/+02` | voice 0: pointer into its **pattern list** (moving cursor) |
| `+03/+04` | voice 1: pattern-list cursor |
| `+05/+06` | voice 2: pattern-list cursor |
| `+07/+08` | voice 0: pointer into current **note data** |
| `+09/+0A` | voice 1: note-data pointer |
| `+0B/+0C` | voice 2: note-data pointer |
| `+0D` | **number of voices** (2 or 3) |
| `+0E` | `len`       — envelope/fade rate (from meta) |
| `+0F` | `velocity`  — note-length multiplier / tempo (from meta) |
| `+10` | `volume`    — base amplitude (from meta) |
| `+11` | `transpose` — added to every note index (from meta) |
| `+12/+13/+14` | per-channel note-duration countdown (A/B/C) |

### Channel / output struct — 8 bytes each
`chA_data $82A0`, `chB_data $82A8`, `chC_data $82B0`. Holds the immediate values
to push to AY channel A/B/C (`bongo.asm` ~190):

| Offset | Meaning |
|--------|---------|
| `+00` | current note index (0 = rest/silent) |
| `+02` | current volume (0–15) |
| `+03` | `len` (envelope tick reload) |
| `+04` | new-note flag (1 = pitch changed this frame) |
| `+05` | envelope tick countdown |

**How they connect:** a song "tick" advances its sequence and, when a note is due,
calls `configure_chA/B/C` (~8628) to translate the sequencer state into the
channel struct. Then `audio_system` pushes the channel struct to the chip.

**Channel mapping & contention.** Song *N* maps its voice 0 to channel *N*
(`sng1_tick`→A first, `sng2_tick`→B first, `sng3_tick`→C first), wrapping around.
With 3 songs each able to use up to 3 voices, multiple songs can target the same
hardware channel — the **last writer in the frame wins**, which is why SFX
audibly cut off music notes.

---

## 4. The data format (custom)

Four nested levels. A "song id" indexes a dispatch table; that yields a header;
the header points at a meta block and per-voice pattern lists; each pattern list
points at note-data blocks; note data is note/duration pairs.

### 4.1 Song dispatch table
`point_hl_to_sfx_data` (~9171): `id × 4` indexes a table of
`ld hl,sfx_N_data / ret`. IDs 1–15 are real sounds; 0 is silent; 16–19 are
stubbed to `hard_reset`. (Annotated list of what each sound is at ~9180.)

### 4.2 Song header — `sfx_N_data`
```
db  num_voices        ; 2 or 3
dw  meta_ptr          ; -> meta block (also serves as voice-0 pattern list)
dw  voice1_ptr        ; -> voice 1 pattern list
dw  voice2_ptr        ; -> voice 2 pattern list   (omitted if num_voices < 3)
db  $FF
```
Copied into the song struct by `copy_cur_sfx_data_to_RAM` (~9224).

### 4.3 Meta block — 4-byte header + voice-0 pattern list
```
db  len, velocity, volume, transpose   ; 4 params (-> struct +0E.. +11)
... pattern list for voice 0 ...       ; same format as a voice (see 4.4)
```
- **len** — frames between each 1-step volume decrement (software decay rate; smaller = faster fade).
- **velocity** — note-length multiplier (see duration math below); effectively tempo.
- **volume** — base amplitude 0–15.
- **transpose** — signed offset added to every note index.

### 4.4 Voice = pattern list
A sequence of 2-byte pointers to note-data blocks, with two control opcodes:
```
dw  note_data_ptr     ; play this pattern
dw  note_data_ptr     ; then this one ...
db  $EE, nn           ; LOOP: jump back nn bytes (repeat)  -> handled ~8866
db  $FF               ; END  of voice
```
The engine walks the list 2 bytes at a time (`sfx_pattern_done_chA` ~8860). `$EE`
makes the voice loop forever (subtract `nn` from the cursor); `$FF` ends it.

### 4.5 Note data — note/duration pairs
```
db  note, dur         ; note index (into table), duration count
db  note, dur
...
db  $FF               ; END of pattern  -> handled ~8852
```
`note` indexes the pitch table (§4.6). `dur` is multiplied by `velocity` for the
real on-time. `note = 0` is a **rest** (silent — `write_aysnd_chA_all` returns
early on note 0).

### 4.6 Pitch table — `sfx_note_lookup` (~8762, ROM $4400)
112+ entries, **2 bytes each = `[coarse, fine]`** AY tone-period values, indexed by
`note × 2`. Approximately one entry per semitone, ascending pitch (descending
period). Per the author: tuned by ear, so it's only approximately
equal-tempered, index 0 is silent, and a few low semitones are out of order /
wrong.

---

## 5. Playback semantics (the math)

In `configure_chA` (~8628), when a new note is loaded:

- **Pitch:** `note_index = data_note + transpose`; look up `[coarse, fine]` at
  `sfx_note_lookup + note_index×2`; write coarse→tone reg, fine→tone-fine reg.
- **Duration (in frames):** `note_frames = velocity × dur − 1`.
  Bigger `velocity` ⇒ longer notes ⇒ slower tempo. Counted down in struct
  `+12/+13/+14`; at 0 the voice advances to the next note.
- **Volume envelope (software):** start at base `volume`; every `len` frames
  decrement the amplitude register by 1 (`write_aysnd_chA_vol_fade` ~8176) until
  it reaches 0. This is a linear software decay — the AY's hardware envelope
  generator is **not** used.

Each frame `write_aysnd_data_chA` (~8436) checks the new-note flag: if set, write
the full note (pitch + volume) via `write_aysnd_chA_all`; otherwise just step the
volume fade.

---

## 6. Quirks & gotchas

- **No hardware envelope, no noise.** Decay is software; R7 disables noise on all
  channels. The chip's envelope/noise features go unused.
- **Note 0 = rest.** `write_aysnd_chA_all` returns early on note index 0, so the
  first table entry never sounds.
- **Hand-tuned, buggy pitch table.** Author's comments at ~8755 flag out-of-order
  semitones and uncertainty past the top of the table.
- **3-song / 3-channel contention.** Songs share the 3 hardware channels; last
  writer per frame wins, so SFX clip music.
- **Orphan data exists.** e.g. the unreferenced 22-byte block at `$5D1A`
  ("wass all this?") has the *shape* of this format (`$EE` loop + `$FF $FF`) but
  isn't reachable and doesn't decode to a valid sound — a scrapped remnant.

## 7. Cross-reference (key symbols)

| What | Symbol / addr |
|------|----------------|
| Per-frame driver | `audio_system` (~5186) |
| Sequencer tick / song load | `tick_all_songs_or_load_new` (~9314) |
| Song id → data | `point_hl_to_sfx_data` (~9171) |
| Header → RAM | `copy_cur_sfx_data_to_RAM` (~9224) |
| Sequencer → channel struct | `configure_chA/B/C` (~8628) |
| Channel struct → AY (note) | `write_aysnd_chA/B/C_all` (~8311) |
| Channel struct → AY (fade) | `write_aysnd_chA/B/C_vol_fade` (~8176) |
| Pitch table | `sfx_note_lookup` (~8762) |
| Mixer init | `init_aysnd` (~4564) |

The browser tool in `tools/js_dump/` (`play_notes.js`: `get_song_ptrs`,
`get_sfx_ptrs`, `get_note_sequence`) is a working JS reimplementation of this
format that plays the extracted data via WebAudio.

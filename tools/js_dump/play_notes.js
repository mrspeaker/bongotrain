import { chunk, take, pairs, as_byte, as_dw, to_hex } from "./utils.js";

// The board is Galaxian-derived (~60.6 Hz)... 60 is close enough.
export const FRAME_RATE = 60;

// AY tone frequency = clock / (16 * period). Calibrated so the table's A4
// (note index 0x17, period 213) is ~440 Hz, matching the by-ear tuning
// the original devs used.
export const AY_CLOCK = 1_500_000;

// AY-3-8910 4-bit volume is logarithmic, not linear. 0 = silent, 15 = full.
export const AY_VOLUME = [
    0.0, 0.01, 0.0145, 0.0211, 0.0307, 0.0455, 0.0645, 0.1073, 0.1284, 0.205,
    0.2929, 0.418, 0.5043, 0.7079, 0.8367, 1.0,
];

// `sfx_note_lookup` in ROM ($4400 in the concatenated bg1..bg6 image).
export const NOTE_TABLE_ADDR = 0x4400;

export const period_to_freq = (period) =>
    period > 0 ? AY_CLOCK / (16 * period) : 0;

// Read the ROM's note->period lookup table into an indexable array.
// Each entry is two bytes [coarse, fine] -> 12-bit period -> frequency.
// Index 0 is treated as a rest.
export const get_note_table = (bytes, start = NOTE_TABLE_ADDR, count = 96) => {
    const table = [];
    for (let i = 0; i < count; i++) {
        const coarse = bytes[start + i * 2];
        const fine = bytes[start + i * 2 + 1];
        const period = (coarse << 8) | fine;
        table.push({ period, freq: period_to_freq(period) });
    }
    return table;
};

//note_data = { freq, duration }
export function _old_play_notes(note_data, start = 0, bpm = 120) {
    const audioContext = new (window.AudioContext ||
        window.webkitAudioContext)();
    let time = start || audioContext.currentTime + 0.1; // start in the future
    let quarterNoteTime = 60 / bpm;

    let oscillator = audioContext.createOscillator();
    oscillator.start(time);
    oscillator.type = "square";
    let gainNode = audioContext.createGain();
    gainNode.gain.value = 0.1;

    for (let i = 0; i < note_data.length; i++) {
        const note = note_data[i];
        oscillator.frequency.setValueAtTime(note.freq, time);
        gainNode.gain.setValueAtTime(0.1, time);
        gainNode.gain.setTargetAtTime(
            0.0,
            time + note.duration * quarterNoteTime * 0.6,
            0.015,
        );
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        oscillator.stop(time + note.duration * quarterNoteTime);

        // advance time by length of note
        time += note.duration * quarterNoteTime;
    }
    return time;
}

export const get_until_$ff = (bytes, start = 0) => {
    let out = [];
    let idx = 0;
    while (bytes[start + idx] != 0xff) {
        out.push(bytes[start + idx++]);
    }
    return out;
};

const follow = (bytes, ptr) => as_dw(take(bytes, ptr, 2));

const get_ptr_list = (bytes, start) => {
    let i = start;
    let back_bytes = 0;
    const is_end = () => {
        const byte = bytes[i];
        if (byte == 0xee) {
            back_bytes = bytes[i + 1];
        }
        return byte == 0xff || byte == 0xee;
    };
    const ptrs = [];
    while (!is_end()) {
        ptrs.push(as_dw(take(bytes, i, 2)));
        i += 2;
    }
    return {
        ptrs,
        repeat_idx: back_bytes > 0 ? ptrs.length - (back_bytes - 1) / 2 : -1,
    };
};
const get_meta = (bytes, meta_ptr) => {};

// Deprecated helper. Pass a note_table (from get_note_table) for accurate ROM
// pitches. Without one it falls back to the old equal-tempered estimate.
export const get_note_sequence = (bytes, start, note_table = null) =>
    pairs(get_until_$ff(bytes, start)).map(([note, dur]) => {
        const freq = note_table
            ? note_table[note]?.freq ?? 0
            : 440 * Math.pow(2, (note - 22.5) / 12);
        return {
            freq,
            duration: (dur % 8) / 4,
        };
    });

export const get_sfx_ptrs = (bytes, start) => {
    const ptrs = {
        voices: as_byte(take(bytes, start + 0, 1)),
        meta: as_dw(take(bytes, start + 1, 2)),
        voice0: null,
        voice1: as_dw(take(bytes, start + 3, 2)),
        voice2: as_dw(take(bytes, start + 5, 2)),
    };
    ptrs.voice0 = ptrs.meta + 4;
    return ptrs;
};

const map_meta = ([len, speed, volume, transpose]) => ({
    len,
    speed,
    volume,
    transpose,
});

export const get_sfx_ptr_lists = (bytes, ptrs) => {
    return {
        voices: ptrs.voices,
        meta: map_meta(take(bytes, ptrs.meta, 4)),
        voice0: get_ptr_list(bytes, ptrs.voice0),
        voice1: get_ptr_list(bytes, ptrs.voice1),
        voice2: get_ptr_list(bytes, ptrs.voice2),
    };
};

export const get_song_ptrs = (bytes, start) => {
    if (!start) {
        throw new Error("nop start");
    }
    const ptrs = get_sfx_ptrs(bytes, start);
    return get_sfx_ptr_lists(bytes, ptrs);
};

// Tries to reproduce what the AY-3-8910 + sound driver actually does.

// Expand a voice's pattern-pointer list, unrolling the $EE loop `repeats`
// extra times so looping tunes actually loop instead of stopping dead.
const expand_with_loop = ({ ptrs, repeat_idx }, repeats) => {
    if (repeat_idx < 0 || repeat_idx >= ptrs.length) return ptrs.slice();
    const out = ptrs.slice();
    for (let r = 0; r < repeats; r++) out.push(...ptrs.slice(repeat_idx));
    return out;
};

// Build a flat, frame-accurate timeline for one voice of a song
export const build_voice_timeline = (
    bytes,
    voice,
    meta,
    note_table,
    { repeats = 1 } = {},
) => {
    const { speed, len, volume, transpose } = meta;
    const step = (len + 1) / FRAME_RATE; // seconds per volume decrement
    const events = [];
    let frame = 0;

    for (const ptr of expand_with_loop(voice, repeats)) {
        const data = get_until_$ff(bytes, ptr);
        for (let i = 0; i + 1 < data.length; i += 2) {
            const note = (data[i] + transpose) & 0xff;
            const frames = Math.max(1, speed * data[i + 1]);
            events.push({
                freq: note === 0 ? null : note_table[note]?.freq ?? null,
                start: frame / FRAME_RATE,
                dur: frames / FRAME_RATE,
                vol: volume,
                step,
            });
            frame += frames;
        }
    }
    return events;
};

let _shared_ctx = null;
const get_ctx = () => {
    _shared_ctx ??= new (window.AudioContext || window.webkitAudioContext)();
    _shared_ctx.resume?.();
    return _shared_ctx;
};

// Nodes created by the current playback, so stop_notes() can silence them.
let _active = [];

// Immediately stop and tear down any currently-playing song.
export const stop_notes = () => {
    for (const node of _active) {
        try {
            node.stop?.(); // oscillators only
        } catch (e) {}
        try {
            node.disconnect();
        } catch (e) {}
    }
    _active = [];
};

// Schedule one voice's timeline on a single oscillator + gain node, recreating
// the driver's stepped (staircase) software volume envelope.
const schedule_voice = (ctx, events, start_time, out) => {
    const osc = ctx.createOscillator();
    osc.type = "square"; // AY tone channels are 50% square waves
    const gain = ctx.createGain();
    gain.gain.value = 0;
    osc.connect(gain);
    gain.connect(out);

    let end = start_time;
    for (const ev of events) {
        const t0 = start_time + ev.start;
        const t1 = t0 + ev.dur;
        end = Math.max(end, t1);
        if (ev.freq == null) {
            gain.gain.setValueAtTime(0, t0); // rest
            continue;
        }
        osc.frequency.setValueAtTime(ev.freq, t0);
        // Staircase decay: level v held for `step` seconds, then v-- , until
        // the note's time runs out or it reaches silence.
        let v = ev.vol;
        let t = t0;
        gain.gain.setValueAtTime(AY_VOLUME[v] ?? 0, t);
        while (v > 0 && t + ev.step < t1) {
            t += ev.step;
            v -= 1;
            gain.gain.setValueAtTime(AY_VOLUME[v] ?? 0, t);
        }
    }
    osc.start(start_time);
    osc.stop(end + 0.05);
    _active.push(osc); // track so stop_notes() can cut it short
    return end;
};

// Play a Bongo song/sound . `sfx` is the result of get_song_ptrs():
export const play_notes = (
    bytes,
    sfx,
    note_table,
    { repeats = 1, master = 0.2 } = {},
) => {
    stop_notes(); // cut any song already playing before starting a new one
    const ctx = get_ctx();
    const out = ctx.createGain();
    out.gain.value = master;
    out.connect(ctx.destination);
    _active.push(out);

    const start = ctx.currentTime + 0.1;
    let end = start;
    ["voice0", "voice1", "voice2"].forEach((v, i) => {
        if (i >= sfx.voices) return;
        const voice = sfx[v];
        if (!voice || voice.ptrs.length === 0) return;
        const events = build_voice_timeline(
            bytes,
            voice,
            sfx.meta,
            note_table,
            {
                repeats,
            },
        );
        end = Math.max(end, schedule_voice(ctx, events, start, out));
    });
    return end;
};

// A raw note-data block has no song meta of its own, so audition it with these
// neutral envelope/tempo values.
export const DEFAULT_BLOCK_META = { len: 4, speed: 6, volume: 15, transpose: 0 };

// Play a single raw note-data block by address (the notes up to the next $FF),
// independent of any song. For auditioning unreferenced / hidden sound data.
export const play_block = (
    bytes,
    addr,
    note_table,
    { master = 0.2, meta = DEFAULT_BLOCK_META } = {},
) => {
    stop_notes(); // cut anything already playing
    const ctx = get_ctx();
    const out = ctx.createGain();
    out.gain.value = master;
    out.connect(ctx.destination);
    _active.push(out);

    const voice = { ptrs: [addr], repeat_idx: -1 };
    const events = build_voice_timeline(bytes, voice, meta, note_table, {
        repeats: 0,
    });
    return schedule_voice(ctx, events, ctx.currentTime + 0.1, out);
};

// ============================================================================
// Heuristic hidden-tune scanner.
// ============================================================================

// A "tune" is a note-data block (note,dur pairs up to $FF) whose values all
// fall in the musical range the real songs use. Tuned so the known hidden
// tunes pass and control/code bytes (e.g. the $5D1A orphan) don't.
export const TUNE_HEURISTIC = {
    minNotes: 5, // ignore tiny blocks (too easy to hit by chance)
    maxNote: 0x3a, // real songs top out ~0x38; padding/control bytes are higher
    maxDur: 0x10, // real durations are small multipliers
};

// If the block at `addr` looks like a tune, return its note count, else 0.
export const tune_note_count = (bytes, addr, h = TUNE_HEURISTIC) => {
    let end = addr;
    while (end < bytes.length && bytes[end] !== 0xff) end++;
    const len = end - addr;
    if (len < h.minNotes * 2 || len % 2 !== 0) return 0;
    let has_note = false;
    for (let k = addr; k < end; k += 2) {
        const note = bytes[k];
        const dur = bytes[k + 1];
        if (note > h.maxNote || dur < 1 || dur > h.maxDur) return 0;
        if (note !== 0) has_note = true; // not all rests
    }
    return has_note ? len / 2 : 0;
};

// Scan a ROM range for tune-shaped blocks. Partitions on $FF terminators (the
// natural block boundary) and tests each chunk, so sub-blocks aren't double
// reported. Each hit is tagged `ref` if a real song already points at it.
// Returns [{ addr, notes, ref }].
export const find_hidden_tunes = (
    bytes,
    referenced = new Set(),
    { lo = 0x4400, hi = 0x6000, h = TUNE_HEURISTIC } = {},
) => {
    const out = [];
    let i = lo;
    while (i < hi) {
        if (bytes[i] === 0xff) {
            i++; // skip padding between blocks
            continue;
        }
        const notes = tune_note_count(bytes, i, h);
        if (notes) out.push({ addr: i, notes, ref: referenced.has(i) });
        while (i < hi && bytes[i] !== 0xff) i++; // jump to end of this chunk
    }
    return out;
};

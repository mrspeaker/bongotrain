// Export a Bongo song to a Standard MIDI File.
//
// Decodes a song straight from the ROM (same format as play_notes.js): header
// -> meta + per-voice pattern lists -> note/duration pairs. ROM note indices
// are converted to pitch via the AY note table, then to the nearest MIDI note.
// Durations are frame-based (frames = speed * dur at 60fps); one "dur unit"
// (= speed frames) is mapped to a 16th note so the rhythm notates cleanly.
//
// Usage:  node midi_export.mjs [songAddrHex] [outFile]
//   e.g.  node midi_export.mjs 5d00 lil_tune.mid   (default)

import { readFileSync, writeFileSync } from "fs";

const ROM_DIR = new URL("./dump/bongo/", import.meta.url);
const rd = (f) => [...readFileSync(new URL(f, ROM_DIR))];
const bytes = ["bg1", "bg2", "bg3", "bg4", "bg5", "bg6"].flatMap((n) =>
    rd(n + ".bin"),
);

const AY_CLOCK = 1_500_000; // calibrated so note 0x17 (period 213) ~= A4 440Hz
const NOTE_TABLE_ADDR = 0x4400; // sfx_note_lookup
const dw = (a) => bytes[a] | (bytes[a + 1] << 8);

// ROM note index -> frequency (Hz), 0 if rest/silent.
const noteTable = Array.from({ length: 96 }, (_, i) => {
    const period = (bytes[NOTE_TABLE_ADDR + i * 2] << 8) | bytes[NOTE_TABLE_ADDR + i * 2 + 1];
    return period > 0 ? AY_CLOCK / (16 * period) : 0;
});
const freqToMidi = (f) => (f > 0 ? Math.round(69 + 12 * Math.log2(f / 440)) : null);

// --- song decode (mirrors get_song_ptrs / build_voice_timeline) ---
const ptrList = (start) => {
    let i = start;
    const ptrs = [];
    let back = 0;
    for (;;) {
        const b = bytes[i];
        if (b === 0xff || b === 0xee) {
            if (b === 0xee) back = bytes[i + 1];
            break;
        }
        ptrs.push(dw(i));
        i += 2;
    }
    return { ptrs, repeat_idx: back > 0 ? ptrs.length - (back - 1) / 2 : -1 };
};

const getSong = (addr) => {
    const meta = dw(addr + 1);
    return {
        voices: bytes[addr],
        meta: { len: bytes[meta], speed: bytes[meta + 1], volume: bytes[meta + 2], transpose: bytes[meta + 3] },
        voice0: ptrList(meta + 4),
        voice1: ptrList(dw(addr + 3)),
        voice2: ptrList(dw(addr + 5)),
    };
};

const pattern = (addr) => {
    const out = [];
    for (let i = addr; bytes[i] !== 0xff; i += 2) out.push([bytes[i], bytes[i + 1]]);
    return out;
};

// Flatten a voice to {frame, frames, midi} note events, unrolling its loop.
const voiceEvents = (voice, meta, loops) => {
    const seq = voice.ptrs.slice();
    if (voice.repeat_idx >= 0)
        for (let r = 0; r < loops; r++) seq.push(...voice.ptrs.slice(voice.repeat_idx));
    const ev = [];
    let frame = 0;
    for (const ptr of seq)
        for (const [note, dur] of pattern(ptr)) {
            const frames = Math.max(1, meta.speed * dur);
            const n = (note + meta.transpose) & 0xff;
            ev.push({ frame, frames, midi: note === 0 ? null : freqToMidi(noteTable[n]) });
            frame += frames;
        }
    return ev;
};

// --- MIDI writing ---
const PPQ = 480; // ticks per quarter note
const FRAME_TO_TICK = 15; // 8 frames (one dur unit) = 120 ticks = a 16th note
const TEMPO_US = 533_333; // microseconds/quarter -> 112.5 BPM (real-time accurate)
const SQUARE_LEAD = 80; // GM program "Lead 1 (square)"

const varlen = (n) => {
    const b = [n & 0x7f];
    for (n >>>= 7; n > 0; n >>>= 7) b.unshift((n & 0x7f) | 0x80);
    return b;
};
const u32 = (n) => [(n >> 24) & 0xff, (n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff];
const chunk = (id, data) => [...[...id].map((c) => c.charCodeAt(0)), ...u32(data.length), ...data];

const tempoTrack = () => [
    ...varlen(0), 0xff, 0x51, 0x03, (TEMPO_US >> 16) & 0xff, (TEMPO_US >> 8) & 0xff, TEMPO_US & 0xff,
    ...varlen(0), 0xff, 0x58, 0x04, 4, 2, 24, 8, // 4/4 time signature
    ...varlen(0), 0xff, 0x2f, 0x00, // end of track
];

const voiceTrack = (events, channel) => {
    const list = [{ t: 0, order: 0, data: [0xc0 | channel, SQUARE_LEAD] }];
    for (const e of events) {
        if (e.midi == null) continue; // rest
        list.push({ t: e.frame * FRAME_TO_TICK, order: 1, data: [0x90 | channel, e.midi, 100] });
        list.push({ t: (e.frame + e.frames) * FRAME_TO_TICK, order: 0, data: [0x80 | channel, e.midi, 0] });
    }
    list.sort((a, b) => a.t - b.t || a.order - b.order); // note-offs before note-ons at same tick
    const out = [];
    let last = 0;
    for (const ev of list) {
        out.push(...varlen(ev.t - last), ...ev.data);
        last = ev.t;
    }
    return [...out, ...varlen(0), 0xff, 0x2f, 0x00];
};

// --- run ---
const songAddr = parseInt(process.argv[2] ?? "5d00", 16);
const outFile = process.argv[3] ?? "lil_tune.mid";
const loops = 0; // 0 = play the full pattern once (the complete tune)

const song = getSong(songAddr);
const tracks = [tempoTrack()];
["voice0", "voice1", "voice2"].slice(0, song.voices).forEach((v, i) => {
    tracks.push(voiceTrack(voiceEvents(song[v], song.meta, loops), i));
});

const midi = [
    ...chunk("MThd", [0, 1, (tracks.length >> 8) & 0xff, tracks.length & 0xff, (PPQ >> 8) & 0xff, PPQ & 0xff]),
    ...tracks.flatMap((t) => chunk("MTrk", t)),
];
writeFileSync(new URL(outFile, import.meta.url), Buffer.from(midi));
console.log(`wrote ${outFile}: ${song.voices} voices, ${tracks.length} tracks, ${midi.length} bytes`);

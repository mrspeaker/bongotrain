import { get_bongo_bytes, get_rom_bytes } from "./rom.js";

import { $, $set, $get, $click } from "./dom.js";

import {
    get_note_sequence,
    get_note_table,
    get_song_ptrs,
    play_notes,
    play_block,
    stop_notes,
    find_hidden_tunes,
    tune_note_count,
} from "./play_notes.js";

import { pal, mk_tiles_from_rom, draw_tile } from "./extract_gfx.js";

(async () => {
    const ctx = document.getElementById("board").getContext("2d");
    const ctx_dst = document.getElementById("dst").getContext("2d");
    const w = ctx.canvas.width;
    const h = ctx.canvas.height;
    const pix = ctx.getImageData(0, 0, w, h);
    const pix_dst = ctx.getImageData(0, 0, w, h);

    const bytes1 = await get_rom_bytes("b-h.bin");
    const bytes2 = await get_rom_bytes("b-k.bin");

    const tiles = mk_tiles_from_rom(bytes1, bytes2);

    const cell_size = 8; // each sprite cell is 8 x 8
    const spr_size = cell_size * 2; // a "sprite" is 2 x 2 cells

    // Draw a 2x2 group of cells as a sprite
    // The format in memory is weird: [[1, 0], [1, 1], [0, 0], [0, 1]]
    const drawSpr = (spr, x, y, cols, px) => {
        const off = 0 + spr * 4;
        draw_tile(tiles[off], x + cell_size, y, w, cols, px);
        draw_tile(tiles[off + 1], x + cell_size, y + cell_size, w, cols, px);
        draw_tile(tiles[off + 2], x, y, w, cols, px);
        draw_tile(tiles[off + 3], x, y + cell_size, w, cols, px);
    };

    // Render tiles (alphabet single tiles)
    const tw = 32;
    const th = 16;
    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            const t = j * tw + i;
            draw_tile(tiles[t], i * cell_size, j * cell_size, w, pal[0], pix);
        }
    }
    // Render sprites
    let yoff = th * cell_size;
    let sw = tw / 2;
    let sh = 8;
    for (let j = 0; j < sh; j++) {
        for (let i = 0; i < sw; i++) {
            const spr = j * sw + i + 0;
            // Set correct colors for various sprites
            const col =
                spr < 64
                    ? pal[0]
                    : spr > 92 && spr < 98
                    ? pal[5]
                    : spr >= 98 && spr < 101
                    ? pal[6]
                    : spr > 115 && spr < 120
                    ? pal[7]
                    : pal[2];
            drawSpr(spr, i * spr_size, j * spr_size + yoff, col, pix);
        }
    }

    const o = 16;
    const o2 = 3;

    // Map tiles to dest
    [
        [0x10, 0, 0, 0], // blank
        ...(() =>
            Array(27)
                .fill(0)
                .map((_, i) => [0x11 + i, i, 0, 0]))(), // alphabet
        [0x8b, 27, 0, 0], // copyright
        [0x89, 28, 0, 0], // cursor up arrow
        [0x51, 29, 0, 0], // red circle
        [0x52, 30, 0, 0], // green
        [0x53, 31, 0, 0], // white

        ...(() =>
            Array(28)
                .fill(0)
                .map((_, i) => [0xc0 + i, i, 1, 2]))(), // level nums

        [0x2c, 28, 1, 0], // sq open
        [0x2d, 29, 1, 0], // sq red
        [0x2e, 30, 1, 0], // sq green
        [0x2f, 31, 1, 0], // sq white

        [0x58, 28, 2, 0], // RUB start
        [0x59, 29, 2, 0], // RUB end
        [0x5a, 30, 2, 0], // END start
        [0x5b, 31, 2, 0], // END end

        ...(() =>
            Array(12)
                .fill(0)
                .map((_, i) => [0x90 + i, i, 2, 0]))(), // pickup numbers

        [0x8a, 12, 2, 1], // lil guy
        [0x8c, 13, 2, 0], // pickups 1
        [0x8d, 14, 2, 0],
        [0x8e, 15, 2, 0],
        [0x8f, 16, 2, 0],
        [0x9c, 17, 2, 0], // pickups 2
        [0x9d, 18, 2, 0],
        [0x9e, 19, 2, 0],
        [0x9f, 20, 2, 0],

        [0xb8, 26, 10, 0], // outline 1
        [0xbf, 27, 10, 0],
        [0xb7, 28, 10, 0],
        [0xb9, 26, 11, 0],
        [0xbe, 28, 11, 0],
        [0xba, 26, 12, 0],
        [0xbb, 27, 12, 0],
        [0xbc, 28, 12, 0],
        [0xb4, 26, 13, 0], // bonus1
        [0xb5, 27, 13, 0],
        [0xb6, 28, 13, 0],

        [0xe0, 29, 10, 0], // ourline 2
        [0xe7, 30, 10, 0],
        [0xdf, 31, 10, 0],
        [0xe1, 29, 11, 0],
        [0xe6, 31, 11, 0],
        [0xe2, 29, 12, 0],
        [0xe3, 30, 12, 0],
        [0xe4, 31, 12, 0],
        [0xdc, 29, 13, 0], // bonus 2
        [0xdd, 30, 13, 0],
        [0xde, 31, 13, 0],

        [0x76, 1, 20, 0], // dino cage
        [0x74, 2, 20, 0],
        [0x7e, 3, 20, 0],
        [0x77, 1, 21, 0],
        [0x75, 2, 21, 0],
        [0x7f, 3, 21, 0],
        [0x7a, 1, 22, 0],
        [0x78, 2, 22, 0],
        [0x7c, 3, 22, 0],
        [0x7b, 1, 23, 0],
        [0x79, 2, 23, 0],
        [0x7d, 3, 23, 0],

        [0x76 - o, 1 + o2, 20, 0], // dino cage
        [0x74 - o, 2 + o2, 20, 0],
        [0x7e - o, 3 + o2, 20, 0],
        [0x77 - o, 1 + o2, 21, 0],
        [0x75 - o, 2 + o2, 21, 0],
        [0x7f - o, 3 + o2, 21, 0],
        [0x7a - o, 1 + o2, 22, 0],
        [0x78 - o, 2 + o2, 22, 0],
        [0x7c - o, 3 + o2, 22, 0],
        [0x7b - o, 1 + o2, 23, 0],
        [0x79 - o, 2 + o2, 23, 0],
        [0x7d - o, 3 + o2, 23, 0],
    ].forEach(([t, x, y, col]) => {
        draw_tile(tiles[t], x * cell_size, y * cell_size, w, pal[col], pix_dst);
    });

    // Map sprites to dest
    [
        [0x28, 0, 4, 0], // B
        [0x29, 2, 4, 0],
        [0x2a, 4, 4, 0],
        [0x2b, 6, 4, 0],
        [0x2c, 8, 4, 0], // O

        [0x40, 10, 4, 2], // nugget dance frame 1
        [0x41, 12, 4, 2],
        [0x42, 14, 4, 2],
        [0x43, 16, 4, 2],
        [0x45, 18, 4, 2], // bongo dance frame 1
        [0x46, 20, 4, 2],
        [0x47, 22, 4, 2],
        [0x48, 24, 4, 2],

        [0x69, 26, 4, 2], // bongo walk
        [0x6a, 28, 4, 2],
        [0x6b, 30, 4, 2],

        [0x4c, 0, 6, 1], // main man
        [0x4d, 0, 8, 1], // mm feet
        [0x4e, 2, 6, 1], // fr2
        [0x4f, 2, 8, 1],
        [0x50, 4, 6, 1], // fr3
        [0x51, 4, 8, 1],
        [0x52, 6, 6, 1], // fr4
        [0x53, 6, 8, 1],
        [0x54, 8, 6, 1], // fr5
        [0x55, 8, 8, 1],
        [0x57, 10, 6, 1], // back fr 1
        [0x58, 10, 8, 1],
        [0x59, 12, 6, 1], // back fr 2
        [0x5a, 12, 8, 1],
        [0x5b, 14, 6, 1], // back fr 3
        [0x5c, 14, 8, 1],
        [0x7a, 16, 6, 1], // dance 1
        [0x7b, 16, 8, 1],
        [0x7c, 18, 6, 1], // dance 2
        [0x7d, 18, 8, 1],
        [0x7e, 20, 6, 1], // dance 3
        [0x7f, 20, 8, 1],
        [0x66, 22, 6, 1], // die
        [0x67, 24, 6, 1],
        [0x56, 22, 8, 1], // jump legs
        [0x68, 24, 8, 1], // die cross

        [0x6c, 1, 10, 2], // dino (head offset 1 in x)
        [0x70, 0, 12, 2],
        [0x6d, 4, 10, 2],
        [0x71, 3, 12, 2],
        [0x6e, 7, 10, 2],
        [0x72, 6, 12, 2],
        [0x6f, 10, 10, 2],
        [0x73, 9, 12, 2],

        [0x78, 13, 10, 2], // dino cage intro top
        [0x79, 12, 12, 2], // dino cage intro

        [0x63, 0, 14, 6], // duck
        [0x64, 2, 14, 6],
        [0x74, 4, 14, 7], // blob guy
        [0x75, 6, 14, 7],
        [0x76, 8, 14, 7], // blue fire
        [0x77, 10, 14, 7],
        [0x62, 12, 14, 7], // arrow'd

        [0x5d, 0, 16, 5], // rock fall
        [0x5e, 2, 16, 5],
        [0x5f, 4, 16, 5],
        [0x60, 6, 16, 5],
        [0x61, 8, 16, 5],
    ].forEach(([t, x, y, col]) => {
        drawSpr(t, x * cell_size, y * cell_size, pal[col], pix_dst);
    });

    ctx.putImageData(pix, 0, 0);
    ctx_dst.putImageData(pix_dst, 0, 0);
})();

const tunes_5 = [
    0x4ae4, 0x4ac4, 0x4aaa, 0x4a94, 0x4a80, 0x4b0c, 0x4a80, 0x44c0, 0x4a20,
];
const tunes_6 = [
    0x5f38, 0x5132, 0x5550, 0x56f8, 0x5df4, 0x5c86, 0x5d30, 0x5d64, 0x5e4c,
    0x5ea0,
];

const sfx_data = [
    0x5d00, 0x4c46, 0x5053, 0x50bc, 0x50ec, 0x519a, 0x51ea, 0x5514, 0x5770,
    0x5560, 0x5dea, 0x5e88, 0x5f30, 0x5f78, 0x4b40,
];

// Labels for each sfx_data entry, from point_hl_to_sfx_data in bongo.asm.
const SONG_NAMES = [
    "lil tune",
    "death ditty",
    "pickup sound",
    "jump sfx",
    "falling sound",
    "fast low 1/8note tune",
    "dino start sound",
    "high-pitch win sound",
    "game over song",
    "credit? (few notes)",
    "like sfx15",
    "scary woods song",
    "post-bonus tune",
    "main tune (level 1)",
    "intro riff",
];

// The author's hand-collected note-data block addresses from the sound ROM,
// plus the "wass all this?" orphan at $5D1A. handle_tunes() surfaces whichever
// of these no song references -- i.e. sound data normal play never triggers.
const SOUND_BLOCKS = [...tunes_5, ...tunes_6, 0x5d1a];

const options = (items) =>
    items
        .map(([value, label]) => `<option value="${value}">${label}</option>`)
        .join("");

// A complete two-voice tune found unused in the ROM. Two phrases (14- and
// 19-note), each harmonized into an upper and lower line; the voices are
// duration-synced at 108 frames so they loop together. No song header points
// at it, so we hand-assemble one. Meta is borrowed from the neighbouring song
// at 0x5770 (same region, also 2-voice) -- a best guess; tweak to taste.
const HIDDEN_DUET = {
    name: "hidden duet (reconstructed)",
    sfx: {
        voices: 2,
        meta: { len: 1, speed: 8, volume: 15, transpose: 16 },
        voice0: { ptrs: [0x5630, 0x5650], repeat_idx: 0 }, // upper line
        voice1: { ptrs: [0x5678, 0x5696], repeat_idx: 0 }, // lower line
        voice2: { ptrs: [], repeat_idx: -1 },
    },
};

// A single-voice melody found unused in the ROM: three same-length (32-tick)
// phrases of a descending theme, played in sequence. These blocks sit among
// song 13's note data in the 0x4Axx region, so it borrows song 13's meta.
const HIDDEN_MELODY = {
    name: "hidden melody (3 phrases)",
    sfx: {
        voices: 1,
        meta: { len: 1, speed: 5, volume: 15, transpose: 0 },
        voice0: { ptrs: [0x4a80, 0x4a94, 0x4aaa], repeat_idx: 0 },
        voice1: { ptrs: [], repeat_idx: -1 },
        voice2: { ptrs: [], repeat_idx: -1 },
    },
};

const mk_ui = () => ({
    btnPlay: $("#play"),
    btnStop: $("#stop"),
    btnPlayUnused: $("#play-unused"),
    notes: $("#notes"),
    unused: $("#unused"),
});

// Decode a voice's patterns for the on-screen debug dump (uses the real ROM
// note table for pitches). Playback itself goes through play_notes.
const expand_voice = (bytes, voice, note_table) => {
    const patterns = voice.ptrs.map((p) =>
        get_note_sequence(bytes, p, note_table),
    );
    return { repeat: voice.repeat_idx, patterns };
};

const get_song = (bytes, id, note_table) => {
    const sfx = get_song_ptrs(bytes, id);
    const { speed, len, volume, transpose } = sfx.meta;

    return {
        sfx,
        len,
        speed,
        volume,
        transpose,
        voices: sfx.voices,
        voice0: expand_voice(bytes, sfx.voice0, note_table),
        voice1: expand_voice(bytes, sfx.voice1, note_table),
        voice2: expand_voice(bytes, sfx.voice2, note_table),
    };
};

async function handle_tunes() {
    const bytes = await get_bongo_bytes();
    const note_table = get_note_table(bytes);
    const all_songs = [
        ...sfx_data.map((i) => get_song(bytes, i, note_table)),
        HIDDEN_DUET,
        HIDDEN_MELODY,
    ];
    const ui = mk_ui();

    // Song dropdown (the last entry is the reconstructed hidden duet).
    ui.notes.innerHTML = options(
        all_songs.map((s, i) => [i, `${i}: ${s.name ?? SONG_NAMES[i] ?? "?"}`]),
    );

    // Unused/hidden sounds: tune-shaped note-data blocks that no song points
    // at. Two sources are merged: the heuristic scanner (auto-discovery) and
    // the author's hand-collected addresses (catches blocks the scanner's $FF
    // alignment misses, e.g. 0x44c0). The same tune test drops non-musical
    // data such as the 0x5D1A orphan.
    const referenced = new Set();
    all_songs.forEach((s) =>
        ["voice0", "voice1", "voice2"]
            .slice(0, s.sfx.voices)
            .forEach((v) => s.sfx[v].ptrs.forEach((p) => referenced.add(p))),
    );
    const scanned = find_hidden_tunes(bytes, referenced).filter((t) => !t.ref);
    const curated = SOUND_BLOCKS.filter((a) => !referenced.has(a)).map((a) => ({
        addr: a,
        notes: tune_note_count(bytes, a),
    }));
    const unused = [
        ...new Map(
            [...scanned, ...curated]
                .filter((t) => t.notes > 0)
                .map((t) => [t.addr, t]),
        ).values(),
    ].sort((a, b) => a.addr - b.addr);
    ui.unused.innerHTML = options(
        unused.map((t) => [
            t.addr,
            `0x${t.addr.toString(16)} (${t.notes} notes)`,
        ]),
    );

    $click(ui.btnPlay, () => {
        const song = parseInt($get(ui.notes), 10) || 0;
        play_notes(bytes, all_songs[song].sfx, note_table, { repeats: 1 });
    });

    $click(ui.btnPlayUnused, () => {
        const addr = parseInt($get(ui.unused), 10) || 0;
        play_block(bytes, addr, note_table);
    });

    $click(ui.btnStop, () => stop_notes());
}

handle_tunes();

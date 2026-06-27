import { get_bongo_bytes, get_rom_bytes } from "./rom.js";

import { $, $set, $get, $click, $inner } from "./dom.js";

import { NUM_SCREENS, draw_level, level_name } from "./levels.js";

import { CHARS_W, CHARS_H, draw_chars } from "./chars.js";

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
    const w = ctx.canvas.width;
    const h = ctx.canvas.height;
    // Blank buffers to draw into. Use createImageData, not getImageData: we
    // never read existing canvas pixels, and a getImageData readback renders
    // corrupted (vertical stripes) on Firefox/macOS Retina.
    const pix = ctx.createImageData(w, h);

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

    ctx.putImageData(pix, 0, 0);
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

// Level visualizer: flip through each screen's background with prev/next.
async function handle_levels() {
    const bytes = await get_bongo_bytes();
    const gfx = mk_tiles_from_rom(
        await get_rom_bytes("b-h.bin"),
        await get_rom_bytes("b-k.bin"),
    );
    const ctx = $("#level").getContext("2d");
    const label = $("#level-label");
    let screen = 1;

    const render = () => {
        draw_level(ctx, gfx, bytes, screen);
        $inner(label, `screen ${screen} / ${NUM_SCREENS}`);
    };
    const step = (d) => () => {
        screen = ((screen - 1 + d + NUM_SCREENS) % NUM_SCREENS) + 1;
        render();
    };
    $click($("#level-prev"), step(-1));
    $click($("#level-next"), step(+1));
    render();
}

handle_levels();

// Character viewer: each game character's animation frames in a labelled row.
async function handle_chars() {
    const gfx = mk_tiles_from_rom(
        await get_rom_bytes("b-h.bin"),
        await get_rom_bytes("b-k.bin"),
    );
    const ctx = $("#chars").getContext("2d");
    ctx.canvas.width = CHARS_W;
    ctx.canvas.height = CHARS_H;
    draw_chars(ctx, gfx);
}

handle_chars();

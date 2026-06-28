import { draw_tile, pal } from "./extract_gfx.js";
import { draw_sprite } from "./chars.js";

// Level/screen background visualizer.
//
// Geometry & data format come straight from bongo.asm:
//   - level_bg_ptr_lookup ($1500): 27 little-endian pointers, one per screen,
//     into a handful of shared layout blocks (level_bg__n_n, __stairs_up, ...).
//   - draw_background ($12B8): draws 6 constant "entrance" columns, then
//     draw_screen_column_from_level_data ($1322) draws 23 columns of level data.
//   - A column is a run of segments: <row-offset> <tile>... terminated by 0x00
//     (start a new segment in the same column) or 0xFF (end of column). Only
//     0x00 and 0xFF are markers -- 0xFE/0xFD are ordinary tiles.

const LOOKUP = 0x1500; // level_bg_ptr_lookup
export const NUM_SCREENS = 27;
const LEVEL_COLS = 23; // columns of level data per screen (playfield width - 6)
const ENTRANCE_COLS = 6; // constant left-edge columns drawn by draw_background
const ROWS = 32;
const CELL = 8; // tile size in px

// Friendly name per layout block (by its ROM address), from bongo.asm labels.
const BLOCK_NAMES = {
    0x18b0: "n_n (flat)",
    0x1a10: "stairs up",
    0x1d00: "S",
    0x1e70: "stairs down",
    0x1fe0: "S_S",
    0x2140: "nTn",
};

// The 6 constant entrance columns: three horizontal tile runs at fixed rows,
// inlined in draw_background (ceiling spikes, top platform, ground).
const ENTRANCE = [
    { row: 0x03, tiles: [0x40, 0x42, 0x43, 0x42, 0x41, 0x40] },
    { row: 0x09, tiles: [0xfe, 0xfd, 0xfd, 0xfd, 0xfd, 0xfc] },
    { row: 0x1e, tiles: [0xfe, 0xfd, 0xfd, 0xfd, 0xfd, 0xfc] },
];

// 2-byte little-endian pointer to a screen's level data (screen is 1-based).
export const get_level_ptr = (bytes, screen) => {
    const a = LOOKUP + (screen - 1) * 2;
    return bytes[a] | (bytes[a + 1] << 8);
};

export const level_name = (bytes, screen) =>
    BLOCK_NAMES[get_level_ptr(bytes, screen)] ?? "?";

// Parse one column starting at byte index `i`; returns its {row, tile} cells
// and the index of the next column.
const parse_column = (bytes, i) => {
    const cells = [];
    for (;;) {
        let row = bytes[i++]; // each segment begins at this row in the column
        for (;;) {
            const b = bytes[i++];
            if (b === 0xff) return { cells, next: i }; // end of column
            if (b === 0x00) break; // end of segment -> read next row offset
            cells.push({ row, tile: b });
            row++;
        }
    }
};

// Every tile of a screen as {col, row, tile}: the constant entrance plus the
// 23 parsed level columns.
export const get_screen_tiles = (bytes, screen) => {
    const out = [];
    ENTRANCE.forEach(({ row, tiles }) =>
        tiles.forEach((tile, col) => out.push({ col, row, tile })),
    );
    let i = get_level_ptr(bytes, screen);
    for (let c = 0; c < LEVEL_COLS; c++) {
        const { cells, next } = parse_column(bytes, i);
        cells.forEach(({ row, tile }) =>
            out.push({ col: ENTRANCE_COLS + c, row, tile }),
        );
        i = next;
    }
    return out;
};

// --- Pickups --------------------------------------------------------------
//
// Each screen runs one "pattern" routine (add_screen_pickups dispatch at $4C50)
// that pokes pickup tiles into fixed screen-RAM addresses. Those addresses sit
// in the same column-major VRAM the BG is drawn into, so they convert to the
// same (col,row) grid: scr_lvl_bg_start ($92E0) is col 6 / row 0, one screen
// column left is -32 in memory, one row down is +1.
const PICK_BASE = 0x92e0;

// VRAM address -> grid {col, row}. delta = 32*c - row, so c rounds up.
const pick_pos = (addr) => {
    const delta = PICK_BASE - addr;
    const c = Math.ceil(delta / 32);
    return { col: ENTRANCE_COLS + c, row: 32 * c - delta };
};

// Pattern routine -> the [addr, tile] pokes it makes (add_pickup_pat_* in
// bongo.asm). Patterns that call others are inlined here. Tiles $8C-$8F are the
// animated crown/cross/ring/vase frames. Key 11 is the _4170 routine.
const PICK_PATTERNS = {
    1: [[0x915a, 0x8c]],
    2: [[0x915a, 0x8d]],
    3: [[0x911a, 0x8d]],
    4: [[0x91b1, 0x8c]],
    5: [[0x918e, 0x8c]],
    6: [[0x91d2, 0x8d]],
    7: [
        [0x90cb, 0x8e],
        [0x918e, 0x8c],
    ], // ring + pat_5
    8: [
        [0x911a, 0x8d],
        [0x927a, 0x8e],
    ], // pat_3 + ring
    9: [
        [0x92ee, 0x8f],
        [0x9217, 0x8e],
    ],
    10: [
        [0x9217, 0x8c],
        [0x9231, 0x8d],
        [0x922b, 0x8f],
    ],
    11: [
        [0x90cb, 0x8e],
        [0x918e, 0x8c],
        [0x92ab, 0x8e],
    ], // _4170 = pat_7 + ring
};

// screen (1-based) -> pattern key. 0 = no pickups (screen 27).
const SCREEN_PICK = [
    1, 2, 3, 1, 4, 5, 6, 2, 3, 4, 7, 6, 1, 8, 2, 9, 6, 2, 9, 6, 10, 7, 6, 10,
    11, 6, 0,
];

export const get_pickups = (screen) =>
    (PICK_PATTERNS[SCREEN_PICK[screen - 1]] ?? []).map(([addr, tile]) => ({
        ...pick_pos(addr),
        tile,
    }));

// --- Player spawn ---------------------------------------------------------
//
// player_start_pos_data ($1850): 27 [x, y] pixel pairs, one per screen, read
// by init_player_pos_for_screen. x is the head/legs x; the legs sprite sits 16px
// below the head (player_y_legs = player_y + $10). Pixel coords map straight onto
// the level grid (tile = px / 8). The standing frame is sprites $4C (head) / $4D
// (legs), drawn with the player palette (pal[1]).
const PLAYER_SPAWN = 0x1850;
const PLAYER_HEAD = 0x4c;
const PLAYER_LEGS = 0x4d;
const PLAYER_THEME = 1;

export const get_player_spawn = (bytes, screen) => {
    const a = PLAYER_SPAWN + (screen - 1) * 2;
    return { x: bytes[a], y: bytes[a + 1] };
};

// --- Enemies --------------------------------------------------------------
//
// Enemies have no [x,y] table: update_enemies ($2B54) dispatches a per-screen
// routine that calls spawners with hardcoded start positions. These are the
// spawn points (rocks fall from the top, flames rise from the bottom, birds &
// spears fly in from a side edge, blue "meanies" walk the stairs). Sprite ids
// are the game frame + $40 (fr_rock_1 $1D->$5D, fr_bird_1 $23->$63, fr_flame_1
// $36->$76, fr_spear $22->$62, fr_blue_1 $34->$74); palettes match the
// character viewer.
const ENEMY = {
    rock: { spr: 0x5d, theme: 5 },
    bird: { spr: 0x63, theme: 6 },
    flame: { spr: 0x76, theme: 7 },
    spear: { spr: 0x62, theme: 7 },
    blue: { spr: 0x74, theme: 7 },
};

// Reusable spawns, named for the bongo.asm spawner that sets them.
const R1 = [0xb0, 0x40, "rock"]; //  set_rock_1_b0_40   (enemy_1)
const R3 = [0x60, 0x40, "rock"]; //  set_rock_x_60      (enemy_3)
const BL_C4 = [0xf0, 0xc4, "bird"]; // set_bird_left_y_c4  (enters from right)
const BL_40 = [0xf0, 0x40, "bird"]; // set_bird_left_y_40
const BR_BC = [0x10, 0xbc, "bird"]; // set_bird_right_y_bc (enters from left)
const BR_60 = [0x10, 0x60, "bird"]; // set_bird_right_y_60
const BR_98 = [0x10, 0x98, "bird"]; // _3688
const F1 = [0x98, 0xc0, "flame"]; //  activate_flame_1
const F2 = [0x90, 0xc0, "flame"]; //  activate_flame_2
const F3 = [0x90, 0xc0, "flame"]; //  activate_flame_3
const SP_94 = [0xf0, 0x94, "spear"]; // set_spear_left_y_94   (enters from right)
const SP_50 = [0xf0, 0x50, "spear"]; // _3778
const SP_C8 = [0xf0, 0xc8, "spear"]; // set_spear_left_bottom
const SP_98 = [0xf0, 0x98, "spear"]; // set_spear_left_middle
const SP_68 = [0xf0, 0x68, "spear"]; // set_spear_left_top
const BM_HI = [0xa0, 0xd0, "blue"]; //  set_blue_meanie_a0_d0 (stair up)
const BM_R = [0xa4, 0xac, "blue"]; //   _34A8 (stairdown, right)
const BM_L = [0x80, 0x7c, "blue"]; //   _34C8 (stairdown, left)

// Per-screen spawns (1-based). [] = no enemies on that screen.
const ENEMY_SPAWNS = [
    [], // 1
    [R1], // 2
    [], // 3
    [R1, BL_C4], // 4
    [], // 5
    [], // 6
    [], // 7
    [R1, BL_C4, R3], // 8
    [R1], // 9
    [BM_HI], // 10
    [BL_40], // 11
    [BM_R, BM_L], // 12
    [BL_C4, R1, R3], // 13
    [R3, R1], // 14
    [BR_BC, BL_C4], // 15
    [], // 16
    [BR_98, BM_R, BM_L], // 17
    [BR_BC, BL_C4, R1], // 18
    [SP_94, SP_50], // 19
    [SP_94, SP_50, BM_R], // 20
    [], // 21
    [BL_40, BR_60], // 22
    [BR_98, BL_C4, BM_R], // 23
    [F1, F2, F3], // 24
    [BL_40, BR_60], // 25
    [SP_C8, SP_98, SP_68], // 26
    [BL_40, BR_60], // 27
];

export const get_enemy_spawns = (screen) =>
    (ENEMY_SPAWNS[screen - 1] ?? []).map(([x, y, type]) => ({ x, y, type }));

export const LEVEL_W = (ENTRANCE_COLS + LEVEL_COLS) * CELL;
export const LEVEL_H = ROWS * CELL;

// Palette for pickups, kept distinct from the background theme so items pop.
const PICK_THEME = 0; // red / cream / purple

// Render a screen's background into a 2d canvas context.
//   gfx   - decoded tile graphics (mk_tiles_from_rom)
//   bytes - combined code ROM bytes (get_bongo_bytes)
export const draw_level = (ctx, gfx, bytes, screen, theme = 0) => {
    const w = ctx.canvas.width;
    const cols = pal[theme];
    const pix = ctx.createImageData(w, ctx.canvas.height);
    get_screen_tiles(bytes, screen).forEach(({ col, row, tile }) => {
        draw_tile(gfx[tile], col * CELL, row * CELL, w, cols, pix);
    });
    // Pickups sit on top of the background, tinted with their own palette.
    get_pickups(screen).forEach(({ col, row, tile }) => {
        draw_tile(gfx[tile], col * CELL, row * CELL, w, pal[PICK_THEME], pix);
    });
    // Enemies (flames / rocks / birds) at their spawn points.
    get_enemy_spawns(screen).forEach(({ x, y, type }) => {
        const e = ENEMY[type];
        draw_sprite(gfx, e.spr, x, y, pal[e.theme], pix, w);
    });
    // The player at its spawn point (head over legs).
    const { x, y } = get_player_spawn(bytes, screen);
    draw_sprite(gfx, PLAYER_HEAD, x, y, pal[PLAYER_THEME], pix, w);
    draw_sprite(gfx, PLAYER_LEGS, x, y + CELL * 2, pal[PLAYER_THEME], pix, w);
    ctx.putImageData(pix, 0, 0);
};

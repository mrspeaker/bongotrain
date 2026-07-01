import { draw_tile, pal } from "./extract_gfx.js";

// Game character viewer: each character's animation frames laid out in a
// labelled row. Sprite ids, part layout and colours come from the curated
// sprite map in bongo.asm / the original gfx dump.

const CELL = 8;
const SPR = 16; // a sprite is a 2x2 group of cells (16x16)

// Draw one sprite (16x16) at x,y. ROM cell order within a sprite is
// [top-right, bottom-right, top-left, bottom-left].
export const draw_sprite = (gfx, spr, x, y, cols, pix, w) => {
    const o = spr * 4;
    draw_tile(gfx[o], x + CELL, y, w, cols, pix);
    draw_tile(gfx[o + 1], x + CELL, y + CELL, w, cols, pix);
    draw_tile(gfx[o + 2], x, y, w, cols, pix);
    draw_tile(gfx[o + 3], x, y + CELL, w, cols, pix);
};

// The player stacks a head sprite over a legs sprite.
const stack = (head, legs) => [
    [head, 0, 0],
    [legs, 0, SPR],
];

// A frame is a list of parts [spr, dx, dy]. theme indexes pal[] (extract_gfx).
// fps (optional) sets the per-character playback rate in the animation viewer.
// seq (optional) is an explicit play order of frame indices; without it the
// viewer just cycles frames 0,1,2,... The dances aren't linear: the game drives
// them from dance_frame_data (see do_cutscene in bongo.asm), an 8-step table
// stepped once per 8 vblanks (~7.5fps). Sprite id = frame byte in that table
// + 0x40, which is how these seq/fps values were derived.
const CHARS = [
    { name: "player walk", theme: 1, frames: [
        stack(0x4c, 0x4d), stack(0x4e, 0x4f), stack(0x50, 0x51),
        stack(0x52, 0x53), stack(0x54, 0x55),
    ] },
    { name: "player back", theme: 1, frames: [
        stack(0x57, 0x58), stack(0x59, 0x5a), stack(0x5b, 0x5c),
    ] },
    { name: "player dance", theme: 1, fps: 7.5, seq: [1, 0, 1, 0, 2, 0, 2, 0],
        frames: [
        stack(0x7a, 0x7b), stack(0x7c, 0x7d), stack(0x7e, 0x7f),
    ] },
    { name: "player die", theme: 1, frames: [
        [[0x66, 0, 0]], [[0x67, 0, 0]], [[0x68, 0, 0]],
    ] },
    // Walk is dino_anim_lookup fr4-7 (the only head+legs poses): head 6D/6C
    // (mouth open/closed) alternating over leg frames 70-73. Heads 6E (lunge)
    // and 6F (small far head) are head-only, legs-hidden poses -- not shown.
    { name: "dino walk", theme: 2, frames: [
        [[0x6d, CELL, 0], [0x70, 0, SPR]],
        [[0x6c, CELL, 0], [0x71, 0, SPR]],
        [[0x6d, CELL, 0], [0x72, 0, SPR]],
        [[0x6c, CELL, 0], [0x73, 0, SPR]],
    ] },
    { name: "bongo walk", theme: 2, frames: [
        [[0x69, 0, 0]], [[0x6a, 0, 0]], [[0x6b, 0, 0]],
    ] },
    { name: "bongo dance", theme: 2, fps: 7.5, seq: [1, 0, 1, 2, 3, 2, 3, 0],
        frames: [
        [[0x45, 0, 0]], [[0x46, 0, 0]], [[0x47, 0, 0]], [[0x48, 0, 0]],
    ] },
    { name: "nugget", theme: 2, frames: [
        [[0x40, 0, 0]], [[0x41, 0, 0]], [[0x42, 0, 0]], [[0x43, 0, 0]],
    ] },
    { name: "duck", theme: 6, frames: [[[0x63, 0, 0]], [[0x64, 0, 0]]] },
    { name: "blob", theme: 7, frames: [[[0x74, 0, 0]], [[0x75, 0, 0]]] },
    { name: "fire", theme: 7, frames: [[[0x76, 0, 0]], [[0x77, 0, 0]]] },
    { name: "arrow'd", theme: 7, frames: [[[0x62, 0, 0]]] },
    { name: "rock fall", theme: 5, frames: [
        [[0x5d, 0, 0]], [[0x5e, 0, 0]], [[0x5f, 0, 0]],
        [[0x60, 0, 0]], [[0x61, 0, 0]],
    ] },
];

const LABEL_W = 84;
const ROW_H = 38; // tall enough for the 32px player (head + legs)
const GAP = 6;

export const CHARS_W = 256;
export const CHARS_H = CHARS.length * ROW_H + 4;

export const draw_chars = (ctx, gfx) => {
    const w = ctx.canvas.width;
    const pix = ctx.createImageData(w, ctx.canvas.height);
    CHARS.forEach((ch, r) => {
        const y = r * ROW_H + 4;
        let x = LABEL_W;
        ch.frames.forEach((frame) => {
            frame.forEach(([spr, dx, dy]) =>
                draw_sprite(gfx, spr, x + dx, y + dy, pal[ch.theme], pix, w),
            );
            x += Math.max(...frame.map(([, dx]) => dx)) + SPR + GAP;
        });
    });
    ctx.putImageData(pix, 0, 0);

    // Row labels drawn straight to the canvas, on top of the sprites.
    ctx.fillStyle = "#fff";
    ctx.font = "10px monospace";
    ctx.textBaseline = "middle";
    CHARS.forEach((ch, r) => ctx.fillText(ch.name, 4, r * ROW_H + 4 + CELL));
};

const DEFAULT_FPS = 8; // per-character frame rate unless ch.fps overrides

// Animated view: each character's frames cycle in place over time. `t` is a
// timestamp in ms (e.g. from requestAnimationFrame). Call this every rAF tick.
export const draw_chars_anim = (ctx, gfx, t) => {
    const w = ctx.canvas.width;
    const pix = ctx.createImageData(w, ctx.canvas.height);
    CHARS.forEach((ch, r) => {
        const y = r * ROW_H + 4;
        const fps = ch.fps ?? DEFAULT_FPS;
        const seq = ch.seq ?? ch.frames.map((_, k) => k);
        const i = seq[Math.floor((t / 1000) * fps) % seq.length];
        ch.frames[i].forEach(([spr, dx, dy]) =>
            draw_sprite(gfx, spr, LABEL_W + dx, y + dy, pal[ch.theme], pix, w),
        );
    });
    ctx.putImageData(pix, 0, 0);

    ctx.fillStyle = "#fff";
    ctx.font = "10px monospace";
    ctx.textBaseline = "middle";
    CHARS.forEach((ch, r) => ctx.fillText(ch.name, 4, r * ROW_H + 4 + CELL));
};

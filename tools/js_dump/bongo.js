import { play_notes } from "./play_notes.js";

const pal = [
    ["#3ea202", "#e01d01", "#e0e0d9"],
    ["#c3c344", "#e00700", "#0b01d9"],
    ["#e08500", "#e00700", "#e0e0d9"],
    ["#00a200", "#005b94", "#e00700"],
    ["#c3c344", "#0b01d9", "#e0e0d9"],
    ["#e00700", "#e0e0d9", "#a23ed9"],
    ["#c3c344", "#0085d9", "#e0e0d9"],
    ["#e0e0d9", "#0085d9", "#c3c344"],
].map((p) =>
    p.map((c) => ({
        r: parseInt(c.substring(1, 3), 16),
        g: parseInt(c.substring(3, 5), 16),
        b: parseInt(c.substring(5, 7), 16),
    })),
);

const chunk = (arr, size) => {
    const out = [];
    let i = 0;
    while (i < arr.length) {
        out.push(arr.slice(i, i + size));
        i += size;
    }
    return out;
};

(async () => {
    const getRomBytes = (rom) =>
        fetch(`./dump/bongo/${rom}`)
            .then((r) => r.arrayBuffer())
            .then((buf) => [...new Uint8Array(buf)]);

    const b = (byte) => byte.toString(2).padStart(8, "0");
    const rot90 = (tile) => {
        const out = [];
        for (let col = 0; col < 8; col++) {
            const mask = 1 << (7 - col); // 128, 64, 32, 16, 8, 4, 2, 1
            const flp = [1, 2, 4, 8, 16, 32, 64, 128];
            let v = 0;
            for (let row = 0; row < 8; row++) {
                const shr = row; // 0,1,2,3,4,5,6,7
                v += !!(tile[row] & mask) << row;
            }
            out.push(v);
        }
        return out;
    };

    const ctx = document.getElementById("board").getContext("2d");
    const ctx_dst = document.getElementById("dst").getContext("2d");
    const w = ctx.canvas.width;
    const h = ctx.canvas.height;
    const pix = ctx.getImageData(0, 0, w, h);
    const pix_dst = ctx.getImageData(0, 0, w, h);

    const bytes1 = await getRomBytes("b-h.bin");
    const bytes2 = await getRomBytes("b-k.bin");
    const tiles1 = chunk(bytes1, 8).map(rot90);
    const tiles2 = chunk(bytes2, 8).map(rot90);
    // smoosh tiles 1 and 2 bytes into an array of pixel values (0-3)
    const tiles = tiles1.map((t, i) =>
        t.map((byte1, j) => {
            const px = [];
            const byte2 = tiles2[i][j];
            for (let k = 0; k < 8; k++) {
                const mask = 1 << (7 - k);
                const b1 = !!(byte1 & mask);
                const b2 = !!(byte2 & mask);
                // 4bits-per-pixel
                px.push((b1 << 1) | b2);
            }
            return px;
        }),
    );

    const drawTile = (tile, x, y, cols, px) => {
        for (let j = 0; j < 8; j++) {
            const row = tile[j];
            for (let i = 0; i < 8; i++) {
                const p = row[i];
                if (p === 0) continue;
                const off = (y * w + j * w + x + i) * 4;
                (px || pix).data[off + 0] = cols[p - 1].r;
                (px || pix).data[off + 1] = cols[p - 1].g;
                (px || pix).data[off + 2] = cols[p - 1].b;
                (px || pix).data[off + 3] = 255;
            }
        }
    };

    const cell_size = 8; // each sprite cell is 8 x 8
    const spr_size = cell_size * 2; // a "sprite" is 2 x 2 cells

    // Draw a 2x2 group of cells as a sprite
    // The format in memory is weird: [[1, 0], [1, 1], [0, 0], [0, 1]]
    const drawSpr = (spr, x, y, cols, px) => {
        const off = 0 + spr * 4;
        drawTile(tiles[off], x + cell_size, y, cols, px);
        drawTile(tiles[off + 1], x + cell_size, y + cell_size, cols, px);
        drawTile(tiles[off + 2], x, y, cols, px);
        drawTile(tiles[off + 3], x, y + cell_size, cols, px);
    };

    // Render tiles (alphabet single tiles)
    const tw = 32;
    const th = 16;
    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            const t = j * tw + i;
            drawTile(tiles[t], i * cell_size, j * cell_size, pal[0]);
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
            drawSpr(spr, i * spr_size, j * spr_size + yoff, col);
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
        drawTile(tiles[t], x * cell_size, y * cell_size, pal[col], pix_dst);
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

const getRomBytes = (rom) =>
    fetch(`./dump/bongo/${rom}`)
        .then((r) => r.arrayBuffer())
        .then((buf) => [...new Uint8Array(buf)]);

const tunes_5 = [0xb0c, 0xa80, 0x4c0, 0xa20];
const tunes_6 = [
    0xc86, 0xf38, 0x132, 0x6f8, 0xdf4, 0xc86, 0xd30, 0xd64, 0xe4c, 0xea0,
];

async function handle_tunes() {
    const bytes = await getRomBytes("bg6.bin");
    const val = parseInt(document.getElementById("notes").value) ?? 0;

    const start = tunes_6[0];
    const notes = [];
    let idx = 0;
    let min = 9999;
    let max = 0;
    while (bytes[start + idx] != 0xff) {
        const note = bytes[start + idx++];
        const duration = bytes[start + idx++];
        if (duration < min) min = duration;
        if (duration > max) max = duration;

        const freq = 440 * Math.pow(2, (note - 16) / 12);
        notes.push(freq);
        notes.push(duration / 3);
    }

    console.log("Notes: ", notes.length / 2, min, max);

    document.getElementById("play").addEventListener(
        "click",
        () => {
            play_notes(notes, 150);
        },
        false,
    );
}

handle_tunes();

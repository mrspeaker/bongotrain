import { chunk } from "./utils.js";

export const pal = [
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

export const mk_tiles_from_rom = (bytes1, bytes2) => {
    const tiles1 = chunk(bytes1, 8).map(rot90);
    const tiles2 = chunk(bytes2, 8).map(rot90);
    // smoosh tiles 1 and 2 bytes into an array of pixel values (0-3)
    return tiles1.map((t, i) =>
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
};

export const draw_tile = (tile, x, y, w, cols, px) => {
    for (let j = 0; j < 8; j++) {
        const row = tile[j];
        for (let i = 0; i < 8; i++) {
            const p = row[i];
            if (p === 0) continue;
            const off = (y * w + j * w + x + i) * 4;
            px.data[off + 0] = cols[p - 1].r;
            px.data[off + 1] = cols[p - 1].g;
            px.data[off + 2] = cols[p - 1].b;
            px.data[off + 3] = 255;
        }
    }
};

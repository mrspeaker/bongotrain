import { search_str } from "./search_str.js";

(async () => {
    const getRomBytes = (rom) =>
        fetch(`./romgo/${rom}`)
            .then((r) => r.arrayBuffer())
            .then((buf) => [...new Uint8Array(buf)]);

    const chunk = (arr, size) => {
        const out = [];
        let i = 0;
        while (i < arr.length) {
            out.push(arr.slice(i, i + size));
            i += size;
        }
        return out;
    };

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
    const w = ctx.canvas.width;
    const h = ctx.canvas.height;
    let pix = ctx.getImageData(0, 0, w, h);

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

    const drawTile = (tile, x, y, cols) => {
        for (let j = 0; j < 8; j++) {
            const row = tile[j];
            for (let i = 0; i < 8; i++) {
                const p = row[i];
                if (p === 0) continue;
                const off = (y * w + j * w + x + i) * 4;
                pix.data[off + 0] = cols[p - 1].r;
                pix.data[off + 1] = cols[p - 1].g;
                pix.data[off + 2] = cols[p - 1].b;
                pix.data[off + 3] = 255;
            }
        }
    };

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

    const drawSpr = (spr, x, y, cols) => {
        const off = 0 + spr * 4;
        drawTile(tiles[off], x + 8, y, cols);
        drawTile(tiles[off + 1], x + 8, y + 8, cols);
        drawTile(tiles[off + 2], x, y, cols);
        drawTile(tiles[off + 3], x, y + 8, cols);
    };

    const tw = 32;
    const th = 8;
    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            const t = j * tw + i;
            drawTile(tiles[t], i * 9, j * 9, pal[0]);
        }
    }

    let yo = 78;
    for (let j = 0; j < 4; j++) {
        for (let i = 0; i < 16; i++) {
            const spr = j * 16 + i + 64;
            const col =
                spr > 92 && spr < 98
                    ? pal[5]
                    : spr >= 98 && spr < 101
                    ? pal[6]
                    : spr > 115 && spr < 120
                    ? pal[7]
                    : pal[2];
            drawSpr(spr, i * 16, j * 16 + yo, col);
        }
    }
    ctx.putImageData(pix, 0, 0);

    setInterval(() => {
        ctx.clearRect(ctx.canvas.width - 20, 0, 20, ctx.canvas.height);
        pix = ctx.getImageData(0, 0, w, h);

        const t = Math.floor(Date.now() / 200);

        drawSpr(16 * 4 + (t % 4), ctx.canvas.width - 20, 0, pal[2]);
        drawSpr(16 * 4 + 5 + (t % 4), ctx.canvas.width - 20, 17, pal[2]);
        ctx.putImageData(pix, 0, 0);
    }, 16);

    // Hunting in bin files for strings...
    const fetches = [1, 2, 3, 4, 5, 6].map((v) => getRomBytes(`bg${v}.bin`));
    Promise.all(fetches)
        .then((b) => b.map(search_str))
        .then(console.log);
})();

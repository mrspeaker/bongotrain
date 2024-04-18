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
    const pix = ctx.getImageData(0, 0, w, h);

    const bytes1 = await getRomBytes("b-h.bin");
    const bytes2 = await getRomBytes("b-k.bin");
    const tiles1 = chunk(bytes1, 8);
    const tiles2 = chunk(bytes2, 8);

    const drawTile = (tile, x, y, r = 0, g = 0, b = 0) => {
        for (let j = 0; j < 8; j++) {
            const row = tile[j];
            for (let i = 0; i < 8; i++) {
                if (row & (1 << (7 - i))) {
                    const off = (y * w + j * w + x + i) * 4;
                    pix.data[off + 0] += r;
                    pix.data[off + 1] += g;
                    pix.data[off + 2] += b;
                    pix.data[off + 3] += 100;
                }
            }
        }
    };

    const tw = 32;
    const th = 16;
    const t = tiles1[1 * tw + 15];
    const t2 = tiles2[1 * tw + 15];
    drawTile(t, 8, 16);
    drawTile(t2, 17, 16);

    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            const t = j * tw + i;
            drawTile(rot90(tiles1[t]), i * 8, j * 8, 100, 0, 0);
            drawTile(rot90(tiles2[t]), i * 8, j * 8, 0, 100, 0);
        }
    }
    ctx.putImageData(pix, 0, 0);
})();

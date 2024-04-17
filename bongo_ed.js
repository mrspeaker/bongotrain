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

    const flip_v = (tile) => tile.toReversed();
    const flip_h = (tile) => {
        const out = [];
        for (let col = 0; col < 8; col++) {
            let v = 0;
            for (let row = 0; row < 8; row++) {
                v += (tile[row] & (1 << (7 - col))) >> (7 - row);
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
    const bytes2 = await getRomBytes("b-h.bin");
    const tiles1 = chunk(bytes1, 8).map(flip_v).map(flip_h);
    const tiles2 = chunk(bytes2, 8).map(flip_v); //.map(flip_h);

    let tiles = tiles1;

    const drawTile = (t, x, y) => {
        const tile = tiles[t];
        if (!tile) return;

        for (let j = 0; j < 8; j++) {
            const byte = tile[j];
            for (let i = 0; i < 8; i++) {
                if (byte & (1 << i)) {
                    const off = (y * w + j * w + x + i) * 4;
                    pix.data[off] = 0;
                    pix.data[off + 1] = 1;
                    pix.data[off + 2] = 2;
                    pix.data[off + 3] = 255;
                }
            }
        }
    };

    const tw = 32;
    const th = 16;

    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            drawTile(j * tw + i, i * 8, j * 8);
        }
    }
    tiles = tiles2;
    for (let j = 0; j < th; j++) {
        for (let i = 0; i < tw; i++) {
            drawTile(j * tw + i, i * 8, (j + 16) * 8);
        }
    }
    ctx.putImageData(pix, 0, 0);
})();

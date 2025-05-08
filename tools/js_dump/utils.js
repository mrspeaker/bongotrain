export const chunk = (bytes, size = 2) => {
    const out = [];
    let i = 0;
    while (i < bytes.length) {
        out.push(take(bytes, i, size));
        i += size;
    }
    return out;
};

export const take = (bytes, start, n) => bytes.slice(start, start + n);
export const pairs = (bytes, start) => chunk(bytes);

export const as_byte = ([a]) => a;
export const as_dw = ([a, b]) => (b << 8) + a;
export const to_hex = (v) => "0x" + v.toString(16);

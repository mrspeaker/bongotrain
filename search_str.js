export const search_str = (bytes) => {
    const all = bytes.reduce(
        (ac, el) => {
            const isAlpha = el >= 16 && el < 16 + 26;
            if (ac.inWord) {
                if (!isAlpha) {
                    ac.words.push([...ac.word]);
                    ac.word.length = 0;
                    ac.inWord = false;
                    return ac;
                } else {
                    ac.word.push(el);
                    return ac;
                }
            } else if (isAlpha) {
                ac.inWord = true;
                ac.word.push(el);
            }
            return ac;
        },
        { inWord: false, word: [], words: [] },
    ).words;

    return all
        .filter((w) => w.length > 2)
        .map((w) =>
            w.map((v) => (v === 16 ? " " : String.fromCharCode(v - 16 + 64))),
        )
        .flat()
        .join("");
};

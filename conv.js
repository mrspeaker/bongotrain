const get_file = async (name) => await fetch(name).then((r) => r.text());

const t = {
    NONE: 0,
    BLANK: 1,
    COMMENT: 2,
    SYMBOL: 3,
    INST: 4,
    LABEL: 5,
};

const parseLine = (raw, addr) => {
    const line = raw.trim();
    const leading = raw.length - line.trimEnd().length;
    const out = { line, leading, type: t.NONE };
    if (line === "") return { ...out, type: t.BLANK };
    if (line.startsWith(";")) return { ...out, type: t.COMMENT };
    return out;
};

const caseFix = (f) => (line) => {
    const el = f(line);
    if (el.type === t.SYMBOL) {
        const words = el.line.split("$");
        const sym = words[0].toLowerCase();
        el.line = sym + "= $" + words.slice(1).join("$");
    }
    if (el.type === t.LABEL) {
        const toks = el.line.split(" ");
        el.line = toks[0].toLowerCase() + ":" + toks.slice(1).join(" ");
    }
    return el;
};

const parseSrcLine = (raw, addr) => {
    const out = parseLine(raw, addr);
    const { type, leading, line } = out;
    if (type !== t.NONE) return out;
    if (leading > 0) return { ...out, type: t.SYMBOL };
    if (line.match(/[0-9A-F]{4}:.*/)) {
        return {
            ...out,
            type: t.INST,
            addr: parseInt(line.slice(0, 4), 16),
        };
    }
    return { ...out, type: t.LABEL, addr };
};

const parseDstLine = (raw, addr) => {
    const out = parseLine(raw, addr);
    const { type, leading, line } = out;
    if (type !== t.NONE) return out;
    if (line.split(";")[0].includes("=")) return { ...out, type: t.SYMBOL };
    if (line.match(/[0-9A-F]{4}\s.*/)) {
        return {
            ...out,
            type: t.INST,
            addr: parseInt(line.slice(0, 4), 16),
        };
    }
    return { ...out, type: t.LABEL, addr };
};

const parse = (txt, lineParser) => {
    const parsed = txt.reduce(
        (ac, line) => {
            const out = lineParser(line, ac.addr);
            if (out.addr !== undefined) {
                ac.addr = out.addr;
            }
            //if (out.type === t.LABEL) {
            ac.lines.push(out);
            //}
            return ac;
        },
        { state: 0, addr: -1, lines: [] },
    );

    // Link labels and instructions
    parsed.lines.reduce(
        (ac, line) => {
            if (!ac.label) {
                if (line.type === t.LABEL) {
                    return { label: line };
                }
            } else if (line.type === t.INST) {
                // next inst after label.
                delete ac.label.addr;
                ac.label.inst = line;
                line.label = ac.label;
                return {};
            }
            return ac;
        },
        { label: null },
    );

    return parsed.lines;
};

const get_non_inst_between = (from, to, src) => {
    const out = [];
    let started = from === -1;
    for (let i = 0; i < src.length; i++) {
        const { addr } = src[i];
        if (addr && addr === from) {
            started = true;
            continue;
        }
        // started &&
        ////console.log("add", addr, "from", from, "to", to, "start", started);
        if (addr && addr >= to) {
            // donezo.
            // console.log("lines:", out);
            break;
        }
        if (started) {
            out.push(src[i]);
        }
    }
    return out;
};

const get_meta = (src) =>
    src.reduce(
        ({ cur, groups }, line) => {
            if (line.type == t.INST) {
                if (cur.length) {
                    groups[line.addr] = [...cur];
                    cur.length = 0;
                }
            } else {
                cur.push(line);
            }
            return { cur, groups };
        },
        { cur: [], groups: {} },
    ).groups;

const moosh = (meta, code) =>
    code.reduce((ac, inst) => {
        if (meta[inst.addr]) {
            ac.push(...meta[inst.addr]);
        }
        ac.push(inst);
        return ac;
    }, []);

const moosh_comments = (comments, code) =>
    code.reduce((ac, inst) => {
        if (comments[inst.addr]) {
            inst.line += " ; " + comments[inst.addr];
            //ac.push(...meta[inst.addr]);
        }
        ac.push(inst);
        return ac;
    }, []);

const indent = (src) => {
    const sp = [0, 0, 16, 16, 0, 16];
    return src.map((i) => {
        return " ".repeat(sp[i.type]) + i.line;
    });
};

const get_inst_comments = (src) =>
    src.reduce((ac, el) => {
        if (el.type == t.INST) {
            // look for comment
            if (el.line.includes(";")) {
                ac[el.addr] = el.line.split(";")[1].trim();
            }
        }
        return ac;
    }, {});

const get_missing_labels = (src, dst) => {
    const src_labels = src.filter((el) => el.type === t.LABEL && el.inst);
    const dst_labels = dst.filter((el) => el.type === t.LABEL && el.inst);
    console.log(src_labels.length, dst_labels.length);
    return src_labels.reduce((ac, s, i) => {
        //        , dst_labels.length];
        if (
            i > 0 &&
            !ac &&
            (!s.inst || s.inst.addr !== dst_labels?.[i].inst?.addr)
        ) {
            return [i, s, dst_labels[i]];
        }
        return ac;
    }, null);
};

const get_sym_table = (dst) =>
    dst.reduce((ac, el) => {
        if (el.type === t.SYMBOL) {
            const m = el.line.match(/\s*(\w+)\s*=\s\$(\w{4})/);
            if (m) {
                if (!!ac[m[2]]) {
                    console.log("dupe:", ac[m[2]], m[2], m[1]);
                }
                ac[m[2]] = m[1];
            }
        }
        return ac;
    }, {});

const replace_sym = (dst, sym_table) => {
    const miss = new Set();
    const out = dst.map((d) => {
        if (d.type === t.INST) {
            const m = d.line.match(/\$([0-9A-Fa-f]{4})/);
            if (m) {
                const addr = parseInt(m[1], 16);
                if (addr < 0x6000) {
                    // Jump addr
                } else {
                    if (sym_table[m[1]] === undefined) {
                        console.log("oh");
                        miss.add(m[1]);
                    }
                    //console.log(m[1], sym_table[m[1]]);
                }
            }
        }
        return d;
    });
    console.log(Array.from(miss).sort());
    return out;
};

const get_labels = (dst) =>
    dst.reduce((ac, el) => {
        if (el.type === t.LABEL) {
            const m = el.line.match(/\s*(\w+)\s*:/);
            if (m) {
                ac[el.addr] = m[1];
            }
        }
        return ac;
    }, {});

const run = async () => {
    //const src_txt = await get_file("./bongo.asm");
    const dst_txt = await get_file("./bongo_src.asm");

    //const src = parse(src_txt.split("\n"), caseFix(parseSrcLine)).slice(240);
    const dst = parse(dst_txt.split("\n"), parseDstLine);

    //const labels = get_labels(dst); //dst.filter((d) => d.type === t.LABEL); //.map((d) => d.addr);
    //console.log(labels);

    const sym_table = get_sym_table(dst);
    console.log(sym_table);

    const out = replace_sym(dst, sym_table);
    //console.log(src.length, dst.length);
    //console.table(src);
    console.table(out);
    //const comments = get_inst_comments(src);
    // console.log(inst_comments);
    //const meta = get_meta(src);
    //const out = moosh_comments(comments, dst);
    //document.querySelector("#out").value = indent(out).join("\n");
};

run();

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

const run = async () => {
    //const src_txt = await get_file("./bongo.asm");
    const dst_txt = await get_file("./bongo_src.asm");

    //const src = parse(src_txt.split("\n"), caseFix(parseSrcLine)); //.slice(240);
    const dst = parse(dst_txt.split("\n"), parseDstLine); //.slice(240);
    //console.log(src.length, dst.length);
    //console.table(src);
    console.table(dst);
    //const comments = get_inst_comments(src);
    // console.log(inst_comments);
    //const meta = get_meta(src);
    //const out = moosh_comments(comments, dst);
    //document.querySelector("#out").value = indent(out).join("\n");
};

run();

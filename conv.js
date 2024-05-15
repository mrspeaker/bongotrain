const get_file = async (name) => await fetch(name).then((r) => r.text());

const t = {
    NONE: 0,
    BLANK: 1,
    COMMENT: 2,
    SYMBOL: 3,
    INST: 4,
    LABEL: 5,
};

const missing_labels = [
    "0079",
    "00B3",
    "01AD",
    "0215",
    "0246",
    "0260",
    "0260",
    "027E",
    "027E",
    "029F",
    "02B9",
    "02E3",
    "02D6",
    "02F9",
    "0304",
    "0336",
    "03C7",
    "03FA",
    "04B2",
    "04C8",
    "04D4",
    "05AB",
    "059D",
    "05A6",
    "05C2",
    "05ED",
    "06AA",
    "06B2",
    "06BE",
    "06C6",
    "06CE",
    "0797",
    "07EB",
    "0904",
    "09B1",
    "0A24",
    "0A50",
    "0ADB",
    "0AEE",
    "0B96",
    "0BE6",
    "0BD6",
    "0BBA",
    "0C8E",
    "0CA2",
    "0CB2",
    "0D19",
    "0D79",
    "0DCD",
    "0E4C",
    "0E81",
    "0E9F",
    "0F44",
    "0F4E",
    "107A",
    "10E9",
    "1121",
    "1121",
    "1126",
    "1139",
    "11DB",
];
const missing_label_map = missing_labels.reduce((ac, el) => {
    ac[el] = true;
    return ac;
}, {});

const val2hex = (val) => val.toString(16).toUpperCase().padStart(4, 0);
const hex2val = (hex) => parseInt(hex, 16);

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
    //    console.log("LABBB:", { ...out, type: t.LABEL, addr });
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
    const miss = new Map();
    const out = dst.map((d) => {
        if (d.type === t.INST) {
            const m = d.line.match(/\$([0-9A-Fa-f]{4})/);
            if (m) {
                const addr = parseInt(m[1], 16);
                if (addr >= 0x6000) {
                    if (sym_table[m[1]] === undefined) {
                        miss.set(m[1], miss.has(m[1]) ? miss.get(m[1]) + 1 : 1);
                    } else {
                        // found symbol... replace it in d.
                        //...
                        return {
                            ...d,
                            line: d.line.replace("$" + m[1], sym_table[m[1]]),
                        };
                    }
                }
            }
        }
        return { ...d };
    });
    if (miss.size > 0) {
        console.log(
            "Missing symbols",
            Array.from(miss).sort((a, b) => (a[0] > b[0] ? 1 : -1)),
        );
    }
    return out;
};

const replace_labels = (dst, labels, insts, labelMap) => {
    const miss = new Map();
    const ddd = [];
    const out = dst.flatMap((d) => {
        if (d.type === t.INST) {
            const m = d.line
                .split(";")[0]
                .slice(20)
                .match(/(\w+)[^\$]*\$([0-9A-Fa-f]{4}).*/);
            const inst_points_to_addr = m && m.length;
            if (inst_points_to_addr) {
                const ref_addr = m[2];
                const ref_addr_p = parseInt(ref_addr, 16);
                if (ref_addr_p < 0x6000) {
                    const instr = m[1];
                    const label = labels[ref_addr];
                    if (!label) {
                        miss.set(
                            ref_addr,
                            miss.has(ref_addr) ? miss.get(ref_addr) + 1 : 1,
                        );
                        // Show any invalid label addresses...
                        const label_addr_is_valid = !!insts[hex2val(ref_addr)];
                        if (!label_addr_is_valid) {
                            /* console.log(
                                "Missing label addr:",
                                val2hex(d.addr),
                                instr,
                                ref_addr,
                                );*/
                            // console.log("mis", ref_addr, d.line);
                        } else {
                            // dest addr is valid, but has no label...
                            //ddd.push(ref_addr);
                            //if (labelMap[ref_addr]) {
                            //console.log("hit", ref_addr, d.line);
                            ////} else
                        }
                    } else {
                        /*                        console.log(
                            "HIT",
                            instr,
                            label,
                            "...",
                            d.line,
                            "|",
                            d.line.replace("$" + ref_addr, label),
                        );*/
                        return {
                            ...d,
                            line: d.line.replace("$" + ref_addr, label),
                        };
                        // Got a label - replace it.
                        //const addr = parseInt(m[1], 16);
                        //                if (addr < 0x6000) {
                        //console.log(addr, labels[addr]);
                    }
                }
            }
        }
        return { ...d };
    });
    //console.log(ddd);
    //    console.table(miss);
    //console.table(Array.from(miss).sort((a, b) => (a[0] > b[0] ? 1 : -1)));
    return out;
};

const get_labels = (dst) =>
    dst.reduce((ac, el) => {
        if (el.type === t.LABEL) {
            const m = el.line.match(/\s*(\w+)\s*:/);
            if (m && m.length == 2) {
                ac[val2hex(el.inst.addr)] = m[1];
            } else {
                console.log("Bad label?", el.line);
            }
        }
        return ac;
    }, {});

const get_inst = (dst) =>
    dst.reduce((ac, el) => {
        if (el.type === t.INST) {
            ac[el.addr] = el.line;
        }
        return ac;
    }, {});

const add_missing_labels = (dst, labels) =>
    dst.reduce((ac, el) => {
        if (el.type === t.INST) {
            const addr = val2hex(el.addr);
            if (labels[addr]) {
                const label = {
                    line: `_${addr}:`,
                    leading: 16,
                    type: t.LABEL,
                    addr: el.addr,
                    inst: el,
                };
                console.log("hit", label);
                ac.push(label);
            } else {
                //  console.log("addr not in lables:", addr);
            }
        }
        ac.push(el);
        return ac;
    }, []);

const run = async () => {
    //const src_txt = await get_file("./bongo.asm");
    const dst_txt = await get_file("./bongo_src.asm");

    //const src = parse(src_txt.split("\n"), caseFix(parseSrcLine)).slice(240);
    const dsta = parse(dst_txt.split("\n"), parseDstLine);

    //const labels = get_labels(dst); //dst.filter((d) => d.type === t.LABEL); //.map((d) => d.addr);
    //console.log(labels);

    const dst = add_missing_labels(dsta, missing_label_map);

    const sym_table = get_sym_table(dst);
    const label_table = get_labels(dst);
    const inst_table = get_inst(dst);

    //console.log(inst_table);
    //const out_sym = replace_sym(dst, sym_table);
    const out_lab = replace_labels(
        dst,
        label_table,
        inst_table,
        missing_label_map,
    );
    //console.log(out_lab);
    const out = out_lab;
    document.querySelector("#out").value = indent(out).join("\n");
};

run();

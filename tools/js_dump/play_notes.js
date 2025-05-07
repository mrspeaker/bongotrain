//note_data = { freq, duration }
export function play_notes(note_data, bpm = 120) {
    const audioContext = new (window.AudioContext ||
        window.webkitAudioContext)();
    let time = audioContext.currentTime + 0.1; // start in the future
    let quarterNoteTime = 60 / bpm;

    let oscillator = audioContext.createOscillator();
    oscillator.start(time);
    oscillator.type = "square";
    let gainNode = audioContext.createGain();
    gainNode.gain.value = 0.1;

    for (let i = 0; i < note_data.length; i++) {
        const note = note_data[i];
        oscillator.frequency.setValueAtTime(note.freq, time);
        gainNode.gain.setValueAtTime(0.1, time);
        gainNode.gain.setTargetAtTime(
            0.0,
            time + note.duration * quarterNoteTime * 0.5,
            0.015,
        );
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        oscillator.stop(time + note.duration * quarterNoteTime);

        // advance time by length of note
        time += note.duration * quarterNoteTime;
    }
}

export const get_until_$ff = (bytes, start = 0) => {
    let out = [];
    let idx = 0;
    while (bytes[start + idx] != 0xff) {
        out.push(bytes[start + idx++]);
    }
    return out;
};

const take = (bytes, start, n) => bytes.slice(start, start + n);

export const chunk = (bytes, size = 2) => {
    const out = [];
    let i = 0;
    while (i < bytes.length) {
        out.push(take(bytes, i, size));
        i += size;
    }
    return out;
};

export const pairs = (bytes, start) => chunk(bytes);

const as_byte = ([a]) => a;
const as_dw = ([a, b]) => (b << 8) + a;
export const to_hex = (v) => "0x" + v.toString(16);

const follow = (bytes, ptr) => as_dw(take(bytes, ptr, 2));

const get_ptr_list = (bytes, start) => {
    let i = start;
    let back_bytes = 0;
    const is_end = () => {
        const byte = bytes[i];
        if (byte == 0xee) {
            back_bytes = bytes[i + 1];
        }
        return byte == 0xff || byte == 0xee;
    };
    const ptrs = [];
    while (!is_end()) {
        ptrs.push(as_dw(take(bytes, i, 2)));
        i += 2;
    }
    return {
        ptrs,
        repeat_idx: back_bytes > 0 ? ptrs.length - (back_bytes - 1) / 2 : -1,
    };
};
const get_meta = (bytes, meta_ptr) => {};

export const get_note_sequence = (bytes, start) =>
    pairs(get_until_$ff(bytes, start)).map(([note, dur]) => {
        return {
            freq: 440 * Math.pow(2, (note - 16 - 6) / 12),
            duration: dur / 4,
        };
    });

export const get_sfx_ptrs = (bytes, start) => {
    const ptrs = {
        voices: as_byte(take(bytes, start + 0, 1)),
        meta: as_dw(take(bytes, start + 1, 2)),
        voice0: null,
        voice1: as_dw(take(bytes, start + 3, 2)),
        voice2: as_dw(take(bytes, start + 5, 2)),
    };
    ptrs.voice0 = ptrs.meta + 4;
    return ptrs;
};

const map_meta = ([len, speed, volume, transpose]) => ({
    len,
    speed,
    volume,
    transpose,
});

export const get_sfx_ptr_lists = (bytes, ptrs) => {
    return {
        voices: ptrs.voices,
        meta: map_meta(take(bytes, ptrs.meta, 4)),
        voice0: get_ptr_list(bytes, ptrs.voice0),
        voice1: get_ptr_list(bytes, ptrs.voice1),
        voice2: get_ptr_list(bytes, ptrs.voice2),
    };
};

export const get_sfx = (bytes, start) => {
    if (!start) {
        throw new Error("nop start");
    }
    const ptrs = get_sfx_ptrs(bytes, start);
    return get_sfx_ptr_lists(bytes, ptrs);
};

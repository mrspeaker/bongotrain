export function play_notes(tones, bpm = 120) {
    const audioContext = new (window.AudioContext ||
        window.webkitAudioContext)();
    let time = audioContext.currentTime + 0.1; // start in the future
    let quarterNoteTime = 60 / bpm;

    let oscillator = audioContext.createOscillator();
    oscillator.start(time);
    oscillator.type = "square";
    let gainNode = audioContext.createGain();
    gainNode.gain.value = 1;

    for (let i = 0; i < tones.length; i += 2) {
        oscillator.frequency.setValueAtTime(tones[i], time);
        gainNode.gain.setValueAtTime(0.25, time);
        gainNode.gain.setTargetAtTime(0.0, time + tones[i + 1], 0.015);
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        oscillator.stop(time + tones[i + 1] * quarterNoteTime);

        // advance time by length of note
        time += tones[i + 1] * quarterNoteTime;
    }
}

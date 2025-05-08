export const get_rom_bytes = (rom) =>
    fetch(`./dump/bongo/${rom}`)
        .then((r) => r.arrayBuffer())
        .then((buf) => [...new Uint8Array(buf)]);

export async function get_bongo_bytes() {
    return [
        ...(await get_rom_bytes("bg1.bin")),
        ...(await get_rom_bytes("bg2.bin")),
        ...(await get_rom_bytes("bg3.bin")),
        ...(await get_rom_bytes("bg4.bin")),
        ...(await get_rom_bytes("bg5.bin")),
        ...(await get_rom_bytes("bg6.bin")),
    ];
}

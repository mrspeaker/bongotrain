#!/bin/bash

# relies on zmac (http://48k.ca/zmac.html) for compilation

# Notes: making compileable listing from mame `dasm`
# 1. In Mame: `dasm bongdump.asm,0,5fff,1`  ; last 1 is for opcodes on/off
# 2. Manually chop off start of lines to only leave instructions
# 3. zmac -j -c -n bongdump.asm ; try to compile with rel jumps fixed
# .. rename any `rrd (hl)` to `rrd` (same for `rld`)
# 4. copy zout/bongdump.lst back to be new source, then build.sh...

# Test which bits are diff:
# cmp  -l -x dump/bg1.bin zout/bg1
#

# Usage: ./build.sh [--hack]
#   default: CRC errors are fatal - no zip is produced, exits non-zero.
#   --hack:  CRC errors are only warnings - a (bootleg) zip is still produced.

hack=0
for arg in "$@"; do
    case "$arg" in
        --hack) hack=1 ;;
        *) echo "Unknown option: $arg"; echo "Usage: $0 [--hack]"; exit 2 ;;
    esac
done

set -e

# clear previous output
rm -rf zout
echo "clean:     go."

# compile to un-annotated bytes
echo -n "compile:   "
zmac -j -c -n --oo cim,lst bongo.asm
echo "go."

# split bytes into 4K chunks (to mimic ROMs)
echo -n "split:     "
split -b4k -d -a 1 zout/bongo.cim zout/bg
# rename chunks to match the ROM names (bg0 -> bg1.bin, ...)
for f in zout/bg[0-9]; do
    n=${f#zout/bg}
    mv "$f" "zout/bg$((n+1)).bin"
done

# check the checksums match to real ROM dumps
obj=(`echo zout/bg*.bin`)
rom=(`echo dump/bongo/bg*.bin`)

if [ ${#obj[@]} -eq "6" ]; then
    echo "go."
else
    echo "-"
    echo "Error: bad split. ${#obj[@]} files instead of 6"
    echo
fi

# CRC verify split files
err=0
for index in ${!obj[*]}; do
    a=`shasum ${obj[$index]} | awk '{ print $1 }'`
    b=`shasum ${rom[$index]} | awk '{ print $1 }'`
    if test "$a" != "$b"
    then
        if [ "$hack" -eq "1" ]; then
            printf "CRC warning: %s differs from %s (\$%04x)\n" ${obj[$index]} ${rom[$index]} $((index*0x1000))
        else
            echo
            printf "CRC error: %s - %s (\$%04x):\n" ${obj[$index]} ${rom[$index]} $((index*0x1000))
            cmp -l ${obj[$index]} ${rom[$index]} | head -n 5 || true
        fi
        err=$((err+1))
    fi
done

if [ "$err" -ne "0" ] && [ "$hack" -eq "0" ]; then
    echo
    echo "no go."
    exit 1
fi

# package up full Bongo MAME ROMs
echo -n "zip:       "
cd zout
rm bongo.cim

# copy over color and gfx ROMs
cp ../dump/bongo/b-*.bin .
# non-exact (--hack) builds get a -hack suffix so they're never mistaken for the real ROM set
zipname=bongo.zip
if [ "$err" -ne "0" ]; then
    zipname=bongo-hack.zip
fi
zip -j -q "$zipname" *.bin
cd ..

if [ "$err" -eq "0" ]; then
    echo "go."
    echo "bon:       go!"
else
    echo "-"
    echo "(bootleg) zip: go. (zout/$zipname)"
    echo "hack:      go. $err ROMs differ from original."
fi

echo

set +e

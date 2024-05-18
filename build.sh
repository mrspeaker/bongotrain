#!/bin/bash

# relies on zmac (http://48k.ca/zmac.html) for compilation

# Notes: making compileable listing from mame `dasm`
# 1. In Mame: `dasm bongdump.asm,0,5fff,0`  ; note last 0 to omit something?
# 2. Manually chop off start of lines to only leave instructions
# 3. zmac -j -c -n bongdump.asm ; try to compile with rel jumps fixed
# .. rename any `rrd (hl)` to `rrd` (same for `rld`)
# 4. copy zout/bongdump.lst back to be new source, then build.sh...

# Test which bits are diff:
# cmp  -l -x dump/suprmous.x3 zout/fac

set -e

# clear previous output
rm -rf zout
echo "clean:     go."

# compile to un-annotated bytes
zmac -j -c -n --oo cim,lst bongo.asm
echo "compile:   go."

# split bytes into 4K chunks (to mimic ROMs)
split -b4k -d -a 1 zout/bongo.cim zout/bg
echo "split:     go."

# check the checksums match to real ROM dumps
obj=(
  zout/bg0
  zout/bg1
  zout/bg2
  zout/bg3
  zout/bg4
  zout/bg5
)
rom=(
  dump/romgo/bg1.bin
  dump/romgo/bg2.bin
  dump/romgo/bg3.bin
  dump/romgo/bg4.bin
  dump/romgo/bg5.bin
  dump/romgo/bg6.bin
)

#shasum `echo zout/bg*` | awk '{ print $1 }'

err=0
for index in ${!obj[*]}; do
    a=`shasum ${obj[$index]} | awk '{ print $1 }'`
    b=`shasum ${rom[$index]} | awk '{ print $1 }'`
    if test "$a" != "$b"
    then
        echo
        echo "CRC error: ${obj[$index]} - ${rom[$index]} (${index}k):"
        cmp -l -x ${obj[$index]} ${rom[$index]} | head -n 5
        err=$((err+1))
    fi
done

# package up full Bongo MAME ROMs
cd zout
mv bg0 bg1.bin
mv bg1 bg2.bin
mv bg2 bg3.bin
mv bg3 bg4.bin
mv bg4 bg5.bin
mv bg5 bg6.bin
rm bongo.cim
# copy over color and gfx ROMs
cp ../dump/romgo/b-clr.bin .
cp ../dump/romgo/b-h.bin .
cp ../dump/romgo/b-k.bin .
zip -j -q bongo.zip *.bin
cd ..

if [ "$err" -eq "0" ]; then
    echo "bongo.zip: go."
    echo "bon:       go."
else
    echo "(bootleg) bongo.zip: go."
    echo
    echo "no go."
fi

echo

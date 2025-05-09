#!/bin/bash

# relies on zmac (http://48k.ca/zmac.html) for compilation

# Notes: making compileable listing from mame `dasm`
# 1. In Mame: `dasm bongdump.asm,0,5fff,0`  ; note last 0 to omit something?
# 2. Manually chop off start of lines to only leave instructions
# 3. zmac -j -c -n bongdump.asm ; try to compile with rel jumps fixed
# .. rename any `rrd (hl)` to `rrd` (same for `rld`)
# 4. copy zout/bongdump.lst back to be new source, then build.sh...

# Test which bits are diff:
# cmp  -l -x dump/bg1.bin zout/bg1
#

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

# check the checksums match to real ROM dumps
obj=(`echo zout/bg*`)
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
        echo
        echo "CRC error: ${obj[$index]} - ${rom[$index]} (${index}k):"
        cmp -l ${obj[$index]} ${rom[$index]} | head -n 5
        err=$((err+1))
    fi
done

# package up full Bongo MAME ROMs
echo -n "zip:       "
cd zout
mv bg0 bg1.bin
mv bg1 bg2.bin
mv bg2 bg3.bin
mv bg3 bg4.bin
mv bg4 bg5.bin
mv bg5 bg6.bin
rm bongo.cim

# copy over color and gfx ROMs
cp ../dump/bongo/b-*.bin .
zip -j -q bongo.zip *.bin
cd ..

if [ "$err" -eq "0" ]; then
    echo "go."
    echo "bon:       go!"
else
    echo "-"
    echo "(bootleg) zip: go."
    echo
    echo "no go."
fi

echo

set +e

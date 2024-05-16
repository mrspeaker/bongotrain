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
echo "clean:   go."

# compile to un-annotated bytes
zmac -j -c -n bongo.asm
echo "compile: go."

# split bytes into 4K chunks (to mimic ROMs)
split -b4k zout/bongo.cim zout/b_
echo "split:   go."

# check the checksums match to real ROM dumps
obj=(
  zout/b_aa
  zout/b_ab
  zout/b_ac
  zout/b_ad
  zout/b_ae
  zout/b_af
)
rom=(
  dump/romgo/bg1.bin
  dump/romgo/bg2.bin
  dump/romgo/bg3.bin
  dump/romgo/bg4.bin
  dump/romgo/bg5.bin
  dump/romgo/bg6.bin
)

err=0
for index in ${!obj[*]}; do
    a=`shasum ${obj[$index]} | sed 's/.*=.//g'`
    b=`shasum ${rom[$index]} | sed 's/.*=.//g'`
    a_sha=`echo $a | cut -c 1-40`
    b_sha=`echo $b | cut -c 1-40`
    if test "$a_sha" != "$b_sha"
    then
        err=$((err+1))
        echo
        echo "CRC error: ${obj[$index]} - ${rom[$index]} (${index}k):"
        cmp -l -x ${obj[$index]} ${rom[$index]} | head -n 5
    fi
done

if [ "$err" -eq "0" ]; then
    echo "bon:     go."
else
    echo "no go."
fi

echo

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

rm -rf zout

zmac -j -c -n bongo.asm
split -b4k zout/bongo.cim zout/b_

a=`shasum zout/b_aa | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg1.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

a=`shasum zout/b_ab | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg2.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

a=`shasum zout/b_ac | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg3.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

a=`shasum zout/b_ad | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg4.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

a=`shasum zout/b_ae | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg5.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

a=`shasum zout/b_af | sed 's/.*=.//g'`
b=`shasum dump/romgo/bg6.bin | sed 's/.*=.//g'`
echo $a | cut -c 33-
echo $b | cut -c 33-
echo

#if [ "$f1a" = "$f1b" ]; then
#    echo "ROM 1 OK"
#else
#    echo "ROM 1 checksum error"
#fi

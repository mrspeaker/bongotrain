    and  d
    ld   ($B001),a
    ld   ($80FF),a
    ld   a,$FF
    ld   ($B800),a
    jp   $14A0
    ld   sp,$83F0
    call $3F00
    call $0048
    call $2288
    jp   $008D
    add  ix,de
    add  ix,de
    dec  hl
    djnz $FFD4
    rrd
    ld   (ix-$13),a
    ld   l,a
    db   $dd
    add  ix,de
    rld
    db   $dd
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($B800)
    jr   $0038
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($A000)
    and  $83
    ret  z
    call $1470
    call $0310
    add  hl,bc
    nop
    inc  de
    ld   ($1415),hl
    add  hl,de
    inc  h
    djnz $0074
    ld   de,$1C25
    inc  h
    rst  $38
    jr   $0048
    rst  $38
    xor  a
    ld   ($B001),a
    ld   a,($B800)
    call $00C0
    ld   a,($8034)
    and  a
    jr   nz,$0079
    call $0190
    ld   b,$01
    call $1100
    call $2420
    nop
    ld   a,($A000)
    bit  1,a
    jp   nz,$C003
    retn
    rst  $38
    call $0348
    call $3080
    call $13A0
    ld   a,($8303)
    and  a
    jr   nz,$00A4
    call $0370
    call $1470
    jr   $0093
    call $13A0
    ld   a,($8303)
    cp   $01
    jr   nz,$00B3
    call $00D0
    jr   $00B6
    call $0140
    ld   a,($8034)
    and  a
    jp   nz,$01E7
    jr   $00A4
    rst  $38
    exx
    call $0288
    call $1550
    call $2960
    call $01D0
    exx
    ret
    rst  $38
    ld   a,$01
    ld   ($8090),a
    xor  a
    ld   ($B004),a
    ld   a,($8303)
    ld   b,a
    ld   a,($8035)
    cp   b
    ret  z
    nop
    nop
    nop
    call $1480
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $2450
    call $0310
    add  hl,bc
    dec  bc
    jr   nz,$011C
    dec  d
    inc  hl
    inc  hl
    rst  $38
    call $0310
    inc  c
    add  hl,bc
    rra
    ld   e,$15
    djnz $0128
    inc  e
    ld   de,$1529
    ld   ($CDFF),hl
    djnz $0114
    rrca
    adc  a,e
    ld   (de),a
    dec  h
    inc  h
    inc  h
    rra
    ld   e,$FF
    call $0310
    add  hl,de
    add  hl,bc
    inc  de
    ld   ($1415),hl
    add  hl,de
    inc  h
    inc  hl
    rst  $38
    ld   hl,$8303
    xor  a
    rld
    ld   ($9199),a
    rld
    ld   ($9179),a
    rld
    ld   a,($8303)
    ld   ($8035),a
    ret
    rst  $38
    rst  $38
    call $2430
    ld   a,($8303)
    ld   b,a
    ld   a,($8035)
    cp   b
    nop
    call $00D0
    call $0310
    inc  c
    ld   b,$1F
    ld   e,$15
    djnz $0178
    ld   ($2410),hl
    daa
    rra
    djnz $0180
    inc  e
    ld   de,$1529
    ld   ($C9FF),hl
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0020
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push bc
    ld   bc,$4000
    add  hl,bc
    pop  bc
    jp   (hl)
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8303)
    and  a
    ret  z
    ld   a,($83F1)
    bit  0,a
    jr   z,$01AD
    call $1460
    ld   a,$01
    ld   ($8034),a
    ld   a,($8303)
    dec  a
    daa
    ld   ($8303),a
    ret
    ld   a,($8303)
    dec  a
    ret  z
    ld   a,($83F1)
    bit  1,a
    ret  z
    call $1460
    ld   a,$02
    ld   ($8034),a
    ld   a,($8303)
    dec  a
    daa
    dec  a
    daa
    ld   ($8303),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($A000)
    ld   ($800B),a
    ld   a,($83F1)
    ld   ($800C),a
    ld   a,($83F2)
    ld   ($800D),a
    ret
    jp   $0180
    ret
    ld   a,$1F
    ld   ($805B),a
    ld   ($805C),a
    nop
    ld   a,($83F2)
    and  $06
    sra  a
    add  a,$02
    ld   ($8032),a
    ld   ($8033),a
    ld   a,($8034)
    dec  a
    ld   ($8031),a
    ld   a,$01
    ld   ($8004),a
    ld   a,($8031)
    and  a
    jr   nz,$0215
    xor  a
    ld   ($8033),a
    ld   a,$01
    ld   ($8029),a
    ld   ($802A),a
    ld   ($8090),a
    ld   sp,$83F0
    ld   a,($8004)
    xor  $01
    ld   ($8004),a
    ld   hl,$8032
    add  a,l
    ld   l,a
    ld   a,(hl)
    and  a
    jr   nz,$0246
    ld   a,($8004)
    xor  $01
    ld   ($8004),a
    ld   hl,$8032
    add  a,l
    ld   l,a
    ld   a,(hl)
    and  a
    jp   z,$0410
    dec  a
    ld   (hl),a
    ld   a,($83F1)
    bit  7,a
    jr   z,$0260
    ld   a,($8004)
    cp   $01
    jr   nz,$0260
    ld   a,$01
    ld   ($B006),a
    ld   ($B007),a
    jr   $0267
    xor  a
    ld   ($B006),a
    ld   ($B007),a
    ld   a,($83F2)
    bit  3,a
    jr   z,$027E
    ld   a,$03
    ld   ($8032),a
    ld   a,($8033)
    and  a
    jr   z,$027E
    ld   a,$03
    ld   ($8033),a
    jp   $1000
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8306)
    and  a
    jr   z,$029F
    dec  a
    ld   ($8306),a
    ret  nz
    ld   a,($A000)
    and  $03
    ret  z
    ld   a,$05
    ld   ($8306),a
    ret
    ld   a,($A000)
    and  $03
    ret  z
    ld   b,a
    ld   a,$20
    ld   ($8093),a
    ld   a,b
    cp   $01
    jr   nz,$02B9
    ld   a,($8305)
    inc  a
    ld   ($8305),a
    jr   $02C1
    ld   a,($8305)
    add  a,$06
    ld   ($8305),a
    ld   a,$07
    ld   ($8306),a
    ld   a,($83F1)
    bit  6,a
    jr   z,$02E3
    ld   a,($8305)
    and  a
    ret  z
    ld   b,a
    ld   a,($8303)
    inc  a
    daa
    dec  b
    jr   nz,$02D6
    ld   ($8303),a
    xor  a
    ld   ($8305),a
    ret
    ld   a,($8305)
    and  a
    ret  z
    cp   $01
    ret  z
    ld   b,a
    ld   a,($8303)
    inc  a
    daa
    dec  b
    jr   z,$02F9
    dec  b
    jr   z,$0304
    jr   $02EF
    dec  a
    daa
    ld   ($8303),a
    ld   a,$01
    ld   ($8305),a
    ret
    ld   ($8303),a
    xor  a
    ld   ($8305),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($B800)
    ld   hl,$9040
    pop  bc
    ld   a,(bc)
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc)
    ld   e,a
    ld   a,$1B
    sub  e
    ld   e,a
    ld   d,$00
    sla  e
    sla  e
    sla  e
    add  hl,de
    add  hl,de
    add  hl,de
    add  hl,de
    inc  bc
    ld   a,(bc)
    inc  bc
    cp   $FF
    jr   nz,$0336
    push bc
    ret
    ld   (hl),a
    ld   d,$FF
    ld   e,$E0
    add  hl,de
    jr   $032E
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    call $1470
    ld   hl,$8000
    ld   (hl),$00
    inc  l
    jr   nz,$0351
    inc  h
    ld   a,($B800)
    ld   a,h
    cp   $88
    jr   nz,$0351
    ld   sp,$83F0
    ld   a,$01
    ld   ($8090),a
    jp   $0583
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $1470
    ld   hl,$1520
    call $01E3
    ld   hl,$0E20
    call $01E3
    ld   hl,$17C0
    call $01E3
    ld   hl,$15A0
    call $01E3
    nop
    nop
    nop
    ret
    rst  $38
    call $13A0
    jr   $0390
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0408
    ld   a,($8032)
    and  a
    ld   b,a
    ld   a,$8A
    jr   z,$03C7
    dec  b
    ld   ($92C2),a
    jr   z,$03C7
    dec  b
    ld   ($92A2),a
    jr   z,$03C7
    dec  b
    ld   ($9282),a
    jr   z,$03C7
    dec  b
    ld   ($9262),a
    jr   z,$03C7
    ld   ($9242),a
    ld   a,($8033)
    and  a
    ld   b,a
    ret  z
    ld   a,$8A
    dec  b
    ld   ($9122),a
    ret  z
    dec  b
    ld   ($9142),a
    ret  z
    dec  b
    ld   ($9162),a
    ret  z
    dec  b
    ld   ($9182),a
    ret  z
    ld   ($91A2),a
    ret
    rst  $38
    xor  a
    ld   ($8034),a
    ld   ($8035),a
    jp   $0093
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$E0
    call $13A0
    inc  c
    jr   nz,$03FA
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$01
    ld   ($8105),a
    ret
    rst  $38
    rst  $38
    ld   hl,$16E8
    call $01E3
    call $24E0
    call $0430
    call $1470
    xor  a
    ld   ($B004),a
    jp   $2D00
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0440
    call $0470
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8016)
    ld   c,a
    ld   a,($8302)
    scf
    ccf
    sbc  a,c
    call c,$04E0
    ret  nz
    ld   a,($8015)
    ld   c,a
    ld   a,($8301)
    scf
    ccf
    sbc  a,c
    call c,$04E0
    ret  nz
    ld   a,($8014)
    ld   c,a
    ld   a,($8300)
    scf
    ccf
    sbc  a,c
    call c,$04E0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8019)
    ld   c,a
    ld   a,($8302)
    scf
    ccf
    sbc  a,c
    call c,$0500
    ret  nz
    ld   a,($8018)
    ld   c,a
    ld   a,($8301)
    scf
    ccf
    sbc  a,c
    call c,$0500
    ret  nz
    ld   a,($8017)
    ld   c,a
    ld   a,($8300)
    scf
    ccf
    sbc  a,c
    call c,$0500
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$01
    call $13A0
    dec  c
    jr   nz,$04B2
    ret
    rst  $38
    call $28E0
    ld   a,($8004)
    and  a
    jr   nz,$04C8
    ld   a,($805B)
    jr   $04CB
    ld   a,($805C)
    ld   b,a
    ld   a,($805D)
    inc  a
    cp   b
    jr   nz,$04D4
    xor  a
    ld   ($805D),a
    and  a
    ret  nz
    call $22F0
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8014)
    ld   ($8300),a
    ld   a,($8015)
    ld   ($8301),a
    ld   a,($8016)
    ld   ($8302),a
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8017)
    ld   ($8300),a
    ld   a,($8018)
    ld   ($8301),a
    ld   a,($8019)
    ld   ($8302),a
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8038
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$38
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$38
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$38
    inc  hl
    ld   (hl),$38
    inc  hl
    ld   (hl),$31
    inc  hl
    ld   (hl),$31
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$31
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$31
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$30
    call $0888
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0348
    call $3080
    call $13A0
    ld   a,($8034)
    and  a
    jr   nz,$05AB
    ld   a,($8303)
    and  a
    jr   nz,$059D
    call $0370
    call $1470
    jr   $0586
    cp   $01
    jr   nz,$05A6
    call $00D0
    jr   $0586
    call $0140
    jr   $0586
    jp   nz,$01E7
    jr   $0586
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8303)
    and  a
    jr   nz,$05C2
    call $13A0
    ret
    call $13A0
    pop  hl
    pop  hl
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   z,$05ED
    ld   a,($800C)
    bit  7,a
    jr   z,$05ED
    ld   a,($800C)
    and  $3C
    ld   b,a
    ld   a,($800B)
    and  $40
    add  a,b
    ld   ($800E),a
    ret
    ld   a,($800B)
    and  $3C
    ld   b,a
    ld   a,($800B)
    and  $80
    srl  a
    add  a,b
    ld   ($800E),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  c
    ld   c,$10
    ld   c,$0C
    ld   (de),a
    inc  d
    ld   (de),a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8010)
    inc  a
    and  $07
    ld   ($8010),a
    ld   hl,$0608
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8141),a
    inc  a
    ld   ($8145),a
    ld   a,($8140)
    inc  a
    inc  a
    inc  a
    ld   ($8140),a
    ld   ($8144),a
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    adc  a,h
    adc  a,(hl)
    sub  b
    adc  a,(hl)
    adc  a,h
    sub  d
    sub  h
    sub  d
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8010)
    inc  a
    and  $07
    ld   ($8010),a
    ld   hl,$0648
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8141),a
    inc  a
    ld   ($8145),a
    ld   a,($8140)
    dec  a
    dec  a
    dec  a
    ld   ($8140),a
    ld   ($8144),a
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($8012)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    ret  nz
    ld   a,($800E)
    bit  5,a
    jr   z,$06B6
    call $0710
    bit  2,a
    jr   z,$06AA
    call $07A0
    ret
    bit  3,a
    jr   z,$06B2
    call $07C0
    ret
    call $08C0
    ret
    bit  2,a
    jr   z,$06BE
    call $0658
    ret
    bit  3,a
    jr   z,$06C6
    call $0618
    ret
    bit  4,a
    jr   z,$06CE
    nop
    nop
    nop
    ret
    bit  6,a
    ret  z
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    nop
    ld   a,($800F)
    dec  a
    ld   ($800F),a
    sla  a
    sla  a
    add  a,l
    ld   l,a
    ld   ix,$8140
    ld   a,(hl)
    add  a,(ix+$00)
    ld   (ix+$00),a
    ld   (ix+$04),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$01),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a
    inc  hl
    ld   a,(hl)
    add  a,(ix+$07)
    ld   (ix+$07),a
    sub  $10
    ld   (ix+$03),a
    ret
    push af
    ld   a,$A0
    ld   ($804A),a
    ld   a,$0F
    ld   ($8049),a
    pop  af
    ret
    rst  $38
    rst  $38
    rst  $38
    adc  a,h
    djnz $0722
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jp   m,$8D8C
    inc  c
    jp   m,$8F8E
    inc  c
    jp   m,$9190
    ld   b,$FA
    sub  b
    sub  (hl)
    nop
    jp   m,$9190
    jp   m,$8EFA
    adc  a,a
    call p,$8CFA
    adc  a,l
    call p,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   b,$0C
    dec  c
    inc  c
    ld   b,$0E
    rrca
    inc  c
    ld   b,$10
    ld   de,$0606
    djnz $0775
    nop
    ld   b,$10
    ld   de,$06FA
    ld   c,$0F
    call p,$0C06
    dec  c
    call p,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8316)
    and  $07
    ret  nz
    ld   a,($8012)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    ret  z
    ld   a,$01
    ld   ($8005),a
    ld   a,($800E)
    bit  2,a
    jr   z,$0797
    ld   hl,$0728
    call $06D8
    ret
    jp   $07E0
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8005)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    ret  nz
    call $0988
    and  a
    ret  z
    ld   a,$07
    ld   ($800F),a
    ld   a,$8C
    ld   ($8141),a
    ld   a,$8D
    jp   $07F4
    ret
    rst  $38
    ld   a,($8005)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    ret  nz
    call $0988
    and  a
    ret  z
    ld   a,$07
    ld   ($800F),a
    ld   a,$0C
    ld   ($8141),a
    ld   a,$0D
    jp   $07F4
    ret
    rst  $38
    bit  3,a
    jr   z,$07EB
    ld   hl,$0750
    call $06D8
    ret
    ld   hl,$0948
    call $06D8
    ret
    rst  $38
    rst  $38
    ld   ($8145),a
    ld   a,$04
    ld   ($8043),a
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0000
    nop
    nop
    nop
    nop
    ld   bc,$003A
    cp   b
    ld   hl,$9040
    pop  bc
    ld   a,(bc)
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc)
    ld   e,a
    ld   a,$1B
    sub  e
    ld   e,a
    ld   d,$00
    sla  e
    sla  e
    sla  e
    add  hl,de
    add  hl,de
    add  hl,de
    add  hl,de
    inc  bc
    ld   a,(bc)
    ld   e,a
    inc  bc
    ld   a,(bc)
    ld   d,a
    inc  bc
    push bc
    ld   a,(de)
    cp   $FF
    ret  z
    inc  de
    ld   (hl),a
    ld   b,$FF
    ld   c,$E0
    add  hl,bc
    jr   $082D
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    exx
    pop  hl
    ld   d,h
    ld   e,l
    ld   hl,$9040
    pop  bc
    ld   a,(bc)
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc)
    inc  bc
    push bc
    push de
    ld   e,a
    ld   a,$1D
    sub  e
    ld   e,a
    ld   d,$00
    sla  e
    sla  e
    sla  e
    add  hl,de
    add  hl,de
    add  hl,de
    add  hl,de
    pop  de
    ld   ix,$802C
    ld   (ix+$00),$20
    ld   a,(de)
    ld   (hl),a
    inc  de
    ld   bc,$FFE0
    dec  (ix+$00)
    xor  a
    cp   (ix+$00)
    jr   z,$0880
    add  hl,bc
    ld   a,($B800)
    jr   $086B
    exx
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($800E)
    bit  5,a
    ret  nz
    xor  a
    ld   ($8005),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8140
    ld   (hl),$10
    inc  hl
    ld   (hl),$0C
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$CE
    inc  hl
    ld   (hl),$10
    inc  hl
    ld   (hl),$0D
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$DE
    call $1820
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8005)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    ret  nz
    call $0988
    and  a
    ret  z
    ld   a,$07
    ld   ($800F),a
    ld   a,$17
    ld   ($8141),a
    jp   $0930
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $07
    jr   nz,$0904
    ld   a,($8023)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   ($8023),a
    ld   hl,$0918
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8149),a
    ld   a,($8312)
    and  $01
    ret  nz
    ld   a,($8148)
    inc  a
    ld   ($8148),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    add  hl,hl
    ld   hl,($2A2B)
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  c
    xor  d
    xor  e
    xor  d
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$18
    ld   ($8145),a
    ld   a,$04
    ld   ($8043),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    rla
    jr   $0958
    nop
    add  hl,de
    ld   a,(de)
    inc  c
    nop
    dec  de
    inc  e
    ld   b,$00
    sbc  a,e
    sbc  a,h
    nop
    nop
    sbc  a,c
    sbc  a,d
    jp   m,$9700
    sbc  a,b
    call p,$1700
    jr   $0958
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   b,l
    xor  a
    sub  h
    and  $F8
    ld   l,a
    ld   h,$00
    add  hl,hl
    add  hl,hl
    ld   a,$90
    add  a,h
    ld   h,a
    ld   a,b
    srl  a
    srl  a
    srl  a
    add  a,l
    ld   l,a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8147)
    add  a,$10
    srl  a
    srl  a
    and  $FE
    ld   hl,$8100
    add  a,l
    ld   l,a
    ld   a,($8144)
    sub  (hl)
    add  a,$08
    ld   h,a
    ld   a,($8147)
    add  a,$10
    ld   l,a
    call $0968
    ld   a,(hl)
    and  $F8
    cp   $F8
    jr   z,$09B1
    xor  a
    ret
    ld   a,$01
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8012)
    and  a
    ret  nz
    ld   a,($800F)
    and  a
    jr   z,$09E6
    and  $0C
    ret  nz
    call $0988
    and  a
    ret  z
    xor  a
    ld   ($800F),a
    ld   a,($8141)
    and  $80
    add  a,$0C
    ld   ($8141),a
    inc  a
    ld   ($8145),a
    ret
    call $0988
    and  a
    jr   nz,$09F7
    ld   a,($8011)
    and  a
    ret  nz
    ld   a,$10
    ld   ($8011),a
    ret
    xor  a
    ld   ($8011),a
    call $0A68
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $07
    jr   nz,$0A24
    ld   a,($8023)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   ($8023),a
    ld   hl,$0920
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8149),a
    ld   a,($8312)
    and  $01
    ret  nz
    ld   a,($8148)
    dec  a
    ld   ($8148),a
    ret
    rst  $38
    nop
    nop
    nop
    nop
    nop
    ld   a,$01
    ld   ($8012),a
    ret
    rst  $38
    rst  $38
    ld   a,($8011)
    and  a
    ret  z
    dec  a
    ld   ($8011),a
    and  a
    jr   nz,$0A50
    call $0A33
    ret
    ld   a,($8143)
    inc  a
    inc  a
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8143)
    and  $F8
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8012)
    and  a
    ret  nz
    ld   a,($8143)
    add  a,$01
    srl  a
    srl  a
    and  $FE
    ld   hl,$8100
    add  a,l
    ld   l,a
    ld   a,($8140)
    sub  (hl)
    add  a,$08
    ld   h,a
    ld   a,($8143)
    add  a,$01
    ld   l,a
    call $0968
    ld   a,(hl)
    and  $C0
    cp   $C0
    ret  nz
    call $0AB8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8011)
    and  a
    ret  nz
    xor  a
    ld   ($800F),a
    ld   a,$08
    ld   ($8011),a
    call $13A0
    call $13A0
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$0ADB
    ld   a,($8029)
    jr   $0ADE
    ld   a,($802A)
    dec  a
    ld   hl,$0B00
    sla  a
    add  a,l
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   hl,$8180
    ld   d,$23
    ld   a,(bc)
    ld   (hl),a
    inc  bc
    inc  hl
    dec  d
    jr   nz,$0AEE
    call $1898
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   c,$0B0E
    jr   c,$0B10
    jr   c,$0B12
    jr   c,$0B14
    jr   c,$0B16
    jr   c,$0B18
    jr   c,$0B1A
    jr   c,$0B1C
    jr   c,$0B1E
    jr   c,$0B20
    jr   c,$0B22
    jr   c,$0B24
    jr   c,$0B26
    jr   c,$0B28
    jr   c,$0B2A
    djnz $0B2C
    jr   c,$0B2E
    jr   c,$0B30
    djnz $0B32
    jr   c,$0B34
    jr   c,$0B36
    jr   c,$0B38
    jr   c,$0B3A
    jr   c,$0B3C
    jr   c,$0B3E
    jr   c,$0B40
    djnz $0B42
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$01)
    ld   (ix+$03),a
    bit  0,(ix+$02)
    jr   nz,$0B96
    inc  (iy+$00)
    inc  (iy+$02)
    inc  (iy+$04)
    ret
    dec  (iy+$00)
    dec  (iy+$02)
    dec  (iy+$04)
    ret
    xor  a
    ld   ($802D),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ix,$8180
    ld   iy,$8138
    ld   d,$09
    ld   a,(ix+$01)
    and  a
    jr   z,$0BE6
    ld   a,(ix+$02)
    and  $FE
    jr   nz,$0BD6
    ld   a,(ix+$00)
    and  $FE
    add  a,(ix+$02)
    xor  $01
    ld   (ix+$02),a
    jr   $0BDC
    dec  (ix+$02)
    dec  (ix+$02)
    ld   a,(ix+$03)
    and  a
    call z,$0B80
    dec  (ix+$03)
    dec  iy
    dec  iy
    dec  iy
    dec  iy
    dec  iy
    dec  iy
    inc  ix
    inc  ix
    inc  ix
    inc  ix
    dec  d
    jr   nz,$0BBA
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret  p
    inc  bc
    add  a,b
    inc  bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8012)
    and  a
    ret  z
    call $13A0
    ld   a,($8143)
    inc  a
    inc  a
    inc  a
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    scf
    ccf
    add  a,$10
    jr   c,$0C8E
    ld   a,($8140)
    ld   h,a
    ld   a,($8147)
    add  a,$20
    ld   l,a
    call $0968
    ld   a,(hl)
    cp   $10
    jr   z,$0C65
    call $0CC0
    xor  a
    ld   ($8012),a
    call $0220
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   e,$08
    call $13A0
    dec  e
    jr   nz,$0CA2
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   e,$03
    call $0D30
    call $0D60
    call $13A0
    dec  e
    jr   nz,$0CB2
    ret
    rst  $38
    ld   a,$02
    ld   ($8042),a
    ld   ($8065),a
    call $0BA0
    call $0D14
    call $0CA0
    ld   a,$26
    ld   ($8141),a
    ld   a,$27
    ld   ($8145),a
    ld   a,($8147)
    ld   ($8143),a
    ld   a,($8140)
    sub  $10
    ld   ($8140),a
    call $0CA0
    ld   a,($8140)
    add  a,$08
    ld   ($815C),a
    ld   a,$28
    ld   ($815D),a
    ld   a,$11
    ld   ($815E),a
    ld   a,($8143)
    sub  $10
    ld   ($815F),a
    ld   d,$28
    call $0CB0
    ld   a,($815F)
    dec  a
    dec  a
    ld   ($815F),a
    dec  d
    jr   nz,$0D08
    ret
    ld   d,$08
    ld   a,($8143)
    inc  a
    inc  a
    inc  a
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    call $13A0
    dec  d
    jr   nz,$0D19
    ret
    rst  $38
    rst  $38
    ld   a,($8024)
    and  a
    ret  nz
    ld   a,$10
    ld   ($8024),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ret
    ld   a,($8148)
    ld   h,a
    ld   ($814B),a
    add  a,$10
    ld   l,a
    call $0968
    ld   a,(hl)
    scf
    ccf
    sub  $C0
    ret  c
    xor  a
    ld   ($8024),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0D40
    ld   a,($8024)
    and  a
    ret  z
    dec  a
    ld   ($8024),a
    and  $08
    jr   z,$0D79
    ld   a,($814B)
    dec  a
    dec  a
    ld   ($814B),a
    ret
    ld   a,($814B)
    inc  a
    inc  a
    ld   ($814B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $07
    ret  nz
    ld   a,($8023)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   ($8023),a
    ld   hl,$0DB0
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8149),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    dec  b
    ld   b,$07
    ex   af,af'
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   ($8024),a
    ld   ($8025),a
    ld   ($8027),a
    ld   a,($8004)
    and  a
    jr   nz,$0DCD
    ld   a,($8029)
    jr   $0DD0
    ld   a,($802A)
    dec  a
    sla  a
    ld   hl,$0E00
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8148),a
    inc  hl
    ld   a,(hl)
    ld   ($814B),a
    ld   a,$12
    ld   ($814A),a
    ld   a,$05
    ld   ($8149),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ret  po
    jr   c,$0DE3
    jr   c,$0DE5
    jr   c,$0DE7
    jr   c,$0DE9
    jr   c,$0DEB
    jr   c,$0DED
    jr   c,$0DEF
    jr   c,$0DF1
    jr   c,$0DF3
    jr   c,$0DF5
    jr   c,$0DF7
    jr   c,$0DF9
    jr   c,$0DFB
    jr   c,$0DFD
    jr   c,$0DEF
    jr   c,$0E01
    jr   c,$0E03
    jr   c,$0DF5
    jr   c,$0E07
    jr   c,$0E09
    jr   c,$0E0B
    jr   c,$0E0D
    jr   c,$0E0F
    jr   c,$0E11
    jr   c,$0E13
    jr   c,$0E05
    jr   c,$0E37
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    ld   a,($8025)
    and  $03
    jr   nz,$0E4C
    call $0D88
    jr   $0E58
    cp   $01
    jr   nz,$0E55
    call $08E8
    jr   $0E58
    call $0A08
    ld   a,($8025)
    bit  2,a
    ret  z
    call $0D30
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $07
    ret  nz
    ld   a,($8004)
    and  a
    jr   nz,$0E81
    ld   a,($8029)
    jr   $0E84
    ld   a,($802A)
    ld   b,a
    call $0F30
    ld   a,b
    dec  a
    sla  a
    ld   hl,$0EC0
    add  a,l
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    push bc
    pop  hl
    ld   a,($8027)
    inc  a
    cp   $20
    jr   nz,$0E9F
    xor  a
    ld   ($8027),a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8025),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ld   l,b
    rrca
    ld   l,b
    rrca
    ex   af,af'
    rrca
    ex   af,af'
    rrca
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0101
    ld   bc,$0506
    ld   (bc),a
    ld   (bc),a
    ld   (bc),a
    ld   (bc),a
    inc  b
    nop
    nop
    nop
    nop
    nop
    nop
    inc  b
    ld   (bc),a
    ld   (bc),a
    ld   (bc),a
    ld   (bc),a
    dec  b
    ld   b,$01
    ld   bc,$0101
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8148)
    scf
    ccf
    add  a,$08
    jr   nc,$0F44
    xor  a
    ld   ($8025),a
    ld   a,$FF
    ld   ($8148),a
    pop  hl
    ret
    ld   a,($8143)
    scf
    ccf
    sub  $60
    jr   c,$0F4E
    ret
    ld   a,($8140)
    scf
    ccf
    add  a,$70
    ret  nc
    ld   a,$01
    ld   ($8025),a
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    inc  b
    nop
    nop
    nop
    call $0310
    ld   (bc),a
    ld   (bc),a
    ret  po
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $20
    rst  $18
    rst  $38
    call $3BD8
    ld   (bc),a
    inc  bc
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    and  $E6
    rst  $38
    jp   $1BD6
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rrca
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rrca
    rst  $38
    rst  $38
    djnz $0FF2
    djnz $0FF4
    jr   nz,$1002
    ld   bc,$1010
    djnz $0FFB
    jr   $1006
    rla
    jr   $101B
    inc  hl
    inc  de
    rra
    ld   ($1015),hl
    djnz $1008
    djnz $101A
    inc  e
    ld   (bc),a
    djnz $100E
    djnz $0FFF
    ld   a,$50
    ld   ($801B),a
    xor  a
    ld   ($800E),a
    ld   ($800F),a
    ld   ($8012),a
    ld   ($8011),a
    ld   ($8051),a
    ld   ($8060),a
    ld   ($8062),a
    ld   a,$20
    ld   ($8030),a
    call $1B80
    call $1470
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $16D0
    call $3038
    call $2450
    call $03A0
    call $0898
    call $12B8
    call $0AD0
    call $0DB8
    ld   a,$02
    ld   ($813F),a
    call $10E0
    call $1130
    call $1170
    call $13A0
    ld   a,($B800)
    ld   a,($4000)
    jr   $104B
    rst  $38
    ret  p
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$107A
    call $1080
    ret
    call $10A8
    ret
    rst  $38
    rst  $38
    ld   a,($8070)
    and  a
    ret  nz
    ld   a,($8015)
    scf
    ccf
    sub  $15
    ret  c
    ld   a,$01
    ld   ($8070),a
    ld   a,($8032)
    inc  a
    ld   ($8032),a
    call $03A0
    ld   a,$08
    ld   ($8044),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8071)
    and  a
    ret  nz
    ld   a,($8018)
    scf
    ccf
    sub  $15
    ret  c
    ld   a,$01
    ld   ($8071),a
    ld   a,($8033)
    inc  a
    ld   ($8033),a
    call $03A0
    ld   a,$08
    ld   ($8044),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8000)
    inc  a
    cp   $03
    jr   nz,$10E9
    xor  a
    ld   ($8000),a
    sla  a
    sla  a
    call $1390
    call $1700
    ret
    call $1070
    ret
    call $2518
    ret
    rst  $38
    ld   a,($8312)
    inc  a
    ld   ($8312),a
    call $1680
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push af
    push hl
    ld   hl,$8066
    xor  a
    cp   (hl)
    jr   nz,$1121
    inc  hl
    cp   (hl)
    jr   nz,$1121
    inc  hl
    cp   (hl)
    jr   z,$1126
    ld   a,(hl)
    ld   (hl),$00
    add  a,$18
    and  $7F
    nop
    nop
    pop  hl
    pop  af
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8001)
    inc  a
    cp   $06
    jr   nz,$1139
    xor  a
    ld   ($8001),a
    sla  a
    sla  a
    call $1390
    call $3C02
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $1A04
    call $13D0
    call $05D0
    call $0688
    call $0774
    call $0A40
    call $0C60
    call $09C0
    call $0A80
    call $0BB0
    call $1200
    call $1290
    call $1750
    call $0888
    call $0D60
    call $0D40
    call $0E40
    call $0E70
    call $19F0
    call $04BA
    call $2B50
    call $3BA8
    ld   hl,$0020
    call $01E3
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8158)
    cp   $70
    jr   z,$11DB
    cp   $71
    jr   z,$11DB
    cp   $72
    jr   z,$11DB
    cp   $73
    jr   z,$11DB
    cp   $74
    jr   z,$11DB
    cp   $00
    jr   nz,$11DE
    call $3960
    ld   a,($815C)
    cp   $60
    jr   z,$11F9
    cp   $61
    jr   z,$11F9
    cp   $62
    jr   z,$11F9
    cp   $63
    jr   z,$11F9
    cp   $64
    jr   z,$11F9
    cp   $00
    jr   nz,$11FC
    call $3988
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8147)
    ld   b,a
    ld   a,($8002)
    cp   b
    jr   nz,$1228
    add  a,$08
    srl  a
    srl  a
    and  $3E
    ld   h,$81
    ld   l,a
    ld   a,($8003)
    ld   c,a
    ld   a,(hl)
    cp   c
    ret  z
    sub  c
    ld   c,a
    ld   a,($8140)
    add  a,c
    ld   ($8140),a
    ld   ($8144),a
    ld   a,($8147)
    add  a,$08
    srl  a
    srl  a
    and  $3E
    ld   h,$81
    ld   l,a
    ld   a,(hl)
    ld   ($8003),a
    ld   a,($8147)
    ld   ($8002),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    ld   a,($8140)
    sub  (hl)
    ld   h,a
    ld   a,($8147)
    sub  $12
    ld   e,d
    sla  e
    sla  e
    sla  e
    add  a,e
    ld   l,a
    call $0968
    nop
    nop
    nop
    nop
    ld   a,(hl)
    and  $C0
    cp   $C0
    jr   z,$127D
    ld   bc,$FFC0
    add  hl,bc
    ld   a,(hl)
    and  $C0
    cp   $C0
    jr   nz,$1280
    call $0AB8
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ret
    ld   a,($8147)
    add  a,$04
    srl  a
    srl  a
    and  $3E
    ld   l,a
    ld   h,$81
    ld   d,$04
    call $1250
    dec  hl
    dec  hl
    dec  d
    jr   nz,$12A1
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0310
    inc  bc
    nop
    ld   b,b
    ld   b,d
    ld   b,e
    ld   b,d
    ld   b,c
    ld   b,b
    rst  $38
    call $0310
    add  hl,bc
    nop
    cp   $FD
    db   $fd
    db   $fd
    db   $fd
    call m,$CDFF
    djnz $12D6
    ld   e,$00
    cp   $FD
    db   $fd
    db   $fd
    db   $fd
    call m,$CDFF
    or   b
    inc  d
    ld   hl,$92E0
    ld   ix,($8020)
    ld   d,$17
    call $1328
    nop
    nop
    nop
    dec  d
    jr   nz,$12E8
    ld   ($801E),hl
    call $3510
    ld   hl,$0C50
    call $01E3
    jp   $3F10
    ld   e,$04
    push hl
    ld   hl,$8106
    dec  (hl)
    dec  (hl)
    inc  hl
    inc  hl
    push hl
    call $1200
    pop  hl
    ld   a,l
    cp   $3E
    jr   nz,$1306
    call $13A0
    dec  e
    jr   nz,$1303
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $1768
    ld   a,(ix+$00)
    push hl
    add  a,l
    ld   l,a
    inc  ix
    ld   a,(ix+$00)
    cp   $FF
    jr   z,$1343
    and  a
    jr   z,$1351
    ld   (hl),a
    inc  hl
    inc  ix
    jr   $1333
    inc  ix
    pop  hl
    ld   bc,$FFE0
    add  hl,bc
    ld   a,h
    cp   $8F
    ret  nz
    ld   h,$93
    ret
    inc  ix
    pop  hl
    jr   $132B
    rst  $38
    rst  $38
    call $13B8
    nop
    call $14B0
    ld   ix,($8020)
    ld   hl,($801E)
    ld   d,$15
    call $1328
    call $1300
    dec  d
    jr   nz,$1368
    ld   ($8020),ix
    ld   ($801E),hl
    call $19C0
    call $12B8
    xor  a
    ld   ($8002),a
    ld   ($8003),a
    call $1820
    call $0DB8
    call $0408
    ret
    rst  $38
    exx
    pop  hl
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    exx
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   b,$00
    ld   a,$01
    ld   ($B001),a
    ld   a,($B800)
    ld   a,b
    cp   $01
    jr   nz,$13A2
    xor  a
    ld   ($B001),a
    ld   a,($B800)
    ret
    rst  $38
    ld   hl,$8148
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $60
    jr   nz,$13BB
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8006)
    inc  a
    ld   ($8006),a
    cp   $3C
    ret  nz
    xor  a
    ld   ($8006),a
    call $13F0
    call $1410
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    bit  0,a
    ld   hl,$8007
    jr   z,$13FC
    inc  hl
    inc  hl
    ld   a,(hl)
    inc  a
    daa
    ld   (hl),a
    cp   $60
    ret  nz
    ld   (hl),$00
    inc  hl
    ld   a,(hl)
    inc  a
    daa
    ld   (hl),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ret
    ld   a,($8004)
    bit  0,a
    jr   nz,$1436
    xor  a
    ld   hl,$8007
    rrd
    ld   ($9302),a
    rrd
    ld   ($9322),a
    rrd
    inc  hl
    rrd
    ld   ($9362),a
    rrd
    ld   ($9382),a
    rrd
    ret
    xor  a
    ld   hl,$8009
    rrd
    ld   ($9082),a
    rrd
    ld   ($90A2),a
    rrd
    inc  hl
    rrd
    ld   ($90E2),a
    rrd
    ld   ($9102),a
    rrd
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8000
    ld   (hl),$00
    inc  l
    jr   nz,$1463
    inc  h
    ld   a,h
    cp   $83
    jr   nz,$1463
    ret
    rst  $38
    call $1490
    nop
    nop
    nop
    nop
    nop
    inc  hl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld   hl,$9000
    ld   (hl),$10
    inc  l
    jr   nz,$1483
    inc  h
    ld   a,h
    cp   $98
    jr   nz,$1483
    ret
    rst  $38
    ld   hl,$8100
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $80
    jr   nz,$1493
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8000
    ld   (hl),$00
    inc  hl
    ld   a,h
    cp   $84
    jr   nz,$14A3
    jp   $000F
    rst  $38
    rst  $38
    ld   hl,$06E8
    call $01E3
    call $3BC8
    ld   a,$20
    ld   ($8030),a
    ld   a,($8004)
    and  a
    jr   nz,$14C9
    ld   a,($8029)
    jr   $14CC
    ld   a,($802A)
    ld   hl,$1500
    ld   b,$00
    dec  a
    ld   c,a
    sla  c
    add  hl,bc
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   ($8020),bc
    ret
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $03
    ret  nz
    call $3A50
    call $3A88
    call $3AC0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    or   b
    jr   $14B3
    jr   $1545
    ld   hl,$18B0
    djnz $1524
    ld   b,b
    ld   hl,$1E70
    or   b
    jr   $1551
    ld   hl,$1A10
    ld   b,b
    ld   hl,$1E70
    or   b
    jr   $155B
    ld   hl,$18B0
    nop
    dec  e
    ld   (hl),b
    ld   e,$B0
    jr   $1525
    dec  e
    ld   (hl),b
    ld   e,$E0
    rra
    ld   b,b
    ld   hl,$1E70
    ret  po
    rra
    ld   b,b
    ld   hl,$1E70
    nop
    dec  e
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    push bc
    push de
    ld   hl,$8100
    ld   de,$9800
    ld   bc,$0080
    ldir
    pop  de
    pop  bc
    pop  hl
    ret
    rst  $38
    rst  $38
    nop
    nop
    ld   a,($9308)
    cp   $10
    jr   z,$157D
    cp   $8C
    jr   nz,$1578
    ld   a,$9C
    ld   ($9308),a
    jr   $157D
    ld   a,$8C
    ld   ($9308),a
    ld   a,($930C)
    cp   $10
    jr   z,$1594
    cp   $8D
    jr   nz,$158F
    ld   a,$9D
    ld   ($930C),a
    jr   $1594
    ld   a,$8D
    ld   ($930C),a
    ld   a,($9310)
    cp   $10
    jr   z,$15AB
    cp   $8E
    jr   nz,$15A6
    ld   a,$9E
    ld   ($9310),a
    jr   $15AB
    ld   a,$8E
    ld   ($9310),a
    ld   a,($9314)
    cp   $10
    jr   z,$15C2
    cp   $8F
    jr   nz,$15BD
    ld   a,$9F
    ld   ($9314),a
    jr   $15C2
    ld   a,$8F
    ld   ($9314),a
    ret
    rst  $38
    push de
    ld   hl,$1BA8
    call $01E3
    pop  de
    ret
    rst  $38
    rst  $38
    rst  $38
    call $1470
    call $0F88
    call $1660
    ld   a,$8C
    ld   ($9308),a
    call $1660
    call $0310
    ex   af,af'
    djnz $15E9
    nop
    nop
    djnz $160B
    inc  h
    inc  hl
    rst  $38
    call $1660
    ld   a,$8D
    ld   ($930C),a
    call $1660
    call $0310
    inc  c
    djnz $1603
    nop
    nop
    djnz $1623
    inc  h
    inc  hl
    rst  $38
    call $1660
    ld   a,$8E
    ld   ($9310),a
    call $1660
    call $0310
    djnz $1626
    ld   b,$00
    nop
    djnz $163B
    inc  h
    inc  hl
    rst  $38
    call $1660
    ld   a,$8F
    ld   ($9314),a
    call $1660
    call $0310
    inc  d
    djnz $1630
    nop
    nop
    nop
    djnz $1654
    inc  h
    inc  hl
    rst  $38
    call $1660
    call $1660
    call $1660
    call $1660
    ld   hl,$1494
    call $01E3
    ret
    rst  $38
    call $1470
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $2450
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   d,$10
    call $1564
    call $15C4
    ld   e,$04
    push de
    call $2128
    pop  de
    dec  e
    jr   nz,$166A
    dec  d
    jr   nz,$1662
    ret
    rst  $38
    rst  $38
    ret  pe
    call pe,$F0EE
    jp   (hl)
    db   $ed
    rst  $28
    pop  af
    ld   a,($8004)
    and  a
    jr   nz,$168B
    ld   a,($805B)
    jr   $168E
    ld   a,($805C)
    cp   $1F
    jr   nz,$16AB
    ld   a,($8315)
    inc  a
    cp   $03
    jr   nz,$169B
    xor  a
    ld   ($8315),a
    ld   a,($8316)
    inc  a
    cp   $06
    jr   nz,$16A7
    xor  a
    ld   ($8316),a
    ret
    ld   a,($8315)
    inc  a
    cp   $02
    jr   nz,$16B4
    xor  a
    ld   ($8315),a
    ld   a,($8316)
    inc  a
    cp   $04
    jr   nz,$16C0
    xor  a
    ld   ($8316),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0310
    ld   a,(bc)
    nop
    ret  po
    call c,$DEDD
    rst  $18
    rst  $38
    call $0310
    dec  bc
    nop
    pop  hl
    push hl
    push hl
    push hl
    and  $FF
    call $0310
    inc  c
    nop
    pop  hl
    push hl
    push hl
    push hl
    and  $FF
    call $0310
    dec  c
    nop
    jp   po,$E3E3
    ex   (sp),hl
    call po,$C9FF
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8034)
    and  a
    ret  z
    ld   a,($8004)
    and  a
    jr   nz,$1722
    ld   a,($801D)
    and  a
    ret  z
    ld   c,a
    ld   h,$80
    ld   b,$00
    ld   l,$14
    call $17A0
    call $2450
    xor  a
    ld   ($801D),a
    ret
    ld   a,($801D)
    and  a
    ret  z
    ld   c,a
    ld   h,$80
    ld   b,$00
    ld   l,$17
    call $17A0
    call $2450
    xor  a
    ld   ($801D),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    scf
    ccf
    ld   a,($8143)
    add  a,$48
    jr   c,$175C
    sub  $78
    ret  nc
    ld   a,($8140)
    scf
    ccf
    sub  $E0
    ret  c
    call $1778
    ret
    push hl
    ld   a,$03
    add  a,l
    ld   l,a
    ld   e,$1C
    ld   (hl),$10
    inc  hl
    dec  e
    jr   nz,$176F
    pop  hl
    ret
    rst  $38
    call $17C0
    ld   a,($8004)
    and  a
    jr   nz,$178A
    ld   a,($8029)
    inc  a
    ld   ($8029),a
    jr   $1791
    ld   a,($802A)
    inc  a
    ld   ($802A),a
    call $27E0
    call $1358
    call $0AD0
    ld   a,$02
    jp   $17B4
    ret
    ld   a,(hl)
    scf
    ccf
    add  a,c
    daa
    ld   (hl),a
    inc  l
    ld   a,(hl)
    adc  a,b
    daa
    ld   (hl),a
    inc  l
    ld   a,(hl)
    adc  a,$00
    daa
    ld   (hl),a
    ret
    rst  $38
    rst  $38
    ld   ($813F),a
    xor  a
    ld   ($800F),a
    ld   ($8005),a
    ret
    rst  $38
    xor  a
    ld   ($802D),a
    ld   a,($814C)
    ld   ($8150),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0310
    ld   a,(bc)
    nop
    cp   b
    or   h
    or   l
    or   (hl)
    or   a
    rst  $38
    call $0310
    dec  bc
    nop
    cp   c
    rst  $38
    call $0310
    dec  bc
    inc  b
    cp   (hl)
    rst  $38
    call $0310
    inc  c
    nop
    cp   c
    rst  $38
    call $0310
    inc  c
    inc  b
    cp   (hl)
    rst  $38
    call $0310
    dec  c
    nop
    cp   d
    cp   e
    cp   e
    cp   e
    cp   h
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$0C
    ld   ($8141),a
    inc  a
    ld   ($8145),a
    ld   a,$11
    ld   ($8142),a
    ld   ($8146),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$182B
    ld   a,($8029)
    jr   $182E
    ld   a,($802A)
    ld   hl,$1850
    dec  a
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8140),a
    ld   ($8144),a
    inc  hl
    ld   a,(hl)
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    call $1808
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   nz,$1822
    jr   nz,$1824
    jr   nz,$1826
    jr   nz,$1828
    jr   nz,$182A
    jr   nz,$1882
    jr   nz,$1884
    jr   nz,$1830
    jr   nz,$1832
    jr   nz,$1834
    jr   nz,$188C
    jr   nz,$188E
    jr   nz,$183A
    jr   nz,$183C
    jr   nz,$183E
    jr   nz,$1840
    jr   nz,$1898
    jr   nz,$1844
    jr   nz,$1846
    jr   nz,$189E
    jr   nz,$184A
    jr   nz,$18A2
    jr   nz,$18A4
    jr   nz,$1850
    jr   nz,$18A8
    jr   nz,$18AA
    jr   nz,$1856
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8100
    ld   (hl),$00
    inc  hl
    inc  hl
    ld   a,l
    cp   $40
    jr   nz,$189B
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    cp   $00
    ld   e,$39
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    ld   b,iyl
    ld   b,c
    nop
    dec  de
    cp   $3B
    ld   b,l
    ld   b,l
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    db   $fd
    ld   b,d
    nop
    dec  de
    db   $fd
    ccf
    ccf
    dec  sp
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    call m,$0041
    dec  de
    db   $fd
    dec  sp
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    dec  de
    db   $fd
    ccf
    dec  sp
    dec  sp
    rst  $38
    inc  bc
    ccf
    nop
    dec  de
    db   $fd
    ccf
    ccf
    dec  sp
    rst  $38
    inc  bc
    ld   a,$43
    nop
    dec  de
    db   $fd
    dec  sp
    ccf
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   b,b
    nop
    dec  de
    call m,$3B47
    ld   b,a
    rst  $38
    inc  bc
    dec  sp
    ld   b,d
    nop
    dec  e
    dec  a
    ccf
    rst  $38
    inc  bc
    dec  sp
    ld   b,b
    nop
    dec  e
    inc  a
    ld   a,$FF
    inc  bc
    ccf
    ld   b,e
    nop
    dec  e
    ld   a,($FF3F)
    inc  bc
    ld   a,$41
    nop
    dec  de
    cp   $10
    dec  a
    ld   a,$FF
    inc  bc
    dec  sp
    ld   b,b
    nop
    dec  de
    db   $fd
    ld   b,a
    ld   a,$47
    rst  $38
    inc  bc
    ccf
    ld   b,d
    nop
    dec  de
    db   $fd
    dec  sp
    dec  sp
    dec  sp
    rst  $38
    inc  bc
    ld   a,$00
    dec  de
    db   $fd
    ld   a,$3F
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    cp   $00
    dec  de
    db   $fd
    ccf
    dec  sp
    ld   a,$FF
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    db   $fd
    ld   b,a
    ld   b,c
    nop
    dec  de
    db   $fd
    dec  sp
    ld   a,$3E
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    dec  de
    call m,$3B3E
    dec  sp
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FE
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FC
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F0
    ld   ($8140),a
    ld   ($8144),a
    ld   a,$26
    ld   ($8147),a
    ld   a,$16
    ld   ($8143),a
    ld   a,$17
    ld   ($8141),a
    ld   ($8145),a
    xor  a
    ld   ($8142),a
    ld   ($8146),a
    jp   $1778
    ld   hl,$9000
    inc  hl
    inc  hl
    inc  hl
    ld   d,$1D
    ld   (hl),$10
    inc  hl
    dec  d
    jr   nz,$19C8
    ld   a,h
    cp   $94
    jr   nz,$19C3
    nop
    nop
    nop
    nop
    nop
    ld   hl,$8100
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $80
    jr   nz,$19DB
    call $13A0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8147)
    scf
    ccf
    add  a,$18
    ret  nc
    call $0CC0
    xor  a
    ld   ($8012),a
    call $0220
    ret
    rst  $38
    ld   a,($8140)
    scf
    ccf
    sub  $10
    ret  nc
    jp   $1B48
    ret
    inc  bc
    ccf
    nop
    dec  de
    cp   $30
    ld   sp,$FF3C
    inc  bc
    ccf
    ld   a,$3B
    ld   b,b
    nop
    dec  de
    call m,$3A10
    ccf
    rst  $38
    inc  bc
    dec  sp
    dec  sp
    ld   a,$3F
    ld   b,d
    nop
    dec  de
    ld   (hl),$10
    dec  a
    ccf
    rst  $38
    inc  bc
    ccf
    dec  sp
    ccf
    ld   a,$3B
    ld   b,c
    nop
    jr   $1A3A
    jr   nc,$1A6F
    djnz $1A7C
    ccf
    ld   a,$FF
    inc  bc
    ccf
    dec  sp
    ld   a,$3B
    ld   a,$3F
    ld   b,b
    nop
    jr   $1A4A
    nop
    dec  e
    add  hl,sp
    ld   a,$FF
    inc  bc
    dec  sp
    ccf
    dec  sp
    ld   a,$3B
    ld   b,c
    nop
    jr   $1A93
    djnz $1A6F
    dec  a
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    ccf
    dec  sp
    dec  sp
    dec  sp
    nop
    dec  d
    cp   $30
    ld   sp,$1030
    ld   a,($3B3E)
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   a,$3E
    dec  sp
    nop
    dec  d
    call m,$1A00
    inc  a
    ccf
    ld   a,$3E
    ccf
    rst  $38
    inc  bc
    dec  sp
    nop
    dec  d
    scf
    djnz $1A9C
    djnz $1AC7
    ld   a,$3E
    ccf
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   a,$42
    nop
    ld   (de),a
    cp   $31
    jr   nc,$1ACE
    djnz $1AAF
    djnz $1ADB
    ccf
    ld   a,$3B
    ld   a,$3F
    rst  $38
    inc  bc
    ccf
    ld   b,c
    nop
    ld   (de),a
    call m,$1A00
    jr   c,$1AEF
    dec  sp
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   a,$40
    nop
    ld   (de),a
    ld   (hl),$00
    dec  de
    add  hl,sp
    ccf
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    rrca
    cp   $30
    ld   sp,$1B00
    inc  a
    ccf
    ld   a,$3E
    rst  $38
    inc  bc
    ld   b,e
    nop
    rrca
    call m,$1C00
    ld   a,$3E
    dec  sp
    rst  $38
    inc  bc
    ld   b,c
    nop
    rrca
    scf
    nop
    dec  e
    ld   a,($FF3B)
    inc  bc
    ld   b,d
    nop
    inc  c
    cp   $34
    dec  (hl)
    ld   (hl),$00
    ld   e,$3C
    rst  $38
    inc  bc
    ld   b,c
    nop
    inc  c
    call m,$1E00
    add  hl,sp
    rst  $38
    inc  bc
    ld   b,b
    nop
    inc  c
    ld   (hl),$00
    ld   e,$3E
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    cp   $00
    ld   e,$FE
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    call m,$1E00
    call m,$2AFF
    jr   nz,$1AB3
    ld   bc,$0014
    add  hl,bc
    ld   ($8020),hl
    ld   hl,($801E)
    ld   bc,$0014
    add  hl,bc
    ld   ($801E),hl
    ret
    rst  $38
    rst  $38
    rst  $38
    call $0CC0
    call $0220
    ret
    rst  $38
    ld   a,$03
    ld   ($8080),a
    call $1700
    call $24E0
    ld   a,($8004)
    and  a
    jr   nz,$1B66
    ld   hl,$8029
    jr   $1B69
    ld   hl,$802A
    ld   a,(hl)
    inc  a
    daa
    ld   (hl),a
    call $2CB0
    jp   $1000
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8031)
    and  a
    jr   nz,$1B91
    ld   a,($8022)
    and  a
    jr   z,$1B8D
    ret
    inc  a
    ld   ($8022),a
    call $1700
    call $1470
    nop
    nop
    call $03A0
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $2450
    ld   a,($8004)
    and  a
    jr   nz,$1BBD
    call $0310
    djnz $1BBC
    jr   nz,$1BD0
    ld   de,$1529
    ld   ($0110),hl
    rst  $38
    jr   $1BCB
    call $0310
    djnz $1BCC
    jr   nz,$1BE0
    ld   de,$1529
    ld   ($0210),hl
    rst  $38
    call $1C41
    ret
    ld   a,$08
    ld   ($8086),a
    ret
    rst  $38
    call $0310
    dec  de
    ld   (bc),a
    jp   po,$E3E3
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    ex   (sp),hl
    call po,$C3FF
    ret  c
    inc  e
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   e,$18
    call $13A0
    dec  e
    jr   nz,$1C02
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8140)
    add  a,$08
    ld   ($814C),a
    add  a,$08
    ld   ($8150),a
    ld   a,($8143)
    ld   ($814F),a
    add  a,$10
    ld   ($8153),a
    ld   a,$AC
    ld   ($814D),a
    ld   a,$B0
    ld   ($8151),a
    call $1C00
    ld   a,$AD
    ld   ($814D),a
    call $1C00
    call $0A33
    ret
    ld   a,$0F
    ld   ($8044),a
    xor  a
    ld   ($8042),a
    call $24E0
    ret
    rst  $38
    rst  $38
    ld   a,($8140)
    sub  $08
    ld   ($814C),a
    sub  $08
    ld   ($8150),a
    ld   a,($8143)
    ld   ($814F),a
    add  a,$10
    ld   ($8153),a
    ld   a,$2C
    ld   ($814D),a
    ld   a,$30
    ld   ($8151),a
    call $1C00
    ld   a,$2D
    ld   ($814D),a
    call $1C00
    call $0A33
    ret
    jp   (hl)
    djnz $1CC4
    ld   bc,$1C81
    push bc
    push hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8140)
    ld   b,a
    ld   a,($814C)
    scf
    ccf
    sub  b
    jr   c,$1CA0
    call $1C10
    ret
    call $1C50
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($814C)
    ld   b,a
    ld   a,($8140)
    sub  b
    scf
    ccf
    sub  $18
    jr   c,$1CC1
    add  a,$30
    ret  nc
    ld   a,($814F)
    ld   b,a
    ld   a,($8143)
    sub  b
    scf
    ccf
    sub  $28
    jr   c,$1CD2
    add  a,$50
    ret  nc
    call $1C90
    ret
    rst  $38
    rst  $38
    call $3BD8
    add  hl,de
    inc  bc
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    pop  hl
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    dec  sp
    ld   a,$3F
    nop
    rrca
    cp   $00
    dec  de
    cp   $10
    dec  a
    ld   a,$FF
    inc  bc
    ld   a,$3E
    ccf
    ld   a,$00
    rrca
    db   $fd
    nop
    dec  de
    db   $fd
    djnz $1D57
    ccf
    rst  $38
    inc  bc
    ld   a,$3B
    dec  sp
    ccf
    dec  sp
    nop
    rrca
    db   $fd
    nop
    dec  de
    db   $fd
    djnz $1D65
    dec  sp
    rst  $38
    inc  bc
    dec  sp
    ld   a,$3B
    ccf
    ccf
    ld   b,c
    nop
    rrca
    db   $fd
    nop
    dec  de
    db   $fd
    djnz $1D78
    dec  sp
    rst  $38
    inc  bc
    dec  sp
    ld   a,$3F
    dec  sp
    nop
    rrca
    call m,$1900
    dec  (hl)
    inc  (hl)
    inc  a
    djnz $1D86
    ld   a,$FF
    inc  bc
    ccf
    ld   a,$3B
    ld   a,$00
    dec  c
    ld   (hl),$31
    nop
    jr   $1D92
    djnz $1D6D
    djnz $1D9C
    ccf
    ld   a,$FF
    inc  bc
    dec  sp
    dec  sp
    ld   b,b
    nop
    inc  c
    inc  sp
    nop
    ld   (de),a
    cp   $00
    jr   $1D6D
    djnz $1D81
    inc  a
    ld   a,$3F
    ccf
    rst  $38
    inc  bc
    ld   a,$40
    nop
    inc  c
    cp   $00
    ld   (de),a
    db   $fd
    nop
    jr   $1D7F
    djnz $1D94
    dec  a
    dec  sp
    ccf
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   b,c
    nop
    inc  c
    db   $fd
    nop
    ld   (de),a
    db   $fd
    nop
    jr   $1D92
    djnz $1DD1
    ccf
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    ccf
    ld   b,b
    nop
    inc  c
    db   $fd
    nop
    ld   (de),a
    db   $fd
    nop
    jr   $1DA5
    djnz $1DE2
    ld   a,$3F
    ld   a,$3B
    rst  $38
    inc  bc
    ld   b,b
    nop
    inc  c
    db   $fd
    nop
    ld   (de),a
    db   $fd
    nop
    jr   $1DB7
    djnz $1DCC
    ld   a,($3B3B)
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    inc  c
    call m,$1200
    call m,$1800
    call m,$1010
    ld   a,($3E3F)
    dec  sp
    rst  $38
    inc  bc
    ld   b,e
    nop
    ld   a,(bc)
    inc  sp
    ld   sp,$1700
    ld   (hl),$10
    djnz $1E1B
    ccf
    dec  sp
    dec  sp
    ld   a,$FF
    inc  bc
    ld   b,c
    nop
    ld   a,(bc)
    ld   (hl),$00
    ld   d,$36
    djnz $1DFE
    dec  a
    dec  sp
    ccf
    ld   a,$3B
    dec  sp
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    cp   $00
    dec  d
    cp   $10
    djnz $1E3A
    ld   a,$3F
    dec  sp
    ccf
    dec  sp
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    dec  d
    db   $fd
    djnz $1E21
    djnz $1E23
    ld   a,$3B
    ccf
    ccf
    ld   a,$FF
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    dec  d
    db   $fd
    djnz $1E33
    djnz $1E35
    djnz $1E61
    ccf
    dec  sp
    ld   a,$FF
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    db   $fd
    nop
    dec  d
    call m,$1E00
    db   $fd
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FE
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    call m,$1E00
    call m,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ld   b,d
    nop
    ld   a,(bc)
    jr   nc,$1EA8
    nop
    dec  e
    inc  a
    ccf
    rst  $38
    inc  bc
    ld   b,e
    nop
    inc  c
    cp   $00
    inc  e
    ld   a,($3F3B)
    rst  $38
    inc  bc
    ld   b,c
    nop
    inc  c
    call m,$1900
    jr   c,$1ECD
    dec  sp
    ccf
    ccf
    dec  sp
    rst  $38
    inc  bc
    dec  sp
    ld   b,b
    nop
    dec  c
    ld   sp,$0032
    ld   d,$3A
    ccf
    ld   a,$3B
    dec  sp
    ld   a,$3F
    dec  sp
    ccf
    rst  $38
    inc  bc
    dec  sp
    nop
    rrca
    cp   $00
    dec  d
    add  hl,sp
    ld   a,$3E
    ccf
    dec  sp
    ccf
    ccf
    dec  sp
    ld   a,$3F
    rst  $38
    inc  bc
    ccf
    ld   b,b
    nop
    rrca
    call m,$1400
    jr   c,$1F02
    dec  sp
    ld   a,$3B
    ccf
    ld   a,$3B
    ccf
    ld   a,$3E
    rst  $38
    inc  bc
    dec  sp
    ld   a,$41
    nop
    djnz $1F04
    ld   ($1400),a
    ld   a,($3F3B)
    ld   a,$3F
    ccf
    dec  sp
    dec  sp
    ld   a,$3F
    ld   a,$FF
    inc  bc
    ld   a,$3F
    dec  sp
    dec  sp
    ld   b,b
    nop
    ld   (de),a
    cp   $3F
    ccf
    dec  sp
    ld   a,$3F
    ld   a,$3B
    dec  sp
    ld   a,$3F
    ld   a,$3B
    rst  $38
    inc  bc
    dec  sp
    ccf
    ccf
    ld   a,$40
    nop
    ld   (de),a
    db   $fd
    dec  sp
    ccf
    ld   a,$3B
    ld   a,$3F
    ccf
    dec  sp
    dec  sp
    ccf
    ld   a,$3E
    rst  $38
    inc  bc
    ccf
    ccf
    ld   a,$3B
    dec  sp
    nop
    ld   d,$39
    dec  sp
    ccf
    ld   a,$3F
    ccf
    dec  sp
    dec  sp
    ld   a,$FF
    inc  bc
    ccf
    dec  sp
    dec  sp
    ld   a,$40
    nop
    dec  d
    cp   $3B
    ld   a,$3F
    dec  sp
    ld   a,$3F
    dec  sp
    ld   a,$3F
    rst  $38
    inc  bc
    dec  sp
    ccf
    ld   a,$3E
    dec  sp
    ld   b,c
    nop
    dec  d
    call m,$3B3E
    ccf
    ld   a,$3B
    ccf
    ld   a,$3B
    ccf
    rst  $38
    inc  bc
    ccf
    ld   a,$3E
    ccf
    ccf
    nop
    add  hl,de
    ld   a,($3F3E)
    dec  sp
    ccf
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   a,$3F
    dec  sp
    ld   b,b
    nop
    jr   $1F5E
    dec  sp
    ld   a,$3F
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    ccf
    ld   a,$3E
    dec  sp
    ccf
    ld   b,b
    nop
    jr   $1F6D
    ld   a,$3B
    ld   a,$3B
    ld   a,$3F
    rst  $38
    inc  bc
    ld   a,$3B
    dec  sp
    ld   b,c
    nop
    inc  e
    jr   c,$1FC0
    ccf
    rst  $38
    inc  bc
    ccf
    ld   a,$42
    nop
    dec  de
    cp   $3E
    dec  sp
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   b,b
    nop
    dec  de
    call m,$3E3B
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    cp   $00
    ld   e,$FE
    rst  $38
    inc  bc
    ld   b,e
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    call m,$1E00
    call m,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ld   b,d
    nop
    dec  e
    dec  a
    dec  sp
    rst  $38
    inc  bc
    ld   b,c
    nop
    rrca
    cp   $00
    dec  de
    cp   $3F
    ld   a,$3B
    rst  $38
    inc  bc
    ld   b,b
    nop
    rrca
    db   $fd
    nop
    dec  de
    db   $fd
    dec  sp
    ld   a,$3F
    rst  $38
    inc  bc
    ccf
    ld   b,e
    nop
    rrca
    call m,$1B00
    call m,$3E3F
    dec  sp
    rst  $38
    inc  bc
    ld   a,$3B
    ld   b,c
    nop
    ld   c,$36
    djnz $2047
    nop
    dec  de
    jr   c,$2054
    ccf
    ld   a,$FF
    inc  bc
    dec  sp
    ld   a,$3E
    ld   b,b
    nop
    dec  c
    ld   (hl),$10
    djnz $2037
    ld   ($1A00),a
    dec  a
    dec  sp
    dec  sp
    ccf
    ccf
    rst  $38
    inc  bc
    dec  sp
    ld   a,$3E
    ld   b,b
    nop
    inc  c
    cp   $00
    ld   (de),a
    cp   $00
    jr   $203C
    ld   a,$3F
    dec  sp
    dec  sp
    ld   a,$3F
    rst  $38
    inc  bc
    ccf
    ld   a,$3B
    nop
    inc  c
    db   $fd
    nop
    ld   (de),a
    db   $fd
    nop
    jr   $204F
    ccf
    ld   a,$3B
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    ld   a,$3B
    ld   b,c
    nop
    inc  c
    call m,$1200
    call m,$1800
    call m,$3F3E
    ld   a,$3F
    dec  sp
    ccf
    rst  $38
    inc  bc
    ccf
    ld   b,d
    nop
    add  hl,de
    inc  a
    ccf
    ld   a,$3B
    dec  sp
    ccf
    rst  $38
    inc  bc
    dec  sp
    ld   b,e
    nop
    add  hl,de
    ld   a,($3F3E)
    ld   a,$3F
    ld   a,$FF
    inc  bc
    dec  sp
    ld   b,d
    nop
    add  hl,de
    inc  a
    dec  sp
    dec  sp
    ld   a,$3B
    dec  sp
    rst  $38
    inc  bc
    ccf
    ccf
    ld   b,c
    nop
    add  hl,de
    inc  a
    ccf
    ld   a,$3F
    dec  sp
    ld   a,$FF
    inc  bc
    ld   a,$43
    nop
    ld   a,(de)
    ld   a,$3F
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    dec  sp
    dec  sp
    ld   b,b
    nop
    inc  c
    cp   $00
    ld   (de),a
    cp   $00
    jr   $20B4
    ld   a,$3F
    dec  sp
    dec  sp
    ccf
    ld   a,$FF
    inc  bc
    ccf
    nop
    inc  c
    db   $fd
    nop
    ld   (de),a
    db   $fd
    nop
    jr   $20C5
    ld   a,$3E
    ccf
    dec  sp
    ccf
    dec  sp
    rst  $38
    inc  bc
    ld   b,b
    nop
    inc  c
    call m,$1200
    call m,$1800
    call m,$3E3F
    dec  sp
    dec  sp
    ld   a,$3F
    rst  $38
    inc  bc
    ld   b,d
    nop
    dec  bc
    ld   (hl),$00
    inc  de
    ld   ($1900),a
    jr   nc,$211E
    ld   sp,$3030
    cp   $FF
    inc  bc
    ld   b,e
    nop
    ld   a,(bc)
    ld   (hl),$00
    inc  d
    ld   ($1E00),a
    db   $fd
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    cp   $00
    dec  d
    cp   $00
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    dec  d
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    call m,$1500
    call m,$1E00
    call m,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $13A0
    ld   a,($8303)
    and  a
    ret  z
    call $1490
    jp   $00A4
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ld   b,b
    nop
    ld   a,(bc)
    ld   c,b
    nop
    ld   e,$39
    rst  $38
    inc  bc
    ld   b,c
    nop
    dec  bc
    ld   c,b
    nop
    dec  e
    ld   a,($FF3B)
    inc  bc
    ccf
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    jp   m,$1B00
    cp   $3E
    ccf
    ld   a,$FF
    inc  bc
    ld   a,$40
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ret  m
    nop
    dec  de
    db   $fd
    dec  sp
    ccf
    ld   a,$FF
    inc  bc
    ld   b,d
    nop
    dec  c
    ld   c,b
    nop
    dec  de
    call m,$3B3A
    dec  sp
    rst  $38
    inc  bc
    dec  sp
    dec  sp
    ld   b,c
    nop
    ld   c,$48
    nop
    dec  de
    inc  a
    dec  sp
    ld   a,$3E
    rst  $38
    inc  bc
    dec  sp
    ld   a,$00
    rrca
    ld   c,b
    nop
    dec  de
    ld   a,($3F3E)
    ccf
    rst  $38
    inc  bc
    ccf
    ccf
    ld   b,b
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    jp   m,$1800
    cp   $10
    djnz $21EB
    dec  sp
    ccf
    ccf
    rst  $38
    inc  bc
    ld   a,$3B
    dec  sp
    ld   b,c
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ret  m
    nop
    jr   $21C4
    ccf
    ld   a,$3B
    ccf
    ld   a,$3B
    rst  $38
    inc  bc
    ccf
    dec  sp
    ld   a,$40
    nop
    rrca
    ld   c,d
    nop
    jr   $21D5
    ccf
    ccf
    ld   a,$3E
    dec  sp
    ld   a,$FF
    inc  bc
    dec  sp
    ld   a,$43
    nop
    rrca
    ld   c,d
    nop
    dec  de
    inc  a
    ld   a,$3F
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   b,c
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    jp   m,$1B00
    inc  a
    dec  sp
    ccf
    ld   a,$FF
    inc  bc
    ld   b,b
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ret  m
    nop
    inc  e
    add  hl,sp
    ld   a,$3F
    rst  $38
    inc  bc
    ld   b,d
    nop
    rrca
    ld   c,c
    nop
    inc  e
    inc  a
    dec  sp
    dec  sp
    rst  $38
    inc  bc
    ld   b,c
    nop
    ld   c,$49
    nop
    dec  de
    cp   $3F
    ld   a,$3B
    rst  $38
    inc  bc
    ld   b,e
    nop
    dec  c
    ld   c,c
    nop
    dec  de
    call m,$3F3E
    dec  sp
    rst  $38
    inc  bc
    ccf
    ld   b,c
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    ld   b,(hl)
    jp   m,$1C00
    add  hl,sp
    ld   a,$3B
    rst  $38
    inc  bc
    ld   b,b
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ld   b,h
    ret  m
    nop
    dec  e
    inc  a
    ccf
    rst  $38
    inc  bc
    ld   b,d
    nop
    dec  bc
    ld   c,c
    nop
    ld   e,$3C
    rst  $38
    inc  bc
    ld   b,e
    nop
    ld   a,(bc)
    ld   c,c
    nop
    ld   e,$FE
    rst  $38
    inc  bc
    ld   b,d
    nop
    add  hl,bc
    cp   $00
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,c
    nop
    add  hl,bc
    db   $fd
    nop
    ld   e,$FD
    rst  $38
    inc  bc
    ld   b,b
    nop
    add  hl,bc
    call m,$1E00
    call m,$3EFF
    rlca
    out  ($00),a
    ld   a,$38
    out  ($01),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(hl)
    ld   ($814C),a
    inc  hl
    ld   a,(hl)
    ld   ($814F),a
    inc  hl
    ld   a,$12
    ld   ($814E),a
    ld   ($8152),a
    ld   a,(hl)
    and  $FC
    jr   z,$22D4
    and  $F8
    jr   nz,$22C2
    ld   a,($814C)
    sub  $08
    jr   $22C7
    ld   a,($814C)
    add  a,$08
    ld   ($8150),a
    ld   a,($814F)
    add  a,$10
    ld   ($8153),a
    jr   $22D8
    xor  a
    ld   ($8150),a
    ld   a,(hl)
    sla  a
    ld   bc,$2400
    add  a,c
    ld   c,a
    ld   a,(bc)
    ld   ($814D),a
    inc  bc
    ld   a,(bc)
    ld   ($8151),a
    call $2920
    jp   $23E0
    rst  $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld   a,($802D)
    inc  a
    ld   ($802D),a
    ld   e,a
    scf
    ccf
    sub  $0B
    ret  c
    ld   a,($8004)
    and  a
    jr   nz,$2313
    ld   a,($8029)
    jr   $2316
    ld   a,($802A)
    dec  a
    ld   hl,$2330
    sla  a
    add  a,l
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   a,e
    sub  $0B
    sla  a
    sla  a
    add  a,c
    ld   l,a
    ld   h,b
    call $22A0
    ret
    rst  $38
    ld   a,b
    inc  hl
    ld   a,b
    inc  hl
    nop
    ld   h,$78
    inc  hl
    add  a,b
    ld   h,$00
    daa
    ld   (hl),b
    daa
    ld   a,b
    inc  hl
    nop
    ld   h,$80
    ld   h,$00
    daa
    ld   (hl),b
    daa
    ld   a,b
    inc  hl
    nop
    ld   h,$78
    inc  hl
    nop
    jr   z,$23C1
    daa
    ld   a,b
    inc  hl
    nop
    jr   z,$23C7
    daa
    nop
    ld   hl,($2700)
    ld   (hl),b
    daa
    nop
    ld   hl,($2700)
    ld   (hl),b
    daa
    nop
    jr   z,$2367
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   $235A
    nop
    nop
    inc  e
    ret  po
    ld   bc,$2000
    ret  po
    ld   (bc),a
    nop
    jr   z,$2366
    inc  bc
    nop
    jr   nc,$236A
    ld   (bc),a
    nop
    jr   c,$236E
    ld   bc,$4800
    ret  z
    nop
    nop
    ld   d,b
    ret  z
    ld   bc,$5800
    ret  z
    ld   (bc),a
    nop
    ld   h,b
    ret  z
    inc  bc
    nop
    ld   l,b
    ret  z
    ld   (bc),a
    nop
    ld   (hl),b
    ret  z
    inc  bc
    nop
    add  a,b
    ret  z
    rlca
    nop
    adc  a,b
    ret  z
    dec  b
    nop
    sbc  a,b
    ret  z
    inc  bc
    nop
    and  b
    ret  z
    ld   (bc),a
    nop
    xor  b
    ret  z
    inc  bc
    nop
    or   b
    ret  z
    ld   (bc),a
    nop
    cp   b
    ret  z
    inc  bc
    nop
    ret  nz
    ret  z
    ld   bc,$D000
    ret  nc
    rlca
    nop
    ret  c
    ret  nc
    dec  b
    nop
    ret  po
    ret  nc
    ld   b,$00
    ret  pe
    ret  nc
    dec  b
    nop
    ret  p
    ret  nc
    inc  b
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($814C)
    cp   $18
    ret  nz
    ld   a,$07
    ld   ($8044),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    cpl
    nop
    ld   l,$00
    dec  l
    nop
    inc  l
    nop
    dec  l
    jr   nc,$2437
    ld   sp,$322D
    inc  l
    inc  sp
    xor  l
    or   b
    xor  h
    or   c
    xor  l
    or   d
    xor  h
    or   e
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($A800)
    ld   ($83F1),a
    ld   a,($B000)
    ld   ($83F2),a
    call $3640
    ret
    ld   b,$00
    ld   a,($B800)
    dec  b
    jr   nz,$2432
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   hl,$8014
    rrd
    ld   ($9301),a
    rrd
    ld   ($9321),a
    rrd
    inc  l
    rrd
    ld   ($9341),a
    rrd
    ld   ($9361),a
    rrd
    inc  l
    rrd
    ld   ($9381),a
    rrd
    rrd
    xor  a
    ld   ($92E1),a
    ld   hl,$8017
    rrd
    ld   ($9081),a
    rrd
    ld   ($90A1),a
    rrd
    inc  l
    rrd
    ld   ($90C1),a
    rrd
    ld   ($90E1),a
    rrd
    inc  l
    rrd
    ld   ($9101),a
    rrd
    rrd
    xor  a
    ld   ($9061),a
    ld   hl,$8300
    rrd
    ld   ($91C1),a
    rrd
    ld   ($91E1),a
    rrd
    inc  l
    rrd
    ld   ($9201),a
    rrd
    ld   ($9221),a
    rrd
    inc  l
    rrd
    ld   ($9241),a
    rrd
    rrd
    xor  a
    ld   ($91A1),a
    call $3038
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   h,$60
    call $13A0
    inc  h
    jr   nz,$24E2
    ret
    rst  $38
    rst  $38
    rst  $38
    push bc
    ld   b,$08
    push bc
    call $13A0
    pop  bc
    djnz $24EF
    pop  bc
    ld   a,$0A
    ld   ($8044),a
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8300
    ld   (hl),$00
    inc  l
    ld   a,l
    cp   $E1
    jr   nz,$2503
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($802D)
    and  $F8
    ret  z
    call $1CB0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   de,$0016
    ld   c,$20
    ld   hl,$9010
    ld   b,$0A
    ld   (hl),$D4
    inc  hl
    dec  b
    jr   nz,$2542
    add  hl,de
    dec  c
    ret  z
    jr   $2540
    rst  $38
    rst  $38
    rst  $38
    call $1470
    call $13A0
    ld   hl,$9040
    ld   e,$79
    call $2588
    ld   hl,$93A0
    call $2588
    ld   hl,$9000
    call $2598
    ld   hl,$901F
    call $2598
    ld   d,$10
    ld   hl,$9061
    call $25A8
    call $25C0
    call $25D0
    call $25E8
    dec  d
    jr   nz,$2575
    call $1480
    ret
    ld   (hl),e
    inc  l
    ld   a,l
    and  $1F
    ret  z
    jr   $2588
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   (hl),e
    ld   bc,$0020
    add  hl,bc
    ld   a,h
    cp   $94
    ret  z
    jr   $2598
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $13A0
    ld   (hl),e
    ld   bc,$0020
    add  hl,bc
    ld   a,(hl)
    cp   e
    jr   nz,$25AB
    sbc  hl,bc
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $13A0
    ld   (hl),e
    inc  hl
    ld   a,(hl)
    cp   e
    jr   nz,$25C3
    dec  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $13A0
    ld   (hl),e
    ld   bc,$0020
    sbc  hl,bc
    ld   a,(hl)
    cp   e
    jr   nz,$25D0
    add  hl,bc
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $13A0
    ld   (hl),e
    dec  hl
    ld   a,(hl)
    cp   e
    jr   nz,$25EB
    inc  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   $25E2
    nop
    nop
    inc  e
    ret  po
    ld   bc,$2000
    ret  po
    ld   (bc),a
    nop
    jr   z,$25EE
    inc  bc
    nop
    jr   nc,$25F2
    ld   (bc),a
    nop
    jr   c,$25F6
    ld   bc,$4000
    ret  c
    ld   (bc),a
    nop
    ld   c,b
    ret  nc
    inc  b
    nop
    ld   d,b
    ret  z
    nop
    nop
    ld   e,b
    ret  z
    ld   bc,$6000
    ret  z
    ld   (bc),a
    nop
    ld   l,b
    call z,$0003
    ld   (hl),b
    call z,$0002
    ld   (hl),b
    ret  nz
    inc  b
    nop
    add  a,b
    or   b
    nop
    nop
    adc  a,b
    or   b
    ld   bc,$9000
    or   b
    rlca
    nop
    sbc  a,b
    cp   b
    inc  b
    nop
    and  b
    ret  nz
    dec  b
    nop
    xor  b
    cp   b
    ld   b,$00
    or   b
    cp   b
    dec  b
    nop
    cp   b
    cp   b
    inc  b
    nop
    ret  nz
    ret  z
    rlca
    nop
    ret  z
    ret  z
    dec  b
    nop
    ret  nc
    ret  nc
    ld   b,$00
    ret  c
    ret  nc
    inc  b
    nop
    ret  po
    ret  nc
    dec  b
    nop
    ret  pe
    ret  nc
    ld   b,$00
    ret  p
    ret  nc
    dec  b
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   $2662
    nop
    nop
    jr   nz,$2666
    ld   bc,$2800
    ret  po
    ld   (bc),a
    nop
    jr   nc,$265E
    inc  b
    nop
    jr   c,$2652
    dec  b
    nop
    ld   c,b
    cp   b
    ld   b,$00
    ld   d,b
    cp   b
    inc  b
    nop
    ld   e,b
    xor  b
    dec  b
    nop
    ld   e,b
    and  b
    ld   b,$00
    ld   h,b
    and  b
    inc  b
    nop
    ld   l,b
    sub  b
    dec  b
    nop
    ld   (hl),b
    adc  a,b
    ld   b,$00
    ld   a,b
    adc  a,b
    inc  b
    nop
    add  a,b
    ld   a,b
    dec  b
    nop
    adc  a,b
    ld   (hl),b
    ld   b,$00
    sub  b
    ld   (hl),b
    inc  b
    nop
    sbc  a,b
    ld   h,b
    dec  b
    nop
    and  b
    ld   e,b
    ld   b,$00
    xor  b
    ld   e,b
    inc  b
    nop
    or   b
    ld   c,b
    dec  b
    nop
    cp   b
    ld   b,b
    ld   b,$00
    ret  nz
    ld   b,b
    inc  b
    nop
    ret  z
    jr   nc,$26E0
    nop
    ret  nc
    jr   z,$26E5
    nop
    ret  c
    jr   z,$26E7
    nop
    ret  po
    jr   z,$26EC
    nop
    ret  pe
    jr   z,$26F1
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   $273A
    nop
    nop
    jr   nz,$273E
    ld   bc,$2800
    jr   c,$270D
    nop
    jr   nc,$2746
    inc  bc
    nop
    jr   c,$274A
    rlca
    nop
    ld   b,b
    ld   b,b
    inc  b
    nop
    ld   c,b
    ld   b,b
    dec  b
    nop
    ld   d,b
    ld   b,b
    ld   b,$00
    ld   e,b
    ld   b,b
    inc  b
    nop
    ld   l,b
    ld   e,b
    dec  b
    nop
    ld   (hl),b
    ld   e,b
    ld   b,$00
    ld   a,b
    ld   e,b
    inc  b
    nop
    add  a,b
    ld   e,b
    dec  b
    nop
    adc  a,b
    ld   e,b
    ld   b,$00
    sub  b
    ld   e,b
    inc  b
    nop
    sbc  a,b
    ld   e,b
    dec  b
    nop
    and  b
    ld   e,b
    ld   b,$00
    xor  b
    ld   e,b
    inc  b
    nop
    cp   b
    ld   b,b
    dec  b
    nop
    ret  nz
    ld   b,b
    ld   b,$00
    ret  z
    ld   b,b
    inc  b
    nop
    ret  nc
    jr   nc,$275C
    nop
    ret  c
    ld   c,b
    ld   b,$00
    ret  po
    jr   z,$2763
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jr   $27AA
    nop
    nop
    jr   nz,$27AE
    ld   bc,$2800
    jr   c,$277D
    nop
    jr   nc,$27B6
    inc  bc
    nop
    jr   c,$27BA
    ld   (bc),a
    nop
    ld   b,b
    jr   c,$278E
    nop
    ld   c,b
    ld   b,b
    inc  b
    nop
    ld   d,b
    ld   b,b
    dec  b
    nop
    ld   e,b
    ld   b,b
    ld   b,$00
    ld   h,b
    ld   e,b
    inc  b
    nop
    ld   l,b
    ld   e,b
    dec  b
    nop
    ld   (hl),b
    ld   e,b
    ld   b,$00
    ld   a,b
    ld   (hl),b
    inc  b
    nop
    add  a,b
    ld   (hl),b
    dec  b
    nop
    adc  a,b
    ld   (hl),b
    ld   b,$00
    sub  b
    adc  a,b
    inc  b
    nop
    sbc  a,b
    adc  a,b
    dec  b
    nop
    and  b
    adc  a,b
    ld   b,$00
    xor  b
    and  b
    inc  b
    nop
    or   b
    and  b
    dec  b
    nop
    cp   b
    and  b
    ld   b,$00
    ret  nz
    cp   b
    inc  b
    nop
    ret  z
    cp   b
    dec  b
    nop
    ret  nc
    cp   b
    ld   b,$00
    ret  c
    ret  nc
    inc  b
    nop
    ret  po
    ret  nc
    dec  b
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8143)
    scf
    ccf
    add  a,$60
    jr   nc,$27F4
    ld   a,$D0
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    ret
    ld   a,$28
    ld   ($8143),a
    add  a,$10
    ld   ($8147),a
    ret
    rst  $38
    jr   $27E2
    nop
    nop
    jr   nz,$27E6
    ld   bc,$2800
    ret  po
    ld   (bc),a
    nop
    jr   nc,$27DE
    inc  b
    nop
    jr   c,$27E2
    dec  b
    nop
    ld   b,b
    cp   b
    dec  b
    nop
    ld   c,b
    cp   b
    ld   b,$00
    ld   d,b
    cp   b
    inc  b
    nop
    ld   e,b
    cp   b
    dec  b
    nop
    ld   h,b
    cp   b
    ld   b,$00
    ld   l,b
    cp   b
    inc  b
    nop
    ld   l,b
    and  b
    dec  b
    nop
    ld   (hl),b
    and  b
    ld   b,$00
    ld   a,b
    and  b
    inc  b
    nop
    add  a,b
    and  b
    dec  b
    nop
    adc  a,b
    and  b
    ld   b,$00
    sub  b
    and  b
    inc  b
    nop
    sbc  a,b
    and  b
    dec  b
    nop
    and  b
    adc  a,b
    ld   b,$00
    or   b
    adc  a,b
    inc  b
    nop
    or   b
    adc  a,b
    ex   af,af'
    nop
    xor  b
    adc  a,b
    add  hl,bc
    nop
    and  b
    adc  a,b
    ld   a,(bc)
    nop
    sub  b
    ld   (hl),b
    ex   af,af'
    nop
    adc  a,b
    ld   (hl),b
    add  hl,bc
    nop
    add  a,b
    ld   (hl),b
    ld   a,(bc)
    nop
    ld   a,b
    ld   (hl),b
    ex   af,af'
    nop
    ld   (hl),b
    ld   (hl),b
    add  hl,bc
    nop
    ld   l,b
    ld   h,b
    ld   a,(bc)
    nop
    ld   h,b
    ld   e,b
    ex   af,af'
    nop
    ld   e,b
    ld   e,b
    add  hl,bc
    nop
    ld   d,b
    ld   e,b
    ld   a,(bc)
    nop
    ld   c,b
    ld   e,b
    inc  b
    nop
    ld   d,b
    ld   e,b
    dec  b
    nop
    ld   e,b
    ld   e,b
    ld   b,$00
    ld   h,b
    ld   e,b
    inc  b
    nop
    ld   l,b
    ld   e,b
    dec  b
    nop
    ld   (hl),b
    ld   c,b
    ld   b,$00
    ld   a,b
    ld   b,b
    inc  b
    nop
    add  a,b
    ld   b,b
    dec  b
    nop
    adc  a,b
    ld   b,b
    ld   b,$00
    sub  b
    ld   b,b
    inc  b
    nop
    sbc  a,b
    ld   b,b
    dec  b
    nop
    and  b
    jr   c,$28B5
    nop
    xor  b
    jr   nc,$28B7
    nop
    or   b
    jr   z,$28BC
    nop
    cp   b
    jr   z,$28C1
    nop
    ret  nz
    jr   z,$28C3
    nop
    ret  z
    jr   z,$28C8
    nop
    ret  nc
    jr   z,$28CD
    nop
    ret  c
    jr   z,$28CF
    nop
    ret  po
    jr   z,$28D4
    nop
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($814C)
    and  a
    ret  z
    ld   b,a
    ld   a,($802E)
    add  a,b
    ld   ($814C),a
    ld   a,($8150)
    and  a
    ret  z
    ld   b,a
    ld   a,($802E)
    add  a,b
    ld   ($8150),a
    ret
    ld   hl,$0200
    call $01E3
    call $1110
    ld   hl,$0220
    call $01E3
    ld   hl,$0240
    call $01E3
    call $1110
    ld   hl,$0840
    jr   $2940
    rst  $38
    rst  $38
    inc  hl
    inc  hl
    ld   b,(hl)
    ld   a,($814C)
    scf
    ccf
    sub  b
    jr   c,$292F
    ld   a,$FF
    jr   $2931
    ld   a,$01
    ld   ($802E),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $01E3
    call $1110
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push ix
    call $2901
    pop  ix
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8060)
    inc  a
    ld   ($8060),a
    cp   $01
    jr   nz,$2991
    ld   a,$F2
    ld   ($934B),a
    ret
    cp   $02
    jr   nz,$299B
    ld   a,$F3
    ld   ($934C),a
    ret
    cp   $03
    jr   nz,$29A5
    ld   a,$EA
    ld   ($936B),a
    ret
    cp   $04
    jr   nz,$29AF
    ld   a,$EB
    ld   ($936C),a
    ret
    cp   $05
    jr   nz,$29C0
    ld   a,($8062)
    ld   hl,$1678
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($938B),a
    ret
    ld   a,($8062)
    ld   hl,$167C
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($938C),a
    call $3FD0
    ld   c,$0A
    ld   a,($8062)
    ld   b,a
    inc  b
    ld   a,$A0
    ld   ($801D),a
    push bc
    call $1700
    pop  bc
    call $24EC
    djnz $29D6
    dec  c
    jr   nz,$29D1
    ld   a,($8062)
    inc  a
    cp   $04
    jr   nz,$29F2
    ld   a,$03
    ld   ($8062),a
    xor  a
    ld   ($8060),a
    call $16D0
    call $199C
    ret
    jr   $29E2
    nop
    nop
    jr   nz,$29E6
    ld   bc,$2800
    ret  po
    ld   (bc),a
    nop
    jr   nc,$29EE
    inc  bc
    nop
    jr   c,$29E2
    inc  b
    nop
    ld   b,b
    ret  nz
    dec  b
    nop
    ld   c,b
    cp   b
    ld   b,$00
    ld   c,b
    cp   b
    inc  b
    nop
    ld   d,b
    cp   b
    dec  b
    nop
    ld   e,b
    cp   b
    ld   b,$00
    ld   h,b
    cp   b
    inc  b
    nop
    ld   l,b
    or   b
    nop
    nop
    ld   (hl),b
    or   b
    ld   bc,$7800
    or   b
    ld   (bc),a
    nop
    add  a,b
    or   b
    inc  bc
    nop
    adc  a,b
    cp   b
    ld   (bc),a
    nop
    sbc  a,b
    cp   b
    inc  bc
    nop
    xor  b
    cp   b
    ld   (bc),a
    nop
    or   b
    or   b
    inc  bc
    nop
    cp   b
    or   b
    ld   (bc),a
    nop
    ret  nz
    or   b
    inc  bc
    nop
    ret  z
    and  b
    inc  b
    nop
    ret  nc
    sub  b
    dec  b
    nop
    ret  c
    adc  a,b
    ld   b,$00
    ret  po
    adc  a,b
    ex   af,af'
    nop
    ret  nc
    adc  a,b
    add  hl,bc
    nop
    ret  c
    add  a,b
    ld   a,(bc)
    nop
    ret  nz
    ld   (hl),b
    ex   af,af'
    nop
    cp   b
    ld   (hl),b
    add  hl,bc
    nop
    or   b
    ld   (hl),b
    ld   a,(bc)
    nop
    sub  b
    ld   (hl),b
    ex   af,af'
    nop
    add  a,b
    ld   (hl),b
    add  hl,bc
    nop
    ld   a,b
    ld   (hl),b
    ld   a,(bc)
    nop
    ld   (hl),b
    ld   (hl),b
    ex   af,af'
    nop
    ld   l,b
    ld   (hl),b
    add  hl,bc
    nop
    ld   h,b
    ld   h,b
    ld   a,(bc)
    nop
    ld   e,b
    ld   e,b
    ex   af,af'
    nop
    ld   d,b
    ld   e,b
    inc  b
    nop
    ld   e,b
    ld   e,b
    dec  b
    nop
    ld   h,b
    ld   c,b
    ld   b,$00
    ld   l,b
    ld   b,b
    inc  b
    nop
    ld   (hl),b
    ld   b,b
    dec  b
    nop
    ld   a,b
    ld   b,b
    ld   b,$00
    add  a,b
    ld   b,b
    inc  b
    nop
    sub  b
    ld   b,b
    dec  b
    nop
    or   b
    ld   b,b
    ld   b,$00
    cp   b
    ld   b,b
    inc  b
    nop
    ret  nz
    ld   b,b
    dec  b
    nop
    ret  z
    ld   b,b
    ld   b,$00
    ret  nc
    jr   c,$2ACB
    nop
    ret  c
    jr   nc,$2AD0
    nop
    ret  po
    jr   z,$2AD5
    nop
    call $16D0
    ld   a,($8060)
    ld   e,a
    xor  a
    ld   ($8060),a
    ld   a,e
    and  a
    ret  z
    call $2980
    dec  e
    jr   nz,$2ADE
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8093)
    ld   b,a
    xor  a
    ld   ($8093),a
    ld   a,b
    and  a
    jr   nz,$2B14
    ld   a,($8094)
    ld   b,a
    xor  a
    ld   ($8094),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   b,a
    and  $F0
    jr   nz,$2B28
    xor  a
    jr   $2B3A
    cp   $10
    jr   nz,$2B30
    ld   a,$0A
    jr   $2B3A
    cp   $20
    jr   nz,$2B38
    ld   a,$14
    jr   $2B3A
    ld   a,$1E
    ld   c,a
    ld   a,b
    and  $0F
    add  a,c
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$2B5B
    ld   a,($8029)
    jr   $2B5E
    ld   a,($802A)
    dec  a
    sla  a
    sla  a
    call $1390
    nop
    nop
    nop
    ret
    call $2C48
    ret
    nop
    nop
    nop
    ret
    call $2C58
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    call $2C98
    ret
    call $3168
    ret
    call $2BF0
    ret
    call $3398
    ret
    call $3470
    ret
    call $3538
    ret
    call $35B8
    ret
    call $3658
    ret
    nop
    nop
    nop
    ret
    call $3670
    ret
    call $36D0
    ret
    call $3760
    ret
    call $37E8
    ret
    nop
    nop
    nop
    ret
    call $3808
    ret
    call $3868
    ret
    call $3B68
    ret
    call $3888
    ret
    call $3918
    ret
    call $3888
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $32D0
    call $32F0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$B0
    ld   ($8154),a
    ld   a,$40
    ld   ($8157),a
    ld   a,$1D
    ld   ($8155),a
    ld   a,$15
    ld   ($8156),a
    ld   a,$01
    ld   ($8037),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8316)
    and  $07
    ret  nz
    ld   a,($8036)
    inc  a
    cp   $0E
    jr   nz,$2C37
    xor  a
    ld   ($8036),a
    and  a
    ret  nz
    call $2C00
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $2C28
    call $3140
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $2C28
    call $3140
    call $3238
    call $3260
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($83F1)
    ld   b,a
    ld   a,($9184)
    cp   $01
    jr   z,$2C7F
    bit  7,b
    jr   nz,$2C88
    ld   a,($A000)
    bit  5,a
    call nz,$2ED8
    ret
    bit  5,b
    call nz,$2ED8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $2C28
    call $3140
    call $3238
    call $3260
    call $3570
    call $3590
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$2CBB
    ld   a,($8029)
    jr   $2CBE
    ld   a,($802A)
    dec  a
    and  $07
    sla  a
    sla  a
    call $1390
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8300
    ld   a,($8014)
    cp   (hl)
    jr   nz,$2D1D
    inc  hl
    ld   a,($8015)
    cp   (hl)
    jr   nz,$2D1D
    inc  hl
    ld   a,($8016)
    cp   (hl)
    jr   nz,$2D1D
    call $2D48
    jp   $03E8
    ld   hl,$8300
    ld   a,($8017)
    cp   (hl)
    jr   nz,$2D1A
    inc  hl
    ld   a,($8018)
    cp   (hl)
    jr   nz,$2D1A
    inc  hl
    ld   a,($8019)
    cp   (hl)
    jr   nz,$2D1A
    call $2D58
    jp   $03E8
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   ($B006),a
    ld   ($B007),a
    ld   a,$01
    call $2D88
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($83F1)
    bit  7,a
    jr   z,$2D69
    ld   a,$01
    ld   ($B006),a
    ld   ($B007),a
    jr   $2D70
    xor  a
    ld   ($B006),a
    ld   ($B007),a
    ld   a,$02
    call $2D88
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push af
    ld   hl,$16E8
    call $01E3
    ld   a,$09
    ld   ($8042),a
    nop
    call $1470
    call $37B8
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $0310
    inc  b
    ld   a,(bc)
    jr   nz,$2DC6
    ld   de,$1529
    ld   ($CDFF),hl
    djnz $2DB5
    rlca
    inc  bc
    add  hl,hl
    rra
    dec  h
    djnz $2DCB
    dec  d
    ld   de,$1024
    inc  h
    jr   $2DD5
    djnz $2DDA
    add  hl,de
    rla
    jr   $2DDB
    inc  hl
    inc  h
    rst  $38
    call $0310
    add  hl,bc
    inc  bc
    inc  hl
    inc  de
    rra
    ld   ($1015),hl
    rra
    ld   d,$10
    inc  h
    jr   $2DEF
    djnz $2DF0
    ld   de,$FF29
    call $0310
    dec  bc
    inc  bc
    jr   nz,$2E02
    dec  d
    ld   de,$1523
    djnz $2E01
    ld   e,$24
    dec  d
    ld   ($2910),hl
    rra
    dec  h
    ld   ($1E10),hl
    ld   de,$151D
    rst  $38
    call $0310
    dec  c
    inc  bc
    ld   de,$1210
    djnz $2E18
    djnz $2E1B
    djnz $2E1E
    djnz $2E21
    djnz $2E24
    djnz $2E27
    djnz $2E2A
    djnz $2E2D
    djnz $2E30
    djnz $2E33
    rst  $38
    call $0310
    rrca
    inc  bc
    dec  e
    djnz $2E3E
    djnz $2E41
    djnz $2E44
    djnz $2E47
    djnz $2E4A
    djnz $2E4D
    djnz $2E50
    djnz $2E53
    djnz $2E56
    djnz $2E59
    djnz $2E5C
    rst  $38
    call $0310
    ld   de,$2903
    djnz $2E67
    djnz $2E4F
    djnz $2E51
    djnz $2E53
    djnz $2E96
    djnz $2E99
    djnz $2E9C
    djnz $2E5B
    djnz $2E5D
    djnz $2EA7
    ld   e,c
    ld   e,d
    ld   e,e
    rst  $38
    call $0310
    rla
    ld   a,(bc)
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    rst  $38
    call $2450
    ld   a,$09
    ld   ($9382),a
    xor  a
    ld   ($9362),a
    ld   ($8075),a
    pop  af
    ld   iy,$9277
    ld   ($9184),a
    call $2F88
    ld   hl,$934E
    ld   (hl),$89
    ld   ix,$83F1
    ld   a,($9184)
    cp   $01
    jr   z,$2E93
    bit  7,(ix+$00)
    jr   nz,$2E97
    ld   ix,$A000
    bit  3,(ix+$00)
    jr   z,$2EA0
    call $2FA8
    bit  2,(ix+$00)
    jr   z,$2EA9
    call $2F50
    call $2C70
    nop
    nop
    nop
    nop
    nop
    nop
    push hl
    push iy
    pop  hl
    ld   a,$37
    cp   l
    jr   nz,$2EC0
    ld   a,$91
    cp   h
    jr   z,$2EC8
    pop  hl
    ld   (hl),$89
    call $3108
    jr   $2E80
    pop  hl
    call $2F10
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$10
    ld   ($8093),a
    ld   a,$90
    cp   h
    jr   nz,$2EF4
    ld   a,$92
    cp   l
    jr   nz,$2EEB
    call $2F10
    ret
    ld   a,$D2
    cp   l
    jr   nz,$2EF4
    call $2F20
    ret
    dec  hl
    ld   a,(hl)
    inc  hl
    ld   (iy+$00),a
    ld   de,$FFE0
    add  iy,de
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   ($8086),a
    pop  hl
    pop  hl
    call $2FE0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   de,$0020
    add  iy,de
    ld   (iy+$00),$2B
    ld   a,$10
    ld   ($9297),a
    push hl
    push iy
    pop  hl
    ld   a,$92
    cp   h
    jr   nz,$2F3C
    ld   a,$97
    cp   l
    jr   z,$2F3E
    pop  hl
    ret
    ld   de,$FFE0
    add  iy,de
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   (hl),$10
    ld   de,$0040
    add  hl,de
    ld   a,$93
    cp   h
    ret  nz
    ld   a,$92
    cp   l
    jr   nz,$2F63
    ld   hl,$9090
    ret
    ld   a,$90
    cp   l
    jr   nz,$2F6C
    ld   hl,$908E
    ret
    ld   a,$8E
    cp   l
    ret  nz
    ld   hl,$9092
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    ld   hl,$8307
    ld   (hl),$10
    inc  hl
    ld   a,l
    cp   $11
    jr   nz,$2F8C
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rra
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$10
    ld   ($8093),a
    ld   (hl),$10
    ld   de,$0040
    sbc  hl,de
    ld   a,$90
    cp   h
    ret  nz
    ld   a,$4E
    cp   l
    jr   nz,$2FC1
    ld   hl,$9350
    ret
    ld   a,$50
    cp   l
    jr   nz,$2FCA
    ld   hl,$9352
    ret
    ld   a,$52
    cp   l
    ret  nz
    ld   hl,$934E
    ret
    rst  $38
    rst  $38
    rst  $38
    call $3038
    call $24E0
    call $1470
    ret
    rst  $38
    ld   hl,$8307
    ld   a,($9277)
    ld   (hl),a
    ld   a,($9257)
    inc  hl
    ld   (hl),a
    ld   a,($9237)
    inc  hl
    ld   (hl),a
    ld   a,($9217)
    inc  hl
    ld   (hl),a
    ld   a,($91F7)
    inc  hl
    ld   (hl),a
    ld   a,($91D7)
    inc  hl
    ld   (hl),a
    ld   a,($91B7)
    inc  hl
    ld   (hl),a
    ld   a,($9197)
    inc  hl
    ld   (hl),a
    ld   a,($9177)
    inc  hl
    ld   (hl),a
    ld   a,($9157)
    inc  hl
    ld   (hl),a
    call $30C0
    call $2FD5
    jp   $03E8
    rst  $38
    rst  $38
    rst  $38
    ld   c,$05
    call $13A0
    dec  c
    jr   nz,$3022
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8307)
    ld   ($9280),a
    ld   a,($8308)
    ld   ($9260),a
    ld   a,($8309)
    ld   ($9240),a
    ld   a,($830A)
    ld   ($9220),a
    ld   a,($830B)
    ld   ($9200),a
    ld   a,($830C)
    ld   ($91E0),a
    ld   a,($830D)
    ld   ($91C0),a
    ld   a,($830E)
    ld   ($91A0),a
    ld   a,($830F)
    ld   ($9180),a
    ld   a,($8310)
    ld   ($9160),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8307
    ld   (hl),$18
    inc  hl
    ld   (hl),$19
    inc  hl
    ld   (hl),$17
    inc  hl
    ld   (hl),$18
    inc  hl
    ld   (hl),$2B
    inc  hl
    ld   (hl),$23
    inc  hl
    ld   (hl),$13
    inc  hl
    ld   (hl),$1F
    inc  hl
    ld   (hl),$22
    inc  hl
    ld   (hl),$15
    ld   hl,$8300
    ld   (hl),$00
    inc  hl
    ld   (hl),$05
    inc  hl
    ld   (hl),$00
    inc  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$00
    ld   hl,$8310
    ld   a,(hl)
    cp   $2B
    jr   nz,$30D8
    ld   (hl),$10
    dec  hl
    ld   a,(hl)
    cp   $2B
    jr   nz,$30D8
    ld   (hl),$10
    dec  hl
    inc  c
    jr   $30C5
    ld   a,c
    and  a
    ret  z
    dec  c
    call $30E8
    jr   $30D8
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   d,$0A
    ld   ix,$830F
    ld   a,(ix+$00)
    ld   (ix+$01),a
    dec  d
    dec  ix
    jr   nz,$30EE
    ld   a,$10
    ld   ($8307),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    push bc
    push iy
    push ix
    ld   c,$14
    call $13A0
    dec  c
    jr   nz,$3110
    ld   a,($8076)
    inc  a
    ld   ($8076),a
    and  $01
    jr   z,$3135
    ld   hl,$8075
    ld   a,(hl)
    dec  a
    daa
    call z,$2F10
    ld   (hl),a
    xor  a
    rld
    ld   ($9382),a
    rld
    ld   ($9362),a
    rld
    pop  ix
    pop  iy
    pop  bc
    pop  hl
    ret
    rst  $38
    ld   a,($8037)
    and  a
    ret  z
    inc  a
    cp   $3C
    jr   nz,$314B
    xor  a
    ld   ($8037),a
    ld   hl,$3180
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($8155),a
    inc  hl
    ld   a,(hl)
    ld   ($8157),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $2C28
    call $3140
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    dec  e
    ld   d,d
    dec  e
    ld   d,h
    dec  e
    ld   d,(hl)
    dec  e
    ld   e,b
    dec  e
    ld   e,d
    dec  e
    ld   e,h
    dec  e
    ld   e,(hl)
    dec  e
    ld   h,b
    dec  e
    ld   h,d
    dec  e
    ld   h,h
    dec  e
    ld   h,(hl)
    dec  e
    ld   l,b
    dec  e
    ld   l,d
    dec  e
    ld   l,h
    dec  e
    ld   l,(hl)
    dec  e
    ld   (hl),c
    dec  e
    ld   (hl),e
    dec  e
    ld   (hl),l
    dec  e
    ld   a,b
    dec  e
    ld   a,d
    dec  e
    ld   a,h
    dec  e
    ld   a,a
    dec  e
    add  a,c
    dec  e
    add  a,e
    dec  e
    add  a,(hl)
    dec  e
    adc  a,b
    dec  e
    adc  a,d
    dec  e
    adc  a,l
    dec  e
    adc  a,a
    dec  e
    sub  c
    dec  e
    sub  h
    dec  e
    sub  (hl)
    dec  e
    sbc  a,b
    dec  e
    sbc  a,e
    dec  e
    sbc  a,l
    dec  e
    sbc  a,a
    dec  e
    and  d
    dec  e
    and  h
    dec  e
    and  (hl)
    dec  e
    xor  e
    dec  e
    xor  l
    dec  e
    xor  a
    dec  e
    or   d
    dec  e
    or   h
    dec  e
    or   (hl)
    dec  e
    cp   c
    dec  e
    cp   e
    dec  e
    cp   l
    dec  e
    ret  nz
    dec  e
    jp   nz,$C41D
    dec  e
    add  a,$1D
    ret  z
    dec  e
    jp   z,$CC1D
    dec  e
    adc  a,$1E
    adc  a,$1F
    adc  a,$20
    adc  a,$21
    adc  a,$21
    adc  a,$21
    adc  a,$FF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F0
    ld   ($8158),a
    ld   a,$C4
    ld   ($815B),a
    ld   a,$23
    ld   ($8159),a
    ld   a,$16
    ld   ($815A),a
    ld   a,$01
    ld   ($8039),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8158)
    and  a
    jr   z,$324D
    cp   $01
    jr   z,$324D
    cp   $02
    jr   z,$324D
    cp   $03
    jr   z,$324D
    cp   $04
    ret  nz
    call $3210
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $01
    ret  z
    ld   a,($8039)
    and  a
    ret  z
    ld   a,($8158)
    dec  a
    dec  a
    dec  a
    ld   ($8158),a
    ld   a,($8315)
    and  $02
    ret  nz
    ld   a,($8159)
    cp   $23
    jr   nz,$3287
    ld   a,$24
    ld   ($8159),a
    ret
    ld   a,$23
    ld   ($8159),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$A0
    ld   ($8154),a
    ld   a,$D0
    ld   ($8157),a
    ld   a,$17
    ld   ($8156),a
    ld   a,$34
    ld   ($8155),a
    ld   a,$01
    ld   ($803B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($803A)
    inc  a
    cp   $20
    jr   nz,$32DF
    xor  a
    ld   ($803A),a
    and  a
    ret  nz
    call $32B0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($803B)
    and  a
    ret  z
    inc  a
    cp   $81
    jr   nz,$32FB
    xor  a
    ld   ($803B),a
    ld   b,a
    scf
    ccf
    sub  $40
    jr   nc,$3309
    call $3318
    ret
    call $3340
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8157)
    dec  a
    dec  a
    ld   ($8157),a
    and  $03
    ret  nz
    ld   a,($8155)
    cp   $34
    jr   z,$3330
    ld   a,$34
    ld   ($8155),a
    ret
    ld   a,$35
    ld   ($8155),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8157)
    inc  a
    inc  a
    ld   ($8157),a
    ld   a,$34
    ld   ($8155),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F0
    ld   ($8158),a
    ld   a,$40
    ld   ($815B),a
    ld   a,$23
    ld   ($8159),a
    ld   a,$16
    ld   ($815A),a
    ld   a,$01
    ld   ($8039),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8158)
    and  a
    jr   z,$338D
    cp   $01
    jr   z,$338D
    cp   $02
    jr   z,$338D
    cp   $03
    jr   z,$338D
    cp   $04
    ret  nz
    call $3358
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3378
    call $3260
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $32D0
    call $32F0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($803B)
    and  a
    ret  z
    inc  a
    cp   $81
    jr   nz,$33C3
    xor  a
    ld   ($803B),a
    ld   b,a
    scf
    ccf
    sub  $40
    jr   nc,$33D1
    call $33D8
    ret
    call $3400
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8157)
    dec  a
    dec  a
    ld   ($8157),a
    and  $03
    ret  nz
    ld   a,($8155)
    cp   $34
    jr   nz,$33F0
    ld   a,$35
    ld   ($8155),a
    ret
    ld   a,$34
    ld   ($8155),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8157)
    inc  a
    inc  a
    ld   ($8157),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($803D)
    and  a
    ret  z
    inc  a
    cp   $61
    jr   nz,$3423
    xor  a
    ld   ($803D),a
    ld   b,a
    scf
    ccf
    sub  $30
    jr   nc,$3431
    call $3438
    ret
    call $3458
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815B)
    dec  a
    dec  a
    ld   ($815B),a
    and  $03
    ret  nz
    ld   a,($8159)
    cp   $34
    jr   nz,$3450
    ld   a,$35
    ld   ($8159),a
    ret
    ld   a,$34
    ld   ($8159),a
    ret
    rst  $38
    rst  $38
    ld   a,($815B)
    inc  a
    inc  a
    ld   ($815B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $33B8
    call $3418
    call $3488
    call $34E8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($803A)
    inc  a
    cp   $20
    jr   nz,$3497
    xor  a
    ld   ($803A),a
    and  a
    ret  nz
    call $34A8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$34
    ld   ($8155),a
    ld   a,$A4
    ld   ($8154),a
    ld   a,$AC
    ld   ($8157),a
    ld   a,$17
    ld   ($8156),a
    ld   a,$01
    ld   ($803B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$80
    ld   ($8158),a
    ld   a,$7C
    ld   ($815B),a
    ld   a,$34
    ld   ($8159),a
    ld   a,$17
    ld   ($815A),a
    ld   a,$01
    ld   ($803D),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($803C)
    inc  a
    cp   $28
    jr   nz,$34F7
    xor  a
    ld   ($803C),a
    and  a
    ret  nz
    call $34C8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$FF
    ld   ($8036),a
    ld   ($8038),a
    ld   ($803A),a
    ld   ($803C),a
    ld   ($803E),a
    ld   ($8040),a
    xor  a
    ld   ($8037),a
    ld   ($8039),a
    ld   ($803B),a
    ld   ($803D),a
    ld   ($803F),a
    ld   ($8041),a
    ret
    call $3238
    call $3260
    call $2C28
    call $3140
    call $3570
    call $3590
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$60
    ld   ($815C),a
    ld   a,$1D
    ld   ($815D),a
    ld   a,$15
    ld   ($815E),a
    ld   a,$40
    ld   ($815F),a
    ld   a,$01
    ld   ($803F),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8316)
    and  $07
    ret  nz
    ld   a,($803E)
    inc  a
    cp   $14
    jr   nz,$357F
    xor  a
    ld   ($803E),a
    and  a
    ret  nz
    call $3550
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($803F)
    and  a
    ret  z
    inc  a
    cp   $40
    jr   nz,$359B
    xor  a
    ld   ($803F),a
    ld   hl,$3180
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   ($815D),a
    inc  hl
    ld   a,(hl)
    ld   ($815F),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3570
    call $3590
    call $2C28
    call $3140
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$10
    ld   ($815C),a
    ld   a,$A3
    ld   ($815D),a
    ld   a,$16
    ld   ($815E),a
    ld   a,$BC
    ld   ($815F),a
    ld   a,$01
    ld   ($8041),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    and  a
    jr   z,$3605
    cp   $01
    jr   z,$3605
    cp   $02
    jr   z,$3605
    cp   $03
    jr   z,$3605
    cp   $04
    ret  nz
    call $35D0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $01
    ret  z
    ld   a,($8041)
    and  a
    ret  z
    ld   a,($815C)
    inc  a
    inc  a
    inc  a
    ld   ($815C),a
    ld   a,($8315)
    and  $02
    ret  nz
    ld   a,($815D)
    cp   $A3
    jr   nz,$3637
    ld   a,$A4
    ld   ($815D),a
    ret
    ld   a,$A3
    ld   ($815D),a
    ret
    rst  $38
    rst  $38
    rst  $38
    push bc
    ld   a,($83F1)
    and  $3F
    ld   c,a
    ld   a,$0E
    out  ($00),a
    in   a,($02)
    ld   ($83F2),a
    and  $C0
    add  a,c
    ld   ($83F1),a
    pop  bc
    ret
    call $35F0
    call $3610
    call $3238
    call $3260
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $33B8
    call $3418
    call $3488
    call $34E8
    call $36A8
    call $3610
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$10
    ld   ($815C),a
    ld   a,$A3
    ld   ($815D),a
    ld   a,$16
    ld   ($815E),a
    ld   a,$98
    ld   ($815F),a
    ld   a,$01
    ld   ($8041),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    and  a
    jr   z,$36BD
    cp   $01
    jr   z,$36BD
    cp   $02
    jr   z,$36BD
    cp   $03
    jr   z,$36BD
    cp   $04
    ret  nz
    call $3688
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $35F0
    call $3610
    call $3238
    call $3260
    call $2C28
    call $3140
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F0
    ld   ($815C),a
    ld   a,$22
    ld   ($815D),a
    ld   a,$17
    ld   ($815E),a
    ld   a,$94
    ld   ($815F),a
    ld   a,$01
    ld   ($8041),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    and  a
    jr   z,$3725
    cp   $01
    jr   z,$3725
    cp   $02
    jr   z,$3725
    cp   $03
    jr   z,$3725
    cp   $04
    ret  nz
    call $36E8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $01
    ret  z
    ld   a,($8041)
    and  a
    ret  z
    ld   a,($815C)
    dec  a
    dec  a
    dec  a
    ld   ($815C),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3710
    call $3730
    call $3798
    call $37B8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F0
    ld   ($8158),a
    ld   a,$22
    ld   ($8159),a
    ld   a,$17
    ld   ($815A),a
    ld   a,$50
    ld   ($815B),a
    ld   a,$01
    ld   ($8039),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8158)
    and  a
    jr   z,$37AD
    cp   $01
    jr   z,$37AD
    cp   $02
    jr   z,$37AD
    cp   $03
    jr   z,$37AD
    cp   $04
    ret  nz
    call $3778
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $01
    ret  z
    ld   a,($8039)
    and  a
    ret  z
    ld   a,($8158)
    dec  a
    dec  a
    dec  a
    dec  a
    ld   ($8158),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3710
    call $3730
    call $3798
    call $37B8
    call $33B8
    call $3488
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3378
    call $3260
    call $3840
    call $3610
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$10
    ld   ($815C),a
    ld   a,$23
    ld   ($815D),a
    ld   a,$16
    ld   ($815E),a
    ld   a,$60
    ld   ($815F),a
    ld   a,$01
    ld   ($8041),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    and  a
    jr   z,$3855
    cp   $01
    jr   z,$3855
    cp   $02
    jr   z,$3855
    cp   $03
    jr   z,$3855
    cp   $04
    ret  nz
    call $3820
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3488
    call $33B8
    call $36A8
    call $3610
    call $3238
    call $3260
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $3378
    call $3260
    call $3840
    call $3610
    call $38C0
    call $38D0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$60
    ld   ($8157),a
    ld   a,$A3
    ld   ($8155),a
    ld   a,$16
    ld   ($8156),a
    ld   a,$01
    ld   ($803B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $38A0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    sub  $50
    ld   ($8154),a
    ld   a,($815D)
    ld   ($8155),a
    ret
    rst  $38
    call $0310
    ld   a,(bc)
    nop
    ret  po
    call c,$DEDD
    rst  $18
    rst  $38
    call $0310
    dec  bc
    nop
    pop  hl
    rst  $38
    call $0310
    dec  bc
    inc  b
    and  $FF
    call $0310
    inc  c
    nop
    pop  hl
    rst  $38
    call $0310
    inc  c
    inc  b
    and  $FF
    call $0310
    dec  c
    nop
    jp   po,$E3E3
    ex   (sp),hl
    call po,$C9FF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $39B8
    call $39E8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8154)
    and  a
    ret  nz
    ld   a,$F0
    ld   ($8154),a
    ld   a,$22
    ld   ($8155),a
    ld   a,$17
    ld   ($8156),a
    ld   a,$C8
    ld   ($8157),a
    ld   a,$01
    ld   ($8037),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8158)
    and  a
    ret  nz
    ld   a,$F0
    ld   ($8158),a
    ld   a,$22
    ld   ($8159),a
    ld   a,$17
    ld   ($815A),a
    ld   a,$98
    ld   ($815B),a
    ld   a,$01
    ld   ($8039),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($815C)
    and  a
    ret  nz
    ld   a,$F0
    ld   ($815C),a
    ld   a,$22
    ld   ($815D),a
    ld   a,$17
    ld   ($815E),a
    ld   a,$68
    ld   ($815F),a
    ld   a,$01
    ld   ($803B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8007)
    ld   ($8036),a
    ret
    rst  $38
    ld   a,($8154)
    cp   $80
    jr   z,$39D3
    cp   $81
    jr   z,$39D3
    cp   $82
    jr   z,$39D3
    cp   $83
    jr   z,$39D3
    cp   $84
    jr   z,$39D3
    cp   $00
    jr   nz,$39D6
    call $3938
    jp   $11C0
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $07
    ret  nz
    ld   a,($8037)
    and  a
    jr   z,$3A0D
    inc  a
    cp   $40
    jr   nz,$3A02
    xor  a
    ld   ($8037),a
    ld   ($8154),a
    jr   $3A0D
    ld   ($8037),a
    ld   a,($8154)
    sub  $02
    ld   ($8154),a
    ld   a,($8039)
    and  a
    jr   z,$3A2C
    inc  a
    cp   $40
    jr   nz,$3A21
    xor  a
    ld   ($8039),a
    ld   ($8158),a
    jr   $3A2C
    ld   ($8039),a
    ld   a,($8158)
    sub  $03
    ld   ($8158),a
    ld   a,($803B)
    and  a
    ret  z
    inc  a
    cp   $40
    jr   nz,$3A3E
    xor  a
    ld   ($803B),a
    ld   ($815C),a
    ret
    ld   ($803B),a
    ld   a,($815C)
    sub  $04
    ld   ($815C),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8037)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,$3A62
    xor  a
    ld   ($8154),a
    ld   ($8037),a
    ret
    ld   ($8037),a
    ld   a,($8157)
    dec  a
    dec  a
    dec  a
    ld   ($8157),a
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($8155)
    cp   $36
    jr   nz,$3A81
    ld   a,$37
    ld   ($8155),a
    ret
    ld   a,$36
    ld   ($8155),a
    ret
    rst  $38
    ld   a,($8039)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,$3A9A
    xor  a
    ld   ($8158),a
    ld   ($8039),a
    ret
    ld   ($8039),a
    ld   a,($815B)
    dec  a
    dec  a
    dec  a
    ld   ($815B),a
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($8159)
    cp   $36
    jr   nz,$3AB9
    ld   a,$37
    ld   ($8159),a
    ret
    ld   a,$36
    ld   ($8159),a
    ret
    rst  $38
    ld   a,($803B)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,$3AD2
    xor  a
    ld   ($815C),a
    ld   ($803B),a
    ret
    ld   ($803B),a
    ld   a,($815F)
    dec  a
    dec  a
    dec  a
    ld   ($815F),a
    ld   a,($8312)
    and  $03
    ret  nz
    ld   a,($815D)
    cp   $36
    jr   nz,$3AF1
    ld   a,$37
    ld   ($815D),a
    ret
    ld   a,$36
    ld   ($815D),a
    ret
    rst  $38
    ld   hl,$8154
    ld   (hl),$98
    inc  hl
    ld   (hl),$36
    inc  hl
    ld   (hl),$17
    inc  hl
    ld   (hl),$C0
    inc  hl
    ld   a,$01
    ld   ($8037),a
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8158
    ld   (hl),$90
    inc  hl
    ld   (hl),$36
    inc  hl
    ld   (hl),$17
    inc  hl
    ld   (hl),$C0
    inc  hl
    ld   a,$01
    ld   ($8039),a
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$815C
    ld   (hl),$90
    inc  hl
    ld   (hl),$36
    inc  hl
    ld   (hl),$17
    inc  hl
    ld   (hl),$C0
    inc  hl
    ld   a,$01
    ld   ($803B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    call $3B78
    ld   a,($8036)
    inc  a
    cp   $60
    jr   nz,$3B4C
    xor  a
    ld   ($8036),a
    cp   $08
    jr   nz,$3B57
    call $3AF8
    ret
    cp   $30
    jr   nz,$3B5F
    call $3B10
    ret
    cp   $40
    ret  nz
    call $3B28
    ret
    rst  $38
    rst  $38
    call $3B40
    call $14E0
    nop
    nop
    nop
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8315)
    and  $03
    ret  z
    pop  hl
    ret
    ld   a,(iy+$00)
    sub  (ix+$00)
    scf
    ccf
    sub  $0C
    jr   c,$3B8F
    add  a,$18
    ret  nc
    ld   a,(ix+$03)
    sub  (iy+$03)
    scf
    ccf
    sub  $0A
    jr   c,$3B9E
    add  a,$21
    ret  nc
    call $0A33
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   iy,$8154
    ld   ix,$8140
    call $3B80
    ld   iy,$8158
    call $3B80
    ld   iy,$815C
    call $3B80
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8108
    ld   a,($8106)
    ld   (hl),a
    inc  hl
    inc  hl
    ld   a,l
    cp   $40
    jr   nz,$3BCB
    ret
    rst  $38
    pop  ix
    ld   h,$00
    ld   l,(ix+$00)
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    inc  ix
    ld   a,(ix+$00)
    add  a,l
    ld   l,a
    ld   bc,$9040
    add  hl,bc
    inc  ix
    ld   a,(ix+$00)
    cp   $FF
    jr   z,$3BFC
    ld   (hl),a
    inc  hl
    jr   $3BEF
    inc  ix
    push ix
    ret
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$3C0D
    ld   a,($8029)
    jr   $3C10
    ld   a,($802A)
    cp   $01
    jr   z,$3C35
    cp   $02
    jr   z,$3C35
    cp   $04
    jr   z,$3C35
    cp   $08
    jr   z,$3C35
    cp   $0D
    jr   z,$3C35
    cp   $0F
    jr   z,$3C35
    cp   $12
    jr   z,$3C35
    cp   $15
    jr   z,$3C78
    cp   $18
    jr   z,$3C78
    ret
    ld   a,($804B)
    inc  a
    cp   $04
    jr   nz,$3C3E
    xor  a
    ld   ($804B),a
    and  a
    jr   nz,$3C4F
    call $0310
    dec  e
    ld   c,$80
    add  a,b
    add  a,b
    add  a,b
    rst  $38
    ret
    cp   $01
    jr   nz,$3C5E
    call $0310
    dec  e
    ld   c,$85
    add  a,c
    add  a,a
    add  a,c
    rst  $38
    ret
    cp   $02
    jr   nz,$3C6D
    call $0310
    dec  e
    ld   c,$86
    add  a,d
    adc  a,b
    add  a,b
    rst  $38
    ret
    call $0310
    dec  e
    ld   c,$85
    add  a,e
    add  a,a
    add  a,d
    rst  $38
    ret
    ld   a,($804B)
    inc  a
    cp   $04
    jr   nz,$3C81
    xor  a
    ld   ($804B),a
    and  a
    jr   nz,$3C93
    call $0310
    add  hl,de
    rrca
    add  a,b
    add  a,b
    add  a,b
    add  a,b
    add  a,b
    rst  $38
    ret
    cp   $01
    jr   nz,$3CA3
    call $0310
    add  hl,de
    rrca
    add  a,l
    add  a,c
    add  a,h
    add  a,c
    add  a,a
    rst  $38
    ret
    cp   $02
    jr   nz,$3CB3
    call $0310
    add  hl,de
    rrca
    add  a,(hl)
    add  a,d
    adc  a,b
    add  a,(hl)
    add  a,d
    rst  $38
    ret
    call $0310
    add  hl,de
    rrca
    add  a,l
    add  a,e
    add  a,b
    add  a,e
    add  a,a
    rst  $38
    ret
    rst  $38
    add  a,b
    ld   a,($7011)
    add  a,b
    dec  sp
    ld   de,$9480
    dec  b
    ld   (de),a
    add  a,b
    nop
    nop
    ld   (de),a
    add  a,b
    nop
    nop
    ld   (de),a
    add  a,b
    ld   l,h
    nop
    ld   (de),a
    add  a,b
    xor  b
    nop
    ld   (de),a
    add  a,b
    nop
    nop
    ld   (de),a
    add  a,b
    ld   e,$08
    push hl
    push de
    call $13A0
    pop  de
    pop  hl
    dec  e
    jr   nz,$3CE2
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  a
    dec  a
    ld   b,$01
    ld   a,($053B)
    nop
    inc  a
    dec  a
    ld   b,$01
    ld   a,($073B)
    ld   (bc),a
    ld   a,$3F
    ex   af,af'
    inc  bc
    ld   a,($073B)
    ld   (bc),a
    ld   a,$3F
    ex   af,af'
    inc  bc
    ld   a,($053B)
    nop
    ld   a,(hl)
    ld   ($8141),a
    inc  hl
    ld   a,(hl)
    ld   ($8145),a
    inc  hl
    ld   a,(hl)
    ld   ($8149),a
    inc  hl
    ld   a,(hl)
    ld   ($8151),a
    ld   ($8155),a
    ld   ($8159),a
    inc  hl
    ld   a,l
    and  $1F
    ld   l,a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$06
    ld   ($8042),a
    ld   ($8065),a
    call $1470
    ld   hl,$0FE0
    call $0840
    nop
    nop
    call $03A0
    call $2450
    ld   hl,$8140
    ld   bc,$3CC0
    ld   d,$20
    ld   a,(bc)
    ld   (hl),a
    inc  hl
    inc  bc
    dec  d
    jr   nz,$3D69
    call $3DA0
    ld   d,$80
    xor  a
    ld   ($802D),a
    ld   hl,$3D00
    call $3CE0
    call $3D20
    dec  d
    jr   nz,$3D7C
    call $3EB0
    ld   a,($8004)
    and  a
    jr   nz,$3D96
    ld   a,$01
    ld   ($8029),a
    jp   $1000
    ld   a,$01
    ld   ($802A),a
    jp   $1000
    ret
    rst  $38
    ld   hl,$9218
    ld   (hl),$66
    inc  hl
    ld   (hl),$67
    inc  hl
    ld   (hl),$6A
    inc  hl
    ld   (hl),$6B
    ld   hl,$91F8
    ld   (hl),$64
    inc  hl
    ld   (hl),$65
    inc  hl
    ld   (hl),$68
    inc  hl
    ld   (hl),$69
    ld   hl,$91D8
    ld   (hl),$6E
    inc  hl
    ld   (hl),$6F
    inc  hl
    ld   (hl),$6C
    inc  hl
    ld   (hl),$6D
    ld   a,$02
    ld   ($8131),a
    ld   ($8133),a
    ld   ($8135),a
    ld   ($8137),a
    call $0310
    inc  e
    nop
    jr   c,$3E18
    ld   a,($3839)
    add  hl,sp
    inc  a
    dec  a
    add  hl,sp
    ld   a,($3838)
    inc  a
    inc  a
    dec  a
    inc  a
    add  hl,sp
    ld   a,($3938)
    jr   c,$3E2C
    dec  a
    inc  a
    add  hl,sp
    jr   c,$3E32
    dec  a
    inc  a
    add  hl,sp
    add  hl,sp
    jr   c,$3DFD
    call $0310
    ld   (de),a
    nop
    cp   $FD
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    db   $fd
    call m,$C9FF
    rst  $38
    ld   a,$0C
    ld   ($8141),a
    ld   a,$0D
    ld   ($8145),a
    ld   a,$29
    ld   ($8129),a
    ld   e,$70
    push de
    call $3EF0
    call $08E8
    call $08E8
    call $13A0
    pop  de
    dec  e
    jr   nz,$3E33
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   e,$01
    push de
    push ix
    call $13A0
    pop  ix
    pop  de
    dec  e
    jr   nz,$3E52
    ret
    rst  $38
    ld   ix,$8140
    call $3E50
    ld   d,$08
    dec  (ix+$03)
    dec  (ix+$07)
    dec  (ix+$0b)
    call $3E50
    dec  d
    jr   nz,$3E69
    ld   d,$08
    inc  (ix+$03)
    inc  (ix+$07)
    inc  (ix+$0b)
    call $3E50
    dec  d
    jr   nz,$3E7A
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$07
    ld   ($8042),a
    ld   hl,$8150
    ld   (hl),$18
    inc  hl
    ld   (hl),$2E
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$70
    ld   hl,$815C
    ld   (hl),$11
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$80
    call $3CE0
    call $3E60
    call $3E60
    call $3E60
    add  a,b
    call $3E22
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,e
    and  $03
    ret  nz
    call $0618
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $1460
    ld   hl,$0E90
    call $01E3
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $0310
    rra
    nop
    ret  nz
    pop  bc
    jp   nz,$C4C3
    push bc
    add  a,$C7
    ret  z
    ret
    jp   z,$CCCB
    call $CFCE
    ret  nc
    pop  de
    jp   nc,$D4D3
    push de
    sub  $D7
    ret  c
    exx
    jp   c,$3AFF
    inc  b
    add  a,b
    and  a
    jr   nz,$3F3C
    ld   a,($8029)
    jr   $3F3F
    ld   a,($802A)
    ld   hl,$93BF
    call $3F55
    dec  a
    jr   z,$3F50
    ld   (hl),$DB
    ld   bc,$FFE0
    add  hl,bc
    jr   $3F42
    call $2AD0
    ret
    rst  $38
    push af
    push hl
    ld   e,$01
    push de
    call $13A0
    pop  de
    dec  e
    jr   nz,$3F59
    pop  hl
    pop  af
    ret
    rst  $38
    rst  $38
    call $0310
    inc  c
    ld   a,(bc)
    ld   a,(de)
    dec  d
    inc  h
    inc  hl
    rra
    ld   d,$24
    rst  $38
    ret
    call $0310
    inc  d
    rlca
    jr   nz,$3F9D
    rra
    dec  h
    inc  d
    inc  e
    add  hl,hl
    djnz $3FA2
    ld   ($2315),hl
    dec  d
    ld   e,$24
    rst  $38
    ret
    rst  $38
    rst  $38
    call $0310
    djnz $3F95
    adc  a,e
    ld   bc,$0809
    inc  bc
    rst  $38
    call $0310
    ld   (de),a
    inc  b
    ld   a,(de)
    dec  d
    inc  h
    inc  hl
    rra
    ld   d,$24
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    call $0310
    rra
    nop
    djnz $3FBF
    djnz $3FC1
    djnz $3FC3
    djnz $3FC5
    djnz $3FC7
    djnz $3FC9
    djnz $3FCB
    djnz $3FCD
    djnz $3FCF
    djnz $3FD1
    djnz $3FD3
    djnz $3FD5
    djnz $3FD7
    djnz $3FD9
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    nop
    call $17D0
    call $24EC
    call $38E0
    call $24EC
    call $17D0
    call $24EC
    call $38E0
    call $24EC
    call $17D0
    call $24EC
    call $38E0
    call $24EC
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   ($B001),a
    ld   a,($4040)
    nop
    nop
    nop
    ld   a,$FF
    ld   ($B800),a
    ld   sp,$83F0
    ld   a,($4040)
    nop
    nop
    nop
    call $0000
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $4050
    call $4258
    call $42E0
    call $4D74
    call $5020
    ret
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$C000
    call $5C81
    ret
    rst  $38
    call $4568
    ld   a,$8E
    ld   ($927A),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8140)
    scf
    ccf
    ld   hl,$8030
    sub  (hl)
    ret  c
    ld   b,a
    ld   a,($801D)
    add  a,b
    ld   ($801D),a
    ld   a,($8140)
    ld   ($8030),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$8C
    ld   ($918E),a
    ret
    rst  $38
    rst  $38
    ld   a,$8D
    ld   ($91D2),a
    ret
    rst  $38
    rst  $38
    ld   a,(ix+$05)
    and  a
    jr   z,$408B
    dec  a
    ld   (ix+$05),a
    ret
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ld   a,(ix+$02)
    and  a
    ret  z
    dec  a
    ld   (ix+$02),a
    add  a,$00
    ld   l,a
    ld   a,$08
    out  ($00),a
    ld   a,l
    out  ($01),a
    nop
    ret
    rst  $38
    ld   b,l
    xor  a
    sub  h
    and  $F8
    ld   l,a
    ld   h,$00
    add  hl,hl
    add  hl,hl
    ld   a,$90
    add  a,h
    ld   h,a
    ld   a,b
    srl  a
    srl  a
    srl  a
    add  a,l
    ld   l,a
    ret
    rst  $38
    ld   a,(ix+$05)
    and  a
    jr   z,$40CB
    dec  a
    ld   (ix+$05),a
    ret
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ld   a,(ix+$02)
    and  a
    ret  z
    dec  a
    ld   (ix+$02),a
    add  a,$00
    ld   l,a
    ld   a,$09
    out  ($00),a
    ld   a,l
    out  ($01),a
    nop
    ret
    rst  $38
    rst  $38
    ld   a,$8F
    ld   ($92EE),a
    ld   a,$8E
    ld   ($9217),a
    ret
    rst  $38
    ld   a,$03
    ld   ($8044),a
    ld   hl,$2980
    call $5C81
    ret
    ld   a,(ix+$05)
    and  a
    jr   z,$410B
    dec  a
    ld   (ix+$05),a
    ret
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ld   a,(ix+$02)
    and  a
    ret  z
    dec  a
    ld   (ix+$02),a
    add  a,$00
    ld   l,a
    ld   a,$0A
    out  ($00),a
    ld   a,l
    out  ($01),a
    nop
    ret
    rst  $38
    rst  $38
    ld   a,$8C
    ld   ($9217),a
    ld   a,$8D
    ld   ($9231),a
    ld   a,$8F
    ld   ($922B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   ($8066),a
    sla  a
    ld   hl,$4400
    add  a,l
    ld   l,a
    ld   a,$01
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$00
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$08
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret
    call $4577
    ld   a,$8E
    ld   ($92AB),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   ($8067),a
    sla  a
    ld   hl,$4400
    add  a,l
    ld   l,a
    ld   a,$03
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$02
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$09
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret
    ld   b,a
    ld   a,($801D)
    add  a,b
    ld   ($801D),a
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    ld   ($804C),hl
    ld   a,(hl)
    ld   ($804E),a
    ld   a,$90
    srl  b
    srl  b
    srl  b
    srl  b
    add  a,b
    ld   (hl),a
    ld   de,$FFE0
    add  hl,de
    ld   a,(hl)
    ld   ($804F),a
    ld   (hl),$9B
    ld   a,$40
    ld   ($8050),a
    jp   $40F4
    rst  $38
    rst  $38
    ld   a,($4100)
    ld   bc,$01E3
    push bc
    push hl
    ret
    ld   a,$9C
    ld   ($915A),a
    ret
    ld   a,$9D
    ld   ($915A),a
    ret
    ld   a,$9D
    ld   ($911A),a
    ret
    rst  $38
    rst  $38
    ld   ix,$82A0
    ld   a,(ix+$04)
    and  a
    jr   z,$4212
    call $4140
    ld   (ix+$04),$00
    ret
    call $4080
    ret
    ld   a,$9C
    ld   ($91B1),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ix,$82A8
    ld   a,(ix+$04)
    and  a
    jr   z,$4232
    call $4180
    ld   (ix+$04),$00
    ret
    call $40C0
    ret
    ld   a,$9C
    ld   ($918E),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ix,$82B0
    ld   a,(ix+$04)
    and  a
    jr   z,$4252
    call $42B0
    ld   (ix+$04),$00
    ret
    call $4100
    ret
    rst  $38
    rst  $38
    ld   a,($8140)
    add  a,$04
    ld   h,a
    ld   a,($8143)
    add  a,$18
    ld   l,a
    call $40A7
    ld   a,(hl)
    cp   $10
    ret  z
    cp   $8C
    jr   nz,$4277
    ld   a,$20
    ld   (hl),$10
    call $41B0
    ret
    cp   $8D
    jr   nz,$4283
    ld   a,$40
    ld   (hl),$10
    call $41B0
    ret
    cp   $8E
    jr   nz,$428F
    ld   a,$60
    ld   (hl),$10
    call $41B0
    ret
    cp   $8F
    ret  nz
    ld   a,$A0
    ld   (hl),$10
    call $41B0
    ret
    ld   a,$9D
    ld   ($91D2),a
    ret
    ld   a,$8E
    ld   ($90CB),a
    call $3602
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   ($8068),a
    sla  a
    ld   hl,$4400
    add  a,l
    ld   l,a
    ld   a,$05
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$04
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$0A
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret
    ld   a,($8050)
    and  a
    ret  z
    dec  a
    ld   ($8050),a
    and  a
    ret
    ld   hl,($804C)
    ld   a,$10
    nop
    ld   (hl),a
    ld   de,$FFE0
    add  hl,de
    ld   a,$10
    nop
    ld   (hl),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ret  p
    ld   (hl),b
    or   b
    jr   nc,$42D5
    ld   d,b
    sub  b
    djnz $42E9
    ld   h,b
    and  b
    jr   nz,$42CD
    ld   b,b
    add  a,b
    nop
    rst  $38
    rst  $38
    call $41F8
    ld   a,$9E
    ld   ($927A),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   l,(ix+$07)
    ld   h,(ix+$08)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    ld   iy,$82A0
    ld   (iy+$00),a
    inc  hl
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
    dec  b
    jr   z,$4340
    add  a,c
    jr   $433A
    dec  a
    ld   (ix+$12),a
    call $5200
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   l,(ix+$09)
    ld   h,(ix+$0a)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    ld   iy,$82A8
    ld   (iy+$00),a
    inc  hl
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
    dec  b
    jr   z,$4380
    add  a,c
    jr   $437A
    dec  a
    ld   (ix+$13),a
    call $5250
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret
    call $42A0
    ld   a,$9E
    ld   ($92AB),a
    ret
    rst  $38
    ld   l,(ix+$0b)
    ld   h,(ix+$0c)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    inc  hl
    ld   iy,$82B0
    ld   (iy+$00),a
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
    dec  b
    jr   z,$43C0
    add  a,c
    jr   $43BA
    dec  a
    ld   (ix+$14),a
    call $52A0
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$9F
    ld   ($92EE),a
    ld   a,$9E
    ld   ($9217),a
    ret
    rst  $38
    ld   a,$9C
    ld   ($9217),a
    ld   a,$9D
    ld   ($9231),a
    ld   a,$9F
    ld   ($922B),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    inc  h
    inc  bc
    or   $02
    call z,$A402
    ld   (bc),a
    ld   a,(hl)
    ld   (bc),a
    ld   e,d
    ld   (bc),a
    jr   c,$4411
    jr   $4413
    jp   m,$DE01
    ld   bc,$01C3
    xor  d
    ld   bc,$0192
    ld   a,e
    ld   bc,$0166
    ld   d,d
    ld   bc,$013F
    dec  l
    ld   bc,$011C
    inc  c
    ld   bc,$0000
    rst  $28
    nop
    jp   po,$D500
    nop
    ret
    nop
    cp   (hl)
    nop
    or   e
    nop
    xor  c
    nop
    and  b
    nop
    sub  (hl)
    nop
    adc  a,(hl)
    nop
    add  a,(hl)
    nop
    ld   a,a
    nop
    ld   a,b
    nop
    ld   (hl),c
    nop
    ld   l,e
    nop
    ld   h,h
    nop
    ld   e,a
    nop
    ld   e,c
    nop
    ld   d,h
    nop
    ld   d,b
    nop
    ld   c,e
    nop
    ld   b,a
    nop
    ld   b,e
    nop
    ccf
    nop
    inc  a
    nop
    jr   c,$445F
    dec  (hl)
    nop
    ld   ($2F00),a
    nop
    inc  l
    nop
    ld   hl,($2800)
    nop
    dec  h
    nop
    inc  hl
    nop
    ld   hl,$1F00
    nop
    ld   e,$00
    nop
    ld   bc,$0104
    rlca
    ld   bc,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$448F
    ld   a,($8029)
    jr   $4492
    ld   a,($802A)
    cp   $1B
    ret  nz
    ld   a,$74
    ld   ($91A9),a
    inc  a
    ld   ($91AA),a
    inc  a
    ld   ($91C9),a
    inc  a
    ld   ($91CA),a
    inc  a
    ld   ($91AB),a
    inc  a
    ld   ($91AC),a
    inc  a
    ld   ($91CB),a
    inc  a
    ld   ($91CC),a
    inc  a
    ld   ($918B),a
    inc  a
    ld   ($918C),a
    jr   $44E4
    djnz $44C3
    ld   (de),a
    inc  bc
    inc  d
    ld   bc,$0315
    rla
    ld   bc,$0319
    dec  de
    ld   bc,$031C
    rst  $38
    rst  $38
    inc  e
    ld   bc,$0300
    inc  e
    ld   bc,$0300
    inc  e
    ld   bc,$0300
    inc  e
    ld   bc,$0300
    rst  $38
    rst  $38
    inc  a
    ld   ($9189),a
    inc  a
    ld   ($918A),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$12)
    and  a
    jr   z,$450B
    dec  a
    ld   (ix+$12),a
    ret
    ld   l,(ix+$07)
    ld   h,(ix+$08)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,$4522
    ld   (ix+$07),l
    ld   (ix+$08),h
    call $4320
    ret
    ld   l,(ix+$01)
    ld   h,(ix+$02)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,$4552
    inc  hl
    ld   a,(hl)
    ld   c,a
    ld   b,$00
    scf
    ccf
    sbc  hl,bc
    ld   (ix+$01),l
    ld   (ix+$02),h
    ld   a,(hl)
    ld   (ix+$07),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$08),a
    ld   l,(ix+$07)
    ld   h,(ix+$08)
    ld   a,(hl)
    call $4320
    ret
    cp   $FF
    ret  z
    ld   (ix+$01),l
    ld   (ix+$02),h
    ld   (ix+$07),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$08),a
    call $4320
    ret
    rst  $38
    ld   a,$8D
    ld   ($911A),a
    ret
    rst  $38
    rst  $38
    ld   a,$8C
    ld   ($91B1),a
    ret
    rst  $38
    ld   a,$8E
    ld   ($90CB),a
    call $4070
    ret
    ld   a,(ix+$13)
    and  a
    jr   z,$458B
    dec  a
    ld   (ix+$13),a
    ret
    ld   l,(ix+$09)
    ld   h,(ix+$0a)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,$45A2
    ld   (ix+$09),l
    ld   (ix+$0a),h
    call $4360
    ret
    ld   l,(ix+$03)
    ld   h,(ix+$04)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,$45D2
    inc  hl
    ld   a,(hl)
    ld   c,a
    ld   b,$00
    scf
    ccf
    sbc  hl,bc
    ld   (ix+$03),l
    ld   (ix+$04),h
    ld   a,(hl)
    ld   (ix+$09),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0a),a
    ld   l,(ix+$09)
    ld   h,(ix+$0a)
    ld   a,(hl)
    call $4360
    ret
    cp   $FF
    ret  z
    ld   (ix+$03),l
    ld   (ix+$04),h
    ld   (ix+$09),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0a),a
    call $4360
    ret
    rst  $38
    ld   a,$8D
    ld   ($915A),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,(ix+$14)
    and  a
    jr   z,$460B
    dec  a
    ld   (ix+$14),a
    ret
    ld   l,(ix+$0b)
    ld   h,(ix+$0c)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,$4622
    ld   (ix+$0b),l
    ld   (ix+$0c),h
    call $43A0
    ret
    ld   l,(ix+$05)
    ld   h,(ix+$06)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,$4652
    inc  hl
    ld   a,(hl)
    ld   c,a
    ld   b,$00
    scf
    ccf
    sbc  hl,bc
    ld   (ix+$05),l
    ld   (ix+$06),h
    ld   a,(hl)
    ld   (ix+$0b),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0c),a
    ld   l,(ix+$0b)
    ld   h,(ix+$0c)
    ld   a,(hl)
    call $43A0
    ret
    cp   $FF
    ret  z
    ld   (ix+$05),l
    ld   (ix+$06),h
    ld   (ix+$0b),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0c),a
    call $43A0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ix,$82B8
    ld   a,(ix+$0d)
    and  a
    jr   z,$46A1
    call $4500
    ld   a,(ix+$0d)
    dec  a
    jr   z,$46A1
    call $4580
    ld   a,(ix+$0d)
    dec  a
    dec  a
    jr   z,$46A1
    call $4600
    ret
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    pop  hl
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$82B8
    ld   b,$18
    ld   (hl),$00
    inc  hl
    djnz $46C5
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $46C0
    ld   a,($8042)
    call $4730
    ld   ix,$82B8
    call $4790
    xor  a
    ld   ($8042),a
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8034)
    and  a
    ret  z
    ld   a,($8004)
    and  a
    jr   nz,$46F8
    ld   a,($8029)
    jr   $46FB
    ld   a,($802A)
    dec  a
    add  a,a
    add  a,a
    call $49B0
    ld   b,a
    ld   a,($8065)
    cp   b
    ret  z
    ld   a,b
    ld   ($8042),a
    ld   ($8065),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    halt
    dec  c
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    sla  a
    sla  a
    call $46B0
    nop
    nop
    nop
    ret
    ld   hl,$5D00
    ret
    ld   hl,$4C46
    ret
    ld   hl,$5053
    ret
    ld   hl,$50BC
    ret
    ld   hl,$50EC
    ret
    ld   hl,$519A
    ret
    ld   hl,$51EA
    ret
    ld   hl,$5514
    ret
    ld   hl,$5770
    ret
    ld   hl,$5560
    ret
    ld   hl,$5DEA
    ret
    ld   hl,$5E88
    ret
    ld   hl,$5F30
    ret
    ld   hl,$5F78
    ret
    ld   hl,$4B40
    ret
    ld   hl,$0000
    ret
    ld   hl,$0000
    ret
    ld   hl,$0000
    ret
    ld   hl,$0000
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    nop
    nop
    ld   a,(hl)
    ld   (ix+$0d),a
    ld   b,a
    inc  hl
    ld   a,(hl)
    ld   (ix+$01),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$02),a
    dec  b
    jr   z,$47BD
    inc  hl
    ld   a,(hl)
    ld   (ix+$03),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$04),a
    dec  b
    jr   z,$47BD
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$06),a
    ld   h,(ix+$02)
    ld   l,(ix+$01)
    ld   a,(hl)
    ld   (ix+$0e),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0f),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$10),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$11),a
    ld   (ix+$12),$00
    ld   (ix+$13),$00
    ld   (ix+$14),$00
    inc  hl
    ld   (ix+$01),l
    ld   (ix+$02),h
    ld   a,(hl)
    ld   (ix+$07),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$08),a
    ld   l,(ix+$03)
    ld   h,(ix+$04)
    ld   a,(hl)
    ld   (ix+$09),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0a),a
    ld   l,(ix+$05)
    ld   h,(ix+$04)
    ld   a,(hl)
    ld   (ix+$0b),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0c),a
    call $4320
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call $4360
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call $43A0
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8042)
    and  a
    jr   nz,$484B
    call $4680
    jr   $484E
    call $46D0
    ld   a,($8043)
    and  a
    jr   nz,$4859
    call $48E0
    jr   $485C
    call $4920
    ld   a,($8044)
    and  a
    jr   nz,$4867
    call $487C
    jr   $486A
    call $489C
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$82E8
    ld   b,$18
    ld   (hl),$00
    inc  hl
    djnz $4875
    ret
    rst  $38
    ld   ix,$82E8
    ld   a,(ix+$0d)
    and  a
    ret  z
    call $4600
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call $4500
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call $4580
    ret
    rst  $38
    rst  $38
    call $4870
    ld   a,($8044)
    call $4730
    ld   ix,$82E8
    call $4790
    xor  a
    ld   ($8044),a
    ret
    rst  $38
    call $4B50
    call $5AA8
    call $5AA8
    call $5AA8
    call $5AA8
    ld   hl,$1470
    call $5C81
    call $5AA8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ix,$82D0
    ld   a,(ix+$0d)
    and  a
    ret  z
    call $4580
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call $4600
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call $4500
    ret
    rst  $38
    rst  $38
    exx
    pop  hl
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    exx
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$82D0
    ld   b,$18
    ld   (hl),$00
    inc  hl
    djnz $4915
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $4910
    ld   a,($8043)
    call $4730
    ld   ix,$82D0
    call $4790
    xor  a
    ld   ($8043),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    ld   c,$00
    bit  0,a
    jr   z,$494A
    set  5,b
    bit  1,a
    jr   z,$4950
    set  4,b
    bit  2,a
    jr   z,$4956
    set  7,c
    bit  3,a
    jr   z,$495C
    set  6,c
    bit  4,a
    jr   z,$4962
    set  5,c
    bit  5,a
    jr   z,$4968
    set  4,c
    bit  6,a
    jr   z,$496E
    set  3,c
    bit  7,a
    jr   z,$4974
    set  2,c
    ld   a,b
    nop
    nop
    nop
    ld   a,c
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    nop
    nop
    ld   c,$F0
    bit  0,a
    jr   z,$498A
    res  7,c
    bit  1,a
    jr   z,$4990
    res  6,c
    bit  2,a
    jr   z,$4996
    res  5,c
    bit  3,a
    jr   z,$499C
    res  4,c
    ld   a,c
    add  a,b
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $46B0
    ld   a,$0E
    ret
    nop
    ld   a,$0E
    ret
    nop
    ld   a,$0E
    ret
    nop
    ld   a,$0E
    ret
    nop
    ld   a,$0E
    ret
    nop
    ld   a,$0E
    ret
    nop
    ld   a,$0D
    ret
    nop
    ld   a,$01
    ret
    nop
    ld   a,$01
    ret
    nop
    ld   a,$01
    ret
    nop
    ld   a,$01
    ret
    nop
    ld   a,$01
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0B
    ret
    nop
    ld   a,$0D
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0C
    ret
    nop
    ld   a,$0E
    ret
    nop
    rst  $38
    dec  d
    ld   bc,$0117
    add  hl,de
    ld   bc,$021A
    ld   a,(de)
    ld   (bc),a
    jr   $4A2E
    jr   $4A30
    rla
    ld   (bc),a
    rla
    ld   (bc),a
    ld   d,$02
    ld   d,$02
    dec  d
    ld   (bc),a
    dec  d
    ld   (bc),a
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    ld   (de),a
    ld   bc,$010E
    djnz $4A45
    ld   c,$02
    rst  $38
    rst  $38
    dec  d
    ld   bc,$0117
    add  hl,de
    ld   bc,$0121
    ld   h,$02
    ld   hl,$2601
    ld   (bc),a
    ld   hl,$2002
    ld   bc,$0226
    jr   nz,$4A5F
    ld   h,$02
    jr   nz,$4A64
    rra
    ld   bc,$0226
    rra
    ld   bc,$0226
    rra
    ld   (bc),a
    ld   e,$01
    rra
    ld   bc,$0120
    ld   hl,$FF02
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  de
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    jr   $4A8A
    rla
    ld   (bc),a
    jr   $4A8E
    ld   a,(de)
    ld   (bc),a
    inc  e
    ld   (bc),a
    ld   a,(de)
    ld   a,(bc)
    rst  $38
    rst  $38
    rra
    ld   (bc),a
    ld   e,$02
    inc  e
    inc  b
    ld   a,(de)
    ld   (bc),a
    jr   $4AA0
    rla
    inc  b
    dec  d
    ld   (bc),a
    inc  de
    ld   (bc),a
    dec  d
    ld   (bc),a
    rla
    ld   a,(bc)
    rst  $38
    rst  $38
    inc  hl
    ld   (bc),a
    ld   hl,$1F02
    ld   (bc),a
    ld   e,$02
    inc  e
    ld   (bc),a
    ld   a,(de)
    ld   (bc),a
    jr   $4ABA
    rla
    ld   (bc),a
    dec  d
    ld   (bc),a
    inc  de
    ld   (bc),a
    ld   (de),a
    ld   (bc),a
    inc  de
    ld   a,(bc)
    rst  $38
    rst  $38
    dec  d
    inc  bc
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    rla
    inc  b
    rla
    inc  b
    ld   a,(de)
    ex   af,af'
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    add  hl,de
    inc  b
    add  hl,de
    inc  b
    ld   a,(de)
    dec  b
    rst  $38
    rst  $38
    dec  d
    inc  bc
    dec  d
    ld   (bc),a
    dec  d
    ld   (bc),a
    dec  d
    ld   (bc),a
    dec  d
    ld   (bc),a
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    djnz $4AF6
    djnz $4AF8
    djnz $4AFA
    djnz $4AFC
    ld   c,$02
    ld   c,$02
    add  hl,bc
    ld   (bc),a
    add  hl,bc
    ld   bc,$0209
    rst  $38
    rst  $38
    dec  d
    jr   nz,$4B08
    rst  $38
    rst  $38
    rst  $38
    dec  d
    ld   bc,$021A
    dec  d
    ld   bc,$021A
    dec  d
    ld   (bc),a
    inc  d
    ld   bc,$021A
    inc  d
    ld   bc,$021A
    inc  d
    ld   (bc),a
    inc  de
    ld   bc,$021A
    inc  de
    ld   bc,$021A
    inc  de
    ld   (bc),a
    ld   (de),a
    ld   (bc),a
    add  hl,bc
    ld   (bc),a
    ld   c,$02
    rst  $38
    rst  $38
    ld   bc,$0F05
    nop
    inc  c
    ld   c,e
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,b
    ld   c,e
    rst  $38
    rst  $38
    inc  bc
    ld   ($364B),a
    ld   c,e
    ld   (hl),$4B
    rst  $38
    nop
    ld   bc,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$8140
    ld   (hl),$85
    inc  hl
    ld   (hl),$2C
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$90
    inc  hl
    ld   (hl),$7E
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$A0
    inc  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$04
    ld   c,$02
    inc  c
    ld   (bc),a
    ld   c,$04
    ld   de,$1002
    ld   (bc),a
    ld   c,$02
    ld   c,$02
    inc  c
    ld   (bc),a
    ld   c,$10
    rst  $38
    rst  $38
    add  hl,bc
    inc  b
    rlca
    ld   (bc),a
    add  hl,bc
    inc  b
    ld   a,(de)
    ld   (bc),a
    jr   $4C02
    jr   $4C04
    add  hl,bc
    ld   (bc),a
    add  hl,bc
    ld   (bc),a
    rlca
    ld   (bc),a
    add  hl,bc
    inc  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   ($FF4C),a
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F04
    nop
    ret  po
    ld   c,e
    rst  $38
    rst  $38
    or   $4B
    rst  $38
    rst  $38
    inc  c
    inc  c
    rst  $38
    rst  $38
    inc  bc
    ld   (hl),$4C
    ld   a,$4C
    jr   nc,$4C99
    rst  $38
    rst  $38
    rst  $38
    call $4484
    ld   a,($8004)
    and  a
    jr   z,$4C5E
    ld   a,($802A)
    jr   $4C61
    ld   a,($8029)
    dec  a
    add  a,a
    add  a,a
    call $4900
    call $4CE3
    ret
    call $45E8
    ret
    call $4568
    ret
    call $4CE3
    ret
    call $4570
    ret
    call $4070
    ret
    call $4078
    ret
    call $45E8
    ret
    call $4568
    ret
    call $4570
    ret
    call $4577
    ret
    call $4078
    ret
    call $4CE3
    ret
    call $4040
    ret
    call $45E8
    ret
    call $40E8
    ret
    call $4078
    ret
    call $45E8
    ret
    call $40E8
    ret
    call $4078
    ret
    call $4128
    ret
    call $4577
    ret
    call $4078
    ret
    call $4128
    ret
    call $4170
    ret
    call $4078
    ret
    nop
    nop
    nop
    ret
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$8C
    ld   ($915A),a
    ret
    rst  $38
    ld   a,($814C)
    sub  $84
    scf
    ccf
    sub  $18
    ret  nc
    ld   a,($814F)
    srl  a
    srl  a
    srl  a
    ld   b,a
    ld   a,l
    and  $1F
    sub  b
    scf
    ccf
    jp   $4DB4
    rst  $38
    call $4D60
    push hl
    dec  hl
    ld   (hl),$10
    inc  hl
    ld   (hl),$76
    inc  hl
    ld   (hl),$77
    inc  hl
    ld   (hl),$7A
    inc  hl
    ld   (hl),$7B
    ld   bc,$FFDC
    add  hl,bc
    ld   (hl),$10
    inc  hl
    ld   (hl),$74
    inc  hl
    ld   (hl),$75
    inc  hl
    ld   (hl),$78
    inc  hl
    ld   (hl),$79
    add  hl,bc
    ld   (hl),$10
    inc  hl
    ld   (hl),$7E
    inc  hl
    ld   (hl),$7F
    inc  hl
    ld   (hl),$7C
    inc  hl
    ld   (hl),$7D
    pop  hl
    ret
    rst  $38
    rst  $38
    call $4E75
    call $4D08
    push hl
    ld   hl,$13A0
    call $5C81
    ld   a,($8312)
    and  $03
    jr   nz,$4D47
    pop  hl
    inc  hl
    call $4CEA
    ld   a,$DC
    cp   l
    ret  z
    jr   $4D43
    rst  $38
    xor  a
    ld   ($8126),a
    ld   ($8128),a
    ld   ($812A),a
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$4D7F
    ld   a,($8029)
    jr   $4D82
    ld   a,($802A)
    cp   $1B
    ret  nz
    call $4D90
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8051)
    and  a
    ret  nz
    ld   a,($8140)
    sub  $70
    scf
    ccf
    sub  $20
    ret  nc
    ld   a,($8143)
    sub  $30
    scf
    ccf
    sub  $1C
    ret  nc
    ld   a,$01
    ld   ($8051),a
    call $4D40
    ret
    rst  $38
    rst  $38
    sub  $02
    ret  nc
    jp   $4DD0
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   l,$40
    push hl
    ld   hl,$13A0
    call $5C81
    pop  hl
    dec  l
    jr   nz,$4DC2
    ret
    rst  $38
    rst  $38
    xor  a
    ld   ($814C),a
    ld   ($8150),a
    call $4D08
    push hl
    ld   hl,$13A0
    call $5C81
    pop  hl
    inc  hl
    ld   a,$DC
    cp   l
    jr   nz,$4DD7
    ld   a,$91
    ld   ($814C),a
    ld   a,$38
    ld   ($814D),a
    ld   a,$12
    ld   ($814E),a
    ld   a,$D7
    ld   ($814F),a
    ld   a,$8A
    ld   ($8150),a
    ld   a,$39
    ld   ($8151),a
    ld   a,$12
    ld   ($8152),a
    ld   a,$E7
    ld   ($8153),a
    call $4DC0
    call $4EE0
    ld   hl,$3D48
    call $5C81
    ret
    rst  $38
    rst  $38
    rst  $38
    call $4E80
    call $5C81
    call $5AA8
    ld   hl,$3F74
    call $5C81
    call $5AA8
    ld   hl,$164B
    call $5C81
    ld   a,$07
    ld   ($8029),a
    ld   ($802A),a
    ld   hl,$12B8
    call $5C81
    ld   hl,$3FA8
    call $5C81
    ld   hl,$9248
    ld   b,$A0
    ld   c,$05
    ld   (hl),b
    inc  b
    inc  hl
    ld   (hl),b
    inc  b
    ld   de,$001F
    add  hl,de
    ld   (hl),b
    inc  b
    inc  hl
    ld   (hl),b
    ld   de,$FFA1
    add  hl,de
    inc  b
    call $4ED4
    dec  c
    jr   nz,$4E53
    ld   hl,$3F8C
    call $5C81
    jp   $52E2
    rst  $38
    push af
    ld   a,$05
    ld   ($8044),a
    pop  af
    ld   hl,$91C9
    ret
    ld   hl,$0F88
    call $5C81
    ld   hl,$3F66
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,$F9
    nop
    nop
    nop
    ld   a,$FD
    nop
    nop
    nop
    ld   a,$FB
    nop
    nop
    nop
    ld   a,$FF
    nop
    nop
    nop
    ret
    ld   a,b
    call $4900
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $4EC2
    call $4EC2
    call $4EC2
    call $4EC2
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   d,$0E
    push hl
    push bc
    push de
    ld   hl,$2128
    call $5C81
    pop  de
    pop  bc
    pop  hl
    dec  d
    jr   nz,$4EC4
    ret
    call $4EC2
    call $4EC2
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8004)
    and  a
    jr   nz,$4EEB
    ld   hl,$805B
    jr   $4EEE
    ld   hl,$805C
    ld   a,(hl)
    cp   $1F
    jr   nz,$4EF6
    ld   (hl),$10
    ret
    cp   $10
    jr   nz,$4EFD
    ld   (hl),$0D
    ret
    jp   $501C
    sub  c
    ld   e,d
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   a,(de)
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    or   c
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    adc  a,(hl)
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   a,(de)
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  c
    or   c
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  b
    res  1,(hl)
    sub  c
    adc  a,(hl)
    adc  a,h
    nop
    nop
    nop
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,h
    nop
    nop
    nop
    nop
    nop
    nop
    sub  d
    ld   a,d
    adc  a,(hl)
    sub  c
    ld   a,(de)
    adc  a,l
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  d
    xor  $83
    sub  d
    rla
    adc  a,(hl)
    nop
    nop
    nop
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    sub  c
    ld   e,d
    adc  a,l
    nop
    nop
    nop
    nop
    nop
    nop
    sub  d
    xor  $83
    sub  d
    rla
    adc  a,(hl)
    nop
    nop
    nop
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    sub  d
    rla
    adc  a,h
    sub  d
    ld   sp,$928D
    dec  hl
    adc  a,a
    sub  b
    res  1,(hl)
    sub  c
    adc  a,(hl)
    adc  a,h
    nop
    nop
    nop
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    sub  d
    rla
    adc  a,h
    sub  d
    ld   sp,$928D
    dec  hl
    adc  a,a
    sub  b
    res  1,(hl)
    sub  c
    adc  a,(hl)
    adc  a,h
    sub  d
    xor  e
    adc  a,(hl)
    sub  c
    jp   nc,$008D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst  $38
    rst  $38
    ld   b,(hl)
    inc  hl
    ld   c,(hl)
    inc  hl
    ld   a,(bc)
    cp   $10
    jr   z,$501A
    ld   e,a
    and  $F0
    cp   $80
    jr   nz,$5016
    ld   a,e
    add  a,$10
    ld   (bc),a
    jr   $501A
    ld   a,e
    sub  $10
    ld   (bc),a
    inc  hl
    ret
    dec  a
    dec  a
    ld   (hl),a
    ret
    ld   a,($8312)
    and  $03
    ret  nz
    ld   hl,$4F00
    ld   a,($8004)
    and  a
    jr   z,$5034
    ld   a,($802A)
    jr   $5037
    ld   a,($8029)
    dec  a
    ld   b,a
    add  a,a
    add  a,a
    add  a,a
    add  a,b
    add  a,l
    ld   l,a
    ld   a,(hl)
    and  a
    ret  z
    call $5000
    ld   a,(hl)
    and  a
    ret  z
    call $5000
    ld   a,(hl)
    and  a
    ret  z
    call $5000
    ret
    rst  $38
    inc  bc
    add  a,h
    ld   d,b
    sub  b
    ld   d,b
    adc  a,h
    ld   d,b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  c
    ld   bc,$010E
    djnz $5067
    ld   de,$1301
    inc  bc
    rst  $38
    rst  $38
    inc  de
    ld   bc,$0115
    rla
    ld   bc,$0118
    ld   a,(de)
    inc  bc
    rst  $38
    rst  $38
    jr   $507B
    ld   a,(de)
    ld   bc,$011C
    dec  e
    ld   bc,$031F
    rst  $38
    rst  $38
    ld   (bc),a
    ld   (bc),a
    rrca
    djnz $50E9
    ld   d,b
    rst  $38
    rst  $38
    ld   l,(hl)
    ld   d,b
    rst  $38
    rst  $38
    ld   l,h
    ld   d,b
    rst  $38
    rst  $38
    nop
    ld   bc,$0102
    inc  b
    ld   bc,$0106
    ex   af,af'
    ld   bc,$010A
    inc  c
    ld   bc,$010E
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F01
    nop
    sub  h
    ld   d,b
    rst  $38
    rst  $38
    sub  h
    djnz $50BA
    rst  $38
    inc  bc
    or   b
    ld   d,b
    ret  z
    ld   d,b
    ret  z
    ld   d,b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  h
    ld   d,b
    rst  $38
    rst  $38
    jr   $50CF
    rla
    ld   bc,$0115
    inc  de
    ld   bc,$0111
    djnz $50D9
    ld   c,$01
    inc  c
    ld   bc,$010B
    add  hl,bc
    ld   bc,$0107
    dec  b
    ld   bc,$0104
    ld   (bc),a
    ld   bc,$0100
    rst  $38
    rst  $38
    inc  bc
    call p,$F450
    ld   d,c
    call p,$FF51
    inc  bc
    inc  bc
    rrca
    djnz $50C5
    ld   d,b
    rst  $38
    rst  $38
    dec  hl
    ld   (bc),a
    inc  (hl)
    ld   (bc),a
    inc  (hl)
    ld   (bc),a
    inc  (hl)
    ld   (bc),a
    ld   ($3401),a
    ld   bc,$0132
    jr   nc,$510D
    cpl
    ld   bc,$012D
    dec  hl
    ld   (bc),a
    dec  l
    ld   (bc),a
    dec  l
    ld   (bc),a
    ld   ($3401),a
    ld   bc,$0226
    rst  $38
    rst  $38
    scf
    ld   (bc),a
    cpl
    ld   (bc),a
    ld   ($FF04),a
    rst  $38
    dec  hl
    ld   bc,$0126
    inc  hl
    ld   bc,$0126
    rra
    inc  b
    rst  $38
    rst  $38
    inc  c
    ld   bc,$0110
    inc  de
    ld   bc,$0110
    inc  c
    ld   bc,$010C
    ld   c,$01
    djnz $5143
    dec  bc
    ld   bc,$010C
    dec  bc
    ld   bc,$0109
    rlca
    ld   bc,$0107
    add  hl,bc
    ld   bc,$010B
    add  hl,bc
    ld   bc,$010B
    add  hl,bc
    ld   bc,$0107
    ld   b,$01
    ld   b,$01
    rlca
    ld   bc,$0109
    rst  $38
    rst  $38
    rlca
    ld   bc,$0107
    dec  bc
    ld   bc,$010C
    ld   c,$01
    rlca
    ld   bc,$010B
    ld   c,$01
    rst  $38
    rst  $38
    rlca
    ld   bc,$010C
    dec  bc
    ld   bc,$0109
    rlca
    inc  b
    rst  $38
    rst  $38
    ld   bc,$0F08
    nop
    ld   ($1E51),a
    ld   d,c
    call m,$2650
    ld   d,c
    call m,$1E50
    ld   d,c
    call m,$2650
    ld   d,c
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   (bc),a
    add  a,d
    ld   d,c
    xor  b
    ld   d,c
    xor  b
    ld   d,c
    rst  $38
    rst  $38
    sbc  a,b
    ld   de,$FFFF
    rst  $38
    call m,$6450
    ld   d,c
    ld   ($7651),a
    ld   d,c
    ld   ($6451),a
    ld   d,c
    ld   ($7651),a
    ld   d,c
    rst  $38
    rst  $38
    inc  c
    ld   (bc),a
    jr   $51C0
    inc  c
    ld   (bc),a
    jr   $51C4
    inc  c
    ld   (bc),a
    jr   $51C8
    inc  c
    ld   (bc),a
    jr   $51CC
    inc  c
    ld   (bc),a
    jr   $51D0
    inc  c
    ld   (bc),a
    jr   $51D4
    inc  c
    ld   (bc),a
    jr   $51D8
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    inc  bc
    rrca
    djnz $5199
    ld   d,c
    rst  $38
    rst  $38
    jp   z,$FF11
    rst  $38
    ret  m
    ld   d,c
    rst  $38
    rst  $38
    inc  bc
    jp   c,$E651
    ld   d,c
    call p,$FF51
    rst  $38
    rst  $38
    ret  m
    ld   d,c
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,$520F
    ld   a,$02
    ld   ($8055),a
    jr   $5225
    ld   a,($8055)
    and  a
    jr   z,$5225
    dec  a
    ld   ($8055),a
    ld   a,($8052)
    and  a
    jr   z,$5223
    dec  a
    ld   ($8052),a
    pop  hl
    ret
    ld   a,l
    cp   $D0
    jr   nz,$5231
    ld   a,$02
    ld   ($8052),a
    jr   $523D
    ld   a,($8052)
    and  a
    jr   z,$523D
    dec  a
    ld   ($8052),a
    pop  hl
    ret
    ld   a,(ix+$10)
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,$525F
    ld   a,$02
    ld   ($8056),a
    jr   $5275
    ld   a,($8056)
    and  a
    jr   z,$5275
    dec  a
    ld   ($8056),a
    ld   a,($8053)
    and  a
    jr   z,$5273
    dec  a
    ld   ($8053),a
    pop  hl
    ret
    ld   a,l
    cp   $D0
    jr   nz,$5281
    ld   a,$02
    ld   ($8053),a
    jr   $528D
    ld   a,($8053)
    and  a
    jr   z,$528D
    dec  a
    ld   ($8053),a
    pop  hl
    ret
    ld   a,(ix+$10)
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,$52AF
    ld   a,$02
    ld   ($8057),a
    jr   $52C5
    ld   a,($8057)
    and  a
    jr   z,$52C5
    dec  a
    ld   ($8057),a
    ld   a,($8054)
    and  a
    jr   z,$52C3
    dec  a
    ld   ($8054),a
    pop  hl
    ret
    ld   a,l
    cp   $D0
    jr   nz,$52D1
    ld   a,$02
    ld   ($8054),a
    jr   $52DD
    ld   a,($8054)
    and  a
    jr   z,$52DD
    dec  a
    ld   ($8054),a
    pop  hl
    ret
    ld   a,(ix+$10)
    ret
    rst  $38
    call $4EB0
    ld   hl,$8140
    ld   (hl),$D8
    inc  hl
    ld   (hl),$8D
    inc  hl
    ld   (hl),$11
    inc  hl
    ld   (hl),$E0
    inc  hl
    ld   (hl),$D8
    inc  hl
    ld   (hl),$8D
    inc  hl
    ld   (hl),$11
    inc  hl
    ld   (hl),$F0
    ld   e,$06
    call $5328
    dec  e
    jr   nz,$5301
    ld   hl,$8148
    ld   (hl),$20
    inc  hl
    ld   (hl),$2D
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$28
    inc  hl
    ld   (hl),$19
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$38
    call $53AC
    jp   $5428
    rst  $38
    ld   d,$00
    ld   hl,$5380
    ld   a,d
    add  a,a
    add  a,a
    add  a,l
    ld   l,a
    ld   ix,$8140
    ld   a,(hl)
    ld   (ix+$01),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a
    inc  hl
    ld   a,(hl)
    add  a,(ix+$00)
    ld   (ix+$00),a
    ld   (ix+$04),a
    inc  hl
    ld   a,(hl)
    add  a,(ix+$03)
    ld   (ix+$03),a
    sub  $10
    ld   (ix+$07),a
    push de
    ld   hl,$2128
    call $5C81
    ld   hl,$2128
    call $5C81
    ld   hl,$2128
    call $5C81
    pop  de
    inc  d
    ld   a,d
    cp   $06
    jr   nz,$532A
    call $4ED4
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    adc  a,l
    adc  a,h
    call m,$8FF4
    adc  a,(hl)
    call m,$91F6
    sub  b
    call m,$96F8
    sub  d
    call m,$94F8
    sub  e
    call m,$8D06
    adc  a,h
    call m,$3A08
    ld   c,c
    add  a,c
    cp   $2D
    jr   nz,$53A6
    ld   a,$2C
    ld   ($8149),a
    jr   $53AB
    ld   a,$2D
    ld   ($8149),a
    ret
    ld   e,$06
    call $53B8
    call $5398
    dec  e
    jr   nz,$53AE
    ret
    ld   d,$00
    ld   hl,$5408
    ld   a,d
    add  a,a
    add  a,a
    add  a,l
    ld   l,a
    ld   ix,$8140
    ld   a,(hl)
    ld   (ix+$01),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a
    inc  hl
    ld   a,(hl)
    add  a,(ix+$00)
    ld   (ix+$00),a
    ld   (ix+$04),a
    inc  hl
    ld   a,(hl)
    add  a,(ix+$03)
    ld   (ix+$03),a
    sub  $10
    ld   (ix+$07),a
    push de
    ld   hl,$2128
    call $5C81
    ld   hl,$2128
    call $5C81
    ld   hl,$2128
    call $5C81
    pop  de
    inc  d
    ld   a,d
    cp   $06
    jr   nz,$53BA
    call $4EC2
    ret
    rst  $38
    rst  $38
    rst  $38
    dec  c
    inc  c
    inc  b
    ret  m
    rrca
    ld   c,$04
    nop
    ld   de,$0410
    ex   af,af'
    ld   d,$12
    inc  b
    ex   af,af'
    inc  d
    inc  de
    inc  b
    ex   af,af'
    dec  c
    inc  c
    inc  b
    ex   af,af'
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$15D0
    call $5C81
    ret
    rst  $38
    ld   hl,$9224
    call $4D08
    push hl
    call $54C2
    nop
    nop
    nop
    pop  hl
    inc  hl
    ld   a,$39
    cp   l
    jr   nz,$5433
    ld   a,$38
    ld   ($8141),a
    inc  a
    ld   ($8145),a
    ret
    rst  $38
    rst  $38
    ld   ix,$8140
    ld   a,$79
    cp   (ix+$00)
    ret  z
    inc  (ix+$00)
    inc  (ix+$04)
    ld   a,($8312)
    and  $03
    jr   nz,$548B
    ld   a,(ix+$05)
    inc  a
    cp   $33
    jr   nz,$5471
    ld   a,$31
    ld   (ix+$05),a
    ld   a,($8312)
    and  $0F
    cp   $05
    jr   nz,$5483
    ld   (ix+$01),$2C
    jr   $548B
    cp   $08
    jr   nz,$548B
    ld   (ix+$01),$2D
    call $54C2
    nop
    nop
    nop
    jr   $5450
    rst  $38
    ld   hl,$8140
    ld   (hl),$07
    inc  hl
    ld   (hl),$2D
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$BF
    inc  hl
    ld   (hl),$00
    inc  hl
    ld   (hl),$30
    inc  hl
    ld   (hl),$12
    inc  hl
    ld   (hl),$CF
    ld   hl,$9224
    call $4D08
    call $5450
    call $54D8
    call $5430
    call $54D8
    ret
    rst  $38
    ld   a,($8312)
    and  $03
    jr   nz,$54CF
    ld   hl,$1564
    call $5C81
    ld   hl,$2128
    call $5C81
    ret
    rst  $38
    rst  $38
    ld   e,$20
    push de
    call $54C2
    pop  de
    dec  e
    jr   nz,$54DA
    ret
    rst  $38
    dec  l
    ld   (bc),a
    dec  l
    ld   bc,$012D
    dec  l
    ld   (bc),a
    ld   hl,($2D02)
    ld   (bc),a
    ld   ($FF04),a
    rst  $38
    ld   hl,$2102
    ld   bc,$0121
    ld   hl,$1E02
    ld   (bc),a
    ld   hl,$2602
    inc  b
    rst  $38
    rst  $38
    ld   bc,$0F03
    nop
    call po,$FF54
    rst  $38
    call p,$FF54
    rst  $38
    ld   l,h
    ld   d,l
    rst  $38
    rst  $38
    inc  bc
    inc  b
    ld   d,l
    ex   af,af'
    ld   d,l
    ex   af,af'
    ld   d,l
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    xor  a
    ld   ($8046),a
    ld   a,($82A5)
    and  a
    jr   nz,$552F
    ld   a,$F9
    nop
    nop
    nop
    ld   a,($82AD)
    and  a
    jr   nz,$553A
    ld   a,$FD
    nop
    nop
    nop
    ld   a,($82B5)
    and  a
    jr   nz,$5545
    ld   a,$FB
    nop
    nop
    nop
    ld   a,$FF
    nop
    nop
    nop
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    djnz $5553
    dec  bc
    ld   bc,$0108
    rst  $38
    rst  $38
    inc  b
    inc  b
    rrca
    djnz $55AD
    ld   d,l
    rst  $38
    rst  $38
    inc  bc
    ld   e,b
    ld   d,l
    ld   e,h
    ld   d,l
    ld   e,h
    ld   d,l
    rst  $38
    ld   l,d
    ld   d,l
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($B800)
    ld   hl,$9040
    pop  bc
    ld   a,(bc)
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc)
    ld   e,a
    ld   a,$1B
    sub  e
    ld   e,a
    ld   d,$00
    sla  e
    sla  e
    sla  e
    add  hl,de
    add  hl,de
    add  hl,de
    add  hl,de
    inc  bc
    ld   a,(bc)
    inc  bc
    cp   $FF
    jr   nz,$5596
    push bc
    ret
    ld   (hl),a
    ld   d,$FF
    ld   e,$E0
    add  hl,de
    jr   $558E
    rst  $38
    rst  $38
    ld   hl,$1470
    call $5C81
    call $56D0
    nop
    nop
    nop
    call $5AA8
    call $5570
    ex   af,af'
    dec  bc
    ld   (de),a
    dec  d
    daa
    ld   de,$1522
    rst  $38
    call $5AA8
    call $5570
    inc  c
    dec  b
    add  hl,hl
    rra
    dec  h
    ld   ($1210),hl
    dec  d
    add  hl,de
    ld   e,$17
    djnz $55E2
    jr   $55E2
    inc  hl
    dec  d
    inc  d
    rst  $38
    call $5AA8
    call $5570
    djnz $55E4
    ld   (de),a
    add  hl,hl
    djnz $55F2
    djnz $55F7
    add  hl,de
    ld   e,$1F
    inc  hl
    ld   de,$2225
    rst  $38
    jp   $48B2
    rst  $38
    rst  $38
    and  c
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $FF02
    rst  $38
    rst  $38
    rst  $38
    nop
    ld   (bc),a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$0E
    rst  $38
    rst  $38
    ret  po
    dec  d
    rst  $38
    rst  $38
    ld   b,h
    dec  d
    ld   c,b
    dec  d
    ld   c,b
    dec  d
    and  b
    dec  d
    and  b
    dec  d
    xor  $09
    rst  $38
    rst  $38
    ld   (hl),b
    jr   $5695
    jr   $5657
    rla
    or   b
    jr   $5619
    dec  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$02
    inc  de
    inc  b
    inc  de
    inc  b
    inc  de
    ld   (bc),a
    inc  de
    ld   b,$1A
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    ld   (bc),a
    ld   e,$06
    inc  e
    inc  b
    ld   e,$02
    inc  e
    ld   (bc),a
    ld   a,(de)
    ld   b,$17
    inc  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  de
    ld   (bc),a
    rla
    ld   (bc),a
    jr   $5658
    ld   a,(de)
    ld   (bc),a
    ld   a,(de)
    inc  b
    ld   a,(de)
    inc  b
    ld   a,(de)
    ld   b,$1A
    ld   (bc),a
    jr   $5668
    jr   $5668
    jr   $5668
    jr   $566A
    jr   $566C
    rla
    ld   (bc),a
    rla
    ld   (bc),a
    inc  de
    inc  b
    rla
    inc  b
    jr   $5676
    ld   c,$02
    rst  $38
    rst  $38
    add  hl,bc
    ld   (bc),a
    dec  bc
    inc  b
    dec  bc
    inc  b
    dec  bc
    ld   (bc),a
    inc  c
    ld   b,$15
    inc  b
    dec  d
    inc  b
    dec  d
    ld   (bc),a
    ld   a,(de)
    ld   b,$18
    inc  b
    ld   a,(de)
    ld   (bc),a
    jr   $5692
    dec  d
    ld   b,$13
    inc  b
    rst  $38
    rst  $38
    ld   c,$02
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    dec  d
    ld   (bc),a
    dec  d
    inc  b
    dec  d
    inc  b
    dec  d
    ld   b,$15
    ld   (bc),a
    inc  de
    ld   b,$13
    inc  b
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    inc  de
    ld   (bc),a
    ld   c,$04
    inc  de
    inc  b
    inc  de
    ld   (bc),a
    dec  d
    ld   (bc),a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    dec  b
    dec  b
    inc  c
    nop
    inc  c
    ld   d,$30
    ld   d,$30
    ld   d,$50
    ld   d,$50
    ld   d,$EE
    add  hl,bc
    ld   a,$01
    call $5AD8
    ld   hl,$0F88
    call $4C81
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ret  nz
    ld   d,$A0
    jr   $5708
    ld   d,$FF
    call $46C0
    call $4870
    call $4910
    call $5520
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   (de),a
    ld   bc,$010E
    ld   (de),a
    ld   bc,$010E
    djnz $5703
    dec  c
    ld   bc,$0110
    dec  c
    ld   bc,$010E
    dec  bc
    ld   bc,$010E
    dec  bc
    ld   bc,$010D
    add  hl,bc
    ld   bc,$010D
    add  hl,bc
    ld   bc,$0104
    ld   b,$01
    rlca
    ld   bc,$0109
    dec  bc
    ld   bc,$010D
    ld   c,$01
    djnz $5729
    ld   c,$02
    add  hl,bc
    ld   (bc),a
    ld   c,$04
    rst  $38
    rst  $38
    and  c
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $C301
    ld   bc,$02A0
    and  b
    ld   (bc),a
    out  ($01),a
    out  ($01),a
    out  ($01),a
    out  ($01),a
    ret  nz
    ld   (bc),a
    pop  bc
    ld   (bc),a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F08
    djnz $575D
    ld   d,(hl)
    rst  $38
    rst  $38
    add  a,b
    ld   d,a
    rst  $38
    rst  $38
    ld   l,(hl)
    ld   d,a
    rst  $38
    rst  $38
    ld   (bc),a
    ld   h,b
    ld   d,a
    ld   l,b
    ld   d,a
    ld   l,h
    ld   d,a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    dec  d
    ld   bc,$010E
    dec  d
    ld   bc,$010E
    dec  d
    ld   bc,$0110
    dec  d
    ld   bc,$0110
    inc  de
    ld   bc,$010E
    inc  de
    ld   bc,$010E
    djnz $579B
    add  hl,bc
    ld   bc,$0110
    add  hl,bc
    ld   bc,$0109
    dec  bc
    ld   bc,$0109
    rlca
    ld   bc,$0106
    inc  b
    ld   bc,$0102
    inc  b
    ld   bc,$0202
    ld   b,$02
    ld   (bc),a
    inc  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jp   $5AF0
    call $5C81
    ld   hl,$0F88
    call $5C81
    call $5570
    ex   af,af'
    ex   af,af'
    dec  d
    jr   z,$57F8
    ld   ($1011),hl
    ld   (de),a
    rra
    ld   e,$25
    inc  hl
    rst  $38
    call $5570
    add  hl,bc
    ex   af,af'
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    rst  $38
    call $4EB0
    call $4EB0
    call $5570
    inc  c
    rlca
    jr   nz,$5814
    inc  de
    dec  de
    djnz $5824
    jr   nz,$5811
    ld   b,$10
    ld   (de),a
    rra
    ld   e,$25
    inc  hl
    rst  $38
    call $5570
    djnz $5815
    rra
    ld   (de),a
    ld   a,(de)
    dec  d
    inc  de
    inc  h
    inc  hl
    djnz $583E
    add  hl,de
    inc  h
    jr   $583A
    dec  h
    inc  h
    rst  $38
    call $5570
    inc  d
    rlca
    inc  e
    rra
    inc  hl
    add  hl,de
    ld   e,$17
    djnz $583C
    djnz $5849
    add  hl,de
    ld   d,$15
    rst  $38
    call $4EB0
    call $4EB0
    call $5570
    rla
    dec  bc
    ret  po
    call c,$DEDD
    rst  $18
    rst  $38
    call $5570
    jr   $5852
    pop  hl
    ret  pe
    jp   pe,$E6F2
    rst  $38
    call $5570
    add  hl,de
    dec  bc
    pop  hl
    jp   (hl)
    ex   de,hl
    di
    and  $FF
    call $5570
    ld   a,(de)
    dec  bc
    jp   po,$E3E3
    ex   (sp),hl
    call po,$CDFF
    or   b
    ld   c,(hl)
    call $4EB0
    call $4EB0
    call $4EB0
    ret
    and  d
    ld   bc,$01A2
    and  d
    ld   bc,$01A2
    or   d
    ld   bc,$01B2
    or   d
    ld   bc,$01B2
    jp   nz,$C201
    ld   bc,$01C2
    jp   nz,$D201
    ld   bc,$01D2
    jp   nc,$D201
    ld   bc,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  c
    ld   d,$78
    ld   d,$78
    ld   d,$96
    ld   d,$96
    ld   d,$EE
    add  hl,bc
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    and  c
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A102
    ld   (bc),a
    jp   $A002
    ld   (bc),a
    out  ($01),a
    out  ($01),a
    out  ($01),a
    out  ($01),a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    pop  ix
    ld   h,$00
    ld   l,(ix+$00)
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    inc  ix
    ld   a,(ix+$00)
    add  a,l
    ld   l,a
    ld   bc,$9040
    add  hl,bc
    inc  ix
    ld   a,(ix+$00)
    cp   $FF
    jr   z,$58F4
    ld   (hl),a
    inc  hl
    jr   $58E7
    inc  ix
    push ix
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $5570
    ld   bc,$5101
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    rst  $38
    call $58D0
    ld   bc,$5302
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    rst  $38
    call $58D0
    ld   a,(de)
    ld   (bc),a
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    rst  $38
    call $5570
    inc  e
    ld   bc,$5153
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $5570
    ld   bc,$5201
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    rst  $38
    call $58D0
    ld   bc,$5202
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    rst  $38
    call $58D0
    ld   a,(de)
    ld   (bc),a
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    rst  $38
    call $5570
    inc  e
    ld   bc,$5352
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    call $5570
    ld   bc,$5301
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    rst  $38
    call $58D0
    ld   bc,$5102
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    ld   d,d
    ld   d,c
    ld   d,e
    rst  $38
    call $58D0
    ld   a,(de)
    ld   (bc),a
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    rst  $38
    call $5570
    inc  e
    ld   bc,$5251
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    ld   d,e
    ld   d,c
    ld   d,d
    rst  $38
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    push hl
    push bc
    push de
    ld   hl,$2128
    call $5C81
    pop  de
    pop  bc
    pop  hl
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   e,$05
    ld   d,$05
    push de
    call $5900
    call $5A98
    pop  de
    dec  d
    jr   nz,$5AAC
    ld   d,$05
    push de
    call $5988
    call $5A98
    pop  de
    dec  d
    jr   nz,$5AB9
    ld   d,$05
    push de
    call $5A10
    call $5A98
    pop  de
    dec  d
    jr   nz,$5AC6
    dec  e
    jr   nz,$5AAA
    ret
    rst  $38
    rst  $38
    rst  $38
    ld   b,a
    ld   hl,$8101
    ld   (hl),b
    inc  hl
    inc  hl
    ld   a,l
    cp   $41
    jr   nz,$5ADC
    ret
    rst  $38
    ld   a,$04
    call $5AD8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   hl,$1470
    call $5C81
    ld   hl,$0F88
    call $5C81
    call $5AE6
    call $5570
    ex   af,af'
    ex   af,af'
    dec  d
    jr   z,$5B2B
    ld   ($1011),hl
    ld   (de),a
    rra
    ld   e,$25
    inc  hl
    rst  $38
    call $5570
    add  hl,bc
    ex   af,af'
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    rst  $38
    call $5AA8
    call $5AA8
    call $5570
    inc  c
    rlca
    jr   nz,$5B47
    inc  de
    dec  de
    djnz $5B57
    jr   nz,$5B44
    ld   b,$10
    ld   (de),a
    rra
    ld   e,$25
    inc  hl
    rst  $38
    call $5570
    djnz $5B48
    rra
    ld   (de),a
    ld   a,(de)
    dec  d
    inc  de
    inc  h
    inc  hl
    djnz $5B71
    add  hl,de
    inc  h
    jr   $5B6D
    dec  h
    inc  h
    rst  $38
    call $5570
    inc  d
    rlca
    inc  e
    rra
    inc  hl
    add  hl,de
    ld   e,$17
    djnz $5B6F
    djnz $5B7C
    add  hl,de
    ld   d,$15
    rst  $38
    call $5AA8
    call $5570
    rla
    dec  bc
    ret  po
    call c,$DEDD
    rst  $18
    rst  $38
    call $5570
    jr   $5B82
    pop  hl
    push hl
    push hl
    push hl
    and  $FF
    call $5570
    add  hl,de
    dec  bc
    pop  hl
    push hl
    push hl
    push hl
    and  $FF
    call $5570
    ld   a,(de)
    dec  bc
    jp   po,$E3E3
    ex   (sp),hl
    call po,$CDFF
    xor  b
    ld   e,d
    call $5AA8
    call $5BC8
    ret
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   a,($8064)
    inc  a
    cp   $03
    jr   nz,$5BB1
    xor  a
    ld   ($8064),a
    and  a
    jr   nz,$5BBB
    call $5A10
    ret
    cp   $01
    jr   nz,$5BC3
    call $5988
    ret
    call $5900
    ret
    rst  $38
    ld   a,$F2
    ld   ($91F8),a
    call $5AA8
    ld   a,$F3
    ld   ($91F9),a
    call $5AA8
    ld   a,$EA
    ld   ($9218),a
    call $5AA8
    ld   a,$EB
    ld   ($9219),a
    call $5AA8
    ld   a,$E8
    ld   ($9238),a
    call $5AA8
    ld   a,$E9
    ld   ($9239),a
    call $5AA8
    call $5AA8
    call $5AA8
    ret
    rst  $38
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$031A
    ld   e,$02
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$031A
    ld   e,$02
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$011A
    ld   hl,$2101
    ld   bc,$0121
    ld   hl,$2303
    ld   bc,$011E
    inc  e
    inc  b
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$0319
    inc  e
    ld   (bc),a
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$0319
    inc  e
    ld   (bc),a
    dec  d
    ld   bc,$0115
    dec  d
    ld   bc,$0115
    ld   hl,$2101
    ld   bc,$0121
    ld   hl,$2302
    ld   bc,$021E
    ld   a,(de)
    inc  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   h,d
    ld   e,h
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    jp   (hl)
    ld   b,b
    ld   b,c
    ret
    rst  $38
    ld   b,$01
    ld   b,$01
    ld   b,$01
    ld   c,$01
    add  hl,bc
    ld   bc,$0112
    djnz $5C95
    ld   c,$01
    ld   b,$01
    ld   b,$01
    ld   b,$01
    ld   c,$01
    add  hl,bc
    ld   bc,$0112
    djnz $5CA5
    ld   c,$01
    ld   b,$01
    ld   b,$01
    ld   b,$01
    ld   c,$01
    add  hl,bc
    ld   bc,$0112
    djnz $5CB5
    ld   c,$01
    ld   (de),a
    ld   bc,$0112
    ld   (de),a
    ld   bc,$0110
    djnz $5CC1
    dec  c
    ld   bc,$0207
    rlca
    ld   bc,$0107
    rlca
    ld   bc,$010D
    dec  c
    ld   bc,$0110
    djnz $5CD4
    rlca
    ld   bc,$0107
    rlca
    ld   bc,$010D
    dec  c
    ld   bc,$0110
    djnz $5CE2
    rlca
    ld   bc,$0107
    rlca
    ld   bc,$0109
    djnz $5CEB
    djnz $5CED
    djnz $5CEF
    dec  d
    ld   bc,$0115
    inc  de
    ld   (bc),a
    ld   (de),a
    ld   bc,$0210
    ld   c,$02
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   (bc),a
    ex   af,af'
    ld   e,l
    inc  d
    ld   e,l
    inc  d
    ld   e,l
    rst  $38
    ld   bc,$0E08
    nop
    add  a,(hl)
    ld   e,h
    xor  $03
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    nop
    ld   e,h
    xor  $03
    rst  $38
    rst  $38
    ld   (hl),b
    jr   $5D4D
    rla
    jr   nc,$5D37
    jr   nc,$5D39
    jr   nc,$5D3B
    jr   z,$5D43
    xor  $03
    ex   (sp),hl
    ld   b,$D3
    inc  bc
    out  ($03),a
    rst  $38
    rst  $38
    add  hl,de
    ld   bc,$011A
    dec  de
    ld   bc,$011C
    ld   hl,$1C02
    ld   bc,$0221
    inc  e
    ld   (bc),a
    dec  de
    ld   bc,$0221
    dec  de
    ld   bc,$0221
    dec  de
    ld   (bc),a
    ld   a,(de)
    ld   bc,$0221
    ld   a,(de)
    ld   bc,$0221
    ld   a,(de)
    ld   (bc),a
    add  hl,de
    ld   bc,$011A
    dec  de
    ld   bc,$021C
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    add  hl,de
    jr   nz,$5D62
    rst  $38
    ld   a,(de)
    ld   bc,$0119
    rla
    ld   bc,$0315
    dec  d
    ld   bc,$031C
    inc  e
    ld   bc,$021E
    ld   a,(de)
    ld   (bc),a
    dec  d
    ld   (bc),a
    ld   e,$02
    inc  e
    inc  bc
    add  hl,de
    ld   bc,$0119
    rla
    ld   bc,$0215
    rla
    ld   b,$19
    ld   bc,$0117
    dec  d
    inc  bc
    dec  d
    ld   bc,$031C
    inc  e
    ld   bc,$011E
    inc  e
    ld   bc,$021A
    ld   e,$02
    ld   hl,$2502
    ld   (bc),a
    dec  h
    ld   (bc),a
    ld   h,$01
    dec  h
    ld   bc,$0223
    ld   hl,$FF05
    rst  $38
    rst  $38
    rst  $38
    djnz $5DB1
    djnz $5DB4
    djnz $5DB6
    ld   (de),a
    inc  b
    ld   (de),a
    inc  b
    djnz $5DBC
    djnz $5DBE
    dec  bc
    inc  b
    dec  bc
    inc  b
    djnz $5DC4
    djnz $5DC6
    ld   (de),a
    inc  b
    ld   (de),a
    inc  b
    djnz $5DCC
    add  hl,bc
    inc  b
    add  hl,bc
    dec  b
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F05
    nop
    ld   h,b
    ld   e,l
    xor  h
    ld   e,l
    xor  h
    ld   e,l
    xor  $07
    call z,$FF1D
    rst  $38
    jr   nc,$5E3F
    ld   h,h
    ld   e,l
    ld   h,h
    ld   e,l
    xor  $07
    rst  $38
    rst  $38
    inc  bc
    ret  nc
    ld   e,l
    ret  po
    ld   e,l
    call c,$FF5D
    rst  $38
    rst  $38
    dec  d
    ld   bc,$021A
    dec  e
    ld   bc,$011C
    dec  e
    ld   bc,$011C
    ld   a,(de)
    ld   (bc),a
    dec  e
    ld   bc,$021C
    dec  e
    ld   bc,$011A
    inc  e
    ld   bc,$011D
    inc  e
    ld   (bc),a
    dec  e
    ld   bc,$011A
    dec  d
    ld   bc,$0111
    ld   c,$03
    rst  $38
    rst  $38
    ld   de,$1101
    ld   bc,$0111
    ld   de,$1101
    ld   bc,$0111
    ld   de,$1101
    ld   bc,$0110
    djnz $5E31
    djnz $5E33
    djnz $5E35
    djnz $5E37
    djnz $5E39
    djnz $5E3B
    djnz $5E3D
    ld   c,$02
    ld   c,$01
    djnz $5E43
    ld   de,$0E02
    ld   (bc),a
    inc  d
    inc  b
    dec  d
    inc  b
    rst  $38
    rst  $38
    ld   c,$02
    ld   de,$0901
    ld   bc,$010B
    inc  c
    ld   bc,$020E
    ld   de,$0901
    ld   bc,$010B
    inc  c
    ld   bc,$020E
    ld   de,$0901
    ld   bc,$010B
    inc  c
    ld   bc,$010E
    add  hl,bc
    ld   bc,$0105
    ld   (bc),a
    inc  bc
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F06
    nop
    add  a,b
    ld   e,(hl)
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    ld   (hl),l
    ld   e,(hl)
    sub  b
    ld   e,(hl)
    ld   a,c
    ld   e,(hl)
    rst  $38
    call p,$1C5D
    ld   e,(hl)
    ld   c,h
    ld   e,(hl)
    ld   c,h
    ld   e,(hl)
    xor  $09
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   c,$01
    djnz $5EA5
    inc  de
    ld   bc,$0117
    ld   d,$01
    rla
    ld   bc,$0116
    rla
    ld   bc,$0116
    rla
    ld   bc,$0116
    jr   $5EB9
    rla
    ld   bc,$0115
    rla
    ld   bc,$0113
    ld   c,$01
    inc  de
    ld   bc,$0117
    ld   a,(de)
    ld   bc,$0119
    ld   a,(de)
    ld   bc,$0119
    ld   a,(de)
    ld   bc,$0119
    ld   a,(de)
    ld   bc,$0119
    inc  e
    ld   bc,$011A
    add  hl,de
    ld   bc,$011A
    rla
    ld   bc,$010E
    djnz $5EE5
    inc  de
    ld   bc,$0117
    ld   d,$01
    rla
    ld   bc,$0116
    rla
    ld   bc,$0116
    rla
    ld   bc,$0116
    jr   $5EF9
    rla
    ld   bc,$0115
    rla
    ld   bc,$0113
    ld   c,$01
    djnz $5F05
    inc  de
    ld   bc,$0117
    dec  d
    ld   (bc),a
    ld   c,$01
    rla
    ld   bc,$0215
    ld   c,$01
    inc  de
    ld   (bc),a
    ld   c,$02
    inc  de
    ld   bc,$FFFF
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    and  b
    ld   e,(hl)
    xor  $03
    inc  bc
    ld   b,$0F
    djnz $5F45
    ld   e,a
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    inc  h
    ld   e,a
    jr   nz,$5F94
    jr   z,$5F96
    rst  $38
    add  hl,bc
    ld   bc,$010E
    djnz $5F3F
    ld   (de),a
    inc  bc
    inc  de
    ld   bc,$0213
    rla
    ld   (bc),a
    dec  d
    inc  b
    ld   (de),a
    ld   (bc),a
    dec  d
    ld   (bc),a
    inc  de
    inc  bc
    ld   (de),a
    ld   bc,$0213
    djnz $5F56
    ld   (de),a
    dec  b
    add  hl,bc
    ld   bc,$010E
    djnz $5F5D
    ld   (de),a
    inc  bc
    inc  de
    ld   bc,$0213
    rla
    ld   (bc),a
    dec  d
    inc  b
    ld   (de),a
    ld   (bc),a
    dec  d
    ld   (bc),a
    inc  de
    inc  bc
    ld   (de),a
    ld   bc,$0213
    djnz $5F74
    ld   c,$05
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    inc  bc
    sub  b
    ld   e,a
    add  a,b
    ld   e,a
    sbc  a,b
    ld   e,a
    rst  $38
    jr   c,$5FE1
    jr   nz,$5FCE
    jr   nz,$5FD0
    ld   c,b
    ld   c,d
    ld   c,b
    ld   c,d
    xor  $0B
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    ld   bc,$0F05
    nop
    adc  a,h
    ld   e,a
    rst  $38
    rst  $38
    call nz,$E44A
    ld   c,d
    call po,$064A
    ld   c,e
    ld   b,$4B
    xor  $0B
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38

                ;; Redoing my annotating, but keeping everyting
                ;; actually buildable

                ;; First 16 chars get chopped, so don't put anyting
                ;; before col 16.

                ram_loc         = $8000
                num_players     = $8034 ; attract mode = 0, 1P = 1, 2P = 2
                _80ff           = $80ff ; written once at init. Unused?
                screen_xoff_col = $8100 ; OFFSET and COL for each row of tiles
                                        ; Gets memcpy'd to $9800

                credits         = $8303 ; how many credits in machine
                stack_loc       = $83f0

                ;;; hardware

                screen_ram      = $9000 ; - 0x93ff  videoram
                start_of_tiles  = $9040 ; top right tile
                end_of_tiles    = $93BF ; bottom left tile
                ;; what's all the stuff in herer?
                xoff_col_ram    = $9800 ; xoffset and color data per tile row
                sprites         = $9840 ; 0x9800 - 0x98ff is spriteram
                port_in0        = $A000 ;
                port_in1        = $A800 ;
                port_in2        = $B000 ;
                int_enable      = $B001 ; interrupt enable
                _b006           = $b006 ; set to 1 for P1 or
                _b007           = $b007 ; 0 for P2... why? Controls?
                watchdog        = $b800 ; main timer?

                ;;; =========== START OF BG1.BIN =============

                hard_reset:
0000  A2            and  d
0001  3201B0        ld   (int_enable),a
0004  32FF80        ld   (_80ff),a ; unused
0007  3EFF          ld   a,$FF
0009  3200B8        ld   (watchdog),a
000C  C3A014        jp   clear_ram ; jumps back here after clear
000F  31F083        ld   sp,stack_loc
0012  CD003F        call delay_83_call_weird_a
0015  CD4800        call init_screen
0018  CD8822        call write_out_0_1
001B  C38D00        jp   setup_then_start_game

                    ;; data? Never read/exec
001E                db $dd,$19,$dd,$19,$2b,$10,$af,$ed
0026                db $67,$dd,$77,$ed,$6f,$dd,$dd,$19
002e                db $ed,$6f,$dd,$ff,$ff,$ff,$ff,$ff
0036                db $ff,$ff

                reset_vector:
0038  3A00B8        ld   a,(watchdog)
003B  18FB          jr   reset_vector

003D  FF            dc   11, $ff

                ;; Called once at startup
                init_screen:
0048  3A00A0        ld   a,(port_in0)
004B  E683          and  $83            ; 1000 0011
004D  C8            ret  z
004E  CD7014        call reset_xoff_sprites_and_clear_screen
0051  CD1003        call draw_tiles_h
0054                db   $09, $00       ; CREDIT FAULT
0056                db   $13,$22,$15,$14,$19,$24,$10,$16,$11,$25,$1C,$24,$FF
0063  18E3          jr   init_screen

0065  FF            db   $ff

                ;; Non-Maskable Interrupt handler. Fires every frame
                nmi_loop:
0066  AF            xor  a
0067  3201B0        ld   (int_enable),a
006A  3A00B8        ld   a,(watchdog)
006D  CDC000        call nmi_handler
0070  3A3480        ld   a,(num_players)
0073  A7            and  a
0074  2003          jr   nz,$0079
0076  CD9001        call did_player_press_start
0079  0601          ld   b,$01
007B  CD0011        call tick_ticks ; update ticks
007E  CD2024        call $2420
0081  00            nop
0082  3A00A0        ld   a,(port_in0)
0085  CB4F          bit  1,a
0087  C203C0        jp   nz,$C003   ; c003?! What's that?
008A  ED45          retn            ; NMI return

008C  FF            db   $ff

                setup_then_start_game:
008D  CD4803        call $0348
0090  CD8030        call $3080
0093  CDA013        call $13A0
0096  3A0383        ld   a,(credits)
0099  A7            and  a
009A  2008          jr   nz,$00A4
009C  CD7003        call $0370
009F  CD7014        call reset_xoff_sprites_and_clear_screen
00A2  18EF          jr   $0093
                _play_splash:
00A4  CDA013        call  wait_vblank
00A7  3A0383        ld   a,(credits)
00AA  FE01          cp   $01
00AC  2005          jr   nz,$00B3
00AE  CDD000        call $00D0
00B1  1803          jr   $00B6
00B3  CD4001        call $0140
00B6  3A3480        ld   a,(num_players)
00B9  A7            and  a
00BA  C2E701        jp   nz,start_game
00BD  18E5          jr   _play_splash

00BF  FF            db  $ff

                nmi_handler:
00C0  D9            exx
00C1  CD8802        call $0288
00C4  CD5015        call $1550
00C7  CD6029        call $2960
00CA  CDD001        call $01D0
00CD  D9            exx
00CE  C9            ret

00CF  FF            db   $ff

00D0  3E01          ld   a,$01
00D2  329080        ld   ($8090),a
00D5  AF            xor  a
00D6  3204B0        ld   ($B004),a
00D9  3A0383        ld   a,(credits)
00DC  47            ld   b,a
00DD  3A3580        ld   a,($8035)
00E0  B8            cp   b
00E1  C8            ret  z
00E2  00            nop
00E3  00            nop
00E4  00            nop
00E5  CD8014        call clear_screen
00E8  21E00F        ld   hl,$0FE0
00EB  CD4008        call $0840
00EE  00            nop
00EF  00            nop
00F0  CD5024        call $2450
00F3  CD1003        call draw_tiles_h
00F6  09            add  hl,bc
00F7  0B            dec  bc
00F8  2022          jr   nz,$011C
00FA  15            dec  d
00FB  23            inc  hl
00FC  23            inc  hl
00FD  FF            rst  $38
00FE  CD1003        call draw_tiles_h
0101  0C            inc  c
0102  09            add  hl,bc
0103  1F            rra
0104  1E15          ld   e,$15
0106  1020          djnz $0128
0108  1C            inc  e
0109  112915        ld   de,$1529
010C  22FFCD        ld   ($CDFF),hl
010F  1003          djnz $0114
0111  0F            rrca
0112  8B            adc  a,e
0113  12            ld   (de),a
0114  25            dec  h
0115  24            inc  h
0116  24            inc  h
0117  1F            rra
0118  1EFF          ld   e,$FF
011A  CD1003        call draw_tiles_h
011D  19            add  hl,de
011E  09            add  hl,bc
011F  13            inc  de
0120  221514        ld   ($1415),hl
0123  19            add  hl,de
0124  24            inc  h
0125  23            inc  hl
0126  FF            rst  $38
0127  210383        ld   hl,credits
012A  AF            xor  a
012B  ED6F          rld
012D  329991        ld   ($9199),a
0130  ED6F          rld
0132  327991        ld   ($9179),a
0135  ED6F          rld
0137  3A0383        ld   a,(credits)
013A  323580        ld   ($8035),a
013D  C9            ret
013E  FF            rst  $38
013F  FF            rst  $38
0140  CD3024        call $2430
0143  3A0383        ld   a,(credits)
0146  47            ld   b,a
0147  3A3580        ld   a,($8035)
014A  B8            cp   b
014B  00            nop
014C  CDD000        call $00D0
014F  CD1003        call draw_tiles_h
0152  0C            inc  c
0153  061F          ld   b,$1F
0155  1E15          ld   e,$15
0157  101F          djnz $0178
0159  221024        ld   ($2410),hl
015C  27            daa
015D  1F            rra
015E  1020          djnz $0180
0160  1C            inc  e
0161  112915        ld   de,$1529
0164  22FFC9        ld   ($C9FF),hl
0167  FF            rst  $38
0168  FF            rst  $38
0169  FF            rst  $38
016A  FF            rst  $38
016B  FF            rst  $38
016C  FF            rst  $38
016D  FF            rst  $38
016E  FF            rst  $38
016F  FF            rst  $38
0170  CD2000        call $0020
0173  C9            ret
0174  FF            rst  $38
0175  FF            rst  $38
0176  FF            rst  $38
0177  FF            rst  $38
0178  FF            rst  $38
0179  FF            rst  $38
017A  FF            rst  $38
017B  FF            rst  $38
017C  FF            rst  $38
017D  FF            rst  $38
017E  FF            rst  $38
017F  FF            rst  $38
0180  C5            push bc
0181  010040        ld   bc,$4000
0184  09            add  hl,bc
0185  C1            pop  bc
0186  E9            jp   (hl)
0187  FF            rst  $38
0188  FF            rst  $38
0189  FF            rst  $38
018A  FF            rst  $38
018B  FF            rst  $38
018C  FF            rst  $38
018D  FF            rst  $38
018E  FF            rst  $38
018F  FF            rst  $38

                did_player_press_start:
0190  3A0383        ld   a,(credits) ; check you have credits
0193  A7            and  a
0194  C8            ret  z
0195  3AF183        ld   a,($83F1)
0198  CB47          bit  0,a
019A  2811          jr   z,$01AD
019C  CD6014        call $1460
019F  3E01          ld   a,$01
01A1  323480        ld   (num_players),a
01A4  3A0383        ld   a,(credits)
01A7  3D            dec  a
01A8  27            daa
01A9  320383        ld   (credits),a
01AC  C9            ret
01AD  3A0383        ld   a,(credits)
01B0  3D            dec  a
01B1  C8            ret  z
01B2  3AF183        ld   a,($83F1)
01B5  CB4F          bit  1,a
01B7  C8            ret  z
01B8  CD6014        call $1460
01BB  3E02          ld   a,$02
01BD  323480        ld   (num_players),a
01C0  3A0383        ld   a,(credits)
01C3  3D            dec  a
01C4  27            daa
01C5  3D            dec  a
01C6  27            daa
01C7  320383        ld   (credits),a
01CA  C9            ret
01CB  FF            rst  $38
01CC  FF            rst  $38
01CD  FF            rst  $38
01CE  FF            rst  $38
01CF  FF            rst  $38
01D0  3A00A0        ld   a,(port_in0)
01D3  320B80        ld   ($800B),a
01D6  3AF183        ld   a,($83F1)
01D9  320C80        ld   ($800C),a
01DC  3AF283        ld   a,($83F2)
01DF  320D80        ld   ($800D),a
01E2  C9            ret
01E3  C38001        jp   $0180
01E6  C9            ret

                start_game:
01E7  3E1F          ld   a,$1F
01E9  325B80        ld   ($805B),a
01EC  325C80        ld   ($805C),a
01EF  00            nop
01F0  3AF283        ld   a,($83F2)
01F3  E606          and  $06
01F5  CB2F          sra  a
01F7  C602          add  a,$02
01F9  323280        ld   ($8032),a
01FC  323380        ld   ($8033),a
01FF  3A3480        ld   a,(num_players)
0202  3D            dec  a
0203  323180        ld   ($8031),a
0206  3E01          ld   a,$01
0208  320480        ld   ($8004),a
020B  3A3180        ld   a,($8031)
020E  A7            and  a
020F  2004          jr   nz,$0215
0211  AF            xor  a
0212  323380        ld   ($8033),a
0215  3E01          ld   a,$01
0217  322980        ld   ($8029),a
021A  322A80        ld   ($802A),a
021D  329080        ld   ($8090),a
0220  31F083        ld   sp,stack_loc
0223  3A0480        ld   a,($8004)
0226  EE01          xor  $01
0228  320480        ld   ($8004),a
022B  213280        ld   hl,$8032
022E  85            add  a,l
022F  6F            ld   l,a
0230  7E            ld   a,(hl)
0231  A7            and  a
0232  2012          jr   nz,$0246
0234  3A0480        ld   a,($8004)
0237  EE01          xor  $01
0239  320480        ld   ($8004),a
023C  213280        ld   hl,$8032
023F  85            add  a,l
0240  6F            ld   l,a
0241  7E            ld   a,(hl)
0242  A7            and  a
0243  CA1004        jp   z,$0410
0246  3D            dec  a
0247  77            ld   (hl),a
0248  3AF183        ld   a,($83F1)
024B  CB7F          bit  7,a
024D  2811          jr   z,$0260
024F  3A0480        ld   a,($8004)
0252  FE01          cp   $01
0254  200A          jr   nz,$0260
0256  3E01          ld   a,$01
0258  3206B0        ld   ($B006),a
025B  3207B0        ld   ($B007),a
025E  1807          jr   $0267
0260  AF            xor  a
0261  3206B0        ld   ($B006),a
0264  3207B0        ld   ($B007),a
0267  3AF283        ld   a,($83F2)
026A  CB5F          bit  3,a
026C  2810          jr   z,$027E
026E  3E03          ld   a,$03
0270  323280        ld   ($8032),a
0273  3A3380        ld   a,($8033)
0276  A7            and  a
0277  2805          jr   z,$027E
0279  3E03          ld   a,$03
027B  323380        ld   ($8033),a
027E  C30010        jp   $1000
0281  FF            rst  $38
0282  FF            rst  $38
0283  FF            rst  $38
0284  FF            rst  $38
0285  FF            rst  $38
0286  FF            rst  $38
0287  FF            rst  $38
0288  3A0683        ld   a,($8306)
028B  A7            and  a
028C  2811          jr   z,$029F
028E  3D            dec  a
028F  320683        ld   ($8306),a
0292  C0            ret  nz
0293  3A00A0        ld   a,(port_in0)
0296  E603          and  $03
0298  C8            ret  z
0299  3E05          ld   a,$05
029B  320683        ld   ($8306),a
029E  C9            ret
029F  3A00A0        ld   a,(port_in0)
02A2  E603          and  $03
02A4  C8            ret  z
02A5  47            ld   b,a
02A6  3E20          ld   a,$20
02A8  329380        ld   ($8093),a
02AB  78            ld   a,b
02AC  FE01          cp   $01
02AE  2009          jr   nz,$02B9
02B0  3A0583        ld   a,($8305)
02B3  3C            inc  a
02B4  320583        ld   ($8305),a
02B7  1808          jr   $02C1
02B9  3A0583        ld   a,($8305)
02BC  C606          add  a,$06
02BE  320583        ld   ($8305),a
02C1  3E07          ld   a,$07
02C3  320683        ld   ($8306),a
02C6  3AF183        ld   a,($83F1)
02C9  CB77          bit  6,a
02CB  2816          jr   z,$02E3
02CD  3A0583        ld   a,($8305)
02D0  A7            and  a
02D1  C8            ret  z
02D2  47            ld   b,a
02D3  3A0383        ld   a,(credits)
02D6  3C            inc  a
02D7  27            daa
02D8  05            dec  b
02D9  20FB          jr   nz,$02D6
02DB  320383        ld   (credits),a
02DE  AF            xor  a
02DF  320583        ld   ($8305),a
02E2  C9            ret
02E3  3A0583        ld   a,($8305)
02E6  A7            and  a
02E7  C8            ret  z
02E8  FE01          cp   $01
02EA  C8            ret  z
02EB  47            ld   b,a
02EC  3A0383        ld   a,(credits)
02EF  3C            inc  a
02F0  27            daa
02F1  05            dec  b
02F2  2805          jr   z,$02F9
02F4  05            dec  b
02F5  280D          jr   z,$0304
02F7  18F6          jr   $02EF
02F9  3D            dec  a
02FA  27            daa
02FB  320383        ld   (credits),a
02FE  3E01          ld   a,$01
0300  320583        ld   ($8305),a
0303  C9            ret
0304  320383        ld   (credits),a
0307  AF            xor  a
0308  320583        ld   ($8305),a
030B  C9            ret
030C  FF            rst  $38
030D  FF            rst  $38
030E  FF            rst  $38
030F  FF            rst  $38

                ;; draw sequence of tiles at (y, x)
                draw_tiles_h:
0310  3A00B8        ld   a,(watchdog)
0313  214090        ld   hl,start_of_tiles
0316  C1            pop  bc
0317  0A            ld   a,(bc) ; y pos
0318  03            inc  bc
0319  85            add  a,l
031A  6F            ld   l,a
031B  0A            ld   a,(bc) ; x pos
031C  5F            ld   e,a
031D  3E1B          ld   a,$1B
031F  93            sub  e
0320  5F            ld   e,a
0321  1600          ld   d,$00
0323  CB23          sla  e
0325  CB23          sla  e
0327  CB23          sla  e
0329  19            add  hl,de
032A  19            add  hl,de
032B  19            add  hl,de
032C  19            add  hl,de
032D  03            inc  bc
032E  0A            ld   a,(bc) ; read data until 0xff
032F  03            inc  bc
0330  FEFF          cp   $FF
0332  2002          jr   nz,$0336
0334  C5            push bc
0335  C9            ret
0336  77            ld   (hl),a
0337  16FF          ld   d,$FF
0339  1EE0          ld   e,$E0
033B  19            add  hl,de
033C  18F0          jr   $032E

033E                dc 10,$ff

0348  00            nop
0349  00            nop
034A  00            nop
034B  CD7014        call reset_xoff_sprites_and_clear_screen
034E  210080        ld   hl,$8000
0351  3600          ld   (hl),$00
0353  2C            inc  l
0354  20FB          jr   nz,$0351
0356  24            inc  h
0357  3A00B8        ld   a,(watchdog)
035A  7C            ld   a,h
035B  FE88          cp   $88
035D  20F2          jr   nz,$0351
035F  31F083        ld   sp,stack_loc
0362  3E01          ld   a,$01
0364  329080        ld   ($8090),a
0367  C38305        jp   $0583
036A  FF            rst  $38
036B  FF            rst  $38
036C  FF            rst  $38
036D  FF            rst  $38
036E  FF            rst  $38
036F  FF            rst  $38
0370  CD7014        call reset_xoff_sprites_and_clear_screen
0373  212015        ld   hl,$1520
0376  CDE301        call $01E3
0379  21200E        ld   hl,$0E20
037C  CDE301        call $01E3
037F  21C017        ld   hl,$17C0
0382  CDE301        call $01E3
0385  21A015        ld   hl,$15A0
0388  CDE301        call $01E3
038B  00            nop
038C  00            nop
038D  00            nop
038E  C9            ret
038F  FF            rst  $38
0390  CDA013        call wait_vblank
0393  18FB          jr   $0390
0395  FF            rst  $38
0396  FF            rst  $38
0397  FF            rst  $38
0398  FF            rst  $38
0399  FF            rst  $38
039A  FF            rst  $38
039B  FF            rst  $38
039C  FF            rst  $38
039D  FF            rst  $38
039E  FF            rst  $38
039F  FF            rst  $38
03A0  CD0804        call $0408
03A3  3A3280        ld   a,($8032)
03A6  A7            and  a
03A7  47            ld   b,a
03A8  3E8A          ld   a,$8A
03AA  281B          jr   z,$03C7
03AC  05            dec  b
03AD  32C292        ld   ($92C2),a
03B0  2815          jr   z,$03C7
03B2  05            dec  b
03B3  32A292        ld   ($92A2),a
03B6  280F          jr   z,$03C7
03B8  05            dec  b
03B9  328292        ld   ($9282),a
03BC  2809          jr   z,$03C7
03BE  05            dec  b
03BF  326292        ld   ($9262),a
03C2  2803          jr   z,$03C7
03C4  324292        ld   ($9242),a
03C7  3A3380        ld   a,($8033)
03CA  A7            and  a
03CB  47            ld   b,a
03CC  C8            ret  z
03CD  3E8A          ld   a,$8A
03CF  05            dec  b
03D0  322291        ld   ($9122),a
03D3  C8            ret  z
03D4  05            dec  b
03D5  324291        ld   ($9142),a
03D8  C8            ret  z
03D9  05            dec  b
03DA  326291        ld   ($9162),a
03DD  C8            ret  z
03DE  05            dec  b
03DF  328291        ld   ($9182),a
03E2  C8            ret  z
03E3  32A291        ld   ($91A2),a
03E6  C9            ret
03E7  FF            rst  $38
03E8  AF            xor  a
03E9  323480        ld   (num_players),a
03EC  323580        ld   ($8035),a
03EF  C39300        jp   $0093
03F2  FF            rst  $38
03F3  FF            rst  $38
03F4  FF            rst  $38
03F5  FF            rst  $38
03F6  FF            rst  $38
03F7  FF            rst  $38
03F8  0EE0          ld   c,$E0
03FA  CDA013        call wait_vblank
03FD  0C            inc  c
03FE  20FA          jr   nz,$03FA
0400  C9            ret
0401  FF            rst  $38
0402  FF            rst  $38
0403  FF            rst  $38
0404  FF            rst  $38
0405  FF            rst  $38
0406  FF            rst  $38
0407  FF            rst  $38
0408  3E01          ld   a,$01
040A  320581        ld   ($8105),a
040D  C9            ret
040E  FF            rst  $38
040F  FF            rst  $38
0410  21E816        ld   hl,$16E8
0413  CDE301        call $01E3
0416  CDE024        call $24E0
0419  CD3004        call $0430
041C  CD7014        call reset_xoff_sprites_and_clear_screen
041F  AF            xor  a
0420  3204B0        ld   ($B004),a
0423  C3002D        jp   $2D00
0426  FF            rst  $38
0427  FF            rst  $38
0428  FF            rst  $38
0429  FF            rst  $38
042A  FF            rst  $38
042B  FF            rst  $38
042C  FF            rst  $38
042D  FF            rst  $38
042E  FF            rst  $38
042F  FF            rst  $38
0430  CD4004        call $0440
0433  CD7004        call $0470
0436  C9            ret
0437  FF            rst  $38
0438  FF            rst  $38
0439  FF            rst  $38
043A  FF            rst  $38
043B  FF            rst  $38
043C  FF            rst  $38
043D  FF            rst  $38
043E  FF            rst  $38
043F  FF            rst  $38
0440  3A1680        ld   a,($8016)
0443  4F            ld   c,a
0444  3A0283        ld   a,($8302)
0447  37            scf
0448  3F            ccf
0449  99            sbc  a,c
044A  DCE004        call c,$04E0
044D  C0            ret  nz
044E  3A1580        ld   a,($8015)
0451  4F            ld   c,a
0452  3A0183        ld   a,($8301)
0455  37            scf
0456  3F            ccf
0457  99            sbc  a,c
0458  DCE004        call c,$04E0
045B  C0            ret  nz
045C  3A1480        ld   a,($8014)
045F  4F            ld   c,a
0460  3A0083        ld   a,($8300)
0463  37            scf
0464  3F            ccf
0465  99            sbc  a,c
0466  DCE004        call c,$04E0
0469  C9            ret
046A  FF            rst  $38
046B  FF            rst  $38
046C  FF            rst  $38
046D  FF            rst  $38
046E  FF            rst  $38
046F  FF            rst  $38
0470  3A1980        ld   a,($8019)
0473  4F            ld   c,a
0474  3A0283        ld   a,($8302)
0477  37            scf
0478  3F            ccf
0479  99            sbc  a,c
047A  DC0005        call c,$0500
047D  C0            ret  nz
047E  3A1880        ld   a,($8018)
0481  4F            ld   c,a
0482  3A0183        ld   a,($8301)
0485  37            scf
0486  3F            ccf
0487  99            sbc  a,c
0488  DC0005        call c,$0500
048B  C0            ret  nz
048C  3A1780        ld   a,($8017)
048F  4F            ld   c,a
0490  3A0083        ld   a,($8300)
0493  37            scf
0494  3F            ccf
0495  99            sbc  a,c
0496  DC0005        call c,$0500
0499  C9            ret
049A  FF            rst  $38
049B  FF            rst  $38
049C  FF            rst  $38
049D  FF            rst  $38
049E  FF            rst  $38
049F  FF            rst  $38
04A0  FF            rst  $38
04A1  FF            rst  $38
04A2  FF            rst  $38
04A3  FF            rst  $38
04A4  FF            rst  $38
04A5  FF            rst  $38
04A6  FF            rst  $38
04A7  FF            rst  $38
04A8  FF            rst  $38
04A9  FF            rst  $38
04AA  FF            rst  $38
04AB  FF            rst  $38
04AC  FF            rst  $38
04AD  FF            rst  $38
04AE  FF            rst  $38
04AF  FF            rst  $38
04B0  0E01          ld   c,$01
04B2  CDA013        call wait_vblank
04B5  0D            dec  c
04B6  20FA          jr   nz,$04B2
04B8  C9            ret
04B9  FF            rst  $38
04BA  CDE028        call $28E0
04BD  3A0480        ld   a,($8004)
04C0  A7            and  a
04C1  2005          jr   nz,$04C8
04C3  3A5B80        ld   a,($805B)
04C6  1803          jr   $04CB
04C8  3A5C80        ld   a,($805C)
04CB  47            ld   b,a
04CC  3A5D80        ld   a,($805D)
04CF  3C            inc  a
04D0  B8            cp   b
04D1  2001          jr   nz,$04D4
04D3  AF            xor  a
04D4  325D80        ld   ($805D),a
04D7  A7            and  a
04D8  C0            ret  nz
04D9  CDF022        call $22F0
04DC  C9            ret
04DD  FF            rst  $38
04DE  FF            rst  $38
04DF  FF            rst  $38
04E0  3A1480        ld   a,($8014)
04E3  320083        ld   ($8300),a
04E6  3A1580        ld   a,($8015)
04E9  320183        ld   ($8301),a
04EC  3A1680        ld   a,($8016)
04EF  320283        ld   ($8302),a
04F2  E1            pop  hl
04F3  C9            ret
04F4  FF            rst  $38
04F5  FF            rst  $38
04F6  FF            rst  $38
04F7  FF            rst  $38
04F8  FF            rst  $38
04F9  FF            rst  $38
04FA  FF            rst  $38
04FB  FF            rst  $38
04FC  FF            rst  $38
04FD  FF            rst  $38
04FE  FF            rst  $38
04FF  FF            rst  $38
0500  3A1780        ld   a,($8017)
0503  320083        ld   ($8300),a
0506  3A1880        ld   a,($8018)
0509  320183        ld   ($8301),a
050C  3A1980        ld   a,($8019)
050F  320283        ld   ($8302),a
0512  E1            pop  hl
0513  C9            ret
0514  FF            rst  $38
0515  FF            rst  $38
0516  FF            rst  $38
0517  FF            rst  $38
0518  213880        ld   hl,$8038
051B  3639          ld   (hl),$39
051D  23            inc  hl
051E  3639          ld   (hl),$39
0520  23            inc  hl
0521  3639          ld   (hl),$39
0523  23            inc  hl
0524  3639          ld   (hl),$39
0526  23            inc  hl
0527  3638          ld   (hl),$38
0529  23            inc  hl
052A  3639          ld   (hl),$39
052C  23            inc  hl
052D  3639          ld   (hl),$39
052F  23            inc  hl
0530  3639          ld   (hl),$39
0532  23            inc  hl
0533  3638          ld   (hl),$38
0535  23            inc  hl
0536  3639          ld   (hl),$39
0538  23            inc  hl
0539  3638          ld   (hl),$38
053B  23            inc  hl
053C  3638          ld   (hl),$38
053E  23            inc  hl
053F  3631          ld   (hl),$31
0541  23            inc  hl
0542  3631          ld   (hl),$31
0544  23            inc  hl
0545  3630          ld   (hl),$30
0547  23            inc  hl
0548  3631          ld   (hl),$31
054A  23            inc  hl
054B  3630          ld   (hl),$30
054D  23            inc  hl
054E  3630          ld   (hl),$30
0550  23            inc  hl
0551  3630          ld   (hl),$30
0553  23            inc  hl
0554  3631          ld   (hl),$31
0556  23            inc  hl
0557  3630          ld   (hl),$30
0559  23            inc  hl
055A  3630          ld   (hl),$30
055C  23            inc  hl
055D  3630          ld   (hl),$30
055F  23            inc  hl
0560  3630          ld   (hl),$30
0562  23            inc  hl
0563  3630          ld   (hl),$30
0565  CD8808        call $0888
0568  C9            ret
0569  FF            rst  $38
056A  FF            rst  $38
056B  FF            rst  $38
056C  FF            rst  $38
056D  FF            rst  $38
056E  FF            rst  $38
056F  FF            rst  $38
0570  FF            rst  $38
0571  FF            rst  $38
0572  FF            rst  $38
0573  FF            rst  $38
0574  FF            rst  $38
0575  FF            rst  $38
0576  FF            rst  $38
0577  FF            rst  $38
0578  FF            rst  $38
0579  FF            rst  $38
057A  FF            rst  $38
057B  FF            rst  $38
057C  FF            rst  $38
057D  FF            rst  $38
057E  FF            rst  $38
057F  FF            rst  $38
0580  CD4803        call $0348
0583  CD8030        call $3080
0586  CDA013        call wait_vblank
0589  3A3480        ld   a,(num_players)
058C  A7            and  a
058D  201C          jr   nz,$05AB
058F  3A0383        ld   a,(credits)
0592  A7            and  a
0593  2008          jr   nz,$059D
0595  CD7003        call $0370
0598  CD7014        call reset_xoff_sprites_and_clear_screen
059B  18E9          jr   $0586
059D  FE01          cp   $01
059F  2005          jr   nz,$05A6
05A1  CDD000        call $00D0
05A4  18E0          jr   $0586
05A6  CD4001        call $0140
05A9  18DB          jr   $0586
05AB  C2E701        jp   nz,start_game
05AE  18D6          jr   $0586
05B0  FF            rst  $38
05B1  FF            rst  $38
05B2  FF            rst  $38
05B3  FF            rst  $38
05B4  FF            rst  $38
05B5  FF            rst  $38
05B6  FF            rst  $38
05B7  FF            rst  $38
05B8  3A0383        ld   a,(credits)
05BB  A7            and  a
05BC  2004          jr   nz,$05C2
05BE  CDA013        call wait_vblank
05C1  C9            ret
05C2  CDA013        call wait_vblank
05C5  E1            pop  hl
05C6  E1            pop  hl
05C7  E1            pop  hl
05C8  C9            ret
05C9  FF            rst  $38
05CA  FF            rst  $38
05CB  FF            rst  $38
05CC  FF            rst  $38
05CD  FF            rst  $38
05CE  FF            rst  $38
05CF  FF            rst  $38
05D0  3A0480        ld   a,($8004)
05D3  A7            and  a
05D4  2817          jr   z,$05ED
05D6  3A0C80        ld   a,($800C)
05D9  CB7F          bit  7,a
05DB  2810          jr   z,$05ED
05DD  3A0C80        ld   a,($800C)
05E0  E63C          and  $3C
05E2  47            ld   b,a
05E3  3A0B80        ld   a,($800B)
05E6  E640          and  $40
05E8  80            add  a,b
05E9  320E80        ld   ($800E),a
05EC  C9            ret
05ED  3A0B80        ld   a,($800B)
05F0  E63C          and  $3C
05F2  47            ld   b,a
05F3  3A0B80        ld   a,($800B)
05F6  E680          and  $80
05F8  CB3F          srl  a
05FA  80            add  a,b
05FB  320E80        ld   ($800E),a
05FE  C9            ret
05FF  FF            rst  $38
0600  FF            rst  $38
0601  FF            rst  $38
0602  FF            rst  $38
0603  FF            rst  $38
0604  FF            rst  $38
0605  FF            rst  $38
0606  FF            rst  $38
0607  FF            rst  $38
0608  0C            inc  c
0609  0E10          ld   c,$10
060B  0E0C          ld   c,$0C
060D  12            ld   (de),a
060E  14            inc  d
060F  12            ld   (de),a
0610  FF            rst  $38
0611  FF            rst  $38
0612  FF            rst  $38
0613  FF            rst  $38
0614  FF            rst  $38
0615  FF            rst  $38
0616  FF            rst  $38
0617  FF            rst  $38
0618  3A1080        ld   a,($8010)
061B  3C            inc  a
061C  E607          and  $07
061E  321080        ld   ($8010),a
0621  210806        ld   hl,$0608
0624  85            add  a,l
0625  6F            ld   l,a
0626  7E            ld   a,(hl)
0627  324181        ld   ($8141),a
062A  3C            inc  a
062B  324581        ld   ($8145),a
062E  3A4081        ld   a,($8140)
0631  3C            inc  a
0632  3C            inc  a
0633  3C            inc  a
0634  324081        ld   ($8140),a
0637  324481        ld   ($8144),a
063A  00            nop
063B  00            nop
063C  00            nop
063D  C9            ret
063E  FF            rst  $38
063F  FF            rst  $38
0640  FF            rst  $38
0641  FF            rst  $38
0642  FF            rst  $38
0643  FF            rst  $38
0644  FF            rst  $38
0645  FF            rst  $38
0646  FF            rst  $38
0647  FF            rst  $38
0648  8C            adc  a,h
0649  8E            adc  a,(hl)
064A  90            sub  b
064B  8E            adc  a,(hl)
064C  8C            adc  a,h
064D  92            sub  d
064E  94            sub  h
064F  92            sub  d
0650  FF            rst  $38
0651  FF            rst  $38
0652  FF            rst  $38
0653  FF            rst  $38
0654  FF            rst  $38
0655  FF            rst  $38
0656  FF            rst  $38
0657  FF            rst  $38
0658  3A1080        ld   a,($8010)
065B  3C            inc  a
065C  E607          and  $07
065E  321080        ld   ($8010),a
0661  214806        ld   hl,$0648
0664  85            add  a,l
0665  6F            ld   l,a
0666  7E            ld   a,(hl)
0667  324181        ld   ($8141),a
066A  3C            inc  a
066B  324581        ld   ($8145),a
066E  3A4081        ld   a,($8140)
0671  3D            dec  a
0672  3D            dec  a
0673  3D            dec  a
0674  324081        ld   ($8140),a
0677  324481        ld   ($8144),a
067A  00            nop
067B  00            nop
067C  00            nop
067D  C9            ret
067E  FF            rst  $38
067F  FF            rst  $38
0680  FF            rst  $38
0681  FF            rst  $38
0682  FF            rst  $38
0683  FF            rst  $38
0684  FF            rst  $38
0685  FF            rst  $38
0686  FF            rst  $38
0687  FF            rst  $38
0688  3A1283        ld   a,($8312)
068B  E603          and  $03
068D  C0            ret  nz
068E  3A1280        ld   a,($8012)
0691  A7            and  a
0692  C0            ret  nz
0693  3A0F80        ld   a,($800F)
0696  A7            and  a
0697  C0            ret  nz
0698  3A0E80        ld   a,($800E)
069B  CB6F          bit  5,a
069D  2817          jr   z,$06B6
069F  CD1007        call $0710
06A2  CB57          bit  2,a
06A4  2804          jr   z,$06AA
06A6  CDA007        call $07A0
06A9  C9            ret
06AA  CB5F          bit  3,a
06AC  2804          jr   z,$06B2
06AE  CDC007        call $07C0
06B1  C9            ret
06B2  CDC008        call $08C0
06B5  C9            ret
06B6  CB57          bit  2,a
06B8  2804          jr   z,$06BE
06BA  CD5806        call $0658
06BD  C9            ret
06BE  CB5F          bit  3,a
06C0  2804          jr   z,$06C6
06C2  CD1806        call $0618
06C5  C9            ret
06C6  CB67          bit  4,a
06C8  2804          jr   z,$06CE
06CA  00            nop
06CB  00            nop
06CC  00            nop
06CD  C9            ret
06CE  CB77          bit  6,a
06D0  C8            ret  z
06D1  00            nop
06D2  00            nop
06D3  00            nop
06D4  C9            ret
06D5  FF            rst  $38
06D6  FF            rst  $38
06D7  FF            rst  $38
06D8  00            nop
06D9  00            nop
06DA  00            nop
06DB  00            nop
06DC  00            nop
06DD  3A0F80        ld   a,($800F)
06E0  3D            dec  a
06E1  320F80        ld   ($800F),a
06E4  CB27          sla  a
06E6  CB27          sla  a
06E8  85            add  a,l
06E9  6F            ld   l,a
06EA  DD214081      ld   ix,$8140
06EE  7E            ld   a,(hl)
06EF  DD8600        add  a,(ix+$00)
06F2  DD7700        ld   (ix+$00),a
06F5  DD7704        ld   (ix+$04),a
06F8  23            inc  hl
06F9  7E            ld   a,(hl)
06FA  DD7701        ld   (ix+$01),a
06FD  23            inc  hl
06FE  7E            ld   a,(hl)
06FF  DD7705        ld   (ix+$05),a
0702  23            inc  hl
0703  7E            ld   a,(hl)
0704  DD8607        add  a,(ix+$07)
0707  DD7707        ld   (ix+$07),a
070A  D610          sub  $10
070C  DD7703        ld   (ix+$03),a
070F  C9            ret
0710  F5            push af
0711  3EA0          ld   a,$A0
0713  324A80        ld   ($804A),a
0716  3E0F          ld   a,$0F
0718  324980        ld   ($8049),a
071B  F1            pop  af
071C  C9            ret
071D  FF            rst  $38
071E  FF            rst  $38
071F  FF            rst  $38
0720  8C            adc  a,h
0721  10FF          djnz $0722
0723  FF            rst  $38
0724  FF            rst  $38
0725  FF            rst  $38
0726  FF            rst  $38
0727  FF            rst  $38
0728  FA8C8D        jp   m,$8D8C
072B  0C            inc  c
072C  FA8E8F        jp   m,$8F8E
072F  0C            inc  c
0730  FA9091        jp   m,$9190
0733  06FA          ld   b,$FA
0735  90            sub  b
0736  96            sub  (hl)
0737  00            nop
0738  FA9091        jp   m,$9190
073B  FAFA8E        jp   m,$8EFA
073E  8F            adc  a,a
073F  F4FA8C        call p,$8CFA
0742  8D            adc  a,l
0743  F4FFFF        call p,$FFFF
0746  FF            rst  $38
0747  FF            rst  $38
0748  FF            rst  $38
0749  FF            rst  $38
074A  FF            rst  $38
074B  FF            rst  $38
074C  FF            rst  $38
074D  FF            rst  $38
074E  FF            rst  $38
074F  FF            rst  $38
0750  060C          ld   b,$0C
0752  0D            dec  c
0753  0C            inc  c
0754  060E          ld   b,$0E
0756  0F            rrca
0757  0C            inc  c
0758  0610          ld   b,$10
075A  110606        ld   de,$0606
075D  1016          djnz $0775
075F  00            nop
0760  0610          ld   b,$10
0762  11FA06        ld   de,$06FA
0765  0E0F          ld   c,$0F
0767  F4060C        call p,$0C06
076A  0D            dec  c
076B  F4FFFF        call p,$FFFF
076E  FF            rst  $38
076F  FF            rst  $38
0770  FF            rst  $38
0771  FF            rst  $38
0772  FF            rst  $38
0773  FF            rst  $38
0774  3A1683        ld   a,($8316)
0777  E607          and  $07
0779  C0            ret  nz
077A  3A1280        ld   a,($8012)
077D  A7            and  a
077E  C0            ret  nz
077F  3A0F80        ld   a,($800F)
0782  A7            and  a
0783  C8            ret  z
0784  3E01          ld   a,$01
0786  320580        ld   ($8005),a
0789  3A0E80        ld   a,($800E)
078C  CB57          bit  2,a
078E  2807          jr   z,$0797
0790  212807        ld   hl,$0728
0793  CDD806        call $06D8
0796  C9            ret
0797  C3E007        jp   $07E0
079A  FF            rst  $38
079B  FF            rst  $38
079C  FF            rst  $38
079D  FF            rst  $38
079E  FF            rst  $38
079F  FF            rst  $38
07A0  3A0580        ld   a,($8005)
07A3  A7            and  a
07A4  C0            ret  nz
07A5  3A0F80        ld   a,($800F)
07A8  A7            and  a
07A9  C0            ret  nz
07AA  CD8809        call $0988
07AD  A7            and  a
07AE  C8            ret  z
07AF  3E07          ld   a,$07
07B1  320F80        ld   ($800F),a
07B4  3E8C          ld   a,$8C
07B6  324181        ld   ($8141),a
07B9  3E8D          ld   a,$8D
07BB  C3F407        jp   $07F4
07BE  C9            ret
07BF  FF            rst  $38
07C0  3A0580        ld   a,($8005)
07C3  A7            and  a
07C4  C0            ret  nz
07C5  3A0F80        ld   a,($800F)
07C8  A7            and  a
07C9  C0            ret  nz
07CA  CD8809        call $0988
07CD  A7            and  a
07CE  C8            ret  z
07CF  3E07          ld   a,$07
07D1  320F80        ld   ($800F),a
07D4  3E0C          ld   a,$0C
07D6  324181        ld   ($8141),a
07D9  3E0D          ld   a,$0D
07DB  C3F407        jp   $07F4
07DE  C9            ret
07DF  FF            rst  $38
07E0  CB5F          bit  3,a
07E2  2807          jr   z,$07EB
07E4  215007        ld   hl,$0750
07E7  CDD806        call $06D8
07EA  C9            ret
07EB  214809        ld   hl,$0948
07EE  CDD806        call $06D8
07F1  C9            ret
07F2  FF            rst  $38
07F3  FF            rst  $38
07F4  324581        ld   ($8145),a
07F7  3E04          ld   a,$04
07F9  324380        ld   ($8043),a
07FC  C9            ret
07FD  FF            rst  $38
07FE  FF            rst  $38
07FF  FF            rst  $38
0800  010000        ld   bc,$0000
0803  00            nop
0804  00            nop
0805  00            nop
0806  00            nop
0807  013A00        ld   bc,$003A
080A  B8            cp   b
080B  214090        ld   hl,$9040
080E  C1            pop  bc
080F  0A            ld   a,(bc)
0810  03            inc  bc
0811  85            add  a,l
0812  6F            ld   l,a
0813  0A            ld   a,(bc)
0814  5F            ld   e,a
0815  3E1B          ld   a,$1B
0817  93            sub  e
0818  5F            ld   e,a
0819  1600          ld   d,$00
081B  CB23          sla  e
081D  CB23          sla  e
081F  CB23          sla  e
0821  19            add  hl,de
0822  19            add  hl,de
0823  19            add  hl,de
0824  19            add  hl,de
0825  03            inc  bc
0826  0A            ld   a,(bc)
0827  5F            ld   e,a
0828  03            inc  bc
0829  0A            ld   a,(bc)
082A  57            ld   d,a
082B  03            inc  bc
082C  C5            push bc
082D  1A            ld   a,(de)
082E  FEFF          cp   $FF
0830  C8            ret  z
0831  13            inc  de
0832  77            ld   (hl),a
0833  06FF          ld   b,$FF
0835  0EE0          ld   c,$E0
0837  09            add  hl,bc
0838  18F3          jr   $082D
083A  FF            rst  $38
083B  FF            rst  $38
083C  FF            rst  $38
083D  FF            rst  $38
083E  FF            rst  $38
083F  FF            rst  $38
0840  E5            push hl
0841  D9            exx
0842  E1            pop  hl
0843  54            ld   d,h
0844  5D            ld   e,l
0845  214090        ld   hl,$9040
0848  C1            pop  bc
0849  0A            ld   a,(bc)
084A  03            inc  bc
084B  85            add  a,l
084C  6F            ld   l,a
084D  0A            ld   a,(bc)
084E  03            inc  bc
084F  C5            push bc
0850  D5            push de
0851  5F            ld   e,a
0852  3E1D          ld   a,$1D
0854  93            sub  e
0855  5F            ld   e,a
0856  1600          ld   d,$00
0858  CB23          sla  e
085A  CB23          sla  e
085C  CB23          sla  e
085E  19            add  hl,de
085F  19            add  hl,de
0860  19            add  hl,de
0861  19            add  hl,de
0862  D1            pop  de
0863  DD212C80      ld   ix,$802C
0867  DD360020      ld   (ix+$00),$20
086B  1A            ld   a,(de)
086C  77            ld   (hl),a
086D  13            inc  de
086E  01E0FF        ld   bc,$FFE0
0871  DD3500        dec  (ix+$00)
0874  AF            xor  a
0875  DDBE00        cp   (ix+$00)
0878  2806          jr   z,$0880
087A  09            add  hl,bc
087B  3A00B8        ld   a,(watchdog)
087E  18EB          jr   $086B
0880  D9            exx
0881  C9            ret
0882  FF            rst  $38
0883  FF            rst  $38
0884  FF            rst  $38
0885  FF            rst  $38
0886  FF            rst  $38
0887  FF            rst  $38
0888  3A0E80        ld   a,($800E)
088B  CB6F          bit  5,a
088D  C0            ret  nz
088E  AF            xor  a
088F  320580        ld   ($8005),a
0892  C9            ret
0893  FF            rst  $38
0894  FF            rst  $38
0895  FF            rst  $38
0896  FF            rst  $38
0897  FF            rst  $38
0898  214081        ld   hl,$8140
089B  3610          ld   (hl),$10
089D  23            inc  hl
089E  360C          ld   (hl),$0C
08A0  23            inc  hl
08A1  3612          ld   (hl),$12
08A3  23            inc  hl
08A4  36CE          ld   (hl),$CE
08A6  23            inc  hl
08A7  3610          ld   (hl),$10
08A9  23            inc  hl
08AA  360D          ld   (hl),$0D
08AC  23            inc  hl
08AD  3612          ld   (hl),$12
08AF  23            inc  hl
08B0  36DE          ld   (hl),$DE
08B2  CD2018        call $1820
08B5  C9            ret
08B6  FF            rst  $38
08B7  FF            rst  $38
08B8  FF            rst  $38
08B9  FF            rst  $38
08BA  FF            rst  $38
08BB  FF            rst  $38
08BC  FF            rst  $38
08BD  FF            rst  $38
08BE  FF            rst  $38
08BF  FF            rst  $38
08C0  3A0580        ld   a,($8005)
08C3  A7            and  a
08C4  C0            ret  nz
08C5  3A0F80        ld   a,($800F)
08C8  A7            and  a
08C9  C0            ret  nz
08CA  CD8809        call $0988
08CD  A7            and  a
08CE  C8            ret  z
08CF  3E07          ld   a,$07
08D1  320F80        ld   ($800F),a
08D4  3E17          ld   a,$17
08D6  324181        ld   ($8141),a
08D9  C33009        jp   $0930
08DC  FF            rst  $38
08DD  FF            rst  $38
08DE  FF            rst  $38
08DF  FF            rst  $38
08E0  FF            rst  $38
08E1  FF            rst  $38
08E2  FF            rst  $38
08E3  FF            rst  $38
08E4  FF            rst  $38
08E5  FF            rst  $38
08E6  FF            rst  $38
08E7  FF            rst  $38
08E8  3A1283        ld   a,($8312)
08EB  E607          and  $07
08ED  2015          jr   nz,$0904
08EF  3A2380        ld   a,($8023)
08F2  3C            inc  a
08F3  E603          and  $03
08F5  00            nop
08F6  00            nop
08F7  00            nop
08F8  322380        ld   ($8023),a
08FB  211809        ld   hl,$0918
08FE  85            add  a,l
08FF  6F            ld   l,a
0900  7E            ld   a,(hl)
0901  324981        ld   ($8149),a
0904  3A1283        ld   a,($8312)
0907  E601          and  $01
0909  C0            ret  nz
090A  3A4881        ld   a,($8148)
090D  3C            inc  a
090E  324881        ld   ($8148),a
0911  C9            ret
0912  FF            rst  $38
0913  FF            rst  $38
0914  FF            rst  $38
0915  FF            rst  $38
0916  FF            rst  $38
0917  FF            rst  $38
0918  29            add  hl,hl
0919  2A2B2A        ld   hl,($2A2B)
091C  FF            rst  $38
091D  FF            rst  $38
091E  FF            rst  $38
091F  FF            rst  $38
0920  A9            xor  c
0921  AA            xor  d
0922  AB            xor  e
0923  AA            xor  d
0924  FF            rst  $38
0925  FF            rst  $38
0926  FF            rst  $38
0927  FF            rst  $38
0928  FF            rst  $38
0929  FF            rst  $38
092A  FF            rst  $38
092B  FF            rst  $38
092C  FF            rst  $38
092D  FF            rst  $38
092E  FF            rst  $38
092F  FF            rst  $38
0930  3E18          ld   a,$18
0932  324581        ld   ($8145),a
0935  3E04          ld   a,$04
0937  324380        ld   ($8043),a
093A  C9            ret
093B  FF            rst  $38
093C  FF            rst  $38
093D  FF            rst  $38
093E  FF            rst  $38
093F  FF            rst  $38
0940  FF            rst  $38
0941  FF            rst  $38
0942  FF            rst  $38
0943  FF            rst  $38
0944  FF            rst  $38
0945  FF            rst  $38
0946  FF            rst  $38
0947  FF            rst  $38
0948  00            nop
0949  17            rla
094A  180C          jr   $0958
094C  00            nop
094D  19            add  hl,de
094E  1A            ld   a,(de)
094F  0C            inc  c
0950  00            nop
0951  1B            dec  de
0952  1C            inc  e
0953  0600          ld   b,$00
0955  9B            sbc  a,e
0956  9C            sbc  a,h
0957  00            nop
0958  00            nop
0959  99            sbc  a,c
095A  9A            sbc  a,d
095B  FA0097        jp   m,$9700
095E  98            sbc  a,b
095F  F40017        call p,$1700
0962  18F4          jr   $0958
0964  FF            rst  $38
0965  FF            rst  $38
0966  FF            rst  $38
0967  FF            rst  $38
0968  45            ld   b,l
0969  AF            xor  a
096A  94            sub  h
096B  E6F8          and  $F8
096D  6F            ld   l,a
096E  2600          ld   h,$00
0970  29            add  hl,hl
0971  29            add  hl,hl
0972  3E90          ld   a,$90
0974  84            add  a,h
0975  67            ld   h,a
0976  78            ld   a,b
0977  CB3F          srl  a
0979  CB3F          srl  a
097B  CB3F          srl  a
097D  85            add  a,l
097E  6F            ld   l,a
097F  C9            ret
0980  FF            rst  $38
0981  FF            rst  $38
0982  FF            rst  $38
0983  FF            rst  $38
0984  FF            rst  $38
0985  FF            rst  $38
0986  FF            rst  $38
0987  FF            rst  $38
0988  3A4781        ld   a,($8147)
098B  C610          add  a,$10
098D  CB3F          srl  a
098F  CB3F          srl  a
0991  E6FE          and  $FE
0993  210081        ld   hl,screen_xoff_col
0996  85            add  a,l
0997  6F            ld   l,a
0998  3A4481        ld   a,($8144)
099B  96            sub  (hl)
099C  C608          add  a,$08
099E  67            ld   h,a
099F  3A4781        ld   a,($8147)
09A2  C610          add  a,$10
09A4  6F            ld   l,a
09A5  CD6809        call $0968
09A8  7E            ld   a,(hl)
09A9  E6F8          and  $F8
09AB  FEF8          cp   $F8
09AD  2802          jr   z,$09B1
09AF  AF            xor  a
09B0  C9            ret
09B1  3E01          ld   a,$01
09B3  C9            ret
09B4  FF            rst  $38
09B5  FF            rst  $38
09B6  FF            rst  $38
09B7  FF            rst  $38
09B8  FF            rst  $38
09B9  FF            rst  $38
09BA  FF            rst  $38
09BB  FF            rst  $38
09BC  FF            rst  $38
09BD  FF            rst  $38
09BE  FF            rst  $38
09BF  FF            rst  $38
09C0  3A1280        ld   a,($8012)
09C3  A7            and  a
09C4  C0            ret  nz
09C5  3A0F80        ld   a,($800F)
09C8  A7            and  a
09C9  281B          jr   z,$09E6
09CB  E60C          and  $0C
09CD  C0            ret  nz
09CE  CD8809        call $0988
09D1  A7            and  a
09D2  C8            ret  z
09D3  AF            xor  a
09D4  320F80        ld   ($800F),a
09D7  3A4181        ld   a,($8141)
09DA  E680          and  $80
09DC  C60C          add  a,$0C
09DE  324181        ld   ($8141),a
09E1  3C            inc  a
09E2  324581        ld   ($8145),a
09E5  C9            ret
09E6  CD8809        call $0988
09E9  A7            and  a
09EA  200B          jr   nz,$09F7
09EC  3A1180        ld   a,($8011)
09EF  A7            and  a
09F0  C0            ret  nz
09F1  3E10          ld   a,$10
09F3  321180        ld   ($8011),a
09F6  C9            ret
09F7  AF            xor  a
09F8  321180        ld   ($8011),a
09FB  CD680A        call $0A68
09FE  C9            ret
09FF  FF            rst  $38
0A00  FF            rst  $38
0A01  FF            rst  $38
0A02  FF            rst  $38
0A03  FF            rst  $38
0A04  FF            rst  $38
0A05  FF            rst  $38
0A06  FF            rst  $38
0A07  FF            rst  $38
0A08  3A1283        ld   a,($8312)
0A0B  E607          and  $07
0A0D  2015          jr   nz,$0A24
0A0F  3A2380        ld   a,($8023)
0A12  3C            inc  a
0A13  E603          and  $03
0A15  00            nop
0A16  00            nop
0A17  00            nop
0A18  322380        ld   ($8023),a
0A1B  212009        ld   hl,$0920
0A1E  85            add  a,l
0A1F  6F            ld   l,a
0A20  7E            ld   a,(hl)
0A21  324981        ld   ($8149),a
0A24  3A1283        ld   a,($8312)
0A27  E601          and  $01
0A29  C0            ret  nz
0A2A  3A4881        ld   a,($8148)
0A2D  3D            dec  a
0A2E  324881        ld   ($8148),a
0A31  C9            ret
0A32  FF            rst  $38
0A33  00            nop
0A34  00            nop
0A35  00            nop
0A36  00            nop
0A37  00            nop
0A38  3E01          ld   a,$01
0A3A  321280        ld   ($8012),a
0A3D  C9            ret
0A3E  FF            rst  $38
0A3F  FF            rst  $38
0A40  3A1180        ld   a,($8011)
0A43  A7            and  a
0A44  C8            ret  z
0A45  3D            dec  a
0A46  321180        ld   ($8011),a
0A49  A7            and  a
0A4A  2004          jr   nz,$0A50
0A4C  CD330A        call $0A33
0A4F  C9            ret
0A50  3A4381        ld   a,($8143)
0A53  3C            inc  a
0A54  3C            inc  a
0A55  324381        ld   ($8143),a
0A58  C610          add  a,$10
0A5A  324781        ld   ($8147),a
0A5D  C9            ret
0A5E  FF            rst  $38
0A5F  FF            rst  $38
0A60  FF            rst  $38
0A61  FF            rst  $38
0A62  FF            rst  $38
0A63  FF            rst  $38
0A64  FF            rst  $38
0A65  FF            rst  $38
0A66  FF            rst  $38
0A67  FF            rst  $38
0A68  3A4381        ld   a,($8143)
0A6B  E6F8          and  $F8
0A6D  324381        ld   ($8143),a
0A70  C610          add  a,$10
0A72  324781        ld   ($8147),a
0A75  C9            ret
0A76  FF            rst  $38
0A77  FF            rst  $38
0A78  FF            rst  $38
0A79  FF            rst  $38
0A7A  FF            rst  $38
0A7B  FF            rst  $38
0A7C  FF            rst  $38
0A7D  FF            rst  $38
0A7E  FF            rst  $38
0A7F  FF            rst  $38
0A80  3A1280        ld   a,($8012)
0A83  A7            and  a
0A84  C0            ret  nz
0A85  3A4381        ld   a,($8143)
0A88  C601          add  a,$01
0A8A  CB3F          srl  a
0A8C  CB3F          srl  a
0A8E  E6FE          and  $FE
0A90  210081        ld   hl,screen_xoff_col
0A93  85            add  a,l
0A94  6F            ld   l,a
0A95  3A4081        ld   a,($8140)
0A98  96            sub  (hl)
0A99  C608          add  a,$08
0A9B  67            ld   h,a
0A9C  3A4381        ld   a,($8143)
0A9F  C601          add  a,$01
0AA1  6F            ld   l,a
0AA2  CD6809        call $0968
0AA5  7E            ld   a,(hl)
0AA6  E6C0          and  $C0
0AA8  FEC0          cp   $C0
0AAA  C0            ret  nz
0AAB  CDB80A        call $0AB8
0AAE  C9            ret
0AAF  FF            rst  $38
0AB0  FF            rst  $38
0AB1  FF            rst  $38
0AB2  FF            rst  $38
0AB3  FF            rst  $38
0AB4  FF            rst  $38
0AB5  FF            rst  $38
0AB6  FF            rst  $38
0AB7  FF            rst  $38
0AB8  3A1180        ld   a,($8011)
0ABB  A7            and  a
0ABC  C0            ret  nz
0ABD  AF            xor  a
0ABE  320F80        ld   ($800F),a
0AC1  3E08          ld   a,$08
0AC3  321180        ld   ($8011),a
0AC6  CDA013        call wait_vblank
0AC9  CDA013        call wait_vblank
0ACC  C9            ret
0ACD  FF            rst  $38
0ACE  FF            rst  $38
0ACF  FF            rst  $38
0AD0  3A0480        ld   a,($8004)
0AD3  A7            and  a
0AD4  2005          jr   nz,$0ADB
0AD6  3A2980        ld   a,($8029)
0AD9  1803          jr   $0ADE
0ADB  3A2A80        ld   a,($802A)
0ADE  3D            dec  a
0ADF  21000B        ld   hl,$0B00
0AE2  CB27          sla  a
0AE4  85            add  a,l
0AE5  6F            ld   l,a
0AE6  4E            ld   c,(hl)
0AE7  23            inc  hl
0AE8  46            ld   b,(hl)
0AE9  218081        ld   hl,$8180
0AEC  1623          ld   d,$23
0AEE  0A            ld   a,(bc)
0AEF  77            ld   (hl),a
0AF0  03            inc  bc
0AF1  23            inc  hl
0AF2  15            dec  d
0AF3  20F9          jr   nz,$0AEE
0AF5  CD9818        call $1898
0AF8  C9            ret
0AF9  FF            rst  $38
0AFA  FF            rst  $38
0AFB  FF            rst  $38
0AFC  FF            rst  $38
0AFD  FF            rst  $38
0AFE  FF            rst  $38
0AFF  FF            rst  $38
0B00  380C          jr   c,$0B0E
0B02  380C          jr   c,$0B10
0B04  380C          jr   c,$0B12
0B06  380C          jr   c,$0B14
0B08  380C          jr   c,$0B16
0B0A  380C          jr   c,$0B18
0B0C  380C          jr   c,$0B1A
0B0E  380C          jr   c,$0B1C
0B10  380C          jr   c,$0B1E
0B12  380C          jr   c,$0B20
0B14  380C          jr   c,$0B22
0B16  380C          jr   c,$0B24
0B18  380C          jr   c,$0B26
0B1A  380C          jr   c,$0B28
0B1C  380C          jr   c,$0B2A
0B1E  100C          djnz $0B2C
0B20  380C          jr   c,$0B2E
0B22  380C          jr   c,$0B30
0B24  100C          djnz $0B32
0B26  380C          jr   c,$0B34
0B28  380C          jr   c,$0B36
0B2A  380C          jr   c,$0B38
0B2C  380C          jr   c,$0B3A
0B2E  380C          jr   c,$0B3C
0B30  380C          jr   c,$0B3E
0B32  380C          jr   c,$0B40
0B34  100C          djnz $0B42
0B36  00            nop
0B37  00            nop
0B38  00            nop
0B39  00            nop
0B3A  00            nop
0B3B  00            nop
0B3C  00            nop
0B3D  00            nop
0B3E  00            nop
0B3F  00            nop
0B40  00            nop
0B41  00            nop
0B42  00            nop
0B43  00            nop
0B44  00            nop
0B45  00            nop
0B46  00            nop
0B47  00            nop
0B48  00            nop
0B49  00            nop
0B4A  00            nop
0B4B  00            nop
0B4C  00            nop
0B4D  00            nop
0B4E  00            nop
0B4F  00            nop
0B50  00            nop
0B51  00            nop
0B52  00            nop
0B53  00            nop
0B54  00            nop
0B55  00            nop
0B56  00            nop
0B57  00            nop
0B58  00            nop
0B59  00            nop
0B5A  00            nop
0B5B  00            nop
0B5C  00            nop
0B5D  00            nop
0B5E  00            nop
0B5F  00            nop
0B60  00            nop
0B61  00            nop
0B62  00            nop
0B63  00            nop
0B64  00            nop
0B65  00            nop
0B66  00            nop
0B67  00            nop
0B68  00            nop
0B69  00            nop
0B6A  00            nop
0B6B  00            nop
0B6C  00            nop
0B6D  00            nop
0B6E  00            nop
0B6F  00            nop
0B70  00            nop
0B71  00            nop
0B72  00            nop
0B73  00            nop
0B74  00            nop
0B75  00            nop
0B76  00            nop
0B77  00            nop
0B78  00            nop
0B79  00            nop
0B7A  00            nop
0B7B  00            nop
0B7C  FF            rst  $38
0B7D  FF            rst  $38
0B7E  FF            rst  $38
0B7F  FF            rst  $38
0B80  DD7E01        ld   a,(ix+$01)
0B83  DD7703        ld   (ix+$03),a
0B86  DDCB0246      bit  0,(ix+$02)
0B8A  200A          jr   nz,$0B96
0B8C  FD3400        inc  (iy+$00)
0B8F  FD3402        inc  (iy+$02)
0B92  FD3404        inc  (iy+$04)
0B95  C9            ret
0B96  FD3500        dec  (iy+$00)
0B99  FD3502        dec  (iy+$02)
0B9C  FD3504        dec  (iy+$04)
0B9F  C9            ret
0BA0  AF            xor  a
0BA1  322D80        ld   ($802D),a
0BA4  C9            ret
0BA5  FF            rst  $38
0BA6  FF            rst  $38
0BA7  FF            rst  $38
0BA8  FF            rst  $38
0BA9  FF            rst  $38
0BAA  FF            rst  $38
0BAB  FF            rst  $38
0BAC  FF            rst  $38
0BAD  FF            rst  $38
0BAE  FF            rst  $38
0BAF  FF            rst  $38
0BB0  DD218081      ld   ix,$8180
0BB4  FD213881      ld   iy,$8138
0BB8  1609          ld   d,$09
0BBA  DD7E01        ld   a,(ix+$01)
0BBD  A7            and  a
0BBE  2826          jr   z,$0BE6
0BC0  DD7E02        ld   a,(ix+$02)
0BC3  E6FE          and  $FE
0BC5  200F          jr   nz,$0BD6
0BC7  DD7E00        ld   a,(ix+$00)
0BCA  E6FE          and  $FE
0BCC  DD8602        add  a,(ix+$02)
0BCF  EE01          xor  $01
0BD1  DD7702        ld   (ix+$02),a
0BD4  1806          jr   $0BDC
0BD6  DD3502        dec  (ix+$02)
0BD9  DD3502        dec  (ix+$02)
0BDC  DD7E03        ld   a,(ix+$03)
0BDF  A7            and  a
0BE0  CC800B        call z,$0B80
0BE3  DD3503        dec  (ix+$03)
0BE6  FD2B          dec  iy
0BE8  FD2B          dec  iy
0BEA  FD2B          dec  iy
0BEC  FD2B          dec  iy
0BEE  FD2B          dec  iy
0BF0  FD2B          dec  iy
0BF2  DD23          inc  ix
0BF4  DD23          inc  ix
0BF6  DD23          inc  ix
0BF8  DD23          inc  ix
0BFA  15            dec  d
0BFB  20BD          jr   nz,$0BBA
0BFD  C9            ret
0BFE  FF            rst  $38
0BFF  FF            rst  $38
0C00  FF            rst  $38
0C01  FF            rst  $38
0C02  FF            rst  $38
0C03  FF            rst  $38
0C04  FF            rst  $38
0C05  FF            rst  $38
0C06  FF            rst  $38
0C07  FF            rst  $38
0C08  FF            rst  $38
0C09  FF            rst  $38
0C0A  FF            rst  $38
0C0B  FF            rst  $38
0C0C  FF            rst  $38
0C0D  FF            rst  $38
0C0E  FF            rst  $38
0C0F  FF            rst  $38
0C10  00            nop
0C11  00            nop
0C12  00            nop
0C13  00            nop
0C14  00            nop
0C15  00            nop
0C16  00            nop
0C17  00            nop
0C18  00            nop
0C19  00            nop
0C1A  00            nop
0C1B  00            nop
0C1C  F0            ret  p
0C1D  03            inc  bc
0C1E  80            add  a,b
0C1F  03            inc  bc
0C20  00            nop
0C21  00            nop
0C22  00            nop
0C23  00            nop
0C24  00            nop
0C25  00            nop
0C26  00            nop
0C27  00            nop
0C28  00            nop
0C29  00            nop
0C2A  00            nop
0C2B  00            nop
0C2C  00            nop
0C2D  00            nop
0C2E  00            nop
0C2F  00            nop
0C30  00            nop
0C31  00            nop
0C32  00            nop
0C33  00            nop
0C34  FF            rst  $38
0C35  FF            rst  $38
0C36  FF            rst  $38
0C37  FF            rst  $38
0C38  00            nop
0C39  00            nop
0C3A  00            nop
0C3B  00            nop
0C3C  00            nop
0C3D  00            nop
0C3E  00            nop
0C3F  00            nop
0C40  00            nop
0C41  00            nop
0C42  00            nop
0C43  00            nop
0C44  00            nop
0C45  00            nop
0C46  00            nop
0C47  00            nop
0C48  00            nop
0C49  00            nop
0C4A  00            nop
0C4B  00            nop
0C4C  00            nop
0C4D  00            nop
0C4E  00            nop
0C4F  00            nop
0C50  00            nop
0C51  00            nop
0C52  00            nop
0C53  00            nop
0C54  00            nop
0C55  00            nop
0C56  00            nop
0C57  00            nop
0C58  00            nop
0C59  00            nop
0C5A  00            nop
0C5B  00            nop
0C5C  FF            rst  $38
0C5D  FF            rst  $38
0C5E  FF            rst  $38
0C5F  FF            rst  $38
0C60  3A1280        ld   a,($8012)
0C63  A7            and  a
0C64  C8            ret  z
0C65  CDA013        call wait_vblank
0C68  3A4381        ld   a,($8143)
0C6B  3C            inc  a
0C6C  3C            inc  a
0C6D  3C            inc  a
0C6E  324381        ld   ($8143),a
0C71  C610          add  a,$10
0C73  324781        ld   ($8147),a
0C76  37            scf
0C77  3F            ccf
0C78  C610          add  a,$10
0C7A  3812          jr   c,$0C8E
0C7C  3A4081        ld   a,($8140)
0C7F  67            ld   h,a
0C80  3A4781        ld   a,($8147)
0C83  C620          add  a,$20
0C85  6F            ld   l,a
0C86  CD6809        call $0968
0C89  7E            ld   a,(hl)
0C8A  FE10          cp   $10
0C8C  28D7          jr   z,$0C65
0C8E  CDC00C        call $0CC0
0C91  AF            xor  a
0C92  321280        ld   ($8012),a
0C95  CD2002        call $0220
0C98  C9            ret
0C99  FF            rst  $38
0C9A  FF            rst  $38
0C9B  FF            rst  $38
0C9C  FF            rst  $38
0C9D  FF            rst  $38
0C9E  FF            rst  $38
0C9F  FF            rst  $38
0CA0  1E08          ld   e,$08
0CA2  CDA013        call wait_vblank
0CA5  1D            dec  e
0CA6  20FA          jr   nz,$0CA2
0CA8  C9            ret
0CA9  FF            rst  $38
0CAA  FF            rst  $38
0CAB  FF            rst  $38
0CAC  FF            rst  $38
0CAD  FF            rst  $38
0CAE  FF            rst  $38
0CAF  FF            rst  $38
0CB0  1E03          ld   e,$03
0CB2  CD300D        call $0D30
0CB5  CD600D        call $0D60
0CB8  CDA013        call wait_vblank
0CBB  1D            dec  e
0CBC  20F4          jr   nz,$0CB2
0CBE  C9            ret
0CBF  FF            rst  $38
0CC0  3E02          ld   a,$02
0CC2  324280        ld   ($8042),a
0CC5  326580        ld   ($8065),a
0CC8  CDA00B        call $0BA0
0CCB  CD140D        call $0D14
0CCE  CDA00C        call $0CA0
0CD1  3E26          ld   a,$26
0CD3  324181        ld   ($8141),a
0CD6  3E27          ld   a,$27
0CD8  324581        ld   ($8145),a
0CDB  3A4781        ld   a,($8147)
0CDE  324381        ld   ($8143),a
0CE1  3A4081        ld   a,($8140)
0CE4  D610          sub  $10
0CE6  324081        ld   ($8140),a
0CE9  CDA00C        call $0CA0
0CEC  3A4081        ld   a,($8140)
0CEF  C608          add  a,$08
0CF1  325C81        ld   ($815C),a
0CF4  3E28          ld   a,$28
0CF6  325D81        ld   ($815D),a
0CF9  3E11          ld   a,$11
0CFB  325E81        ld   ($815E),a
0CFE  3A4381        ld   a,($8143)
0D01  D610          sub  $10
0D03  325F81        ld   ($815F),a
0D06  1628          ld   d,$28
0D08  CDB00C        call $0CB0
0D0B  3A5F81        ld   a,($815F)
0D0E  3D            dec  a
0D0F  3D            dec  a
0D10  325F81        ld   ($815F),a
0D13  15            dec  d
0D14  20F2          jr   nz,$0D08
0D16  C9            ret
0D17  1608          ld   d,$08
0D19  3A4381        ld   a,($8143)
0D1C  3C            inc  a
0D1D  3C            inc  a
0D1E  3C            inc  a
0D1F  324381        ld   ($8143),a
0D22  C610          add  a,$10
0D24  324781        ld   ($8147),a
0D27  CDA013        call wait_vblank
0D2A  15            dec  d
0D2B  20EC          jr   nz,$0D19
0D2D  C9            ret
0D2E  FF            rst  $38
0D2F  FF            rst  $38
0D30  3A2480        ld   a,($8024)
0D33  A7            and  a
0D34  C0            ret  nz
0D35  3E10          ld   a,$10
0D37  322480        ld   ($8024),a
0D3A  C9            ret
0D3B  FF            rst  $38
0D3C  FF            rst  $38
0D3D  FF            rst  $38
0D3E  FF            rst  $38
0D3F  FF            rst  $38
0D40  C9            ret
0D41  3A4881        ld   a,($8148)
0D44  67            ld   h,a
0D45  324B81        ld   ($814B),a
0D48  C610          add  a,$10
0D4A  6F            ld   l,a
0D4B  CD6809        call $0968
0D4E  7E            ld   a,(hl)
0D4F  37            scf
0D50  3F            ccf
0D51  D6C0          sub  $C0
0D53  D8            ret  c
0D54  AF            xor  a
0D55  322480        ld   ($8024),a
0D58  C9            ret
0D59  FF            rst  $38
0D5A  FF            rst  $38
0D5B  FF            rst  $38
0D5C  FF            rst  $38
0D5D  FF            rst  $38
0D5E  FF            rst  $38
0D5F  FF            rst  $38
0D60  CD400D        call $0D40
0D63  3A2480        ld   a,($8024)
0D66  A7            and  a
0D67  C8            ret  z
0D68  3D            dec  a
0D69  322480        ld   ($8024),a
0D6C  E608          and  $08
0D6E  2809          jr   z,$0D79
0D70  3A4B81        ld   a,($814B)
0D73  3D            dec  a
0D74  3D            dec  a
0D75  324B81        ld   ($814B),a
0D78  C9            ret
0D79  3A4B81        ld   a,($814B)
0D7C  3C            inc  a
0D7D  3C            inc  a
0D7E  324B81        ld   ($814B),a
0D81  C9            ret
0D82  FF            rst  $38
0D83  FF            rst  $38
0D84  FF            rst  $38
0D85  FF            rst  $38
0D86  FF            rst  $38
0D87  FF            rst  $38
0D88  3A1283        ld   a,($8312)
0D8B  E607          and  $07
0D8D  C0            ret  nz
0D8E  3A2380        ld   a,($8023)
0D91  3C            inc  a
0D92  E603          and  $03
0D94  00            nop
0D95  00            nop
0D96  00            nop
0D97  322380        ld   ($8023),a
0D9A  21B00D        ld   hl,$0DB0
0D9D  85            add  a,l
0D9E  6F            ld   l,a
0D9F  7E            ld   a,(hl)
0DA0  324981        ld   ($8149),a
0DA3  C9            ret
0DA4  FF            rst  $38
0DA5  FF            rst  $38
0DA6  FF            rst  $38
0DA7  FF            rst  $38
0DA8  FF            rst  $38
0DA9  FF            rst  $38
0DAA  FF            rst  $38
0DAB  FF            rst  $38
0DAC  FF            rst  $38
0DAD  FF            rst  $38
0DAE  FF            rst  $38
0DAF  FF            rst  $38
0DB0  05            dec  b
0DB1  0607          ld   b,$07
0DB3  08            ex   af,af'
0DB4  FF            rst  $38
0DB5  FF            rst  $38
0DB6  FF            rst  $38
0DB7  FF            rst  $38
0DB8  AF            xor  a
0DB9  322480        ld   ($8024),a
0DBC  322580        ld   ($8025),a
0DBF  322780        ld   ($8027),a
0DC2  3A0480        ld   a,($8004)
0DC5  A7            and  a
0DC6  2005          jr   nz,$0DCD
0DC8  3A2980        ld   a,($8029)
0DCB  1803          jr   $0DD0
0DCD  3A2A80        ld   a,($802A)
0DD0  3D            dec  a
0DD1  CB27          sla  a
0DD3  21000E        ld   hl,$0E00
0DD6  85            add  a,l
0DD7  6F            ld   l,a
0DD8  7E            ld   a,(hl)
0DD9  324881        ld   ($8148),a
0DDC  23            inc  hl
0DDD  7E            ld   a,(hl)
0DDE  324B81        ld   ($814B),a
0DE1  3E12          ld   a,$12
0DE3  324A81        ld   ($814A),a
0DE6  3E05          ld   a,$05
0DE8  324981        ld   ($8149),a
0DEB  C9            ret
0DEC  FF            rst  $38
0DED  FF            rst  $38
0DEE  FF            rst  $38
0DEF  FF            rst  $38
0DF0  FF            rst  $38
0DF1  FF            rst  $38
0DF2  FF            rst  $38
0DF3  FF            rst  $38
0DF4  FF            rst  $38
0DF5  FF            rst  $38
0DF6  FF            rst  $38
0DF7  FF            rst  $38
0DF8  FF            rst  $38
0DF9  FF            rst  $38
0DFA  FF            rst  $38
0DFB  FF            rst  $38
0DFC  FF            rst  $38
0DFD  FF            rst  $38
0DFE  FF            rst  $38
0DFF  FF            rst  $38
0E00  E0            ret  po
0E01  38E0          jr   c,$0DE3
0E03  38E0          jr   c,$0DE5
0E05  38E0          jr   c,$0DE7
0E07  38E0          jr   c,$0DE9
0E09  38E0          jr   c,$0DEB
0E0B  38E0          jr   c,$0DED
0E0D  38E0          jr   c,$0DEF
0E0F  38E0          jr   c,$0DF1
0E11  38E0          jr   c,$0DF3
0E13  38E0          jr   c,$0DF5
0E15  38E0          jr   c,$0DF7
0E17  38E0          jr   c,$0DF9
0E19  38E0          jr   c,$0DFB
0E1B  38E0          jr   c,$0DFD
0E1D  38D0          jr   c,$0DEF
0E1F  38E0          jr   c,$0E01
0E21  38E0          jr   c,$0E03
0E23  38D0          jr   c,$0DF5
0E25  38E0          jr   c,$0E07
0E27  38E0          jr   c,$0E09
0E29  38E0          jr   c,$0E0B
0E2B  38E0          jr   c,$0E0D
0E2D  38E0          jr   c,$0E0F
0E2F  38E0          jr   c,$0E11
0E31  38E0          jr   c,$0E13
0E33  38D0          jr   c,$0E05
0E35  3800          jr   c,$0E37
0E37  00            nop
0E38  00            nop
0E39  00            nop
0E3A  00            nop
0E3B  00            nop
0E3C  00            nop
0E3D  00            nop
0E3E  FF            rst  $38
0E3F  FF            rst  $38
0E40  3A2580        ld   a,($8025)
0E43  E603          and  $03
0E45  2005          jr   nz,$0E4C
0E47  CD880D        call $0D88
0E4A  180C          jr   $0E58
0E4C  FE01          cp   $01
0E4E  2005          jr   nz,$0E55
0E50  CDE808        call $08E8
0E53  1803          jr   $0E58
0E55  CD080A        call $0A08
0E58  3A2580        ld   a,($8025)
0E5B  CB57          bit  2,a
0E5D  C8            ret  z
0E5E  CD300D        call $0D30
0E61  C9            ret
0E62  FF            rst  $38
0E63  FF            rst  $38
0E64  FF            rst  $38
0E65  FF            rst  $38
0E66  FF            rst  $38
0E67  FF            rst  $38
0E68  FF            rst  $38
0E69  FF            rst  $38
0E6A  FF            rst  $38
0E6B  FF            rst  $38
0E6C  FF            rst  $38
0E6D  FF            rst  $38
0E6E  FF            rst  $38
0E6F  FF            rst  $38
0E70  3A1283        ld   a,($8312)
0E73  E607          and  $07
0E75  C0            ret  nz
0E76  3A0480        ld   a,($8004)
0E79  A7            and  a
0E7A  2005          jr   nz,$0E81
0E7C  3A2980        ld   a,($8029)
0E7F  1803          jr   $0E84
0E81  3A2A80        ld   a,($802A)
0E84  47            ld   b,a
0E85  CD300F        call $0F30
0E88  78            ld   a,b
0E89  3D            dec  a
0E8A  CB27          sla  a
0E8C  21C00E        ld   hl,$0EC0
0E8F  85            add  a,l
0E90  6F            ld   l,a
0E91  4E            ld   c,(hl)
0E92  23            inc  hl
0E93  46            ld   b,(hl)
0E94  C5            push bc
0E95  E1            pop  hl
0E96  3A2780        ld   a,($8027)
0E99  3C            inc  a
0E9A  FE20          cp   $20
0E9C  2001          jr   nz,$0E9F
0E9E  AF            xor  a
0E9F  322780        ld   ($8027),a
0EA2  85            add  a,l
0EA3  6F            ld   l,a
0EA4  7E            ld   a,(hl)
0EA5  322580        ld   ($8025),a
0EA8  C9            ret
0EA9  FF            rst  $38
0EAA  FF            rst  $38
0EAB  FF            rst  $38
0EAC  FF            rst  $38
0EAD  FF            rst  $38
0EAE  FF            rst  $38
0EAF  FF            rst  $38
0EB0  FF            rst  $38
0EB1  FF            rst  $38
0EB2  FF            rst  $38
0EB3  FF            rst  $38
0EB4  FF            rst  $38
0EB5  FF            rst  $38
0EB6  FF            rst  $38
0EB7  FF            rst  $38
0EB8  FF            rst  $38
0EB9  FF            rst  $38
0EBA  FF            rst  $38
0EBB  FF            rst  $38
0EBC  FF            rst  $38
0EBD  FF            rst  $38
0EBE  FF            rst  $38
0EBF  FF            rst  $38
0EC0  08            ex   af,af'
0EC1  0F            rrca
0EC2  08            ex   af,af'
0EC3  0F            rrca
0EC4  68            ld   l,b
0EC5  0F            rrca
0EC6  08            ex   af,af'
0EC7  0F            rrca
0EC8  08            ex   af,af'
0EC9  0F            rrca
0ECA  68            ld   l,b
0ECB  0F            rrca
0ECC  08            ex   af,af'
0ECD  0F            rrca
0ECE  08            ex   af,af'
0ECF  0F            rrca
0ED0  68            ld   l,b
0ED1  0F            rrca
0ED2  08            ex   af,af'
0ED3  0F            rrca
0ED4  68            ld   l,b
0ED5  0F            rrca
0ED6  08            ex   af,af'
0ED7  0F            rrca
0ED8  08            ex   af,af'
0ED9  0F            rrca
0EDA  68            ld   l,b
0EDB  0F            rrca
0EDC  08            ex   af,af'
0EDD  0F            rrca
0EDE  08            ex   af,af'
0EDF  0F            rrca
0EE0  08            ex   af,af'
0EE1  0F            rrca
0EE2  08            ex   af,af'
0EE3  0F            rrca
0EE4  08            ex   af,af'
0EE5  0F            rrca
0EE6  08            ex   af,af'
0EE7  0F            rrca
0EE8  68            ld   l,b
0EE9  0F            rrca
0EEA  68            ld   l,b
0EEB  0F            rrca
0EEC  08            ex   af,af'
0EED  0F            rrca
0EEE  68            ld   l,b
0EEF  0F            rrca
0EF0  68            ld   l,b
0EF1  0F            rrca
0EF2  08            ex   af,af'
0EF3  0F            rrca
0EF4  08            ex   af,af'
0EF5  0F            rrca
0EF6  00            nop
0EF7  00            nop
0EF8  00            nop
0EF9  00            nop
0EFA  00            nop
0EFB  00            nop
0EFC  00            nop
0EFD  00            nop
0EFE  00            nop
0EFF  00            nop
0F00  FF            rst  $38
0F01  FF            rst  $38
0F02  FF            rst  $38
0F03  FF            rst  $38
0F04  FF            rst  $38
0F05  FF            rst  $38
0F06  FF            rst  $38
0F07  FF            rst  $38
0F08  010101        ld   bc,$0101
0F0B  010605        ld   bc,$0506
0F0E  02            ld   (bc),a
0F0F  02            ld   (bc),a
0F10  02            ld   (bc),a
0F11  02            ld   (bc),a
0F12  04            inc  b
0F13  00            nop
0F14  00            nop
0F15  00            nop
0F16  00            nop
0F17  00            nop
0F18  00            nop
0F19  04            inc  b
0F1A  02            ld   (bc),a
0F1B  02            ld   (bc),a
0F1C  02            ld   (bc),a
0F1D  02            ld   (bc),a
0F1E  05            dec  b
0F1F  0601          ld   b,$01
0F21  010101        ld   bc,$0101
0F24  00            nop
0F25  00            nop
0F26  00            nop
0F27  00            nop
0F28  FF            rst  $38
0F29  FF            rst  $38
0F2A  FF            rst  $38
0F2B  FF            rst  $38
0F2C  FF            rst  $38
0F2D  FF            rst  $38
0F2E  FF            rst  $38
0F2F  FF            rst  $38
0F30  3A4881        ld   a,($8148)
0F33  37            scf
0F34  3F            ccf
0F35  C608          add  a,$08
0F37  300B          jr   nc,$0F44
0F39  AF            xor  a
0F3A  322580        ld   ($8025),a
0F3D  3EFF          ld   a,$FF
0F3F  324881        ld   ($8148),a
0F42  E1            pop  hl
0F43  C9            ret
0F44  3A4381        ld   a,($8143)
0F47  37            scf
0F48  3F            ccf
0F49  D660          sub  $60
0F4B  3801          jr   c,$0F4E
0F4D  C9            ret
0F4E  3A4081        ld   a,($8140)
0F51  37            scf
0F52  3F            ccf
0F53  C670          add  a,$70
0F55  D0            ret  nc
0F56  3E01          ld   a,$01
0F58  322580        ld   ($8025),a
0F5B  E1            pop  hl
0F5C  C9            ret
0F5D  FF            rst  $38
0F5E  FF            rst  $38
0F5F  FF            rst  $38
0F60  FF            rst  $38
0F61  FF            rst  $38
0F62  FF            rst  $38
0F63  FF            rst  $38
0F64  FF            rst  $38
0F65  FF            rst  $38
0F66  FF            rst  $38
0F67  FF            rst  $38
0F68  00            nop
0F69  00            nop
0F6A  00            nop
0F6B  00            nop
0F6C  04            inc  b
0F6D  00            nop
0F6E  00            nop
0F6F  00            nop
0F70  04            inc  b
0F71  00            nop
0F72  00            nop
0F73  00            nop
0F74  04            inc  b
0F75  00            nop
0F76  00            nop
0F77  00            nop
0F78  00            nop
0F79  00            nop
0F7A  00            nop
0F7B  00            nop
0F7C  04            inc  b
0F7D  00            nop
0F7E  00            nop
0F7F  00            nop
0F80  04            inc  b
0F81  00            nop
0F82  00            nop
0F83  00            nop
0F84  04            inc  b
0F85  00            nop
0F86  00            nop
0F87  00            nop
0F88  CD1003        call draw_tiles_h
0F8B  02            ld   (bc),a
0F8C  02            ld   (bc),a
0F8D  E0            ret  po
0F8E  E7            rst  $20
0F8F  E7            rst  $20
0F90  E7            rst  $20
0F91  E7            rst  $20
0F92  E7            rst  $20
0F93  E7            rst  $20
0F94  E7            rst  $20
0F95  E7            rst  $20
0F96  E7            rst  $20
0F97  E7            rst  $20
0F98  E7            rst  $20
0F99  E7            rst  $20
0F9A  E7            rst  $20
0F9B  E7            rst  $20
0F9C  E7            rst  $20
0F9D  E7            rst  $20
0F9E  E7            rst  $20
0F9F  E7            rst  $20
0FA0  E7            rst  $20
0FA1  E7            rst  $20
0FA2  E7            rst  $20
0FA3  E7            rst  $20
0FA4  DF            rst  $18
0FA5  FF            rst  $38
0FA6  CDD83B        call $3BD8
0FA9  02            ld   (bc),a
0FAA  03            inc  bc
0FAB  E6E6          and  $E6
0FAD  E6E6          and  $E6
0FAF  E6E6          and  $E6
0FB1  E6E6          and  $E6
0FB3  E6E6          and  $E6
0FB5  E6E6          and  $E6
0FB7  E6E6          and  $E6
0FB9  E6E6          and  $E6
0FBB  E6E6          and  $E6
0FBD  E6E6          and  $E6
0FBF  E6E6          and  $E6
0FC1  E6E6          and  $E6
0FC3  FF            rst  $38
0FC4  C3D61B        jp   $1BD6
0FC7  FF            rst  $38
0FC8  FF            rst  $38
0FC9  FF            rst  $38
0FCA  FF            rst  $38
0FCB  FF            rst  $38
0FCC  FF            rst  $38
0FCD  FF            rst  $38
0FCE  FF            rst  $38
0FCF  FF            rst  $38
0FD0  FF            rst  $38
0FD1  0F            rrca
0FD2  FF            rst  $38
0FD3  FF            rst  $38
0FD4  FF            rst  $38
0FD5  FF            rst  $38
0FD6  FF            rst  $38
0FD7  FF            rst  $38
0FD8  FF            rst  $38
0FD9  FF            rst  $38
0FDA  FF            rst  $38
0FDB  FF            rst  $38
0FDC  FF            rst  $38
0FDD  0F            rrca
0FDE  FF            rst  $38
0FDF  FF            rst  $38
0FE0  1010          djnz $0FF2
0FE2  1010          djnz $0FF4
0FE4  201C          jr   nz,$1002
0FE6  011010        ld   bc,$1010
0FE9  1010          djnz $0FFB
0FEB  1819          jr   $1006
0FED  17            rla
0FEE  182B          jr   $101B
0FF0  23            inc  hl
0FF1  13            inc  de
0FF2  1F            rra
0FF3  221510        ld   ($1015),hl
0FF6  1010          djnz $1008
0FF8  1020          djnz $101A
0FFA  1C            inc  e
0FFB  02            ld   (bc),a
0FFC  1010          djnz $100E
0FFE  10FF          djnz $0FFF
1000  3E50          ld   a,$50
1002  321B80        ld   ($801B),a
1005  AF            xor  a
1006  320E80        ld   ($800E),a
1009  320F80        ld   ($800F),a
100C  321280        ld   ($8012),a
100F  321180        ld   ($8011),a
1012  325180        ld   ($8051),a
1015  326080        ld   ($8060),a
1018  326280        ld   ($8062),a
101B  3E20          ld   a,$20
101D  323080        ld   ($8030),a
1020  CD801B        call $1B80
1023  CD7014        call reset_xoff_sprites_and_clear_screen
1026  21E00F        ld   hl,$0FE0
1029  CD4008        call $0840
102C  00            nop
102D  00            nop
102E  CDD016        call $16D0
1031  CD3830        call $3038
1034  CD5024        call $2450
1037  CDA003        call $03A0
103A  CD9808        call $0898
103D  CDB812        call $12B8
1040  CDD00A        call $0AD0
1043  CDB80D        call $0DB8
1046  3E02          ld   a,$02
1048  323F81        ld   ($813F),a
104B  CDE010        call $10E0
104E  CD3011        call $1130
1051  CD7011        call $1170
1054  CDA013        call wait_vblank
1057  3A00B8        ld   a,(watchdog)
105A  3A0040        ld   a,($4000)
105D  18EC          jr   $104B
105F  FF            rst  $38
1060  F0            ret  p
1061  FF            rst  $38
1062  FF            rst  $38
1063  FF            rst  $38
1064  FF            rst  $38
1065  FF            rst  $38
1066  FF            rst  $38
1067  FF            rst  $38
1068  FF            rst  $38
1069  FF            rst  $38
106A  FF            rst  $38
106B  FF            rst  $38
106C  FF            rst  $38
106D  FF            rst  $38
106E  FF            rst  $38
106F  FF            rst  $38
1070  3A0480        ld   a,($8004)
1073  A7            and  a
1074  2004          jr   nz,$107A
1076  CD8010        call $1080
1079  C9            ret
107A  CDA810        call $10A8
107D  C9            ret
107E  FF            rst  $38
107F  FF            rst  $38
1080  3A7080        ld   a,($8070)
1083  A7            and  a
1084  C0            ret  nz
1085  3A1580        ld   a,($8015)
1088  37            scf
1089  3F            ccf
108A  D615          sub  $15
108C  D8            ret  c
108D  3E01          ld   a,$01
108F  327080        ld   ($8070),a
1092  3A3280        ld   a,($8032)
1095  3C            inc  a
1096  323280        ld   ($8032),a
1099  CDA003        call $03A0
109C  3E08          ld   a,$08
109E  324480        ld   ($8044),a
10A1  C9            ret
10A2  FF            rst  $38
10A3  FF            rst  $38
10A4  FF            rst  $38
10A5  FF            rst  $38
10A6  FF            rst  $38
10A7  FF            rst  $38
10A8  3A7180        ld   a,($8071)
10AB  A7            and  a
10AC  C0            ret  nz
10AD  3A1880        ld   a,($8018)
10B0  37            scf
10B1  3F            ccf
10B2  D615          sub  $15
10B4  D8            ret  c
10B5  3E01          ld   a,$01
10B7  327180        ld   ($8071),a
10BA  3A3380        ld   a,($8033)
10BD  3C            inc  a
10BE  323380        ld   ($8033),a
10C1  CDA003        call $03A0
10C4  3E08          ld   a,$08
10C6  324480        ld   ($8044),a
10C9  C9            ret
10CA  FF            rst  $38
10CB  FF            rst  $38
10CC  FF            rst  $38
10CD  FF            rst  $38
10CE  FF            rst  $38
10CF  FF            rst  $38
10D0  FF            rst  $38
10D1  FF            rst  $38
10D2  FF            rst  $38
10D3  FF            rst  $38
10D4  FF            rst  $38
10D5  FF            rst  $38
10D6  FF            rst  $38
10D7  FF            rst  $38
10D8  FF            rst  $38
10D9  FF            rst  $38
10DA  FF            rst  $38
10DB  FF            rst  $38
10DC  FF            rst  $38
10DD  FF            rst  $38
10DE  FF            rst  $38
10DF  FF            rst  $38
10E0  3A0080        ld   a,($8000)
10E3  3C            inc  a
10E4  FE03          cp   $03
10E6  2001          jr   nz,$10E9
10E8  AF            xor  a
10E9  320080        ld   ($8000),a
10EC  CB27          sla  a
10EE  CB27          sla  a
10F0  CD9013        call jump_rel_a
10F3  CD0017        call $1700
10F6  C9            ret
10F7  CD7010        call $1070
10FA  C9            ret
10FB  CD1825        call $2518
10FE  C9            ret

10FF  FF            db   $ff

                ;; Ticks the main ticks and speed timers
                tick_ticks:
1100  3A1283        ld   a,($8312)
1103  3C            inc  a
1104  321283        ld   ($8312),a
1107  CD8016        call $1680
110A  C9            ret

110B  FF            dc   5,$ff

1110  F5            push af
1111  E5            push hl
1112  216680        ld   hl,$8066
1115  AF            xor  a
1116  BE            cp   (hl)
1117  2008          jr   nz,$1121
1119  23            inc  hl
111A  BE            cp   (hl)
111B  2004          jr   nz,$1121
111D  23            inc  hl
111E  BE            cp   (hl)
111F  2805          jr   z,$1126
1121  7E            ld   a,(hl)
1122  3600          ld   (hl),$00
1124  C618          add  a,$18
1126  E67F          and  $7F
1128  00            nop
1129  00            nop
112A  E1            pop  hl
112B  F1            pop  af
112C  C9            ret
112D  FF            rst  $38
112E  FF            rst  $38
112F  FF            rst  $38
1130  3A0180        ld   a,($8001)
1133  3C            inc  a
1134  FE06          cp   $06
1136  2001          jr   nz,$1139
1138  AF            xor  a
1139  320180        ld   ($8001),a
113C  CB27          sla  a
113E  CB27          sla  a
1140  CD9013        call jump_rel_a
1143  CD023C        call $3C02
1146  C9            ret
1147  00            nop
1148  00            nop
1149  00            nop
114A  C9            ret
114B  00            nop
114C  00            nop
114D  00            nop
114E  C9            ret
114F  00            nop
1150  00            nop
1151  00            nop
1152  C9            ret
1153  00            nop
1154  00            nop
1155  00            nop
1156  C9            ret
1157  00            nop
1158  00            nop
1159  00            nop
115A  C9            ret
115B  00            nop
115C  00            nop
115D  00            nop
115E  C9            ret
115F  FF            rst  $38
1160  FF            rst  $38
1161  FF            rst  $38
1162  FF            rst  $38
1163  FF            rst  $38
1164  FF            rst  $38
1165  FF            rst  $38
1166  FF            rst  $38
1167  FF            rst  $38
1168  FF            rst  $38
1169  FF            rst  $38
116A  FF            rst  $38
116B  FF            rst  $38
116C  FF            rst  $38
116D  FF            rst  $38
116E  FF            rst  $38
116F  FF            rst  $38
1170  CD041A        call $1A04
1173  CDD013        call $13D0
1176  CDD005        call $05D0
1179  CD8806        call $0688
117C  CD7407        call $0774
117F  CD400A        call $0A40
1182  CD600C        call $0C60
1185  CDC009        call $09C0
1188  CD800A        call $0A80
118B  CDB00B        call $0BB0
118E  CD0012        call $1200
1191  CD9012        call $1290
1194  CD5017        call $1750
1197  CD8808        call $0888
119A  CD600D        call $0D60
119D  CD400D        call $0D40
11A0  CD400E        call $0E40
11A3  CD700E        call $0E70
11A6  CDF019        call $19F0
11A9  CDBA04        call $04BA
11AC  CD502B        call $2B50
11AF  CDA83B        call $3BA8
11B2  212000        ld   hl,$0020
11B5  CDE301        call $01E3
11B8  C9            ret
11B9  FF            rst  $38
11BA  FF            rst  $38
11BB  FF            rst  $38
11BC  FF            rst  $38
11BD  FF            rst  $38
11BE  FF            rst  $38
11BF  FF            rst  $38
11C0  3A5881        ld   a,($8158)
11C3  FE70          cp   $70
11C5  2814          jr   z,$11DB
11C7  FE71          cp   $71
11C9  2810          jr   z,$11DB
11CB  FE72          cp   $72
11CD  280C          jr   z,$11DB
11CF  FE73          cp   $73
11D1  2808          jr   z,$11DB
11D3  FE74          cp   $74
11D5  2804          jr   z,$11DB
11D7  FE00          cp   $00
11D9  2003          jr   nz,$11DE
11DB  CD6039        call $3960
11DE  3A5C81        ld   a,($815C)
11E1  FE60          cp   $60
11E3  2814          jr   z,$11F9
11E5  FE61          cp   $61
11E7  2810          jr   z,$11F9
11E9  FE62          cp   $62
11EB  280C          jr   z,$11F9
11ED  FE63          cp   $63
11EF  2808          jr   z,$11F9
11F1  FE64          cp   $64
11F3  2804          jr   z,$11F9
11F5  FE00          cp   $00
11F7  2003          jr   nz,$11FC
11F9  CD8839        call $3988
11FC  C9            ret
11FD  FF            rst  $38
11FE  FF            rst  $38
11FF  FF            rst  $38
1200  3A4781        ld   a,($8147)
1203  47            ld   b,a
1204  3A0280        ld   a,($8002)
1207  B8            cp   b
1208  201E          jr   nz,$1228
120A  C608          add  a,$08
120C  CB3F          srl  a
120E  CB3F          srl  a
1210  E63E          and  $3E
1212  2681          ld   h,$81
1214  6F            ld   l,a
1215  3A0380        ld   a,($8003)
1218  4F            ld   c,a
1219  7E            ld   a,(hl)
121A  B9            cp   c
121B  C8            ret  z
121C  91            sub  c
121D  4F            ld   c,a
121E  3A4081        ld   a,($8140)
1221  81            add  a,c
1222  324081        ld   ($8140),a
1225  324481        ld   ($8144),a
1228  3A4781        ld   a,($8147)
122B  C608          add  a,$08
122D  CB3F          srl  a
122F  CB3F          srl  a
1231  E63E          and  $3E
1233  2681          ld   h,$81
1235  6F            ld   l,a
1236  7E            ld   a,(hl)
1237  320380        ld   ($8003),a
123A  3A4781        ld   a,($8147)
123D  320280        ld   ($8002),a
1240  C9            ret
1241  FF            rst  $38
1242  FF            rst  $38
1243  FF            rst  $38
1244  FF            rst  $38
1245  FF            rst  $38
1246  FF            rst  $38
1247  FF            rst  $38
1248  FF            rst  $38
1249  FF            rst  $38
124A  FF            rst  $38
124B  FF            rst  $38
124C  FF            rst  $38
124D  FF            rst  $38
124E  FF            rst  $38
124F  FF            rst  $38
1250  E5            push hl
1251  3A4081        ld   a,($8140)
1254  96            sub  (hl)
1255  67            ld   h,a
1256  3A4781        ld   a,($8147)
1259  D612          sub  $12
125B  5A            ld   e,d
125C  CB23          sla  e
125E  CB23          sla  e
1260  CB23          sla  e
1262  83            add  a,e
1263  6F            ld   l,a
1264  CD6809        call $0968
1267  00            nop
1268  00            nop
1269  00            nop
126A  00            nop
126B  7E            ld   a,(hl)
126C  E6C0          and  $C0
126E  FEC0          cp   $C0
1270  280B          jr   z,$127D
1272  01C0FF        ld   bc,$FFC0
1275  09            add  hl,bc
1276  7E            ld   a,(hl)
1277  E6C0          and  $C0
1279  FEC0          cp   $C0
127B  2003          jr   nz,$1280
127D  CDB80A        call $0AB8
1280  E1            pop  hl
1281  C9            ret
1282  FF            rst  $38
1283  FF            rst  $38
1284  FF            rst  $38
1285  FF            rst  $38
1286  FF            rst  $38
1287  FF            rst  $38
1288  FF            rst  $38
1289  FF            rst  $38
128A  FF            rst  $38
128B  FF            rst  $38
128C  FF            rst  $38
128D  FF            rst  $38
128E  FF            rst  $38
128F  FF            rst  $38
1290  C9            ret
1291  3A4781        ld   a,($8147)
1294  C604          add  a,$04
1296  CB3F          srl  a
1298  CB3F          srl  a
129A  E63E          and  $3E
129C  6F            ld   l,a
129D  2681          ld   h,$81
129F  1604          ld   d,$04
12A1  CD5012        call $1250
12A4  2B            dec  hl
12A5  2B            dec  hl
12A6  15            dec  d
12A7  20F8          jr   nz,$12A1
12A9  C9            ret
12AA  FF            rst  $38
12AB  FF            rst  $38
12AC  FF            rst  $38
12AD  FF            rst  $38
12AE  FF            rst  $38
12AF  FF            rst  $38
12B0  FF            rst  $38
12B1  FF            rst  $38
12B2  FF            rst  $38
12B3  FF            rst  $38
12B4  FF            rst  $38
12B5  FF            rst  $38
12B6  FF            rst  $38
12B7  FF            rst  $38
12B8  CD1003        call draw_tiles_h
12BB  03            inc  bc
12BC  00            nop
12BD  40            ld   b,b
12BE  42            ld   b,d
12BF  43            ld   b,e
12C0  42            ld   b,d
12C1  41            ld   b,c
12C2  40            ld   b,b
12C3  FF            rst  $38
12C4  CD1003        call draw_tiles_h
12C7  09            add  hl,bc
12C8  00            nop
12C9  FEFD          cp   $FD
12CB  FD            db   $fd
12CC  FD            db   $fd
12CD  FD            db   $fd
12CE  FCFFCD        call m,$CDFF
12D1  1003          djnz $12D6
12D3  1E00          ld   e,$00
12D5  FEFD          cp   $FD
12D7  FD            db   $fd
12D8  FD            db   $fd
12D9  FD            db   $fd
12DA  FCFFCD        call m,$CDFF
12DD  B0            or   b
12DE  14            inc  d
12DF  21E092        ld   hl,$92E0
12E2  DD2A2080      ld   ix,($8020)
12E6  1617          ld   d,$17
12E8  CD2813        call $1328
12EB  00            nop
12EC  00            nop
12ED  00            nop
12EE  15            dec  d
12EF  20F7          jr   nz,$12E8
12F1  221E80        ld   ($801E),hl
12F4  CD1035        call $3510
12F7  21500C        ld   hl,$0C50
12FA  CDE301        call $01E3
12FD  C3103F        jp   $3F10
1300  1E04          ld   e,$04
1302  E5            push hl
1303  210681        ld   hl,$8106
1306  35            dec  (hl)
1307  35            dec  (hl)
1308  23            inc  hl
1309  23            inc  hl
130A  E5            push hl
130B  CD0012        call $1200
130E  E1            pop  hl
130F  7D            ld   a,l
1310  FE3E          cp   $3E
1312  20F2          jr   nz,$1306
1314  CDA013        call wait_vblank
1317  1D            dec  e
1318  20E9          jr   nz,$1303
131A  E1            pop  hl
131B  C9            ret
131C  FF            rst  $38
131D  FF            rst  $38
131E  FF            rst  $38
131F  FF            rst  $38
1320  FF            rst  $38
1321  FF            rst  $38
1322  FF            rst  $38
1323  FF            rst  $38
1324  FF            rst  $38
1325  FF            rst  $38
1326  FF            rst  $38
1327  FF            rst  $38
1328  CD6817        call $1768
132B  DD7E00        ld   a,(ix+$00)
132E  E5            push hl
132F  85            add  a,l
1330  6F            ld   l,a
1331  DD23          inc  ix
1333  DD7E00        ld   a,(ix+$00)
1336  FEFF          cp   $FF
1338  2809          jr   z,$1343
133A  A7            and  a
133B  2814          jr   z,$1351
133D  77            ld   (hl),a
133E  23            inc  hl
133F  DD23          inc  ix
1341  18F0          jr   $1333
1343  DD23          inc  ix
1345  E1            pop  hl
1346  01E0FF        ld   bc,$FFE0
1349  09            add  hl,bc
134A  7C            ld   a,h
134B  FE8F          cp   $8F
134D  C0            ret  nz
134E  2693          ld   h,$93
1350  C9            ret
1351  DD23          inc  ix
1353  E1            pop  hl
1354  18D5          jr   $132B
1356  FF            rst  $38
1357  FF            rst  $38
1358  CDB813        call $13B8
135B  00            nop
135C  CDB014        call $14B0
135F  DD2A2080      ld   ix,($8020)
1363  2A1E80        ld   hl,($801E)
1366  1615          ld   d,$15
1368  CD2813        call $1328
136B  CD0013        call $1300
136E  15            dec  d
136F  20F7          jr   nz,$1368
1371  DD222080      ld   ($8020),ix
1375  221E80        ld   ($801E),hl
1378  CDC019        call $19C0
137B  CDB812        call $12B8
137E  AF            xor  a
137F  320280        ld   ($8002),a
1382  320380        ld   ($8003),a
1385  CD2018        call $1820
1388  CDB80D        call $0DB8
138B  CD0804        call $0408
138E  C9            ret

138F  FF            db   $ff

                ;; "jump relative A": dispatches to address based on A
                jump_rel_a:
1390  D9            exx
1391  E1            pop  hl       ; stack RET pointer
1392  0600          ld   b,$00
1394  4F            ld   c,a
1395  09            add  hl,bc
1396  E5            push hl
1397  D9            exx
1398  C9            ret           ; sets PC to RET + A

1399  FF            dc 7, $ff

                wait_vblank:
13A0  0600          ld   b,$00
13A2  3E01          ld   a,$01
13A4  3201B0        ld   (int_enable),a ; enable interrupts
13A7  3A00B8        ld   a,(watchdog)
13AA  78            ld   a,b
13AB  FE01          cp   $01
13AD  20F3          jr   nz,$13A2
13AF  AF            xor  a
13B0  3201B0        ld   (int_enable),a ; disable interrupts
13B3  3A00B8        ld   a,(watchdog)
13B6  C9            ret

13B7  FF            db   $ff

13B8  214881        ld   hl,$8148
13BB  3600          ld   (hl),$00
13BD  23            inc  hl
13BE  7D            ld   a,l
13BF  FE60          cp   $60
13C1  20F8          jr   nz,$13BB
13C3  C9            ret
13C4  FF            rst  $38
13C5  FF            rst  $38
13C6  FF            rst  $38
13C7  FF            rst  $38
13C8  FF            rst  $38
13C9  FF            rst  $38
13CA  FF            rst  $38
13CB  FF            rst  $38
13CC  FF            rst  $38
13CD  FF            rst  $38
13CE  FF            rst  $38
13CF  FF            rst  $38
13D0  3A0680        ld   a,($8006)
13D3  3C            inc  a
13D4  320680        ld   ($8006),a
13D7  FE3C          cp   $3C
13D9  C0            ret  nz
13DA  AF            xor  a
13DB  320680        ld   ($8006),a
13DE  CDF013        call $13F0
13E1  CD1014        call $1410
13E4  C9            ret
13E5  FF            rst  $38
13E6  FF            rst  $38
13E7  FF            rst  $38
13E8  FF            rst  $38
13E9  FF            rst  $38
13EA  FF            rst  $38
13EB  FF            rst  $38
13EC  FF            rst  $38
13ED  FF            rst  $38
13EE  FF            rst  $38
13EF  FF            rst  $38
13F0  3A0480        ld   a,($8004)
13F3  CB47          bit  0,a
13F5  210780        ld   hl,$8007
13F8  2802          jr   z,$13FC
13FA  23            inc  hl
13FB  23            inc  hl
13FC  7E            ld   a,(hl)
13FD  3C            inc  a
13FE  27            daa
13FF  77            ld   (hl),a
1400  FE60          cp   $60
1402  C0            ret  nz
1403  3600          ld   (hl),$00
1405  23            inc  hl
1406  7E            ld   a,(hl)
1407  3C            inc  a
1408  27            daa
1409  77            ld   (hl),a
140A  C9            ret
140B  FF            rst  $38
140C  FF            rst  $38
140D  FF            rst  $38
140E  FF            rst  $38
140F  FF            rst  $38
1410  C9            ret
1411  3A0480        ld   a,($8004)
1414  CB47          bit  0,a
1416  201E          jr   nz,$1436
1418  AF            xor  a
1419  210780        ld   hl,$8007
141C  ED67          rrd
141E  320293        ld   ($9302),a
1421  ED67          rrd
1423  322293        ld   ($9322),a
1426  ED67          rrd
1428  23            inc  hl
1429  ED67          rrd
142B  326293        ld   ($9362),a
142E  ED67          rrd
1430  328293        ld   ($9382),a
1433  ED67          rrd
1435  C9            ret
1436  AF            xor  a
1437  210980        ld   hl,$8009
143A  ED67          rrd
143C  328290        ld   ($9082),a
143F  ED67          rrd
1441  32A290        ld   ($90A2),a
1444  ED67          rrd
1446  23            inc  hl
1447  ED67          rrd
1449  32E290        ld   ($90E2),a
144C  ED67          rrd
144E  320291        ld   ($9102),a
1451  ED67          rrd
1453  C9            ret
1454  FF            rst  $38
1455  FF            rst  $38
1456  FF            rst  $38
1457  FF            rst  $38
1458  FF            rst  $38
1459  FF            rst  $38
145A  FF            rst  $38
145B  FF            rst  $38
145C  FF            rst  $38
145D  FF            rst  $38
145E  FF            rst  $38
145F  FF            rst  $38
1460  210080        ld   hl,$8000
1463  3600          ld   (hl),$00
1465  2C            inc  l
1466  20FB          jr   nz,$1463
1468  24            inc  h
1469  7C            ld   a,h
146A  FE83          cp   $83
146C  20F5          jr   nz,$1463
146E  C9            ret
146F  FF            rst  $38

                reset_xoff_sprites_and_clear_screen:    ; AND clear screen.
1470  CD9014        call reset_xoff_and_cols_and_sprites ; then nop slides
1473  00            nop                                  ; ...
1474  00            nop                                  ; ...
1475  00            nop
1476  00            nop
1477  00            nop
1478  23            inc  hl     ; hl++?
1479  00            nop
147A  00            nop
147B  00            nop
147C  00            nop
147D  00            nop
147E  00            nop
147F  00            nop                                 ; end of weird nopslide
                clear_screen:
1480  210090        ld   hl,screen_ram
1483  3610          ld   (hl),$10
1485  2C            inc  l
1486  20FB          jr   nz,$1483
1488  24            inc  h
1489  7C            ld   a,h
148A  FE98          cp   $98
148C  20F5          jr   nz,$1483
148E  C9            ret
148F  FF            rst  $38

                ;; Lotsa calls here (via $1470)
                reset_xoff_and_cols_and_sprites: ; sets 128 locations to 0
1490  210081        ld   hl,screen_xoff_col
1493  3600          ld   (hl),$00
1495  23            inc  hl
1496  7D            ld   a,l
1497  FE80          cp   $80    ; 128
1499  20F8          jr   nz,$1493
149B  C9            ret

149C  FF            dc   4, $ff

                clear_ram:
14A0  210080        ld   hl,$8000
14A3  3600          ld   (hl),$00
14A5  23            inc  hl
14A6  7C            ld   a,h
14A7  FE84          cp   $84
14A9  20F8          jr   nz,$14A3
14AB  C30F00        jp   $000F

14AE  FF            db   $ff, $ff

14B0  21E806        ld   hl,$06E8
14B3  CDE301        call $01E3
14B6  CDC83B        call $3BC8
14B9  3E20          ld   a,$20
14BB  323080        ld   ($8030),a
14BE  3A0480        ld   a,($8004)
14C1  A7            and  a
14C2  2005          jr   nz,$14C9
14C4  3A2980        ld   a,($8029)
14C7  1803          jr   $14CC
14C9  3A2A80        ld   a,($802A)
14CC  210015        ld   hl,$1500
14CF  0600          ld   b,$00
14D1  3D            dec  a
14D2  4F            ld   c,a
14D3  CB21          sla  c
14D5  09            add  hl,bc
14D6  4E            ld   c,(hl)
14D7  23            inc  hl
14D8  46            ld   b,(hl)
14D9  ED432080      ld   ($8020),bc
14DD  C9            ret
14DE  FF            rst  $38
14DF  FF            rst  $38
14E0  3A1583        ld   a,($8315)
14E3  E603          and  $03
14E5  C0            ret  nz
14E6  CD503A        call $3A50
14E9  CD883A        call $3A88
14EC  CDC03A        call $3AC0
14EF  C9            ret
14F0  FF            rst  $38
14F1  FF            rst  $38
14F2  FF            rst  $38
14F3  FF            rst  $38
14F4  FF            rst  $38
14F5  FF            rst  $38
14F6  FF            rst  $38
14F7  FF            rst  $38
14F8  FF            rst  $38
14F9  FF            rst  $38
14FA  FF            rst  $38
14FB  FF            rst  $38
14FC  FF            rst  $38
14FD  FF            rst  $38
14FE  FF            rst  $38
14FF  FF            rst  $38
1500  B0            or   b
1501  18B0          jr   $14B3
1503  1840          jr   $1545
1505  21B018        ld   hl,$18B0
1508  101A          djnz $1524
150A  40            ld   b,b
150B  21701E        ld   hl,$1E70
150E  B0            or   b
150F  1840          jr   $1551
1511  21101A        ld   hl,$1A10
1514  40            ld   b,b
1515  21701E        ld   hl,$1E70
1518  B0            or   b
1519  1840          jr   $155B
151B  21B018        ld   hl,$18B0
151E  00            nop
151F  1D            dec  e
1520  70            ld   (hl),b
1521  1EB0          ld   e,$B0
1523  1800          jr   $1525
1525  1D            dec  e
1526  70            ld   (hl),b
1527  1EE0          ld   e,$E0
1529  1F            rra
152A  40            ld   b,b
152B  21701E        ld   hl,$1E70
152E  E0            ret  po
152F  1F            rra
1530  40            ld   b,b
1531  21701E        ld   hl,$1E70
1534  00            nop
1535  1D            dec  e
1536  00            nop
1537  00            nop
1538  00            nop
1539  00            nop
153A  00            nop
153B  00            nop
153C  FF            rst  $38
153D  FF            rst  $38
153E  FF            rst  $38
153F  FF            rst  $38
1540  FF            rst  $38
1541  FF            rst  $38
1542  FF            rst  $38
1543  FF            rst  $38
1544  FF            rst  $38
1545  FF            rst  $38
1546  FF            rst  $38
1547  FF            rst  $38
1548  FF            rst  $38
1549  FF            rst  $38
154A  FF            rst  $38
154B  FF            rst  $38
154C  FF            rst  $38
154D  FF            rst  $38
154E  FF            rst  $38
154F  FF            rst  $38
1550  E5            push hl
1551  C5            push bc
1552  D5            push de
1553  210081        ld   hl,screen_xoff_col
1556  110098        ld   de,$9800
1559  018000        ld   bc,$0080
155C  EDB0          ldir
155E  D1            pop  de
155F  C1            pop  bc
1560  E1            pop  hl
1561  C9            ret
1562  FF            rst  $38
1563  FF            rst  $38
1564  00            nop
1565  00            nop
1566  3A0893        ld   a,($9308)
1569  FE10          cp   $10
156B  2810          jr   z,$157D
156D  FE8C          cp   $8C
156F  2007          jr   nz,$1578
1571  3E9C          ld   a,$9C
1573  320893        ld   ($9308),a
1576  1805          jr   $157D
1578  3E8C          ld   a,$8C
157A  320893        ld   ($9308),a
157D  3A0C93        ld   a,($930C)
1580  FE10          cp   $10
1582  2810          jr   z,$1594
1584  FE8D          cp   $8D
1586  2007          jr   nz,$158F
1588  3E9D          ld   a,$9D
158A  320C93        ld   ($930C),a
158D  1805          jr   $1594
158F  3E8D          ld   a,$8D
1591  320C93        ld   ($930C),a
1594  3A1093        ld   a,($9310)
1597  FE10          cp   $10
1599  2810          jr   z,$15AB
159B  FE8E          cp   $8E
159D  2007          jr   nz,$15A6
159F  3E9E          ld   a,$9E
15A1  321093        ld   ($9310),a
15A4  1805          jr   $15AB
15A6  3E8E          ld   a,$8E
15A8  321093        ld   ($9310),a
15AB  3A1493        ld   a,($9314)
15AE  FE10          cp   $10
15B0  2810          jr   z,$15C2
15B2  FE8F          cp   $8F
15B4  2007          jr   nz,$15BD
15B6  3E9F          ld   a,$9F
15B8  321493        ld   ($9314),a
15BB  1805          jr   $15C2
15BD  3E8F          ld   a,$8F
15BF  321493        ld   ($9314),a
15C2  C9            ret
15C3  FF            rst  $38
15C4  D5            push de
15C5  21A81B        ld   hl,$1BA8
15C8  CDE301        call $01E3
15CB  D1            pop  de
15CC  C9            ret
15CD  FF            rst  $38
15CE  FF            rst  $38
15CF  FF            rst  $38
15D0  CD7014        call reset_xoff_sprites_and_clear_screen
15D3  CD880F        call $0F88
15D6  CD6016        call $1660
15D9  3E8C          ld   a,$8C
15DB  320893        ld   ($9308),a
15DE  CD6016        call $1660
15E1  CD1003        call draw_tiles_h
15E4  08            ex   af,af'
15E5  1002          djnz $15E9
15E7  00            nop
15E8  00            nop
15E9  1020          djnz $160B
15EB  24            inc  h
15EC  23            inc  hl
15ED  FF            rst  $38
15EE  CD6016        call $1660
15F1  3E8D          ld   a,$8D
15F3  320C93        ld   ($930C),a
15F6  CD6016        call $1660
15F9  CD1003        call draw_tiles_h
15FC  0C            inc  c
15FD  1004          djnz $1603
15FF  00            nop
1600  00            nop
1601  1020          djnz $1623
1603  24            inc  h
1604  23            inc  hl
1605  FF            rst  $38
1606  CD6016        call $1660
1609  3E8E          ld   a,$8E
160B  321093        ld   ($9310),a
160E  CD6016        call $1660
1611  CD1003        call draw_tiles_h
1614  1010          djnz $1626
1616  0600          ld   b,$00
1618  00            nop
1619  1020          djnz $163B
161B  24            inc  h
161C  23            inc  hl
161D  FF            rst  $38
161E  CD6016        call $1660
1621  3E8F          ld   a,$8F
1623  321493        ld   ($9314),a
1626  CD6016        call $1660
1629  CD1003        call draw_tiles_h
162C  14            inc  d
162D  1001          djnz $1630
162F  00            nop
1630  00            nop
1631  00            nop
1632  1020          djnz $1654
1634  24            inc  h
1635  23            inc  hl
1636  FF            rst  $38
1637  CD6016        call $1660
163A  CD6016        call $1660
163D  CD6016        call $1660
1640  CD6016        call $1660
1643  219414        ld   hl,$1494
1646  CDE301        call $01E3
1649  C9            ret
164A  FF            rst  $38
164B  CD7014        call reset_xoff_sprites_and_clear_screen
164E  21E00F        ld   hl,$0FE0
1651  CD4008        call $0840
1654  00            nop
1655  00            nop
1656  CD5024        call $2450
1659  C9            ret
165A  FF            rst  $38
165B  FF            rst  $38
165C  FF            rst  $38
165D  FF            rst  $38
165E  FF            rst  $38
165F  FF            rst  $38
1660  1610          ld   d,$10
1662  CD6415        call $1564
1665  CDC415        call $15C4
1668  1E04          ld   e,$04
166A  D5            push de
166B  CD2821        call $2128
166E  D1            pop  de
166F  1D            dec  e
1670  20F8          jr   nz,$166A
1672  15            dec  d
1673  20ED          jr   nz,$1662
1675  C9            ret
1676  FF            rst  $38
1677  FF            rst  $38
1678  E8            ret  pe
1679  ECEEF0        call pe,$F0EE
167C  E9            jp   (hl)
167D  ED            db   $ed
167E  EF            rst  $28
167F  F1            pop  af
1680  3A0480        ld   a,($8004)
1683  A7            and  a
1684  2005          jr   nz,$168B
1686  3A5B80        ld   a,($805B)
1689  1803          jr   $168E
168B  3A5C80        ld   a,($805C)
168E  FE1F          cp   $1F
1690  2019          jr   nz,$16AB
1692  3A1583        ld   a,($8315)
1695  3C            inc  a
1696  FE03          cp   $03
1698  2001          jr   nz,$169B
169A  AF            xor  a
169B  321583        ld   ($8315),a
169E  3A1683        ld   a,($8316)
16A1  3C            inc  a
16A2  FE06          cp   $06
16A4  2001          jr   nz,$16A7
16A6  AF            xor  a
16A7  321683        ld   ($8316),a
16AA  C9            ret
16AB  3A1583        ld   a,($8315)
16AE  3C            inc  a
16AF  FE02          cp   $02
16B1  2001          jr   nz,$16B4
16B3  AF            xor  a
16B4  321583        ld   ($8315),a
16B7  3A1683        ld   a,($8316)
16BA  3C            inc  a
16BB  FE04          cp   $04
16BD  2001          jr   nz,$16C0
16BF  AF            xor  a
16C0  321683        ld   ($8316),a
16C3  C9            ret
16C4  FF            rst  $38
16C5  FF            rst  $38
16C6  FF            rst  $38
16C7  FF            rst  $38
16C8  FF            rst  $38
16C9  FF            rst  $38
16CA  FF            rst  $38
16CB  FF            rst  $38
16CC  FF            rst  $38
16CD  FF            rst  $38
16CE  FF            rst  $38
16CF  FF            rst  $38
16D0  CD1003        call draw_tiles_h
16D3  0A            ld   a,(bc)
16D4  00            nop
16D5  E0            ret  po
16D6  DCDDDE        call c,$DEDD
16D9  DF            rst  $18
16DA  FF            rst  $38
16DB  CD1003        call draw_tiles_h
16DE  0B            dec  bc
16DF  00            nop
16E0  E1            pop  hl
16E1  E5            push hl
16E2  E5            push hl
16E3  E5            push hl
16E4  E6FF          and  $FF
16E6  CD1003        call draw_tiles_h
16E9  0C            inc  c
16EA  00            nop
16EB  E1            pop  hl
16EC  E5            push hl
16ED  E5            push hl
16EE  E5            push hl
16EF  E6FF          and  $FF
16F1  CD1003        call draw_tiles_h
16F4  0D            dec  c
16F5  00            nop
16F6  E2E3E3        jp   po,$E3E3
16F9  E3            ex   (sp),hl
16FA  E4FFC9        call po,$C9FF
16FD  FF            rst  $38
16FE  FF            rst  $38
16FF  FF            rst  $38
1700  3A3480        ld   a,(num_players)
1703  A7            and  a
1704  C8            ret  z
1705  3A0480        ld   a,($8004)
1708  A7            and  a
1709  2017          jr   nz,$1722
170B  3A1D80        ld   a,($801D)
170E  A7            and  a
170F  C8            ret  z
1710  4F            ld   c,a
1711  2680          ld   h,$80
1713  0600          ld   b,$00
1715  2E14          ld   l,$14
1717  CDA017        call $17A0
171A  CD5024        call $2450
171D  AF            xor  a
171E  321D80        ld   ($801D),a
1721  C9            ret
1722  3A1D80        ld   a,($801D)
1725  A7            and  a
1726  C8            ret  z
1727  4F            ld   c,a
1728  2680          ld   h,$80
172A  0600          ld   b,$00
172C  2E17          ld   l,$17
172E  CDA017        call $17A0
1731  CD5024        call $2450
1734  AF            xor  a
1735  321D80        ld   ($801D),a
1738  C9            ret
1739  FF            rst  $38
173A  FF            rst  $38
173B  FF            rst  $38
173C  FF            rst  $38
173D  FF            rst  $38
173E  FF            rst  $38
173F  FF            rst  $38
1740  FF            rst  $38
1741  FF            rst  $38
1742  FF            rst  $38
1743  FF            rst  $38
1744  FF            rst  $38
1745  FF            rst  $38
1746  FF            rst  $38
1747  FF            rst  $38
1748  FF            rst  $38
1749  FF            rst  $38
174A  FF            rst  $38
174B  FF            rst  $38
174C  FF            rst  $38
174D  FF            rst  $38
174E  FF            rst  $38
174F  FF            rst  $38
1750  37            scf
1751  3F            ccf
1752  3A4381        ld   a,($8143)
1755  C648          add  a,$48
1757  3803          jr   c,$175C
1759  D678          sub  $78
175B  D0            ret  nc
175C  3A4081        ld   a,($8140)
175F  37            scf
1760  3F            ccf
1761  D6E0          sub  $E0
1763  D8            ret  c
1764  CD7817        call $1778
1767  C9            ret
1768  E5            push hl
1769  3E03          ld   a,$03
176B  85            add  a,l
176C  6F            ld   l,a
176D  1E1C          ld   e,$1C
176F  3610          ld   (hl),$10
1771  23            inc  hl
1772  1D            dec  e
1773  20FA          jr   nz,$176F
1775  E1            pop  hl
1776  C9            ret
1777  FF            rst  $38
1778  CDC017        call $17C0
177B  3A0480        ld   a,($8004)
177E  A7            and  a
177F  2009          jr   nz,$178A
1781  3A2980        ld   a,($8029)
1784  3C            inc  a
1785  322980        ld   ($8029),a
1788  1807          jr   $1791
178A  3A2A80        ld   a,($802A)
178D  3C            inc  a
178E  322A80        ld   ($802A),a
1791  CDE027        call $27E0
1794  CD5813        call $1358
1797  CDD00A        call $0AD0
179A  3E02          ld   a,$02
179C  C3B417        jp   $17B4
179F  C9            ret
17A0  7E            ld   a,(hl)
17A1  37            scf
17A2  3F            ccf
17A3  81            add  a,c
17A4  27            daa
17A5  77            ld   (hl),a
17A6  2C            inc  l
17A7  7E            ld   a,(hl)
17A8  88            adc  a,b
17A9  27            daa
17AA  77            ld   (hl),a
17AB  2C            inc  l
17AC  7E            ld   a,(hl)
17AD  CE00          adc  a,$00
17AF  27            daa
17B0  77            ld   (hl),a
17B1  C9            ret
17B2  FF            rst  $38
17B3  FF            rst  $38
17B4  323F81        ld   ($813F),a
17B7  AF            xor  a
17B8  320F80        ld   ($800F),a
17BB  320580        ld   ($8005),a
17BE  C9            ret
17BF  FF            rst  $38
17C0  AF            xor  a
17C1  322D80        ld   ($802D),a
17C4  3A4C81        ld   a,($814C)
17C7  325081        ld   ($8150),a
17CA  C9            ret
17CB  FF            rst  $38
17CC  FF            rst  $38
17CD  FF            rst  $38
17CE  FF            rst  $38
17CF  FF            rst  $38
17D0  CD1003        call draw_tiles_h
17D3  0A            ld   a,(bc)
17D4  00            nop
17D5  B8            cp   b
17D6  B4            or   h
17D7  B5            or   l
17D8  B6            or   (hl)
17D9  B7            or   a
17DA  FF            rst  $38
17DB  CD1003        call draw_tiles_h
17DE  0B            dec  bc
17DF  00            nop
17E0  B9            cp   c
17E1  FF            rst  $38
17E2  CD1003        call draw_tiles_h
17E5  0B            dec  bc
17E6  04            inc  b
17E7  BE            cp   (hl)
17E8  FF            rst  $38
17E9  CD1003        call draw_tiles_h
17EC  0C            inc  c
17ED  00            nop
17EE  B9            cp   c
17EF  FF            rst  $38
17F0  CD1003        call draw_tiles_h
17F3  0C            inc  c
17F4  04            inc  b
17F5  BE            cp   (hl)
17F6  FF            rst  $38
17F7  CD1003        call draw_tiles_h
17FA  0D            dec  c
17FB  00            nop
17FC  BA            cp   d
17FD  BB            cp   e
17FE  BB            cp   e
17FF  BB            cp   e
1800  BC            cp   h
1801  FF            rst  $38
1802  C9            ret
1803  FF            rst  $38
1804  FF            rst  $38
1805  FF            rst  $38
1806  FF            rst  $38
1807  FF            rst  $38
1808  3E0C          ld   a,$0C
180A  324181        ld   ($8141),a
180D  3C            inc  a
180E  324581        ld   ($8145),a
1811  3E11          ld   a,$11
1813  324281        ld   ($8142),a
1816  324681        ld   ($8146),a
1819  C9            ret
181A  FF            rst  $38
181B  FF            rst  $38
181C  FF            rst  $38
181D  FF            rst  $38
181E  FF            rst  $38
181F  FF            rst  $38
1820  3A0480        ld   a,($8004)
1823  A7            and  a
1824  2005          jr   nz,$182B
1826  3A2980        ld   a,($8029)
1829  1803          jr   $182E
182B  3A2A80        ld   a,($802A)
182E  215018        ld   hl,$1850
1831  3D            dec  a
1832  CB27          sla  a
1834  85            add  a,l
1835  6F            ld   l,a
1836  7E            ld   a,(hl)
1837  324081        ld   ($8140),a
183A  324481        ld   ($8144),a
183D  23            inc  hl
183E  7E            ld   a,(hl)
183F  324381        ld   ($8143),a
1842  C610          add  a,$10
1844  324781        ld   ($8147),a
1847  CD0818        call $1808
184A  C9            ret
184B  FF            rst  $38
184C  FF            rst  $38
184D  FF            rst  $38
184E  FF            rst  $38
184F  FF            rst  $38
1850  20D0          jr   nz,$1822
1852  20D0          jr   nz,$1824
1854  20D0          jr   nz,$1826
1856  20D0          jr   nz,$1828
1858  20D0          jr   nz,$182A
185A  2026          jr   nz,$1882
185C  2026          jr   nz,$1884
185E  20D0          jr   nz,$1830
1860  20D0          jr   nz,$1832
1862  20D0          jr   nz,$1834
1864  2026          jr   nz,$188C
1866  2026          jr   nz,$188E
1868  20D0          jr   nz,$183A
186A  20D0          jr   nz,$183C
186C  20D0          jr   nz,$183E
186E  20D0          jr   nz,$1840
1870  2026          jr   nz,$1898
1872  20D0          jr   nz,$1844
1874  20D0          jr   nz,$1846
1876  2026          jr   nz,$189E
1878  20D0          jr   nz,$184A
187A  2026          jr   nz,$18A2
187C  2026          jr   nz,$18A4
187E  20D0          jr   nz,$1850
1880  2026          jr   nz,$18A8
1882  2026          jr   nz,$18AA
1884  20D0          jr   nz,$1856
1886  00            nop
1887  00            nop
1888  00            nop
1889  00            nop
188A  00            nop
188B  00            nop
188C  00            nop
188D  00            nop
188E  00            nop
188F  00            nop
1890  FF            rst  $38
1891  FF            rst  $38
1892  FF            rst  $38
1893  FF            rst  $38
1894  FF            rst  $38
1895  FF            rst  $38
1896  FF            rst  $38
1897  FF            rst  $38
1898  210081        ld   hl,screen_xoff_col
189B  3600          ld   (hl),$00
189D  23            inc  hl
189E  23            inc  hl
189F  7D            ld   a,l
18A0  FE40          cp   $40
18A2  20F7          jr   nz,$189B
18A4  C9            ret
18A5  FF            rst  $38
18A6  FF            rst  $38
18A7  FF            rst  $38
18A8  FF            rst  $38
18A9  FF            rst  $38
18AA  FF            rst  $38
18AB  FF            rst  $38
18AC  FF            rst  $38
18AD  FF            rst  $38
18AE  FF            rst  $38
18AF  FF            rst  $38
18B0  03            inc  bc
18B1  41            ld   b,c
18B2  00            nop
18B3  09            add  hl,bc
18B4  FE00          cp   $00
18B6  1E39          ld   e,$39
18B8  FF            rst  $38
18B9  03            inc  bc
18BA  43            ld   b,e
18BB  00            nop
18BC  09            add  hl,bc
18BD  FD45          ld   b,iyl
18BF  41            ld   b,c
18C0  00            nop
18C1  1B            dec  de
18C2  FE3B          cp   $3B
18C4  45            ld   b,l
18C5  45            ld   b,l
18C6  FF            rst  $38
18C7  03            inc  bc
18C8  40            ld   b,b
18C9  00            nop
18CA  09            add  hl,bc
18CB  FD            db   $fd
18CC  42            ld   b,d
18CD  00            nop
18CE  1B            dec  de
18CF  FD            db   $fd
18D0  3F            ccf
18D1  3F            ccf
18D2  3B            dec  sp
18D3  FF            rst  $38
18D4  03            inc  bc
18D5  43            ld   b,e
18D6  00            nop
18D7  09            add  hl,bc
18D8  FC4100        call m,$0041
18DB  1B            dec  de
18DC  FD            db   $fd
18DD  3B            dec  sp
18DE  3B            dec  sp
18DF  3F            ccf
18E0  FF            rst  $38
18E1  03            inc  bc
18E2  42            ld   b,d
18E3  00            nop
18E4  1B            dec  de
18E5  FD            db   $fd
18E6  3F            ccf
18E7  3B            dec  sp
18E8  3B            dec  sp
18E9  FF            rst  $38
18EA  03            inc  bc
18EB  3F            ccf
18EC  00            nop
18ED  1B            dec  de
18EE  FD            db   $fd
18EF  3F            ccf
18F0  3F            ccf
18F1  3B            dec  sp
18F2  FF            rst  $38
18F3  03            inc  bc
18F4  3E43          ld   a,$43
18F6  00            nop
18F7  1B            dec  de
18F8  FD            db   $fd
18F9  3B            dec  sp
18FA  3F            ccf
18FB  3B            dec  sp
18FC  FF            rst  $38
18FD  03            inc  bc
18FE  3F            ccf
18FF  40            ld   b,b
1900  00            nop
1901  1B            dec  de
1902  FC473B        call m,$3B47
1905  47            ld   b,a
1906  FF            rst  $38
1907  03            inc  bc
1908  3B            dec  sp
1909  42            ld   b,d
190A  00            nop
190B  1D            dec  e
190C  3D            dec  a
190D  3F            ccf
190E  FF            rst  $38
190F  03            inc  bc
1910  3B            dec  sp
1911  40            ld   b,b
1912  00            nop
1913  1D            dec  e
1914  3C            inc  a
1915  3EFF          ld   a,$FF
1917  03            inc  bc
1918  3F            ccf
1919  43            ld   b,e
191A  00            nop
191B  1D            dec  e
191C  3A3FFF        ld   a,($FF3F)
191F  03            inc  bc
1920  3E41          ld   a,$41
1922  00            nop
1923  1B            dec  de
1924  FE10          cp   $10
1926  3D            dec  a
1927  3EFF          ld   a,$FF
1929  03            inc  bc
192A  3B            dec  sp
192B  40            ld   b,b
192C  00            nop
192D  1B            dec  de
192E  FD            db   $fd
192F  47            ld   b,a
1930  3E47          ld   a,$47
1932  FF            rst  $38
1933  03            inc  bc
1934  3F            ccf
1935  42            ld   b,d
1936  00            nop
1937  1B            dec  de
1938  FD            db   $fd
1939  3B            dec  sp
193A  3B            dec  sp
193B  3B            dec  sp
193C  FF            rst  $38
193D  03            inc  bc
193E  3E00          ld   a,$00
1940  1B            dec  de
1941  FD            db   $fd
1942  3E3F          ld   a,$3F
1944  3F            ccf
1945  FF            rst  $38
1946  03            inc  bc
1947  42            ld   b,d
1948  00            nop
1949  09            add  hl,bc
194A  FE00          cp   $00
194C  1B            dec  de
194D  FD            db   $fd
194E  3F            ccf
194F  3B            dec  sp
1950  3EFF          ld   a,$FF
1952  03            inc  bc
1953  43            ld   b,e
1954  00            nop
1955  09            add  hl,bc
1956  FD            db   $fd
1957  47            ld   b,a
1958  41            ld   b,c
1959  00            nop
195A  1B            dec  de
195B  FD            db   $fd
195C  3B            dec  sp
195D  3E3E          ld   a,$3E
195F  FF            rst  $38
1960  03            inc  bc
1961  41            ld   b,c
1962  00            nop
1963  09            add  hl,bc
1964  FD            db   $fd
1965  00            nop
1966  1B            dec  de
1967  FC3E3B        call m,$3B3E
196A  3B            dec  sp
196B  FF            rst  $38
196C  03            inc  bc
196D  42            ld   b,d
196E  00            nop
196F  09            add  hl,bc
1970  FD            db   $fd
1971  00            nop
1972  1EFE          ld   e,$FE
1974  FF            rst  $38
1975  03            inc  bc
1976  43            ld   b,e
1977  00            nop
1978  09            add  hl,bc
1979  FD            db   $fd
197A  00            nop
197B  1EFD          ld   e,$FD
197D  FF            rst  $38
197E  03            inc  bc
197F  42            ld   b,d
1980  00            nop
1981  09            add  hl,bc
1982  FD            db   $fd
1983  00            nop
1984  1EFD          ld   e,$FD
1986  FF            rst  $38
1987  03            inc  bc
1988  41            ld   b,c
1989  00            nop
198A  09            add  hl,bc
198B  FD            db   $fd
198C  00            nop
198D  1EFD          ld   e,$FD
198F  FF            rst  $38
1990  03            inc  bc
1991  40            ld   b,b
1992  00            nop
1993  09            add  hl,bc
1994  FD            db   $fd
1995  00            nop
1996  1EFC          ld   e,$FC
1998  FF            rst  $38
1999  FF            rst  $38
199A  FF            rst  $38
199B  FF            rst  $38
199C  3EF0          ld   a,$F0
199E  324081        ld   ($8140),a
19A1  324481        ld   ($8144),a
19A4  3E26          ld   a,$26
19A6  324781        ld   ($8147),a
19A9  3E16          ld   a,$16
19AB  324381        ld   ($8143),a
19AE  3E17          ld   a,$17
19B0  324181        ld   ($8141),a
19B3  324581        ld   ($8145),a
19B6  AF            xor  a
19B7  324281        ld   ($8142),a
19BA  324681        ld   ($8146),a
19BD  C37817        jp   $1778
19C0  210090        ld   hl,screen_ram
19C3  23            inc  hl
19C4  23            inc  hl
19C5  23            inc  hl
19C6  161D          ld   d,$1D
19C8  3610          ld   (hl),$10
19CA  23            inc  hl
19CB  15            dec  d
19CC  20FA          jr   nz,$19C8
19CE  7C            ld   a,h
19CF  FE94          cp   $94
19D1  20F0          jr   nz,$19C3
19D3  00            nop
19D4  00            nop
19D5  00            nop
19D6  00            nop
19D7  00            nop
19D8  210081        ld   hl,screen_xoff_col
19DB  3600          ld   (hl),$00
19DD  23            inc  hl
19DE  7D            ld   a,l
19DF  FE80          cp   $80
19E1  20F8          jr   nz,$19DB
19E3  CDA013        call wait_vblank
19E6  C9            ret
19E7  FF            rst  $38
19E8  FF            rst  $38
19E9  FF            rst  $38
19EA  FF            rst  $38
19EB  FF            rst  $38
19EC  FF            rst  $38
19ED  FF            rst  $38
19EE  FF            rst  $38
19EF  FF            rst  $38
19F0  3A4781        ld   a,($8147)
19F3  37            scf
19F4  3F            ccf
19F5  C618          add  a,$18
19F7  D0            ret  nc
19F8  CDC00C        call $0CC0
19FB  AF            xor  a
19FC  321280        ld   ($8012),a
19FF  CD2002        call $0220
1A02  C9            ret
1A03  FF            rst  $38
1A04  3A4081        ld   a,($8140)
1A07  37            scf
1A08  3F            ccf
1A09  D610          sub  $10
1A0B  D0            ret  nc
1A0C  C3481B        jp   $1B48
1A0F  C9            ret
1A10  03            inc  bc
1A11  3F            ccf
1A12  00            nop
1A13  1B            dec  de
1A14  FE30          cp   $30
1A16  313CFF        ld   sp,$FF3C
1A19  03            inc  bc
1A1A  3F            ccf
1A1B  3E3B          ld   a,$3B
1A1D  40            ld   b,b
1A1E  00            nop
1A1F  1B            dec  de
1A20  FC103A        call m,$3A10
1A23  3F            ccf
1A24  FF            rst  $38
1A25  03            inc  bc
1A26  3B            dec  sp
1A27  3B            dec  sp
1A28  3E3F          ld   a,$3F
1A2A  42            ld   b,d
1A2B  00            nop
1A2C  1B            dec  de
1A2D  3610          ld   (hl),$10
1A2F  3D            dec  a
1A30  3F            ccf
1A31  FF            rst  $38
1A32  03            inc  bc
1A33  3F            ccf
1A34  3B            dec  sp
1A35  3F            ccf
1A36  3E3B          ld   a,$3B
1A38  41            ld   b,c
1A39  00            nop
1A3A  18FE          jr   $1A3A
1A3C  3031          jr   nc,$1A6F
1A3E  103C          djnz $1A7C
1A40  3F            ccf
1A41  3EFF          ld   a,$FF
1A43  03            inc  bc
1A44  3F            ccf
1A45  3B            dec  sp
1A46  3E3B          ld   a,$3B
1A48  3E3F          ld   a,$3F
1A4A  40            ld   b,b
1A4B  00            nop
1A4C  18FC          jr   $1A4A
1A4E  00            nop
1A4F  1D            dec  e
1A50  39            add  hl,sp
1A51  3EFF          ld   a,$FF
1A53  03            inc  bc
1A54  3B            dec  sp
1A55  3F            ccf
1A56  3B            dec  sp
1A57  3E3B          ld   a,$3B
1A59  41            ld   b,c
1A5A  00            nop
1A5B  1836          jr   $1A93
1A5D  1010          djnz $1A6F
1A5F  3D            dec  a
1A60  3F            ccf
1A61  3E3B          ld   a,$3B
1A63  FF            rst  $38
1A64  03            inc  bc
1A65  3F            ccf
1A66  3B            dec  sp
1A67  3B            dec  sp
1A68  3B            dec  sp
1A69  00            nop
1A6A  15            dec  d
1A6B  FE30          cp   $30
1A6D  313010        ld   sp,$1030
1A70  3A3E3B        ld   a,($3B3E)
1A73  3B            dec  sp
1A74  3F            ccf
1A75  FF            rst  $38
1A76  03            inc  bc
1A77  3E3E          ld   a,$3E
1A79  3B            dec  sp
1A7A  00            nop
1A7B  15            dec  d
1A7C  FC001A        call m,$1A00
1A7F  3C            inc  a
1A80  3F            ccf
1A81  3E3E          ld   a,$3E
1A83  3F            ccf
1A84  FF            rst  $38
1A85  03            inc  bc
1A86  3B            dec  sp
1A87  00            nop
1A88  15            dec  d
1A89  37            scf
1A8A  1010          djnz $1A9C
1A8C  1039          djnz $1AC7
1A8E  3E3E          ld   a,$3E
1A90  3F            ccf
1A91  3B            dec  sp
1A92  3F            ccf
1A93  FF            rst  $38
1A94  03            inc  bc
1A95  3E42          ld   a,$42
1A97  00            nop
1A98  12            ld   (de),a
1A99  FE31          cp   $31
1A9B  3031          jr   nc,$1ACE
1A9D  1010          djnz $1AAF
1A9F  103A          djnz $1ADB
1AA1  3F            ccf
1AA2  3E3B          ld   a,$3B
1AA4  3E3F          ld   a,$3F
1AA6  FF            rst  $38
1AA7  03            inc  bc
1AA8  3F            ccf
1AA9  41            ld   b,c
1AAA  00            nop
1AAB  12            ld   (de),a
1AAC  FC001A        call m,$1A00
1AAF  383E          jr   c,$1AEF
1AB1  3B            dec  sp
1AB2  3B            dec  sp
1AB3  3F            ccf
1AB4  FF            rst  $38
1AB5  03            inc  bc
1AB6  3E40          ld   a,$40
1AB8  00            nop
1AB9  12            ld   (de),a
1ABA  3600          ld   (hl),$00
1ABC  1B            dec  de
1ABD  39            add  hl,sp
1ABE  3F            ccf
1ABF  3B            dec  sp
1AC0  3F            ccf
1AC1  FF            rst  $38
1AC2  03            inc  bc
1AC3  42            ld   b,d
1AC4  00            nop
1AC5  0F            rrca
1AC6  FE30          cp   $30
1AC8  31001B        ld   sp,$1B00
1ACB  3C            inc  a
1ACC  3F            ccf
1ACD  3E3E          ld   a,$3E
1ACF  FF            rst  $38
1AD0  03            inc  bc
1AD1  43            ld   b,e
1AD2  00            nop
1AD3  0F            rrca
1AD4  FC001C        call m,$1C00
1AD7  3E3E          ld   a,$3E
1AD9  3B            dec  sp
1ADA  FF            rst  $38
1ADB  03            inc  bc
1ADC  41            ld   b,c
1ADD  00            nop
1ADE  0F            rrca
1ADF  37            scf
1AE0  00            nop
1AE1  1D            dec  e
1AE2  3A3BFF        ld   a,($FF3B)
1AE5  03            inc  bc
1AE6  42            ld   b,d
1AE7  00            nop
1AE8  0C            inc  c
1AE9  FE34          cp   $34
1AEB  35            dec  (hl)
1AEC  3600          ld   (hl),$00
1AEE  1E3C          ld   e,$3C
1AF0  FF            rst  $38
1AF1  03            inc  bc
1AF2  41            ld   b,c
1AF3  00            nop
1AF4  0C            inc  c
1AF5  FC001E        call m,$1E00
1AF8  39            add  hl,sp
1AF9  FF            rst  $38
1AFA  03            inc  bc
1AFB  40            ld   b,b
1AFC  00            nop
1AFD  0C            inc  c
1AFE  3600          ld   (hl),$00
1B00  1E3E          ld   e,$3E
1B02  FF            rst  $38
1B03  03            inc  bc
1B04  42            ld   b,d
1B05  00            nop
1B06  09            add  hl,bc
1B07  FE00          cp   $00
1B09  1EFE          ld   e,$FE
1B0B  FF            rst  $38
1B0C  03            inc  bc
1B0D  43            ld   b,e
1B0E  00            nop
1B0F  09            add  hl,bc
1B10  FD            db   $fd
1B11  00            nop
1B12  1EFD          ld   e,$FD
1B14  FF            rst  $38
1B15  03            inc  bc
1B16  42            ld   b,d
1B17  00            nop
1B18  09            add  hl,bc
1B19  FD            db   $fd
1B1A  00            nop
1B1B  1EFD          ld   e,$FD
1B1D  FF            rst  $38
1B1E  03            inc  bc
1B1F  41            ld   b,c
1B20  00            nop
1B21  09            add  hl,bc
1B22  FD            db   $fd
1B23  00            nop
1B24  1EFD          ld   e,$FD
1B26  FF            rst  $38
1B27  03            inc  bc
1B28  40            ld   b,b
1B29  00            nop
1B2A  09            add  hl,bc
1B2B  FC001E        call m,$1E00
1B2E  FCFF2A        call m,$2AFF
1B31  2080          jr   nz,$1AB3
1B33  011400        ld   bc,$0014
1B36  09            add  hl,bc
1B37  222080        ld   ($8020),hl
1B3A  2A1E80        ld   hl,($801E)
1B3D  011400        ld   bc,$0014
1B40  09            add  hl,bc
1B41  221E80        ld   ($801E),hl
1B44  C9            ret
1B45  FF            rst  $38
1B46  FF            rst  $38
1B47  FF            rst  $38
1B48  CDC00C        call $0CC0
1B4B  CD2002        call $0220
1B4E  C9            ret
1B4F  FF            rst  $38
1B50  3E03          ld   a,$03
1B52  328080        ld   ($8080),a
1B55  CD0017        call $1700
1B58  CDE024        call $24E0
1B5B  3A0480        ld   a,($8004)
1B5E  A7            and  a
1B5F  2005          jr   nz,$1B66
1B61  212980        ld   hl,$8029
1B64  1803          jr   $1B69
1B66  212A80        ld   hl,$802A
1B69  7E            ld   a,(hl)
1B6A  3C            inc  a
1B6B  27            daa
1B6C  77            ld   (hl),a
1B6D  CDB02C        call $2CB0
1B70  C30010        jp   $1000
1B73  FF            rst  $38
1B74  FF            rst  $38
1B75  FF            rst  $38
1B76  FF            rst  $38
1B77  FF            rst  $38
1B78  FF            rst  $38
1B79  FF            rst  $38
1B7A  FF            rst  $38
1B7B  FF            rst  $38
1B7C  FF            rst  $38
1B7D  FF            rst  $38
1B7E  FF            rst  $38
1B7F  FF            rst  $38
1B80  3A3180        ld   a,($8031)
1B83  A7            and  a
1B84  200B          jr   nz,$1B91
1B86  3A2280        ld   a,($8022)
1B89  A7            and  a
1B8A  2801          jr   z,$1B8D
1B8C  C9            ret
1B8D  3C            inc  a
1B8E  322280        ld   ($8022),a
1B91  CD0017        call $1700
1B94  CD7014        call reset_xoff_sprites_and_clear_screen
1B97  00            nop
1B98  00            nop
1B99  CDA003        call $03A0
1B9C  21E00F        ld   hl,$0FE0
1B9F  CD4008        call $0840
1BA2  00            nop
1BA3  00            nop
1BA4  CD5024        call $2450
1BA7  3A0480        ld   a,($8004)
1BAA  A7            and  a
1BAB  2010          jr   nz,$1BBD
1BAD  CD1003        call draw_tiles_h
1BB0  100A          djnz $1BBC
1BB2  201C          jr   nz,$1BD0
1BB4  112915        ld   de,$1529
1BB7  221001        ld   ($0110),hl
1BBA  FF            rst  $38
1BBB  180E          jr   $1BCB
1BBD  CD1003        call draw_tiles_h
1BC0  100A          djnz $1BCC
1BC2  201C          jr   nz,$1BE0
1BC4  112915        ld   de,$1529
1BC7  221002        ld   ($0210),hl
1BCA  FF            rst  $38
1BCB  CD411C        call $1C41
1BCE  C9            ret
1BCF  3E08          ld   a,$08
1BD1  328680        ld   ($8086),a
1BD4  C9            ret
1BD5  FF            rst  $38
1BD6  CD1003        call draw_tiles_h
1BD9  1B            dec  de
1BDA  02            ld   (bc),a
1BDB  E2E3E3        jp   po,$E3E3
1BDE  E3            ex   (sp),hl
1BDF  E3            ex   (sp),hl
1BE0  E3            ex   (sp),hl
1BE1  E3            ex   (sp),hl
1BE2  E3            ex   (sp),hl
1BE3  E3            ex   (sp),hl
1BE4  E3            ex   (sp),hl
1BE5  E3            ex   (sp),hl
1BE6  E3            ex   (sp),hl
1BE7  E3            ex   (sp),hl
1BE8  E3            ex   (sp),hl
1BE9  E3            ex   (sp),hl
1BEA  E3            ex   (sp),hl
1BEB  E3            ex   (sp),hl
1BEC  E3            ex   (sp),hl
1BED  E3            ex   (sp),hl
1BEE  E3            ex   (sp),hl
1BEF  E3            ex   (sp),hl
1BF0  E3            ex   (sp),hl
1BF1  E3            ex   (sp),hl
1BF2  E4FFC3        call po,$C3FF
1BF5  D8            ret  c
1BF6  1C            inc  e
1BF7  FF            rst  $38
1BF8  FF            rst  $38
1BF9  FF            rst  $38
1BFA  FF            rst  $38
1BFB  FF            rst  $38
1BFC  FF            rst  $38
1BFD  FF            rst  $38
1BFE  FF            rst  $38
1BFF  FF            rst  $38
1C00  1E18          ld   e,$18
1C02  CDA013        call wait_vblank
1C05  1D            dec  e
1C06  20FA          jr   nz,$1C02
1C08  C9            ret
1C09  FF            rst  $38
1C0A  FF            rst  $38
1C0B  FF            rst  $38
1C0C  FF            rst  $38
1C0D  FF            rst  $38
1C0E  FF            rst  $38
1C0F  FF            rst  $38
1C10  3A4081        ld   a,($8140)
1C13  C608          add  a,$08
1C15  324C81        ld   ($814C),a
1C18  C608          add  a,$08
1C1A  325081        ld   ($8150),a
1C1D  3A4381        ld   a,($8143)
1C20  324F81        ld   ($814F),a
1C23  C610          add  a,$10
1C25  325381        ld   ($8153),a
1C28  3EAC          ld   a,$AC
1C2A  324D81        ld   ($814D),a
1C2D  3EB0          ld   a,$B0
1C2F  325181        ld   ($8151),a
1C32  CD001C        call $1C00
1C35  3EAD          ld   a,$AD
1C37  324D81        ld   ($814D),a
1C3A  CD001C        call $1C00
1C3D  CD330A        call $0A33
1C40  C9            ret
1C41  3E0F          ld   a,$0F
1C43  324480        ld   ($8044),a
1C46  AF            xor  a
1C47  324280        ld   ($8042),a
1C4A  CDE024        call $24E0
1C4D  C9            ret
1C4E  FF            rst  $38
1C4F  FF            rst  $38
1C50  3A4081        ld   a,($8140)
1C53  D608          sub  $08
1C55  324C81        ld   ($814C),a
1C58  D608          sub  $08
1C5A  325081        ld   ($8150),a
1C5D  3A4381        ld   a,($8143)
1C60  324F81        ld   ($814F),a
1C63  C610          add  a,$10
1C65  325381        ld   ($8153),a
1C68  3E2C          ld   a,$2C
1C6A  324D81        ld   ($814D),a
1C6D  3E30          ld   a,$30
1C6F  325181        ld   ($8151),a
1C72  CD001C        call $1C00
1C75  3E2D          ld   a,$2D
1C77  324D81        ld   ($814D),a
1C7A  CD001C        call $1C00
1C7D  CD330A        call $0A33
1C80  C9            ret
1C81  E9            jp   (hl)
1C82  1040          djnz $1CC4
1C84  01811C        ld   bc,$1C81
1C87  C5            push bc
1C88  E5            push hl
1C89  C9            ret
1C8A  FF            rst  $38
1C8B  FF            rst  $38
1C8C  FF            rst  $38
1C8D  FF            rst  $38
1C8E  FF            rst  $38
1C8F  FF            rst  $38
1C90  3A4081        ld   a,($8140)
1C93  47            ld   b,a
1C94  3A4C81        ld   a,($814C)
1C97  37            scf
1C98  3F            ccf
1C99  90            sub  b
1C9A  3804          jr   c,$1CA0
1C9C  CD101C        call $1C10
1C9F  C9            ret
1CA0  CD501C        call $1C50
1CA3  C9            ret
1CA4  FF            rst  $38
1CA5  FF            rst  $38
1CA6  FF            rst  $38
1CA7  FF            rst  $38
1CA8  FF            rst  $38
1CA9  FF            rst  $38
1CAA  FF            rst  $38
1CAB  FF            rst  $38
1CAC  FF            rst  $38
1CAD  FF            rst  $38
1CAE  FF            rst  $38
1CAF  FF            rst  $38
1CB0  3A4C81        ld   a,($814C)
1CB3  47            ld   b,a
1CB4  3A4081        ld   a,($8140)
1CB7  90            sub  b
1CB8  37            scf
1CB9  3F            ccf
1CBA  D618          sub  $18
1CBC  3803          jr   c,$1CC1
1CBE  C630          add  a,$30
1CC0  D0            ret  nc
1CC1  3A4F81        ld   a,($814F)
1CC4  47            ld   b,a
1CC5  3A4381        ld   a,($8143)
1CC8  90            sub  b
1CC9  37            scf
1CCA  3F            ccf
1CCB  D628          sub  $28
1CCD  3803          jr   c,$1CD2
1CCF  C650          add  a,$50
1CD1  D0            ret  nc
1CD2  CD901C        call $1C90
1CD5  C9            ret
1CD6  FF            rst  $38
1CD7  FF            rst  $38
1CD8  CDD83B        call $3BD8
1CDB  19            add  hl,de
1CDC  03            inc  bc
1CDD  E1            pop  hl
1CDE  E1            pop  hl
1CDF  E1            pop  hl
1CE0  E1            pop  hl
1CE1  E1            pop  hl
1CE2  E1            pop  hl
1CE3  E1            pop  hl
1CE4  E1            pop  hl
1CE5  E1            pop  hl
1CE6  E1            pop  hl
1CE7  E1            pop  hl
1CE8  E1            pop  hl
1CE9  E1            pop  hl
1CEA  E1            pop  hl
1CEB  E1            pop  hl
1CEC  E1            pop  hl
1CED  E1            pop  hl
1CEE  E1            pop  hl
1CEF  E1            pop  hl
1CF0  E1            pop  hl
1CF1  E1            pop  hl
1CF2  E1            pop  hl
1CF3  E1            pop  hl
1CF4  E1            pop  hl
1CF5  FF            rst  $38
1CF6  C9            ret
1CF7  FF            rst  $38
1CF8  FF            rst  $38
1CF9  FF            rst  $38
1CFA  FF            rst  $38
1CFB  FF            rst  $38
1CFC  FF            rst  $38
1CFD  FF            rst  $38
1CFE  FF            rst  $38
1CFF  FF            rst  $38
1D00  03            inc  bc
1D01  3B            dec  sp
1D02  3E3F          ld   a,$3F
1D04  00            nop
1D05  0F            rrca
1D06  FE00          cp   $00
1D08  1B            dec  de
1D09  FE10          cp   $10
1D0B  3D            dec  a
1D0C  3EFF          ld   a,$FF
1D0E  03            inc  bc
1D0F  3E3E          ld   a,$3E
1D11  3F            ccf
1D12  3E00          ld   a,$00
1D14  0F            rrca
1D15  FD            db   $fd
1D16  00            nop
1D17  1B            dec  de
1D18  FD            db   $fd
1D19  103C          djnz $1D57
1D1B  3F            ccf
1D1C  FF            rst  $38
1D1D  03            inc  bc
1D1E  3E3B          ld   a,$3B
1D20  3B            dec  sp
1D21  3F            ccf
1D22  3B            dec  sp
1D23  00            nop
1D24  0F            rrca
1D25  FD            db   $fd
1D26  00            nop
1D27  1B            dec  de
1D28  FD            db   $fd
1D29  103A          djnz $1D65
1D2B  3B            dec  sp
1D2C  FF            rst  $38
1D2D  03            inc  bc
1D2E  3B            dec  sp
1D2F  3E3B          ld   a,$3B
1D31  3F            ccf
1D32  3F            ccf
1D33  41            ld   b,c
1D34  00            nop
1D35  0F            rrca
1D36  FD            db   $fd
1D37  00            nop
1D38  1B            dec  de
1D39  FD            db   $fd
1D3A  103C          djnz $1D78
1D3C  3B            dec  sp
1D3D  FF            rst  $38
1D3E  03            inc  bc
1D3F  3B            dec  sp
1D40  3E3F          ld   a,$3F
1D42  3B            dec  sp
1D43  00            nop
1D44  0F            rrca
1D45  FC0019        call m,$1900
1D48  35            dec  (hl)
1D49  34            inc  (hl)
1D4A  3C            inc  a
1D4B  1039          djnz $1D86
1D4D  3EFF          ld   a,$FF
1D4F  03            inc  bc
1D50  3F            ccf
1D51  3E3B          ld   a,$3B
1D53  3E00          ld   a,$00
1D55  0D            dec  c
1D56  3631          ld   (hl),$31
1D58  00            nop
1D59  1837          jr   $1D92
1D5B  1010          djnz $1D6D
1D5D  103D          djnz $1D9C
1D5F  3F            ccf
1D60  3EFF          ld   a,$FF
1D62  03            inc  bc
1D63  3B            dec  sp
1D64  3B            dec  sp
1D65  40            ld   b,b
1D66  00            nop
1D67  0C            inc  c
1D68  33            inc  sp
1D69  00            nop
1D6A  12            ld   (de),a
1D6B  FE00          cp   $00
1D6D  18FE          jr   $1D6D
1D6F  1010          djnz $1D81
1D71  3C            inc  a
1D72  3E3F          ld   a,$3F
1D74  3F            ccf
1D75  FF            rst  $38
1D76  03            inc  bc
1D77  3E40          ld   a,$40
1D79  00            nop
1D7A  0C            inc  c
1D7B  FE00          cp   $00
1D7D  12            ld   (de),a
1D7E  FD            db   $fd
1D7F  00            nop
1D80  18FD          jr   $1D7F
1D82  1010          djnz $1D94
1D84  3D            dec  a
1D85  3B            dec  sp
1D86  3F            ccf
1D87  3B            dec  sp
1D88  FF            rst  $38
1D89  03            inc  bc
1D8A  3F            ccf
1D8B  41            ld   b,c
1D8C  00            nop
1D8D  0C            inc  c
1D8E  FD            db   $fd
1D8F  00            nop
1D90  12            ld   (de),a
1D91  FD            db   $fd
1D92  00            nop
1D93  18FD          jr   $1D92
1D95  103A          djnz $1DD1
1D97  3F            ccf
1D98  3F            ccf
1D99  3E3B          ld   a,$3B
1D9B  FF            rst  $38
1D9C  03            inc  bc
1D9D  3F            ccf
1D9E  40            ld   b,b
1D9F  00            nop
1DA0  0C            inc  c
1DA1  FD            db   $fd
1DA2  00            nop
1DA3  12            ld   (de),a
1DA4  FD            db   $fd
1DA5  00            nop
1DA6  18FD          jr   $1DA5
1DA8  1038          djnz $1DE2
1DAA  3E3F          ld   a,$3F
1DAC  3E3B          ld   a,$3B
1DAE  FF            rst  $38
1DAF  03            inc  bc
1DB0  40            ld   b,b
1DB1  00            nop
1DB2  0C            inc  c
1DB3  FD            db   $fd
1DB4  00            nop
1DB5  12            ld   (de),a
1DB6  FD            db   $fd
1DB7  00            nop
1DB8  18FD          jr   $1DB7
1DBA  1010          djnz $1DCC
1DBC  3A3B3B        ld   a,($3B3B)
1DBF  3F            ccf
1DC0  FF            rst  $38
1DC1  03            inc  bc
1DC2  42            ld   b,d
1DC3  00            nop
1DC4  0C            inc  c
1DC5  FC0012        call m,$1200
1DC8  FC0018        call m,$1800
1DCB  FC1010        call m,$1010
1DCE  3A3F3E        ld   a,($3E3F)
1DD1  3B            dec  sp
1DD2  FF            rst  $38
1DD3  03            inc  bc
1DD4  43            ld   b,e
1DD5  00            nop
1DD6  0A            ld   a,(bc)
1DD7  33            inc  sp
1DD8  310017        ld   sp,$1700
1DDB  3610          ld   (hl),$10
1DDD  103C          djnz $1E1B
1DDF  3F            ccf
1DE0  3B            dec  sp
1DE1  3B            dec  sp
1DE2  3EFF          ld   a,$FF
1DE4  03            inc  bc
1DE5  41            ld   b,c
1DE6  00            nop
1DE7  0A            ld   a,(bc)
1DE8  3600          ld   (hl),$00
1DEA  1636          ld   d,$36
1DEC  1010          djnz $1DFE
1DEE  3D            dec  a
1DEF  3B            dec  sp
1DF0  3F            ccf
1DF1  3E3B          ld   a,$3B
1DF3  3B            dec  sp
1DF4  FF            rst  $38
1DF5  03            inc  bc
1DF6  43            ld   b,e
1DF7  00            nop
1DF8  09            add  hl,bc
1DF9  FE00          cp   $00
1DFB  15            dec  d
1DFC  FE10          cp   $10
1DFE  103A          djnz $1E3A
1E00  3E3F          ld   a,$3F
1E02  3B            dec  sp
1E03  3F            ccf
1E04  3B            dec  sp
1E05  3F            ccf
1E06  FF            rst  $38
1E07  03            inc  bc
1E08  42            ld   b,d
1E09  00            nop
1E0A  09            add  hl,bc
1E0B  FD            db   $fd
1E0C  00            nop
1E0D  15            dec  d
1E0E  FD            db   $fd
1E0F  1010          djnz $1E21
1E11  1010          djnz $1E23
1E13  3E3B          ld   a,$3B
1E15  3F            ccf
1E16  3F            ccf
1E17  3EFF          ld   a,$FF
1E19  03            inc  bc
1E1A  41            ld   b,c
1E1B  00            nop
1E1C  09            add  hl,bc
1E1D  FD            db   $fd
1E1E  00            nop
1E1F  15            dec  d
1E20  FD            db   $fd
1E21  1010          djnz $1E33
1E23  1010          djnz $1E35
1E25  103A          djnz $1E61
1E27  3F            ccf
1E28  3B            dec  sp
1E29  3EFF          ld   a,$FF
1E2B  03            inc  bc
1E2C  40            ld   b,b
1E2D  00            nop
1E2E  09            add  hl,bc
1E2F  FD            db   $fd
1E30  00            nop
1E31  15            dec  d
1E32  FC001E        call m,$1E00
1E35  FD            db   $fd
1E36  FF            rst  $38
1E37  03            inc  bc
1E38  42            ld   b,d
1E39  00            nop
1E3A  09            add  hl,bc
1E3B  FD            db   $fd
1E3C  00            nop
1E3D  1EFE          ld   e,$FE
1E3F  FF            rst  $38
1E40  03            inc  bc
1E41  43            ld   b,e
1E42  00            nop
1E43  09            add  hl,bc
1E44  FD            db   $fd
1E45  00            nop
1E46  1EFD          ld   e,$FD
1E48  FF            rst  $38
1E49  03            inc  bc
1E4A  42            ld   b,d
1E4B  00            nop
1E4C  09            add  hl,bc
1E4D  FD            db   $fd
1E4E  00            nop
1E4F  1EFD          ld   e,$FD
1E51  FF            rst  $38
1E52  03            inc  bc
1E53  41            ld   b,c
1E54  00            nop
1E55  09            add  hl,bc
1E56  FD            db   $fd
1E57  00            nop
1E58  1EFD          ld   e,$FD
1E5A  FF            rst  $38
1E5B  03            inc  bc
1E5C  40            ld   b,b
1E5D  00            nop
1E5E  09            add  hl,bc
1E5F  FC001E        call m,$1E00
1E62  FCFFFF        call m,$FFFF
1E65  FF            rst  $38
1E66  FF            rst  $38
1E67  FF            rst  $38
1E68  FF            rst  $38
1E69  FF            rst  $38
1E6A  FF            rst  $38
1E6B  FF            rst  $38
1E6C  FF            rst  $38
1E6D  FF            rst  $38
1E6E  FF            rst  $38
1E6F  FF            rst  $38
1E70  03            inc  bc
1E71  42            ld   b,d
1E72  00            nop
1E73  0A            ld   a,(bc)
1E74  3032          jr   nc,$1EA8
1E76  00            nop
1E77  1D            dec  e
1E78  3C            inc  a
1E79  3F            ccf
1E7A  FF            rst  $38
1E7B  03            inc  bc
1E7C  43            ld   b,e
1E7D  00            nop
1E7E  0C            inc  c
1E7F  FE00          cp   $00
1E81  1C            inc  e
1E82  3A3B3F        ld   a,($3F3B)
1E85  FF            rst  $38
1E86  03            inc  bc
1E87  41            ld   b,c
1E88  00            nop
1E89  0C            inc  c
1E8A  FC0019        call m,$1900
1E8D  383E          jr   c,$1ECD
1E8F  3B            dec  sp
1E90  3F            ccf
1E91  3F            ccf
1E92  3B            dec  sp
1E93  FF            rst  $38
1E94  03            inc  bc
1E95  3B            dec  sp
1E96  40            ld   b,b
1E97  00            nop
1E98  0D            dec  c
1E99  313200        ld   sp,$0032
1E9C  163A          ld   d,$3A
1E9E  3F            ccf
1E9F  3E3B          ld   a,$3B
1EA1  3B            dec  sp
1EA2  3E3F          ld   a,$3F
1EA4  3B            dec  sp
1EA5  3F            ccf
1EA6  FF            rst  $38
1EA7  03            inc  bc
1EA8  3B            dec  sp
1EA9  00            nop
1EAA  0F            rrca
1EAB  FE00          cp   $00
1EAD  15            dec  d
1EAE  39            add  hl,sp
1EAF  3E3E          ld   a,$3E
1EB1  3F            ccf
1EB2  3B            dec  sp
1EB3  3F            ccf
1EB4  3F            ccf
1EB5  3B            dec  sp
1EB6  3E3F          ld   a,$3F
1EB8  FF            rst  $38
1EB9  03            inc  bc
1EBA  3F            ccf
1EBB  40            ld   b,b
1EBC  00            nop
1EBD  0F            rrca
1EBE  FC0014        call m,$1400
1EC1  383F          jr   c,$1F02
1EC3  3B            dec  sp
1EC4  3E3B          ld   a,$3B
1EC6  3F            ccf
1EC7  3E3B          ld   a,$3B
1EC9  3F            ccf
1ECA  3E3E          ld   a,$3E
1ECC  FF            rst  $38
1ECD  03            inc  bc
1ECE  3B            dec  sp
1ECF  3E41          ld   a,$41
1ED1  00            nop
1ED2  1030          djnz $1F04
1ED4  320014        ld   ($1400),a
1ED7  3A3B3F        ld   a,($3F3B)
1EDA  3E3F          ld   a,$3F
1EDC  3F            ccf
1EDD  3B            dec  sp
1EDE  3B            dec  sp
1EDF  3E3F          ld   a,$3F
1EE1  3EFF          ld   a,$FF
1EE3  03            inc  bc
1EE4  3E3F          ld   a,$3F
1EE6  3B            dec  sp
1EE7  3B            dec  sp
1EE8  40            ld   b,b
1EE9  00            nop
1EEA  12            ld   (de),a
1EEB  FE3F          cp   $3F
1EED  3F            ccf
1EEE  3B            dec  sp
1EEF  3E3F          ld   a,$3F
1EF1  3E3B          ld   a,$3B
1EF3  3B            dec  sp
1EF4  3E3F          ld   a,$3F
1EF6  3E3B          ld   a,$3B
1EF8  FF            rst  $38
1EF9  03            inc  bc
1EFA  3B            dec  sp
1EFB  3F            ccf
1EFC  3F            ccf
1EFD  3E40          ld   a,$40
1EFF  00            nop
1F00  12            ld   (de),a
1F01  FD            db   $fd
1F02  3B            dec  sp
1F03  3F            ccf
1F04  3E3B          ld   a,$3B
1F06  3E3F          ld   a,$3F
1F08  3F            ccf
1F09  3B            dec  sp
1F0A  3B            dec  sp
1F0B  3F            ccf
1F0C  3E3E          ld   a,$3E
1F0E  FF            rst  $38
1F0F  03            inc  bc
1F10  3F            ccf
1F11  3F            ccf
1F12  3E3B          ld   a,$3B
1F14  3B            dec  sp
1F15  00            nop
1F16  1639          ld   d,$39
1F18  3B            dec  sp
1F19  3F            ccf
1F1A  3E3F          ld   a,$3F
1F1C  3F            ccf
1F1D  3B            dec  sp
1F1E  3B            dec  sp
1F1F  3EFF          ld   a,$FF
1F21  03            inc  bc
1F22  3F            ccf
1F23  3B            dec  sp
1F24  3B            dec  sp
1F25  3E40          ld   a,$40
1F27  00            nop
1F28  15            dec  d
1F29  FE3B          cp   $3B
1F2B  3E3F          ld   a,$3F
1F2D  3B            dec  sp
1F2E  3E3F          ld   a,$3F
1F30  3B            dec  sp
1F31  3E3F          ld   a,$3F
1F33  FF            rst  $38
1F34  03            inc  bc
1F35  3B            dec  sp
1F36  3F            ccf
1F37  3E3E          ld   a,$3E
1F39  3B            dec  sp
1F3A  41            ld   b,c
1F3B  00            nop
1F3C  15            dec  d
1F3D  FC3E3B        call m,$3B3E
1F40  3F            ccf
1F41  3E3B          ld   a,$3B
1F43  3F            ccf
1F44  3E3B          ld   a,$3B
1F46  3F            ccf
1F47  FF            rst  $38
1F48  03            inc  bc
1F49  3F            ccf
1F4A  3E3E          ld   a,$3E
1F4C  3F            ccf
1F4D  3F            ccf
1F4E  00            nop
1F4F  19            add  hl,de
1F50  3A3E3F        ld   a,($3F3E)
1F53  3B            dec  sp
1F54  3F            ccf
1F55  3B            dec  sp
1F56  FF            rst  $38
1F57  03            inc  bc
1F58  3F            ccf
1F59  3E3F          ld   a,$3F
1F5B  3B            dec  sp
1F5C  40            ld   b,b
1F5D  00            nop
1F5E  18FE          jr   $1F5E
1F60  3B            dec  sp
1F61  3E3F          ld   a,$3F
1F63  3F            ccf
1F64  3E3B          ld   a,$3B
1F66  FF            rst  $38
1F67  03            inc  bc
1F68  3F            ccf
1F69  3E3E          ld   a,$3E
1F6B  3B            dec  sp
1F6C  3F            ccf
1F6D  40            ld   b,b
1F6E  00            nop
1F6F  18FC          jr   $1F6D
1F71  3E3B          ld   a,$3B
1F73  3E3B          ld   a,$3B
1F75  3E3F          ld   a,$3F
1F77  FF            rst  $38
1F78  03            inc  bc
1F79  3E3B          ld   a,$3B
1F7B  3B            dec  sp
1F7C  41            ld   b,c
1F7D  00            nop
1F7E  1C            inc  e
1F7F  383F          jr   c,$1FC0
1F81  3F            ccf
1F82  FF            rst  $38
1F83  03            inc  bc
1F84  3F            ccf
1F85  3E42          ld   a,$42
1F87  00            nop
1F88  1B            dec  de
1F89  FE3E          cp   $3E
1F8B  3B            dec  sp
1F8C  3B            dec  sp
1F8D  FF            rst  $38
1F8E  03            inc  bc
1F8F  3F            ccf
1F90  40            ld   b,b
1F91  00            nop
1F92  1B            dec  de
1F93  FC3B3E        call m,$3E3B
1F96  3F            ccf
1F97  FF            rst  $38
1F98  03            inc  bc
1F99  42            ld   b,d
1F9A  00            nop
1F9B  09            add  hl,bc
1F9C  FE00          cp   $00
1F9E  1EFE          ld   e,$FE
1FA0  FF            rst  $38
1FA1  03            inc  bc
1FA2  43            ld   b,e
1FA3  00            nop
1FA4  09            add  hl,bc
1FA5  FD            db   $fd
1FA6  00            nop
1FA7  1EFD          ld   e,$FD
1FA9  FF            rst  $38
1FAA  03            inc  bc
1FAB  42            ld   b,d
1FAC  00            nop
1FAD  09            add  hl,bc
1FAE  FD            db   $fd
1FAF  00            nop
1FB0  1EFD          ld   e,$FD
1FB2  FF            rst  $38
1FB3  03            inc  bc
1FB4  41            ld   b,c
1FB5  00            nop
1FB6  09            add  hl,bc
1FB7  FD            db   $fd
1FB8  00            nop
1FB9  1EFD          ld   e,$FD
1FBB  FF            rst  $38
1FBC  03            inc  bc
1FBD  40            ld   b,b
1FBE  00            nop
1FBF  09            add  hl,bc
1FC0  FC001E        call m,$1E00
1FC3  FCFFFF        call m,$FFFF
1FC6  FF            rst  $38
1FC7  FF            rst  $38
1FC8  FF            rst  $38
1FC9  FF            rst  $38
1FCA  FF            rst  $38
1FCB  FF            rst  $38
1FCC  FF            rst  $38
1FCD  FF            rst  $38
1FCE  FF            rst  $38
1FCF  FF            rst  $38
1FD0  FF            rst  $38
1FD1  FF            rst  $38
1FD2  FF            rst  $38
1FD3  FF            rst  $38
1FD4  FF            rst  $38
1FD5  FF            rst  $38
1FD6  FF            rst  $38
1FD7  FF            rst  $38
1FD8  FF            rst  $38
1FD9  FF            rst  $38
1FDA  FF            rst  $38
1FDB  FF            rst  $38
1FDC  FF            rst  $38
1FDD  FF            rst  $38
1FDE  FF            rst  $38
1FDF  FF            rst  $38
1FE0  03            inc  bc
1FE1  42            ld   b,d
1FE2  00            nop
1FE3  1D            dec  e
1FE4  3D            dec  a
1FE5  3B            dec  sp
1FE6  FF            rst  $38
1FE7  03            inc  bc
1FE8  41            ld   b,c
1FE9  00            nop
1FEA  0F            rrca
1FEB  FE00          cp   $00
1FED  1B            dec  de
1FEE  FE3F          cp   $3F
1FF0  3E3B          ld   a,$3B
1FF2  FF            rst  $38
1FF3  03            inc  bc
1FF4  40            ld   b,b
1FF5  00            nop
1FF6  0F            rrca
1FF7  FD            db   $fd
1FF8  00            nop
1FF9  1B            dec  de
1FFA  FD            db   $fd
1FFB  3B            dec  sp
1FFC  3E3F          ld   a,$3F
1FFE  FF            rst  $38
1FFF  03            inc  bc
2000  3F            ccf
2001  43            ld   b,e
2002  00            nop
2003  0F            rrca
2004  FC001B        call m,$1B00
2007  FC3F3E        call m,$3E3F
200A  3B            dec  sp
200B  FF            rst  $38
200C  03            inc  bc
200D  3E3B          ld   a,$3B
200F  41            ld   b,c
2010  00            nop
2011  0E36          ld   c,$36
2013  1032          djnz $2047
2015  00            nop
2016  1B            dec  de
2017  383B          jr   c,$2054
2019  3F            ccf
201A  3EFF          ld   a,$FF
201C  03            inc  bc
201D  3B            dec  sp
201E  3E3E          ld   a,$3E
2020  40            ld   b,b
2021  00            nop
2022  0D            dec  c
2023  3610          ld   (hl),$10
2025  1010          djnz $2037
2027  32001A        ld   ($1A00),a
202A  3D            dec  a
202B  3B            dec  sp
202C  3B            dec  sp
202D  3F            ccf
202E  3F            ccf
202F  FF            rst  $38
2030  03            inc  bc
2031  3B            dec  sp
2032  3E3E          ld   a,$3E
2034  40            ld   b,b
2035  00            nop
2036  0C            inc  c
2037  FE00          cp   $00
2039  12            ld   (de),a
203A  FE00          cp   $00
203C  18FE          jr   $203C
203E  3E3F          ld   a,$3F
2040  3B            dec  sp
2041  3B            dec  sp
2042  3E3F          ld   a,$3F
2044  FF            rst  $38
2045  03            inc  bc
2046  3F            ccf
2047  3E3B          ld   a,$3B
2049  00            nop
204A  0C            inc  c
204B  FD            db   $fd
204C  00            nop
204D  12            ld   (de),a
204E  FD            db   $fd
204F  00            nop
2050  18FD          jr   $204F
2052  3F            ccf
2053  3E3B          ld   a,$3B
2055  3F            ccf
2056  3E3B          ld   a,$3B
2058  FF            rst  $38
2059  03            inc  bc
205A  3E3B          ld   a,$3B
205C  41            ld   b,c
205D  00            nop
205E  0C            inc  c
205F  FC0012        call m,$1200
2062  FC0018        call m,$1800
2065  FC3E3F        call m,$3F3E
2068  3E3F          ld   a,$3F
206A  3B            dec  sp
206B  3F            ccf
206C  FF            rst  $38
206D  03            inc  bc
206E  3F            ccf
206F  42            ld   b,d
2070  00            nop
2071  19            add  hl,de
2072  3C            inc  a
2073  3F            ccf
2074  3E3B          ld   a,$3B
2076  3B            dec  sp
2077  3F            ccf
2078  FF            rst  $38
2079  03            inc  bc
207A  3B            dec  sp
207B  43            ld   b,e
207C  00            nop
207D  19            add  hl,de
207E  3A3E3F        ld   a,($3F3E)
2081  3E3F          ld   a,$3F
2083  3EFF          ld   a,$FF
2085  03            inc  bc
2086  3B            dec  sp
2087  42            ld   b,d
2088  00            nop
2089  19            add  hl,de
208A  3C            inc  a
208B  3B            dec  sp
208C  3B            dec  sp
208D  3E3B          ld   a,$3B
208F  3B            dec  sp
2090  FF            rst  $38
2091  03            inc  bc
2092  3F            ccf
2093  3F            ccf
2094  41            ld   b,c
2095  00            nop
2096  19            add  hl,de
2097  3C            inc  a
2098  3F            ccf
2099  3E3F          ld   a,$3F
209B  3B            dec  sp
209C  3EFF          ld   a,$FF
209E  03            inc  bc
209F  3E43          ld   a,$43
20A1  00            nop
20A2  1A            ld   a,(de)
20A3  3E3F          ld   a,$3F
20A5  3F            ccf
20A6  3E3B          ld   a,$3B
20A8  FF            rst  $38
20A9  03            inc  bc
20AA  3B            dec  sp
20AB  3B            dec  sp
20AC  40            ld   b,b
20AD  00            nop
20AE  0C            inc  c
20AF  FE00          cp   $00
20B1  12            ld   (de),a
20B2  FE00          cp   $00
20B4  18FE          jr   $20B4
20B6  3E3F          ld   a,$3F
20B8  3B            dec  sp
20B9  3B            dec  sp
20BA  3F            ccf
20BB  3EFF          ld   a,$FF
20BD  03            inc  bc
20BE  3F            ccf
20BF  00            nop
20C0  0C            inc  c
20C1  FD            db   $fd
20C2  00            nop
20C3  12            ld   (de),a
20C4  FD            db   $fd
20C5  00            nop
20C6  18FD          jr   $20C5
20C8  3E3E          ld   a,$3E
20CA  3F            ccf
20CB  3B            dec  sp
20CC  3F            ccf
20CD  3B            dec  sp
20CE  FF            rst  $38
20CF  03            inc  bc
20D0  40            ld   b,b
20D1  00            nop
20D2  0C            inc  c
20D3  FC0012        call m,$1200
20D6  FC0018        call m,$1800
20D9  FC3F3E        call m,$3E3F
20DC  3B            dec  sp
20DD  3B            dec  sp
20DE  3E3F          ld   a,$3F
20E0  FF            rst  $38
20E1  03            inc  bc
20E2  42            ld   b,d
20E3  00            nop
20E4  0B            dec  bc
20E5  3600          ld   (hl),$00
20E7  13            inc  de
20E8  320019        ld   ($1900),a
20EB  3031          jr   nc,$211E
20ED  313030        ld   sp,$3030
20F0  FEFF          cp   $FF
20F2  03            inc  bc
20F3  43            ld   b,e
20F4  00            nop
20F5  0A            ld   a,(bc)
20F6  3600          ld   (hl),$00
20F8  14            inc  d
20F9  32001E        ld   ($1E00),a
20FC  FD            db   $fd
20FD  FF            rst  $38
20FE  03            inc  bc
20FF  42            ld   b,d
2100  00            nop
2101  09            add  hl,bc
2102  FE00          cp   $00
2104  15            dec  d
2105  FE00          cp   $00
2107  1EFD          ld   e,$FD
2109  FF            rst  $38
210A  03            inc  bc
210B  41            ld   b,c
210C  00            nop
210D  09            add  hl,bc
210E  FD            db   $fd
210F  00            nop
2110  15            dec  d
2111  FD            db   $fd
2112  00            nop
2113  1EFD          ld   e,$FD
2115  FF            rst  $38
2116  03            inc  bc
2117  40            ld   b,b
2118  00            nop
2119  09            add  hl,bc
211A  FC0015        call m,$1500
211D  FC001E        call m,$1E00
2120  FCFFFF        call m,$FFFF
2123  FF            rst  $38
2124  FF            rst  $38
2125  FF            rst  $38
2126  FF            rst  $38
2127  FF            rst  $38
2128  CDA013        call wait_vblank
212B  3A0383        ld   a,(credits)
212E  A7            and  a
212F  C8            ret  z
2130  CD9014        call reset_xoff_and_cols_and_sprites
2133  C3A400        jp   $00A4
2136  FF            rst  $38
2137  FF            rst  $38
2138  FF            rst  $38
2139  FF            rst  $38
213A  FF            rst  $38
213B  FF            rst  $38
213C  FF            rst  $38
213D  FF            rst  $38
213E  FF            rst  $38
213F  FF            rst  $38
2140  03            inc  bc
2141  40            ld   b,b
2142  00            nop
2143  0A            ld   a,(bc)
2144  48            ld   c,b
2145  00            nop
2146  1E39          ld   e,$39
2148  FF            rst  $38
2149  03            inc  bc
214A  41            ld   b,c
214B  00            nop
214C  0B            dec  bc
214D  48            ld   c,b
214E  00            nop
214F  1D            dec  e
2150  3A3BFF        ld   a,($FF3B)
2153  03            inc  bc
2154  3F            ccf
2155  46            ld   b,(hl)
2156  46            ld   b,(hl)
2157  46            ld   b,(hl)
2158  46            ld   b,(hl)
2159  46            ld   b,(hl)
215A  46            ld   b,(hl)
215B  46            ld   b,(hl)
215C  46            ld   b,(hl)
215D  FA001B        jp   m,$1B00
2160  FE3E          cp   $3E
2162  3F            ccf
2163  3EFF          ld   a,$FF
2165  03            inc  bc
2166  3E40          ld   a,$40
2168  44            ld   b,h
2169  44            ld   b,h
216A  44            ld   b,h
216B  44            ld   b,h
216C  44            ld   b,h
216D  44            ld   b,h
216E  44            ld   b,h
216F  F8            ret  m
2170  00            nop
2171  1B            dec  de
2172  FD            db   $fd
2173  3B            dec  sp
2174  3F            ccf
2175  3EFF          ld   a,$FF
2177  03            inc  bc
2178  42            ld   b,d
2179  00            nop
217A  0D            dec  c
217B  48            ld   c,b
217C  00            nop
217D  1B            dec  de
217E  FC3A3B        call m,$3B3A
2181  3B            dec  sp
2182  FF            rst  $38
2183  03            inc  bc
2184  3B            dec  sp
2185  3B            dec  sp
2186  41            ld   b,c
2187  00            nop
2188  0E48          ld   c,$48
218A  00            nop
218B  1B            dec  de
218C  3C            inc  a
218D  3B            dec  sp
218E  3E3E          ld   a,$3E
2190  FF            rst  $38
2191  03            inc  bc
2192  3B            dec  sp
2193  3E00          ld   a,$00
2195  0F            rrca
2196  48            ld   c,b
2197  00            nop
2198  1B            dec  de
2199  3A3E3F        ld   a,($3F3E)
219C  3F            ccf
219D  FF            rst  $38
219E  03            inc  bc
219F  3F            ccf
21A0  3F            ccf
21A1  40            ld   b,b
21A2  46            ld   b,(hl)
21A3  46            ld   b,(hl)
21A4  46            ld   b,(hl)
21A5  46            ld   b,(hl)
21A6  46            ld   b,(hl)
21A7  46            ld   b,(hl)
21A8  46            ld   b,(hl)
21A9  46            ld   b,(hl)
21AA  46            ld   b,(hl)
21AB  FA0018        jp   m,$1800
21AE  FE10          cp   $10
21B0  1039          djnz $21EB
21B2  3B            dec  sp
21B3  3F            ccf
21B4  3F            ccf
21B5  FF            rst  $38
21B6  03            inc  bc
21B7  3E3B          ld   a,$3B
21B9  3B            dec  sp
21BA  41            ld   b,c
21BB  44            ld   b,h
21BC  44            ld   b,h
21BD  44            ld   b,h
21BE  44            ld   b,h
21BF  44            ld   b,h
21C0  44            ld   b,h
21C1  44            ld   b,h
21C2  44            ld   b,h
21C3  F8            ret  m
21C4  00            nop
21C5  18FD          jr   $21C4
21C7  3F            ccf
21C8  3E3B          ld   a,$3B
21CA  3F            ccf
21CB  3E3B          ld   a,$3B
21CD  FF            rst  $38
21CE  03            inc  bc
21CF  3F            ccf
21D0  3B            dec  sp
21D1  3E40          ld   a,$40
21D3  00            nop
21D4  0F            rrca
21D5  4A            ld   c,d
21D6  00            nop
21D7  18FC          jr   $21D5
21D9  3F            ccf
21DA  3F            ccf
21DB  3E3E          ld   a,$3E
21DD  3B            dec  sp
21DE  3EFF          ld   a,$FF
21E0  03            inc  bc
21E1  3B            dec  sp
21E2  3E43          ld   a,$43
21E4  00            nop
21E5  0F            rrca
21E6  4A            ld   c,d
21E7  00            nop
21E8  1B            dec  de
21E9  3C            inc  a
21EA  3E3F          ld   a,$3F
21EC  3B            dec  sp
21ED  FF            rst  $38
21EE  03            inc  bc
21EF  3F            ccf
21F0  41            ld   b,c
21F1  46            ld   b,(hl)
21F2  46            ld   b,(hl)
21F3  46            ld   b,(hl)
21F4  46            ld   b,(hl)
21F5  46            ld   b,(hl)
21F6  46            ld   b,(hl)
21F7  46            ld   b,(hl)
21F8  46            ld   b,(hl)
21F9  46            ld   b,(hl)
21FA  46            ld   b,(hl)
21FB  FA001B        jp   m,$1B00
21FE  3C            inc  a
21FF  3B            dec  sp
2200  3F            ccf
2201  3EFF          ld   a,$FF
2203  03            inc  bc
2204  40            ld   b,b
2205  44            ld   b,h
2206  44            ld   b,h
2207  44            ld   b,h
2208  44            ld   b,h
2209  44            ld   b,h
220A  44            ld   b,h
220B  44            ld   b,h
220C  44            ld   b,h
220D  44            ld   b,h
220E  44            ld   b,h
220F  44            ld   b,h
2210  F8            ret  m
2211  00            nop
2212  1C            inc  e
2213  39            add  hl,sp
2214  3E3F          ld   a,$3F
2216  FF            rst  $38
2217  03            inc  bc
2218  42            ld   b,d
2219  00            nop
221A  0F            rrca
221B  49            ld   c,c
221C  00            nop
221D  1C            inc  e
221E  3C            inc  a
221F  3B            dec  sp
2220  3B            dec  sp
2221  FF            rst  $38
2222  03            inc  bc
2223  41            ld   b,c
2224  00            nop
2225  0E49          ld   c,$49
2227  00            nop
2228  1B            dec  de
2229  FE3F          cp   $3F
222B  3E3B          ld   a,$3B
222D  FF            rst  $38
222E  03            inc  bc
222F  43            ld   b,e
2230  00            nop
2231  0D            dec  c
2232  49            ld   c,c
2233  00            nop
2234  1B            dec  de
2235  FC3E3F        call m,$3F3E
2238  3B            dec  sp
2239  FF            rst  $38
223A  03            inc  bc
223B  3F            ccf
223C  41            ld   b,c
223D  46            ld   b,(hl)
223E  46            ld   b,(hl)
223F  46            ld   b,(hl)
2240  46            ld   b,(hl)
2241  46            ld   b,(hl)
2242  46            ld   b,(hl)
2243  46            ld   b,(hl)
2244  FA001C        jp   m,$1C00
2247  39            add  hl,sp
2248  3E3B          ld   a,$3B
224A  FF            rst  $38
224B  03            inc  bc
224C  40            ld   b,b
224D  44            ld   b,h
224E  44            ld   b,h
224F  44            ld   b,h
2250  44            ld   b,h
2251  44            ld   b,h
2252  44            ld   b,h
2253  44            ld   b,h
2254  44            ld   b,h
2255  F8            ret  m
2256  00            nop
2257  1D            dec  e
2258  3C            inc  a
2259  3F            ccf
225A  FF            rst  $38
225B  03            inc  bc
225C  42            ld   b,d
225D  00            nop
225E  0B            dec  bc
225F  49            ld   c,c
2260  00            nop
2261  1E3C          ld   e,$3C
2263  FF            rst  $38
2264  03            inc  bc
2265  43            ld   b,e
2266  00            nop
2267  0A            ld   a,(bc)
2268  49            ld   c,c
2269  00            nop
226A  1EFE          ld   e,$FE
226C  FF            rst  $38
226D  03            inc  bc
226E  42            ld   b,d
226F  00            nop
2270  09            add  hl,bc
2271  FE00          cp   $00
2273  1EFD          ld   e,$FD
2275  FF            rst  $38
2276  03            inc  bc
2277  41            ld   b,c
2278  00            nop
2279  09            add  hl,bc
227A  FD            db   $fd
227B  00            nop
227C  1EFD          ld   e,$FD
227E  FF            rst  $38
227F  03            inc  bc
2280  40            ld   b,b
2281  00            nop
2282  09            add  hl,bc
2283  FC001E        call m,$1E00
2286  FCFF          db $fc, $ff

                write_out_0_1:
2288  3E07          ld   a,07
228A  D300          out  ($00),a
228C  3E38          ld   a,$38  ; interuppt?
228E  D301          out  ($01),a
2290  C9            ret

2291  FF            rst  $38
2292  FF            rst  $38
2293  FF            rst  $38
2294  FF            rst  $38
2295  FF            rst  $38
2296  FF            rst  $38
2297  FF            rst  $38
2298  FF            rst  $38
2299  FF            rst  $38
229A  FF            rst  $38
229B  FF            rst  $38
229C  FF            rst  $38
229D  FF            rst  $38
229E  FF            rst  $38
229F  FF            rst  $38
22A0  7E            ld   a,(hl)
22A1  324C81        ld   ($814C),a
22A4  23            inc  hl
22A5  7E            ld   a,(hl)
22A6  324F81        ld   ($814F),a
22A9  23            inc  hl
22AA  3E12          ld   a,$12
22AC  324E81        ld   ($814E),a
22AF  325281        ld   ($8152),a
22B2  7E            ld   a,(hl)
22B3  E6FC          and  $FC
22B5  281D          jr   z,$22D4
22B7  E6F8          and  $F8
22B9  2007          jr   nz,$22C2
22BB  3A4C81        ld   a,($814C)
22BE  D608          sub  $08
22C0  1805          jr   $22C7
22C2  3A4C81        ld   a,($814C)
22C5  C608          add  a,$08
22C7  325081        ld   ($8150),a
22CA  3A4F81        ld   a,($814F)
22CD  C610          add  a,$10
22CF  325381        ld   ($8153),a
22D2  1804          jr   $22D8
22D4  AF            xor  a
22D5  325081        ld   ($8150),a
22D8  7E            ld   a,(hl)
22D9  CB27          sla  a
22DB  010024        ld   bc,$2400
22DE  81            add  a,c
22DF  4F            ld   c,a
22E0  0A            ld   a,(bc)
22E1  324D81        ld   ($814D),a
22E4  03            inc  bc
22E5  0A            ld   a,(bc)
22E6  325181        ld   ($8151),a
22E9  CD2029        call $2920
22EC  C3E023        jp   $23E0
22EF  FF            rst  $38
22F0  00            nop
22F1  00            nop
22F2  00            nop
22F3  00            nop
22F4  00            nop
22F5  00            nop
22F6  00            nop
22F7  00            nop
22F8  00            nop
22F9  00            nop
22FA  00            nop
22FB  3A2D80        ld   a,($802D)
22FE  3C            inc  a
22FF  322D80        ld   ($802D),a
2302  5F            ld   e,a
2303  37            scf
2304  3F            ccf
2305  D60B          sub  $0B
2307  D8            ret  c
2308  3A0480        ld   a,($8004)
230B  A7            and  a
230C  2005          jr   nz,$2313
230E  3A2980        ld   a,($8029)
2311  1803          jr   $2316
2313  3A2A80        ld   a,($802A)
2316  3D            dec  a
2317  213023        ld   hl,$2330
231A  CB27          sla  a
231C  85            add  a,l
231D  6F            ld   l,a
231E  4E            ld   c,(hl)
231F  23            inc  hl
2320  46            ld   b,(hl)
2321  7B            ld   a,e
2322  D60B          sub  $0B
2324  CB27          sla  a
2326  CB27          sla  a
2328  81            add  a,c
2329  6F            ld   l,a
232A  60            ld   h,b
232B  CDA022        call $22A0
232E  C9            ret
232F  FF            rst  $38
2330  78            ld   a,b
2331  23            inc  hl
2332  78            ld   a,b
2333  23            inc  hl
2334  00            nop
2335  2678          ld   h,$78
2337  23            inc  hl
2338  80            add  a,b
2339  2600          ld   h,$00
233B  27            daa
233C  70            ld   (hl),b
233D  27            daa
233E  78            ld   a,b
233F  23            inc  hl
2340  00            nop
2341  2680          ld   h,$80
2343  2600          ld   h,$00
2345  27            daa
2346  70            ld   (hl),b
2347  27            daa
2348  78            ld   a,b
2349  23            inc  hl
234A  00            nop
234B  2678          ld   h,$78
234D  23            inc  hl
234E  00            nop
234F  2870          jr   z,$23C1
2351  27            daa
2352  78            ld   a,b
2353  23            inc  hl
2354  00            nop
2355  2870          jr   z,$23C7
2357  27            daa
2358  00            nop
2359  2A0027        ld   hl,($2700)
235C  70            ld   (hl),b
235D  27            daa
235E  00            nop
235F  2A0027        ld   hl,($2700)
2362  70            ld   (hl),b
2363  27            daa
2364  00            nop
2365  2800          jr   z,$2367
2367  00            nop
2368  00            nop
2369  00            nop
236A  00            nop
236B  00            nop
236C  00            nop
236D  00            nop
236E  00            nop
236F  00            nop
2370  FF            rst  $38
2371  FF            rst  $38
2372  FF            rst  $38
2373  FF            rst  $38
2374  FF            rst  $38
2375  FF            rst  $38
2376  FF            rst  $38
2377  FF            rst  $38
2378  18E0          jr   $235A
237A  00            nop
237B  00            nop
237C  1C            inc  e
237D  E0            ret  po
237E  010020        ld   bc,$2000
2381  E0            ret  po
2382  02            ld   (bc),a
2383  00            nop
2384  28E0          jr   z,$2366
2386  03            inc  bc
2387  00            nop
2388  30E0          jr   nc,$236A
238A  02            ld   (bc),a
238B  00            nop
238C  38E0          jr   c,$236E
238E  010048        ld   bc,$4800
2391  C8            ret  z
2392  00            nop
2393  00            nop
2394  50            ld   d,b
2395  C8            ret  z
2396  010058        ld   bc,$5800
2399  C8            ret  z
239A  02            ld   (bc),a
239B  00            nop
239C  60            ld   h,b
239D  C8            ret  z
239E  03            inc  bc
239F  00            nop
23A0  68            ld   l,b
23A1  C8            ret  z
23A2  02            ld   (bc),a
23A3  00            nop
23A4  70            ld   (hl),b
23A5  C8            ret  z
23A6  03            inc  bc
23A7  00            nop
23A8  80            add  a,b
23A9  C8            ret  z
23AA  07            rlca
23AB  00            nop
23AC  88            adc  a,b
23AD  C8            ret  z
23AE  05            dec  b
23AF  00            nop
23B0  98            sbc  a,b
23B1  C8            ret  z
23B2  03            inc  bc
23B3  00            nop
23B4  A0            and  b
23B5  C8            ret  z
23B6  02            ld   (bc),a
23B7  00            nop
23B8  A8            xor  b
23B9  C8            ret  z
23BA  03            inc  bc
23BB  00            nop
23BC  B0            or   b
23BD  C8            ret  z
23BE  02            ld   (bc),a
23BF  00            nop
23C0  B8            cp   b
23C1  C8            ret  z
23C2  03            inc  bc
23C3  00            nop
23C4  C0            ret  nz
23C5  C8            ret  z
23C6  0100D0        ld   bc,$D000
23C9  D0            ret  nc
23CA  07            rlca
23CB  00            nop
23CC  D8            ret  c
23CD  D0            ret  nc
23CE  05            dec  b
23CF  00            nop
23D0  E0            ret  po
23D1  D0            ret  nc
23D2  0600          ld   b,$00
23D4  E8            ret  pe
23D5  D0            ret  nc
23D6  05            dec  b
23D7  00            nop
23D8  F0            ret  p
23D9  D0            ret  nc
23DA  04            inc  b
23DB  00            nop
23DC  FF            rst  $38
23DD  FF            rst  $38
23DE  FF            rst  $38
23DF  FF            rst  $38
23E0  3A4C81        ld   a,($814C)
23E3  FE18          cp   $18
23E5  C0            ret  nz
23E6  3E07          ld   a,$07
23E8  324480        ld   ($8044),a
23EB  C9            ret
23EC  FF            rst  $38
23ED  FF            rst  $38
23EE  FF            rst  $38
23EF  FF            rst  $38
23F0  FF            rst  $38
23F1  FF            rst  $38
23F2  FF            rst  $38
23F3  FF            rst  $38
23F4  FF            rst  $38
23F5  FF            rst  $38
23F6  FF            rst  $38
23F7  FF            rst  $38
23F8  FF            rst  $38
23F9  FF            rst  $38
23FA  FF            rst  $38
23FB  FF            rst  $38
23FC  FF            rst  $38
23FD  FF            rst  $38
23FE  FF            rst  $38
23FF  FF            rst  $38
2400  2F            cpl
2401  00            nop
2402  2E00          ld   l,$00
2404  2D            dec  l
2405  00            nop
2406  2C            inc  l
2407  00            nop
2408  2D            dec  l
2409  302C          jr   nc,$2437
240B  312D32        ld   sp,$322D
240E  2C            inc  l
240F  33            inc  sp
2410  AD            xor  l
2411  B0            or   b
2412  AC            xor  h
2413  B1            or   c
2414  AD            xor  l
2415  B2            or   d
2416  AC            xor  h
2417  B3            or   e
2418  FF            rst  $38
2419  FF            rst  $38
241A  FF            rst  $38
241B  FF            rst  $38
241C  FF            rst  $38
241D  FF            rst  $38
241E  FF            rst  $38
241F  FF            rst  $38
2420  3A00A8        ld   a,(port_in1)
2423  32F183        ld   ($83F1),a
2426  3A00B0        ld   a,(port_in2)
2429  32F283        ld   ($83F2),a
242C  CD4036        call $3640
242F  C9            ret
2430  0600          ld   b,$00
2432  3A00B8        ld   a,(watchdog)
2435  05            dec  b
2436  20FA          jr   nz,$2432
2438  C9            ret
2439  FF            rst  $38
243A  FF            rst  $38
243B  FF            rst  $38
243C  FF            rst  $38
243D  FF            rst  $38
243E  FF            rst  $38
243F  FF            rst  $38
2440  FF            rst  $38
2441  FF            rst  $38
2442  FF            rst  $38
2443  FF            rst  $38
2444  FF            rst  $38
2445  FF            rst  $38
2446  FF            rst  $38
2447  FF            rst  $38
2448  FF            rst  $38
2449  FF            rst  $38
244A  FF            rst  $38
244B  FF            rst  $38
244C  FF            rst  $38
244D  FF            rst  $38
244E  FF            rst  $38
244F  FF            rst  $38
2450  AF            xor  a
2451  211480        ld   hl,$8014
2454  ED67          rrd
2456  320193        ld   ($9301),a
2459  ED67          rrd
245B  322193        ld   ($9321),a
245E  ED67          rrd
2460  2C            inc  l
2461  ED67          rrd
2463  324193        ld   ($9341),a
2466  ED67          rrd
2468  326193        ld   ($9361),a
246B  ED67          rrd
246D  2C            inc  l
246E  ED67          rrd
2470  328193        ld   ($9381),a
2473  ED67          rrd
2475  ED67          rrd
2477  AF            xor  a
2478  32E192        ld   ($92E1),a
247B  211780        ld   hl,$8017
247E  ED67          rrd
2480  328190        ld   ($9081),a
2483  ED67          rrd
2485  32A190        ld   ($90A1),a
2488  ED67          rrd
248A  2C            inc  l
248B  ED67          rrd
248D  32C190        ld   ($90C1),a
2490  ED67          rrd
2492  32E190        ld   ($90E1),a
2495  ED67          rrd
2497  2C            inc  l
2498  ED67          rrd
249A  320191        ld   ($9101),a
249D  ED67          rrd
249F  ED67          rrd
24A1  AF            xor  a
24A2  326190        ld   ($9061),a
24A5  210083        ld   hl,$8300
24A8  ED67          rrd
24AA  32C191        ld   ($91C1),a
24AD  ED67          rrd
24AF  32E191        ld   ($91E1),a
24B2  ED67          rrd
24B4  2C            inc  l
24B5  ED67          rrd
24B7  320192        ld   ($9201),a
24BA  ED67          rrd
24BC  322192        ld   ($9221),a
24BF  ED67          rrd
24C1  2C            inc  l
24C2  ED67          rrd
24C4  324192        ld   ($9241),a
24C7  ED67          rrd
24C9  ED67          rrd
24CB  AF            xor  a
24CC  32A191        ld   ($91A1),a
24CF  CD3830        call $3038
24D2  C9            ret
24D3  FF            rst  $38
24D4  FF            rst  $38
24D5  FF            rst  $38
24D6  FF            rst  $38
24D7  FF            rst  $38
24D8  FF            rst  $38
24D9  FF            rst  $38
24DA  FF            rst  $38
24DB  FF            rst  $38
24DC  FF            rst  $38
24DD  FF            rst  $38
24DE  FF            rst  $38
24DF  FF            rst  $38
24E0  2660          ld   h,$60
24E2  CDA013        call wait_vblank
24E5  24            inc  h
24E6  20FA          jr   nz,$24E2
24E8  C9            ret
24E9  FF            rst  $38
24EA  FF            rst  $38
24EB  FF            rst  $38
24EC  C5            push bc
24ED  0608          ld   b,$08
24EF  C5            push bc
24F0  CDA013        call wait_vblank
24F3  C1            pop  bc
24F4  10F9          djnz $24EF
24F6  C1            pop  bc
24F7  3E0A          ld   a,$0A
24F9  324480        ld   ($8044),a
24FC  C9            ret
24FD  FF            rst  $38
24FE  FF            rst  $38
24FF  FF            rst  $38
2500  210083        ld   hl,$8300
2503  3600          ld   (hl),$00
2505  2C            inc  l
2506  7D            ld   a,l
2507  FEE1          cp   $E1
2509  20F8          jr   nz,$2503
250B  C9            ret
250C  FF            rst  $38
250D  FF            rst  $38
250E  FF            rst  $38
250F  FF            rst  $38
2510  FF            rst  $38
2511  FF            rst  $38
2512  FF            rst  $38
2513  FF            rst  $38
2514  FF            rst  $38
2515  FF            rst  $38
2516  FF            rst  $38
2517  FF            rst  $38
2518  3A2D80        ld   a,($802D)
251B  E6F8          and  $F8
251D  C8            ret  z
251E  CDB01C        call $1CB0
2521  C9            ret
2522  FF            rst  $38
2523  FF            rst  $38
2524  FF            rst  $38
2525  FF            rst  $38
2526  FF            rst  $38
2527  FF            rst  $38
2528  FF            rst  $38
2529  FF            rst  $38
252A  FF            rst  $38
252B  FF            rst  $38
252C  FF            rst  $38
252D  FF            rst  $38
252E  FF            rst  $38
252F  FF            rst  $38
2530  FF            rst  $38
2531  FF            rst  $38
2532  FF            rst  $38
2533  FF            rst  $38
2534  FF            rst  $38
2535  FF            rst  $38
2536  FF            rst  $38
2537  FF            rst  $38
2538  111600        ld   de,$0016
253B  0E20          ld   c,$20
253D  211090        ld   hl,$9010
2540  060A          ld   b,$0A
2542  36D4          ld   (hl),$D4
2544  23            inc  hl
2545  05            dec  b
2546  20FA          jr   nz,$2542
2548  19            add  hl,de
2549  0D            dec  c
254A  C8            ret  z
254B  18F3          jr   $2540
254D  FF            rst  $38
254E  FF            rst  $38
254F  FF            rst  $38
2550  CD7014        call reset_xoff_sprites_and_clear_screen
2553  CDA013        call wait_vblank
2556  214090        ld   hl,$9040
2559  1E79          ld   e,$79
255B  CD8825        call $2588
255E  21A093        ld   hl,$93A0
2561  CD8825        call $2588
2564  210090        ld   hl,screen_ram
2567  CD9825        call $2598
256A  211F90        ld   hl,$901F
256D  CD9825        call $2598
2570  1610          ld   d,$10
2572  216190        ld   hl,$9061
2575  CDA825        call $25A8
2578  CDC025        call $25C0
257B  CDD025        call $25D0
257E  CDE825        call $25E8
2581  15            dec  d
2582  20F1          jr   nz,$2575
2584  CD8014        call clear_screen
2587  C9            ret
2588  73            ld   (hl),e
2589  2C            inc  l
258A  7D            ld   a,l
258B  E61F          and  $1F
258D  C8            ret  z
258E  18F8          jr   $2588
2590  FF            rst  $38
2591  FF            rst  $38
2592  FF            rst  $38
2593  FF            rst  $38
2594  FF            rst  $38
2595  FF            rst  $38
2596  FF            rst  $38
2597  FF            rst  $38
2598  73            ld   (hl),e
2599  012000        ld   bc,$0020
259C  09            add  hl,bc
259D  7C            ld   a,h
259E  FE94          cp   $94
25A0  C8            ret  z
25A1  18F5          jr   $2598
25A3  FF            rst  $38
25A4  FF            rst  $38
25A5  FF            rst  $38
25A6  FF            rst  $38
25A7  FF            rst  $38
25A8  CDA013        call wait_vblank
25AB  73            ld   (hl),e
25AC  012000        ld   bc,$0020
25AF  09            add  hl,bc
25B0  7E            ld   a,(hl)
25B1  BB            cp   e
25B2  20F7          jr   nz,$25AB
25B4  ED42          sbc  hl,bc
25B6  C9            ret
25B7  FF            rst  $38
25B8  FF            rst  $38
25B9  FF            rst  $38
25BA  FF            rst  $38
25BB  FF            rst  $38
25BC  FF            rst  $38
25BD  FF            rst  $38
25BE  FF            rst  $38
25BF  FF            rst  $38
25C0  CDA013        call wait_vblank
25C3  73            ld   (hl),e
25C4  23            inc  hl
25C5  7E            ld   a,(hl)
25C6  BB            cp   e
25C7  20FA          jr   nz,$25C3
25C9  2B            dec  hl
25CA  C9            ret
25CB  FF            rst  $38
25CC  FF            rst  $38
25CD  FF            rst  $38
25CE  FF            rst  $38
25CF  FF            rst  $38
25D0  CDA013        call wait_vblank
25D3  73            ld   (hl),e
25D4  012000        ld   bc,$0020
25D7  ED42          sbc  hl,bc
25D9  7E            ld   a,(hl)
25DA  BB            cp   e
25DB  20F3          jr   nz,$25D0
25DD  09            add  hl,bc
25DE  C9            ret
25DF  FF            rst  $38
25E0  FF            rst  $38
25E1  FF            rst  $38
25E2  FF            rst  $38
25E3  FF            rst  $38
25E4  FF            rst  $38
25E5  FF            rst  $38
25E6  FF            rst  $38
25E7  FF            rst  $38
25E8  CDA013        call wait_vblank
25EB  73            ld   (hl),e
25EC  2B            dec  hl
25ED  7E            ld   a,(hl)
25EE  BB            cp   e
25EF  20FA          jr   nz,$25EB
25F1  23            inc  hl
25F2  C9            ret
25F3  FF            rst  $38
25F4  FF            rst  $38
25F5  FF            rst  $38
25F6  FF            rst  $38
25F7  FF            rst  $38
25F8  FF            rst  $38
25F9  FF            rst  $38
25FA  FF            rst  $38
25FB  FF            rst  $38
25FC  FF            rst  $38
25FD  FF            rst  $38
25FE  FF            rst  $38
25FF  FF            rst  $38
2600  18E0          jr   $25E2
2602  00            nop
2603  00            nop
2604  1C            inc  e
2605  E0            ret  po
2606  010020        ld   bc,$2000
2609  E0            ret  po
260A  02            ld   (bc),a
260B  00            nop
260C  28E0          jr   z,$25EE
260E  03            inc  bc
260F  00            nop
2610  30E0          jr   nc,$25F2
2612  02            ld   (bc),a
2613  00            nop
2614  38E0          jr   c,$25F6
2616  010040        ld   bc,$4000
2619  D8            ret  c
261A  02            ld   (bc),a
261B  00            nop
261C  48            ld   c,b
261D  D0            ret  nc
261E  04            inc  b
261F  00            nop
2620  50            ld   d,b
2621  C8            ret  z
2622  00            nop
2623  00            nop
2624  58            ld   e,b
2625  C8            ret  z
2626  010060        ld   bc,$6000
2629  C8            ret  z
262A  02            ld   (bc),a
262B  00            nop
262C  68            ld   l,b
262D  CC0300        call z,$0003
2630  70            ld   (hl),b
2631  CC0200        call z,$0002
2634  70            ld   (hl),b
2635  C0            ret  nz
2636  04            inc  b
2637  00            nop
2638  80            add  a,b
2639  B0            or   b
263A  00            nop
263B  00            nop
263C  88            adc  a,b
263D  B0            or   b
263E  010090        ld   bc,screen_ram
2641  B0            or   b
2642  07            rlca
2643  00            nop
2644  98            sbc  a,b
2645  B8            cp   b
2646  04            inc  b
2647  00            nop
2648  A0            and  b
2649  C0            ret  nz
264A  05            dec  b
264B  00            nop
264C  A8            xor  b
264D  B8            cp   b
264E  0600          ld   b,$00
2650  B0            or   b
2651  B8            cp   b
2652  05            dec  b
2653  00            nop
2654  B8            cp   b
2655  B8            cp   b
2656  04            inc  b
2657  00            nop
2658  C0            ret  nz
2659  C8            ret  z
265A  07            rlca
265B  00            nop
265C  C8            ret  z
265D  C8            ret  z
265E  05            dec  b
265F  00            nop
2660  D0            ret  nc
2661  D0            ret  nc
2662  0600          ld   b,$00
2664  D8            ret  c
2665  D0            ret  nc
2666  04            inc  b
2667  00            nop
2668  E0            ret  po
2669  D0            ret  nc
266A  05            dec  b
266B  00            nop
266C  E8            ret  pe
266D  D0            ret  nc
266E  0600          ld   b,$00
2670  F0            ret  p
2671  D0            ret  nc
2672  05            dec  b
2673  00            nop
2674  FF            rst  $38
2675  FF            rst  $38
2676  FF            rst  $38
2677  FF            rst  $38
2678  FF            rst  $38
2679  FF            rst  $38
267A  FF            rst  $38
267B  FF            rst  $38
267C  FF            rst  $38
267D  FF            rst  $38
267E  FF            rst  $38
267F  FF            rst  $38
2680  18E0          jr   $2662
2682  00            nop
2683  00            nop
2684  20E0          jr   nz,$2666
2686  010028        ld   bc,$2800
2689  E0            ret  po
268A  02            ld   (bc),a
268B  00            nop
268C  30D0          jr   nc,$265E
268E  04            inc  b
268F  00            nop
2690  38C0          jr   c,$2652
2692  05            dec  b
2693  00            nop
2694  48            ld   c,b
2695  B8            cp   b
2696  0600          ld   b,$00
2698  50            ld   d,b
2699  B8            cp   b
269A  04            inc  b
269B  00            nop
269C  58            ld   e,b
269D  A8            xor  b
269E  05            dec  b
269F  00            nop
26A0  58            ld   e,b
26A1  A0            and  b
26A2  0600          ld   b,$00
26A4  60            ld   h,b
26A5  A0            and  b
26A6  04            inc  b
26A7  00            nop
26A8  68            ld   l,b
26A9  90            sub  b
26AA  05            dec  b
26AB  00            nop
26AC  70            ld   (hl),b
26AD  88            adc  a,b
26AE  0600          ld   b,$00
26B0  78            ld   a,b
26B1  88            adc  a,b
26B2  04            inc  b
26B3  00            nop
26B4  80            add  a,b
26B5  78            ld   a,b
26B6  05            dec  b
26B7  00            nop
26B8  88            adc  a,b
26B9  70            ld   (hl),b
26BA  0600          ld   b,$00
26BC  90            sub  b
26BD  70            ld   (hl),b
26BE  04            inc  b
26BF  00            nop
26C0  98            sbc  a,b
26C1  60            ld   h,b
26C2  05            dec  b
26C3  00            nop
26C4  A0            and  b
26C5  58            ld   e,b
26C6  0600          ld   b,$00
26C8  A8            xor  b
26C9  58            ld   e,b
26CA  04            inc  b
26CB  00            nop
26CC  B0            or   b
26CD  48            ld   c,b
26CE  05            dec  b
26CF  00            nop
26D0  B8            cp   b
26D1  40            ld   b,b
26D2  0600          ld   b,$00
26D4  C0            ret  nz
26D5  40            ld   b,b
26D6  04            inc  b
26D7  00            nop
26D8  C8            ret  z
26D9  3005          jr   nc,$26E0
26DB  00            nop
26DC  D0            ret  nc
26DD  2806          jr   z,$26E5
26DF  00            nop
26E0  D8            ret  c
26E1  2804          jr   z,$26E7
26E3  00            nop
26E4  E0            ret  po
26E5  2805          jr   z,$26EC
26E7  00            nop
26E8  E8            ret  pe
26E9  2806          jr   z,$26F1
26EB  00            nop
26EC  FF            rst  $38
26ED  FF            rst  $38
26EE  FF            rst  $38
26EF  FF            rst  $38
26F0  FF            rst  $38
26F1  FF            rst  $38
26F2  FF            rst  $38
26F3  FF            rst  $38
26F4  FF            rst  $38
26F5  FF            rst  $38
26F6  FF            rst  $38
26F7  FF            rst  $38
26F8  FF            rst  $38
26F9  FF            rst  $38
26FA  FF            rst  $38
26FB  FF            rst  $38
26FC  FF            rst  $38
26FD  FF            rst  $38
26FE  FF            rst  $38
26FF  FF            rst  $38
2700  1838          jr   $273A
2702  00            nop
2703  00            nop
2704  2038          jr   nz,$273E
2706  010028        ld   bc,$2800
2709  3802          jr   c,$270D
270B  00            nop
270C  3038          jr   nc,$2746
270E  03            inc  bc
270F  00            nop
2710  3838          jr   c,$274A
2712  07            rlca
2713  00            nop
2714  40            ld   b,b
2715  40            ld   b,b
2716  04            inc  b
2717  00            nop
2718  48            ld   c,b
2719  40            ld   b,b
271A  05            dec  b
271B  00            nop
271C  50            ld   d,b
271D  40            ld   b,b
271E  0600          ld   b,$00
2720  58            ld   e,b
2721  40            ld   b,b
2722  04            inc  b
2723  00            nop
2724  68            ld   l,b
2725  58            ld   e,b
2726  05            dec  b
2727  00            nop
2728  70            ld   (hl),b
2729  58            ld   e,b
272A  0600          ld   b,$00
272C  78            ld   a,b
272D  58            ld   e,b
272E  04            inc  b
272F  00            nop
2730  80            add  a,b
2731  58            ld   e,b
2732  05            dec  b
2733  00            nop
2734  88            adc  a,b
2735  58            ld   e,b
2736  0600          ld   b,$00
2738  90            sub  b
2739  58            ld   e,b
273A  04            inc  b
273B  00            nop
273C  98            sbc  a,b
273D  58            ld   e,b
273E  05            dec  b
273F  00            nop
2740  A0            and  b
2741  58            ld   e,b
2742  0600          ld   b,$00
2744  A8            xor  b
2745  58            ld   e,b
2746  04            inc  b
2747  00            nop
2748  B8            cp   b
2749  40            ld   b,b
274A  05            dec  b
274B  00            nop
274C  C0            ret  nz
274D  40            ld   b,b
274E  0600          ld   b,$00
2750  C8            ret  z
2751  40            ld   b,b
2752  04            inc  b
2753  00            nop
2754  D0            ret  nc
2755  3005          jr   nc,$275C
2757  00            nop
2758  D8            ret  c
2759  48            ld   c,b
275A  0600          ld   b,$00
275C  E0            ret  po
275D  2804          jr   z,$2763
275F  00            nop
2760  FF            rst  $38
2761  FF            rst  $38
2762  FF            rst  $38
2763  FF            rst  $38
2764  FF            rst  $38
2765  FF            rst  $38
2766  FF            rst  $38
2767  FF            rst  $38
2768  FF            rst  $38
2769  FF            rst  $38
276A  FF            rst  $38
276B  FF            rst  $38
276C  FF            rst  $38
276D  FF            rst  $38
276E  FF            rst  $38
276F  FF            rst  $38
2770  1838          jr   $27AA
2772  00            nop
2773  00            nop
2774  2038          jr   nz,$27AE
2776  010028        ld   bc,$2800
2779  3802          jr   c,$277D
277B  00            nop
277C  3038          jr   nc,$27B6
277E  03            inc  bc
277F  00            nop
2780  3838          jr   c,$27BA
2782  02            ld   (bc),a
2783  00            nop
2784  40            ld   b,b
2785  3807          jr   c,$278E
2787  00            nop
2788  48            ld   c,b
2789  40            ld   b,b
278A  04            inc  b
278B  00            nop
278C  50            ld   d,b
278D  40            ld   b,b
278E  05            dec  b
278F  00            nop
2790  58            ld   e,b
2791  40            ld   b,b
2792  0600          ld   b,$00
2794  60            ld   h,b
2795  58            ld   e,b
2796  04            inc  b
2797  00            nop
2798  68            ld   l,b
2799  58            ld   e,b
279A  05            dec  b
279B  00            nop
279C  70            ld   (hl),b
279D  58            ld   e,b
279E  0600          ld   b,$00
27A0  78            ld   a,b
27A1  70            ld   (hl),b
27A2  04            inc  b
27A3  00            nop
27A4  80            add  a,b
27A5  70            ld   (hl),b
27A6  05            dec  b
27A7  00            nop
27A8  88            adc  a,b
27A9  70            ld   (hl),b
27AA  0600          ld   b,$00
27AC  90            sub  b
27AD  88            adc  a,b
27AE  04            inc  b
27AF  00            nop
27B0  98            sbc  a,b
27B1  88            adc  a,b
27B2  05            dec  b
27B3  00            nop
27B4  A0            and  b
27B5  88            adc  a,b
27B6  0600          ld   b,$00
27B8  A8            xor  b
27B9  A0            and  b
27BA  04            inc  b
27BB  00            nop
27BC  B0            or   b
27BD  A0            and  b
27BE  05            dec  b
27BF  00            nop
27C0  B8            cp   b
27C1  A0            and  b
27C2  0600          ld   b,$00
27C4  C0            ret  nz
27C5  B8            cp   b
27C6  04            inc  b
27C7  00            nop
27C8  C8            ret  z
27C9  B8            cp   b
27CA  05            dec  b
27CB  00            nop
27CC  D0            ret  nc
27CD  B8            cp   b
27CE  0600          ld   b,$00
27D0  D8            ret  c
27D1  D0            ret  nc
27D2  04            inc  b
27D3  00            nop
27D4  E0            ret  po
27D5  D0            ret  nc
27D6  05            dec  b
27D7  00            nop
27D8  FF            rst  $38
27D9  FF            rst  $38
27DA  FF            rst  $38
27DB  FF            rst  $38
27DC  FF            rst  $38
27DD  FF            rst  $38
27DE  FF            rst  $38
27DF  FF            rst  $38
27E0  3A4381        ld   a,($8143)
27E3  37            scf
27E4  3F            ccf
27E5  C660          add  a,$60
27E7  300B          jr   nc,$27F4
27E9  3ED0          ld   a,$D0
27EB  324381        ld   ($8143),a
27EE  C610          add  a,$10
27F0  324781        ld   ($8147),a
27F3  C9            ret
27F4  3E28          ld   a,$28
27F6  324381        ld   ($8143),a
27F9  C610          add  a,$10
27FB  324781        ld   ($8147),a
27FE  C9            ret
27FF  FF            rst  $38
2800  18E0          jr   $27E2
2802  00            nop
2803  00            nop
2804  20E0          jr   nz,$27E6
2806  010028        ld   bc,$2800
2809  E0            ret  po
280A  02            ld   (bc),a
280B  00            nop
280C  30D0          jr   nc,$27DE
280E  04            inc  b
280F  00            nop
2810  38D0          jr   c,$27E2
2812  05            dec  b
2813  00            nop
2814  40            ld   b,b
2815  B8            cp   b
2816  05            dec  b
2817  00            nop
2818  48            ld   c,b
2819  B8            cp   b
281A  0600          ld   b,$00
281C  50            ld   d,b
281D  B8            cp   b
281E  04            inc  b
281F  00            nop
2820  58            ld   e,b
2821  B8            cp   b
2822  05            dec  b
2823  00            nop
2824  60            ld   h,b
2825  B8            cp   b
2826  0600          ld   b,$00
2828  68            ld   l,b
2829  B8            cp   b
282A  04            inc  b
282B  00            nop
282C  68            ld   l,b
282D  A0            and  b
282E  05            dec  b
282F  00            nop
2830  70            ld   (hl),b
2831  A0            and  b
2832  0600          ld   b,$00
2834  78            ld   a,b
2835  A0            and  b
2836  04            inc  b
2837  00            nop
2838  80            add  a,b
2839  A0            and  b
283A  05            dec  b
283B  00            nop
283C  88            adc  a,b
283D  A0            and  b
283E  0600          ld   b,$00
2840  90            sub  b
2841  A0            and  b
2842  04            inc  b
2843  00            nop
2844  98            sbc  a,b
2845  A0            and  b
2846  05            dec  b
2847  00            nop
2848  A0            and  b
2849  88            adc  a,b
284A  0600          ld   b,$00
284C  B0            or   b
284D  88            adc  a,b
284E  04            inc  b
284F  00            nop
2850  B0            or   b
2851  88            adc  a,b
2852  08            ex   af,af'
2853  00            nop
2854  A8            xor  b
2855  88            adc  a,b
2856  09            add  hl,bc
2857  00            nop
2858  A0            and  b
2859  88            adc  a,b
285A  0A            ld   a,(bc)
285B  00            nop
285C  90            sub  b
285D  70            ld   (hl),b
285E  08            ex   af,af'
285F  00            nop
2860  88            adc  a,b
2861  70            ld   (hl),b
2862  09            add  hl,bc
2863  00            nop
2864  80            add  a,b
2865  70            ld   (hl),b
2866  0A            ld   a,(bc)
2867  00            nop
2868  78            ld   a,b
2869  70            ld   (hl),b
286A  08            ex   af,af'
286B  00            nop
286C  70            ld   (hl),b
286D  70            ld   (hl),b
286E  09            add  hl,bc
286F  00            nop
2870  68            ld   l,b
2871  60            ld   h,b
2872  0A            ld   a,(bc)
2873  00            nop
2874  60            ld   h,b
2875  58            ld   e,b
2876  08            ex   af,af'
2877  00            nop
2878  58            ld   e,b
2879  58            ld   e,b
287A  09            add  hl,bc
287B  00            nop
287C  50            ld   d,b
287D  58            ld   e,b
287E  0A            ld   a,(bc)
287F  00            nop
2880  48            ld   c,b
2881  58            ld   e,b
2882  04            inc  b
2883  00            nop
2884  50            ld   d,b
2885  58            ld   e,b
2886  05            dec  b
2887  00            nop
2888  58            ld   e,b
2889  58            ld   e,b
288A  0600          ld   b,$00
288C  60            ld   h,b
288D  58            ld   e,b
288E  04            inc  b
288F  00            nop
2890  68            ld   l,b
2891  58            ld   e,b
2892  05            dec  b
2893  00            nop
2894  70            ld   (hl),b
2895  48            ld   c,b
2896  0600          ld   b,$00
2898  78            ld   a,b
2899  40            ld   b,b
289A  04            inc  b
289B  00            nop
289C  80            add  a,b
289D  40            ld   b,b
289E  05            dec  b
289F  00            nop
28A0  88            adc  a,b
28A1  40            ld   b,b
28A2  0600          ld   b,$00
28A4  90            sub  b
28A5  40            ld   b,b
28A6  04            inc  b
28A7  00            nop
28A8  98            sbc  a,b
28A9  40            ld   b,b
28AA  05            dec  b
28AB  00            nop
28AC  A0            and  b
28AD  3806          jr   c,$28B5
28AF  00            nop
28B0  A8            xor  b
28B1  3004          jr   nc,$28B7
28B3  00            nop
28B4  B0            or   b
28B5  2805          jr   z,$28BC
28B7  00            nop
28B8  B8            cp   b
28B9  2806          jr   z,$28C1
28BB  00            nop
28BC  C0            ret  nz
28BD  2804          jr   z,$28C3
28BF  00            nop
28C0  C8            ret  z
28C1  2805          jr   z,$28C8
28C3  00            nop
28C4  D0            ret  nc
28C5  2806          jr   z,$28CD
28C7  00            nop
28C8  D8            ret  c
28C9  2804          jr   z,$28CF
28CB  00            nop
28CC  E0            ret  po
28CD  2805          jr   z,$28D4
28CF  00            nop
28D0  FF            rst  $38
28D1  FF            rst  $38
28D2  FF            rst  $38
28D3  FF            rst  $38
28D4  FF            rst  $38
28D5  FF            rst  $38
28D6  FF            rst  $38
28D7  FF            rst  $38
28D8  FF            rst  $38
28D9  FF            rst  $38
28DA  FF            rst  $38
28DB  FF            rst  $38
28DC  FF            rst  $38
28DD  FF            rst  $38
28DE  FF            rst  $38
28DF  FF            rst  $38
28E0  3A1283        ld   a,($8312)
28E3  E603          and  $03
28E5  C0            ret  nz
28E6  3A4C81        ld   a,($814C)
28E9  A7            and  a
28EA  C8            ret  z
28EB  47            ld   b,a
28EC  3A2E80        ld   a,($802E)
28EF  80            add  a,b
28F0  324C81        ld   ($814C),a
28F3  3A5081        ld   a,($8150)
28F6  A7            and  a
28F7  C8            ret  z
28F8  47            ld   b,a
28F9  3A2E80        ld   a,($802E)
28FC  80            add  a,b
28FD  325081        ld   ($8150),a
2900  C9            ret
2901  210002        ld   hl,$0200
2904  CDE301        call $01E3
2907  CD1011        call $1110
290A  212002        ld   hl,$0220
290D  CDE301        call $01E3
2910  214002        ld   hl,$0240
2913  CDE301        call $01E3
2916  CD1011        call $1110
2919  214008        ld   hl,$0840
291C  1822          jr   $2940
291E  FF            rst  $38
291F  FF            rst  $38
2920  23            inc  hl
2921  23            inc  hl
2922  46            ld   b,(hl)
2923  3A4C81        ld   a,($814C)
2926  37            scf
2927  3F            ccf
2928  90            sub  b
2929  3804          jr   c,$292F
292B  3EFF          ld   a,$FF
292D  1802          jr   $2931
292F  3E01          ld   a,$01
2931  322E80        ld   ($802E),a
2934  C9            ret
2935  FF            rst  $38
2936  FF            rst  $38
2937  FF            rst  $38
2938  FF            rst  $38
2939  FF            rst  $38
293A  FF            rst  $38
293B  FF            rst  $38
293C  FF            rst  $38
293D  FF            rst  $38
293E  FF            rst  $38
293F  FF            rst  $38
2940  CDE301        call $01E3
2943  CD1011        call $1110
2946  C9            ret
2947  FF            rst  $38
2948  FF            rst  $38
2949  FF            rst  $38
294A  FF            rst  $38
294B  FF            rst  $38
294C  FF            rst  $38
294D  FF            rst  $38
294E  FF            rst  $38
294F  FF            rst  $38
2950  FF            rst  $38
2951  FF            rst  $38
2952  FF            rst  $38
2953  FF            rst  $38
2954  FF            rst  $38
2955  FF            rst  $38
2956  FF            rst  $38
2957  FF            rst  $38
2958  FF            rst  $38
2959  FF            rst  $38
295A  FF            rst  $38
295B  FF            rst  $38
295C  FF            rst  $38
295D  FF            rst  $38
295E  FF            rst  $38
295F  FF            rst  $38
2960  DDE5          push ix
2962  CD0129        call $2901
2965  DDE1          pop  ix
2967  C9            ret
2968  FF            rst  $38
2969  FF            rst  $38
296A  FF            rst  $38
296B  FF            rst  $38
296C  FF            rst  $38
296D  FF            rst  $38
296E  FF            rst  $38
296F  FF            rst  $38
2970  FF            rst  $38
2971  FF            rst  $38
2972  FF            rst  $38
2973  FF            rst  $38
2974  FF            rst  $38
2975  FF            rst  $38
2976  FF            rst  $38
2977  FF            rst  $38
2978  FF            rst  $38
2979  FF            rst  $38
297A  FF            rst  $38
297B  FF            rst  $38
297C  FF            rst  $38
297D  FF            rst  $38
297E  FF            rst  $38
297F  FF            rst  $38
2980  3A6080        ld   a,($8060)
2983  3C            inc  a
2984  326080        ld   ($8060),a
2987  FE01          cp   $01
2989  2006          jr   nz,$2991
298B  3EF2          ld   a,$F2
298D  324B93        ld   ($934B),a
2990  C9            ret
2991  FE02          cp   $02
2993  2006          jr   nz,$299B
2995  3EF3          ld   a,$F3
2997  324C93        ld   ($934C),a
299A  C9            ret
299B  FE03          cp   $03
299D  2006          jr   nz,$29A5
299F  3EEA          ld   a,$EA
29A1  326B93        ld   ($936B),a
29A4  C9            ret
29A5  FE04          cp   $04
29A7  2006          jr   nz,$29AF
29A9  3EEB          ld   a,$EB
29AB  326C93        ld   ($936C),a
29AE  C9            ret
29AF  FE05          cp   $05
29B1  200D          jr   nz,$29C0
29B3  3A6280        ld   a,($8062)
29B6  217816        ld   hl,$1678
29B9  85            add  a,l
29BA  6F            ld   l,a
29BB  7E            ld   a,(hl)
29BC  328B93        ld   ($938B),a
29BF  C9            ret
29C0  3A6280        ld   a,($8062)
29C3  217C16        ld   hl,$167C
29C6  85            add  a,l
29C7  6F            ld   l,a
29C8  7E            ld   a,(hl)
29C9  328C93        ld   ($938C),a
29CC  CDD03F        call $3FD0
29CF  0E0A          ld   c,$0A
29D1  3A6280        ld   a,($8062)
29D4  47            ld   b,a
29D5  04            inc  b
29D6  3EA0          ld   a,$A0
29D8  321D80        ld   ($801D),a
29DB  C5            push bc
29DC  CD0017        call $1700
29DF  C1            pop  bc
29E0  CDEC24        call $24EC
29E3  10F1          djnz $29D6
29E5  0D            dec  c
29E6  20E9          jr   nz,$29D1
29E8  3A6280        ld   a,($8062)
29EB  3C            inc  a
29EC  FE04          cp   $04
29EE  2002          jr   nz,$29F2
29F0  3E03          ld   a,$03
29F2  326280        ld   ($8062),a
29F5  AF            xor  a
29F6  326080        ld   ($8060),a
29F9  CDD016        call $16D0
29FC  CD9C19        call $199C
29FF  C9            ret
2A00  18E0          jr   $29E2
2A02  00            nop
2A03  00            nop
2A04  20E0          jr   nz,$29E6
2A06  010028        ld   bc,$2800
2A09  E0            ret  po
2A0A  02            ld   (bc),a
2A0B  00            nop
2A0C  30E0          jr   nc,$29EE
2A0E  03            inc  bc
2A0F  00            nop
2A10  38D0          jr   c,$29E2
2A12  04            inc  b
2A13  00            nop
2A14  40            ld   b,b
2A15  C0            ret  nz
2A16  05            dec  b
2A17  00            nop
2A18  48            ld   c,b
2A19  B8            cp   b
2A1A  0600          ld   b,$00
2A1C  48            ld   c,b
2A1D  B8            cp   b
2A1E  04            inc  b
2A1F  00            nop
2A20  50            ld   d,b
2A21  B8            cp   b
2A22  05            dec  b
2A23  00            nop
2A24  58            ld   e,b
2A25  B8            cp   b
2A26  0600          ld   b,$00
2A28  60            ld   h,b
2A29  B8            cp   b
2A2A  04            inc  b
2A2B  00            nop
2A2C  68            ld   l,b
2A2D  B0            or   b
2A2E  00            nop
2A2F  00            nop
2A30  70            ld   (hl),b
2A31  B0            or   b
2A32  010078        ld   bc,$7800
2A35  B0            or   b
2A36  02            ld   (bc),a
2A37  00            nop
2A38  80            add  a,b
2A39  B0            or   b
2A3A  03            inc  bc
2A3B  00            nop
2A3C  88            adc  a,b
2A3D  B8            cp   b
2A3E  02            ld   (bc),a
2A3F  00            nop
2A40  98            sbc  a,b
2A41  B8            cp   b
2A42  03            inc  bc
2A43  00            nop
2A44  A8            xor  b
2A45  B8            cp   b
2A46  02            ld   (bc),a
2A47  00            nop
2A48  B0            or   b
2A49  B0            or   b
2A4A  03            inc  bc
2A4B  00            nop
2A4C  B8            cp   b
2A4D  B0            or   b
2A4E  02            ld   (bc),a
2A4F  00            nop
2A50  C0            ret  nz
2A51  B0            or   b
2A52  03            inc  bc
2A53  00            nop
2A54  C8            ret  z
2A55  A0            and  b
2A56  04            inc  b
2A57  00            nop
2A58  D0            ret  nc
2A59  90            sub  b
2A5A  05            dec  b
2A5B  00            nop
2A5C  D8            ret  c
2A5D  88            adc  a,b
2A5E  0600          ld   b,$00
2A60  E0            ret  po
2A61  88            adc  a,b
2A62  08            ex   af,af'
2A63  00            nop
2A64  D0            ret  nc
2A65  88            adc  a,b
2A66  09            add  hl,bc
2A67  00            nop
2A68  D8            ret  c
2A69  80            add  a,b
2A6A  0A            ld   a,(bc)
2A6B  00            nop
2A6C  C0            ret  nz
2A6D  70            ld   (hl),b
2A6E  08            ex   af,af'
2A6F  00            nop
2A70  B8            cp   b
2A71  70            ld   (hl),b
2A72  09            add  hl,bc
2A73  00            nop
2A74  B0            or   b
2A75  70            ld   (hl),b
2A76  0A            ld   a,(bc)
2A77  00            nop
2A78  90            sub  b
2A79  70            ld   (hl),b
2A7A  08            ex   af,af'
2A7B  00            nop
2A7C  80            add  a,b
2A7D  70            ld   (hl),b
2A7E  09            add  hl,bc
2A7F  00            nop
2A80  78            ld   a,b
2A81  70            ld   (hl),b
2A82  0A            ld   a,(bc)
2A83  00            nop
2A84  70            ld   (hl),b
2A85  70            ld   (hl),b
2A86  08            ex   af,af'
2A87  00            nop
2A88  68            ld   l,b
2A89  70            ld   (hl),b
2A8A  09            add  hl,bc
2A8B  00            nop
2A8C  60            ld   h,b
2A8D  60            ld   h,b
2A8E  0A            ld   a,(bc)
2A8F  00            nop
2A90  58            ld   e,b
2A91  58            ld   e,b
2A92  08            ex   af,af'
2A93  00            nop
2A94  50            ld   d,b
2A95  58            ld   e,b
2A96  04            inc  b
2A97  00            nop
2A98  58            ld   e,b
2A99  58            ld   e,b
2A9A  05            dec  b
2A9B  00            nop
2A9C  60            ld   h,b
2A9D  48            ld   c,b
2A9E  0600          ld   b,$00
2AA0  68            ld   l,b
2AA1  40            ld   b,b
2AA2  04            inc  b
2AA3  00            nop
2AA4  70            ld   (hl),b
2AA5  40            ld   b,b
2AA6  05            dec  b
2AA7  00            nop
2AA8  78            ld   a,b
2AA9  40            ld   b,b
2AAA  0600          ld   b,$00
2AAC  80            add  a,b
2AAD  40            ld   b,b
2AAE  04            inc  b
2AAF  00            nop
2AB0  90            sub  b
2AB1  40            ld   b,b
2AB2  05            dec  b
2AB3  00            nop
2AB4  B0            or   b
2AB5  40            ld   b,b
2AB6  0600          ld   b,$00
2AB8  B8            cp   b
2AB9  40            ld   b,b
2ABA  04            inc  b
2ABB  00            nop
2ABC  C0            ret  nz
2ABD  40            ld   b,b
2ABE  05            dec  b
2ABF  00            nop
2AC0  C8            ret  z
2AC1  40            ld   b,b
2AC2  0600          ld   b,$00
2AC4  D0            ret  nc
2AC5  3804          jr   c,$2ACB
2AC7  00            nop
2AC8  D8            ret  c
2AC9  3005          jr   nc,$2AD0
2ACB  00            nop
2ACC  E0            ret  po
2ACD  2806          jr   z,$2AD5
2ACF  00            nop
2AD0  CDD016        call $16D0
2AD3  3A6080        ld   a,($8060)
2AD6  5F            ld   e,a
2AD7  AF            xor  a
2AD8  326080        ld   ($8060),a
2ADB  7B            ld   a,e
2ADC  A7            and  a
2ADD  C8            ret  z
2ADE  CD8029        call $2980
2AE1  1D            dec  e
2AE2  20FA          jr   nz,$2ADE
2AE4  C9            ret
2AE5  FF            rst  $38
2AE6  FF            rst  $38
2AE7  FF            rst  $38
2AE8  FF            rst  $38
2AE9  FF            rst  $38
2AEA  FF            rst  $38
2AEB  FF            rst  $38
2AEC  FF            rst  $38
2AED  FF            rst  $38
2AEE  FF            rst  $38
2AEF  FF            rst  $38
2AF0  FF            rst  $38
2AF1  FF            rst  $38
2AF2  FF            rst  $38
2AF3  FF            rst  $38
2AF4  FF            rst  $38
2AF5  FF            rst  $38
2AF6  FF            rst  $38
2AF7  FF            rst  $38
2AF8  FF            rst  $38
2AF9  FF            rst  $38
2AFA  FF            rst  $38
2AFB  FF            rst  $38
2AFC  FF            rst  $38
2AFD  FF            rst  $38
2AFE  FF            rst  $38
2AFF  FF            rst  $38
2B00  3A9380        ld   a,($8093)
2B03  47            ld   b,a
2B04  AF            xor  a
2B05  329380        ld   ($8093),a
2B08  78            ld   a,b
2B09  A7            and  a
2B0A  2008          jr   nz,$2B14
2B0C  3A9480        ld   a,($8094)
2B0F  47            ld   b,a
2B10  AF            xor  a
2B11  329480        ld   ($8094),a
2B14  C9            ret
2B15  FF            rst  $38
2B16  FF            rst  $38
2B17  FF            rst  $38
2B18  FF            rst  $38
2B19  FF            rst  $38
2B1A  FF            rst  $38
2B1B  FF            rst  $38
2B1C  FF            rst  $38
2B1D  FF            rst  $38
2B1E  FF            rst  $38
2B1F  FF            rst  $38
2B20  47            ld   b,a
2B21  E6F0          and  $F0
2B23  2003          jr   nz,$2B28
2B25  AF            xor  a
2B26  1812          jr   $2B3A
2B28  FE10          cp   $10
2B2A  2004          jr   nz,$2B30
2B2C  3E0A          ld   a,$0A
2B2E  180A          jr   $2B3A
2B30  FE20          cp   $20
2B32  2004          jr   nz,$2B38
2B34  3E14          ld   a,$14
2B36  1802          jr   $2B3A
2B38  3E1E          ld   a,$1E
2B3A  4F            ld   c,a
2B3B  78            ld   a,b
2B3C  E60F          and  $0F
2B3E  81            add  a,c
2B3F  C9            ret
2B40  FF            rst  $38
2B41  FF            rst  $38
2B42  FF            rst  $38
2B43  FF            rst  $38
2B44  FF            rst  $38
2B45  FF            rst  $38
2B46  FF            rst  $38
2B47  FF            rst  $38
2B48  FF            rst  $38
2B49  FF            rst  $38
2B4A  FF            rst  $38
2B4B  FF            rst  $38
2B4C  FF            rst  $38
2B4D  FF            rst  $38
2B4E  FF            rst  $38
2B4F  FF            rst  $38
2B50  3A0480        ld   a,($8004)
2B53  A7            and  a
2B54  2005          jr   nz,$2B5B
2B56  3A2980        ld   a,($8029)
2B59  1803          jr   $2B5E
2B5B  3A2A80        ld   a,($802A)
2B5E  3D            dec  a
2B5F  CB27          sla  a
2B61  CB27          sla  a
2B63  CD9013        call jump_rel_a
2B66  00            nop
2B67  00            nop
2B68  00            nop
2B69  C9            ret
2B6A  CD482C        call $2C48
2B6D  C9            ret
2B6E  00            nop
2B6F  00            nop
2B70  00            nop
2B71  C9            ret
2B72  CD582C        call $2C58
2B75  C9            ret
2B76  00            nop
2B77  00            nop
2B78  00            nop
2B79  C9            ret
2B7A  00            nop
2B7B  00            nop
2B7C  00            nop
2B7D  C9            ret
2B7E  00            nop
2B7F  00            nop
2B80  00            nop
2B81  C9            ret
2B82  CD982C        call $2C98
2B85  C9            ret
2B86  CD6831        call $3168
2B89  C9            ret
2B8A  CDF02B        call $2BF0
2B8D  C9            ret
2B8E  CD9833        call $3398
2B91  C9            ret
2B92  CD7034        call $3470
2B95  C9            ret
2B96  CD3835        call $3538
2B99  C9            ret
2B9A  CDB835        call $35B8
2B9D  C9            ret
2B9E  CD5836        call $3658
2BA1  C9            ret
2BA2  00            nop
2BA3  00            nop
2BA4  00            nop
2BA5  C9            ret
2BA6  CD7036        call $3670
2BA9  C9            ret
2BAA  CDD036        call $36D0
2BAD  C9            ret
2BAE  CD6037        call $3760
2BB1  C9            ret
2BB2  CDE837        call $37E8
2BB5  C9            ret
2BB6  00            nop
2BB7  00            nop
2BB8  00            nop
2BB9  C9            ret
2BBA  CD0838        call $3808
2BBD  C9            ret
2BBE  CD6838        call $3868
2BC1  C9            ret
2BC2  CD683B        call $3B68
2BC5  C9            ret
2BC6  CD8838        call $3888
2BC9  C9            ret
2BCA  CD1839        call $3918
2BCD  C9            ret
2BCE  CD8838        call $3888
2BD1  C9            ret
2BD2  00            nop
2BD3  00            nop
2BD4  00            nop
2BD5  C9            ret
2BD6  00            nop
2BD7  00            nop
2BD8  00            nop
2BD9  C9            ret
2BDA  00            nop
2BDB  00            nop
2BDC  00            nop
2BDD  C9            ret
2BDE  00            nop
2BDF  00            nop
2BE0  00            nop
2BE1  C9            ret
2BE2  00            nop
2BE3  00            nop
2BE4  00            nop
2BE5  C9            ret
2BE6  FF            rst  $38
2BE7  FF            rst  $38
2BE8  FF            rst  $38
2BE9  FF            rst  $38
2BEA  FF            rst  $38
2BEB  FF            rst  $38
2BEC  FF            rst  $38
2BED  FF            rst  $38
2BEE  FF            rst  $38
2BEF  FF            rst  $38
2BF0  CDD032        call $32D0
2BF3  CDF032        call $32F0
2BF6  C9            ret
2BF7  FF            rst  $38
2BF8  FF            rst  $38
2BF9  FF            rst  $38
2BFA  FF            rst  $38
2BFB  FF            rst  $38
2BFC  FF            rst  $38
2BFD  FF            rst  $38
2BFE  FF            rst  $38
2BFF  FF            rst  $38
2C00  3EB0          ld   a,$B0
2C02  325481        ld   ($8154),a
2C05  3E40          ld   a,$40
2C07  325781        ld   ($8157),a
2C0A  3E1D          ld   a,$1D
2C0C  325581        ld   ($8155),a
2C0F  3E15          ld   a,$15
2C11  325681        ld   ($8156),a
2C14  3E01          ld   a,$01
2C16  323780        ld   ($8037),a
2C19  C9            ret
2C1A  FF            rst  $38
2C1B  FF            rst  $38
2C1C  FF            rst  $38
2C1D  FF            rst  $38
2C1E  FF            rst  $38
2C1F  FF            rst  $38
2C20  FF            rst  $38
2C21  FF            rst  $38
2C22  FF            rst  $38
2C23  FF            rst  $38
2C24  FF            rst  $38
2C25  FF            rst  $38
2C26  FF            rst  $38
2C27  FF            rst  $38
2C28  3A1683        ld   a,($8316)
2C2B  E607          and  $07
2C2D  C0            ret  nz
2C2E  3A3680        ld   a,($8036)
2C31  3C            inc  a
2C32  FE0E          cp   $0E
2C34  2001          jr   nz,$2C37
2C36  AF            xor  a
2C37  323680        ld   ($8036),a
2C3A  A7            and  a
2C3B  C0            ret  nz
2C3C  CD002C        call $2C00
2C3F  C9            ret
2C40  FF            rst  $38
2C41  FF            rst  $38
2C42  FF            rst  $38
2C43  FF            rst  $38
2C44  FF            rst  $38
2C45  FF            rst  $38
2C46  FF            rst  $38
2C47  FF            rst  $38
2C48  CD282C        call $2C28
2C4B  CD4031        call $3140
2C4E  C9            ret
2C4F  FF            rst  $38
2C50  FF            rst  $38
2C51  FF            rst  $38
2C52  FF            rst  $38
2C53  FF            rst  $38
2C54  FF            rst  $38
2C55  FF            rst  $38
2C56  FF            rst  $38
2C57  FF            rst  $38
2C58  CD282C        call $2C28
2C5B  CD4031        call $3140
2C5E  CD3832        call $3238
2C61  CD6032        call $3260
2C64  C9            ret
2C65  FF            rst  $38
2C66  FF            rst  $38
2C67  FF            rst  $38
2C68  FF            rst  $38
2C69  FF            rst  $38
2C6A  FF            rst  $38
2C6B  FF            rst  $38
2C6C  FF            rst  $38
2C6D  FF            rst  $38
2C6E  FF            rst  $38
2C6F  FF            rst  $38
2C70  3AF183        ld   a,($83F1)
2C73  47            ld   b,a
2C74  3A8491        ld   a,($9184)
2C77  FE01          cp   $01
2C79  2804          jr   z,$2C7F
2C7B  CB78          bit  7,b
2C7D  2009          jr   nz,$2C88
2C7F  3A00A0        ld   a,(port_in0)
2C82  CB6F          bit  5,a
2C84  C4D82E        call nz,$2ED8
2C87  C9            ret
2C88  CB68          bit  5,b
2C8A  C4D82E        call nz,$2ED8
2C8D  C9            ret
2C8E  FF            rst  $38
2C8F  FF            rst  $38
2C90  FF            rst  $38
2C91  FF            rst  $38
2C92  FF            rst  $38
2C93  FF            rst  $38
2C94  FF            rst  $38
2C95  FF            rst  $38
2C96  FF            rst  $38
2C97  FF            rst  $38
2C98  CD282C        call $2C28
2C9B  CD4031        call $3140
2C9E  CD3832        call $3238
2CA1  CD6032        call $3260
2CA4  CD7035        call $3570
2CA7  CD9035        call $3590
2CAA  C9            ret
2CAB  FF            rst  $38
2CAC  FF            rst  $38
2CAD  FF            rst  $38
2CAE  FF            rst  $38
2CAF  FF            rst  $38
2CB0  3A0480        ld   a,($8004)
2CB3  A7            and  a
2CB4  2005          jr   nz,$2CBB
2CB6  3A2980        ld   a,($8029)
2CB9  1803          jr   $2CBE
2CBB  3A2A80        ld   a,($802A)
2CBE  3D            dec  a
2CBF  E607          and  $07
2CC1  CB27          sla  a
2CC3  CB27          sla  a
2CC5  CD9013        call jump_rel_a
2CC8  00            nop
2CC9  00            nop
2CCA  00            nop
2CCB  C9            ret
2CCC  00            nop
2CCD  00            nop
2CCE  00            nop
2CCF  C9            ret
2CD0  00            nop
2CD1  00            nop
2CD2  00            nop
2CD3  C9            ret
2CD4  00            nop
2CD5  00            nop
2CD6  00            nop
2CD7  C9            ret
2CD8  00            nop
2CD9  00            nop
2CDA  00            nop
2CDB  C9            ret
2CDC  00            nop
2CDD  00            nop
2CDE  00            nop
2CDF  C9            ret
2CE0  00            nop
2CE1  00            nop
2CE2  00            nop
2CE3  C9            ret
2CE4  00            nop
2CE5  00            nop
2CE6  00            nop
2CE7  C9            ret
2CE8  00            nop
2CE9  00            nop
2CEA  00            nop
2CEB  C9            ret
2CEC  00            nop
2CED  00            nop
2CEE  00            nop
2CEF  C9            ret
2CF0  FF            rst  $38
2CF1  FF            rst  $38
2CF2  FF            rst  $38
2CF3  FF            rst  $38
2CF4  FF            rst  $38
2CF5  FF            rst  $38
2CF6  FF            rst  $38
2CF7  FF            rst  $38
2CF8  FF            rst  $38
2CF9  FF            rst  $38
2CFA  FF            rst  $38
2CFB  FF            rst  $38
2CFC  FF            rst  $38
2CFD  FF            rst  $38
2CFE  FF            rst  $38
2CFF  FF            rst  $38
2D00  210083        ld   hl,$8300
2D03  3A1480        ld   a,($8014)
2D06  BE            cp   (hl)
2D07  2014          jr   nz,$2D1D
2D09  23            inc  hl
2D0A  3A1580        ld   a,($8015)
2D0D  BE            cp   (hl)
2D0E  200D          jr   nz,$2D1D
2D10  23            inc  hl
2D11  3A1680        ld   a,($8016)
2D14  BE            cp   (hl)
2D15  2006          jr   nz,$2D1D
2D17  CD482D        call $2D48
2D1A  C3E803        jp   $03E8
2D1D  210083        ld   hl,$8300
2D20  3A1780        ld   a,($8017)
2D23  BE            cp   (hl)
2D24  20F4          jr   nz,$2D1A
2D26  23            inc  hl
2D27  3A1880        ld   a,($8018)
2D2A  BE            cp   (hl)
2D2B  20ED          jr   nz,$2D1A
2D2D  23            inc  hl
2D2E  3A1980        ld   a,($8019)
2D31  BE            cp   (hl)
2D32  20E6          jr   nz,$2D1A
2D34  CD582D        call $2D58
2D37  C3E803        jp   $03E8
2D3A  FF            rst  $38
2D3B  FF            rst  $38
2D3C  FF            rst  $38
2D3D  FF            rst  $38
2D3E  FF            rst  $38
2D3F  FF            rst  $38
2D40  FF            rst  $38
2D41  FF            rst  $38
2D42  FF            rst  $38
2D43  FF            rst  $38
2D44  FF            rst  $38
2D45  FF            rst  $38
2D46  FF            rst  $38
2D47  FF            rst  $38
2D48  AF            xor  a
2D49  3206B0        ld   ($B006),a
2D4C  3207B0        ld   ($B007),a
2D4F  3E01          ld   a,$01
2D51  CD882D        call $2D88
2D54  C9            ret
2D55  FF            rst  $38
2D56  FF            rst  $38
2D57  FF            rst  $38
2D58  3AF183        ld   a,($83F1)
2D5B  CB7F          bit  7,a
2D5D  280A          jr   z,$2D69
2D5F  3E01          ld   a,$01
2D61  3206B0        ld   ($B006),a
2D64  3207B0        ld   ($B007),a
2D67  1807          jr   $2D70
2D69  AF            xor  a
2D6A  3206B0        ld   ($B006),a
2D6D  3207B0        ld   ($B007),a
2D70  3E02          ld   a,$02
2D72  CD882D        call $2D88
2D75  C9            ret
2D76  FF            rst  $38
2D77  FF            rst  $38
2D78  FF            rst  $38
2D79  FF            rst  $38
2D7A  FF            rst  $38
2D7B  FF            rst  $38
2D7C  FF            rst  $38
2D7D  FF            rst  $38
2D7E  FF            rst  $38
2D7F  FF            rst  $38
2D80  FF            rst  $38
2D81  FF            rst  $38
2D82  FF            rst  $38
2D83  FF            rst  $38
2D84  FF            rst  $38
2D85  FF            rst  $38
2D86  FF            rst  $38
2D87  FF            rst  $38
2D88  F5            push af
2D89  21E816        ld   hl,$16E8
2D8C  CDE301        call $01E3
2D8F  3E09          ld   a,$09
2D91  324280        ld   ($8042),a
2D94  00            nop
2D95  CD7014        call reset_xoff_sprites_and_clear_screen
2D98  CDB837        call $37B8
2D9B  21E00F        ld   hl,$0FE0
2D9E  CD4008        call $0840
2DA1  00            nop
2DA2  00            nop
2DA3  CD1003        call draw_tiles_h
2DA6  04            inc  b
2DA7  0A            ld   a,(bc)
2DA8  201C          jr   nz,$2DC6
2DAA  112915        ld   de,$1529
2DAD  22FFCD        ld   ($CDFF),hl
2DB0  1003          djnz $2DB5
2DB2  07            rlca
2DB3  03            inc  bc
2DB4  29            add  hl,hl
2DB5  1F            rra
2DB6  25            dec  h
2DB7  1012          djnz $2DCB
2DB9  15            dec  d
2DBA  112410        ld   de,$1024
2DBD  24            inc  h
2DBE  1815          jr   $2DD5
2DC0  1018          djnz $2DDA
2DC2  19            add  hl,de
2DC3  17            rla
2DC4  1815          jr   $2DDB
2DC6  23            inc  hl
2DC7  24            inc  h
2DC8  FF            rst  $38
2DC9  CD1003        call draw_tiles_h
2DCC  09            add  hl,bc
2DCD  03            inc  bc
2DCE  23            inc  hl
2DCF  13            inc  de
2DD0  1F            rra
2DD1  221510        ld   ($1015),hl
2DD4  1F            rra
2DD5  1610          ld   d,$10
2DD7  24            inc  h
2DD8  1815          jr   $2DEF
2DDA  1014          djnz $2DF0
2DDC  1129FF        ld   de,$FF29
2DDF  CD1003        call draw_tiles_h
2DE2  0B            dec  bc
2DE3  03            inc  bc
2DE4  201C          jr   nz,$2E02
2DE6  15            dec  d
2DE7  112315        ld   de,$1523
2DEA  1015          djnz $2E01
2DEC  1E24          ld   e,$24
2DEE  15            dec  d
2DEF  221029        ld   ($2910),hl
2DF2  1F            rra
2DF3  25            dec  h
2DF4  22101E        ld   ($1E10),hl
2DF7  111D15        ld   de,$151D
2DFA  FF            rst  $38
2DFB  CD1003        call draw_tiles_h
2DFE  0D            dec  c
2DFF  03            inc  bc
2E00  111012        ld   de,$1210
2E03  1013          djnz $2E18
2E05  1014          djnz $2E1B
2E07  1015          djnz $2E1E
2E09  1016          djnz $2E21
2E0B  1017          djnz $2E24
2E0D  1018          djnz $2E27
2E0F  1019          djnz $2E2A
2E11  101A          djnz $2E2D
2E13  101B          djnz $2E30
2E15  101C          djnz $2E33
2E17  FF            rst  $38
2E18  CD1003        call draw_tiles_h
2E1B  0F            rrca
2E1C  03            inc  bc
2E1D  1D            dec  e
2E1E  101E          djnz $2E3E
2E20  101F          djnz $2E41
2E22  1020          djnz $2E44
2E24  1021          djnz $2E47
2E26  1022          djnz $2E4A
2E28  1023          djnz $2E4D
2E2A  1024          djnz $2E50
2E2C  1025          djnz $2E53
2E2E  1026          djnz $2E56
2E30  1027          djnz $2E59
2E32  1028          djnz $2E5C
2E34  FF            rst  $38
2E35  CD1003        call draw_tiles_h
2E38  110329        ld   de,$2903
2E3B  102A          djnz $2E67
2E3D  1010          djnz $2E4F
2E3F  1010          djnz $2E51
2E41  1010          djnz $2E53
2E43  1051          djnz $2E96
2E45  1052          djnz $2E99
2E47  1053          djnz $2E9C
2E49  1010          djnz $2E5B
2E4B  1010          djnz $2E5D
2E4D  1058          djnz $2EA7
2E4F  59            ld   e,c
2E50  5A            ld   e,d
2E51  5B            ld   e,e
2E52  FF            rst  $38
2E53  CD1003        call draw_tiles_h
2E56  17            rla
2E57  0A            ld   a,(bc)
2E58  2B            dec  hl
2E59  2B            dec  hl
2E5A  2B            dec  hl
2E5B  2B            dec  hl
2E5C  2B            dec  hl
2E5D  2B            dec  hl
2E5E  2B            dec  hl
2E5F  2B            dec  hl
2E60  2B            dec  hl
2E61  2B            dec  hl
2E62  FF            rst  $38
2E63  CD5024        call $2450
2E66  3E09          ld   a,$09
2E68  328293        ld   ($9382),a
2E6B  AF            xor  a
2E6C  326293        ld   ($9362),a
2E6F  327580        ld   ($8075),a
2E72  F1            pop  af
2E73  FD217792      ld   iy,$9277
2E77  328491        ld   ($9184),a
2E7A  CD882F        call $2F88
2E7D  214E93        ld   hl,$934E
2E80  3689          ld   (hl),$89
2E82  DD21F183      ld   ix,$83F1
2E86  3A8491        ld   a,($9184)
2E89  FE01          cp   $01
2E8B  2806          jr   z,$2E93
2E8D  DDCB007E      bit  7,(ix+$00)
2E91  2004          jr   nz,$2E97
2E93  DD2100A0      ld   ix,port_in0
2E97  DDCB005E      bit  3,(ix+$00)
2E9B  2803          jr   z,$2EA0
2E9D  CDA82F        call $2FA8
2EA0  DDCB0056      bit  2,(ix+$00)
2EA4  2803          jr   z,$2EA9
2EA6  CD502F        call $2F50
2EA9  CD702C        call $2C70
2EAC  00            nop
2EAD  00            nop
2EAE  00            nop
2EAF  00            nop
2EB0  00            nop
2EB1  00            nop
2EB2  E5            push hl
2EB3  FDE5          push iy
2EB5  E1            pop  hl
2EB6  3E37          ld   a,$37
2EB8  BD            cp   l
2EB9  2005          jr   nz,$2EC0
2EBB  3E91          ld   a,$91
2EBD  BC            cp   h
2EBE  2808          jr   z,$2EC8
2EC0  E1            pop  hl
2EC1  3689          ld   (hl),$89
2EC3  CD0831        call $3108
2EC6  18B8          jr   $2E80
2EC8  E1            pop  hl
2EC9  CD102F        call $2F10
2ECC  C9            ret
2ECD  FF            rst  $38
2ECE  FF            rst  $38
2ECF  FF            rst  $38
2ED0  FF            rst  $38
2ED1  FF            rst  $38
2ED2  FF            rst  $38
2ED3  FF            rst  $38
2ED4  FF            rst  $38
2ED5  FF            rst  $38
2ED6  FF            rst  $38
2ED7  FF            rst  $38
2ED8  3E10          ld   a,$10
2EDA  329380        ld   ($8093),a
2EDD  3E90          ld   a,$90
2EDF  BC            cp   h
2EE0  2012          jr   nz,$2EF4
2EE2  3E92          ld   a,$92
2EE4  BD            cp   l
2EE5  2004          jr   nz,$2EEB
2EE7  CD102F        call $2F10
2EEA  C9            ret
2EEB  3ED2          ld   a,$D2
2EED  BD            cp   l
2EEE  2004          jr   nz,$2EF4
2EF0  CD202F        call $2F20
2EF3  C9            ret
2EF4  2B            dec  hl
2EF5  7E            ld   a,(hl)
2EF6  23            inc  hl
2EF7  FD7700        ld   (iy+$00),a
2EFA  11E0FF        ld   de,$FFE0
2EFD  FD19          add  iy,de
2EFF  C9            ret
2F00  FF            rst  $38
2F01  FF            rst  $38
2F02  FF            rst  $38
2F03  FF            rst  $38
2F04  FF            rst  $38
2F05  FF            rst  $38
2F06  FF            rst  $38
2F07  FF            rst  $38
2F08  FF            rst  $38
2F09  FF            rst  $38
2F0A  FF            rst  $38
2F0B  FF            rst  $38
2F0C  FF            rst  $38
2F0D  FF            rst  $38
2F0E  FF            rst  $38
2F0F  FF            rst  $38
2F10  AF            xor  a
2F11  328680        ld   ($8086),a
2F14  E1            pop  hl
2F15  E1            pop  hl
2F16  CDE02F        call $2FE0
2F19  C9            ret
2F1A  FF            rst  $38
2F1B  FF            rst  $38
2F1C  FF            rst  $38
2F1D  FF            rst  $38
2F1E  FF            rst  $38
2F1F  FF            rst  $38
2F20  112000        ld   de,$0020
2F23  FD19          add  iy,de
2F25  FD36002B      ld   (iy+$00),$2B
2F29  3E10          ld   a,$10
2F2B  329792        ld   ($9297),a
2F2E  E5            push hl
2F2F  FDE5          push iy
2F31  E1            pop  hl
2F32  3E92          ld   a,$92
2F34  BC            cp   h
2F35  2005          jr   nz,$2F3C
2F37  3E97          ld   a,$97
2F39  BD            cp   l
2F3A  2802          jr   z,$2F3E
2F3C  E1            pop  hl
2F3D  C9            ret
2F3E  11E0FF        ld   de,$FFE0
2F41  FD19          add  iy,de
2F43  E1            pop  hl
2F44  C9            ret
2F45  FF            rst  $38
2F46  FF            rst  $38
2F47  FF            rst  $38
2F48  FF            rst  $38
2F49  FF            rst  $38
2F4A  FF            rst  $38
2F4B  FF            rst  $38
2F4C  FF            rst  $38
2F4D  FF            rst  $38
2F4E  FF            rst  $38
2F4F  FF            rst  $38
2F50  3610          ld   (hl),$10
2F52  114000        ld   de,$0040
2F55  19            add  hl,de
2F56  3E93          ld   a,$93
2F58  BC            cp   h
2F59  C0            ret  nz
2F5A  3E92          ld   a,$92
2F5C  BD            cp   l
2F5D  2004          jr   nz,$2F63
2F5F  219090        ld   hl,$9090
2F62  C9            ret
2F63  3E90          ld   a,$90
2F65  BD            cp   l
2F66  2004          jr   nz,$2F6C
2F68  218E90        ld   hl,$908E
2F6B  C9            ret
2F6C  3E8E          ld   a,$8E
2F6E  BD            cp   l
2F6F  C0            ret  nz
2F70  219290        ld   hl,$9092
2F73  C9            ret
2F74  FF            rst  $38
2F75  FF            rst  $38
2F76  FF            rst  $38
2F77  FF            rst  $38
2F78  FF            rst  $38
2F79  FF            rst  $38
2F7A  FF            rst  $38
2F7B  FF            rst  $38
2F7C  FF            rst  $38
2F7D  FF            rst  $38
2F7E  FF            rst  $38
2F7F  FF            rst  $38
2F80  FF            rst  $38
2F81  FF            rst  $38
2F82  FF            rst  $38
2F83  FF            rst  $38
2F84  FF            rst  $38
2F85  FF            rst  $38
2F86  FF            rst  $38
2F87  FF            rst  $38
2F88  E5            push hl
2F89  210783        ld   hl,$8307
2F8C  3610          ld   (hl),$10
2F8E  23            inc  hl
2F8F  7D            ld   a,l
2F90  FE11          cp   $11
2F92  20F8          jr   nz,$2F8C
2F94  E1            pop  hl
2F95  C9            ret
2F96  FF            rst  $38
2F97  FF            rst  $38
2F98  FF            rst  $38
2F99  1F            rra
2F9A  FF            rst  $38
2F9B  FF            rst  $38
2F9C  FF            rst  $38
2F9D  FF            rst  $38
2F9E  FF            rst  $38
2F9F  FF            rst  $38
2FA0  FF            rst  $38
2FA1  FF            rst  $38
2FA2  FF            rst  $38
2FA3  FF            rst  $38
2FA4  FF            rst  $38
2FA5  FF            rst  $38
2FA6  FF            rst  $38
2FA7  FF            rst  $38
2FA8  3E10          ld   a,$10
2FAA  329380        ld   ($8093),a
2FAD  3610          ld   (hl),$10
2FAF  114000        ld   de,$0040
2FB2  ED52          sbc  hl,de
2FB4  3E90          ld   a,$90
2FB6  BC            cp   h
2FB7  C0            ret  nz
2FB8  3E4E          ld   a,$4E
2FBA  BD            cp   l
2FBB  2004          jr   nz,$2FC1
2FBD  215093        ld   hl,$9350
2FC0  C9            ret
2FC1  3E50          ld   a,$50
2FC3  BD            cp   l
2FC4  2004          jr   nz,$2FCA
2FC6  215293        ld   hl,$9352
2FC9  C9            ret
2FCA  3E52          ld   a,$52
2FCC  BD            cp   l
2FCD  C0            ret  nz
2FCE  214E93        ld   hl,$934E
2FD1  C9            ret
2FD2  FF            rst  $38
2FD3  FF            rst  $38
2FD4  FF            rst  $38
2FD5  CD3830        call $3038
2FD8  CDE024        call $24E0
2FDB  CD7014        call reset_xoff_sprites_and_clear_screen
2FDE  C9            ret
2FDF  FF            rst  $38
2FE0  210783        ld   hl,$8307
2FE3  3A7792        ld   a,($9277)
2FE6  77            ld   (hl),a
2FE7  3A5792        ld   a,($9257)
2FEA  23            inc  hl
2FEB  77            ld   (hl),a
2FEC  3A3792        ld   a,($9237)
2FEF  23            inc  hl
2FF0  77            ld   (hl),a
2FF1  3A1792        ld   a,($9217)
2FF4  23            inc  hl
2FF5  77            ld   (hl),a
2FF6  3AF791        ld   a,($91F7)
2FF9  23            inc  hl
2FFA  77            ld   (hl),a
2FFB  3AD791        ld   a,($91D7)
2FFE  23            inc  hl
2FFF  77            ld   (hl),a
3000  3AB791        ld   a,($91B7)
3003  23            inc  hl
3004  77            ld   (hl),a
3005  3A9791        ld   a,($9197)
3008  23            inc  hl
3009  77            ld   (hl),a
300A  3A7791        ld   a,($9177)
300D  23            inc  hl
300E  77            ld   (hl),a
300F  3A5791        ld   a,($9157)
3012  23            inc  hl
3013  77            ld   (hl),a
3014  CDC030        call $30C0
3017  CDD52F        call $2FD5
301A  C3E803        jp   $03E8
301D  FF            rst  $38
301E  FF            rst  $38
301F  FF            rst  $38
3020  0E05          ld   c,$05
3022  CDA013        call wait_vblank
3025  0D            dec  c
3026  20FA          jr   nz,$3022
3028  C9            ret
3029  FF            rst  $38
302A  FF            rst  $38
302B  FF            rst  $38
302C  FF            rst  $38
302D  FF            rst  $38
302E  FF            rst  $38
302F  FF            rst  $38
3030  FF            rst  $38
3031  FF            rst  $38
3032  FF            rst  $38
3033  FF            rst  $38
3034  FF            rst  $38
3035  FF            rst  $38
3036  FF            rst  $38
3037  FF            rst  $38
3038  3A0783        ld   a,($8307)
303B  328092        ld   ($9280),a
303E  3A0883        ld   a,($8308)
3041  326092        ld   ($9260),a
3044  3A0983        ld   a,($8309)
3047  324092        ld   ($9240),a
304A  3A0A83        ld   a,($830A)
304D  322092        ld   ($9220),a
3050  3A0B83        ld   a,($830B)
3053  320092        ld   ($9200),a
3056  3A0C83        ld   a,($830C)
3059  32E091        ld   ($91E0),a
305C  3A0D83        ld   a,($830D)
305F  32C091        ld   ($91C0),a
3062  3A0E83        ld   a,($830E)
3065  32A091        ld   ($91A0),a
3068  3A0F83        ld   a,($830F)
306B  328091        ld   ($9180),a
306E  3A1083        ld   a,($8310)
3071  326091        ld   ($9160),a
3074  C9            ret
3075  FF            rst  $38
3076  FF            rst  $38
3077  FF            rst  $38
3078  FF            rst  $38
3079  FF            rst  $38
307A  FF            rst  $38
307B  FF            rst  $38
307C  FF            rst  $38
307D  FF            rst  $38
307E  FF            rst  $38
307F  FF            rst  $38
3080  210783        ld   hl,$8307
3083  3618          ld   (hl),$18
3085  23            inc  hl
3086  3619          ld   (hl),$19
3088  23            inc  hl
3089  3617          ld   (hl),$17
308B  23            inc  hl
308C  3618          ld   (hl),$18
308E  23            inc  hl
308F  362B          ld   (hl),$2B
3091  23            inc  hl
3092  3623          ld   (hl),$23
3094  23            inc  hl
3095  3613          ld   (hl),$13
3097  23            inc  hl
3098  361F          ld   (hl),$1F
309A  23            inc  hl
309B  3622          ld   (hl),$22
309D  23            inc  hl
309E  3615          ld   (hl),$15
30A0  210083        ld   hl,$8300
30A3  3600          ld   (hl),$00
30A5  23            inc  hl
30A6  3605          ld   (hl),$05
30A8  23            inc  hl
30A9  3600          ld   (hl),$00
30AB  23            inc  hl
30AC  C9            ret
30AD  FF            rst  $38
30AE  FF            rst  $38
30AF  FF            rst  $38
30B0  FF            rst  $38
30B1  FF            rst  $38
30B2  FF            rst  $38
30B3  FF            rst  $38
30B4  FF            rst  $38
30B5  FF            rst  $38
30B6  FF            rst  $38
30B7  FF            rst  $38
30B8  FF            rst  $38
30B9  FF            rst  $38
30BA  FF            rst  $38
30BB  FF            rst  $38
30BC  FF            rst  $38
30BD  FF            rst  $38
30BE  FF            rst  $38
30BF  FF            rst  $38
30C0  0E00          ld   c,$00
30C2  211083        ld   hl,$8310
30C5  7E            ld   a,(hl)
30C6  FE2B          cp   $2B
30C8  200E          jr   nz,$30D8
30CA  3610          ld   (hl),$10
30CC  2B            dec  hl
30CD  7E            ld   a,(hl)
30CE  FE2B          cp   $2B
30D0  2006          jr   nz,$30D8
30D2  3610          ld   (hl),$10
30D4  2B            dec  hl
30D5  0C            inc  c
30D6  18ED          jr   $30C5
30D8  79            ld   a,c
30D9  A7            and  a
30DA  C8            ret  z
30DB  0D            dec  c
30DC  CDE830        call $30E8
30DF  18F7          jr   $30D8
30E1  FF            rst  $38
30E2  FF            rst  $38
30E3  FF            rst  $38
30E4  FF            rst  $38
30E5  FF            rst  $38
30E6  FF            rst  $38
30E7  FF            rst  $38
30E8  160A          ld   d,$0A
30EA  DD210F83      ld   ix,$830F
30EE  DD7E00        ld   a,(ix+$00)
30F1  DD7701        ld   (ix+$01),a
30F4  15            dec  d
30F5  DD2B          dec  ix
30F7  20F5          jr   nz,$30EE
30F9  3E10          ld   a,$10
30FB  320783        ld   ($8307),a
30FE  C9            ret
30FF  FF            rst  $38
3100  FF            rst  $38
3101  FF            rst  $38
3102  FF            rst  $38
3103  FF            rst  $38
3104  FF            rst  $38
3105  FF            rst  $38
3106  FF            rst  $38
3107  FF            rst  $38
3108  E5            push hl
3109  C5            push bc
310A  FDE5          push iy
310C  DDE5          push ix
310E  0E14          ld   c,$14
3110  CDA013        call wait_vblank
3113  0D            dec  c
3114  20FA          jr   nz,$3110
3116  3A7680        ld   a,($8076)
3119  3C            inc  a
311A  327680        ld   ($8076),a
311D  E601          and  $01
311F  2814          jr   z,$3135
3121  217580        ld   hl,$8075
3124  7E            ld   a,(hl)
3125  3D            dec  a
3126  27            daa
3127  CC102F        call z,$2F10
312A  77            ld   (hl),a
312B  AF            xor  a
312C  ED6F          rld
312E  328293        ld   ($9382),a
3131  ED6F          rld
3133  326293        ld   ($9362),a
3136  ED6F          rld
3138  DDE1          pop  ix
313A  FDE1          pop  iy
313C  C1            pop  bc
313D  E1            pop  hl
313E  C9            ret
313F  FF            rst  $38
3140  3A3780        ld   a,($8037)
3143  A7            and  a
3144  C8            ret  z
3145  3C            inc  a
3146  FE3C          cp   $3C
3148  2001          jr   nz,$314B
314A  AF            xor  a
314B  323780        ld   ($8037),a
314E  218031        ld   hl,$3180
3151  CB27          sla  a
3153  85            add  a,l
3154  6F            ld   l,a
3155  7E            ld   a,(hl)
3156  325581        ld   ($8155),a
3159  23            inc  hl
315A  7E            ld   a,(hl)
315B  325781        ld   ($8157),a
315E  C9            ret
315F  FF            rst  $38
3160  FF            rst  $38
3161  FF            rst  $38
3162  FF            rst  $38
3163  FF            rst  $38
3164  FF            rst  $38
3165  FF            rst  $38
3166  FF            rst  $38
3167  FF            rst  $38
3168  CD282C        call $2C28
316B  CD4031        call $3140
316E  C9            ret
316F  FF            rst  $38
3170  FF            rst  $38
3171  FF            rst  $38
3172  FF            rst  $38
3173  FF            rst  $38
3174  FF            rst  $38
3175  FF            rst  $38
3176  FF            rst  $38
3177  FF            rst  $38
3178  FF            rst  $38
3179  FF            rst  $38
317A  FF            rst  $38
317B  FF            rst  $38
317C  FF            rst  $38
317D  FF            rst  $38
317E  FF            rst  $38
317F  FF            rst  $38
3180  00            nop
3181  00            nop
3182  1D            dec  e
3183  52            ld   d,d
3184  1D            dec  e
3185  54            ld   d,h
3186  1D            dec  e
3187  56            ld   d,(hl)
3188  1D            dec  e
3189  58            ld   e,b
318A  1D            dec  e
318B  5A            ld   e,d
318C  1D            dec  e
318D  5C            ld   e,h
318E  1D            dec  e
318F  5E            ld   e,(hl)
3190  1D            dec  e
3191  60            ld   h,b
3192  1D            dec  e
3193  62            ld   h,d
3194  1D            dec  e
3195  64            ld   h,h
3196  1D            dec  e
3197  66            ld   h,(hl)
3198  1D            dec  e
3199  68            ld   l,b
319A  1D            dec  e
319B  6A            ld   l,d
319C  1D            dec  e
319D  6C            ld   l,h
319E  1D            dec  e
319F  6E            ld   l,(hl)
31A0  1D            dec  e
31A1  71            ld   (hl),c
31A2  1D            dec  e
31A3  73            ld   (hl),e
31A4  1D            dec  e
31A5  75            ld   (hl),l
31A6  1D            dec  e
31A7  78            ld   a,b
31A8  1D            dec  e
31A9  7A            ld   a,d
31AA  1D            dec  e
31AB  7C            ld   a,h
31AC  1D            dec  e
31AD  7F            ld   a,a
31AE  1D            dec  e
31AF  81            add  a,c
31B0  1D            dec  e
31B1  83            add  a,e
31B2  1D            dec  e
31B3  86            add  a,(hl)
31B4  1D            dec  e
31B5  88            adc  a,b
31B6  1D            dec  e
31B7  8A            adc  a,d
31B8  1D            dec  e
31B9  8D            adc  a,l
31BA  1D            dec  e
31BB  8F            adc  a,a
31BC  1D            dec  e
31BD  91            sub  c
31BE  1D            dec  e
31BF  94            sub  h
31C0  1D            dec  e
31C1  96            sub  (hl)
31C2  1D            dec  e
31C3  98            sbc  a,b
31C4  1D            dec  e
31C5  9B            sbc  a,e
31C6  1D            dec  e
31C7  9D            sbc  a,l
31C8  1D            dec  e
31C9  9F            sbc  a,a
31CA  1D            dec  e
31CB  A2            and  d
31CC  1D            dec  e
31CD  A4            and  h
31CE  1D            dec  e
31CF  A6            and  (hl)
31D0  1D            dec  e
31D1  AB            xor  e
31D2  1D            dec  e
31D3  AD            xor  l
31D4  1D            dec  e
31D5  AF            xor  a
31D6  1D            dec  e
31D7  B2            or   d
31D8  1D            dec  e
31D9  B4            or   h
31DA  1D            dec  e
31DB  B6            or   (hl)
31DC  1D            dec  e
31DD  B9            cp   c
31DE  1D            dec  e
31DF  BB            cp   e
31E0  1D            dec  e
31E1  BD            cp   l
31E2  1D            dec  e
31E3  C0            ret  nz
31E4  1D            dec  e
31E5  C21DC4        jp   nz,$C41D
31E8  1D            dec  e
31E9  C61D          add  a,$1D
31EB  C8            ret  z
31EC  1D            dec  e
31ED  CA1DCC        jp   z,$CC1D
31F0  1D            dec  e
31F1  CE1E          adc  a,$1E
31F3  CE1F          adc  a,$1F
31F5  CE20          adc  a,$20
31F7  CE21          adc  a,$21
31F9  CE21          adc  a,$21
31FB  CE21          adc  a,$21
31FD  CEFF          adc  a,$FF
31FF  FF            rst  $38
3200  FF            rst  $38
3201  FF            rst  $38
3202  FF            rst  $38
3203  FF            rst  $38
3204  FF            rst  $38
3205  FF            rst  $38
3206  FF            rst  $38
3207  FF            rst  $38
3208  FF            rst  $38
3209  FF            rst  $38
320A  FF            rst  $38
320B  FF            rst  $38
320C  FF            rst  $38
320D  FF            rst  $38
320E  FF            rst  $38
320F  FF            rst  $38
3210  3EF0          ld   a,$F0
3212  325881        ld   ($8158),a
3215  3EC4          ld   a,$C4
3217  325B81        ld   ($815B),a
321A  3E23          ld   a,$23
321C  325981        ld   ($8159),a
321F  3E16          ld   a,$16
3221  325A81        ld   ($815A),a
3224  3E01          ld   a,$01
3226  323980        ld   ($8039),a
3229  C9            ret
322A  FF            rst  $38
322B  FF            rst  $38
322C  FF            rst  $38
322D  FF            rst  $38
322E  FF            rst  $38
322F  FF            rst  $38
3230  FF            rst  $38
3231  FF            rst  $38
3232  FF            rst  $38
3233  FF            rst  $38
3234  FF            rst  $38
3235  FF            rst  $38
3236  FF            rst  $38
3237  FF            rst  $38
3238  3A5881        ld   a,($8158)
323B  A7            and  a
323C  280F          jr   z,$324D
323E  FE01          cp   $01
3240  280B          jr   z,$324D
3242  FE02          cp   $02
3244  2807          jr   z,$324D
3246  FE03          cp   $03
3248  2803          jr   z,$324D
324A  FE04          cp   $04
324C  C0            ret  nz
324D  CD1032        call $3210
3250  C9            ret
3251  FF            rst  $38
3252  FF            rst  $38
3253  FF            rst  $38
3254  FF            rst  $38
3255  FF            rst  $38
3256  FF            rst  $38
3257  FF            rst  $38
3258  FF            rst  $38
3259  FF            rst  $38
325A  FF            rst  $38
325B  FF            rst  $38
325C  FF            rst  $38
325D  FF            rst  $38
325E  FF            rst  $38
325F  FF            rst  $38
3260  3A1583        ld   a,($8315)
3263  E601          and  $01
3265  C8            ret  z
3266  3A3980        ld   a,($8039)
3269  A7            and  a
326A  C8            ret  z
326B  3A5881        ld   a,($8158)
326E  3D            dec  a
326F  3D            dec  a
3270  3D            dec  a
3271  325881        ld   ($8158),a
3274  3A1583        ld   a,($8315)
3277  E602          and  $02
3279  C0            ret  nz
327A  3A5981        ld   a,($8159)
327D  FE23          cp   $23
327F  2006          jr   nz,$3287
3281  3E24          ld   a,$24
3283  325981        ld   ($8159),a
3286  C9            ret
3287  3E23          ld   a,$23
3289  325981        ld   ($8159),a
328C  C9            ret
328D  FF            rst  $38
328E  FF            rst  $38
328F  FF            rst  $38
3290  FF            rst  $38
3291  FF            rst  $38
3292  FF            rst  $38
3293  FF            rst  $38
3294  FF            rst  $38
3295  FF            rst  $38
3296  FF            rst  $38
3297  FF            rst  $38
3298  FF            rst  $38
3299  FF            rst  $38
329A  FF            rst  $38
329B  FF            rst  $38
329C  FF            rst  $38
329D  FF            rst  $38
329E  FF            rst  $38
329F  FF            rst  $38
32A0  FF            rst  $38
32A1  FF            rst  $38
32A2  FF            rst  $38
32A3  FF            rst  $38
32A4  FF            rst  $38
32A5  FF            rst  $38
32A6  FF            rst  $38
32A7  FF            rst  $38
32A8  FF            rst  $38
32A9  FF            rst  $38
32AA  FF            rst  $38
32AB  FF            rst  $38
32AC  FF            rst  $38
32AD  FF            rst  $38
32AE  FF            rst  $38
32AF  FF            rst  $38
32B0  3EA0          ld   a,$A0
32B2  325481        ld   ($8154),a
32B5  3ED0          ld   a,$D0
32B7  325781        ld   ($8157),a
32BA  3E17          ld   a,$17
32BC  325681        ld   ($8156),a
32BF  3E34          ld   a,$34
32C1  325581        ld   ($8155),a
32C4  3E01          ld   a,$01
32C6  323B80        ld   ($803B),a
32C9  C9            ret
32CA  FF            rst  $38
32CB  FF            rst  $38
32CC  FF            rst  $38
32CD  FF            rst  $38
32CE  FF            rst  $38
32CF  FF            rst  $38
32D0  3A1283        ld   a,($8312)
32D3  E603          and  $03
32D5  C0            ret  nz
32D6  3A3A80        ld   a,($803A)
32D9  3C            inc  a
32DA  FE20          cp   $20
32DC  2001          jr   nz,$32DF
32DE  AF            xor  a
32DF  323A80        ld   ($803A),a
32E2  A7            and  a
32E3  C0            ret  nz
32E4  CDB032        call $32B0
32E7  C9            ret
32E8  FF            rst  $38
32E9  FF            rst  $38
32EA  FF            rst  $38
32EB  FF            rst  $38
32EC  FF            rst  $38
32ED  FF            rst  $38
32EE  FF            rst  $38
32EF  FF            rst  $38
32F0  3A3B80        ld   a,($803B)
32F3  A7            and  a
32F4  C8            ret  z
32F5  3C            inc  a
32F6  FE81          cp   $81
32F8  2001          jr   nz,$32FB
32FA  AF            xor  a
32FB  323B80        ld   ($803B),a
32FE  47            ld   b,a
32FF  37            scf
3300  3F            ccf
3301  D640          sub  $40
3303  3004          jr   nc,$3309
3305  CD1833        call $3318
3308  C9            ret
3309  CD4033        call $3340
330C  C9            ret
330D  FF            rst  $38
330E  FF            rst  $38
330F  FF            rst  $38
3310  FF            rst  $38
3311  FF            rst  $38
3312  FF            rst  $38
3313  FF            rst  $38
3314  FF            rst  $38
3315  FF            rst  $38
3316  FF            rst  $38
3317  FF            rst  $38
3318  3A5781        ld   a,($8157)
331B  3D            dec  a
331C  3D            dec  a
331D  325781        ld   ($8157),a
3320  E603          and  $03
3322  C0            ret  nz
3323  3A5581        ld   a,($8155)
3326  FE34          cp   $34
3328  2806          jr   z,$3330
332A  3E34          ld   a,$34
332C  325581        ld   ($8155),a
332F  C9            ret
3330  3E35          ld   a,$35
3332  325581        ld   ($8155),a
3335  C9            ret
3336  FF            rst  $38
3337  FF            rst  $38
3338  FF            rst  $38
3339  FF            rst  $38
333A  FF            rst  $38
333B  FF            rst  $38
333C  FF            rst  $38
333D  FF            rst  $38
333E  FF            rst  $38
333F  FF            rst  $38
3340  3A5781        ld   a,($8157)
3343  3C            inc  a
3344  3C            inc  a
3345  325781        ld   ($8157),a
3348  3E34          ld   a,$34
334A  325581        ld   ($8155),a
334D  C9            ret
334E  FF            rst  $38
334F  FF            rst  $38
3350  FF            rst  $38
3351  FF            rst  $38
3352  FF            rst  $38
3353  FF            rst  $38
3354  FF            rst  $38
3355  FF            rst  $38
3356  FF            rst  $38
3357  FF            rst  $38
3358  3EF0          ld   a,$F0
335A  325881        ld   ($8158),a
335D  3E40          ld   a,$40
335F  325B81        ld   ($815B),a
3362  3E23          ld   a,$23
3364  325981        ld   ($8159),a
3367  3E16          ld   a,$16
3369  325A81        ld   ($815A),a
336C  3E01          ld   a,$01
336E  323980        ld   ($8039),a
3371  C9            ret
3372  FF            rst  $38
3373  FF            rst  $38
3374  FF            rst  $38
3375  FF            rst  $38
3376  FF            rst  $38
3377  FF            rst  $38
3378  3A5881        ld   a,($8158)
337B  A7            and  a
337C  280F          jr   z,$338D
337E  FE01          cp   $01
3380  280B          jr   z,$338D
3382  FE02          cp   $02
3384  2807          jr   z,$338D
3386  FE03          cp   $03
3388  2803          jr   z,$338D
338A  FE04          cp   $04
338C  C0            ret  nz
338D  CD5833        call $3358
3390  C9            ret
3391  FF            rst  $38
3392  FF            rst  $38
3393  FF            rst  $38
3394  FF            rst  $38
3395  FF            rst  $38
3396  FF            rst  $38
3397  FF            rst  $38
3398  CD7833        call $3378
339B  CD6032        call $3260
339E  C9            ret
339F  FF            rst  $38
33A0  FF            rst  $38
33A1  FF            rst  $38
33A2  FF            rst  $38
33A3  FF            rst  $38
33A4  FF            rst  $38
33A5  FF            rst  $38
33A6  FF            rst  $38
33A7  FF            rst  $38
33A8  CDD032        call $32D0
33AB  CDF032        call $32F0
33AE  C9            ret
33AF  FF            rst  $38
33B0  FF            rst  $38
33B1  FF            rst  $38
33B2  FF            rst  $38
33B3  FF            rst  $38
33B4  FF            rst  $38
33B5  FF            rst  $38
33B6  FF            rst  $38
33B7  FF            rst  $38
33B8  3A3B80        ld   a,($803B)
33BB  A7            and  a
33BC  C8            ret  z
33BD  3C            inc  a
33BE  FE81          cp   $81
33C0  2001          jr   nz,$33C3
33C2  AF            xor  a
33C3  323B80        ld   ($803B),a
33C6  47            ld   b,a
33C7  37            scf
33C8  3F            ccf
33C9  D640          sub  $40
33CB  3004          jr   nc,$33D1
33CD  CDD833        call $33D8
33D0  C9            ret
33D1  CD0034        call $3400
33D4  C9            ret
33D5  FF            rst  $38
33D6  FF            rst  $38
33D7  FF            rst  $38
33D8  3A5781        ld   a,($8157)
33DB  3D            dec  a
33DC  3D            dec  a
33DD  325781        ld   ($8157),a
33E0  E603          and  $03
33E2  C0            ret  nz
33E3  3A5581        ld   a,($8155)
33E6  FE34          cp   $34
33E8  2006          jr   nz,$33F0
33EA  3E35          ld   a,$35
33EC  325581        ld   ($8155),a
33EF  C9            ret
33F0  3E34          ld   a,$34
33F2  325581        ld   ($8155),a
33F5  C9            ret
33F6  FF            rst  $38
33F7  FF            rst  $38
33F8  FF            rst  $38
33F9  FF            rst  $38
33FA  FF            rst  $38
33FB  FF            rst  $38
33FC  FF            rst  $38
33FD  FF            rst  $38
33FE  FF            rst  $38
33FF  FF            rst  $38
3400  3A5781        ld   a,($8157)
3403  3C            inc  a
3404  3C            inc  a
3405  325781        ld   ($8157),a
3408  C9            ret
3409  FF            rst  $38
340A  FF            rst  $38
340B  FF            rst  $38
340C  FF            rst  $38
340D  FF            rst  $38
340E  FF            rst  $38
340F  FF            rst  $38
3410  FF            rst  $38
3411  FF            rst  $38
3412  FF            rst  $38
3413  FF            rst  $38
3414  FF            rst  $38
3415  FF            rst  $38
3416  FF            rst  $38
3417  FF            rst  $38
3418  3A3D80        ld   a,($803D)
341B  A7            and  a
341C  C8            ret  z
341D  3C            inc  a
341E  FE61          cp   $61
3420  2001          jr   nz,$3423
3422  AF            xor  a
3423  323D80        ld   ($803D),a
3426  47            ld   b,a
3427  37            scf
3428  3F            ccf
3429  D630          sub  $30
342B  3004          jr   nc,$3431
342D  CD3834        call $3438
3430  C9            ret
3431  CD5834        call $3458
3434  C9            ret
3435  FF            rst  $38
3436  FF            rst  $38
3437  FF            rst  $38
3438  3A5B81        ld   a,($815B)
343B  3D            dec  a
343C  3D            dec  a
343D  325B81        ld   ($815B),a
3440  E603          and  $03
3442  C0            ret  nz
3443  3A5981        ld   a,($8159)
3446  FE34          cp   $34
3448  2006          jr   nz,$3450
344A  3E35          ld   a,$35
344C  325981        ld   ($8159),a
344F  C9            ret
3450  3E34          ld   a,$34
3452  325981        ld   ($8159),a
3455  C9            ret
3456  FF            rst  $38
3457  FF            rst  $38
3458  3A5B81        ld   a,($815B)
345B  3C            inc  a
345C  3C            inc  a
345D  325B81        ld   ($815B),a
3460  C9            ret
3461  FF            rst  $38
3462  FF            rst  $38
3463  FF            rst  $38
3464  FF            rst  $38
3465  FF            rst  $38
3466  FF            rst  $38
3467  FF            rst  $38
3468  FF            rst  $38
3469  FF            rst  $38
346A  FF            rst  $38
346B  FF            rst  $38
346C  FF            rst  $38
346D  FF            rst  $38
346E  FF            rst  $38
346F  FF            rst  $38
3470  CDB833        call $33B8
3473  CD1834        call $3418
3476  CD8834        call $3488
3479  CDE834        call $34E8
347C  C9            ret
347D  FF            rst  $38
347E  FF            rst  $38
347F  FF            rst  $38
3480  FF            rst  $38
3481  FF            rst  $38
3482  FF            rst  $38
3483  FF            rst  $38
3484  FF            rst  $38
3485  FF            rst  $38
3486  FF            rst  $38
3487  FF            rst  $38
3488  3A1283        ld   a,($8312)
348B  E603          and  $03
348D  C0            ret  nz
348E  3A3A80        ld   a,($803A)
3491  3C            inc  a
3492  FE20          cp   $20
3494  2001          jr   nz,$3497
3496  AF            xor  a
3497  323A80        ld   ($803A),a
349A  A7            and  a
349B  C0            ret  nz
349C  CDA834        call $34A8
349F  C9            ret
34A0  FF            rst  $38
34A1  FF            rst  $38
34A2  FF            rst  $38
34A3  FF            rst  $38
34A4  FF            rst  $38
34A5  FF            rst  $38
34A6  FF            rst  $38
34A7  FF            rst  $38
34A8  3E34          ld   a,$34
34AA  325581        ld   ($8155),a
34AD  3EA4          ld   a,$A4
34AF  325481        ld   ($8154),a
34B2  3EAC          ld   a,$AC
34B4  325781        ld   ($8157),a
34B7  3E17          ld   a,$17
34B9  325681        ld   ($8156),a
34BC  3E01          ld   a,$01
34BE  323B80        ld   ($803B),a
34C1  C9            ret
34C2  FF            rst  $38
34C3  FF            rst  $38
34C4  FF            rst  $38
34C5  FF            rst  $38
34C6  FF            rst  $38
34C7  FF            rst  $38
34C8  3E80          ld   a,$80
34CA  325881        ld   ($8158),a
34CD  3E7C          ld   a,$7C
34CF  325B81        ld   ($815B),a
34D2  3E34          ld   a,$34
34D4  325981        ld   ($8159),a
34D7  3E17          ld   a,$17
34D9  325A81        ld   ($815A),a
34DC  3E01          ld   a,$01
34DE  323D80        ld   ($803D),a
34E1  C9            ret
34E2  FF            rst  $38
34E3  FF            rst  $38
34E4  FF            rst  $38
34E5  FF            rst  $38
34E6  FF            rst  $38
34E7  FF            rst  $38
34E8  3A1283        ld   a,($8312)
34EB  E603          and  $03
34ED  C0            ret  nz
34EE  3A3C80        ld   a,($803C)
34F1  3C            inc  a
34F2  FE28          cp   $28
34F4  2001          jr   nz,$34F7
34F6  AF            xor  a
34F7  323C80        ld   ($803C),a
34FA  A7            and  a
34FB  C0            ret  nz
34FC  CDC834        call $34C8
34FF  C9            ret
3500  FF            rst  $38
3501  FF            rst  $38
3502  FF            rst  $38
3503  FF            rst  $38
3504  FF            rst  $38
3505  FF            rst  $38
3506  FF            rst  $38
3507  FF            rst  $38
3508  FF            rst  $38
3509  FF            rst  $38
350A  FF            rst  $38
350B  FF            rst  $38
350C  FF            rst  $38
350D  FF            rst  $38
350E  FF            rst  $38
350F  FF            rst  $38
3510  3EFF          ld   a,$FF
3512  323680        ld   ($8036),a
3515  323880        ld   ($8038),a
3518  323A80        ld   ($803A),a
351B  323C80        ld   ($803C),a
351E  323E80        ld   ($803E),a
3521  324080        ld   ($8040),a
3524  AF            xor  a
3525  323780        ld   ($8037),a
3528  323980        ld   ($8039),a
352B  323B80        ld   ($803B),a
352E  323D80        ld   ($803D),a
3531  323F80        ld   ($803F),a
3534  324180        ld   ($8041),a
3537  C9            ret
3538  CD3832        call $3238
353B  CD6032        call $3260
353E  CD282C        call $2C28
3541  CD4031        call $3140
3544  CD7035        call $3570
3547  CD9035        call $3590
354A  C9            ret
354B  FF            rst  $38
354C  FF            rst  $38
354D  FF            rst  $38
354E  FF            rst  $38
354F  FF            rst  $38
3550  3E60          ld   a,$60
3552  325C81        ld   ($815C),a
3555  3E1D          ld   a,$1D
3557  325D81        ld   ($815D),a
355A  3E15          ld   a,$15
355C  325E81        ld   ($815E),a
355F  3E40          ld   a,$40
3561  325F81        ld   ($815F),a
3564  3E01          ld   a,$01
3566  323F80        ld   ($803F),a
3569  C9            ret
356A  FF            rst  $38
356B  FF            rst  $38
356C  FF            rst  $38
356D  FF            rst  $38
356E  FF            rst  $38
356F  FF            rst  $38
3570  3A1683        ld   a,($8316)
3573  E607          and  $07
3575  C0            ret  nz
3576  3A3E80        ld   a,($803E)
3579  3C            inc  a
357A  FE14          cp   $14
357C  2001          jr   nz,$357F
357E  AF            xor  a
357F  323E80        ld   ($803E),a
3582  A7            and  a
3583  C0            ret  nz
3584  CD5035        call $3550
3587  C9            ret
3588  FF            rst  $38
3589  FF            rst  $38
358A  FF            rst  $38
358B  FF            rst  $38
358C  FF            rst  $38
358D  FF            rst  $38
358E  FF            rst  $38
358F  FF            rst  $38
3590  3A3F80        ld   a,($803F)
3593  A7            and  a
3594  C8            ret  z
3595  3C            inc  a
3596  FE40          cp   $40
3598  2001          jr   nz,$359B
359A  AF            xor  a
359B  323F80        ld   ($803F),a
359E  218031        ld   hl,$3180
35A1  CB27          sla  a
35A3  85            add  a,l
35A4  6F            ld   l,a
35A5  7E            ld   a,(hl)
35A6  325D81        ld   ($815D),a
35A9  23            inc  hl
35AA  7E            ld   a,(hl)
35AB  325F81        ld   ($815F),a
35AE  C9            ret
35AF  FF            rst  $38
35B0  FF            rst  $38
35B1  FF            rst  $38
35B2  FF            rst  $38
35B3  FF            rst  $38
35B4  FF            rst  $38
35B5  FF            rst  $38
35B6  FF            rst  $38
35B7  FF            rst  $38
35B8  CD7035        call $3570
35BB  CD9035        call $3590
35BE  CD282C        call $2C28
35C1  CD4031        call $3140
35C4  C9            ret
35C5  FF            rst  $38
35C6  FF            rst  $38
35C7  FF            rst  $38
35C8  FF            rst  $38
35C9  FF            rst  $38
35CA  FF            rst  $38
35CB  FF            rst  $38
35CC  FF            rst  $38
35CD  FF            rst  $38
35CE  FF            rst  $38
35CF  FF            rst  $38
35D0  3E10          ld   a,$10
35D2  325C81        ld   ($815C),a
35D5  3EA3          ld   a,$A3
35D7  325D81        ld   ($815D),a
35DA  3E16          ld   a,$16
35DC  325E81        ld   ($815E),a
35DF  3EBC          ld   a,$BC
35E1  325F81        ld   ($815F),a
35E4  3E01          ld   a,$01
35E6  324180        ld   ($8041),a
35E9  C9            ret
35EA  FF            rst  $38
35EB  FF            rst  $38
35EC  FF            rst  $38
35ED  FF            rst  $38
35EE  FF            rst  $38
35EF  FF            rst  $38
35F0  3A5C81        ld   a,($815C)
35F3  A7            and  a
35F4  280F          jr   z,$3605
35F6  FE01          cp   $01
35F8  280B          jr   z,$3605
35FA  FE02          cp   $02
35FC  2807          jr   z,$3605
35FE  FE03          cp   $03
3600  2803          jr   z,$3605
3602  FE04          cp   $04
3604  C0            ret  nz
3605  CDD035        call $35D0
3608  C9            ret
3609  FF            rst  $38
360A  FF            rst  $38
360B  FF            rst  $38
360C  FF            rst  $38
360D  FF            rst  $38
360E  FF            rst  $38
360F  FF            rst  $38
3610  3A1583        ld   a,($8315)
3613  E601          and  $01
3615  C8            ret  z
3616  3A4180        ld   a,($8041)
3619  A7            and  a
361A  C8            ret  z
361B  3A5C81        ld   a,($815C)
361E  3C            inc  a
361F  3C            inc  a
3620  3C            inc  a
3621  325C81        ld   ($815C),a
3624  3A1583        ld   a,($8315)
3627  E602          and  $02
3629  C0            ret  nz
362A  3A5D81        ld   a,($815D)
362D  FEA3          cp   $A3
362F  2006          jr   nz,$3637
3631  3EA4          ld   a,$A4
3633  325D81        ld   ($815D),a
3636  C9            ret
3637  3EA3          ld   a,$A3
3639  325D81        ld   ($815D),a
363C  C9            ret
363D  FF            rst  $38
363E  FF            rst  $38
363F  FF            rst  $38
3640  C5            push bc
3641  3AF183        ld   a,($83F1)
3644  E63F          and  $3F
3646  4F            ld   c,a
3647  3E0E          ld   a,$0E
3649  D300          out  ($00),a
364B  DB02          in   a,($02)
364D  32F283        ld   ($83F2),a
3650  E6C0          and  $C0
3652  81            add  a,c
3653  32F183        ld   ($83F1),a
3656  C1            pop  bc
3657  C9            ret
3658  CDF035        call $35F0
365B  CD1036        call $3610
365E  CD3832        call $3238
3661  CD6032        call $3260
3664  C9            ret
3665  FF            rst  $38
3666  FF            rst  $38
3667  FF            rst  $38
3668  FF            rst  $38
3669  FF            rst  $38
366A  FF            rst  $38
366B  FF            rst  $38
366C  FF            rst  $38
366D  FF            rst  $38
366E  FF            rst  $38
366F  FF            rst  $38
3670  CDB833        call $33B8
3673  CD1834        call $3418
3676  CD8834        call $3488
3679  CDE834        call $34E8
367C  CDA836        call $36A8
367F  CD1036        call $3610
3682  C9            ret
3683  FF            rst  $38
3684  FF            rst  $38
3685  FF            rst  $38
3686  FF            rst  $38
3687  FF            rst  $38
3688  3E10          ld   a,$10
368A  325C81        ld   ($815C),a
368D  3EA3          ld   a,$A3
368F  325D81        ld   ($815D),a
3692  3E16          ld   a,$16
3694  325E81        ld   ($815E),a
3697  3E98          ld   a,$98
3699  325F81        ld   ($815F),a
369C  3E01          ld   a,$01
369E  324180        ld   ($8041),a
36A1  C9            ret
36A2  FF            rst  $38
36A3  FF            rst  $38
36A4  FF            rst  $38
36A5  FF            rst  $38
36A6  FF            rst  $38
36A7  FF            rst  $38
36A8  3A5C81        ld   a,($815C)
36AB  A7            and  a
36AC  280F          jr   z,$36BD
36AE  FE01          cp   $01
36B0  280B          jr   z,$36BD
36B2  FE02          cp   $02
36B4  2807          jr   z,$36BD
36B6  FE03          cp   $03
36B8  2803          jr   z,$36BD
36BA  FE04          cp   $04
36BC  C0            ret  nz
36BD  CD8836        call $3688
36C0  C9            ret
36C1  FF            rst  $38
36C2  FF            rst  $38
36C3  FF            rst  $38
36C4  FF            rst  $38
36C5  FF            rst  $38
36C6  FF            rst  $38
36C7  FF            rst  $38
36C8  FF            rst  $38
36C9  FF            rst  $38
36CA  FF            rst  $38
36CB  FF            rst  $38
36CC  FF            rst  $38
36CD  FF            rst  $38
36CE  FF            rst  $38
36CF  FF            rst  $38
36D0  CDF035        call $35F0
36D3  CD1036        call $3610
36D6  CD3832        call $3238
36D9  CD6032        call $3260
36DC  CD282C        call $2C28
36DF  CD4031        call $3140
36E2  C9            ret
36E3  FF            rst  $38
36E4  FF            rst  $38
36E5  FF            rst  $38
36E6  FF            rst  $38
36E7  FF            rst  $38
36E8  3EF0          ld   a,$F0
36EA  325C81        ld   ($815C),a
36ED  3E22          ld   a,$22
36EF  325D81        ld   ($815D),a
36F2  3E17          ld   a,$17
36F4  325E81        ld   ($815E),a
36F7  3E94          ld   a,$94
36F9  325F81        ld   ($815F),a
36FC  3E01          ld   a,$01
36FE  324180        ld   ($8041),a
3701  C9            ret
3702  FF            rst  $38
3703  FF            rst  $38
3704  FF            rst  $38
3705  FF            rst  $38
3706  FF            rst  $38
3707  FF            rst  $38
3708  FF            rst  $38
3709  FF            rst  $38
370A  FF            rst  $38
370B  FF            rst  $38
370C  FF            rst  $38
370D  FF            rst  $38
370E  FF            rst  $38
370F  FF            rst  $38
3710  3A5C81        ld   a,($815C)
3713  A7            and  a
3714  280F          jr   z,$3725
3716  FE01          cp   $01
3718  280B          jr   z,$3725
371A  FE02          cp   $02
371C  2807          jr   z,$3725
371E  FE03          cp   $03
3720  2803          jr   z,$3725
3722  FE04          cp   $04
3724  C0            ret  nz
3725  CDE836        call $36E8
3728  C9            ret
3729  FF            rst  $38
372A  FF            rst  $38
372B  FF            rst  $38
372C  FF            rst  $38
372D  FF            rst  $38
372E  FF            rst  $38
372F  FF            rst  $38
3730  3A1583        ld   a,($8315)
3733  E601          and  $01
3735  C8            ret  z
3736  3A4180        ld   a,($8041)
3739  A7            and  a
373A  C8            ret  z
373B  3A5C81        ld   a,($815C)
373E  3D            dec  a
373F  3D            dec  a
3740  3D            dec  a
3741  325C81        ld   ($815C),a
3744  C9            ret
3745  FF            rst  $38
3746  FF            rst  $38
3747  FF            rst  $38
3748  FF            rst  $38
3749  FF            rst  $38
374A  FF            rst  $38
374B  FF            rst  $38
374C  FF            rst  $38
374D  FF            rst  $38
374E  FF            rst  $38
374F  FF            rst  $38
3750  FF            rst  $38
3751  FF            rst  $38
3752  FF            rst  $38
3753  FF            rst  $38
3754  FF            rst  $38
3755  FF            rst  $38
3756  FF            rst  $38
3757  FF            rst  $38
3758  FF            rst  $38
3759  FF            rst  $38
375A  FF            rst  $38
375B  FF            rst  $38
375C  FF            rst  $38
375D  FF            rst  $38
375E  FF            rst  $38
375F  FF            rst  $38
3760  CD1037        call $3710
3763  CD3037        call $3730
3766  CD9837        call $3798
3769  CDB837        call $37B8
376C  C9            ret
376D  FF            rst  $38
376E  FF            rst  $38
376F  FF            rst  $38
3770  FF            rst  $38
3771  FF            rst  $38
3772  FF            rst  $38
3773  FF            rst  $38
3774  FF            rst  $38
3775  FF            rst  $38
3776  FF            rst  $38
3777  FF            rst  $38
3778  3EF0          ld   a,$F0
377A  325881        ld   ($8158),a
377D  3E22          ld   a,$22
377F  325981        ld   ($8159),a
3782  3E17          ld   a,$17
3784  325A81        ld   ($815A),a
3787  3E50          ld   a,$50
3789  325B81        ld   ($815B),a
378C  3E01          ld   a,$01
378E  323980        ld   ($8039),a
3791  C9            ret
3792  FF            rst  $38
3793  FF            rst  $38
3794  FF            rst  $38
3795  FF            rst  $38
3796  FF            rst  $38
3797  FF            rst  $38
3798  3A5881        ld   a,($8158)
379B  A7            and  a
379C  280F          jr   z,$37AD
379E  FE01          cp   $01
37A0  280B          jr   z,$37AD
37A2  FE02          cp   $02
37A4  2807          jr   z,$37AD
37A6  FE03          cp   $03
37A8  2803          jr   z,$37AD
37AA  FE04          cp   $04
37AC  C0            ret  nz
37AD  CD7837        call $3778
37B0  C9            ret
37B1  FF            rst  $38
37B2  FF            rst  $38
37B3  FF            rst  $38
37B4  FF            rst  $38
37B5  FF            rst  $38
37B6  FF            rst  $38
37B7  FF            rst  $38
37B8  3A1583        ld   a,($8315)
37BB  E601          and  $01
37BD  C8            ret  z
37BE  3A3980        ld   a,($8039)
37C1  A7            and  a
37C2  C8            ret  z
37C3  3A5881        ld   a,($8158)
37C6  3D            dec  a
37C7  3D            dec  a
37C8  3D            dec  a
37C9  3D            dec  a
37CA  325881        ld   ($8158),a
37CD  C9            ret
37CE  FF            rst  $38
37CF  FF            rst  $38
37D0  FF            rst  $38
37D1  FF            rst  $38
37D2  FF            rst  $38
37D3  FF            rst  $38
37D4  FF            rst  $38
37D5  FF            rst  $38
37D6  FF            rst  $38
37D7  FF            rst  $38
37D8  FF            rst  $38
37D9  FF            rst  $38
37DA  FF            rst  $38
37DB  FF            rst  $38
37DC  FF            rst  $38
37DD  FF            rst  $38
37DE  FF            rst  $38
37DF  FF            rst  $38
37E0  FF            rst  $38
37E1  FF            rst  $38
37E2  FF            rst  $38
37E3  FF            rst  $38
37E4  FF            rst  $38
37E5  FF            rst  $38
37E6  FF            rst  $38
37E7  FF            rst  $38
37E8  CD1037        call $3710
37EB  CD3037        call $3730
37EE  CD9837        call $3798
37F1  CDB837        call $37B8
37F4  CDB833        call $33B8
37F7  CD8834        call $3488
37FA  C9            ret
37FB  FF            rst  $38
37FC  FF            rst  $38
37FD  FF            rst  $38
37FE  FF            rst  $38
37FF  FF            rst  $38
3800  FF            rst  $38
3801  FF            rst  $38
3802  FF            rst  $38
3803  FF            rst  $38
3804  FF            rst  $38
3805  FF            rst  $38
3806  FF            rst  $38
3807  FF            rst  $38
3808  CD7833        call $3378
380B  CD6032        call $3260
380E  CD4038        call $3840
3811  CD1036        call $3610
3814  C9            ret
3815  FF            rst  $38
3816  FF            rst  $38
3817  FF            rst  $38
3818  FF            rst  $38
3819  FF            rst  $38
381A  FF            rst  $38
381B  FF            rst  $38
381C  FF            rst  $38
381D  FF            rst  $38
381E  FF            rst  $38
381F  FF            rst  $38
3820  3E10          ld   a,$10
3822  325C81        ld   ($815C),a
3825  3E23          ld   a,$23
3827  325D81        ld   ($815D),a
382A  3E16          ld   a,$16
382C  325E81        ld   ($815E),a
382F  3E60          ld   a,$60
3831  325F81        ld   ($815F),a
3834  3E01          ld   a,$01
3836  324180        ld   ($8041),a
3839  C9            ret
383A  FF            rst  $38
383B  FF            rst  $38
383C  FF            rst  $38
383D  FF            rst  $38
383E  FF            rst  $38
383F  FF            rst  $38
3840  3A5C81        ld   a,($815C)
3843  A7            and  a
3844  280F          jr   z,$3855
3846  FE01          cp   $01
3848  280B          jr   z,$3855
384A  FE02          cp   $02
384C  2807          jr   z,$3855
384E  FE03          cp   $03
3850  2803          jr   z,$3855
3852  FE04          cp   $04
3854  C0            ret  nz
3855  CD2038        call $3820
3858  C9            ret
3859  FF            rst  $38
385A  FF            rst  $38
385B  FF            rst  $38
385C  FF            rst  $38
385D  FF            rst  $38
385E  FF            rst  $38
385F  FF            rst  $38
3860  FF            rst  $38
3861  FF            rst  $38
3862  FF            rst  $38
3863  FF            rst  $38
3864  FF            rst  $38
3865  FF            rst  $38
3866  FF            rst  $38
3867  FF            rst  $38
3868  CD8834        call $3488
386B  CDB833        call $33B8
386E  CDA836        call $36A8
3871  CD1036        call $3610
3874  CD3832        call $3238
3877  CD6032        call $3260
387A  C9            ret
387B  FF            rst  $38
387C  FF            rst  $38
387D  FF            rst  $38
387E  FF            rst  $38
387F  FF            rst  $38
3880  FF            rst  $38
3881  FF            rst  $38
3882  FF            rst  $38
3883  FF            rst  $38
3884  FF            rst  $38
3885  FF            rst  $38
3886  FF            rst  $38
3887  FF            rst  $38
3888  CD7833        call $3378
388B  CD6032        call $3260
388E  CD4038        call $3840
3891  CD1036        call $3610
3894  CDC038        call $38C0
3897  CDD038        call $38D0
389A  C9            ret
389B  FF            rst  $38
389C  FF            rst  $38
389D  FF            rst  $38
389E  FF            rst  $38
389F  FF            rst  $38
38A0  3E60          ld   a,$60
38A2  325781        ld   ($8157),a
38A5  3EA3          ld   a,$A3
38A7  325581        ld   ($8155),a
38AA  3E16          ld   a,$16
38AC  325681        ld   ($8156),a
38AF  3E01          ld   a,$01
38B1  323B80        ld   ($803B),a
38B4  C9            ret
38B5  FF            rst  $38
38B6  FF            rst  $38
38B7  FF            rst  $38
38B8  FF            rst  $38
38B9  FF            rst  $38
38BA  FF            rst  $38
38BB  FF            rst  $38
38BC  FF            rst  $38
38BD  FF            rst  $38
38BE  FF            rst  $38
38BF  FF            rst  $38
38C0  CDA038        call $38A0
38C3  C9            ret
38C4  FF            rst  $38
38C5  FF            rst  $38
38C6  FF            rst  $38
38C7  FF            rst  $38
38C8  FF            rst  $38
38C9  FF            rst  $38
38CA  FF            rst  $38
38CB  FF            rst  $38
38CC  FF            rst  $38
38CD  FF            rst  $38
38CE  FF            rst  $38
38CF  FF            rst  $38
38D0  3A5C81        ld   a,($815C)
38D3  D650          sub  $50
38D5  325481        ld   ($8154),a
38D8  3A5D81        ld   a,($815D)
38DB  325581        ld   ($8155),a
38DE  C9            ret
38DF  FF            rst  $38
38E0  CD1003        call draw_tiles_h
38E3  0A            ld   a,(bc)
38E4  00            nop
38E5  E0            ret  po
38E6  DCDDDE        call c,$DEDD
38E9  DF            rst  $18
38EA  FF            rst  $38
38EB  CD1003        call draw_tiles_h
38EE  0B            dec  bc
38EF  00            nop
38F0  E1            pop  hl
38F1  FF            rst  $38
38F2  CD1003        call draw_tiles_h
38F5  0B            dec  bc
38F6  04            inc  b
38F7  E6FF          and  $FF
38F9  CD1003        call draw_tiles_h
38FC  0C            inc  c
38FD  00            nop
38FE  E1            pop  hl
38FF  FF            rst  $38
3900  CD1003        call draw_tiles_h
3903  0C            inc  c
3904  04            inc  b
3905  E6FF          and  $FF
3907  CD1003        call draw_tiles_h
390A  0D            dec  c
390B  00            nop
390C  E2E3E3        jp   po,$E3E3
390F  E3            ex   (sp),hl
3910  E4FFC9        call po,$C9FF
3913  FF            rst  $38
3914  FF            rst  $38
3915  FF            rst  $38
3916  FF            rst  $38
3917  FF            rst  $38
3918  CDB839        call $39B8
391B  CDE839        call $39E8
391E  C9            ret
391F  FF            rst  $38
3920  FF            rst  $38
3921  FF            rst  $38
3922  FF            rst  $38
3923  FF            rst  $38
3924  FF            rst  $38
3925  FF            rst  $38
3926  FF            rst  $38
3927  FF            rst  $38
3928  FF            rst  $38
3929  FF            rst  $38
392A  FF            rst  $38
392B  FF            rst  $38
392C  FF            rst  $38
392D  FF            rst  $38
392E  FF            rst  $38
392F  FF            rst  $38
3930  FF            rst  $38
3931  FF            rst  $38
3932  FF            rst  $38
3933  FF            rst  $38
3934  FF            rst  $38
3935  FF            rst  $38
3936  FF            rst  $38
3937  FF            rst  $38
3938  3A5481        ld   a,($8154)
393B  A7            and  a
393C  C0            ret  nz
393D  3EF0          ld   a,$F0
393F  325481        ld   ($8154),a
3942  3E22          ld   a,$22
3944  325581        ld   ($8155),a
3947  3E17          ld   a,$17
3949  325681        ld   ($8156),a
394C  3EC8          ld   a,$C8
394E  325781        ld   ($8157),a
3951  3E01          ld   a,$01
3953  323780        ld   ($8037),a
3956  C9            ret
3957  FF            rst  $38
3958  FF            rst  $38
3959  FF            rst  $38
395A  FF            rst  $38
395B  FF            rst  $38
395C  FF            rst  $38
395D  FF            rst  $38
395E  FF            rst  $38
395F  FF            rst  $38
3960  3A5881        ld   a,($8158)
3963  A7            and  a
3964  C0            ret  nz
3965  3EF0          ld   a,$F0
3967  325881        ld   ($8158),a
396A  3E22          ld   a,$22
396C  325981        ld   ($8159),a
396F  3E17          ld   a,$17
3971  325A81        ld   ($815A),a
3974  3E98          ld   a,$98
3976  325B81        ld   ($815B),a
3979  3E01          ld   a,$01
397B  323980        ld   ($8039),a
397E  C9            ret
397F  FF            rst  $38
3980  FF            rst  $38
3981  FF            rst  $38
3982  FF            rst  $38
3983  FF            rst  $38
3984  FF            rst  $38
3985  FF            rst  $38
3986  FF            rst  $38
3987  FF            rst  $38
3988  3A5C81        ld   a,($815C)
398B  A7            and  a
398C  C0            ret  nz
398D  3EF0          ld   a,$F0
398F  325C81        ld   ($815C),a
3992  3E22          ld   a,$22
3994  325D81        ld   ($815D),a
3997  3E17          ld   a,$17
3999  325E81        ld   ($815E),a
399C  3E68          ld   a,$68
399E  325F81        ld   ($815F),a
39A1  3E01          ld   a,$01
39A3  323B80        ld   ($803B),a
39A6  C9            ret
39A7  FF            rst  $38
39A8  FF            rst  $38
39A9  FF            rst  $38
39AA  FF            rst  $38
39AB  FF            rst  $38
39AC  FF            rst  $38
39AD  FF            rst  $38
39AE  FF            rst  $38
39AF  FF            rst  $38
39B0  3A0780        ld   a,($8007)
39B3  323680        ld   ($8036),a
39B6  C9            ret
39B7  FF            rst  $38
39B8  3A5481        ld   a,($8154)
39BB  FE80          cp   $80
39BD  2814          jr   z,$39D3
39BF  FE81          cp   $81
39C1  2810          jr   z,$39D3
39C3  FE82          cp   $82
39C5  280C          jr   z,$39D3
39C7  FE83          cp   $83
39C9  2808          jr   z,$39D3
39CB  FE84          cp   $84
39CD  2804          jr   z,$39D3
39CF  FE00          cp   $00
39D1  2003          jr   nz,$39D6
39D3  CD3839        call $3938
39D6  C3C011        jp   $11C0
39D9  FF            rst  $38
39DA  FF            rst  $38
39DB  FF            rst  $38
39DC  FF            rst  $38
39DD  FF            rst  $38
39DE  FF            rst  $38
39DF  FF            rst  $38
39E0  FF            rst  $38
39E1  FF            rst  $38
39E2  FF            rst  $38
39E3  FF            rst  $38
39E4  FF            rst  $38
39E5  FF            rst  $38
39E6  FF            rst  $38
39E7  FF            rst  $38
39E8  3A1583        ld   a,($8315)
39EB  E607          and  $07
39ED  C0            ret  nz
39EE  3A3780        ld   a,($8037)
39F1  A7            and  a
39F2  2819          jr   z,$3A0D
39F4  3C            inc  a
39F5  FE40          cp   $40
39F7  2009          jr   nz,$3A02
39F9  AF            xor  a
39FA  323780        ld   ($8037),a
39FD  325481        ld   ($8154),a
3A00  180B          jr   $3A0D
3A02  323780        ld   ($8037),a
3A05  3A5481        ld   a,($8154)
3A08  D602          sub  $02
3A0A  325481        ld   ($8154),a
3A0D  3A3980        ld   a,($8039)
3A10  A7            and  a
3A11  2819          jr   z,$3A2C
3A13  3C            inc  a
3A14  FE40          cp   $40
3A16  2009          jr   nz,$3A21
3A18  AF            xor  a
3A19  323980        ld   ($8039),a
3A1C  325881        ld   ($8158),a
3A1F  180B          jr   $3A2C
3A21  323980        ld   ($8039),a
3A24  3A5881        ld   a,($8158)
3A27  D603          sub  $03
3A29  325881        ld   ($8158),a
3A2C  3A3B80        ld   a,($803B)
3A2F  A7            and  a
3A30  C8            ret  z
3A31  3C            inc  a
3A32  FE40          cp   $40
3A34  2008          jr   nz,$3A3E
3A36  AF            xor  a
3A37  323B80        ld   ($803B),a
3A3A  325C81        ld   ($815C),a
3A3D  C9            ret
3A3E  323B80        ld   ($803B),a
3A41  3A5C81        ld   a,($815C)
3A44  D604          sub  $04
3A46  325C81        ld   ($815C),a
3A49  C9            ret
3A4A  FF            rst  $38
3A4B  FF            rst  $38
3A4C  FF            rst  $38
3A4D  FF            rst  $38
3A4E  FF            rst  $38
3A4F  FF            rst  $38
3A50  3A3780        ld   a,($8037)
3A53  A7            and  a
3A54  C8            ret  z
3A55  3C            inc  a
3A56  FE3A          cp   $3A
3A58  2008          jr   nz,$3A62
3A5A  AF            xor  a
3A5B  325481        ld   ($8154),a
3A5E  323780        ld   ($8037),a
3A61  C9            ret
3A62  323780        ld   ($8037),a
3A65  3A5781        ld   a,($8157)
3A68  3D            dec  a
3A69  3D            dec  a
3A6A  3D            dec  a
3A6B  325781        ld   ($8157),a
3A6E  3A1283        ld   a,($8312)
3A71  E603          and  $03
3A73  C0            ret  nz
3A74  3A5581        ld   a,($8155)
3A77  FE36          cp   $36
3A79  2006          jr   nz,$3A81
3A7B  3E37          ld   a,$37
3A7D  325581        ld   ($8155),a
3A80  C9            ret
3A81  3E36          ld   a,$36
3A83  325581        ld   ($8155),a
3A86  C9            ret
3A87  FF            rst  $38
3A88  3A3980        ld   a,($8039)
3A8B  A7            and  a
3A8C  C8            ret  z
3A8D  3C            inc  a
3A8E  FE3A          cp   $3A
3A90  2008          jr   nz,$3A9A
3A92  AF            xor  a
3A93  325881        ld   ($8158),a
3A96  323980        ld   ($8039),a
3A99  C9            ret
3A9A  323980        ld   ($8039),a
3A9D  3A5B81        ld   a,($815B)
3AA0  3D            dec  a
3AA1  3D            dec  a
3AA2  3D            dec  a
3AA3  325B81        ld   ($815B),a
3AA6  3A1283        ld   a,($8312)
3AA9  E603          and  $03
3AAB  C0            ret  nz
3AAC  3A5981        ld   a,($8159)
3AAF  FE36          cp   $36
3AB1  2006          jr   nz,$3AB9
3AB3  3E37          ld   a,$37
3AB5  325981        ld   ($8159),a
3AB8  C9            ret
3AB9  3E36          ld   a,$36
3ABB  325981        ld   ($8159),a
3ABE  C9            ret
3ABF  FF            rst  $38
3AC0  3A3B80        ld   a,($803B)
3AC3  A7            and  a
3AC4  C8            ret  z
3AC5  3C            inc  a
3AC6  FE3A          cp   $3A
3AC8  2008          jr   nz,$3AD2
3ACA  AF            xor  a
3ACB  325C81        ld   ($815C),a
3ACE  323B80        ld   ($803B),a
3AD1  C9            ret
3AD2  323B80        ld   ($803B),a
3AD5  3A5F81        ld   a,($815F)
3AD8  3D            dec  a
3AD9  3D            dec  a
3ADA  3D            dec  a
3ADB  325F81        ld   ($815F),a
3ADE  3A1283        ld   a,($8312)
3AE1  E603          and  $03
3AE3  C0            ret  nz
3AE4  3A5D81        ld   a,($815D)
3AE7  FE36          cp   $36
3AE9  2006          jr   nz,$3AF1
3AEB  3E37          ld   a,$37
3AED  325D81        ld   ($815D),a
3AF0  C9            ret
3AF1  3E36          ld   a,$36
3AF3  325D81        ld   ($815D),a
3AF6  C9            ret
3AF7  FF            rst  $38
3AF8  215481        ld   hl,$8154
3AFB  3698          ld   (hl),$98
3AFD  23            inc  hl
3AFE  3636          ld   (hl),$36
3B00  23            inc  hl
3B01  3617          ld   (hl),$17
3B03  23            inc  hl
3B04  36C0          ld   (hl),$C0
3B06  23            inc  hl
3B07  3E01          ld   a,$01
3B09  323780        ld   ($8037),a
3B0C  C9            ret
3B0D  FF            rst  $38
3B0E  FF            rst  $38
3B0F  FF            rst  $38
3B10  215881        ld   hl,$8158
3B13  3690          ld   (hl),$90
3B15  23            inc  hl
3B16  3636          ld   (hl),$36
3B18  23            inc  hl
3B19  3617          ld   (hl),$17
3B1B  23            inc  hl
3B1C  36C0          ld   (hl),$C0
3B1E  23            inc  hl
3B1F  3E01          ld   a,$01
3B21  323980        ld   ($8039),a
3B24  C9            ret
3B25  FF            rst  $38
3B26  FF            rst  $38
3B27  FF            rst  $38
3B28  215C81        ld   hl,$815C
3B2B  3690          ld   (hl),$90
3B2D  23            inc  hl
3B2E  3636          ld   (hl),$36
3B30  23            inc  hl
3B31  3617          ld   (hl),$17
3B33  23            inc  hl
3B34  36C0          ld   (hl),$C0
3B36  23            inc  hl
3B37  3E01          ld   a,$01
3B39  323B80        ld   ($803B),a
3B3C  C9            ret
3B3D  FF            rst  $38
3B3E  FF            rst  $38
3B3F  FF            rst  $38
3B40  CD783B        call $3B78
3B43  3A3680        ld   a,($8036)
3B46  3C            inc  a
3B47  FE60          cp   $60
3B49  2001          jr   nz,$3B4C
3B4B  AF            xor  a
3B4C  323680        ld   ($8036),a
3B4F  FE08          cp   $08
3B51  2004          jr   nz,$3B57
3B53  CDF83A        call $3AF8
3B56  C9            ret
3B57  FE30          cp   $30
3B59  2004          jr   nz,$3B5F
3B5B  CD103B        call $3B10
3B5E  C9            ret
3B5F  FE40          cp   $40
3B61  C0            ret  nz
3B62  CD283B        call $3B28
3B65  C9            ret
3B66  FF            rst  $38
3B67  FF            rst  $38
3B68  CD403B        call $3B40
3B6B  CDE014        call $14E0
3B6E  00            nop
3B6F  00            nop
3B70  00            nop
3B71  00            nop
3B72  00            nop
3B73  00            nop
3B74  C9            ret
3B75  FF            rst  $38
3B76  FF            rst  $38
3B77  FF            rst  $38
3B78  3A1583        ld   a,($8315)
3B7B  E603          and  $03
3B7D  C8            ret  z
3B7E  E1            pop  hl
3B7F  C9            ret
3B80  FD7E00        ld   a,(iy+$00)
3B83  DD9600        sub  (ix+$00)
3B86  37            scf
3B87  3F            ccf
3B88  D60C          sub  $0C
3B8A  3803          jr   c,$3B8F
3B8C  C618          add  a,$18
3B8E  D0            ret  nc
3B8F  DD7E03        ld   a,(ix+$03)
3B92  FD9603        sub  (iy+$03)
3B95  37            scf
3B96  3F            ccf
3B97  D60A          sub  $0A
3B99  3803          jr   c,$3B9E
3B9B  C621          add  a,$21
3B9D  D0            ret  nc
3B9E  CD330A        call $0A33
3BA1  C9            ret
3BA2  FF            rst  $38
3BA3  FF            rst  $38
3BA4  FF            rst  $38
3BA5  FF            rst  $38
3BA6  FF            rst  $38
3BA7  FF            rst  $38
3BA8  FD215481      ld   iy,$8154
3BAC  DD214081      ld   ix,$8140
3BB0  CD803B        call $3B80
3BB3  FD215881      ld   iy,$8158
3BB7  CD803B        call $3B80
3BBA  FD215C81      ld   iy,$815C
3BBE  CD803B        call $3B80
3BC1  C9            ret
3BC2  FF            rst  $38
3BC3  FF            rst  $38
3BC4  FF            rst  $38
3BC5  FF            rst  $38
3BC6  FF            rst  $38
3BC7  FF            rst  $38
3BC8  210881        ld   hl,$8108
3BCB  3A0681        ld   a,($8106)
3BCE  77            ld   (hl),a
3BCF  23            inc  hl
3BD0  23            inc  hl
3BD1  7D            ld   a,l
3BD2  FE40          cp   $40
3BD4  20F5          jr   nz,$3BCB
3BD6  C9            ret
3BD7  FF            rst  $38
3BD8  DDE1          pop  ix
3BDA  2600          ld   h,$00
3BDC  DD6E00        ld   l,(ix+$00)
3BDF  29            add  hl,hl
3BE0  29            add  hl,hl
3BE1  29            add  hl,hl
3BE2  29            add  hl,hl
3BE3  29            add  hl,hl
3BE4  DD23          inc  ix
3BE6  DD7E00        ld   a,(ix+$00)
3BE9  85            add  a,l
3BEA  6F            ld   l,a
3BEB  014090        ld   bc,$9040
3BEE  09            add  hl,bc
3BEF  DD23          inc  ix
3BF1  DD7E00        ld   a,(ix+$00)
3BF4  FEFF          cp   $FF
3BF6  2804          jr   z,$3BFC
3BF8  77            ld   (hl),a
3BF9  23            inc  hl
3BFA  18F3          jr   $3BEF
3BFC  DD23          inc  ix
3BFE  DDE5          push ix
3C00  C9            ret
3C01  FF            rst  $38
3C02  3A0480        ld   a,($8004)
3C05  A7            and  a
3C06  2005          jr   nz,$3C0D
3C08  3A2980        ld   a,($8029)
3C0B  1803          jr   $3C10
3C0D  3A2A80        ld   a,($802A)
3C10  FE01          cp   $01
3C12  2821          jr   z,$3C35
3C14  FE02          cp   $02
3C16  281D          jr   z,$3C35
3C18  FE04          cp   $04
3C1A  2819          jr   z,$3C35
3C1C  FE08          cp   $08
3C1E  2815          jr   z,$3C35
3C20  FE0D          cp   $0D
3C22  2811          jr   z,$3C35
3C24  FE0F          cp   $0F
3C26  280D          jr   z,$3C35
3C28  FE12          cp   $12
3C2A  2809          jr   z,$3C35
3C2C  FE15          cp   $15
3C2E  2848          jr   z,$3C78
3C30  FE18          cp   $18
3C32  2844          jr   z,$3C78
3C34  C9            ret
3C35  3A4B80        ld   a,($804B)
3C38  3C            inc  a
3C39  FE04          cp   $04
3C3B  2001          jr   nz,$3C3E
3C3D  AF            xor  a
3C3E  324B80        ld   ($804B),a
3C41  A7            and  a
3C42  200B          jr   nz,$3C4F
3C44  CD1003        call draw_tiles_h
3C47  1D            dec  e
3C48  0E80          ld   c,$80
3C4A  80            add  a,b
3C4B  80            add  a,b
3C4C  80            add  a,b
3C4D  FF            rst  $38
3C4E  C9            ret
3C4F  FE01          cp   $01
3C51  200B          jr   nz,$3C5E
3C53  CD1003        call draw_tiles_h
3C56  1D            dec  e
3C57  0E85          ld   c,$85
3C59  81            add  a,c
3C5A  87            add  a,a
3C5B  81            add  a,c
3C5C  FF            rst  $38
3C5D  C9            ret
3C5E  FE02          cp   $02
3C60  200B          jr   nz,$3C6D
3C62  CD1003        call draw_tiles_h
3C65  1D            dec  e
3C66  0E86          ld   c,$86
3C68  82            add  a,d
3C69  88            adc  a,b
3C6A  80            add  a,b
3C6B  FF            rst  $38
3C6C  C9            ret
3C6D  CD1003        call draw_tiles_h
3C70  1D            dec  e
3C71  0E85          ld   c,$85
3C73  83            add  a,e
3C74  87            add  a,a
3C75  82            add  a,d
3C76  FF            rst  $38
3C77  C9            ret
3C78  3A4B80        ld   a,($804B)
3C7B  3C            inc  a
3C7C  FE04          cp   $04
3C7E  2001          jr   nz,$3C81
3C80  AF            xor  a
3C81  324B80        ld   ($804B),a
3C84  A7            and  a
3C85  200C          jr   nz,$3C93
3C87  CD1003        call draw_tiles_h
3C8A  19            add  hl,de
3C8B  0F            rrca
3C8C  80            add  a,b
3C8D  80            add  a,b
3C8E  80            add  a,b
3C8F  80            add  a,b
3C90  80            add  a,b
3C91  FF            rst  $38
3C92  C9            ret
3C93  FE01          cp   $01
3C95  200C          jr   nz,$3CA3
3C97  CD1003        call draw_tiles_h
3C9A  19            add  hl,de
3C9B  0F            rrca
3C9C  85            add  a,l
3C9D  81            add  a,c
3C9E  84            add  a,h
3C9F  81            add  a,c
3CA0  87            add  a,a
3CA1  FF            rst  $38
3CA2  C9            ret
3CA3  FE02          cp   $02
3CA5  200C          jr   nz,$3CB3
3CA7  CD1003        call draw_tiles_h
3CAA  19            add  hl,de
3CAB  0F            rrca
3CAC  86            add  a,(hl)
3CAD  82            add  a,d
3CAE  88            adc  a,b
3CAF  86            add  a,(hl)
3CB0  82            add  a,d
3CB1  FF            rst  $38
3CB2  C9            ret
3CB3  CD1003        call draw_tiles_h
3CB6  19            add  hl,de
3CB7  0F            rrca
3CB8  85            add  a,l
3CB9  83            add  a,e
3CBA  80            add  a,b
3CBB  83            add  a,e
3CBC  87            add  a,a
3CBD  FF            rst  $38
3CBE  C9            ret
3CBF  FF            rst  $38
3CC0  80            add  a,b
3CC1  3A1170        ld   a,($7011)
3CC4  80            add  a,b
3CC5  3B            dec  sp
3CC6  118094        ld   de,$9480
3CC9  05            dec  b
3CCA  12            ld   (de),a
3CCB  80            add  a,b
3CCC  00            nop
3CCD  00            nop
3CCE  12            ld   (de),a
3CCF  80            add  a,b
3CD0  00            nop
3CD1  00            nop
3CD2  12            ld   (de),a
3CD3  80            add  a,b
3CD4  6C            ld   l,h
3CD5  00            nop
3CD6  12            ld   (de),a
3CD7  80            add  a,b
3CD8  A8            xor  b
3CD9  00            nop
3CDA  12            ld   (de),a
3CDB  80            add  a,b
3CDC  00            nop
3CDD  00            nop
3CDE  12            ld   (de),a
3CDF  80            add  a,b
3CE0  1E08          ld   e,$08
3CE2  E5            push hl
3CE3  D5            push de
3CE4  CDA013        call wait_vblank
3CE7  D1            pop  de
3CE8  E1            pop  hl
3CE9  1D            dec  e
3CEA  20F6          jr   nz,$3CE2
3CEC  C9            ret
3CED  FF            rst  $38
3CEE  FF            rst  $38
3CEF  FF            rst  $38
3CF0  FF            rst  $38
3CF1  FF            rst  $38
3CF2  FF            rst  $38
3CF3  FF            rst  $38
3CF4  FF            rst  $38
3CF5  FF            rst  $38
3CF6  FF            rst  $38
3CF7  FF            rst  $38
3CF8  FF            rst  $38
3CF9  FF            rst  $38
3CFA  FF            rst  $38
3CFB  FF            rst  $38
3CFC  FF            rst  $38
3CFD  FF            rst  $38
3CFE  FF            rst  $38
3CFF  FF            rst  $38
3D00  3C            inc  a
3D01  3D            dec  a
3D02  0601          ld   b,$01
3D04  3A3B05        ld   a,($053B)
3D07  00            nop
3D08  3C            inc  a
3D09  3D            dec  a
3D0A  0601          ld   b,$01
3D0C  3A3B07        ld   a,($073B)
3D0F  02            ld   (bc),a
3D10  3E3F          ld   a,$3F
3D12  08            ex   af,af'
3D13  03            inc  bc
3D14  3A3B07        ld   a,($073B)
3D17  02            ld   (bc),a
3D18  3E3F          ld   a,$3F
3D1A  08            ex   af,af'
3D1B  03            inc  bc
3D1C  3A3B05        ld   a,($053B)
3D1F  00            nop
3D20  7E            ld   a,(hl)
3D21  324181        ld   ($8141),a
3D24  23            inc  hl
3D25  7E            ld   a,(hl)
3D26  324581        ld   ($8145),a
3D29  23            inc  hl
3D2A  7E            ld   a,(hl)
3D2B  324981        ld   ($8149),a
3D2E  23            inc  hl
3D2F  7E            ld   a,(hl)
3D30  325181        ld   ($8151),a
3D33  325581        ld   ($8155),a
3D36  325981        ld   ($8159),a
3D39  23            inc  hl
3D3A  7D            ld   a,l
3D3B  E61F          and  $1F
3D3D  6F            ld   l,a
3D3E  C9            ret
3D3F  FF            rst  $38
3D40  FF            rst  $38
3D41  FF            rst  $38
3D42  FF            rst  $38
3D43  FF            rst  $38
3D44  FF            rst  $38
3D45  FF            rst  $38
3D46  FF            rst  $38
3D47  FF            rst  $38
3D48  3E06          ld   a,$06
3D4A  324280        ld   ($8042),a
3D4D  326580        ld   ($8065),a
3D50  CD7014        call reset_xoff_sprites_and_clear_screen
3D53  21E00F        ld   hl,$0FE0
3D56  CD4008        call $0840
3D59  00            nop
3D5A  00            nop
3D5B  CDA003        call $03A0
3D5E  CD5024        call $2450
3D61  214081        ld   hl,$8140
3D64  01C03C        ld   bc,$3CC0
3D67  1620          ld   d,$20
3D69  0A            ld   a,(bc)
3D6A  77            ld   (hl),a
3D6B  23            inc  hl
3D6C  03            inc  bc
3D6D  15            dec  d
3D6E  20F9          jr   nz,$3D69
3D70  CDA03D        call $3DA0
3D73  1680          ld   d,$80
3D75  AF            xor  a
3D76  322D80        ld   ($802D),a
3D79  21003D        ld   hl,$3D00
3D7C  CDE03C        call $3CE0
3D7F  CD203D        call $3D20
3D82  15            dec  d
3D83  20F7          jr   nz,$3D7C
3D85  CDB03E        call $3EB0
3D88  3A0480        ld   a,($8004)
3D8B  A7            and  a
3D8C  2008          jr   nz,$3D96
3D8E  3E01          ld   a,$01
3D90  322980        ld   ($8029),a
3D93  C30010        jp   $1000
3D96  3E01          ld   a,$01
3D98  322A80        ld   ($802A),a
3D9B  C30010        jp   $1000
3D9E  C9            ret
3D9F  FF            rst  $38
3DA0  211892        ld   hl,$9218
3DA3  3666          ld   (hl),$66
3DA5  23            inc  hl
3DA6  3667          ld   (hl),$67
3DA8  23            inc  hl
3DA9  366A          ld   (hl),$6A
3DAB  23            inc  hl
3DAC  366B          ld   (hl),$6B
3DAE  21F891        ld   hl,$91F8
3DB1  3664          ld   (hl),$64
3DB3  23            inc  hl
3DB4  3665          ld   (hl),$65
3DB6  23            inc  hl
3DB7  3668          ld   (hl),$68
3DB9  23            inc  hl
3DBA  3669          ld   (hl),$69
3DBC  21D891        ld   hl,$91D8
3DBF  366E          ld   (hl),$6E
3DC1  23            inc  hl
3DC2  366F          ld   (hl),$6F
3DC4  23            inc  hl
3DC5  366C          ld   (hl),$6C
3DC7  23            inc  hl
3DC8  366D          ld   (hl),$6D
3DCA  3E02          ld   a,$02
3DCC  323181        ld   ($8131),a
3DCF  323381        ld   ($8133),a
3DD2  323581        ld   ($8135),a
3DD5  323781        ld   ($8137),a
3DD8  CD1003        call draw_tiles_h
3DDB  1C            inc  e
3DDC  00            nop
3DDD  3839          jr   c,$3E18
3DDF  3A3938        ld   a,($3839)
3DE2  39            add  hl,sp
3DE3  3C            inc  a
3DE4  3D            dec  a
3DE5  39            add  hl,sp
3DE6  3A3838        ld   a,($3838)
3DE9  3C            inc  a
3DEA  3C            inc  a
3DEB  3D            dec  a
3DEC  3C            inc  a
3DED  39            add  hl,sp
3DEE  3A3839        ld   a,($3938)
3DF1  3839          jr   c,$3E2C
3DF3  3D            dec  a
3DF4  3C            inc  a
3DF5  39            add  hl,sp
3DF6  383A          jr   c,$3E32
3DF8  3D            dec  a
3DF9  3C            inc  a
3DFA  39            add  hl,sp
3DFB  39            add  hl,sp
3DFC  38FF          jr   c,$3DFD
3DFE  CD1003        call draw_tiles_h
3E01  12            ld   (de),a
3E02  00            nop
3E03  FEFD          cp   $FD
3E05  FD            db   $fd
3E06  FD            db   $fd
3E07  FD            db   $fd
3E08  FD            db   $fd
3E09  FD            db   $fd
3E0A  FD            db   $fd
3E0B  FD            db   $fd
3E0C  FD            db   $fd
3E0D  FD            db   $fd
3E0E  FD            db   $fd
3E0F  FD            db   $fd
3E10  FD            db   $fd
3E11  FD            db   $fd
3E12  FD            db   $fd
3E13  FD            db   $fd
3E14  FD            db   $fd
3E15  FD            db   $fd
3E16  FD            db   $fd
3E17  FD            db   $fd
3E18  FD            db   $fd
3E19  FD            db   $fd
3E1A  FD            db   $fd
3E1B  FD            db   $fd
3E1C  FD            db   $fd
3E1D  FD            db   $fd
3E1E  FCFFC9        call m,$C9FF
3E21  FF            rst  $38
3E22  3E0C          ld   a,$0C
3E24  324181        ld   ($8141),a
3E27  3E0D          ld   a,$0D
3E29  324581        ld   ($8145),a
3E2C  3E29          ld   a,$29
3E2E  322981        ld   ($8129),a
3E31  1E70          ld   e,$70
3E33  D5            push de
3E34  CDF03E        call $3EF0
3E37  CDE808        call $08E8
3E3A  CDE808        call $08E8
3E3D  CDA013        call wait_vblank
3E40  D1            pop  de
3E41  1D            dec  e
3E42  20EF          jr   nz,$3E33
3E44  C9            ret
3E45  FF            rst  $38
3E46  FF            rst  $38
3E47  FF            rst  $38
3E48  FF            rst  $38
3E49  FF            rst  $38
3E4A  FF            rst  $38
3E4B  FF            rst  $38
3E4C  FF            rst  $38
3E4D  FF            rst  $38
3E4E  FF            rst  $38
3E4F  FF            rst  $38
3E50  1E01          ld   e,$01
3E52  D5            push de
3E53  DDE5          push ix
3E55  CDA013        call wait_vblank
3E58  DDE1          pop  ix
3E5A  D1            pop  de
3E5B  1D            dec  e
3E5C  20F4          jr   nz,$3E52
3E5E  C9            ret
3E5F  FF            rst  $38
3E60  DD214081      ld   ix,$8140
3E64  CD503E        call $3E50
3E67  1608          ld   d,$08
3E69  DD3503        dec  (ix+$03)
3E6C  DD3507        dec  (ix+$07)
3E6F  DD350B        dec  (ix+$0b)
3E72  CD503E        call $3E50
3E75  15            dec  d
3E76  20F1          jr   nz,$3E69
3E78  1608          ld   d,$08
3E7A  DD3403        inc  (ix+$03)
3E7D  DD3407        inc  (ix+$07)
3E80  DD340B        inc  (ix+$0b)
3E83  CD503E        call $3E50
3E86  15            dec  d
3E87  20F1          jr   nz,$3E7A
3E89  C9            ret
3E8A  FF            rst  $38
3E8B  FF            rst  $38
3E8C  FF            rst  $38
3E8D  FF            rst  $38
3E8E  FF            rst  $38
3E8F  FF            rst  $38
3E90  FF            rst  $38
3E91  FF            rst  $38
3E92  FF            rst  $38
3E93  FF            rst  $38
3E94  FF            rst  $38
3E95  FF            rst  $38
3E96  FF            rst  $38
3E97  FF            rst  $38
3E98  FF            rst  $38
3E99  FF            rst  $38
3E9A  FF            rst  $38
3E9B  FF            rst  $38
3E9C  FF            rst  $38
3E9D  FF            rst  $38
3E9E  FF            rst  $38
3E9F  FF            rst  $38
3EA0  FF            rst  $38
3EA1  FF            rst  $38
3EA2  FF            rst  $38
3EA3  FF            rst  $38
3EA4  FF            rst  $38
3EA5  FF            rst  $38
3EA6  FF            rst  $38
3EA7  FF            rst  $38
3EA8  FF            rst  $38
3EA9  FF            rst  $38
3EAA  FF            rst  $38
3EAB  FF            rst  $38
3EAC  FF            rst  $38
3EAD  FF            rst  $38
3EAE  FF            rst  $38
3EAF  FF            rst  $38
3EB0  3E07          ld   a,$07
3EB2  324280        ld   ($8042),a
3EB5  215081        ld   hl,$8150
3EB8  3618          ld   (hl),$18
3EBA  23            inc  hl
3EBB  362E          ld   (hl),$2E
3EBD  23            inc  hl
3EBE  3612          ld   (hl),$12
3EC0  23            inc  hl
3EC1  3670          ld   (hl),$70
3EC3  215C81        ld   hl,$815C
3EC6  3611          ld   (hl),$11
3EC8  23            inc  hl
3EC9  3630          ld   (hl),$30
3ECB  23            inc  hl
3ECC  3612          ld   (hl),$12
3ECE  23            inc  hl
3ECF  3680          ld   (hl),$80
3ED1  CDE03C        call $3CE0
3ED4  CD603E        call $3E60
3ED7  CD603E        call $3E60
3EDA  CD603E        call $3E60
3EDD  80            add  a,b
3EDE  CD223E        call $3E22
3EE1  C9            ret
3EE2  FF            rst  $38
3EE3  FF            rst  $38
3EE4  FF            rst  $38
3EE5  FF            rst  $38
3EE6  FF            rst  $38
3EE7  FF            rst  $38
3EE8  FF            rst  $38
3EE9  FF            rst  $38
3EEA  FF            rst  $38
3EEB  FF            rst  $38
3EEC  FF            rst  $38
3EED  FF            rst  $38
3EEE  FF            rst  $38
3EEF  FF            rst  $38
3EF0  7B            ld   a,e
3EF1  E603          and  $03
3EF3  C0            ret  nz
3EF4  CD1806        call $0618
3EF7  C9            ret
3EF8  FF            rst  $38
3EF9  FF            rst  $38
3EFA  FF            rst  $38
3EFB  FF            rst  $38
3EFC  FF            rst  $38
3EFD  FF            rst  $38
3EFE  FF            rst  $38
3EFF  FF            rst  $38

                delay_83_call_weird_a:
3F00  CD6014        call $1460
3F03  21900E        ld   hl,$0E90
3F06  CDE301        call $01E3
3F09  C9            ret

3F0A  FF            rst  $38
3F0B  FF            rst  $38
3F0C  FF            rst  $38
3F0D  FF            rst  $38
3F0E  FF            rst  $38
3F0F  FF            rst  $38
3F10  CD1003        call draw_tiles_h
3F13  1F            rra
3F14  00            nop
3F15  C0            ret  nz
3F16  C1            pop  bc
3F17  C2C3C4        jp   nz,$C4C3
3F1A  C5            push bc
3F1B  C6C7          add  a,$C7
3F1D  C8            ret  z
3F1E  C9            ret
3F1F  CACBCC        jp   z,$CCCB
3F22  CDCECF        call $CFCE
3F25  D0            ret  nc
3F26  D1            pop  de
3F27  D2D3D4        jp   nc,$D4D3
3F2A  D5            push de
3F2B  D6D7          sub  $D7
3F2D  D8            ret  c
3F2E  D9            exx
3F2F  DAFF3A        jp   c,$3AFF
3F32  04            inc  b
3F33  80            add  a,b
3F34  A7            and  a
3F35  2005          jr   nz,$3F3C
3F37  3A2980        ld   a,($8029)
3F3A  1803          jr   $3F3F
3F3C  3A2A80        ld   a,($802A)
3F3F  21BF93        ld   hl,$93BF
3F42  CD553F        call $3F55
3F45  3D            dec  a
3F46  2808          jr   z,$3F50
3F48  36DB          ld   (hl),$DB
3F4A  01E0FF        ld   bc,$FFE0
3F4D  09            add  hl,bc
3F4E  18F2          jr   $3F42
3F50  CDD02A        call $2AD0
3F53  C9            ret
3F54  FF            rst  $38
3F55  F5            push af
3F56  E5            push hl
3F57  1E01          ld   e,$01
3F59  D5            push de
3F5A  CDA013        call wait_vblank
3F5D  D1            pop  de
3F5E  1D            dec  e
3F5F  20F8          jr   nz,$3F59
3F61  E1            pop  hl
3F62  F1            pop  af
3F63  C9            ret
3F64  FF            rst  $38
3F65  FF            rst  $38
3F66  CD1003        call draw_tiles_h
3F69  0C            inc  c
3F6A  0A            ld   a,(bc)
3F6B  1A            ld   a,(de)
3F6C  15            dec  d
3F6D  24            inc  h
3F6E  23            inc  hl
3F6F  1F            rra
3F70  1624          ld   d,$24
3F72  FF            rst  $38
3F73  C9            ret
3F74  CD1003        call draw_tiles_h
3F77  14            inc  d
3F78  07            rlca
3F79  2022          jr   nz,$3F9D
3F7B  1F            rra
3F7C  25            dec  h
3F7D  14            inc  d
3F7E  1C            inc  e
3F7F  29            add  hl,hl
3F80  1020          djnz $3FA2
3F82  221523        ld   ($2315),hl
3F85  15            dec  d
3F86  1E24          ld   e,$24
3F88  FF            rst  $38
3F89  C9            ret
3F8A  FF            rst  $38
3F8B  FF            rst  $38
3F8C  CD1003        call draw_tiles_h
3F8F  1004          djnz $3F95
3F91  8B            adc  a,e
3F92  010908        ld   bc,$0809
3F95  03            inc  bc
3F96  FF            rst  $38
3F97  CD1003        call draw_tiles_h
3F9A  12            ld   (de),a
3F9B  04            inc  b
3F9C  1A            ld   a,(de)
3F9D  15            dec  d
3F9E  24            inc  h
3F9F  23            inc  hl
3FA0  1F            rra
3FA1  1624          ld   d,$24
3FA3  FF            rst  $38
3FA4  C9            ret
3FA5  FF            rst  $38
3FA6  FF            rst  $38
3FA7  FF            rst  $38
3FA8  CD1003        call draw_tiles_h
3FAB  1F            rra
3FAC  00            nop
3FAD  1010          djnz $3FBF
3FAF  1010          djnz $3FC1
3FB1  1010          djnz $3FC3
3FB3  1010          djnz $3FC5
3FB5  1010          djnz $3FC7
3FB7  1010          djnz $3FC9
3FB9  1010          djnz $3FCB
3FBB  1010          djnz $3FCD
3FBD  1010          djnz $3FCF
3FBF  1010          djnz $3FD1
3FC1  1010          djnz $3FD3
3FC3  1010          djnz $3FD5
3FC5  1010          djnz $3FD7
3FC7  1010          djnz $3FD9
3FC9  FF            rst  $38
3FCA  C9            ret
3FCB  FF            rst  $38
3FCC  FF            rst  $38
3FCD  FF            rst  $38
3FCE  FF            rst  $38
3FCF  FF            rst  $38
3FD0  00            nop
3FD1  00            nop
3FD2  00            nop
3FD3  00            nop
3FD4  00            nop
3FD5  CDD017        call $17D0
3FD8  CDEC24        call $24EC
3FDB  CDE038        call $38E0
3FDE  CDEC24        call $24EC
3FE1  CDD017        call $17D0
3FE4  CDEC24        call $24EC
3FE7  CDE038        call $38E0
3FEA  CDEC24        call $24EC
3FED  CDD017        call $17D0
3FF0  CDEC24        call $24EC
3FF3  CDE038        call $38E0
3FF6  CDEC24        call $24EC
3FF9  C9            ret
3FFA  FF            rst  $38
3FFB  FF            rst  $38
3FFC  FF            rst  $38
3FFD  FF            rst  $38
3FFE  FF            rst  $38
3FFF  FF            rst  $38
4000  AF            xor  a
4001  3201B0        ld   (int_enable),a
4004  3A4040        ld   a,($4040)
4007  00            nop
4008  00            nop
4009  00            nop
400A  3EFF          ld   a,$FF
400C  3200B8        ld   (watchdog),a
400F  31F083        ld   sp,stack_loc
4012  3A4040        ld   a,($4040)
4015  00            nop
4016  00            nop
4017  00            nop
4018  CD0000        call $0000
401B  FF            rst  $38
401C  FF            rst  $38
401D  FF            rst  $38
401E  FF            rst  $38
401F  FF            rst  $38
4020  CD5040        call $4050
4023  CD5842        call $4258
4026  CDE042        call $42E0
4029  CD744D        call $4D74
402C  CD2050        call $5020
402F  C9            ret
4030  C9            ret
4031  FF            rst  $38
4032  FF            rst  $38
4033  FF            rst  $38
4034  FF            rst  $38
4035  FF            rst  $38
4036  FF            rst  $38
4037  FF            rst  $38
4038  2100C0        ld   hl,$C000
403B  CD815C        call $5C81
403E  C9            ret
403F  FF            rst  $38
4040  CD6845        call $4568
4043  3E8E          ld   a,$8E
4045  327A92        ld   ($927A),a
4048  C9            ret
4049  FF            rst  $38
404A  FF            rst  $38
404B  FF            rst  $38
404C  FF            rst  $38
404D  FF            rst  $38
404E  FF            rst  $38
404F  FF            rst  $38
4050  3A4081        ld   a,($8140)
4053  37            scf
4054  3F            ccf
4055  213080        ld   hl,$8030
4058  96            sub  (hl)
4059  D8            ret  c
405A  47            ld   b,a
405B  3A1D80        ld   a,($801D)
405E  80            add  a,b
405F  321D80        ld   ($801D),a
4062  3A4081        ld   a,($8140)
4065  323080        ld   ($8030),a
4068  C9            ret
4069  FF            rst  $38
406A  FF            rst  $38
406B  FF            rst  $38
406C  FF            rst  $38
406D  FF            rst  $38
406E  FF            rst  $38
406F  FF            rst  $38
4070  3E8C          ld   a,$8C
4072  328E91        ld   ($918E),a
4075  C9            ret
4076  FF            rst  $38
4077  FF            rst  $38
4078  3E8D          ld   a,$8D
407A  32D291        ld   ($91D2),a
407D  C9            ret
407E  FF            rst  $38
407F  FF            rst  $38
4080  DD7E05        ld   a,(ix+$05)
4083  A7            and  a
4084  2805          jr   z,$408B
4086  3D            dec  a
4087  DD7705        ld   (ix+$05),a
408A  C9            ret
408B  DD7E03        ld   a,(ix+$03)
408E  DD7705        ld   (ix+$05),a
4091  DD7E02        ld   a,(ix+$02)
4094  A7            and  a
4095  C8            ret  z
4096  3D            dec  a
4097  DD7702        ld   (ix+$02),a
409A  C600          add  a,$00
409C  6F            ld   l,a
409D  3E08          ld   a,$08
409F  D300          out  ($00),a
40A1  7D            ld   a,l
40A2  D301          out  ($01),a
40A4  00            nop
40A5  C9            ret
40A6  FF            rst  $38
40A7  45            ld   b,l
40A8  AF            xor  a
40A9  94            sub  h
40AA  E6F8          and  $F8
40AC  6F            ld   l,a
40AD  2600          ld   h,$00
40AF  29            add  hl,hl
40B0  29            add  hl,hl
40B1  3E90          ld   a,$90
40B3  84            add  a,h
40B4  67            ld   h,a
40B5  78            ld   a,b
40B6  CB3F          srl  a
40B8  CB3F          srl  a
40BA  CB3F          srl  a
40BC  85            add  a,l
40BD  6F            ld   l,a
40BE  C9            ret
40BF  FF            rst  $38
40C0  DD7E05        ld   a,(ix+$05)
40C3  A7            and  a
40C4  2805          jr   z,$40CB
40C6  3D            dec  a
40C7  DD7705        ld   (ix+$05),a
40CA  C9            ret
40CB  DD7E03        ld   a,(ix+$03)
40CE  DD7705        ld   (ix+$05),a
40D1  DD7E02        ld   a,(ix+$02)
40D4  A7            and  a
40D5  C8            ret  z
40D6  3D            dec  a
40D7  DD7702        ld   (ix+$02),a
40DA  C600          add  a,$00
40DC  6F            ld   l,a
40DD  3E09          ld   a,$09
40DF  D300          out  ($00),a
40E1  7D            ld   a,l
40E2  D301          out  ($01),a
40E4  00            nop
40E5  C9            ret
40E6  FF            rst  $38
40E7  FF            rst  $38
40E8  3E8F          ld   a,$8F
40EA  32EE92        ld   ($92EE),a
40ED  3E8E          ld   a,$8E
40EF  321792        ld   ($9217),a
40F2  C9            ret
40F3  FF            rst  $38
40F4  3E03          ld   a,$03
40F6  324480        ld   ($8044),a
40F9  218029        ld   hl,$2980
40FC  CD815C        call $5C81
40FF  C9            ret
4100  DD7E05        ld   a,(ix+$05)
4103  A7            and  a
4104  2805          jr   z,$410B
4106  3D            dec  a
4107  DD7705        ld   (ix+$05),a
410A  C9            ret
410B  DD7E03        ld   a,(ix+$03)
410E  DD7705        ld   (ix+$05),a
4111  DD7E02        ld   a,(ix+$02)
4114  A7            and  a
4115  C8            ret  z
4116  3D            dec  a
4117  DD7702        ld   (ix+$02),a
411A  C600          add  a,$00
411C  6F            ld   l,a
411D  3E0A          ld   a,$0A
411F  D300          out  ($00),a
4121  7D            ld   a,l
4122  D301          out  ($01),a
4124  00            nop
4125  C9            ret
4126  FF            rst  $38
4127  FF            rst  $38
4128  3E8C          ld   a,$8C
412A  321792        ld   ($9217),a
412D  3E8D          ld   a,$8D
412F  323192        ld   ($9231),a
4132  3E8F          ld   a,$8F
4134  322B92        ld   ($922B),a
4137  C9            ret
4138  FF            rst  $38
4139  FF            rst  $38
413A  FF            rst  $38
413B  FF            rst  $38
413C  FF            rst  $38
413D  FF            rst  $38
413E  FF            rst  $38
413F  FF            rst  $38
4140  DD7E00        ld   a,(ix+$00)
4143  A7            and  a
4144  C8            ret  z
4145  326680        ld   ($8066),a
4148  CB27          sla  a
414A  210044        ld   hl,$4400
414D  85            add  a,l
414E  6F            ld   l,a
414F  3E01          ld   a,$01
4151  D300          out  ($00),a
4153  7E            ld   a,(hl)
4154  D301          out  ($01),a
4156  23            inc  hl
4157  3E00          ld   a,$00
4159  D300          out  ($00),a
415B  7E            ld   a,(hl)
415C  D301          out  ($01),a
415E  3E08          ld   a,$08
4160  D300          out  ($00),a
4162  DD7E02        ld   a,(ix+$02)
4165  C600          add  a,$00
4167  D301          out  ($01),a
4169  DD7E03        ld   a,(ix+$03)
416C  DD7705        ld   (ix+$05),a
416F  C9            ret
4170  CD7745        call $4577
4173  3E8E          ld   a,$8E
4175  32AB92        ld   ($92AB),a
4178  C9            ret
4179  FF            rst  $38
417A  FF            rst  $38
417B  FF            rst  $38
417C  FF            rst  $38
417D  FF            rst  $38
417E  FF            rst  $38
417F  FF            rst  $38
4180  DD7E00        ld   a,(ix+$00)
4183  A7            and  a
4184  C8            ret  z
4185  326780        ld   ($8067),a
4188  CB27          sla  a
418A  210044        ld   hl,$4400
418D  85            add  a,l
418E  6F            ld   l,a
418F  3E03          ld   a,$03
4191  D300          out  ($00),a
4193  7E            ld   a,(hl)
4194  D301          out  ($01),a
4196  23            inc  hl
4197  3E02          ld   a,$02
4199  D300          out  ($00),a
419B  7E            ld   a,(hl)
419C  D301          out  ($01),a
419E  3E09          ld   a,$09
41A0  D300          out  ($00),a
41A2  DD7E02        ld   a,(ix+$02)
41A5  C600          add  a,$00
41A7  D301          out  ($01),a
41A9  DD7E03        ld   a,(ix+$03)
41AC  DD7705        ld   (ix+$05),a
41AF  C9            ret
41B0  47            ld   b,a
41B1  3A1D80        ld   a,($801D)
41B4  80            add  a,b
41B5  321D80        ld   ($801D),a
41B8  2B            dec  hl
41B9  2B            dec  hl
41BA  2B            dec  hl
41BB  2B            dec  hl
41BC  224C80        ld   ($804C),hl
41BF  7E            ld   a,(hl)
41C0  324E80        ld   ($804E),a
41C3  3E90          ld   a,$90
41C5  CB38          srl  b
41C7  CB38          srl  b
41C9  CB38          srl  b
41CB  CB38          srl  b
41CD  80            add  a,b
41CE  77            ld   (hl),a
41CF  11E0FF        ld   de,$FFE0
41D2  19            add  hl,de
41D3  7E            ld   a,(hl)
41D4  324F80        ld   ($804F),a
41D7  369B          ld   (hl),$9B
41D9  3E40          ld   a,$40
41DB  325080        ld   ($8050),a
41DE  C3F440        jp   $40F4
41E1  FF            rst  $38
41E2  FF            rst  $38
41E3  3A0041        ld   a,($4100)
41E6  01E301        ld   bc,$01E3
41E9  C5            push bc
41EA  E5            push hl
41EB  C9            ret
41EC  3E9C          ld   a,$9C
41EE  325A91        ld   ($915A),a
41F1  C9            ret
41F2  3E9D          ld   a,$9D
41F4  325A91        ld   ($915A),a
41F7  C9            ret
41F8  3E9D          ld   a,$9D
41FA  321A91        ld   ($911A),a
41FD  C9            ret
41FE  FF            rst  $38
41FF  FF            rst  $38
4200  DD21A082      ld   ix,$82A0
4204  DD7E04        ld   a,(ix+$04)
4207  A7            and  a
4208  2808          jr   z,$4212
420A  CD4041        call $4140
420D  DD360400      ld   (ix+$04),$00
4211  C9            ret
4212  CD8040        call $4080
4215  C9            ret
4216  3E9C          ld   a,$9C
4218  32B191        ld   ($91B1),a
421B  C9            ret
421C  FF            rst  $38
421D  FF            rst  $38
421E  FF            rst  $38
421F  FF            rst  $38
4220  DD21A882      ld   ix,$82A8
4224  DD7E04        ld   a,(ix+$04)
4227  A7            and  a
4228  2808          jr   z,$4232
422A  CD8041        call $4180
422D  DD360400      ld   (ix+$04),$00
4231  C9            ret
4232  CDC040        call $40C0
4235  C9            ret
4236  3E9C          ld   a,$9C
4238  328E91        ld   ($918E),a
423B  C9            ret
423C  FF            rst  $38
423D  FF            rst  $38
423E  FF            rst  $38
423F  FF            rst  $38
4240  DD21B082      ld   ix,$82B0
4244  DD7E04        ld   a,(ix+$04)
4247  A7            and  a
4248  2808          jr   z,$4252
424A  CDB042        call $42B0
424D  DD360400      ld   (ix+$04),$00
4251  C9            ret
4252  CD0041        call $4100
4255  C9            ret
4256  FF            rst  $38
4257  FF            rst  $38
4258  3A4081        ld   a,($8140)
425B  C604          add  a,$04
425D  67            ld   h,a
425E  3A4381        ld   a,($8143)
4261  C618          add  a,$18
4263  6F            ld   l,a
4264  CDA740        call $40A7
4267  7E            ld   a,(hl)
4268  FE10          cp   $10
426A  C8            ret  z
426B  FE8C          cp   $8C
426D  2008          jr   nz,$4277
426F  3E20          ld   a,$20
4271  3610          ld   (hl),$10
4273  CDB041        call $41B0
4276  C9            ret
4277  FE8D          cp   $8D
4279  2008          jr   nz,$4283
427B  3E40          ld   a,$40
427D  3610          ld   (hl),$10
427F  CDB041        call $41B0
4282  C9            ret
4283  FE8E          cp   $8E
4285  2008          jr   nz,$428F
4287  3E60          ld   a,$60
4289  3610          ld   (hl),$10
428B  CDB041        call $41B0
428E  C9            ret
428F  FE8F          cp   $8F
4291  C0            ret  nz
4292  3EA0          ld   a,$A0
4294  3610          ld   (hl),$10
4296  CDB041        call $41B0
4299  C9            ret
429A  3E9D          ld   a,$9D
429C  32D291        ld   ($91D2),a
429F  C9            ret
42A0  3E8E          ld   a,$8E
42A2  32CB90        ld   ($90CB),a
42A5  CD0236        call $3602
42A8  C9            ret
42A9  FF            rst  $38
42AA  FF            rst  $38
42AB  FF            rst  $38
42AC  FF            rst  $38
42AD  FF            rst  $38
42AE  FF            rst  $38
42AF  FF            rst  $38
42B0  DD7E00        ld   a,(ix+$00)
42B3  A7            and  a
42B4  C8            ret  z
42B5  326880        ld   ($8068),a
42B8  CB27          sla  a
42BA  210044        ld   hl,$4400
42BD  85            add  a,l
42BE  6F            ld   l,a
42BF  3E05          ld   a,$05
42C1  D300          out  ($00),a
42C3  7E            ld   a,(hl)
42C4  D301          out  ($01),a
42C6  23            inc  hl
42C7  3E04          ld   a,$04
42C9  D300          out  ($00),a
42CB  7E            ld   a,(hl)
42CC  D301          out  ($01),a
42CE  3E0A          ld   a,$0A
42D0  D300          out  ($00),a
42D2  DD7E02        ld   a,(ix+$02)
42D5  C600          add  a,$00
42D7  D301          out  ($01),a
42D9  DD7E03        ld   a,(ix+$03)
42DC  DD7705        ld   (ix+$05),a
42DF  C9            ret
42E0  3A5080        ld   a,($8050)
42E3  A7            and  a
42E4  C8            ret  z
42E5  3D            dec  a
42E6  325080        ld   ($8050),a
42E9  A7            and  a
42EA  C9            ret
42EB  2A4C80        ld   hl,($804C)
42EE  3E10          ld   a,$10
42F0  00            nop
42F1  77            ld   (hl),a
42F2  11E0FF        ld   de,$FFE0
42F5  19            add  hl,de
42F6  3E10          ld   a,$10
42F8  00            nop
42F9  77            ld   (hl),a
42FA  C9            ret
42FB  FF            rst  $38
42FC  FF            rst  $38
42FD  FF            rst  $38
42FE  FF            rst  $38
42FF  FF            rst  $38
4300  F0            ret  p
4301  70            ld   (hl),b
4302  B0            or   b
4303  30D0          jr   nc,$42D5
4305  50            ld   d,b
4306  90            sub  b
4307  10E0          djnz $42E9
4309  60            ld   h,b
430A  A0            and  b
430B  20C0          jr   nz,$42CD
430D  40            ld   b,b
430E  80            add  a,b
430F  00            nop
4310  FF            rst  $38
4311  FF            rst  $38
4312  CDF841        call $41F8
4315  3E9E          ld   a,$9E
4317  327A92        ld   ($927A),a
431A  C9            ret
431B  FF            rst  $38
431C  FF            rst  $38
431D  FF            rst  $38
431E  FF            rst  $38
431F  FF            rst  $38
4320  DD6E07        ld   l,(ix+$07)
4323  DD6608        ld   h,(ix+$08)
4326  7E            ld   a,(hl)
4327  FEFF          cp   $FF
4329  C8            ret  z
432A  DD8611        add  a,(ix+$11)
432D  FD21A082      ld   iy,$82A0
4331  FD7700        ld   (iy+$00),a
4334  23            inc  hl
4335  46            ld   b,(hl)
4336  DD7E0F        ld   a,(ix+$0f)
4339  4F            ld   c,a
433A  05            dec  b
433B  2803          jr   z,$4340
433D  81            add  a,c
433E  18FA          jr   $433A
4340  3D            dec  a
4341  DD7712        ld   (ix+$12),a
4344  CD0052        call $5200
4347  FD7702        ld   (iy+$02),a
434A  DD7E0E        ld   a,(ix+$0e)
434D  FD7703        ld   (iy+$03),a
4350  3E01          ld   a,$01
4352  FD7704        ld   (iy+$04),a
4355  C9            ret
4356  FF            rst  $38
4357  FF            rst  $38
4358  FF            rst  $38
4359  FF            rst  $38
435A  FF            rst  $38
435B  FF            rst  $38
435C  FF            rst  $38
435D  FF            rst  $38
435E  FF            rst  $38
435F  FF            rst  $38
4360  DD6E09        ld   l,(ix+$09)
4363  DD660A        ld   h,(ix+$0a)
4366  7E            ld   a,(hl)
4367  FEFF          cp   $FF
4369  C8            ret  z
436A  DD8611        add  a,(ix+$11)
436D  FD21A882      ld   iy,$82A8
4371  FD7700        ld   (iy+$00),a
4374  23            inc  hl
4375  46            ld   b,(hl)
4376  DD7E0F        ld   a,(ix+$0f)
4379  4F            ld   c,a
437A  05            dec  b
437B  2803          jr   z,$4380
437D  81            add  a,c
437E  18FA          jr   $437A
4380  3D            dec  a
4381  DD7713        ld   (ix+$13),a
4384  CD5052        call $5250
4387  FD7702        ld   (iy+$02),a
438A  DD7E0E        ld   a,(ix+$0e)
438D  FD7703        ld   (iy+$03),a
4390  3E01          ld   a,$01
4392  FD7704        ld   (iy+$04),a
4395  C9            ret
4396  CDA042        call $42A0
4399  3E9E          ld   a,$9E
439B  32AB92        ld   ($92AB),a
439E  C9            ret
439F  FF            rst  $38
43A0  DD6E0B        ld   l,(ix+$0b)
43A3  DD660C        ld   h,(ix+$0c)
43A6  7E            ld   a,(hl)
43A7  FEFF          cp   $FF
43A9  C8            ret  z
43AA  DD8611        add  a,(ix+$11)
43AD  23            inc  hl
43AE  FD21B082      ld   iy,$82B0
43B2  FD7700        ld   (iy+$00),a
43B5  46            ld   b,(hl)
43B6  DD7E0F        ld   a,(ix+$0f)
43B9  4F            ld   c,a
43BA  05            dec  b
43BB  2803          jr   z,$43C0
43BD  81            add  a,c
43BE  18FA          jr   $43BA
43C0  3D            dec  a
43C1  DD7714        ld   (ix+$14),a
43C4  CDA052        call $52A0
43C7  FD7702        ld   (iy+$02),a
43CA  DD7E0E        ld   a,(ix+$0e)
43CD  FD7703        ld   (iy+$03),a
43D0  3E01          ld   a,$01
43D2  FD7704        ld   (iy+$04),a
43D5  C9            ret
43D6  FF            rst  $38
43D7  FF            rst  $38
43D8  FF            rst  $38
43D9  FF            rst  $38
43DA  FF            rst  $38
43DB  FF            rst  $38
43DC  FF            rst  $38
43DD  FF            rst  $38
43DE  FF            rst  $38
43DF  FF            rst  $38
43E0  3E9F          ld   a,$9F
43E2  32EE92        ld   ($92EE),a
43E5  3E9E          ld   a,$9E
43E7  321792        ld   ($9217),a
43EA  C9            ret
43EB  FF            rst  $38
43EC  3E9C          ld   a,$9C
43EE  321792        ld   ($9217),a
43F1  3E9D          ld   a,$9D
43F3  323192        ld   ($9231),a
43F6  3E9F          ld   a,$9F
43F8  322B92        ld   ($922B),a
43FB  C9            ret
43FC  FF            rst  $38
43FD  FF            rst  $38
43FE  FF            rst  $38
43FF  FF            rst  $38
4400  03            inc  bc
4401  24            inc  h
4402  03            inc  bc
4403  F602          or   $02
4405  CC02A4        call z,$A402
4408  02            ld   (bc),a
4409  7E            ld   a,(hl)
440A  02            ld   (bc),a
440B  5A            ld   e,d
440C  02            ld   (bc),a
440D  3802          jr   c,$4411
440F  1802          jr   $4413
4411  FA01DE        jp   m,$DE01
4414  01C301        ld   bc,$01C3
4417  AA            xor  d
4418  019201        ld   bc,$0192
441B  7B            ld   a,e
441C  016601        ld   bc,$0166
441F  52            ld   d,d
4420  013F01        ld   bc,$013F
4423  2D            dec  l
4424  011C01        ld   bc,$011C
4427  0C            inc  c
4428  010000        ld   bc,$0000
442B  EF            rst  $28
442C  00            nop
442D  E200D5        jp   po,$D500
4430  00            nop
4431  C9            ret
4432  00            nop
4433  BE            cp   (hl)
4434  00            nop
4435  B3            or   e
4436  00            nop
4437  A9            xor  c
4438  00            nop
4439  A0            and  b
443A  00            nop
443B  96            sub  (hl)
443C  00            nop
443D  8E            adc  a,(hl)
443E  00            nop
443F  86            add  a,(hl)
4440  00            nop
4441  7F            ld   a,a
4442  00            nop
4443  78            ld   a,b
4444  00            nop
4445  71            ld   (hl),c
4446  00            nop
4447  6B            ld   l,e
4448  00            nop
4449  64            ld   h,h
444A  00            nop
444B  5F            ld   e,a
444C  00            nop
444D  59            ld   e,c
444E  00            nop
444F  54            ld   d,h
4450  00            nop
4451  50            ld   d,b
4452  00            nop
4453  4B            ld   c,e
4454  00            nop
4455  47            ld   b,a
4456  00            nop
4457  43            ld   b,e
4458  00            nop
4459  3F            ccf
445A  00            nop
445B  3C            inc  a
445C  00            nop
445D  3800          jr   c,$445F
445F  35            dec  (hl)
4460  00            nop
4461  32002F        ld   ($2F00),a
4464  00            nop
4465  2C            inc  l
4466  00            nop
4467  2A0028        ld   hl,($2800)
446A  00            nop
446B  25            dec  h
446C  00            nop
446D  23            inc  hl
446E  00            nop
446F  21001F        ld   hl,$1F00
4472  00            nop
4473  1E00          ld   e,$00
4475  00            nop
4476  010401        ld   bc,$0104
4479  07            rlca
447A  01FFFF        ld   bc,$FFFF
447D  FF            rst  $38
447E  FF            rst  $38
447F  FF            rst  $38
4480  FF            rst  $38
4481  FF            rst  $38
4482  FF            rst  $38
4483  FF            rst  $38
4484  3A0480        ld   a,($8004)
4487  A7            and  a
4488  2005          jr   nz,$448F
448A  3A2980        ld   a,($8029)
448D  1803          jr   $4492
448F  3A2A80        ld   a,($802A)
4492  FE1B          cp   $1B
4494  C0            ret  nz
4495  3E74          ld   a,$74
4497  32A991        ld   ($91A9),a
449A  3C            inc  a
449B  32AA91        ld   ($91AA),a
449E  3C            inc  a
449F  32C991        ld   ($91C9),a
44A2  3C            inc  a
44A3  32CA91        ld   ($91CA),a
44A6  3C            inc  a
44A7  32AB91        ld   ($91AB),a
44AA  3C            inc  a
44AB  32AC91        ld   ($91AC),a
44AE  3C            inc  a
44AF  32CB91        ld   ($91CB),a
44B2  3C            inc  a
44B3  32CC91        ld   ($91CC),a
44B6  3C            inc  a
44B7  328B91        ld   ($918B),a
44BA  3C            inc  a
44BB  328C91        ld   ($918C),a
44BE  1824          jr   $44E4
44C0  1001          djnz $44C3
44C2  12            ld   (de),a
44C3  03            inc  bc
44C4  14            inc  d
44C5  011503        ld   bc,$0315
44C8  17            rla
44C9  011903        ld   bc,$0319
44CC  1B            dec  de
44CD  011C03        ld   bc,$031C
44D0  FF            rst  $38
44D1  FF            rst  $38
44D2  1C            inc  e
44D3  010003        ld   bc,$0300
44D6  1C            inc  e
44D7  010003        ld   bc,$0300
44DA  1C            inc  e
44DB  010003        ld   bc,$0300
44DE  1C            inc  e
44DF  010003        ld   bc,$0300
44E2  FF            rst  $38
44E3  FF            rst  $38
44E4  3C            inc  a
44E5  328991        ld   ($9189),a
44E8  3C            inc  a
44E9  328A91        ld   ($918A),a
44EC  C9            ret
44ED  FF            rst  $38
44EE  FF            rst  $38
44EF  FF            rst  $38
44F0  FF            rst  $38
44F1  FF            rst  $38
44F2  FF            rst  $38
44F3  FF            rst  $38
44F4  FF            rst  $38
44F5  FF            rst  $38
44F6  FF            rst  $38
44F7  FF            rst  $38
44F8  FF            rst  $38
44F9  FF            rst  $38
44FA  FF            rst  $38
44FB  FF            rst  $38
44FC  FF            rst  $38
44FD  FF            rst  $38
44FE  FF            rst  $38
44FF  FF            rst  $38
4500  DD7E12        ld   a,(ix+$12)
4503  A7            and  a
4504  2805          jr   z,$450B
4506  3D            dec  a
4507  DD7712        ld   (ix+$12),a
450A  C9            ret
450B  DD6E07        ld   l,(ix+$07)
450E  DD6608        ld   h,(ix+$08)
4511  23            inc  hl
4512  23            inc  hl
4513  7E            ld   a,(hl)
4514  FEFF          cp   $FF
4516  280A          jr   z,$4522
4518  DD7507        ld   (ix+$07),l
451B  DD7408        ld   (ix+$08),h
451E  CD2043        call $4320
4521  C9            ret
4522  DD6E01        ld   l,(ix+$01)
4525  DD6602        ld   h,(ix+$02)
4528  23            inc  hl
4529  23            inc  hl
452A  7E            ld   a,(hl)
452B  FEEE          cp   $EE
452D  2023          jr   nz,$4552
452F  23            inc  hl
4530  7E            ld   a,(hl)
4531  4F            ld   c,a
4532  0600          ld   b,$00
4534  37            scf
4535  3F            ccf
4536  ED42          sbc  hl,bc
4538  DD7501        ld   (ix+$01),l
453B  DD7402        ld   (ix+$02),h
453E  7E            ld   a,(hl)
453F  DD7707        ld   (ix+$07),a
4542  23            inc  hl
4543  7E            ld   a,(hl)
4544  DD7708        ld   (ix+$08),a
4547  DD6E07        ld   l,(ix+$07)
454A  DD6608        ld   h,(ix+$08)
454D  7E            ld   a,(hl)
454E  CD2043        call $4320
4551  C9            ret
4552  FEFF          cp   $FF
4554  C8            ret  z
4555  DD7501        ld   (ix+$01),l
4558  DD7402        ld   (ix+$02),h
455B  DD7707        ld   (ix+$07),a
455E  23            inc  hl
455F  7E            ld   a,(hl)
4560  DD7708        ld   (ix+$08),a
4563  CD2043        call $4320
4566  C9            ret
4567  FF            rst  $38
4568  3E8D          ld   a,$8D
456A  321A91        ld   ($911A),a
456D  C9            ret
456E  FF            rst  $38
456F  FF            rst  $38
4570  3E8C          ld   a,$8C
4572  32B191        ld   ($91B1),a
4575  C9            ret
4576  FF            rst  $38
4577  3E8E          ld   a,$8E
4579  32CB90        ld   ($90CB),a
457C  CD7040        call $4070
457F  C9            ret
4580  DD7E13        ld   a,(ix+$13)
4583  A7            and  a
4584  2805          jr   z,$458B
4586  3D            dec  a
4587  DD7713        ld   (ix+$13),a
458A  C9            ret
458B  DD6E09        ld   l,(ix+$09)
458E  DD660A        ld   h,(ix+$0a)
4591  23            inc  hl
4592  23            inc  hl
4593  7E            ld   a,(hl)
4594  FEFF          cp   $FF
4596  280A          jr   z,$45A2
4598  DD7509        ld   (ix+$09),l
459B  DD740A        ld   (ix+$0a),h
459E  CD6043        call $4360
45A1  C9            ret
45A2  DD6E03        ld   l,(ix+$03)
45A5  DD6604        ld   h,(ix+$04)
45A8  23            inc  hl
45A9  23            inc  hl
45AA  7E            ld   a,(hl)
45AB  FEEE          cp   $EE
45AD  2023          jr   nz,$45D2
45AF  23            inc  hl
45B0  7E            ld   a,(hl)
45B1  4F            ld   c,a
45B2  0600          ld   b,$00
45B4  37            scf
45B5  3F            ccf
45B6  ED42          sbc  hl,bc
45B8  DD7503        ld   (ix+$03),l
45BB  DD7404        ld   (ix+$04),h
45BE  7E            ld   a,(hl)
45BF  DD7709        ld   (ix+$09),a
45C2  23            inc  hl
45C3  7E            ld   a,(hl)
45C4  DD770A        ld   (ix+$0a),a
45C7  DD6E09        ld   l,(ix+$09)
45CA  DD660A        ld   h,(ix+$0a)
45CD  7E            ld   a,(hl)
45CE  CD6043        call $4360
45D1  C9            ret
45D2  FEFF          cp   $FF
45D4  C8            ret  z
45D5  DD7503        ld   (ix+$03),l
45D8  DD7404        ld   (ix+$04),h
45DB  DD7709        ld   (ix+$09),a
45DE  23            inc  hl
45DF  7E            ld   a,(hl)
45E0  DD770A        ld   (ix+$0a),a
45E3  CD6043        call $4360
45E6  C9            ret
45E7  FF            rst  $38
45E8  3E8D          ld   a,$8D
45EA  325A91        ld   ($915A),a
45ED  C9            ret
45EE  FF            rst  $38
45EF  FF            rst  $38
45F0  FF            rst  $38
45F1  FF            rst  $38
45F2  FF            rst  $38
45F3  FF            rst  $38
45F4  FF            rst  $38
45F5  FF            rst  $38
45F6  FF            rst  $38
45F7  FF            rst  $38
45F8  FF            rst  $38
45F9  FF            rst  $38
45FA  FF            rst  $38
45FB  FF            rst  $38
45FC  FF            rst  $38
45FD  FF            rst  $38
45FE  FF            rst  $38
45FF  FF            rst  $38
4600  DD7E14        ld   a,(ix+$14)
4603  A7            and  a
4604  2805          jr   z,$460B
4606  3D            dec  a
4607  DD7714        ld   (ix+$14),a
460A  C9            ret
460B  DD6E0B        ld   l,(ix+$0b)
460E  DD660C        ld   h,(ix+$0c)
4611  23            inc  hl
4612  23            inc  hl
4613  7E            ld   a,(hl)
4614  FEFF          cp   $FF
4616  280A          jr   z,$4622
4618  DD750B        ld   (ix+$0b),l
461B  DD740C        ld   (ix+$0c),h
461E  CDA043        call $43A0
4621  C9            ret
4622  DD6E05        ld   l,(ix+$05)
4625  DD6606        ld   h,(ix+$06)
4628  23            inc  hl
4629  23            inc  hl
462A  7E            ld   a,(hl)
462B  FEEE          cp   $EE
462D  2023          jr   nz,$4652
462F  23            inc  hl
4630  7E            ld   a,(hl)
4631  4F            ld   c,a
4632  0600          ld   b,$00
4634  37            scf
4635  3F            ccf
4636  ED42          sbc  hl,bc
4638  DD7505        ld   (ix+$05),l
463B  DD7406        ld   (ix+$06),h
463E  7E            ld   a,(hl)
463F  DD770B        ld   (ix+$0b),a
4642  23            inc  hl
4643  7E            ld   a,(hl)
4644  DD770C        ld   (ix+$0c),a
4647  DD6E0B        ld   l,(ix+$0b)
464A  DD660C        ld   h,(ix+$0c)
464D  7E            ld   a,(hl)
464E  CDA043        call $43A0
4651  C9            ret
4652  FEFF          cp   $FF
4654  C8            ret  z
4655  DD7505        ld   (ix+$05),l
4658  DD7406        ld   (ix+$06),h
465B  DD770B        ld   (ix+$0b),a
465E  23            inc  hl
465F  7E            ld   a,(hl)
4660  DD770C        ld   (ix+$0c),a
4663  CDA043        call $43A0
4666  C9            ret
4667  FF            rst  $38
4668  FF            rst  $38
4669  FF            rst  $38
466A  FF            rst  $38
466B  FF            rst  $38
466C  FF            rst  $38
466D  FF            rst  $38
466E  FF            rst  $38
466F  FF            rst  $38
4670  FF            rst  $38
4671  FF            rst  $38
4672  FF            rst  $38
4673  FF            rst  $38
4674  FF            rst  $38
4675  FF            rst  $38
4676  FF            rst  $38
4677  FF            rst  $38
4678  FF            rst  $38
4679  FF            rst  $38
467A  FF            rst  $38
467B  FF            rst  $38
467C  FF            rst  $38
467D  FF            rst  $38
467E  FF            rst  $38
467F  FF            rst  $38
4680  DD21B882      ld   ix,$82B8
4684  DD7E0D        ld   a,(ix+$0d)
4687  A7            and  a
4688  2817          jr   z,$46A1
468A  CD0045        call $4500
468D  DD7E0D        ld   a,(ix+$0d)
4690  3D            dec  a
4691  280E          jr   z,$46A1
4693  CD8045        call $4580
4696  DD7E0D        ld   a,(ix+$0d)
4699  3D            dec  a
469A  3D            dec  a
469B  2804          jr   z,$46A1
469D  CD0046        call $4600
46A0  C9            ret
46A1  C9            ret
46A2  FF            rst  $38
46A3  FF            rst  $38
46A4  FF            rst  $38
46A5  FF            rst  $38
46A6  FF            rst  $38
46A7  FF            rst  $38
46A8  FF            rst  $38
46A9  FF            rst  $38
46AA  FF            rst  $38
46AB  FF            rst  $38
46AC  FF            rst  $38
46AD  FF            rst  $38
46AE  FF            rst  $38
46AF  FF            rst  $38
46B0  E1            pop  hl
46B1  0600          ld   b,$00
46B3  4F            ld   c,a
46B4  09            add  hl,bc
46B5  E5            push hl
46B6  C9            ret
46B7  FF            rst  $38
46B8  FF            rst  $38
46B9  FF            rst  $38
46BA  FF            rst  $38
46BB  FF            rst  $38
46BC  FF            rst  $38
46BD  FF            rst  $38
46BE  FF            rst  $38
46BF  FF            rst  $38
46C0  21B882        ld   hl,$82B8
46C3  0618          ld   b,$18
46C5  3600          ld   (hl),$00
46C7  23            inc  hl
46C8  10FB          djnz $46C5
46CA  C9            ret
46CB  FF            rst  $38
46CC  FF            rst  $38
46CD  FF            rst  $38
46CE  FF            rst  $38
46CF  FF            rst  $38
46D0  CDC046        call $46C0
46D3  3A4280        ld   a,($8042)
46D6  CD3047        call $4730
46D9  DD21B882      ld   ix,$82B8
46DD  CD9047        call $4790
46E0  AF            xor  a
46E1  324280        ld   ($8042),a
46E4  C9            ret
46E5  FF            rst  $38
46E6  FF            rst  $38
46E7  FF            rst  $38
46E8  3A3480        ld   a,(num_players)
46EB  A7            and  a
46EC  C8            ret  z
46ED  3A0480        ld   a,($8004)
46F0  A7            and  a
46F1  2005          jr   nz,$46F8
46F3  3A2980        ld   a,($8029)
46F6  1803          jr   $46FB
46F8  3A2A80        ld   a,($802A)
46FB  3D            dec  a
46FC  87            add  a,a
46FD  87            add  a,a
46FE  CDB049        call $49B0
4701  47            ld   b,a
4702  3A6580        ld   a,($8065)
4705  B8            cp   b
4706  C8            ret  z
4707  78            ld   a,b
4708  324280        ld   ($8042),a
470B  326580        ld   ($8065),a
470E  C9            ret
470F  FF            rst  $38
4710  FF            rst  $38
4711  FF            rst  $38
4712  FF            rst  $38
4713  FF            rst  $38
4714  FF            rst  $38
4715  FF            rst  $38
4716  FF            rst  $38
4717  FF            rst  $38
4718  FF            rst  $38
4719  FF            rst  $38
471A  FF            rst  $38
471B  FF            rst  $38
471C  FF            rst  $38
471D  FF            rst  $38
471E  FF            rst  $38
471F  FF            rst  $38
4720  76            halt
4721  0D            dec  c
4722  FF            rst  $38
4723  FF            rst  $38
4724  FF            rst  $38
4725  FF            rst  $38
4726  FF            rst  $38
4727  FF            rst  $38
4728  FF            rst  $38
4729  FF            rst  $38
472A  FF            rst  $38
472B  FF            rst  $38
472C  FF            rst  $38
472D  FF            rst  $38
472E  FF            rst  $38
472F  FF            rst  $38
4730  CB27          sla  a
4732  CB27          sla  a
4734  CDB046        call $46B0
4737  00            nop
4738  00            nop
4739  00            nop
473A  C9            ret
473B  21005D        ld   hl,$5D00
473E  C9            ret
473F  21464C        ld   hl,$4C46
4742  C9            ret
4743  215350        ld   hl,$5053
4746  C9            ret
4747  21BC50        ld   hl,$50BC
474A  C9            ret
474B  21EC50        ld   hl,$50EC
474E  C9            ret
474F  219A51        ld   hl,$519A
4752  C9            ret
4753  21EA51        ld   hl,$51EA
4756  C9            ret
4757  211455        ld   hl,$5514
475A  C9            ret
475B  217057        ld   hl,$5770
475E  C9            ret
475F  216055        ld   hl,$5560
4762  C9            ret
4763  21EA5D        ld   hl,$5DEA
4766  C9            ret
4767  21885E        ld   hl,$5E88
476A  C9            ret
476B  21305F        ld   hl,$5F30
476E  C9            ret
476F  21785F        ld   hl,$5F78
4772  C9            ret
4773  21404B        ld   hl,$4B40
4776  C9            ret
4777  210000        ld   hl,$0000
477A  C9            ret
477B  210000        ld   hl,$0000
477E  C9            ret
477F  210000        ld   hl,$0000
4782  C9            ret
4783  210000        ld   hl,$0000
4786  C9            ret
4787  FF            rst  $38
4788  FF            rst  $38
4789  FF            rst  $38
478A  FF            rst  $38
478B  FF            rst  $38
478C  FF            rst  $38
478D  FF            rst  $38
478E  FF            rst  $38
478F  FF            rst  $38
4790  00            nop
4791  00            nop
4792  00            nop
4793  00            nop
4794  7E            ld   a,(hl)
4795  DD770D        ld   (ix+$0d),a
4798  47            ld   b,a
4799  23            inc  hl
479A  7E            ld   a,(hl)
479B  DD7701        ld   (ix+$01),a
479E  23            inc  hl
479F  7E            ld   a,(hl)
47A0  DD7702        ld   (ix+$02),a
47A3  05            dec  b
47A4  2817          jr   z,$47BD
47A6  23            inc  hl
47A7  7E            ld   a,(hl)
47A8  DD7703        ld   (ix+$03),a
47AB  23            inc  hl
47AC  7E            ld   a,(hl)
47AD  DD7704        ld   (ix+$04),a
47B0  05            dec  b
47B1  280A          jr   z,$47BD
47B3  23            inc  hl
47B4  7E            ld   a,(hl)
47B5  DD7705        ld   (ix+$05),a
47B8  23            inc  hl
47B9  7E            ld   a,(hl)
47BA  DD7706        ld   (ix+$06),a
47BD  DD6602        ld   h,(ix+$02)
47C0  DD6E01        ld   l,(ix+$01)
47C3  7E            ld   a,(hl)
47C4  DD770E        ld   (ix+$0e),a
47C7  23            inc  hl
47C8  7E            ld   a,(hl)
47C9  DD770F        ld   (ix+$0f),a
47CC  23            inc  hl
47CD  7E            ld   a,(hl)
47CE  DD7710        ld   (ix+$10),a
47D1  23            inc  hl
47D2  7E            ld   a,(hl)
47D3  DD7711        ld   (ix+$11),a
47D6  DD361200      ld   (ix+$12),$00
47DA  DD361300      ld   (ix+$13),$00
47DE  DD361400      ld   (ix+$14),$00
47E2  23            inc  hl
47E3  DD7501        ld   (ix+$01),l
47E6  DD7402        ld   (ix+$02),h
47E9  7E            ld   a,(hl)
47EA  DD7707        ld   (ix+$07),a
47ED  23            inc  hl
47EE  7E            ld   a,(hl)
47EF  DD7708        ld   (ix+$08),a
47F2  DD6E03        ld   l,(ix+$03)
47F5  DD6604        ld   h,(ix+$04)
47F8  7E            ld   a,(hl)
47F9  DD7709        ld   (ix+$09),a
47FC  23            inc  hl
47FD  7E            ld   a,(hl)
47FE  DD770A        ld   (ix+$0a),a
4801  DD6E05        ld   l,(ix+$05)
4804  DD6604        ld   h,(ix+$04)
4807  7E            ld   a,(hl)
4808  DD770B        ld   (ix+$0b),a
480B  23            inc  hl
480C  7E            ld   a,(hl)
480D  DD770C        ld   (ix+$0c),a
4810  CD2043        call $4320
4813  DD7E0D        ld   a,(ix+$0d)
4816  3D            dec  a
4817  C8            ret  z
4818  CD6043        call $4360
481B  DD7E0D        ld   a,(ix+$0d)
481E  3D            dec  a
481F  3D            dec  a
4820  C8            ret  z
4821  CDA043        call $43A0
4824  C9            ret
4825  FF            rst  $38
4826  FF            rst  $38
4827  FF            rst  $38
4828  FF            rst  $38
4829  FF            rst  $38
482A  FF            rst  $38
482B  FF            rst  $38
482C  FF            rst  $38
482D  FF            rst  $38
482E  FF            rst  $38
482F  FF            rst  $38
4830  FF            rst  $38
4831  FF            rst  $38
4832  FF            rst  $38
4833  FF            rst  $38
4834  FF            rst  $38
4835  FF            rst  $38
4836  FF            rst  $38
4837  FF            rst  $38
4838  FF            rst  $38
4839  FF            rst  $38
483A  FF            rst  $38
483B  FF            rst  $38
483C  FF            rst  $38
483D  FF            rst  $38
483E  FF            rst  $38
483F  FF            rst  $38
4840  3A4280        ld   a,($8042)
4843  A7            and  a
4844  2005          jr   nz,$484B
4846  CD8046        call $4680
4849  1803          jr   $484E
484B  CDD046        call $46D0
484E  3A4380        ld   a,($8043)
4851  A7            and  a
4852  2005          jr   nz,$4859
4854  CDE048        call $48E0
4857  1803          jr   $485C
4859  CD2049        call $4920
485C  3A4480        ld   a,($8044)
485F  A7            and  a
4860  2005          jr   nz,$4867
4862  CD7C48        call $487C
4865  1803          jr   $486A
4867  CD9C48        call $489C
486A  C9            ret
486B  FF            rst  $38
486C  FF            rst  $38
486D  FF            rst  $38
486E  FF            rst  $38
486F  FF            rst  $38
4870  21E882        ld   hl,$82E8
4873  0618          ld   b,$18
4875  3600          ld   (hl),$00
4877  23            inc  hl
4878  10FB          djnz $4875
487A  C9            ret
487B  FF            rst  $38
487C  DD21E882      ld   ix,$82E8
4880  DD7E0D        ld   a,(ix+$0d)
4883  A7            and  a
4884  C8            ret  z
4885  CD0046        call $4600
4888  DD7E0D        ld   a,(ix+$0d)
488B  3D            dec  a
488C  C8            ret  z
488D  CD0045        call $4500
4890  DD7E0D        ld   a,(ix+$0d)
4893  3D            dec  a
4894  3D            dec  a
4895  C8            ret  z
4896  CD8045        call $4580
4899  C9            ret
489A  FF            rst  $38
489B  FF            rst  $38
489C  CD7048        call $4870
489F  3A4480        ld   a,($8044)
48A2  CD3047        call $4730
48A5  DD21E882      ld   ix,$82E8
48A9  CD9047        call $4790
48AC  AF            xor  a
48AD  324480        ld   ($8044),a
48B0  C9            ret
48B1  FF            rst  $38
48B2  CD504B        call $4B50
48B5  CDA85A        call $5AA8
48B8  CDA85A        call $5AA8
48BB  CDA85A        call $5AA8
48BE  CDA85A        call $5AA8
48C1  217014        ld   hl,reset_xoff_sprites_and_clear_screen
48C4  CD815C        call $5C81
48C7  CDA85A        call $5AA8
48CA  C9            ret
48CB  FF            rst  $38
48CC  FF            rst  $38
48CD  FF            rst  $38
48CE  FF            rst  $38
48CF  FF            rst  $38
48D0  FF            rst  $38
48D1  FF            rst  $38
48D2  FF            rst  $38
48D3  FF            rst  $38
48D4  FF            rst  $38
48D5  FF            rst  $38
48D6  FF            rst  $38
48D7  FF            rst  $38
48D8  FF            rst  $38
48D9  FF            rst  $38
48DA  FF            rst  $38
48DB  FF            rst  $38
48DC  FF            rst  $38
48DD  FF            rst  $38
48DE  FF            rst  $38
48DF  FF            rst  $38
48E0  DD21D082      ld   ix,$82D0
48E4  DD7E0D        ld   a,(ix+$0d)
48E7  A7            and  a
48E8  C8            ret  z
48E9  CD8045        call $4580
48EC  DD7E0D        ld   a,(ix+$0d)
48EF  3D            dec  a
48F0  C8            ret  z
48F1  CD0046        call $4600
48F4  DD7E0D        ld   a,(ix+$0d)
48F7  3D            dec  a
48F8  3D            dec  a
48F9  C8            ret  z
48FA  CD0045        call $4500
48FD  C9            ret
48FE  FF            rst  $38
48FF  FF            rst  $38
4900  D9            exx
4901  E1            pop  hl
4902  0600          ld   b,$00
4904  4F            ld   c,a
4905  09            add  hl,bc
4906  E5            push hl
4907  D9            exx
4908  C9            ret
4909  FF            rst  $38
490A  FF            rst  $38
490B  FF            rst  $38
490C  FF            rst  $38
490D  FF            rst  $38
490E  FF            rst  $38
490F  FF            rst  $38
4910  21D082        ld   hl,$82D0
4913  0618          ld   b,$18
4915  3600          ld   (hl),$00
4917  23            inc  hl
4918  10FB          djnz $4915
491A  C9            ret
491B  FF            rst  $38
491C  FF            rst  $38
491D  FF            rst  $38
491E  FF            rst  $38
491F  FF            rst  $38
4920  CD1049        call $4910
4923  3A4380        ld   a,($8043)
4926  CD3047        call $4730
4929  DD21D082      ld   ix,$82D0
492D  CD9047        call $4790
4930  AF            xor  a
4931  324380        ld   ($8043),a
4934  C9            ret
4935  FF            rst  $38
4936  FF            rst  $38
4937  FF            rst  $38
4938  FF            rst  $38
4939  FF            rst  $38
493A  FF            rst  $38
493B  FF            rst  $38
493C  FF            rst  $38
493D  FF            rst  $38
493E  FF            rst  $38
493F  FF            rst  $38
4940  00            nop
4941  00            nop
4942  0E00          ld   c,$00
4944  CB47          bit  0,a
4946  2802          jr   z,$494A
4948  CBE8          set  5,b
494A  CB4F          bit  1,a
494C  2802          jr   z,$4950
494E  CBE0          set  4,b
4950  CB57          bit  2,a
4952  2802          jr   z,$4956
4954  CBF9          set  7,c
4956  CB5F          bit  3,a
4958  2802          jr   z,$495C
495A  CBF1          set  6,c
495C  CB67          bit  4,a
495E  2802          jr   z,$4962
4960  CBE9          set  5,c
4962  CB6F          bit  5,a
4964  2802          jr   z,$4968
4966  CBE1          set  4,c
4968  CB77          bit  6,a
496A  2802          jr   z,$496E
496C  CBD9          set  3,c
496E  CB7F          bit  7,a
4970  2802          jr   z,$4974
4972  CBD1          set  2,c
4974  78            ld   a,b
4975  00            nop
4976  00            nop
4977  00            nop
4978  79            ld   a,c
4979  00            nop
497A  00            nop
497B  00            nop
497C  C9            ret
497D  FF            rst  $38
497E  FF            rst  $38
497F  FF            rst  $38
4980  00            nop
4981  00            nop
4982  0EF0          ld   c,$F0
4984  CB47          bit  0,a
4986  2802          jr   z,$498A
4988  CBB9          res  7,c
498A  CB4F          bit  1,a
498C  2802          jr   z,$4990
498E  CBB1          res  6,c
4990  CB57          bit  2,a
4992  2802          jr   z,$4996
4994  CBA9          res  5,c
4996  CB5F          bit  3,a
4998  2802          jr   z,$499C
499A  CBA1          res  4,c
499C  79            ld   a,c
499D  80            add  a,b
499E  00            nop
499F  00            nop
49A0  00            nop
49A1  C9            ret
49A2  FF            rst  $38
49A3  FF            rst  $38
49A4  FF            rst  $38
49A5  FF            rst  $38
49A6  FF            rst  $38
49A7  FF            rst  $38
49A8  FF            rst  $38
49A9  FF            rst  $38
49AA  FF            rst  $38
49AB  FF            rst  $38
49AC  FF            rst  $38
49AD  FF            rst  $38
49AE  FF            rst  $38
49AF  FF            rst  $38
49B0  CDB046        call $46B0
49B3  3E0E          ld   a,$0E
49B5  C9            ret
49B6  00            nop
49B7  3E0E          ld   a,$0E
49B9  C9            ret
49BA  00            nop
49BB  3E0E          ld   a,$0E
49BD  C9            ret
49BE  00            nop
49BF  3E0E          ld   a,$0E
49C1  C9            ret
49C2  00            nop
49C3  3E0E          ld   a,$0E
49C5  C9            ret
49C6  00            nop
49C7  3E0E          ld   a,$0E
49C9  C9            ret
49CA  00            nop
49CB  3E0D          ld   a,$0D
49CD  C9            ret
49CE  00            nop
49CF  3E01          ld   a,$01
49D1  C9            ret
49D2  00            nop
49D3  3E01          ld   a,$01
49D5  C9            ret
49D6  00            nop
49D7  3E01          ld   a,$01
49D9  C9            ret
49DA  00            nop
49DB  3E01          ld   a,$01
49DD  C9            ret
49DE  00            nop
49DF  3E01          ld   a,$01
49E1  C9            ret
49E2  00            nop
49E3  3E0B          ld   a,$0B
49E5  C9            ret
49E6  00            nop
49E7  3E0B          ld   a,$0B
49E9  C9            ret
49EA  00            nop
49EB  3E0B          ld   a,$0B
49ED  C9            ret
49EE  00            nop
49EF  3E0B          ld   a,$0B
49F1  C9            ret
49F2  00            nop
49F3  3E0B          ld   a,$0B
49F5  C9            ret
49F6  00            nop
49F7  3E0B          ld   a,$0B
49F9  C9            ret
49FA  00            nop
49FB  3E0B          ld   a,$0B
49FD  C9            ret
49FE  00            nop
49FF  3E0D          ld   a,$0D
4A01  C9            ret
4A02  00            nop
4A03  3E0C          ld   a,$0C
4A05  C9            ret
4A06  00            nop
4A07  3E0C          ld   a,$0C
4A09  C9            ret
4A0A  00            nop
4A0B  3E0C          ld   a,$0C
4A0D  C9            ret
4A0E  00            nop
4A0F  3E0C          ld   a,$0C
4A11  C9            ret
4A12  00            nop
4A13  3E0C          ld   a,$0C
4A15  C9            ret
4A16  00            nop
4A17  3E0C          ld   a,$0C
4A19  C9            ret
4A1A  00            nop
4A1B  3E0E          ld   a,$0E
4A1D  C9            ret
4A1E  00            nop
4A1F  FF            rst  $38
4A20  15            dec  d
4A21  011701        ld   bc,$0117
4A24  19            add  hl,de
4A25  011A02        ld   bc,$021A
4A28  1A            ld   a,(de)
4A29  02            ld   (bc),a
4A2A  1802          jr   $4A2E
4A2C  1802          jr   $4A30
4A2E  17            rla
4A2F  02            ld   (bc),a
4A30  17            rla
4A31  02            ld   (bc),a
4A32  1602          ld   d,$02
4A34  1602          ld   d,$02
4A36  15            dec  d
4A37  02            ld   (bc),a
4A38  15            dec  d
4A39  02            ld   (bc),a
4A3A  13            inc  de
4A3B  02            ld   (bc),a
4A3C  13            inc  de
4A3D  02            ld   (bc),a
4A3E  12            ld   (de),a
4A3F  010E01        ld   bc,$010E
4A42  1001          djnz $4A45
4A44  0E02          ld   c,$02
4A46  FF            rst  $38
4A47  FF            rst  $38
4A48  15            dec  d
4A49  011701        ld   bc,$0117
4A4C  19            add  hl,de
4A4D  012101        ld   bc,$0121
4A50  2602          ld   h,$02
4A52  210126        ld   hl,$2601
4A55  02            ld   (bc),a
4A56  210220        ld   hl,$2002
4A59  012602        ld   bc,$0226
4A5C  2001          jr   nz,$4A5F
4A5E  2602          ld   h,$02
4A60  2002          jr   nz,$4A64
4A62  1F            rra
4A63  012602        ld   bc,$0226
4A66  1F            rra
4A67  012602        ld   bc,$0226
4A6A  1F            rra
4A6B  02            ld   (bc),a
4A6C  1E01          ld   e,$01
4A6E  1F            rra
4A6F  012001        ld   bc,$0120
4A72  2102FF        ld   hl,$FF02
4A75  FF            rst  $38
4A76  FF            rst  $38
4A77  FF            rst  $38
4A78  FF            rst  $38
4A79  FF            rst  $38
4A7A  FF            rst  $38
4A7B  FF            rst  $38
4A7C  FF            rst  $38
4A7D  FF            rst  $38
4A7E  FF            rst  $38
4A7F  FF            rst  $38
4A80  13            inc  de
4A81  04            inc  b
4A82  1A            ld   a,(de)
4A83  04            inc  b
4A84  1A            ld   a,(de)
4A85  04            inc  b
4A86  1802          jr   $4A8A
4A88  17            rla
4A89  02            ld   (bc),a
4A8A  1802          jr   $4A8E
4A8C  1A            ld   a,(de)
4A8D  02            ld   (bc),a
4A8E  1C            inc  e
4A8F  02            ld   (bc),a
4A90  1A            ld   a,(de)
4A91  0A            ld   a,(bc)
4A92  FF            rst  $38
4A93  FF            rst  $38
4A94  1F            rra
4A95  02            ld   (bc),a
4A96  1E02          ld   e,$02
4A98  1C            inc  e
4A99  04            inc  b
4A9A  1A            ld   a,(de)
4A9B  02            ld   (bc),a
4A9C  1802          jr   $4AA0
4A9E  17            rla
4A9F  04            inc  b
4AA0  15            dec  d
4AA1  02            ld   (bc),a
4AA2  13            inc  de
4AA3  02            ld   (bc),a
4AA4  15            dec  d
4AA5  02            ld   (bc),a
4AA6  17            rla
4AA7  0A            ld   a,(bc)
4AA8  FF            rst  $38
4AA9  FF            rst  $38
4AAA  23            inc  hl
4AAB  02            ld   (bc),a
4AAC  21021F        ld   hl,$1F02
4AAF  02            ld   (bc),a
4AB0  1E02          ld   e,$02
4AB2  1C            inc  e
4AB3  02            ld   (bc),a
4AB4  1A            ld   a,(de)
4AB5  02            ld   (bc),a
4AB6  1802          jr   $4ABA
4AB8  17            rla
4AB9  02            ld   (bc),a
4ABA  15            dec  d
4ABB  02            ld   (bc),a
4ABC  13            inc  de
4ABD  02            ld   (bc),a
4ABE  12            ld   (de),a
4ABF  02            ld   (bc),a
4AC0  13            inc  de
4AC1  0A            ld   a,(bc)
4AC2  FF            rst  $38
4AC3  FF            rst  $38
4AC4  15            dec  d
4AC5  03            inc  bc
4AC6  1A            ld   a,(de)
4AC7  04            inc  b
4AC8  1A            ld   a,(de)
4AC9  04            inc  b
4ACA  1A            ld   a,(de)
4ACB  04            inc  b
4ACC  1A            ld   a,(de)
4ACD  04            inc  b
4ACE  17            rla
4ACF  04            inc  b
4AD0  17            rla
4AD1  04            inc  b
4AD2  1A            ld   a,(de)
4AD3  08            ex   af,af'
4AD4  1A            ld   a,(de)
4AD5  04            inc  b
4AD6  1A            ld   a,(de)
4AD7  04            inc  b
4AD8  1A            ld   a,(de)
4AD9  04            inc  b
4ADA  1A            ld   a,(de)
4ADB  04            inc  b
4ADC  19            add  hl,de
4ADD  04            inc  b
4ADE  19            add  hl,de
4ADF  04            inc  b
4AE0  1A            ld   a,(de)
4AE1  05            dec  b
4AE2  FF            rst  $38
4AE3  FF            rst  $38
4AE4  15            dec  d
4AE5  03            inc  bc
4AE6  15            dec  d
4AE7  02            ld   (bc),a
4AE8  15            dec  d
4AE9  02            ld   (bc),a
4AEA  15            dec  d
4AEB  02            ld   (bc),a
4AEC  15            dec  d
4AED  02            ld   (bc),a
4AEE  13            inc  de
4AEF  02            ld   (bc),a
4AF0  13            inc  de
4AF1  02            ld   (bc),a
4AF2  1002          djnz $4AF6
4AF4  1002          djnz $4AF8
4AF6  1002          djnz $4AFA
4AF8  1002          djnz $4AFC
4AFA  0E02          ld   c,$02
4AFC  0E02          ld   c,$02
4AFE  09            add  hl,bc
4AFF  02            ld   (bc),a
4B00  09            add  hl,bc
4B01  010902        ld   bc,$0209
4B04  FF            rst  $38
4B05  FF            rst  $38
4B06  15            dec  d
4B07  20FF          jr   nz,$4B08
4B09  FF            rst  $38
4B0A  FF            rst  $38
4B0B  FF            rst  $38
4B0C  15            dec  d
4B0D  011A02        ld   bc,$021A
4B10  15            dec  d
4B11  011A02        ld   bc,$021A
4B14  15            dec  d
4B15  02            ld   (bc),a
4B16  14            inc  d
4B17  011A02        ld   bc,$021A
4B1A  14            inc  d
4B1B  011A02        ld   bc,$021A
4B1E  14            inc  d
4B1F  02            ld   (bc),a
4B20  13            inc  de
4B21  011A02        ld   bc,$021A
4B24  13            inc  de
4B25  011A02        ld   bc,$021A
4B28  13            inc  de
4B29  02            ld   (bc),a
4B2A  12            ld   (de),a
4B2B  02            ld   (bc),a
4B2C  09            add  hl,bc
4B2D  02            ld   (bc),a
4B2E  0E02          ld   c,$02
4B30  FF            rst  $38
4B31  FF            rst  $38
4B32  01050F        ld   bc,$0F05
4B35  00            nop
4B36  0C            inc  c
4B37  4B            ld   c,e
4B38  FF            rst  $38
4B39  FF            rst  $38
4B3A  FF            rst  $38
4B3B  FF            rst  $38
4B3C  48            ld   c,b
4B3D  4B            ld   c,e
4B3E  FF            rst  $38
4B3F  FF            rst  $38
4B40  03            inc  bc
4B41  324B36        ld   ($364B),a
4B44  4B            ld   c,e
4B45  364B          ld   (hl),$4B
4B47  FF            rst  $38
4B48  00            nop
4B49  01FFFF        ld   bc,$FFFF
4B4C  FF            rst  $38
4B4D  FF            rst  $38
4B4E  FF            rst  $38
4B4F  FF            rst  $38
4B50  214081        ld   hl,$8140
4B53  3685          ld   (hl),$85
4B55  23            inc  hl
4B56  362C          ld   (hl),$2C
4B58  23            inc  hl
4B59  3612          ld   (hl),$12
4B5B  23            inc  hl
4B5C  3690          ld   (hl),$90
4B5E  23            inc  hl
4B5F  367E          ld   (hl),$7E
4B61  23            inc  hl
4B62  3630          ld   (hl),$30
4B64  23            inc  hl
4B65  3612          ld   (hl),$12
4B67  23            inc  hl
4B68  36A0          ld   (hl),$A0
4B6A  23            inc  hl
4B6B  C9            ret
4B6C  FF            rst  $38
4B6D  FF            rst  $38
4B6E  FF            rst  $38
4B6F  FF            rst  $38
4B70  FF            rst  $38
4B71  FF            rst  $38
4B72  FF            rst  $38
4B73  FF            rst  $38
4B74  FF            rst  $38
4B75  FF            rst  $38
4B76  FF            rst  $38
4B77  FF            rst  $38
4B78  FF            rst  $38
4B79  FF            rst  $38
4B7A  FF            rst  $38
4B7B  FF            rst  $38
4B7C  FF            rst  $38
4B7D  FF            rst  $38
4B7E  FF            rst  $38
4B7F  FF            rst  $38
4B80  FF            rst  $38
4B81  FF            rst  $38
4B82  FF            rst  $38
4B83  FF            rst  $38
4B84  FF            rst  $38
4B85  FF            rst  $38
4B86  FF            rst  $38
4B87  FF            rst  $38
4B88  FF            rst  $38
4B89  FF            rst  $38
4B8A  FF            rst  $38
4B8B  FF            rst  $38
4B8C  FF            rst  $38
4B8D  FF            rst  $38
4B8E  FF            rst  $38
4B8F  FF            rst  $38
4B90  FF            rst  $38
4B91  FF            rst  $38
4B92  FF            rst  $38
4B93  FF            rst  $38
4B94  FF            rst  $38
4B95  FF            rst  $38
4B96  FF            rst  $38
4B97  FF            rst  $38
4B98  FF            rst  $38
4B99  FF            rst  $38
4B9A  FF            rst  $38
4B9B  FF            rst  $38
4B9C  FF            rst  $38
4B9D  FF            rst  $38
4B9E  FF            rst  $38
4B9F  FF            rst  $38
4BA0  FF            rst  $38
4BA1  FF            rst  $38
4BA2  FF            rst  $38
4BA3  FF            rst  $38
4BA4  FF            rst  $38
4BA5  FF            rst  $38
4BA6  FF            rst  $38
4BA7  FF            rst  $38
4BA8  FF            rst  $38
4BA9  FF            rst  $38
4BAA  FF            rst  $38
4BAB  FF            rst  $38
4BAC  FF            rst  $38
4BAD  FF            rst  $38
4BAE  FF            rst  $38
4BAF  FF            rst  $38
4BB0  FF            rst  $38
4BB1  FF            rst  $38
4BB2  FF            rst  $38
4BB3  FF            rst  $38
4BB4  FF            rst  $38
4BB5  FF            rst  $38
4BB6  FF            rst  $38
4BB7  FF            rst  $38
4BB8  FF            rst  $38
4BB9  FF            rst  $38
4BBA  FF            rst  $38
4BBB  FF            rst  $38
4BBC  FF            rst  $38
4BBD  FF            rst  $38
4BBE  FF            rst  $38
4BBF  FF            rst  $38
4BC0  FF            rst  $38
4BC1  FF            rst  $38
4BC2  FF            rst  $38
4BC3  FF            rst  $38
4BC4  FF            rst  $38
4BC5  FF            rst  $38
4BC6  FF            rst  $38
4BC7  FF            rst  $38
4BC8  FF            rst  $38
4BC9  FF            rst  $38
4BCA  FF            rst  $38
4BCB  FF            rst  $38
4BCC  FF            rst  $38
4BCD  FF            rst  $38
4BCE  FF            rst  $38
4BCF  FF            rst  $38
4BD0  FF            rst  $38
4BD1  FF            rst  $38
4BD2  FF            rst  $38
4BD3  FF            rst  $38
4BD4  FF            rst  $38
4BD5  FF            rst  $38
4BD6  FF            rst  $38
4BD7  FF            rst  $38
4BD8  FF            rst  $38
4BD9  FF            rst  $38
4BDA  FF            rst  $38
4BDB  FF            rst  $38
4BDC  FF            rst  $38
4BDD  FF            rst  $38
4BDE  FF            rst  $38
4BDF  FF            rst  $38
4BE0  0E04          ld   c,$04
4BE2  0E02          ld   c,$02
4BE4  0C            inc  c
4BE5  02            ld   (bc),a
4BE6  0E04          ld   c,$04
4BE8  110210        ld   de,$1002
4BEB  02            ld   (bc),a
4BEC  0E02          ld   c,$02
4BEE  0E02          ld   c,$02
4BF0  0C            inc  c
4BF1  02            ld   (bc),a
4BF2  0E10          ld   c,$10
4BF4  FF            rst  $38
4BF5  FF            rst  $38
4BF6  09            add  hl,bc
4BF7  04            inc  b
4BF8  07            rlca
4BF9  02            ld   (bc),a
4BFA  09            add  hl,bc
4BFB  04            inc  b
4BFC  1A            ld   a,(de)
4BFD  02            ld   (bc),a
4BFE  1802          jr   $4C02
4C00  1802          jr   $4C04
4C02  09            add  hl,bc
4C03  02            ld   (bc),a
4C04  09            add  hl,bc
4C05  02            ld   (bc),a
4C06  07            rlca
4C07  02            ld   (bc),a
4C08  09            add  hl,bc
4C09  04            inc  b
4C0A  FF            rst  $38
4C0B  FF            rst  $38
4C0C  FF            rst  $38
4C0D  FF            rst  $38
4C0E  FF            rst  $38
4C0F  FF            rst  $38
4C10  FF            rst  $38
4C11  FF            rst  $38
4C12  FF            rst  $38
4C13  FF            rst  $38
4C14  FF            rst  $38
4C15  FF            rst  $38
4C16  FF            rst  $38
4C17  FF            rst  $38
4C18  FF            rst  $38
4C19  FF            rst  $38
4C1A  FF            rst  $38
4C1B  FF            rst  $38
4C1C  FF            rst  $38
4C1D  FF            rst  $38
4C1E  FF            rst  $38
4C1F  FF            rst  $38
4C20  FF            rst  $38
4C21  FF            rst  $38
4C22  FF            rst  $38
4C23  FF            rst  $38
4C24  FF            rst  $38
4C25  FF            rst  $38
4C26  FF            rst  $38
4C27  FF            rst  $38
4C28  FF            rst  $38
4C29  FF            rst  $38
4C2A  FF            rst  $38
4C2B  FF            rst  $38
4C2C  FF            rst  $38
4C2D  FF            rst  $38
4C2E  FF            rst  $38
4C2F  FF            rst  $38
4C30  324CFF        ld   ($FF4C),a
4C33  FF            rst  $38
4C34  FF            rst  $38
4C35  FF            rst  $38
4C36  01040F        ld   bc,$0F04
4C39  00            nop
4C3A  E0            ret  po
4C3B  4B            ld   c,e
4C3C  FF            rst  $38
4C3D  FF            rst  $38
4C3E  F64B          or   $4B
4C40  FF            rst  $38
4C41  FF            rst  $38
4C42  0C            inc  c
4C43  0C            inc  c
4C44  FF            rst  $38
4C45  FF            rst  $38
4C46  03            inc  bc
4C47  364C          ld   (hl),$4C
4C49  3E4C          ld   a,$4C
4C4B  304C          jr   nc,$4C99
4C4D  FF            rst  $38
4C4E  FF            rst  $38
4C4F  FF            rst  $38
4C50  CD8444        call $4484
4C53  3A0480        ld   a,($8004)
4C56  A7            and  a
4C57  2805          jr   z,$4C5E
4C59  3A2A80        ld   a,($802A)
4C5C  1803          jr   $4C61
4C5E  3A2980        ld   a,($8029)
4C61  3D            dec  a
4C62  87            add  a,a
4C63  87            add  a,a
4C64  CD0049        call $4900
4C67  CDE34C        call $4CE3
4C6A  C9            ret
4C6B  CDE845        call $45E8
4C6E  C9            ret
4C6F  CD6845        call $4568
4C72  C9            ret
4C73  CDE34C        call $4CE3
4C76  C9            ret
4C77  CD7045        call $4570
4C7A  C9            ret
4C7B  CD7040        call $4070
4C7E  C9            ret
4C7F  CD7840        call $4078
4C82  C9            ret
4C83  CDE845        call $45E8
4C86  C9            ret
4C87  CD6845        call $4568
4C8A  C9            ret
4C8B  CD7045        call $4570
4C8E  C9            ret
4C8F  CD7745        call $4577
4C92  C9            ret
4C93  CD7840        call $4078
4C96  C9            ret
4C97  CDE34C        call $4CE3
4C9A  C9            ret
4C9B  CD4040        call $4040
4C9E  C9            ret
4C9F  CDE845        call $45E8
4CA2  C9            ret
4CA3  CDE840        call $40E8
4CA6  C9            ret
4CA7  CD7840        call $4078
4CAA  C9            ret
4CAB  CDE845        call $45E8
4CAE  C9            ret
4CAF  CDE840        call $40E8
4CB2  C9            ret
4CB3  CD7840        call $4078
4CB6  C9            ret
4CB7  CD2841        call $4128
4CBA  C9            ret
4CBB  CD7745        call $4577
4CBE  C9            ret
4CBF  CD7840        call $4078
4CC2  C9            ret
4CC3  CD2841        call $4128
4CC6  C9            ret
4CC7  CD7041        call $4170
4CCA  C9            ret
4CCB  CD7840        call $4078
4CCE  C9            ret
4CCF  00            nop
4CD0  00            nop
4CD1  00            nop
4CD2  C9            ret
4CD3  00            nop
4CD4  00            nop
4CD5  00            nop
4CD6  C9            ret
4CD7  FF            rst  $38
4CD8  FF            rst  $38
4CD9  FF            rst  $38
4CDA  FF            rst  $38
4CDB  FF            rst  $38
4CDC  FF            rst  $38
4CDD  FF            rst  $38
4CDE  FF            rst  $38
4CDF  FF            rst  $38
4CE0  FF            rst  $38
4CE1  FF            rst  $38
4CE2  FF            rst  $38
4CE3  3E8C          ld   a,$8C
4CE5  325A91        ld   ($915A),a
4CE8  C9            ret
4CE9  FF            rst  $38
4CEA  3A4C81        ld   a,($814C)
4CED  D684          sub  $84
4CEF  37            scf
4CF0  3F            ccf
4CF1  D618          sub  $18
4CF3  D0            ret  nc
4CF4  3A4F81        ld   a,($814F)
4CF7  CB3F          srl  a
4CF9  CB3F          srl  a
4CFB  CB3F          srl  a
4CFD  47            ld   b,a
4CFE  7D            ld   a,l
4CFF  E61F          and  $1F
4D01  90            sub  b
4D02  37            scf
4D03  3F            ccf
4D04  C3B44D        jp   $4DB4
4D07  FF            rst  $38
4D08  CD604D        call $4D60
4D0B  E5            push hl
4D0C  2B            dec  hl
4D0D  3610          ld   (hl),$10
4D0F  23            inc  hl
4D10  3676          ld   (hl),$76
4D12  23            inc  hl
4D13  3677          ld   (hl),$77
4D15  23            inc  hl
4D16  367A          ld   (hl),$7A
4D18  23            inc  hl
4D19  367B          ld   (hl),$7B
4D1B  01DCFF        ld   bc,$FFDC
4D1E  09            add  hl,bc
4D1F  3610          ld   (hl),$10
4D21  23            inc  hl
4D22  3674          ld   (hl),$74
4D24  23            inc  hl
4D25  3675          ld   (hl),$75
4D27  23            inc  hl
4D28  3678          ld   (hl),$78
4D2A  23            inc  hl
4D2B  3679          ld   (hl),$79
4D2D  09            add  hl,bc
4D2E  3610          ld   (hl),$10
4D30  23            inc  hl
4D31  367E          ld   (hl),$7E
4D33  23            inc  hl
4D34  367F          ld   (hl),$7F
4D36  23            inc  hl
4D37  367C          ld   (hl),$7C
4D39  23            inc  hl
4D3A  367D          ld   (hl),$7D
4D3C  E1            pop  hl
4D3D  C9            ret
4D3E  FF            rst  $38
4D3F  FF            rst  $38
4D40  CD754E        call $4E75
4D43  CD084D        call $4D08
4D46  E5            push hl
4D47  21A013        ld   hl,wait_vblank
4D4A  CD815C        call $5C81
4D4D  3A1283        ld   a,($8312)
4D50  E603          and  $03
4D52  20F3          jr   nz,$4D47
4D54  E1            pop  hl
4D55  23            inc  hl
4D56  CDEA4C        call $4CEA
4D59  3EDC          ld   a,$DC
4D5B  BD            cp   l
4D5C  C8            ret  z
4D5D  18E4          jr   $4D43
4D5F  FF            rst  $38
4D60  AF            xor  a
4D61  322681        ld   ($8126),a
4D64  322881        ld   ($8128),a
4D67  322A81        ld   ($812A),a
4D6A  C9            ret
4D6B  FF            rst  $38
4D6C  FF            rst  $38
4D6D  FF            rst  $38
4D6E  FF            rst  $38
4D6F  FF            rst  $38
4D70  FF            rst  $38
4D71  FF            rst  $38
4D72  FF            rst  $38
4D73  FF            rst  $38
4D74  3A0480        ld   a,($8004)
4D77  A7            and  a
4D78  2005          jr   nz,$4D7F
4D7A  3A2980        ld   a,($8029)
4D7D  1803          jr   $4D82
4D7F  3A2A80        ld   a,($802A)
4D82  FE1B          cp   $1B
4D84  C0            ret  nz
4D85  CD904D        call $4D90
4D88  C9            ret
4D89  FF            rst  $38
4D8A  FF            rst  $38
4D8B  FF            rst  $38
4D8C  FF            rst  $38
4D8D  FF            rst  $38
4D8E  FF            rst  $38
4D8F  FF            rst  $38
4D90  3A5180        ld   a,($8051)
4D93  A7            and  a
4D94  C0            ret  nz
4D95  3A4081        ld   a,($8140)
4D98  D670          sub  $70
4D9A  37            scf
4D9B  3F            ccf
4D9C  D620          sub  $20
4D9E  D0            ret  nc
4D9F  3A4381        ld   a,($8143)
4DA2  D630          sub  $30
4DA4  37            scf
4DA5  3F            ccf
4DA6  D61C          sub  $1C
4DA8  D0            ret  nc
4DA9  3E01          ld   a,$01
4DAB  325180        ld   ($8051),a
4DAE  CD404D        call $4D40
4DB1  C9            ret
4DB2  FF            rst  $38
4DB3  FF            rst  $38
4DB4  D602          sub  $02
4DB6  D0            ret  nc
4DB7  C3D04D        jp   $4DD0
4DBA  FF            rst  $38
4DBB  FF            rst  $38
4DBC  FF            rst  $38
4DBD  FF            rst  $38
4DBE  FF            rst  $38
4DBF  FF            rst  $38
4DC0  2E40          ld   l,$40
4DC2  E5            push hl
4DC3  21A013        ld   hl,wait_vblank
4DC6  CD815C        call $5C81
4DC9  E1            pop  hl
4DCA  2D            dec  l
4DCB  20F5          jr   nz,$4DC2
4DCD  C9            ret
4DCE  FF            rst  $38
4DCF  FF            rst  $38
4DD0  AF            xor  a
4DD1  324C81        ld   ($814C),a
4DD4  325081        ld   ($8150),a
4DD7  CD084D        call $4D08
4DDA  E5            push hl
4DDB  21A013        ld   hl,wait_vblank
4DDE  CD815C        call $5C81
4DE1  E1            pop  hl
4DE2  23            inc  hl
4DE3  3EDC          ld   a,$DC
4DE5  BD            cp   l
4DE6  20EF          jr   nz,$4DD7
4DE8  3E91          ld   a,$91
4DEA  324C81        ld   ($814C),a
4DED  3E38          ld   a,$38
4DEF  324D81        ld   ($814D),a
4DF2  3E12          ld   a,$12
4DF4  324E81        ld   ($814E),a
4DF7  3ED7          ld   a,$D7
4DF9  324F81        ld   ($814F),a
4DFC  3E8A          ld   a,$8A
4DFE  325081        ld   ($8150),a
4E01  3E39          ld   a,$39
4E03  325181        ld   ($8151),a
4E06  3E12          ld   a,$12
4E08  325281        ld   ($8152),a
4E0B  3EE7          ld   a,$E7
4E0D  325381        ld   ($8153),a
4E10  CDC04D        call $4DC0
4E13  CDE04E        call $4EE0
4E16  21483D        ld   hl,$3D48
4E19  CD815C        call $5C81
4E1C  C9            ret
4E1D  FF            rst  $38
4E1E  FF            rst  $38
4E1F  FF            rst  $38
4E20  CD804E        call $4E80
4E23  CD815C        call $5C81
4E26  CDA85A        call $5AA8
4E29  21743F        ld   hl,$3F74
4E2C  CD815C        call $5C81
4E2F  CDA85A        call $5AA8
4E32  214B16        ld   hl,$164B
4E35  CD815C        call $5C81
4E38  3E07          ld   a,$07
4E3A  322980        ld   ($8029),a
4E3D  322A80        ld   ($802A),a
4E40  21B812        ld   hl,$12B8
4E43  CD815C        call $5C81
4E46  21A83F        ld   hl,$3FA8
4E49  CD815C        call $5C81
4E4C  214892        ld   hl,$9248
4E4F  06A0          ld   b,$A0
4E51  0E05          ld   c,$05
4E53  70            ld   (hl),b
4E54  04            inc  b
4E55  23            inc  hl
4E56  70            ld   (hl),b
4E57  04            inc  b
4E58  111F00        ld   de,$001F
4E5B  19            add  hl,de
4E5C  70            ld   (hl),b
4E5D  04            inc  b
4E5E  23            inc  hl
4E5F  70            ld   (hl),b
4E60  11A1FF        ld   de,$FFA1
4E63  19            add  hl,de
4E64  04            inc  b
4E65  CDD44E        call $4ED4
4E68  0D            dec  c
4E69  20E8          jr   nz,$4E53
4E6B  218C3F        ld   hl,$3F8C
4E6E  CD815C        call $5C81
4E71  C3E252        jp   $52E2
4E74  FF            rst  $38
4E75  F5            push af
4E76  3E05          ld   a,$05
4E78  324480        ld   ($8044),a
4E7B  F1            pop  af
4E7C  21C991        ld   hl,$91C9
4E7F  C9            ret
4E80  21880F        ld   hl,$0F88
4E83  CD815C        call $5C81
4E86  21663F        ld   hl,$3F66
4E89  C9            ret
4E8A  FF            rst  $38
4E8B  FF            rst  $38
4E8C  FF            rst  $38
4E8D  FF            rst  $38
4E8E  FF            rst  $38
4E8F  FF            rst  $38
4E90  3EF9          ld   a,$F9
4E92  00            nop
4E93  00            nop
4E94  00            nop
4E95  3EFD          ld   a,$FD
4E97  00            nop
4E98  00            nop
4E99  00            nop
4E9A  3EFB          ld   a,$FB
4E9C  00            nop
4E9D  00            nop
4E9E  00            nop
4E9F  3EFF          ld   a,$FF
4EA1  00            nop
4EA2  00            nop
4EA3  00            nop
4EA4  C9            ret
4EA5  78            ld   a,b
4EA6  CD0049        call $4900
4EA9  FF            rst  $38
4EAA  FF            rst  $38
4EAB  FF            rst  $38
4EAC  FF            rst  $38
4EAD  FF            rst  $38
4EAE  FF            rst  $38
4EAF  FF            rst  $38
4EB0  CDC24E        call $4EC2
4EB3  CDC24E        call $4EC2
4EB6  CDC24E        call $4EC2
4EB9  CDC24E        call $4EC2
4EBC  C9            ret
4EBD  FF            rst  $38
4EBE  FF            rst  $38
4EBF  FF            rst  $38
4EC0  FF            rst  $38
4EC1  FF            rst  $38
4EC2  160E          ld   d,$0E
4EC4  E5            push hl
4EC5  C5            push bc
4EC6  D5            push de
4EC7  212821        ld   hl,$2128
4ECA  CD815C        call $5C81
4ECD  D1            pop  de
4ECE  C1            pop  bc
4ECF  E1            pop  hl
4ED0  15            dec  d
4ED1  20F1          jr   nz,$4EC4
4ED3  C9            ret
4ED4  CDC24E        call $4EC2
4ED7  CDC24E        call $4EC2
4EDA  C9            ret
4EDB  FF            rst  $38
4EDC  FF            rst  $38
4EDD  FF            rst  $38
4EDE  FF            rst  $38
4EDF  FF            rst  $38
4EE0  3A0480        ld   a,($8004)
4EE3  A7            and  a
4EE4  2005          jr   nz,$4EEB
4EE6  215B80        ld   hl,$805B
4EE9  1803          jr   $4EEE
4EEB  215C80        ld   hl,$805C
4EEE  7E            ld   a,(hl)
4EEF  FE1F          cp   $1F
4EF1  2003          jr   nz,$4EF6
4EF3  3610          ld   (hl),$10
4EF5  C9            ret
4EF6  FE10          cp   $10
4EF8  2003          jr   nz,$4EFD
4EFA  360D          ld   (hl),$0D
4EFC  C9            ret
4EFD  C31C50        jp   $501C
4F00  91            sub  c
4F01  5A            ld   e,d
4F02  8C            adc  a,h
4F03  00            nop
4F04  00            nop
4F05  00            nop
4F06  00            nop
4F07  00            nop
4F08  00            nop
4F09  91            sub  c
4F0A  5A            ld   e,d
4F0B  8D            adc  a,l
4F0C  00            nop
4F0D  00            nop
4F0E  00            nop
4F0F  00            nop
4F10  00            nop
4F11  00            nop
4F12  91            sub  c
4F13  1A            ld   a,(de)
4F14  8D            adc  a,l
4F15  00            nop
4F16  00            nop
4F17  00            nop
4F18  00            nop
4F19  00            nop
4F1A  00            nop
4F1B  91            sub  c
4F1C  5A            ld   e,d
4F1D  8C            adc  a,h
4F1E  00            nop
4F1F  00            nop
4F20  00            nop
4F21  00            nop
4F22  00            nop
4F23  00            nop
4F24  91            sub  c
4F25  B1            or   c
4F26  8C            adc  a,h
4F27  00            nop
4F28  00            nop
4F29  00            nop
4F2A  00            nop
4F2B  00            nop
4F2C  00            nop
4F2D  91            sub  c
4F2E  8E            adc  a,(hl)
4F2F  8C            adc  a,h
4F30  00            nop
4F31  00            nop
4F32  00            nop
4F33  00            nop
4F34  00            nop
4F35  00            nop
4F36  91            sub  c
4F37  D28D00        jp   nc,$008D
4F3A  00            nop
4F3B  00            nop
4F3C  00            nop
4F3D  00            nop
4F3E  00            nop
4F3F  91            sub  c
4F40  5A            ld   e,d
4F41  8D            adc  a,l
4F42  00            nop
4F43  00            nop
4F44  00            nop
4F45  00            nop
4F46  00            nop
4F47  00            nop
4F48  91            sub  c
4F49  1A            ld   a,(de)
4F4A  8D            adc  a,l
4F4B  00            nop
4F4C  00            nop
4F4D  00            nop
4F4E  00            nop
4F4F  00            nop
4F50  00            nop
4F51  91            sub  c
4F52  B1            or   c
4F53  8C            adc  a,h
4F54  00            nop
4F55  00            nop
4F56  00            nop
4F57  00            nop
4F58  00            nop
4F59  00            nop
4F5A  90            sub  b
4F5B  CB8E          res  1,(hl)
4F5D  91            sub  c
4F5E  8E            adc  a,(hl)
4F5F  8C            adc  a,h
4F60  00            nop
4F61  00            nop
4F62  00            nop
4F63  91            sub  c
4F64  D28D00        jp   nc,$008D
4F67  00            nop
4F68  00            nop
4F69  00            nop
4F6A  00            nop
4F6B  00            nop
4F6C  91            sub  c
4F6D  5A            ld   e,d
4F6E  8C            adc  a,h
4F6F  00            nop
4F70  00            nop
4F71  00            nop
4F72  00            nop
4F73  00            nop
4F74  00            nop
4F75  92            sub  d
4F76  7A            ld   a,d
4F77  8E            adc  a,(hl)
4F78  91            sub  c
4F79  1A            ld   a,(de)
4F7A  8D            adc  a,l
4F7B  00            nop
4F7C  00            nop
4F7D  00            nop
4F7E  91            sub  c
4F7F  5A            ld   e,d
4F80  8D            adc  a,l
4F81  00            nop
4F82  00            nop
4F83  00            nop
4F84  00            nop
4F85  00            nop
4F86  00            nop
4F87  92            sub  d
4F88  EE83          xor  $83
4F8A  92            sub  d
4F8B  17            rla
4F8C  8E            adc  a,(hl)
4F8D  00            nop
4F8E  00            nop
4F8F  00            nop
4F90  91            sub  c
4F91  D28D00        jp   nc,$008D
4F94  00            nop
4F95  00            nop
4F96  00            nop
4F97  00            nop
4F98  00            nop
4F99  91            sub  c
4F9A  5A            ld   e,d
4F9B  8D            adc  a,l
4F9C  00            nop
4F9D  00            nop
4F9E  00            nop
4F9F  00            nop
4FA0  00            nop
4FA1  00            nop
4FA2  92            sub  d
4FA3  EE83          xor  $83
4FA5  92            sub  d
4FA6  17            rla
4FA7  8E            adc  a,(hl)
4FA8  00            nop
4FA9  00            nop
4FAA  00            nop
4FAB  91            sub  c
4FAC  D28D00        jp   nc,$008D
4FAF  00            nop
4FB0  00            nop
4FB1  00            nop
4FB2  00            nop
4FB3  00            nop
4FB4  92            sub  d
4FB5  17            rla
4FB6  8C            adc  a,h
4FB7  92            sub  d
4FB8  318D92        ld   sp,$928D
4FBB  2B            dec  hl
4FBC  8F            adc  a,a
4FBD  90            sub  b
4FBE  CB8E          res  1,(hl)
4FC0  91            sub  c
4FC1  8E            adc  a,(hl)
4FC2  8C            adc  a,h
4FC3  00            nop
4FC4  00            nop
4FC5  00            nop
4FC6  91            sub  c
4FC7  D28D00        jp   nc,$008D
4FCA  00            nop
4FCB  00            nop
4FCC  00            nop
4FCD  00            nop
4FCE  00            nop
4FCF  92            sub  d
4FD0  17            rla
4FD1  8C            adc  a,h
4FD2  92            sub  d
4FD3  318D92        ld   sp,$928D
4FD6  2B            dec  hl
4FD7  8F            adc  a,a
4FD8  90            sub  b
4FD9  CB8E          res  1,(hl)
4FDB  91            sub  c
4FDC  8E            adc  a,(hl)
4FDD  8C            adc  a,h
4FDE  92            sub  d
4FDF  AB            xor  e
4FE0  8E            adc  a,(hl)
4FE1  91            sub  c
4FE2  D28D00        jp   nc,$008D
4FE5  00            nop
4FE6  00            nop
4FE7  00            nop
4FE8  00            nop
4FE9  00            nop
4FEA  00            nop
4FEB  00            nop
4FEC  00            nop
4FED  00            nop
4FEE  00            nop
4FEF  00            nop
4FF0  00            nop
4FF1  00            nop
4FF2  00            nop
4FF3  00            nop
4FF4  00            nop
4FF5  00            nop
4FF6  00            nop
4FF7  00            nop
4FF8  00            nop
4FF9  00            nop
4FFA  00            nop
4FFB  00            nop
4FFC  00            nop
4FFD  00            nop
4FFE  FF            rst  $38
4FFF  FF            rst  $38
5000  46            ld   b,(hl)
5001  23            inc  hl
5002  4E            ld   c,(hl)
5003  23            inc  hl
5004  0A            ld   a,(bc)
5005  FE10          cp   $10
5007  2811          jr   z,$501A
5009  5F            ld   e,a
500A  E6F0          and  $F0
500C  FE80          cp   $80
500E  2006          jr   nz,$5016
5010  7B            ld   a,e
5011  C610          add  a,$10
5013  02            ld   (bc),a
5014  1804          jr   $501A
5016  7B            ld   a,e
5017  D610          sub  $10
5019  02            ld   (bc),a
501A  23            inc  hl
501B  C9            ret
501C  3D            dec  a
501D  3D            dec  a
501E  77            ld   (hl),a
501F  C9            ret
5020  3A1283        ld   a,($8312)
5023  E603          and  $03
5025  C0            ret  nz
5026  21004F        ld   hl,$4F00
5029  3A0480        ld   a,($8004)
502C  A7            and  a
502D  2805          jr   z,$5034
502F  3A2A80        ld   a,($802A)
5032  1803          jr   $5037
5034  3A2980        ld   a,($8029)
5037  3D            dec  a
5038  47            ld   b,a
5039  87            add  a,a
503A  87            add  a,a
503B  87            add  a,a
503C  80            add  a,b
503D  85            add  a,l
503E  6F            ld   l,a
503F  7E            ld   a,(hl)
5040  A7            and  a
5041  C8            ret  z
5042  CD0050        call $5000
5045  7E            ld   a,(hl)
5046  A7            and  a
5047  C8            ret  z
5048  CD0050        call $5000
504B  7E            ld   a,(hl)
504C  A7            and  a
504D  C8            ret  z
504E  CD0050        call $5000
5051  C9            ret
5052  FF            rst  $38
5053  03            inc  bc
5054  84            add  a,h
5055  50            ld   d,b
5056  90            sub  b
5057  50            ld   d,b
5058  8C            adc  a,h
5059  50            ld   d,b
505A  FF            rst  $38
505B  FF            rst  $38
505C  FF            rst  $38
505D  FF            rst  $38
505E  FF            rst  $38
505F  FF            rst  $38
5060  0C            inc  c
5061  010E01        ld   bc,$010E
5064  1001          djnz $5067
5066  110113        ld   de,$1301
5069  03            inc  bc
506A  FF            rst  $38
506B  FF            rst  $38
506C  13            inc  de
506D  011501        ld   bc,$0115
5070  17            rla
5071  011801        ld   bc,$0118
5074  1A            ld   a,(de)
5075  03            inc  bc
5076  FF            rst  $38
5077  FF            rst  $38
5078  1801          jr   $507B
507A  1A            ld   a,(de)
507B  011C01        ld   bc,$011C
507E  1D            dec  e
507F  011F03        ld   bc,$031F
5082  FF            rst  $38
5083  FF            rst  $38
5084  02            ld   (bc),a
5085  02            ld   (bc),a
5086  0F            rrca
5087  1060          djnz $50E9
5089  50            ld   d,b
508A  FF            rst  $38
508B  FF            rst  $38
508C  6E            ld   l,(hl)
508D  50            ld   d,b
508E  FF            rst  $38
508F  FF            rst  $38
5090  6C            ld   l,h
5091  50            ld   d,b
5092  FF            rst  $38
5093  FF            rst  $38
5094  00            nop
5095  010201        ld   bc,$0102
5098  04            inc  b
5099  010601        ld   bc,$0106
509C  08            ex   af,af'
509D  010A01        ld   bc,$010A
50A0  0C            inc  c
50A1  010E01        ld   bc,$010E
50A4  FF            rst  $38
50A5  FF            rst  $38
50A6  FF            rst  $38
50A7  FF            rst  $38
50A8  FF            rst  $38
50A9  FF            rst  $38
50AA  FF            rst  $38
50AB  FF            rst  $38
50AC  FF            rst  $38
50AD  FF            rst  $38
50AE  FF            rst  $38
50AF  FF            rst  $38
50B0  01010F        ld   bc,$0F01
50B3  00            nop
50B4  94            sub  h
50B5  50            ld   d,b
50B6  FF            rst  $38
50B7  FF            rst  $38
50B8  94            sub  h
50B9  10FF          djnz $50BA
50BB  FF            rst  $38
50BC  03            inc  bc
50BD  B0            or   b
50BE  50            ld   d,b
50BF  C8            ret  z
50C0  50            ld   d,b
50C1  C8            ret  z
50C2  50            ld   d,b
50C3  FF            rst  $38
50C4  FF            rst  $38
50C5  FF            rst  $38
50C6  FF            rst  $38
50C7  FF            rst  $38
50C8  AC            xor  h
50C9  50            ld   d,b
50CA  FF            rst  $38
50CB  FF            rst  $38
50CC  1801          jr   $50CF
50CE  17            rla
50CF  011501        ld   bc,$0115
50D2  13            inc  de
50D3  011101        ld   bc,$0111
50D6  1001          djnz $50D9
50D8  0E01          ld   c,$01
50DA  0C            inc  c
50DB  010B01        ld   bc,$010B
50DE  09            add  hl,bc
50DF  010701        ld   bc,$0107
50E2  05            dec  b
50E3  010401        ld   bc,$0104
50E6  02            ld   (bc),a
50E7  010001        ld   bc,$0100
50EA  FF            rst  $38
50EB  FF            rst  $38
50EC  03            inc  bc
50ED  F450F4        call p,$F450
50F0  51            ld   d,c
50F1  F451FF        call p,$FF51
50F4  03            inc  bc
50F5  03            inc  bc
50F6  0F            rrca
50F7  10CC          djnz $50C5
50F9  50            ld   d,b
50FA  FF            rst  $38
50FB  FF            rst  $38
50FC  2B            dec  hl
50FD  02            ld   (bc),a
50FE  34            inc  (hl)
50FF  02            ld   (bc),a
5100  34            inc  (hl)
5101  02            ld   (bc),a
5102  34            inc  (hl)
5103  02            ld   (bc),a
5104  320134        ld   ($3401),a
5107  013201        ld   bc,$0132
510A  3001          jr   nc,$510D
510C  2F            cpl
510D  012D01        ld   bc,$012D
5110  2B            dec  hl
5111  02            ld   (bc),a
5112  2D            dec  l
5113  02            ld   (bc),a
5114  2D            dec  l
5115  02            ld   (bc),a
5116  320134        ld   ($3401),a
5119  012602        ld   bc,$0226
511C  FF            rst  $38
511D  FF            rst  $38
511E  37            scf
511F  02            ld   (bc),a
5120  2F            cpl
5121  02            ld   (bc),a
5122  3204FF        ld   ($FF04),a
5125  FF            rst  $38
5126  2B            dec  hl
5127  012601        ld   bc,$0126
512A  23            inc  hl
512B  012601        ld   bc,$0126
512E  1F            rra
512F  04            inc  b
5130  FF            rst  $38
5131  FF            rst  $38
5132  0C            inc  c
5133  011001        ld   bc,$0110
5136  13            inc  de
5137  011001        ld   bc,$0110
513A  0C            inc  c
513B  010C01        ld   bc,$010C
513E  0E01          ld   c,$01
5140  1001          djnz $5143
5142  0B            dec  bc
5143  010C01        ld   bc,$010C
5146  0B            dec  bc
5147  010901        ld   bc,$0109
514A  07            rlca
514B  010701        ld   bc,$0107
514E  09            add  hl,bc
514F  010B01        ld   bc,$010B
5152  09            add  hl,bc
5153  010B01        ld   bc,$010B
5156  09            add  hl,bc
5157  010701        ld   bc,$0107
515A  0601          ld   b,$01
515C  0601          ld   b,$01
515E  07            rlca
515F  010901        ld   bc,$0109
5162  FF            rst  $38
5163  FF            rst  $38
5164  07            rlca
5165  010701        ld   bc,$0107
5168  0B            dec  bc
5169  010C01        ld   bc,$010C
516C  0E01          ld   c,$01
516E  07            rlca
516F  010B01        ld   bc,$010B
5172  0E01          ld   c,$01
5174  FF            rst  $38
5175  FF            rst  $38
5176  07            rlca
5177  010C01        ld   bc,$010C
517A  0B            dec  bc
517B  010901        ld   bc,$0109
517E  07            rlca
517F  04            inc  b
5180  FF            rst  $38
5181  FF            rst  $38
5182  01080F        ld   bc,$0F08
5185  00            nop
5186  32511E        ld   ($1E51),a
5189  51            ld   d,c
518A  FC5026        call m,$2650
518D  51            ld   d,c
518E  FC501E        call m,$1E50
5191  51            ld   d,c
5192  FC5026        call m,$2650
5195  51            ld   d,c
5196  FF            rst  $38
5197  FF            rst  $38
5198  FF            rst  $38
5199  FF            rst  $38
519A  02            ld   (bc),a
519B  82            add  a,d
519C  51            ld   d,c
519D  A8            xor  b
519E  51            ld   d,c
519F  A8            xor  b
51A0  51            ld   d,c
51A1  FF            rst  $38
51A2  FF            rst  $38
51A3  98            sbc  a,b
51A4  11FFFF        ld   de,$FFFF
51A7  FF            rst  $38
51A8  FC5064        call m,$6450
51AB  51            ld   d,c
51AC  325176        ld   ($7651),a
51AF  51            ld   d,c
51B0  325164        ld   ($6451),a
51B3  51            ld   d,c
51B4  325176        ld   ($7651),a
51B7  51            ld   d,c
51B8  FF            rst  $38
51B9  FF            rst  $38
51BA  0C            inc  c
51BB  02            ld   (bc),a
51BC  1802          jr   $51C0
51BE  0C            inc  c
51BF  02            ld   (bc),a
51C0  1802          jr   $51C4
51C2  0C            inc  c
51C3  02            ld   (bc),a
51C4  1802          jr   $51C8
51C6  0C            inc  c
51C7  02            ld   (bc),a
51C8  1802          jr   $51CC
51CA  0C            inc  c
51CB  02            ld   (bc),a
51CC  1802          jr   $51D0
51CE  0C            inc  c
51CF  02            ld   (bc),a
51D0  1802          jr   $51D4
51D2  0C            inc  c
51D3  02            ld   (bc),a
51D4  1802          jr   $51D8
51D6  FF            rst  $38
51D7  FF            rst  $38
51D8  FF            rst  $38
51D9  FF            rst  $38
51DA  03            inc  bc
51DB  03            inc  bc
51DC  0F            rrca
51DD  10BA          djnz $5199
51DF  51            ld   d,c
51E0  FF            rst  $38
51E1  FF            rst  $38
51E2  CA11FF        jp   z,$FF11
51E5  FF            rst  $38
51E6  F8            ret  m
51E7  51            ld   d,c
51E8  FF            rst  $38
51E9  FF            rst  $38
51EA  03            inc  bc
51EB  DA51E6        jp   c,$E651
51EE  51            ld   d,c
51EF  F451FF        call p,$FF51
51F2  FF            rst  $38
51F3  FF            rst  $38
51F4  F8            ret  m
51F5  51            ld   d,c
51F6  FF            rst  $38
51F7  FF            rst  $38
51F8  FF            rst  $38
51F9  FF            rst  $38
51FA  FF            rst  $38
51FB  FF            rst  $38
51FC  FF            rst  $38
51FD  FF            rst  $38
51FE  FF            rst  $38
51FF  FF            rst  $38
5200  DDE5          push ix
5202  E1            pop  hl
5203  7D            ld   a,l
5204  FEE8          cp   $E8
5206  2007          jr   nz,$520F
5208  3E02          ld   a,$02
520A  325580        ld   ($8055),a
520D  1816          jr   $5225
520F  3A5580        ld   a,($8055)
5212  A7            and  a
5213  2810          jr   z,$5225
5215  3D            dec  a
5216  325580        ld   ($8055),a
5219  3A5280        ld   a,($8052)
521C  A7            and  a
521D  2804          jr   z,$5223
521F  3D            dec  a
5220  325280        ld   ($8052),a
5223  E1            pop  hl
5224  C9            ret
5225  7D            ld   a,l
5226  FED0          cp   $D0
5228  2007          jr   nz,$5231
522A  3E02          ld   a,$02
522C  325280        ld   ($8052),a
522F  180C          jr   $523D
5231  3A5280        ld   a,($8052)
5234  A7            and  a
5235  2806          jr   z,$523D
5237  3D            dec  a
5238  325280        ld   ($8052),a
523B  E1            pop  hl
523C  C9            ret
523D  DD7E10        ld   a,(ix+$10)
5240  C9            ret
5241  FF            rst  $38
5242  FF            rst  $38
5243  FF            rst  $38
5244  FF            rst  $38
5245  FF            rst  $38
5246  FF            rst  $38
5247  FF            rst  $38
5248  FF            rst  $38
5249  FF            rst  $38
524A  FF            rst  $38
524B  FF            rst  $38
524C  FF            rst  $38
524D  FF            rst  $38
524E  FF            rst  $38
524F  FF            rst  $38
5250  DDE5          push ix
5252  E1            pop  hl
5253  7D            ld   a,l
5254  FEE8          cp   $E8
5256  2007          jr   nz,$525F
5258  3E02          ld   a,$02
525A  325680        ld   ($8056),a
525D  1816          jr   $5275
525F  3A5680        ld   a,($8056)
5262  A7            and  a
5263  2810          jr   z,$5275
5265  3D            dec  a
5266  325680        ld   ($8056),a
5269  3A5380        ld   a,($8053)
526C  A7            and  a
526D  2804          jr   z,$5273
526F  3D            dec  a
5270  325380        ld   ($8053),a
5273  E1            pop  hl
5274  C9            ret
5275  7D            ld   a,l
5276  FED0          cp   $D0
5278  2007          jr   nz,$5281
527A  3E02          ld   a,$02
527C  325380        ld   ($8053),a
527F  180C          jr   $528D
5281  3A5380        ld   a,($8053)
5284  A7            and  a
5285  2806          jr   z,$528D
5287  3D            dec  a
5288  325380        ld   ($8053),a
528B  E1            pop  hl
528C  C9            ret
528D  DD7E10        ld   a,(ix+$10)
5290  C9            ret
5291  FF            rst  $38
5292  FF            rst  $38
5293  FF            rst  $38
5294  FF            rst  $38
5295  FF            rst  $38
5296  FF            rst  $38
5297  FF            rst  $38
5298  FF            rst  $38
5299  FF            rst  $38
529A  FF            rst  $38
529B  FF            rst  $38
529C  FF            rst  $38
529D  FF            rst  $38
529E  FF            rst  $38
529F  FF            rst  $38
52A0  DDE5          push ix
52A2  E1            pop  hl
52A3  7D            ld   a,l
52A4  FEE8          cp   $E8
52A6  2007          jr   nz,$52AF
52A8  3E02          ld   a,$02
52AA  325780        ld   ($8057),a
52AD  1816          jr   $52C5
52AF  3A5780        ld   a,($8057)
52B2  A7            and  a
52B3  2810          jr   z,$52C5
52B5  3D            dec  a
52B6  325780        ld   ($8057),a
52B9  3A5480        ld   a,($8054)
52BC  A7            and  a
52BD  2804          jr   z,$52C3
52BF  3D            dec  a
52C0  325480        ld   ($8054),a
52C3  E1            pop  hl
52C4  C9            ret
52C5  7D            ld   a,l
52C6  FED0          cp   $D0
52C8  2007          jr   nz,$52D1
52CA  3E02          ld   a,$02
52CC  325480        ld   ($8054),a
52CF  180C          jr   $52DD
52D1  3A5480        ld   a,($8054)
52D4  A7            and  a
52D5  2806          jr   z,$52DD
52D7  3D            dec  a
52D8  325480        ld   ($8054),a
52DB  E1            pop  hl
52DC  C9            ret
52DD  DD7E10        ld   a,(ix+$10)
52E0  C9            ret
52E1  FF            rst  $38
52E2  CDB04E        call $4EB0
52E5  214081        ld   hl,$8140
52E8  36D8          ld   (hl),$D8
52EA  23            inc  hl
52EB  368D          ld   (hl),$8D
52ED  23            inc  hl
52EE  3611          ld   (hl),$11
52F0  23            inc  hl
52F1  36E0          ld   (hl),$E0
52F3  23            inc  hl
52F4  36D8          ld   (hl),$D8
52F6  23            inc  hl
52F7  368D          ld   (hl),$8D
52F9  23            inc  hl
52FA  3611          ld   (hl),$11
52FC  23            inc  hl
52FD  36F0          ld   (hl),$F0
52FF  1E06          ld   e,$06
5301  CD2853        call $5328
5304  1D            dec  e
5305  20FA          jr   nz,$5301
5307  214881        ld   hl,$8148
530A  3620          ld   (hl),$20
530C  23            inc  hl
530D  362D          ld   (hl),$2D
530F  23            inc  hl
5310  3612          ld   (hl),$12
5312  23            inc  hl
5313  3628          ld   (hl),$28
5315  23            inc  hl
5316  3619          ld   (hl),$19
5318  23            inc  hl
5319  3630          ld   (hl),$30
531B  23            inc  hl
531C  3612          ld   (hl),$12
531E  23            inc  hl
531F  3638          ld   (hl),$38
5321  CDAC53        call $53AC
5324  C32854        jp   $5428
5327  FF            rst  $38
5328  1600          ld   d,$00
532A  218053        ld   hl,$5380
532D  7A            ld   a,d
532E  87            add  a,a
532F  87            add  a,a
5330  85            add  a,l
5331  6F            ld   l,a
5332  DD214081      ld   ix,$8140
5336  7E            ld   a,(hl)
5337  DD7701        ld   (ix+$01),a
533A  23            inc  hl
533B  7E            ld   a,(hl)
533C  DD7705        ld   (ix+$05),a
533F  23            inc  hl
5340  7E            ld   a,(hl)
5341  DD8600        add  a,(ix+$00)
5344  DD7700        ld   (ix+$00),a
5347  DD7704        ld   (ix+$04),a
534A  23            inc  hl
534B  7E            ld   a,(hl)
534C  DD8603        add  a,(ix+$03)
534F  DD7703        ld   (ix+$03),a
5352  D610          sub  $10
5354  DD7707        ld   (ix+$07),a
5357  D5            push de
5358  212821        ld   hl,$2128
535B  CD815C        call $5C81
535E  212821        ld   hl,$2128
5361  CD815C        call $5C81
5364  212821        ld   hl,$2128
5367  CD815C        call $5C81
536A  D1            pop  de
536B  14            inc  d
536C  7A            ld   a,d
536D  FE06          cp   $06
536F  20B9          jr   nz,$532A
5371  CDD44E        call $4ED4
5374  C9            ret
5375  FF            rst  $38
5376  FF            rst  $38
5377  FF            rst  $38
5378  FF            rst  $38
5379  FF            rst  $38
537A  FF            rst  $38
537B  FF            rst  $38
537C  FF            rst  $38
537D  FF            rst  $38
537E  FF            rst  $38
537F  FF            rst  $38
5380  8D            adc  a,l
5381  8C            adc  a,h
5382  FCF48F        call m,$8FF4
5385  8E            adc  a,(hl)
5386  FCF691        call m,$91F6
5389  90            sub  b
538A  FCF896        call m,$96F8
538D  92            sub  d
538E  FCF894        call m,$94F8
5391  93            sub  e
5392  FC068D        call m,$8D06
5395  8C            adc  a,h
5396  FC083A        call m,$3A08
5399  49            ld   c,c
539A  81            add  a,c
539B  FE2D          cp   $2D
539D  2007          jr   nz,$53A6
539F  3E2C          ld   a,$2C
53A1  324981        ld   ($8149),a
53A4  1805          jr   $53AB
53A6  3E2D          ld   a,$2D
53A8  324981        ld   ($8149),a
53AB  C9            ret
53AC  1E06          ld   e,$06
53AE  CDB853        call $53B8
53B1  CD9853        call $5398
53B4  1D            dec  e
53B5  20F7          jr   nz,$53AE
53B7  C9            ret
53B8  1600          ld   d,$00
53BA  210854        ld   hl,$5408
53BD  7A            ld   a,d
53BE  87            add  a,a
53BF  87            add  a,a
53C0  85            add  a,l
53C1  6F            ld   l,a
53C2  DD214081      ld   ix,$8140
53C6  7E            ld   a,(hl)
53C7  DD7701        ld   (ix+$01),a
53CA  23            inc  hl
53CB  7E            ld   a,(hl)
53CC  DD7705        ld   (ix+$05),a
53CF  23            inc  hl
53D0  7E            ld   a,(hl)
53D1  DD8600        add  a,(ix+$00)
53D4  DD7700        ld   (ix+$00),a
53D7  DD7704        ld   (ix+$04),a
53DA  23            inc  hl
53DB  7E            ld   a,(hl)
53DC  DD8603        add  a,(ix+$03)
53DF  DD7703        ld   (ix+$03),a
53E2  D610          sub  $10
53E4  DD7707        ld   (ix+$07),a
53E7  D5            push de
53E8  212821        ld   hl,$2128
53EB  CD815C        call $5C81
53EE  212821        ld   hl,$2128
53F1  CD815C        call $5C81
53F4  212821        ld   hl,$2128
53F7  CD815C        call $5C81
53FA  D1            pop  de
53FB  14            inc  d
53FC  7A            ld   a,d
53FD  FE06          cp   $06
53FF  20B9          jr   nz,$53BA
5401  CDC24E        call $4EC2
5404  C9            ret
5405  FF            rst  $38
5406  FF            rst  $38
5407  FF            rst  $38
5408  0D            dec  c
5409  0C            inc  c
540A  04            inc  b
540B  F8            ret  m
540C  0F            rrca
540D  0E04          ld   c,$04
540F  00            nop
5410  111004        ld   de,$0410
5413  08            ex   af,af'
5414  1612          ld   d,$12
5416  04            inc  b
5417  08            ex   af,af'
5418  14            inc  d
5419  13            inc  de
541A  04            inc  b
541B  08            ex   af,af'
541C  0D            dec  c
541D  0C            inc  c
541E  04            inc  b
541F  08            ex   af,af'
5420  FF            rst  $38
5421  FF            rst  $38
5422  FF            rst  $38
5423  FF            rst  $38
5424  FF            rst  $38
5425  FF            rst  $38
5426  FF            rst  $38
5427  FF            rst  $38
5428  21D015        ld   hl,$15D0
542B  CD815C        call $5C81
542E  C9            ret
542F  FF            rst  $38
5430  212492        ld   hl,$9224
5433  CD084D        call $4D08
5436  E5            push hl
5437  CDC254        call $54C2
543A  00            nop
543B  00            nop
543C  00            nop
543D  E1            pop  hl
543E  23            inc  hl
543F  3E39          ld   a,$39
5441  BD            cp   l
5442  20EF          jr   nz,$5433
5444  3E38          ld   a,$38
5446  324181        ld   ($8141),a
5449  3C            inc  a
544A  324581        ld   ($8145),a
544D  C9            ret
544E  FF            rst  $38
544F  FF            rst  $38
5450  DD214081      ld   ix,$8140
5454  3E79          ld   a,$79
5456  DDBE00        cp   (ix+$00)
5459  C8            ret  z
545A  DD3400        inc  (ix+$00)
545D  DD3404        inc  (ix+$04)
5460  3A1283        ld   a,($8312)
5463  E603          and  $03
5465  2024          jr   nz,$548B
5467  DD7E05        ld   a,(ix+$05)
546A  3C            inc  a
546B  FE33          cp   $33
546D  2002          jr   nz,$5471
546F  3E31          ld   a,$31
5471  DD7705        ld   (ix+$05),a
5474  3A1283        ld   a,($8312)
5477  E60F          and  $0F
5479  FE05          cp   $05
547B  2006          jr   nz,$5483
547D  DD36012C      ld   (ix+$01),$2C
5481  1808          jr   $548B
5483  FE08          cp   $08
5485  2004          jr   nz,$548B
5487  DD36012D      ld   (ix+$01),$2D
548B  CDC254        call $54C2
548E  00            nop
548F  00            nop
5490  00            nop
5491  18BD          jr   $5450
5493  FF            rst  $38
5494  214081        ld   hl,$8140
5497  3607          ld   (hl),$07
5499  23            inc  hl
549A  362D          ld   (hl),$2D
549C  23            inc  hl
549D  3612          ld   (hl),$12
549F  23            inc  hl
54A0  36BF          ld   (hl),$BF
54A2  23            inc  hl
54A3  3600          ld   (hl),$00
54A5  23            inc  hl
54A6  3630          ld   (hl),$30
54A8  23            inc  hl
54A9  3612          ld   (hl),$12
54AB  23            inc  hl
54AC  36CF          ld   (hl),$CF
54AE  212492        ld   hl,$9224
54B1  CD084D        call $4D08
54B4  CD5054        call $5450
54B7  CDD854        call $54D8
54BA  CD3054        call $5430
54BD  CDD854        call $54D8
54C0  C9            ret
54C1  FF            rst  $38
54C2  3A1283        ld   a,($8312)
54C5  E603          and  $03
54C7  2006          jr   nz,$54CF
54C9  216415        ld   hl,$1564
54CC  CD815C        call $5C81
54CF  212821        ld   hl,$2128
54D2  CD815C        call $5C81
54D5  C9            ret
54D6  FF            rst  $38
54D7  FF            rst  $38
54D8  1E20          ld   e,$20
54DA  D5            push de
54DB  CDC254        call $54C2
54DE  D1            pop  de
54DF  1D            dec  e
54E0  20F8          jr   nz,$54DA
54E2  C9            ret
54E3  FF            rst  $38
54E4  2D            dec  l
54E5  02            ld   (bc),a
54E6  2D            dec  l
54E7  012D01        ld   bc,$012D
54EA  2D            dec  l
54EB  02            ld   (bc),a
54EC  2A022D        ld   hl,($2D02)
54EF  02            ld   (bc),a
54F0  3204FF        ld   ($FF04),a
54F3  FF            rst  $38
54F4  210221        ld   hl,$2102
54F7  012101        ld   bc,$0121
54FA  21021E        ld   hl,$1E02
54FD  02            ld   (bc),a
54FE  210226        ld   hl,$2602
5501  04            inc  b
5502  FF            rst  $38
5503  FF            rst  $38
5504  01030F        ld   bc,$0F03
5507  00            nop
5508  E454FF        call po,$FF54
550B  FF            rst  $38
550C  F454FF        call p,$FF54
550F  FF            rst  $38
5510  6C            ld   l,h
5511  55            ld   d,l
5512  FF            rst  $38
5513  FF            rst  $38
5514  03            inc  bc
5515  04            inc  b
5516  55            ld   d,l
5517  08            ex   af,af'
5518  55            ld   d,l
5519  08            ex   af,af'
551A  55            ld   d,l
551B  FF            rst  $38
551C  FF            rst  $38
551D  FF            rst  $38
551E  FF            rst  $38
551F  FF            rst  $38
5520  AF            xor  a
5521  324680        ld   ($8046),a
5524  3AA582        ld   a,($82A5)
5527  A7            and  a
5528  2005          jr   nz,$552F
552A  3EF9          ld   a,$F9
552C  00            nop
552D  00            nop
552E  00            nop
552F  3AAD82        ld   a,($82AD)
5532  A7            and  a
5533  2005          jr   nz,$553A
5535  3EFD          ld   a,$FD
5537  00            nop
5538  00            nop
5539  00            nop
553A  3AB582        ld   a,($82B5)
553D  A7            and  a
553E  2005          jr   nz,$5545
5540  3EFB          ld   a,$FB
5542  00            nop
5543  00            nop
5544  00            nop
5545  3EFF          ld   a,$FF
5547  00            nop
5548  00            nop
5549  00            nop
554A  C9            ret
554B  FF            rst  $38
554C  FF            rst  $38
554D  FF            rst  $38
554E  FF            rst  $38
554F  FF            rst  $38
5550  1001          djnz $5553
5552  0B            dec  bc
5553  010801        ld   bc,$0108
5556  FF            rst  $38
5557  FF            rst  $38
5558  04            inc  b
5559  04            inc  b
555A  0F            rrca
555B  1050          djnz $55AD
555D  55            ld   d,l
555E  FF            rst  $38
555F  FF            rst  $38
5560  03            inc  bc
5561  58            ld   e,b
5562  55            ld   d,l
5563  5C            ld   e,h
5564  55            ld   d,l
5565  5C            ld   e,h
5566  55            ld   d,l
5567  FF            rst  $38
5568  6A            ld   l,d
5569  55            ld   d,l
556A  FF            rst  $38
556B  FF            rst  $38
556C  FF            rst  $38
556D  FF            rst  $38
556E  FF            rst  $38
556F  FF            rst  $38
5570  3A00B8        ld   a,(watchdog)
5573  214090        ld   hl,$9040
5576  C1            pop  bc
5577  0A            ld   a,(bc)
5578  03            inc  bc
5579  85            add  a,l
557A  6F            ld   l,a
557B  0A            ld   a,(bc)
557C  5F            ld   e,a
557D  3E1B          ld   a,$1B
557F  93            sub  e
5580  5F            ld   e,a
5581  1600          ld   d,$00
5583  CB23          sla  e
5585  CB23          sla  e
5587  CB23          sla  e
5589  19            add  hl,de
558A  19            add  hl,de
558B  19            add  hl,de
558C  19            add  hl,de
558D  03            inc  bc
558E  0A            ld   a,(bc)
558F  03            inc  bc
5590  FEFF          cp   $FF
5592  2002          jr   nz,$5596
5594  C5            push bc
5595  C9            ret
5596  77            ld   (hl),a
5597  16FF          ld   d,$FF
5599  1EE0          ld   e,$E0
559B  19            add  hl,de
559C  18F0          jr   $558E
559E  FF            rst  $38
559F  FF            rst  $38
55A0  217014        ld   hl,reset_xoff_sprites_and_clear_screen
55A3  CD815C        call $5C81
55A6  CDD056        call $56D0
55A9  00            nop
55AA  00            nop
55AB  00            nop
55AC  CDA85A        call $5AA8
55AF  CD7055        call $5570
55B2  08            ex   af,af'
55B3  0B            dec  bc
55B4  12            ld   (de),a
55B5  15            dec  d
55B6  27            daa
55B7  112215        ld   de,$1522
55BA  FF            rst  $38
55BB  CDA85A        call $5AA8
55BE  CD7055        call $5570
55C1  0C            inc  c
55C2  05            dec  b
55C3  29            add  hl,hl
55C4  1F            rra
55C5  25            dec  h
55C6  221012        ld   ($1210),hl
55C9  15            dec  d
55CA  19            add  hl,de
55CB  1E17          ld   e,$17
55CD  1013          djnz $55E2
55CF  1811          jr   $55E2
55D1  23            inc  hl
55D2  15            dec  d
55D3  14            inc  d
55D4  FF            rst  $38
55D5  CDA85A        call $5AA8
55D8  CD7055        call $5570
55DB  1007          djnz $55E4
55DD  12            ld   (de),a
55DE  29            add  hl,hl
55DF  1011          djnz $55F2
55E1  1014          djnz $55F7
55E3  19            add  hl,de
55E4  1E1F          ld   e,$1F
55E6  23            inc  hl
55E7  112522        ld   de,$2225
55EA  FF            rst  $38
55EB  C3B248        jp   $48B2
55EE  FF            rst  $38
55EF  FF            rst  $38
55F0  A1            and  c
55F1  02            ld   (bc),a
55F2  C302A1        jp   $A102
55F5  02            ld   (bc),a
55F6  C302A1        jp   $A102
55F9  02            ld   (bc),a
55FA  C302A1        jp   $A102
55FD  02            ld   (bc),a
55FE  C302FF        jp   $FF02
5601  FF            rst  $38
5602  FF            rst  $38
5603  FF            rst  $38
5604  00            nop
5605  02            ld   (bc),a
5606  FF            rst  $38
5607  FF            rst  $38
5608  FF            rst  $38
5609  FF            rst  $38
560A  FF            rst  $38
560B  FF            rst  $38
560C  0E0E          ld   c,$0E
560E  FF            rst  $38
560F  FF            rst  $38
5610  E0            ret  po
5611  15            dec  d
5612  FF            rst  $38
5613  FF            rst  $38
5614  44            ld   b,h
5615  15            dec  d
5616  48            ld   c,b
5617  15            dec  d
5618  48            ld   c,b
5619  15            dec  d
561A  A0            and  b
561B  15            dec  d
561C  A0            and  b
561D  15            dec  d
561E  EE09          xor  $09
5620  FF            rst  $38
5621  FF            rst  $38
5622  70            ld   (hl),b
5623  1870          jr   $5695
5625  1830          jr   $5657
5627  17            rla
5628  B0            or   b
5629  18EE          jr   $5619
562B  05            dec  b
562C  FF            rst  $38
562D  FF            rst  $38
562E  FF            rst  $38
562F  FF            rst  $38
5630  0E02          ld   c,$02
5632  13            inc  de
5633  04            inc  b
5634  13            inc  de
5635  04            inc  b
5636  13            inc  de
5637  02            ld   (bc),a
5638  13            inc  de
5639  061A          ld   b,$1A
563B  04            inc  b
563C  1A            ld   a,(de)
563D  04            inc  b
563E  1A            ld   a,(de)
563F  02            ld   (bc),a
5640  1E06          ld   e,$06
5642  1C            inc  e
5643  04            inc  b
5644  1E02          ld   e,$02
5646  1C            inc  e
5647  02            ld   (bc),a
5648  1A            ld   a,(de)
5649  0617          ld   b,$17
564B  04            inc  b
564C  FF            rst  $38
564D  FF            rst  $38
564E  FF            rst  $38
564F  FF            rst  $38
5650  13            inc  de
5651  02            ld   (bc),a
5652  17            rla
5653  02            ld   (bc),a
5654  1802          jr   $5658
5656  1A            ld   a,(de)
5657  02            ld   (bc),a
5658  1A            ld   a,(de)
5659  04            inc  b
565A  1A            ld   a,(de)
565B  04            inc  b
565C  1A            ld   a,(de)
565D  061A          ld   b,$1A
565F  02            ld   (bc),a
5660  1806          jr   $5668
5662  1804          jr   $5668
5664  1802          jr   $5668
5666  1802          jr   $566A
5668  1802          jr   $566C
566A  17            rla
566B  02            ld   (bc),a
566C  17            rla
566D  02            ld   (bc),a
566E  13            inc  de
566F  04            inc  b
5670  17            rla
5671  04            inc  b
5672  1802          jr   $5676
5674  0E02          ld   c,$02
5676  FF            rst  $38
5677  FF            rst  $38
5678  09            add  hl,bc
5679  02            ld   (bc),a
567A  0B            dec  bc
567B  04            inc  b
567C  0B            dec  bc
567D  04            inc  b
567E  0B            dec  bc
567F  02            ld   (bc),a
5680  0C            inc  c
5681  0615          ld   b,$15
5683  04            inc  b
5684  15            dec  d
5685  04            inc  b
5686  15            dec  d
5687  02            ld   (bc),a
5688  1A            ld   a,(de)
5689  0618          ld   b,$18
568B  04            inc  b
568C  1A            ld   a,(de)
568D  02            ld   (bc),a
568E  1802          jr   $5692
5690  15            dec  d
5691  0613          ld   b,$13
5693  04            inc  b
5694  FF            rst  $38
5695  FF            rst  $38
5696  0E02          ld   c,$02
5698  13            inc  de
5699  02            ld   (bc),a
569A  13            inc  de
569B  02            ld   (bc),a
569C  15            dec  d
569D  02            ld   (bc),a
569E  15            dec  d
569F  04            inc  b
56A0  15            dec  d
56A1  04            inc  b
56A2  15            dec  d
56A3  0615          ld   b,$15
56A5  02            ld   (bc),a
56A6  13            inc  de
56A7  0613          ld   b,$13
56A9  04            inc  b
56AA  13            inc  de
56AB  02            ld   (bc),a
56AC  13            inc  de
56AD  02            ld   (bc),a
56AE  13            inc  de
56AF  02            ld   (bc),a
56B0  13            inc  de
56B1  02            ld   (bc),a
56B2  13            inc  de
56B3  02            ld   (bc),a
56B4  0E04          ld   c,$04
56B6  13            inc  de
56B7  04            inc  b
56B8  13            inc  de
56B9  02            ld   (bc),a
56BA  15            dec  d
56BB  02            ld   (bc),a
56BC  FF            rst  $38
56BD  FF            rst  $38
56BE  FF            rst  $38
56BF  FF            rst  $38
56C0  05            dec  b
56C1  05            dec  b
56C2  0C            inc  c
56C3  00            nop
56C4  0C            inc  c
56C5  1630          ld   d,$30
56C7  1630          ld   d,$30
56C9  1650          ld   d,$50
56CB  1650          ld   d,$50
56CD  16EE          ld   d,$EE
56CF  09            add  hl,bc
56D0  3E01          ld   a,$01
56D2  CDD85A        call $5AD8
56D5  21880F        ld   hl,$0F88
56D8  CD814C        call $4C81
56DB  C9            ret
56DC  FF            rst  $38
56DD  FF            rst  $38
56DE  FF            rst  $38
56DF  FF            rst  $38
56E0  03            inc  bc
56E1  C0            ret  nz
56E2  16A0          ld   d,$A0
56E4  1822          jr   $5708
56E6  16FF          ld   d,$FF
56E8  CDC046        call $46C0
56EB  CD7048        call $4870
56EE  CD1049        call $4910
56F1  CD2055        call $5520
56F4  C9            ret
56F5  FF            rst  $38
56F6  FF            rst  $38
56F7  FF            rst  $38
56F8  12            ld   (de),a
56F9  010E01        ld   bc,$010E
56FC  12            ld   (de),a
56FD  010E01        ld   bc,$010E
5700  1001          djnz $5703
5702  0D            dec  c
5703  011001        ld   bc,$0110
5706  0D            dec  c
5707  010E01        ld   bc,$010E
570A  0B            dec  bc
570B  010E01        ld   bc,$010E
570E  0B            dec  bc
570F  010D01        ld   bc,$010D
5712  09            add  hl,bc
5713  010D01        ld   bc,$010D
5716  09            add  hl,bc
5717  010401        ld   bc,$0104
571A  0601          ld   b,$01
571C  07            rlca
571D  010901        ld   bc,$0109
5720  0B            dec  bc
5721  010D01        ld   bc,$010D
5724  0E01          ld   c,$01
5726  1001          djnz $5729
5728  0E02          ld   c,$02
572A  09            add  hl,bc
572B  02            ld   (bc),a
572C  0E04          ld   c,$04
572E  FF            rst  $38
572F  FF            rst  $38
5730  A1            and  c
5731  02            ld   (bc),a
5732  C302A1        jp   $A102
5735  02            ld   (bc),a
5736  C302A1        jp   $A102
5739  02            ld   (bc),a
573A  C302A1        jp   $A102
573D  02            ld   (bc),a
573E  C302A1        jp   $A102
5741  02            ld   (bc),a
5742  C301C3        jp   $C301
5745  01A002        ld   bc,$02A0
5748  A0            and  b
5749  02            ld   (bc),a
574A  D301          out  ($01),a
574C  D301          out  ($01),a
574E  D301          out  ($01),a
5750  D301          out  ($01),a
5752  C0            ret  nz
5753  02            ld   (bc),a
5754  C1            pop  bc
5755  02            ld   (bc),a
5756  FF            rst  $38
5757  FF            rst  $38
5758  FF            rst  $38
5759  FF            rst  $38
575A  FF            rst  $38
575B  FF            rst  $38
575C  FF            rst  $38
575D  FF            rst  $38
575E  FF            rst  $38
575F  FF            rst  $38
5760  01080F        ld   bc,$0F08
5763  10F8          djnz $575D
5765  56            ld   d,(hl)
5766  FF            rst  $38
5767  FF            rst  $38
5768  80            add  a,b
5769  57            ld   d,a
576A  FF            rst  $38
576B  FF            rst  $38
576C  6E            ld   l,(hl)
576D  57            ld   d,a
576E  FF            rst  $38
576F  FF            rst  $38
5770  02            ld   (bc),a
5771  60            ld   h,b
5772  57            ld   d,a
5773  68            ld   l,b
5774  57            ld   d,a
5775  6C            ld   l,h
5776  57            ld   d,a
5777  FF            rst  $38
5778  FF            rst  $38
5779  FF            rst  $38
577A  FF            rst  $38
577B  FF            rst  $38
577C  FF            rst  $38
577D  FF            rst  $38
577E  FF            rst  $38
577F  FF            rst  $38
5780  15            dec  d
5781  010E01        ld   bc,$010E
5784  15            dec  d
5785  010E01        ld   bc,$010E
5788  15            dec  d
5789  011001        ld   bc,$0110
578C  15            dec  d
578D  011001        ld   bc,$0110
5790  13            inc  de
5791  010E01        ld   bc,$010E
5794  13            inc  de
5795  010E01        ld   bc,$010E
5798  1001          djnz $579B
579A  09            add  hl,bc
579B  011001        ld   bc,$0110
579E  09            add  hl,bc
579F  010901        ld   bc,$0109
57A2  0B            dec  bc
57A3  010901        ld   bc,$0109
57A6  07            rlca
57A7  010601        ld   bc,$0106
57AA  04            inc  b
57AB  010201        ld   bc,$0102
57AE  04            inc  b
57AF  010202        ld   bc,$0202
57B2  0602          ld   b,$02
57B4  02            ld   (bc),a
57B5  04            inc  b
57B6  FF            rst  $38
57B7  FF            rst  $38
57B8  FF            rst  $38
57B9  FF            rst  $38
57BA  FF            rst  $38
57BB  FF            rst  $38
57BC  FF            rst  $38
57BD  FF            rst  $38
57BE  FF            rst  $38
57BF  FF            rst  $38
57C0  C3F05A        jp   $5AF0
57C3  CD815C        call $5C81
57C6  21880F        ld   hl,$0F88
57C9  CD815C        call $5C81
57CC  CD7055        call $5570
57CF  08            ex   af,af'
57D0  08            ex   af,af'
57D1  15            dec  d
57D2  2824          jr   z,$57F8
57D4  221110        ld   ($1011),hl
57D7  12            ld   (de),a
57D8  1F            rra
57D9  1E25          ld   e,$25
57DB  23            inc  hl
57DC  FF            rst  $38
57DD  CD7055        call $5570
57E0  09            add  hl,bc
57E1  08            ex   af,af'
57E2  2B            dec  hl
57E3  2B            dec  hl
57E4  2B            dec  hl
57E5  2B            dec  hl
57E6  2B            dec  hl
57E7  2B            dec  hl
57E8  2B            dec  hl
57E9  2B            dec  hl
57EA  2B            dec  hl
57EB  2B            dec  hl
57EC  2B            dec  hl
57ED  FF            rst  $38
57EE  CDB04E        call $4EB0
57F1  CDB04E        call $4EB0
57F4  CD7055        call $5570
57F7  0C            inc  c
57F8  07            rlca
57F9  2019          jr   nz,$5814
57FB  13            inc  de
57FC  1B            dec  de
57FD  1025          djnz $5824
57FF  2010          jr   nz,$5811
5801  0610          ld   b,$10
5803  12            ld   (de),a
5804  1F            rra
5805  1E25          ld   e,$25
5807  23            inc  hl
5808  FF            rst  $38
5809  CD7055        call $5570
580C  1007          djnz $5815
580E  1F            rra
580F  12            ld   (de),a
5810  1A            ld   a,(de)
5811  15            dec  d
5812  13            inc  de
5813  24            inc  h
5814  23            inc  hl
5815  1027          djnz $583E
5817  19            add  hl,de
5818  24            inc  h
5819  181F          jr   $583A
581B  25            dec  h
581C  24            inc  h
581D  FF            rst  $38
581E  CD7055        call $5570
5821  14            inc  d
5822  07            rlca
5823  1C            inc  e
5824  1F            rra
5825  23            inc  hl
5826  19            add  hl,de
5827  1E17          ld   e,$17
5829  1011          djnz $583C
582B  101C          djnz $5849
582D  19            add  hl,de
582E  1615          ld   d,$15
5830  FF            rst  $38
5831  CDB04E        call $4EB0
5834  CDB04E        call $4EB0
5837  CD7055        call $5570
583A  17            rla
583B  0B            dec  bc
583C  E0            ret  po
583D  DCDDDE        call c,$DEDD
5840  DF            rst  $18
5841  FF            rst  $38
5842  CD7055        call $5570
5845  180B          jr   $5852
5847  E1            pop  hl
5848  E8            ret  pe
5849  EAF2E6        jp   pe,$E6F2
584C  FF            rst  $38
584D  CD7055        call $5570
5850  19            add  hl,de
5851  0B            dec  bc
5852  E1            pop  hl
5853  E9            jp   (hl)
5854  EB            ex   de,hl
5855  F3            di
5856  E6FF          and  $FF
5858  CD7055        call $5570
585B  1A            ld   a,(de)
585C  0B            dec  bc
585D  E2E3E3        jp   po,$E3E3
5860  E3            ex   (sp),hl
5861  E4FFCD        call po,$CDFF
5864  B0            or   b
5865  4E            ld   c,(hl)
5866  CDB04E        call $4EB0
5869  CDB04E        call $4EB0
586C  CDB04E        call $4EB0
586F  C9            ret
5870  A2            and  d
5871  01A201        ld   bc,$01A2
5874  A2            and  d
5875  01A201        ld   bc,$01A2
5878  B2            or   d
5879  01B201        ld   bc,$01B2
587C  B2            or   d
587D  01B201        ld   bc,$01B2
5880  C201C2        jp   nz,$C201
5883  01C201        ld   bc,$01C2
5886  C201D2        jp   nz,$D201
5889  01D201        ld   bc,$01D2
588C  D201D2        jp   nc,$D201
588F  01FFFF        ld   bc,$FFFF
5892  FF            rst  $38
5893  FF            rst  $38
5894  FF            rst  $38
5895  FF            rst  $38
5896  FF            rst  $38
5897  FF            rst  $38
5898  FF            rst  $38
5899  FF            rst  $38
589A  FF            rst  $38
589B  FF            rst  $38
589C  FF            rst  $38
589D  FF            rst  $38
589E  FF            rst  $38
589F  FF            rst  $38
58A0  0C            inc  c
58A1  1678          ld   d,$78
58A3  1678          ld   d,$78
58A5  1696          ld   d,$96
58A7  1696          ld   d,$96
58A9  16EE          ld   d,$EE
58AB  09            add  hl,bc
58AC  FF            rst  $38
58AD  FF            rst  $38
58AE  FF            rst  $38
58AF  FF            rst  $38
58B0  A1            and  c
58B1  02            ld   (bc),a
58B2  C302A1        jp   $A102
58B5  02            ld   (bc),a
58B6  C302A1        jp   $A102
58B9  02            ld   (bc),a
58BA  C302A1        jp   $A102
58BD  02            ld   (bc),a
58BE  C302A0        jp   $A002
58C1  02            ld   (bc),a
58C2  D301          out  ($01),a
58C4  D301          out  ($01),a
58C6  D301          out  ($01),a
58C8  D301          out  ($01),a
58CA  FF            rst  $38
58CB  FF            rst  $38
58CC  FF            rst  $38
58CD  FF            rst  $38
58CE  FF            rst  $38
58CF  FF            rst  $38
58D0  DDE1          pop  ix
58D2  2600          ld   h,$00
58D4  DD6E00        ld   l,(ix+$00)
58D7  29            add  hl,hl
58D8  29            add  hl,hl
58D9  29            add  hl,hl
58DA  29            add  hl,hl
58DB  29            add  hl,hl
58DC  DD23          inc  ix
58DE  DD7E00        ld   a,(ix+$00)
58E1  85            add  a,l
58E2  6F            ld   l,a
58E3  014090        ld   bc,$9040
58E6  09            add  hl,bc
58E7  DD23          inc  ix
58E9  DD7E00        ld   a,(ix+$00)
58EC  FEFF          cp   $FF
58EE  2804          jr   z,$58F4
58F0  77            ld   (hl),a
58F1  23            inc  hl
58F2  18F3          jr   $58E7
58F4  DD23          inc  ix
58F6  DDE5          push ix
58F8  C9            ret
58F9  FF            rst  $38
58FA  FF            rst  $38
58FB  FF            rst  $38
58FC  FF            rst  $38
58FD  FF            rst  $38
58FE  FF            rst  $38
58FF  FF            rst  $38
5900  CD7055        call $5570
5903  010151        ld   bc,$5101
5906  52            ld   d,d
5907  53            ld   d,e
5908  51            ld   d,c
5909  52            ld   d,d
590A  53            ld   d,e
590B  51            ld   d,c
590C  52            ld   d,d
590D  53            ld   d,e
590E  51            ld   d,c
590F  52            ld   d,d
5910  53            ld   d,e
5911  51            ld   d,c
5912  52            ld   d,d
5913  53            ld   d,e
5914  51            ld   d,c
5915  52            ld   d,d
5916  53            ld   d,e
5917  51            ld   d,c
5918  52            ld   d,d
5919  53            ld   d,e
591A  51            ld   d,c
591B  52            ld   d,d
591C  53            ld   d,e
591D  51            ld   d,c
591E  52            ld   d,d
591F  FF            rst  $38
5920  CDD058        call $58D0
5923  010253        ld   bc,$5302
5926  52            ld   d,d
5927  51            ld   d,c
5928  53            ld   d,e
5929  52            ld   d,d
592A  51            ld   d,c
592B  53            ld   d,e
592C  52            ld   d,d
592D  51            ld   d,c
592E  53            ld   d,e
592F  52            ld   d,d
5930  51            ld   d,c
5931  53            ld   d,e
5932  52            ld   d,d
5933  51            ld   d,c
5934  53            ld   d,e
5935  52            ld   d,d
5936  51            ld   d,c
5937  53            ld   d,e
5938  52            ld   d,d
5939  51            ld   d,c
593A  53            ld   d,e
593B  52            ld   d,d
593C  51            ld   d,c
593D  53            ld   d,e
593E  52            ld   d,d
593F  FF            rst  $38
5940  CDD058        call $58D0
5943  1A            ld   a,(de)
5944  02            ld   (bc),a
5945  51            ld   d,c
5946  52            ld   d,d
5947  53            ld   d,e
5948  51            ld   d,c
5949  52            ld   d,d
594A  53            ld   d,e
594B  51            ld   d,c
594C  52            ld   d,d
594D  53            ld   d,e
594E  51            ld   d,c
594F  52            ld   d,d
5950  53            ld   d,e
5951  51            ld   d,c
5952  52            ld   d,d
5953  53            ld   d,e
5954  51            ld   d,c
5955  52            ld   d,d
5956  53            ld   d,e
5957  51            ld   d,c
5958  52            ld   d,d
5959  53            ld   d,e
595A  51            ld   d,c
595B  52            ld   d,d
595C  53            ld   d,e
595D  51            ld   d,c
595E  52            ld   d,d
595F  FF            rst  $38
5960  CD7055        call $5570
5963  1C            inc  e
5964  015351        ld   bc,$5153
5967  52            ld   d,d
5968  53            ld   d,e
5969  51            ld   d,c
596A  52            ld   d,d
596B  53            ld   d,e
596C  51            ld   d,c
596D  52            ld   d,d
596E  53            ld   d,e
596F  51            ld   d,c
5970  52            ld   d,d
5971  53            ld   d,e
5972  51            ld   d,c
5973  52            ld   d,d
5974  53            ld   d,e
5975  51            ld   d,c
5976  52            ld   d,d
5977  53            ld   d,e
5978  51            ld   d,c
5979  52            ld   d,d
597A  53            ld   d,e
597B  51            ld   d,c
597C  52            ld   d,d
597D  53            ld   d,e
597E  51            ld   d,c
597F  FF            rst  $38
5980  C9            ret
5981  FF            rst  $38
5982  FF            rst  $38
5983  FF            rst  $38
5984  FF            rst  $38
5985  FF            rst  $38
5986  FF            rst  $38
5987  FF            rst  $38
5988  CD7055        call $5570
598B  010152        ld   bc,$5201
598E  53            ld   d,e
598F  51            ld   d,c
5990  52            ld   d,d
5991  53            ld   d,e
5992  51            ld   d,c
5993  52            ld   d,d
5994  53            ld   d,e
5995  51            ld   d,c
5996  52            ld   d,d
5997  53            ld   d,e
5998  51            ld   d,c
5999  52            ld   d,d
599A  53            ld   d,e
599B  51            ld   d,c
599C  52            ld   d,d
599D  53            ld   d,e
599E  51            ld   d,c
599F  52            ld   d,d
59A0  53            ld   d,e
59A1  51            ld   d,c
59A2  52            ld   d,d
59A3  53            ld   d,e
59A4  51            ld   d,c
59A5  52            ld   d,d
59A6  53            ld   d,e
59A7  FF            rst  $38
59A8  CDD058        call $58D0
59AB  010252        ld   bc,$5202
59AE  51            ld   d,c
59AF  53            ld   d,e
59B0  52            ld   d,d
59B1  51            ld   d,c
59B2  53            ld   d,e
59B3  52            ld   d,d
59B4  51            ld   d,c
59B5  53            ld   d,e
59B6  52            ld   d,d
59B7  51            ld   d,c
59B8  53            ld   d,e
59B9  52            ld   d,d
59BA  51            ld   d,c
59BB  53            ld   d,e
59BC  52            ld   d,d
59BD  51            ld   d,c
59BE  53            ld   d,e
59BF  52            ld   d,d
59C0  51            ld   d,c
59C1  53            ld   d,e
59C2  52            ld   d,d
59C3  51            ld   d,c
59C4  53            ld   d,e
59C5  52            ld   d,d
59C6  51            ld   d,c
59C7  FF            rst  $38
59C8  CDD058        call $58D0
59CB  1A            ld   a,(de)
59CC  02            ld   (bc),a
59CD  53            ld   d,e
59CE  51            ld   d,c
59CF  52            ld   d,d
59D0  53            ld   d,e
59D1  51            ld   d,c
59D2  52            ld   d,d
59D3  53            ld   d,e
59D4  51            ld   d,c
59D5  52            ld   d,d
59D6  53            ld   d,e
59D7  51            ld   d,c
59D8  52            ld   d,d
59D9  53            ld   d,e
59DA  51            ld   d,c
59DB  52            ld   d,d
59DC  53            ld   d,e
59DD  51            ld   d,c
59DE  52            ld   d,d
59DF  53            ld   d,e
59E0  51            ld   d,c
59E1  52            ld   d,d
59E2  53            ld   d,e
59E3  51            ld   d,c
59E4  52            ld   d,d
59E5  53            ld   d,e
59E6  51            ld   d,c
59E7  FF            rst  $38
59E8  CD7055        call $5570
59EB  1C            inc  e
59EC  015253        ld   bc,$5352
59EF  51            ld   d,c
59F0  52            ld   d,d
59F1  53            ld   d,e
59F2  51            ld   d,c
59F3  52            ld   d,d
59F4  53            ld   d,e
59F5  51            ld   d,c
59F6  52            ld   d,d
59F7  53            ld   d,e
59F8  51            ld   d,c
59F9  52            ld   d,d
59FA  53            ld   d,e
59FB  51            ld   d,c
59FC  52            ld   d,d
59FD  53            ld   d,e
59FE  51            ld   d,c
59FF  52            ld   d,d
5A00  53            ld   d,e
5A01  51            ld   d,c
5A02  52            ld   d,d
5A03  53            ld   d,e
5A04  51            ld   d,c
5A05  52            ld   d,d
5A06  53            ld   d,e
5A07  FF            rst  $38
5A08  C9            ret
5A09  FF            rst  $38
5A0A  FF            rst  $38
5A0B  FF            rst  $38
5A0C  FF            rst  $38
5A0D  FF            rst  $38
5A0E  FF            rst  $38
5A0F  FF            rst  $38
5A10  CD7055        call $5570
5A13  010153        ld   bc,$5301
5A16  51            ld   d,c
5A17  52            ld   d,d
5A18  53            ld   d,e
5A19  51            ld   d,c
5A1A  52            ld   d,d
5A1B  53            ld   d,e
5A1C  51            ld   d,c
5A1D  52            ld   d,d
5A1E  53            ld   d,e
5A1F  51            ld   d,c
5A20  52            ld   d,d
5A21  53            ld   d,e
5A22  51            ld   d,c
5A23  52            ld   d,d
5A24  53            ld   d,e
5A25  51            ld   d,c
5A26  52            ld   d,d
5A27  53            ld   d,e
5A28  51            ld   d,c
5A29  52            ld   d,d
5A2A  53            ld   d,e
5A2B  51            ld   d,c
5A2C  52            ld   d,d
5A2D  53            ld   d,e
5A2E  51            ld   d,c
5A2F  FF            rst  $38
5A30  CDD058        call $58D0
5A33  010251        ld   bc,$5102
5A36  53            ld   d,e
5A37  52            ld   d,d
5A38  51            ld   d,c
5A39  53            ld   d,e
5A3A  52            ld   d,d
5A3B  51            ld   d,c
5A3C  53            ld   d,e
5A3D  52            ld   d,d
5A3E  51            ld   d,c
5A3F  53            ld   d,e
5A40  52            ld   d,d
5A41  51            ld   d,c
5A42  53            ld   d,e
5A43  52            ld   d,d
5A44  51            ld   d,c
5A45  53            ld   d,e
5A46  52            ld   d,d
5A47  51            ld   d,c
5A48  53            ld   d,e
5A49  52            ld   d,d
5A4A  51            ld   d,c
5A4B  53            ld   d,e
5A4C  52            ld   d,d
5A4D  51            ld   d,c
5A4E  53            ld   d,e
5A4F  FF            rst  $38
5A50  CDD058        call $58D0
5A53  1A            ld   a,(de)
5A54  02            ld   (bc),a
5A55  52            ld   d,d
5A56  53            ld   d,e
5A57  51            ld   d,c
5A58  52            ld   d,d
5A59  53            ld   d,e
5A5A  51            ld   d,c
5A5B  52            ld   d,d
5A5C  53            ld   d,e
5A5D  51            ld   d,c
5A5E  52            ld   d,d
5A5F  53            ld   d,e
5A60  51            ld   d,c
5A61  52            ld   d,d
5A62  53            ld   d,e
5A63  51            ld   d,c
5A64  52            ld   d,d
5A65  53            ld   d,e
5A66  51            ld   d,c
5A67  52            ld   d,d
5A68  53            ld   d,e
5A69  51            ld   d,c
5A6A  52            ld   d,d
5A6B  53            ld   d,e
5A6C  51            ld   d,c
5A6D  52            ld   d,d
5A6E  53            ld   d,e
5A6F  FF            rst  $38
5A70  CD7055        call $5570
5A73  1C            inc  e
5A74  015152        ld   bc,$5251
5A77  53            ld   d,e
5A78  51            ld   d,c
5A79  52            ld   d,d
5A7A  53            ld   d,e
5A7B  51            ld   d,c
5A7C  52            ld   d,d
5A7D  53            ld   d,e
5A7E  51            ld   d,c
5A7F  52            ld   d,d
5A80  53            ld   d,e
5A81  51            ld   d,c
5A82  52            ld   d,d
5A83  53            ld   d,e
5A84  51            ld   d,c
5A85  52            ld   d,d
5A86  53            ld   d,e
5A87  51            ld   d,c
5A88  52            ld   d,d
5A89  53            ld   d,e
5A8A  51            ld   d,c
5A8B  52            ld   d,d
5A8C  53            ld   d,e
5A8D  51            ld   d,c
5A8E  52            ld   d,d
5A8F  FF            rst  $38
5A90  C9            ret
5A91  FF            rst  $38
5A92  FF            rst  $38
5A93  FF            rst  $38
5A94  FF            rst  $38
5A95  FF            rst  $38
5A96  FF            rst  $38
5A97  FF            rst  $38
5A98  E5            push hl
5A99  C5            push bc
5A9A  D5            push de
5A9B  212821        ld   hl,$2128
5A9E  CD815C        call $5C81
5AA1  D1            pop  de
5AA2  C1            pop  bc
5AA3  E1            pop  hl
5AA4  C9            ret
5AA5  FF            rst  $38
5AA6  FF            rst  $38
5AA7  FF            rst  $38
5AA8  1E05          ld   e,$05
5AAA  1605          ld   d,$05
5AAC  D5            push de
5AAD  CD0059        call $5900
5AB0  CD985A        call $5A98
5AB3  D1            pop  de
5AB4  15            dec  d
5AB5  20F5          jr   nz,$5AAC
5AB7  1605          ld   d,$05
5AB9  D5            push de
5ABA  CD8859        call $5988
5ABD  CD985A        call $5A98
5AC0  D1            pop  de
5AC1  15            dec  d
5AC2  20F5          jr   nz,$5AB9
5AC4  1605          ld   d,$05
5AC6  D5            push de
5AC7  CD105A        call $5A10
5ACA  CD985A        call $5A98
5ACD  D1            pop  de
5ACE  15            dec  d
5ACF  20F5          jr   nz,$5AC6
5AD1  1D            dec  e
5AD2  20D6          jr   nz,$5AAA
5AD4  C9            ret
5AD5  FF            rst  $38
5AD6  FF            rst  $38
5AD7  FF            rst  $38
5AD8  47            ld   b,a
5AD9  210181        ld   hl,$8101
5ADC  70            ld   (hl),b
5ADD  23            inc  hl
5ADE  23            inc  hl
5ADF  7D            ld   a,l
5AE0  FE41          cp   $41
5AE2  20F8          jr   nz,$5ADC
5AE4  C9            ret
5AE5  FF            rst  $38
5AE6  3E04          ld   a,$04
5AE8  CDD85A        call $5AD8
5AEB  C9            ret
5AEC  FF            rst  $38
5AED  FF            rst  $38
5AEE  FF            rst  $38
5AEF  FF            rst  $38
5AF0  217014        ld   hl,reset_xoff_sprites_and_clear_screen
5AF3  CD815C        call $5C81
5AF6  21880F        ld   hl,$0F88
5AF9  CD815C        call $5C81
5AFC  CDE65A        call $5AE6
5AFF  CD7055        call $5570
5B02  08            ex   af,af'
5B03  08            ex   af,af'
5B04  15            dec  d
5B05  2824          jr   z,$5B2B
5B07  221110        ld   ($1011),hl
5B0A  12            ld   (de),a
5B0B  1F            rra
5B0C  1E25          ld   e,$25
5B0E  23            inc  hl
5B0F  FF            rst  $38
5B10  CD7055        call $5570
5B13  09            add  hl,bc
5B14  08            ex   af,af'
5B15  2B            dec  hl
5B16  2B            dec  hl
5B17  2B            dec  hl
5B18  2B            dec  hl
5B19  2B            dec  hl
5B1A  2B            dec  hl
5B1B  2B            dec  hl
5B1C  2B            dec  hl
5B1D  2B            dec  hl
5B1E  2B            dec  hl
5B1F  2B            dec  hl
5B20  FF            rst  $38
5B21  CDA85A        call $5AA8
5B24  CDA85A        call $5AA8
5B27  CD7055        call $5570
5B2A  0C            inc  c
5B2B  07            rlca
5B2C  2019          jr   nz,$5B47
5B2E  13            inc  de
5B2F  1B            dec  de
5B30  1025          djnz $5B57
5B32  2010          jr   nz,$5B44
5B34  0610          ld   b,$10
5B36  12            ld   (de),a
5B37  1F            rra
5B38  1E25          ld   e,$25
5B3A  23            inc  hl
5B3B  FF            rst  $38
5B3C  CD7055        call $5570
5B3F  1007          djnz $5B48
5B41  1F            rra
5B42  12            ld   (de),a
5B43  1A            ld   a,(de)
5B44  15            dec  d
5B45  13            inc  de
5B46  24            inc  h
5B47  23            inc  hl
5B48  1027          djnz $5B71
5B4A  19            add  hl,de
5B4B  24            inc  h
5B4C  181F          jr   $5B6D
5B4E  25            dec  h
5B4F  24            inc  h
5B50  FF            rst  $38
5B51  CD7055        call $5570
5B54  14            inc  d
5B55  07            rlca
5B56  1C            inc  e
5B57  1F            rra
5B58  23            inc  hl
5B59  19            add  hl,de
5B5A  1E17          ld   e,$17
5B5C  1011          djnz $5B6F
5B5E  101C          djnz $5B7C
5B60  19            add  hl,de
5B61  1615          ld   d,$15
5B63  FF            rst  $38
5B64  CDA85A        call $5AA8
5B67  CD7055        call $5570
5B6A  17            rla
5B6B  0B            dec  bc
5B6C  E0            ret  po
5B6D  DCDDDE        call c,$DEDD
5B70  DF            rst  $18
5B71  FF            rst  $38
5B72  CD7055        call $5570
5B75  180B          jr   $5B82
5B77  E1            pop  hl
5B78  E5            push hl
5B79  E5            push hl
5B7A  E5            push hl
5B7B  E6FF          and  $FF
5B7D  CD7055        call $5570
5B80  19            add  hl,de
5B81  0B            dec  bc
5B82  E1            pop  hl
5B83  E5            push hl
5B84  E5            push hl
5B85  E5            push hl
5B86  E6FF          and  $FF
5B88  CD7055        call $5570
5B8B  1A            ld   a,(de)
5B8C  0B            dec  bc
5B8D  E2E3E3        jp   po,$E3E3
5B90  E3            ex   (sp),hl
5B91  E4FFCD        call po,$CDFF
5B94  A8            xor  b
5B95  5A            ld   e,d
5B96  CDA85A        call $5AA8
5B99  CDC85B        call $5BC8
5B9C  C9            ret
5B9D  FF            rst  $38
5B9E  FF            rst  $38
5B9F  FF            rst  $38
5BA0  FF            rst  $38
5BA1  FF            rst  $38
5BA2  FF            rst  $38
5BA3  FF            rst  $38
5BA4  FF            rst  $38
5BA5  FF            rst  $38
5BA6  FF            rst  $38
5BA7  FF            rst  $38
5BA8  3A6480        ld   a,($8064)
5BAB  3C            inc  a
5BAC  FE03          cp   $03
5BAE  2001          jr   nz,$5BB1
5BB0  AF            xor  a
5BB1  326480        ld   ($8064),a
5BB4  A7            and  a
5BB5  2004          jr   nz,$5BBB
5BB7  CD105A        call $5A10
5BBA  C9            ret
5BBB  FE01          cp   $01
5BBD  2004          jr   nz,$5BC3
5BBF  CD8859        call $5988
5BC2  C9            ret
5BC3  CD0059        call $5900
5BC6  C9            ret
5BC7  FF            rst  $38
5BC8  3EF2          ld   a,$F2
5BCA  32F891        ld   ($91F8),a
5BCD  CDA85A        call $5AA8
5BD0  3EF3          ld   a,$F3
5BD2  32F991        ld   ($91F9),a
5BD5  CDA85A        call $5AA8
5BD8  3EEA          ld   a,$EA
5BDA  321892        ld   ($9218),a
5BDD  CDA85A        call $5AA8
5BE0  3EEB          ld   a,$EB
5BE2  321992        ld   ($9219),a
5BE5  CDA85A        call $5AA8
5BE8  3EE8          ld   a,$E8
5BEA  323892        ld   ($9238),a
5BED  CDA85A        call $5AA8
5BF0  3EE9          ld   a,$E9
5BF2  323992        ld   ($9239),a
5BF5  CDA85A        call $5AA8
5BF8  CDA85A        call $5AA8
5BFB  CDA85A        call $5AA8
5BFE  C9            ret
5BFF  FF            rst  $38
5C00  15            dec  d
5C01  011501        ld   bc,$0115
5C04  15            dec  d
5C05  011A03        ld   bc,$031A
5C08  1E02          ld   e,$02
5C0A  15            dec  d
5C0B  011501        ld   bc,$0115
5C0E  15            dec  d
5C0F  011A03        ld   bc,$031A
5C12  1E02          ld   e,$02
5C14  15            dec  d
5C15  011501        ld   bc,$0115
5C18  15            dec  d
5C19  011A01        ld   bc,$011A
5C1C  210121        ld   hl,$2101
5C1F  012101        ld   bc,$0121
5C22  210323        ld   hl,$2303
5C25  011E01        ld   bc,$011E
5C28  1C            inc  e
5C29  04            inc  b
5C2A  15            dec  d
5C2B  011501        ld   bc,$0115
5C2E  15            dec  d
5C2F  011903        ld   bc,$0319
5C32  1C            inc  e
5C33  02            ld   (bc),a
5C34  15            dec  d
5C35  011501        ld   bc,$0115
5C38  15            dec  d
5C39  011903        ld   bc,$0319
5C3C  1C            inc  e
5C3D  02            ld   (bc),a
5C3E  15            dec  d
5C3F  011501        ld   bc,$0115
5C42  15            dec  d
5C43  011501        ld   bc,$0115
5C46  210121        ld   hl,$2101
5C49  012101        ld   bc,$0121
5C4C  210223        ld   hl,$2302
5C4F  011E02        ld   bc,$021E
5C52  1A            ld   a,(de)
5C53  04            inc  b
5C54  FF            rst  $38
5C55  FF            rst  $38
5C56  FF            rst  $38
5C57  FF            rst  $38
5C58  FF            rst  $38
5C59  FF            rst  $38
5C5A  FF            rst  $38
5C5B  FF            rst  $38
5C5C  FF            rst  $38
5C5D  FF            rst  $38
5C5E  FF            rst  $38
5C5F  FF            rst  $38
5C60  62            ld   h,d
5C61  5C            ld   e,h
5C62  FF            rst  $38
5C63  FF            rst  $38
5C64  FF            rst  $38
5C65  FF            rst  $38
5C66  FF            rst  $38
5C67  FF            rst  $38
5C68  FF            rst  $38
5C69  FF            rst  $38
5C6A  FF            rst  $38
5C6B  FF            rst  $38
5C6C  FF            rst  $38
5C6D  FF            rst  $38
5C6E  FF            rst  $38
5C6F  FF            rst  $38
5C70  FF            rst  $38
5C71  FF            rst  $38
5C72  FF            rst  $38
5C73  FF            rst  $38
5C74  FF            rst  $38
5C75  FF            rst  $38
5C76  FF            rst  $38
5C77  FF            rst  $38
5C78  FF            rst  $38
5C79  FF            rst  $38
5C7A  FF            rst  $38
5C7B  FF            rst  $38
5C7C  FF            rst  $38
5C7D  FF            rst  $38
5C7E  FF            rst  $38
5C7F  FF            rst  $38
5C80  FF            rst  $38
5C81  E9            jp   (hl)
5C82  40            ld   b,b
5C83  41            ld   b,c
5C84  C9            ret
5C85  FF            rst  $38
5C86  0601          ld   b,$01
5C88  0601          ld   b,$01
5C8A  0601          ld   b,$01
5C8C  0E01          ld   c,$01
5C8E  09            add  hl,bc
5C8F  011201        ld   bc,$0112
5C92  1001          djnz $5C95
5C94  0E01          ld   c,$01
5C96  0601          ld   b,$01
5C98  0601          ld   b,$01
5C9A  0601          ld   b,$01
5C9C  0E01          ld   c,$01
5C9E  09            add  hl,bc
5C9F  011201        ld   bc,$0112
5CA2  1001          djnz $5CA5
5CA4  0E01          ld   c,$01
5CA6  0601          ld   b,$01
5CA8  0601          ld   b,$01
5CAA  0601          ld   b,$01
5CAC  0E01          ld   c,$01
5CAE  09            add  hl,bc
5CAF  011201        ld   bc,$0112
5CB2  1001          djnz $5CB5
5CB4  0E01          ld   c,$01
5CB6  12            ld   (de),a
5CB7  011201        ld   bc,$0112
5CBA  12            ld   (de),a
5CBB  011001        ld   bc,$0110
5CBE  1001          djnz $5CC1
5CC0  0D            dec  c
5CC1  010702        ld   bc,$0207
5CC4  07            rlca
5CC5  010701        ld   bc,$0107
5CC8  07            rlca
5CC9  010D01        ld   bc,$010D
5CCC  0D            dec  c
5CCD  011001        ld   bc,$0110
5CD0  1002          djnz $5CD4
5CD2  07            rlca
5CD3  010701        ld   bc,$0107
5CD6  07            rlca
5CD7  010D01        ld   bc,$010D
5CDA  0D            dec  c
5CDB  011001        ld   bc,$0110
5CDE  1002          djnz $5CE2
5CE0  07            rlca
5CE1  010701        ld   bc,$0107
5CE4  07            rlca
5CE5  010901        ld   bc,$0109
5CE8  1001          djnz $5CEB
5CEA  1001          djnz $5CED
5CEC  1001          djnz $5CEF
5CEE  15            dec  d
5CEF  011501        ld   bc,$0115
5CF2  13            inc  de
5CF3  02            ld   (bc),a
5CF4  12            ld   (de),a
5CF5  011002        ld   bc,$0210
5CF8  0E02          ld   c,$02
5CFA  FF            rst  $38
5CFB  FF            rst  $38
5CFC  FF            rst  $38
5CFD  FF            rst  $38
5CFE  FF            rst  $38
5CFF  FF            rst  $38
5D00  02            ld   (bc),a
5D01  08            ex   af,af'
5D02  5D            ld   e,l
5D03  14            inc  d
5D04  5D            ld   e,l
5D05  14            inc  d
5D06  5D            ld   e,l
5D07  FF            rst  $38
5D08  01080E        ld   bc,$0E08
5D0B  00            nop
5D0C  86            add  a,(hl)
5D0D  5C            ld   e,h
5D0E  EE03          xor  $03
5D10  FF            rst  $38
5D11  FF            rst  $38
5D12  FF            rst  $38
5D13  FF            rst  $38
5D14  00            nop
5D15  5C            ld   e,h
5D16  EE03          xor  $03
5D18  FF            rst  $38
5D19  FF            rst  $38
5D1A  70            ld   (hl),b
5D1B  1830          jr   $5D4D
5D1D  17            rla
5D1E  3017          jr   nc,$5D37
5D20  3017          jr   nc,$5D39
5D22  3017          jr   nc,$5D3B
5D24  281D          jr   z,$5D43
5D26  EE03          xor  $03
5D28  E3            ex   (sp),hl
5D29  06D3          ld   b,$D3
5D2B  03            inc  bc
5D2C  D303          out  ($03),a
5D2E  FF            rst  $38
5D2F  FF            rst  $38
5D30  19            add  hl,de
5D31  011A01        ld   bc,$011A
5D34  1B            dec  de
5D35  011C01        ld   bc,$011C
5D38  21021C        ld   hl,$1C02
5D3B  012102        ld   bc,$0221
5D3E  1C            inc  e
5D3F  02            ld   (bc),a
5D40  1B            dec  de
5D41  012102        ld   bc,$0221
5D44  1B            dec  de
5D45  012102        ld   bc,$0221
5D48  1B            dec  de
5D49  02            ld   (bc),a
5D4A  1A            ld   a,(de)
5D4B  012102        ld   bc,$0221
5D4E  1A            ld   a,(de)
5D4F  012102        ld   bc,$0221
5D52  1A            ld   a,(de)
5D53  02            ld   (bc),a
5D54  19            add  hl,de
5D55  011A01        ld   bc,$011A
5D58  1B            dec  de
5D59  011C02        ld   bc,$021C
5D5C  FF            rst  $38
5D5D  FF            rst  $38
5D5E  FF            rst  $38
5D5F  FF            rst  $38
5D60  19            add  hl,de
5D61  20FF          jr   nz,$5D62
5D63  FF            rst  $38
5D64  1A            ld   a,(de)
5D65  011901        ld   bc,$0119
5D68  17            rla
5D69  011503        ld   bc,$0315
5D6C  15            dec  d
5D6D  011C03        ld   bc,$031C
5D70  1C            inc  e
5D71  011E02        ld   bc,$021E
5D74  1A            ld   a,(de)
5D75  02            ld   (bc),a
5D76  15            dec  d
5D77  02            ld   (bc),a
5D78  1E02          ld   e,$02
5D7A  1C            inc  e
5D7B  03            inc  bc
5D7C  19            add  hl,de
5D7D  011901        ld   bc,$0119
5D80  17            rla
5D81  011502        ld   bc,$0215
5D84  17            rla
5D85  0619          ld   b,$19
5D87  011701        ld   bc,$0117
5D8A  15            dec  d
5D8B  03            inc  bc
5D8C  15            dec  d
5D8D  011C03        ld   bc,$031C
5D90  1C            inc  e
5D91  011E01        ld   bc,$011E
5D94  1C            inc  e
5D95  011A02        ld   bc,$021A
5D98  1E02          ld   e,$02
5D9A  210225        ld   hl,$2502
5D9D  02            ld   (bc),a
5D9E  25            dec  h
5D9F  02            ld   (bc),a
5DA0  2601          ld   h,$01
5DA2  25            dec  h
5DA3  012302        ld   bc,$0223
5DA6  2105FF        ld   hl,$FF05
5DA9  FF            rst  $38
5DAA  FF            rst  $38
5DAB  FF            rst  $38
5DAC  1003          djnz $5DB1
5DAE  1004          djnz $5DB4
5DB0  1004          djnz $5DB6
5DB2  12            ld   (de),a
5DB3  04            inc  b
5DB4  12            ld   (de),a
5DB5  04            inc  b
5DB6  1004          djnz $5DBC
5DB8  1004          djnz $5DBE
5DBA  0B            dec  bc
5DBB  04            inc  b
5DBC  0B            dec  bc
5DBD  04            inc  b
5DBE  1004          djnz $5DC4
5DC0  1004          djnz $5DC6
5DC2  12            ld   (de),a
5DC3  04            inc  b
5DC4  12            ld   (de),a
5DC5  04            inc  b
5DC6  1004          djnz $5DCC
5DC8  09            add  hl,bc
5DC9  04            inc  b
5DCA  09            add  hl,bc
5DCB  05            dec  b
5DCC  FF            rst  $38
5DCD  FF            rst  $38
5DCE  FF            rst  $38
5DCF  FF            rst  $38
5DD0  01050F        ld   bc,$0F05
5DD3  00            nop
5DD4  60            ld   h,b
5DD5  5D            ld   e,l
5DD6  AC            xor  h
5DD7  5D            ld   e,l
5DD8  AC            xor  h
5DD9  5D            ld   e,l
5DDA  EE07          xor  $07
5DDC  CC1DFF        call z,$FF1D
5DDF  FF            rst  $38
5DE0  305D          jr   nc,$5E3F
5DE2  64            ld   h,h
5DE3  5D            ld   e,l
5DE4  64            ld   h,h
5DE5  5D            ld   e,l
5DE6  EE07          xor  $07
5DE8  FF            rst  $38
5DE9  FF            rst  $38
5DEA  03            inc  bc
5DEB  D0            ret  nc
5DEC  5D            ld   e,l
5DED  E0            ret  po
5DEE  5D            ld   e,l
5DEF  DC5DFF        call c,$FF5D
5DF2  FF            rst  $38
5DF3  FF            rst  $38
5DF4  15            dec  d
5DF5  011A02        ld   bc,$021A
5DF8  1D            dec  e
5DF9  011C01        ld   bc,$011C
5DFC  1D            dec  e
5DFD  011C01        ld   bc,$011C
5E00  1A            ld   a,(de)
5E01  02            ld   (bc),a
5E02  1D            dec  e
5E03  011C02        ld   bc,$021C
5E06  1D            dec  e
5E07  011A01        ld   bc,$011A
5E0A  1C            inc  e
5E0B  011D01        ld   bc,$011D
5E0E  1C            inc  e
5E0F  02            ld   (bc),a
5E10  1D            dec  e
5E11  011A01        ld   bc,$011A
5E14  15            dec  d
5E15  011101        ld   bc,$0111
5E18  0E03          ld   c,$03
5E1A  FF            rst  $38
5E1B  FF            rst  $38
5E1C  110111        ld   de,$1101
5E1F  011101        ld   bc,$0111
5E22  110111        ld   de,$1101
5E25  011101        ld   bc,$0111
5E28  110111        ld   de,$1101
5E2B  011001        ld   bc,$0110
5E2E  1001          djnz $5E31
5E30  1001          djnz $5E33
5E32  1001          djnz $5E35
5E34  1001          djnz $5E37
5E36  1001          djnz $5E39
5E38  1001          djnz $5E3B
5E3A  1001          djnz $5E3D
5E3C  0E02          ld   c,$02
5E3E  0E01          ld   c,$01
5E40  1001          djnz $5E43
5E42  11020E        ld   de,$0E02
5E45  02            ld   (bc),a
5E46  14            inc  d
5E47  04            inc  b
5E48  15            dec  d
5E49  04            inc  b
5E4A  FF            rst  $38
5E4B  FF            rst  $38
5E4C  0E02          ld   c,$02
5E4E  110109        ld   de,$0901
5E51  010B01        ld   bc,$010B
5E54  0C            inc  c
5E55  010E02        ld   bc,$020E
5E58  110109        ld   de,$0901
5E5B  010B01        ld   bc,$010B
5E5E  0C            inc  c
5E5F  010E02        ld   bc,$020E
5E62  110109        ld   de,$0901
5E65  010B01        ld   bc,$010B
5E68  0C            inc  c
5E69  010E01        ld   bc,$010E
5E6C  09            add  hl,bc
5E6D  010501        ld   bc,$0105
5E70  02            ld   (bc),a
5E71  03            inc  bc
5E72  FF            rst  $38
5E73  FF            rst  $38
5E74  FF            rst  $38
5E75  01060F        ld   bc,$0F06
5E78  00            nop
5E79  80            add  a,b
5E7A  5E            ld   e,(hl)
5E7B  FF            rst  $38
5E7C  FF            rst  $38
5E7D  FF            rst  $38
5E7E  FF            rst  $38
5E7F  FF            rst  $38
5E80  FF            rst  $38
5E81  FF            rst  $38
5E82  FF            rst  $38
5E83  FF            rst  $38
5E84  FF            rst  $38
5E85  FF            rst  $38
5E86  FF            rst  $38
5E87  FF            rst  $38
5E88  03            inc  bc
5E89  75            ld   (hl),l
5E8A  5E            ld   e,(hl)
5E8B  90            sub  b
5E8C  5E            ld   e,(hl)
5E8D  79            ld   a,c
5E8E  5E            ld   e,(hl)
5E8F  FF            rst  $38
5E90  F45D1C        call p,$1C5D
5E93  5E            ld   e,(hl)
5E94  4C            ld   c,h
5E95  5E            ld   e,(hl)
5E96  4C            ld   c,h
5E97  5E            ld   e,(hl)
5E98  EE09          xor  $09
5E9A  FF            rst  $38
5E9B  FF            rst  $38
5E9C  FF            rst  $38
5E9D  FF            rst  $38
5E9E  FF            rst  $38
5E9F  FF            rst  $38
5EA0  0E01          ld   c,$01
5EA2  1001          djnz $5EA5
5EA4  13            inc  de
5EA5  011701        ld   bc,$0117
5EA8  1601          ld   d,$01
5EAA  17            rla
5EAB  011601        ld   bc,$0116
5EAE  17            rla
5EAF  011601        ld   bc,$0116
5EB2  17            rla
5EB3  011601        ld   bc,$0116
5EB6  1801          jr   $5EB9
5EB8  17            rla
5EB9  011501        ld   bc,$0115
5EBC  17            rla
5EBD  011301        ld   bc,$0113
5EC0  0E01          ld   c,$01
5EC2  13            inc  de
5EC3  011701        ld   bc,$0117
5EC6  1A            ld   a,(de)
5EC7  011901        ld   bc,$0119
5ECA  1A            ld   a,(de)
5ECB  011901        ld   bc,$0119
5ECE  1A            ld   a,(de)
5ECF  011901        ld   bc,$0119
5ED2  1A            ld   a,(de)
5ED3  011901        ld   bc,$0119
5ED6  1C            inc  e
5ED7  011A01        ld   bc,$011A
5EDA  19            add  hl,de
5EDB  011A01        ld   bc,$011A
5EDE  17            rla
5EDF  010E01        ld   bc,$010E
5EE2  1001          djnz $5EE5
5EE4  13            inc  de
5EE5  011701        ld   bc,$0117
5EE8  1601          ld   d,$01
5EEA  17            rla
5EEB  011601        ld   bc,$0116
5EEE  17            rla
5EEF  011601        ld   bc,$0116
5EF2  17            rla
5EF3  011601        ld   bc,$0116
5EF6  1801          jr   $5EF9
5EF8  17            rla
5EF9  011501        ld   bc,$0115
5EFC  17            rla
5EFD  011301        ld   bc,$0113
5F00  0E01          ld   c,$01
5F02  1001          djnz $5F05
5F04  13            inc  de
5F05  011701        ld   bc,$0117
5F08  15            dec  d
5F09  02            ld   (bc),a
5F0A  0E01          ld   c,$01
5F0C  17            rla
5F0D  011502        ld   bc,$0215
5F10  0E01          ld   c,$01
5F12  13            inc  de
5F13  02            ld   (bc),a
5F14  0E02          ld   c,$02
5F16  13            inc  de
5F17  01FFFF        ld   bc,$FFFF
5F1A  FF            rst  $38
5F1B  FF            rst  $38
5F1C  FF            rst  $38
5F1D  FF            rst  $38
5F1E  FF            rst  $38
5F1F  FF            rst  $38
5F20  A0            and  b
5F21  5E            ld   e,(hl)
5F22  EE03          xor  $03
5F24  03            inc  bc
5F25  060F          ld   b,$0F
5F27  101C          djnz $5F45
5F29  5F            ld   e,a
5F2A  FF            rst  $38
5F2B  FF            rst  $38
5F2C  FF            rst  $38
5F2D  FF            rst  $38
5F2E  FF            rst  $38
5F2F  FF            rst  $38
5F30  03            inc  bc
5F31  24            inc  h
5F32  5F            ld   e,a
5F33  205F          jr   nz,$5F94
5F35  285F          jr   z,$5F96
5F37  FF            rst  $38
5F38  09            add  hl,bc
5F39  010E01        ld   bc,$010E
5F3C  1001          djnz $5F3F
5F3E  12            ld   (de),a
5F3F  03            inc  bc
5F40  13            inc  de
5F41  011302        ld   bc,$0213
5F44  17            rla
5F45  02            ld   (bc),a
5F46  15            dec  d
5F47  04            inc  b
5F48  12            ld   (de),a
5F49  02            ld   (bc),a
5F4A  15            dec  d
5F4B  02            ld   (bc),a
5F4C  13            inc  de
5F4D  03            inc  bc
5F4E  12            ld   (de),a
5F4F  011302        ld   bc,$0213
5F52  1002          djnz $5F56
5F54  12            ld   (de),a
5F55  05            dec  b
5F56  09            add  hl,bc
5F57  010E01        ld   bc,$010E
5F5A  1001          djnz $5F5D
5F5C  12            ld   (de),a
5F5D  03            inc  bc
5F5E  13            inc  de
5F5F  011302        ld   bc,$0213
5F62  17            rla
5F63  02            ld   (bc),a
5F64  15            dec  d
5F65  04            inc  b
5F66  12            ld   (de),a
5F67  02            ld   (bc),a
5F68  15            dec  d
5F69  02            ld   (bc),a
5F6A  13            inc  de
5F6B  03            inc  bc
5F6C  12            ld   (de),a
5F6D  011302        ld   bc,$0213
5F70  1002          djnz $5F74
5F72  0E05          ld   c,$05
5F74  FF            rst  $38
5F75  FF            rst  $38
5F76  FF            rst  $38
5F77  FF            rst  $38
5F78  03            inc  bc
5F79  90            sub  b
5F7A  5F            ld   e,a
5F7B  80            add  a,b
5F7C  5F            ld   e,a
5F7D  98            sbc  a,b
5F7E  5F            ld   e,a
5F7F  FF            rst  $38
5F80  385F          jr   c,$5FE1
5F82  204A          jr   nz,$5FCE
5F84  204A          jr   nz,$5FD0
5F86  48            ld   c,b
5F87  4A            ld   c,d
5F88  48            ld   c,b
5F89  4A            ld   c,d
5F8A  EE0B          xor  $0B
5F8C  FF            rst  $38
5F8D  FF            rst  $38
5F8E  FF            rst  $38
5F8F  FF            rst  $38
5F90  01050F        ld   bc,$0F05
5F93  00            nop
5F94  8C            adc  a,h
5F95  5F            ld   e,a
5F96  FF            rst  $38
5F97  FF            rst  $38
5F98  C44AE4        call nz,$E44A
5F9B  4A            ld   c,d
5F9C  E44A06        call po,$064A
5F9F  4B            ld   c,e
5FA0  064B          ld   b,$4B
5FA2  EE0B          xor  $0B
5FA4  FF            rst  $38
5FA5  FF            rst  $38
5FA6  FF            rst  $38
5FA7  FF            rst  $38
5FA8  FF            rst  $38
5FA9  FF            rst  $38
5FAA  FF            rst  $38
5FAB  FF            rst  $38
5FAC  FF            rst  $38
5FAD  FF            rst  $38
5FAE  FF            rst  $38
5FAF  FF            rst  $38
5FB0  FF            rst  $38
5FB1  FF            rst  $38
5FB2  FF            rst  $38
5FB3  FF            rst  $38
5FB4  FF            rst  $38
5FB5  FF            rst  $38
5FB6  FF            rst  $38
5FB7  FF            rst  $38
5FB8  FF            rst  $38
5FB9  FF            rst  $38
5FBA  FF            rst  $38
5FBB  FF            rst  $38
5FBC  FF            rst  $38
5FBD  FF            rst  $38
5FBE  FF            rst  $38
5FBF  FF            rst  $38
5FC0  FF            rst  $38
5FC1  FF            rst  $38
5FC2  FF            rst  $38
5FC3  FF            rst  $38
5FC4  FF            rst  $38
5FC5  FF            rst  $38
5FC6  FF            rst  $38
5FC7  FF            rst  $38
5FC8  FF            rst  $38
5FC9  FF            rst  $38
5FCA  FF            rst  $38
5FCB  FF            rst  $38
5FCC  FF            rst  $38
5FCD  FF            rst  $38
5FCE  FF            rst  $38
5FCF  FF            rst  $38
5FD0  FF            rst  $38
5FD1  FF            rst  $38
5FD2  FF            rst  $38
5FD3  FF            rst  $38
5FD4  FF            rst  $38
5FD5  FF            rst  $38
5FD6  FF            rst  $38
5FD7  FF            rst  $38
5FD8  FF            rst  $38
5FD9  FF            rst  $38
5FDA  FF            rst  $38
5FDB  FF            rst  $38
5FDC  FF            rst  $38
5FDD  FF            rst  $38
5FDE  FF            rst  $38
5FDF  FF            rst  $38
5FE0  FF            rst  $38
5FE1  FF            rst  $38
5FE2  FF            rst  $38
5FE3  FF            rst  $38
5FE4  FF            rst  $38
5FE5  FF            rst  $38
5FE6  FF            rst  $38
5FE7  FF            rst  $38
5FE8  FF            rst  $38
5FE9  FF            rst  $38
5FEA  FF            rst  $38
5FEB  FF            rst  $38
5FEC  FF            rst  $38
5FED  FF            rst  $38
5FEE  FF            rst  $38
5FEF  FF            rst  $38
5FF0  FF            rst  $38
5FF1  FF            rst  $38
5FF2  FF            rst  $38
5FF3  FF            rst  $38
5FF4  FF            rst  $38
5FF5  FF            rst  $38
5FF6  FF            rst  $38
5FF7  FF            rst  $38
5FF8  FF            rst  $38
5FF9  FF            rst  $38
5FFA  FF            rst  $38
5FFB  FF            rst  $38
5FFC  FF            rst  $38
5FFD  FF            rst  $38
5FFE  FF            rst  $38
5FFF  FF            rst  $38

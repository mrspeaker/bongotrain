                ;; Bongo by JetSoft
                ;; picked apart by Mr Speaker
                ;; https://www.mrspeaker.net

                ;; (NOTE: all just find/replace in a text editor:
                ;; so don't try and compile me!)

                ;; Overview:
                ;; - BIG_RESET ($1000) inits and starts loop
                ;; - Main loop is at MAIN_LOOP ($104b)
                ;; - ... which calls UPDATE_EVERYTHING ($1170)
                ;; - Also a NMI interrupt loop ($66)
                ;; - ... which calls hardware-y stuff

                ;; Important Bongo lore:
                ;; - We decided "Bongo" is actually name of the lil' jumpy
                ;;   guy in the corner of the screen, not the player.
                ;;   He's complicated: celebrates the player's death,
                ;;   but also parties with player on dino capture.

                tick_mod_3        = $8000  ; timer for every 3 frames
                tick_mod_6        = $8001  ; timer for every 6 frames
                pl_y_legs_copy    = $8002  ; copy of player y legs?
                _8003             = $8003  ; ? used with 8002 s bunch
                player_num        = $8004  ; current player
                jump_triggered    = $8005  ; jump triggered by setting jump_tbl_idx
                second_timer      = $8006
                p1_time           = $8007  ; time of player's run: never displayed!
                p1_timer_h        = $8008  ; hi byte of timer 1
                p2_time           = $8009  ; ...we could have had speed running!
                p2_timer_h        = $800A  ; hi byte of timer 2
                controls          = $800B  ; 0010 0000 = jump, 1000 = right, 0100 = left
                buttons_1         = $800C  ; P1/P2 buttons... and?
                buttons_2         = $800D  ; ... more buttons?
                controlsn         = $800E  ; some kind of "normalized" controls
                jump_tbl_idx      = $800F  ; index into table for physics jump
                walk_anim_timer   = $8010  ; % 7?
                falling_timer     = $8011  ; set to $10 when falling - if hits 0, dead.
                player_died       = $8012  ; 0 = no, 1 = yep, dead
                p1_score          = $8014  ; and 8015, 8016 (BCD score)
                p2_score          = $8017  ; and 8018, 8019 (BCD score)
                _unused_1         = $801B  ; unused? Set once, never read
                score_to_add      = $801D  ; amount to add to the current score

                screen_ram_ptr    = $801E  ; maybe it's where to start drawing bg?
                level_bg_ptr      = $8020  ; screen data pointer (2 byte addr)

                did_init          = $8022  ; set after first init, not really used
                bongo_anim_timer  = $8023  ; [0,1,2] updated every 8 ticks
                bongo_jump_timer  = $8024  ; amount of ticks keep jumping for
                bongo_dir_flag    = $8025  ; 4 = jump | 2 = left | 1 = right
                bongo_timer       = $8027  ; ticks 0-1f for troll

                screen_num        = $8029  ; Current screen player is on
                screen_num_p2     = $802A  ; Player 2 screen
                _802c             = $802C  ; ??
                dino_counter      = $802D  ; Ticks up when DINO_TIMER is done
                dino_dir          = $802E  ; 01 = right, ff = left

                player_max_x      = $8030  ; furthest x pos (used for move score)
                is_2_players      = $8031  ; 1=2p, 0=1p mode (not used much)
                lives             = $8032
                lives_p2          = $8033
                num_players       = $8034  ; attract mode = 0, 1P = 1, 2P = 2
                credits_umm       = $8035  ; something to do with credits

                ;; Enemies: seems to be mix-and-match per screen
                rock_fall_timer   = $8036  ; resets falling pos of rock
                enemy_1_active    = $8037  ; not really "active":  has many values.
                enemy_1_timer     = $8038  ; unused?
                enemy_2_active    = $8039  ;
                enemy_2_timer     = $803A  ;
                enemy_3_active    = $803B  ;
                enemy_3_timer     = $803C  ;
                enemy_4_active    = $803D  ; ...1 - active as well? two kinds of active?
                rock_left_timer   = $803E  ; Rock left timer
                _803f             = $803F  ; ...2
                _8040             = $8040  ; ?
                enemy_6_active    = $8041  ;

                ch1_sfx           = $8042  ; 2 = dead, e = re/spawn, 6 = cutscene, 7 = cutscene end dance, 9 = ?...
                ch2_sfx           = $8043  ; SFX channel 2
                sfx_id            = $8044  ; queued sound effect ID to play

                1up_scr_pos       = $804C  ; I reckon its where the 1up bonus text is on screen
                1up_scr_pos_2     = $804E  ; ... but not used I reckon,
                1up_scr_pos_3     = $804F  ; ... as they decided not to clear the text

                1up_timer         = $8050  ; This is never read- but looks like was going to remove 1up text
                is_hit_cage       = $8051  ; did player trigger cage?
                speed_delay_p1    = $805B  ; speed for dino/rocks, start=1f, 10, d, then dec 2...
                speed_delay_p2    = $805C  ; ...until dead. Smaller delay = faster dino/rock fall
                dino_timer        = $805D  ; timer based on SPEED_DELAY (current round)

                bonuses           = $8060  ; How many bonuses collected
                bonus_mult        = $8062  ; Bonus multiplier.

                splash_anim_fr    = $8064  ; cycles 0-2 maybe... splash anim counter
                sfx_prev          = $8065  ; prevent retrigger effect?

                _8066             = $8066  ; ?? OE when alive, 02 when dead?
                _8067             = $8067  ; ?? used with 66
                _8068             = $8068  ; ?? used with 67

                extra_got_p1      = $8070  ; P1 Earned extra life
                extra_got_p1      = $8071  ; P2 Earned extra life

                hiscore_timer     = $8075  ; Countdown for entering time in hiscore screen
                hiscore_timer2    = $8076  ; 16 counter for countdown


                ;; Bunch of unused/debugs/tmps?
                _8086             = $8086  ; set in hiscore, never read
                _8090             = $8090  ; set to 1, never read?
                _8093             = $8093  ; set to $20 in coinage... hiscore, cursor?
                _8094             = $8094  ; unused? used with 8093

                screen_xoff_col   = $8100  ; OFFSET and COL for each row of tiles
                ; Gets memcpy'd to $9800


                ;;; ======== SPRITES ========
                ;;; all have the form: X, FRAME, COL, Y.
                player_x          = $8140
                player_frame      = $8141
                player_col        = $8142
                player_y          = $8143
                player_x_legs     = $8144
                player_frame_legs = $8145
                player_col_legs   = $8146
                player_y_legs     = $8147
                bongo_x           = $8148
                bongo_frame       = $8149
                bongo_col         = $814A
                bongo_y           = $814B
                dino_x            = $814C
                dino_frame        = $814D
                dino_col          = $814E
                dino_y            = $814F
                dino_x_legs       = $8150
                dino_frame_legs   = $8151
                dino_col_legs     = $8152
                dino_y_legs       = $8153
                enemy_1_x         = $8154
                enemy_1_frame     = $8155
                enemy_1_col       = $8156
                enemy_1_y         = $8157
                enemy_2_x         = $8158
                enemy_2_frame     = $8159
                enemy_2_col       = $815A
                enemy_2_y         = $815B
                enemy_3_x         = $815C
                enemy_3_frame     = $815D
                enemy_3_col       = $815E
                enemy_3_y         = $815F
                ;;; ============================

                platform_xoffs    = $8180  ; maybe

                synth1            = $82A0  ; bunch of bytes for sfx
                synth2            = $82A8  ; bunch of bytes for sfx
                synth3            = $82B0  ; bunch of bytes for sfx

                hiscore           = $8300  ;
                hiscore_1         = $8301  ;
                hiscore_2         = $8302

                credits           = $8303  ; how many credits in machine
                _8305             = $8305  ; Coins? dunno
                hiscore_name      = $8307  ; - $8310: Start of HI-SCORE text message area (10 bytes)

                tick_num          = $8312  ; adds 1 every tick
                ;; NOTE: TICK_MOD is sped up after round 1!
                tick_mod_fast     = $8315  ; % 3 in round 1, % 2 in round 2+
                tick_mod_slow     = $8316  ; % 6 in round 1, % 4 in round 2+. (offset by 1 from $8001)

                stack_location    = $83F0  ; I think?
                input_buttons     = $83F1  ; copied to 800C and 800D
                input_buttons_2   = $83F2  ; dunno what buttons

                ;;;  constants

                screen_width      = $E0  ; 224
                scr_tile_w        = $1A  ; 26 columns (just playable? TW=27.)
                scr_tile_h        = $1C  ; 28 rows    (only playable area? TH=31.)
                num_screens       = $1B  ; 27 screens

                round1_speed      = $1F
                round2_speed      = $10
                round3_speed      = $0D

                fr_rock_1         = $1D
                fr_spear          = $22
                fr_bird_1         = $23
                fr_bird_2         = $24
                fr_blue_1         = $34
                fr_blue_2         = $35

                tile_0            = $00
                tile_9            = $09
                tile_blank        = $10
                tile_a            = $11
                tile_e            = $15
                tile_r            = $22
                tile_hyphen       = $2B

                tile_cage         = $74       ; - $7f
                tile_cursor       = $89
                tile_crown_pika   = $8C ; alt crown
                tile_pik_crossa   = $8D
                tile_pik_ringa    = $8E
                tile_pik_vasea    = $8F
                tile_crown_pik    = $9C
                tile_pik_cross    = $9D
                tile_pik_ring     = $9E
                tile_pik_vase     = $9F
                tile_lvl_01       = $C0

                ;; tile > $F8 is a platform
                tile_solid        = $F8 ; high-wire platform R
                tile_platform_r   = $FC
                tile_platform_c   = $FD
                tile_platform_l   = $FE

                scr_line_prev     = $FFE0       ; -32 = previous screen line

                ;;; hardware

                screen_ram        = $9000 ; - 0x93ff  videoram
                start_of_tiles    = $9040 ; top right tile
                end_of_tiles      = $93BF ; bottom left tile
                ;; what's all the stuff in herer?
                xoff_col_ram      = $9800 ; xoffset and color data per tile row
                sprites           = $9840 ; 0x9800 - 0x98ff is spriteram
                port_in0          = $A000 ;
                port_in1          = $A800 ;
                port_in2          = $B000 ;
                int_enable        = $B001 ; interrupt enable
                _B006             = $B006 ; set to 1 for P1 or
                _B007             = $B007 ; 0 for P2... why? Controls?
                watchdog          = $B800 ; main timer?

                ;;; ============ START OF BG1.BIN =============

                hard_reset:
0000  A2            and  d
0001  3201B0        ld   ($B001),a
0004  32FF80        ld   ($80FF),a
0007  3EFF          ld   a,$FF
0009  3200B8        ld   ($B800),a
000C  C3A014        jp   $14A0 ; jumps back here after clear
000F  31F083        ld   sp,$83F0
0012  CD003F        call $3F00
0015  CD4800        call $0048
0018  CD8822        call $2288
001B  C38D00        jp   $008D

                ;; data?
001E                db $DD,$19,$DD,$19,$2B,$10,$AF
0025                db $ED,$67,$DD,$77,$ED,$6F,$DD
002C                db $DD,$19,$ED,$6F,$DD

0031                dc 7, $FF

                ;;  Reset vector
                reset_vector:
0038  3A00B8        ld   a,($B800)
003B  18FB          jr   $0038

003D                dc 11, $FF

                ;; Called once at startup
                init_screen:
0048  3A00A0        ld   a,($A000)
004B  E683          and  $83 ; 1000 0011
004D  C8            ret  z
004E  CD7014        call $1470
0051  CD1003        call $0310
0054                db $09, $00
0056                db $13,$22,$15,$14,$19,$24,$10,$16,$11,$25,$1C,$24,$FF ; CREDIT FAULT
0063  18E3          jr   $0048

0065  FF            db   $FF

                ;; Non-Maskable Interrupt handler. Fires every frame
                nmi_loop:
0066  AF            xor  a
0067  3201B0        ld   ($B001),a
006A  3A00B8        ld   a,($B800)
006D  CDC000        call $00C0
0070  3A3480        ld   a,($8034)
0073  A7            and  a
0074  2003          jr   nz,$0079
0076  CD9001        call $0190
0079  0601          ld   b,$01
007B  CD0011        call $1100 ; update ticks...
007E  CD2024        call $2420
0081  00            nop
0082  3A00A0        ld   a,($A000)
0085  CB4F          bit  1,a
0087  C203C0        jp   nz,$C003 ; c003?!
008A  ED45          retn ; NMI return

008C  FF            db   $FF

                setup_then_start_game:
008D  CD4803        call $0348
0090  CD8030        call $3080
                _after_game_over:
0093  CDA013        call $13A0
0096  3A0383        ld   a,($8303)
0099  A7            and  a
009A  2008          jr   nz,$00A4
009C  CD7003        call $0370
009F  CD7014        call $1470
00A2  18EF          jr   $0093
                _play_splash:
00A4  CDA013        call $13A0
00A7  3A0383        ld   a,($8303)
00AA  FE01          cp   $01
00AC  2005          jr   nz,$00B3
00AE  CDD000        call $00D0
00B1  1803          jr   $00B6
00B3  CD4001        call $0140
00B6  3A3480        ld   a,($8034)
00B9  A7            and  a
00BA  C2E701        jp   nz,$01E7
00BD  18E5          jr   $00A4

00BF  FF            db   $FF

                nmi_int_handler:
00C0  D9            exx
00C1  CD8802        call $0288
00C4  CD5015        call $1550
00C7  CD6029        call $2960
00CA  CDD001        call $01D0
00CD  D9            exx
00CE  C9            ret

00CF  FF            db   $FF

                ;;;
                attract_press_p1_screen:
00D0  3E01          ld   a,$01
00D2  329080        ld   ($8090),a
00D5  AF            xor  a
00D6  3204B0        ld   ($B004),a
00D9  3A0383        ld   a,($8303)
00DC  47            ld   b,a
00DD  3A3580        ld   a,($8035)
00E0  B8            cp   b
00E1  C8            ret  z ; credits == credits_um
00E2  00            nop
00E3  00            nop
00E4  00            nop
00E5  CD8014        call $1480
00E8  21E00F        ld   hl,$0FE0
00EB  CD4008        call $0840
00EE                db   $00, $00 ; params to DRAW_SCREEN
00F0  CD5024        call $2450
00F3  CD1003        call $0310
00F6                db   $09, $0B
00F8                db   $20,$22,$15,$23,$23,$FF ; PRESS
00FE  CD1003        call $0310
0101                db   $0C, $09
0103                db   $1F,$1E,$15,$10,$20,$1C,$11,$29,$15,$22,$FF ; ONE PLAYER
010E  CD1003        call $0310
0111                db   $0F, $8B
0113                db   $12,$25,$24,$24,$1F,$1E,$FF ; BUTTON
011A  CD1003        call $0310
011D                db   $19, $09
011F                db   $13,$22,$15,$14,$19,$24,$23,$FF ; CREDITS
0127  210383        ld   hl,$8303
012A  AF            xor  a
012B  ED6F          rld
012D  329991        ld   ($9199),a
0130  ED6F          rld
0132  327991        ld   ($9179),a
0135  ED6F          rld
0137  3A0383        ld   a,($8303)
013A  323580        ld   ($8035),a
013D  C9            ret

013E                dc   2, $FF

                ;;
                draw_one_or_two_player:
0140  CD3024        call $2430
0143  3A0383        ld   a,($8303)
0146  47            ld   b,a
0147  3A3580        ld   a,($8035)
014A  B8            cp   b
014B  00            nop
014C  CDD000        call $00D0
014F  CD1003        call $0310
0152                db   $0C, $06
0154                db   $1F,$1E,$15,$10,$1F,$22,$10,$24,$27,$1F,$10,$20,$1C,$11,$29,$15
0164                db   $22,$FF,$C9,$FF  ; ONE OR TWO PLAYER
                    ;; Does it fall through here?
0168                dc   8,$FF

0170  CD2000        call $0020
0173  C9            ret

0174                dc   12,$FF

                ;; called a lot (via... JMP_HL_PLUS_4K)
                ;; why? Why not just jump?
                ;; Is there a max jump distance or something?
                do_jmp_hl_plus_4k:
0180  C5            push bc
0181  010040        ld   bc,$4000
0184  09            add  hl,bc
0185  C1            pop  bc
0186  E9            jp   (hl)

0187                dc   9,$FF

                did_player_press_start:; Did player start the game?
0190  3A0383        ld   a,($8303) ; check you have credits
0193  A7            and  a
0194  C8            ret  z
0195  3AF183        ld   a,($83F1) ; P1 pressed?
0198  CB47          bit  0,a
019A  2811          jr   z,$01AD
019C  CD6014        call $1460
019F  3E01          ld   a,$01 ; start the game, 1 player
01A1  323480        ld   ($8034),a
01A4  3A0383        ld   a,($8303) ; use a credit
01A7  3D            dec  a
01A8  27            daa
01A9  320383        ld   ($8303),a
01AC  C9            ret
01AD  3A0383        ld   a,($8303)
01B0  3D            dec  a
01B1  C8            ret  z
01B2  3AF183        ld   a,($83F1)
01B5  CB4F          bit  1,a ; is P2 pressed?
01B7  C8            ret  z
01B8  CD6014        call $1460
01BB  3E02          ld   a,$02 ; start the game, 2 player
01BD  323480        ld   ($8034),a
01C0  3A0383        ld   a,($8303)
01C3  3D            dec  a
01C4  27            daa
01C5  3D            dec  a
01C6  27            daa
01C7  320383        ld   ($8303),a
01CA  C9            ret

01CB                dc   5,$FF

                ;;;
                copy_ports_to_buttons:
01D0  3A00A0        ld   a,($A000)
01D3  320B80        ld   ($800B),a
01D6  3AF183        ld   a,($83F1)
01D9  320C80        ld   ($800C),a
01DC  3AF283        ld   a,($83F2)
01DF  320D80        ld   ($800D),a
01E2  C9            ret

                ;;
                jmp_hl_plus_4k:
01E3  C38001        jp   $0180
01E6  C9            ret

                start_game:
01E7  3E1F          ld   a,$1F
01E9  325B80        ld   ($805B),a
01EC  325C80        ld   ($805C),a
01EF  00            nop
01F0  3AF283        ld   a,($83F2) ; from dip-switch settings?
01F3  E606          and  $06
01F5  CB2F          sra  a
01F7  C602          add  a,$02
01F9  323280        ld   ($8032),a
01FC  323380        ld   ($8033),a
01FF  3A3480        ld   a,($8034)
0202  3D            dec  a
0203  323180        ld   ($8031),a ; 0 = 1P, 1 = 2P
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
                post_death_reset:
0220  31F083        ld   sp,$83F0 ; hmm. sets stack pointer?
0223  3A0480        ld   a,($8004) ; flip flops?!
0226  EE01          xor  $01
0228  320480        ld   ($8004),a
022B  213280        ld   hl,$8032
022E  85            add  a,l
022F  6F            ld   l,a
0230  7E            ld   a,(hl)
0231  A7            and  a
0232  2012          jr   nz,$0246
0234  3A0480        ld   a,($8004) ; and back again?
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
024B  CB7F        bit  7,a ; what is this "button"?!
024D  2811          jr   z,$0260
024F  3A0480        ld   a,($8004)
0252  FE01          cp   $01
0254  200A          jr   nz,$0260
0256  3E01          ld   a,$01
0258  3206B0        ld   ($B006),a ; a = 1 if P1,
025B  3207B0        ld   ($B007),a
025E  1807          jr   $0267
0260  AF            xor  a ; 0 if P2
0261  3206B0        ld   ($B006),a
0264  3207B0        ld   ($B007),a
0267  3AF283        ld   a,($83F2)
026A  CB5F          bit  3,a ; is this INfinite Lives DIP setting? resets lives on death
026C  2810          jr   z,$027E
026E  3E03          ld   a,$03 ; set 3 lives
0270  323280        ld   ($8032),a
0273  3A3380        ld   a,($8033)
0276  A7            and  a
0277  2805          jr   z,$027E
0279  3E03          ld   a,$03
027B  323380        ld   ($8033),a
027E  C30010        jp   $1000

0281                dc   7, $FF

                coinage_routine:
0288  3A0683        ld   a,($8306)
028B  A7            and  a
028C  2811          jr   z,$029F
028E  3D            dec  a
028F  320683        ld   ($8306),a
0292  C0            ret  nz
0293  3A00A0        ld   a,($A000)
0296  E603          and  $03
0298  C8            ret  z
0299  3E05          ld   a,$05
029B  320683        ld   ($8306),a
029E  C9            ret
029F  3A00A0        ld   a,($A000)
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
02C9  CB77          bit  6,a ; added credit
02CB  2816          jr   z,$02E3
02CD  3A0583        ld   a,($8305)
02D0  A7            and  a
02D1  C8            ret  z
02D2  47            ld   b,a
02D3  3A0383        ld   a,($8303)
02D6  3C            inc  a
02D7  27            daa
02D8  05            dec  b
02D9  20FB          jr   nz,$02D6
02DB  320383        ld   ($8303),a
02DE  AF            xor  a
02DF  320583        ld   ($8305),a
02E2  C9            ret
02E3  3A0583        ld   a,($8305)
02E6  A7            and  a
02E7  C8            ret  z
02E8  FE01          cp   $01
02EA  C8            ret  z
02EB  47            ld   b,a
02EC  3A0383        ld   a,($8303)
02EF  3C            inc  a
02F0  27            daa
02F1  05            dec  b
02F2  2805          jr   z,$02F9
02F4  05            dec  b
02F5  280D          jr   z,$0304
02F7  18F6          jr   $02EF
02F9  3D            dec  a
02FA  27            daa
02FB  320383        ld   ($8303),a
02FE  3E01          ld   a,$01
0300  320583        ld   ($8305),a
0303  C9            ret
0304  320383        ld   ($8303),a
0307  AF            xor  a
0308  320583        ld   ($8305),a
030B  C9            ret

030C                dc   4, $FF

                ;; draw sequence of tiles at (y, x)
                draw_tiles_h:
0310  3A00B8        ld   a,($B800)
0313  214090        ld   hl,$9040
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
                _lp_032E:
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

033E                dc   10, $FF

                ;;
                setup_more:
0348  00            nop
0349  00            nop
034A  00            nop
034B  CD7014        call $1470
034E  210080        ld   hl,$8000 ; reset $8000-$88FF? to 0
                _lp_0351:
0351  3600          ld   (hl),$00
0353  2C            inc  l
0354  20FB          jr   nz,$0351
0356  24            inc  h
0357  3A00B8        ld   a,($B800)
035A  7C            ld   a,h
035B  FE88          cp   $88
035D  20F2          jr   nz,$0351
035F  31F083        ld   sp,$83F0
0362  3E01          ld   a,$01
0364  329080        ld   ($8090),a
0367  C38305        jp   $0583

036A                dc   6, $FF

                reset_ents_all:
0370  CD7014        call $1470
0373  212015        ld   hl,$1520 ; RESET_SFX_SOMETHING_1
0376  CDE301        call $01E3 ; $4520
0379  21200E        ld   hl,$0E20 ; ATTRACT_SPLASH_BONGO
037C  CDE301        call $01E3 ; $4220
037F  21C017        ld   hl,$17C0
0382  CDE301        call $01E3 ; $57C0
0385  21A015        ld   hl,$15A0 ; $CHASED_BY_A_DINO_SCREEN
0388  CDE301        call $01E3 ; $55A0
038B  00            nop
038C  00            nop
038D  00            nop
038E  C9            ret

038F  FF            db   $FF

0390  CDA013        call $13A0
0393  18FB          jr   $0390

0395                dc   11, $FF

                draw_lives:
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

03E7  FF            db   $FF

                clear_after_game_over:
03E8  AF            xor  a
03E9  323480        ld   ($8034),a
03EC  323580        ld   ($8035),a
03EF  C39300        jp   $0093

03F2                dc   6, $FF

03F8  0EE0          ld   c,$E0
03FA  CDA013        call $13A0
03FD  0C            inc  c
03FE  20FA          jr   nz,$03FA
0400  C9            ret

0401                dc  7, $FF

                set_lives_row_color:
0408  3E01          ld   a,$01
040A  320581        ld   ($8105),a
040D  C9            ret

040E                dc   2, $FF

                game_over:
0410  21E816        ld   hl,$16E8 ; $SFX_RESET_A_BUNCH-$4000
0413  CDE301        call $01E3
0416  CDE024        call $24E0
0419  CD3004        call $0430
041C  CD7014        call $1470
041F  AF            xor  a
0420  3204B0        ld   ($B004),a
0423  C3002D        jp   $2D00

0426                dc   10, $FF

                check_if_hiscore:
0430  CD4004        call $0440
0433  CD7004        call $0470
0436  C9            ret

0437                dc   9, $FF

                check_if_hiscore_p1:
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

046A                dc   6, $FF

                check_if_hiscore_p2:
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

049A                dc   22, $FF

04B0  0E01          ld   c,$01
04B2  CDA013        call $13A0
04B5  0D            dec  c
04B6  20FA          jr   nz,$04B2
04B8  C9            ret

04B9                dc   1, $FF

                ;; count up timer - every SPEED_DELAY ticks
                check_dino_timer:
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
04D0  B8            cp   b ; have done SPEED_DELAY ticks?
04D1  2001          jr   nz,$04D4
04D3  AF            xor  a
04D4  325D80        ld   ($805D),a
04D7  A7            and  a
04D8  C0            ret  nz
04D9  CDF022        call $22F0
04DC  C9            ret

04DD                dc   3, $FF

                hiscore_for_p1:
04E0  3A1480        ld   a,($8014)
04E3  320083        ld   ($8300),a
04E6  3A1580        ld   a,($8015)
04E9  320183        ld   ($8301),a
04EC  3A1680        ld   a,($8016)
04EF  320283        ld   ($8302),a
04F2  E1            pop  hl ; hmm
04F3  C9            ret

04F4                dc   12, $FF

                hiscore_for_p2:
0500  3A1780        ld   a,($8017)
0503  320083        ld   ($8300),a
0506  3A1880        ld   a,($8018)
0509  320183        ld   ($8301),a
050C  3A1980        ld   a,($8019)
050F  320283        ld   ($8302),a
0512  E1            pop  hl ; hmm
0513  C9            ret

0514                dc   4, $FF

                ;; who calls?
                ;; This looks suspicious. 25 bytes written
                ;; to $8038+, code is never called (or read?)
                ;; wpset 0518,18,rw doesn't trigger
0518  213880        ld   hl,$8038
051B  3639          ld   (hl),$39 ; 57
051D  23            inc  hl
051E  3639          ld   (hl),$39 ; enemy_2_active
0520  23            inc  hl
0521  3639          ld   (hl),$39 ; enemy_2_timer
0523  23            inc  hl
0524  3639          ld   (hl),$39 ; enemy_3_active
0526  23            inc  hl
0527  3638          ld   (hl),$38
0529  23            inc  hl
052A  3639          ld   (hl),$39
052C  23            inc  hl
052D  3639          ld   (hl),$39
052F  23            inc  hl
0530  3639          ld   (hl),$39
0532  23            inc  hl ; 8040
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

0569                dc   23, $FF

                ;; (free bytes?)
                _setup_2:;looks a lot like SETUP_THEN_START_GAME - no one calls it?
0580  CD4803        call $0348
                _setup_more_ret:                ; returns here after setup_more
0583  CD8030        call $3080
                _play_splash_2:
0586  CDA013        call $13A0
0589  3A3480        ld   a,($8034)
058C  A7            and  a
058D  201C          jr   nz,$05AB
058F  3A0383        ld   a,($8303)
0592  A7            and  a
0593  2008          jr   nz,$059D
0595  CD7003        call $0370
0598  CD7014        call $1470
059B  18E9          jr   $0586
059D  FE01          cp   $01
059F  2005          jr   nz,$05A6
05A1  CDD000        call $00D0
05A4  18E0          jr   $0586
05A6  CD4001        call $0140
05A9  18DB          jr   $0586
05AB  C2E701        jp   nz,$01E7
05AE  18D6          jr   $0586

05B0                dc   8, $FF

                ;; who calls?
05B8  3A0383        ld   a,($8303)
05BB  A7            and  a
05BC  2004          jr   nz,$05C2
05BE  CDA013        call $13A0
05C1  C9            ret
05C2  CDA013        call $13A0
05C5  E1            pop  hl
05C6  E1            pop  hl
05C7  E1            pop  hl
05C8  C9            ret

05C9                dc   7, $FF

                ;; Not really sure.
                normalize_input:
05D0  3A0480        ld   a,($8004)
05D3  A7            and  a
05D4  2817          jr   z,$05ED
                ;; p2
05D6  3A0C80        ld   a,($800C)
05D9  CB7F          bit  7,a
05DB  2810          jr   z,$05ED ; p1 too?
05DD  3A0C80        ld   a,($800C)
05E0  E63C          and  $3C ; 0011 1100
05E2  47            ld   b,a
05E3  3A0B80        ld   a,($800B)
05E6  E640          and  $40 ; 0100 0000
05E8  80            add  a,b
05E9  320E80        ld   ($800E),a
05EC  C9            ret
                ;; p1
05ED  3A0B80        ld   a,($800B)
05F0  E63C          and  $3C ; 0011 1100
05F2  47            ld   b,a
05F3  3A0B80        ld   a,($800B)
05F6  E680          and  $80 ; 1000 0000
05F8  CB3F          srl  a
05FA  80            add  a,b
05FB  320E80        ld   ($800E),a
05FE  C9            ret

05FF                dc   9, $FF

                player_frame_data_walk_right:
0608                db  $0C,$0E,$10,$0E,$0C,$12,$14,$12
0610                dc   8, $FF

                player_move_right:
0618  3A1080        ld   a,($8010)
061B  3C            inc  a
061C  E607          and  $07 ; 0111
061E  321080        ld   ($8010),a
0621  210806        ld   hl,$0608
0624  85            add  a,l
0625  6F            ld   l,a
0626  7E            ld   a,(hl)
0627  324181        ld   ($8141),a
062A  3C            inc  a
062B  324581        ld   ($8145),a
062E  3A4081        ld   a,($8140)
0631  3C            inc  a ; move right 3px.
0632  3C            inc  a
0633  3C            inc  a
0634  324081        ld   ($8140),a
0637  324481        ld   ($8144),a
063A  00            nop
063B  00            nop
063C  00            nop
063D  C9            ret

063E                dc   10, $FF

                player_frame_data_walk_left:
0648                db   $8C,$8E,$90,$8E,$8C,$92,$94,$92
0650                dc   8, $FF

                player_move_left:
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
0671  3D            dec  a ; move left 3px
0672  3D            dec  a
0673  3D            dec  a
0674  324081        ld   ($8140),a
0677  324481        ld   ($8144),a
067A  00            nop
067B  00            nop
067C  00            nop
067D  C9            ret

067E                dc   10, $FF

                player_input:
0688  3A1283        ld   a,($8312)
068B  E603          and  $03
068D  C0            ret  nz
068E  3A1280        ld   a,($8012)
0691  A7            and  a
0692  C0            ret  nz ; dead, get out
0693  3A0F80        ld   a,($800F)
0696  A7            and  a
0697  C0            ret  nz ; don't do this input if jumping?
0698  3A0E80        ld   a,($800E)
069B  CB6F          bit  5,a ; jump pressed? 0010 0000
069D  2817          jr   z,$06B6
069F  CD1007        call $0710
06A2  CB57          bit  2,a ; not left? 0000 0100
06A4  2804          jr   z,$06AA
06A6  CDA007        call $07A0
06A9  C9            ret
06AA  CB5F          bit  3,a ; not right?
06AC  2804          jr   z,$06B2
06AE  CDC007        call $07C0
06B1  C9            ret
06B2  CDC008        call $08C0
06B5  C9            ret
                ;; no jump: left/right?
                _no_jump:
06B6  CB57          bit  2,a ; is left?
06B8  2804          jr   z,$06BE
06BA  CD5806        call $0658
06BD  C9            ret
06BE  CB5F          bit  3,a ; is right?
06C0  2804          jr   z,$06C6
06C2  CD1806        call $0618
06C5  C9            ret
                ;; looks like bit 4 and 6 aren't used (up/dpwn?)
06C6  CB67          bit  4,a ; ?
06C8  2804          jr   z,$06CE
06CA  00            nop
06CB  00            nop
06CC  00            nop
06CD  C9            ret
                ;; bit 6?
06CE  CB77          bit  6,a
06D0  C8            ret  z
06D1  00            nop
06D2  00            nop
06D3  00            nop
06D4  C9            ret

06D5                dc   3, $FF

                ;; "Physics": do jumps according to jump lookup tables
                player_physics:
06D8  00            nop
06D9  00            nop
06DA  00            nop
06DB  00            nop
06DC  00            nop
06DD  3A0F80        ld   a,($800F)
06E0  3D            dec  a ; idx - 1
06E1  320F80        ld   ($800F),a
06E4  CB27          sla  a ; * 2
06E6  CB27          sla  a ; * 2 = 4th byte in table row
06E8  85            add  a,l
06E9  6F            ld   l,a
06EA  DD214081      ld   ix,$8140
06EE  7E            ld   a,(hl) ; reads from the PHYS_JUMP_LOOKUP_XXX tables
06EF  DD8600        add  a,(ix+$00) ; player x
06F2  DD7700        ld   (ix+$00),a ; player x
06F5  DD7704        ld   (ix+$04),a ; player_x_legs
06F8  23            inc  hl
06F9  7E            ld   a,(hl)
06FA  DD7701        ld   (ix+$01),a ; frame
06FD  23            inc  hl
06FE  7E            ld   a,(hl)
06FF  DD7705        ld   (ix+$05),a ; legs frame
0702  23            inc  hl
0703  7E            ld   a,(hl)
0704  DD8607        add  a,(ix+$07) ; player y legs?
0707  DD7707        ld   (ix+$07),a
070A  D610          sub  $10
070C  DD7703        ld   (ix+$03),a ; player y
070F  C9            ret

                ;; jump pressed, sets these... why?
                ;; 804a and 8049 never read?
                ;; wpset 804a,1,r never triggers?
                set_unused_804a_49:
0710  F5            push af
0711  3EA0          ld   a,$A0
0713  324A80        ld   ($804A),a
0716  3E0F          ld   a,$0F
0718  324980        ld   ($8049),a
071B  F1            pop  af
071C  C9            ret

                ;; wassis?
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

                ;; x-off, head-anim, leg-anim, yoff
                phys_jump_lookup_left:
0728                db   $FA,$8C,$8D,$0C
072C                db   $FA,$8E,$8F,$0C
0730                db   $FA,$90,$91,$06
0734                db   $FA,$90,$96,$00
0738                db   $FA,$90,$91,$FA
073C                db   $FA,$8E,$8F,$F4
0740                db   $FA,$8C,$8D,$F4

0744                dc   12, $FF

                ;; x-off, head-anim, leg-anim, yoff
                phys_jump_lookup_right:
0750                db   $06,$0C,$0D,$0C
0754                db   $06,$0E,$0F,$0C
0758                db   $06,$10,$11,$06
075C                db   $06,$10,$16,$00
0760                db   $06,$10,$11,$FA
0764                db   $06,$0E,$0F,$F4
0768                db   $06,$0C,$0D,$F4

076C                dc   8, $FF

                ;; only runs every "tick_mod_slow" frames
                apply_jump_physics:
0774  3A1683        ld   a,($8316) ; speeds up after round 1
0777  E607          and  $07
0779  C0            ret  nz
077A  3A1280        ld   a,($8012)
077D  A7            and  a
077E  C0            ret  nz ; dead, get out
077F  3A0F80        ld   a,($800F) ; return if not mid jump tbl
0782  A7            and  a
0783  C8            ret  z
0784  3E01          ld   a,$01
0786  320580        ld   ($8005),a ; jump was triggererd
                ;; set the correct jump lookup table based on left, right, or none.
0789  3A0E80        ld   a,($800E)
078C  CB57          bit  2,a ; not left?
078E  2807          jr   z,$0797
0790  212807        ld   hl,$0728
0793  CDD806        call $06D8
0796  C9            ret
0797  C3E007        jp   $07E0

079A                dc   6, $FF

                ;;; jump button, but not jumping, and on ground, right
                trigger_jump_right:
07A0  3A0580        ld   a,($8005) ; already jumping, leave
07A3  A7            and  a
07A4  C0            ret  nz
07A5  3A0F80        ld   a,($800F) ; already jumping, leave
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

07BF                dc   1, $FF

                ;;; jump button, but not jumping, and on ground, left
                trigger_jump_left:
07C0  3A0580        ld   a,($8005) ; already jumping, leave
07C3  A7            and  a
07C4  C0            ret  nz
07C5  3A0F80        ld   a,($800F) ; already jumping, leave
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

07DF                dc   1, $FF

                ;; Right or no direction checkt
                phys_jump_set_right_or_up_lookup:
07E0  CB5F          bit  3,a ; right?
07E2  2807          jr   z,$07EB
07E4  215007        ld   hl,$0750
07E7  CDD806        call $06D8
07EA  C9            ret
07EB  214809        ld   hl,$0948 ; not left or right?
07EE  CDD806        call $06D8
07F1  C9            ret

07F2                dc   2, $FF

                play_jump_sfx:
07F4  324581        ld   ($8145),a
07F7  3E04          ld   a,$04 ; jump sfx
07F9  324380        ld   ($8043),a
07FC  C9            ret

07FD                dc   3, $FF

                ;; who calls? (free bytes)
                ;; this looks similar to other DRAW_TILES code, but tile data
                ;; is indirectly fetched via (bc) addresses.
                ;; I set a breakpoint here and played a bunch (even cutscene)
                ;; but could not get it to trigger... not used? debug?
0800  010000        ld   bc,$0000
0803  00            nop
0804  00            nop
0805  00            nop
0806  00            nop
0807  013A00        ld   bc,$003A
080A  B8            cp   b ; really?
                ;;
080B  214090        ld   hl,$9040
080E  C1            pop  bc ; stack return pointer into bc (ie, data)
080F  0A            ld   a,(bc) ; start_y
0810  03            inc  bc
0811  85            add  a,l
0812  6F            ld   l,a
0813  0A            ld   a,(bc) ; start_x
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
0826  0A            ld   a,(bc) ; addr hi byte
0827  5F            ld   e,a
0828  03            inc  bc
0829  0A            ld   a,(bc) ; addr lo byte
082A  57            ld   d,a
082B  03            inc  bc
082C  C5            push bc
                _lp_082D:
082D  1A            ld   a,(de)
082E  FEFF          cp   $FF ; $FF delimited
0830  C8            ret  z
0831  13            inc  de
0832  77            ld   (hl),a
0833  06FF          ld   b,$FF
0835  0EE0          ld   c,$E0
0837  09            add  hl,bc
0838  18F3          jr   $082D

083A                dc   6, $FF

                ;;
                draw_screen:
0840  E5            push hl
0841  D9            exx
0842  E1            pop  hl
0843  54            ld   d,h ; de = hl
0844  5D            ld   e,l
0845  214090        ld   hl,$9040
0848  C1            pop  bc
0849  0A            ld   a,(bc) ; param 1
084A  03            inc  bc
084B  85            add  a,l
084C  6F            ld   l,a
084D  0A            ld   a,(bc) ; param 2
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
0862  D1            pop  de ; ret ptr
0863  DD212C80      ld   ix,$802C
0867  DD360020      ld   (ix+$00),$20
                _lp_086B:
086B  1A            ld   a,(de) ; ret
086C  77            ld   (hl),a
086D  13            inc  de ; ret + 1
086E  01E0FF        ld   bc,$FFE0
0871  DD3500        dec  (ix+$00)
0874  AF            xor  a
0875  DDBE00        cp   (ix+$00)
0878  2806          jr   z,$0880
087A  09            add  hl,bc
087B  3A00B8        ld   a,($B800)
087E  18EB          jr   $086B
                _done_0880:
0880  D9            exx
0881  C9            ret

0882                dc   6, $FF

                clear_jump_button:
0888  3A0E80        ld   a,($800E)
088B  CB6F          bit  5,a ; jump
088D  C0            ret  nz
088E  AF            xor  a
088F  320580        ld   ($8005),a
0892  C9            ret

0893                dc   5, $FF

                init_player_sprite:
0898  214081        ld   hl,$8140
089B  3610          ld   (hl),$10 ; x
089D  23            inc  hl
089E  360C          ld   (hl),$0C ; frame
08A0  23            inc  hl
08A1  3612          ld   (hl),$12 ; color
08A3  23            inc  hl
08A4  36CE          ld   (hl),$CE ; y
08A6  23            inc  hl
08A7  3610          ld   (hl),$10 ; x legs
08A9  23            inc  hl
08AA  360D          ld   (hl),$0D ; frame legs
08AC  23            inc  hl
08AD  3612          ld   (hl),$12 ; color legs
08AF  23            inc  hl
08B0  36DE          ld   (hl),$DE ; y legs
08B2  CD2018        call $1820
08B5  C9            ret

08B6                dc   10, $FF

                trigger_jump_straight_up:
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

08DC                dc   12, $FF

                move_bongo_right:
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

0912                dc   6, $FF

                bongo_lookup3:
0918                db   $29,$2A,$2B,$2A,$FF,$FF,$FF,$FF
0920                db   $A9,$AA,$AB,$AA,$FF,$FF,$FF,$FF

0928                dc   8, $FF

                face_backwards_and_play_jump_sfx:
0930  3E18          ld   a,$18
0932  324581        ld   ($8145),a
0935  3E04          ld   a,$04
0937  324380        ld   ($8043),a
093A  C9            ret

093B                dc   13, $FF

                ;; jumping straight up
                ;; x-off, head-anim, leg-anim, yoff
                phys_jump_lookup_up:
0948                db   $00,$17,$18,$0C
094C                db   $00,$19,$1A,$0C
0950                db   $00,$1B,$1C,$06
0954                db   $00,$9B,$9C,$00
0958                db   $00,$99,$9A,$FA  ; -6
095C                db   $00,$97,$98,$F4  ; -12
0960                db   $00,$17,$18,$F4  ; -12

0964                dc   4, $FF

                ;; Get tile from x/y
                ;; in: h = x, l = y
                ;; out: hl = screen addr of tile
                get_tile_addr_from_xy:
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

0980                dc   8, $FF

                ;;; ground check
                ground_check:
0988  3A4781        ld   a,($8147)
098B  C610          add  a,$10 ; +  16   : the ground
098D  CB3F          srl  a ; /  2
098F  CB3F          srl  a ; /  2
0991  E6FE          and  $FE ; &  1111 1110
0993  210081        ld   hl,$8100
0996  85            add  a,l
0997  6F            ld   l,a
0998  3A4481        ld   a,($8144)
099B  96            sub  (hl)
099C  C608          add  a,$08 ; offset of 8
099E  67            ld   h,a
099F  3A4781        ld   a,($8147)
09A2  C610          add  a,$10
09A4  6F            ld   l,a
09A5  CD6809        call $0968

09A8  7E            ld   a,(hl)
09A9  E6F8          and  $F8
09AB  FEF8          cp   $F8
09AD  2802          jr   z,$09B1
09AF  AF            xor  a ; walkable tile
09B0  C9            ret
09B1  3E01          ld   a,$01 ; solid tile
09B3  C9            ret

09B4                dc   12, $FF

                check_if_landed_on_ground:      ; only when big fall?
09C0  3A1280        ld   a,($8012)
09C3  A7            and  a
09C4  C0            ret  nz ; dead, get out
09C5  3A0F80        ld   a,($800F)
09C8  A7            and  a
09C9  281B          jr   z,$09E6
09CB  E60C          and  $0C ; 1100 (only last 3 entries are falling)
09CD  C0            ret  nz ; not falling, leave
09CE  CD8809        call $0988
09D1  A7            and  a
09D2  C8            ret  z ; ret if in air?
09D3  AF            xor  a ; clear jump_tbl_idx
09D4  320F80        ld   ($800F),a
09D7  3A4181        ld   a,($8141)
09DA  E680          and  $80 ; set/clear face-left bit
09DC  C60C          add  a,$0C ; reset to first frame
09DE  324181        ld   ($8141),a
09E1  3C            inc  a
09E2  324581        ld   ($8145),a
09E5  C9            ret
                _jump_tble_idx_0:
09E6  CD8809        call $0988
09E9  A7            and  a
09EA  200B          jr   nz,$09F7
09EC  3A1180        ld   a,($8011)
09EF  A7            and  a
09F0  C0            ret  nz
09F1  3E10          ld   a,$10 ; start falling timer
09F3  321180        ld   ($8011),a
09F6  C9            ret
                _on_ground:
09F7  AF            xor  a ; reset
09F8  321180        ld   ($8011),a
09FB  CD680A        call $0A68
09FE  C9            ret

09FF                dc   9, $FF

                move_bongo_left:
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

0A32  FF            db   $FF

                kill_player:
0A33  00            nop ; weee, nopslide
0A34  00            nop
0A35  00            nop
0A36  00            nop
0A37  00            nop
0A38  3E01          ld   a,$01
0A3A  321280        ld   ($8012),a
0A3D  C9            ret

0A3E                dc   2, $FF

                ;; There's a bug in level one/two: if you jump of the
                ;; edge of level one, and hold jump... it bashes invisible
                ;; head barrier at the start of level two and dies.
                ;; (because of falling timer here).
                add_gravity_and_check_big_fall:
0A40  3A1180        ld   a,($8011) ; did we fall too far?
0A43  A7            and  a
0A44  C8            ret  z
0A45  3D            dec  a
0A46  321180        ld   ($8011),a
0A49  A7            and  a
0A4A  2004          jr   nz,$0A50
0A4C  CD330A        call $0A33 ; yep.
0A4F  C9            ret
                ;; Ok, what's this... "gravity"? always pushing down 2
0A50  3A4381        ld   a,($8143)
0A53  3C            inc  a ; Why? Looks suspicious - related to bug?
0A54  3C            inc  a ; force to ground I think
0A55  324381        ld   ($8143),a
0A58  C610          add  a,$10
0A5A  324781        ld   ($8147),a
0A5D  C9            ret

0A5E                dc   10, $FF

                    ;; TODO: figure out what this does to gameplay.
                    ;; what if it was removed?
                    ;; (Is this why it "snaps upwards" on my fake platform in nTn?)
                snap_y_to_8:
0A68  3A4381        ld   a,($8143)
0A6B  E6F8          and  $F8 ; 1111 1000
0A6D  324381        ld   ($8143),a
0A70  C610          add  a,$10
0A72  324781        ld   ($8147),a
0A75  C9            ret

0A76                dc   10, $FF

                check_head_hit_tile:
0A80  3A1280        ld   a,($8012)
0A83  A7            and  a
0A84  C0            ret  nz ; player dead, get outta here
0A85  3A4381        ld   a,($8143)
0A88  C601          add  a,$01
0A8A  CB3F          srl  a
0A8C  CB3F          srl  a
0A8E  E6FE          and  $FE
0A90  210081        ld   hl,$8100
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
0AA6  E6C0          and  $C0 ; 1100 0000
0AA8  FEC0          cp   $C0 ; whats a C0 tile?
0AAA  C0            ret  nz
0AAB  CDB80A        call $0AB8
0AAE  C9            ret

0AAF                dc   9, $FF

                fall_under_a_ledge:
0AB8  3A1180        ld   a,($8011)
0ABB  A7            and  a
0ABC  C0            ret  nz ; falling? Get outta here
0ABD  AF            xor  a
0ABE  320F80        ld   ($800F),a ; clear jump idx
0AC1  3E08          ld   a,$08
0AC3  321180        ld   ($8011),a ; set low fall
0AC6  CDA013        call $13A0
0AC9  CDA013        call $13A0
0ACC  C9            ret

0ACD                dc   3, $FF

                set_level_platform_xoffs:
0AD0  3A0480        ld   a,($8004)
0AD3  A7            and  a
0AD4  2005          jr   nz,$0ADB ; p2?
0AD6  3A2980        ld   a,($8029)
0AD9  1803          jr   $0ADE
0ADB  3A2A80        ld   a,($802A)
0ADE  3D            dec  a ; scr - 1
0ADF  21000B        ld   hl,$0B00
0AE2  CB27          sla  a ; scr - 1 * 2
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

0AF9                dc   7, $FF

                ;;; platform data. points to either $0c10 (moving) or $0c38 (static)
                platform_scroll_data_addr:
0B00                db $38,$0C,$38,$0C,$38,$0C,$38,$0C
0B0A                db $38,$0C,$38,$0C,$38,$0C,$38,$0C
0B12                db $38,$0C,$38,$0C,$38,$0C,$38,$0C
0B1A                db $38,$0C,$38,$0C,$38,$0C,$10,$0C
0B22                db $38,$0C,$38,$0C,$10,$0C,$38,$0C
0B2A                db $38,$0C,$38,$0C,$38,$0C,$38,$0C
0B32                db $38,$0C,$38,$0C,$10,$0C

                ;; 70 zeros/nops. That's a lotta nops. (free bytes?)
0B36                dc 70,$0

0B7C                dc   4, $FF

                move_moving_platform:
0B80  DD7E01        ld   a,(ix+$01) ; $PLATFORM_XOFFS+1
0B83  DD7703        ld   (ix+$03),a
0B86  DDCB0246      bit  0,(ix+$02)
0B8A  200A          jr   nz,$0B96
0B8C  FD3400        inc  (iy+$00) ; move right
0B8F  FD3402        inc  (iy+$02)
0B92  FD3404        inc  (iy+$04)
0B95  C9            ret
0B96  FD3500        dec  (iy+$00) ; move left
0B99  FD3502        dec  (iy+$02)
0B9C  FD3504        dec  (iy+$04)
0B9F  C9            ret

                reset_dino_counter:
0BA0  AF            xor  a
0BA1  322D80        ld   ($802D),a
0BA4  C9            ret

0BA5                dc   11, $FF

                moving_platforms:
0BB0  DD218081      ld   ix,$8180
0BB4  FD213881      ld   iy,$8138
0BB8  1609          ld   d,$09 ; loop 9 times
0BBA  DD7E01        ld   a,(ix+$01) ; xoff + 1
0BBD  A7            and  a
0BBE  2826          jr   z,$0BE6
0BC0  DD7E02        ld   a,(ix+$02) ; xoff + 2
0BC3  E6FE          and  $FE
0BC5  200F          jr   nz,$0BD6
0BC7  DD7E00        ld   a,(ix+$00) ; xoff
0BCA  E6FE          and  $FE
0BCC  DD8602        add  a,(ix+$02) ; xoff + 2
0BCF  EE01          xor  $01
0BD1  DD7702        ld   (ix+$02),a ; xoff + 2
0BD4  1806          jr   $0BDC
0BD6  DD3502        dec  (ix+$02)
0BD9  DD3502        dec  (ix+$02)
0BDC  DD7E03        ld   a,(ix+$03) ; xoff + 3
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

0BFE                dc   18, $FF

                platform_moving_data: ; All "S" levels.
0C10                db   $00,$00,$00,$00
0C14                db   $00,$00,$00,$00
0C18                db   $00,$00,$00,$00
0C1C                db   $F0,$03,$80,$03
0C20                db   $00,$00,$00,$00
0C24                db   $00,$00,$00,$00
0C28                db   $00,$00,$00,$00
0C2C                db   $00,$00,$00,$00
0C30                db   $00,$00,$00,$00

0C34                dc   4, $FF

                platform_static_data: ; All non-"S" levels.
0C38                db   $00,$00,$00,$00
0C3C                db   $00,$00,$00,$00
0C40                db   $00,$00,$00,$00
0C44                db   $00,$00,$00,$00
0C48                db   $00,$00,$00,$00
0C4C                db   $00,$00,$00,$00
0C50                db   $00,$00,$00,$00
0C54                db   $00,$00,$00,$00
0C58                db   $00,$00,$00,$00

0C5C                dc   4, $FF

                animate_player_to_ground_if_dead:
0C60  3A1280        ld   a,($8012)
0C63  A7            and  a
0C64  C8            ret  z ; player still alive... leave.
                _loop:
0C65  CDA013        call $13A0
0C68  3A4381        ld   a,($8143) ; push player towards ground
0C6B  3C            inc  a
0C6C  3C            inc  a
0C6D  3C            inc  a
0C6E  324381        ld   ($8143),a
0C71  C610          add  a,$10
0C73  324781        ld   ($8147),a
0C76  37            scf
0C77  3F            ccf
0C78  C610          add  a,$10
0C7A  3812          jr   c,$0C8E ; deaded.
0C7C  3A4081        ld   a,($8140)
0C7F  67            ld   h,a
0C80  3A4781        ld   a,($8147)
0C83  C620          add  a,$20
0C85  6F            ld   l,a
0C86  CD6809        call $0968
0C89  7E            ld   a,(hl)
0C8A  FE10          cp   $10 ; are we still in the air?
0C8C  28D7          jr   z,$0C65 ; keep falling
0C8E  CDC00C        call $0CC0
0C91  AF            xor  a
0C92  321280        ld   ($8012),a ; clear died
0C95  CD2002        call $0220
0C98  C9            ret

0C99                dc   7, $FF

                delay_8_vblanks:
0CA0  1E08          ld   e,$08
0CA2  CDA013        call $13A0
0CA5  1D            dec  e
0CA6  20FA          jr   nz,$0CA2
0CA8  C9            ret

0CA9                dc   7, $FF

                bongo_jump_on_player_death:
0CB0  1E03          ld   e,$03 ; jumps 3 times
0CB2  CD300D        call $0D30
0CB5  CD600D        call $0D60 ; why twice? Checks before re-setting
0CB8  CDA013        call $13A0 ; (is this blocking?)
0CBB  1D            dec  e
0CBC  20F4          jr   nz,$0CB2
0CBE  C9            ret

0CBF                dc   1, $FF

                do_death_sequence:
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
                _lp_0D08:
0D08  CDB00C        call $0CB0
0D0B  3A5F81        ld   a,($815F)
0D0E  3D            dec  a
0D0F  3D            dec  a
0D10  325F81        ld   ($815F),a
0D13  15            dec  d
                _done_if_zero:
0D14  20F2          jr   nz,$0D08
0D16  C9            ret

                ;; who calls?
                move_player_towards_ground_for_a_while:
0D17  1608          ld   d,$08 ; 8 frames
0D19  3A4381        ld   a,($8143)
0D1C  3C            inc  a
0D1D  3C            inc  a
0D1E  3C            inc  a
0D1F  324381        ld   ($8143),a
0D22  C610          add  a,$10
0D24  324781        ld   ($8147),a
0D27  CDA013        call $13A0
0D2A  15            dec  d
0D2B  20EC          jr   nz,$0D19
0D2D  C9            ret

0D2E                dc   2, $FF

                start_bongo_jump:
0D30  3A2480        ld   a,($8024)
0D33  A7            and  a
0D34  C0            ret  nz
0D35  3E10          ld   a,$10
0D37  322480        ld   ($8024),a
0D3A  C9            ret

0D3B                dc   5, $FF

                ;; Oooh, mystery function - commented out.
                ;; Think it was going to place Bongo on the
                ;; bottom right for levels where player is
                ;; up top. Only looks correct for those levels.
                move_bongo_redacted:
0D40  C9            ret ; just rets.
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

0D59                dc   7, $FF

                jump_bongo:
0D60  CD400D        call $0D40 ; also called from UPDATE_EVERYTHING
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

0D82                dc   6, $FF

                on_the_spot_bongo:   ; animate on the spot (no left/right)
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

0DA4                dc   12, $FF

                ;; wat
0DB0  05            dec  b
0DB1  0607          ld   b,$07
0DB3  08            ex   af,af'
0DB4  FF            rst  $38
0DB5  FF            rst  $38
0DB6  FF            rst  $38
0DB7  FF            rst  $38

                draw_bongo:
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

0DEC                dc   20, $FF

                bongo_lookup2:
0E00                db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
0E08                db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
0E10                db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
0E18                db   $E0,$38,$E0,$38,$E0,$38,$D0,$38
0E20                db   $E0,$38,$E0,$38,$D0,$38,$E0,$38
0E28                db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
0E30                db   $E0,$38,$E0,$38,$D0,$38,$00,$00
0E38                db   $00,$00,$00,$00,$00,$00,$FF,$FF

                bongo_move_and_animate:
0E40  3A2580        ld   a,($8025)
0E43  E603          and  $03 ; left or right
0E45  2005          jr   nz,$0E4C
0E47  CD880D        call $0D88
0E4A  180C          jr   $0E58
0E4C  FE01          cp   $01
0E4E  2005          jr   nz,$0E55
                _right:
0E50  CDE808        call $08E8
0E53  1803          jr   $0E58
                _left:
0E55  CD080A        call $0A08
0E58  3A2580        ld   a,($8025)
0E5B  CB57          bit  2,a ; jump
0E5D  C8            ret  z
0E5E  CD300D        call $0D30
0E61  C9            ret

0E62                dc   14, $FF

                bongo_animate_per_screen:
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
0E89  3D            dec  a ; scr #
0E8A  CB27          sla  a ; * 2
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
0E9A  FE20          cp   $20 ; timer hit top, reset
0E9C  2001          jr   nz,$0E9F
0E9E  AF            xor  a
0E9F  322780        ld   ($8027),a
0EA2  85            add  a,l
0EA3  6F            ld   l,a
0EA4  7E            ld   a,(hl) ; animation lookup
0EA5  322580        ld   ($8025),a
0EA8  C9            ret

0EA9                dc   23, $FF

                ;; addr lookup: 2 bytes per screen, points to BONGO_ANIM_DATA
                bongo_anim_lookup:
0EC0                db   $08,$0F,$08,$0F,$68,$0F,$08,$0F
0EC8                db   $08,$0F,$68,$0F,$08,$0F,$08,$0F
0ED0                db   $68,$0F,$08,$0F,$68,$0F,$08,$0F
0ED8                db   $08,$0F,$68,$0F,$08,$0F,$08,$0F
0EE0                db   $08,$0F,$08,$0F,$08,$0F,$08,$0F
0EE8                db   $68,$0F,$68,$0F,$08,$0F,$68,$0F
0EF0                db   $68,$0F,$08,$0F,$08,$0F

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
0F00                dc   8, $FF

                ;; this looks like bongo anim data
                ;; 4 = jump | 2 = left | 1 = right
                bongo_anim_data:
0F08                db   $01,$01,$01,$01,$06,$05,$02,$02
0F10                db   $02,$02,$04,$00,$00,$00,$00,$00
0F18                db   $00,$04,$02,$02,$02,$02,$05,$06
0F20                db   $01,$01,$01,$01,$00,$00,$00,$00

0F28                dc   8, $FF

                ;;
                bongo_run_when_player_close:
0F30  3A4881        ld   a,($8148)
0F33  37            scf
0F34  3F            ccf
0F35  C608          add  a,$08
0F37  300B          jr   nc,$0F44
0F39  AF            xor  a
0F3A  322580        ld   ($8025),a ; stop moving
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
0F56  3E01          ld   a,$01 ; right
0F58  322580        ld   ($8025),a
0F5B  E1            pop  hl
0F5C  C9            ret

0F5D                dc   11, $FF

                ;; 32 bytes of something...
0F68                db   $00,$00,$00,$00
0F6C                db   $04,$00,$00,$00
0F70                db   $04,$00,$00,$00
0F74                db   $04,$00,$00,$00
0F78                db   $00,$00,$00,$00
0F7C                db   $04,$00,$00,$00
0F80                db   $04,$00,$00,$00
0F84                db   $04,$00,$00,$00

                draw_border_1:
                ;;  intro inside border top
0F88  CD1003        call $0310
0F8B                db   $02, $02
0F8D                db   $E0,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
0F8D                db   $E7,$E7,$E7,$E7,$E7,$E7,$E7,$DF,$FF

                ;; intro inside border right
0FA6  CDD83B        call $3BD8
0FA9                db   $02, $03
0FAB                db   $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
0FBB                db   $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$FF

0FC4  C3D61B        jp   $1BD6

                ;; couple of $0Fs in a sea of $FFs
0FC7                dc   10, $FF
0FD1  0F            rrca
0FD2                dc   11, $FF
0FDD  0F            rrca
0FDE                dc   2, $FF

                header_text_data:
0FE0                db   $10,$10,$10,$10,$20,$1C,$01,$10,$10,$10,$10 ; PL1
0FEB                db   $18,$19,$17,$18,$2B,$23,$13,$1F,$22,$15,$10 ; HIGH-SCORE
0FF6                db   $10,$10,$10,$20,$1C,$02,$10,$10,$10,$FF    ; PL2

                ;;; === END OF BG1.BIN, START OF BG2.BIN =======

                ;; Reset then run main loop.
                ;; Happens after death and new round
                big_reset:
1000  3E50          ld   a,$50
1002  321B80        ld   ($801B),a ; never read?
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
1023  CD7014        call $1470
1026  21E00F        ld   hl,$0FE0 ; loaded by DRAW_SCREEN
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
1046  3E02          ld   a,$02 ; bottom row is red
1048  323F81        ld   ($813F),a
                ;;; falls through to main loop:

                ;;; =========================================
                main_loop:
104B  CDE010        call $10E0
104E  CD3011        call $1130
1051  CD7011        call $1170 ; Main logic
1054  CDA013        call $13A0
1057  3A00B8        ld   a,($B800) ; why load? ack?
105A  3A0040        ld   a,($4000) ; why load?
105D  18EC          jr   $104B

105F  FF            rst  $38
1060  F0            ret  p

1061                dc   15, $FF

                ;;; =========================================

                ;;;  Extra life
                extra_life:
1070  3A0480        ld   a,($8004)
1073  A7            and  a
1074  2004          jr   nz,$107A
1076  CD8010        call $1080
1079  C9            ret
107A  CDA810        call $10A8
107D  C9            ret

107E                dc   2, $FF

                ;; P1 extra life
                _p1_extra_life:
1080  3A7080        ld   a,($8070)
1083  A7            and  a
1084  C0            ret  nz
1085  3A1580        ld   a,($8015)
1088  37            scf
1089  3F            ccf
108A  D615          sub  $15 ; bonus at ??
108C  D8            ret  c
108D  3E01          ld   a,$01
108F  327080        ld   ($8070),a
1092  3A3280        ld   a,($8032) ; Bonus life
1095  3C            inc  a
1096  323280        ld   ($8032),a
1099  CDA003        call $03A0
109C  3E08          ld   a,$08
109E  324480        ld   ($8044),a
10A1  C9            ret

10A2                dc   6, $FF

                ;; P2 extra life
                _p2_extra_life:
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
10BA  3A3380        ld   a,($8033) ; bonus life p2
10BD  3C            inc  a
10BE  323380        ld   ($8033),a
10C1  CDA003        call $03A0
10C4  3E08          ld   a,$08
10C6  324480        ld   ($8044),a
10C9  C9            ret

10CA                dc   22, $FF

                set_tick_mod_3_and_add_score:
10E0  3A0080        ld   a,($8000)
10E3  3C            inc  a
10E4  FE03          cp   $03
10E6  2001          jr   nz,$10E9
10E8  AF            xor  a ; reset a
10E9  320080        ld   ($8000),a
10EC  CB27          sla  a ; (tick % 3) * 4
10EE  CB27          sla  a
10F0  CD9013        call $1390 ; do one of the three funcs
                _add_score:
10F3  CD0017        call $1700
10F6  C9            ret
                _extra_life:
10F7  CD7010        call $1070
10FA  C9            ret
                _dino_collision:
10FB  CD1825        call $2518
10FE  C9            ret

10FF  FF            db   $FF

                ;; Ticks the main ticks and speed timers
                tick_ticks:                     ;
1100  3A1283        ld   a,($8312)
1103  3C            inc  a
1104  321283        ld   ($8312),a ; only place tick_num is set
1107  CD8016        call $1680
110A  C9            ret

110B                dc   5, $FF

                ;; ?? is it about dino?
                mystery_8066_fn:
1110  F5            push af
1111  E5            push hl
1112  216680        ld   hl,$8066
1115  AF            xor  a ; cp: If A == N, then Z flag is set
1116  BE            cp   (hl) ; state == 0?
1117  2008          jr   nz,$1121 ; no, off to AND
1119  23            inc  hl ; yep, what about $8067
111A  BE            cp   (hl) ; == 0?
111B  2004          jr   nz,$1121
111D  23            inc  hl ; yep, what about $8068
111E  BE            cp   (hl) ; == 0?
111F  2805          jr   z,$1126 ; no, all zero - don't load
1121  7E            ld   a,(hl) ; ...first non-zero
1122  3600          ld   (hl),$00
1124  C618          add  a,$18 ; 0001 1000
1126  E67F          and  $7F ; 0111 1111
1128  00            nop
1129  00            nop
112A  E1            pop  hl
112B  F1            pop  af
112C  C9            ret

112D                dc   3, $FF

                ;;
                update_screen_tile_animations:
1130  3A0180        ld   a,($8001) ; set tick % 6
1133  3C            inc  a
1134  FE06          cp   $06
1136  2001          jr   nz,$1139
1138  AF            xor  a
1139  320180        ld   ($8001),a
113C  CB27          sla  a ; tick * 2
113E  CB27          sla  a ; tick * 4
1140  CD9013        call $1390 ; anims one-in6-times
1143  CD023C        call $3C02 ; a = 0
1146  C9            ret
1147  00            nop ; a = 1
1148  00            nop
1149  00            nop
114A  C9            ret
114B  00            nop ; a = 2
114C  00            nop
114D  00            nop
114E  C9            ret
114F  00            nop ; a = 3
1150  00            nop
1151  00            nop
1152  C9            ret
1153  00            nop ; a = 4
1154  00            nop
1155  00            nop
1156  C9            ret
1157  00            nop ; a = 5
1158  00            nop
1159  00            nop
115A  C9            ret
115B  00            nop ; a = 6
115C  00            nop
115D  00            nop
115E  C9            ret

115F                dc   17, $FF

                update_everything:
1170  CD041A        call $1A04
1173  CDD013        call $13D0
1176  CDD005        call $05D0
1179  CD8806        call $0688
117C  CD7407        call $0774 ; tick_mod_slow
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
11B5  CDE301        call $01E3 ; $UPDATE_EVERYTHING_MORE
11B8  C9            ret

11B9                dc   7, $FF

                wrap_other_spears_left:
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
                ;;
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

11FD                dc   3, $FF

                ;;;
                player_pos_update:
1200  3A4781        ld   a,($8147)
1203  47            ld   b,a
1204  3A0280        ld   a,($8002) ; no idea what this is about
1207  B8            cp   b
1208  201E          jr   nz,$1228 ; legs copy different from legs?
120A  C608          add  a,$08 ; they are the same.. add 8
120C  CB3F          srl  a ; ...
120E  CB3F          srl  a
1210  E63E          and  $3E ; 0011 1110 (62)
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
                _did_leg_thing:
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

1241                dc   15, $FF

                ;;; only called from PREVENT_CLOUD_JUMP_REDACTED
                prevent_cloud_jump_redacted_2:
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

1282                dc   14, $FF

                ;; ANOTHER commented out one!
                ;; This stops a player jumping up through a platform
                ;; from underneath it. Probably more realistic, but
                ;; good decision on the devs part to remove it it: it sucks!
                prevent_cloud_jump_redacted:
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

12AA                dc  14, $FF

                draw_background:
                ;; draw first 6 columns
12B8  CD1003        call $0310
12BB                db   $03,$00
12BD                db   $40,$42,$43,$42,$41,$40,$FF ; downward spikes
12C4  CD1003        call $0310
12C7                db   $09,$00
12C9                db   $FE,$FD,$FD,$FD,$FD,$FC,$FF ; top left platform
12D0  CD1003        call $0310
12D3                db   $1E,$00
12D5                db   $FE,$FD,$FD,$FD,$FD,$FC,$FF ; bottomleft platform
12DC  CDB014        call $14B0
12DF  21E092        ld   hl,$92E0 ; screen pos (6,0)
12E2  DD2A2080      ld   ix,($8020)
12E6  1617          ld   d,$17 ; call 23 columns = width - 6
                _draw_column:                   ; because first 6 are constant
12E8  CD2813        call $1328
12EB  00            nop
12EC  00            nop
12ED  00            nop
12EE  15            dec  d
12EF  20F7          jr   nz,$12E8
                reset_enemies_and_draw_bottom_row:
12F1  221E80        ld   ($801E),hl ; hl = 9000 when hits here on death
12F4  CD1035        call $3510
12F7  21500C        ld   hl,$0C50 ; $ADD_SCREEN_PICKUPS
12FA  CDE301        call $01E3
12FD  C3103F        jp   $3F10

                ;; scrolls the screen one tile - done in a loop for the transition
                scroll_one_column:
1300  1E04          ld   e,$04 ; 4 loops of 2 pixels
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
1314  CDA013        call $13A0
1317  1D            dec  e
1318  20E9          jr   nz,$1303
131A  E1            pop  hl
131B  C9            ret

131C                dc   12, $FF

                ;; ix = level data
                ;; hl = screen pos

                ;; Level BG data is FF separated, then split on 00.
                ;; Each row is a column of the screen, starting at col 6
                ;; first byte of segment is the row #
                draw_screen_column_from_level_data:
1328  CD6817        call $1768
                _lp_132B:
132B  DD7E00        ld   a,(ix+$00) ; ix + 0 (always 3?)
132E  E5            push hl
132F  85            add  a,l
1330  6F            ld   l,a
1331  DD23          inc  ix ; ix++
                _draw_char:
1333  DD7E00        ld   a,(ix+$00)
1336  FEFF          cp   $FF ; 0xff = EOL marker
1338  2809          jr   z,$1343
133A  A7            and  a ; 0x00 = segment marker
133B  2814          jr   z,$1351
133D  77            ld   (hl),a
133E  23            inc  hl
133F  DD23          inc  ix ; ix++
1341  18F0          jr   $1333
                _done_1343:
1343  DD23          inc  ix ; ix++
1345  E1            pop  hl
1346  01E0FF        ld   bc,$FFE0
1349  09            add  hl,bc
134A  7C            ld   a,h
134B  FE8F          cp   $8F
134D  C0            ret  nz
134E  2693          ld   h,$93
1350  C9            ret
                __next_seg:
1351  DD23          inc  ix ; ix++
1353  E1            pop  hl ; reset screen pos
1354  18D5          jr   $132B

1356                dc   2, $FF

                ;;
                during_transition_next:
1358  CDB813        call $13B8
135B  00            nop
135C  CDB014        call $14B0
135F  DD2A2080      ld   ix,($8020)
1363  2A1E80        ld   hl,($801E) ; must point to screen?
1366  1615          ld   d,$15 ; 21 columns to scroll
                _lp_1368:
1368  CD2813        call $1328
136B  CD0013        call $1300
136E  15            dec  d
136F  20F7          jr   nz,$1368
                _done_scrolling:
1371  DD222080      ld   ($8020),ix
1375  221E80        ld   ($801E),hl ; hl = 9160 on transition (e on HIGH-SCORE)
                _reset_for_next_level:
1378  CDC019        call $19C0
137B  CDB812        call $12B8
137E  AF            xor  a
137F  320280        ld   ($8002),a
1382  320380        ld   ($8003),a
1385  CD2018        call $1820
1388  CDB80D        call $0DB8
138B  CD0804        call $0408
138E  C9            ret

138F  FF            db   $FF

                ;; "jump relative A": dispatches to address based on A
                jump_rel_a:
1390  D9            exx
1391  E1            pop  hl ; stack RET pointer
1392  0600          ld   b,$00
1394  4F            ld   c,a
1395  09            add  hl,bc
1396  E5            push hl
1397  D9            exx
1398  C9            ret ; sets PC to RET + A

1399                dc   7, $FF

                ;;; Looks important. VBLANK?
                wait_vblank:
13A0  0600          ld   b,$00
13A2  3E01          ld   a,$01
13A4  3201B0        ld   ($B001),a ; enable interrupts
13A7  3A00B8        ld   a,($B800)
13AA  78            ld   a,b
13AB  FE01          cp   $01
13AD  20F3          jr   nz,$13A2
13AF  AF            xor  a
13B0  3201B0        ld   ($B001),a ; disable interrupts
13B3  3A00B8        ld   a,($B800)
13B6  C9            ret

13B7  FF            db   $FF

                bongo_runs_off_screen:
13B8  214881        ld   hl,$8148
13BB  3600          ld   (hl),$00
13BD  23            inc  hl
13BE  7D            ld   a,l
13BF  FE60          cp   $60
13C1  20F8          jr   nz,$13BB
13C3  C9            ret

13C4                dc   12, $FF

                update_time_timer:
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

13E5                dc   11, $FF

                update_time:
13F0  3A0480        ld   a,($8004)
13F3  CB47          bit  0,a
13F5  210780        ld   hl,$8007
13F8  2802          jr   z,$13FC
13FA  23            inc  hl
13FB  23            inc  hl
13FC  7E            ld   a,(hl)
13FD  3C            inc  a
13FE  27            daa ; the A register is BCD corrected from flags
13FF  77            ld   (hl),a
1400  FE60          cp   $60 ; minutes
1402  C0            ret  nz
1403  3600          ld   (hl),$00
1405  23            inc  hl
1406  7E            ld   a,(hl)
1407  3C            inc  a
1408  27            daa
1409  77            ld   (hl),a ; store it
140A  C9            ret

140B                dc   5, $FF

                ;; draws the player's time under score
                ;; ret's immediately: must have been removed! aww :(
                draw_time:
1410  C9            ret
1411  3A0480        ld   a,($8004)
1414  CB47          bit  0,a
1416  201E          jr   nz,$1436
                ;; p1 version
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
                ;;  p2 version
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

1454                dc   12, $FF

                delay_83:                       ; maybe a delay?
1460  210080        ld   hl,$8000
1463  3600          ld   (hl),$00
1465  2C            inc  l
1466  20FB          jr   nz,$1463
1468  24            inc  h
1469  7C            ld   a,h
146A  FE83          cp   $83 ; 1000 0011
146C  20F5          jr   nz,$1463
146E  C9            ret

146F                dc   1, $FF

                ;; lotsa calls here
                reset_xoff_sprites_and_clear_screen:
1470  CD9014        call $1490 ; then nop slides
1473  00            nop ; ...
1474  00            nop ; ...
1475  00            nop
1476  00            nop
1477  00            nop
1478  23            inc  hl ; hl++ ?
1479  00            nop
147A  00            nop
147B  00            nop
147C  00            nop
147D  00            nop
147E  00            nop
147F  00            nop ; end of weird nopslide

                clear_screen:
1480  210090        ld   hl,$9000
1483  3610          ld   (hl),$10
1485  2C            inc  l
1486  20FB          jr   nz,$1483
1488  24            inc  h
1489  7C            ld   a,h
148A  FE98          cp   $98
148C  20F5          jr   nz,$1483
148E  C9            ret

148F  FF            db   $FF

                ;; Lotsa calls here (via $1470);
                reset_xoff_and_cols_and_sprites:    ; sets 128 locations to 0
1490  210081        ld   hl,$8100
1493  3600          ld   (hl),$00
1495  23            inc  hl
1496  7D            ld   a,l
1497  FE80          cp   $80 ; 128
1499  20F8          jr   nz,$1493
149B  C9            ret

149C                dc   4, $FF

                ;;
                clear_ram:
14A0  210080        ld   hl,$8000 ; = $8000, start of ram
14A3  3600          ld   (hl),$00
14A5  23            inc  hl
14A6  7C            ld   a,h
14A7  FE84          cp   $84 ; 132
14A9  20F8          jr   nz,$14A3
14AB  C30F00        jp   $000F ; Return

14AE                dc   2, $FF

                screen_reset:
14B0  21E806        ld   hl,$06E8
14B3  CDE301        call $01E3
14B6  CDC83B        call $3BC8
                ;; set init player pos
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
14D1  3D            dec  a ; scr# - 1
14D2  4F            ld   c,a
14D3  CB21          sla  c ; * 2
14D5  09            add  hl,bc
14D6  4E            ld   c,(hl)
14D7  23            inc  hl
14D8  46            ld   b,(hl)
14D9  ED432080      ld   ($8020),bc
14DD  C9            ret

14DE                dc   2, $FF

                reset_enemies_2:
14E0  3A1583        ld   a,($8315) ; faster in round 2
14E3  E603          and  $03
14E5  C0            ret  nz
14E6  CD503A        call $3A50
14E9  CD883A        call $3A88
14EC  CDC03A        call $3AC0
14EF  C9            ret

14F0                dc   16, $FF

                ;; Points to the addr of each screen's level data
                level_bg_ptr_lookup:
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
153C                dc   20, $FF

                copy_xoffs_and_cols_to_screen:
1550  E5            push hl
1551  C5            push bc
1552  D5            push de
1553  210081        ld   hl,$8100
1556  110098        ld   de,$9800
1559  018000        ld   bc,$0080
155C  EDB0          ldir ; LD (DE),(HL) repeated: copies a chunk of mem
155E  D1            pop  de
155F  C1            pop  bc
1560  E1            pop  hl
1561  C9            ret

1562                dc   2, $FF

                ;; Why?
                animate_splash_pickup_nops:
1564  00            nop
1565  00            nop
                animate_splash_pickups:
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
                ;;
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
                ;;
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

15C3  FF            db   $FF

15C4  D5            push de
15C5  21A81B        ld   hl,$1BA8
15C8  CDE301        call $01E3
15CB  D1            pop  de
15CC  C9            ret

15CD                dc   3, $FF

                attract_bonus_screen:
15D0  CD7014        call $1470
15D3  CD880F        call $0F88
15D6  CD6016        call $1660
15D9  3E8C          ld   a,$8C
15DB  320893        ld   ($9308),a
15DE  CD6016        call $1660
15E1  CD1003        call $0310
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
15F9  CD1003        call $0310
15FC  0C            inc  c
15FD  1004          djnz $1603 ; 400 ...
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
1611  CD1003        call $0310
1614  1010          djnz $1626
1616  0600          ld   b,$00 ; 600 ...
1618  00            nop
1619  1020          djnz $163B
161B  24            inc  h
161C  23            inc  hl
161D  FF            rst  $38
161E  CD6016        call $1660
1621  3E8F          ld   a,$8F
1623  321493        ld   ($9314),a
1626  CD6016        call $1660
1629  CD1003        call $0310
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
1643  219414        ld   hl,$1494 ; $ATTRACT_CATCH_DINO
1646  CDE301        call $01E3
1649  C9            ret

164A  FF            db   $FF

                clear_and_draw_screen:
164B  CD7014        call $1470
164E  21E00F        ld   hl,$0FE0
1651  CD4008        call $0840
1654  00            nop ; data
1655  00            nop
1656  CD5024        call $2450
1659  C9            ret

165A                dc   6, $FF

                animate_splash_screen:
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

1676                dc   2, $FF

                ;; ? data for something?
1678  E8            ret  pe
1679  ECEEF0        call pe,$F0EE
167C  E9            jp   (hl)
167D  ED            db   $ed
167E  EF            rst  $28
167F  F1            pop  af

                update_speed_timers:
1680  3A0480        ld   a,($8004)
1683  A7            and  a
1684  2005          jr   nz,$168B
1686  3A5B80        ld   a,($805B)
1689  1803          jr   $168E
168B  3A5C80        ld   a,($805C)
168E  FE1F          cp   $1F
1690  2019          jr   nz,$16AB
                ;;  Round 1
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
                ;;; Round 2+
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

16C4                dc   12, $FF

                draw_bonus:
16D0  CD1003        call $0310
16D3  0A            ld   a,(bc)
16D4  00            nop
16D5  E0            ret  po
16D6  DCDDDE        call c,$DEDD
16D9  DF            rst  $18
16DA  FF            rst  $38
16DB  CD1003        call $0310
16DE  0B            dec  bc
16DF  00            nop
16E0  E1            pop  hl
16E1  E5            push hl
16E2  E5            push hl
16E3  E5            push hl
16E4  E6FF          and  $FF
16E6  CD1003        call $0310
16E9  0C            inc  c
16EA  00            nop
16EB  E1            pop  hl
16EC  E5            push hl
16ED  E5            push hl
16EE  E5            push hl
16EF  E6FF          and  $FF
16F1  CD1003        call $0310
16F4  0D            dec  c
16F5  00            nop
16F6  E2E3E3        jp   po,$E3E3
16F9  E3            ex   (sp),hl
16FA  E4FFC9        call po,$C9FF
16FD  FF            rst  $38

16FE                dc   2, $FF

                ;; Adds whatever is in 801d
                add_score:
1700  3A3480        ld   a,($8034)
1703  A7            and  a
1704  C8            ret  z
1705  3A0480        ld   a,($8004)
1708  A7            and  a
1709  2017          jr   nz,$1722
                ;;; player 1
170B  3A1D80        ld   a,($801D) ; amount to add
170E  A7            and  a
170F  C8            ret  z ; nothing to add... leave.
1710  4F            ld   c,a
1711  2680          ld   h,$80 ; 8014 for p1 8017 for p2
1713  0600          ld   b,$00
1715  2E14          ld   l,$14
1717  CDA017        call $17A0
171A  CD5024        call $2450
171D  AF            xor  a
171E  321D80        ld   ($801D),a ; clear
1721  C9            ret
                ;;; player 2
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

1739                dc   23, $FF

                check_done_screen:
1750  37            scf
1751  3F            ccf
1752  3A4381        ld   a,($8143) ; Test if player is at top or bottom
1755  C648          add  a,$48 ; Y + 72 > 255?
1757  3803          jr   c,$175C ; ...yep, check x
1759  D678          sub  $78 ; Y - 120 < 0?
175B  D0            ret  nc ; ...no, can't finish level here...
                ;; check if gone past edge of screen
175C  3A4081        ld   a,($8140)
175F  37            scf
1760  3F            ccf
1761  D6E0          sub  $E0 ; out of screen?
1763  D8            ret  c
1764  CD7817        call $1778 ; jump to next screen
1767  C9            ret

                ;;
                clear_column_of_tiles:
1768  E5            push hl
1769  3E03          ld   a,$03
176B  85            add  a,l
176C  6F            ld   l,a
176D  1E1C          ld   e,$1C ; 24 loops
                _lp_176F:
176F  3610          ld   (hl),$10
1771  23            inc  hl
1772  1D            dec  e
1773  20FA          jr   nz,$176F
1775  E1            pop  hl
1776  C9            ret

1777  FF            db   $FF

                transition_to_next_screen:
1778  CDC017        call $17C0
177B  3A0480        ld   a,($8004)
177E  A7            and  a
177F  2009          jr   nz,$178A
1781  3A2980        ld   a,($8029)
1784  3C            inc  a ; next screen if p1
1785  322980        ld   ($8029),a
1788  1807          jr   $1791
178A  3A2A80        ld   a,($802A)
178D  3C            inc  a ; next screen if p2
178E  322A80        ld   ($802A),a
1791  CDE027        call $27E0
1794  CD5813        call $1358 ; wipes to next
1797  CDD00A        call $0AD0
179A  3E02          ld   a,$02
                ;; I think that should be call not jump. It rets anyway.
179C  C3B417        jp   $17B4
179F  C9            ret

                ;; (might be just "add bcd to addr")
                ;; hl is either 8014 for p1 or 8017 for p2
                ;; c contains score to add
                add_amount_bdc:
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

17B2                dc   2, $FF

                reset_jump_and_redify_bottom_row:
17B4  323F81        ld   ($813F),a ; set bottom row col
17B7  AF            xor  a
17B8  320F80        ld   ($800F),a
17BB  320580        ld   ($8005),a
17BE  C9            ret

17BF  FF            db   $FF

                reset_dino:
17C0  AF            xor  a
17C1  322D80        ld   ($802D),a
17C4  3A4C81        ld   a,($814C)
17C7  325081        ld   ($8150),a
17CA  C9            ret

17CB                dc   5, $FF

                draw_bonus_box:
17D0  CD1003        call $0310
17D3  0A            ld   a,(bc)
17D4  00            nop
17D5  B8            cp   b
17D6  B4            or   h
17D7  B5            or   l
17D8  B6            or   (hl)
17D9  B7            or   a
17DA  FF            rst  $38
17DB  CD1003        call $0310
17DE  0B            dec  bc
17DF  00            nop
17E0  B9            cp   c
17E1  FF            rst  $38
17E2  CD1003        call $0310
17E5  0B            dec  bc
17E6  04            inc  b
17E7  BE            cp   (hl)
17E8  FF            rst  $38
17E9  CD1003        call $0310
17EC  0C            inc  c
17ED  00            nop
17EE  B9            cp   c
17EF  FF            rst  $38
17F0  CD1003        call $0310
17F3  0C            inc  c
17F4  04            inc  b
17F5  BE            cp   (hl)
17F6  FF            rst  $38
17F7  CD1003        call $0310
17FA  0D            dec  c
17FB  00            nop
17FC  BA            cp   d
17FD  BB            cp   e
17FE  BB            cp   e
17FF  BB            cp   e
1800  BC            cp   h
1801  FF            rst  $38
1802  C9            ret

1803                dc   5, $FF

                reset_player_sprite_frame_col:
1808  3E0C          ld   a,$0C
180A  324181        ld   ($8141),a
180D  3C            inc  a
180E  324581        ld   ($8145),a
1811  3E11          ld   a,$11
1813  324281        ld   ($8142),a
1816  324681        ld   ($8146),a
1819  C9            ret

181A                dc   6, $FF

                init_player_pos_for_screen:
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

184B                dc   5, $FF

                ;; [x, y]
                player_start_pos_data:
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

1890                dc   8, $FF

                reset_xoffs:
1898  210081        ld   hl,$8100
189B  3600          ld   (hl),$00
189D  23            inc  hl
189E  23            inc  hl
189F  7D            ld   a,l
18A0  FE40          cp   $40
18A2  20F7          jr   nz,$189B
18A4  C9            ret

18A5                dc   11, $FF

                ;; Level data for screens 1, 2, 4, 8, 13, 15, 18
                ;; (all `n_n` screens).
                ;; See by DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__n_n:
18B0: 03 41 00 09 FE 00 1E 39 FF
18B9: 03 43 00 09 FD 45 41 00 1B FE 3B 45 45 FF
18C7: 03 40 00 09 FD 42 00 1B FD 3F 3F 3B FF
18D4: 03 43 00 09 FC 41 00 1B FD 3B 3B 3F FF
18E1: 03 42 00 1B FD 3F 3B 3B FF
18EA: 03 3F 00 1B FD 3F 3F 3B FF
18F3: 03 3E 43 00 1B FD 3B 3F 3B FF
18FD: 03 3F 40 00 1B FC 47 3B 47 FF
1907: 03 3B 42 00 1D 3D 3F FF
190F: 03 3B 40 00 1D 3C 3E FF
1917: 03 3F 43 00 1D 3A 3F FF
191F: 03 3E 41 00 1B FE 10 3D 3E FF
1929: 03 3B 40 00 1B FD 47 3E 47 FF
1933: 03 3F 42 00 1B FD 3B 3B 3B FF
193D: 03 3E 00 1B FD 3E 3F 3F FF
1946: 03 42 00 09 FE 00 1B FD 3F 3B 3E FF
1952: 03 43 00 09 FD 47 41 00 1B FD 3B 3E 3E FF
1960: 03 41 00 09 FD 00 1B FC 3E 3B 3B FF
196C: 03 42 00 09 FD 00 1E FE FF
1975: 03 43 00 09 FD 00 1E FD FF
197E: 03 42 00 09 FD 00 1E FD FF
1987: 03 41 00 09 FD 00 1E FD FF
1990: 03 40 00 09 FD 00 1E FC FF

1999                dc   3, $FF

                ;;; Skip level AFTER getting bonus
                bonus_skip_screen:
                ;; Draws the Bongo Tree. I thought this must have been a glitch,
                ;; but nope: the Bongo Tree is meant to be like that!
199C  3EF0          ld   a,$F0 ; right of screen (scrolls to left)
199E  324081        ld   ($8140),a
19A1  324481        ld   ($8144),a
19A4  3E26          ld   a,$26 ; top of screen
19A6  324781        ld   ($8147),a
19A9  3E16          ld   a,$16
19AB  324381        ld   ($8143),a
19AE  3E17          ld   a,$17 ; backwards player for both head and legs, lol
19B0  324181        ld   ($8141),a
19B3  324581        ld   ($8145),a
19B6  AF            xor  a ; red and green for the bongo tree.
19B7  324281        ld   ($8142),a
19BA  324681        ld   ($8146),a
19BD  C37817        jp   $1778

                ;; Clear screen to blanks
                clear_scr_to_blanks:
19C0  210090        ld   hl,$9000
19C3  23            inc  hl
19C4  23            inc  hl
19C5  23            inc  hl
19C6  161D          ld   d,$1D ; 29
19C8  3610          ld   (hl),$10
19CA  23            inc  hl
19CB  15            dec  d
19CC  20FA          jr   nz,$19C8
19CE  7C            ld   a,h
19CF  FE94          cp   $94 ; 148
19D1  20F0          jr   nz,$19C3
19D3  00            nop
19D4  00            nop
19D5  00            nop
19D6  00            nop
19D7  00            nop
                _clear_xoff_col_spr:  ; Same code as $RESET_XOFF_AND_COLS_AND_SPRITES
19D8  210081        ld   hl,$8100
19DB  3600          ld   (hl),$00
19DD  23            inc  hl
19DE  7D            ld   a,l
19DF  FE80          cp   $80
19E1  20F8          jr   nz,$19DB
                _done_19E3:
19E3  CDA013        call $13A0
19E6  C9            ret

19E7                dc   9, $FF

                check_fall_off_bottom_scr:
19F0  3A4781        ld   a,($8147)
19F3  37            scf
19F4  3F            ccf
19F5  C618          add  a,$18 ; +24 (ground = 255-24?)
19F7  D0            ret  nc
19F8  CDC00C        call $0CC0
19FB  AF            xor  a
19FC  321280        ld   ($8012),a
19FF  CD2002        call $0220
1A02  C9            ret

1A03  FF            db   $FF

                ;; Die if you go out the screen to the left (16px)
                check_exit_stage_left:
1A04  3A4081        ld   a,($8140)
1A07  37            scf
1A08  3F            ccf
1A09  D610          sub  $10 ; out the start of the screen?
1A0B  D0            ret  nc ; ... nope, you're good
1A0C  C3481B        jp   $1B48 ; ... yep, you're dead
1A0F  C9            ret

                ;; Level data for screens 5, 10
                ;; (`/` screens)
                ;; See DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__stairs_up:
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
1B33  011400        ld   bc,$0014 ; add 20 bytes to bg_ptr
1B36  09            add  hl,bc
1B37  222080        ld   ($8020),hl
1B3A  2A1E80        ld   hl,($801E)
1B3D  011400        ld   bc,$0014 ; add 20 bytes to SCREEN_RAM_PTR
1B40  09            add  hl,bc
1B41  221E80        ld   ($801E),hl
1B44  C9            ret

1B45                dc   3, $FF

                call_do_death_sequence:
1B48  CDC00C        call $0CC0
1B4B  CD2002        call $0220
1B4E  C9            ret

1B4F  FF            db   $FF

                ;; ?
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
1B6D  CDB02C        call $2CB0 ; calls nothing based on screen
1B70  C30010        jp   $1000

1B73                dc   13, $FF

                init_score_and_screen_once:
1B80  3A3180        ld   a,($8031)
1B83  A7            and  a
1B84  200B          jr   nz,$1B91
                _2_players:
1B86  3A2280        ld   a,($8022) ; $8022 never used anywhere else
1B89  A7            and  a
1B8A  2801          jr   z,$1B8D
1B8C  C9            ret ; p2 hasn't inited?
                _did_init:
1B8D  3C            inc  a
1B8E  322280        ld   ($8022),a ; (except here)
                _both:
1B91  CD0017        call $1700
1B94  CD7014        call $1470

1B97  00            nop
1B98  00            nop
1B99  CDA003        call $03A0
1B9C  21E00F        ld   hl,$0FE0
1B9F  CD4008        call $0840
1BA2  00            nop ; data
1BA3  00            nop
1BA4  CD5024        call $2450
1BA7  3A0480        ld   a,($8004)
1BAA  A7            and  a
1BAB  2010          jr   nz,$1BBD
1BAD  CD1003        call $0310
1BB0  100A          djnz $1BBC
1BB2  201C          jr   nz,$1BD0 ; PLAYER 1
1BB4  112915        ld   de,$1529
1BB7  221001        ld   ($0110),hl
1BBA  FF            rst  $38
1BBB  180E          jr   $1BCB
1BBD  CD1003        call $0310
1BC0  100A          djnz $1BCC
1BC2  201C          jr   nz,$1BE0 ; PLAYER 2
1BC4  112915        ld   de,$1529
1BC7  221002        ld   ($0210),hl
1BCA  FF            rst  $38
1BCB  CD411C        call $1C41
1BCE  C9            ret

1BCF  3E08          ld   a,$08
1BD1  328680        ld   ($8086),a
1BD4  C9            ret

1BD5                dc   1, $FF

                draw_border_1_b:
1BD6  CD1003        call $0310
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

1BF7                dc   9, $FF

                delay_18_vblanks:
1C00  1E18          ld   e,$18
1C02  CDA013        call $13A0
1C05  1D            dec  e
1C06  20FA          jr   nz,$1C02
1C08  C9            ret

1C09                dc   7, $FF

                dino_caught_player_right:
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

                play_intro_jingle:
1C41  3E0F          ld   a,$0F ; intro jingle
1C43  324480        ld   ($8044),a
1C46  AF            xor  a
1C47  324280        ld   ($8042),a
1C4A  CDE024        call $24E0
1C4D  C9            ret

1C4E                dc   2, $FF

                dino_caught_player_left:
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

1C8A                dc   6, $FF

                dino_got_player_left_or_right:
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

1CA4                dc   12, $FF

                dino_collision:
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

1CD6                dc   2, $FF

                draw_border_1_c:
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

                ;; Level data for screens: 16, 19, 27
                ;; (all `S` screens)
                ;; See by DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__s:
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

                ;; Level data for screens 7, 12, 17, 20, 23, 26
                ;; (all `\` screens)
                ;; See by DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__stairs_down:
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

                ;; Level data for screens 21, 24
                ;; (all `S_S` screens)
                ;; See by DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__s_s:
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
1FFF  03            inc  bc ; ...to be continued...
                ;;; ======END OF BG2.BIN, START OF BG3.BIN ===========
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

                ;; Waits 1 vblank, checks if credit is added yet
                wait_for_start_button:
2128  CDA013        call $13A0
212B  3A0383        ld   a,($8303)
212E  A7            and  a
212F  C8            ret  z
                ;; credit added! - start the game
2130  CD9014        call $1490
2133  C3A400        jp   $00A4
                ;;
2136                dc   10, $FF

                ;; Level data for screens 3, 6, 9, 11, 14, 22, 25
                ;; (all `nTn` and `W` levels)
                ;; See DRAW_SCREEN_FROM_LEVEL_DATA
                level_bg__ntn:
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
2286  FCFF3E        call m,$3EFF
2289  07            rlca
228A  D300          out  ($00),a
228C  3E38          ld   a,$38
228E  D301          out  ($01),a
2290  C9            ret

2291                dc   15, $FF

                update_dino:
22A0  7E            ld   a,(hl)
22A1  324C81        ld   ($814C),a
22A4  23            inc  hl
22A5  7E            ld   a,(hl)
22A6  324F81        ld   ($814F),a
22A9  23            inc  hl
22AA  3E12          ld   a,$12
22AC  324E81        ld   ($814E),a
22AF  325281        ld   ($8152),a
22B2  7E            ld   a,(hl) ; anim height (for hiding dino)
22B3  E6FC          and  $FC ; 1111 1100
22B5  281D          jr   z,$22D4
22B7  E6F8          and  $F8 ; 1111 1000
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
                _this:
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

22EF  FF            db   $FF

                dino_pathfind_nopslide:
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

                ;; Check if it's time to start the dino,
                ;; if started - follow path.
                dino_pathfind:
22FB  3A2D80        ld   a,($802D)
22FE  3C            inc  a
22FF  322D80        ld   ($802D),a
2302  5F            ld   e,a
2303  37            scf
2304  3F            ccf
2305  D60B          sub  $0B ; 11 ticks till dino time
2307  D8            ret  c
2308  3A0480        ld   a,($8004) ; start dino!
230B  A7            and  a
230C  2005          jr   nz,$2313
230E  3A2980        ld   a,($8029)
2311  1803          jr   $2316
2313  3A2A80        ld   a,($802A)
2316  3D            dec  a
2317  213023        ld   hl,$2330
231A  CB27          sla  a ; screen # x 2
231C  85            add  a,l ; dino_lookup + scr*2
231D  6F            ld   l,a
231E  4E            ld   c,(hl)
231F  23            inc  hl
2320  46            ld   b,(hl)
2321  7B            ld   a,e ; add dino counter
2322  D60B          sub  $0B
2324  CB27          sla  a
2326  CB27          sla  a
2328  81            add  a,c
2329  6F            ld   l,a
232A  60            ld   h,b ; hl points to dino x/y
232B  CDA022        call $22A0
232E  C9            ret

232F  FF            db   $FF

                ;; location of path data for each screen
                dino_path_lookup:
2330  78            ld   a,b ; DINO_PATH_1 (screen1)
2331  23            inc  hl
2332  78            ld   a,b
2333  23            inc  hl
2334  00            nop ; DINO_PATH_2
2335  2678          ld   h,$78
2337  23            inc  hl
2338  80            add  a,b ; DINO_PATH_3
2339  2600          ld   h,$00
233B  27            daa
233C  70            ld   (hl),b ; DINO_PATH_5
233D  27            daa
233E  78            ld   a,b
233F  23            inc  hl
2340  00            nop ; DINO_PATH_4
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
234E  00            nop ; DINO_PATH_6
234F  2870          jr   z,$23C1
2351  27            daa
2352  78            ld   a,b
2353  23            inc  hl
2354  00            nop
2355  2870          jr   z,$23C7
2357  27            daa
2358  00            nop ; DINO_PATH_7
2359  2A0027        ld   hl,($2700)
235C  70            ld   (hl),b
235D  27            daa
235E  00            nop
235F  2A0027        ld   hl,($2700)
2362  70            ld   (hl),b
2363  27            daa
2364  00            nop ; (screen 27)
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

                ;; Nodes for dino to follow: 25 nodes,
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_1:
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

                ;;
23E0  3A4C81        ld   a,($814C)
23E3  FE18          cp   $18
23E5  C0            ret  nz
23E6  3E07          ld   a,$07
23E8  324480        ld   ($8044),a
23EB  C9            ret

23EC                dc   20, $FF

                dino_anim_lookup:
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

2418                dc   8, $FF

                ;;
                copy_inp_to_buttons_and_check_buttons:
2420  3A00A8        ld   a,($A800)
2423  32F183        ld   ($83F1),a
2426  3A00B0        ld   a,($B000)
2429  32F283        ld   ($83F2),a
242C  CD4036        call $3640
242F  C9            ret

2430  0600          ld   b,$00
2432  3A00B8        ld   a,($B800)
2435  05            dec  b
2436  20FA          jr   nz,$2432
2438  C9            ret

2439                dc   23, $FF

                draw_score:
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

24D3                dc   13, $FF

                delay_60_vblanks:
24E0  2660          ld   h,$60
24E2  CDA013        call $13A0
24E5  24            inc  h
24E6  20FA          jr   nz,$24E2
24E8  C9            ret

24E9                dc   3, $FF

                delay_8_play_sound:
24EC  C5            push bc
24ED  0608          ld   b,$08
24EF  C5            push bc
24F0  CDA013        call $13A0
24F3  C1            pop  bc
24F4  10F9          djnz $24EF
24F6  C1            pop  bc
24F7  3E0A          ld   a,$0A
24F9  324480        ld   ($8044),a
24FC  C9            ret

24FD                dc   3, $FF

2500  210083        ld   hl,$8300
2503  3600          ld   (hl),$00
2505  2C            inc  l
2506  7D            ld   a,l
2507  FEE1          cp   $E1
2509  20F8          jr   nz,$2503
250B  C9            ret

250C                dc   12, $FF

                test_then_dino_collision:
2518  3A2D80        ld   a,($802D)
251B  E6F8          and  $F8
251D  C8            ret  z
251E  CDB01C        call $1CB0
2521  C9            ret

2522                dc   22, $FF

                ;; who calls? (free bytes)
                ;; Appears to draw [21] (the 21 in a box from the level indicators)
                ;; through a thick horizontal band in the middle of the screen.
                ;; ... for some reason
                unused_draw_d4_everywhere:
2538  111600        ld   de,$0016 ; +22 each outer loop?
253B  0E20          ld   c,$20
253D  211090        ld   hl,$9010
                _j_1:                             ; 32 loops
2540  060A          ld   b,$0A
                _i_1:                             ; 10 loops
2542  36D4          ld   (hl),$D4 ; tile [21] (level indicator number)
2544  23            inc  hl
2545  05            dec  b
2546  20FA          jr   nz,$2542
2548  19            add  hl,de
2549  0D            dec  c
254A  C8            ret  z
254B  18F3          jr   $2540

254D                dc   3, $FF

                ;; (free bytes... if you don't want a cool transition)
                ;; whoa! Draws some weird spirtal cage flood-fill thing
                ;; inward spiral fill of screen, then clear.
                ;; (it's right in the dino code - maybe was supposed to happen
                ;; if you got caught by a dino, or if you caught the dino)
                unused_spiral_cage_fill_transition:
2550  CD7014        call $1470
2553  CDA013        call $13A0
2556  214090        ld   hl,$9040
2559  1E79          ld   e,$79
255B  CD8825        call $2588
255E  21A093        ld   hl,$93A0
2561  CD8825        call $2588
2564  210090        ld   hl,$9000
2567  CD9825        call $2598
256A  211F90        ld   hl,$901F
256D  CD9825        call $2598
2570  1610          ld   d,$10
2572  216190        ld   hl,$9061
                _lp_2575:
2575  CDA825        call $25A8
2578  CDC025        call $25C0
257B  CDD025        call $25D0
257E  CDE825        call $25E8
2581  15            dec  d
2582  20F1          jr   nz,$2575
2584  CD8014        call $1480
2587  C9            ret
                _part_two:
2588  73            ld   (hl),e
2589  2C            inc  l
258A  7D            ld   a,l
258B  E61F          and  $1F
258D  C8            ret  z
258E  18F8          jr   $2588
2590                dc   8, $FF
                _part_three:
2598  73            ld   (hl),e
2599  012000        ld   bc,$0020
259C  09            add  hl,bc
259D  7C            ld   a,h
259E  FE94          cp   $94
25A0  C8            ret  z
25A1  18F5          jr   $2598
25A3                dc   5, $FF
                _part_four:
25A8  CDA013        call $13A0
25AB  73            ld   (hl),e
25AC  012000        ld   bc,$0020
25AF  09            add  hl,bc
25B0  7E            ld   a,(hl)
25B1  BB            cp   e
25B2  20F7          jr   nz,$25AB
25B4  ED42          sbc  hl,bc
25B6  C9            ret
25B7                dc   9, $FF
                _part_five:
25C0  CDA013        call $13A0
25C3  73            ld   (hl),e
25C4  23            inc  hl
25C5  7E            ld   a,(hl)
25C6  BB            cp   e
25C7  20FA          jr   nz,$25C3
25C9  2B            dec  hl
25CA  C9            ret
25CB                dc   5, $FF
                _part_six:
25D0  CDA013        call $13A0
25D3  73            ld   (hl),e
25D4  012000        ld   bc,$0020
25D7  ED42          sbc  hl,bc
25D9  7E            ld   a,(hl)
25DA  BB            cp   e
25DB  20F3          jr   nz,$25D0
25DD  09            add  hl,bc
25DE  C9            ret
25DF                dc   9, $FF
                _part_seven:
25E8  CDA013        call $13A0
25EB  73            ld   (hl),e
25EC  2B            dec  hl
25ED  7E            ld   a,(hl)
25EE  BB            cp   e
25EF  20FA          jr   nz,$25EB
25F1  23            inc  hl
25F2  C9            ret
25F3                dc   13, $FF

                ;; Nodes for dino to follow: 31 nodes,
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_2:
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
263E  010090        ld   bc,$9000
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

2674                dc   12, $FF

                ;; Nodes for dino to follow: 27 nodes,
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_3:
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

26EC                dc   20, $FF

                ;; Nodes for dino to follow: 24 nodes,
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_4:
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

2760                dc   16, $FF

                ;; Nodes for dino to follow: 24 nodes,
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_5:
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

27D8                dc   8, $FF

                ;;;
                set_player_y_level_start:
27E0  3A4381        ld   a,($8143)
27E3  37            scf
27E4  3F            ccf
27E5  C660          add  a,$60 ; at top of screen?
27E7  300B          jr   nc,$27F4
27E9  3ED0          ld   a,$D0 ; no, set to bottom
27EB  324381        ld   ($8143),a
27EE  C610          add  a,$10
27F0  324781        ld   ($8147),a
27F3  C9            ret
27F4  3E28          ld   a,$28 ; yes, set to top
27F6  324381        ld   ($8143),a
27F9  C610          add  a,$10
27FB  324781        ld   ($8147),a
27FE  C9            ret
                ;;;
27FF  FF            db   $FF

                ;; Nodes for dino to follow
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_6:
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

28D0                dc   16, $FF

                move_dino_x:
28E0  3A1283        ld   a,($8312)
28E3  E603          and  $03
28E5  C0            ret  nz
28E6  3A4C81        ld   a,($814C)
28E9  A7            and  a
28EA  C8            ret  z ; no dino out, leave
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

                ;;
2901  210002        ld   hl,$0200
2904  CDE301        call $01E3 ; $4200: sfx something
2907  CD1011        call $1110
290A  212002        ld   hl,$0220 ; $4220 = SFX_SUMFIN_1
290D  CDE301        call $01E3
2910  214002        ld   hl,$0240 ; $4240 = SFX_SUMFIN_2
2913  CDE301        call $01E3
2916  CD1011        call $1110
2919  214008        ld   hl,$0840
291C  1822          jr   $2940

291E                dc   2, $FF

                ;;
                set_dino_dir:
2920  23            inc  hl
2921  23            inc  hl
2922  46            ld   b,(hl) ; read DINO_PATH_X
2923  3A4C81        ld   a,($814C)
2926  37            scf
2927  3F            ccf
2928  90            sub  b
2929  3804          jr   c,$292F ; reset
292B  3EFF          ld   a,$FF
292D  1802          jr   $2931
292F  3E01          ld   a,$01
2931  322E80        ld   ($802E),a
2934  C9            ret

2935                dc   11, $FF

                jmp_hl_pl_4k_and_mystery_8066_fn:
2940  CDE301        call $01E3 ; hl = DRAW_SCREEN
2943  CD1011        call $1110
2946  C9            ret

2947                dc   25, $FF

                save_ix_and_?:
2960  DDE5          push ix
2962  CD0129        call $2901
2965  DDE1          pop  ix
2967  C9            ret

2968                dc   24, $FF

                got_a_bonus:
2980  3A6080        ld   a,($8060)
2983  3C            inc  a
2984  326080        ld   ($8060),a
2987  FE01          cp   $01
2989  2006          jr   nz,$2991
298B  3EF2          ld   a,$F2
298D  324B93        ld   ($934B),a ; uncovering bonus red squares
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
                ;; 6 Bonuses got!
29C0  3A6280        ld   a,($8062)
29C3  217C16        ld   hl,$167C
29C6  85            add  a,l
29C7  6F            ld   l,a
29C8  7E            ld   a,(hl)
29C9  328C93        ld   ($938C),a
29CC  CDD03F        call $3FD0
29CF  0E0A          ld   c,$0A ; 10x
29D1  3A6280        ld   a,($8062)
29D4  47            ld   b,a
29D5  04            inc  b
29D6  3EA0          ld   a,$A0 ; 1000 in bdc
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
29EC  FE04          cp   $04 ; Cap bonus to 4x
29EE  2002          jr   nz,$29F2
29F0  3E03          ld   a,$03
29F2  326280        ld   ($8062),a
29F5  AF            xor  a
29F6  326080        ld   ($8060),a
29F9  CDD016        call $16D0
29FC  CD9C19        call $199C
29FF  C9            ret

                ;; Nodes for dino to follow
                ;; four bytes per node: [ x, y, fr, _ ]
                dino_path_7:
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

                draw_bonus_state:
2AD0  CDD016        call $16D0
2AD3  3A6080        ld   a,($8060)
2AD6  5F            ld   e,a
2AD7  AF            xor  a
2AD8  326080        ld   ($8060),a
2ADB  7B            ld   a,e
2ADC  A7            and  a
2ADD  C8            ret  z
2ADE  CD8029        call $2980 ; clear out "got" bonuses
2AE1  1D            dec  e
2AE2  20FA          jr   nz,$2ADE
2AE4  C9            ret

2AE5                dc   27, $FF

                ;; who calls? (free bytes)
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
                _done_2B14:
2B14  C9            ret

2B15                dc   11, $FF

                ;; who calls? (free bytes?)
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

2B40                dc   16, $FF

                ;; Run enemy update subs, based on current screen
                update_enemies:
2B50  3A0480        ld   a,($8004)
2B53  A7            and  a
2B54  2005          jr   nz,$2B5B
2B56  3A2980        ld   a,($8029)
2B59  1803          jr   $2B5E
2B5B  3A2A80        ld   a,($802A)
2B5E  3D            dec  a ; scr#-1
2B5F  CB27          sla  a ; * 2
2B61  CB27          sla  a ; * 2
2B63  CD9013        call $1390
2B66  00            nop ; scr 1
2B67  00            nop
2B68  00            nop
2B69  C9            ret
2B6A  CD482C        call $2C48
2B6D  C9            ret
2B6E  00            nop ; scr 3
2B6F  00            nop
2B70  00            nop
2B71  C9            ret
2B72  CD582C        call $2C58
2B75  C9            ret
2B76  00            nop ; scr 5
2B77  00            nop
2B78  00            nop
2B79  C9            ret
2B7A  00            nop ; scr 6
2B7B  00            nop
2B7C  00            nop
2B7D  C9            ret
2B7E  00            nop ; scr 7
2B7F  00            nop
2B80  00            nop
2B81  C9            ret
2B82  CD982C        call $2C98
2B85  C9            ret
2B86  CD6831        call $3168
2B89  C9            ret
2B8A  CDF02B        call $2BF0
2B8D  C9            ret
2B8E  CD9833        call $3398 ; scr 11
2B91  C9            ret
2B92  CD7034        call $3470 ; scr 12
2B95  C9            ret
2B96  CD3835        call $3538 ; scr 13
2B99  C9            ret
2B9A  CDB835        call $35B8 ; scr 14
2B9D  C9            ret
2B9E  CD5836        call $3658 ; scr 15
2BA1  C9            ret
2BA2  00            nop ; scr 16
2BA3  00            nop
2BA4  00            nop
2BA5  C9            ret
2BA6  CD7036        call $3670 ; scr 17
2BA9  C9            ret
2BAA  CDD036        call $36D0 ; scr 18
2BAD  C9            ret
2BAE  CD6037        call $3760 ; scr 19
2BB1  C9            ret
2BB2  CDE837        call $37E8 ; scr 20
2BB5  C9            ret
2BB6  00            nop ; scr 21
2BB7  00            nop
2BB8  00            nop
2BB9  C9            ret
2BBA  CD0838        call $3808 ; scr 22
2BBD  C9            ret
2BBE  CD6838        call $3868 ; scr 23
2BC1  C9            ret
2BC2  CD683B        call $3B68 ; scr 24
2BC5  C9            ret
2BC6  CD8838        call $3888 ; scr 25
2BC9  C9            ret
2BCA  CD1839        call $3918
2BCD  C9            ret
2BCE  CD8838        call $3888 ; scr 27
2BD1  C9            ret
2BD2  00            nop ; scr ?
2BD3  00            nop
2BD4  00            nop
2BD5  C9            ret
2BD6  00            nop ; scr ?
2BD7  00            nop
2BD8  00            nop
2BD9  C9            ret
2BDA  00            nop ; scr ?
2BDB  00            nop
2BDC  00            nop
2BDD  C9            ret
2BDE  00            nop ; scr ?
2BDF  00            nop
2BE0  00            nop
2BE1  C9            ret
2BE2  00            nop ; scr ? (32)
2BE3  00            nop
2BE4  00            nop
2BE5  C9            ret

2BE6                dc   10, $FF

                enemy_pattern_scr_10:
2BF0  CDD032        call $32D0
2BF3  CDF032        call $32F0
2BF6  C9            ret

2BF7                dc   9, $FF

                set_rock_1_b0_40:
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

2C1A                dc   14, $FF

                rock_fall_1:
2C28  3A1683        ld   a,($8316)
2C2B  E607          and  $07
2C2D  C0            ret  nz
2C2E  3A3680        ld   a,($8036)
2C31  3C            inc  a
2C32  FE0E          cp   $0E ; has rock finished falling?
2C34  2001          jr   nz,$2C37
2C36  AF            xor  a ; reset
2C37  323680        ld   ($8036),a
2C3A  A7            and  a
2C3B  C0            ret  nz
2C3C  CD002C        call $2C00
2C3F  C9            ret

2C40                dc   8, $FF

                enemy_pattern_scr_2:
2C48  CD282C        call $2C28
2C4B  CD4031        call $3140
2C4E  C9            ret

2C4F                dc   9, $FF

                enemy_pattern_scr_4:
2C58  CD282C        call $2C28
2C5B  CD4031        call $3140
2C5E  CD3832        call $3238
2C61  CD6032        call $3260
2C64  C9            ret

2C65                dc   11, $FF

                ;;
                hiscore_check_buttons:
2C70  3AF183        ld   a,($83F1)
2C73  47            ld   b,a
2C74  3A8491        ld   a,($9184)
2C77  FE01          cp   $01
2C79  2804          jr   z,$2C7F
2C7B  CB78          bit  7,b
2C7D  2009          jr   nz,$2C88
2C7F  3A00A0        ld   a,($A000)
2C82  CB6F          bit  5,a ; jump?
2C84  C4D82E        call nz,$2ED8
2C87  C9            ret
2C88  CB68          bit  5,b ; jump?
2C8A  C4D82E        call nz,$2ED8
2C8D  C9            ret

2C8E                dc   10, $FF

                enemy_pattern_scr_8:
2C98  CD282C        call $2C28
2C9B  CD4031        call $3140
2C9E  CD3832        call $3238
2CA1  CD6032        call $3260
2CA4  CD7035        call $3570
2CA7  CD9035        call $3590
2CAA  C9            ret

2CAB                dc   5, $FF

                ;; wonder what this was for? No paths call anything
                ;; maybe a debug tool?
                ;; -- i've stolen this area for OGNOB mode.
                nopped_out_dispatch:
2CB0  3A0480        ld   a,($8004)
2CB3  A7            and  a
2CB4  2005          jr   nz,$2CBB
2CB6  3A2980        ld   a,($8029)
2CB9  1803          jr   $2CBE
2CBB  3A2A80        ld   a,($802A)
2CBE  3D            dec  a ; scr - 1
2CBF  E607          and  $07 ; & 0000 0111
2CC1  CB27          sla  a ; * 4
2CC3  CB27          sla  a
2CC5  CD9013        call $1390
                ;; all nops, no calls...
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

2CF0                dc   16, $FF

                ;; HiScore somthing
                set_hiscore_and_reset_game:
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

2D3A                dc   14, $FF

                p1_got_hiscore:
2D48  AF            xor  a
2D49  3206B0        ld   ($B006),a
2D4C  3207B0        ld   ($B007),a
2D4F  3E01          ld   a,$01
2D51  CD882D        call $2D88
2D54  C9            ret

2D55                dc   3, $FF

                p2_got_hiscore:
2D58  3AF183        ld   a,($83F1)
2D5B  CB7F          bit  7,a ; hmm what is bit 7 button?
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

2D76                dc   18, $FF

                enter_hiscore_screen:
2D88  F5            push af
2D89  21E816        ld   hl,$16E8 ; 56e8 = $SFX_RESET_A_BUNCH
2D8C  CDE301        call $01E3
2D8F  3E09          ld   a,$09 ; extra life /hiscore sfx
2D91  324280        ld   ($8042),a
2D94  00            nop
2D95  CD7014        call $1470
2D98  CDB837        call $37B8
2D9B  21E00F        ld   hl,$0FE0
2D9E  CD4008        call $0840 ; draws the hiscore screen..
2DA1  00            nop ; params to DRAW_SCREEN
2DA2  00            nop
2DA3  CD1003        call $0310
2DA6  04            inc  b
2DA7  0A            ld   a,(bc)
2DA8  201C          jr   nz,$2DC6 ; PLAYER
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
2DC4  1815          jr   $2DDB ; YOU BEAT THE HIGHEST
2DC6  23            inc  hl
2DC7  24            inc  h
2DC8  FF            rst  $38
2DC9  CD1003        call $0310
2DCC  09            add  hl,bc ; SCORE OF THE DAY
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
2DDF  CD1003        call $0310
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
2DFB  CD1003        call $0310
2DFE  0D            dec  c
2DFF  03            inc  bc
                ;; drawing the alphabet A-L
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
2E18  CD1003        call $0310
2E1B  0F            rrca
2E1C  03            inc  bc
                ;; drawing the alphabet M-X
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
2E35  CD1003        call $0310
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
2E53  CD1003        call $0310
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
2E66  3E09          ld   a,$09 ; 90 seconds timer
2E68  328293        ld   ($9382),a ; num 1 to screen
2E6B  AF            xor  a
2E6C  326293        ld   ($9362),a ; num 2 to screen
2E6F  327580        ld   ($8075),a
2E72  F1            pop  af
2E73  FD217792      ld   iy,$9277
2E77  328491        ld   ($9184),a ; something else on screen...
2E7A  CD882F        call $2F88
2E7D  214E93        ld   hl,$934E
                set_cursor:
2E80  3689          ld   (hl),$89
2E82  DD21F183      ld   ix,$83F1
2E86  3A8491        ld   a,($9184) ; read from screen set above?
2E89  FE01          cp   $01 ; p1 (maybe)?
2E8B  2806          jr   z,$2E93
2E8D  DDCB007E      bit  7,(ix+$00)
2E91  2004          jr   nz,$2E97
2E93  DD2100A0      ld   ix,$A000
2E97  DDCB005E      bit  3,(ix+$00) ; right?
2E9B  2803          jr   z,$2EA0
2E9D  CDA82F        call $2FA8
2EA0  DDCB0056      bit  2,(ix+$00) ; left?
2EA4  2803          jr   z,$2EA9
2EA6  CD502F        call $2F50
2EA9  CD702C        call $2C70
2EAC  00            nop
2EAD  00            nop
2EAE  00            nop
2EAF  00            nop
2EB0  00            nop
2EB1  00            nop
                _check_if_letters_full:
2EB2  E5            push hl
2EB3  FDE5          push iy
2EB5  E1            pop  hl
2EB6  3E37          ld   a,$37
2EB8  BD            cp   l
2EB9  2005          jr   nz,$2EC0
2EBB  3E91          ld   a,$91 ; 9137 = last letter pos
2EBD  BC            cp   h
2EBE  2808          jr   z,$2EC8
2EC0  E1            pop  hl
2EC1  3689          ld   (hl),$89 ; useless? Done in SET_CURSOR
2EC3  CD0831        call $3108
2EC6  18B8          jr   $2E80
                _done_2EC8:
2EC8  E1            pop  hl
2EC9  CD102F        call $2F10
2ECC  C9            ret

2ECD                dc   11, $FF

                ;; called when entered a letter on name
                hiscore_select_letter:
2ED8  3E10          ld   a,$10
2EDA  329380        ld   ($8093),a
2EDD  3E90          ld   a,$90 ; did we press "end"?
2EDF  BC            cp   h
2EE0  2012          jr   nz,$2EF4
2EE2  3E92          ld   a,$92
2EE4  BD            cp   l
2EE5  2004          jr   nz,$2EEB ; no!
2EE7  CD102F        call $2F10
2EEA  C9            ret
2EEB  3ED2          ld   a,$D2 ; how about "rub"?
2EED  BD            cp   l
2EEE  2004          jr   nz,$2EF4 ; nope...
2EF0  CD202F        call $2F20
2EF3  C9            ret
                _enter_letter:
2EF4  2B            dec  hl
2EF5  7E            ld   a,(hl)
2EF6  23            inc  hl
2EF7  FD7700        ld   (iy+$00),a ; draws letter on screen
2EFA  11E0FF        ld   de,$FFE0
2EFD  FD19          add  iy,de
2EFF  C9            ret

2F00                dc   16, $FF

                pop_hls_then_copy_hiscore_name:
2F10  AF            xor  a
2F11  328680        ld   ($8086),a
2F14  E1            pop  hl
2F15  E1            pop  hl
2F16  CDE02F        call $2FE0
2F19  C9            ret

2F1A                dc   6, $FF

                hiscore_rub_letter:
2F20  112000        ld   de,$0020
2F23  FD19          add  iy,de
2F25  FD36002B      ld   (iy+$00),$2B
2F29  3E10          ld   a,$10
2F2B  329792        ld   ($9297),a
2F2E  E5            push hl
2F2F  FDE5          push iy
2F31  E1            pop  hl
2F32  3E92          ld   a,$92 ; 9297 = first letter pos
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

2F45                dc   11, $FF

                hiscore_back_cursor:
2F50  3610          ld   (hl),$10
2F52  114000        ld   de,$0040
2F55  19            add  hl,de
2F56  3E93          ld   a,$93
2F58  BC            cp   h
2F59  C0            ret  nz
2F5A  3E92          ld   a,$92
2F5C  BD            cp   l
2F5D  2004          jr   nz,$2F63
2F5F  219090        ld   hl,$9090 ; screen somewhere
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

2F74                dc   20, $FF

                hiscore_clear_name:
2F88  E5            push hl
2F89  210783        ld   hl,$8307 ; default is "HI-SCORE", clearing...
2F8C  3610          ld   (hl),$10
2F8E  23            inc  hl
2F8F  7D            ld   a,l
2F90  FE11          cp   $11
2F92  20F8          jr   nz,$2F8C
2F94  E1            pop  hl
2F95  C9            ret

2F96                dc   3, $FF
2F99  1F            rra ; weird 0x1F. Dump error?
2F9A                dc   14, $FF

                ;;
                hiscore_fwd_cursor:
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
2FBD  215093        ld   hl,$9350 ; wrap line 1
2FC0  C9            ret
2FC1  3E50          ld   a,$50
2FC3  BD            cp   l
2FC4  2004          jr   nz,$2FCA
2FC6  215293        ld   hl,$9352 ; wrap line 2
2FC9  C9            ret
2FCA  3E52          ld   a,$52
2FCC  BD            cp   l
2FCD  C0            ret  nz
2FCE  214E93        ld   hl,$934E ; wrap line 3
2FD1  C9            ret

2FD2                dc   3, $FF

2FD5  CD3830        call $3038
2FD8  CDE024        call $24E0
2FDB  CD7014        call $1470
2FDE  C9            ret

2FDF  FF            db   $FF

                copy_hiscore_name_to_screen:
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
                ;;; === END OF BG3.BIN, START OF BG4.BIN ======
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

301D                dc   3, $FF

3020  0E05          ld   c,$05
3022  CDA013        call $13A0
3025  0D            dec  c
3026  20FA          jr   nz,$3022
3028  C9            ret

3029                dc   15, $FF

                ;; writes some chars to screen
                ;; actually - different screen loc than copy_msg 1!
                copy_hiscore_name_to_screen_2:
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

3075                dc   11, $FF

                ;; Writes HIGH-SCORE to bytes (later to screen)
                set_hiscore_text:
3080  210783        ld   hl,$8307
3083  3618          ld   (hl),$18 ; h
3085  23            inc  hl
3086  3619          ld   (hl),$19 ; i
3088  23            inc  hl
3089  3617          ld   (hl),$17 ; g
308B  23            inc  hl
308C  3618          ld   (hl),$18 ; h
308E  23            inc  hl
308F  362B          ld   (hl),$2B
3091  23            inc  hl
3092  3623          ld   (hl),$23 ; s
3094  23            inc  hl
3095  3613          ld   (hl),$13 ; c
3097  23            inc  hl
3098  361F          ld   (hl),$1F ; o
309A  23            inc  hl
309B  3622          ld   (hl),$22 ; r
309D  23            inc  hl
309E  3615          ld   (hl),$15 ; e
                ;; set default hiscore
30A0  210083        ld   hl,$8300
30A3  3600          ld   (hl),$00
30A5  23            inc  hl
30A6  3605          ld   (hl),$05
30A8  23            inc  hl
30A9  3600          ld   (hl),$00
30AB  23            inc  hl
30AC  C9            ret

30AD                dc   19, $FF

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

30E1                dc   7, $FF

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

30FF                dc   9, $FF

                ;;
                hiscore_enter_timer:
3108  E5            push hl
3109  C5            push bc
310A  FDE5          push iy
310C  DDE5          push ix
310E  0E14          ld   c,$14
3110  CDA013        call $13A0
3113  0D            dec  c
3114  20FA          jr   nz,$3110
3116  3A7680        ld   a,($8076)
3119  3C            inc  a
311A  327680        ld   ($8076),a
311D  E601          and  $01
                ;; Bug! Jumps to middle of instruction! 0x93 = `sub e, rld (hl)`
                ;; I think maybe should be $3138? (28 17 instead of 28 14)
                ;; (hl) points to the cursor pos. `rld (hl)` makes the cursor into a "0" (tile 0x90),
                ;; but you don't see a visual glitch: because the cursor is re-drawn just
                ;; immediately after this sub returns ($2E80)
311F  2814          jr   z,$3135
3121  217580        ld   hl,$8075
3124  7E            ld   a,(hl)
3125  3D            dec  a
3126  27            daa
3127  CC102F        call z,$2F10
312A  77            ld   (hl),a ; load a into $HISCORE_TIMER
312B  AF            xor  a
312C  ED6F          rld
312E  328293        ld   ($9382),a ; Timer countdown char 1
3131  ED6F          rld
3133  326293        ld   ($9362),a ; Timer countdown char 2
3136  ED6F          rld
3138  DDE1          pop  ix
313A  FDE1          pop  iy
313C  C1            pop  bc
313D  E1            pop  hl
313E  C9            ret

313F  FF            db   $FF

                ;; load rock pos (reset rock pos?)
                update_enemy_1:
3140  3A3780        ld   a,($8037)
3143  A7            and  a
3144  C8            ret  z ; enemy not alive, return
                ;;  Move rock according to lookup table
3145  3C            inc  a
3146  FE3C          cp   $3C
3148  2001          jr   nz,$314B
314A  AF            xor  a
314B  323780        ld   ($8037),a
314E  218031        ld   hl,$3180 ; list of [frame,y pos]
3151  CB27          sla  a
3153  85            add  a,l
3154  6F            ld   l,a
3155  7E            ld   a,(hl)
3156  325581        ld   ($8155),a
3159  23            inc  hl
315A  7E            ld   a,(hl)
315B  325781        ld   ($8157),a
315E  C9            ret

315F                dc   9, $FF

                ;; looks the same as 1?
                enemy_pattern_scr_9:
3168  CD282C        call $2C28
316B  CD4031        call $3140
316E  C9            ret

316F                dc   17, $FF

                ;; ha, every frame is a lookup (like the jump table)
                ;; Format is: [frame, y pos]
                rock_fall_lookup:
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

                set_bird_left_y_c4:
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

322A                dc   14, $FF

                wrap_bird_left_y_c4:
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

3251                dc   15, $FF

                move_animate_bird_left:
3260  3A1583        ld   a,($8315)
3263  E601          and  $01
3265  C8            ret  z
3266  3A3980        ld   a,($8039)
3269  A7            and  a
326A  C8            ret  z
326B  3A5881        ld   a,($8158) ; move left
326E  3D            dec  a
326F  3D            dec  a
3270  3D            dec  a
3271  325881        ld   ($8158),a
3274  3A1583        ld   a,($8315)
3277  E602          and  $02
3279  C0            ret  nz
                _animate_bird:
327A  3A5981        ld   a,($8159)
327D  FE23          cp   $23
327F  2006          jr   nz,$3287
3281  3E24          ld   a,$24
3283  325981        ld   ($8159),a
3286  C9            ret
3287  3E23          ld   a,$23
3289  325981        ld   ($8159),a
328C  C9            ret

328D                dc   35, $FF

                set_blue_meanie_a0_d0:
32B0  3EA0          ld   a,$A0
32B2  325481        ld   ($8154),a
32B5  3ED0          ld   a,$D0
32B7  325781        ld   ($8157),a
32BA  3E17          ld   a,$17
32BC  325681        ld   ($8156),a
32BF  3E34          ld   a,$34
32C1  325581        ld   ($8155),a
32C4  3E01          ld   a,$01
32C6  323B80        ld   ($803B),a ; why enemy_3?
32C9  C9            ret

32CA                dc   6, $FF

                update_stair_up_blue_timer:
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

32E8                dc   8, $FF

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

330D                dc   11, $FF

                ;; blue-meanie up?
3318  3A5781        ld   a,($8157) ; move up?
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

3336                dc   10, $FF

                ;; blue-meanie down?
3340  3A5781        ld   a,($8157) ; move down?
3343  3C            inc  a
3344  3C            inc  a
3345  325781        ld   ($8157),a
3348  3E34          ld   a,$34
334A  325581        ld   ($8155),a
334D  C9            ret

334E                dc   10, $FF

                set_bird_left_y_40:
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

3372                dc   6, $FF

                ;; if x pos < 4 then wrap the bird
                wrap_bird_left_y_40:
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
                _wrap_bird_1:
338D  CD5833        call $3358
3390  C9            ret

3391                dc   7, $FF

3398  CD7833        call $3378
339B  CD6032        call $3260
339E  C9            ret

339F                dc   9, $FF

33A8  CDD032        call $32D0
33AB  CDF032        call $32F0
33AE  C9            ret

33AF                dc   9, $FF

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

33D5                dc   3, $FF

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

33F6                dc   10, $FF

3400  3A5781        ld   a,($8157)
3403  3C            inc  a
3404  3C            inc  a
3405  325781        ld   ($8157),a
3408  C9            ret

3409                dc   15, $FF


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

3435                dc   3, $FF

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

3456                dc   2, $FF

3458  3A5B81        ld   a,($815B)
345B  3C            inc  a
345C  3C            inc  a
345D  325B81        ld   ($815B),a
3460  C9            ret

3461                dc   15, $FF

                ;; wats this?
3470  CDB833        call $33B8
3473  CD1834        call $3418
3476  CD8834        call $3488
3479  CDE834        call $34E8
347C  C9            ret

347D                dc   11, $FF

                update_stairdown_blue_right_timer:
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

34A0                dc   8, $FF

34A8  3E34          ld   a,$34
34AA  325581        ld   ($8155),a
34AD  3EA4          ld   a,$A4
34AF  325481        ld   ($8154),a
34B2  3EAC          ld   a,$AC
34B4  325781        ld   ($8157),a
34B7  3E17          ld   a,$17
34B9  325681        ld   ($8156),a
34BC  3E01          ld   a,$01
34BE  323B80        ld   ($803B),a ; Why set enemy_3?
34C1  C9            ret

34C2                dc   6, $FF

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

34E2                dc   6, $FF

                update_stairdown_blue_left_timer:
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

3500                dc   16, $FF

                ;;  reset a bunch of thing to 255
                reset_enemies:
3510  3EFF          ld   a,$FF
3512  323680        ld   ($8036),a
3515  323880        ld   ($8038),a
3518  323A80        ld   ($803A),a
351B  323C80        ld   ($803C),a
351E  323E80        ld   ($803E),a
3521  324080        ld   ($8040),a
3524  AF            xor  a
                ;;;  reset a bunch of things to 0
3525  323780        ld   ($8037),a
3528  323980        ld   ($8039),a
352B  323B80        ld   ($803B),a
352E  323D80        ld   ($803D),a
3531  323F80        ld   ($803F),a
3534  324180        ld   ($8041),a
3537  C9            ret

                ;;
3538  CD3832        call $3238
353B  CD6032        call $3260
353E  CD282C        call $2C28
3541  CD4031        call $3140
3544  CD7035        call $3570
3547  CD9035        call $3590
354A  C9            ret

354B                dc   5, $FF

                set_rock_x_60:
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

356A                dc   6, $FF

                update_rock_left_timer:
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


3588                dc   8, $FF

                set_rock_3_fr_and_y:
3590  3A3F80        ld   a,($803F)
3593  A7            and  a
3594  C8            ret  z
                ;;  Move rock according to lookup table
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

35AF                dc   9, $FF

35B8  CD7035        call $3570
35BB  CD9035        call $3590
35BE  CD282C        call $2C28
35C1  CD4031        call $3140
35C4  C9            ret

35C5                dc   11, $FF

                ;; in screen 14
                set_bird_right_y_bc:
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

35EA                dc   6, $FF

                ;; any time x < 5?
                wrap_bird_right_y_bc:
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

3609                dc   7, $FF

                move_animate_bird_right:
3610  3A1583        ld   a,($8315)
3613  E601          and  $01
3615  C8            ret  z
3616  3A4180        ld   a,($8041)
3619  A7            and  a
361A  C8            ret  z
361B  3A5C81        ld   a,($815C) ; move right
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

363D                dc   3, $FF

                check_buttons_for_something:
3640  C5            push bc
3641  3AF183        ld   a,($83F1)
3644  E63F          and  $3F ; 0011 1111
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

3665                dc   11, $FF

3670  CDB833        call $33B8
3673  CD1834        call $3418
3676  CD8834        call $3488
3679  CDE834        call $34E8
367C  CDA836        call $36A8
367F  CD1036        call $3610
3682  C9            ret

3683                dc   5, $FF

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

36A2                dc   6, $FF

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

36C1                dc   15, $FF

36D0  CDF035        call $35F0
36D3  CD1036        call $3610
36D6  CD3832        call $3238
36D9  CD6032        call $3260
36DC  CD282C        call $2C28
36DF  CD4031        call $3140
36E2  C9            ret

36E3                dc   5, $FF

                set_spear_left_y_94:
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

3702                dc   14, $FF


                wrap_spear_left_y_94:
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

3729                dc   7, $FF

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

3745                dc   27, $FF

3760  CD1037        call $3710
3763  CD3037        call $3730
3766  CD9837        call $3798
3769  CDB837        call $37B8
376C  C9            ret

376D                dc   11, $FF

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

3792                dc   6, $FF

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

37B1                dc   7, $FF

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

37CE                dc   26, $FF

37E8  CD1037        call $3710
37EB  CD3037        call $3730
37EE  CD9837        call $3798
37F1  CDB837        call $37B8
37F4  CDB833        call $33B8
37F7  CD8834        call $3488
37FA  C9            ret

37FB                dc   13, $FF

3808  CD7833        call $3378
380B  CD6032        call $3260
380E  CD4038        call $3840
3811  CD1036        call $3610
3814  C9            ret

3815                dc   11, $FF

                ;; no! frame 23 is bird left.
                set_bird_right_y_60:
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

383A                dc   6, $FF

                ;; if bird < 4, wrap
                ;; i think this is bird left not right?
                wrap_bird_right_y_60:
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
                _wrap_bird_2:
3855  CD2038        call $3820
3858  C9            ret

3859                dc   15, $FF

3868  CD8834        call $3488
386B  CDB833        call $33B8
386E  CDA836        call $36A8
3871  CD1036        call $3610
3874  CD3832        call $3238
3877  CD6032        call $3260
387A  C9            ret

387B                dc   13, $FF

3888  CD7833        call $3378
388B  CD6032        call $3260
388E  CD4038        call $3840
3891  CD1036        call $3610
3894  CDC038        call $38C0
3897  CDD038        call $38D0
389A  C9            ret

389B                dc   5, $FF

38A0  3E60          ld   a,$60
38A2  325781        ld   ($8157),a
38A5  3EA3          ld   a,$A3
38A7  325581        ld   ($8155),a
38AA  3E16          ld   a,$16
38AC  325681        ld   ($8156),a
38AF  3E01          ld   a,$01
38B1  323B80        ld   ($803B),a
38B4  C9            ret

38B5                dc   11, $FF

38C0  CDA038        call $38A0
38C3  C9            ret

38C4                dc   12, $FF

38D0  3A5C81        ld   a,($815C)
38D3  D650          sub  $50
38D5  325481        ld   ($8154),a
38D8  3A5D81        ld   a,($815D)
38DB  325581        ld   ($8155),a
38DE  C9            ret

38DF  FF            db   $FF

                draw_bonus_box_b:
38E0  CD1003        call $0310
38E3  0A            ld   a,(bc)
38E4  00            nop
38E5  E0            ret  po
38E6  DCDDDE        call c,$DEDD
38E9  DF            rst  $18
38EA  FF            rst  $38
38EB  CD1003        call $0310
38EE  0B            dec  bc
38EF  00            nop
38F0  E1            pop  hl
38F1  FF            rst  $38
38F2  CD1003        call $0310
38F5  0B            dec  bc
38F6  04            inc  b
38F7  E6FF          and  $FF
38F9  CD1003        call $0310
38FC  0C            inc  c
38FD  00            nop
38FE  E1            pop  hl
38FF  FF            rst  $38
3900  CD1003        call $0310
3903  0C            inc  c
3904  04            inc  b
3905  E6FF          and  $FF
3907  CD1003        call $0310
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

                enemy_pattern_scr_26:
3918  CDB839        call $39B8
391B  CDE839        call $39E8
391E  C9            ret

391F                dc   25, $FF

                set_spear_left_bottom:
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

3957                dc   9, $FF

                set_spear_left_middle:
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

397F                dc   9, $FF

                set_spear_left_top:
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

39A7                dc   9, $FF

                ;;; who calls? debug?
39B0  3A0780        ld   a,($8007) ; woah! P1 timer is used maybe?
39B3  323680        ld   ($8036),a
39B6  C9            ret

39B7  FF            db   $FF

                ;;
                wrap_spear_left_bottom:
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

39D9                dc   15, $FF

                update_3_spears_left:           ; screen 26
39E8  3A1583        ld   a,($8315)
39EB  E607          and  $07
39ED  C0            ret  nz
39EE  3A3780        ld   a,($8037) ; bottom spear
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
                ;;
                _middle_spear:
3A0D  3A3980        ld   a,($8039) ; middle spear
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
                ;;
                _top_spear:
3A2C  3A3B80        ld   a,($803B) ; top spear
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

3A4A                dc   6, $FF

                ;;
                enemy_1_reset:
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

3A87  FF            db   $FF

                ;;
                enemy_2_reset:
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

3ABF  FF            dc   1, $FF

                ;; enemy 3
                enemy_3_reset:
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

3AF7                dc   1, $FF

                ;; enemy 1
                set_enemy_1_98_c0:
3AF8  215481        ld   hl,$8154
3AFB  3698          ld   (hl),$98 ; x
3AFD  23            inc  hl
3AFE  3636          ld   (hl),$36 ; frame
3B00  23            inc  hl
3B01  3617          ld   (hl),$17 ; color
3B03  23            inc  hl
3B04  36C0          ld   (hl),$C0 ; y
3B06  23            inc  hl
3B07  3E01          ld   a,$01
3B09  323780        ld   ($8037),a
3B0C  C9            ret

3B0D                dc   3, $FF

                ;; enemy 2
                set_enemy_2_90_c0:
3B10  215881        ld   hl,$8158
3B13  3690          ld   (hl),$90 ; x
3B15  23            inc  hl
3B16  3636          ld   (hl),$36 ; frame
3B18  23            inc  hl
3B19  3617          ld   (hl),$17 ; color
3B1B  23            inc  hl
3B1C  36C0          ld   (hl),$C0 ; y
3B1E  23            inc  hl
3B1F  3E01          ld   a,$01
3B21  323980        ld   ($8039),a
3B24  C9            ret

3B25                dc   3, $FF

                ;; enemy 3
                set_enemy_3_90_c0:
3B28  215C81        ld   hl,$815C
3B2B  3690          ld   (hl),$90 ; x
3B2D  23            inc  hl
3B2E  3636          ld   (hl),$36 ; frame
3B30  23            inc  hl
3B31  3617          ld   (hl),$17 ; color
3B33  23            inc  hl
3B34  36C0          ld   (hl),$C0 ; y
3B36  23            inc  hl
3B37  3E01          ld   a,$01
3B39  323B80        ld   ($803B),a
3B3C  C9            ret

3B3D                dc   3, $FF

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

3B66                dc   2, $FF

3B68  CD403B        call $3B40
3B6B  CDE014        call $14E0
3B6E  00            nop
3B6F  00            nop
3B70  00            nop
3B71  00            nop
3B72  00            nop
3B73  00            nop
3B74  C9            ret

3B75                dc   3, $FF

                ;;
3B78  3A1583        ld   a,($8315)
3B7B  E603          and  $03
3B7D  C8            ret  z
3B7E  E1            pop  hl
3B7F  C9            ret

                ;; interesting algorithm for collision detection!
                player_enemy_collision:
                ;; Check X
3B80  FD7E00        ld   a,(iy+$00) ; points to enemy X
3B83  DD9600        sub  (ix+$00) ; minus player_x
3B86  37            scf
3B87  3F            ccf ; (clear carry)
3B88  D60C          sub  $0C ; is enemy to the right and X diff <= sprite width?
3B8A  3803          jr   c,$3B8F ; ... yes, check Y
3B8C  C618          add  a,$18 ; no, but enemy might be to the left: try "+ width * 2"
3B8E  D0            ret  nc ; no collision on X, leave.
                _check_y:
3B8F  DD7E03        ld   a,(ix+$03) ; player Y pos (player_x addr + 3)
3B92  FD9603        sub  (iy+$03) ; minus enemy Y pos (enemy Y addr + 3)
3B95  37            scf
3B96  3F            ccf ; (clear carry)
3B97  D60A          sub  $0A ; is Y diff <= 10?
3B99  3803          jr   c,$3B9E ; ... yes - we collided.
3B9B  C621          add  a,$21 ; no, but is player above? Check legs.
3B9D  D0            ret  nc ; no - no collsions on Y, leave
                _hit:
3B9E  CD330A        call $0A33
3BA1  C9            ret

3BA2                dc   6, $FF

                ;; Always checks all 3 enemies. "Offscreen" enemies
                ;; have x = 0, so the "check x" test fails.
                player_enemies_collision:
3BA8  FD215481      ld   iy,$8154
3BAC  DD214081      ld   ix,$8140
3BB0  CD803B        call $3B80
3BB3  FD215881      ld   iy,$8158
3BB7  CD803B        call $3B80
3BBA  FD215C81      ld   iy,$815C
3BBE  CD803B        call $3B80
3BC1  C9            ret

3BC2                dc   6, $FF

                copy_xoffs:
3BC8  210881        ld   hl,$8108
3BCB  3A0681        ld   a,($8106)
3BCE  77            ld   (hl),a
3BCF  23            inc  hl
3BD0  23            inc  hl
3BD1  7D            ld   a,l
3BD2  FE40          cp   $40
3BD4  20F5          jr   nz,$3BCB
3BD6  C9            ret

3BD7                dc   1, $FF

                ;; bytes after the call are:
                ;; start_x, start_y, tile 1, ...tile id, 0xFF
                draw_tiles_v_copy:
3BD8  DDE1          pop  ix
3BDA  2600          ld   h,$00
3BDC  DD6E00        ld   l,(ix+$00) ; param 1
3BDF  29            add  hl,hl
3BE0  29            add  hl,hl
3BE1  29            add  hl,hl
3BE2  29            add  hl,hl
3BE3  29            add  hl,hl
3BE4  DD23          inc  ix
3BE6  DD7E00        ld   a,(ix+$00) ; param 2
3BE9  85            add  a,l
3BEA  6F            ld   l,a
3BEB  014090        ld   bc,$9040
3BEE  09            add  hl,bc
3BEF  DD23          inc  ix
3BF1  DD7E00        ld   a,(ix+$00) ; read until 0xff
3BF4  FEFF          cp   $FF
3BF6  2804          jr   z,$3BFC
3BF8  77            ld   (hl),a
3BF9  23            inc  hl
3BFA  18F3          jr   $3BEF
3BFC  DD23          inc  ix
3BFE  DDE5          push ix
3C00  C9            ret

3C01                dc   1, $FF

                screen_tile_animations:
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

                bubble_lava:
3C35  3A4B80        ld   a,($804B)
3C38  3C            inc  a
3C39  FE04          cp   $04
3C3B  2001          jr   nz,$3C3E
3C3D  AF            xor  a
3C3E  324B80        ld   ($804B),a
3C41  A7            and  a
3C42  200B          jr   nz,$3C4F
3C44  CD1003        call $0310
3C47  1D            dec  e
3C48  0E80          ld   c,$80
3C4A  80            add  a,b
3C4B  80            add  a,b
3C4C  80            add  a,b
3C4D  FF            rst  $38
3C4E  C9            ret

                bubble_lava_1:
3C4F  FE01          cp   $01
3C51  200B          jr   nz,$3C5E
3C53  CD1003        call $0310
3C56  1D            dec  e
3C57  0E85          ld   c,$85
3C59  81            add  a,c
3C5A  87            add  a,a
3C5B  81            add  a,c
3C5C  FF            rst  $38
3C5D  C9            ret

                bubble_lava_2:
3C5E  FE02          cp   $02
3C60  200B          jr   nz,$3C6D
3C62  CD1003        call $0310
3C65  1D            dec  e
3C66  0E86          ld   c,$86
3C68  82            add  a,d
3C69  88            adc  a,b
3C6A  80            add  a,b
3C6B  FF            rst  $38
3C6C  C9            ret

                bubble_lava_3:
3C6D  CD1003        call $0310
3C70  1D            dec  e
3C71  0E85          ld   c,$85
3C73  83            add  a,e
3C74  87            add  a,a
3C75  82            add  a,d
3C76  FF            rst  $38
3C77  C9            ret

                bubble_lava_var:
3C78  3A4B80        ld   a,($804B)
3C7B  3C            inc  a
3C7C  FE04          cp   $04
3C7E  2001          jr   nz,$3C81
3C80  AF            xor  a
3C81  324B80        ld   ($804B),a
3C84  A7            and  a
3C85  200C          jr   nz,$3C93
3C87  CD1003        call $0310
3C8A  19            add  hl,de
3C8B  0F            rrca
3C8C  80            add  a,b
3C8D  80            add  a,b ; Flat
3C8E  80            add  a,b
3C8F  80            add  a,b
3C90  80            add  a,b
3C91  FF            rst  $38
3C92  C9            ret

                bubble_lava_var_1:
3C93  FE01          cp   $01
3C95  200C          jr   nz,$3CA3
3C97  CD1003        call $0310
3C9A  19            add  hl,de
3C9B  0F            rrca
3C9C  85            add  a,l
3C9D  81            add  a,c
3C9E  84            add  a,h
3C9F  81            add  a,c
3CA0  87            add  a,a
3CA1  FF            rst  $38
3CA2  C9            ret

                bubble_lava_var_2:
3CA3  FE02          cp   $02
3CA5  200C          jr   nz,$3CB3
3CA7  CD1003        call $0310
3CAA  19            add  hl,de
3CAB  0F            rrca
3CAC  86            add  a,(hl)
3CAD  82            add  a,d
3CAE  88            adc  a,b
3CAF  86            add  a,(hl)
3CB0  82            add  a,d
3CB1  FF            rst  $38
3CB2  C9            ret

                bubble_lava_var_3:
3CB3  CD1003        call $0310
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

                ;; x, frame, color, y
                cutscene_data:
3CC0  80            add  a,b ; player
3CC1  3A1170        ld   a,($7011)
3CC4  80            add  a,b ; player legs
3CC5  3B            dec  sp
3CC6  118094        ld   de,$9480
3CC9  05            dec  b
3CCA  12            ld   (de),a
3CCB  80            add  a,b
3CCC  00            nop ; dino (offscreen)
3CCD  00            nop
3CCE  12            ld   (de),a
3CCF  80            add  a,b
3CD0  00            nop ; dino legs
3CD1  00            nop
3CD2  12            ld   (de),a
3CD3  80            add  a,b
3CD4  6C            ld   l,h ; bambongo 1
3CD5  00            nop
3CD6  12            ld   (de),a
3CD7  80            add  a,b
3CD8  A8            xor  b ; bambongo 2
3CD9  00            nop
3CDA  12            ld   (de),a
3CDB  80            add  a,b
3CDC  00            nop ; unused?
3CDD  00            nop
3CDE  12            ld   (de),a
3CDF  80            add  a,b

                ;; CUTSCENE something
                wait_vblank_8:
3CE0  1E08          ld   e,$08
                _lp_3CE2:
3CE2  E5            push hl
3CE3  D5            push de
3CE4  CDA013        call $13A0
3CE7  D1            pop  de
3CE8  E1            pop  hl
3CE9  1D            dec  e
3CEA  20F6          jr   nz,$3CE2
3CEC  C9            ret

3CED                dc   19, $FF

                ;; player, player legs, bongo, dino_legs -bambongo1-dino-bambongo2
                dance_frame_data:
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

                update_dance_frames:
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
3D30  325181        ld   ($8151),a ; how is dino the same?!
3D33  325581        ld   ($8155),a
3D36  325981        ld   ($8159),a
3D39  23            inc  hl
3D3A  7D            ld   a,l
3D3B  E61F          and  $1F ; wrap dance at 32 bytes
3D3D  6F            ld   l,a
3D3E  C9            ret

3D3F                dc   9, $FF

                ;;; Cut sceen
                do_cutscene:
3D48  3E06          ld   a,$06
3D4A  324280        ld   ($8042),a
3D4D  326580        ld   ($8065),a
3D50  CD7014        call $1470
3D53  21E00F        ld   hl,$0FE0
3D56  CD4008        call $0840
3D59  00            nop ; params to DRAW_SCREEN
3D5A  00            nop
3D5B  CDA003        call $03A0
3D5E  CD5024        call $2450
3D61  214081        ld   hl,$8140 ; destination
3D64  01C03C        ld   bc,$3CC0 ; src location
3D67  1620          ld   d,$20 ; 32 times do
3D69  0A            ld   a,(bc) ; <-
3D6A  77            ld   (hl),a ; |  (sets all sprites)
3D6B  23            inc  hl ; |
3D6C  03            inc  bc ; |
3D6D  15            dec  d ; |
3D6E  20F9          jr   nz,$3D69 ; _|
3D70  CDA03D        call $3DA0
3D73  1680          ld   d,$80 ; 128 x animate cutscene
3D75  AF            xor  a
3D76  322D80        ld   ($802D),a
3D79  21003D        ld   hl,$3D00
                _lp_3D7C:
3D7C  CDE03C        call $3CE0 ; draws gang <-
3D7F  CD203D        call $3D20 ; |
3D82  15            dec  d ; |
3D83  20F7          jr   nz,$3D7C ; ____|
3D85  CDB03E        call $3EB0 ; end of round cutscene
                _cutscene_done:
3D88  3A0480        ld   a,($8004) ; a = $8004 - which screen to use?
3D8B  A7            and  a ; if a != 0
3D8C  2008          jr   nz,$3D96 ; goto screen-set 2
3D8E  3E01          ld   a,$01 ; reset to screen 1
3D90  322980        ld   ($8029),a ; set screen
3D93  C30010        jp   $1000
3D96  3E01          ld   a,$01
3D98  322A80        ld   ($802A),a ; player 2 screen
3D9B  C30010        jp   $1000
3D9E  C9            ret
3D9F                dc   1, $FF

                draw_cage_and_scene:            ; for cutscene
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
3DCA  3E02          ld   a,$02 ; red
3DCC  323181        ld   ($8131),a
3DCF  323381        ld   ($8133),a
3DD2  323581        ld   ($8135),a
3DD5  323781        ld   ($8137),a
3DD8  CD1003        call $0310
3DDB  1C            inc  e ; Row of upward spikes
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
3DFE  CD1003        call $0310
3E01  12            ld   (de),a ; real long platform
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

                cutscene_run_offscreen:
3E22  3E0C          ld   a,$0C
3E24  324181        ld   ($8141),a
3E27  3E0D          ld   a,$0D
3E29  324581        ld   ($8145),a
3E2C  3E29          ld   a,$29
3E2E  322981        ld   ($8129),a
3E31  1E70          ld   e,$70
                _lp_3E33:
3E33  D5            push de
3E34  CDF03E        call $3EF0
3E37  CDE808        call $08E8
3E3A  CDE808        call $08E8
3E3D  CDA013        call $13A0
3E40  D1            pop  de
3E41  1D            dec  e
3E42  20EF          jr   nz,$3E33
3E44  C9            ret

3E45                dc   11, $FF

                delay_2_b:
3E50  1E01          ld   e,$01
                _lp_3E52:
3E52  D5            push de
3E53  DDE5          push ix
3E55  CDA013        call $13A0
3E58  DDE1          pop  ix
3E5A  D1            pop  de
3E5B  1D            dec  e
3E5C  20F4          jr   nz,$3E52
3E5E  C9            ret

3E5F                dc   1, $FF

                cutscene_jump_up_and_down:
3E60  DD214081      ld   ix,$8140
3E64  CD503E        call $3E50
3E67  1608          ld   d,$08
                _lp_3E69:
3E69  DD3503        dec  (ix+$03)
3E6C  DD3507        dec  (ix+$07)
3E6F  DD350B        dec  (ix+$0b)
3E72  CD503E        call $3E50
3E75  15            dec  d
3E76  20F1          jr   nz,$3E69
3E78  1608          ld   d,$08
                _lp_3E7A:
3E7A  DD3403        inc  (ix+$03)
3E7D  DD3407        inc  (ix+$07)
3E80  DD340B        inc  (ix+$0b)
3E83  CD503E        call $3E50
3E86  15            dec  d
3E87  20F1          jr   nz,$3E7A
3E89  C9            ret

3E8A                dc   38, $FF

                end_cutscene:
3EB0  3E07          ld   a,$07 ; end of dance in cutscene
3EB2  324280        ld   ($8042),a
3EB5  215081        ld   hl,$8150 ; set a bunch of bytes at 8150
3EB8  3618          ld   (hl),$18 ; x
3EBA  23            inc  hl
3EBB  362E          ld   (hl),$2E ; frame
3EBD  23            inc  hl
3EBE  3612          ld   (hl),$12 ; color
3EC0  23            inc  hl
3EC1  3670          ld   (hl),$70 ; y
3EC3  215C81        ld   hl,$815C ; and 815c
3EC6  3611          ld   (hl),$11 ; x
3EC8  23            inc  hl
3EC9  3630          ld   (hl),$30 ; frame
3ECB  23            inc  hl
3ECC  3612          ld   (hl),$12 ; color
3ECE  23            inc  hl
3ECF  3680          ld   (hl),$80 ; y
3ED1  CDE03C        call $3CE0
3ED4  CD603E        call $3E60
3ED7  CD603E        call $3E60
3EDA  CD603E        call $3E60
3EDD  80            add  a,b
3EDE  CD223E        call $3E22
3EE1  C9            ret

3EE2                dc   14, $FF

                animate_player_right:
3EF0  7B            ld   a,e
3EF1  E603          and  $03
3EF3  C0            ret  nz
3EF4  CD1806        call $0618
3EF7  C9            ret

3EF8                dc   8, $FF

                delay_83_call_weird_a:
3F00  CD6014        call $1460
3F03  21900E        ld   hl,$0E90 ; 4e90 = LOAD_A_VAL_REALLY_WEIRD
                ; seems to do nothing
3F06  CDE301        call $01E3
3F09  C9            ret

3F0A                dc   6, $FF

                ;;; level tiles at the bottom of the screen
                draw_bottom_row_numbers:
3F10  CD1003        call $0310
3F13  1F            rra ; bottom row
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
3F3C  3A2A80        ld   a,($802A) ; a = scr
3F3F  21BF93        ld   hl,$93BF
                _lp_3F42:
3F42  CD553F        call $3F55 ; slow things down
3F45  3D            dec  a
3F46  2808          jr   z,$3F50
3F48  36DB          ld   (hl),$DB
3F4A  01E0FF        ld   bc,$FFE0
3F4D  09            add  hl,bc
3F4E  18F2          jr   $3F42
                _done_3F50:
3F50  CDD02A        call $2AD0
3F53  C9            ret

3F54                dc   1, $FF

                delay_2_vblank:
3F55  F5            push af
3F56  E5            push hl
3F57  1E01          ld   e,$01
                _lp:
3F59  D5            push de
3F5A  CDA013        call $13A0
3F5D  D1            pop  de
3F5E  1D            dec  e
3F5F  20F8          jr   nz,$3F59
3F61  E1            pop  hl
3F62  F1            pop  af
3F63  C9            ret

3F64                dc   2, $FF

                draw_jetsoft:
3F66  CD1003        call $0310
3F69  0C            inc  c
3F6A  0A            ld   a,(bc)
3F6B  1A            ld   a,(de) ; JETSOFT
3F6C  15            dec  d
3F6D  24            inc  h
3F6E  23            inc  hl
3F6F  1F            rra
3F70  1624          ld   d,$24
3F72  FF            rst  $38
3F73  C9            ret

                draw_proudly_presents:
3F74  CD1003        call $0310
3F77  14            inc  d ; PROUDLY PRESENTS
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

3F8A                dc   2, $FF

                draw_copyright:
3F8C  CD1003        call $0310
3F8F  1004          djnz $3F95
3F91  8B            adc  a,e ; (c) 1983
3F92  010908        ld   bc,$0809
3F95  03            inc  bc
3F96  FF            rst  $38
3F97  CD1003        call $0310
3F9A  12            ld   (de),a
3F9B  04            inc  b
3F9C  1A            ld   a,(de) ; JETSOFT
3F9D  15            dec  d
3F9E  24            inc  h
3F9F  23            inc  hl
3FA0  1F            rra
3FA1  1624          ld   d,$24
3FA3  FF            rst  $38
3FA4  C9            ret

3FA5                dc   3, $FF

                blank_out_bottom_row:
3FA8  CD1003        call $0310
3FAB  1F            rra ; Whole bunch of spaces over the level numbers
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

3FCB                dc   5, $FF

                do_bonus_flashing:
3FD0  00            nop ; wonder what these did originally?
3FD1  00            nop ; 5 bytes?
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

3FFA                dc   6, $FF

                ;;; === END OF BG4.BIN, START OF BG5.BIN ======

                int_handler:
4000  AF            xor  a
4001  3201B0        ld   ($B001),a
4004  3A4040        ld   a,($4040)
4007  00            nop
4008  00            nop
4009  00            nop
400A  3EFF          ld   a,$FF
400C  3200B8        ld   ($B800),a
400F  31F083        ld   sp,$83F0
4012  3A4040        ld   a,($4040)
4015  00            nop
4016  00            nop
4017  00            nop
4018  CD0000        call $0000

401B                dc   5, $FF

                ;; Looks like more general updates
                update_everything_more:
4020  CD5040        call $4050
4023  CD5842        call $4258
4026  CDE042        call $42E0
4029  CD744D        call $4D74
402C  CD2050        call $5020
402F  C9            ret

4030  C9            ret         ;?
4031                dc   7, $FF

                ;; who calls?
                ;; What the heck is $c000?
                ;; RESET_VECTOR is 0x38, this is 4k higher... coincidence?
4038  2100C0        ld   hl,$C000
403B  CD815C        call $5C81
403E  C9            ret

403F                dc   1, $FF


                add_pickup_pat_8:
4040  CD6845        call $4568
4043  3E8E          ld   a,$8E
4045  327A92        ld   ($927A),a
4048  C9            ret

4049                dc   7, $FF

                ;; Adds a bonus as you move right
                ;; Keeps track of "max x" - when you go past it,
                ;; it gets the diff (x - old max x) and adds it to bonus
                add_move_score:
4050  3A4081        ld   a,($8140)
4053  37            scf
4054  3F            ccf
4055  213080        ld   hl,$8030
4058  96            sub  (hl)
4059  D8            ret  c ; not furthest right, no bonus
                ;; adds the move score
405A  47            ld   b,a ; add position diff to score_to_add
405B  3A1D80        ld   a,($801D)
405E  80            add  a,b
405F  321D80        ld   ($801D),a
4062  3A4081        ld   a,($8140) ; set new max X pos
4065  323080        ld   ($8030),a
4068  C9            ret

4069                dc   7, $FF

                add_pickup_pat_5:
4070  3E8C          ld   a,$8C
4072  328E91        ld   ($918E),a
4075  C9            ret

4076                dc   2, $FF

                add_pickup_pat_6:
4078  3E8D          ld   a,$8D
407A  32D291        ld   ($91D2),a
407D  C9            ret

407E                dc   2, $FF

                ;;
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

40A6                dc   1, $FF

                ;; in: h = x, y = l
                ;; out: hl = screen pos of tile at xy
                get_tile_scr_pos:
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

40BF                dc   1, $FF

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

40E6                dc   2, $FF

                add_pickup_pat_9:
40E8  3E8F          ld   a,$8F
40EA  32EE92        ld   ($92EE),a
40ED  3E8E          ld   a,$8E
40EF  321792        ld   ($9217),a
40F2  C9            ret

40F3                dc   1, $FF

                ;;; ; hit bonus
                hit_bonus:
40F4  3E03          ld   a,$03
40F6  324480        ld   ($8044),a
40F9  218029        ld   hl,$2980
40FC  CD815C        call $5C81
40FF  C9            ret

                ;; Called directly by SFX_SUMFIN_2 and
                ;; indirectly (maybe) by weird load at 0x41e3
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

4126                dc   2, $FF

                add_pickup_pat_10:
4128  3E8C          ld   a,$8C
412A  321792        ld   ($9217),a
412D  3E8D          ld   a,$8D
412F  323192        ld   ($9231),a
4132  3E8F          ld   a,$8F
4134  322B92        ld   ($922B),a
4137  C9            ret

4138                dc   8, $FF

                set_synth_settings:
4140  DD7E00        ld   a,(ix+$00)
4143  A7            and  a
4144  C8            ret  z
4145  326680        ld   ($8066),a ; not synth!
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

4179                dc   7, $FF

                related_to_mystery_8066:
4180  DD7E00        ld   a,(ix+$00)
4183  A7            and  a
4184  C8            ret  z
4185  326780        ld   ($8067),a ; 8067
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

                ;; I reckon this is the tiles that say the points
                ;; Changes the tiles, then calls $HIT_BONUS
                hit_bonus_draw_points:
41B0  47            ld   b,a ; adds bonus score
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
41D9  3E40          ld   a,$40 ; 64 countdown. Never read.
41DB  325080        ld   ($8050),a
41DE  C3F440        jp   $40F4

41E1                dc   2, $FF

                ;; How do i get here?... what is this Weird load for?
41E3  3A0041        ld   a,($4100)
41E6  01E301        ld   bc,$01E3
41E9  C5            push bc
41EA  E5            push hl
41EB  C9            ret

                ;; DRAW_CROWN_PIK_BOT_RIGHT
41EC  3E9C          ld   a,$9C
41EE  325A91        ld   ($915A),a
41F1  C9            ret

                ;; DRAW_CROSS_PIK_BOT_RIGHT
41F2  3E9D          ld   a,$9D
41F4  325A91        ld   ($915A),a
41F7  C9            ret

                ;; draw pikup cross, bot, right-er
41F8  3E9D          ld   a,$9D
41FA  321A91        ld   ($911A),a
41FD  C9            ret

41FE                dc   2, $FF

                ;;
4200  DD21A082      ld   ix,$82A0
4204  DD7E04        ld   a,(ix+$04)
4207  A7            and  a
4208  2808          jr   z,$4212
420A  CD4041        call $4140
420D  DD360400      ld   (ix+$04),$00
4211  C9            ret
                _i_2:
4212  CD8040        call $4080
4215  C9            ret

4216  3E9C          ld   a,$9C
4218  32B191        ld   ($91B1),a
421B  C9            ret

421C                dc   4, $FF

                sfx_sumfin_1:
4220  DD21A882      ld   ix,$82A8
4224  DD7E04        ld   a,(ix+$04)
4227  A7            and  a
4228  2808          jr   z,$4232
422A  CD8041        call $4180
422D  DD360400      ld   (ix+$04),$00
4231  C9            ret
                _i_3:
4232  CDC040        call $40C0
4235  C9            ret

4236  3E9C          ld   a,$9C
4238  328E91        ld   ($918E),a
423B  C9            ret

423C                dc   4, $FF

                sfx_sumfin_2:
4240  DD21B082      ld   ix,$82B0
4244  DD7E04        ld   a,(ix+$04)
4247  A7            and  a
4248  2808          jr   z,$4252
424A  CDB042        call $42B0
424D  DD360400      ld   (ix+$04),$00
4251  C9            ret
                _i_4:
4252  CD0041        call $4100
4255  C9            ret

4256                dc   2, $FF

                pickup_tile_collision:
4258  3A4081        ld   a,($8140)
425B  C604          add  a,$04 ; lol, 4 pixels to get pickup
425D  67            ld   h,a
425E  3A4381        ld   a,($8143)
4261  C618          add  a,$18
4263  6F            ld   l,a
4264  CDA740        call $40A7
4267  7E            ld   a,(hl)
4268  FE10          cp   $10
426A  C8            ret  z
                ;;
426B  FE8C          cp   $8C
426D  2008          jr   nz,$4277
426F  3E20          ld   a,$20 ; 200 bonus
4271  3610          ld   (hl),$10
4273  CDB041        call $41B0
4276  C9            ret
                _crossa:
4277  FE8D          cp   $8D
4279  2008          jr   nz,$4283
427B  3E40          ld   a,$40 ; 400 bonus
427D  3610          ld   (hl),$10
427F  CDB041        call $41B0
4282  C9            ret
                _ringa:
4283  FE8E          cp   $8E
4285  2008          jr   nz,$428F
4287  3E60          ld   a,$60 ; 600 bonus
4289  3610          ld   (hl),$10
428B  CDB041        call $41B0
428E  C9            ret
                _vasea:
428F  FE8F          cp   $8F
4291  C0            ret  nz
4292  3EA0          ld   a,$A0 ; 1000 bonus
4294  3610          ld   (hl),$10
4296  CDB041        call $41B0
4299  C9            ret

                ;;; called? Draws a cross (same spot as "ADD_PICKUP_PAT_6", but A version)
                ;; might be old dud code
429A  3E9D          ld   a,$9D
429C  32D291        ld   ($91D2),a
429F  C9            ret

                ;; Weird bug in it - same code as ADD_PICKUP_PAT_7,
                ;; but that called $ADD_PICKUP_PAT_5: not the middle of nowhere!
                funky_looking_set_ring:
42A0  3E8E          ld   a,$8E
42A2  32CB90        ld   ($90CB),a
42A5  CD0236        call $3602 ; <- that looks odd. Weird jump to middle of code
42A8  C9            ret

42A9                dc   7, $FF

                related_to_mystery_8066_2:
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

                ;; My theory: the bonus-points text that appears
                ;; when you get a pickup, was supposed to disappear after 64 frames
                ;; but they gave up. That's my theory.
                1up_timer_countdown:
42E0  3A5080        ld   a,($8050)
42E3  A7            and  a
42E4  C8            ret  z
42E5  3D            dec  a
42E6  325080        ld   ($8050),a
42E9  A7            and  a
42EA  C9            ret

                ;; never called, cause my theory above...
                blank_out_1up_text:
42EB  2A4C80        ld   hl,($804C)
42EE  3E10          ld   a,$10
42F0  00            nop
42F1  77            ld   (hl),a
42F2  11E0FF        ld   de,$FFE0 ; -32 (next line up screen)
42F5  19            add  hl,de
42F6  3E10          ld   a,$10
42F8  00            nop
42F9  77            ld   (hl),a
42FA  C9            ret

42FB                dc   5, $FF

                ;; data?
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

                ;;
4312  CDF841        call $41F8
4315  3E9E          ld   a,$9E
4317  327A92        ld   ($927A),a
431A  C9            ret

431B                dc   5, $FF

                sfx_something_ch_1:
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

4356                dc   10, $FF

                sfx_something_ch_2:
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

                ;; called?
4396  CDA042        call $42A0
4399  3E9E          ld   a,$9E
439B  32AB92        ld   ($92AB),a
439E  C9            ret

439F                dc   1, $FF

                ;;
                sfx_what_1:
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

43D6                dc   10, $FF

43E0  3E9F          ld   a,$9F
43E2  32EE92        ld   ($92EE),a
43E5  3E9E          ld   a,$9E
43E7  321792        ld   ($9217),a
43EA  C9            ret

43EB                dc   1, $FF

43EC  3E9C          ld   a,$9C
43EE  321792        ld   ($9217),a
43F1  3E9D          ld   a,$9D
43F3  323192        ld   ($9231),a
43F6  3E9F          ld   a,$9F
43F8  322B92        ld   ($922B),a
43FB  C9            ret

43FC                dc   4, $FF

                ;;; SFX synth settings data
                sfx_synth_settings:
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

                draw_cage_top:
4484  3A0480        ld   a,($8004)
4487  A7            and  a
4488  2005          jr   nz,$448F
448A  3A2980        ld   a,($8029)
448D  1803          jr   $4492
448F  3A2A80        ld   a,($802A)
4492  FE1B          cp   $1B ; are we on screen 27?
4494  C0            ret  nz ; Nope, leave.
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
                ;; looks like data: 2byte coords
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
                _more_cage:
44E4  3C            inc  a
44E5  328991        ld   ($9189),a
44E8  3C            inc  a
44E9  328A91        ld   ($918A),a
44EC  C9            ret

44ED                dc   19, $FF

                ;; sfx/tune player
                ;; plays a few samples of sfx each tick

                sfx_01:; La Cucaracha
4500  DD7E12        ld   a,(ix+$12)
4503  A7            and  a
4504  2805          jr   z,$450B
4506  3D            dec  a
4507  DD7712        ld   (ix+$12),a
450A  C9            ret

                sfx_02:; Minor-key death ditti
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

                sfx_03:; Pickup bling
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

                ;;  not sfx routine?
4555  DD7501        ld   (ix+$01),l
4558  DD7402        ld   (ix+$02),h
455B  DD7707        ld   (ix+$07),a
455E  23            inc  hl
455F  7E            ld   a,(hl)
4560  DD7708        ld   (ix+$08),a
4563  CD2043        call $4320
4566  C9            ret

4567                dc   1, $FF

                add_pickup_pat_3:
4568  3E8D          ld   a,$8D
456A  321A91        ld   ($911A),a
456D  C9            ret

456E                dc   2, $FF

                add_pickup_pat_4:
4570  3E8C          ld   a,$8C
4572  32B191        ld   ($91B1),a
4575  C9            ret

4576                dc   1, $FF

                add_pickup_pat_7:
4577  3E8E          ld   a,$8E
4579  32CB90        ld   ($90CB),a
457C  CD7040        call $4070
457F  C9            ret

                sfx_06:; cutscene dance start (also intro tune?)
4580  DD7E13        ld   a,(ix+$13)
4583  A7            and  a
4584  2805          jr   z,$458B
4586  3D            dec  a
4587  DD7713        ld   (ix+$13),a
458A  C9            ret
                ;; sfxsomething #4
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

                ;; sfxsomething #5
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

                ;; sfxsomething #6
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

45E7                dc   1, $FF

                ;;
                add_pickup_pat_2:
45E8  3E8D          ld   a,$8D
45EA  325A91        ld   ($915A),a
45ED  C9            ret

45EE                dc   18, $FF

                ;; sfxsomething #7
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

                ;; sfxsomething #8
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

                ;; sfxsomething #9
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

4667                dc   25, $FF

                ;;; sfx something #10
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

46A2                dc   14, $FF
                ;;
                add_a_to_ret_addr:
46B0  E1            pop  hl
46B1  0600          ld   b,$00
46B3  4F            ld   c,a
46B4  09            add  hl,bc
46B5  E5            push hl
46B6  C9            ret

46B7                dc   9, $FF

                zero_out_some_sfx:
46C0  21B882        ld   hl,$82B8
46C3  0618          ld   b,$18
46C5  3600          ld   (hl),$00
46C7  23            inc  hl
46C8  10FB          djnz $46C5
46CA  C9            ret

46CB                dc   5, $FF

                ;; gets here on death and re-spawn
                clear_sfx_1:
46D0  CDC046        call $46C0
46D3  3A4280        ld   a,($8042)
46D6  CD3047        call $4730
46D9  DD21B882      ld   ix,$82B8
46DD  CD9047        call $4790
46E0  AF            xor  a
46E1  324280        ld   ($8042),a
46E4  C9            ret

46E5                dc   3, $FF

                play_tune_for_cur_screen:
46E8  3A3480        ld   a,($8034)
46EB  A7            and  a
46EC  C8            ret  z
46ED  3A0480        ld   a,($8004)
46F0  A7            and  a
46F1  2005          jr   nz,$46F8
46F3  3A2980        ld   a,($8029)
46F6  1803          jr   $46FB
46F8  3A2A80        ld   a,($802A)
46FB  3D            dec  a ; scr - 1
46FC  87            add  a,a ; ...
46FD  87            add  a,a ; * 3
46FE  CDB049        call $49B0
4701  47            ld   b,a
4702  3A6580        ld   a,($8065)
4705  B8            cp   b
4706  C8            ret  z
4707  78            ld   a,b
4708  324280        ld   ($8042),a ; wat sfx is this?
470B  326580        ld   ($8065),a
470E  C9            ret

470F                dc   17, $FF

4720  76            halt ; only halt in file!
4721  0D            dec  c
4722                dc   14, $FF

                ;;
                point_hl_to_sfx_data:
4730  CB27          sla  a ; sfx id * 4
4732  CB27          sla  a
4734  CDB046        call $46B0
                _sfx_data_lookup:
4737  00            nop ; sfx 0?
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

4787                dc   9, $FF

                ;; hl = sfx data
                ;; ix = ... 82d0, 82e8, or 82b8
                do_something_with_sfx_data:
4790  00            nop
4791  00            nop
4792  00            nop
4793  00            nop
4794  7E            ld   a,(hl) ; 1. points at sfx data
4795  DD770D        ld   (ix+$0d),a
4798  47            ld   b,a
4799  23            inc  hl
479A  7E            ld   a,(hl) ; 2
479B  DD7701        ld   (ix+$01),a
479E  23            inc  hl
479F  7E            ld   a,(hl) ; 3
47A0  DD7702        ld   (ix+$02),a
47A3  05            dec  b
47A4  2817          jr   z,$47BD ; branch...
47A6  23            inc  hl
47A7  7E            ld   a,(hl) ; 4
47A8  DD7703        ld   (ix+$03),a
47AB  23            inc  hl
47AC  7E            ld   a,(hl) ; 5
47AD  DD7704        ld   (ix+$04),a
47B0  05            dec  b
47B1  280A          jr   z,$47BD
47B3  23            inc  hl
47B4  7E            ld   a,(hl) ; 6
47B5  DD7705        ld   (ix+$05),a
47B8  23            inc  hl
47B9  7E            ld   a,(hl) ; 7
47BA  DD7706        ld   (ix+$06),a
                _here:
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

4825                dc   27, $FF

                sfx_queuer:
4840  3A4280        ld   a,($8042)
4843  A7            and  a
4844  2005          jr   nz,$484B
4846  CD8046        call $4680 ; play in ch1
4849  1803          jr   $484E
484B  CDD046        call $46D0 ; ... kill ch1?
484E  3A4380        ld   a,($8043) ; and try ch2?
4851  A7            and  a
4852  2005          jr   nz,$4859
4854  CDE048        call $48E0 ; play in ch2?
4857  1803          jr   $485C
4859  CD2049        call $4920
485C  3A4480        ld   a,($8044)
485F  A7            and  a
4860  2005          jr   nz,$4867
4862  CD7C48        call $487C
4865  1803          jr   $486A
4867  CD9C48        call $489C
                _done_486A:
486A  C9            ret

486B                dc   5, $FF

                ;;; called from PLAY_SFX...
                zero_out_some_sfx_2:
4870  21E882        ld   hl,$82E8
4873  0618          ld   b,$18
4875  3600          ld   (hl),$00
4877  23            inc  hl
4878  10FB          djnz $4875
487A  C9            ret

487B                dc   1, $FF

                ;;; more sfx something
                more_sfx_something:
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

489A                dc   2, $FF

                play_sfx:
489C  CD7048        call $4870
489F  3A4480        ld   a,($8044)
48A2  CD3047        call $4730
48A5  DD21E882      ld   ix,$82E8
48A9  CD9047        call $4790
48AC  AF            xor  a
48AD  324480        ld   ($8044),a
48B0  C9            ret

48B1                dc   1, $FF

                attract_your_being_chased_flash:
48B2  CD504B        call $4B50
48B5  CDA85A        call $5AA8
48B8  CDA85A        call $5AA8
48BB  CDA85A        call $5AA8
48BE  CDA85A        call $5AA8
48C1  217014        ld   hl,$1470
48C4  CD815C        call $5C81
48C7  CDA85A        call $5AA8
48CA  C9            ret

48CB                dc   21, $FF

                ;;; Even more sfx something
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

48FE                dc   2, $FF

                jump_rel_a_copy:  ; duplicate routine
4900  D9            exx
4901  E1            pop  hl
4902  0600          ld   b,$00
4904  4F            ld   c,a
4905  09            add  hl,bc
4906  E5            push hl
4907  D9            exx
4908  C9            ret

4909                dc   7, $FF

                zero_out_some_sfx_3:
4910  21D082        ld   hl,$82D0
4913  0618          ld   b,$18
4915  3600          ld   (hl),$00
4917  23            inc  hl
4918  10FB          djnz $4915
491A  C9            ret

491B                dc   5, $FF

                clear_sfx_2:
4920  CD1049        call $4910
4923  3A4380        ld   a,($8043)
4926  CD3047        call $4730
4929  DD21D082      ld   ix,$82D0
492D  CD9047        call $4790
4930  AF            xor  a
4931  324380        ld   ($8043),a
4934  C9            ret

4935                dc   11, $FF

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

497D                dc   3, $FF

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

49A2                dc   14, $FF

                ;; set the sfx value for the new screen
                ;; a contains offset of sfx to play for screen
                get_screen_tune_sfx_id:
49B0  CDB046        call $46B0
49B3  3E0E          ld   a,$0E ; scr 1
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
4A03  3E0C          ld   a,$0C ; scr 21: best tune
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

                sfx_15_data:
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

                ;;
                your_being_chased_dino_sprite:
4B50  214081        ld   hl,$8140
4B53  3685          ld   (hl),$85 ; x
4B55  23            inc  hl
4B56  362C          ld   (hl),$2C ; frame
4B58  23            inc  hl
4B59  3612          ld   (hl),$12 ; color
4B5B  23            inc  hl
4B5C  3690          ld   (hl),$90 ; y
4B5E  23            inc  hl
4B5F  367E          ld   (hl),$7E ; x legs
4B61  23            inc  hl
4B62  3630          ld   (hl),$30 ; frame legs
4B64  23            inc  hl
4B65  3612          ld   (hl),$12 ; color legs
4B67  23            inc  hl
4B68  36A0          ld   (hl),$A0 ; y legs
4B6A  23            inc  hl
4B6B  C9            ret

4B6C                dc   116, $FF ; 116 free bytes!

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

                sfx_2_data:
4C46  03            inc  bc
4C47  364C          ld   (hl),$4C
4C49  3E4C          ld   a,$4C
4C4B  304C          jr   nc,$4C99

4C4D                dc   3, $FF

                ;;
                add_screen_pickups:
4C50  CD8444        call $4484
4C53  3A0480        ld   a,($8004)
4C56  A7            and  a
4C57  2805          jr   z,$4C5E
4C59  3A2A80        ld   a,($802A)
4C5C  1803          jr   $4C61
4C5E  3A2980        ld   a,($8029)
4C61  3D            dec  a ; scr - 1
4C62  87            add  a,a
4C63  87            add  a,a ; * 3
4C64  CD0049        call $4900
                ;; One per screen
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
4CCF  00            nop ; screen 27
4CD0  00            nop ; (no pickups)
4CD1  00            nop
4CD2  C9            ret
4CD3  00            nop
4CD4  00            nop
4CD5  00            nop
4CD6  C9            ret

4CD7                dc   12, $FF

                add_pickup_pat_1:
4CE3  3E8C          ld   a,$8C
4CE5  325A91        ld   ($915A),a
4CE8  C9            ret

4CE9                dc   1, $FF

                ;; Runs every frame as cage drops...
                ;; hl contains screen location of cage
                ;; so `l` is used as CAGE_Y
                check_dino_cage_collision:
4CEA  3A4C81        ld   a,($814C)
4CED  D684          sub  $84 ; is dino x >= 0x84 (132)?
4CEF  37            scf
4CF0  3F            ccf ; ...
4CF1  D618          sub  $18 ; and < 132 + 24 (156) ?
4CF3  D0            ret  nc ; no: return.
4CF4  3A4F81        ld   a,($814F) ; yes! check y
4CF7  CB3F          srl  a
4CF9  CB3F          srl  a
4CFB  CB3F          srl  a
4CFD  47            ld   b,a ; b = y / 8
4CFE  7D            ld   a,l ; cage_y
4CFF  E61F          and  $1F ; & 00011111 (?)
4D01  90            sub  b ; - b
4D02  37            scf
4D03  3F            ccf ; (... -2)
4D04  C3B44D        jp   $4DB4

4D07                dc   1, $FF

                draw_cage_tiles:
4D08  CD604D        call $4D60
4D0B  E5            push hl
4D0C  2B            dec  hl
4D0D  3610          ld   (hl),$10 ; column 1
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
4D1F  3610          ld   (hl),$10 ; column 2
4D21  23            inc  hl
4D22  3674          ld   (hl),$74
4D24  23            inc  hl
4D25  3675          ld   (hl),$75
4D27  23            inc  hl
4D28  3678          ld   (hl),$78
4D2A  23            inc  hl
4D2B  3679          ld   (hl),$79
4D2D  09            add  hl,bc
4D2E  3610          ld   (hl),$10 ; column 3
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

4D3E                dc   2, $FF

                ;; hl = cage screen addr, so l = "Y pos"
                ;; starts at 0xC9 (201) and incs to 0xDC (220)
                trigger_cage_fall:
4D40  CD754E        call $4E75
                _update_cage_fall:
4D43  CD084D        call $4D08
4D46  E5            push hl
4D47  21A013        ld   hl,$13A0 ; blocks action as cage falls
4D4A  CD815C        call $5C81
4D4D  3A1283        ld   a,($8312)
4D50  E603          and  $03
4D52  20F3          jr   nz,$4D47
4D54  E1            pop  hl
4D55  23            inc  hl ; move cage down
4D56  CDEA4C        call $4CEA
4D59  3EDC          ld   a,$DC ; did cage hit ground?
4D5B  BD            cp   l
4D5C  C8            ret  z
4D5D  18E4          jr   $4D43 ; nope, loop

4D5F                dc   1, $FF

                reset_3_row_xoffs:              ; which ones?
4D60  AF            xor  a
4D61  322681        ld   ($8126),a
4D64  322881        ld   ($8128),a
4D67  322A81        ld   ($812A),a
4D6A  C9            ret

4D6B                dc   9, $FF

                end_screen_logic:
4D74  3A0480        ld   a,($8004) ; are we on end screen?
4D77  A7            and  a
4D78  2005          jr   nz,$4D7F
4D7A  3A2980        ld   a,($8029)
4D7D  1803          jr   $4D82
4D7F  3A2A80        ld   a,($802A)
4D82  FE1B          cp   $1B ; // check is screen 27
4D84  C0            ret  nz
4D85  CD904D        call $4D90
4D88  C9            ret

4D89                dc   7, $FF

                check_player_cage_collision:
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
4DA9  3E01          ld   a,$01 ; Yep, trigger cage
4DAB  325180        ld   ($8051),a
4DAE  CD404D        call $4D40
4DB1  C9            ret

4DB2                dc   2, $FF

                check_dino_cage_collision_cont:
4DB4  D602          sub  $02 ; less than 2 diff?
4DB6  D0            ret  nc ; no, no Y collision
4DB7  C3D04D        jp   $4DD0 ; yes, caged the dino

4DBA                dc   6, $FF

                ;;
                wait_vblank_40:
4DC0  2E40          ld   l,$40
                _lp_4DC2:
4DC2  E5            push hl
4DC3  21A013        ld   hl,$13A0
4DC6  CD815C        call $5C81
4DC9  E1            pop  hl
4DCA  2D            dec  l
4DCB  20F5          jr   nz,$4DC2
4DCD  C9            ret

4DCE                dc   2, $FF

                done_caged_dino:
4DD0  AF            xor  a
4DD1  324C81        ld   ($814C),a
4DD4  325081        ld   ($8150),a
4DD7  CD084D        call $4D08
4DDA  E5            push hl
4DDB  21A013        ld   hl,$13A0
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

4E1D                dc   3, $FF

                attract_splash_bongo:
4E20  CD804E        call $4E80
4E23  CD815C        call $5C81 ; hl = $DRAW_JETSOFT
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
4E4C  214892        ld   hl,$9248 ; draw the BONGO logo
4E4F  06A0          ld   b,$A0
4E51  0E05          ld   c,$05
                _lp_4E53:
4E53  70            ld   (hl),b ; top right
4E54  04            inc  b
4E55  23            inc  hl
4E56  70            ld   (hl),b ; bottom right
4E57  04            inc  b
4E58  111F00        ld   de,$001F
4E5B  19            add  hl,de
4E5C  70            ld   (hl),b ; top left
4E5D  04            inc  b
4E5E  23            inc  hl
4E5F  70            ld   (hl),b ; bottom left
4E60  11A1FF        ld   de,$FFA1
4E63  19            add  hl,de
4E64  04            inc  b
4E65  CDD44E        call $4ED4
4E68  0D            dec  c
4E69  20E8          jr   nz,$4E53
4E6B  218C3F        ld   hl,$3F8C
4E6E  CD815C        call $5C81
4E71  C3E252        jp   $52E2

4E74                dc   1, $FF

                ;;
                setup_cage_sfx_and_screen:
4E75  F5            push af
4E76  3E05          ld   a,$05
4E78  324480        ld   ($8044),a
4E7B  F1            pop  af
4E7C  21C991        ld   hl,$91C9
4E7F  C9            ret

                draw_border_and_jetsoft:
4E80  21880F        ld   hl,$0F88
4E83  CD815C        call $5C81
4E86  21663F        ld   hl,$3F66
4E89  C9            ret

4E8A                dc   6, $FF

                ;; This totally does nothing but waste some
                ;; cycles right? A reg is not even used after
                ;; Maybe it was nopped out? debug?
                load_a_val_really_weird:
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

                ;; on splash screen something... wait a bunch
                wait_60_for_start_button:
4EB0  CDC24E        call $4EC2
4EB3  CDC24E        call $4EC2
4EB6  CDC24E        call $4EC2
4EB9  CDC24E        call $4EC2
4EBC  C9            ret

4EBD                dc   5, $FF

                wait_15_for_start_button:
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

                ;; what 30 for start
                wait_30_for_start_button:
4ED4  CDC24E        call $4EC2
4ED7  CDC24E        call $4EC2
4EDA  C9            ret

4EDB                dc   5, $FF

                speed_up_for_next_round:
4EE0  3A0480        ld   a,($8004)
4EE3  A7            and  a
4EE4  2005          jr   nz,$4EEB
4EE6  215B80        ld   hl,$805B
4EE9  1803          jr   $4EEE
4EEB  215C80        ld   hl,$805C
4EEE  7E            ld   a,(hl)
4EEF  FE1F          cp   $1F
4EF1  2003          jr   nz,$4EF6
4EF3  3610          ld   (hl),$10 ; round 2 = $10
4EF5  C9            ret
4EF6  FE10          cp   $10
4EF8  2003          jr   nz,$4EFD
4EFA  360D          ld   (hl),$0D ; round 3 = $0d
4EFC  C9            ret
4EFD  C31C50        jp   $501C ; round 4+ = get 2 faster each time!

                pickups_lookup:
4F00  91            sub  c ; up to 3 pickups per screen
4F01  5A            ld   e,d
4F02  8C            adc  a,h
4F03  00            nop
4F04  00            nop
4F05  00            nop
4F06  00            nop
4F07  00            nop
4F08  00            nop
4F09  91            sub  c ; pos (hi), pos (lo), pickup symbol
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
4FEA  00            nop ; Screen 27 (cage - no pickups)
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

4FFE                dc   2, $FF

                ;;; === END OF BG5.BIN, START OF BG6.BIN ======

                animate_pickups:
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

                ;; Decrease the speed timer further each round
                even_more_faster_dino:
501C  3D            dec  a
501D  3D            dec  a
501E  77            ld   (hl),a
501F  C9            ret

                animate_all_pickups:
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
5037  3D            dec  a ; Get screen x 9
5038  47            ld   b,a
5039  87            add  a,a
503A  87            add  a,a
503B  87            add  a,a
503C  80            add  a,b
503D  85            add  a,l ; index into PICKUPS table
503E  6F            ld   l,a
503F  7E            ld   a,(hl) ; Find pickup screen addr
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

5052                dc   1, $FF

                sfx_3_data:
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

                sfx_4_data:
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

                sfx_5_data:
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

                sfx_6_data:
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

                sfx_7_data:
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

                ;; ??
                play_sfx_chunk_ch_1:
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

5241                dc   15, $FF

                ;; triggers every few frames.
                ;; Maybe play current chunk of tune?
                ;; looks the same as above funk (ch1?)
                play_sfx_chunk_ch_2:
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

5291                dc   15, $FF

                ;;??
                sfx_sub_what_1:
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

52E1                dc   1, $FF

                ;;
                attract_animate_player_up_stairs:
52E2  CDB04E        call $4EB0
52E5  214081        ld   hl,$8140
52E8  36D8          ld   (hl),$D8 ; x (right of screen)
52EA  23            inc  hl
52EB  368D          ld   (hl),$8D ; frame
52ED  23            inc  hl
52EE  3611          ld   (hl),$11 ; color
52F0  23            inc  hl
52F1  36E0          ld   (hl),$E0 ; y (bottom of screen)
52F3  23            inc  hl
52F4  36D8          ld   (hl),$D8 ; x legs
52F6  23            inc  hl
52F7  368D          ld   (hl),$8D ; frame legs
52F9  23            inc  hl
52FA  3611          ld   (hl),$11 ; color legs
52FC  23            inc  hl
52FD  36F0          ld   (hl),$F0 ; y legs
52FF  1E06          ld   e,$06
                _jump_up_stair:
5301  CD2853        call $5328
5304  1D            dec  e
5305  20FA          jr   nz,$5301
5307  214881        ld   hl,$8148 ; using bongo - but it shows dino
530A  3620          ld   (hl),$20 ; x (left of screen)
530C  23            inc  hl
530D  362D          ld   (hl),$2D ; frame
530F  23            inc  hl
5310  3612          ld   (hl),$12 ; color
5312  23            inc  hl
5313  3628          ld   (hl),$28 ; y (top of screen)
5315  23            inc  hl
5316  3619          ld   (hl),$19 ; x legs
5318  23            inc  hl
5319  3630          ld   (hl),$30 ; frame legs
531B  23            inc  hl
531C  3612          ld   (hl),$12 ; color legs
531E  23            inc  hl
531F  3638          ld   (hl),$38 ; y legs
5321  CDAC53        call $53AC
5324  C32854        jp   $5428

5327                dc   1, $FF

                attract_jump_up_one_stair:
5328  1600          ld   d,$00
                _lp_532A:
532A  218053        ld   hl,$5380
532D  7A            ld   a,d
532E  87            add  a,a
532F  87            add  a,a
5330  85            add  a,l
5331  6F            ld   l,a
5332  DD214081      ld   ix,$8140
5336  7E            ld   a,(hl)
5337  DD7701        ld   (ix+$01),a ; frame
533A  23            inc  hl
533B  7E            ld   a,(hl)
533C  DD7705        ld   (ix+$05),a ; frame leg
533F  23            inc  hl
5340  7E            ld   a,(hl)
5341  DD8600        add  a,(ix+$00) ; x-offset
5344  DD7700        ld   (ix+$00),a ; x
5347  DD7704        ld   (ix+$04),a ; x legs
534A  23            inc  hl
534B  7E            ld   a,(hl)
534C  DD8603        add  a,(ix+$03) ; y-offset
534F  DD7703        ld   (ix+$03),a ; y
5352  D610          sub  $10
5354  DD7707        ld   (ix+$07),a ; y legs
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

5375                dc   11, $FF

                ;; frame, frame leg, x-off, y-off
                attract_player_up_stair_data:
5380  8D            adc  a,l ; jumping up stairs
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
                _done_54AB:
53AB  C9            ret

                attract_jump_down_stairs:
53AC  1E06          ld   e,$06 ; 6 stairs down
53AE  CDB853        call $53B8
53B1  CD9853        call $5398
53B4  1D            dec  e
53B5  20F7          jr   nz,$53AE
53B7  C9            ret

                ;; identical to jump up, but point at down data.
                attract_jump_down_one_stair:
53B8  1600          ld   d,$00
                _lp_53BA:
53BA  210854        ld   hl,$5408
53BD  7A            ld   a,d
53BE  87            add  a,a
53BF  87            add  a,a
53C0  85            add  a,l
53C1  6F            ld   l,a
53C2  DD214081      ld   ix,$8140
53C6  7E            ld   a,(hl)
53C7  DD7701        ld   (ix+$01),a ; frame
53CA  23            inc  hl
53CB  7E            ld   a,(hl)
53CC  DD7705        ld   (ix+$05),a ; frame leg
53CF  23            inc  hl
53D0  7E            ld   a,(hl)
53D1  DD8600        add  a,(ix+$00) ; x-offset
53D4  DD7700        ld   (ix+$00),a ; x
53D7  DD7704        ld   (ix+$04),a ; x legs
53DA  23            inc  hl
53DB  7E            ld   a,(hl)
53DC  DD8603        add  a,(ix+$03) ; y-offset
53DF  DD7703        ld   (ix+$03),a ; y
53E2  D610          sub  $10
53E4  DD7707        ld   (ix+$07),a ; y legs
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

5405                dc   3, $FF

                ;; frame, frame leg, x-off, y-off
                attract_player_down_stair_data:
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
5418  14            inc  d ; WHAT?! Wrong on the way down too! Head and legs flipped.
5419  13            inc  de
541A  04            inc  b
541B  08            ex   af,af'
541C  0D            dec  c
541D  0C            inc  c
541E  04            inc  b
541F  08            ex   af,af'

5420                dc   8, $FF

                call_attract_bonus_screen:
5428  21D015        ld   hl,$15D0
542B  CD815C        call $5C81
542E  C9            ret

542F                dc   1, $FF

                attract_cage_falls_on_dino:
5430  212492        ld   hl,$9224
                _lp_5433:
5433  CD084D        call $4D08
5436  E5            push hl
5437  CDC254        call $54C2
543A  00            nop
543B  00            nop
543C  00            nop
543D  E1            pop  hl
543E  23            inc  hl
543F  3E39          ld   a,$39 ; check if cage hit ground
5441  BD            cp   l
5442  20EF          jr   nz,$5433
5444  3E38          ld   a,$38 ; caged dino sprite
5446  324181        ld   ($8141),a
5449  3C            inc  a
544A  324581        ld   ($8145),a
544D  C9            ret

544E                dc   2, $FF

                attract_dino_runs_along_ground:
5450  DD214081      ld   ix,$8140 ; this is a dino on attract screen
5454  3E79          ld   a,$79
5456  DDBE00        cp   (ix+$00)
5459  C8            ret  z
545A  DD3400        inc  (ix+$00) ; dino runs along ground
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

5493                dc   1, $FF

                attract_catch_dino:
5494  214081        ld   hl,$8140 ; oi! You made the player a dinosaur!
5497  3607          ld   (hl),$07 ; x
5499  23            inc  hl
549A  362D          ld   (hl),$2D ; frame : 2d is dino?
549C  23            inc  hl
549D  3612          ld   (hl),$12 ; colr
549F  23            inc  hl
54A0  36BF          ld   (hl),$BF ; y
54A2  23            inc  hl
54A3  3600          ld   (hl),$00 ; x legs
54A5  23            inc  hl
54A6  3630          ld   (hl),$30 ; frame legs
54A8  23            inc  hl
54A9  3612          ld   (hl),$12 ; col legs
54AB  23            inc  hl
54AC  36CF          ld   (hl),$CF ; y legs
54AE  212492        ld   hl,$9224
54B1  CD084D        call $4D08
54B4  CD5054        call $5450
54B7  CDD854        call $54D8
54BA  CD3054        call $5430
54BD  CDD854        call $54D8
54C0  C9            ret

54C1                dc   1, $FF

                ;;
                attract_animate_pickups_and_wait:
54C2  3A1283        ld   a,($8312)
54C5  E603          and  $03
54C7  2006          jr   nz,$54CF
54C9  216415        ld   hl,$1564
54CC  CD815C        call $5C81
54CF  212821        ld   hl,$2128
54D2  CD815C        call $5C81
54D5  C9            ret

54D6                dc   2, $FF

                attract_dino_cage_invert:
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

                sfx_8_data:
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

                ;; mabye sfx?
                reset_sfx_something_1:
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

                sfx_10_data:
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

                ;; bytes after the call are
                ;; start_y, start_x, tile 1, ...tile x, 0xFF
                draw_tiles_h_copy:
5570  3A00B8        ld   a,($B800) ; is this ack? "A" not used
5573  214090        ld   hl,$9040
5576  C1            pop  bc ; stack return pointer into bc (ie, data)
5577  0A            ld   a,(bc) ; start_y
5578  03            inc  bc
5579  85            add  a,l
557A  6F            ld   l,a
557B  0A            ld   a,(bc) ; start_x
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
                _lp_558E:
558E  0A            ld   a,(bc) ; each character until 0xff
558F  03            inc  bc
5590  FEFF          cp   $FF
5592  2002          jr   nz,$5596
5594  C5            push bc
                _done_5595:
5595  C9            ret
5596  77            ld   (hl),a ; writes to screen loc
5597  16FF          ld   d,$FF
5599  1EE0          ld   e,$E0
559B  19            add  hl,de
559C  18F0          jr   $558E

559E                dc   2, $FF

                chased_by_a_dino_screen:
55A0  217014        ld   hl,$1470
55A3  CD815C        call $5C81
55A6  CDD056        call $56D0
55A9  00            nop
55AA  00            nop
55AB  00            nop
55AC  CDA85A        call $5AA8
55AF  CD7055        call $5570
55B2  08            ex   af,af'
55B3  0B            dec  bc
55B4  12            ld   (de),a ; BEWARE
55B5  15            dec  d
55B6  27            daa
55B7  112215        ld   de,$1522
55BA  FF            rst  $38
55BB  CDA85A        call $5AA8
55BE  CD7055        call $5570
55C1  0C            inc  c
55C2  05            dec  b
                ;; YOUR BEING CHASED
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
                ;; BY A DINOSAUR (classic!)
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

55EE                dc   2, $FF

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

                draw_buggy_border:
56D0  3E01          ld   a,$01
56D2  CDD85A        call $5AD8
56D5  21880F        ld   hl,$0F88
                ;; THIS IS A BUG! It's supposed to call draw_border
                ;; to put the inner rounded border on the beautiful
                ;; "YOUR BEING CHASED BY A DINO" screen, but the typo
                ;; Jumps to middle of nowhere, that happens to be
                ;; ... 0x40 (ld b,b), 0xC9 (ret). Phew, does nothing...
                ;; It's supposed to be: call $5C81 (JMP_HL)
                ;;
                ;; (err, did they call everything by hand without labels?!)
56D8  CD814C        call $4C81 ; bad jump, no inner border for us :(
56DB  C9            ret

56DC                dc   4, $FF

                ;; ???
56E0  03            inc  bc
56E1  C0            ret  nz
56E2  16A0          ld   d,$A0
56E4  1822          jr   $5708
56E6  16FF          ld   d,$FF

                ;;
                sfx_reset_a_bunch:
56E8  CDC046        call $46C0
56EB  CD7048        call $4870
56EE  CD1049        call $4910
56F1  CD2055        call $5520
56F4  C9            ret

56F5                dc   3, $FF

                ;;
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

                sfx_9_data:
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

                call_draw_extra_bonus_screen:
57C0  C3F05A        jp   $5AF0
                ;;
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

                ;; what's this data eh? Looks similar to $5c00
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

                ;; bytes after the call are:
                ;; start_x, start_y, tile 1, ...tile id, 0xFF
                draw_tiles_v:
58D0  DDE1          pop  ix ; pops next addr (eg, data) from stack
58D2  2600          ld   h,$00
58D4  DD6E00        ld   l,(ix+$00) ; start_x
58D7  29            add  hl,hl
58D8  29            add  hl,hl
58D9  29            add  hl,hl
58DA  29            add  hl,hl
58DB  29            add  hl,hl
58DC  DD23          inc  ix ; start_y
58DE  DD7E00        ld   a,(ix+$00)
58E1  85            add  a,l
58E2  6F            ld   l,a
58E3  014090        ld   bc,$9040
58E6  09            add  hl,bc
58E7  DD23          inc  ix ; read data until 0xff
58E9  DD7E00        ld   a,(ix+$00)
58EC  FEFF          cp   $FF
58EE  2804          jr   z,$58F4
58F0  77            ld   (hl),a
58F1  23            inc  hl
58F2  18F3          jr   $58E7
58F4  DD23          inc  ix
58F6  DDE5          push ix
58F8  C9            ret

58F9                dc   7, $FF

                draw_splash_circle_border_1:
5900  CD7055        call $5570
5903  010151        ld   bc,$5101 ; start pos
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

                ;; left side 1
5920  CDD058        call $58D0
5923  010253        ld   bc,$5302 ; start pos
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

                ;; right side 1
5940  CDD058        call $58D0
5943  1A            ld   a,(de) ; start pos
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

                ;; Bottom row 1
5960  CD7055        call $5570
5963  1C            inc  e ; start pos
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

5981                dc   7, $FF

                draw_splash_circle_border_2:
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
                ;;
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
                ;;
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
                ;;
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
                ;;
5A08  C9            ret
5A09                dc   7, $FF

                draw_splash_circle_border_3:
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
                ;;
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
                ;;
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
                ;;
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
                ;;
5A90  C9            ret

5A91                dc   7, $FF

                ;;
5A98  E5            push hl
5A99  C5            push bc
5A9A  D5            push de
5A9B  212821        ld   hl,$2128
5A9E  CD815C        call $5C81
5AA1  D1            pop  de
5AA2  C1            pop  bc
5AA3  E1            pop  hl
5AA4  C9            ret

5AA5                dc   3, $FF

                ;; Splash screen animated circle border
                flash_border:
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

5AD5                dc   3, $FF

                set_row_colors:
5AD8  47            ld   b,a
5AD9  210181        ld   hl,$8101 ; col for row 1
5ADC  70            ld   (hl),b
5ADD  23            inc  hl
5ADE  23            inc  hl
5ADF  7D            ld   a,l
5AE0  FE41          cp   $41
5AE2  20F8          jr   nz,$5ADC
5AE4  C9            ret

5AE5                dc   1, $FF

                set_screen_color_to_4:
5AE6  3E04          ld   a,$04
5AE8  CDD85A        call $5AD8
5AEB  C9            ret

5AEC                dc   4, $FF

                draw_extra_bonus_screen:
5AF0  217014        ld   hl,$1470
5AF3  CD815C        call $5C81
5AF6  21880F        ld   hl,$0F88
5AF9  CD815C        call $5C81
5AFC  CDE65A        call $5AE6
5AFF  CD7055        call $5570
5B02  08            ex   af,af'
5B03  08            ex   af,af'
                ;; EXTRA BONUS
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
                ;; PICK UP 6 BONUS
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

5B9D                dc   11, $FF

                animate_circle_border:
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
                _border_1_2:
5BBB  FE01          cp   $01
5BBD  2004          jr   nz,$5BC3
5BBF  CD8859        call $5988
5BC2  C9            ret
5BC3  CD0059        call $5900
5BC6  C9            ret

5BC7                dc   1, $FF

                ;;
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

5BFF                dc   1, $FF

                ;; Looks similar format to 5870
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

                jmp_hl:
5C81  E9            jp   (hl)
5C82  40            ld   b,b
5C83  41            ld   b,c
5C84  C9            ret

5C85                dc   1, $FF

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

                sfx_1_data:
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

                sfx_11_data:
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

                sfx_12_data:
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

                sfx_13_data:
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

                sfx_14_data:
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

5FA5                dc   91, $FF ; to 0x5fff

    ;; Bongo by JetSoft
    ;; picked apart by Mr Speaker
    ;; https://www.mrspeaker.net

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

    TICK_MOD_3     $8000  ; timer for every 3 frames
    TICK_MOD_6     $8001  ; timer for every 6 frames
    PL_Y_LEGS_COPY $8002  ; copy of player y legs?
    _              $8003  ; ? used with 8002 s bunch
    PLAYER_NUM     $8004  ; current player
    JUMP_TRIGGERED $8005  ; jump triggered by setting jump_tbl_idx
    SECOND_TIMER   $8006
    P1_TIME        $8007  ; time of player's run: never displayed!
    P2_TIME        $8009  ; ...we could have had speed running!
    CONTROLS       $800B  ; 0010 0000 = jump, 1000 = right, 0100 = left
    BUTTONS_1      $800C  ; P1/P2 buttons... and?
    BUTTONS_2      $800D  ; ... more buttons?
    CONTROLSN      $800E  ; some kind of "normalized" controls
    JUMP_TBL_IDX   $800F  ; index into table for physics jump
    WALK_ANIM_TIMER $8010 ; % 7?
    FALLING_TIMER  $8011  ; set to $10 when falling - if hits 0, dead.
    PLAYER_DIED    $8012  ; 0 = no, 1 = yep, dead
    P1_SCORE       $8014  ; and 8015, 8016 (BCD score)
    P2_SCORE       $8017  ; and 8018, 8019 (BCD score)
    _UNUSED_1      $801B  ; unused? Set once, never read
    SCORE_TO_ADD   $801D  ; amount to add to the current score

    _              $8020  ; ???
    DID_INIT       $8022  ; set after first init, not really used
    BONGO_ANIM_TIMER $8023 ; [0,1,2] updated every 8 ticks
    BONGO_JUMP_TIMER $8024 ; amount of ticks keep jumping for
    BONGO_DIR_FLAG $8025 ; 4 = jump | 2 = left | 1 = right
    BONGO_TIMER    $8027  ; ticks 0-1f for troll

    SCREEN_NUM     $8029  ; Current screen player is on
    SCREEN_NUM_P2  $802A  ; Player 2 screen
    _              $802C  ; ??
    DINO_COUNTER   $802D  ; Ticks up when DINO_TIMER is done
    DINO_DIR       $802E  ; 01 = right, ff = left

    PLAYER_MAX_X   $8030  ; furthest x pos (used for move score)
    PLAYER_UMM     $8031  ; ???
    LIVES          $8032
    LIVES_P2       $8033
    IS_PLAYING     $8034  ; attract mode = 0, 1P = 1, 2P = 2
    CREDITS_UMM    $8035  ; something to do with credits

    ROCK_FALL_TIMER $8036 ; resets falling pos of rock
    ENEMY_1_ACTIVE $8037  ; really "active"? think it has many values not just on/off
    ENEMY_2_ACTIVE $8039  ;
    ENEMY_3_ACTIVE $803B  ;
    _              $8041   ; enemy 3 something..

    CH1_SFX        $8042  ; 2 = dead, e = re/spawn, 6 = cutscene, 7 = cutscene end dance, 9 = ?...
    CH2_SFX        $8043  ; SFX channel 2
    SFX_ID         $8044  ; queued sound effect ID to play

    IS_HIT_CAGE    $8051  ; did player trigger cage?
    SPEED_DELAY_P1 $805b  ; speed for dino/rocks, start=1f, 10, d, then dec 2...
    SPEED_DELAY_P2 $805c  ; ...until dead. Smaller delay = faster dino/rock fall
    DINO_TIMER     $805d  ; timer based on SPEED_DELAY (current round)

    BONUSES        $8060  ; How many bonuses collected
    BONUS_MULT     $8062  ; Bonus multiplier.

    SPLASH_ANIM_FR $8064  ; cycles 0-2 maybe... splash anim counter
    SFX_PREV       $8065  ; prevent retrigger effect?

    _              $8066  ; ?? OE when alive, 02 when dead?
    _              $8067  ; ?? used with 66
    _              $8068  ; ?? used with 67

    EXTRA_GOT_P1   $8070  ; P1 Earned extra life
    EXTRA_GOT_P1   $8071  ; P2 Earned extra life

    SCREEN_XOFF_COL $8100 ; OFFSET and COL for each row of tiles
                          ; Gets memcpy'd to $9800


;;; ======== SPRITES ========
;;; all have the form: X, FRAME, COL, Y.
    PLAYER_X       $8140
    PLAYER_FRAME   $8141
    PLAYER_COL     $8142
    PLAYER_Y       $8143
    PLAYER_X_LEGS  $8144
    PLAYER_FRAME_LEGS $8145
    PLAYER_COL_LEGS   $8146
    PLAYER_Y_LEGS  $8147
    BONGO_X        $8148
    BONGO_FRAME    $8149
    BONGO_COL      $814A
    BONGO_Y        $814B
    DINO_X         $814C
    DINO_FRAME     $814D
    DINO_COL       $814E
    DINO_Y         $814F
    DINO_X_LEGS    $8150
    DINO_FRAME_LEGS $8151
    DINO_COL_LEGS  $8152
    DINO_Y_LEGS    $8153

    ENEMY_1_X      $8154
    ENEMY_1_FRAME  $8155
    ENEMY_1_COL    $8156
    ENEMY_1_Y      $8157
    ENEMY_2_X      $8158
    ENEMY_2_FRAME  $8159
    ENEMY_2_COL    $815A
    ENEMY_2_Y      $815B
    ENEMY_3_X      $815C
    ENEMY_3_FRAME  $815D
    ENEMY_3_COL    $815E
    ENEMY_3_Y      $815F
;;; ============================

    PLATFORM_XOFFS $8180  ; maybe

    HISCORE        $8300  ;
    HISCORE+1      $8301  ;
    HISCORE+2      $8302

    CREDITS        $8303  ; how many credits in machine
    _              $8305  ; Coins? dunno
    HISCORE_NAME   $8307  ; - $8310: Start of HI-SCORE text message area (10 bytes)

    TICK_NUM       $8312  ; adds 1 every tick
    ;; NOTE: TICK_MOD is sped up after round 1!
    TICK_MOD_FAST  $8315  ; % 3 in round 1, % 2 in round 2+
    TICK_MOD_SLOW  $8316  ; % 6 in round 1, % 4 in round 2+. (offset by 1 from $8001)

    STACK_LOCATION  $83F0  ; I think?
    INPUT_BUTTONS   $83F1  ; copied to 800C and 800D
    INPUT_BUTTONS_2 $83F2  ; dunno what buttons

;;;  constants

    SCREEN_WIDTH    $E0  ; 224
    SCR_TILE_W      $1a  ; 26 columns
    SCR_TILE_H      $1c  ; 28 rows

    ROUND1_SPEED    $1f
    ROUND2_SPEED    $10
    ROUND3_SPEED    $0D

    TILE_0          $00
    TILE_9          $09
    TILE_BLANK      $10
    TILE_A          $11
    TILE_E          $15
    TILE_R          $22
    TILE_HYPHEN     $2B

    TILE_SOLID      $F8
    TILE_CROWN_PIKA $8C ; alt crown
    TILE_PIK_CROSSA $8D ;
    TILE_PIK_RINGA  $8E
    TILE_PIK_VASEA  $8F
    TILE_CROWN_PIK  $9C
    TILE_PIK_CROSS  $9D
    TILE_PIK_RING   $9E
    TILE_PIK_VASE   $9F
    TILE_LVL_01     $C0

    TILE_PLATFORM_L $FE
    TILE_PLATFORM_C $FD
    TILE_PLATFORM_R $FC

;;; hardware

    SCREEN_RAM      $9000 ; - 0x93ff  videoram
    START_OF_TILES  $9040 ; top right tile...
    XOFF_COL_RAM    $9800 ; xoffset and color data per tile row
    SPRITES         $9840 ; 0x9800 - 0x98ff is spriteram
    PORT_IN0        $A000 ;
    PORT_IN1        $A800 ;
    PORT_IN2        $B000 ;
    INT_ENABLE      $b001 ; interrupt enable
    WATCHDOG        $b800 ; main timer?

SOFT_RESET
0000: A2          and  d
0001: 32 01 B0    ld   ($INT_ENABLE),a
0004: 32 FF 80    ld   ($80FF),a
0007: 3E FF       ld   a,$FF
0009: 32 00 B8    ld   ($WATCHDOG),a
000C: C3 A0 14    jp   $CLEAR_SCREEN

000F: 31 F0 83    ld   sp,$STACK_LOCATION
0012: CD 00 3F    call $DELAY_N_4E90
0015: CD 48 00    call $INIT_SCREEN
0018: CD 88 22    call $WRITE_TO_0_AND_1
001B: C3 8D 00    jp   $SETUP_BEFORE_PLAYING

001E: DD 19       add  ix,de
0020: DD 19       add  ix,de
0022: 2B          dec  hl
0023: 10 AF       djnz $FFD4
0025: ED 67       rrd  (hl)
0027: DD 77 ED    ld   (ix-$13),a
002A: 6F          ld   l,a
002B: DD          db   $dd
002C: DD 19       add  ix,de
002E: ED 6F       rld  (hl)
0030: DD          db   $dd
0031: FF ...

    ;;  Reset vector
RESET_VECTOR
0038: 3A 00 B8    ld   a,($WATCHDOG)
003B: 18 FB       jr   $RESET_VECTOR
003D: FF ...

    ;; Called once at startup
INIT_SCREEN
0048: 3A 00 A0    ld   a,($PORT_IN0) ;
004B: E6 83       and  $83           ; 1000 0011
004D: C8          ret  z
004E: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
0051: CD 10 03    call $DRAW_TILES_H ; data next 2 lines
0054: 09 00                           ; scr pos x / y
0056: 13 22 15 14 19 24 10 16 11 25 1C 24 FF ; tiles
0063: 18 E3       jr   $INIT_SCREEN
0065: FF          rst  $38

    ;; Non-Maskable Interrupt handler. Fires every frame
NMI_LOOP
0066: AF          xor  a
0067: 32 01 B0    ld   ($INT_ENABLE),a
006A: 3A 00 B8    ld   a,($WATCHDOG)
006D: CD C0 00    call $NMI_INT_HANDLER
0070: 3A 34 80    ld   a,($IS_PLAYING)
0073: A7          and  a
0074: 20 03       jr   nz,$0079
0076: CD 90 01    call $DID_PLAYER_PRESS_START
0079: 06 01       ld   b,$01
007B: CD 00 11    call $TICK_TICKS ; update ticks...
007E: CD 20 24    call $COPY_INP_TO_BUTTONS_AND_CHECK_BUTTONS
0081: 00          nop
0082: 3A 00 A0    ld   a,($PORT_IN0)
0085: CB 4F       bit  1,a
0087: C2 03 C0    jp   nz,$C003
008A: ED 45       retn          ; NMI return

008C: FF

SETUP_BEFORE_PLAYING
008D: CD 48 03    call $SETUP_MORE
0090: CD 80 30    call $SET_HISCORE_TEXT
0093: CD A0 13    call $WAIT_VBLANK
0096: 3A 03 83    ld   a,($CREDITS)
0099: A7          and  a
009A: 20 08       jr   nz,$00A4
009C: CD 70 03    call $RESET_ENTS_ALL
009F: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
00A2: 18 EF       jr   $0093
_PLAY_SPLASH
00A4: CD A0 13    call $WAIT_VBLANK
00A7: 3A 03 83    ld   a,($CREDITS)
00AA: FE 01       cp   $01
00AC: 20 05       jr   nz,$00B3
00AE: CD D0 00    call $ATTRACT_PRESS_P1_SCREEN
00B1: 18 03       jr   $00B6
00B3: CD 40 01    call $DRAW_ONE_OR_TWO_PLAYER
00B6: 3A 34 80    ld   a,($IS_PLAYING)
00B9: A7          and  a
00BA: C2 E7 01    jp   nz,$RESET_A_BUNCH
00BD: 18 E5       jr   $00A4
00BF: FF

NMI_INT_HANDLER
00C0: D9          exx
00C1: CD 88 02    call $COINAGE_ROUTINE
00C4: CD 50 15    call $COPY_XOFFS_COL_SPRITES_TO_SCREEN
00C7: CD 60 29    call $SAVE_IX_AND_?
00CA: CD D0 01    call $COPY_PORTS_TO_BUTTONS
00CD: D9          exx
00CE: C9          ret
00CF: FF

;;;
ATTRACT_PRESS_P1_SCREEN
00D0: 3E 01       ld   a,$01
00D2: 32 90 80    ld   ($8090),a
00D5: AF          xor  a
00D6: 32 04 B0    ld   ($B004),a
00D9: 3A 03 83    ld   a,($CREDITS)
00DC: 47          ld   b,a
00DD: 3A 35 80    ld   a,($CREDITS_UMM)
00E0: B8          cp   b
00E1: C8          ret  z        ; credits == credits_um
00E2: 00          nop
00E3: 00          nop
00E4: 00          nop
00E5: CD 80 14    call $CLEAR_SCREEN
00E8: 21 E0 0F    ld   hl,$0FE0
00EB: CD 40 08    call $DRAW_SCREEN
00EE: 00 00                     ; params to DRAW_SCREEN
00F0: CD 50 24    call $DRAW_SCORE
00F3: CD 10 03    call $DRAW_TILES_H
00F6: 09 0B
00F8: 20 22 15 23 23 FF         ; PRESS
00FE: CD 10 03    call $DRAW_TILES_H
0101: 0C 09
0103: 1F 1E 15 10 20 1C 11 29 15 22 FF ; ONE PLAYER
010E: CD 10 03    call $DRAW_TILES_H
0111: 0F 8B
0113: 12 25 24 24 1F 1E FF      ; BUTTON
011A: CD 10 03    call $DRAW_TILES_H
011D: 19 09
011F: 13 22 15 14 19 24 23 FF   ; CREDITS
0127: 21 03 83    ld   hl,$CREDITS
012A: AF          xor  a
012B: ED 6F       rld  (hl)
012D: 32 99 91    ld   ($9199),a
0130: ED 6F       rld  (hl)
0132: 32 79 91    ld   ($9179),a
0135: ED 6F       rld  (hl)
0137: 3A 03 83    ld   a,($CREDITS)
013A: 32 35 80    ld   ($CREDITS_UMM),a
013D: C9          ret
    
013E: FF FF

    ;;
DRAW_ONE_OR_TWO_PLAYER
0140: CD 30 24    call $2430
0143: 3A 03 83    ld   a,($CREDITS)
0146: 47          ld   b,a
0147: 3A 35 80    ld   a,($CREDITS_UMM)
014A: B8          cp   b
014B: 00          nop
014C: CD D0 00    call $00D0
014F: CD 10 03    call $DRAW_TILES_H
0152: 0C 06
0154: 1F 1E 15 10 1F 22 10 24 27 1F 10 20 1C 11 29 15
0164: 22 FF C9 FF               ; ONE OR TWO PLAYER
0168: FF ...

0170: CD 20 00    call $0020
0173: C9          ret
0174: FF ...

    ;; called a lot (via... CALL_HL_PLUS_4K)
DO_CALL_HL_PLUS_4K
0180: C5          push bc
0181: 01 00 40    ld   bc,$INT_HANDLER
0184: 09          add  hl,bc
0185: C1          pop  bc
0186: E9          jp   (hl)
0187: FF ...

DID_PLAYER_PRESS_START ; Did player start the game?
0190: 3A 03 83    ld   a,($CREDITS) ; check you have credits
0193: A7          and  a
0194: C8          ret  z
0195: 3A F1 83    ld   a,($INPUT_BUTTONS) ; P1 pressed?
0198: CB 47       bit  0,a
019A: 28 11       jr   z,$01AD
019C: CD 60 14    call $DELAY_83
019F: 3E 01       ld   a,$01    ; start the game, 1 player
01A1: 32 34 80    ld   ($IS_PLAYING),a
01A4: 3A 03 83    ld   a,($CREDITS) ; use a credit
01A7: 3D          dec  a
01A8: 27          daa
01A9: 32 03 83    ld   ($CREDITS),a
01AC: C9          ret
01AD: 3A 03 83    ld   a,($CREDITS)
01B0: 3D          dec  a
01B1: C8          ret  z
01B2: 3A F1 83    ld   a,($INPUT_BUTTONS)
01B5: CB 4F       bit  1,a      ; is P2 pressed?
01B7: C8          ret  z
01B8: CD 60 14    call $DELAY_83
01BB: 3E 02       ld   a,$02    ; start the game, 2 player
01BD: 32 34 80    ld   ($IS_PLAYING),a
01C0: 3A 03 83    ld   a,($CREDITS)
01C3: 3D          dec  a
01C4: 27          daa
01C5: 3D          dec  a
01C6: 27          daa
01C7: 32 03 83    ld   ($CREDITS),a
01CA: C9          ret

01CB: FF ...

;;;
COPY_PORTS_TO_BUTTONS
01D0: 3A 00 A0    ld   a,($PORT_IN0)
01D3: 32 0B 80    ld   ($CONTROLS),a
01D6: 3A F1 83    ld   a,($INPUT_BUTTONS)
01D9: 32 0C 80    ld   ($BUTTONS_1),a
01DC: 3A F2 83    ld   a,($INPUT_BUTTONS_2)
01DF: 32 0D 80    ld   ($BUTTONS_2),a
01E2: C9          ret

    ;;
CALL_HL_PLUS_4K
01E3: C3 80 01    jp   $DO_CALL_HL_PLUS_4K
01E6: C9          ret

RESET_A_BUNCH
01E7: 3E 1F       ld   a,$ROUND1_SPEED
01E9: 32 5B 80    ld   ($SPEED_DELAY_P1),a
01EC: 32 5C 80    ld   ($SPEED_DELAY_P2),a
01EF: 00          nop
01F0: 3A F2 83    ld   a,($INPUT_BUTTONS_2) ; from dip-switch settings?
01F3: E6 06       and  $06
01F5: CB 2F       sra  a
01F7: C6 02       add  a,$02
01F9: 32 32 80    ld   ($LIVES),a
01FC: 32 33 80    ld   ($LIVES_P2),a
01FF: 3A 34 80    ld   a,($IS_PLAYING)
0202: 3D          dec  a        ; is playing - 1?
0203: 32 31 80    ld   ($PLAYER_UMM),a
0206: 3E 01       ld   a,$01
0208: 32 04 80    ld   ($PLAYER_NUM),a
020B: 3A 31 80    ld   a,($PLAYER_UMM)
020E: A7          and  a
020F: 20 04       jr   nz,$0215
0211: AF          xor  a
0212: 32 33 80    ld   ($LIVES_P2),a
0215: 3E 01       ld   a,$01
0217: 32 29 80    ld   ($SCREEN_NUM),a
021A: 32 2A 80    ld   ($SCREEN_NUM_P2),a
021D: 32 90 80    ld   ($8090),a
POST_DEATH_RESET
0220: 31 F0 83    ld   sp,$STACK_LOCATION ; hmm. sets stack pointer?
0223: 3A 04 80    ld   a,($PLAYER_NUM) ; flip flops?!
0226: EE 01       xor  $01
0228: 32 04 80    ld   ($PLAYER_NUM),a
022B: 21 32 80    ld   hl,$LIVES
022E: 85          add  a,l
022F: 6F          ld   l,a
0230: 7E          ld   a,(hl)
0231: A7          and  a
0232: 20 12       jr   nz,$0246
0234: 3A 04 80    ld   a,($PLAYER_NUM) ; and back again?
0237: EE 01       xor  $01
0239: 32 04 80    ld   ($PLAYER_NUM),a
023C: 21 32 80    ld   hl,$LIVES
023F: 85          add  a,l
0240: 6F          ld   l,a
0241: 7E          ld   a,(hl)
0242: A7          and  a
0243: CA 10 04    jp   z,$OUT_OF_LIVES  ; out of lives? (maybe)
0246: 3D          dec  a
0247: 77          ld   (hl),a
0248: 3A F1 83    ld   a,($INPUT_BUTTONS)
024B: CB 7F       bit  7,a
024D: 28 11       jr   z,$0260
024F: 3A 04 80    ld   a,($PLAYER_NUM)
0252: FE 01       cp   $01
0254: 20 0A       jr   nz,$0260
0256: 3E 01       ld   a,$01
0258: 32 06 B0    ld   ($B006),a
025B: 32 07 B0    ld   ($B007),a
025E: 18 07       jr   $0267
0260: AF          xor  a
0261: 32 06 B0    ld   ($B006),a
0264: 32 07 B0    ld   ($B007),a
0267: 3A F2 83    ld   a,($INPUT_BUTTONS_2)
026A: CB 5F       bit  3,a
026C: 28 10       jr   z,$027E
026E: 3E 03       ld   a,$03    ; set 3 lives
0270: 32 32 80    ld   ($LIVES),a
0273: 3A 33 80    ld   a,($LIVES_P2)
0276: A7          and  a
0277: 28 05       jr   z,$027E
0279: 3E 03       ld   a,$03
027B: 32 33 80    ld   ($LIVES_P2),a
027E: C3 00 10    jp   $BIG_RESET
    
0281: FF ...

COINAGE_ROUTINE
0288: 3A 06 83    ld   a,($8306)
028B: A7          and  a
028C: 28 11       jr   z,$029F
028E: 3D          dec  a
028F: 32 06 83    ld   ($8306),a
0292: C0          ret  nz
0293: 3A 00 A0    ld   a,($PORT_IN0)
0296: E6 03       and  $03
0298: C8          ret  z
0299: 3E 05       ld   a,$05
029B: 32 06 83    ld   ($8306),a
029E: C9          ret
029F: 3A 00 A0    ld   a,($PORT_IN0)
02A2: E6 03       and  $03
02A4: C8          ret  z
02A5: 47          ld   b,a
02A6: 3E 20       ld   a,$20
02A8: 32 93 80    ld   ($8093),a
02AB: 78          ld   a,b
02AC: FE 01       cp   $01
02AE: 20 09       jr   nz,$02B9
02B0: 3A 05 83    ld   a,($8305)
02B3: 3C          inc  a
02B4: 32 05 83    ld   ($8305),a
02B7: 18 08       jr   $02C1
02B9: 3A 05 83    ld   a,($8305)
02BC: C6 06       add  a,$06
02BE: 32 05 83    ld   ($8305),a
02C1: 3E 07       ld   a,$07
02C3: 32 06 83    ld   ($8306),a
02C6: 3A F1 83    ld   a,($INPUT_BUTTONS)
02C9: CB 77       bit  6,a
02CB: 28 16       jr   z,$02E3
02CD: 3A 05 83    ld   a,($8305)
02D0: A7          and  a
02D1: C8          ret  z
02D2: 47          ld   b,a
02D3: 3A 03 83    ld   a,($CREDITS)
02D6: 3C          inc  a
02D7: 27          daa
02D8: 05          dec  b
02D9: 20 FB       jr   nz,$02D6
02DB: 32 03 83    ld   ($CREDITS),a
02DE: AF          xor  a
02DF: 32 05 83    ld   ($8305),a
02E2: C9          ret
02E3: 3A 05 83    ld   a,($8305)
02E6: A7          and  a
02E7: C8          ret  z
02E8: FE 01       cp   $01
02EA: C8          ret  z
02EB: 47          ld   b,a
02EC: 3A 03 83    ld   a,($CREDITS)
02EF: 3C          inc  a
02F0: 27          daa
02F1: 05          dec  b
02F2: 28 05       jr   z,$02F9
02F4: 05          dec  b
02F5: 28 0D       jr   z,$0304
02F7: 18 F6       jr   $02EF
02F9: 3D          dec  a
02FA: 27          daa
02FB: 32 03 83    ld   ($CREDITS),a
02FE: 3E 01       ld   a,$01
0300: 32 05 83    ld   ($8305),a
0303: C9          ret
0304: 32 03 83    ld   ($CREDITS),a
0307: AF          xor  a
0308: 32 05 83    ld   ($8305),a
030B: C9          ret
    
030C: FF ...

    ;; draw sequence of tiles at x/y (or is it y/x)?
DRAW_TILES_H
0310: 3A 00 B8    ld   a,($WATCHDOG)
0313: 21 40 90    ld   hl,$START_OF_TILES
0316: C1          pop  bc
0317: 0A          ld   a,(bc)   ; x pos (or y pos?!)
0318: 03          inc  bc
0319: 85          add  a,l
031A: 6F          ld   l,a
031B: 0A          ld   a,(bc)   ; y pos
031C: 5F          ld   e,a
031D: 3E 1B       ld   a,$1B
031F: 93          sub  e
0320: 5F          ld   e,a
0321: 16 00       ld   d,$00
0323: CB 23       sla  e
0325: CB 23       sla  e
0327: CB 23       sla  e
0329: 19          add  hl,de
032A: 19          add  hl,de
032B: 19          add  hl,de
032C: 19          add  hl,de
032D: 03          inc  bc
_LP_1
032E: 0A          ld   a,(bc)   ; read data until 0xff
032F: 03          inc  bc
0330: FE FF       cp   $FF
0332: 20 02       jr   nz,$0336
0334: C5          push bc
0335: C9          ret
0336: 77          ld   (hl),a
0337: 16 FF       ld   d,$FF
0339: 1E E0       ld   e,$E0
033B: 19          add  hl,de
033C: 18 F0       jr   $_LP_1

033E: FF ...

    ;;
SETUP_MORE
0348: 00          nop
0349: 00          nop
034A: 00          nop
034B: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
034E: 21 00 80    ld   hl,$8000
0351: 36 00       ld   (hl),$00
0353: 2C          inc  l
0354: 20 FB       jr   nz,$0351
0356: 24          inc  h
0357: 3A 00 B8    ld   a,($WATCHDOG)
035A: 7C          ld   a,h
035B: FE 88       cp   $88
035D: 20 F2       jr   nz,$0351
035F: 31 F0 83    ld   sp,$STACK_LOCATION
0362: 3E 01       ld   a,$01
0364: 32 90 80    ld   ($8090),a
0367: C3 83 05    jp   $0583
    
036A: FF ...

RESET_ENTS_ALL
0370: CD 70 14    call $CALL_RESET_ENTS
0373: 21 20 15    ld   hl,$1520
0376: CD E3 01    call $CALL_HL_PLUS_4K
0379: 21 20 0E    ld   hl,$0E20
037C: CD E3 01    call $CALL_HL_PLUS_4K
037F: 21 C0 17    ld   hl,$RESET_DINO
0382: CD E3 01    call $CALL_HL_PLUS_4K
0385: 21 A0 15    ld   hl,$15A0
0388: CD E3 01    call $CALL_HL_PLUS_4K
038B: 00          nop
038C: 00          nop
038D: 00          nop
038E: C9          ret
    
038F: FF
    
0390: CD A0 13    call $WAIT_VBLANK
0393: 18 FB       jr   $0390
0395: FF ...

DRAW_LIVES
03A0: CD 08 04    call $SET_COLOR_ROW_3
03A3: 3A 32 80    ld   a,($LIVES)
03A6: A7          and  a
03A7: 47          ld   b,a
03A8: 3E 8A       ld   a,$8A
03AA: 28 1B       jr   z,$03C7
03AC: 05          dec  b
03AD: 32 C2 92    ld   ($92C2),a
03B0: 28 15       jr   z,$03C7
03B2: 05          dec  b
03B3: 32 A2 92    ld   ($92A2),a
03B6: 28 0F       jr   z,$03C7
03B8: 05          dec  b
03B9: 32 82 92    ld   ($9282),a
03BC: 28 09       jr   z,$03C7
03BE: 05          dec  b
03BF: 32 62 92    ld   ($9262),a
03C2: 28 03       jr   z,$03C7
03C4: 32 42 92    ld   ($9242),a
03C7: 3A 33 80    ld   a,($LIVES_P2)
03CA: A7          and  a
03CB: 47          ld   b,a
03CC: C8          ret  z
03CD: 3E 8A       ld   a,$8A
03CF: 05          dec  b
03D0: 32 22 91    ld   ($9122),a
03D3: C8          ret  z
03D4: 05          dec  b
03D5: 32 42 91    ld   ($9142),a
03D8: C8          ret  z
03D9: 05          dec  b
03DA: 32 62 91    ld   ($9162),a
03DD: C8          ret  z
03DE: 05          dec  b
03DF: 32 82 91    ld   ($9182),a
03E2: C8          ret  z
03E3: 32 A2 91    ld   ($91A2),a
03E6: C9          ret
    
03E7: FF
    
03E8: AF          xor  a
03E9: 32 34 80    ld   ($IS_PLAYING),a
03EC: 32 35 80    ld   ($CREDITS_UMM),a
03EF: C3 93 00    jp   $0093

03F2: FF ...

03F8: 0E E0       ld   c,$E0
03FA: CD A0 13    call $WAIT_VBLANK
03FD: 0C          inc  c
03FE: 20 FA       jr   nz,$03FA
0400: C9          ret

0401: FF ...

SET_COLOR_ROW_3                 ; dunno what row.
0408: 3E 01       ld   a,$01
040A: 32 05 81    ld   ($SCREEN_XOFF_COL+5),a
040D: C9          ret
    
040E: FF FF

OUT_OF_LIVES
0410: 21 E8 16    ld   hl,$16E8
0413: CD E3 01    call $CALL_HL_PLUS_4K
0416: CD E0 24    call $DELAY_60_VBLANKS
0419: CD 30 04    call $CHECK_IF_HISCORE
041C: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
041F: AF          xor  a
0420: 32 04 B0    ld   ($B004),a
0423: C3 00 2D    jp   $2D00
    
0426: FF ...

CHECK_IF_HISCORE
0430: CD 40 04    call $CHECK_IF_HISCORE_P1
0433: CD 70 04    call $CHECK_IF_HISCORE_P2
0436: C9          ret

0437: FF ...

CHECK_IF_HISCORE_P1
0440: 3A 16 80    ld   a,($P1_SCORE+2)
0443: 4F          ld   c,a
0444: 3A 02 83    ld   a,($HISCORE+2)
0447: 37          scf
0448: 3F          ccf
0449: 99          sbc  a,c
044A: DC E0 04    call c,$HISCORE_FOR_P1
044D: C0          ret  nz
044E: 3A 15 80    ld   a,($P1_SCORE+1)
0451: 4F          ld   c,a
0452: 3A 01 83    ld   a,($HISCORE+1)
0455: 37          scf
0456: 3F          ccf
0457: 99          sbc  a,c
0458: DC E0 04    call c,$HISCORE_FOR_P1
045B: C0          ret  nz
045C: 3A 14 80    ld   a,($P1_SCORE)
045F: 4F          ld   c,a
0460: 3A 00 83    ld   a,($HISCORE)
0463: 37          scf
0464: 3F          ccf
0465: 99          sbc  a,c
0466: DC E0 04    call c,$HISCORE_FOR_P1
0469: C9          ret
    
046A: FF ...

CHECK_IF_HISCORE_P2
0470: 3A 19 80    ld   a,($P2_SCORE+2)
0473: 4F          ld   c,a
0474: 3A 02 83    ld   a,($HISCORE+2)
0477: 37          scf
0478: 3F          ccf
0479: 99          sbc  a,c
047A: DC 00 05    call c,$HISCORE_FOR_P2
047D: C0          ret  nz
047E: 3A 18 80    ld   a,($P2_SCORE+1)
0481: 4F          ld   c,a
0482: 3A 01 83    ld   a,($HISCORE+1)
0485: 37          scf
0486: 3F          ccf
0487: 99          sbc  a,c
0488: DC 00 05    call c,$HISCORE_FOR_P2
048B: C0          ret  nz
048C: 3A 17 80    ld   a,($P2_SCORE)
048F: 4F          ld   c,a
0490: 3A 00 83    ld   a,($HISCORE_0)
0493: 37          scf
0494: 3F          ccf
0495: 99          sbc  a,c
0496: DC 00 05    call c,$HISCORE_FOR_P2
0499: C9          ret

049A: FF ...

04B0: 0E 01       ld   c,$01
04B2: CD A0 13    call $WAIT_VBLANK
04B5: 0D          dec  c
04B6: 20 FA       jr   nz,$04B2
04B8: C9          ret
    
04B9: FF

;; count up timer - every SPEED_DELAY ticks
CHECK_DINO_TIMER
04BA: CD E0 28    call $MOVE_DINO_X
04BD: 3A 04 80    ld   a,($PLAYER_NUM)
04C0: A7          and  a
04C1: 20 05       jr   nz,$04C8
04C3: 3A 5B 80    ld   a,($SPEED_DELAY_P1)
04C6: 18 03       jr   $04CB
04C8: 3A 5C 80    ld   a,($SPEED_DELAY_P2)
04CB: 47          ld   b,a
04CC: 3A 5D 80    ld   a,($DINO_TIMER)
04CF: 3C          inc  a
04D0: B8          cp   b        ; have done SPEED_DELAY ticks?
04D1: 20 01       jr   nz,$04D4
04D3: AF          xor  a
04D4: 32 5D 80    ld   ($DINO_TIMER),a
04D7: A7          and  a
04D8: C0          ret  nz
04D9: CD F0 22    call $DINO_PATHFIND_NOPSLIDE
04DC: C9          ret
    
04DD: FF ...

HISCORE_FOR_P1
04E0: 3A 14 80    ld   a,($P1_SCORE)
04E3: 32 00 83    ld   ($HISCORE),a
04E6: 3A 15 80    ld   a,($P1_SCORE+1)
04E9: 32 01 83    ld   ($HISCORE+1),a
04EC: 3A 16 80    ld   a,($P1_SCORE+2)
04EF: 32 02 83    ld   ($HISCORE+2),a
04F2: E1          pop  hl       ; hmm
04F3: C9          ret
    
04F4: FF ...

HISCORE_FOR_P2
0500: 3A 17 80    ld   a,($P2_SCORE)
0503: 32 00 83    ld   ($HISCORE),a
0506: 3A 18 80    ld   a,($P2_SCORE+1)
0509: 32 01 83    ld   ($HISCORE+1),a
050C: 3A 19 80    ld   a,($P2_SCORE+2)
050F: 32 02 83    ld   ($HISCORE+2),a
0512: E1          pop  hl       ; hmm
0513: C9          ret
    
0514: FF ...

    ;; This looks suspicious. 25 bytes written
    ;; to $8038+, code is never called (or read?)
    ;; wpset 0518,18,rw doesn't trigger
0518: 21 38 80    ld   hl,$8038
051B: 36 39       ld   (hl),$39 ; 57
051D: 23          inc  hl
051E: 36 39       ld   (hl),$39
0520: 23          inc  hl
0521: 36 39       ld   (hl),$39
0523: 23          inc  hl
0524: 36 39       ld   (hl),$39
0526: 23          inc  hl
0527: 36 38       ld   (hl),$38
0529: 23          inc  hl
052A: 36 39       ld   (hl),$39
052C: 23          inc  hl
052D: 36 39       ld   (hl),$39
052F: 23          inc  hl
0530: 36 39       ld   (hl),$39
0532: 23          inc  hl       ;8040
0533: 36 38       ld   (hl),$38
0535: 23          inc  hl
0536: 36 39       ld   (hl),$39
0538: 23          inc  hl
0539: 36 38       ld   (hl),$38
053B: 23          inc  hl
053C: 36 38       ld   (hl),$38
053E: 23          inc  hl
053F: 36 31       ld   (hl),$31
0541: 23          inc  hl
0542: 36 31       ld   (hl),$31
0544: 23          inc  hl
0545: 36 30       ld   (hl),$30
0547: 23          inc  hl
0548: 36 31       ld   (hl),$31
054A: 23          inc  hl
054B: 36 30       ld   (hl),$30
054D: 23          inc  hl
054E: 36 30       ld   (hl),$30
0550: 23          inc  hl
0551: 36 30       ld   (hl),$30
0553: 23          inc  hl
0554: 36 31       ld   (hl),$31
0556: 23          inc  hl
0557: 36 30       ld   (hl),$30
0559: 23          inc  hl
055A: 36 30       ld   (hl),$30
055C: 23          inc  hl
055D: 36 30       ld   (hl),$30
055F: 23          inc  hl
0560: 36 30       ld   (hl),$30
0562: 23          inc  hl
0563: 36 30       ld   (hl),$30
0565: CD 88 08    call $CLEAR_JUMP_BUTTON
0568: C9          ret
    
0569: FF ...

_SETUP_2 ;looks like SETUP - no one calls it?
0580: CD 48 03    call $SETUP_MORE
0583: CD 80 30    call $SET_HISCORE_TEXT
0586: CD A0 13    call $WAIT_VBLANK
0589: 3A 34 80    ld   a,($IS_PLAYING)
058C: A7          and  a
058D: 20 1C       jr   nz,$05AB
058F: 3A 03 83    ld   a,($CREDITS)
0592: A7          and  a
0593: 20 08       jr   nz,$059D
0595: CD 70 03    call $RESET_ENTS_ALL
0598: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
059B: 18 E9       jr   $0586
059D: FE 01       cp   $01
059F: 20 05       jr   nz,$05A6
05A1: CD D0 00    call $00D0
05A4: 18 E0       jr   $0586
05A6: CD 40 01    call $0140
05A9: 18 DB       jr   $0586
05AB: C2 E7 01    jp   nz,$RESET_A_BUNCH
05AE: 18 D6       jr   $0586
05B0: FF ...

05B8: 3A 03 83    ld   a,($CREDITS)
05BB: A7          and  a
05BC: 20 04       jr   nz,$05C2
05BE: CD A0 13    call $WAIT_VBLANK
05C1: C9          ret
05C2: CD A0 13    call $WAIT_VBLANK
05C5: E1          pop  hl
05C6: E1          pop  hl
05C7: E1          pop  hl
05C8: C9          ret
    
05C9: FF ...

    ;; could this ben not P1/P2, but "player" vs "ai" (like
    ;; in splash screen player jump automatically)
    ;; AND/OR, could this disable input during transition?
    ;; (hmm, no... looks like P1/P2... but why?)
NORMALIZE_INPUT
05D0: 3A 04 80    ld   a,($PLAYER_NUM)
05D3: A7          and  a
05D4: 28 17       jr   z,$05ED
    ;; p2
05D6: 3A 0C 80    ld   a,($BUTTONS_1)
05D9: CB 7F       bit  7,a
05DB: 28 10       jr   z,$05ED  ;p1 too?
05DD: 3A 0C 80    ld   a,($BUTTONS_1)
05E0: E6 3C       and  $3C      ; 0011 1100
05E2: 47          ld   b,a
05E3: 3A 0B 80    ld   a,($CONTROLS)
05E6: E6 40       and  $40      ; 0100 0000
05E8: 80          add  a,b
05E9: 32 0E 80    ld   ($CONTROLSN),a
05EC: C9          ret
    ;; p1
05ED: 3A 0B 80    ld   a,($CONTROLS)
05F0: E6 3C       and  $3C      ; 0011 1100
05F2: 47          ld   b,a
05F3: 3A 0B 80    ld   a,($CONTROLS)
05F6: E6 80       and  $80      ; 1000 0000
05F8: CB 3F       srl  a
05FA: 80          add  a,b
05FB: 32 0E 80    ld   ($CONTROLSN),a
05FE: C9          ret
    
05FF: FF ...

PLAYER_FRAME_DATA               ; whats this anim?
0608: 0C 0E 10 0E 0C 12 14 12
0610: FF FF FF FF FF FF FF FF

PLAYER_MOVE_RIGHT
0618: 3A 10 80    ld   a,($WALK_ANIM_TIMER)
061B: 3C          inc  a
061C: E6 07       and  $07      ; 0111
061E: 32 10 80    ld   ($WALK_ANIM_TIMER),a
0621: 21 08 06    ld   hl,$PLAYER_FRAME_DATA
0624: 85          add  a,l
0625: 6F          ld   l,a
0626: 7E          ld   a,(hl)
0627: 32 41 81    ld   ($PLAYER_FRAME),a
062A: 3C          inc  a
062B: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
062E: 3A 40 81    ld   a,($PLAYER_X)
0631: 3C          inc  a
0632: 3C          inc  a
0633: 3C          inc  a
0634: 32 40 81    ld   ($PLAYER_X),a
0637: 32 44 81    ld   ($PLAYER_X_LEGS),a
063A: 00          nop
063B: 00          nop
063C: 00          nop
063D: C9          ret
    
063E: FF ...

PLAYER_FRAME_DATA_2             ;what's this anim?
0648: 8C 8E 90 8E 8C 92 94 92
0650: FF FF FF FF FF FF FF FF

PLAYER_MOVE_LEFT
0658: 3A 10 80    ld   a,($WALK_ANIM_TIMER)
065B: 3C          inc  a
065C: E6 07       and  $07
065E: 32 10 80    ld   ($WALK_ANIM_TIMER),a
0661: 21 48 06    ld   hl,$PLAYER_FRAME_DATA_2
0664: 85          add  a,l
0665: 6F          ld   l,a
0666: 7E          ld   a,(hl)
0667: 32 41 81    ld   ($PLAYER_FRAME),a
066A: 3C          inc  a
066B: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
066E: 3A 40 81    ld   a,($PLAYER_X)
0671: 3D          dec  a
0672: 3D          dec  a
0673: 3D          dec  a
0674: 32 40 81    ld   ($PLAYER_X),a
0677: 32 44 81    ld   ($PLAYER_X_LEGS),a
067A: 00          nop
067B: 00          nop
067C: 00          nop
067D: C9          ret
    
067E: FF ...

PLAYER_INPUT
0688: 3A 12 83    ld   a,($TICK_NUM)
068B: E6 03       and  $03
068D: C0          ret  nz
068E: 3A 12 80    ld   a,($PLAYER_DIED)
0691: A7          and  a
0692: C0          ret  nz       ; dead, get out
0693: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
0696: A7          and  a
0697: C0          ret  nz       ; don't do this input if jumping?
0698: 3A 0E 80    ld   a,($CONTROLSN)
069B: CB 6F       bit  5,a      ; jump pressed? 0010 0000
069D: 28 17       jr   z,$06B6
069F: CD 10 07    call $SET_UNUSED_804A_49
06A2: CB 57       bit  2,a      ; not left? 0000 0100
06A4: 28 04       jr   z,$06AA
06A6: CD A0 07    call $TRIGGER_JUMP_RIGHT
06A9: C9          ret
06AA: CB 5F       bit  3,a      ; not right?
06AC: 28 04       jr   z,$06B2
06AE: CD C0 07    call $TRIGGER_JUMP_LEFT
06B1: C9          ret
06B2: CD C0 08    call $TRIGGER_JUMP_STRAIGHT_UP
06B5: C9          ret
    ;; no jump: left/right?
06B6: CB 57       bit  2,a      ; is left?
06B8: 28 04       jr   z,$06BE
06BA: CD 58 06    call $PLAYER_MOVE_LEFT
06BD: C9          ret
06BE: CB 5F       bit  3,a      ; is right?
06C0: 28 04       jr   z,$06C6
06C2: CD 18 06    call $PLAYER_MOVE_RIGHT
06C5: C9          ret
    ;; looks like bit 4 and 6 aren't used
06C6: CB 67       bit  4,a      ;?
06C8: 28 04       jr   z,$06CE
06CA: 00          nop
06CB: 00          nop
06CC: 00          nop
06CD: C9          ret
    ;; bit 6?
06CE: CB 77       bit  6,a
06D0: C8          ret  z
06D1: 00          nop
06D2: 00          nop
06D3: 00          nop
06D4: C9          ret

06D5: FF ...

    ;; Physics: fall with gravity (maybe?)
PLAYER_PHYSICS
06D8: 00          nop
06D9: 00          nop
06DA: 00          nop
06DB: 00          nop
06DC: 00          nop    
06DD: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
06E0: 3D          dec  a
06E1: 32 0F 80    ld   ($JUMP_TBL_IDX),a
06E4: CB 27       sla  a
06E6: CB 27       sla  a
06E8: 85          add  a,l
06E9: 6F          ld   l,a
06EA: DD 21 40 81 ld   ix,$PLAYER_X
06EE: 7E          ld   a,(hl)     ; reads from the PHYS_JUMP_LOOKUP_XXX tables
06EF: DD 86 00    add  a,(ix+$00) ;player x
06F2: DD 77 00    ld   (ix+$00),a ;player x
06F5: DD 77 04    ld   (ix+$04),a ;player_x_legs
06F8: 23          inc  hl
06F9: 7E          ld   a,(hl)
06FA: DD 77 01    ld   (ix+$01),a ; frame
06FD: 23          inc  hl
06FE: 7E          ld   a,(hl)
06FF: DD 77 05    ld   (ix+$05),a ; legs frame
0702: 23          inc  hl
0703: 7E          ld   a,(hl)
0704: DD 86 07    add  a,(ix+$07) ; player y legs?
0707: DD 77 07    ld   (ix+$07),a
070A: D6 10       sub  $10
070C: DD 77 03    ld   (ix+$03),a ; player y
070F: C9          ret

    ;; jump pressed, sets these... why?
    ;; 804a and 8049 never read?
    ;; wpset 804a,1,r never triggers?
SET_UNUSED_804A_49
0710: F5          push af
0711: 3E A0       ld   a,$A0
0713: 32 4A 80    ld   ($804A),a
0716: 3E 0F       ld   a,$0F
0718: 32 49 80    ld   ($8049),a
071B: F1          pop  af
071C: C9          ret
    
071D: FF          rst  $38
071E: FF          rst  $38
071F: FF          rst  $38
0720: 8C          adc  a,h
0721: 10 FF       djnz $0722
0723: FF          rst  $38
0724: FF          rst  $38
0725: FF          rst  $38
0726: FF          rst  $38
0727: FF          rst  $38

    ;; x-off, head-anim, leg-anim, yoff
PHYS_JUMP_LOOKUP_LEFT
0728: FA 8C 8D 0C
072C: FA 8E 8F 0C
0730: FA 90 91 06
0734: FA 90 96 00
0738: FA 90 91 FA
073C: FA 8E 8F F4
0740: FA 8C 8D F4

0744: FF ...

    ;; x-off, head-anim, leg-anim, yoff
PHYS_JUMP_LOOKUP_RIGHT           ; right?
0750: 06 0C 0D 0C
0754: 06 0E 0F 0C
0758: 06 10 11 06
075C: 06 10 16 00
0760: 06 10 11 FA
0764: 06 0E 0F F4
0768: 06 0C 0D F4

076C: FF ...

DO_JUMP_PHYSICS
0774: 3A 16 83    ld   a,($TICK_MOD_SLOW) ; speeds up after round 1
0777: E6 07       and  $07
0779: C0          ret  nz
077A: 3A 12 80    ld   a,($PLAYER_DIED)
077D: A7          and  a
077E: C0          ret  nz       ; dead, get out
077F: 3A 0F 80    ld   a,($JUMP_TBL_IDX) ; return if not jumping/falling
0782: A7          and  a
0783: C8          ret  z
0784: 3E 01       ld   a,$01             ;
0786: 32 05 80    ld   (JUMP_TRIGGERED),a ; jump was triggererd
0789: 3A 0E 80    ld   a,($CONTROLSN)
078C: CB 57       bit  2,a      ; not left?
078E: 28 07       jr   z,$PHYS_JUMP_RIGHT_OR_UP  ; (no, not right_l, go check left or none)
0790: 21 28 07    ld   hl,$PHYS_JUMP_LOOKUP_LEFT
0793: CD D8 06    call $PLAYER_PHYSICS
0796: C9          ret
0797: C3 E0 07    jp   $07E0

079A: FF ...

;;; jump button, but not jumping, and on ground)
TRIGGER_JUMP_RIGHT
07A0: 3A 05 80    ld   a,(JUMP_TRIGGERED)
07A3: A7          and  a
07A4: C0          ret  nz
07A5: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
07A8: A7          and  a
07A9: C0          ret  nz       ;
07AA: CD 88 09    call $GROUND_CHECK 
07AD: A7          and  a
07AE: C8          ret  z
07AF: 3E 07       ld   a,$07
07B1: 32 0F 80    ld   ($JUMP_TBL_IDX),a
07B4: 3E 8C       ld   a,$8C
07B6: 32 41 81    ld   ($PLAYER_FRAME),a
07B9: 3E 8D       ld   a,$8D
07BB: C3 F4 07    jp   $PLAY_JUMP_SFX
07BE: C9          ret

07BF: FF          rst  $38

;;;  is this one when jump left?
TRIGGER_JUMP_LEFT
07C0: 3A 05 80    ld   a,(JUMP_TRIGGERED)
07C3: A7          and  a
07C4: C0          ret  nz
07C5: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
07C8: A7          and  a
07C9: C0          ret  nz
07CA: CD 88 09    call $GROUND_CHECK
07CD: A7          and  a
07CE: C8          ret  z
07CF: 3E 07       ld   a,$07
07D1: 32 0F 80    ld   ($JUMP_TBL_IDX),a
07D4: 3E 0C       ld   a,$0C
07D6: 32 41 81    ld   ($PLAYER_FRAME),a
07D9: 3E 0D       ld   a,$0D
07DB: C3 F4 07    jp   $PLAY_JUMP_SFX
07DE: C9          ret

07DF: FF

    ;; Right or no direction checkt
PHYS_JUMP_RIGHT_OR_UP
07E0: CB 5F       bit  3,a      ; right?
07E2: 28 07       jr   z,$07EB
07E4: 21 50 07    ld   hl,$PHYS_JUMP_LOOKUP_RIGHT
07E7: CD D8 06    call $PLAYER_PHYSICS
07EA: C9          ret
07EB: 21 48 09    ld   hl,$PHYS_JUMP_LOOKUP_UP ; not left or right?
07EE: CD D8 06    call $PLAYER_PHYSICS
07F1: C9          ret

07F2: FF FF

PLAY_JUMP_SFX
07F4: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
07F7: 3E 04       ld   a,$04    ; jump sfx
07F9: 32 43 80    ld   ($CH2_SFX),a
07FC: C9          ret

07FD: FF ...

    ;;  totes loks like data... who reads it?
0800: 01 00 00    ld   bc,$0000
0803: 00          nop
0804: 00          nop
0805: 00          nop
0806: 00          nop
0807: 01 3A 00    ld   bc,$003A
080A: B8          cp   b
    ;; this looks similar to other tile-related code
    ;; I set a breakpoint here and played a bunch (even cutscene)
    ;; but could not get it to trigger... not used?
080B: 21 40 90    ld   hl,$START_OF_TILES
080E: C1          pop  bc
080F: 0A          ld   a,(bc)   ; param 1
0810: 03          inc  bc
0811: 85          add  a,l
0812: 6F          ld   l,a
0813: 0A          ld   a,(bc)   ; param 2
0814: 5F          ld   e,a
0815: 3E 1B       ld   a,$1B
0817: 93          sub  e
0818: 5F          ld   e,a
0819: 16 00       ld   d,$00
081B: CB 23       sla  e
081D: CB 23       sla  e
081F: CB 23       sla  e
0821: 19          add  hl,de
0822: 19          add  hl,de
0823: 19          add  hl,de
0824: 19          add  hl,de
0825: 03          inc  bc
0826: 0A          ld   a,(bc)   ; param 3
0827: 5F          ld   e,a
0828: 03          inc  bc
0829: 0A          ld   a,(bc)   ; param 4
082A: 57          ld   d,a
082B: 03          inc  bc
082C: C5          push bc
082D: 1A          ld   a,(de)
082E: FE FF       cp   $FF
0830: C8          ret  z
0831: 13          inc  de
0832: 77          ld   (hl),a
0833: 06 FF       ld   b,$FF
0835: 0E E0       ld   c,$E0
0837: 09          add  hl,bc
0838: 18 F3       jr   $082D
083A: FF ...

    ;; screen something... draw level?
DRAW_SCREEN
0840: E5          push hl
0841: D9          exx
0842: E1          pop  hl
0843: 54          ld   d,h
0844: 5D          ld   e,l
0845: 21 40 90    ld   hl,$START_OF_TILES
0848: C1          pop  bc
0849: 0A          ld   a,(bc)   ;param 1
084A: 03          inc  bc
084B: 85          add  a,l
084C: 6F          ld   l,a
084D: 0A          ld   a,(bc)   ; param 2
084E: 03          inc  bc
084F: C5          push bc
0850: D5          push de
0851: 5F          ld   e,a
0852: 3E 1D       ld   a,$1D
0854: 93          sub  e
0855: 5F          ld   e,a
0856: 16 00       ld   d,$00
0858: CB 23       sla  e
085A: CB 23       sla  e
085C: CB 23       sla  e
085E: 19          add  hl,de
085F: 19          add  hl,de
0860: 19          add  hl,de
0861: 19          add  hl,de
0862: D1          pop  de
0863: DD 21 2C 80 ld   ix,$802C
0867: DD 36 00 20 ld   (ix+$00),$20
086B: 1A          ld   a,(de)
086C: 77          ld   (hl),a
086D: 13          inc  de
086E: 01 E0 FF    ld   bc,$FFE0
0871: DD 35 00    dec  (ix+$00)
0874: AF          xor  a
0875: DD BE 00    cp   (ix+$00)
0878: 28 06       jr   z,$0880
087A: 09          add  hl,bc
087B: 3A 00 B8    ld   a,($WATCHDOG)
087E: 18 EB       jr   $086B
0880: D9          exx
0881: C9          ret
0882: FF ...

CLEAR_JUMP_BUTTON
0888: 3A 0E 80    ld   a,($CONTROLSN)
088B: CB 6F       bit  5,a      ; jump
088D: C0          ret  nz
088E: AF          xor  a
088F: 32 05 80    ld   (JUMP_TRIGGERED),a
0892: C9          ret

0893: FF ...

INIT_PLAYER_SPRITE
0898: 21 40 81    ld   hl,$PLAYER_X
089B: 36 10       ld   (hl),$10
089D: 23          inc  hl
089E: 36 0C       ld   (hl),$0C
08A0: 23          inc  hl
08A1: 36 12       ld   (hl),$12
08A3: 23          inc  hl
08A4: 36 CE       ld   (hl),$CE
08A6: 23          inc  hl
08A7: 36 10       ld   (hl),$10
08A9: 23          inc  hl
08AA: 36 0D       ld   (hl),$0D
08AC: 23          inc  hl
08AD: 36 12       ld   (hl),$12
08AF: 23          inc  hl
08B0: 36 DE       ld   (hl),$DE
08B2: CD 20 18    call $INIT_PLAYER_POS_FOR_SCREEN
08B5: C9          ret
    
08B6: FF ...

TRIGGER_JUMP_STRAIGHT_UP
08C0: 3A 05 80    ld   a,(JUMP_TRIGGERED)
08C3: A7          and  a
08C4: C0          ret  nz
08C5: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
08C8: A7          and  a
08C9: C0          ret  nz
08CA: CD 88 09    call $GROUND_CHECK
08CD: A7          and  a
08CE: C8          ret  z
08CF: 3E 07       ld   a,$07
08D1: 32 0F 80    ld   ($JUMP_TBL_IDX),a
08D4: 3E 17       ld   a,$17
08D6: 32 41 81    ld   ($PLAYER_FRAME),a
08D9: C3 30 09    jp   $FACE_BACKWARDS_AND_PLAY_JUMP_SFX
    
08DC: FF ...

08E8: 3A 12 83    ld   a,($TICK_NUM)
08EB: E6 07       and  $07
08ED: 20 15       jr   nz,$0904
08EF: 3A 23 80    ld   a,($BONGO_ANIM_TIMER)
08F2: 3C          inc  a
08F3: E6 03       and  $03
08F5: 00          nop
08F6: 00          nop
08F7: 00          nop
08F8: 32 23 80    ld   ($BONGO_ANIM_TIMER),a
08FB: 21 18 09    ld   hl,$BONGO_LOOKUP3
08FE: 85          add  a,l
08FF: 6F          ld   l,a
0900: 7E          ld   a,(hl)
0901: 32 49 81    ld   ($BONGO_FRAME),a
0904: 3A 12 83    ld   a,($TICK_NUM)
0907: E6 01       and  $01
0909: C0          ret  nz
090A: 3A 48 81    ld   a,($BONGO_X)
090D: 3C          inc  a
090E: 32 48 81    ld   ($BONGO_X),a
0911: C9          ret
    
0912: FF ...

BONGO_LOOKUP3
0918: 29 2A 2B 2A FF FF FF FF
0920: A9 AA AB AA FF FF FF FF
0928: FF FF FF FF FF FF FF FF

FACE_BACKWARDS_AND_PLAY_JUMP_SFX
0930: 3E 18       ld   a,$18
0932: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
0935: 3E 04       ld   a,$04
0937: 32 43 80    ld   ($CH2_SFX),a
093A: C9          ret
    
093B: FF ...

    ;; jumping straight up
    ;; x-off, head-anim, leg-anim, yoff
PHYS_JUMP_LOOKUP_UP
0948: 00 17 18 0C
094C: 00 19 1A 0C
0950: 00 1B 1C 06
0954: 00 9B 9C 00
0958: 00 99 9A FA
095C: 00 97 98 F4
0960: 00 17 18 F4

0964: FF ...

    ;; Get tile from x/y?
GET_TILE_ADDR_FROM_XY
0968: 45          ld   b,l
0969: AF          xor  a
096A: 94          sub  h
096B: E6 F8       and  $F8
096D: 6F          ld   l,a
096E: 26 00       ld   h,$00
0970: 29          add  hl,hl
0971: 29          add  hl,hl
0972: 3E 90       ld   a,$90
0974: 84          add  a,h
0975: 67          ld   h,a
0976: 78          ld   a,b
0977: CB 3F       srl  a
0979: CB 3F       srl  a
097B: CB 3F       srl  a
097D: 85          add  a,l
097E: 6F          ld   l,a
097F: C9          ret
    
0980: FF ...

;;; ground check?
GROUND_CHECK
0988: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
098B: C6 10       add  a,$10    ; +  16   ; the ground
098D: CB 3F       srl  a        ; /  2
098F: CB 3F       srl  a        ; /  2
0991: E6 FE       and  $FE      ; &  1111 1110
0993: 21 00 81    ld   hl,$SCREEN_XOFF_COLL
0996: 85          add  a,l
0997: 6F          ld   l,a
0998: 3A 44 81    ld   a,($PLAYER_X_LEGS)
099B: 96          sub  (hl)
099C: C6 08       add  a,$08
099E: 67          ld   h,a
099F: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
09A2: C6 10       add  a,$10
09A4: 6F          ld   l,a
09A5: CD 68 09    call $GET_TILE_ADDR_FROM_XY

09A8: 7E          ld   a,(hl)
09A9: E6 F8       and  $TILE_SOLID
09AB: FE F8       cp   $TILE_SOLID
09AD: 28 02       jr   z,$09B1
09AF: AF          xor  a
09B0: C9          ret
09B1: 3E 01       ld   a,$01
09B3: C9          ret
    
09B4: FF ...

CHECK_IF_LANDED_ON_GROUND
09C0: 3A 12 80    ld   a,($PLAYER_DIED)
09C3: A7          and  a
09C4: C0          ret  nz       ; dead, get out
09C5: 3A 0F 80    ld   a,($JUMP_TBL_IDX)
09C8: A7          and  a
09C9: 28 1B       jr   z,$_JUMP_TBL_IDX_0
09CB: E6 0C       and  $0C      ; 0000 1100 (only last 3 are falling)
09CD: C0          ret  nz       ; not falling, leave
09CE: CD 88 09    call $GROUND_CHECK
09D1: A7          and  a
09D2: C8          ret  z        ; ret if in air?
09D3: AF          xor  a        ; clear jump_tbl_idx
09D4: 32 0F 80    ld   ($JUMP_TBL_IDX),a
09D7: 3A 41 81    ld   a,($PLAYER_FRAME)
09DA: E6 80       and  $80
09DC: C6 0C       add  a,$0C
09DE: 32 41 81    ld   ($PLAYER_FRAME),a
09E1: 3C          inc  a
09E2: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
09E5: C9          ret
_JUMP_TBLE_IDX_0
09E6: CD 88 09    call $GROUND_CHECK
09E9: A7          and  a
09EA: 20 0B       jr   nz,$_ON_GROUND
09EC: 3A 11 80    ld   a,($FALLING_TIMER)
09EF: A7          and  a
09F0: C0          ret  nz
09F1: 3E 10       ld   a,$10
09F3: 32 11 80    ld   ($FALLING_TIMER),a
09F6: C9          ret
_ON_GROUND
09F7: AF          xor  a        ; reset
09F8: 32 11 80    ld   ($FALLING_TIMER),a
09FB: CD 68 0A    call $SNAP_Y_TO_8
09FE: C9          ret
    
09FF: FF ...

0A08: 3A 12 83    ld   a,($TICK_NUM)
0A0B: E6 07       and  $07
0A0D: 20 15       jr   nz,$0A24
0A0F: 3A 23 80    ld   a,($BONGO_ANIM_TIMER)
0A12: 3C          inc  a
0A13: E6 03       and  $03
0A15: 00          nop
0A16: 00          nop
0A17: 00          nop
0A18: 32 23 80    ld   ($BONGO_ANIM_TIMER),a
0A1B: 21 20 09    ld   hl,$0920
0A1E: 85          add  a,l
0A1F: 6F          ld   l,a
0A20: 7E          ld   a,(hl)
0A21: 32 49 81    ld   ($BONGO_FRAME),a
0A24: 3A 12 83    ld   a,($TICK_NUM)
0A27: E6 01       and  $01
0A29: C0          ret  nz
0A2A: 3A 48 81    ld   a,($BONGO_X)
0A2D: 3D          dec  a
0A2E: 32 48 81    ld   ($BONGO_X),a
0A31: C9          ret
0A32: FF          rst  $38

KILL_PLAYER
0A33: 00          nop  ; weee, nopslide
0A34: 00          nop
0A35: 00          nop
0A36: 00          nop
0A37: 00          nop
0A38: 3E 01       ld   a,$01
0A3A: 32 12 80    ld   ($PLAYER_DIED),a
0A3D: C9          ret

0A3E: FF FF

    ;; There's a bug in level one/two: if you jump of the
    ;; edge of level one, and hold jump... it bashes invisible
    ;; head barrier at the start of level two and dies here.
    ;; (because of falling timer). Not sure why.
JUMP_UPWARD_CHECK_BIG_FALL
0A40: 3A 11 80    ld   a,($FALLING_TIMER) ; did we fall too far?
0A43: A7          and  a
0A44: C8          ret  z
0A45: 3D          dec  a
0A46: 32 11 80    ld   ($FALLING_TIMER),a
0A49: A7          and  a
0A4A: 20 04       jr   nz,$0A50
0A4C: CD 33 0A    call $KILL_PLAYER ; yep.
0A4F: C9          ret
0A50: 3A 43 81    ld   a,($PLAYER_Y) ; Nope... move downwards 2.
0A53: 3C          inc  a             ; Why? Looks suspicious - related to bug?
0A54: 3C          inc  a             ; force to ground I think
0A55: 32 43 81    ld   ($PLAYER_Y),a
0A58: C6 10       add  a,$10
0A5A: 32 47 81    ld   ($PLAYER_Y_LEGS),a
0A5D: C9          ret
    
0A5E: FF ...

SNAP_Y_TO_8
0A68: 3A 43 81    ld   a,($PLAYER_Y)
0A6B: E6 F8       and  $F8      ; 1111 1000
0A6D: 32 43 81    ld   ($PLAYER_Y),a
0A70: C6 10       add  a,$10
0A72: 32 47 81    ld   ($PLAYER_Y_LEGS),a
0A75: C9          ret
    
0A76: FF ...

CHECK_HEAD_HIT_TILE
0A80: 3A 12 80    ld   a,($PLAYER_DIED)
0A83: A7          and  a
0A84: C0          ret  nz       ; player dead, get outta here
0A85: 3A 43 81    ld   a,($PLAYER_Y)
0A88: C6 01       add  a,$01
0A8A: CB 3F       srl  a
0A8C: CB 3F       srl  a
0A8E: E6 FE       and  $FE
0A90: 21 00 81    ld   hl,$SCREEN_XOFF_COL
0A93: 85          add  a,l
0A94: 6F          ld   l,a
0A95: 3A 40 81    ld   a,($PLAYER_X)
0A98: 96          sub  (hl)
0A99: C6 08       add  a,$08
0A9B: 67          ld   h,a
0A9C: 3A 43 81    ld   a,($PLAYER_Y)
0A9F: C6 01       add  a,$01
0AA1: 6F          ld   l,a
0AA2: CD 68 09    call $GET_TILE_ADDR_FROM_XY
0AA5: 7E          ld   a,(hl)
0AA6: E6 C0       and  $C0      ; 1100 0000
0AA8: FE C0       cp   $C0      ; whats a C0 tile?
0AAA: C0          ret  nz
0AAB: CD B8 0A    call $FALL_UNDER_A_LEDGE
0AAE: C9          ret
    
0AAF: FF ...

FALL_UNDER_A_LEDGE
0AB8: 3A 11 80    ld   a,($FALLING_TIMER)
0ABB: A7          and  a
0ABC: C0          ret  nz       ; falling? Get outta here
0ABD: AF          xor  a
0ABE: 32 0F 80    ld   ($JUMP_TBL_IDX),a ; clear jump idx
0AC1: 3E 08       ld   a,$08
0AC3: 32 11 80    ld   ($FALLING_TIMER),a ; set low fall
0AC6: CD A0 13    call $WAIT_VBLANK
0AC9: CD A0 13    call $WAIT_VBLANK
0ACC: C9          ret
    
0ACD: FF FF FF

SET_LEVEL_PLATFORM_XOFFS
0AD0: 3A 04 80    ld   a,($PLAYER_NUM)
0AD3: A7          and  a
0AD4: 20 05       jr   nz,$0ADB ;p2?
0AD6: 3A 29 80    ld   a,($SCREEN_NUM)
0AD9: 18 03       jr   $0ADE
0ADB: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
0ADE: 3D          dec  a        ; scr - 1
0ADF: 21 00 0B    ld   hl,$SOME_DATA_1
0AE2: CB 27       sla  a        ; scr - 1 * 2
0AE4: 85          add  a,l
0AE5: 6F          ld   l,a
0AE6: 4E          ld   c,(hl)
0AE7: 23          inc  hl
0AE8: 46          ld   b,(hl)
0AE9: 21 80 81    ld   hl,$PLATFORM_XOFFS
0AEC: 16 23       ld   d,$23
0AEE: 0A          ld   a,(bc)
0AEF: 77          ld   (hl),a
0AF0: 03          inc  bc
0AF1: 23          inc  hl
0AF2: 15          dec  d
0AF3: 20 F9       jr   nz,$0AEE
0AF5: CD 98 18    call $RESET_XOFF_AND_COLS
0AF8: C9          ret
    
0AF9: FF ...

;;; platform data? nah. 2 bytes per screen
SOME_DATA_1
0B00: 38 0C 38 0C 38 0C 38 0C
0B0A: 38 0C 38 0C 38 0C 38 0C
0B12: 38 0C 38 0C 38 0C 38 0C
0B1A: 38 0C 38 0C 10 0C 38 0C
0B22: 38 0C 10 0C 38 0C 38 0C
0B2A: 38 0C 38 0C 38 0C 38 0C
0B32: 38 0C 10 0C

0B36: 00 ...
0B7C: FF ...

MOVE_MOVING_PLATFORM
0B80: DD 7E 01    ld   a,(ix+$01) ;$PLATFORM_XOFFS+1
0B83: DD 77 03    ld   (ix+$03),a
0B86: DD CB 02 46 bit  0,(ix+$02)
0B8A: 20 0A       jr   nz,$0B96
0B8C: FD 34 00    inc  (iy+$00) ; move right
0B8F: FD 34 02    inc  (iy+$02)
0B92: FD 34 04    inc  (iy+$04)
0B95: C9          ret
0B96: FD 35 00    dec  (iy+$00) ; move left
0B99: FD 35 02    dec  (iy+$02)
0B9C: FD 35 04    dec  (iy+$04)
0B9F: C9          ret

RESET_DINO_COUNTER
0BA0: AF          xor  a
0BA1: 32 2D 80    ld   ($DINO_COUNTER),a
0BA4: C9          ret
0BA5: FF ...

MOVING_PLATFORMS
0BB0: DD 21 80 81 ld   ix,$PLATFORM_XOFFS
0BB4: FD 21 38 81 ld   iy,$SCREEN_XOFF_COL+38
0BB8: 16 09       ld   d,$09    ; loop 9 times
0BBA: DD 7E 01    ld   a,(ix+$01) ; xoff + 1
0BBD: A7          and  a
0BBE: 28 26       jr   z,$0BE6
0BC0: DD 7E 02    ld   a,(ix+$02) ; xoff + 2
0BC3: E6 FE       and  $FE
0BC5: 20 0F       jr   nz,$0BD6
0BC7: DD 7E 00    ld   a,(ix+$00) ; xoff
0BCA: E6 FE       and  $FE
0BCC: DD 86 02    add  a,(ix+$02) ; xoff + 2
0BCF: EE 01       xor  $01
0BD1: DD 77 02    ld   (ix+$02),a ; xoff + 2
0BD4: 18 06       jr   $0BDC
0BD6: DD 35 02    dec  (ix+$02)
0BD9: DD 35 02    dec  (ix+$02)
0BDC: DD 7E 03    ld   a,(ix+$03) ; xoff + 3
0BDF: A7          and  a
0BE0: CC 80 0B    call z,$MOVE_MOVING_PLATFORM
0BE3: DD 35 03    dec  (ix+$03)
0BE6: FD 2B       dec  iy
0BE8: FD 2B       dec  iy
0BEA: FD 2B       dec  iy
0BEC: FD 2B       dec  iy
0BEE: FD 2B       dec  iy
0BF0: FD 2B       dec  iy
0BF2: DD 23       inc  ix
0BF4: DD 23       inc  ix
0BF6: DD 23       inc  ix
0BF8: DD 23       inc  ix
0BFA: 15          dec  d
0BFB: 20 BD       jr   nz,$0BBA
0BFD: C9          ret
    
0BFE: FF ...

0C10: 00          nop
0C11: 00          nop
0C12: 00          nop
0C13: 00          nop
0C14: 00          nop
0C15: 00          nop
0C16: 00          nop
0C17: 00          nop
0C18: 00          nop
0C19: 00          nop
0C1A: 00          nop
0C1B: 00          nop
0C1C: F0          ret  p
0C1D: 03          inc  bc
0C1E: 80          add  a,b
0C1F: 03          inc  bc
0C20: 00          nop
0C21: 00          nop
0C22: 00          nop
0C23: 00          nop
0C24: 00          nop
0C25: 00          nop
0C26: 00          nop
0C27: 00          nop
0C28: 00          nop
0C29: 00          nop
0C2A: 00          nop
0C2B: 00          nop
0C2C: 00          nop
0C2D: 00          nop
0C2E: 00          nop
0C2F: 00          nop
0C30: 00          nop
0C31: 00          nop
0C32: 00          nop
0C33: 00          nop
0C34: FF          rst  $38
0C35: FF          rst  $38
0C36: FF          rst  $38
0C37: FF          rst  $38
0C38: 00          nop
0C39: 00          nop
0C3A: 00          nop
0C3B: 00          nop
0C3C: 00          nop
0C3D: 00          nop
0C3E: 00          nop
0C3F: 00          nop
0C40: 00          nop
0C41: 00          nop
0C42: 00          nop
0C43: 00          nop
0C44: 00          nop
0C45: 00          nop
0C46: 00          nop
0C47: 00          nop
0C48: 00          nop
0C49: 00          nop
0C4A: 00          nop
0C4B: 00          nop
0C4C: 00          nop
0C4D: 00          nop
0C4E: 00          nop
0C4F: 00          nop
0C50: 00          nop
0C51: 00          nop
0C52: 00          nop
0C53: 00          nop
0C54: 00          nop
0C55: 00          nop
0C56: 00          nop
0C57: 00          nop
0C58: 00          nop
0C59: 00          nop
0C5A: 00          nop
0C5B: 00          nop
0C5C: FF          rst  $38
0C5D: FF          rst  $38
0C5E: FF          rst  $38
0C5F: FF          rst  $38

MOVE_PLAYER_TOWARDS_GROUND_IF_DEAD
0C60: 3A 12 80    ld   a,($PLAYER_DIED)
0C63: A7          and  a
0C64: C8          ret  z        ; player still alive... leave.
_LOOP
0C65: CD A0 13    call $WAIT_VBLANK
0C68: 3A 43 81    ld   a,($PLAYER_Y) ; push player towards ground
0C6B: 3C          inc  a
0C6C: 3C          inc  a
0C6D: 3C          inc  a
0C6E: 32 43 81    ld   ($PLAYER_Y),a
0C71: C6 10       add  a,$10
0C73: 32 47 81    ld   ($PLAYER_Y_LEGS),a
0C76: 37          scf
0C77: 3F          ccf
0C78: C6 10       add  a,$10
0C7A: 38 12       jr   c,$0C8E  ; deaded.
0C7C: 3A 40 81    ld   a,($PLAYER_X)
0C7F: 67          ld   h,a
0C80: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
0C83: C6 20       add  a,$20
0C85: 6F          ld   l,a
0C86: CD 68 09    call $GET_TILE_ADDR_FROM_XY
0C89: 7E          ld   a,(hl)
0C8A: FE 10       cp   $TILE_BLANK ; are we still in the air?
0C8C: 28 D7       jr   z,$_LOOP    ; keep falling
0C8E: CD C0 0C    call $DO_DEATH_SEQUENCE
0C91: AF          xor  a
0C92: 32 12 80    ld   ($PLAYER_DIED),a ; clear died
0C95: CD 20 02    call $POST_DEATH_RESET
0C98: C9          ret
    
0C99: FF ...

0CA0: 1E 08       ld   e,$08
0CA2: CD A0 13    call $WAIT_VBLANK
0CA5: 1D          dec  e
0CA6: 20 FA       jr   nz,$0CA2
0CA8: C9          ret
0CA9: FF ...

0CB0: 1E 03       ld   e,$03
0CB2: CD 30 0D    call $0D30
0CB5: CD 60 0D    call $0D60
0CB8: CD A0 13    call $WAIT_VBLANK
0CBB: 1D          dec  e
0CBC: 20 F4       jr   nz,$0CB2
0CBE: C9          ret
0CBF: FF

DO_DEATH_SEQUENCE
0CC0: 3E 02       ld   a,$02
0CC2: 32 42 80    ld   ($CH1_SFX),a
0CC5: 32 65 80    ld   ($SFX_PREV),a
0CC8: CD A0 0B    call $RESET_DINO_COUNTER
0CCB: CD 14 0D    call $0D14
0CCE: CD A0 0C    call $0CA0
0CD1: 3E 26       ld   a,$26
0CD3: 32 41 81    ld   ($PLAYER_FRAME),a
0CD6: 3E 27       ld   a,$27
0CD8: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
0CDB: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
0CDE: 32 43 81    ld   ($PLAYER_Y),a
0CE1: 3A 40 81    ld   a,($PLAYER_X)
0CE4: D6 10       sub  $10
0CE6: 32 40 81    ld   ($PLAYER_X),a
0CE9: CD A0 0C    call $0CA0
0CEC: 3A 40 81    ld   a,($PLAYER_X)
0CEF: C6 08       add  a,$08
0CF1: 32 5C 81    ld   ($ENEMY_3_X),a
0CF4: 3E 28       ld   a,$28
0CF6: 32 5D 81    ld   ($ENEMY_3_FRAME),a
0CF9: 3E 11       ld   a,$11
0CFB: 32 5E 81    ld   ($ENEMY_3_COL),a
0CFE: 3A 43 81    ld   a,($PLAYER_Y)
0D01: D6 10       sub  $10
0D03: 32 5F 81    ld   ($ENEMY_3_Y),a
0D06: 16 28       ld   d,$28
0D08: CD B0 0C    call $0CB0
0D0B: 3A 5F 81    ld   a,($ENEMY_3_Y)
0D0E: 3D          dec  a
0D0F: 3D          dec  a
0D10: 32 5F 81    ld   ($ENEMY_3_Y),a
0D13: 15          dec  d
0D14: 20 F2       jr   nz,$0D08
0D16: C9          ret

    ;; called?
MOVE_PLAYER_TOWARDS_GROUND_FOR_A_WHILE
0D17: 16 08       ld   d,$08
0D19: 3A 43 81    ld   a,($PLAYER_Y)
0D1C: 3C          inc  a
0D1D: 3C          inc  a
0D1E: 3C          inc  a
0D1F: 32 43 81    ld   ($PLAYER_Y),a
0D22: C6 10       add  a,$10
0D24: 32 47 81    ld   ($PLAYER_Y_LEGS),a
0D27: CD A0 13    call $WAIT_VBLANK
0D2A: 15          dec  d
0D2B: 20 EC       jr   nz,$0D19
0D2D: C9          ret

0D2E: FF ...

0D30: 3A 24 80    ld   a,($BONGO_JUMP_TIMER)
0D33: A7          and  a
0D34: C0          ret  nz
0D35: 3E 10       ld   a,$10
0D37: 32 24 80    ld   ($BONGO_JUMP_TIMER),a
0D3A: C9          ret

0D3B: FF ...

    ;; Oooh, mystery function - commented out.
    ;; Think it was going to place Bongo on the
    ;; bottom right for levels where player is
    ;; up top. Only looks correct for those levels.
MOVE_BONGO_REDACTED
0D40: C9          ret           ; just rets.
0D41: 3A 48 81    ld   a,($BONGO_X)
0D44: 67          ld   h,a
0D45: 32 4B 81    ld   ($BONGO_Y),a
0D48: C6 10       add  a,$10
0D4A: 6F          ld   l,a
0D4B: CD 68 09    call $GET_TILE_ADDR_FROM_XY
0D4E: 7E          ld   a,(hl)
0D4F: 37          scf
0D50: 3F          ccf
0D51: D6 C0       sub  $C0
0D53: D8          ret  c
0D54: AF          xor  a
0D55: 32 24 80    ld   ($BONGO_JUMP_TIMER),a
0D58: C9          ret

0D59: FF ...

MOVE_BONGO
0D60: CD 40 0D    call $MOVE_BONGO_REDACTED
0D63: 3A 24 80    ld   a,($BONGO_JUMP_TIMER)
0D66: A7          and  a
0D67: C8          ret  z
0D68: 3D          dec  a
0D69: 32 24 80    ld   ($BONGO_JUMP_TIMER),a
0D6C: E6 08       and  $08
0D6E: 28 09       jr   z,$0D79
0D70: 3A 4B 81    ld   a,($BONGO_Y)
0D73: 3D          dec  a
0D74: 3D          dec  a
0D75: 32 4B 81    ld   ($BONGO_Y),a
0D78: C9          ret
0D79: 3A 4B 81    ld   a,($BONGO_Y)
0D7C: 3C          inc  a
0D7D: 3C          inc  a
0D7E: 32 4B 81    ld   ($BONGO_Y),a
0D81: C9          ret

0D82: FF ...

0D88: 3A 12 83    ld   a,($TICK_NUM)
0D8B: E6 07       and  $07
0D8D: C0          ret  nz
0D8E: 3A 23 80    ld   a,($BONGO_ANIM_TIMER)
0D91: 3C          inc  a
0D92: E6 03       and  $03
0D94: 00          nop
0D95: 00          nop
0D96: 00          nop
0D97: 32 23 80    ld   ($BONGO_ANIM_TIMER),a
0D9A: 21 B0 0D    ld   hl,$0DB0
0D9D: 85          add  a,l
0D9E: 6F          ld   l,a
0D9F: 7E          ld   a,(hl)
0DA0: 32 49 81    ld   ($BONGO_X),a
0DA3: C9          ret

0DA4: FF ...

0DB0: 05 06 07 08 FF FF FF FF

DRAW_BONGO
0DB8: AF          xor  a
0DB9: 32 24 80    ld   ($BONGO_JUMP_TIMER),a
0DBC: 32 25 80    ld   ($BONGO_DIR_FLAG),a
0DBF: 32 27 80    ld   ($BONGO_TIMER),a
0DC2: 3A 04 80    ld   a,($PLAYER_NUM)
0DC5: A7          and  a
0DC6: 20 05       jr   nz,$0DCD
0DC8: 3A 29 80    ld   a,($SCREEN_NUM)
0DCB: 18 03       jr   $0DD0
0DCD: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
0DD0: 3D          dec  a
0DD1: CB 27       sla  a
0DD3: 21 00 0E    ld   hl,$BONGO_LOOKUP2
0DD6: 85          add  a,l
0DD7: 6F          ld   l,a
0DD8: 7E          ld   a,(hl)
0DD9: 32 48 81    ld   ($BONGO_X),a
0DDC: 23          inc  hl
0DDD: 7E          ld   a,(hl)
0DDE: 32 4B 81    ld   ($BONGO_Y),a
0DE1: 3E 12       ld   a,$12
0DE3: 32 4A 81    ld   ($BONGO_COL),a
0DE6: 3E 05       ld   a,$05
0DE8: 32 49 81    ld   ($BONGO_FRAME),a
0DEB: C9          ret

0DEC: FF ...

BONGO_LOOKUP2
0E00: E0 38 E0 38 E0 38 E0 38
0E08: E0 38 E0 38 E0 38 E0 38
0E10: E0 38 E0 38 E0 38 E0 38
0E18: E0 38 E0 38 E0 38 D0 38
0E20: E0 38 E0 38 D0 38 E0 38
0E28: E0 38 E0 38 E0 38 E0 38
0E30: E0 38 E0 38 D0 38 00 00
0E38: 00 00 00 00 00 00 FF FF

    ;;
BONGO_ANIMATE_SOMETHING
0E40: 3A 25 80    ld   a,($BONGO_DIR_FLAG)
0E43: E6 03       and  $03      ;left or right
0E45: 20 05       jr   nz,$0E4C
0E47: CD 88 0D    call $0D88    ; not moving?
0E4A: 18 0C       jr   $0E58
0E4C: FE 01       cp   $01
0E4E: 20 05       jr   nz,$0E55
0E50: CD E8 08    call $08E8
0E53: 18 03       jr   $0E58
0E55: CD 08 0A    call $0A08
0E58: 3A 25 80    ld   a,($BONGO_DIR_FLAG)
0E5B: CB 57       bit  2,a      ; left
0E5D: C8          ret  z
0E5E: CD 30 0D    call $0D30
0E61: C9          ret

0E62: FF ...

BONGO_ANIMATE
0E70: 3A 12 83    ld   a,($TICK_NUM)
0E73: E6 07       and  $07
0E75: C0          ret  nz
0E76: 3A 04 80    ld   a,($PLAYER_NUM)
0E79: A7          and  a
0E7A: 20 05       jr   nz,$0E81
0E7C: 3A 29 80    ld   a,($SCREEN_NUM)
0E7F: 18 03       jr   $0E84
0E81: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
0E84: 47          ld   b,a
0E85: CD 30 0F    call $BONGO_RUN_WHEN_PLAYER_CLOSE
0E88: 78          ld   a,b
0E89: 3D          dec  a
0E8A: CB 27       sla  a
0E8C: 21 C0 0E    ld   hl,$BONGO_LOOKUP
0E8F: 85          add  a,l
0E90: 6F          ld   l,a
0E91: 4E          ld   c,(hl)
0E92: 23          inc  hl
0E93: 46          ld   b,(hl)
0E94: C5          push bc
0E95: E1          pop  hl
0E96: 3A 27 80    ld   a,($BONGO_TIMER)
0E99: 3C          inc  a
0E9A: FE 20       cp   $20      ; timer hit top, reset
0E9C: 20 01       jr   nz,$0E9F
0E9E: AF          xor  a
0E9F: 32 27 80    ld   ($BONGO_TIMER),a
0EA2: 85          add  a,l
0EA3: 6F          ld   l,a
0EA4: 7E          ld   a,(hl)   ; animation lookup
0EA5: 32 25 80    ld   ($BONGO_DIR_FLAG),a
0EA8: C9          ret

0EA9: FF ...

    ;; what's this data for?
BONGO_LOOKUP
0EC0: 08 0F 08 0F 68 0F 08 0F
0EC8: 08 0F 68 0F 08 0F 08 0F
0ED0: 68 0F 08 0F 68 0F 08 0F
0ED8: 08 0F 68 0F 08 0F 08 0F
0EE0: 08 0F 08 0F 08 0F 08 0F
0EE8: 68 0F 68 0F 08 0F 68 0F
0EF0: 68 0F 08 0F 08 0F 00 00
0EF8: 00 00 00 00 00 00 00 00

0F00: FF ...

    ;; this looks like bongo anim data
    ;; 4 = jump | 2 = left | 1 = right
BONGO_ANIM_DATA
0F08: 01 01 01 01 06 05 02 02
0F10: 02 02 04 00 00 00 00 00
0F18: 00 04 02 02 02 02 05 06
0F20: 01 01 01 01 00 00 00 00

0F28: FF ...

    ;;
BONGO_RUN_WHEN_PLAYER_CLOSE
0F30: 3A 48 81    ld   a,($BONGO_X)
0F33: 37          scf
0F34: 3F          ccf
0F35: C6 08       add  a,$08
0F37: 30 0B       jr   nc,$0F44
0F39: AF          xor  a
0F3A: 32 25 80    ld   ($BONGO_DIR_FLAG),a ; stop moving
0F3D: 3E FF       ld   a,$FF
0F3F: 32 48 81    ld   ($BONGO_X),a
0F42: E1          pop  hl
0F43: C9          ret
0F44: 3A 43 81    ld   a,($PLAYER_Y)
0F47: 37          scf
0F48: 3F          ccf
0F49: D6 60       sub  $60
0F4B: 38 01       jr   c,$0F4E
0F4D: C9          ret
0F4E: 3A 40 81    ld   a,($PLAYER_X)
0F51: 37          scf
0F52: 3F          ccf
0F53: C6 70       add  a,$70
0F55: D0          ret  nc
0F56: 3E 01       ld   a,$01    ; right
0F58: 32 25 80    ld   ($BONGO_DIR_FLAG),a
0F5B: E1          pop  hl
0F5C: C9          ret
0F5D: FF ...

0F68: 00          nop
0F69: 00          nop
0F6A: 00          nop
0F6B: 00          nop
0F6C: 04          inc  b
0F6D: 00          nop
0F6E: 00          nop
0F6F: 00          nop
0F70: 04          inc  b
0F71: 00          nop
0F72: 00          nop
0F73: 00          nop
0F74: 04          inc  b
0F75: 00          nop
0F76: 00          nop
0F77: 00          nop
0F78: 00          nop
0F79: 00          nop
0F7A: 00          nop
0F7B: 00          nop
0F7C: 04          inc  b
0F7D: 00          nop
0F7E: 00          nop
0F7F: 00          nop
0F80: 04          inc  b
0F81: 00          nop
0F82: 00          nop
0F83: 00          nop
0F84: 04          inc  b
0F85: 00          nop
0F86: 00          nop
0F87: 00          nop

    ;;  intro inside border top
0F88: CD 10 03    call $DRAW_TILES_H
0F8B: 02 02
0F8D: E0 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7 E7
0F8D: E7 E7 E7 E7 E7 E7 E7 DF FF
    ;; intro inside border right
0FA6: CD D8 3B    call $DRAW_TILES_V_COPY
0FA9: 02 03
0FAB: E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6 E6
0FBB: E6 E6 E6 E6 E6 E6 E6 E6 FF
0FC4: C3 D6 1B    jp   $1BD6
0FC7: FF ...

0FD1: 0F          rrca
0FD2: FF ...
0FDD: 0F          rrca
0FDE: FF          rst  $38
0FDF: FF          rst  $38
0FE0: 10 10       djnz $0FF2
0FE2: 10 10       djnz $0FF4
0FE4: 20 1C       jr   nz,$1002
0FE6: 01 10 10    ld   bc,$1010
0FE9: 10 10       djnz $0FFB
0FEB: 18 19       jr   $1006
0FED: 17          rla
0FEE: 18 2B       jr   $101B
0FF0: 23          inc  hl
0FF1: 13          inc  de
0FF2: 1F          rra
0FF3: 22 15 10    ld   ($1015),hl
0FF6: 10 10       djnz $1008
0FF8: 10 20       djnz $101A
0FFA: 1C          inc  e
0FFB: 02          ld   (bc),a
0FFC: 10 10       djnz $100E
0FFE: 10 FF       djnz $0FFF

;;; =========================================
    ;; Reset then run main loop.
    ;; Happens after death and new round
BIG_RESET
1000: 3E 50       ld   a,$50
1002: 32 1B 80    ld   ($_UNUSED_1),a ; never read?
1005: AF          xor  a
1006: 32 0E 80    ld   ($CONTROLSN),a
1009: 32 0F 80    ld   ($JUMP_TBL_IDX),a
100C: 32 12 80    ld   ($PLAYER_DIED),a
100F: 32 11 80    ld   ($FALLING_TIMER),a
1012: 32 51 80    ld   ($IS_HIT_CAGE),a
1015: 32 60 80    ld   ($BONUSES),a
1018: 32 62 80    ld   ($BONUS_MULT),a
101B: 3E 20       ld   a,$20
101D: 32 30 80    ld   ($PLAYER_MAX_X),a
1020: CD 80 1B    call $INIT_SCORE_AND_SCREEN_ONCE
1023: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
1026: 21 E0 0F    ld   hl,$0FE0
1029: CD 40 08    call $DRAW_SCREEN
102C: 00          nop
102D: 00          nop
102E: CD D0 16    call $DRAW_BONUS
1031: CD 38 30    call $COPY_HISCORE_NAME_TO_SCREEN_2
1034: CD 50 24    call $DRAW_SCORE
1037: CD A0 03    call $DRAW_LIVES
103A: CD 98 08    call $INIT_PLAYER_SPRITE
103D: CD B8 12    call $DRAW_BACKGROUND
1040: CD D0 0A    call $0AD0
1043: CD B8 0D    call $DRAW_BONGO
1046: 3E 02       ld   a,$02    ; bottom row is red
1048: 32 3F 81    ld   ($SCREEN_XOFF_COL+3F),a
;;; falls through to main loop:

;;; =========================================
MAIN_LOOP
104B: CD E0 10    call $SET_TICK_MOD_3_AND_ADD_SCORE
104E: CD 30 11    call $UPDATE_SCREEN_TILE_ANIMATIONS
1051: CD 70 11    call $UPDATE_EVERYTHING ; Main logic
1054: CD A0 13    call $WAIT_VBLANK
1057: 3A 00 B8    ld   a,($WATCHDOG)    ; why load? ack?
105A: 3A 00 40    ld   a,($INT_HANDLER) ; why load?
105D: 18 EC       jr   $MAIN_LOOP

105F: FF          rst  $38
1060: F0          ret  p
1061: FF ...
;;; =========================================

;;;  Extra life
EXTRA_LIFE
1070: 3A 04 80    ld   a,($PLAYER_NUM)
1073: A7          and  a
1074: 20 04       jr   nz,$107A
1076: CD 80 10    call $1080    ; p1
1079: C9          ret
107A: CD A8 10    call $10A8    ; p2
107D: C9          ret
107E: FF FF
    ;; P1 extra life
1080: 3A 70 80    ld   a,($EXTRA_GOT_P1)
1083: A7          and  a
1084: C0          ret  nz
1085: 3A 15 80    ld   a,($P1_SCORE+1)
1088: 37          scf
1089: 3F          ccf
108A: D6 15       sub  $15      ; bonus at ??
108C: D8          ret  c
108D: 3E 01       ld   a,$01
108F: 32 70 80    ld   ($EXTRA_GOT_P1),a
1092: 3A 32 80    ld   a,($LIVES) ; Bonus life
1095: 3C          inc  a
1096: 32 32 80    ld   ($LIVES),a
1099: CD A0 03    call $DRAW_LIVES
109C: 3E 08       ld   a,$08
109E: 32 44 80    ld   ($SFX_ID),a
10A1: C9          ret
10A2: FF ...
    ;; P2 extra life
10A8: 3A 71 80    ld   a,($EXTRA_GOT_P2)
10AB: A7          and  a
10AC: C0          ret  nz
10AD: 3A 18 80    ld   a,($P2_SCORE+1)
10B0: 37          scf
10B1: 3F          ccf
10B2: D6 15       sub  $15
10B4: D8          ret  c
10B5: 3E 01       ld   a,$01
10B7: 32 71 80    ld   ($EXTRA_GOT_P2),a
10BA: 3A 33 80    ld   a,($LIVES_P2) ; bonus life p2
10BD: 3C          inc  a
10BE: 32 33 80    ld   ($LIVES_P2),a
10C1: CD A0 03    call $DRAW_LIVES
10C4: 3E 08       ld   a,$08
10C6: 32 44 80    ld   ($SFX_ID),a
10C9: C9          ret

10CA: FF ...

SET_TICK_MOD_3_AND_ADD_SCORE
10E0: 3A 00 80    ld   a,($TICK_MOD_3)
10E3: 3C          inc  a
10E4: FE 03       cp   $03
10E6: 20 01       jr   nz,$10E9
10E8: AF          xor  a        ; reset a
10E9: 32 00 80    ld   ($TICK_MOD_3),a
10EC: CB 27       sla  a        ; (tick % 3) * 4
10EE: CB 27       sla  a
10F0: CD 90 13    call $SHADOW_ADD_A_TO_RET
10F3: CD 00 17    call $ADD_SCORE
10F6: C9          ret

;;; um, nothing calls 10f7 - must come from interrupt
;;; (via $SHADOW_ADD_A_TO_RET somehow I reckon)
EXTRA_LIFE_HANDLER
10F7: CD 70 10    call $EXTRA_LIFE
10FA: C9          ret

;;;  or 10fb! - done in an interrupt?
DINO_COLLISION_HANDLER
10FB: CD 18 25    call $TEST_THEN_DINO_COLLISION
10FE: C9          ret

10FF: FF

    ;; Ticks the main ticks and speed timers
TICK_TICKS                      ;
1100: 3A 12 83    ld   a,($TICK_NUM)
1103: 3C          inc  a
1104: 32 12 83    ld   ($TICK_NUM),a ; only place tick_num is set
1107: CD 80 16    call $UPDATE_SPEED_TIMERS
110A: C9          ret

110B: FF ...

    ;; ?? is it about dino?
MYSTERY_8066_FN
1110: F5          push af
1111: E5          push hl
1112: 21 66 80    ld   hl,$8066
1115: AF          xor  a        ; cp: If A == N, then Z flag is set
1116: BE          cp   (hl)     ; state == 0?
1117: 20 08       jr   nz,$1121 ; no, off to AND
1119: 23          inc  hl       ; yep, what about $8067
111A: BE          cp   (hl)     ; == 0?
111B: 20 04       jr   nz,$1121
111D: 23          inc  hl       ; yep, what about $8068
111E: BE          cp   (hl)     ; == 0?
111F: 28 05       jr   z,$1126  ; no, all zero - don't load
1121: 7E          ld   a,(hl)   ; ...first non-zero
1122: 36 00       ld   (hl),$00
1124: C6 18       add  a,$18    ; 0001 1000
1126: E6 7F       and  $7F      ; 0111 1111
1128: 00          nop
1129: 00          nop
112A: E1          pop  hl
112B: F1          pop  af
112C: C9          ret

112D: FF ...

    ;;
UPDATE_SCREEN_TILE_ANIMATIONS
1130: 3A 01 80    ld   a,($TICK_MOD_6) ; set tick % 6
1133: 3C          inc  a
1134: FE 06       cp   $06
1136: 20 01       jr   nz,$1139
1138: AF          xor  a
1139: 32 01 80    ld   ($TICK_MOD_6),a
113C: CB 27       sla  a
113E: CB 27       sla  a
1140: CD 90 13    call $SHADOW_ADD_A_TO_RET
1143: CD 02 3C    call $SCREEN_TILE_ANIMATIONS
1146: C9          ret
1147: 00          nop
1148: 00          nop
1149: 00          nop
114A: C9          ret
114B: 00          nop
114C: 00          nop
114D: 00          nop
114E: C9          ret
114F: 00          nop
1150: 00          nop
1151: 00          nop
1152: C9          ret
1153: 00          nop
1154: 00          nop
1155: 00          nop
1156: C9          ret
1157: 00          nop
1158: 00          nop
1159: 00          nop
115A: C9          ret
115B: 00          nop
115C: 00          nop
115D: 00          nop
115E: C9          ret

115F: FF ...

UPDATE_EVERYTHING
1170: CD 04 1A    call $CHECK_EXIT_STAGE_LEFT
1173: CD D0 13    call $UPDATE_TIME_TIMER
1176: CD D0 05    call $NORMALIZE_INPUT
1179: CD 88 06    call $PLAYER_INPUT
117C: CD 74 07    call $DO_JUMP_PHYSICS
117F: CD 40 0A    call $JUMP_UPWARD_CHECK_BIG_FALL
1182: CD 60 0C    call $MOVE_PLAYER_TOWARDS_GROUND_IF_DEAD
1185: CD C0 09    call $CHECK_IF_LANDED_ON_GROUND
1188: CD 80 0A    call $CHECK_HEAD_HIT_TILE
118B: CD B0 0B    call $MOVING_PLATFORMS
118E: CD 00 12    call $PLAYER_POS_UPDATE
1191: CD 90 12    call $PREVENT_CLOUD_JUMP_REDACTED
1194: CD 50 17    call $CHECK_DONE_SCREEN
1197: CD 88 08    call $CLEAR_JUMP_BUTTON
119A: CD 60 0D    call $MOVE_BONGO
119D: CD 40 0D    call $MOVE_BONGO_REDACTED
11A0: CD 40 0E    call $BONGO_ANIMATE_SOMETHING
11A3: CD 70 0E    call $BONGO_ANIMATE
11A6: CD F0 19    call $CHECK_FALL_OFF_BOTTOM_SCR
11A9: CD BA 04    call $CHECK_DINO_TIMER
11AC: CD 50 2B    call $SHADOW_HL_PLUSEQ_4_TIMES_SCR ; why?
11AF: CD A8 3B    call $PLAYER_ENEMIES_COLLISION
11B2: 21 20 00    ld   hl,$0020
11B5: CD E3 01    call $CALL_HL_PLUS_4K
11B8: C9          ret
    
11B9: FF ...

11C0: 3A 58 81    ld   a,($ENEMY_2_X)
11C3: FE 70       cp   $70
11C5: 28 14       jr   z,$11DB
11C7: FE 71       cp   $71
11C9: 28 10       jr   z,$11DB
11CB: FE 72       cp   $72
11CD: 28 0C       jr   z,$11DB
11CF: FE 73       cp   $73
11D1: 28 08       jr   z,$11DB
11D3: FE 74       cp   $74
11D5: 28 04       jr   z,$11DB
11D7: FE 00       cp   $00
11D9: 20 03       jr   nz,$11DE
11DB: CD 60 39    call $SET_ENEMY_2_F0_98
    ;;
11DE: 3A 5C 81    ld   a,($ENEMY_3_X)
11E1: FE 60       cp   $60
11E3: 28 14       jr   z,$11F9
11E5: FE 61       cp   $61
11E7: 28 10       jr   z,$11F9
11E9: FE 62       cp   $62
11EB: 28 0C       jr   z,$11F9
11ED: FE 63       cp   $63
11EF: 28 08       jr   z,$11F9
11F1: FE 64       cp   $64
11F3: 28 04       jr   z,$11F9
11F5: FE 00       cp   $00
11F7: 20 03       jr   nz,$11FC
11F9: CD 88 39    call $SET_ENEMY_3_F0_68
11FC: C9          ret
11FD: FF ...

;;;
PLAYER_POS_UPDATE
1200: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
1203: 47          ld   b,a
1204: 3A 02 80    ld   a,($PL_Y_LEGS_COPY)
1207: B8          cp   b
1208: 20 1E       jr   nz,$1228 ; legs copy different from legs?
120A: C6 08       add  a,$08
120C: CB 3F       srl  a
120E: CB 3F       srl  a
1210: E6 3E       and  $3E
1212: 26 81       ld   h,$81
1214: 6F          ld   l,a
1215: 3A 03 80    ld   a,($8003)
1218: 4F          ld   c,a
1219: 7E          ld   a,(hl)
121A: B9          cp   c
121B: C8          ret  z
121C: 91          sub  c
121D: 4F          ld   c,a
121E: 3A 40 81    ld   a,($PLAYER_X)
1221: 81          add  a,c
1222: 32 40 81    ld   ($PLAYER_X),a
1225: 32 44 81    ld   ($PLAYER_X_LEGS),a
1228: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
122B: C6 08       add  a,$08
122D: CB 3F       srl  a
122F: CB 3F       srl  a
1231: E6 3E       and  $3E
1233: 26 81       ld   h,$81
1235: 6F          ld   l,a
1236: 7E          ld   a,(hl)
1237: 32 03 80    ld   ($8003),a
123A: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
123D: 32 02 80    ld   ($PL_Y_LEGS_COPY),a
1240: C9          ret
    
1241: FF ...

;;; only called from PREVENT_CLOUD_JUMP_REDACTED
PREVENT_CLOUD_JUMP_REDACTED_2
1250: E5          push hl
1251: 3A 40 81    ld   a,($PLAYER_X)
1254: 96          sub  (hl)
1255: 67          ld   h,a
1256: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
1259: D6 12       sub  $12
125B: 5A          ld   e,d
125C: CB 23       sla  e
125E: CB 23       sla  e
1260: CB 23       sla  e
1262: 83          add  a,e
1263: 6F          ld   l,a
1264: CD 68 09    call $GET_TILE_ADDR_FROM_XY
1267: 00          nop
1268: 00          nop
1269: 00          nop
126A: 00          nop
126B: 7E          ld   a,(hl)
126C: E6 C0       and  $C0
126E: FE C0       cp   $C0
1270: 28 0B       jr   z,$127D
1272: 01 C0 FF    ld   bc,$FFC0
1275: 09          add  hl,bc
1276: 7E          ld   a,(hl)
1277: E6 C0       and  $C0
1279: FE C0       cp   $C0
127B: 20 03       jr   nz,$1280
127D: CD B8 0A    call $FALL_UNDER_A_LEDGE
1280: E1          pop  hl
1281: C9          ret
1282: FF ...

    ;; ANOTHER commented out one!
    ;; This stops a player jumping up through a platform
    ;; from underneath it. Probably more realistic, but
    ;; good decision on the devs part to remove it it: it sucks!
PREVENT_CLOUD_JUMP_REDACTED
1290: C9          ret
1291: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
1294: C6 04       add  a,$04
1296: CB 3F       srl  a
1298: CB 3F       srl  a
129A: E6 3E       and  $3E
129C: 6F          ld   l,a
129D: 26 81       ld   h,$81
129F: 16 04       ld   d,$04
12A1: CD 50 12    call $PREVENT_CLOUD_JUMP_REDACTED_2
12A4: 2B          dec  hl
12A5: 2B          dec  hl
12A6: 15          dec  d
12A7: 20 F8       jr   nz,$12A1
12A9: C9          ret
12AA: FF ...

DRAW_BACKGROUND
12B8: CD 10 03    call $DRAW_TILES_H
12BB: 03 00
12BD: 40 42 43 42 41 40 FF      ; downward spikes
12C4: CD 10 03    call $DRAW_TILES_H
12C7: 09 00
12C9: FE FD FD FD FD FC FF      ; platform
12D0: CD 10 03    call $DRAW_TILES_H
12D3: 1E 00
12D5: FE FD FD FD FD FC FF      ; platform
12DC: CD B0 14    call $14B0
12DF: 21 E0 92    ld   hl,$92E0
12E2: DD 2A 20 80 ld   ix,($8020)
12E6: 16 17       ld   d,$17
12E8: CD 28 13    call $1328
12EB: 00          nop
12EC: 00          nop
12ED: 00          nop
12EE: 15          dec  d
12EF: 20 F7       jr   nz,$12E8
12F1: 22 1E 80    ld   ($801E),hl
12F4: CD 10 35    call $3510
12F7: 21 50 0C    ld   hl,$0C50
12FA: CD E3 01    call $CALL_HL_PLUS_4K
12FD: C3 10 3F    jp   $3F10
    ;;
1300: 1E 04       ld   e,$04
1302: E5          push hl
1303: 21 06 81    ld   hl,$SCREEN_XOFF_COL+6
1306: 35          dec  (hl)
1307: 35          dec  (hl)
1308: 23          inc  hl
1309: 23          inc  hl
130A: E5          push hl
130B: CD 00 12    call $PLAYER_POS_UPDATE
130E: E1          pop  hl
130F: 7D          ld   a,l
1310: FE 3E       cp   $3E
1312: 20 F2       jr   nz,$1306
1314: CD A0 13    call $WAIT_VBLANK
1317: 1D          dec  e
1318: 20 E9       jr   nz,$1303
131A: E1          pop  hl
131B: C9          ret
131C: FF ...

    ;;
1328: CD 68 17    call $1768
132B: DD 7E 00    ld   a,(ix+$00)
132E: E5          push hl
132F: 85          add  a,l
1330: 6F          ld   l,a
1331: DD 23       inc  ix
1333: DD 7E 00    ld   a,(ix+$00)
1336: FE FF       cp   $FF
1338: 28 09       jr   z,$1343
133A: A7          and  a
133B: 28 14       jr   z,$1351
133D: 77          ld   (hl),a
133E: 23          inc  hl
133F: DD 23       inc  ix
1341: 18 F0       jr   $1333
1343: DD 23       inc  ix
1345: E1          pop  hl
1346: 01 E0 FF    ld   bc,$FFE0
1349: 09          add  hl,bc
134A: 7C          ld   a,h
134B: FE 8F       cp   $8F
134D: C0          ret  nz
134E: 26 93       ld   h,$93
1350: C9          ret
1351: DD 23       inc  ix
1353: E1          pop  hl
1354: 18 D5       jr   $132B
1356: FF          rst  $38
1357: FF          rst  $38

    ;;
DURING_TRANSITION_NEXT
1358: CD B8 13    call $BONGO_RUNS_OFF_SCREEN
135B: 00          nop
135C: CD B0 14    call $HMMM_IN_SCR_TRANSITION
135F: DD 2A 20 80 ld   ix,($8020)
1363: 2A 1E 80    ld   hl,($801E)
1366: 16 15       ld   d,$15
1368: CD 28 13    call $1328
136B: CD 00 13    call $1300
136E: 15          dec  d
136F: 20 F7       jr   nz,$1368
1371: DD 22 20 80 ld   ($8020),ix
1375: 22 1E 80    ld   ($801E),hl
1378: CD C0 19    call $CLEAR_SCR_TO_BLANKS
137B: CD B8 12    call $DRAW_BACKGROUND
137E: AF          xor  a
137F: 32 02 80    ld   ($PL_Y_LEGS_COPY),a
1382: 32 03 80    ld   ($8003),a
1385: CD 20 18    call $INIT_PLAYER_POS_FOR_SCREEN
1388: CD B8 0D    call $DRAW_BONGO
138B: CD 08 04    call $SET_COLOR_ROW_3
138E: C9          ret

138F: FF

;;; What's this? Interrupt something?
;;; goes shadow regs, pops ret addr from stack, adds A, re-pushes it
;;; Does shenanigans: hl2 calls functions that aren't otherwise called
SHADOW_ADD_A_TO_RET
1390: D9          exx
1391: E1          pop  hl       ; stack RET pointer
1392: 06 00       ld   b,$00
1394: 4F          ld   c,a
1395: 09          add  hl,bc
1396: E5          push hl
1397: D9          exx
1398: C9          ret           ; so returns to RET+A?

1399: FF ...


;;; Looks important. VBLANK?!
WAIT_VBLANK
13A0: 06 00       ld   b,$00
13A2: 3E 01       ld   a,$01
13A4: 32 01 B0    ld   ($INT_ENABLE),a ; enable interrupts
13A7: 3A 00 B8    ld   a,($WATCHDOG)
13AA: 78          ld   a,b
13AB: FE 01       cp   $01
13AD: 20 F3       jr   nz,$13A2
13AF: AF          xor  a
13B0: 32 01 B0    ld   ($INT_ENABLE),a ; disable interrupts
13B3: 3A 00 B8    ld   a,($WATCHDOG)
13B6: C9          ret

13B7: FF

BONGO_RUNS_OFF_SCREEN
13B8: 21 48 81    ld   hl,$BONGO_X
13BB: 36 00       ld   (hl),$00
13BD: 23          inc  hl
13BE: 7D          ld   a,l
13BF: FE 60       cp   $60
13C1: 20 F8       jr   nz,$13BB
13C3: C9          ret

13C4: FF ...


UPDATE_TIME_TIMER
13D0: 3A 06 80    ld   a,($SECOND_TIMER)
13D3: 3C          inc  a
13D4: 32 06 80    ld   ($SECOND_TIMER),a
13D7: FE 3C       cp   $3C
13D9: C0          ret  nz
13DA: AF          xor  a
13DB: 32 06 80    ld   ($SECOND_TIMER),a
13DE: CD F0 13    call $UPDATE_TIME
13E1: CD 10 14    call $DRAW_TIME
13E4: C9          ret

13E5: FF ...


UPDATE_TIME
13F0: 3A 04 80    ld   a,($PLAYER_NUM)
13F3: CB 47       bit  0,a
13F5: 21 07 80    ld   hl,$P1_TIME
13F8: 28 02       jr   z,$13FC
13FA: 23          inc  hl
13FB: 23          inc  hl
13FC: 7E          ld   a,(hl)
13FD: 3C          inc  a
13FE: 27          daa           ; the A register is BCD corrected from flags
13FF: 77          ld   (hl),a
1400: FE 60       cp   $60      ; minutes
1402: C0          ret  nz
1403: 36 00       ld   (hl),$00
1405: 23          inc  hl
1406: 7E          ld   a,(hl)
1407: 3C          inc  a
1408: 27          daa
1409: 77          ld   (hl),a   ; store it
140A: C9          ret

140B: FF ...

    ;; draws the player's time under score
    ;; ret's immediately: must have been removed! aww :(
DRAW_TIME
1410: C9          ret
1411: 3A 04 80    ld   a,($PLAYER_NUM)
1414: CB 47       bit  0,a
1416: 20 1E       jr   nz,$1436
    ;; p1 version
1418: AF          xor  a
1419: 21 07 80    ld   hl,$8007
141C: ED 67       rrd  (hl)
141E: 32 02 93    ld   ($9302),a
1421: ED 67       rrd  (hl)
1423: 32 22 93    ld   ($9322),a
1426: ED 67       rrd  (hl)
1428: 23          inc  hl
1429: ED 67       rrd  (hl)
142B: 32 62 93    ld   ($9362),a
142E: ED 67       rrd  (hl)
1430: 32 82 93    ld   ($9382),a
1433: ED 67       rrd  (hl)
1435: C9          ret
    ;;  p2 version
1436: AF          xor  a
1437: 21 09 80    ld   hl,$8009
143A: ED 67       rrd  (hl)
143C: 32 82 90    ld   ($9082),a
143F: ED 67       rrd  (hl)
1441: 32 A2 90    ld   ($90A2),a
1444: ED 67       rrd  (hl)
1446: 23          inc  hl
1447: ED 67       rrd  (hl)
1449: 32 E2 90    ld   ($90E2),a
144C: ED 67       rrd  (hl)
144E: 32 02 91    ld   ($9102),a
1451: ED 67       rrd  (hl)
1453: C9          ret

1454: FF ...

DELAY_83                        ; maybe a delay?
1460: 21 00 80    ld   hl,$TICK_MOD_3
1463: 36 00       ld   (hl),$00
1465: 2C          inc  l
1466: 20 FB       jr   nz,$1463
1468: 24          inc  h
1469: 7C          ld   a,h
146A: FE 83       cp   $83      ; 1000 0011
146C: 20 F5       jr   nz,$1463
146E: C9          ret
146F: FF

    ;; lotsa calls here
CALL_RESET_SCREEN_META_AND_SPRITES
1470: CD 90 14    call $RESET_SCREEN_META_AND_SPRITES

1473: 00          nop
1474: 00          nop
1475: 00          nop
1476: 00          nop
1477: 00          nop
1478: 23          inc  hl
1479: 00          nop
147A: 00          nop
147B: 00          nop
147C: 00          nop
147D: 00          nop
147E: 00          nop
147F: 00          nop

CLEAR_SCREEN
1480: 21 00 90    ld   hl,$SCREEN_RAM
1483: 36 10       ld   (hl),$TILE_BLANK
1485: 2C          inc  l
1486: 20 FB       jr   nz,$1483
1488: 24          inc  h
1489: 7C          ld   a,h
148A: FE 98       cp   $98
148C: 20 F5       jr   nz,$1483
148E: C9          ret

148F: FF

    ;; Lotsa calls here (via $1470)
RESET_SCREEN_META_AND_SPRITES     ; sets 128 locations to 0
1490: 21 00 81    ld   hl,$SCREEN_XOFF_COL
1493: 36 00       ld   (hl),$00
1495: 23          inc  hl
1496: 7D          ld   a,l
1497: FE 80       cp   $80      ; 128
1499: 20 F8       jr   nz,$1493
149B: C9          ret

149C: FF ...

14A0: 21 00 80    ld   hl,$TICK_MOD_3
14A3: 36 00       ld   (hl),$00
14A5: 23          inc  hl
14A6: 7C          ld   a,h
14A7: FE 84       cp   $84
14A9: 20 F8       jr   nz,$14A3
14AB: C3 0F 00    jp   $000F
14AE: FF FF

HMMM_IN_SCR_TRANSITION
14B0: 21 E8 06    ld   hl,$06E8
14B3: CD E3 01    call $CALL_HL_PLUS_4K
14B6: CD C8 3B    call $RESET_XOFFS
14B9: 3E 20       ld   a,$20
14BB: 32 30 80    ld   ($PLAYER_MAX_X),a
14BE: 3A 04 80    ld   a,($PLAYER_NUM)
14C1: A7          and  a
14C2: 20 05       jr   nz,$14C9
14C4: 3A 29 80    ld   a,($SCREEN_NUM)
14C7: 18 03       jr   $14CC
14C9: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
14CC: 21 00 15    ld   hl,$1500
14CF: 06 00       ld   b,$00
14D1: 3D          dec  a
14D2: 4F          ld   c,a
14D3: CB 21       sla  c
14D5: 09          add  hl,bc
14D6: 4E          ld   c,(hl)
14D7: 23          inc  hl
14D8: 46          ld   b,(hl)
14D9: ED 43 20 80 ld   ($8020),bc
14DD: C9          ret
14DE: FF ..

14E0: 3A 15 83    ld   a,($TICK_MOD_FAST) ; faster in round 2
14E3: E6 03       and  $03
14E5: C0          ret  nz
14E6: CD 50 3A    call $3A50
14E9: CD 88 3A    call $3A88
14EC: CD C0 3A    call $3AC0
14EF: C9          ret

14F0: FF ...


1500: B0          or   b
1501: 18 B0       jr   $14B3
1503: 18 40       jr   $1545
1505: 21 B0 18    ld   hl,$18B0
1508: 10 1A       djnz $1524
150A: 40          ld   b,b
150B: 21 70 1E    ld   hl,$1E70
150E: B0          or   b
150F: 18 40       jr   $1551
1511: 21 10 1A    ld   hl,$1A10
1514: 40          ld   b,b
1515: 21 70 1E    ld   hl,$1E70
1518: B0          or   b
1519: 18 40       jr   $155B
151B: 21 B0 18    ld   hl,$18B0
151E: 00          nop
151F: 1D          dec  e
1520: 70          ld   (hl),b
1521: 1E B0       ld   e,$B0
1523: 18 00       jr   $1525
1525: 1D          dec  e
1526: 70          ld   (hl),b
1527: 1E E0       ld   e,$E0

1529: 1F          rra
152A: 40          ld   b,b
152B: 21 70 1E    ld   hl,$1E70
152E: E0          ret  po
152F: 1F          rra
1530: 40          ld   b,b
1531: 21 70 1E    ld   hl,$1E70
1534: 00          nop
1535: 1D          dec  e
1536: 00          nop
1537: 00          nop
1538: 00          nop
1539: 00          nop
153A: 00          nop
153B: 00          nop
153C: FF ...

COPY_XOFFS_COL_SPRITES_TO_SCREEN
1550: E5          push hl
1551: C5          push bc
1552: D5          push de
1553: 21 00 81    ld   hl,$SCREEN_XOFF_COL
1556: 11 00 98    ld   de,$XOFF_COL_RAM
1559: 01 80 00    ld   bc,$0080
155C: ED B0       ldir ; LD (DE),(HL) repeated: copies a chunk of mem
155E: D1          pop  de
155F: C1          pop  bc
1560: E1          pop  hl
1561: C9          ret

1562: FF FF

1564: 00          nop
1565: 00          nop

ANIMATE_SPLASH_PICKUPS
1566: 3A 08 93    ld   a,($9308) ;
1569: FE 10       cp   $TILE_BLANK
156B: 28 10       jr   z,$157D
156D: FE 8C       cp   $TILE_CROWN_PIKA
156F: 20 07       jr   nz,$1578
1571: 3E 9C       ld   a,$TILE_CROWN_PIK
1573: 32 08 93    ld   ($9308),a
1576: 18 05       jr   $157D
1578: 3E 8C       ld   a,$TILE_CROWN_PIKA
157A: 32 08 93    ld   ($9308),
    ;;
157D: 3A 0C 93    ld   a,($930C) ;
1580: FE 10       cp   $TILE_BLANK
1582: 28 10       jr   z,$1594
1584: FE 8D       cp   $TILE_PIK_CROSSA
1586: 20 07       jr   nz,$158F
1588: 3E 9D       ld   a,$TILE_PIK_CROSS
158A: 32 0C 93    ld   ($930C),a
158D: 18 05       jr   $1594
158F: 3E 8D       ld   a,$TILE_PIK_CROSSA
1591: 32 0C 93    ld   ($930C),a
    ;;
1594: 3A 10 93    ld   a,($9310)
1597: FE 10       cp   $TILE_BLANK
1599: 28 10       jr   z,$15AB
159B: FE 8E       cp   $TILE_PIK_RINGA
159D: 20 07       jr   nz,$15A6
159F: 3E 9E       ld   a,$TILE_PIK_RING
15A1: 32 10 93    ld   ($9310),a
15A4: 18 05       jr   $15AB
15A6: 3E 8E       ld   a,$TILE_PIK_RINGA
15A8: 32 10 93    ld   ($9310),a

15AB: 3A 14 93    ld   a,($9314)
15AE: FE 10       cp   $TILE_BLANK
15B0: 28 10       jr   z,$15C2
15B2: FE 8F       cp   $TILE_PIK_VASEA
15B4: 20 07       jr   nz,$15BD
15B6: 3E 9F       ld   a,$TILE_PIK_VASE
15B8: 32 14 93    ld   ($9314),a
15BB: 18 05       jr   $15C2
15BD: 3E 8F       ld   a,$TILE_PIK_VASEA
15BF: 32 14 93    ld   ($9314),a
15C2: C9          ret
15C3: FF          rst  $38
15C4: D5          push de
15C5: 21 A8 1B    ld   hl,$1BA8
15C8: CD E3 01    call $CALL_HL_PLUS_4K
15CB: D1          pop  de
15CC: C9          ret
15CD: FF ...

DO_ATTRACT_MODE
15D0: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
15D3: CD 88 0F    call $0F88
15D6: CD 60 16    call $ANIMATE_SPLASH_SCREEN
15D9: 3E 8C       ld   a,$8C
15DB: 32 08 93    ld   ($9308),a
15DE: CD 60 16    call $ANIMATE_SPLASH_SCREEN
15E1: CD 10 03    call $DRAW_TILES_H
15E4: 08 10
15E6: 02 00 00 10 20 24 23 FF
15EE: CD 60 16    call $ANIMATE_SPLASH_SCREEN
15F1: 3E 8D       ld   a,$8D
15F3: 32 0C 93    ld   ($930C),a
15F6: CD 60 16    call $ANIMATE_SPLASH_SCREEN
15F9: CD 10 03    call $DRAW_TILES_H
15FC: 0C 10
15FD: 04 00 00 10 20 24 23 FF
1606: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1609: 3E 8E       ld   a,$8E
160B: 32 10 93    ld   ($9310),a
160E: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1611: CD 10 03    call $DRAW_TILES_H
1614: 10 10
1616: 06 00 00 10 20 24 23 FF
161E: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1621: 3E 8F       ld   a,$8F
1623: 32 14 93    ld   ($9314),a
1626: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1629: CD 10 03    call $DRAW_TILES_H
162C: 14 10
162E: 01 00 00 00 10 20 24 23 FF
1637: CD 60 16    call $ANIMATE_SPLASH_SCREEN
163A: CD 60 16    call $ANIMATE_SPLASH_SCREEN
163D: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1640: CD 60 16    call $ANIMATE_SPLASH_SCREEN
1643: 21 94 14    ld   hl,$1494
1646: CD E3 01    call $CALL_HL_PLUS_4K
1649: C9          ret
164A: FF          rst  $38
164B: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
164E: 21 E0 0F    ld   hl,$0FE0
1651: CD 40 08    call $DRAW_SCREEN
1654: 00          nop
1655: 00          nop
1656: CD 50 24    call $DRAW_SCORE
1659: C9          ret
165A: FF ...

ANIMATE_SPLASH_SCREEN
1660: 16 10       ld   d,$10
1662: CD 64 15    call $ANIMATE_SPLASH_PICKUPS
1665: CD C4 15    call $15C4
1668: 1E 04       ld   e,$04
166A: D5          push de
166B: CD 28 21    call $2128
166E: D1          pop  de
166F: 1D          dec  e
1670: 20 F8       jr   nz,$166A
1672: 15          dec  d
1673: 20 ED       jr   nz,$1662
1675: C9          ret


1676: FF          rst  $38
1677: FF          rst  $38
1678: E8          ret  pe
1679: EC EE F0    call pe,$F0EE
167C: E9          jp   (hl)
167D: ED          db   $ed
167E: EF          rst  $28
167F: F1          pop  af

UPDATE_SPEED_TIMERS
1680: 3A 04 80    ld   a,($PLAYER_NUM)
1683: A7          and  a
1684: 20 05       jr   nz,$168B
1686: 3A 5B 80    ld   a,($SPEED_DELAY_P1)
1689: 18 03       jr   $168E
168B: 3A 5C 80    ld   a,($SPEED_DELAY_P2)
168E: FE 1F       cp   $ROUND1_SPEED
1690: 20 19       jr   nz,$16AB
    ;;  Round 1
1692: 3A 15 83    ld   a,($TICK_MOD_FAST)
1695: 3C          inc  a
1696: FE 03       cp   $03
1698: 20 01       jr   nz,$169B
169A: AF          xor  a
169B: 32 15 83    ld   ($TICK_MOD_FAST),a
169E: 3A 16 83    ld   a,($TICK_MOD_SLOW)
16A1: 3C          inc  a
16A2: FE 06       cp   $06
16A4: 20 01       jr   nz,$16A7
16A6: AF          xor  a
16A7: 32 16 83    ld   ($TICK_MOD_SLOW),a
16AA: C9          ret
;;; Round 2+
16AB: 3A 15 83    ld   a,($TICK_MOD_FAST)
16AE: 3C          inc  a
16AF: FE 02       cp   $02
16B1: 20 01       jr   nz,$16B4
16B3: AF          xor  a
16B4: 32 15 83    ld   ($TICK_MOD_FAST),a
16B7: 3A 16 83    ld   a,($TICK_MOD_SLOW)
16BA: 3C          inc  a
16BB: FE 04       cp   $04
16BD: 20 01       jr   nz,$16C0
16BF: AF          xor  a
16C0: 32 16 83    ld   ($TICK_MOD_SLOW),a
16C3: C9          ret

16C4: FF ...


DRAW_BONUS
16D0: CD 10 03    call $DRAW_TILES_H
16D3: 0A 00
16D5: E0 DC DD DE DF FF
16DB: CD 10 03    call $DRAW_TILES_H
16DE: 0B 00
16E0: E1 E5 E5 E5 E6 FF
16E6: CD 10 03    call $DRAW_TILES_H
16E9: 0C 00
16EB: E1 E5 E5 E5 E6 FF
16F1: CD 10 03    call $DRAW_TILES_H
16F4: 0D 00
16F6: E2 E3 E3 E3 E4 FF
16FC: C9          ret
16FD: FF ...

    ;; Adds whatever is in 801d
ADD_SCORE
1700: 3A 34 80    ld   a,($IS_PLAYING)
1703: A7          and  a
1704: C8          ret  z
1705: 3A 04 80    ld   a,($PLAYER_NUM)
1708: A7          and  a
1709: 20 17       jr   nz,$1722
;;; player 1
170B: 3A 1D 80    ld   a,($SCORE_TO_ADD) ; amount to add
170E: A7          and  a
170F: C8          ret  z        ; nothing to add... leave.
1710: 4F          ld   c,a
1711: 26 80       ld   h,$80    ; 8014 for p1 8017 for p2
1713: 06 00       ld   b,$00
1715: 2E 14       ld   l,$14
1717: CD A0 17    call $ADD_AMOUNT_BDC
171A: CD 50 24    call $DRAW_SCORE
171D: AF          xor  a
171E: 32 1D 80    ld   ($SCORE_TO_ADD),a ; clear
1721: C9          ret
;;; player 2
1722: 3A 1D 80    ld   a,($SCORE_TO_ADD)
1725: A7          and  a
1726: C8          ret  z
1727: 4F          ld   c,a
1728: 26 80       ld   h,$80
172A: 06 00       ld   b,$00
172C: 2E 17       ld   l,$17
172E: CD A0 17    call $ADD_AMOUNT_BDC
1731: CD 50 24    call $DRAW_SCORE
1734: AF          xor  a
1735: 32 1D 80    ld   ($SCORE_TO_ADD),a
1738: C9          ret

1739: FF ...

CHECK_DONE_SCREEN
1750: 37          scf
1751: 3F          ccf
1752: 3A 43 81    ld   a,($PLAYER_Y) ; Test if player is at top or bottom
1755: C6 48       add  a,$48         ; Y + 72 > 255?
1757: 38 03       jr   c,$175C       ; ...yep, check x
1759: D6 78       sub  $78           ; Y - 120 < 0?
175B: D0          ret  nc            ; ...no, can't finish level here...
    ;; check if gone past edge of screen
175C: 3A 40 81    ld   a,($PLAYER_X)
175F: 37          scf
1760: 3F          ccf
1761: D6 E0       sub  $SCREEN_WIDTH  ;out of screen?
1763: D8          ret  c
1764: CD 78 17    call $TRANSITION_TO_NEXT_SCREEN    ; jump to next csreen
1767: C9          ret

;;;
1768: E5          push hl
1769: 3E 03       ld   a,$03
176B: 85          add  a,l
176C: 6F          ld   l,a
176D: 1E 1C       ld   e,$1C
176F: 36 10       ld   (hl),$10
1771: 23          inc  hl
1772: 1D          dec  e
1773: 20 FA       jr   nz,$176F
1775: E1          pop  hl
1776: C9          ret

1777: FF

TRANSITION_TO_NEXT_SCREEN
1778: CD C0 17    call $RESET_DINO
177B: 3A 04 80    ld   a,($PLAYER_NUM)
177E: A7          and  a
177F: 20 09       jr   nz,$178A
1781: 3A 29 80    ld   a,($SCREEN_NUM)
1784: 3C          inc  a        ; next screen if p1
1785: 32 29 80    ld   ($SCREEN_NUM),a
1788: 18 07       jr   $1791
178A: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
178D: 3C          inc  a        ; next screen if p2
178E: 32 2A 80    ld   ($SCREEN_NUM_P2),a
1791: CD E0 27    call $SET_PLAYER_Y_LEVEL_START
1794: CD 58 13    call $DURING_TRANSITION_NEXT ; is this the wipe?
1797: CD D0 0A    call $SET_LEVEL_PLATFORM_XOFFS
179A: 3E 02       ld   a,$02
179C: C3 B4 17    jp   $RESET_JUMP_AND_REDIFY_BOTTOM_ROW
179F: C9          ret

;; (might be just "add bcd to addr")
    ;; hl is either 8014 for p1 or 8017 for p2
    ;; c contains score to add
ADD_AMOUNT_BDC
17A0: 7E          ld   a,(hl)
17A1: 37          scf
17A2: 3F          ccf
17A3: 81          add  a,c
17A4: 27          daa
17A5: 77          ld   (hl),a
17A6: 2C          inc  l
17A7: 7E          ld   a,(hl)
17A8: 88          adc  a,b
17A9: 27          daa
17AA: 77          ld   (hl),a
17AB: 2C          inc  l
17AC: 7E          ld   a,(hl)
17AD: CE 00       adc  a,$00
17AF: 27          daa
17B0: 77          ld   (hl),a
17B1: C9          ret

;;;
17B2: FF          rst  $38
17B3: FF          rst  $38

RESET_JUMP_AND_REDIFY_BOTTOM_ROW
17B4: 32 3F 81    ld   ($SCREEN_XOFF_COL+3F),a ; set bottom row col
17B7: AF          xor  a
17B8: 32 0F 80    ld   ($JUMP_TBL_IDX),a
17BB: 32 05 80    ld   ($JUMP_TRIGGERED),a
17BE: C9          ret

17BF: FF

RESET_DINO
17C0: AF          xor  a
17C1: 32 2D 80    ld   ($DINO_COUNTER),a
17C4: 3A 4C 81    ld   a,($DINO_X)
17C7: 32 50 81    ld   ($DINO_X_LEGS),a
17CA: C9          ret

17CB: FF ...

17D0: CD 10 03    call $DRAW_TILES_H
17D3: 0A 00
17D5: B8 B4 B5 B6 B7 FF
17DB: CD 10 03    call $DRAW_TILES_H
17DE: 0B 00
17E0: B9 FF
17E2: CD 10 03    call $DRAW_TILES_H
17E5: 0B 04
17E7: BE FF
17E9: CD 10 03    call $DRAW_TILES_H
17EC: 0C 00
17EE: B9 FF
17F0: CD 10 03    call $DRAW_TILES_H
17F3: 0C 04
17F5: BE FF
17F7: CD 10 03    call $DRAW_TILES_H
17FA: 0D 00
17FC: BA BB BB BB BC FF
1802: C9          ret
1803: FF ...

RESET_PLAYER_SPRITE_FRAME_COL
1808: 3E 0C       ld   a,$0C
180A: 32 41 81    ld   ($PLAYER_FRAME),a
180D: 3C          inc  a
180E: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
1811: 3E 11       ld   a,$11
1813: 32 42 81    ld   ($PLAYER_COL),a
1816: 32 46 81    ld   ($PLAYER_COL_LEGS),a
1819: C9          ret
181A: FF ...

INIT_PLAYER_POS_FOR_SCREEN
1820: 3A 04 80    ld   a,($PLAYER_NUM)
1823: A7          and  a
1824: 20 05       jr   nz,$182B
1826: 3A 29 80    ld   a,($SCREEN_NUM)
1829: 18 03       jr   $182E
182B: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
182E: 21 50 18    ld   hl,$1850
1831: 3D          dec  a
1832: CB 27       sla  a
1834: 85          add  a,l
1835: 6F          ld   l,a
1836: 7E          ld   a,(hl)
1837: 32 40 81    ld   ($PLAYER_X),a
183A: 32 44 81    ld   ($PLAYER_X_LEGS),a
183D: 23          inc  hl
183E: 7E          ld   a,(hl)
183F: 32 43 81    ld   ($PLAYER_Y),a
1842: C6 10       add  a,$10
1844: 32 47 81    ld   ($PLAYER_Y_LEGS),a
1847: CD 08 18    call $RESET_PLAYER_SPRITE_FRAME_COL
184A: C9          ret
184B: FF ...

1850: 20 D0       jr   nz,$1822
1852: 20 D0       jr   nz,$1824
1854: 20 D0       jr   nz,$1826
1856: 20 D0       jr   nz,$1828
1858: 20 D0       jr   nz,$182A
185A: 20 26       jr   nz,$1882
185C: 20 26       jr   nz,$1884
185E: 20 D0       jr   nz,$1830
1860: 20 D0       jr   nz,$1832
1862: 20 D0       jr   nz,$1834
1864: 20 26       jr   nz,$188C
1866: 20 26       jr   nz,$188E
1868: 20 D0       jr   nz,$183A
186A: 20 D0       jr   nz,$183C
186C: 20 D0       jr   nz,$183E
186E: 20 D0       jr   nz,$1840
1870: 20 26       jr   nz,$1898
1872: 20 D0       jr   nz,$1844
1874: 20 D0       jr   nz,$1846
1876: 20 26       jr   nz,$189E
1878: 20 D0       jr   nz,$184A
187A: 20 26       jr   nz,$18A2
187C: 20 26       jr   nz,$18A4
187E: 20 D0       jr   nz,$1850
1880: 20 26       jr   nz,$18A8
1882: 20 26       jr   nz,$18AA
1884: 20 D0       jr   nz,$1856
1886: 00          nop
1887: 00          nop
1888: 00          nop
1889: 00          nop
188A: 00          nop
188B: 00          nop
188C: 00          nop
188D: 00          nop
188E: 00          nop
188F: 00          nop
1890: FF ...

RESET_XOFF_AND_COLS
1898: 21 00 81    ld   hl,$SCREEN_XOFF_COL
189B: 36 00       ld   (hl),$00
189D: 23          inc  hl
189E: 23          inc  hl
189F: 7D          ld   a,l
18A0: FE 40       cp   $40
18A2: 20 F7       jr   nz,$189B
18A4: C9          ret
18A5: FF ...

18B0: 03          inc  bc
18B1: 41          ld   b,c
18B2: 00          nop
18B3: 09          add  hl,bc
18B4: FE 00       cp   $00
18B6: 1E 39       ld   e,$39
18B8: FF          rst  $38
18B9: 03          inc  bc
18BA: 43          ld   b,e
18BB: 00          nop
18BC: 09          add  hl,bc
18BD: FD 45       ld   b,iyl
18BF: 41          ld   b,c
18C0: 00          nop
18C1: 1B          dec  de
18C2: FE 3B       cp   $3B
18C4: 45          ld   b,l
18C5: 45          ld   b,l
18C6: FF          rst  $38
18C7: 03          inc  bc
18C8: 40          ld   b,b
18C9: 00          nop
18CA: 09          add  hl,bc
18CB: FD          db   $fd
18CC: 42          ld   b,d
18CD: 00          nop
18CE: 1B          dec  de
18CF: FD          db   $fd
18D0: 3F          ccf
18D1: 3F          ccf
18D2: 3B          dec  sp
18D3: FF          rst  $38
18D4: 03          inc  bc
18D5: 43          ld   b,e
18D6: 00          nop
18D7: 09          add  hl,bc
18D8: FC 41 00    call m,$0041
18DB: 1B          dec  de
18DC: FD          db   $fd
18DD: 3B          dec  sp
18DE: 3B          dec  sp
18DF: 3F          ccf
18E0: FF          rst  $38
18E1: 03          inc  bc
18E2: 42          ld   b,d
18E3: 00          nop
18E4: 1B          dec  de
18E5: FD          db   $fd
18E6: 3F          ccf
18E7: 3B          dec  sp
18E8: 3B          dec  sp
18E9: FF          rst  $38
18EA: 03          inc  bc
18EB: 3F          ccf
18EC: 00          nop
18ED: 1B          dec  de
18EE: FD          db   $fd
18EF: 3F          ccf
18F0: 3F          ccf
18F1: 3B          dec  sp
18F2: FF          rst  $38
18F3: 03          inc  bc
18F4: 3E 43       ld   a,$43
18F6: 00          nop
18F7: 1B          dec  de
18F8: FD          db   $fd
18F9: 3B          dec  sp
18FA: 3F          ccf
18FB: 3B          dec  sp
18FC: FF          rst  $38
18FD: 03          inc  bc
18FE: 3F          ccf
18FF: 40          ld   b,b
1900: 00          nop
1901: 1B          dec  de
1902: FC 47 3B    call m,$3B47
1905: 47          ld   b,a
1906: FF          rst  $38
1907: 03          inc  bc
1908: 3B          dec  sp
1909: 42          ld   b,d
190A: 00          nop
190B: 1D          dec  e
190C: 3D          dec  a
190D: 3F          ccf
190E: FF          rst  $38
190F: 03          inc  bc
1910: 3B          dec  sp
1911: 40          ld   b,b
1912: 00          nop
1913: 1D          dec  e
1914: 3C          inc  a
1915: 3E FF       ld   a,$FF
1917: 03          inc  bc
1918: 3F          ccf
1919: 43          ld   b,e
191A: 00          nop
191B: 1D          dec  e
191C: 3A 3F FF    ld   a,($FF3F)
191F: 03          inc  bc
1920: 3E 41       ld   a,$41
1922: 00          nop
1923: 1B          dec  de
1924: FE 10       cp   $10
1926: 3D          dec  a
1927: 3E FF       ld   a,$FF
1929: 03          inc  bc
192A: 3B          dec  sp
192B: 40          ld   b,b
192C: 00          nop
192D: 1B          dec  de
192E: FD          db   $fd
192F: 47          ld   b,a
1930: 3E 47       ld   a,$47
1932: FF          rst  $38
1933: 03          inc  bc
1934: 3F          ccf
1935: 42          ld   b,d
1936: 00          nop
1937: 1B          dec  de
1938: FD          db   $fd
1939: 3B          dec  sp
193A: 3B          dec  sp
193B: 3B          dec  sp
193C: FF          rst  $38
193D: 03          inc  bc
193E: 3E 00       ld   a,$00
1940: 1B          dec  de
1941: FD          db   $fd
1942: 3E 3F       ld   a,$3F
1944: 3F          ccf
1945: FF          rst  $38
1946: 03          inc  bc
1947: 42          ld   b,d
1948: 00          nop
1949: 09          add  hl,bc
194A: FE 00       cp   $00
194C: 1B          dec  de
194D: FD          db   $fd
194E: 3F          ccf
194F: 3B          dec  sp
1950: 3E FF       ld   a,$FF
1952: 03          inc  bc
1953: 43          ld   b,e
1954: 00          nop
1955: 09          add  hl,bc
1956: FD          db   $fd
1957: 47          ld   b,a
1958: 41          ld   b,c
1959: 00          nop
195A: 1B          dec  de
195B: FD          db   $fd
195C: 3B          dec  sp
195D: 3E 3E       ld   a,$3E
195F: FF          rst  $38
1960: 03          inc  bc
1961: 41          ld   b,c
1962: 00          nop
1963: 09          add  hl,bc
1964: FD          db   $fd
1965: 00          nop
1966: 1B          dec  de
1967: FC 3E 3B    call m,$3B3E
196A: 3B          dec  sp
196B: FF          rst  $38
196C: 03          inc  bc
196D: 42          ld   b,d
196E: 00          nop
196F: 09          add  hl,bc
1970: FD          db   $fd
1971: 00          nop
1972: 1E FE       ld   e,$FE
1974: FF          rst  $38
1975: 03          inc  bc
1976: 43          ld   b,e
1977: 00          nop
1978: 09          add  hl,bc
1979: FD          db   $fd
197A: 00          nop
197B: 1E FD       ld   e,$FD
197D: FF          rst  $38
197E: 03          inc  bc
197F: 42          ld   b,d
1980: 00          nop
1981: 09          add  hl,bc
1982: FD          db   $fd
1983: 00          nop
1984: 1E FD       ld   e,$FD
1986: FF          rst  $38
1987: 03          inc  bc
1988: 41          ld   b,c
1989: 00          nop
198A: 09          add  hl,bc
198B: FD          db   $fd
198C: 00          nop
198D: 1E FD       ld   e,$FD
198F: FF          rst  $38
1990: 03          inc  bc
1991: 40          ld   b,b
1992: 00          nop
1993: 09          add  hl,bc
1994: FD          db   $fd
1995: 00          nop
1996: 1E FC       ld   e,$FC
1998: FF          rst  $38
1999: FF          rst  $38
199A: FF          rst  $38
199B: FF          rst  $38

;;; Skip level AFTER getting bonus
BONUS_SKIP_SCREEN
199C: 3E F0       ld   a,$F0
199E: 32 40 81    ld   ($PLAYER_X),a
19A1: 32 44 81    ld   ($PLAYER_X_LEGS),a
19A4: 3E 26       ld   a,$26
19A6: 32 47 81    ld   ($PLAYER_Y_LEGS),a
19A9: 3E 16       ld   a,$16
19AB: 32 43 81    ld   ($PLAYER_Y),a
19AE: 3E 17       ld   a,$17
19B0: 32 41 81    ld   ($PLAYER_FRAME),a
19B3: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
19B6: AF          xor  a
19B7: 32 42 81    ld   ($PLAYER_COL),a
19BA: 32 46 81    ld   ($PLAYER_COL_LEGS),a
19BD: C3 78 17    jp   $TRANSITION_TO_NEXT_SCREEN
    ;; Clear screen to blanks
CLEAR_SCR_TO_BLANKS
19C0: 21 00 90    ld   hl,$SCREEN_RAM
19C3: 23          inc  hl
19C4: 23          inc  hl
19C5: 23          inc  hl
19C6: 16 1D       ld   d,$1D    ; 29
19C8: 36 10       ld   (hl),$TILE_BLANK
19CA: 23          inc  hl
19CB: 15          dec  d
19CC: 20 FA       jr   nz,$19C8
19CE: 7C          ld   a,h
19CF: FE 94       cp   $94      ; 148
19D1: 20 F0       jr   nz,$19C3
19D3: 00          nop
19D4: 00          nop
19D5: 00          nop
19D6: 00          nop
19D7: 00          nop
CLEAR_SCREEN_XOFF_COL           ; Again? dupe sub
19D8: 21 00 81    ld   hl,$SCREEN_XOFF_COL
19DB: 36 00       ld   (hl),$00
19DD: 23          inc  hl
19DE: 7D          ld   a,l
19DF: FE 80       cp   $80
19E1: 20 F8       jr   nz,$19DB
19E3: CD A0 13    call $WAIT_VBLANK
19E6: C9          ret

19E7: FF ...


CHECK_FALL_OFF_BOTTOM_SCR
19F0: 3A 47 81    ld   a,($PLAYER_Y_LEGS)
19F3: 37          scf
19F4: 3F          ccf
19F5: C6 18       add  a,$18    ; +24 (ground)
19F7: D0          ret  nc
19F8: CD C0 0C    call $DO_DEATH_SEQUENCE
19FB: AF          xor  a
19FC: 32 12 80    ld   ($PLAYER_DIED),a
19FF: CD 20 02    call $POST_DEATH_RESET
1A02: C9          ret

1A03: FF

    ;; Die if you go out the screen to the left (16px)
CHECK_EXIT_STAGE_LEFT
1A04: 3A 40 81    ld   a,($PLAYER_X)
1A07: 37          scf
1A08: 3F          ccf
1A09: D6 10       sub  $10      ; out the start of the screen?
1A0B: D0          ret  nc       ; ... nope, you're good
1A0C: C3 48 1B    jp   $CALL_DO_DEATH_SEQUENCE  ; ... yep, you're dead
1A0F: C9          ret

1A10: 03          inc  bc
1A11: 3F          ccf
1A12: 00          nop
1A13: 1B          dec  de
1A14: FE 30       cp   $30
1A16: 31 3C FF    ld   sp,$FF3C
1A19: 03          inc  bc
1A1A: 3F          ccf
1A1B: 3E 3B       ld   a,$3B
1A1D: 40          ld   b,b
1A1E: 00          nop
1A1F: 1B          dec  de
1A20: FC 10 3A    call m,$3A10
1A23: 3F          ccf
1A24: FF          rst  $38
1A25: 03          inc  bc
1A26: 3B          dec  sp
1A27: 3B          dec  sp
1A28: 3E 3F       ld   a,$3F
1A2A: 42          ld   b,d
1A2B: 00          nop
1A2C: 1B          dec  de
1A2D: 36 10       ld   (hl),$10
1A2F: 3D          dec  a
1A30: 3F          ccf
1A31: FF          rst  $38
1A32: 03          inc  bc
1A33: 3F          ccf
1A34: 3B          dec  sp
1A35: 3F          ccf
1A36: 3E 3B       ld   a,$3B
1A38: 41          ld   b,c
1A39: 00          nop
1A3A: 18 FE       jr   $1A3A
1A3C: 30 31       jr   nc,$1A6F
1A3E: 10 3C       djnz $1A7C
1A40: 3F          ccf
1A41: 3E FF       ld   a,$FF
1A43: 03          inc  bc
1A44: 3F          ccf
1A45: 3B          dec  sp
1A46: 3E 3B       ld   a,$3B
1A48: 3E 3F       ld   a,$3F
1A4A: 40          ld   b,b
1A4B: 00          nop
1A4C: 18 FC       jr   $1A4A
1A4E: 00          nop
1A4F: 1D          dec  e
1A50: 39          add  hl,sp
1A51: 3E FF       ld   a,$FF
1A53: 03          inc  bc
1A54: 3B          dec  sp
1A55: 3F          ccf
1A56: 3B          dec  sp
1A57: 3E 3B       ld   a,$3B
1A59: 41          ld   b,c
1A5A: 00          nop
1A5B: 18 36       jr   $1A93
1A5D: 10 10       djnz $1A6F
1A5F: 3D          dec  a
1A60: 3F          ccf
1A61: 3E 3B       ld   a,$3B
1A63: FF          rst  $38
1A64: 03          inc  bc
1A65: 3F          ccf
1A66: 3B          dec  sp
1A67: 3B          dec  sp
1A68: 3B          dec  sp
1A69: 00          nop
1A6A: 15          dec  d
1A6B: FE 30       cp   $30
1A6D: 31 30 10    ld   sp,$1030
1A70: 3A 3E 3B    ld   a,($3B3E)
1A73: 3B          dec  sp
1A74: 3F          ccf
1A75: FF          rst  $38
1A76: 03          inc  bc
1A77: 3E 3E       ld   a,$3E
1A79: 3B          dec  sp
1A7A: 00          nop
1A7B: 15          dec  d
1A7C: FC 00 1A    call m,$1A00
1A7F: 3C          inc  a
1A80: 3F          ccf
1A81: 3E 3E       ld   a,$3E
1A83: 3F          ccf
1A84: FF          rst  $38
1A85: 03          inc  bc
1A86: 3B          dec  sp
1A87: 00          nop
1A88: 15          dec  d
1A89: 37          scf
1A8A: 10 10       djnz $1A9C
1A8C: 10 39       djnz $1AC7
1A8E: 3E 3E       ld   a,$3E
1A90: 3F          ccf
1A91: 3B          dec  sp
1A92: 3F          ccf
1A93: FF          rst  $38
1A94: 03          inc  bc
1A95: 3E 42       ld   a,$42
1A97: 00          nop
1A98: 12          ld   (de),a
1A99: FE 31       cp   $31
1A9B: 30 31       jr   nc,$1ACE
1A9D: 10 10       djnz $1AAF
1A9F: 10 3A       djnz $1ADB
1AA1: 3F          ccf
1AA2: 3E 3B       ld   a,$3B
1AA4: 3E 3F       ld   a,$3F
1AA6: FF          rst  $38
1AA7: 03          inc  bc
1AA8: 3F          ccf
1AA9: 41          ld   b,c
1AAA: 00          nop
1AAB: 12          ld   (de),a
1AAC: FC 00 1A    call m,$1A00
1AAF: 38 3E       jr   c,$1AEF
1AB1: 3B          dec  sp
1AB2: 3B          dec  sp
1AB3: 3F          ccf
1AB4: FF          rst  $38
1AB5: 03          inc  bc
1AB6: 3E 40       ld   a,$40
1AB8: 00          nop
1AB9: 12          ld   (de),a
1ABA: 36 00       ld   (hl),$00
1ABC: 1B          dec  de
1ABD: 39          add  hl,sp
1ABE: 3F          ccf
1ABF: 3B          dec  sp
1AC0: 3F          ccf
1AC1: FF          rst  $38
1AC2: 03          inc  bc
1AC3: 42          ld   b,d
1AC4: 00          nop
1AC5: 0F          rrca
1AC6: FE 30       cp   $30
1AC8: 31 00 1B    ld   sp,$1B00
1ACB: 3C          inc  a
1ACC: 3F          ccf
1ACD: 3E 3E       ld   a,$3E
1ACF: FF          rst  $38
1AD0: 03          inc  bc
1AD1: 43          ld   b,e
1AD2: 00          nop
1AD3: 0F          rrca
1AD4: FC 00 1C    call m,$1C00
1AD7: 3E 3E       ld   a,$3E
1AD9: 3B          dec  sp
1ADA: FF          rst  $38
1ADB: 03          inc  bc
1ADC: 41          ld   b,c
1ADD: 00          nop
1ADE: 0F          rrca
1ADF: 37          scf
1AE0: 00          nop
1AE1: 1D          dec  e
1AE2: 3A 3B FF    ld   a,($FF3B)
1AE5: 03          inc  bc
1AE6: 42          ld   b,d
1AE7: 00          nop
1AE8: 0C          inc  c
1AE9: FE 34       cp   $34
1AEB: 35          dec  (hl)
1AEC: 36 00       ld   (hl),$00
1AEE: 1E 3C       ld   e,$3C
1AF0: FF          rst  $38
1AF1: 03          inc  bc
1AF2: 41          ld   b,c
1AF3: 00          nop
1AF4: 0C          inc  c
1AF5: FC 00 1E    call m,$1E00
1AF8: 39          add  hl,sp
1AF9: FF          rst  $38
1AFA: 03          inc  bc
1AFB: 40          ld   b,b
1AFC: 00          nop
1AFD: 0C          inc  c
1AFE: 36 00       ld   (hl),$00
1B00: 1E 3E       ld   e,$3E
1B02: FF          rst  $38
1B03: 03          inc  bc
1B04: 42          ld   b,d
1B05: 00          nop
1B06: 09          add  hl,bc
1B07: FE 00       cp   $00
1B09: 1E FE       ld   e,$FE
1B0B: FF          rst  $38
1B0C: 03          inc  bc
1B0D: 43          ld   b,e
1B0E: 00          nop
1B0F: 09          add  hl,bc
1B10: FD          db   $fd
1B11: 00          nop
1B12: 1E FD       ld   e,$FD
1B14: FF          rst  $38
1B15: 03          inc  bc
1B16: 42          ld   b,d
1B17: 00          nop
1B18: 09          add  hl,bc
1B19: FD          db   $fd
1B1A: 00          nop
1B1B: 1E FD       ld   e,$FD
1B1D: FF          rst  $38
1B1E: 03          inc  bc
1B1F: 41          ld   b,c
1B20: 00          nop
1B21: 09          add  hl,bc
1B22: FD          db   $fd
1B23: 00          nop
1B24: 1E FD       ld   e,$FD
1B26: FF          rst  $38
1B27: 03          inc  bc
1B28: 40          ld   b,b
1B29: 00          nop
1B2A: 09          add  hl,bc
1B2B: FC 00 1E    call m,$1E00
1B2E: FC FF 2A    call m,$2AFF
1B31: 20 80       jr   nz,$1AB3
1B33: 01 14 00    ld   bc,$0014
1B36: 09          add  hl,bc
1B37: 22 20 80    ld   ($8020),hl
1B3A: 2A 1E 80    ld   hl,($801E)
1B3D: 01 14 00    ld   bc,$0014
1B40: 09          add  hl,bc
1B41: 22 1E 80    ld   ($801E),hl
1B44: C9          ret
1B45: FF FF FF

CALL_DO_DEATH_SEQUENCE
1B48: CD C0 0C    call $DO_DEATH_SEQUENCE
1B4B: CD 20 02    call $POST_DEATH_RESET
1B4E: C9          ret
1B4F: FF

1B50: 3E 03       ld   a,$03
1B52: 32 80 80    ld   ($8080),a
1B55: CD 00 17    call $ADD_SCORE
1B58: CD E0 24    call $DELAY_60_VBLANKS
1B5B: 3A 04 80    ld   a,($PLAYER_NUM)
1B5E: A7          and  a
1B5F: 20 05       jr   nz,$1B66
1B61: 21 29 80    ld   hl,$SCREEN_NUM
1B64: 18 03       jr   $1B69
1B66: 21 2A 80    ld   hl,$SCREEN_NUM_P2
1B69: 7E          ld   a,(hl)
1B6A: 3C          inc  a
1B6B: 27          daa
1B6C: 77          ld   (hl),a
1B6D: CD B0 2C    call $2CB0
1B70: C3 00 10    jp   $BIG_RESET

1B73: FF ...

INIT_SCORE_AND_SCREEN_ONCE
1B80: 3A 31 80    ld   a,($PLAYER_UMM)
1B83: A7          and  a
1B84: 20 0B       jr   nz,$1B91
1B86: 3A 22 80    ld   a,($DID_INIT) ; $8022 never used anywhere else
1B89: A7          and  a
1B8A: 28 01       jr   z,$1B8D
1B8C: C9          ret           ; don't reinit?
1B8D: 3C          inc  a
1B8E: 32 22 80    ld   ($DID_INIT),a ; (except here)
1B91: CD 00 17    call $ADD_SCORE
1B94: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES

1B97: 00          nop
1B98: 00          nop
1B99: CD A0 03    call $DRAW_LIVES
1B9C: 21 E0 0F    ld   hl,$0FE0
1B9F: CD 40 08    call $DRAW_SCREEN
1BA2: 00          nop
1BA3: 00          nop
1BA4: CD 50 24    call $DRAW_SCORE
1BA7: 3A 04 80    ld   a,($PLAYER_NUM)
1BAA: A7          and  a
1BAB: 20 10       jr   nz,$1BBD
1BAD: CD 10 03    call $DRAW_TILES_H
1BB0: 10 0A
1BB2: 20 1C 11 29 15 22 10 01 FF
1BBB: 18 0E       jr   $1BCB
1BBD: CD 10 03    call $DRAW_TILES_H
1BC0: 10 0A
1BC2: 20 1C 11 29 15 22 10 02 FF
1BCB: CD 41 1C    call $1C41
1BCE: C9          ret

1BCF: 3E 08       ld   a,$08
1BD1: 32 86 80    ld   ($8086),a
1BD4: C9          ret

1BD5: FF          rst  $38
1BD6: CD 10 03    call $DRAW_TILES_H
1BD9: 1B 02
1BDB: E2 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3 E3
1BEB: E3 E3 E3 E3 E3 E3 E3 E4 FF
1BF4: C3 D8 1C    jp   $1CD8

1BF7: FF ...

DELAY_18_VBLANKS
1C00: 1E 18       ld   e,$18
1C02: CD A0 13    call $WAIT_VBLANK
1C05: 1D          dec  e
1C06: 20 FA       jr   nz,$1C02
1C08: C9          ret

1C09: FF ...

DINO_CAUGHT_PLAYER_RIGHT
1C10: 3A 40 81    ld   a,($PLAYER_X)
1C13: C6 08       add  a,$08
1C15: 32 4C 81    ld   ($DINO_X),a
1C18: C6 08       add  a,$08
1C1A: 32 50 81    ld   ($DINO_X_LEGS),a
1C1D: 3A 43 81    ld   a,($PLAYER_Y)
1C20: 32 4F 81    ld   ($DINO_Y),a
1C23: C6 10       add  a,$10
1C25: 32 53 81    ld   ($DINO_Y_LEGS),a
1C28: 3E AC       ld   a,$AC
1C2A: 32 4D 81    ld   ($DINO_FRAME),a
1C2D: 3E B0       ld   a,$B0
1C2F: 32 51 81    ld   ($DINO_FRAME_LEGS),a
1C32: CD 00 1C    call $DELAY_18_VBLANKS
1C35: 3E AD       ld   a,$AD
1C37: 32 4D 81    ld   ($DINO_FRAME),a
1C3A: CD 00 1C    call $DELAY_18_VBLANKS
1C3D: CD 33 0A    call $KILL_PLAYER
1C40: C9          ret

PLAY_INTRO_JINGLE
1C41: 3E 0F       ld   a,$0F    ;intro jingle
1C43: 32 44 80    ld   ($SFX_ID),a
1C46: AF          xor  a
1C47: 32 42 80    ld   ($CH1_SFX),a
1C4A: CD E0 24    call $DELAY_60_VBLANKS
1C4D: C9          ret

1C4E: FF FF

DINO_CAUGHT_PLAYER_LEFT
1C50: 3A 40 81    ld   a,($PLAYER_X)
1C53: D6 08       sub  $08
1C55: 32 4C 81    ld   ($DINO_X),a
1C58: D6 08       sub  $08
1C5A: 32 50 81    ld   ($DINO_X_LEGS),a
1C5D: 3A 43 81    ld   a,($PLAYER_Y)
1C60: 32 4F 81    ld   ($DINO_Y),a
1C63: C6 10       add  a,$10
1C65: 32 53 81    ld   ($DINO_Y_LEGS),a
1C68: 3E 2C       ld   a,$2C
1C6A: 32 4D 81    ld   ($DINO_FRAME),a
1C6D: 3E 30       ld   a,$30
1C6F: 32 51 81    ld   ($DINO_FRAME_LEGS),a
1C72: CD 00 1C    call $DELAY_18_VBLANKS
1C75: 3E 2D       ld   a,$2D
1C77: 32 4D 81    ld   ($DINO_FRAME),a
1C7A: CD 00 1C    call $DELAY_18_VBLANKS
1C7D: CD 33 0A    call $KILL_PLAYER
1C80: C9          ret

1C81: E9          jp   (hl)
1C82: 10 40       djnz $1CC4
1C84: 01 81 1C    ld   bc,$1C81
1C87: C5          push bc
1C88: E5          push hl
1C89: C9          ret

1C8A: FF ...

DINO_GOT_PLAYER_LEFT_OR_RIGHT
1C90: 3A 40 81    ld   a,($PLAYER_X)
1C93: 47          ld   b,a
1C94: 3A 4C 81    ld   a,($DINO_X)
1C97: 37          scf
1C98: 3F          ccf
1C99: 90          sub  b
1C9A: 38 04       jr   c,$1CA0
1C9C: CD 10 1C    call $DINO_CAUGHT_PLAYER_RIGHT
1C9F: C9          ret
1CA0: CD 50 1C    call $DINO_CAUGHT_PLAYER_LEFT
1CA3: C9          ret

1CA4: FF ...

DINO_COLLISION
1CB0: 3A 4C 81    ld   a,($DINO_X)
1CB3: 47          ld   b,a
1CB4: 3A 40 81    ld   a,($PLAYER_X)
1CB7: 90          sub  b
1CB8: 37          scf
1CB9: 3F          ccf
1CBA: D6 18       sub  $18
1CBC: 38 03       jr   c,$1CC1
1CBE: C6 30       add  a,$30
1CC0: D0          ret  nc
1CC1: 3A 4F 81    ld   a,($DINO_Y)
1CC4: 47          ld   b,a
1CC5: 3A 43 81    ld   a,($PLAYER_Y)
1CC8: 90          sub  b
1CC9: 37          scf
1CCA: 3F          ccf
1CCB: D6 28       sub  $28
1CCD: 38 03       jr   c,$1CD2
1CCF: C6 50       add  a,$50
1CD1: D0          ret  nc
1CD2: CD 90 1C    call $DINO_GOT_PLAYER_LEFT_OR_RIGHT
1CD5: C9          ret

1CD6: FF ..

1CD8: CD D8 3B    call $DRAW_TILES_V_COPY
1CDB: 19 03
1CDD: E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
1CED: E1 E1 E1 E1 E1 E1 E1 E1 FF
1CF6: C9          ret
1CF7: FF ...

    ;;
1D00: 03          inc  bc
1D01: 3B          dec  sp
1D02: 3E 3F       ld   a,$3F
1D04: 00          nop
1D05: 0F          rrca
1D06: FE 00       cp   $00
1D08: 1B          dec  de
1D09: FE 10       cp   $10
1D0B: 3D          dec  a
1D0C: 3E FF       ld   a,$FF
1D0E: 03          inc  bc
1D0F: 3E 3E       ld   a,$3E
1D11: 3F          ccf
1D12: 3E 00       ld   a,$00
1D14: 0F          rrca
1D15: FD          db   $fd
1D16: 00          nop
1D17: 1B          dec  de
1D18: FD          db   $fd
1D19: 10 3C       djnz $1D57
1D1B: 3F          ccf
1D1C: FF          rst  $38
1D1D: 03          inc  bc
1D1E: 3E 3B       ld   a,$3B
1D20: 3B          dec  sp
1D21: 3F          ccf
1D22: 3B          dec  sp
1D23: 00          nop
1D24: 0F          rrca
1D25: FD          db   $fd
1D26: 00          nop
1D27: 1B          dec  de
1D28: FD          db   $fd
1D29: 10 3A       djnz $1D65
1D2B: 3B          dec  sp
1D2C: FF          rst  $38
1D2D: 03          inc  bc
1D2E: 3B          dec  sp
1D2F: 3E 3B       ld   a,$3B
1D31: 3F          ccf
1D32: 3F          ccf
1D33: 41          ld   b,c
1D34: 00          nop
1D35: 0F          rrca
1D36: FD          db   $fd
1D37: 00          nop
1D38: 1B          dec  de
1D39: FD          db   $fd
1D3A: 10 3C       djnz $1D78
1D3C: 3B          dec  sp
1D3D: FF          rst  $38
1D3E: 03          inc  bc
1D3F: 3B          dec  sp
1D40: 3E 3F       ld   a,$3F
1D42: 3B          dec  sp
1D43: 00          nop
1D44: 0F          rrca
1D45: FC 00 19    call m,$1900
1D48: 35          dec  (hl)
1D49: 34          inc  (hl)
1D4A: 3C          inc  a
1D4B: 10 39       djnz $1D86
1D4D: 3E FF       ld   a,$FF
1D4F: 03          inc  bc
1D50: 3F          ccf
1D51: 3E 3B       ld   a,$3B
1D53: 3E 00       ld   a,$00
1D55: 0D          dec  c
1D56: 36 31       ld   (hl),$31
1D58: 00          nop
1D59: 18 37       jr   $1D92
1D5B: 10 10       djnz $1D6D
1D5D: 10 3D       djnz $1D9C
1D5F: 3F          ccf
1D60: 3E FF       ld   a,$FF
1D62: 03          inc  bc
1D63: 3B          dec  sp
1D64: 3B          dec  sp
1D65: 40          ld   b,b
1D66: 00          nop
1D67: 0C          inc  c
1D68: 33          inc  sp
1D69: 00          nop
1D6A: 12          ld   (de),a
1D6B: FE 00       cp   $00
1D6D: 18 FE       jr   $1D6D
1D6F: 10 10       djnz $1D81
1D71: 3C          inc  a
1D72: 3E 3F       ld   a,$3F
1D74: 3F          ccf
1D75: FF          rst  $38
1D76: 03          inc  bc
1D77: 3E 40       ld   a,$40
1D79: 00          nop
1D7A: 0C          inc  c
1D7B: FE 00       cp   $00
1D7D: 12          ld   (de),a
1D7E: FD          db   $fd
1D7F: 00          nop
1D80: 18 FD       jr   $1D7F
1D82: 10 10       djnz $1D94
1D84: 3D          dec  a
1D85: 3B          dec  sp
1D86: 3F          ccf
1D87: 3B          dec  sp
1D88: FF          rst  $38
1D89: 03          inc  bc
1D8A: 3F          ccf
1D8B: 41          ld   b,c
1D8C: 00          nop
1D8D: 0C          inc  c
1D8E: FD          db   $fd
1D8F: 00          nop
1D90: 12          ld   (de),a
1D91: FD          db   $fd
1D92: 00          nop
1D93: 18 FD       jr   $1D92
1D95: 10 3A       djnz $1DD1
1D97: 3F          ccf
1D98: 3F          ccf
1D99: 3E 3B       ld   a,$3B
1D9B: FF          rst  $38
1D9C: 03          inc  bc
1D9D: 3F          ccf
1D9E: 40          ld   b,b
1D9F: 00          nop
1DA0: 0C          inc  c
1DA1: FD          db   $fd
1DA2: 00          nop
1DA3: 12          ld   (de),a
1DA4: FD          db   $fd
1DA5: 00          nop
1DA6: 18 FD       jr   $1DA5
1DA8: 10 38       djnz $1DE2
1DAA: 3E 3F       ld   a,$3F
1DAC: 3E 3B       ld   a,$3B
1DAE: FF          rst  $38
1DAF: 03          inc  bc
1DB0: 40          ld   b,b
1DB1: 00          nop
1DB2: 0C          inc  c
1DB3: FD          db   $fd
1DB4: 00          nop
1DB5: 12          ld   (de),a
1DB6: FD          db   $fd
1DB7: 00          nop
1DB8: 18 FD       jr   $1DB7
1DBA: 10 10       djnz $1DCC
1DBC: 3A 3B 3B    ld   a,($3B3B)
1DBF: 3F          ccf
1DC0: FF          rst  $38
1DC1: 03          inc  bc
1DC2: 42          ld   b,d
1DC3: 00          nop
1DC4: 0C          inc  c
1DC5: FC 00 12    call m,$PLAYER_POS_UPDATE
1DC8: FC 00 18    call m,$1800
1DCB: FC 10 10    call m,$1010
1DCE: 3A 3F 3E    ld   a,($3E3F)
1DD1: 3B          dec  sp
1DD2: FF          rst  $38
1DD3: 03          inc  bc
1DD4: 43          ld   b,e
1DD5: 00          nop
1DD6: 0A          ld   a,(bc)
1DD7: 33          inc  sp
1DD8: 31 00 17    ld   sp,$ADD_SCORE
1DDB: 36 10       ld   (hl),$10
1DDD: 10 3C       djnz $1E1B
1DDF: 3F          ccf
1DE0: 3B          dec  sp
1DE1: 3B          dec  sp
1DE2: 3E FF       ld   a,$FF
1DE4: 03          inc  bc
1DE5: 41          ld   b,c
1DE6: 00          nop
1DE7: 0A          ld   a,(bc)
1DE8: 36 00       ld   (hl),$00
1DEA: 16 36       ld   d,$36
1DEC: 10 10       djnz $1DFE
1DEE: 3D          dec  a
1DEF: 3B          dec  sp
1DF0: 3F          ccf
1DF1: 3E 3B       ld   a,$3B
1DF3: 3B          dec  sp
1DF4: FF          rst  $38
1DF5: 03          inc  bc
1DF6: 43          ld   b,e
1DF7: 00          nop
1DF8: 09          add  hl,bc
1DF9: FE 00       cp   $00
1DFB: 15          dec  d
1DFC: FE 10       cp   $10
1DFE: 10 3A       djnz $1E3A
1E00: 3E 3F       ld   a,$3F
1E02: 3B          dec  sp
1E03: 3F          ccf
1E04: 3B          dec  sp
1E05: 3F          ccf
1E06: FF          rst  $38
1E07: 03          inc  bc
1E08: 42          ld   b,d
1E09: 00          nop
1E0A: 09          add  hl,bc
1E0B: FD          db   $fd
1E0C: 00          nop
1E0D: 15          dec  d
1E0E: FD          db   $fd
1E0F: 10 10       djnz $1E21
1E11: 10 10       djnz $1E23
1E13: 3E 3B       ld   a,$3B
1E15: 3F          ccf
1E16: 3F          ccf
1E17: 3E FF       ld   a,$FF
1E19: 03          inc  bc
1E1A: 41          ld   b,c
1E1B: 00          nop
1E1C: 09          add  hl,bc
1E1D: FD          db   $fd
1E1E: 00          nop
1E1F: 15          dec  d
1E20: FD          db   $fd
1E21: 10 10       djnz $1E33
1E23: 10 10       djnz $1E35
1E25: 10 3A       djnz $1E61
1E27: 3F          ccf
1E28: 3B          dec  sp
1E29: 3E FF       ld   a,$FF
1E2B: 03          inc  bc
1E2C: 40          ld   b,b
1E2D: 00          nop
1E2E: 09          add  hl,bc
1E2F: FD          db   $fd
1E30: 00          nop
1E31: 15          dec  d
1E32: FC 00 1E    call m,$1E00
1E35: FD          db   $fd
1E36: FF          rst  $38
1E37: 03          inc  bc
1E38: 42          ld   b,d
1E39: 00          nop
1E3A: 09          add  hl,bc
1E3B: FD          db   $fd
1E3C: 00          nop
1E3D: 1E FE       ld   e,$FE
1E3F: FF          rst  $38
1E40: 03          inc  bc
1E41: 43          ld   b,e
1E42: 00          nop
1E43: 09          add  hl,bc
1E44: FD          db   $fd
1E45: 00          nop
1E46: 1E FD       ld   e,$FD
1E48: FF          rst  $38
1E49: 03          inc  bc
1E4A: 42          ld   b,d
1E4B: 00          nop
1E4C: 09          add  hl,bc
1E4D: FD          db   $fd
1E4E: 00          nop
1E4F: 1E FD       ld   e,$FD
1E51: FF          rst  $38
1E52: 03          inc  bc
1E53: 41          ld   b,c
1E54: 00          nop
1E55: 09          add  hl,bc
1E56: FD          db   $fd
1E57: 00          nop
1E58: 1E FD       ld   e,$FD
1E5A: FF          rst  $38
1E5B: 03          inc  bc
1E5C: 40          ld   b,b
1E5D: 00          nop
1E5E: 09          add  hl,bc
1E5F: FC 00 1E    call m,$1E00
1E62: FC FF FF    call m,$FFFF
1E65: FF          rst  $38
1E66: FF          rst  $38
1E67: FF          rst  $38
1E68: FF          rst  $38
1E69: FF          rst  $38
1E6A: FF          rst  $38
1E6B: FF          rst  $38
1E6C: FF          rst  $38
1E6D: FF          rst  $38
1E6E: FF          rst  $38
1E6F: FF          rst  $38
1E70: 03          inc  bc
1E71: 42          ld   b,d
1E72: 00          nop
1E73: 0A          ld   a,(bc)
1E74: 30 32       jr   nc,$1EA8
1E76: 00          nop
1E77: 1D          dec  e
1E78: 3C          inc  a
1E79: 3F          ccf
1E7A: FF          rst  $38
1E7B: 03          inc  bc
1E7C: 43          ld   b,e
1E7D: 00          nop
1E7E: 0C          inc  c
1E7F: FE 00       cp   $00
1E81: 1C          inc  e
1E82: 3A 3B 3F    ld   a,($3F3B)
1E85: FF          rst  $38
1E86: 03          inc  bc
1E87: 41          ld   b,c
1E88: 00          nop
1E89: 0C          inc  c
1E8A: FC 00 19    call m,$1900
1E8D: 38 3E       jr   c,$1ECD
1E8F: 3B          dec  sp
1E90: 3F          ccf
1E91: 3F          ccf
1E92: 3B          dec  sp
1E93: FF          rst  $38
1E94: 03          inc  bc
1E95: 3B          dec  sp
1E96: 40          ld   b,b
1E97: 00          nop
1E98: 0D          dec  c
1E99: 31 32 00    ld   sp,$0032
1E9C: 16 3A       ld   d,$3A
1E9E: 3F          ccf
1E9F: 3E 3B       ld   a,$3B
1EA1: 3B          dec  sp
1EA2: 3E 3F       ld   a,$3F
1EA4: 3B          dec  sp
1EA5: 3F          ccf
1EA6: FF          rst  $38
1EA7: 03          inc  bc
1EA8: 3B          dec  sp
1EA9: 00          nop
1EAA: 0F          rrca
1EAB: FE 00       cp   $00
1EAD: 15          dec  d
1EAE: 39          add  hl,sp
1EAF: 3E 3E       ld   a,$3E
1EB1: 3F          ccf
1EB2: 3B          dec  sp
1EB3: 3F          ccf
1EB4: 3F          ccf
1EB5: 3B          dec  sp
1EB6: 3E 3F       ld   a,$3F
1EB8: FF          rst  $38
1EB9: 03          inc  bc
1EBA: 3F          ccf
1EBB: 40          ld   b,b
1EBC: 00          nop
1EBD: 0F          rrca
1EBE: FC 00 14    call m,$1400
1EC1: 38 3F       jr   c,$1F02
1EC3: 3B          dec  sp
1EC4: 3E 3B       ld   a,$3B
1EC6: 3F          ccf
1EC7: 3E 3B       ld   a,$3B
1EC9: 3F          ccf
1ECA: 3E 3E       ld   a,$3E
1ECC: FF          rst  $38
1ECD: 03          inc  bc
1ECE: 3B          dec  sp
1ECF: 3E 41       ld   a,$41
1ED1: 00          nop
1ED2: 10 30       djnz $1F04
1ED4: 32 00 14    ld   ($1400),a
1ED7: 3A 3B 3F    ld   a,($3F3B)
1EDA: 3E 3F       ld   a,$3F
1EDC: 3F          ccf
1EDD: 3B          dec  sp
1EDE: 3B          dec  sp
1EDF: 3E 3F       ld   a,$3F
1EE1: 3E FF       ld   a,$FF
1EE3: 03          inc  bc
1EE4: 3E 3F       ld   a,$3F
1EE6: 3B          dec  sp
1EE7: 3B          dec  sp
1EE8: 40          ld   b,b
1EE9: 00          nop
1EEA: 12          ld   (de),a
1EEB: FE 3F       cp   $3F
1EED: 3F          ccf
1EEE: 3B          dec  sp
1EEF: 3E 3F       ld   a,$3F
1EF1: 3E 3B       ld   a,$3B
1EF3: 3B          dec  sp
1EF4: 3E 3F       ld   a,$3F
1EF6: 3E 3B       ld   a,$3B
1EF8: FF          rst  $38
1EF9: 03          inc  bc
1EFA: 3B          dec  sp
1EFB: 3F          ccf
1EFC: 3F          ccf
1EFD: 3E 40       ld   a,$40
1EFF: 00          nop
1F00: 12          ld   (de),a
1F01: FD          db   $fd
1F02: 3B          dec  sp
1F03: 3F          ccf
1F04: 3E 3B       ld   a,$3B
1F06: 3E 3F       ld   a,$3F
1F08: 3F          ccf
1F09: 3B          dec  sp
1F0A: 3B          dec  sp
1F0B: 3F          ccf
1F0C: 3E 3E       ld   a,$3E
1F0E: FF          rst  $38
1F0F: 03          inc  bc
1F10: 3F          ccf
1F11: 3F          ccf
1F12: 3E 3B       ld   a,$3B
1F14: 3B          dec  sp
1F15: 00          nop
1F16: 16 39       ld   d,$39
1F18: 3B          dec  sp
1F19: 3F          ccf
1F1A: 3E 3F       ld   a,$3F
1F1C: 3F          ccf
1F1D: 3B          dec  sp
1F1E: 3B          dec  sp
1F1F: 3E FF       ld   a,$FF
1F21: 03          inc  bc
1F22: 3F          ccf
1F23: 3B          dec  sp
1F24: 3B          dec  sp
1F25: 3E 40       ld   a,$40
1F27: 00          nop
1F28: 15          dec  d
1F29: FE 3B       cp   $3B
1F2B: 3E 3F       ld   a,$3F
1F2D: 3B          dec  sp
1F2E: 3E 3F       ld   a,$3F
1F30: 3B          dec  sp
1F31: 3E 3F       ld   a,$3F
1F33: FF          rst  $38
1F34: 03          inc  bc
1F35: 3B          dec  sp
1F36: 3F          ccf
1F37: 3E 3E       ld   a,$3E
1F39: 3B          dec  sp
1F3A: 41          ld   b,c
1F3B: 00          nop
1F3C: 15          dec  d
1F3D: FC 3E 3B    call m,$3B3E
1F40: 3F          ccf
1F41: 3E 3B       ld   a,$3B
1F43: 3F          ccf
1F44: 3E 3B       ld   a,$3B
1F46: 3F          ccf
1F47: FF          rst  $38
1F48: 03          inc  bc
1F49: 3F          ccf
1F4A: 3E 3E       ld   a,$3E
1F4C: 3F          ccf
1F4D: 3F          ccf
1F4E: 00          nop
1F4F: 19          add  hl,de
1F50: 3A 3E 3F    ld   a,($3F3E)
1F53: 3B          dec  sp
1F54: 3F          ccf
1F55: 3B          dec  sp
1F56: FF          rst  $38
1F57: 03          inc  bc
1F58: 3F          ccf
1F59: 3E 3F       ld   a,$3F
1F5B: 3B          dec  sp
1F5C: 40          ld   b,b
1F5D: 00          nop
1F5E: 18 FE       jr   $1F5E
1F60: 3B          dec  sp
1F61: 3E 3F       ld   a,$3F
1F63: 3F          ccf
1F64: 3E 3B       ld   a,$3B
1F66: FF          rst  $38
1F67: 03          inc  bc
1F68: 3F          ccf
1F69: 3E 3E       ld   a,$3E
1F6B: 3B          dec  sp
1F6C: 3F          ccf
1F6D: 40          ld   b,b
1F6E: 00          nop
1F6F: 18 FC       jr   $1F6D
1F71: 3E 3B       ld   a,$3B
1F73: 3E 3B       ld   a,$3B
1F75: 3E 3F       ld   a,$3F
1F77: FF          rst  $38
1F78: 03          inc  bc
1F79: 3E 3B       ld   a,$3B
1F7B: 3B          dec  sp
1F7C: 41          ld   b,c
1F7D: 00          nop
1F7E: 1C          inc  e
1F7F: 38 3F       jr   c,$1FC0
1F81: 3F          ccf
1F82: FF          rst  $38
1F83: 03          inc  bc
1F84: 3F          ccf
1F85: 3E 42       ld   a,$42
1F87: 00          nop
1F88: 1B          dec  de
1F89: FE 3E       cp   $3E
1F8B: 3B          dec  sp
1F8C: 3B          dec  sp
1F8D: FF          rst  $38
1F8E: 03          inc  bc
1F8F: 3F          ccf
1F90: 40          ld   b,b
1F91: 00          nop
1F92: 1B          dec  de
1F93: FC 3B 3E    call m,$3E3B
1F96: 3F          ccf
1F97: FF          rst  $38
1F98: 03          inc  bc
1F99: 42          ld   b,d
1F9A: 00          nop
1F9B: 09          add  hl,bc
1F9C: FE 00       cp   $00
1F9E: 1E FE       ld   e,$FE
1FA0: FF          rst  $38
1FA1: 03          inc  bc
1FA2: 43          ld   b,e
1FA3: 00          nop
1FA4: 09          add  hl,bc
1FA5: FD          db   $fd
1FA6: 00          nop
1FA7: 1E FD       ld   e,$FD
1FA9: FF          rst  $38
1FAA: 03          inc  bc
1FAB: 42          ld   b,d
1FAC: 00          nop
1FAD: 09          add  hl,bc
1FAE: FD          db   $fd
1FAF: 00          nop
1FB0: 1E FD       ld   e,$FD
1FB2: FF          rst  $38
1FB3: 03          inc  bc
1FB4: 41          ld   b,c
1FB5: 00          nop
1FB6: 09          add  hl,bc
1FB7: FD          db   $fd
1FB8: 00          nop
1FB9: 1E FD       ld   e,$FD
1FBB: FF          rst  $38
1FBC: 03          inc  bc
1FBD: 40          ld   b,b
1FBE: 00          nop
1FBF: 09          add  hl,bc
1FC0: FC 00 1E    call m,$1E00
1FC3: FC FF FF    call m,$FFFF
1FC6: FF          rst  $38
1FC7: FF          rst  $38
1FC8: FF          rst  $38
1FC9: FF          rst  $38
1FCA: FF          rst  $38
1FCB: FF          rst  $38
1FCC: FF          rst  $38
1FCD: FF          rst  $38
1FCE: FF          rst  $38
1FCF: FF          rst  $38
1FD0: FF          rst  $38
1FD1: FF          rst  $38
1FD2: FF          rst  $38
1FD3: FF          rst  $38
1FD4: FF          rst  $38
1FD5: FF          rst  $38
1FD6: FF          rst  $38
1FD7: FF          rst  $38
1FD8: FF          rst  $38
1FD9: FF          rst  $38
1FDA: FF          rst  $38
1FDB: FF          rst  $38
1FDC: FF          rst  $38
1FDD: FF          rst  $38
1FDE: FF          rst  $38
1FDF: FF          rst  $38
1FE0: 03          inc  bc
1FE1: 42          ld   b,d
1FE2: 00          nop
1FE3: 1D          dec  e
1FE4: 3D          dec  a
1FE5: 3B          dec  sp
1FE6: FF          rst  $38
1FE7: 03          inc  bc
1FE8: 41          ld   b,c
1FE9: 00          nop
1FEA: 0F          rrca
1FEB: FE 00       cp   $00
1FED: 1B          dec  de
1FEE: FE 3F       cp   $3F
1FF0: 3E 3B       ld   a,$3B
1FF2: FF          rst  $38
1FF3: 03          inc  bc
1FF4: 40          ld   b,b
1FF5: 00          nop
1FF6: 0F          rrca
1FF7: FD          db   $fd
1FF8: 00          nop
1FF9: 1B          dec  de
1FFA: FD          db   $fd
1FFB: 3B          dec  sp
1FFC: 3E 3F       ld   a,$3F
1FFE: FF          rst  $38
1FFF: 03          inc  bc
2000: 3F          ccf
2001: 43          ld   b,e
2002: 00          nop
2003: 0F          rrca
2004: FC 00 1B    call m,$1B00
2007: FC 3F 3E    call m,$3E3F
200A: 3B          dec  sp
200B: FF          rst  $38
200C: 03          inc  bc
200D: 3E 3B       ld   a,$3B
200F: 41          ld   b,c
2010: 00          nop
2011: 0E 36       ld   c,$36
2013: 10 32       djnz $2047
2015: 00          nop
2016: 1B          dec  de
2017: 38 3B       jr   c,$2054
2019: 3F          ccf
201A: 3E FF       ld   a,$FF
201C: 03          inc  bc
201D: 3B          dec  sp
201E: 3E 3E       ld   a,$3E
2020: 40          ld   b,b
2021: 00          nop
2022: 0D          dec  c
2023: 36 10       ld   (hl),$10
2025: 10 10       djnz $2037
2027: 32 00 1A    ld   ($1A00),a
202A: 3D          dec  a
202B: 3B          dec  sp
202C: 3B          dec  sp
202D: 3F          ccf
202E: 3F          ccf
202F: FF          rst  $38
2030: 03          inc  bc
2031: 3B          dec  sp
2032: 3E 3E       ld   a,$3E
2034: 40          ld   b,b
2035: 00          nop
2036: 0C          inc  c
2037: FE 00       cp   $00
2039: 12          ld   (de),a
203A: FE 00       cp   $00
203C: 18 FE       jr   $203C
203E: 3E 3F       ld   a,$3F
2040: 3B          dec  sp
2041: 3B          dec  sp
2042: 3E 3F       ld   a,$3F
2044: FF          rst  $38
2045: 03          inc  bc
2046: 3F          ccf
2047: 3E 3B       ld   a,$3B
2049: 00          nop
204A: 0C          inc  c
204B: FD          db   $fd
204C: 00          nop
204D: 12          ld   (de),a
204E: FD          db   $fd
204F: 00          nop
2050: 18 FD       jr   $204F
2052: 3F          ccf
2053: 3E 3B       ld   a,$3B
2055: 3F          ccf
2056: 3E 3B       ld   a,$3B
2058: FF          rst  $38
2059: 03          inc  bc
205A: 3E 3B       ld   a,$3B
205C: 41          ld   b,c
205D: 00          nop
205E: 0C          inc  c
205F: FC 00 12    call m,$PLAYER_POS_UPDATE
2062: FC 00 18    call m,$1800
2065: FC 3E 3F    call m,$3F3E
2068: 3E 3F       ld   a,$3F
206A: 3B          dec  sp
206B: 3F          ccf
206C: FF          rst  $38
206D: 03          inc  bc
206E: 3F          ccf
206F: 42          ld   b,d
2070: 00          nop
2071: 19          add  hl,de
2072: 3C          inc  a
2073: 3F          ccf
2074: 3E 3B       ld   a,$3B
2076: 3B          dec  sp
2077: 3F          ccf
2078: FF          rst  $38
2079: 03          inc  bc
207A: 3B          dec  sp
207B: 43          ld   b,e
207C: 00          nop
207D: 19          add  hl,de
207E: 3A 3E 3F    ld   a,($3F3E)
2081: 3E 3F       ld   a,$3F
2083: 3E FF       ld   a,$FF
2085: 03          inc  bc
2086: 3B          dec  sp
2087: 42          ld   b,d
2088: 00          nop
2089: 19          add  hl,de
208A: 3C          inc  a
208B: 3B          dec  sp
208C: 3B          dec  sp
208D: 3E 3B       ld   a,$3B
208F: 3B          dec  sp
2090: FF          rst  $38
2091: 03          inc  bc
2092: 3F          ccf
2093: 3F          ccf
2094: 41          ld   b,c
2095: 00          nop
2096: 19          add  hl,de
2097: 3C          inc  a
2098: 3F          ccf
2099: 3E 3F       ld   a,$3F
209B: 3B          dec  sp
209C: 3E FF       ld   a,$FF
209E: 03          inc  bc
209F: 3E 43       ld   a,$43
20A1: 00          nop
20A2: 1A          ld   a,(de)
20A3: 3E 3F       ld   a,$3F
20A5: 3F          ccf
20A6: 3E 3B       ld   a,$3B
20A8: FF          rst  $38
20A9: 03          inc  bc
20AA: 3B          dec  sp
20AB: 3B          dec  sp
20AC: 40          ld   b,b
20AD: 00          nop
20AE: 0C          inc  c
20AF: FE 00       cp   $00
20B1: 12          ld   (de),a
20B2: FE 00       cp   $00
20B4: 18 FE       jr   $20B4
20B6: 3E 3F       ld   a,$3F
20B8: 3B          dec  sp
20B9: 3B          dec  sp
20BA: 3F          ccf
20BB: 3E FF       ld   a,$FF
20BD: 03          inc  bc
20BE: 3F          ccf
20BF: 00          nop
20C0: 0C          inc  c
20C1: FD          db   $fd
20C2: 00          nop
20C3: 12          ld   (de),a
20C4: FD          db   $fd
20C5: 00          nop
20C6: 18 FD       jr   $20C5
20C8: 3E 3E       ld   a,$3E
20CA: 3F          ccf
20CB: 3B          dec  sp
20CC: 3F          ccf
20CD: 3B          dec  sp
20CE: FF          rst  $38
20CF: 03          inc  bc
20D0: 40          ld   b,b
20D1: 00          nop
20D2: 0C          inc  c
20D3: FC 00 12    call m,$PLAYER_POS_UPDATE
20D6: FC 00 18    call m,$1800
20D9: FC 3F 3E    call m,$3E3F
20DC: 3B          dec  sp
20DD: 3B          dec  sp
20DE: 3E 3F       ld   a,$3F
20E0: FF          rst  $38
20E1: 03          inc  bc
20E2: 42          ld   b,d
20E3: 00          nop
20E4: 0B          dec  bc
20E5: 36 00       ld   (hl),$00
20E7: 13          inc  de
20E8: 32 00 19    ld   ($1900),a
20EB: 30 31       jr   nc,$211E
20ED: 31 30 30    ld   sp,$3030
20F0: FE FF       cp   $FF
20F2: 03          inc  bc
20F3: 43          ld   b,e
20F4: 00          nop
20F5: 0A          ld   a,(bc)
20F6: 36 00       ld   (hl),$00
20F8: 14          inc  d
20F9: 32 00 1E    ld   ($1E00),a
20FC: FD          db   $fd
20FD: FF          rst  $38
20FE: 03          inc  bc
20FF: 42          ld   b,d
2100: 00          nop
2101: 09          add  hl,bc
2102: FE 00       cp   $00
2104: 15          dec  d
2105: FE 00       cp   $00
2107: 1E FD       ld   e,$FD
2109: FF          rst  $38
210A: 03          inc  bc
210B: 41          ld   b,c
210C: 00          nop
210D: 09          add  hl,bc
210E: FD          db   $fd
210F: 00          nop
2110: 15          dec  d
2111: FD          db   $fd
2112: 00          nop
2113: 1E FD       ld   e,$FD
2115: FF          rst  $38
2116: 03          inc  bc
2117: 40          ld   b,b
2118: 00          nop
2119: 09          add  hl,bc
211A: FC 00 15    call m,$1500
211D: FC 00 1E    call m,$1E00
2120: FC FF FF    call m,$FFFF
2123: FF          rst  $38
2124: FF          rst  $38
2125: FF          rst  $38
2126: FF          rst  $38
2127: FF          rst  $38

    ;;
2128: CD A0 13    call $WAIT_VBLANK
212B: 3A 03 83    ld   a,($CREDITS)
212E: A7          and  a
212F: C8          ret  z
2130: CD 90 14    call $RESET_SCREEN_META_AND_SPRITES
2133: C3 A4 00    jp   $_PLAY_SPLASH
    ;;
2136: FF ...

2140: 03          inc  bc
2141: 40          ld   b,b
2142: 00          nop
2143: 0A          ld   a,(bc)
2144: 48          ld   c,b
2145: 00          nop
2146: 1E 39       ld   e,$39
2148: FF          rst  $38
2149: 03          inc  bc
214A: 41          ld   b,c
214B: 00          nop
214C: 0B          dec  bc
214D: 48          ld   c,b
214E: 00          nop
214F: 1D          dec  e
2150: 3A 3B FF    ld   a,($FF3B)
2153: 03          inc  bc
2154: 3F          ccf
2155: 46          ld   b,(hl)
2156: 46          ld   b,(hl)
2157: 46          ld   b,(hl)
2158: 46          ld   b,(hl)
2159: 46          ld   b,(hl)
215A: 46          ld   b,(hl)
215B: 46          ld   b,(hl)
215C: 46          ld   b,(hl)
215D: FA 00 1B    jp   m,$1B00
2160: FE 3E       cp   $3E
2162: 3F          ccf
2163: 3E FF       ld   a,$FF
2165: 03          inc  bc
2166: 3E 40       ld   a,$40
2168: 44          ld   b,h
2169: 44          ld   b,h
216A: 44          ld   b,h
216B: 44          ld   b,h
216C: 44          ld   b,h
216D: 44          ld   b,h
216E: 44          ld   b,h
216F: F8          ret  m
2170: 00          nop
2171: 1B          dec  de
2172: FD          db   $fd
2173: 3B          dec  sp
2174: 3F          ccf
2175: 3E FF       ld   a,$FF
2177: 03          inc  bc
2178: 42          ld   b,d
2179: 00          nop
217A: 0D          dec  c
217B: 48          ld   c,b
217C: 00          nop
217D: 1B          dec  de
217E: FC 3A 3B    call m,$3B3A
2181: 3B          dec  sp
2182: FF          rst  $38
2183: 03          inc  bc
2184: 3B          dec  sp
2185: 3B          dec  sp
2186: 41          ld   b,c
2187: 00          nop
2188: 0E 48       ld   c,$48
218A: 00          nop
218B: 1B          dec  de
218C: 3C          inc  a
218D: 3B          dec  sp
218E: 3E 3E       ld   a,$3E
2190: FF          rst  $38
2191: 03          inc  bc
2192: 3B          dec  sp
2193: 3E 00       ld   a,$00
2195: 0F          rrca
2196: 48          ld   c,b
2197: 00          nop
2198: 1B          dec  de
2199: 3A 3E 3F    ld   a,($3F3E)
219C: 3F          ccf
219D: FF          rst  $38
219E: 03          inc  bc
219F: 3F          ccf
21A0: 3F          ccf
21A1: 40          ld   b,b
21A2: 46          ld   b,(hl)
21A3: 46          ld   b,(hl)
21A4: 46          ld   b,(hl)
21A5: 46          ld   b,(hl)
21A6: 46          ld   b,(hl)
21A7: 46          ld   b,(hl)
21A8: 46          ld   b,(hl)
21A9: 46          ld   b,(hl)
21AA: 46          ld   b,(hl)
21AB: FA 00 18    jp   m,$1800
21AE: FE 10       cp   $10
21B0: 10 39       djnz $21EB
21B2: 3B          dec  sp
21B3: 3F          ccf
21B4: 3F          ccf
21B5: FF          rst  $38
21B6: 03          inc  bc
21B7: 3E 3B       ld   a,$3B
21B9: 3B          dec  sp
21BA: 41          ld   b,c
21BB: 44          ld   b,h
21BC: 44          ld   b,h
21BD: 44          ld   b,h
21BE: 44          ld   b,h
21BF: 44          ld   b,h
21C0: 44          ld   b,h
21C1: 44          ld   b,h
21C2: 44          ld   b,h
21C3: F8          ret  m
21C4: 00          nop
21C5: 18 FD       jr   $21C4
21C7: 3F          ccf
21C8: 3E 3B       ld   a,$3B
21CA: 3F          ccf
21CB: 3E 3B       ld   a,$3B
21CD: FF          rst  $38
21CE: 03          inc  bc
21CF: 3F          ccf
21D0: 3B          dec  sp
21D1: 3E 40       ld   a,$40
21D3: 00          nop
21D4: 0F          rrca
21D5: 4A          ld   c,d
21D6: 00          nop
21D7: 18 FC       jr   $21D5
21D9: 3F          ccf
21DA: 3F          ccf
21DB: 3E 3E       ld   a,$3E
21DD: 3B          dec  sp
21DE: 3E FF       ld   a,$FF
21E0: 03          inc  bc
21E1: 3B          dec  sp
21E2: 3E 43       ld   a,$43
21E4: 00          nop
21E5: 0F          rrca
21E6: 4A          ld   c,d
21E7: 00          nop
21E8: 1B          dec  de
21E9: 3C          inc  a
21EA: 3E 3F       ld   a,$3F
21EC: 3B          dec  sp
21ED: FF          rst  $38
21EE: 03          inc  bc
21EF: 3F          ccf
21F0: 41          ld   b,c
21F1: 46          ld   b,(hl)
21F2: 46          ld   b,(hl)
21F3: 46          ld   b,(hl)
21F4: 46          ld   b,(hl)
21F5: 46          ld   b,(hl)
21F6: 46          ld   b,(hl)
21F7: 46          ld   b,(hl)
21F8: 46          ld   b,(hl)
21F9: 46          ld   b,(hl)
21FA: 46          ld   b,(hl)
21FB: FA 00 1B    jp   m,$1B00
21FE: 3C          inc  a
21FF: 3B          dec  sp
2200: 3F          ccf
2201: 3E FF       ld   a,$FF
2203: 03          inc  bc
2204: 40          ld   b,b
2205: 44          ld   b,h
2206: 44          ld   b,h
2207: 44          ld   b,h
2208: 44          ld   b,h
2209: 44          ld   b,h
220A: 44          ld   b,h
220B: 44          ld   b,h
220C: 44          ld   b,h
220D: 44          ld   b,h
220E: 44          ld   b,h
220F: 44          ld   b,h
2210: F8          ret  m
2211: 00          nop
2212: 1C          inc  e
2213: 39          add  hl,sp
2214: 3E 3F       ld   a,$3F
2216: FF          rst  $38
2217: 03          inc  bc
2218: 42          ld   b,d
2219: 00          nop
221A: 0F          rrca
221B: 49          ld   c,c
221C: 00          nop
221D: 1C          inc  e
221E: 3C          inc  a
221F: 3B          dec  sp
2220: 3B          dec  sp
2221: FF          rst  $38
2222: 03          inc  bc
2223: 41          ld   b,c
2224: 00          nop
2225: 0E 49       ld   c,$49
2227: 00          nop
2228: 1B          dec  de
2229: FE 3F       cp   $3F
222B: 3E 3B       ld   a,$3B
222D: FF          rst  $38
222E: 03          inc  bc
222F: 43          ld   b,e
2230: 00          nop
2231: 0D          dec  c
2232: 49          ld   c,c
2233: 00          nop
2234: 1B          dec  de
2235: FC 3E 3F    call m,$3F3E
2238: 3B          dec  sp
2239: FF          rst  $38
223A: 03          inc  bc
223B: 3F          ccf
223C: 41          ld   b,c
223D: 46          ld   b,(hl)
223E: 46          ld   b,(hl)
223F: 46          ld   b,(hl)
2240: 46          ld   b,(hl)
2241: 46          ld   b,(hl)
2242: 46          ld   b,(hl)
2243: 46          ld   b,(hl)
2244: FA 00 1C    jp   m,$1C00
2247: 39          add  hl,sp
2248: 3E 3B       ld   a,$3B
224A: FF          rst  $38
224B: 03          inc  bc
224C: 40          ld   b,b
224D: 44          ld   b,h
224E: 44          ld   b,h
224F: 44          ld   b,h
2250: 44          ld   b,h
2251: 44          ld   b,h
2252: 44          ld   b,h
2253: 44          ld   b,h
2254: 44          ld   b,h
2255: F8          ret  m
2256: 00          nop
2257: 1D          dec  e
2258: 3C          inc  a
2259: 3F          ccf
225A: FF          rst  $38
225B: 03          inc  bc
225C: 42          ld   b,d
225D: 00          nop
225E: 0B          dec  bc
225F: 49          ld   c,c
2260: 00          nop
2261: 1E 3C       ld   e,$3C
2263: FF          rst  $38
2264: 03          inc  bc
2265: 43          ld   b,e
2266: 00          nop
2267: 0A          ld   a,(bc)
2268: 49          ld   c,c
2269: 00          nop
226A: 1E FE       ld   e,$FE
226C: FF          rst  $38
226D: 03          inc  bc
226E: 42          ld   b,d
226F: 00          nop
2270: 09          add  hl,bc
2271: FE 00       cp   $00
2273: 1E FD       ld   e,$FD
2275: FF          rst  $38
2276: 03          inc  bc
2277: 41          ld   b,c
2278: 00          nop
2279: 09          add  hl,bc
227A: FD          db   $fd
227B: 00          nop
227C: 1E FD       ld   e,$FD
227E: FF          rst  $38
227F: 03          inc  bc
2280: 40          ld   b,b
2281: 00          nop
2282: 09          add  hl,bc
2283: FC 00 1E    call m,$1E00
2286: FC FF

WRITE_TO_0_AND_1
2288: 3E 07       ld   a,$07
228A: D3 00       out  ($00),a
228C: 3E 38       ld   a,$38
228E: D3 01       out  ($01),a
2290: C9          ret

2291: FF ...

UPDATE_DINO
22A0: 7E          ld   a,(hl)
22A1: 32 4C 81    ld   ($DINO_X),a
22A4: 23          inc  hl
22A5: 7E          ld   a,(hl)
22A6: 32 4F 81    ld   ($DINO_Y),a
22A9: 23          inc  hl
22AA: 3E 12       ld   a,$12
22AC: 32 4E 81    ld   ($DINO_COL),a
22AF: 32 52 81    ld   ($DINO_COL_LEGS),a
22B2: 7E          ld   a,(hl)   ; param 3?
22B3: E6 FC       and  $FC      ; 1111 1100
22B5: 28 1D       jr   z,$22D4
22B7: E6 F8       and  $F8      ; 1111 1000
22B9: 20 07       jr   nz,$22C2
22BB: 3A 4C 81    ld   a,($DINO_X)
22BE: D6 08       sub  $08
22C0: 18 05       jr   $22C7
22C2: 3A 4C 81    ld   a,($DINO_X)
22C5: C6 08       add  a,$08
22C7: 32 50 81    ld   ($DINO_X_LEGS),a
22CA: 3A 4F 81    ld   a,($DINO_Y)
22CD: C6 10       add  a,$10
22CF: 32 53 81    ld   ($DINO_Y_LEGS),a
22D2: 18 04       jr   $22D8
22D4: AF          xor  a
22D5: 32 50 81    ld   ($DINO_X_LEGS),a
22D8: 7E          ld   a,(hl)
22D9: CB 27       sla  a
22DB: 01 00 24    ld   bc,$DINO_ANIM_LOOKUP
22DE: 81          add  a,c
22DF: 4F          ld   c,a
22E0: 0A          ld   a,(bc)
22E1: 32 4D 81    ld   ($DINO_FRAME),a
22E4: 03          inc  bc
22E5: 0A          ld   a,(bc)
22E6: 32 51 81    ld   ($DINO_FRAME_LEGS),a
22E9: CD 20 29    call $SET_DINO_DIR
22EC: C3 E0 23    jp   $23E0
22EF: FF          rst  $38

DINO_PATHFIND_NOPSLIDE
22F0: 00          nop
22F1: 00          nop
22F2: 00          nop
22F3: 00          nop
22F4: 00          nop
22F5: 00          nop
22F6: 00          nop
22F7: 00          nop
22F8: 00          nop
22F9: 00          nop
22FA: 00          nop

    ;; Check if it's time to start the dino,
    ;; if started - follow path.
DINO_PATHFIND
22FB: 3A 2D 80    ld   a,($DINO_COUNTER)
22FE: 3C          inc  a
22FF: 32 2D 80    ld   ($DINO_COUNTER),a
2302: 5F          ld   e,a
2303: 37          scf
2304: 3F          ccf
2305: D6 0B       sub  $0B      ; 11 ticks till dino time
2307: D8          ret  c
2308: 3A 04 80    ld   a,($PLAYER_NUM) ; start dino!
230B: A7          and  a
230C: 20 05       jr   nz,$2313
230E: 3A 29 80    ld   a,($SCREEN_NUM)
2311: 18 03       jr   $2316
2313: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
2316: 3D          dec  a
2317: 21 30 23    ld   hl,$DINO_PATH_LOOKUP
231A: CB 27       sla  a  ; screen # x 2
231C: 85          add  a,l ; dino_lookup + scr*2
231D: 6F          ld   l,a
231E: 4E          ld   c,(hl)
231F: 23          inc  hl
2320: 46          ld   b,(hl)
2321: 7B          ld   a,e      ; add dino counter
2322: D6 0B       sub  $0B
2324: CB 27       sla  a
2326: CB 27       sla  a
2328: 81          add  a,c
2329: 6F          ld   l,a
232A: 60          ld   h,b      ; hl points to dino x/y
232B: CD A0 22    call $UPDATE_DINO
232E: C9          ret

232F: FF

    ;; location of path data for each screen
DINO_PATH_LOOKUP
2330: 78 23 ; DINO_PATH_1 (screen1)
2332: 78 23
2334: 00 26 ; DINO_PATH_2
2336: 78 23
2338: 80 26 ; DINO_PATH_3
2340: 00 27 ; DINO_PATH_4
233C: 70 27 ; DINO_PATH_5
233E: 78 23
2340: 00 26
2342: 80 26
2344: 00 27
2346: 70 27
2348: 78 23
234A: 00 26
234C: 78 23
234E: 00 28 ; DINO_PATH_6
2350: 70 27
2352: 78 23
2354: 00 28
2356: 70 27
2358: 00 2A ; DINO_PATH_7
235A: 00 27
235C: 70 27
235E: 00 2A
2360: 00 27
2362: 70 27
2364: 00 28 ; (screen 27)
2366: 00 00 00 00 00 00 00 00 00 00

2370: FF ...

    ;; Nodes for dino to follow: 25 nodes,
    ;; four bytes per node: [ x, y, ?, ? ]
DINO_PATH_1
2378: 18 E0 00 00 1C E0 01 00
2380: 20 E0 02 00 28 E0 03 00
2388: 30 E0 02 00 38 E0 01 00
2390: 48 C8 00 00 50 C8 01 00
2398: 58 C8 02 00 60 C8 03 00
23A0: 68 C8 02 00 70 C8 03 00
23A8: 80 C8 07 00 88 C8 05 00
23B0: 98 C8 03 00 A0 C8 02 00
23B8: A8 C8 03 00 B0 C8 02 00
23C0: B8 C8 03 00 C0 C8 01 00
23C8: D0 D0 07 00 D8 D0 05 00
23D0: E0 D0 06 00 E8 D0 05 00
23D8: F0 D0 04 00 FF FF FF FF

    ;;
23E0: 3A 4C 81    ld   a,($DINO_X)
23E3: FE 18       cp   $18
23E5: C0          ret  nz
23E6: 3E 07       ld   a,$07
23E8: 32 44 80    ld   ($SFX_ID),a
23EB: C9          ret

23EC: FF ...

DINO_ANIM_LOOKUP
2400: 2F 00 2E 00
2404: 2D 00 2C 00
2408: 2D 30 2C 31
240C: 2D 32
240E: 2C 33 AD B0
2412: AC B1 AD B2
2416: AC B3

2418: FF ...

    ;;
COPY_INP_TO_BUTTONS_AND_CHECK_BUTTONS
2420: 3A 00 A8    ld   a,($PORT_IN1)
2423: 32 F1 83    ld   ($INPUT_BUTTONS),a
2426: 3A 00 B0    ld   a,($PORT_IN2)
2429: 32 F2 83    ld   ($INPUT_BUTTONS_2),a
242C: CD 40 36    call $CHECK_BUTTONS_FOR_SOMETHING
242F: C9          ret

2430: 06 00       ld   b,$00
2432: 3A 00 B8    ld   a,($WATCHDOG)
2435: 05          dec  b
2436: 20 FA       jr   nz,$2432
2438: C9          ret
2439: FF ...

DRAW_SCORE
2450: AF          xor  a
2451: 21 14 80    ld   hl,$P1_SCORE
2454: ED 67       rrd  (hl)
2456: 32 01 93    ld   ($9301),a
2459: ED 67       rrd  (hl)
245B: 32 21 93    ld   ($9321),a
245E: ED 67       rrd  (hl)
2460: 2C          inc  l
2461: ED 67       rrd  (hl)
2463: 32 41 93    ld   ($9341),a
2466: ED 67       rrd  (hl)
2468: 32 61 93    ld   ($9361),a
246B: ED 67       rrd  (hl)
246D: 2C          inc  l
246E: ED 67       rrd  (hl)
2470: 32 81 93    ld   ($9381),a
2473: ED 67       rrd  (hl)
2475: ED 67       rrd  (hl)
2477: AF          xor  a
2478: 32 E1 92    ld   ($92E1),a
247B: 21 17 80    ld   hl,$P2_SCORE
247E: ED 67       rrd  (hl)
2480: 32 81 90    ld   ($9081),a
2483: ED 67       rrd  (hl)
2485: 32 A1 90    ld   ($90A1),a
2488: ED 67       rrd  (hl)
248A: 2C          inc  l
248B: ED 67       rrd  (hl)
248D: 32 C1 90    ld   ($90C1),a
2490: ED 67       rrd  (hl)
2492: 32 E1 90    ld   ($90E1),a
2495: ED 67       rrd  (hl)
2497: 2C          inc  l
2498: ED 67       rrd  (hl)
249A: 32 01 91    ld   ($9101),a
249D: ED 67       rrd  (hl)
249F: ED 67       rrd  (hl)
24A1: AF          xor  a
24A2: 32 61 90    ld   ($9061),a
24A5: 21 00 83    ld   hl,$HISCORE
24A8: ED 67       rrd  (hl)
24AA: 32 C1 91    ld   ($91C1),a
24AD: ED 67       rrd  (hl)
24AF: 32 E1 91    ld   ($91E1),a
24B2: ED 67       rrd  (hl)
24B4: 2C          inc  l
24B5: ED 67       rrd  (hl)
24B7: 32 01 92    ld   ($9201),a
24BA: ED 67       rrd  (hl)
24BC: 32 21 92    ld   ($9221),a
24BF: ED 67       rrd  (hl)
24C1: 2C          inc  l
24C2: ED 67       rrd  (hl)
24C4: 32 41 92    ld   ($9241),a
24C7: ED 67       rrd  (hl)
24C9: ED 67       rrd  (hl)
24CB: AF          xor  a
24CC: 32 A1 91    ld   ($91A1),a
24CF: CD 38 30    call $COPY_HISCORE_NAME_TO_SCREEN_2
24D2: C9          ret

24D3: FF ...

DELAY_60_VBLANKS
24E0: 26 60       ld   h,$60
24E2: CD A0 13    call $WAIT_VBLANK
24E5: 24          inc  h
24E6: 20 FA       jr   nz,$24E2
24E8: C9          ret
24E9: FF ...

24EC: C5          push bc
24ED: 06 08       ld   b,$08
24EF: C5          push bc
24F0: CD A0 13    call $WAIT_VBLANK
24F3: C1          pop  bc
24F4: 10 F9       djnz $24EF
24F6: C1          pop  bc
24F7: 3E 0A       ld   a,$0A
24F9: 32 44 80    ld   ($SFX_ID),a
24FC: C9          ret

24FD: FF ....

2500: 21 00 83    ld   hl,$HISCORE
2503: 36 00       ld   (hl),$00
2505: 2C          inc  l
2506: 7D          ld   a,l
2507: FE E1       cp   $E1
2509: 20 F8       jr   nz,$2503
250B: C9          ret
250C: FF ...

TEST_THEN_DINO_COLLISION
2518: 3A 2D 80    ld   a,($DINO_COUNTER)
251B: E6 F8       and  $F8
251D: C8          ret  z
251E: CD B0 1C    call $DINO_COLLISION
2521: C9          ret

2522: FF ...

2538: 11 16 00    ld   de,$0016
253B: 0E 20       ld   c,$20
253D: 21 10 90    ld   hl,$9010
2540: 06 0A       ld   b,$0A
2542: 36 D4       ld   (hl),$D4
2544: 23          inc  hl
2545: 05          dec  b
2546: 20 FA       jr   nz,$2542
2548: 19          add  hl,de
2549: 0D          dec  c
254A: C8          ret  z
254B: 18 F3       jr   $2540
254D: FF          rst  $38
254E: FF          rst  $38
254F: FF          rst  $38
2550: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
2553: CD A0 13    call $WAIT_VBLANK
2556: 21 40 90    ld   hl,$9040
2559: 1E 79       ld   e,$79
255B: CD 88 25    call $2588
255E: 21 A0 93    ld   hl,$93A0
2561: CD 88 25    call $2588
2564: 21 00 90    ld   hl,$SCREEN_RAM
2567: CD 98 25    call $2598
256A: 21 1F 90    ld   hl,$901F
256D: CD 98 25    call $2598
2570: 16 10       ld   d,$10
2572: 21 61 90    ld   hl,$9061
2575: CD A8 25    call $25A8
2578: CD C0 25    call $25C0
257B: CD D0 25    call $25D0
257E: CD E8 25    call $25E8
2581: 15          dec  d
2582: 20 F1       jr   nz,$2575
2584: CD 80 14    call $CLEAR_SCREEN
2587: C9          ret
2588: 73          ld   (hl),e
2589: 2C          inc  l
258A: 7D          ld   a,l
258B: E6 1F       and  $1F
258D: C8          ret  z
258E: 18 F8       jr   $2588
2590: FF ...

2598: 73          ld   (hl),e
2599: 01 20 00    ld   bc,$0020
259C: 09          add  hl,bc
259D: 7C          ld   a,h
259E: FE 94       cp   $94
25A0: C8          ret  z
25A1: 18 F5       jr   $2598
25A3: FF          rst  $38
25A4: FF          rst  $38
25A5: FF          rst  $38
25A6: FF          rst  $38
25A7: FF          rst  $38
25A8: CD A0 13    call $WAIT_VBLANK
25AB: 73          ld   (hl),e
25AC: 01 20 00    ld   bc,$0020
25AF: 09          add  hl,bc
25B0: 7E          ld   a,(hl)
25B1: BB          cp   e
25B2: 20 F7       jr   nz,$25AB
25B4: ED 42       sbc  hl,bc
25B6: C9          ret
25B7: FF ...

25C0: CD A0 13    call $WAIT_VBLANK
25C3: 73          ld   (hl),e
25C4: 23          inc  hl
25C5: 7E          ld   a,(hl)
25C6: BB          cp   e
25C7: 20 FA       jr   nz,$25C3
25C9: 2B          dec  hl
25CA: C9          ret
25CB: FF ...

25D0: CD A0 13    call $WAIT_VBLANK
25D3: 73          ld   (hl),e
25D4: 01 20 00    ld   bc,$0020
25D7: ED 42       sbc  hl,bc
25D9: 7E          ld   a,(hl)
25DA: BB          cp   e
25DB: 20 F3       jr   nz,$25D0
25DD: 09          add  hl,bc
25DE: C9          ret
25DF: FF ...

25E8: CD A0 13    call $WAIT_VBLANK
25EB: 73          ld   (hl),e
25EC: 2B          dec  hl
25ED: 7E          ld   a,(hl)
25EE: BB          cp   e
25EF: 20 FA       jr   nz,$25EB
25F1: 23          inc  hl
25F2: C9          ret
25F3: FF ...

    ;; Nodes for dino to follow: 31 nodes,
    ;; four bytes per node: [ x, y, ?, ? ]
DINO_PATH_2
2600: 18 E0 00 00 1C E0 01 00
2608: 20 E0 02 00 28 E0 03 00
2610: 30 E0 02 00 38 E0 01 00
2618: 40 D8 02 00 48 D0 04 00
2620: 50 C8 00 00 58 C8 01 00
2628: 60 C8 02 00 68 CC 03 00
2630: 70 CC 02 00 70 C0 04 00
2638: 80 B0 00 00 88 B0 01 00
2640: 90 B0 07 00 98 B8 04 00
2648: A0 C0 05 00 A8 B8 06 00
2650: B0 B8 05 00 B8 B8 04 00
2658: C0 C8 07 00 C8 C8 05 00
2660: D0 D0 06 00 D8 D0 04 00
2668: E0 D0 05 00 E8 D0 06 00
2670: F0 D0 05 00

2674: FF ...

    ;; Nodes for dino to follow: 27 nodes,
    ;; four bytes per node: [ x, y, ?, ? ]
DINO_PATH_3
2680: 18 E0 00 00 20 E0 01 00
2688: 28 E0 02 00 30 D0 04 00
2690: 38 C0 05 00 48 B8 06 00
2698: 50 B8 04 00 58 A8 05 00
26A0: 58 A0 06 00 60 A0 04 00
26A8: 68 90 05 00 70 88 06 00
26B0: 78 88 04 00 80 78 05 00
26B8: 88 70 06 00 90 70 04 00
26C0: 98 60 05 00 A0 58 06 00
26C8: A8 58 04 00 B0 48 05 00
26D0: B8 40 06 00 C0 40 04 00
26D8: C8 30 05 00 D0 28 06 00
26E0: D8 28 04 00 E0 28 05 00
26E8: E8 28 06 00

26EC: FF ...

    ;; Nodes for dino to follow: 24 nodes,
    ;; four bytes per node: [ x, y, ?, ? ]
DINO_PATH_4
2700: 18 38 00 00 20 38 01 00
2708: 28 38 02 00 30 38 03 00
2710: 38 38 07 00 40 40 04 00
2718: 48 40 05 00 50 40 06 00
2720: 58 40 04 00 68 58 05 00
2728: 70 58 06 00 78 58 04 00
2730: 80 58 05 00 88 58 06 00
2738: 90 58 04 00 98 58 05 00
2740: A0 58 06 00 A8 58 04 00
2748: B8 40 05 00 C0 40 06 00
2750: C8 40 04 00 D0 30 05 00
2758: D8 48 06 00 E0 28 04 00

2760: FF ...

    ;; Nodes for dino to follow: 24 nodes,
    ;; four bytes per node: [ x, y, ?, ? ]
DINO_PATH_5
2770: 18 38 00 00 20 38 01 00
2778: 28 38 02 00 30 38 03 00
2780: 38 38 02 00 40 38 07 00
2788: 48 40 04 00 50 40 05 00
2790: 58 40 06 00 60 58 04 00
2798: 68 58 05 00 70 58 06 00
27A0: 78 70 04 00 80 70 05 00
27A8: 88 70 06 00 90 88 04 00
27B0: 98 88 05 00 A0 88 06 00
27B8: A8 A0 04 00 B0 A0 05 00
27C0: B8 A0 06 00 C0 B8 04 00
27C8: C8 B8 05 00 D0 B8 06 00
27D0: D8 D0 04 00 E0 D0 05 00

27D8: FF ...

;;;
SET_PLAYER_Y_LEVEL_START
27E0: 3A 43 81    ld   a,($PLAYER_Y)
27E3: 37          scf
27E4: 3F          ccf
27E5: C6 60       add  a,$60    ; at top of screen?
27E7: 30 0B       jr   nc,$27F4
27E9: 3E D0       ld   a,$D0    ; no, set to bottom
27EB: 32 43 81    ld   ($PLAYER_Y),a
27EE: C6 10       add  a,$10
27F0: 32 47 81    ld   ($PLAYER_Y_LEGS),a
27F3: C9          ret
27F4: 3E 28       ld   a,$28    ; yes, set to top
27F6: 32 43 81    ld   ($PLAYER_Y),a
27F9: C6 10       add  a,$10
27FB: 32 47 81    ld   ($PLAYER_Y_LEGS),a
27FE: C9          ret
;;;
27FF: FF          rst  $38

DINO_PATH_6 ;DATA lookup table x/y/?/?
2800: 18 E0 00 00 20 E0 01 00
28xx: 28 E0 02 00 30 D0 04 00
28xx: 38 D0 05 00 40 B8 05 00
28xx: 48 B8 06 00 50 B8 04 00
28xx: 58 B8 05 00 60 B8 06 00
28xx: 68 B8 04 00 68 A0 05 00
28xx: 70 A0 06 00 78 A0 04 00
28xx: 80 A0 05 00 88 A0 06 00
28xx: 90 A0 04 00 98 A0 05 00
28xx: A0 88 06 00 B0 88 04 00
28xx: B0 88 08 00 A8 88 09 00
28xx: A0 88 0A 00 90 70 08 00
28xx: 88 70 09 00 80 70 0A 00
28xx: 78 70 08 00 70 70 09 00
28xx: 68 60 0A 00 60 58 08 00
28xx: 58 58 09 00 50 58 0A 00
28xx: 48 58 04 00 50 58 05 00
28xx: 58 58 06 00 60 58 04 00
28xx: 68 58 05 00 70 48 06 00
28xx: 78 40 04 00 80 40 05 00
28xx: 88 40 06 00 90 40 04 00
28xx: 98 40 05 00 A0 38 06 00
28xx: A8 30 04 00 B0 28 05 00
28xx: B8 28 06 00 C0 28 04 00
28xx: C8 28 05 00 D0 28 06 00
28xx: D8 28 04 00 E0 28 05 00

28D0: FF ...

MOVE_DINO_X
28E0: 3A 12 83    ld   a,($TICK_NUM)
28E3: E6 03       and  $03
28E5: C0          ret  nz
28E6: 3A 4C 81    ld   a,($DINO_X)
28E9: A7          and  a
28EA: C8          ret  z        ; no dino out, leave
28EB: 47          ld   b,a
28EC: 3A 2E 80    ld   a,($DINO_DIR)
28EF: 80          add  a,b
28F0: 32 4C 81    ld   ($DINO_X),a
28F3: 3A 50 81    ld   a,($DINO_X_LEGS)
28F6: A7          and  a
28F7: C8          ret  z
28F8: 47          ld   b,a
28F9: 3A 2E 80    ld   a,($DINO_DIR)
28FC: 80          add  a,b
28FD: 32 50 81    ld   ($DINO_X_LEGS),a
2900: C9          ret

    ;;
2901: 21 00 02    ld   hl,$0200
2904: CD E3 01    call $CALL_HL_PLUS_4K
2907: CD 10 11    call $MYSTERY_8066_FN
290A: 21 20 02    ld   hl,$POST_DEATH_RESET
290D: CD E3 01    call $CALL_HL_PLUS_4K
2910: 21 40 02    ld   hl,$0240
2913: CD E3 01    call $CALL_HL_PLUS_4K
2916: CD 10 11    call $MYSTERY_8066_FN
2919: 21 40 08    ld   hl,$DRAW_SCREEN
291C: 18 22       jr   $CALL_MYSTERY_8066_FN

291E: FF FF

    ;;
SET_DINO_DIR
2920: 23          inc  hl
2921: 23          inc  hl
2922: 46          ld   b,(hl)   ; read DINO_PATH_X
2923: 3A 4C 81    ld   a,($DINO_X)
2926: 37          scf
2927: 3F          ccf
2928: 90          sub  b
2929: 38 04       jr   c,$292F  ; reset
292B: 3E FF       ld   a,$FF
292D: 18 02       jr   $2931
292F: 3E 01       ld   a,$01
2931: 32 2E 80    ld   ($DINO_DIR),a
2934: C9          ret

2935: FF ...

CALL_MYSTERY_8066_FN
2940: CD E3 01    call $CALL_HL_PLUS_4K
2943: CD 10 11    call $MYSTERY_8066_FN
2946: C9          ret

2947: FF ...

SAVE_IX_AND_?
2960: DD E5       push ix
2962: CD 01 29    call $2901
2965: DD E1       pop  ix
2967: C9          ret

2968: FF ...

GOT_A_BONUS
2980: 3A 60 80    ld   a,($BONUSES)
2983: 3C          inc  a
2984: 32 60 80    ld   ($BONUSES),a
2987: FE 01       cp   $01
2989: 20 06       jr   nz,$2991
298B: 3E F2       ld   a,$F2
298D: 32 4B 93    ld   ($934B),a ; uncovering bonus red squares
2990: C9          ret
2991: FE 02       cp   $02
2993: 20 06       jr   nz,$299B
2995: 3E F3       ld   a,$F3
2997: 32 4C 93    ld   ($934C),a
299A: C9          ret
299B: FE 03       cp   $03
299D: 20 06       jr   nz,$29A5
299F: 3E EA       ld   a,$EA
29A1: 32 6B 93    ld   ($936B),a
29A4: C9          ret
29A5: FE 04       cp   $04
29A7: 20 06       jr   nz,$29AF
29A9: 3E EB       ld   a,$EB
29AB: 32 6C 93    ld   ($936C),a
29AE: C9          ret
29AF: FE 05       cp   $05
29B1: 20 0D       jr   nz,$29C0
29B3: 3A 62 80    ld   a,($BONUS_MULT)
29B6: 21 78 16    ld   hl,$1678
29B9: 85          add  a,l
29BA: 6F          ld   l,a
29BB: 7E          ld   a,(hl)
29BC: 32 8B 93    ld   ($938B),a
29BF: C9          ret
    ;; 6 Bonuses got!
29C0: 3A 62 80    ld   a,($BONUS_MULT)
29C3: 21 7C 16    ld   hl,$167C
29C6: 85          add  a,l
29C7: 6F          ld   l,a
29C8: 7E          ld   a,(hl)
29C9: 32 8C 93    ld   ($938C),a
29CC: CD D0 3F    call $3FD0
29CF: 0E 0A       ld   c,$0A    ; 10x
29D1: 3A 62 80    ld   a,($BONUS_MULT)
29D4: 47          ld   b,a
29D5: 04          inc  b
29D6: 3E A0       ld   a,$A0    ; 1000 in bdc
29D8: 32 1D 80    ld   ($SCORE_TO_ADD),a
29DB: C5          push bc
29DC: CD 00 17    call $ADD_SCORE
29DF: C1          pop  bc
29E0: CD EC 24    call $24EC
29E3: 10 F1       djnz $29D6
29E5: 0D          dec  c
29E6: 20 E9       jr   nz,$29D1
29E8: 3A 62 80    ld   a,($BONUS_MULT)
29EB: 3C          inc  a
29EC: FE 04       cp   $04      ; Cap bonus to 4x
29EE: 20 02       jr   nz,$29F2
29F0: 3E 03       ld   a,$03
29F2: 32 62 80    ld   ($BONUS_MULT),a
29F5: AF          xor  a
29F6: 32 60 80    ld   ($BONUSES),a
29F9: CD D0 16    call $DRAW_BONUS
29FC: CD 9C 19    call $BONUS_SKIP_SCREEN
29FF: C9          ret

DINO_PATH_7 ;DATA lookup table x/y/?/?
2A00: 18 E0 00 00 20 E0 01 00
2A08: 28 E0 02 00 30 E0 03 00
2A10: 38 D0 04 00 40 C0 05 00
2A18: 48 B8 06 00 48 B8 04 00
2A20: 50 B8 05 00 58 B8 06 00
2A28: 60 B8 04 00 68 B0 00 00
2A30: 70 B0 01 00 78 B0 02 00
2A38: 80 B0 03 00 88 B8 02 00
2A40: 98 B8 03 00 A8 B8 02 00
2A48: B0 B0 03 00 B8 B0 02 00
2A50: C0 B0 03 00 C8 A0 04 00
2A58: D0 90 05 00 D8 88 06 00
2A60: E0 88 08 00 D0 88 09 00
2A68: D8 80 0A 00 C0 70 08 00
2A70: B8 70 09 00 B0 70 0A 00
2A78: 90 70 08 00 80 70 09 00
2A80: 78 70 0A 00 70 70 08 00
2A88: 68 70 09 00 60 60 0A 00
2A90: 58 58 08 00 50 58 04 00
2A98: 58 58 05 00 60 48 06 00
2AA0: 68 40 04 00 70 40 05 00
2AA8: 78 40 06 00 80 40 04 00
2AB0: 90 40 05 00 B0 40 06 00
2AB8: B8 40 04 00 C0 40 05 00
2AC0: C8 40 06 00 D0 38 04 00
2AC8: D8 30 05 00 E0 28 06 00

DRAW_BONUS_STATE
2AD0: CD D0 16    call $DRAW_BONUS
2AD3: 3A 60 80    ld   a,($BONUSES)
2AD6: 5F          ld   e,a
2AD7: AF          xor  a
2AD8: 32 60 80    ld   ($BONUSES),a
2ADB: 7B          ld   a,e
2ADC: A7          and  a
2ADD: C8          ret  z
2ADE: CD 80 29    call $GOT_A_BONUS ; clear out "got" bonuses
2AE1: 1D          dec  e
2AE2: 20 FA       jr   nz,$2ADE
2AE4: C9          ret

2AE5: FF ...

2B00: 3A 93 80    ld   a,($8093)
2B03: 47          ld   b,a
2B04: AF          xor  a
2B05: 32 93 80    ld   ($8093),a
2B08: 78          ld   a,b
2B09: A7          and  a
2B0A: 20 08       jr   nz,$2B14
2B0C: 3A 94 80    ld   a,($8094)
2B0F: 47          ld   b,a
2B10: AF          xor  a
2B11: 32 94 80    ld   ($8094),a
2B14: C9          ret
2B15: FF ...

2B20: 47          ld   b,a
2B21: E6 F0       and  $F0
2B23: 20 03       jr   nz,$2B28
2B25: AF          xor  a
2B26: 18 12       jr   $2B3A
2B28: FE 10       cp   $10
2B2A: 20 04       jr   nz,$2B30
2B2C: 3E 0A       ld   a,$0A
2B2E: 18 0A       jr   $2B3A
2B30: FE 20       cp   $20
2B32: 20 04       jr   nz,$2B38
2B34: 3E 14       ld   a,$14
2B36: 18 02       jr   $2B3A
2B38: 3E 1E       ld   a,$1E
2B3A: 4F          ld   c,a
2B3B: 78          ld   a,b
2B3C: E6 0F       and  $0F
2B3E: 81          add  a,c
2B3F: C9          ret
2B40: FF ...

;;;
SHADOW_HL_PLUSEQ_4_TIMES_SCR
2B50: 3A 04 80    ld   a,($PLAYER_NUM)
2B53: A7          and  a
2B54: 20 05       jr   nz,$2B5B
2B56: 3A 29 80    ld   a,($SCREEN_NUM)
2B59: 18 03       jr   $2B5E
2B5B: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
2B5E: 3D          dec  a        ; scr#-1
2B5F: CB 27       sla  a        ; * 2
2B61: CB 27       sla  a        ; * 2
2B63: CD 90 13    call $SHADOW_ADD_A_TO_RET
2B66: 00          nop
2B67: 00          nop
2B68: 00          nop
2B69: C9          ret

    ;; some kind of dispatcher - this are subs
2B6A: CD 48 2C    call $2C48
2B6D: C9          ret
2B6E: 00          nop
2B6F: 00          nop
2B70: 00          nop
2B71: C9          ret
2B72: CD 58 2C    call $2C58
2B75: C9          ret
2B76: 00          nop
2B77: 00          nop
2B78: 00          nop
2B79: C9          ret
2B7A: 00          nop
2B7B: 00          nop
2B7C: 00          nop
2B7D: C9          ret
2B7E: 00          nop
2B7F: 00          nop
2B80: 00          nop
2B81: C9          ret
2B82: CD 98 2C    call $2C98
2B85: C9          ret
2B86: CD 68 31    call $3168
2B89: C9          ret
2B8A: CD F0 2B    call $2BF0
2B8D: C9          ret
2B8E: CD 98 33    call $3398
2B91: C9          ret
2B92: CD 70 34    call $3470
2B95: C9          ret
2B96: CD 38 35    call $3538
2B99: C9          ret
2B9A: CD B8 35    call $35B8
2B9D: C9          ret
2B9E: CD 58 36    call $3658
2BA1: C9          ret
2BA2: 00          nop
2BA3: 00          nop
2BA4: 00          nop
2BA5: C9          ret
2BA6: CD 70 36    call $3670
2BA9: C9          ret
2BAA: CD D0 36    call $36D0
2BAD: C9          ret
2BAE: CD 60 37    call $3760
2BB1: C9          ret
2BB2: CD E8 37    call $37E8
2BB5: C9          ret
2BB6: 00          nop
2BB7: 00          nop
2BB8: 00          nop
2BB9: C9          ret
2BBA: CD 08 38    call $3808
2BBD: C9          ret
2BBE: CD 68 38    call $3868
2BC1: C9          ret
2BC2: CD 68 3B    call $3B68
2BC5: C9          ret
2BC6: CD 88 38    call $3888
2BC9: C9          ret
2BCA: CD 18 39    call $3918
2BCD: C9          ret
2BCE: CD 88 38    call $3888
2BD1: C9          ret
2BD2: 00          nop
2BD3: 00          nop
2BD4: 00          nop
2BD5: C9          ret
2BD6: 00          nop
2BD7: 00          nop
2BD8: 00          nop
2BD9: C9          ret
2BDA: 00          nop
2BDB: 00          nop
2BDC: 00          nop
2BDD: C9          ret
2BDE: 00          nop
2BDF: 00          nop
2BE0: 00          nop
2BE1: C9          ret
2BE2: 00          nop
2BE3: 00          nop
2BE4: 00          nop
2BE5: C9          ret

2BE6: FF ...

2BF0: CD D0 32    call $32D0
2BF3: CD F0 32    call $32F0
2BF6: C9          ret

2BF7: FF ...

SET_ROCK_1_B0_40
2C00: 3E B0       ld   a,$B0
2C02: 32 54 81    ld   ($ENEMY_1_X),a
2C05: 3E 40       ld   a,$40
2C07: 32 57 81    ld   ($ENEMY_1_Y),a
2C0A: 3E 1D       ld   a,$1D
2C0C: 32 55 81    ld   ($ENEMY_1_FRAME),a
2C0F: 3E 15       ld   a,$15
2C11: 32 56 81    ld   ($ENEMY_1_COL),a
2C14: 3E 01       ld   a,$01
2C16: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
2C19: C9          ret

2C1A: FF ...

ROCK_FALL_1
2C28: 3A 16 83    ld   a,($TICK_MOD_SLOW)
2C2B: E6 07       and  $07
2C2D: C0          ret  nz
2C2E: 3A 36 80    ld   a,($ROCK_FALL_TIMER)
2C31: 3C          inc  a
2C32: FE 0E       cp   $0E      ; has rock finished falling?
2C34: 20 01       jr   nz,$2C37
2C36: AF          xor  a        ; reset
2C37: 32 36 80    ld   ($ROCK_FALL_TIMER),a
2C3A: A7          and  a
2C3B: C0          ret  nz
2C3C: CD 00 2C    call $SET_ROCK_1_B0_40
2C3F: C9          ret

2C40: FF ...

2C48: CD 28 2C    call $ROCK_FALL_1
2C4B: CD 40 31    call $3140
2C4E: C9          ret

2C4F: FF ...

2C58: CD 28 2C    call $2C28
2C5B: CD 40 31    call $3140
2C5E: CD 38 32    call $3238
2C61: CD 60 32    call $3260
2C64: C9          ret

2C65: FF ...

    ;; maybe entering letters on hiscore? maybe?
2C70: 3A F1 83    ld   a,($INPUT_BUTTONS)
2C73: 47          ld   b,a
2C74: 3A 84 91    ld   a,($9184)
2C77: FE 01       cp   $01
2C79: 28 04       jr   z,$2C7F
2C7B: CB 78       bit  7,b
2C7D: 20 09       jr   nz,$2C88
2C7F: 3A 00 A0    ld   a,($PORT_IN0)
2C82: CB 6F       bit  5,a      ; jump?
2C84: C4 D8 2E    call nz,$2ED8
2C87: C9          ret
2C88: CB 68       bit  5,b      ; jump?
2C8A: C4 D8 2E    call nz,$2ED8
2C8D: C9          ret

2C8E: FF ...

2C98: CD 28 2C    call $2C28
2C9B: CD 40 31    call $3140
2C9E: CD 38 32    call $3238
2CA1: CD 60 32    call $3260
2CA4: CD 70 35    call $3570
2CA7: CD 90 35    call $3590
2CAA: C9          ret

2CAB: FF ...

2CB0: 3A 04 80    ld   a,($PLAYER_NUM)
2CB3: A7          and  a
2CB4: 20 05       jr   nz,$2CBB
2CB6: 3A 29 80    ld   a,($SCREEN_NUM)
2CB9: 18 03       jr   $2CBE
2CBB: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
2CBE: 3D          dec  a        ; scr - 1
2CBF: E6 07       and  $07      ; & 0000 0111
2CC1: CB 27       sla  a        ; * 4
2CC3: CB 27       sla  a
2CC5: CD 90 13    call $SHADOW_ADD_A_TO_RET
2CC8: 00          nop
2CC9: 00          nop
2CCA: 00          nop
2CCB: C9          ret
2CCC: 00          nop
2CCD: 00          nop
2CCE: 00          nop
2CCF: C9          ret
2CD0: 00          nop
2CD1: 00          nop
2CD2: 00          nop
2CD3: C9          ret
2CD4: 00          nop
2CD5: 00          nop
2CD6: 00          nop
2CD7: C9          ret
2CD8: 00          nop
2CD9: 00          nop
2CDA: 00          nop
2CDB: C9          ret
2CDC: 00          nop
2CDD: 00          nop
2CDE: 00          nop
2CDF: C9          ret
2CE0: 00          nop
2CE1: 00          nop
2CE2: 00          nop
2CE3: C9          ret
2CE4: 00          nop
2CE5: 00          nop
2CE6: 00          nop
2CE7: C9          ret
2CE8: 00          nop
2CE9: 00          nop
2CEA: 00          nop
2CEB: C9          ret
2CEC: 00          nop
2CED: 00          nop
2CEE: 00          nop
2CEF: C9          ret

2CF0: FF ...
    
    ;; HiScore somthing
2D00: 21 00 83    ld   hl,$HISCORE
2D03: 3A 14 80    ld   a,($P1_SCORE)
2D06: BE          cp   (hl)
2D07: 20 14       jr   nz,$2D1D
2D09: 23          inc  hl
2D0A: 3A 15 80    ld   a,($P1_SCORE+1)
2D0D: BE          cp   (hl)
2D0E: 20 0D       jr   nz,$2D1D
2D10: 23          inc  hl
2D11: 3A 16 80    ld   a,($P1_SCORE+2)
2D14: BE          cp   (hl)
2D15: 20 06       jr   nz,$2D1D
2D17: CD 48 2D    call $2D48    ; p1 got  hiscore
2D1A: C3 E8 03    jp   $03E8
2D1D: 21 00 83    ld   hl,$HISCORE
2D20: 3A 17 80    ld   a,($P2_SCORE)
2D23: BE          cp   (hl)
2D24: 20 F4       jr   nz,$2D1A
2D26: 23          inc  hl
2D27: 3A 18 80    ld   a,($P2_SCORE+1)
2D2A: BE          cp   (hl)
2D2B: 20 ED       jr   nz,$2D1A
2D2D: 23          inc  hl
2D2E: 3A 19 80    ld   a,($P2_SCORE+2)
2D31: BE          cp   (hl)
2D32: 20 E6       jr   nz,$2D1A
2D34: CD 58 2D    call $2D58    ; p2 got hiscore
2D37: C3 E8 03    jp   $03E8
    
2D3A: FF ...

P1_GOT_HISCORE
2D48: AF          xor  a
2D49: 32 06 B0    ld   ($B006),a
2D4C: 32 07 B0    ld   ($B007),a
2D4F: 3E 01       ld   a,$01
2D51: CD 88 2D    call $ENTER_HISCORE_SCREEN
2D54: C9          ret
2D55: FF ...

P2_GOT_HISCORE
2D58: 3A F1 83    ld   a,($INPUT_BUTTONS)
2D5B: CB 7F       bit  7,a      ; hmm what is bit 7 button?
2D5D: 28 0A       jr   z,$2D69
2D5F: 3E 01       ld   a,$01
2D61: 32 06 B0    ld   ($B006),a
2D64: 32 07 B0    ld   ($B007),a
2D67: 18 07       jr   $2D70
2D69: AF          xor  a
2D6A: 32 06 B0    ld   ($B006),a
2D6D: 32 07 B0    ld   ($B007),a
2D70: 3E 02       ld   a,$02
2D72: CD 88 2D    call $ENTER_HISCORE_SCREEN
2D75: C9          ret
    
2D76: FF ...

ENTER_HISCORE_SCREEN
2D88: F5          push af
2D89: 21 E8 16    ld   hl,$16E8
2D8C: CD E3 01    call $CALL_HL_PLUS_4K
2D8F: 3E 09       ld   a,$09    ; extra life /hiscore sfx
2D91: 32 42 80    ld   ($CH1_SFX),a
2D94: 00          nop
2D95: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
2D98: CD B8 37    call $37B8
2D9B: 21 E0 0F    ld   hl,$0FE0
2D9E: CD 40 08    call $DRAW_SCREEN ; draws the hiscore screen..
2DA1: 00 00                         ; params to DRAW_SCREEN
2DA3: CD 10 03    call $DRAW_TILES_H
2DA6: 04 0A
2DA8: 20 1C 11 29 15 22 FF      ; PLAYER
2DAF: CD 10 03    call $DRAW_TILES_H
2DB2: 07 03
2DB4: 29 1F 25 10 12 15 11 24 10 24 18 15 10 18 19 17
2DC4: 18 15 23 24 FF            ; YOU BEAT THE HIGHEST
2DC9: CD 10 03    call $DRAW_TILES_H
2DCC: 09 03                     ; SCORE OF THE DAY
2DCE: 23 13 1F 22 15 10 1F 16 10 24 18 15 10 14 11 29 FF
2DDF: CD 10 03    call $DRAW_TILES_H
2DE2: 0B 03
2DE4: 20 1C 15 11 23 15 10 15 1E 24 15 22 10 29 1F 25
2DF4: 22 10 1E 11 1D 15 FF
2DFB: CD 10 03    call $DRAW_TILES_H
2DFE: 0D 03          inc  bc
    ;; drawing the alphabet A-L
2E00: 11 10 12 10 13 10 14 10 15 10 16 10 17 10 18 10 19
2E11: 10 1A 10 1B 10 1C FF
2E18: CD 10 03    call $DRAW_TILES_H
2E1B: 0F 03
    ;; drawing the alphabet M-X
2E1D: 1D 10 1E 10 1F 10 20 10 21 10 22 10 23 10 24 10 25
2E2E: 10 26 10 27 10 28 FF
2E35: CD 10 03    call $DRAW_TILES_H
2E38: 11 03
    ;; Y,Z... characters
2E3A: 29 10 2A 10 10 10 10 10 10 10 51 10 52 10 53 10 10
2E4B: 10 10 10 58 59 5A 5B FF
2E53: CD 10 03    call $DRAW_TILES_H
2E56: 17 0A
2E58: 2B 2B 2B 2B 2B 2B 2B 2B 2B 2B FF
2E63: CD 50 24    call $DRAW_SCORE
2E66: 3E 09       ld   a,$09
2E68: 32 82 93    ld   ($9382),a
2E6B: AF          xor  a
2E6C: 32 62 93    ld   ($9362),a
2E6F: 32 75 80    ld   ($8075),a
2E72: F1          pop  af
2E73: FD 21 77 92 ld   iy,$9277
2E77: 32 84 91    ld   ($9184),a
2E7A: CD 88 2F    call $2F88
2E7D: 21 4E 93    ld   hl,$934E
2E80: 36 89       ld   (hl),$89
2E82: DD 21 F1 83 ld   ix,$INPUT_BUTTONS
2E86: 3A 84 91    ld   a,($9184)
2E89: FE 01       cp   $01
2E8B: 28 06       jr   z,$2E93
2E8D: DD CB 00 7E bit  7,(ix+$00)
2E91: 20 04       jr   nz,$2E97
2E93: DD 21 00 A0 ld   ix,$PORT_IN0
2E97: DD CB 00 5E bit  3,(ix+$00)
2E9B: 28 03       jr   z,$2EA0
2E9D: CD A8 2F    call $2FA8
2EA0: DD CB 00 56 bit  2,(ix+$00)
2EA4: 28 03       jr   z,$2EA9
2EA6: CD 50 2F    call $2F50
2EA9: CD 70 2C    call $2C70
2EAC: 00          nop
2EAD: 00          nop
2EAE: 00          nop
2EAF: 00          nop
2EB0: 00          nop
2EB1: 00          nop
2EB2: E5          push hl
2EB3: FD E5       push iy
2EB5: E1          pop  hl
2EB6: 3E 37       ld   a,$37
2EB8: BD          cp   l
2EB9: 20 05       jr   nz,$2EC0
2EBB: 3E 91       ld   a,$91
2EBD: BC          cp   h
2EBE: 28 08       jr   z,$2EC8
2EC0: E1          pop  hl
2EC1: 36 89       ld   (hl),$89
2EC3: CD 08 31    call $3108
2EC6: 18 B8       jr   $2E80
2EC8: E1          pop  hl
2EC9: CD 10 2F    call $THINGS_THEN_COPY_HISCORE_NAME
2ECC: C9          ret
2ECD: FF ...

2ED8: 3E 10       ld   a,$10
2EDA: 32 93 80    ld   ($8093),a
2EDD: 3E 90       ld   a,$90
2EDF: BC          cp   h
2EE0: 20 12       jr   nz,$2EF4
2EE2: 3E 92       ld   a,$92
2EE4: BD          cp   l
2EE5: 20 04       jr   nz,$2EEB
2EE7: CD 10 2F    call $THINGS_THEN_COPY_HISCORE_NAME
2EEA: C9          ret
2EEB: 3E D2       ld   a,$D2
2EED: BD          cp   l
2EEE: 20 04       jr   nz,$2EF4
2EF0: CD 20 2F    call $2F20
2EF3: C9          ret
2EF4: 2B          dec  hl
2EF5: 7E          ld   a,(hl)
2EF6: 23          inc  hl
2EF7: FD 77 00    ld   (iy+$00),a
2EFA: 11 E0 FF    ld   de,$FFE0
2EFD: FD 19       add  iy,de
2EFF: C9          ret

2F00: FF ...

THINGS_THEN_COPY_HISCORE_NAME
2F10: AF          xor  a
2F11: 32 86 80    ld   ($8086),a
2F14: E1          pop  hl
2F15: E1          pop  hl
2F16: CD E0 2F    call $COPY_HISCORE_NAME_TO_SCREEN
2F19: C9          ret

2F1A: FF ...

2F20: 11 20 00    ld   de,$0020
2F23: FD 19       add  iy,de
2F25: FD 36 00 2B ld   (iy+$00),$2B
2F29: 3E 10       ld   a,$10
2F2B: 32 97 92    ld   ($9297),a
2F2E: E5          push hl
2F2F: FD E5       push iy
2F31: E1          pop  hl
2F32: 3E 92       ld   a,$92
2F34: BC          cp   h
2F35: 20 05       jr   nz,$2F3C
2F37: 3E 97       ld   a,$97
2F39: BD          cp   l
2F3A: 28 02       jr   z,$2F3E
2F3C: E1          pop  hl
2F3D: C9          ret
2F3E: 11 E0 FF    ld   de,$FFE0
2F41: FD 19       add  iy,de
2F43: E1          pop  hl
2F44: C9          ret

2F45: FF ...

2F50: 36 10       ld   (hl),$10
2F52: 11 40 00    ld   de,$0040
2F55: 19          add  hl,de
2F56: 3E 93       ld   a,$93
2F58: BC          cp   h
2F59: C0          ret  nz
2F5A: 3E 92       ld   a,$92
2F5C: BD          cp   l
2F5D: 20 04       jr   nz,$2F63
2F5F: 21 90 90    ld   hl,$9090 ; screen somewhere
2F62: C9          ret
2F63: 3E 90       ld   a,$90
2F65: BD          cp   l
2F66: 20 04       jr   nz,$2F6C
2F68: 21 8E 90    ld   hl,$908E
2F6B: C9          ret
2F6C: 3E 8E       ld   a,$8E
2F6E: BD          cp   l
2F6F: C0          ret  nz
2F70: 21 92 90    ld   hl,$9092
2F73: C9          ret

2F74: FF ...

2F88: E5          push hl
2F89: 21 07 83    ld   hl,$HISCORE_NAME ; default is "HI-SCORE", clearing...
2F8C: 36 10       ld   (hl),$TILE_BLANK
2F8E: 23          inc  hl
2F8F: 7D          ld   a,l
2F90: FE 11       cp   $11
2F92: 20 F8       jr   nz,$2F8C
2F94: E1          pop  hl
2F95: C9          ret
2F96: FF          rst  $38
2F97: FF          rst  $38
2F98: FF          rst  $38
2F99: 1F          rra
2F9A: FF ...

2FA8: 3E 10       ld   a,$10
2FAA: 32 93 80    ld   ($8093),a
2FAD: 36 10       ld   (hl),$10
2FAF: 11 40 00    ld   de,$0040
2FB2: ED 52       sbc  hl,de
2FB4: 3E 90       ld   a,$90
2FB6: BC          cp   h
2FB7: C0          ret  nz
2FB8: 3E 4E       ld   a,$4E
2FBA: BD          cp   l
2FBB: 20 04       jr   nz,$2FC1
2FBD: 21 50 93    ld   hl,$9350
2FC0: C9          ret
2FC1: 3E 50       ld   a,$50
2FC3: BD          cp   l
2FC4: 20 04       jr   nz,$2FCA
2FC6: 21 52 93    ld   hl,$9352
2FC9: C9          ret
2FCA: 3E 52       ld   a,$52
2FCC: BD          cp   l
2FCD: C0          ret  nz
2FCE: 21 4E 93    ld   hl,$934E
2FD1: C9          ret
2FD2: FF ...

2FD5: CD 38 30    call $COPY_HISCORE_NAME_TO_SCREEN_2
2FD8: CD E0 24    call $DELAY_60_VBLANKS
2FDB: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
2FDE: C9          ret

2FDF: FF          rst  $38

COPY_HISCORE_NAME_TO_SCREEN
2FE0: 21 07 83    ld   hl,$HISCORE_NAME
2FE3: 3A 77 92    ld   a,($9277)
2FE6: 77          ld   (hl),a
2FE7: 3A 57 92    ld   a,($9257)
2FEA: 23          inc  hl
2FEB: 77          ld   (hl),a
2FEC: 3A 37 92    ld   a,($9237)
2FEF: 23          inc  hl
2FF0: 77          ld   (hl),a
2FF1: 3A 17 92    ld   a,($9217)
2FF4: 23          inc  hl
2FF5: 77          ld   (hl),a
2FF6: 3A F7 91    ld   a,($91F7)
2FF9: 23          inc  hl
2FFA: 77          ld   (hl),a
2FFB: 3A D7 91    ld   a,($91D7)
2FFE: 23          inc  hl
2FFF: 77          ld   (hl),a
3000: 3A B7 91    ld   a,($91B7)
3003: 23          inc  hl
3004: 77          ld   (hl),a
3005: 3A 97 91    ld   a,($9197)
3008: 23          inc  hl
3009: 77          ld   (hl),a
300A: 3A 77 91    ld   a,($9177)
300D: 23          inc  hl
300E: 77          ld   (hl),a
300F: 3A 57 91    ld   a,($9157)
3012: 23          inc  hl
3013: 77          ld   (hl),a
3014: CD C0 30    call $30C0
3017: CD D5 2F    call $2FD5
301A: C3 E8 03    jp   $03E8
301D: FF          rst  $38
301E: FF          rst  $38
301F: FF          rst  $38
3020: 0E 05       ld   c,$05
3022: CD A0 13    call $WAIT_VBLANK
3025: 0D          dec  c
3026: 20 FA       jr   nz,$3022
3028: C9          ret

3029: FF ...

    ;; writes some chars to screen
    ;; actually - different screen loc than copy_msg 1!
COPY_HISCORE_NAME_TO_SCREEN_2
3038: 3A 07 83    ld   a,($HISCORE_NAME)
303B: 32 80 92    ld   ($9280),a
303E: 3A 08 83    ld   a,($HISCORE_NAME+1)
3041: 32 60 92    ld   ($9260),a
3044: 3A 09 83    ld   a,($HISCORE_NAME+2)
3047: 32 40 92    ld   ($9240),a
304A: 3A 0A 83    ld   a,($HISCORE_NAME+3)
304D: 32 20 92    ld   ($9220),a
3050: 3A 0B 83    ld   a,($HISCORE_NAME+4)
3053: 32 00 92    ld   ($9200),a
3056: 3A 0C 83    ld   a,($HISCORE_NAME+5)
3059: 32 E0 91    ld   ($91E0),a
305C: 3A 0D 83    ld   a,($HISCORE_NAME+6)
305F: 32 C0 91    ld   ($91C0),a
3062: 3A 0E 83    ld   a,($HISCORE_NAME+7)
3065: 32 A0 91    ld   ($91A0),a
3068: 3A 0F 83    ld   a,($HISCORE_NAME+8)
306B: 32 80 91    ld   ($9180),a
306E: 3A 10 83    ld   a,($HISCORE_NAME+9)
3071: 32 60 91    ld   ($9160),a
3074: C9          ret

3075: FF ...

    ;; Writes HIGH-SCORE to bytes (later to screen)
SET_HISCORE_TEXT
3080: 21 07 83    ld   hl,$HISCORE_NAME
3083: 36 18       ld   (hl),$18 ; h
3085: 23          inc  hl
3086: 36 19       ld   (hl),$19 ; i
3088: 23          inc  hl
3089: 36 17       ld   (hl),$17 ; g
308B: 23          inc  hl
308C: 36 18       ld   (hl),$18 ; h
308E: 23          inc  hl
308F: 36 2B       ld   (hl),$TILE_HYPHEN
3091: 23          inc  hl
3092: 36 23       ld   (hl),$23 ; s
3094: 23          inc  hl
3095: 36 13       ld   (hl),$13 ; c
3097: 23          inc  hl
3098: 36 1F       ld   (hl),$1F ; o
309A: 23          inc  hl
309B: 36 22       ld   (hl),$22 ; r
309D: 23          inc  hl
309E: 36 15       ld   (hl),$15 ; e
    ;; set default hiscore
30A0: 21 00 83    ld   hl,$HISCORE
30A3: 36 00       ld   (hl),$TILE_0
30A5: 23          inc  hl
30A6: 36 05       ld   (hl),$05
30A8: 23          inc  hl
30A9: 36 00       ld   (hl),$TILE_0
30AB: 23          inc  hl
30AC: C9          ret

30AD: FF ...

30C0: 0E 00       ld   c,$00
30C2: 21 10 83    ld   hl,$8310
30C5: 7E          ld   a,(hl)
30C6: FE 2B       cp   $2B
30C8: 20 0E       jr   nz,$30D8
30CA: 36 10       ld   (hl),$10
30CC: 2B          dec  hl
30CD: 7E          ld   a,(hl)
30CE: FE 2B       cp   $2B
30D0: 20 06       jr   nz,$30D8
30D2: 36 10       ld   (hl),$10
30D4: 2B          dec  hl
30D5: 0C          inc  c
30D6: 18 ED       jr   $30C5
30D8: 79          ld   a,c
30D9: A7          and  a
30DA: C8          ret  z
30DB: 0D          dec  c
30DC: CD E8 30    call $30E8
30DF: 18 F7       jr   $30D8

30E1: FF ...

30E8: 16 0A       ld   d,$0A
30EA: DD 21 0F 83 ld   ix,$830F
30EE: DD 7E 00    ld   a,(ix+$00)
30F1: DD 77 01    ld   (ix+$01),a
30F4: 15          dec  d
30F5: DD 2B       dec  ix
30F7: 20 F5       jr   nz,$30EE
30F9: 3E 10       ld   a,$TILE_BLANK
30FB: 32 07 83    ld   ($HISCORE_NAME),a
30FE: C9          ret

30FF: FF ...

3108: E5          push hl
3109: C5          push bc
310A: FD E5       push iy
310C: DD E5       push ix
310E: 0E 14       ld   c,$14
3110: CD A0 13    call $WAIT_VBLANK
3113: 0D          dec  c
3114: 20 FA       jr   nz,$3110
3116: 3A 76 80    ld   a,($8076)
3119: 3C          inc  a
311A: 32 76 80    ld   ($8076),a
311D: E6 01       and  $01
311F: 28 14       jr   z,$3135
3121: 21 75 80    ld   hl,$8075
3124: 7E          ld   a,(hl)
3125: 3D          dec  a
3126: 27          daa
3127: CC 10 2F    call z,$THINGS_THEN_COPY_HISCORE_NAME
312A: 77          ld   (hl),a
312B: AF          xor  a
312C: ED 6F       rld  (hl)
312E: 32 82 93    ld   ($9382),a
3131: ED 6F       rld  (hl)
3133: 32 62 93    ld   ($9362),a
3136: ED 6F       rld  (hl)
3138: DD E1       pop  ix
313A: FD E1       pop  iy
313C: C1          pop  bc
313D: E1          pop  hl
313E: C9          ret
313F: FF          rst  $38
   ; load rock pos (reset rock pos?)
3140: 3A 37 80    ld   a,($ENEMY_1_ACTIVE)
3143: A7          and  a
3144: C8          ret  z        ; enemy not alive, return
    ;;  Move rock down screen
3145: 3C          inc  a
3146: FE 3C       cp   $3C
3148: 20 01       jr   nz,$314B
314A: AF          xor  a
314B: 32 37 80    ld   ($ENEMY_1_ACTIVE),a

314E: 21 80 31    ld   hl,$ENEMY_LOOKUP
3151: CB 27       sla  a
3153: 85          add  a,l
3154: 6F          ld   l,a
3155: 7E          ld   a,(hl)
3156: 32 55 81    ld   ($ENEMY_1_FRAME),a
3159: 23          inc  hl
315A: 7E          ld   a,(hl)
315B: 32 57 81    ld   ($ENEMY_1_Y),a
315E: C9          ret

315F: FF ...

3168: CD 28 2C    call $2C28
316B: CD 40 31    call $3140
316E: C9          ret

316F: FF ...

ENEMY_LOOKUP                     ; (maybe... or all ents?)
3180: 00 00
3182: 1D          dec  e
3183: 52          ld   d,d
3184: 1D          dec  e
3185: 54          ld   d,h
3186: 1D          dec  e
3187: 56          ld   d,(hl)
3188: 1D          dec  e
3189: 58          ld   e,b
318A: 1D          dec  e
318B: 5A          ld   e,d
318C: 1D          dec  e
318D: 5C          ld   e,h
318E: 1D          dec  e
318F: 5E          ld   e,(hl)
3190: 1D          dec  e
3191: 60          ld   h,b
3192: 1D          dec  e
3193: 62          ld   h,d
3194: 1D          dec  e
3195: 64          ld   h,h
3196: 1D          dec  e
3197: 66          ld   h,(hl)
3198: 1D          dec  e
3199: 68          ld   l,b
319A: 1D          dec  e
319B: 6A          ld   l,d
319C: 1D          dec  e
319D: 6C          ld   l,h
319E: 1D          dec  e
319F: 6E          ld   l,(hl)
31A0: 1D          dec  e
31A1: 71          ld   (hl),c
31A2: 1D          dec  e
31A3: 73          ld   (hl),e
31A4: 1D          dec  e
31A5: 75          ld   (hl),l
31A6: 1D          dec  e
31A7: 78          ld   a,b
31A8: 1D          dec  e
31A9: 7A          ld   a,d
31AA: 1D          dec  e
31AB: 7C          ld   a,h
31AC: 1D          dec  e
31AD: 7F          ld   a,a
31AE: 1D          dec  e
31AF: 81          add  a,c
31B0: 1D          dec  e
31B1: 83          add  a,e
31B2: 1D          dec  e
31B3: 86          add  a,(hl)
31B4: 1D          dec  e
31B5: 88          adc  a,b
31B6: 1D          dec  e
31B7: 8A          adc  a,d
31B8: 1D          dec  e
31B9: 8D          adc  a,l
31BA: 1D          dec  e
31BB: 8F          adc  a,a
31BC: 1D          dec  e
31BD: 91          sub  c
31BE: 1D          dec  e
31BF: 94          sub  h
31C0: 1D          dec  e
31C1: 96          sub  (hl)
31C2: 1D          dec  e
31C3: 98          sbc  a,b
31C4: 1D          dec  e
31C5: 9B          sbc  a,e
31C6: 1D          dec  e
31C7: 9D          sbc  a,l
31C8: 1D          dec  e
31C9: 9F          sbc  a,a
31CA: 1D          dec  e
31CB: A2          and  d
31CC: 1D          dec  e
31CD: A4          and  h
31CE: 1D          dec  e
31CF: A6          and  (hl)
31D0: 1D          dec  e
31D1: AB          xor  e
31D2: 1D          dec  e
31D3: AD          xor  l
31D4: 1D          dec  e
31D5: AF          xor  a
31D6: 1D          dec  e
31D7: B2          or   d
31D8: 1D          dec  e
31D9: B4          or   h
31DA: 1D          dec  e
31DB: B6          or   (hl)
31DC: 1D          dec  e
31DD: B9          cp   c
31DE: 1D          dec  e
31DF: BB          cp   e
31E0: 1D          dec  e
31E1: BD          cp   l
31E2: 1D          dec  e
31E3: C0          ret  nz
31E4: 1D          dec  e
31E5: C2 1D C4    jp   nz,$C41D
31E8: 1D          dec  e
31E9: C6 1D       add  a,$1D
31EB: C8          ret  z
31EC: 1D          dec  e
31ED: CA 1D CC    jp   z,$CC1D
31F0: 1D          dec  e
31F1: CE 1E       adc  a,$1E
31F3: CE 1F       adc  a,$1F
31F5: CE 20       adc  a,$20
31F7: CE 21       adc  a,$21
31F9: CE 21       adc  a,$21
31FB: CE 21       adc  a,$21
31FD: CE FF       adc  a,$FF
31FF: FF          rst  $38
3200: FF          rst  $38
3201: FF          rst  $38
3202: FF          rst  $38
3203: FF          rst  $38
3204: FF          rst  $38
3205: FF          rst  $38
3206: FF          rst  $38
3207: FF          rst  $38
3208: FF          rst  $38
3209: FF          rst  $38
320A: FF          rst  $38
320B: FF          rst  $38
320C: FF          rst  $38
320D: FF          rst  $38
320E: FF          rst  $38
320F: FF          rst  $38

3210: 3E F0       ld   a,$F0
3212: 32 58 81    ld   ($ENEMY_2_X),a
3215: 3E C4       ld   a,$C4
3217: 32 5B 81    ld   ($ENEMY_2_Y),a
321A: 3E 23       ld   a,$23
321C: 32 59 81    ld   ($ENEMY_2_FRAME),a
321F: 3E 16       ld   a,$16
3221: 32 5A 81    ld   ($ENEMY_2_COL),a
3224: 3E 01       ld   a,$01
3226: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3229: C9          ret
322A: FF ...

3238: 3A 58 81    ld   a,($ENEMY_2_X)
323B: A7          and  a
323C: 28 0F       jr   z,$324D
323E: FE 01       cp   $01
3240: 28 0B       jr   z,$324D
3242: FE 02       cp   $02
3244: 28 07       jr   z,$324D
3246: FE 03       cp   $03
3248: 28 03       jr   z,$324D
324A: FE 04       cp   $04
324C: C0          ret  nz
324D: CD 10 32    call $3210
3250: C9          ret
3251: FF ...

3260: 3A 15 83    ld   a,($TICK_MOD_FAST)
3263: E6 01       and  $01
3265: C8          ret  z
3266: 3A 39 80    ld   a,($ENEMY_2_ACTIVE)
3269: A7          and  a
326A: C8          ret  z
326B: 3A 58 81    ld   a,($ENEMY_2_X) ; move left
326E: 3D          dec  a
326F: 3D          dec  a
3270: 3D          dec  a
3271: 32 58 81    ld   ($ENEMY_2_X),a
3274: 3A 15 83    ld   a,($TICK_MOD_FAST)
3277: E6 02       and  $02
3279: C0          ret  nz
327A: 3A 59 81    ld   a,($ENEMY_2_FRAME)
327D: FE 23       cp   $23
327F: 20 06       jr   nz,$3287
3281: 3E 24       ld   a,$24
3283: 32 59 81    ld   ($ENEMY_2_FRAME),a
3286: C9          ret
3287: 3E 23       ld   a,$23
3289: 32 59 81    ld   ($ENEMY_2_FRAME),a
328C: C9          ret
328D: FF ...

32B0: 3E A0       ld   a,$A0
32B2: 32 54 81    ld   ($ENEMY_1_X),a
32B5: 3E D0       ld   a,$D0
32B7: 32 57 81    ld   ($ENEMY_1_Y),a
32BA: 3E 17       ld   a,$17
32BC: 32 56 81    ld   ($ENEMY_1_COL),a
32BF: 3E 34       ld   a,$34
32C1: 32 55 81    ld   ($ENEMY_1_FRAME),a
32C4: 3E 01       ld   a,$01
32C6: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a ; why enemy_3?
32C9: C9          ret
32CA: FF ...

32D0: 3A 12 83    ld   a,($TICK_NUM)
32D3: E6 03       and  $03
32D5: C0          ret  nz
32D6: 3A 3A 80    ld   a,($803A)
32D9: 3C          inc  a
32DA: FE 20       cp   $20
32DC: 20 01       jr   nz,$32DF
32DE: AF          xor  a
32DF: 32 3A 80    ld   ($803A),a
32E2: A7          and  a
32E3: C0          ret  nz
32E4: CD B0 32    call $32B0
32E7: C9          ret
32E8: FF ...

32F0: 3A 3B 80    ld   a,($ENEMY_3_ACTIVE)
32F3: A7          and  a
32F4: C8          ret  z
32F5: 3C          inc  a
32F6: FE 81       cp   $81
32F8: 20 01       jr   nz,$32FB
32FA: AF          xor  a
32FB: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
32FE: 47          ld   b,a
32FF: 37          scf
3300: 3F          ccf
3301: D6 40       sub  $40
3303: 30 04       jr   nc,$3309
3305: CD 18 33    call $3318
3308: C9          ret
3309: CD 40 33    call $3340
330C: C9          ret
330D: FF ...

    ;; blue-meanie up?
3318: 3A 57 81    ld   a,($ENEMY_1_Y) ; move up?
331B: 3D          dec  a
331C: 3D          dec  a
331D: 32 57 81    ld   ($ENEMY_1_Y),a
3320: E6 03       and  $03
3322: C0          ret  nz
3323: 3A 55 81    ld   a,($ENEMY_1_FRAME)
3326: FE 34       cp   $34
3328: 28 06       jr   z,$3330
332A: 3E 34       ld   a,$34
332C: 32 55 81    ld   ($ENEMY_1_FRAME),a
332F: C9          ret
3330: 3E 35       ld   a,$35
3332: 32 55 81    ld   ($ENEMY_1_FRAME),a
3335: C9          ret
3336: FF ...

    ;; blue-meanie down?
3340: 3A 57 81    ld   a,($ENEMY_1_Y) ; move down?
3343: 3C          inc  a
3344: 3C          inc  a
3345: 32 57 81    ld   ($ENEMY_1_Y),a
3348: 3E 34       ld   a,$34
334A: 32 55 81    ld   ($ENEMY_1_FRAME),a
334D: C9          ret
334E: FF ...

3358: 3E F0       ld   a,$F0
335A: 32 58 81    ld   ($ENEMY_2_X),a
335D: 3E 40       ld   a,$40
335F: 32 5B 81    ld   ($ENEMY_2_Y),a
3362: 3E 23       ld   a,$23
3364: 32 59 81    ld   ($ENEMY_2_FRAME),a
3367: 3E 16       ld   a,$16
3369: 32 5A 81    ld   ($ENEMY_2_COL),a
336C: 3E 01       ld   a,$01
336E: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3371: C9          ret
3372: FF ...

3378: 3A 58 81    ld   a,($ENEMY_2_X)
337B: A7          and  a
337C: 28 0F       jr   z,$338D
337E: FE 01       cp   $01
3380: 28 0B       jr   z,$338D
3382: FE 02       cp   $02
3384: 28 07       jr   z,$338D
3386: FE 03       cp   $03
3388: 28 03       jr   z,$338D
338A: FE 04       cp   $04
338C: C0          ret  nz
338D: CD 58 33    call $3358
3390: C9          ret
3391: FF ...

3398: CD 78 33    call $3378
339B: CD 60 32    call $3260
339E: C9          ret
339F: FF ...

33A8: CD D0 32    call $32D0
33AB: CD F0 32    call $32F0
33AE: C9          ret
33AF: FF ...

33B8: 3A 3B 80    ld   a,($ENEMY_3_ACTIVE)
33BB: A7          and  a
33BC: C8          ret  z
33BD: 3C          inc  a
33BE: FE 81       cp   $81
33C0: 20 01       jr   nz,$33C3
33C2: AF          xor  a
33C3: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
33C6: 47          ld   b,a
33C7: 37          scf
33C8: 3F          ccf
33C9: D6 40       sub  $40
33CB: 30 04       jr   nc,$33D1
33CD: CD D8 33    call $33D8
33D0: C9          ret
33D1: CD 00 34    call $3400
33D4: C9          ret
33D5: FF ...

33D8: 3A 57 81    ld   a,($ENEMY_1_Y)
33DB: 3D          dec  a
33DC: 3D          dec  a
33DD: 32 57 81    ld   ($ENEMY_1_Y),a
33E0: E6 03       and  $03
33E2: C0          ret  nz
33E3: 3A 55 81    ld   a,($ENEMY_1_FRAME)
33E6: FE 34       cp   $34
33E8: 20 06       jr   nz,$33F0
33EA: 3E 35       ld   a,$35
33EC: 32 55 81    ld   ($ENEMY_1_FRAME),a
33EF: C9          ret
33F0: 3E 34       ld   a,$34
33F2: 32 55 81    ld   ($ENEMY_1_FRAME),a
33F5: C9          ret
33F6: FF ...

3400: 3A 57 81    ld   a,($ENEMY_1_Y)
3403: 3C          inc  a
3404: 3C          inc  a
3405: 32 57 81    ld   ($ENEMY_1_Y),a
3408: C9          ret
3409: FF ...

3418: 3A 3D 80    ld   a,($803D)
341B: A7          and  a
341C: C8          ret  z
341D: 3C          inc  a
341E: FE 61       cp   $61
3420: 20 01       jr   nz,$3423
3422: AF          xor  a
3423: 32 3D 80    ld   ($803D),a
3426: 47          ld   b,a
3427: 37          scf
3428: 3F          ccf
3429: D6 30       sub  $30
342B: 30 04       jr   nc,$3431
342D: CD 38 34    call $3438
3430: C9          ret
3431: CD 58 34    call $3458
3434: C9          ret
3435: FF ...

3438: 3A 5B 81    ld   a,($ENEMY_2_Y)
343B: 3D          dec  a
343C: 3D          dec  a
343D: 32 5B 81    ld   ($ENEMY_2_Y),a
3440: E6 03       and  $03
3442: C0          ret  nz
3443: 3A 59 81    ld   a,($ENEMY_2_FRAME)
3446: FE 34       cp   $34
3448: 20 06       jr   nz,$3450
344A: 3E 35       ld   a,$35
344C: 32 59 81    ld   ($ENEMY_2_FRAME),a
344F: C9          ret
3450: 3E 34       ld   a,$34
3452: 32 59 81    ld   ($ENEMY_2_FRAME),a
3455: C9          ret

3456: FF FF

3458: 3A 5B 81    ld   a,($ENEMY_2_Y)
345B: 3C          inc  a
345C: 3C          inc  a
345D: 32 5B 81    ld   ($ENEMY_2_Y),a
3460: C9          ret
3461: FF ...

    ;; wats this?
3470: CD B8 33    call $33B8
3473: CD 18 34    call $3418
3476: CD 88 34    call $3488
3479: CD E8 34    call $34E8
347C: C9          ret
347D: FF ...

3488: 3A 12 83    ld   a,($TICK_NUM)
348B: E6 03       and  $03
348D: C0          ret  nz
348E: 3A 3A 80    ld   a,($803A)
3491: 3C          inc  a
3492: FE 20       cp   $20
3494: 20 01       jr   nz,$3497
3496: AF          xor  a
3497: 32 3A 80    ld   ($803A),a
349A: A7          and  a
349B: C0          ret  nz
349C: CD A8 34    call $34A8
349F: C9          ret
34A0: FF ...

34A8: 3E 34       ld   a,$34
34AA: 32 55 81    ld   ($ENEMY_1_FRAME),a
34AD: 3E A4       ld   a,$A4
34AF: 32 54 81    ld   ($ENEMY_1_X),a
34B2: 3E AC       ld   a,$AC
34B4: 32 57 81    ld   ($ENEMY_1_Y),a
34B7: 3E 17       ld   a,$17
34B9: 32 56 81    ld   ($ENEMY_1_COL),a
34BC: 3E 01       ld   a,$01
34BE: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a ; Why set enemy_3?
34C1: C9          ret
34C2: FF ...

34C8: 3E 80       ld   a,$80
34CA: 32 58 81    ld   ($ENEMY_2_X),a
34CD: 3E 7C       ld   a,$7C
34CF: 32 5B 81    ld   ($ENEMY_2_Y),a
34D2: 3E 34       ld   a,$34
34D4: 32 59 81    ld   ($ENEMY_2_FRAME),a
34D7: 3E 17       ld   a,$17
34D9: 32 5A 81    ld   ($ENEMY_2_COL),a
34DC: 3E 01       ld   a,$01
34DE: 32 3D 80    ld   ($803D),a
34E1: C9          ret
34E2: FF ...

34E8: 3A 12 83    ld   a,($TICK_NUM)
34EB: E6 03       and  $03
34ED: C0          ret  nz
34EE: 3A 3C 80    ld   a,($803C)
34F1: 3C          inc  a
34F2: FE 28       cp   $28
34F4: 20 01       jr   nz,$34F7
34F6: AF          xor  a
34F7: 32 3C 80    ld   ($803C),a
34FA: A7          and  a
34FB: C0          ret  nz
34FC: CD C8 34    call $34C8
34FF: C9          ret
3500: FF ...

    ;;  reset a bunch of thing to 255
3510: 3E FF       ld   a,$FF
3512: 32 36 80    ld   ($8036),a
3515: 32 38 80    ld   ($8038),a
3518: 32 3A 80    ld   ($803A),a
351B: 32 3C 80    ld   ($803C),a
351E: 32 3E 80    ld   ($803E),a
3521: 32 40 80    ld   ($8040),a
3524: AF          xor  a
;;;  reset a bunch of things to 0
3525: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3528: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
352B: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
352E: 32 3D 80    ld   ($803D),a
3531: 32 3F 80    ld   ($803F),a
3534: 32 41 80    ld   ($8041),a
3537: C9          ret
3538: CD 38 32    call $3238
353B: CD 60 32    call $3260
353E: CD 28 2C    call $2C28
3541: CD 40 31    call $3140
3547: CD 90 35    call $3590
354A: C9          ret
354B: FF ...

3550: 3E 60       ld   a,$60
3552: 32 5C 81    ld   ($ENEMY_3_X),a
3555: 3E 1D       ld   a,$1D
3557: 32 5D 81    ld   ($ENEMY_3_FRAME),a
355A: 3E 15       ld   a,$15
355C: 32 5E 81    ld   ($ENEMY_3_COL),a
355F: 3E 40       ld   a,$40
3561: 32 5F 81    ld   ($ENEMY_3_Y),a
3564: 3E 01       ld   a,$01
3566: 32 3F 80    ld   ($803F),a
3569: C9          ret
356A: FF ..

3570: 3A 16 83    ld   a,($TICK_MOD_SLOW)
3573: E6 07       and  $07
3575: C0          ret  nz
3576: 3A 3E 80    ld   a,($803E)
3579: 3C          inc  a
357A: FE 14       cp   $14
357C: 20 01       jr   nz,$357F
357E: AF          xor  a
357F: 32 3E 80    ld   ($803E),a
3582: A7          and  a
3583: C0          ret  nz
3584: CD 50 35    call $3550
3587: C9          ret

3588: FF ...

3590: 3A 3F 80    ld   a,($803F)
3593: A7          and  a
3594: C8          ret  z
3595: 3C          inc  a
3596: FE 40       cp   $40
3598: 20 01       jr   nz,$359B
359A: AF          xor  a
359B: 32 3F 80    ld   ($803F),a
359E: 21 80 31    ld   hl,$ENEMY_LOOKUP
35A1: CB 27       sla  a
35A3: 85          add  a,l
35A4: 6F          ld   l,a
35A5: 7E          ld   a,(hl)
35A6: 32 5D 81    ld   ($ENEMY_3_FRAME),a
35A9: 23          inc  hl
35AA: 7E          ld   a,(hl)
35AB: 32 5F 81    ld   ($ENEMY_3_Y),a
35AE: C9          ret
35AF: FF ...

35B8: CD 70 35    call $3570
35BB: CD 90 35    call $3590
35BE: CD 28 2C    call $2C28
35C1: CD 40 31    call $3140
35C4: C9          ret
35C5: FF ...

35D0: 3E 10       ld   a,$10
35D2: 32 5C 81    ld   ($ENEMY_3_X),a
35D5: 3E A3       ld   a,$A3
35D7: 32 5D 81    ld   ($ENEMY_3_FRAME),a
35DA: 3E 16       ld   a,$16
35DC: 32 5E 81    ld   ($ENEMY_3_COL),a
35DF: 3E BC       ld   a,$BC
35E1: 32 5F 81    ld   ($ENEMY_3_Y),a
35E4: 3E 01       ld   a,$01
35E6: 32 41 80    ld   ($8041),a
35E9: C9          ret
35EA: FF ...

35F0: 3A 5C 81    ld   a,($ENEMY_3_X)
35F3: A7          and  a
35F4: 28 0F       jr   z,$3605
35F6: FE 01       cp   $01
35F8: 28 0B       jr   z,$3605
35FA: FE 02       cp   $02
35FC: 28 07       jr   z,$3605
35FE: FE 03       cp   $03
3600: 28 03       jr   z,$3605
3602: FE 04       cp   $04
3604: C0          ret  nz
3605: CD D0 35    call $35D0
3608: C9          ret
3609: FF ...

UPDATE_ENEMY_3
3610: 3A 15 83    ld   a,($TICK_MOD_FAST)
3613: E6 01       and  $01
3615: C8          ret  z
3616: 3A 41 80    ld   a,($8041)
3619: A7          and  a
361A: C8          ret  z
361B: 3A 5C 81    ld   a,($ENEMY_3_X) ; move right
361E: 3C          inc  a
361F: 3C          inc  a
3620: 3C          inc  a
3621: 32 5C 81    ld   ($ENEMY_3_X),a
3624: 3A 15 83    ld   a,($TICK_MOD_FAST)
3627: E6 02       and  $02
3629: C0          ret  nz
362A: 3A 5D 81    ld   a,($ENEMY_3_FRAME)
362D: FE A3       cp   $A3
362F: 20 06       jr   nz,$3637
3631: 3E A4       ld   a,$A4
3633: 32 5D 81    ld   ($ENEMY_3_FRAME),a
3636: C9          ret
3637: 3E A3       ld   a,$A3
3639: 32 5D 81    ld   ($ENEMY_3_FRAME),a
363C: C9          ret
363D: FF ...

CHECK_BUTTONS_FOR_SOMETHING
3640: C5          push bc
3641: 3A F1 83    ld   a,($INPUT_BUTTONS)
3644: E6 3F       and  $3F      ; 0011 1111
3646: 4F          ld   c,a
3647: 3E 0E       ld   a,$0E
3649: D3 00       out  ($00),a
364B: DB 02       in   a,($02)
364D: 32 F2 83    ld   ($INPUT_BUTTONS_2),a
3650: E6 C0       and  $C0
3652: 81          add  a,c
3653: 32 F1 83    ld   ($INPUT_BUTTONS),a
3656: C1          pop  bc
3657: C9          ret

3658: CD F0 35    call $35F0
365B: CD 10 36    call $UPDATE_ENEMY_3
365E: CD 38 32    call $3238
3661: CD 60 32    call $3260
3664: C9          ret
3665: FF ...

3670: CD B8 33    call $33B8
3673: CD 18 34    call $3418
3676: CD 88 34    call $3488
3679: CD E8 34    call $34E8
367C: CD A8 36    call $36A8
367F: CD 10 36    call $UPDATE_ENEMY_3
3682: C9          ret
3683: FF ...

3688: 3E 10       ld   a,$10
368A: 32 5C 81    ld   ($ENEMY_3_X),a
368D: 3E A3       ld   a,$A3
368F: 32 5D 81    ld   ($ENEMY_3_FRAME),a
3692: 3E 16       ld   a,$16
3694: 32 5E 81    ld   ($ENEMY_3_COL),a
3697: 3E 98       ld   a,$98
3699: 32 5F 81    ld   ($ENEMY_3_Y),a
369C: 3E 01       ld   a,$01
369E: 32 41 80    ld   ($8041),a
36A1: C9          ret
36A2: FF ...

36A8: 3A 5C 81    ld   a,($ENEMY_3_X)
36AB: A7          and  a
36AC: 28 0F       jr   z,$36BD
36AE: FE 01       cp   $01
36B0: 28 0B       jr   z,$36BD
36B2: FE 02       cp   $02
36B4: 28 07       jr   z,$36BD
36B6: FE 03       cp   $03
36B8: 28 03       jr   z,$36BD
36BA: FE 04       cp   $04
36BC: C0          ret  nz
36BD: CD 88 36    call $3688
36C0: C9          ret
36C1: FF ...

36D0: CD F0 35    call $35F0
36D3: CD 10 36    call $UPDATE_ENEMY_3
36D6: CD 38 32    call $3238
36D9: CD 60 32    call $3260
36DC: CD 28 2C    call $2C28
36DF: CD 40 31    call $3140
36E2: C9          ret
36E3: FF ...

36E8: 3E F0       ld   a,$F0
36EA: 32 5C 81    ld   ($ENEMY_3_X),a
36ED: 3E 22       ld   a,$22
36EF: 32 5D 81    ld   ($ENEMY_3_FRAME),a
36F2: 3E 17       ld   a,$17
36F4: 32 5E 81    ld   ($ENEMY_3_COL),a
36F7: 3E 94       ld   a,$94
36F9: 32 5F 81    ld   ($ENEMY_3_Y),a
36FC: 3E 01       ld   a,$01
36FE: 32 41 80    ld   ($8041),a
3701: C9          ret
3702: FF ...

3710: 3A 5C 81    ld   a,($ENEMY_3_X)
3713: A7          and  a
3714: 28 0F       jr   z,$3725
3716: FE 01       cp   $01
3718: 28 0B       jr   z,$3725
371A: FE 02       cp   $02
371C: 28 07       jr   z,$3725
371E: FE 03       cp   $03
3720: 28 03       jr   z,$3725
3722: FE 04       cp   $04
3724: C0          ret  nz
3725: CD E8 36    call $36E8
3728: C9          ret
3729: FF ...

3730: 3A 15 83    ld   a,($TICK_MOD_FAST)
3733: E6 01       and  $01
3735: C8          ret  z
3736: 3A 41 80    ld   a,($8041)
3739: A7          and  a
373A: C8          ret  z
373B: 3A 5C 81    ld   a,($ENEMY_3_X)
373E: 3D          dec  a
373F: 3D          dec  a
3740: 3D          dec  a
3741: 32 5C 81    ld   ($ENEMY_3_X),a
3744: C9          ret
3745: FF ...

3760: CD 10 37    call $3710
3763: CD 30 37    call $3730
3766: CD 98 37    call $3798
3769: CD B8 37    call $37B8
376C: C9          ret
376D: FF ...

3778: 3E F0       ld   a,$F0
377A: 32 58 81    ld   ($ENEMY_2_X),a
377D: 3E 22       ld   a,$22
377F: 32 59 81    ld   ($ENEMY_2_FRAME),a
3782: 3E 17       ld   a,$17
3784: 32 5A 81    ld   ($ENEMY_2_COL),a
3787: 3E 50       ld   a,$50
3789: 32 5B 81    ld   ($ENEMY_2_Y),a
378C: 3E 01       ld   a,$01
378E: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3791: C9          ret
3792: FF ...

3798: 3A 58 81    ld   a,($ENEMY_2_X)
379B: A7          and  a
379C: 28 0F       jr   z,$37AD
379E: FE 01       cp   $01
37A0: 28 0B       jr   z,$37AD
37A2: FE 02       cp   $02
37A4: 28 07       jr   z,$37AD
37A6: FE 03       cp   $03
37A8: 28 03       jr   z,$37AD
37AA: FE 04       cp   $04
37AC: C0          ret  nz
37AD: CD 78 37    call $3778
37B0: C9          ret
37B1: FF ...

37B8: 3A 15 83    ld   a,($TICK_MOD_FAST)
37BB: E6 01       and  $01
37BD: C8          ret  z
37BE: 3A 39 80    ld   a,($ENEMY_2_ACTIVE)
37C1: A7          and  a
37C2: C8          ret  z
37C3: 3A 58 81    ld   a,($ENEMY_2_X)
37C6: 3D          dec  a
37C7: 3D          dec  a
37C8: 3D          dec  a
37C9: 3D          dec  a
37CA: 32 58 81    ld   ($ENEMY_2_X),a
37CD: C9          ret

37CE: FF ...

37E8: CD 10 37    call $3710
37EB: CD 30 37    call $3730
37EE: CD 98 37    call $3798
37F1: CD B8 37    call $37B8
37F4: CD B8 33    call $33B8
37F7: CD 88 34    call $3488
37FA: C9          ret

37FB: FF ...

3808: CD 78 33    call $3378
380B: CD 60 32    call $3260
380E: CD 40 38    call $3840
3811: CD 10 36    call $UPDATE_ENEMY_3
3814: C9          ret

3815: FF ...

3820: 3E 10       ld   a,$10
3822: 32 5C 81    ld   ($ENEMY_3_X),a
3825: 3E 23       ld   a,$23
3827: 32 5D 81    ld   ($ENEMY_3_FRAME),a
382A: 3E 16       ld   a,$16
382C: 32 5E 81    ld   ($ENEMY_3_COL),a
382F: 3E 60       ld   a,$60
3831: 32 5F 81    ld   ($ENEMY_3_Y),a
3834: 3E 01       ld   a,$01
3836: 32 41 80    ld   ($8041),a
3839: C9          ret

383A: FF ...

3840: 3A 5C 81    ld   a,($ENEMY_3_X)
3843: A7          and  a
3844: 28 0F       jr   z,$3855
3846: FE 01       cp   $01
3848: 28 0B       jr   z,$3855
384A: FE 02       cp   $02
384C: 28 07       jr   z,$3855
384E: FE 03       cp   $03
3850: 28 03       jr   z,$3855
3852: FE 04       cp   $04
3854: C0          ret  nz
3855: CD 20 38    call $3820
3858: C9          ret
3859: FF ...

3868: CD 88 34    call $3488
386B: CD B8 33    call $33B8
386E: CD A8 36    call $36A8
3871: CD 10 36    call $UPDATE_ENEMY_3
3874: CD 38 32    call $3238
3877: CD 60 32    call $3260
387A: C9          ret

387B: FF ...

3888: CD 78 33    call $3378
388B: CD 60 32    call $3260
388E: CD 40 38    call $3840
3891: CD 10 36    call $UPDATE_ENEMY_3
3894: CD C0 38    call $38C0
3897: CD D0 38    call $38D0
389A: C9          ret

389B: FF ...

38A0: 3E 60       ld   a,$60
38A2: 32 57 81    ld   ($ENEMY_1_Y),a
38A5: 3E A3       ld   a,$A3
38A7: 32 55 81    ld   ($ENEMY_1_FRAME),a
38AA: 3E 16       ld   a,$16
38AC: 32 56 81    ld   ($ENEMY_1_COL),a
38AF: 3E 01       ld   a,$01
38B1: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
38B4: C9          ret
38B5: FF ...

38C0: CD A0 38    call $38A0
38C3: C9          ret
38C4: FF ...

38D0: 3A 5C 81    ld   a,($ENEMY_3_X)
38D3: D6 50       sub  $50
38D5: 32 54 81    ld   ($ENEMY_1_X),a
38D8: 3A 5D 81    ld   a,($ENEMY_3_FRAME)
38DB: 32 55 81    ld   ($ENEMY_1_FRAME),a
38DE: C9          ret

38DF: FF          rst  $38

38E0: CD 10 03    call $DRAW_TILES_H
38E3: 0A 00
38E5: E0 DC DD DE DF FF
38EB: CD 10 03    call $DRAW_TILES_H
38EE: 0B 00
38F0: E1 FF
38F2: CD 10 03    call $DRAW_TILES_H
38F5: 0B 04
38F7: E6 FF
38F9: CD 10 03    call $DRAW_TILES_H
38FC: 0C 00
38FE: E1 FF
3900: CD 10 03    call $DRAW_TILES_H
3903: 0C 04
3905: E6 FF
3907: CD 10 03    call $DRAW_TILES_H
390A: 0D 00
390C: E2 E3 E3 E3 E4 FF
3912: C9          ret

3913: FF ...

3918: CD B8 39    call $39B8
391B: CD E8 39    call $39E8
391E: C9          ret

391F: FF ...

SET_ENEMY_1_F0_C8
3938: 3A 54 81    ld   a,($ENEMY_1_X)
393B: A7          and  a
393C: C0          ret  nz
393D: 3E F0       ld   a,$F0
393F: 32 54 81    ld   ($ENEMY_1_X),a
3942: 3E 22       ld   a,$22
3944: 32 55 81    ld   ($ENEMY_1_FRAME),a
3947: 3E 17       ld   a,$17
3949: 32 56 81    ld   ($ENEMY_1_COL),a
394C: 3E C8       ld   a,$C8
394E: 32 57 81    ld   ($ENEMY_1_Y),a
3951: 3E 01       ld   a,$01
3953: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3956: C9          ret

3957: FF ...

SET_ENEMY_2_F0_98
3960: 3A 58 81    ld   a,($ENEMY_2_X)
3963: A7          and  a
3964: C0          ret  nz
3965: 3E F0       ld   a,$F0
3967: 32 58 81    ld   ($ENEMY_2_X),a
396A: 3E 22       ld   a,$22
396C: 32 59 81    ld   ($ENEMY_2_FRAME),a
396F: 3E 17       ld   a,$17
3971: 32 5A 81    ld   ($ENEMY_2_COL),a
3974: 3E 98       ld   a,$98
3976: 32 5B 81    ld   ($ENEMY_2_Y),a
3979: 3E 01       ld   a,$01
397B: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
397E: C9          ret
397F: FF ...

SET_ENEMY_3_F0_68
3988: 3A 5C 81    ld   a,($ENEMY_3_X)
398B: A7          and  a
398C: C0          ret  nz
398D: 3E F0       ld   a,$F0
398F: 32 5C 81    ld   ($ENEMY_3_X),a
3992: 3E 22       ld   a,$22
3994: 32 5D 81    ld   ($ENEMY_3_FRAME),a
3997: 3E 17       ld   a,$17
3999: 32 5E 81    ld   ($ENEMY_3_COL),a
399C: 3E 68       ld   a,$68
399E: 32 5F 81    ld   ($ENEMY_3_Y),a
39A1: 3E 01       ld   a,$01
39A3: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
39A6: C9          ret

39A7: FF ...

;;; ;
39B0: 3A 07 80    ld   a,($8007)
39B3: 32 36 80    ld   ($8036),a
39B6: C9          ret
39B7: FF          rst  $38
39B8: 3A 54 81    ld   a,($ENEMY_1_X)
39BB: FE 80       cp   $80
39BD: 28 14       jr   z,$39D3
39BF: FE 81       cp   $81
39C1: 28 10       jr   z,$39D3
39C3: FE 82       cp   $82
39C5: 28 0C       jr   z,$39D3
39C7: FE 83       cp   $83
39C9: 28 08       jr   z,$39D3
39CB: FE 84       cp   $84
39CD: 28 04       jr   z,$39D3
39CF: FE 00       cp   $00
39D1: 20 03       jr   nz,$39D6
39D3: CD 38 39    call $SET_ENEMY_1_F0_C8
39D6: C3 C0 11    jp   $11C0
39D9: FF ...

39E8: 3A 15 83    ld   a,($TICK_MOD_FAST)
39EB: E6 07       and  $07
39ED: C0          ret  nz
39EE: 3A 37 80    ld   a,($ENEMY_1_ACTIVE)
39F1: A7          and  a
39F2: 28 19       jr   z,$3A0D
39F4: 3C          inc  a
39F5: FE 40       cp   $40
39F7: 20 09       jr   nz,$3A02
39F9: AF          xor  a
    ;; enemy 1
39FA: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
39FD: 32 54 81    ld   ($ENEMY_1_X),a
3A00: 18 0B       jr   $3A0D
3A02: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3A05: 3A 54 81    ld   a,($ENEMY_1_X)
3A08: D6 02       sub  $02
3A0A: 32 54 81    ld   ($ENEMY_1_X),a
    ;; enemy 2
3A0D: 3A 39 80    ld   a,($ENEMY_2_ACTIVE)
3A10: A7          and  a
3A11: 28 19       jr   z,$3A2C
3A13: 3C          inc  a
3A14: FE 40       cp   $40
3A16: 20 09       jr   nz,$3A21
3A18: AF          xor  a
3A19: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3A1C: 32 58 81    ld   ($ENEMY_2_X),a
3A1F: 18 0B       jr   $3A2C
3A21: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3A24: 3A 58 81    ld   a,($ENEMY_2_X)
3A27: D6 03       sub  $03
3A29: 32 58 81    ld   ($ENEMY_2_X),a
    ;; enemy 3
3A2C: 3A 3B 80    ld   a,($ENEMY_3_ACTIVE)
3A2F: A7          and  a
3A30: C8          ret  z
3A31: 3C          inc  a
3A32: FE 40       cp   $40
3A34: 20 08       jr   nz,$3A3E
3A36: AF          xor  a
3A37: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
3A3A: 32 5C 81    ld   ($ENEMY_3_X),a
3A3D: C9          ret
3A3E: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
3A41: 3A 5C 81    ld   a,($ENEMY_3_X)
3A44: D6 04       sub  $04
3A46: 32 5C 81    ld   ($ENEMY_3_X),a
3A49: C9          ret

3A4A: FF ...

3A50: 3A 37 80    ld   a,($ENEMY_1_ACTIVE)
3A53: A7          and  a
3A54: C8          ret  z
3A55: 3C          inc  a
3A56: FE 3A       cp   $3A
3A58: 20 08       jr   nz,$3A62
3A5A: AF          xor  a
3A5B: 32 54 81    ld   ($ENEMY_1_X),a
3A5E: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3A61: C9          ret
3A62: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3A65: 3A 57 81    ld   a,($ENEMY_1_Y)
3A68: 3D          dec  a
3A69: 3D          dec  a
3A6A: 3D          dec  a
3A6B: 32 57 81    ld   ($ENEMY_1_Y),a
3A6E: 3A 12 83    ld   a,($TICK_NUM)
3A71: E6 03       and  $03
3A73: C0          ret  nz
3A74: 3A 55 81    ld   a,($ENEMY_1_FRAME)
3A77: FE 36       cp   $36
3A79: 20 06       jr   nz,$3A81
3A7B: 3E 37       ld   a,$37
3A7D: 32 55 81    ld   ($ENEMY_1_FRAME),a
3A80: C9          ret
3A81: 3E 36       ld   a,$36
3A83: 32 55 81    ld   ($ENEMY_1_FRAME),a
3A86: C9          ret
3A87: FF          rst  $38

3A88: 3A 39 80    ld   a,($ENEMY_2_ACTIVE)
3A8B: A7          and  a
3A8C: C8          ret  z
3A8D: 3C          inc  a
3A8E: FE 3A       cp   $3A
3A90: 20 08       jr   nz,$3A9A
3A92: AF          xor  a
3A93: 32 58 81    ld   ($ENEMY_2_X),a
3A96: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3A99: C9          ret
3A9A: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3A9D: 3A 5B 81    ld   a,($ENEMY_2_Y)
3AA0: 3D          dec  a
3AA1: 3D          dec  a
3AA2: 3D          dec  a
3AA3: 32 5B 81    ld   ($ENEMY_2_Y),a
3AA6: 3A 12 83    ld   a,($TICK_NUM)
3AA9: E6 03       and  $03
3AAB: C0          ret  nz
3AAC: 3A 59 81    ld   a,($ENEMY_2_FRAME)
3AAF: FE 36       cp   $36
3AB1: 20 06       jr   nz,$3AB9
3AB3: 3E 37       ld   a,$37
3AB5: 32 59 81    ld   ($ENEMY_2_FRAME),a
3AB8: C9          ret
3AB9: 3E 36       ld   a,$36
3ABB: 32 59 81    ld   ($ENEMY_2_FRAME),a
3ABE: C9          ret
3ABF: FF          rst  $38
    ;; enemy 3
3AC0: 3A 3B 80    ld   a,($ENEMY_3_ACTIVE)
3AC3: A7          and  a
3AC4: C8          ret  z
3AC5: 3C          inc  a
3AC6: FE 3A       cp   $3A
3AC8: 20 08       jr   nz,$3AD2
3ACA: AF          xor  a
3ACB: 32 5C 81    ld   ($ENEMY_3_X),a
3ACE: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
3AD1: C9          ret
3AD2: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
3AD5: 3A 5F 81    ld   a,($ENEMY_3_Y)
3AD8: 3D          dec  a
3AD9: 3D          dec  a
3ADA: 3D          dec  a
3ADB: 32 5F 81    ld   ($ENEMY_3_Y),a
3ADE: 3A 12 83    ld   a,($TICK_NUM)
3AE1: E6 03       and  $03
3AE3: C0          ret  nz
3AE4: 3A 5D 81    ld   a,($ENEMY_3_FRAME)
3AE7: FE 36       cp   $36
3AE9: 20 06       jr   nz,$3AF1
3AEB: 3E 37       ld   a,$37
3AED: 32 5D 81    ld   ($ENEMY_3_FRAME),a
3AF0: C9          ret
3AF1: 3E 36       ld   a,$36
3AF3: 32 5D 81    ld   ($ENEMY_3_FRAME),a
3AF6: C9          ret
3AF7: FF          rst  $38

    ;; enemy 1
SET_ENEMY_1_98_C0
3AF8: 21 54 81    ld   hl,$ENEMY_1_X
3AFB: 36 98       ld   (hl),$98 ; x
3AFD: 23          inc  hl
3AFE: 36 36       ld   (hl),$36 ; frame
3B00: 23          inc  hl
3B01: 36 17       ld   (hl),$17 ; color
3B03: 23          inc  hl
3B04: 36 C0       ld   (hl),$C0 ; y
3B06: 23          inc  hl
3B07: 3E 01       ld   a,$01
3B09: 32 37 80    ld   ($ENEMY_1_ACTIVE),a
3B0C: C9          ret
3B0D: FF FF FF

        ;; enemy 2
SET_ENEMY_2_90_C0
3B10: 21 58 81    ld   hl,$ENEMY_2_X
3B13: 36 90       ld   (hl),$90 ; x
3B15: 23          inc  hl
3B16: 36 36       ld   (hl),$36 ; frame
3B18: 23          inc  hl
3B19: 36 17       ld   (hl),$17 ; color
3B1B: 23          inc  hl
3B1C: 36 C0       ld   (hl),$C0 ; y
3B1E: 23          inc  hl
3B1F: 3E 01       ld   a,$01
3B21: 32 39 80    ld   ($ENEMY_2_ACTIVE),a
3B24: C9          ret
3B25: FF ...

        ;; enemy 3
SET_ENEMY_3_90_C0
3B28: 21 5C 81    ld   hl,$ENEMY_3_X
3B2B: 36 90       ld   (hl),$90 ; x
3B2D: 23          inc  hl
3B2E: 36 36       ld   (hl),$36 ; frame
3B30: 23          inc  hl
3B31: 36 17       ld   (hl),$17 ; color
3B33: 23          inc  hl
3B34: 36 C0       ld   (hl),$C0 ; y
3B36: 23          inc  hl
3B37: 3E 01       ld   a,$01
3B39: 32 3B 80    ld   ($ENEMY_3_ACTIVE),a
3B3C: C9          ret
3B3D: FF FF FF

3B40: CD 78 3B    call $3B78
3B43: 3A 36 80    ld   a,($8036)
3B46: 3C          inc  a
3B47: FE 60       cp   $60
3B49: 20 01       jr   nz,$3B4C
3B4B: AF          xor  a
3B4C: 32 36 80    ld   ($8036),a
3B4F: FE 08       cp   $08
3B51: 20 04       jr   nz,$3B57
3B53: CD F8 3A    call $SET_ENEMY_1_98_C0
3B56: C9          ret
3B57: FE 30       cp   $30
3B59: 20 04       jr   nz,$3B5F
3B5B: CD 10 3B    call $SET_ENEMY_2_90_C0
3B5E: C9          ret
3B5F: FE 40       cp   $40
3B61: C0          ret  nz
3B62: CD 28 3B    call $SET_ENEMY_3_90_C0
3B65: C9          ret
3B66: FF FF

3B68: CD 40 3B    call $3B40
3B6B: CD E0 14    call $14E0
3B6E: 00          nop
3B6F: 00          nop
3B70: 00          nop
3B71: 00          nop
3B72: 00          nop
3B73: 00          nop
3B74: C9          ret
3B75: FF          rst  $38
3B76: FF          rst  $38
3B77: FF          rst  $38

3B78: 3A 15 83    ld   a,($TICK_MOD_FAST)
3B7B: E6 03       and  $03
3B7D: C8          ret  z
3B7E: E1          pop  hl
3B7F: C9          ret

PLAYER_ENEMY_COLLISION
    ;; Check X
3B80: FD 7E 00    ld   a,(iy+$00) ; points to enemy X
3B83: DD 96 00    sub  (ix+$00)   ; minus player_x
3B86: 37          scf
3B87: 3F          ccf           ; (clear carry)
3B88: D6 0C       sub  $0C      ; is enemy to the right and X diff <= sprite width?
3B8A: 38 03       jr   c,_CHECK_Y  ;   ... yes, check Y
3B8C: C6 18       add  a,$18    ; no, but enemy might be to the left: try "+ width * 2"
3B8E: D0          ret  nc       ;   no collision on X, leave.
_CHECK_Y
3B8F: DD 7E 03    ld   a,(ix+$03) ; player Y pos (player_x addr + 3)
3B92: FD 96 03    sub  (iy+$03)   ; minus enemy Y pos (enemy Y addr + 3)
3B95: 37          scf
3B96: 3F          ccf           ; (clear carry)
3B97: D6 0A       sub  $0A      ; is Y diff <= 10?
3B99: 38 03       jr   c,$_HIT  ;   ... yes - we collided.
3B9B: C6 21       add  a,$21    ; no, but is player above? Check legs.
3B9D: D0          ret  nc       ;   no - no collsions on Y, leave
_HIT
3B9E: CD 33 0A    call $KILL_PLAYER
3BA1: C9          ret
3BA2: FF ...

    ;; Always checks all 3 enemies. "Offscreen" enemies
    ;; have x = 0, so the "check x" test fails.
PLAYER_ENEMIES_COLLISION
3BA8: FD 21 54 81 ld   iy,$ENEMY_1_X
3BAC: DD 21 40 81n ld   ix,$PLAYER_X
3BB0: CD 80 3B    call $PLAYER_ENEMY_COLLISION
3BB3: FD 21 58 81 ld   iy,$ENEMY_2_X
3BB7: CD 80 3B    call $PLAYER_ENEMY_COLLISION
3BBA: FD 21 5C 81 ld   iy,$ENEMY_3_X
3BBE: CD 80 3B    call $PLAYER_ENEMY_COLLISION
3BC1: C9          ret
3BC2: FF ...

RESET_XOFFS                     ;(or colors?)
3BC8: 21 08 81    ld   hl,$SCREEN_XOFF_COL+8
3BCB: 3A 06 81    ld   a,($SCREEN_XOFF_COL+6)
3BCE: 77          ld   (hl),a
3BCF: 23          inc  hl
3BD0: 23          inc  hl
3BD1: 7D          ld   a,l
3BD2: FE 40       cp   $40
3BD4: 20 F5       jr   nz,$3BCB
3BD6: C9          ret

3BD7: FF

DRAW_TILES_V_COPY
3BD8: DD E1       pop  ix
3BDA: 26 00       ld   h,$00
3BDC: DD 6E 00    ld   l,(ix+$00) ; param 1
3BDF: 29          add  hl,hl
3BE0: 29          add  hl,hl
3BE1: 29          add  hl,hl
3BE2: 29          add  hl,hl
3BE3: 29          add  hl,hl
3BE4: DD 23       inc  ix
3BE6: DD 7E 00    ld   a,(ix+$00) ; param 2
3BE9: 85          add  a,l
3BEA: 6F          ld   l,a
3BEB: 01 40 90    ld   bc,$START_OF_TILES
3BEE: 09          add  hl,bc
3BEF: DD 23       inc  ix
3BF1: DD 7E 00    ld   a,(ix+$00) ; read until 0xff
3BF4: FE FF       cp   $FF
3BF6: 28 04       jr   z,$3BFC
3BF8: 77          ld   (hl),a
3BF9: 23          inc  hl
3BFA: 18 F3       jr   $3BEF
3BFC: DD 23       inc  ix
3BFE: DD E5       push ix
3C00: C9          ret

3C01: FF

SCREEN_TILE_ANIMATIONS
3C02: 3A 04 80    ld   a,($PLAYER_NUM)
3C05: A7          and  a
3C06: 20 05       jr   nz,$3C0D
3C08: 3A 29 80    ld   a,($SCREEN_NUM)
3C0B: 18 03       jr   $3C10
3C0D: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
3C10: FE 01       cp   $01
3C12: 28 21       jr   z,$BUBBLE_LAVA
3C14: FE 02       cp   $02
3C16: 28 1D       jr   z,$BUBBLE_LAVA
3C18: FE 04       cp   $04
3C1A: 28 19       jr   z,$BUBBLE_LAVA
3C1C: FE 08       cp   $08
3C1E: 28 15       jr   z,$BUBBLE_LAVA
3C20: FE 0D       cp   $0D
3C22: 28 11       jr   z,$BUBBLE_LAVA
3C24: FE 0F       cp   $0F
3C26: 28 0D       jr   z,$BUBBLE_LAVA
3C28: FE 12       cp   $12
3C2A: 28 09       jr   z,$BUBBLE_LAVA
3C2C: FE 15       cp   $15
3C2E: 28 48       jr   z,$BUBBLE_LAVA_VAR
3C30: FE 18       cp   $18
3C32: 28 44       jr   z,$BUBBLE_LAVA_VAR
3C34: C9          ret

BUBBLE_LAVA
3C35: 3A 4B 80    ld   a,($804B)
3C38: 3C          inc  a
3C39: FE 04       cp   $04
3C3B: 20 01       jr   nz,$3C3E
3C3D: AF          xor  a
3C3E: 32 4B 80    ld   ($804B),a
3C41: A7          and  a
3C42: 20 0B       jr   nz,$BUBBLE_LAVA_1
3C44: CD 10 03    call $DRAW_TILES_H
3C47: 1D 0E
3C49: 80 80 80 80 FF            ; red dash line
3C4E: C9          ret

BUBBLE_LAVA_1
3C4F: FE 01       cp   $01
3C51: 20 0B       jr   nz,$BUBBLE_LAVA_2
3C53: CD 10 03    call $DRAW_TILES_H
3C56: 1D 0E
3C58: 85 81 87 81 FF
3C5D: C9          ret

BUBBLE_LAVA_2
3C5E: FE 02       cp   $02
3C60: 20 0B       jr   nz,$BUBBLE_LAVA_3
3C62: CD 10 03    call $DRAW_TILES_H
3C65: 1D 0E
3C67: 86 82 88 80 FF
3C6C: C9          ret

BUBBLE_LAVA_3
3C6D: CD 10 03    call $DRAW_TILES_H
3C70: 1D 0E
3C72: 85 83 87 82 FF
3C77: C9          ret

BUBBLE_LAVA_VAR
3C78: 3A 4B 80    ld   a,($804B)
3C7B: 3C          inc  a
3C7C: FE 04       cp   $04
3C7E: 20 01       jr   nz,$3C81
3C80: AF          xor  a
3C81: 32 4B 80    ld   ($804B),a
3C84: A7          and  a
3C85: 20 0C       jr   nz,$BUBBLE_LAVA_VAR_1
3C87: CD 10 03    call $DRAW_TILES_H
3C8A: 19 0F
3C8D: 80 80 80 80 FF            ; Flat
3C92: C9          ret

BUBBLE_LAVA_VAR_1
3C93: FE 01       cp   $01
3C95: 20 0C       jr   nz,$BUBBLE_LAVA_VAR_2
3C97: CD 10 03    call $DRAW_TILES_H
3C9A: 19 0F
3C9C: 85 81 84 81 87 FF
3CA2: C9          ret

BUBBLE_LAVA_VAR_2
3CA3: FE 02       cp   $02
3CA5: 20 0C       jr   nz,$BUBBLE_LAVA_VAR_3
3CA7: CD 10 03    call $DRAW_TILES_H
3CAA: 19 0F
3CAC: 86 82 88 86 82 FF
3CB2: C9          ret

BUBBLE_LAVA_VAR_3
3CB3: CD 10 03    call $DRAW_TILES_H
3CB6: 19 0F
3CB9: 83 80 83 87 FF
3CBE: C9          ret

3CBF: FF          rst  $38
3CC0: 80          add  a,b
3CC1: 3A 11 70    ld   a,($7011)
3CC4: 80          add  a,b
3CC5: 3B          dec  sp
3CC6: 11 80 94    ld   de,$9480
3CC9: 05          dec  b
3CCA: 12          ld   (de),a
3CCB: 80          add  a,b
3CCC: 00          nop
3CCD: 00          nop
3CCE: 12          ld   (de),a
3CCF: 80          add  a,b
3CD0: 00          nop
3CD1: 00          nop
3CD2: 12          ld   (de),a
3CD3: 80          add  a,b
3CD4: 6C          ld   l,h
3CD5: 00          nop
3CD6: 12          ld   (de),a
3CD7: 80          add  a,b
3CD8: A8          xor  b
3CD9: 00          nop
3CDA: 12          ld   (de),a
3CDB: 80          add  a,b
3CDC: 00          nop
3CDD: 00          nop
3CDE: 12          ld   (de),a
3CDF: 80          add  a,b

    ;; CUTSCENE something
3CE0: 1E 08       ld   e,$08
3CE2: E5          push hl
3CE3: D5          push de
3CE4: CD A0 13    call $WAIT_VBLANK
3CE7: D1          pop  de
3CE8: E1          pop  hl
3CE9: 1D          dec  e
3CEA: 20 F6       jr   nz,$3CE2
3CEC: C9          ret

3CED: FF ...

3D00: 3C          inc  a
3D01: 3D          dec  a
3D02: 06 01       ld   b,$01
3D04: 3A 3B 05    ld   a,($053B)
3D07: 00          nop
3D08: 3C          inc  a
3D09: 3D          dec  a
3D0A: 06 01       ld   b,$01
3D0C: 3A 3B 07    ld   a,($073B)
3D0F: 02          ld   (bc),a
3D10: 3E 3F       ld   a,$3F
3D12: 08          ex   af,af'
3D13: 03          inc  bc
3D14: 3A 3B 07    ld   a,($073B)
3D17: 02          ld   (bc),a
3D18: 3E 3F       ld   a,$3F
3D1A: 08          ex   af,af'
3D1B: 03          inc  bc
3D1C: 3A 3B 05    ld   a,($053B)
3D1F: 00          nop
3D20: 7E          ld   a,(hl)
3D21: 32 41 81    ld   ($PLAYER_FRAME),a
3D24: 23          inc  hl
3D25: 7E          ld   a,(hl)
3D26: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
3D29: 23          inc  hl
3D2A: 7E          ld   a,(hl)
3D2B: 32 49 81    ld   ($BONGO_FRAME),a
3D2E: 23          inc  hl
3D2F: 7E          ld   a,(hl)
3D30: 32 51 81    ld   ($DINO_FRAME_LEGS),a
3D33: 32 55 81    ld   ($ENEMY_1_FRAME),a
3D36: 32 59 81    ld   ($ENEMY_2_FRAME),a
3D39: 23          inc  hl
3D3A: 7D          ld   a,l
3D3B: E6 1F       and  $1F
3D3D: 6F          ld   l,a
3D3E: C9          ret
3D3F: FF ...

;;; Cut sceen
DO_CUTSCENE
3D48: 3E 06       ld   a,$06
3D4A: 32 42 80    ld   ($CH1_SFX),a
3D4D: 32 65 80    ld   ($SFX_PREV),a
3D50: CD 70 14    call $CALL_RESET_SCREEN_META_AND_SPRITES
3D53: 21 E0 0F    ld   hl,$0FE0
3D56: CD 40 08    call $DRAW_SCREEN
3D59: 00 00                     ; params to DRAW_SCREEN
3D5B: CD A0 03    call $DRAW_LIVES
3D5E: CD 50 24    call $DRAW_SCORE
3D61: 21 40 81    ld   hl,$PLAYER_X ; destination
3D64: 01 C0 3C    ld   bc,$3CC0   ; src location
3D67: 16 20       ld   d,$20      ; 20 times do
3D69: 0A          ld   a,(bc)     ;       <-
3D6A: 77          ld   (hl),a     ;         |
3D6B: 23          inc  hl         ;         |
3D6C: 03          inc  bc         ;         |
3D6D: 15          dec  d          ;         |
3D6E: 20 F9       jr   nz,$3D69   ;        _|
3D70: CD A0 3D    call $DRAW_CAGE_AND_SCENE
3D73: 16 80       ld   d,$80      ; 80 x animate cutscene
3D75: AF          xor  a          ;
3D76: 32 2D 80    ld   ($DINO_COUNTER),a  ;
3D79: 21 00 3D    ld   hl,$3D00   ;
3D7C: CD E0 3C    call $3CE0      ; draws gang <-
3D7F: CD 20 3D    call $3D20      ;             |
3D82: 15          dec  d          ;             |
3D83: 20 F7       jr   nz,$3D7C   ;         ____|
3D85: CD B0 3E    call $END_CUTSCENE    ; end of round cutscene
3D88: 3A 04 80    ld   a,($PLAYER_NUM) ; a = $8004 - which screen to use?
3D8B: A7          and  a         ; if a != 0
3D8C: 20 08       jr   nz,$3D96  ;   goto screen-set 2
3D8E: 3E 01       ld   a,$01     ; reset to screen 1
3D90: 32 29 80    ld   ($SCREEN_NUM),a ; set screen
3D93: C3 00 10    jp   $BIG_RESET
3D96: 3E 01       ld   a,$01
3D98: 32 2A 80    ld   ($SCREEN_NUM_P2),a ; player 2 screen
3D9B: C3 00 10    jp   $BIG_RESET
3D9E: C9          ret
3D9F: FF          rst  $38

DRAW_CAGE_AND_SCENE             ; for cutscene
3DA0: 21 18 92    ld   hl,$9218
3DA3: 36 66       ld   (hl),$66
3DA5: 23          inc  hl
3DA6: 36 67       ld   (hl),$67
3DA8: 23          inc  hl
3DA9: 36 6A       ld   (hl),$6A
3DAB: 23          inc  hl
3DAC: 36 6B       ld   (hl),$6B
3DAE: 21 F8 91    ld   hl,$91F8
3DB1: 36 64       ld   (hl),$64
3DB3: 23          inc  hl
3DB4: 36 65       ld   (hl),$65
3DB6: 23          inc  hl
3DB7: 36 68       ld   (hl),$68
3DB9: 23          inc  hl
3DBA: 36 69       ld   (hl),$69
3DBC: 21 D8 91    ld   hl,$91D8
3DBF: 36 6E       ld   (hl),$6E
3DC1: 23          inc  hl
3DC2: 36 6F       ld   (hl),$6F
3DC4: 23          inc  hl
3DC5: 36 6C       ld   (hl),$6C
3DC7: 23          inc  hl
3DC8: 36 6D       ld   (hl),$6D
3DCA: 3E 02       ld   a,$02
3DCC: 32 31 81    ld   ($SCREEN_XOFF_COL+31),a
3DCF: 32 33 81    ld   ($SCREEN_XOFF_COL+33),a
3DD2: 32 35 81    ld   ($SCREEN_XOFF_COL+35),a
3DD5: 32 37 81    ld   ($SCREEN_XOFF_COL+37),a
3DD8: CD 10 03    call $DRAW_TILES_H
3DDB: 1C 00                     ; Row of upward spikes
3DDD: 38 39 3A 39 38 39 3C 3D 39 3A 38 38 3C 3C 3D 3C
3DED: 39 3A 38 39 38 39 3D 3C 39 38 3A 3D 3C 39 39 38 FF
3DFE: CD 10 03    call $DRAW_TILES_H
3E01: 12 00                     ; real long platform
3E03: FE FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD
3E13: FD FD FD FD FD FD FD FD FD FD FD FC FF
3E20: C9          ret
3E21: FF

3E22: 3E 0C       ld   a,$0C
3E24: 32 41 81    ld   ($PLAYER_FRAME),a
3E27: 3E 0D       ld   a,$0D
3E29: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
3E2C: 3E 29       ld   a,$29
3E2E: 32 29 81    ld   ($SCREEN_XOFF_COL+29),a
3E31: 1E 70       ld   e,$70
;;;  End of level screen?
3E33: D5          push de
3E34: CD F0 3E    call $3EF0
3E37: CD E8 08    call $08E8
3E3A: CD E8 08    call $08E8
3E3D: CD A0 13    call $WAIT_VBLANK
3E40: D1          pop  de
3E41: 1D          dec  e
;;;  end of end of level screen
3E42: 20 EF       jr   nz,$3E33
3E44: C9          ret
3E45: FF ...

3E50: 1E 01       ld   e,$01
3E52: D5          push de
3E53: DD E5       push ix
3E55: CD A0 13    call $WAIT_VBLANK
3E58: DD E1       pop  ix
3E5A: D1          pop  de
3E5B: 1D          dec  e
3E5C: 20 F4       jr   nz,$3E52
3E5E: C9          ret
3E5F: FF          rst  $38
3E60: DD 21 40 81 ld   ix,$PLAYER_X
3E64: CD 50 3E    call $3E50
3E67: 16 08       ld   d,$08
3E69: DD 35 03    dec  (ix+$03)
3E6C: DD 35 07    dec  (ix+$07)
3E6F: DD 35 0B    dec  (ix+$0b)
3E72: CD 50 3E    call $3E50
3E75: 15          dec  d
3E76: 20 F1       jr   nz,$3E69
3E78: 16 08       ld   d,$08
3E7A: DD 34 03    inc  (ix+$03)
3E7D: DD 34 07    inc  (ix+$07)
3E80: DD 34 0B    inc  (ix+$0b)
3E83: CD 50 3E    call $3E50
3E86: 15          dec  d
3E87: 20 F1       jr   nz,$3E7A
3E89: C9          ret

3E8A: FF ...

END_CUTSCENE
3EB0: 3E 07       ld   a,$07    ; end of dance in cutscene
3EB2: 32 42 80    ld   ($CH1_SFX),a
3EB5: 21 50 81    ld   hl,$DINO_X_LEGS ; set a bunch of bytes at 8150
3EB8: 36 18       ld   (hl),$18
3EBA: 23          inc  hl
3EBB: 36 2E       ld   (hl),$2E
3EBD: 23          inc  hl
3EBE: 36 12       ld   (hl),$12
3EC0: 23          inc  hl
3EC1: 36 70       ld   (hl),$70
3EC3: 21 5C 81    ld   hl,$ENEMY_3_X ; and 815c
3EC6: 36 11       ld   (hl),$11
3EC8: 23          inc  hl
3EC9: 36 30       ld   (hl),$30
3ECB: 23          inc  hl
3ECC: 36 12       ld   (hl),$12
3ECE: 23          inc  hl
3ECF: 36 80       ld   (hl),$80
3ED1: CD E0 3C    call $3CE0    ; dino appears
3ED4: CD 60 3E    call $3E60    ; jump up and down
3ED7: CD 60 3E    call $3E60    ; jump up and down
3EDA: CD 60 3E    call $3E60    ; jump up and down
3EDD: 80          add  a,b
3EDE: CD 22 3E    call $3E22    ; run to the right
3EE1: C9          ret

3EE2: FF ...

3EF0: 7B          ld   a,e
3EF1: E6 03       and  $03
3EF3: C0          ret  nz
3EF4: CD 18 06    call $0618
3EF7: C9          ret

3EF8: FF ...

DELAY_N_4E90
3F00: CD 60 14    call $DELAY_83
3F03: 21 90 0E    ld   hl,$0E90
3F06: CD E3 01    call $CALL_HL_PLUS_4K
3F09: C9          ret

3F0A: FF ...

;;; Probably the level tiles at the bottom of the screen
3F10: CD 10 03    call $DRAW_TILES_H
3F13: 1F          rra
3F14: 00          nop
3F15: C0 C1 C2 C3 C4 C5 C6 C7
3F1D: C8 C9 CA CB CC CD CE CF
3F25: D0 D1 D2 D3 D4 D5 D6 D7
3F2D: D8 D9 DA
3F30: FF

3F31: 3A 04 80    ld   a,($PLAYER_NUM)
3F34: A7          and  a
3F35: 20 05       jr   nz,$3F3C
3F37: 3A 29 80    ld   a,($SCREEN_NUM)
3F3A: 18 03       jr   $3F3F
3F3C: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
3F3F: 21 BF 93    ld   hl,$93BF
3F42: CD 55 3F    call $3F55
3F45: 3D          dec  a
3F46: 28 08       jr   z,$3F50
3F48: 36 DB       ld   (hl),$DB
3F4A: 01 E0 FF    ld   bc,$FFE0
3F4D: 09          add  hl,bc
3F4E: 18 F2       jr   $3F42
3F50: CD D0 2A    call $DRAW_BONUS_STATE
3F53: C9          ret

3F54: FF

3F55: F5          push af
3F56: E5          push hl
3F57: 1E 01       ld   e,$01
3F59: D5          push de
3F5A: CD A0 13    call $WAIT_VBLANK
3F5D: D1          pop  de
3F5E: 1D          dec  e
3F5F: 20 F8       jr   nz,$3F59
3F61: E1          pop  hl
3F62: F1          pop  af
3F63: C9          ret

3F64: FF FF

3F66: CD 10 03    call $DRAW_TILES_H
    ;; data again.. how is it used? must be by $DRAW_TILES_H!
3F69: 0C          inc  c
3F6A: 0A          ld   a,(bc)
3F6B: 1A          ld   a,(de)
3F6C: 15          dec  d
3F6D: 24          inc  h
3F6E: 23          inc  hl
3F6F: 1F          rra
3F70: 16 24       ld   d,$24
3F72: FF          rst  $38
3F73: C9          ret

3F74: CD 10 03    call $DRAW_TILES_H
3F77: 14          inc  d
3F78: 07          rlca
3F79: 20 22       jr   nz,$3F9D
3F7B: 1F          rra
3F7C: 25          dec  h
3F7D: 14          inc  d
3F7E: 1C          inc  e
3F7F: 29          add  hl,hl
3F80: 10 20       djnz $3FA2
3F82: 22 15 23    ld   ($2315),hl
3F85: 15          dec  d
3F86: 1E 24       ld   e,$24
3F88: FF          rst  $38
3F89: C9          ret

3F8A: FF FF

3F8C: CD 10 03    call $DRAW_TILES_H
3F8F: 10 04       djnz $3F95
3F91: 8B          adc  a,e
3F92: 01 09 08    ld   bc,$0809
3F95: 03          inc  bc
3F96: FF          rst  $38
3F97: CD 10 03    call $DRAW_TILES_H
3F9A: 12          ld   (de),a
3F9B: 04          inc  b
3F9C: 1A          ld   a,(de)
3F9D: 15          dec  d
3F9E: 24          inc  h
3F9F: 23          inc  hl
3FA0: 1F          rra
3FA1: 16 24       ld   d,$24
3FA3: FF          rst  $38
3FA4: C9          ret

3FA5: FF ...

3FA8: CD 10 03    call $DRAW_TILES_H
3FAB: 1F          rra
3FAC: 00          nop
3FAD: 10 10       djnz $3FBF
3FAF: 10 10       djnz $3FC1
3FB1: 10 10       djnz $3FC3
3FB3: 10 10       djnz $3FC5
3FB5: 10 10       djnz $3FC7
3FB7: 10 10       djnz $3FC9
3FB9: 10 10       djnz $3FCB
3FBB: 10 10       djnz $3FCD
3FBD: 10 10       djnz $3FCF
3FBF: 10 10       djnz $3FD1
3FC1: 10 10       djnz $3FD3
3FC3: 10 10       djnz $3FD5
3FC5: 10 10       djnz $3FD7
3FC7: 10 10       djnz $3FD9
3FC9: FF          rst  $38
3FCA: C9          ret
3FCB: FF ...

3FD0: 00          nop
3FD1: 00          nop
3FD2: 00          nop
3FD3: 00          nop
3FD4: 00          nop

3FD5: CD D0 17    call $17D0
3FD8: CD EC 24    call $24EC
3FDB: CD E0 38    call $38E0
3FDE: CD EC 24    call $24EC
3FE1: CD D0 17    call $17D0
3FE4: CD EC 24    call $24EC
3FE7: CD E0 38    call $38E0
3FEA: CD EC 24    call $24EC
3FED: CD D0 17    call $17D0
3FF0: CD EC 24    call $24EC
3FF3: CD E0 38    call $38E0
3FF6: CD EC 24    call $24EC
3FF9: C9          ret

3FFA: FF ...

INT_HANDLER
4000: AF          xor  a
4001: 32 01 B0    ld   ($INT_ENABLE),a
4004: 3A 40 40    ld   a,($4040)
4007: 00          nop
4008: 00          nop
4009: 00          nop
400A: 3E FF       ld   a,$FF
400C: 32 00 B8    ld   ($WATCHDOG),a
400F: 31 F0 83    ld   sp,$STACK_LOCATION
4012: 3A 40 40    ld   a,($4040)
4015: 00          nop
4016: 00          nop
4017: 00          nop
4018: CD 00 00    call $0000

401B: FF ...

4020: CD 50 40    call $ADD_MOVE_SCORE
4023: CD 58 42    call $PICKUP_TILE_COLLISION
4026: CD E0 42    call $42E0
4029: CD 74 4D    call $END_SCREEN_LOGIC
402C: CD 20 50    call $ANIMATE_ALL_PICKUPS
402F: C9          ret

4030: C9          ret
4031: FF ...

4038: 21 00 C0    ld   hl,$C000
403B: CD 81 5C    call $JMP_HL
403E: C9          ret

403F: FF

    ;; Whole bunch of PICKUP drawing below - is
    ;; it one bunch of code per screen? Does something
    ;; dispatch to each sub?

4040: CD 68 45    call $4568
4043: 3E 8E       ld   a,$TILE_PIK_RINGA
4045: 32 7A 92    ld   ($927A),a
4048: C9          ret

4049: FF ...

    ;; Adds a bonus as you move right
    ;; Keeps track of "max x" - when you go past it,
    ;; it gets the diff (x - old max x) and adds it to bonus
ADD_MOVE_SCORE
4050: 3A 40 81    ld   a,($PLAYER_X)
4053: 37          scf
4054: 3F          ccf
4055: 21 30 80    ld   hl,$PLAYER_MAX_X
4058: 96          sub  (hl)
4059: D8          ret  c        ; not furthest right, no bonus
    ;; adds the move score
405A: 47          ld   b,a      ; add position diff to score_to_add
405B: 3A 1D 80    ld   a,($SCORE_TO_ADD)
405E: 80          add  a,b
405F: 32 1D 80    ld   ($SCORE_TO_ADD),a
4062: 3A 40 81    ld   a,($PLAYER_X)  ; set new max X pos
4065: 32 30 80    ld   ($PLAYER_MAX_X),a
4068: C9          ret

4069: FF ...

4070: 3E 8C       ld   a,$TILE_CROWN_PIKA
4072: 32 8E 91    ld   ($918E),a
4075: C9          ret

4076: FF ...

4078: 3E 8D       ld   a,$TILE_PIK_CROSSA
407A: 32 D2 91    ld   ($91D2),a
407D: C9          ret

407E: FF ...

4080: DD 7E 05    ld   a,(ix+$05)
4083: A7          and  a
4084: 28 05       jr   z,$408B
4086: 3D          dec  a
4087: DD 77 05    ld   (ix+$05),a
408A: C9          ret
408B: DD 7E 03    ld   a,(ix+$03)
408E: DD 77 05    ld   (ix+$05),a
4091: DD 7E 02    ld   a,(ix+$02)
4094: A7          and  a
4095: C8          ret  z
4096: 3D          dec  a
4097: DD 77 02    ld   (ix+$02),a
409A: C6 00       add  a,$00
409C: 6F          ld   l,a
409D: 3E 08       ld   a,$08
409F: D3 00       out  ($00),a
40A1: 7D          ld   a,l
40A2: D3 01       out  ($01),a
40A4: 00          nop
40A5: C9          ret

40A6: FF

    ;; in: h = x, y = l
    ;; out: hl = screen pos of tile at xy
GET_TILE_SCR_POS
40A7: 45          ld   b,l
40A8: AF          xor  a
40A9: 94          sub  h
40AA: E6 F8       and  $F8
40AC: 6F          ld   l,a
40AD: 26 00       ld   h,$00
40AF: 29          add  hl,hl
40B0: 29          add  hl,hl
40B1: 3E 90       ld   a,$90
40B3: 84          add  a,h
40B4: 67          ld   h,a
40B5: 78          ld   a,b
40B6: CB 3F       srl  a
40B8: CB 3F       srl  a
40BA: CB 3F       srl  a
40BC: 85          add  a,l
40BD: 6F          ld   l,a
40BE: C9          ret

40BF: FF          rst  $38
40C0: DD 7E 05    ld   a,(ix+$05)
40C3: A7          and  a
40C4: 28 05       jr   z,$40CB
40C6: 3D          dec  a
40C7: DD 77 05    ld   (ix+$05),a
40CA: C9          ret
40CB: DD 7E 03    ld   a,(ix+$03)
40CE: DD 77 05    ld   (ix+$05),a
40D1: DD 7E 02    ld   a,(ix+$02)
40D4: A7          and  a
40D5: C8          ret  z
40D6: 3D          dec  a
40D7: DD 77 02    ld   (ix+$02),a
40DA: C6 00       add  a,$00
40DC: 6F          ld   l,a
40DD: 3E 09       ld   a,$09
40DF: D3 00       out  ($00),a
40E1: 7D          ld   a,l
40E2: D3 01       out  ($01),a
40E4: 00          nop
40E5: C9          ret
40E6: FF ...

40E8: 3E 8F       ld   a,$TILE_PIK_VASEA
40EA: 32 EE 92    ld   ($92EE),a
40ED: 3E 8E       ld   a,$TILE_PIK_RINGA
40EF: 32 17 92    ld   ($9217),a
40F2: C9          ret
40F3: FF

;;; ; hit bonus
HIT_BONUS
40F4: 3E 03       ld   a,$03
40F6: 32 44 80    ld   ($SFX_ID),a
40F9: 21 80 29    ld   hl,$GOT_A_BONUS
40FC: CD 81 5C    call $JMP_HL
40FF: C9          ret

    ;;
4100: DD 7E 05    ld   a,(ix+$05)
4103: A7          and  a
4104: 28 05       jr   z,$410B
4106: 3D          dec  a
4107: DD 77 05    ld   (ix+$05),a
410A: C9          ret
410B: DD 7E 03    ld   a,(ix+$03)
410E: DD 77 05    ld   (ix+$05),a
4111: DD 7E 02    ld   a,(ix+$02)
4114: A7          and  a
4115: C8          ret  z
4116: 3D          dec  a
4117: DD 77 02    ld   (ix+$02),a
411A: C6 00       add  a,$00
411C: 6F          ld   l,a
411D: 3E 0A       ld   a,$0A
411F: D3 00       out  ($00),a
4121: 7D          ld   a,l
4122: D3 01       out  ($01),a
4124: 00          nop
4125: C9          ret

4126: FF FF

    ;; Draw crown,cross,vase (not ring?)... where? when?
4128: 3E 8C       ld   a,$TILE_CROWN_PIKA
412A: 32 17 92    ld   ($9217),a
412D: 3E 8D       ld   a,$TILE_PIK_CROSSA
412F: 32 31 92    ld   ($9231),a
4132: 3E 8F       ld   a,$TILE_PIK_VASEA
4134: 32 2B 92    ld   ($922B),a
4137: C9          ret

4138: FF ...

SET_SYNTH_SETTINGS
4140: DD 7E 00    ld   a,(ix+$00)
4143: A7          and  a
4144: C8          ret  z
4145: 32 66 80    ld   ($8066),a ; not synth!
4148: CB 27       sla  a
414A: 21 00 44    ld   hl,$SFX_SYNTH_SETTINGS
414D: 85          add  a,l
414E: 6F          ld   l,a
414F: 3E 01       ld   a,$01
4151: D3 00       out  ($00),a
4153: 7E          ld   a,(hl)
4154: D3 01       out  ($01),a
4156: 23          inc  hl
4157: 3E 00       ld   a,$00
4159: D3 00       out  ($00),a
415B: 7E          ld   a,(hl)
415C: D3 01       out  ($01),a
415E: 3E 08       ld   a,$08
4160: D3 00       out  ($00),a
4162: DD 7E 02    ld   a,(ix+$02)
4165: C6 00       add  a,$00
4167: D3 01       out  ($01),a
4169: DD 7E 03    ld   a,(ix+$03)
416C: DD 77 05    ld   (ix+$05),a
416F: C9          ret

4170: CD 77 45    call $4577
4173: 3E 8E       ld   a,$TILE_PIK_RINGA
4175: 32 AB 92    ld   ($92AB),a
4178: C9          ret

4179: FF ...

RELATED_TO_MYSTERY_8066
4180: DD 7E 00    ld   a,(ix+$00)
4183: A7          and  a
4184: C8          ret  z
4185: 32 67 80    ld   ($8067),a ; 8067
4188: CB 27       sla  a
418A: 21 00 44    ld   hl,$4400
418D: 85          add  a,l
418E: 6F          ld   l,a
418F: 3E 03       ld   a,$03
4191: D3 00       out  ($00),a
4193: 7E          ld   a,(hl)
4194: D3 01       out  ($01),a
4196: 23          inc  hl
4197: 3E 02       ld   a,$02
4199: D3 00       out  ($00),a
419B: 7E          ld   a,(hl)
419C: D3 01       out  ($01),a
419E: 3E 09       ld   a,$09
41A0: D3 00       out  ($00),a
41A2: DD 7E 02    ld   a,(ix+$02)
41A5: C6 00       add  a,$00
41A7: D3 01       out  ($01),a
41A9: DD 7E 03    ld   a,(ix+$03)
41AC: DD 77 05    ld   (ix+$05),a
41AF: C9          ret

;;; does... something, then calls hit bonus
HIT_BONUS_PRE
41B0: 47          ld   b,a      ; adds bonus score
41B1: 3A 1D 80    ld   a,($SCORE_TO_ADD)
41B4: 80          add  a,b
41B5: 32 1D 80    ld   ($SCORE_TO_ADD),a
41B8: 2B          dec  hl
41B9: 2B          dec  hl
41BA: 2B          dec  hl
41BB: 2B          dec  hl
41BC: 22 4C 80    ld   ($804C),hl
41BF: 7E          ld   a,(hl)
41C0: 32 4E 80    ld   ($804E),a
41C3: 3E 90       ld   a,$90
41C5: CB 38       srl  b
41C7: CB 38       srl  b
41C9: CB 38       srl  b
41CB: CB 38       srl  b
41CD: 80          add  a,b
41CE: 77          ld   (hl),a
41CF: 11 E0 FF    ld   de,$FFE0
41D2: 19          add  hl,de
41D3: 7E          ld   a,(hl)
41D4: 32 4F 80    ld   ($804F),a
41D7: 36 9B       ld   (hl),$9B
41D9: 3E 40       ld   a,$40
41DB: 32 50 80    ld   ($8050),a
41DE: C3 F4 40    jp   $HIT_BONUS

41E1: FF FF

41E3: 3A 00 41    ld   a,($4100)
41E6: 01 E3 01    ld   bc,$CALL_HL_PLUS_4K
41E9: C5          push bc
41EA: E5          push hl
41EB: C9          ret

    ;; DRAW_CROWN_PIK_BOT_RIGHT
41EC: 3E 9C       ld   a,$TILE_CROWN_PIK
41EE: 32 5A 91    ld   ($915A),a
41F1: C9          ret

    ;; DRAW_CROSS_PIK_BOT_RIGHT
41F2: 3E 9D       ld   a,$TILE_PIK_CROSS
41F4: 32 5A 91    ld   ($915A),a
41F7: C9          ret

    ;; draw pikup cross, bot, right-er
41F8: 3E 9D       ld   a,$TILE_PIK_CROSS
41FA: 32 1A 91    ld   ($911A),a
41FD: C9          ret

41FE: FF FF

4200: DD 21 A0 82 ld   ix,$82A0
4204: DD 7E 04    ld   a,(ix+$04)
4207: A7          and  a
4208: 28 08       jr   z,$4212
420A: CD 40 41    call $SET_SYNTH_SETTINGS
420D: DD 36 04 00 ld   (ix+$04),$00
4211: C9          ret
4212: CD 80 40    call $4080
4215: C9          ret

4216: 3E 9C       ld   a,$TILE_CROWN_PIK
4218: 32 B1 91    ld   ($91B1),a
421B: C9          ret

421C: FF ...

4220: DD 21 A8 82 ld   ix,$82A8
4224: DD 7E 04    ld   a,(ix+$04)
4227: A7          and  a
4228: 28 08       jr   z,$4232
422A: CD 80 41    call $RELATED_TO_MYSTERY_8066
422D: DD 36 04 00 ld   (ix+$04),$00
4231: C9          ret

4232: CD C0 40    call $40C0
4235: C9          ret

4236: 3E 9C       ld   a,$TILE_CROWN_PIK
4238: 32 8E 91    ld   ($918E),a
423B: C9          ret

423C: FF ..

4240: DD 21 B0 82 ld   ix,$82B0
4244: DD 7E 04    ld   a,(ix+$04)
4247: A7          and  a
4248: 28 08       jr   z,$4252
424A: CD B0 42    call $42B0
424D: DD 36 04 00 ld   (ix+$04),$00
4251: C9          ret

4252: CD 00 41    call $4100
4255: C9          ret

4256: FF FF

PICKUP_TILE_COLLISION
4258: 3A 40 81    ld   a,($PLAYER_X)
425B: C6 04       add  a,$04    ; lol, 4 pixels to get pickup
425D: 67          ld   h,a
425E: 3A 43 81    ld   a,($PLAYER_Y)
4261: C6 18       add  a,$18
4263: 6F          ld   l,a
4264: CD A7 40    call $GET_TILE_SCR_POS
4267: 7E          ld   a,(hl)
4268: FE 10       cp   $TILE_BLANK
426A: C8          ret  z
    ;;
426B: FE 8C       cp   $TILE_CROWN_PIKA
426D: 20 08       jr   nz,$4277
426F: 3E 20       ld   a,$20    ; 200 bonus
4271: 36 10       ld   (hl),$TILE_BLANK
4273: CD B0 41    call $HIT_BONUS_PRE
4276: C9          ret
4277: FE 8D       cp   $TILE_PIK_CROSSA
4279: 20 08       jr   nz,$4283
427B: 3E 40       ld   a,$40    ; 400 bonus
427D: 36 10       ld   (hl),$TILE_BLANK
427F: CD B0 41    call $HIT_BONUS_PRE
4282: C9          ret
4283: FE 8E       cp   $TILE_PIK_RINGA
4285: 20 08       jr   nz,$428F
4287: 3E 60       ld   a,$60    ; 600 bonus
4289: 36 10       ld   (hl),$TILE_BLANK
428B: CD B0 41    call $HIT_BONUS_PRE
428E: C9          ret
428F: FE 8F       cp   $TILE_PIK_VASEA
4291: C0          ret  nz
4292: 3E A0       ld   a,$A0    ; 1000 bonus
4294: 36 10       ld   (hl),$TILE_BLANK
4296: CD B0 41    call $HIT_BONUS_PRE
4299: C9          ret

;;;
429A: 3E 9D       ld   a,$TILE_PIK_CROSS
429C: 32 D2 91    ld   ($91D2),a
429F: C9          ret
42A0: 3E 8E       ld   a,$TILE_PIK_RINGA
42A2: 32 CB 90    ld   ($90CB),a
42A5: CD 02 36    call $3602    ; <- that looks od. Weird jump
42A8: C9          ret

42A9: FF ...

RELATED_TO_MYSTERY_8066_2
42B0: DD 7E 00    ld   a,(ix+$00)
42B3: A7          and  a
42B4: C8          ret  z
42B5: 32 68 80    ld   ($8068),a
42B8: CB 27       sla  a
42BA: 21 00 44    ld   hl,$4400
42BD: 85          add  a,l
42BE: 6F          ld   l,a
42BF: 3E 05       ld   a,$05
42C1: D3 00       out  ($00),a
42C3: 7E          ld   a,(hl)
42C4: D3 01       out  ($01),a
42C6: 23          inc  hl
42C7: 3E 04       ld   a,$04
42C9: D3 00       out  ($00),a
42CB: 7E          ld   a,(hl)
42CC: D3 01       out  ($01),a
42CE: 3E 0A       ld   a,$0A
42D0: D3 00       out  ($00),a
42D2: DD 7E 02    ld   a,(ix+$02)
42D5: C6 00       add  a,$00
42D7: D3 01       out  ($01),a
42D9: DD 7E 03    ld   a,(ix+$03)
42DC: DD 77 05    ld   (ix+$05),a
42DF: C9          ret

42E0: 3A 50 80    ld   a,($8050)
42E3: A7          and  a
42E4: C8          ret  z
42E5: 3D          dec  a
42E6: 32 50 80    ld   ($8050),a
42E9: A7          and  a
42EA: C9          ret

42EB: 2A 4C 80    ld   hl,($804C)
42EE: 3E 10       ld   a,$10
42F0: 00          nop
42F1: 77          ld   (hl),a
42F2: 11 E0 FF    ld   de,$FFE0
42F5: 19          add  hl,de
42F6: 3E 10       ld   a,$10
42F8: 00          nop
42F9: 77          ld   (hl),a
42FA: C9          ret
42FB: FF ...

4300: F0          ret  p
4301: 70          ld   (hl),b
4302: B0          or   b
4303: 30 D0       jr   nc,$42D5
4305: 50          ld   d,b
4306: 90          sub  b
4307: 10 E0       djnz $42E9
4309: 60          ld   h,b
430A: A0          and  b
430B: 20 C0       jr   nz,$42CD
430D: 40          ld   b,b
430E: 80          add  a,b
430F: 00          nop
4310: FF          rst  $38
4311: FF          rst  $38
4312: CD F8 41    call $41F8
4315: 3E 9E       ld   a,$9E
4317: 32 7A 92    ld   ($927A),a
431A: C9          ret
431B: FF ...

SFX_SOMETHING
4320: DD 6E 07    ld   l,(ix+$07)
4323: DD 66 08    ld   h,(ix+$08)
4326: 7E          ld   a,(hl)
4327: FE FF       cp   $FF
4329: C8          ret  z
432A: DD 86 11    add  a,(ix+$11)
432D: FD 21 A0 82 ld   iy,$82A0
4331: FD 77 00    ld   (iy+$00),a
4334: 23          inc  hl
4335: 46          ld   b,(hl)
4336: DD 7E 0F    ld   a,(ix+$0f)
4339: 4F          ld   c,a
433A: 05          dec  b
433B: 28 03       jr   z,$4340
433D: 81          add  a,c
433E: 18 FA       jr   $433A
4340: 3D          dec  a
4341: DD 77 12    ld   (ix+$12),a
4344: CD 00 52    call $MORE_SFX_SOMETHING?
4347: FD 77 02    ld   (iy+$02),a
434A: DD 7E 0E    ld   a,(ix+$0e)
434D: FD 77 03    ld   (iy+$03),a
4350: 3E 01       ld   a,$01
4352: FD 77 04    ld   (iy+$04),a
4355: C9          ret

4356: FF ...

;;;  synth?
4360: DD 6E 09    ld   l,(ix+$09)
4363: DD 66 0A    ld   h,(ix+$0a)
4366: 7E          ld   a,(hl)
4367: FE FF       cp   $FF
4369: C8          ret  z
436A: DD 86 11    add  a,(ix+$11)
436D: FD 21 A8 82 ld   iy,$82A8
4371: FD 77 00    ld   (iy+$00),a
4374: 23          inc  hl
4375: 46          ld   b,(hl)
4376: DD 7E 0F    ld   a,(ix+$0f)
4379: 4F          ld   c,a
437A: 05          dec  b
437B: 28 03       jr   z,$4380
437D: 81          add  a,c
437E: 18 FA       jr   $437A
4380: 3D          dec  a
4381: DD 77 13    ld   (ix+$13),a
4384: CD 50 52    call $5250
4387: FD 77 02    ld   (iy+$02),a
438A: DD 7E 0E    ld   a,(ix+$0e)
438D: FD 77 03    ld   (iy+$03),a
4390: 3E 01       ld   a,$01
4392: FD 77 04    ld   (iy+$04),a
4395: C9          ret
4396: CD A0 42    call $42A0
4399: 3E 9E       ld   a,$9E
439B: 32 AB 92    ld   ($92AB),a
439E: C9          ret
439F: FF          rst  $38
43A0: DD 6E 0B    ld   l,(ix+$0b)
43A3: DD 66 0C    ld   h,(ix+$0c)
43A6: 7E          ld   a,(hl)
43A7: FE FF       cp   $FF
43A9: C8          ret  z
43AA: DD 86 11    add  a,(ix+$11)
43AD: 23          inc  hl
43AE: FD 21 B0 82 ld   iy,$82B0
43B2: FD 77 00    ld   (iy+$00),a
43B5: 46          ld   b,(hl)
43B6: DD 7E 0F    ld   a,(ix+$0f)
43B9: 4F          ld   c,a
43BA: 05          dec  b
43BB: 28 03       jr   z,$43C0
43BD: 81          add  a,c
43BE: 18 FA       jr   $43BA
43C0: 3D          dec  a
43C1: DD 77 14    ld   (ix+$14),a
43C4: CD A0 52    call $52A0
43C7: FD 77 02    ld   (iy+$02),a
43CA: DD 7E 0E    ld   a,(ix+$0e)
43CD: FD 77 03    ld   (iy+$03),a
43D0: 3E 01       ld   a,$01
43D2: FD 77 04    ld   (iy+$04),a
43D5: C9          ret

43D6: FF ...

43E0: 3E 9F       ld   a,$TILE_PIK_VASE
43E2: 32 EE 92    ld   ($92EE),a
43E5: 3E 9E       ld   a,$TILE_PIK_RING
43E7: 32 17 92    ld   ($9217),a
43EA: C9          ret

43EB: FF

43EC: 3E 9C       ld   a,$TILE_CROWN_PIK
43EE: 32 17 92    ld   ($9217),a
43F1: 3E 9D       ld   a,$TILE_PIK_CROSS
43F3: 32 31 92    ld   ($9231),a
43F6: 3E 9F       ld   a,$TILE_PIK_VASE
43F8: 32 2B 92    ld   ($922B),a
43FB: C9          ret
43FC: FF ...

;;; SFX synth settings data
SFX_SYNTH_SETTINGS
4400: 03 24 03 F6 02 CC 02 A4
4408: 02 7E 02 5A 02 38 02 18
4410: 02 FA 01 DE 01 C3 01 AA
4418: 01 92 01 7B 01 66 01 52
4420: 01 3F 01 2D 01 1C 01 0C
4428: 01 00 00 EF 00 E2 00 D5
4430: 00 C9 00 BE 00 B3 00 A9
4438: 00 A0 00 96 00 8E 00 86
4440: 00 7F 00 78 00 71 00 6B
4448: 00 64 00 5F 00 59 00 54
4450: 00 50 00 4B 00 47 00 43
4458: 00 3F 00 3C 00 38 00 35
4460: 00 32 00 2F 00 2C 00 2A
4468: 00 28 00 25 00 23 00 21
4470: 00 1F 00 1E 00 00 01 04
4478: 01 07 01

447B: FF ...

;;; (draw?) Something when on Cage screen
4484: 3A 04 80    ld   a,($PLAYER_NUM)
4487: A7          and  a
4488: 20 05       jr   nz,$448F
448A: 3A 29 80    ld   a,($SCREEN_NUM)
448D: 18 03       jr   $4492
448F: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
4492: FE 1B       cp   $1B      ; are we on screen 27?
4494: C0          ret  nz       ; Nope, leave.
4495: 3E 74       ld   a,$74
4497: 32 A9 91    ld   ($91A9),a
449A: 3C          inc  a
449B: 32 AA 91    ld   ($91AA),a
449E: 3C          inc  a
449F: 32 C9 91    ld   ($91C9),a
44A2: 3C          inc  a
44A3: 32 CA 91    ld   ($91CA),a
44A6: 3C          inc  a
44A7: 32 AB 91    ld   ($91AB),a
44AA: 3C          inc  a
44AB: 32 AC 91    ld   ($91AC),a
44AE: 3C          inc  a
44AF: 32 CB 91    ld   ($91CB),a
44B2: 3C          inc  a
44B3: 32 CC 91    ld   ($91CC),a
44B6: 3C          inc  a
44B7: 32 8B 91    ld   ($918B),a
44BA: 3C          inc  a
44BB: 32 8C 91    ld   ($918C),a
44BE: 18 24       jr   $44E4
44C0: 10 01       djnz $44C3
44C2: 12          ld   (de),a
44C3: 03          inc  bc
44C4: 14          inc  d
44C5: 01 15 03    ld   bc,$0315
44C8: 17          rla
44C9: 01 19 03    ld   bc,$0319
44CC: 1B          dec  de
44CD: 01 1C 03    ld   bc,$031C
44D0: FF          rst  $38
44D1: FF          rst  $38
44D2: 1C          inc  e
44D3: 01 00 03    ld   bc,$0300
44D6: 1C          inc  e
44D7: 01 00 03    ld   bc,$0300
44DA: 1C          inc  e
44DB: 01 00 03    ld   bc,$0300
44DE: 1C          inc  e
44DF: 01 00 03    ld   bc,$0300
44E2: FF          rst  $38
44E3: FF          rst  $38
44E4: 3C          inc  a
44E5: 32 89 91    ld   ($9189),a
44E8: 3C          inc  a
44E9: 32 8A 91    ld   ($918A),a
44EC: C9          ret

44ED: FF ...

    ;; sfx/tune player
    ;; plays a few samples of sfx each tick

SFX_01 ; La Cucaracha
4500: DD 7E 12    ld   a,(ix+$12)
4503: A7          and  a
4504: 28 05       jr   z,$SFX_02
4506: 3D          dec  a
4507: DD 77 12    ld   (ix+$12),a
450A: C9          ret

SFX_02 ; Minor-key death ditti
450B: DD 6E 07    ld   l,(ix+$07)
450E: DD 66 08    ld   h,(ix+$08)
4511: 23          inc  hl
4512: 23          inc  hl
4513: 7E          ld   a,(hl)
4514: FE FF       cp   $FF
4516: 28 0A       jr   z,$SFX_03
4518: DD 75 07    ld   (ix+$07),l
451B: DD 74 08    ld   (ix+$08),h
451E: CD 20 43    call $SFX_SOMETHING
4521: C9          ret

SFX_03 ; Pickup bling
4522: DD 6E 01    ld   l,(ix+$01)
4525: DD 66 02    ld   h,(ix+$02)
4528: 23          inc  hl
4529: 23          inc  hl
452A: 7E          ld   a,(hl)
452B: FE EE       cp   $EE
452D: 20 23       jr   nz,$SFX_04
452F: 23          inc  hl
4530: 7E          ld   a,(hl)
4531: 4F          ld   c,a
4532: 06 00       ld   b,$00
4534: 37          scf
4535: 3F          ccf
4536: ED 42       sbc  hl,bc
4538: DD 75 01    ld   (ix+$01),l
453B: DD 74 02    ld   (ix+$02),h
453E: 7E          ld   a,(hl)
453F: DD 77 07    ld   (ix+$07),a
4542: 23          inc  hl
4543: 7E          ld   a,(hl)
4544: DD 77 08    ld   (ix+$08),a
4547: DD 6E 07    ld   l,(ix+$07)
454A: DD 66 08    ld   h,(ix+$08)
454D: 7E          ld   a,(hl)
454E: CD 20 43    call $SFX_SOMETHING
4551: C9          ret

4552: FE FF       cp   $FF
4554: C8          ret  z

    ;;  not sfx routine?
4555: DD 75 01    ld   (ix+$01),l
4558: DD 74 02    ld   (ix+$02),h
455B: DD 77 07    ld   (ix+$07),a
455E: 23          inc  hl
455F: 7E          ld   a,(hl)
4560: DD 77 08    ld   (ix+$08),a
4563: CD 20 43    call $SFX_SOMETHING
4566: C9          ret

4567: FF          rst  $38
4568: 3E 8D       ld   a,$8D
456A: 32 1A 91    ld   ($911A),a
456D: C9          ret
456E: FF          rst  $38
456F: FF          rst  $38
4570: 3E 8C       ld   a,$8C
4572: 32 B1 91    ld   ($91B1),a
4575: C9          ret
4576: FF          rst  $38
4577: 3E 8E       ld   a,$8E
4579: 32 CB 90    ld   ($90CB),a
457C: CD 70 40    call $4070
457F: C9          ret

SFX_06 ; cutscene dance start
4580: DD 7E 13    ld   a,(ix+$13)
4583: A7          and  a
4584: 28 05       jr   z,$458B
4586: 3D          dec  a
4587: DD 77 13    ld   (ix+$13),a
458A: C9          ret

    ;; sfxsomething #4
458B: DD 6E 09    ld   l,(ix+$09)
458E: DD 66 0A    ld   h,(ix+$0a)
4591: 23          inc  hl
4592: 23          inc  hl
4593: 7E          ld   a,(hl)
4594: FE FF       cp   $FF
4596: 28 0A       jr   z,$45A2
4598: DD 75 09    ld   (ix+$09),l
459B: DD 74 0A    ld   (ix+$0a),h
459E: CD 60 43    call $4360
45A1: C9          ret

    ;; sfxsomething #5
45A2: DD 6E 03    ld   l,(ix+$03)
45A5: DD 66 04    ld   h,(ix+$04)
45A8: 23          inc  hl
45A9: 23          inc  hl
45AA: 7E          ld   a,(hl)
45AB: FE EE       cp   $EE
45AD: 20 23       jr   nz,$45D2
45AF: 23          inc  hl
45B0: 7E          ld   a,(hl)
45B1: 4F          ld   c,a
45B2: 06 00       ld   b,$00
45B4: 37          scf
45B5: 3F          ccf
45B6: ED 42       sbc  hl,bc
45B8: DD 75 03    ld   (ix+$03),l
45BB: DD 74 04    ld   (ix+$04),h
45BE: 7E          ld   a,(hl)
45BF: DD 77 09    ld   (ix+$09),a
45C2: 23          inc  hl
45C3: 7E          ld   a,(hl)
45C4: DD 77 0A    ld   (ix+$0a),a
45C7: DD 6E 09    ld   l,(ix+$09)
45CA: DD 66 0A    ld   h,(ix+$0a)
45CD: 7E          ld   a,(hl)
45CE: CD 60 43    call $4360
45D1: C9          ret

    ;; sfxsomething #6
45D2: FE FF       cp   $FF
45D4: C8          ret  z
45D5: DD 75 03    ld   (ix+$03),l
45D8: DD 74 04    ld   (ix+$04),h
45DB: DD 77 09    ld   (ix+$09),a
45DE: 23          inc  hl
45DF: 7E          ld   a,(hl)
45E0: DD 77 0A    ld   (ix+$0a),a
45E3: CD 60 43    call $4360
45E6: C9          ret
45E7: FF          rst  $38
45E8: 3E 8D       ld   a,$8D
45EA: 32 5A 91    ld   ($915A),a
45ED: C9          ret

45EE: FF ...

    ;; sfxsomething #7
4600: DD 7E 14    ld   a,(ix+$14)
4603: A7          and  a
4604: 28 05       jr   z,$460B
4606: 3D          dec  a
4607: DD 77 14    ld   (ix+$14),a
460A: C9          ret
460B: DD 6E 0B    ld   l,(ix+$0b)
460E: DD 66 0C    ld   h,(ix+$0c)
4611: 23          inc  hl
4612: 23          inc  hl
4613: 7E          ld   a,(hl)
4614: FE FF       cp   $FF
4616: 28 0A       jr   z,$4622
4618: DD 75 0B    ld   (ix+$0b),l
461B: DD 74 0C    ld   (ix+$0c),h
461E: CD A0 43    call $43A0
4621: C9          ret

    ;; sfxsomething #8
4622: DD 6E 05    ld   l,(ix+$05)
4625: DD 66 06    ld   h,(ix+$06)
4628: 23          inc  hl
4629: 23          inc  hl
462A: 7E          ld   a,(hl)
462B: FE EE       cp   $EE
462D: 20 23       jr   nz,$4652
462F: 23          inc  hl
4630: 7E          ld   a,(hl)
4631: 4F          ld   c,a
4632: 06 00       ld   b,$00
4634: 37          scf
4635: 3F          ccf
4636: ED 42       sbc  hl,bc
4638: DD 75 05    ld   (ix+$05),l
463B: DD 74 06    ld   (ix+$06),h
463E: 7E          ld   a,(hl)
463F: DD 77 0B    ld   (ix+$0b),a
4642: 23          inc  hl
4643: 7E          ld   a,(hl)
4644: DD 77 0C    ld   (ix+$0c),a
4647: DD 6E 0B    ld   l,(ix+$0b)
464A: DD 66 0C    ld   h,(ix+$0c)
464D: 7E          ld   a,(hl)
464E: CD A0 43    call $43A0
4651: C9          ret

    ;; sfxsomething #9
4652: FE FF       cp   $FF
4654: C8          ret  z
4655: DD 75 05    ld   (ix+$05),l
4658: DD 74 06    ld   (ix+$06),h
465B: DD 77 0B    ld   (ix+$0b),a
465E: 23          inc  hl
465F: 7E          ld   a,(hl)
4660: DD 77 0C    ld   (ix+$0c),a
4663: CD A0 43    call $43A0
4666: C9          ret
4667: FF ...

;;; sfx something #10
4680: DD 21 B8 82 ld   ix,$82B8
4684: DD 7E 0D    ld   a,(ix+$0d)
4687: A7          and  a
4688: 28 17       jr   z,$46A1
468A: CD 00 45    call $4500
468D: DD 7E 0D    ld   a,(ix+$0d)
4690: 3D          dec  a
4691: 28 0E       jr   z,$46A1
4693: CD 80 45    call $4580
4696: DD 7E 0D    ld   a,(ix+$0d)
4699: 3D          dec  a
469A: 3D          dec  a
469B: 28 04       jr   z,$46A1
469D: CD 00 46    call $4600
46A0: C9          ret
46A1: C9          ret

46A2: FF ...

    ;;
ADD_A_TO_RET_ADDR
46B0: E1          pop  hl
46B1: 06 00       ld   b,$00
46B3: 4F          ld   c,a
46B4: 09          add  hl,bc
46B5: E5          push hl
46B6: C9          ret

46B7: FF ...

46C0: 21 B8 82    ld   hl,$82B8
46C3: 06 18       ld   b,$18
46C5: 36 00       ld   (hl),$00
46C7: 23          inc  hl
46C8: 10 FB       djnz $46C5
46CA: C9          ret

46CB: FF ...

    ;; gets here on death and re-spawn
CLEAR_SFX_1
46D0: CD C0 46    call $46C0
46D3: 3A 42 80    ld   a,($CH1_SFX)
46D6: CD 30 47    call $4730
46D9: DD 21 B8 82 ld   ix,$82B8
46DD: CD 90 47    call $4790
46E0: AF          xor  a
46E1: 32 42 80    ld   ($CH1_SFX),a
46E4: C9          ret

46E5: FF ...

    ;;
46E8: 3A 34 80    ld   a,($IS_PLAYING)
46EB: A7          and  a
46EC: C8          ret  z
46ED: 3A 04 80    ld   a,($PLAYER_NUM)
46F0: A7          and  a
46F1: 20 05       jr   nz,$46F8
46F3: 3A 29 80    ld   a,($SCREEN_NUM)
46F6: 18 03       jr   $46FB
46F8: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
46FB: 3D          dec  a        ; scr - 1
46FC: 87          add  a,a      ; ...
46FD: 87          add  a,a      ; * 3
46FE: CD B0 49    call $CALL_ADD_A_TO_RET_ADDR
4701: 47          ld   b,a
4702: 3A 65 80    ld   a,($SFX_PREV)
4705: B8          cp   b
4706: C8          ret  z
4707: 78          ld   a,b
4708: 32 42 80    ld   ($CH1_SFX),a ; wat sfx is this?
470B: 32 65 80    ld   ($SFX_PREV),a
470E: C9          ret
470F: FF ...

4720: 76          halt          ; only halt in file!
4721: 0D          dec  c
4722: FF ...

;;;
4730: CB 27       sla  a
4732: CB 27       sla  a
4734: CD B0 46    call $ADD_A_TO_RET_ADDR
4737: 00          nop
4738: 00          nop
4739: 00          nop
473A: C9          ret
;;;

    ;; some kind of address lookup table
;;;  format of dst is: byte, three lots of "addr lo, addr hi"
;;;  some addr seems to point to another addr?
473B: 21 00 5D    ld   hl,$TBL_2
473E: C9          ret
473F: 21 46 4C    ld   hl,$TBL_4
4742: C9          ret
4743: 21 53 50    ld   hl,$TBL_1
4746: C9          ret
4747: 21 BC 50    ld   hl,$50BC
474A: C9          ret
474B: 21 EC 50    ld   hl,$50EC
474E: C9          ret
474F: 21 9A 51    ld   hl,$519A
4752: C9          ret
4753: 21 EA 51    ld   hl,$51EA
4756: C9          ret
4757: 21 14 55    ld   hl,$5514
475A: C9          ret
475B: 21 70 57    ld   hl,$5770
475E: C9          ret
475F: 21 60 55    ld   hl,$5560
4762: C9          ret
4763: 21 EA 5D    ld   hl,$5DEA
4766: C9          ret
4767: 21 88 5E    ld   hl,$5E88
476A: C9          ret
476B: 21 30 5F    ld   hl,$5F30
476E: C9          ret
476F: 21 78 5F    ld   hl,$5F78
4772: C9          ret
4773: 21 40 4B    ld   hl,$TBL_3
4776: C9          ret
4777: 21 00 00    ld   hl,$0000
477A: C9          ret
477B: 21 00 00    ld   hl,$0000
477E: C9          ret
477F: 21 00 00    ld   hl,$0000
4782: C9          ret
4783: 21 00 00    ld   hl,$0000
4786: C9          ret
4787: FF          rst  $38
4788: FF          rst  $38
4789: FF          rst  $38
478A: FF          rst  $38
478B: FF          rst  $38
478C: FF          rst  $38
478D: FF          rst  $38
478E: FF          rst  $38
478F: FF          rst  $38
4790: 00          nop
4791: 00          nop
4792: 00          nop
4793: 00          nop
4794: 7E          ld   a,(hl)
4795: DD 77 0D    ld   (ix+$0d),a
4798: 47          ld   b,a
4799: 23          inc  hl
479A: 7E          ld   a,(hl)
479B: DD 77 01    ld   (ix+$01),a
479E: 23          inc  hl
479F: 7E          ld   a,(hl)
47A0: DD 77 02    ld   (ix+$02),a
47A3: 05          dec  b
47A4: 28 17       jr   z,$47BD
47A6: 23          inc  hl
47A7: 7E          ld   a,(hl)
47A8: DD 77 03    ld   (ix+$03),a
47AB: 23          inc  hl
47AC: 7E          ld   a,(hl)
47AD: DD 77 04    ld   (ix+$04),a
47B0: 05          dec  b
47B1: 28 0A       jr   z,$47BD
47B3: 23          inc  hl
47B4: 7E          ld   a,(hl)
47B5: DD 77 05    ld   (ix+$05),a
47B8: 23          inc  hl
47B9: 7E          ld   a,(hl)
47BA: DD 77 06    ld   (ix+$06),a
47BD: DD 66 02    ld   h,(ix+$02)
47C0: DD 6E 01    ld   l,(ix+$01)
47C3: 7E          ld   a,(hl)
47C4: DD 77 0E    ld   (ix+$0e),a
47C7: 23          inc  hl
47C8: 7E          ld   a,(hl)
47C9: DD 77 0F    ld   (ix+$0f),a
47CC: 23          inc  hl
47CD: 7E          ld   a,(hl)
47CE: DD 77 10    ld   (ix+$10),a
47D1: 23          inc  hl
47D2: 7E          ld   a,(hl)
47D3: DD 77 11    ld   (ix+$11),a
47D6: DD 36 12 00 ld   (ix+$12),$00
47DA: DD 36 13 00 ld   (ix+$13),$00
47DE: DD 36 14 00 ld   (ix+$14),$00
47E2: 23          inc  hl
47E3: DD 75 01    ld   (ix+$01),l
47E6: DD 74 02    ld   (ix+$02),h
47E9: 7E          ld   a,(hl)
47EA: DD 77 07    ld   (ix+$07),a
47ED: 23          inc  hl
47EE: 7E          ld   a,(hl)
47EF: DD 77 08    ld   (ix+$08),a
47F2: DD 6E 03    ld   l,(ix+$03)
47F5: DD 66 04    ld   h,(ix+$04)
47F8: 7E          ld   a,(hl)
47F9: DD 77 09    ld   (ix+$09),a
47FC: 23          inc  hl
47FD: 7E          ld   a,(hl)
47FE: DD 77 0A    ld   (ix+$0a),a
4801: DD 6E 05    ld   l,(ix+$05)
4804: DD 66 04    ld   h,(ix+$04)
4807: 7E          ld   a,(hl)
4808: DD 77 0B    ld   (ix+$0b),a
480B: 23          inc  hl
480C: 7E          ld   a,(hl)
480D: DD 77 0C    ld   (ix+$0c),a
4810: CD 20 43    call $SFX_SOMETHING
4813: DD 7E 0D    ld   a,(ix+$0d)
4816: 3D          dec  a
4817: C8          ret  z
4818: CD 60 43    call $4360
481B: DD 7E 0D    ld   a,(ix+$0d)
481E: 3D          dec  a
481F: 3D          dec  a
4820: C8          ret  z
4821: CD A0 43    call $43A0
4824: C9          ret
4825: FF ...

SFX_QUEUER
4840: 3A 42 80    ld   a,($CH1_SFX)
4843: A7          and  a
4844: 20 05       jr   nz,$484B
4846: CD 80 46    call $4680    ; play in ch1
4849: 18 03       jr   $484E
484B: CD D0 46    call $CLEAR_SFX_1  ; ... kill ch1?
484E: 3A 43 80    ld   a,($CH2_SFX)  ; and try ch2?
4851: A7          and  a
4852: 20 05       jr   nz,$4859
4854: CD E0 48    call $48E0    ; play in ch2?
4857: 18 03       jr   $485C
4859: CD 20 49    call $CLEAR_SFX_2 ;
485C: 3A 44 80    ld   a,($SFX_ID)
485F: A7          and  a
4860: 20 05       jr   nz,$4867
4862: CD 7C 48    call $MORE_SFX_SOMETHING
4865: 18 03       jr   $486A
4867: CD 9C 48    call $PLAY_SFX
486A: C9          ret
486B: FF ...

;;; called from PLAY_SFX...
4870: 21 E8 82    ld   hl,$82E8
4873: 06 18       ld   b,$18
4875: 36 00       ld   (hl),$00
4877: 23          inc  hl
4878: 10 FB       djnz $4875
487A: C9          ret
487B: FF          rst  $38

;;; more sfx something
MORE_SFX_SOMETHING
487C: DD 21 E8 82 ld   ix,$82E8
4880: DD 7E 0D    ld   a,(ix+$0d)
4883: A7          and  a
4884: C8          ret  z
4885: CD 00 46    call $4600
4888: DD 7E 0D    ld   a,(ix+$0d)
488B: 3D          dec  a
488C: C8          ret  z
488D: CD 00 45    call $4500
4890: DD 7E 0D    ld   a,(ix+$0d)
4893: 3D          dec  a
4894: 3D          dec  a
4895: C8          ret  z
4896: CD 80 45    call $4580
4899: C9          ret

489A: FF FF

PLAY_SFX
489C: CD 70 48    call $4870
489F: 3A 44 80    ld   a,($SFX_ID)
48A2: CD 30 47    call $4730
48A5: DD 21 E8 82 ld   ix,$82E8
48A9: CD 90 47    call $4790
48AC: AF          xor  a
48AD: 32 44 80    ld   ($SFX_ID),a
48B0: C9          ret
48B1: FF          rst  $38

48B2: CD 50 4B    call $4B50
48B5: CD A8 5A    call $FLASH_BORDER
48B8: CD A8 5A    call $FLASH_BORDER
48BB: CD A8 5A    call $FLASH_BORDER
48BE: CD A8 5A    call $FLASH_BORDER
48C1: 21 70 14    ld   hl,$CALL_RESET_SCREEN_META_AND_SPRITES
48C4: CD 81 5C    call $JMP_HL
48C7: CD A8 5A    call $FLASH_BORDER
48CA: C9          ret
48CB: FF ...

;;; Even more sfx something
48E0: DD 21 D0 82 ld   ix,$82D0
48E4: DD 7E 0D    ld   a,(ix+$0d)
48E7: A7          and  a
48E8: C8          ret  z
48E9: CD 80 45    call $4580
48EC: DD 7E 0D    ld   a,(ix+$0d)
48EF: 3D          dec  a
48F0: C8          ret  z
48F1: CD 00 46    call $4600
48F4: DD 7E 0D    ld   a,(ix+$0d)
48F7: 3D          dec  a
48F8: 3D          dec  a
48F9: C8          ret  z
48FA: CD 00 45    call $4500
48FD: C9          ret

48FE: FF ...

SHADOW_ADD_A_TO_RET_2            ; duplicate routine
4900: D9          exx
4901: E1          pop  hl
4902: 06 00       ld   b,$00
4904: 4F          ld   c,a
4905: 09          add  hl,bc
4906: E5          push hl
4907: D9          exx
4908: C9          ret
4909: FF ...

4910: 21 D0 82    ld   hl,$82D0
4913: 06 18       ld   b,$18
4915: 36 00       ld   (hl),$00
4917: 23          inc  hl
4918: 10 FB       djnz $4915
491A: C9          ret
491B: FF ...

CLEAR_SFX_2
4920: CD 10 49    call $4910
4923: 3A 43 80    ld   a,($CH2_SFX)
4926: CD 30 47    call $4730
4929: DD 21 D0 82 ld   ix,$82D0
492D: CD 90 47    call $4790
4930: AF          xor  a
4931: 32 43 80    ld   ($CH2_SFX),a
4934: C9          ret
4935: FF ...

4940: 00          nop
4941: 00          nop
4942: 0E 00       ld   c,$00
4944: CB 47       bit  0,a
4946: 28 02       jr   z,$494A
4948: CB E8       set  5,b
494A: CB 4F       bit  1,a
494C: 28 02       jr   z,$4950
494E: CB E0       set  4,b
4950: CB 57       bit  2,a
4952: 28 02       jr   z,$4956
4954: CB F9       set  7,c
4956: CB 5F       bit  3,a
4958: 28 02       jr   z,$495C
495A: CB F1       set  6,c
495C: CB 67       bit  4,a
495E: 28 02       jr   z,$4962
4960: CB E9       set  5,c
4962: CB 6F       bit  5,a
4964: 28 02       jr   z,$4968
4966: CB E1       set  4,c
4968: CB 77       bit  6,a
496A: 28 02       jr   z,$496E
496C: CB D9       set  3,c
496E: CB 7F       bit  7,a
4970: 28 02       jr   z,$4974
4972: CB D1       set  2,c
4974: 78          ld   a,b
4975: 00          nop
4976: 00          nop
4977: 00          nop
4978: 79          ld   a,c
4979: 00          nop
497A: 00          nop
497B: 00          nop
497C: C9          ret
497D: FF ...

4980: 00          nop
4981: 00          nop
4982: 0E F0       ld   c,$F0
4984: CB 47       bit  0,a
4986: 28 02       jr   z,$498A
4988: CB B9       res  7,c
498A: CB 4F       bit  1,a
498C: 28 02       jr   z,$4990
498E: CB B1       res  6,c
4990: CB 57       bit  2,a
4992: 28 02       jr   z,$4996
4994: CB A9       res  5,c
4996: CB 5F       bit  3,a
4998: 28 02       jr   z,$499C
499A: CB A1       res  4,c
499C: 79          ld   a,c
499D: 80          add  a,b
499E: 00          nop
499F: 00          nop
49A0: 00          nop
49A1: C9          ret
49A2: FF ...

    ;;
CALL_ADD_A_TO_RET_ADDR
49B0: CD B0 46    call $ADD_A_TO_RET_ADDR
    ;; Is this code or data? 27 cases...
49B3: 3E 0E       ld   a,$0E
49B5: C9          ret
49B6: 00          nop
49B7: 3E 0E       ld   a,$0E
49B9: C9          ret
49BA: 00          nop
49BB: 3E 0E       ld   a,$0E
49BD: C9          ret
49BE: 00          nop
49BF: 3E 0E       ld   a,$0E
49C1: C9          ret
49C2: 00          nop
49C3: 3E 0E       ld   a,$0E
49C5: C9          ret
49C6: 00          nop
49C7: 3E 0E       ld   a,$0E
49C9: C9          ret
49CA: 00          nop
49CB: 3E 0D       ld   a,$0D
49CD: C9          ret
49CE: 00          nop
49CF: 3E 01       ld   a,$01
49D1: C9          ret
49D2: 00          nop
49D3: 3E 01       ld   a,$01
49D5: C9          ret
49D6: 00          nop
49D7: 3E 01       ld   a,$01
49D9: C9          ret
49DA: 00          nop
49DB: 3E 01       ld   a,$01
49DD: C9          ret
49DE: 00          nop
49DF: 3E 01       ld   a,$01
49E1: C9          ret
49E2: 00          nop
49E3: 3E 0B       ld   a,$0B
49E5: C9          ret
49E6: 00          nop
49E7: 3E 0B       ld   a,$0B
49E9: C9          ret
49EA: 00          nop
49EB: 3E 0B       ld   a,$0B
49ED: C9          ret
49EE: 00          nop
49EF: 3E 0B       ld   a,$0B
49F1: C9          ret
49F2: 00          nop
49F3: 3E 0B       ld   a,$0B
49F5: C9          ret
49F6: 00          nop
49F7: 3E 0B       ld   a,$0B
49F9: C9          ret
49FA: 00          nop
49FB: 3E 0B       ld   a,$0B
49FD: C9          ret
49FE: 00          nop
49FF: 3E 0D       ld   a,$0D
4A01: C9          ret
4A02: 00          nop
4A03: 3E 0C       ld   a,$0C
4A05: C9          ret
4A06: 00          nop
4A07: 3E 0C       ld   a,$0C
4A09: C9          ret
4A0A: 00          nop
4A0B: 3E 0C       ld   a,$0C
4A0D: C9          ret
4A0E: 00          nop
4A0F: 3E 0C       ld   a,$0C
4A11: C9          ret
4A12: 00          nop
4A13: 3E 0C       ld   a,$0C
4A15: C9          ret
4A16: 00          nop
4A17: 3E 0C       ld   a,$0C
4A19: C9          ret
4A1A: 00          nop
4A1B: 3E 0E       ld   a,$0E
4A1D: C9          ret
4A1E: 00          nop

4A1F: FF          rst  $38

4A20: 15          dec  d
4A21: 01 17 01    ld   bc,$0117
4A24: 19          add  hl,de
4A25: 01 1A 02    ld   bc,$021A
4A28: 1A          ld   a,(de)
4A29: 02          ld   (bc),a
4A2A: 18 02       jr   $4A2E
4A2C: 18 02       jr   $4A30
4A2E: 17          rla
4A2F: 02          ld   (bc),a
4A30: 17          rla
4A31: 02          ld   (bc),a
4A32: 16 02       ld   d,$02
4A34: 16 02       ld   d,$02
4A36: 15          dec  d
4A37: 02          ld   (bc),a
4A38: 15          dec  d
4A39: 02          ld   (bc),a
4A3A: 13          inc  de
4A3B: 02          ld   (bc),a
4A3C: 13          inc  de
4A3D: 02          ld   (bc),a
4A3E: 12          ld   (de),a
4A3F: 01 0E 01    ld   bc,$010E
4A42: 10 01       djnz $4A45
4A44: 0E 02       ld   c,$02
4A46: FF          rst  $38
4A47: FF          rst  $38
4A48: 15          dec  d
4A49: 01 17 01    ld   bc,$0117
4A4C: 19          add  hl,de
4A4D: 01 21 01    ld   bc,$0121
4A50: 26 02       ld   h,$02
4A52: 21 01 26    ld   hl,$2601
4A55: 02          ld   (bc),a
4A56: 21 02 20    ld   hl,$2002
4A59: 01 26 02    ld   bc,$0226
4A5C: 20 01       jr   nz,$4A5F
4A5E: 26 02       ld   h,$02
4A60: 20 02       jr   nz,$4A64
4A62: 1F          rra
4A63: 01 26 02    ld   bc,$0226
4A66: 1F          rra
4A67: 01 26 02    ld   bc,$0226
4A6A: 1F          rra
4A6B: 02          ld   (bc),a
4A6C: 1E 01       ld   e,$01
4A6E: 1F          rra
4A6F: 01 20 01    ld   bc,$0120
4A72: 21 02 FF    ld   hl,$FF02
4A75: FF          rst  $38
4A76: FF          rst  $38
4A77: FF          rst  $38
4A78: FF          rst  $38
4A79: FF          rst  $38
4A7A: FF          rst  $38
4A7B: FF          rst  $38
4A7C: FF          rst  $38
4A7D: FF          rst  $38
4A7E: FF          rst  $38
4A7F: FF          rst  $38
4A80: 13          inc  de
4A81: 04          inc  b
4A82: 1A          ld   a,(de)
4A83: 04          inc  b
4A84: 1A          ld   a,(de)
4A85: 04          inc  b
4A86: 18 02       jr   $4A8A
4A88: 17          rla
4A89: 02          ld   (bc),a
4A8A: 18 02       jr   $4A8E
4A8C: 1A          ld   a,(de)
4A8D: 02          ld   (bc),a
4A8E: 1C          inc  e
4A8F: 02          ld   (bc),a
4A90: 1A          ld   a,(de)
4A91: 0A          ld   a,(bc)
4A92: FF          rst  $38
4A93: FF          rst  $38
4A94: 1F          rra
4A95: 02          ld   (bc),a
4A96: 1E 02       ld   e,$02
4A98: 1C          inc  e
4A99: 04          inc  b
4A9A: 1A          ld   a,(de)
4A9B: 02          ld   (bc),a
4A9C: 18 02       jr   $4AA0
4A9E: 17          rla
4A9F: 04          inc  b
4AA0: 15          dec  d
4AA1: 02          ld   (bc),a
4AA2: 13          inc  de
4AA3: 02          ld   (bc),a
4AA4: 15          dec  d
4AA5: 02          ld   (bc),a
4AA6: 17          rla
4AA7: 0A          ld   a,(bc)
4AA8: FF          rst  $38
4AA9: FF          rst  $38
4AAA: 23          inc  hl
4AAB: 02          ld   (bc),a
4AAC: 21 02 1F    ld   hl,$1F02
4AAF: 02          ld   (bc),a
4AB0: 1E 02       ld   e,$02
4AB2: 1C          inc  e
4AB3: 02          ld   (bc),a
4AB4: 1A          ld   a,(de)
4AB5: 02          ld   (bc),a
4AB6: 18 02       jr   $4ABA
4AB8: 17          rla
4AB9: 02          ld   (bc),a
4ABA: 15          dec  d
4ABB: 02          ld   (bc),a
4ABC: 13          inc  de
4ABD: 02          ld   (bc),a
4ABE: 12          ld   (de),a
4ABF: 02          ld   (bc),a
4AC0: 13          inc  de
4AC1: 0A          ld   a,(bc)
4AC2: FF          rst  $38
4AC3: FF          rst  $38
4AC4: 15          dec  d
4AC5: 03          inc  bc
4AC6: 1A          ld   a,(de)
4AC7: 04          inc  b
4AC8: 1A          ld   a,(de)
4AC9: 04          inc  b
4ACA: 1A          ld   a,(de)
4ACB: 04          inc  b
4ACC: 1A          ld   a,(de)
4ACD: 04          inc  b
4ACE: 17          rla
4ACF: 04          inc  b
4AD0: 17          rla
4AD1: 04          inc  b
4AD2: 1A          ld   a,(de)
4AD3: 08          ex   af,af'
4AD4: 1A          ld   a,(de)
4AD5: 04          inc  b
4AD6: 1A          ld   a,(de)
4AD7: 04          inc  b
4AD8: 1A          ld   a,(de)
4AD9: 04          inc  b
4ADA: 1A          ld   a,(de)
4ADB: 04          inc  b
4ADC: 19          add  hl,de
4ADD: 04          inc  b
4ADE: 19          add  hl,de
4ADF: 04          inc  b
4AE0: 1A          ld   a,(de)
4AE1: 05          dec  b
4AE2: FF          rst  $38
4AE3: FF          rst  $38
4AE4: 15          dec  d
4AE5: 03          inc  bc
4AE6: 15          dec  d
4AE7: 02          ld   (bc),a
4AE8: 15          dec  d
4AE9: 02          ld   (bc),a
4AEA: 15          dec  d
4AEB: 02          ld   (bc),a
4AEC: 15          dec  d
4AED: 02          ld   (bc),a
4AEE: 13          inc  de
4AEF: 02          ld   (bc),a
4AF0: 13          inc  de
4AF1: 02          ld   (bc),a
4AF2: 10 02       djnz $4AF6
4AF4: 10 02       djnz $4AF8
4AF6: 10 02       djnz $4AFA
4AF8: 10 02       djnz $4AFC
4AFA: 0E 02       ld   c,$02
4AFC: 0E 02       ld   c,$02
4AFE: 09          add  hl,bc
4AFF: 02          ld   (bc),a
4B00: 09          add  hl,bc
4B01: 01 09 02    ld   bc,$0209
4B04: FF          rst  $38
4B05: FF          rst  $38
4B06: 15          dec  d
4B07: 20 FF       jr   nz,$4B08
4B09: FF          rst  $38
4B0A: FF          rst  $38
4B0B: FF          rst  $38
4B0C: 15          dec  d
4B0D: 01 1A 02    ld   bc,$021A
4B10: 15          dec  d
4B11: 01 1A 02    ld   bc,$021A
4B14: 15          dec  d
4B15: 02          ld   (bc),a
4B16: 14          inc  d
4B17: 01 1A 02    ld   bc,$021A
4B1A: 14          inc  d
4B1B: 01 1A 02    ld   bc,$021A
4B1E: 14          inc  d
4B1F: 02          ld   (bc),a
4B20: 13          inc  de
4B21: 01 1A 02    ld   bc,$021A
4B24: 13          inc  de
4B25: 01 1A 02    ld   bc,$021A
4B28: 13          inc  de
4B29: 02          ld   (bc),a
4B2A: 12          ld   (de),a
4B2B: 02          ld   (bc),a
4B2C: 09          add  hl,bc
4B2D: 02          ld   (bc),a
4B2E: 0E 02       ld   c,$02
4B30: FF          rst  $38
4B31: FF          rst  $38
4B32: 01 05 0F    ld   bc,$0F05
4B35: 00          nop
4B36: 0C          inc  c
4B37: 4B          ld   c,e
4B38: FF          rst  $38
4B39: FF          rst  $38
4B3A: FF          rst  $38
4B3B: FF          rst  $38
4B3C: 48          ld   c,b
4B3D: 4B          ld   c,e
4B3E: FF          rst  $38
4B3F: FF          rst  $38

TBL_3
4B40: 03
4B41: 32 4B
4B43: 36 4B
4B45: 36 4B

4B47: FF          rst  $38
4B48: 00          nop
4B49: 01 FF FF    ld   bc,$FFFF
4B4C: FF          rst  $38
4B4D: FF          rst  $38
4B4E: FF          rst  $38
4B4F: FF          rst  $38
4B50: 21 40 81    ld   hl,$PLAYER_X
4B53: 36 85       ld   (hl),$85
4B55: 23          inc  hl
4B56: 36 2C       ld   (hl),$2C
4B58: 23          inc  hl
4B59: 36 12       ld   (hl),$12
4B5B: 23          inc  hl
4B5C: 36 90       ld   (hl),$90
4B5E: 23          inc  hl
4B5F: 36 7E       ld   (hl),$7E
4B61: 23          inc  hl
4B62: 36 30       ld   (hl),$30
4B64: 23          inc  hl
4B65: 36 12       ld   (hl),$12
4B67: 23          inc  hl
4B68: 36 A0       ld   (hl),$A0
4B6A: 23          inc  hl
4B6B: C9          ret
4B6C: FF ...

4BE0: 0E 04       ld   c,$04
4BE2: 0E 02       ld   c,$02
4BE4: 0C          inc  c
4BE5: 02          ld   (bc),a
4BE6: 0E 04       ld   c,$04
4BE8: 11 02 10    ld   de,$1002
4BEB: 02          ld   (bc),a
4BEC: 0E 02       ld   c,$02
4BEE: 0E 02       ld   c,$02
4BF0: 0C          inc  c
4BF1: 02          ld   (bc),a
4BF2: 0E 10       ld   c,$10
4BF4: FF          rst  $38
4BF5: FF          rst  $38
4BF6: 09          add  hl,bc
4BF7: 04          inc  b
4BF8: 07          rlca
4BF9: 02          ld   (bc),a
4BFA: 09          add  hl,bc
4BFB: 04          inc  b
4BFC: 1A          ld   a,(de)
4BFD: 02          ld   (bc),a
4BFE: 18 02       jr   $4C02
4C00: 18 02       jr   $4C04
4C02: 09          add  hl,bc
4C03: 02          ld   (bc),a
4C04: 09          add  hl,bc
4C05: 02          ld   (bc),a
4C06: 07          rlca
4C07: 02          ld   (bc),a
4C08: 09          add  hl,bc
4C09: 04          inc  b
4C0A: FF          rst  $38
4C0B: FF          rst  $38
4C0C: FF          rst  $38
4C0D: FF          rst  $38
4C0E: FF          rst  $38
4C0F: FF          rst  $38
4C10: FF          rst  $38
4C11: FF          rst  $38
4C12: FF          rst  $38
4C13: FF          rst  $38
4C14: FF          rst  $38
4C15: FF          rst  $38
4C16: FF          rst  $38
4C17: FF          rst  $38
4C18: FF          rst  $38
4C19: FF          rst  $38
4C1A: FF          rst  $38
4C1B: FF          rst  $38
4C1C: FF          rst  $38
4C1D: FF          rst  $38
4C1E: FF          rst  $38
4C1F: FF          rst  $38
4C20: FF          rst  $38
4C21: FF          rst  $38
4C22: FF          rst  $38
4C23: FF          rst  $38
4C24: FF          rst  $38
4C25: FF          rst  $38
4C26: FF          rst  $38
4C27: FF          rst  $38
4C28: FF          rst  $38
4C29: FF          rst  $38
4C2A: FF          rst  $38
4C2B: FF          rst  $38
4C2C: FF          rst  $38
4C2D: FF          rst  $38
4C2E: FF          rst  $38
4C2F: FF          rst  $38
4C30: 32 4C FF    ld   ($FF4C),a
4C33: FF          rst  $38
4C34: FF          rst  $38
4C35: FF          rst  $38
4C36: 01 04 0F    ld   bc,$0F04
4C39: 00          nop
4C3A: E0          ret  po
4C3B: 4B          ld   c,e
4C3C: FF          rst  $38
4C3D: FF          rst  $38
4C3E: F6 4B       or   $4B
4C40: FF          rst  $38
4C41: FF          rst  $38
4C42: 0C          inc  c
4C43: 0C          inc  c
4C44: FF          rst  $38
4C45: FF          rst  $38

TBL_4
4C46: 03
4C47: 36 4C
4C49: 3E 4C
4C4B: 30 4C

4C4D: FF          rst  $38
4C4E: FF          rst  $38
4C4F: FF          rst  $38

4C50: CD 84 44    call $4484    ; draw something on cage screen
4C53: 3A 04 80    ld   a,($PLAYER_NUM)
4C56: A7          and  a
4C57: 28 05       jr   z,$4C5E
4C59: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
4C5C: 18 03       jr   $4C61
4C5E: 3A 29 80    ld   a,($SCREEN_NUM)
4C61: 3D          dec  a
4C62: 87          add  a,a
4C63: 87          add  a,a
4C64: CD 00 49    call $SHADOW_ADD_A_TO_RET_2
4C67: CD E3 4C    call $4CE3
4C6A: C9          ret
4C6B: CD E8 45    call $45E8
4C6E: C9          ret
4C6F: CD 68 45    call $4568
4C72: C9          ret
4C73: CD E3 4C    call $4CE3
4C76: C9          ret
4C77: CD 70 45    call $4570
4C7A: C9          ret
4C7B: CD 70 40    call $4070
4C7E: C9          ret
4C7F: CD 78 40    call $4078
4C82: C9          ret
4C83: CD E8 45    call $45E8
4C86: C9          ret
4C87: CD 68 45    call $4568
4C8A: C9          ret
4C8B: CD 70 45    call $4570
4C8E: C9          ret
4C8F: CD 77 45    call $4577
4C92: C9          ret
4C93: CD 78 40    call $4078
4C96: C9          ret
4C97: CD E3 4C    call $4CE3
4C9A: C9          ret
4C9B: CD 40 40    call $4040
4C9E: C9          ret
4C9F: CD E8 45    call $45E8
4CA2: C9          ret
4CA3: CD E8 40    call $40E8
4CA6: C9          ret
4CA7: CD 78 40    call $4078
4CAA: C9          ret
4CAB: CD E8 45    call $45E8
4CAE: C9          ret
4CAF: CD E8 40    call $40E8
4CB2: C9          ret
4CB3: CD 78 40    call $4078
4CB6: C9          ret
4CB7: CD 28 41    call $4128
4CBA: C9          ret
4CBB: CD 77 45    call $4577
4CBE: C9          ret
4CBF: CD 78 40    call $4078
4CC2: C9          ret
4CC3: CD 28 41    call $4128
4CC6: C9          ret
4CC7: CD 70 41    call $4170
4CCA: C9          ret
4CCB: CD 78 40    call $4078
4CCE: C9          ret
4CCF: 00          nop
4CD0: 00          nop
4CD1: 00          nop
4CD2: C9          ret
4CD3: 00          nop
4CD4: 00          nop
4CD5: 00          nop
4CD6: C9          ret
4CD7: FF          rst  $38
4CD8: FF          rst  $38
4CD9: FF          rst  $38
4CDA: FF          rst  $38
4CDB: FF          rst  $38
4CDC: FF          rst  $38
4CDD: FF          rst  $38
4CDE: FF          rst  $38
4CDF: FF          rst  $38
4CE0: FF          rst  $38
4CE1: FF          rst  $38
4CE2: FF          rst  $38
4CE3: 3E 8C       ld   a,$8C
4CE5: 32 5A 91    ld   ($915A),a
4CE8: C9          ret
4CE9: FF          rst  $38

;;;
4CEA: 3A 4C 81    ld   a,($DINO_X)
4CED: D6 84       sub  $84
4CEF: 37          scf
4CF0: 3F          ccf
4CF1: D6 18       sub  $18
4CF3: D0          ret  nc       ; not lined up with dino - return.
4CF4: 3A 4F 81    ld   a,($DINO_Y)
4CF7: CB 3F       srl  a
4CF9: CB 3F       srl  a
4CFB: CB 3F       srl  a
4CFD: 47          ld   b,a
4CFE: 7D          ld   a,l
4CFF: E6 1F       and  $1F
4D01: 90          sub  b
4D02: 37          scf
4D03: 3F          ccf
4D04: C3 B4 4D    jp   $WAIT_FOR_CAGE_DOWN

4D07: FF

DRAW_CAGE_TILES
4D08: CD 60 4D    call $BLANK_OUT_3_TILES
4D0B: E5          push hl
4D0C: 2B          dec  hl
4D0D: 36 10       ld   (hl),$10
4D0F: 23          inc  hl
4D10: 36 76       ld   (hl),$76
4D12: 23          inc  hl
4D13: 36 77       ld   (hl),$77
4D15: 23          inc  hl
4D16: 36 7A       ld   (hl),$7A
4D18: 23          inc  hl
4D19: 36 7B       ld   (hl),$7B
4D1B: 01 DC FF    ld   bc,$FFDC
4D1E: 09          add  hl,bc
4D1F: 36 10       ld   (hl),$10
4D21: 23          inc  hl
4D22: 36 74       ld   (hl),$74
4D24: 23          inc  hl
4D25: 36 75       ld   (hl),$75
4D27: 23          inc  hl
4D28: 36 78       ld   (hl),$78
4D2A: 23          inc  hl
4D2B: 36 79       ld   (hl),$79
4D2D: 09          add  hl,bc
4D2E: 36 10       ld   (hl),$10
4D30: 23          inc  hl
4D31: 36 7E       ld   (hl),$7E
4D33: 23          inc  hl
4D34: 36 7F       ld   (hl),$7F
4D36: 23          inc  hl
4D37: 36 7C       ld   (hl),$7C
4D39: 23          inc  hl
4D3A: 36 7D       ld   (hl),$7D
4D3C: E1          pop  hl
4D3D: C9          ret

4D3E: FF FF

TRIGGER_CAGE_FALL
4D40: CD 75 4E    call $4E75
4D43: CD 08 4D    call $DRAW_CAGE_TILES
4D46: E5          push hl
4D47: 21 A0 13    ld   hl,$WAIT_VBLANK
4D4A: CD 81 5C    call $JMP_HL
4D4D: 3A 12 83    ld   a,($TICK_NUM)
4D50: E6 03       and  $03
4D52: 20 F3       jr   nz,$4D47
4D54: E1          pop  hl
4D55: 23          inc  hl
4D56: CD EA 4C    call $4CEA
4D59: 3E DC       ld   a,$DC    ; did cage hit ground?
4D5B: BD          cp   l
4D5C: C8          ret  z
4D5D: 18 E4       jr   $4D43    ;nope, loop

4D5F: FF

BLANK_OUT_3_TILES               ; which ones?
4D60: AF          xor  a
4D61: 32 26 81    ld   ($SCREEN_XOFF_COL+26),a
4D64: 32 28 81    ld   ($SCREEN_XOFF_COL+28),a
4D67: 32 2A 81    ld   ($SCREEN_XOFF_COL+2A),a
4D6A: C9          ret

4D6B: FF ...

END_SCREEN_LOGIC
4D74: 3A 04 80    ld   a,($PLAYER_NUM) ; are we on end screen?
4D77: A7          and  a
4D78: 20 05       jr   nz,$4D7F
4D7A: 3A 29 80    ld   a,($SCREEN_NUM)
4D7D: 18 03       jr   $4D82
4D7F: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
4D82: FE 1B       cp   $1B      ;// check is screen 27
4D84: C0          ret  nz
4D85: CD 90 4D    call $CHECK_TOUCHING_CAGE
4D88: C9          ret

4D89: FF ...

CHECK_TOUCHING_CAGE
4D90: 3A 51 80    ld   a,($IS_HIT_CAGE)
4D93: A7          and  a
4D94: C0          ret  nz
4D95: 3A 40 81    ld   a,($PLAYER_X)
4D98: D6 70       sub  $70
4D9A: 37          scf
4D9B: 3F          ccf
4D9C: D6 20       sub  $20
4D9E: D0          ret  nc
4D9F: 3A 43 81    ld   a,($PLAYER_Y)
4DA2: D6 30       sub  $30
4DA4: 37          scf
4DA5: 3F          ccf
4DA6: D6 1C       sub  $1C
4DA8: D0          ret  nc
4DA9: 3E 01       ld   a,$01    ; Yep, trigger cage
4DAB: 32 51 80    ld   ($IS_HIT_CAGE),a
4DAE: CD 40 4D    call $TRIGGER_CAGE_FALL
4DB1: C9          ret

4DB2: FF FF

WAIT_FOR_CAGE_DOWN
4DB4: D6 02       sub  $02
4DB6: D0          ret  nc
4DB7: C3 D0 4D    jp   $DONE_CAGED_DINO

4DBA: FF ...

    ;; really wait vblank?
REALLY_VBLANK
4DC0: 2E 40       ld   l,$40
4DC2: E5          push hl
4DC3: 21 A0 13    ld   hl,$WAIT_VBLANK
4DC6: CD 81 5C    call $JMP_HL
4DC9: E1          pop  hl
4DCA: 2D          dec  l
4DCB: 20 F5       jr   nz,$4DC2
4DCD: C9          ret

4DCE: FF FF

DONE_CAGED_DINO
4DD0: AF          xor  a
4DD1: 32 4C 81    ld   ($DINO_X),a
4DD4: 32 50 81    ld   ($DINO_X_LEGS),a
4DD7: CD 08 4D    call $DRAW_CAGE_TILES
4DDA: E5          push hl
4DDB: 21 A0 13    ld   hl,$WAIT_VBLANK
4DDE: CD 81 5C    call $JMP_HL
4DE1: E1          pop  hl
4DE2: 23          inc  hl
4DE3: 3E DC       ld   a,$DC
4DE5: BD          cp   l
4DE6: 20 EF       jr   nz,$4DD7
4DE8: 3E 91       ld   a,$91
4DEA: 32 4C 81    ld   ($DINO_X),a
4DED: 3E 38       ld   a,$38
4DEF: 32 4D 81    ld   ($DINO_FRAME),a
4DF2: 3E 12       ld   a,$12
4DF4: 32 4E 81    ld   ($DINO_COL),a
4DF7: 3E D7       ld   a,$D7
4DF9: 32 4F 81    ld   ($DINO_Y),a
4DFC: 3E 8A       ld   a,$8A
4DFE: 32 50 81    ld   ($DINO_X_LEGS),a
4E01: 3E 39       ld   a,$39
4E03: 32 51 81    ld   ($DINO_FRAME_LEGS),a
4E06: 3E 12       ld   a,$12
4E08: 32 52 81    ld   ($DINO_COL_LEGS),a
4E0B: 3E E7       ld   a,$E7
4E0D: 32 53 81    ld   ($DINO_Y_LEGS),a
4E10: CD C0 4D    call $REALLY_VBLANK
4E13: CD E0 4E    call $SPEED_UP_FOR_NEXT_ROUND
4E16: 21 48 3D    ld   hl,$DO_CUTSCENE
4E19: CD 81 5C    call $JMP_HL
4E1C: C9          ret

4E1D: FF ...

4E20: CD 80 4E    call $4E80
4E23: CD 81 5C    call $JMP_HL
4E26: CD A8 5A    call $FLASH_BORDER
4E29: 21 74 3F    ld   hl,$3F74
4E2C: CD 81 5C    call $JMP_HL
4E2F: CD A8 5A    call $FLASH_BORDER
4E32: 21 4B 16    ld   hl,$164B
4E35: CD 81 5C    call $JMP_HL
4E38: 3E 07       ld   a,$07
4E3A: 32 29 80    ld   ($SCREEN_NUM),a
4E3D: 32 2A 80    ld   ($SCREEN_NUM_P2),a
4E40: 21 B8 12    ld   hl,$DRAW_BACKGROUND
4E43: CD 81 5C    call $JMP_HL
4E46: 21 A8 3F    ld   hl,$3FA8
4E49: CD 81 5C    call $JMP_HL
4E4C: 21 48 92    ld   hl,$9248
4E4F: 06 A0       ld   b,$A0
4E51: 0E 05       ld   c,$05
4E53: 70          ld   (hl),b
4E54: 04          inc  b
4E55: 23          inc  hl
4E56: 70          ld   (hl),b
4E57: 04          inc  b
4E58: 11 1F 00    ld   de,$001F
4E5B: 19          add  hl,de
4E5C: 70          ld   (hl),b
4E5D: 04          inc  b
4E5E: 23          inc  hl
4E5F: 70          ld   (hl),b
4E60: 11 A1 FF    ld   de,$FFA1
4E63: 19          add  hl,de
4E64: 04          inc  b
4E65: CD D4 4E    call $4ED4
4E68: 0D          dec  c
4E69: 20 E8       jr   nz,$4E53
4E6B: 21 8C 3F    ld   hl,$3F8C
4E6E: CD 81 5C    call $JMP_HL
4E71: C3 E2 52    jp   $52E2
4E74: FF          rst  $38
4E75: F5          push af
4E76: 3E 05       ld   a,$05
4E78: 32 44 80    ld   ($SFX_ID),a
4E7B: F1          pop  af
4E7C: 21 C9 91    ld   hl,$91C9
4E7F: C9          ret
4E80: 21 88 0F    ld   hl,$0F88
4E83: CD 81 5C    call $JMP_HL
4E86: 21 66 3F    ld   hl,$3F66
4E89: C9          ret
4E8A: FF ...

4E90: 3E F9       ld   a,$F9
4E92: 00          nop
4E93: 00          nop
4E94: 00          nop
4E95: 3E FD       ld   a,$FD
4E97: 00          nop
4E98: 00          nop
4E99: 00          nop
4E9A: 3E FB       ld   a,$FB
4E9C: 00          nop
4E9D: 00          nop
4E9E: 00          nop
4E9F: 3E FF       ld   a,$FF
4EA1: 00          nop
4EA2: 00          nop
4EA3: 00          nop
4EA4: C9          ret

4EA5: 78          ld   a,b
4EA6: CD 00 49    call $SHADOW_ADD_A_TO_RET_2
4EA9: FF          rst  $38
4EAA: FF          rst  $38
4EAB: FF          rst  $38
4EAC: FF          rst  $38
4EAD: FF          rst  $38
4EAE: FF          rst  $38
4EAF: FF          rst  $38

    ;; some kind of effect? on splash screen something
4EB0: CD C2 4E    call $4EC2
4EB3: CD C2 4E    call $4EC2
4EB6: CD C2 4E    call $4EC2
4EB9: CD C2 4E    call $4EC2
4EBC: C9          ret
4EBD: FF ...

4EC2: 16 0E       ld   d,$0E
4EC4: E5          push hl
4EC5: C5          push bc
4EC6: D5          push de
4EC7: 21 28 21    ld   hl,$2128
4ECA: CD 81 5C    call $JMP_HL
4ECD: D1          pop  de
4ECE: C1          pop  bc
4ECF: E1          pop  hl
4ED0: 15          dec  d
4ED1: 20 F1       jr   nz,$4EC4
4ED3: C9          ret
4ED4: CD C2 4E    call $4EC2
4ED7: CD C2 4E    call $4EC2
4EDA: C9          ret

4EDB: FF ...

SPEED_UP_FOR_NEXT_ROUND
4EE0: 3A 04 80    ld   a,($PLAYER_NUM)
4EE3: A7          and  a
4EE4: 20 05       jr   nz,$4EEB
4EE6: 21 5B 80    ld   hl,$SPEED_DELAY_P1
4EE9: 18 03       jr   $4EEE
4EEB: 21 5C 80    ld   hl,$SPEED_DELAY_P2
4EEE: 7E          ld   a,(hl)
4EEF: FE 1F       cp   $ROUND1_SPEED
4EF1: 20 03       jr   nz,$4EF6
4EF3: 36 10       ld   (hl),$ROUND2_SPEED ; round 2 = $10
4EF5: C9          ret
4EF6: FE 10       cp   $ROUND2_SPEED
4EF8: 20 03       jr   nz,$4EFD
4EFA: 36 0D       ld   (hl),$ROUND3_SPEED ; round 3 = $0d
4EFC: C9          ret
4EFD: C3 1C 50    jp   $EVEN_MORE_FASTER_DINO ; round 4+ = get 2 faster each time!

PICKUPS_LOOKUP
4F00: 91 5A 8C 00 00 00 00 00 00 ; up to 3 pickups per screen
4F09: 91 5A 8D 00 00 00 00 00 00 ; pos (hi), pos (lo), pickup symbol
4F12: 91 1A 8D 00 00 00 00 00 00
4F1B: 91 5A 8C 00 00 00 00 00 00
4F24: 91 B1 8C 00 00 00 00 00 00
4F2D: 91 8E 8C 00 00 00 00 00 00
4F36: 91 D2 8D 00 00 00 00 00 00
4F3F: 91 5A 8D 00 00 00 00 00 00
4F48: 91 1A 8D 00 00 00 00 00 00
4F51: 91 B1 8C 00 00 00 00 00 00
4F5A: 90 CB 8E 91 8E 8C 00 00 00
4F63: 91 D2 8D 00 00 00 00 00 00
4F6C: 91 5A 8C 00 00 00 00 00 00
4F75: 92 7A 8E 91 1A 8D 00 00 00
4F7E: 91 5A 8D 00 00 00 00 00 00
4F87: 92 EE 83 92 17 8E 00 00 00
4F90: 91 D2 8D 00 00 00 00 00 00
4F99: 91 5A 8D 00 00 00 00 00 00
4FA2: 92 EE 83 92 17 8E 00 00 00
4FAB: 91 D2 8D 00 00 00 00 00 00
4FB4: 92 17 8C 92 31 8D 92 2B 8F
4FBD: 90 CB 8E 91 8E 8C 00 00 00
4FC6: 91 D2 8D 00 00 00 00 00 00
4FCF: 92 17 8C 92 31 8D 92 2B 8F
4FD8: 90 CB 8E 91 8E 8C 92 AB 8E
4FE1: 91 D2 8D 00 00 00 00 00 00
4FEA: 00 00 00 00 00 00 00 00 00 ; Screen 27 (cage - no pickups)
4FF3: 00 00 00 00 00 00 00 00 00
4FFC: 00 00

4FFE: FF FF

ANIMATE_PICKUPS
5000: 46          ld   b,(hl)
5001: 23          inc  hl
5002: 4E          ld   c,(hl)
5003: 23          inc  hl
5004: 0A          ld   a,(bc)
5005: FE 10       cp   $10
5007: 28 11       jr   z,$501A
5009: 5F          ld   e,a
500A: E6 F0       and  $F0
500C: FE 80       cp   $80
500E: 20 06       jr   nz,$5016
5010: 7B          ld   a,e
5011: C6 10       add  a,$10
5013: 02          ld   (bc),a
5014: 18 04       jr   $501A
5016: 7B          ld   a,e
5017: D6 10       sub  $10
5019: 02          ld   (bc),a
501A: 23          inc  hl
501B: C9          ret

EVEN_MORE_FASTER_DINO
501C: 3D          dec  a
501D: 3D          dec  a
501E: 77          ld   (hl),a
501F: C9          ret

ANIMATE_ALL_PICKUPS
5020: 3A 12 83    ld   a,($TICK_NUM)
5023: E6 03       and  $03
5025: C0          ret  nz
5026: 21 00 4F    ld   hl,$PICKUPS_LOOKUP
5029: 3A 04 80    ld   a,($PLAYER_NUM)
502C: A7          and  a
502D: 28 05       jr   z,$5034
502F: 3A 2A 80    ld   a,($SCREEN_NUM_P2)
5032: 18 03       jr   $5037
5034: 3A 29 80    ld   a,($SCREEN_NUM) ;
5037: 3D          dec  a               ; Get screen x 9
5038: 47          ld   b,a             ;
5039: 87          add  a,a             ;
503A: 87          add  a,a             ;
503B: 87          add  a,a             ;
503C: 80          add  a,b             ;
503D: 85          add  a,l             ; index into PICKUPS table
503E: 6F          ld   l,a
503F: 7E          ld   a,(hl)          ; Find pickup screen addr
5040: A7          and  a
5041: C8          ret  z
5042: CD 00 50    call $ANIMATE_PICKUPS
5045: 7E          ld   a,(hl)
5046: A7          and  a
5047: C8          ret  z
5048: CD 00 50    call $ANIMATE_PICKUPS
504B: 7E          ld   a,(hl)
504C: A7          and  a
504D: C8          ret  z
504E: CD 00 50    call $ANIMATE_PICKUPS
5051: C9          ret

5052: FF          rst  $38

TBL_1
5053: 03
5054: 84 50
5056: 90 50
5058: 8C 50

505A: FF          rst  $38
505B: FF          rst  $38
505C: FF          rst  $38
505D: FF          rst  $38
505E: FF          rst  $38
505F: FF          rst  $38

5060: 0C          inc  c
5061: 01 0E 01    ld   bc,$010E
5064: 10 01       djnz $5067
5066: 11 01 13    ld   de,$1301
5069: 03          inc  bc
506A: FF          rst  $38
506B: FF          rst  $38
506C: 13          inc  de
506D: 01 15 01    ld   bc,$0115
5070: 17          rla
5071: 01 18 01    ld   bc,$0118
5074: 1A          ld   a,(de)
5075: 03          inc  bc
5076: FF          rst  $38
5077: FF          rst  $38
5078: 18 01       jr   $507B
507A: 1A          ld   a,(de)
507B: 01 1C 01    ld   bc,$011C
507E: 1D          dec  e
507F: 01 1F 03    ld   bc,$031F
5082: FF          rst  $38
5083: FF          rst  $38

5084: 02 02
5086: 0F          rrca
5087: 10 60       djnz $50E9
5089: 50          ld   d,b
508A: FF          rst  $38
508B: FF          rst  $38
508C: 6E          ld   l,(hl)
508D: 50          ld   d,b
508E: FF          rst  $38
508F: FF          rst  $38
5090: 6C          ld   l,h
5091: 50          ld   d,b
5092: FF          rst  $38
5093: FF          rst  $38
5094: 00          nop
5095: 01 02 01    ld   bc,$0102
5098: 04          inc  b
5099: 01 06 01    ld   bc,$0106
509C: 08          ex   af,af'
509D: 01 0A 01    ld   bc,$010A
50A0: 0C          inc  c
50A1: 01 0E 01    ld   bc,$010E
50A4: FF          rst  $38
50A5: FF          rst  $38
50A6: FF          rst  $38
50A7: FF          rst  $38
50A8: FF          rst  $38
50A9: FF          rst  $38
50AA: FF          rst  $38
50AB: FF          rst  $38
50AC: FF          rst  $38
50AD: FF          rst  $38
50AE: FF          rst  $38
50AF: FF          rst  $38
50B0: 01 01 0F    ld   bc,$0F01
50B3: 00          nop
50B4: 94          sub  h
50B5: 50          ld   d,b
50B6: FF          rst  $38
50B7: FF          rst  $38
50B8: 94          sub  h
50B9: 10 FF       djnz $50BA
50BB: FF          rst  $38
50BC: 03          inc  bc
50BD: B0          or   b
50BE: 50          ld   d,b
50BF: C8          ret  z
50C0: 50          ld   d,b
50C1: C8          ret  z
50C2: 50          ld   d,b
50C3: FF          rst  $38
50C4: FF          rst  $38
50C5: FF          rst  $38
50C6: FF          rst  $38
50C7: FF          rst  $38
50C8: AC          xor  h
50C9: 50          ld   d,b
50CA: FF          rst  $38
50CB: FF          rst  $38
50CC: 18 01       jr   $50CF
50CE: 17          rla
50CF: 01 15 01    ld   bc,$0115
50D2: 13          inc  de
50D3: 01 11 01    ld   bc,$0111
50D6: 10 01       djnz $50D9
50D8: 0E 01       ld   c,$01
50DA: 0C          inc  c
50DB: 01 0B 01    ld   bc,$010B
50DE: 09          add  hl,bc
50DF: 01 07 01    ld   bc,$0107
50E2: 05          dec  b
50E3: 01 04 01    ld   bc,$0104
50E6: 02          ld   (bc),a
50E7: 01 00 01    ld   bc,$0100
50EA: FF          rst  $38
50EB: FF          rst  $38
50EC: 03          inc  bc
50ED: F4 50 F4    call p,$F450
50F0: 51          ld   d,c
50F1: F4 51 FF    call p,$FF51
50F4: 03          inc  bc
50F5: 03          inc  bc
50F6: 0F          rrca
50F7: 10 CC       djnz $50C5
50F9: 50          ld   d,b
50FA: FF          rst  $38
50FB: FF          rst  $38
50FC: 2B          dec  hl
50FD: 02          ld   (bc),a
50FE: 34          inc  (hl)
50FF: 02          ld   (bc),a
5100: 34          inc  (hl)
5101: 02          ld   (bc),a
5102: 34          inc  (hl)
5103: 02          ld   (bc),a
5104: 32 01 34    ld   ($3401),a
5107: 01 32 01    ld   bc,$0132
510A: 30 01       jr   nc,$510D
510C: 2F          cpl
510D: 01 2D 01    ld   bc,$012D
5110: 2B          dec  hl
5111: 02          ld   (bc),a
5112: 2D          dec  l
5113: 02          ld   (bc),a
5114: 2D          dec  l
5115: 02          ld   (bc),a
5116: 32 01 34    ld   ($3401),a
5119: 01 26 02    ld   bc,$0226
511C: FF          rst  $38
511D: FF          rst  $38
511E: 37          scf
511F: 02          ld   (bc),a
5120: 2F          cpl
5121: 02          ld   (bc),a
5122: 32 04 FF    ld   ($FF04),a
5125: FF          rst  $38
5126: 2B          dec  hl
5127: 01 26 01    ld   bc,$0126
512A: 23          inc  hl
512B: 01 26 01    ld   bc,$0126
512E: 1F          rra
512F: 04          inc  b
5130: FF          rst  $38
5131: FF          rst  $38
5132: 0C          inc  c
5133: 01 10 01    ld   bc,$0110
5136: 13          inc  de
5137: 01 10 01    ld   bc,$0110
513A: 0C          inc  c
513B: 01 0C 01    ld   bc,$010C
513E: 0E 01       ld   c,$01
5140: 10 01       djnz $5143
5142: 0B          dec  bc
5143: 01 0C 01    ld   bc,$010C
5146: 0B          dec  bc
5147: 01 09 01    ld   bc,$0109
514A: 07          rlca
514B: 01 07 01    ld   bc,$0107
514E: 09          add  hl,bc
514F: 01 0B 01    ld   bc,$010B
5152: 09          add  hl,bc
5153: 01 0B 01    ld   bc,$010B
5156: 09          add  hl,bc
5157: 01 07 01    ld   bc,$0107
515A: 06 01       ld   b,$01
515C: 06 01       ld   b,$01
515E: 07          rlca
515F: 01 09 01    ld   bc,$0109
5162: FF          rst  $38
5163: FF          rst  $38
5164: 07          rlca
5165: 01 07 01    ld   bc,$0107
5168: 0B          dec  bc
5169: 01 0C 01    ld   bc,$010C
516C: 0E 01       ld   c,$01
516E: 07          rlca
516F: 01 0B 01    ld   bc,$010B
5172: 0E 01       ld   c,$01
5174: FF          rst  $38
5175: FF          rst  $38
5176: 07          rlca
5177: 01 0C 01    ld   bc,$010C
517A: 0B          dec  bc
517B: 01 09 01    ld   bc,$0109
517E: 07          rlca
517F: 04          inc  b
5180: FF          rst  $38
5181: FF          rst  $38
5182: 01 08 0F    ld   bc,$0F08
5185: 00          nop
5186: 32 51 1E    ld   ($1E51),a
5189: 51          ld   d,c
518A: FC 50 26    call m,$2650
518D: 51          ld   d,c
518E: FC 50 1E    call m,$1E50
5191: 51          ld   d,c
5192: FC 50 26    call m,$2650
5195: 51          ld   d,c
5196: FF          rst  $38
5197: FF          rst  $38
5198: FF          rst  $38
5199: FF          rst  $38
519A: 02          ld   (bc),a
519B: 82          add  a,d
519C: 51          ld   d,c
519D: A8          xor  b
519E: 51          ld   d,c
519F: A8          xor  b
51A0: 51          ld   d,c
51A1: FF          rst  $38
51A2: FF          rst  $38
51A3: 98          sbc  a,b
51A4: 11 FF FF    ld   de,$FFFF
51A7: FF          rst  $38
51A8: FC 50 64    call m,$6450
51AB: 51          ld   d,c
51AC: 32 51 76    ld   ($7651),a
51AF: 51          ld   d,c
51B0: 32 51 64    ld   ($6451),a
51B3: 51          ld   d,c
51B4: 32 51 76    ld   ($7651),a
51B7: 51          ld   d,c
51B8: FF          rst  $38
51B9: FF          rst  $38
51BA: 0C          inc  c
51BB: 02          ld   (bc),a
51BC: 18 02       jr   $51C0
51BE: 0C          inc  c
51BF: 02          ld   (bc),a
51C0: 18 02       jr   $51C4
51C2: 0C          inc  c
51C3: 02          ld   (bc),a
51C4: 18 02       jr   $51C8
51C6: 0C          inc  c
51C7: 02          ld   (bc),a
51C8: 18 02       jr   $51CC
51CA: 0C          inc  c
51CB: 02          ld   (bc),a
51CC: 18 02       jr   $51D0
51CE: 0C          inc  c
51CF: 02          ld   (bc),a
51D0: 18 02       jr   $51D4
51D2: 0C          inc  c
51D3: 02          ld   (bc),a
51D4: 18 02       jr   $51D8
51D6: FF          rst  $38
51D7: FF          rst  $38
51D8: FF          rst  $38
51D9: FF          rst  $38
51DA: 03          inc  bc
51DB: 03          inc  bc
51DC: 0F          rrca
51DD: 10 BA       djnz $5199
51DF: 51          ld   d,c
51E0: FF          rst  $38
51E1: FF          rst  $38
51E2: CA 11 FF    jp   z,$FF11
51E5: FF          rst  $38
51E6: F8          ret  m
51E7: 51          ld   d,c
51E8: FF          rst  $38
51E9: FF          rst  $38
51EA: 03          inc  bc
51EB: DA 51 E6    jp   c,$E651
51EE: 51          ld   d,c
51EF: F4 51 FF    call p,$FF51
51F2: FF          rst  $38
51F3: FF          rst  $38
51F4: F8          ret  m
51F5: 51          ld   d,c
51F6: FF          rst  $38
51F7: FF          rst  $38
51F8: FF          rst  $38
51F9: FF          rst  $38
51FA: FF          rst  $38
51FB: FF          rst  $38
51FC: FF          rst  $38
51FD: FF          rst  $38
51FE: FF          rst  $38
51FF: FF          rst  $38

    ;;
MORE_SFX_SOMETHING?
5200: DD E5       push ix
5202: E1          pop  hl
5203: 7D          ld   a,l
5204: FE E8       cp   $E8
5206: 20 07       jr   nz,$520F
5208: 3E 02       ld   a,$02
520A: 32 55 80    ld   ($8055),a
520D: 18 16       jr   $5225
520F: 3A 55 80    ld   a,($8055)
5212: A7          and  a
5213: 28 10       jr   z,$5225
5215: 3D          dec  a
5216: 32 55 80    ld   ($8055),a
5219: 3A 52 80    ld   a,($8052)
521C: A7          and  a
521D: 28 04       jr   z,$5223
521F: 3D          dec  a
5220: 32 52 80    ld   ($8052),a
5223: E1          pop  hl
5224: C9          ret
5225: 7D          ld   a,l
5226: FE D0       cp   $D0
5228: 20 07       jr   nz,$5231
522A: 3E 02       ld   a,$02
522C: 32 52 80    ld   ($8052),a
522F: 18 0C       jr   $523D
5231: 3A 52 80    ld   a,($8052)
5234: A7          and  a
5235: 28 06       jr   z,$523D
5237: 3D          dec  a
5238: 32 52 80    ld   ($8052),a
523B: E1          pop  hl
523C: C9          ret
523D: DD 7E 10    ld   a,(ix+$10)
5240: C9          ret

5241: FF ...

5250: DD E5       push ix
5252: E1          pop  hl
5253: 7D          ld   a,l
5254: FE E8       cp   $E8
5256: 20 07       jr   nz,$525F
5258: 3E 02       ld   a,$02
525A: 32 56 80    ld   ($8056),a
525D: 18 16       jr   $5275
525F: 3A 56 80    ld   a,($8056)
5262: A7          and  a
5263: 28 10       jr   z,$5275
5265: 3D          dec  a
5266: 32 56 80    ld   ($8056),a
5269: 3A 53 80    ld   a,($8053)
526C: A7          and  a
526D: 28 04       jr   z,$5273
526F: 3D          dec  a
5270: 32 53 80    ld   ($8053),a
5273: E1          pop  hl
5274: C9          ret
5275: 7D          ld   a,l
5276: FE D0       cp   $D0
5278: 20 07       jr   nz,$5281
527A: 3E 02       ld   a,$02
527C: 32 53 80    ld   ($8053),a
527F: 18 0C       jr   $528D
5281: 3A 53 80    ld   a,($8053)
5284: A7          and  a
5285: 28 06       jr   z,$528D
5287: 3D          dec  a
5288: 32 53 80    ld   ($8053),a
528B: E1          pop  hl
528C: C9          ret
528D: DD 7E 10    ld   a,(ix+$10)
5290: C9          ret
5291: FF ...

52A0: DD E5       push ix
52A2: E1          pop  hl
52A3: 7D          ld   a,l
52A4: FE E8       cp   $E8
52A6: 20 07       jr   nz,$52AF
52A8: 3E 02       ld   a,$02
52AA: 32 57 80    ld   ($8057),a
52AD: 18 16       jr   $52C5
52AF: 3A 57 80    ld   a,($8057)
52B2: A7          and  a
52B3: 28 10       jr   z,$52C5
52B5: 3D          dec  a
52B6: 32 57 80    ld   ($8057),a
52B9: 3A 54 80    ld   a,($8054)
52BC: A7          and  a
52BD: 28 04       jr   z,$52C3
52BF: 3D          dec  a
52C0: 32 54 80    ld   ($8054),a
52C3: E1          pop  hl
52C4: C9          ret
52C5: 7D          ld   a,l
52C6: FE D0       cp   $D0
52C8: 20 07       jr   nz,$52D1
52CA: 3E 02       ld   a,$02
52CC: 32 54 80    ld   ($8054),a
52CF: 18 0C       jr   $52DD
52D1: 3A 54 80    ld   a,($8054)
52D4: A7          and  a
52D5: 28 06       jr   z,$52DD
52D7: 3D          dec  a
52D8: 32 54 80    ld   ($8054),a
52DB: E1          pop  hl
52DC: C9          ret
52DD: DD 7E 10    ld   a,(ix+$10)
52E0: C9          ret
52E1: FF          rst  $38
52E2: CD B0 4E    call $4EB0
52E5: 21 40 81    ld   hl,$PLAYER_X
52E8: 36 D8       ld   (hl),$D8
52EA: 23          inc  hl
52EB: 36 8D       ld   (hl),$8D
52ED: 23          inc  hl
52EE: 36 11       ld   (hl),$11
52F0: 23          inc  hl
52F1: 36 E0       ld   (hl),$E0
52F3: 23          inc  hl
52F4: 36 D8       ld   (hl),$D8
52F6: 23          inc  hl
52F7: 36 8D       ld   (hl),$8D
52F9: 23          inc  hl
52FA: 36 11       ld   (hl),$11
52FC: 23          inc  hl
52FD: 36 F0       ld   (hl),$F0
52FF: 1E 06       ld   e,$06
5301: CD 28 53    call $5328
5304: 1D          dec  e
5305: 20 FA       jr   nz,$5301
5307: 21 48 81    ld   hl,$BONGO_X
530A: 36 20       ld   (hl),$20
530C: 23          inc  hl
530D: 36 2D       ld   (hl),$2D
530F: 23          inc  hl
5310: 36 12       ld   (hl),$12
5312: 23          inc  hl
5313: 36 28       ld   (hl),$28
5315: 23          inc  hl
5316: 36 19       ld   (hl),$19
5318: 23          inc  hl
5319: 36 30       ld   (hl),$30
531B: 23          inc  hl
531C: 36 12       ld   (hl),$12
531E: 23          inc  hl
531F: 36 38       ld   (hl),$38
5321: CD AC 53    call $53AC
5324: C3 28 54    jp   $CALL_DO_ATTRACT_MODE
5327: FF          rst  $38
5328: 16 00       ld   d,$00
532A: 21 80 53    ld   hl,$5380
532D: 7A          ld   a,d
532E: 87          add  a,a
532F: 87          add  a,a
5330: 85          add  a,l
5331: 6F          ld   l,a
5332: DD 21 40 81 ld   ix,$PLAYER_X
5336: 7E          ld   a,(hl)
5337: DD 77 01    ld   (ix+$01),a
533A: 23          inc  hl
533B: 7E          ld   a,(hl)
533C: DD 77 05    ld   (ix+$05),a
533F: 23          inc  hl
5340: 7E          ld   a,(hl)
5341: DD 86 00    add  a,(ix+$00)
5344: DD 77 00    ld   (ix+$00),a
5347: DD 77 04    ld   (ix+$04),a
534A: 23          inc  hl
534B: 7E          ld   a,(hl)
534C: DD 86 03    add  a,(ix+$03)
534F: DD 77 03    ld   (ix+$03),a
5352: D6 10       sub  $10
5354: DD 77 07    ld   (ix+$07),a
5357: D5          push de
5358: 21 28 21    ld   hl,$2128
535B: CD 81 5C    call $JMP_HL
535E: 21 28 21    ld   hl,$2128
5361: CD 81 5C    call $JMP_HL
5364: 21 28 21    ld   hl,$2128
5367: CD 81 5C    call $JMP_HL
536A: D1          pop  de
536B: 14          inc  d
536C: 7A          ld   a,d
536D: FE 06       cp   $06
536F: 20 B9       jr   nz,$532A
5371: CD D4 4E    call $4ED4
5374: C9          ret
5375: FF ...

5380: 8D          adc  a,l
5381: 8C          adc  a,h
5382: FC F4 8F    call m,$8FF4
5385: 8E          adc  a,(hl)
5386: FC F6 91    call m,$91F6
5389: 90          sub  b
538A: FC F8 96    call m,$96F8
538D: 92          sub  d
538E: FC F8 94    call m,$94F8
5391: 93          sub  e
5392: FC 06 8D    call m,$8D06
5395: 8C          adc  a,h
5396: FC 08 3A    call m,$3A08
5399: 49          ld   c,c
539A: 81          add  a,c
539B: FE 2D       cp   $2D
539D: 20 07       jr   nz,$53A6
539F: 3E 2C       ld   a,$2C
53A1: 32 49 81    ld   ($BONGO_FRAME),a
53A4: 18 05       jr   $53AB
53A6: 3E 2D       ld   a,$2D
53A8: 32 49 81    ld   ($BONGO_FRAME),a
53AB: C9          ret
53AC: 1E 06       ld   e,$06
53AE: CD B8 53    call $53B8
53B1: CD 98 53    call $5398
53B4: 1D          dec  e
53B5: 20 F7       jr   nz,$53AE
53B7: C9          ret
53B8: 16 00       ld   d,$00
53BA: 21 08 54    ld   hl,$5408
53BD: 7A          ld   a,d
53BE: 87          add  a,a
53BF: 87          add  a,a
53C0: 85          add  a,l
53C1: 6F          ld   l,a
53C2: DD 21 40 81 ld   ix,$PLAYER_X
53C6: 7E          ld   a,(hl)
53C7: DD 77 01    ld   (ix+$01),a
53CA: 23          inc  hl
53CB: 7E          ld   a,(hl)
53CC: DD 77 05    ld   (ix+$05),a
53CF: 23          inc  hl
53D0: 7E          ld   a,(hl)
53D1: DD 86 00    add  a,(ix+$00)
53D4: DD 77 00    ld   (ix+$00),a
53D7: DD 77 04    ld   (ix+$04),a
53DA: 23          inc  hl
53DB: 7E          ld   a,(hl)
53DC: DD 86 03    add  a,(ix+$03)
53DF: DD 77 03    ld   (ix+$03),a
53E2: D6 10       sub  $10
53E4: DD 77 07    ld   (ix+$07),a
53E7: D5          push de
53E8: 21 28 21    ld   hl,$2128
53EB: CD 81 5C    call $JMP_HL
53EE: 21 28 21    ld   hl,$2128
53F1: CD 81 5C    call $JMP_HL
53F4: 21 28 21    ld   hl,$2128
53F7: CD 81 5C    call $JMP_HL
53FA: D1          pop  de
53FB: 14          inc  d
53FC: 7A          ld   a,d
53FD: FE 06       cp   $06
53FF: 20 B9       jr   nz,$53BA
5401: CD C2 4E    call $4EC2
5404: C9          ret
5405: FF ...

5408: 0D          dec  c
5409: 0C          inc  c
540A: 04          inc  b
540B: F8          ret  m
540C: 0F          rrca
540D: 0E 04       ld   c,$04
540F: 00          nop
5410: 11 10 04    ld   de,$OUT_OF_LIVES
5413: 08          ex   af,af'
5414: 16 12       ld   d,$12
5416: 04          inc  b
5417: 08          ex   af,af'
5418: 14          inc  d
5419: 13          inc  de
541A: 04          inc  b
541B: 08          ex   af,af'
541C: 0D          dec  c
541D: 0C          inc  c
541E: 04          inc  b
541F: 08          ex   af,af'
5420: FF          rst  $38
5421: FF          rst  $38
5422: FF          rst  $38
5423: FF          rst  $38
5424: FF          rst  $38
5425: FF          rst  $38
5426: FF          rst  $38
5427: FF          rst  $38

CALL_DO_ATTRACT_MODE
5428: 21 D0 15    ld   hl,$DO_ATTRACT_MODE
542B: CD 81 5C    call $JMP_HL
542E: C9          ret

542F: FF
    ;;
5430: 21 24 92    ld   hl,$9224
5433: CD 08 4D    call $DRAW_CAGE_TILES
5436: E5          push hl
5437: CD C2 54    call $54C2
543A: 00          nop
543B: 00          nop
543C: 00          nop
543D: E1          pop  hl
543E: 23          inc  hl
543F: 3E 39       ld   a,$39
5441: BD          cp   l
5442: 20 EF       jr   nz,$5433
5444: 3E 38       ld   a,$38
5446: 32 41 81    ld   ($PLAYER_FRAME),a
5449: 3C          inc  a
544A: 32 45 81    ld   ($PLAYER_FRAME_LEGS),a
544D: C9          ret

544E: FF ...

5450: DD 21 40 81 ld   ix,$PLAYER_X
5454: 3E 79       ld   a,$79
5456: DD BE 00    cp   (ix+$00)
5459: C8          ret  z
545A: DD 34 00    inc  (ix+$00)
545D: DD 34 04    inc  (ix+$04)
5460: 3A 12 83    ld   a,($TICK_NUM)
5463: E6 03       and  $03
5465: 20 24       jr   nz,$548B
5467: DD 7E 05    ld   a,(ix+$05)
546A: 3C          inc  a
546B: FE 33       cp   $33
546D: 20 02       jr   nz,$5471
546F: 3E 31       ld   a,$31
5471: DD 77 05    ld   (ix+$05),a
5474: 3A 12 83    ld   a,($TICK_NUM)
5477: E6 0F       and  $0F
5479: FE 05       cp   $05
547B: 20 06       jr   nz,$5483
547D: DD 36 01 2C ld   (ix+$01),$2C
5481: 18 08       jr   $548B
5483: FE 08       cp   $08
5485: 20 04       jr   nz,$548B
5487: DD 36 01 2D ld   (ix+$01),$2D
548B: CD C2 54    call $54C2
548E: 00          nop
548F: 00          nop
5490: 00          nop
5491: 18 BD       jr   $5450
5493: FF          rst  $38
5494: 21 40 81    ld   hl,$PLAYER_X
5497: 36 07       ld   (hl),$07 ; x
5499: 23          inc  hl
549A: 36 2D       ld   (hl),$2D ; frame
549C: 23          inc  hl
549D: 36 12       ld   (hl),$12 ; colr
549F: 23          inc  hl
54A0: 36 BF       ld   (hl),$BF ; y
54A2: 23          inc  hl
54A3: 36 00       ld   (hl),$00 ; x legs
54A5: 23          inc  hl
54A6: 36 30       ld   (hl),$30 ; frame legs
54A8: 23          inc  hl
54A9: 36 12       ld   (hl),$12 ; col legs
54AB: 23          inc  hl
54AC: 36 CF       ld   (hl),$CF ; y legs
54AE: 21 24 92    ld   hl,$9224
54B1: CD 08 4D    call $DRAW_CAGE_TILES
54B4: CD 50 54    call $5450
54B7: CD D8 54    call $54D8
54BA: CD 30 54    call $5430
54BD: CD D8 54    call $54D8
54C0: C9          ret

54C1: FF

    ;;
54C2: 3A 12 83    ld   a,($TICK_NUM)
54C5: E6 03       and  $03
54C7: 20 06       jr   nz,$54CF
54C9: 21 64 15    ld   hl,$1564
54CC: CD 81 5C    call $JMP_HL
54CF: 21 28 21    ld   hl,$2128
54D2: CD 81 5C    call $JMP_HL
54D5: C9          ret

54D6: FF

54D8: 1E 20       ld   e,$20
54DA: D5          push de
54DB: CD C2 54    call $54C2
54DE: D1          pop  de
54DF: 1D          dec  e
54E0: 20 F8       jr   nz,$54DA
54E2: C9          ret

54E3: FF

54E4: 2D          dec  l
54E5: 02          ld   (bc),a
54E6: 2D          dec  l
54E7: 01 2D 01    ld   bc,$012D
54EA: 2D          dec  l
54EB: 02          ld   (bc),a
54EC: 2A 02 2D    ld   hl,($2D02)
54EF: 02          ld   (bc),a
54F0: 32 04 FF    ld   ($FF04),a
54F3: FF          rst  $38
54F4: 21 02 21    ld   hl,$2102
54F7: 01 21 01    ld   bc,$0121
54FA: 21 02 1E    ld   hl,$1E02
54FD: 02          ld   (bc),a
54FE: 21 02 26    ld   hl,$2602
5501: 04          inc  b
5502: FF          rst  $38
5503: FF          rst  $38
5504: 01 03 0F    ld   bc,$0F03
5507: 00          nop
5508: E4 54 FF    call po,$FF54
550B: FF          rst  $38
550C: F4 54 FF    call p,$FF54
550F: FF          rst  $38
5510: 6C          ld   l,h
5511: 55          ld   d,l
5512: FF          rst  $38
5513: FF          rst  $38
5514: 03          inc  bc
5515: 04          inc  b
5516: 55          ld   d,l
5517: 08          ex   af,af'
5518: 55          ld   d,l
5519: 08          ex   af,af'
551A: 55          ld   d,l
551B: FF          rst  $38
551C: FF          rst  $38
551D: FF          rst  $38
551E: FF          rst  $38
551F: FF          rst  $38
5520: AF          xor  a
5521: 32 46 80    ld   ($8046),a
5524: 3A A5 82    ld   a,($82A5)
5527: A7          and  a
5528: 20 05       jr   nz,$552F
552A: 3E F9       ld   a,$F9
552C: 00          nop
552D: 00          nop
552E: 00          nop
552F: 3A AD 82    ld   a,($82AD)
5532: A7          and  a
5533: 20 05       jr   nz,$553A
5535: 3E FD       ld   a,$FD
5537: 00          nop
5538: 00          nop
5539: 00          nop
553A: 3A B5 82    ld   a,($82B5)
553D: A7          and  a
553E: 20 05       jr   nz,$5545
5540: 3E FB       ld   a,$FB
5542: 00          nop
5543: 00          nop
5544: 00          nop
5545: 3E FF       ld   a,$FF
5547: 00          nop
5548: 00          nop
5549: 00          nop
554A: C9          ret
554B: FF ...

5550: 10 01       djnz $5553
5552: 0B          dec  bc
5553: 01 08 01    ld   bc,$0108
5556: FF          rst  $38
5557: FF          rst  $38
5558: 04          inc  b
5559: 04          inc  b
555A: 0F          rrca
555B: 10 50       djnz $55AD
555D: 55          ld   d,l
555E: FF          rst  $38
555F: FF          rst  $38
5560: 03          inc  bc
5561: 58          ld   e,b
5562: 55          ld   d,l
5563: 5C          ld   e,h
5564: 55          ld   d,l
5565: 5C          ld   e,h
5566: 55          ld   d,l
5567: FF          rst  $38
5568: 6A          ld   l,d
5569: 55          ld   d,l
556A: FF          rst  $38
556B: FF          rst  $38
556C: FF          rst  $38
556D: FF          rst  $38
556E: FF          rst  $38
556F: FF          rst  $38

    ;; bytes after the call are
    ;; start_x, start_y, tile 1, ...tile x, 0xFF
DRAW_TILES_H_COPY
5570: 3A 00 B8    ld   a,($WATCHDOG) ; is this ack? "A" not used
5573: 21 40 90    ld   hl,$START_OF_TILES
5576: C1          pop  bc       ; stack return pointer into bc (ie, data)
5577: 0A          ld   a,(bc)   ; start_x
5578: 03          inc  bc
5579: 85          add  a,l
557A: 6F          ld   l,a
557B: 0A          ld   a,(bc)   ; start_y
557C: 5F          ld   e,a
557D: 3E 1B       ld   a,$1B
557F: 93          sub  e
5580: 5F          ld   e,a
5581: 16 00       ld   d,$00
5583: CB 23       sla  e
5585: CB 23       sla  e
5587: CB 23       sla  e
5589: 19          add  hl,de
558A: 19          add  hl,de
558B: 19          add  hl,de
558C: 19          add  hl,de
558D: 03          inc  bc
_LP_1
558E: 0A          ld   a,(bc)   ; each character until 0xff
558F: 03          inc  bc
5590: FE FF       cp   $FF
5592: 20 02       jr   nz,$5596
5594: C5          push bc
5595: C9          ret
5596: 77          ld   (hl),a   ; writes to screen loc
5597: 16 FF       ld   d,$FF
5599: 1E E0       ld   e,$E0
559B: 19          add  hl,de
559C: 18 F0       jr   _LP_1

559E: FF ...

55A0: 21 70 14    ld   hl,$CALL_RESET_SCREEN_META_AND_SPRITES
55A3: CD 81 5C    call $JMP_HL
55A6: CD D0 56    call $56D0
55A9: 00          nop
55AA: 00          nop
55AB: 00          nop
55AC: CD A8 5A    call $FLASH_BORDER
55AF: CD 70 55    call $DRAW_TILES_H_COPY
55B2: 08 0B
55B4: 12 15 27 11 22 15 FF
55BB: CD A8 5A    call $FLASH_BORDER
55BE: CD 70 55    call $DRAW_TILES_H_COPY
55C1: 0C 05
55C3: 29 1F 25 22 10 12 15 19 1E 17 10 18 23 15 14 FF
55D5: CD A8 5A    call $FLASH_BORDER
55D8: CD 70 55    call $DRAW_TILES_H_COPY
55DB: 10 07
55DD: 12 29 10 11 10 14 19 1E 1F 23 11 25 22 FF
55EB: C3 B2 48    jp   $48B2

55EE: FF ...

55F0: A1          and  c
55F1: 02          ld   (bc),a
55F2: C3 02 A1    jp   $A102
55F5: 02          ld   (bc),a
55F6: C3 02 A1    jp   $A102
55F9: 02          ld   (bc),a
55FA: C3 02 A1    jp   $A102
55FD: 02          ld   (bc),a
55FE: C3 02 FF    jp   $FF02
5601: FF ...
5604: 00          nop
5605: 02          ld   (bc),a
5606: FF          rst  $38
5607: FF          rst  $38
5608: FF          rst  $38
5609: FF          rst  $38
560A: FF          rst  $38
560B: FF          rst  $38
560C: 0E 0E       ld   c,$0E
560E: FF          rst  $38
560F: FF          rst  $38
5610: E0          ret  po
5611: 15          dec  d
5612: FF          rst  $38
5613: FF          rst  $38
5614: 44          ld   b,h
5615: 15          dec  d
5616: 48          ld   c,b
5617: 15          dec  d
5618: 48          ld   c,b
5619: 15          dec  d
561A: A0          and  b
561B: 15          dec  d
561C: A0          and  b
561D: 15          dec  d
561E: EE 09       xor  $09
5620: FF          rst  $38
5621: FF          rst  $38
5622: 70          ld   (hl),b
5623: 18 70       jr   $5695
5625: 18 30       jr   $5657
5627: 17          rla
5628: B0          or   b
5629: 18 EE       jr   $5619
562B: 05          dec  b
562C: FF          rst  $38
562D: FF          rst  $38
562E: FF          rst  $38
562F: FF          rst  $38
5630: 0E 02       ld   c,$02
5632: 13          inc  de
5633: 04          inc  b
5634: 13          inc  de
5635: 04          inc  b
5636: 13          inc  de
5637: 02          ld   (bc),a
5638: 13          inc  de
5639: 06 1A       ld   b,$1A
563B: 04          inc  b
563C: 1A          ld   a,(de)
563D: 04          inc  b
563E: 1A          ld   a,(de)
563F: 02          ld   (bc),a
5640: 1E 06       ld   e,$06
5642: 1C          inc  e
5643: 04          inc  b
5644: 1E 02       ld   e,$02
5646: 1C          inc  e
5647: 02          ld   (bc),a
5648: 1A          ld   a,(de)
5649: 06 17       ld   b,$17
564B: 04          inc  b
564C: FF          rst  $38
564D: FF          rst  $38
564E: FF          rst  $38
564F: FF          rst  $38
5650: 13          inc  de
5651: 02          ld   (bc),a
5652: 17          rla
5653: 02          ld   (bc),a
5654: 18 02       jr   $5658
5656: 1A          ld   a,(de)
5657: 02          ld   (bc),a
5658: 1A          ld   a,(de)
5659: 04          inc  b
565A: 1A          ld   a,(de)
565B: 04          inc  b
565C: 1A          ld   a,(de)
565D: 06 1A       ld   b,$1A
565F: 02          ld   (bc),a
5660: 18 06       jr   $5668
5662: 18 04       jr   $5668
5664: 18 02       jr   $5668
5666: 18 02       jr   $566A
5668: 18 02       jr   $566C
566A: 17          rla
566B: 02          ld   (bc),a
566C: 17          rla
566D: 02          ld   (bc),a
566E: 13          inc  de
566F: 04          inc  b
5670: 17          rla
5671: 04          inc  b
5672: 18 02       jr   $5676
5674: 0E 02       ld   c,$02
5676: FF          rst  $38
5677: FF          rst  $38
5678: 09          add  hl,bc
5679: 02          ld   (bc),a
567A: 0B          dec  bc
567B: 04          inc  b
567C: 0B          dec  bc
567D: 04          inc  b
567E: 0B          dec  bc
567F: 02          ld   (bc),a
5680: 0C          inc  c
5681: 06 15       ld   b,$15
5683: 04          inc  b
5684: 15          dec  d
5685: 04          inc  b
5686: 15          dec  d
5687: 02          ld   (bc),a
5688: 1A          ld   a,(de)
5689: 06 18       ld   b,$18
568B: 04          inc  b
568C: 1A          ld   a,(de)
568D: 02          ld   (bc),a
568E: 18 02       jr   $5692
5690: 15          dec  d
5691: 06 13       ld   b,$13
5693: 04          inc  b
5694: FF          rst  $38
5695: FF          rst  $38
5696: 0E 02       ld   c,$02
5698: 13          inc  de
5699: 02          ld   (bc),a
569A: 13          inc  de
569B: 02          ld   (bc),a
569C: 15          dec  d
569D: 02          ld   (bc),a
569E: 15          dec  d
569F: 04          inc  b
56A0: 15          dec  d
56A1: 04          inc  b
56A2: 15          dec  d
56A3: 06 15       ld   b,$15
56A5: 02          ld   (bc),a
56A6: 13          inc  de
56A7: 06 13       ld   b,$13
56A9: 04          inc  b
56AA: 13          inc  de
56AB: 02          ld   (bc),a
56AC: 13          inc  de
56AD: 02          ld   (bc),a
56AE: 13          inc  de
56AF: 02          ld   (bc),a
56B0: 13          inc  de
56B1: 02          ld   (bc),a
56B2: 13          inc  de
56B3: 02          ld   (bc),a
56B4: 0E 04       ld   c,$04
56B6: 13          inc  de
56B7: 04          inc  b
56B8: 13          inc  de
56B9: 02          ld   (bc),a
56BA: 15          dec  d
56BB: 02          ld   (bc),a
56BC: FF          rst  $38
56BD: FF          rst  $38
56BE: FF          rst  $38
56BF: FF          rst  $38
56C0: 05          dec  b
56C1: 05          dec  b
56C2: 0C          inc  c
56C3: 00          nop
56C4: 0C          inc  c
56C5: 16 30       ld   d,$30
56C7: 16 30       ld   d,$30
56C9: 16 50       ld   d,$50
56CB: 16 50       ld   d,$50
56CD: 16 EE       ld   d,$EE
56CF: 09          add  hl,bc
56D0: 3E 01       ld   a,$01
56D2: CD D8 5A    call $5AD8
56D5: 21 88 0F    ld   hl,$0F88
56D8: CD 81 4C    call $4C81
56DB: C9          ret
56DC: FF          rst  $38
56DD: FF          rst  $38
56DE: FF          rst  $38
56DF: FF          rst  $38
56E0: 03          inc  bc
56E1: C0          ret  nz
56E2: 16 A0       ld   d,$A0
56E4: 18 22       jr   $5708
56E6: 16 FF       ld   d,$FF
56E8: CD C0 46    call $46C0
56EB: CD 70 48    call $4870
56EE: CD 10 49    call $4910
56F1: CD 20 55    call $5520
56F4: C9          ret
56F5: FF          rst  $38
56F6: FF          rst  $38
56F7: FF          rst  $38
56F8: 12          ld   (de),a
56F9: 01 0E 01    ld   bc,$010E
56FC: 12          ld   (de),a
56FD: 01 0E 01    ld   bc,$010E
5700: 10 01       djnz $5703
5702: 0D          dec  c
5703: 01 10 01    ld   bc,$0110
5706: 0D          dec  c
5707: 01 0E 01    ld   bc,$010E
570A: 0B          dec  bc
570B: 01 0E 01    ld   bc,$010E
570E: 0B          dec  bc
570F: 01 0D 01    ld   bc,$010D
5712: 09          add  hl,bc
5713: 01 0D 01    ld   bc,$010D
5716: 09          add  hl,bc
5717: 01 04 01    ld   bc,$0104
571A: 06 01       ld   b,$01
571C: 07          rlca
571D: 01 09 01    ld   bc,$0109
5720: 0B          dec  bc
5721: 01 0D 01    ld   bc,$010D
5724: 0E 01       ld   c,$01
5726: 10 01       djnz $5729
5728: 0E 02       ld   c,$02
572A: 09          add  hl,bc
572B: 02          ld   (bc),a
572C: 0E 04       ld   c,$04
572E: FF          rst  $38
572F: FF          rst  $38
5730: A1          and  c
5731: 02          ld   (bc),a
5732: C3 02 A1    jp   $A102
5735: 02          ld   (bc),a
5736: C3 02 A1    jp   $A102
5739: 02          ld   (bc),a
573A: C3 02 A1    jp   $A102
573D: 02          ld   (bc),a
573E: C3 02 A1    jp   $A102
5741: 02          ld   (bc),a
5742: C3 01 C3    jp   $C301
5745: 01 A0 02    ld   bc,$02A0
5748: A0          and  b
5749: 02          ld   (bc),a
574A: D3 01       out  ($01),a
574C: D3 01       out  ($01),a
574E: D3 01       out  ($01),a
5750: D3 01       out  ($01),a
5752: C0          ret  nz
5753: 02          ld   (bc),a
5754: C1          pop  bc
5755: 02          ld   (bc),a
5756: FF          rst  $38
5757: FF          rst  $38
5758: FF          rst  $38
5759: FF          rst  $38
575A: FF          rst  $38
575B: FF          rst  $38
575C: FF          rst  $38
575D: FF          rst  $38
575E: FF          rst  $38
575F: FF          rst  $38
5760: 01 08 0F    ld   bc,$0F08
5763: 10 F8       djnz $575D
5765: 56          ld   d,(hl)
5766: FF          rst  $38
5767: FF          rst  $38
5768: 80          add  a,b
5769: 57          ld   d,a
576A: FF          rst  $38
576B: FF          rst  $38
576C: 6E          ld   l,(hl)
576D: 57          ld   d,a
576E: FF          rst  $38
576F: FF          rst  $38
5770: 02          ld   (bc),a
5771: 60          ld   h,b
5772: 57          ld   d,a
5773: 68          ld   l,b
5774: 57          ld   d,a
5775: 6C          ld   l,h
5776: 57          ld   d,a
5777: FF          rst  $38
5778: FF          rst  $38
5779: FF          rst  $38
577A: FF          rst  $38
577B: FF          rst  $38
577C: FF          rst  $38
577D: FF          rst  $38
577E: FF          rst  $38
577F: FF          rst  $38
5780: 15          dec  d
5781: 01 0E 01    ld   bc,$010E
5784: 15          dec  d
5785: 01 0E 01    ld   bc,$010E
5788: 15          dec  d
5789: 01 10 01    ld   bc,$0110
578C: 15          dec  d
578D: 01 10 01    ld   bc,$0110
5790: 13          inc  de
5791: 01 0E 01    ld   bc,$010E
5794: 13          inc  de
5795: 01 0E 01    ld   bc,$010E
5798: 10 01       djnz $579B
579A: 09          add  hl,bc
579B: 01 10 01    ld   bc,$0110
579E: 09          add  hl,bc
579F: 01 09 01    ld   bc,$0109
57A2: 0B          dec  bc
57A3: 01 09 01    ld   bc,$0109
57A6: 07          rlca
57A7: 01 06 01    ld   bc,$0106
57AA: 04          inc  b
57AB: 01 02 01    ld   bc,$0102
57AE: 04          inc  b
57AF: 01 02 02    ld   bc,$0202
57B2: 06 02       ld   b,$02
57B4: 02          ld   (bc),a
57B5: 04          inc  b
57B6: FF ...

CALL_DRAW_EXTRA_BONUS_SCREEN
57C0: C3 F0 5A    jp   $DRAW_EXTRA_BONUS_SCREEN
    ;;
57C3: CD 81 5C    call $JMP_HL
57C6: 21 88 0F    ld   hl,$0F88
57C9: CD 81 5C    call $JMP_HL
57CC: CD 70 55    call $DRAW_TILES_H_COPY
57CF: 08 08
57D1: 15 28 24 22 11 10 12 1F 1E 25 23 FF
57DD: CD 70 55    call $DRAW_TILES_H_COPY
57E0: 09 08
57E2: 2B 2B 2B 2B 2B 2B 2B 2B 2B 2B 2B FF
57EE: CD B0 4E    call $4EB0
57F1: CD B0 4E    call $4EB0
57F4: CD 70 55    call $DRAW_TILES_H_COPY
57F7: 0C 07
57F9: 20 19 13 1B 10 25 20 10 06 10 12 1F 1E 25 23 FF
5809: CD 70 55    call $DRAW_TILES_H_COPY
580C: 10 07
580E: 1F 12 1A 15 13 24 23 10 27 19 24 18 1F 25 24 FF
581E: CD 70 55    call $DRAW_TILES_H_COPY
5821: 14 07
5823: 1C 1F 23 19 1E 10 11 10 1C 19 16 15 FF
5831: CD B0 4E    call $4EB0
5834: CD B0 4E    call $4EB0
5837: CD 70 55    call $DRAW_TILES_H_COPY
583A: 17 0B
583C: E0 DC DD DE DF FF
5842: CD 70 55    call $DRAW_TILES_H_COPY
5845: 18 0B
5847: E1 E8 EA F2 E6 FF
584D: CD 70 55    call $DRAW_TILES_H_COPY
5850: 19 0B
5852: E1 E9 EB F3 E6 FF
5858: CD 70 55    call $DRAW_TILES_H_COPY
585B: 1A 0B
585D: E2 E3 E3 E3 E4 FF
5853: CD B0 4E    call $4EB0
5866: CD B0 4E    call $4EB0
5869: CD B0 4E    call $4EB0
586C: CD B0 4E    call $4EB0
586F: C9          ret

    ;;
5870: A2          and  d
5871: 01 A2 01    ld   bc,$01A2
5874: A2          and  d
5875: 01 A2 01    ld   bc,$01A2
5878: B2          or   d
5879: 01 B2 01    ld   bc,$01B2
587C: B2          or   d
587D: 01 B2 01    ld   bc,$01B2
5880: C2 01 C2    jp   nz,$C201
5883: 01 C2 01    ld   bc,$01C2
5886: C2 01 D2    jp   nz,$D201
5889: 01 D2 01    ld   bc,$01D2
588C: D2 01 D2    jp   nc,$D201
588F: 01 FF FF    ld   bc,$FFFF
5892: FF          rst  $38
5893: FF          rst  $38
5894: FF          rst  $38
5895: FF          rst  $38
5896: FF          rst  $38
5897: FF          rst  $38
5898: FF          rst  $38
5899: FF          rst  $38
589A: FF          rst  $38
589B: FF          rst  $38
589C: FF          rst  $38
589D: FF          rst  $38
589E: FF          rst  $38
589F: FF          rst  $38
58A0: 0C          inc  c
58A1: 16 78       ld   d,$78
58A3: 16 78       ld   d,$78
58A5: 16 96       ld   d,$96
58A7: 16 96       ld   d,$96
58A9: 16 EE       ld   d,$EE
58AB: 09          add  hl,bc
58AC: FF          rst  $38
58AD: FF          rst  $38
58AE: FF          rst  $38
58AF: FF          rst  $38
58B0: A1          and  c
58B1: 02          ld   (bc),a
58B2: C3 02 A1    jp   $A102
58B5: 02          ld   (bc),a
58B6: C3 02 A1    jp   $A102
58B9: 02          ld   (bc),a
58BA: C3 02 A1    jp   $A102
58BD: 02          ld   (bc),a
58BE: C3 02 A0    jp   $A002
58C1: 02          ld   (bc),a
58C2: D3 01       out  ($01),a
58C4: D3 01       out  ($01),a
58C6: D3 01       out  ($01),a
58C8: D3 01       out  ($01),a
58CA: FF          rst  $38
58CB: FF          rst  $38
58CC: FF          rst  $38
58CD: FF          rst  $38
58CE: FF          rst  $38
58CF: FF          rst  $38

    ;; bytes after the call are
    ;; start_x, start_y, tile 1, ...tile x, 0xFF
DRAW_TILES_V
58D0: DD E1       pop  ix       ; pops next addr (eg, data) from stack
58D2: 26 00       ld   h,$00
58D4: DD 6E 00    ld   l,(ix+$00) ; start_x
58D7: 29          add  hl,hl
58D8: 29          add  hl,hl
58D9: 29          add  hl,hl
58DA: 29          add  hl,hl
58DB: 29          add  hl,hl
58DC: DD 23       inc  ix       ; start_y
58DE: DD 7E 00    ld   a,(ix+$00)
58E1: 85          add  a,l
58E2: 6F          ld   l,a
58E3: 01 40 90    ld   bc,$START_OF_TILES
58E6: 09          add  hl,bc
58E7: DD 23       inc  ix       ; read data until 0xff
58E9: DD 7E 00    ld   a,(ix+$00)
58EC: FE FF       cp   $FF
58EE: 28 04       jr   z,$58F4
58F0: 77          ld   (hl),a
58F1: 23          inc  hl
58F2: 18 F3       jr   $58E7
58F4: DD 23       inc  ix
58F6: DD E5       push ix
58F8: C9          ret

58F9: FF ...

DRAW_SPLASH_CIRCLE_BORDER_1
5900: CD 70 55    call $DRAW_TILES_H_COPY
5903: 01 01                ; start pos
    ;; splash screen circle border (26 = tiles)
    ;; Top Row 1
5905: 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51
5915: 52 53 51 52 53 51 52 53 51 52 FF

    ;; Right side 1
5920: CD D0 58    call $DRAW_TILES_V
5923: 01 02                ; start pos
5925: 53 52 51 53 52 51 53 52 51 53 52 51 53 52 51 53
5935: 52 51 53 52 51 53 52 51 53 52 FF

    ;; Left side 1
5940: CD D0 58    call $DRAW_TILES_V
5943: SCR_TILE_W 02       ;start pos
5945: 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51
5955: 52 53 51 52 53 51 52 53 51 52 FF

    ;; Bottom row 1
5960: CD 70 55    call $DRAW_TILES_H_COPY
5963: SCR_TILE_H 01      ; start pos
5965: 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53
5975: 51 52 53 51 52 53 51 52 53 51 FF
5980: C9          ret

5981: FF ...

DRAW_SPLASH_CIRCLE_BORDER_2
5988: CD 70 55    call $DRAW_TILES_H_COPY
598B: 01 01
598D: 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52
599D: 53 51 52 53 51 52 53 51 52 53 FF
    ;;
59A8: CD D0 58    call $DRAW_TILES_V
59AB: 01 02
59AD: 52 51 53 52 51 53 52 51 53 52 51 53 52 51 53 52
59BD: 51 53 52 51 53 52 51 53 52 51 FF
    ;;
59C8: CD D0 58    call $DRAW_TILES_V
59CB: 1A 02
59CD: 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53
59DD: 51 52 53 51 52 53 51 52 53 51 FF           rst  $38
    ;;
59E8: CD 70 55    call $DRAW_TILES_H_COPY
59EB: 1C 01
59ED: 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52
59FD: 53 51 52 53 51 52 53 51 52 53 FF
    ;;
5A08: C9          ret
5A09: FF ...

DRAW_SPLASH_CIRCLE_BORDER_3
5A10: CD 70 55    call $DRAW_TILES_H_COPY
5A13: 01 01
5A15: 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53
5A25: 51 52 53 51 52 53 51 52 53 51 FF
    ;;
5A30: CD D0 58    call $DRAW_TILES_V
5A33: 01 02
5A35: 51 53 52 51 53 52 51 53 52 51 53 52 51 53 52 51
5A45: 53 52 51 53 52 51 53 52 51 53 FF
    ;;
5A50: CD D0 58    call $DRAW_TILES_V
5A53: 1A 02
5A55: 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51 52
5A65: 53 51 52 53 51 52 53 51 52 53 FF
    ;;
5A70: CD 70 55    call $DRAW_TILES_H_COPY
5A73: 1C 01
5A75: 51 52 53 51 52 53 51 52 53 51 52 53 51 52 53 51
5A85: 52 53 51 52 53 51 52 53 51 52 FF
    ;;
5A90: C9          ret
5A91: FF ...

    ;;
5A98: E5          push hl
5A99: C5          push bc
5A9A: D5          push de
5A9B: 21 28 21    ld   hl,$2128
5A9E: CD 81 5C    call $JMP_HL
5AA1: D1          pop  de
5AA2: C1          pop  bc
5AA3: E1          pop  hl
5AA4: C9          ret
5AA5: FF ...

    ;; Splash screen animated circle border
FLASH_BORDER
5AA8: 1E 05       ld   e,$05
5AAA: 16 05       ld   d,$05
5AAC: D5          push de
5AAD: CD 00 59    call $DRAW_SPLASH_CIRCLE_BORDER_1
5AB0: CD 98 5A    call $5A98
5AB3: D1          pop  de
5AB4: 15          dec  d
5AB5: 20 F5       jr   nz,$5AAC
5AB7: 16 05       ld   d,$05
5AB9: D5          push de
5ABA: CD 88 59    call $DRAW_SPLASH_CIRCLE_BORDER_2
5ABD: CD 98 5A    call $5A98
5AC0: D1          pop  de
5AC1: 15          dec  d
5AC2: 20 F5       jr   nz,$5AB9
5AC4: 16 05       ld   d,$05
5AC6: D5          push de
5AC7: CD 10 5A    call $DRAW_SPLASH_CIRCLE_BORDER_3
5ACA: CD 98 5A    call $5A98
5ACD: D1          pop  de
5ACE: 15          dec  d
5ACF: 20 F5       jr   nz,$5AC6
5AD1: 1D          dec  e
5AD2: 20 D6       jr   nz,$5AAA
5AD4: C9          ret
5AD5: FF ...

5AD8: 47          ld   b,a
5AD9: 21 01 81    ld   hl,$SCREEN_XOFF_COL+1 ;col for row 1
5ADC: 70          ld   (hl),b
5ADD: 23          inc  hl
5ADE: 23          inc  hl
5ADF: 7D          ld   a,l
5AE0: FE 41       cp   $41
5AE2: 20 F8       jr   nz,$5ADC
5AE4: C9          ret

5AE5: FF

5AE6: 3E 04       ld   a,$04
5AE8: CD D8 5A    call $5AD8
5AEB: C9          ret
5AEC: FF ...

DRAW_EXTRA_BONUS_SCREEN
5AF0: 21 70 14    ld   hl,$CALL_RESET_SCREEN_META_AND_SPRITES
5AF3: CD 81 5C    call $JMP_HL
5AF6: 21 88 0F    ld   hl,$0F88
5AF9: CD 81 5C    call $JMP_HL
5AFC: CD E6 5A    call $5AE6
5AFF: CD 70 55    call $DRAW_TILES_H_COPY
5B02: 08 08
    ;; EXTRA BONUS
5B04: 15 28 24 22 11 10 12 1F 1E 25 23 FF
5B10: CD 70 55    call $DRAW_TILES_H_COPY
5B13: 09 08
5B15: 2B 2B 2B 2B 2B 2B 2B 2B 2B 2B 2B FF
5B21: CD A8 5A    call $FLASH_BORDER
5B24: CD A8 5A    call $FLASH_BORDER
5B27: CD 70 55    call $DRAW_TILES_H_COPY
5B2A: 0C 07
    ;; PICK UP 6 BONUS
5B2C: 20 19 13 1B 10 25 20 10 06 10 12 1F 1E 25 23 FF
5B3C: CD 70 55    call $DRAW_TILES_H_COPY
5B3F: 10 07
5B41: 1F 12 1A 15 13 24 23 10 27 19 24 18 1F 25 24 FF
5B51: CD 70 55    call $DRAW_TILES_H_COPY
5B54: 14 07
5B56: 1C 1F 23 19 1E 17 10 11 10 1C 19 16 15 FF
5B64: CD A8 5A    call $FLASH_BORDER
5B67: CD 70 55    call $DRAW_TILES_H_COPY
5B6A: 17 0B
5B6C: E0 DC DD DE DF FF
5B72: CD 70 55    call $DRAW_TILES_H_COPY
5B75: 18 0B
5B77: E1 E5 E5 E5 E6 FF
5B7D: CD 70 55    call $DRAW_TILES_H_COPY
5B80: 19 0B
5B82: E1 E5 E5 E5 E6 FF
5B88: CD 70 55    call $DRAW_TILES_H_COPY
5B8B: 1A 0B
5B8D: E2 E3 E3 E3 E4 FF CD A8 5A CD A8 5A CD C8 5B C9 FF
5B9E: FF ...

ANIMATE_CIRCLE_BORDER
5BA8: 3A 64 80    ld   a,($SPLASH_ANIM_FR)
5BAB: 3C          inc  a
5BAC: FE 03       cp   $03
5BAE: 20 01       jr   nz,$5BB1
5BB0: AF          xor  a
5BB1: 32 64 80    ld   ($SPLASH_ANIM_FR),a
5BB4: A7          and  a
5BB5: 20 04       jr   nz,$_BORDER_1_2
5BB7: CD 10 5A    call $DRAW_SPLASH_CIRCLE_BORDER_3
5BBA: C9          ret
_BORDER_1_2
5BBB: FE 01       cp   $01
5BBD: 20 04       jr   nz,$5BC3
5BBF: CD 88 59    call $DRAW_SPLASH_CIRCLE_BORDER_2
5BC2: C9          ret
5BC3: CD 00 59    call $DRAW_SPLASH_CIRCLE_BORDER_1
5BC6: C9          ret

5BC7: FF

5BC8: 3E F2       ld   a,$F2
5BCA: 32 F8 91    ld   ($91F8),a
5BCD: CD A8 5A    call $FLASH_BORDER
5BD0: 3E F3       ld   a,$F3
5BD2: 32 F9 91    ld   ($91F9),a
5BD5: CD A8 5A    call $FLASH_BORDER
5BD8: 3E EA       ld   a,$EA
5BDA: 32 18 92    ld   ($9218),a
5BDD: CD A8 5A    call $FLASH_BORDER
5BE0: 3E EB       ld   a,$EB
5BE2: 32 19 92    ld   ($9219),a
5BE5: CD A8 5A    call $FLASH_BORDER
5BE8: 3E E8       ld   a,$E8
5BEA: 32 38 92    ld   ($9238),a
5BED: CD A8 5A    call $FLASH_BORDER
5BF0: 3E E9       ld   a,$E9
5BF2: 32 39 92    ld   ($9239),a
5BF5: CD A8 5A    call $FLASH_BORDER
5BF8: CD A8 5A    call $FLASH_BORDER
5BFB: CD A8 5A    call $FLASH_BORDER
5BFE: C9          ret
5BFF: FF          rst  $38
5C00: 15          dec  d
5C01: 01 15 01    ld   bc,$0115
5C04: 15          dec  d
5C05: 01 1A 03    ld   bc,$031A
5C08: 1E 02       ld   e,$02
5C0A: 15          dec  d
5C0B: 01 15 01    ld   bc,$0115
5C0E: 15          dec  d
5C0F: 01 1A 03    ld   bc,$031A
5C12: 1E 02       ld   e,$02
5C14: 15          dec  d
5C15: 01 15 01    ld   bc,$0115
5C18: 15          dec  d
5C19: 01 1A 01    ld   bc,$011A
5C1C: 21 01 21    ld   hl,$2101
5C1F: 01 21 01    ld   bc,$0121
5C22: 21 03 23    ld   hl,$2303
5C25: 01 1E 01    ld   bc,$011E
5C28: 1C          inc  e
5C29: 04          inc  b
5C2A: 15          dec  d
5C2B: 01 15 01    ld   bc,$0115
5C2E: 15          dec  d
5C2F: 01 19 03    ld   bc,$0319
5C32: 1C          inc  e
5C33: 02          ld   (bc),a
5C34: 15          dec  d
5C35: 01 15 01    ld   bc,$0115
5C38: 15          dec  d
5C39: 01 19 03    ld   bc,$0319
5C3C: 1C          inc  e
5C3D: 02          ld   (bc),a
5C3E: 15          dec  d
5C3F: 01 15 01    ld   bc,$0115
5C42: 15          dec  d
5C43: 01 15 01    ld   bc,$0115
5C46: 21 01 21    ld   hl,$2101
5C49: 01 21 01    ld   bc,$0121
5C4C: 21 02 23    ld   hl,$2302
5C4F: 01 1E 02    ld   bc,$021E
5C52: 1A          ld   a,(de)
5C53: 04          inc  b
5C54: FF          rst  $38
5C55: FF          rst  $38
5C56: FF          rst  $38
5C57: FF          rst  $38
5C58: FF          rst  $38
5C59: FF          rst  $38
5C5A: FF          rst  $38
5C5B: FF          rst  $38
5C5C: FF          rst  $38
5C5D: FF          rst  $38
5C5E: FF          rst  $38
5C5F: FF          rst  $38
5C60: 62          ld   h,d
5C61: 5C          ld   e,h
5C62: FF          rst  $38
5C63: FF          rst  $38
5C64: FF          rst  $38
5C65: FF          rst  $38
5C66: FF          rst  $38
5C67: FF          rst  $38
5C68: FF          rst  $38
5C69: FF          rst  $38
5C6A: FF          rst  $38
5C6B: FF          rst  $38
5C6C: FF          rst  $38
5C6D: FF          rst  $38
5C6E: FF          rst  $38
5C6F: FF          rst  $38
5C70: FF          rst  $38
5C71: FF          rst  $38
5C72: FF          rst  $38
5C73: FF          rst  $38
5C74: FF          rst  $38
5C75: FF          rst  $38
5C76: FF          rst  $38
5C77: FF          rst  $38
5C78: FF          rst  $38
5C79: FF          rst  $38
5C7A: FF          rst  $38
5C7B: FF          rst  $38
5C7C: FF          rst  $38
5C7D: FF          rst  $38
5C7E: FF          rst  $38
5C7F: FF          rst  $38
5C80: FF          rst  $38

JMP_HL
5C81: E9          jp   (hl)
5C82: 40          ld   b,b
5C83: 41          ld   b,c
5C84: C9          ret
5C85: FF          rst  $38
5C86: 06 01       ld   b,$01
5C88: 06 01       ld   b,$01
5C8A: 06 01       ld   b,$01
5C8C: 0E 01       ld   c,$01
5C8E: 09          add  hl,bc
5C8F: 01 12 01    ld   bc,$0112
5C92: 10 01       djnz $5C95
5C94: 0E 01       ld   c,$01
5C96: 06 01       ld   b,$01
5C98: 06 01       ld   b,$01
5C9A: 06 01       ld   b,$01
5C9C: 0E 01       ld   c,$01
5C9E: 09          add  hl,bc
5C9F: 01 12 01    ld   bc,$0112
5CA2: 10 01       djnz $5CA5
5CA4: 0E 01       ld   c,$01
5CA6: 06 01       ld   b,$01
5CA8: 06 01       ld   b,$01
5CAA: 06 01       ld   b,$01
5CAC: 0E 01       ld   c,$01
5CAE: 09          add  hl,bc
5CAF: 01 12 01    ld   bc,$0112
5CB2: 10 01       djnz $5CB5
5CB4: 0E 01       ld   c,$01
5CB6: 12          ld   (de),a
5CB7: 01 12 01    ld   bc,$0112
5CBA: 12          ld   (de),a
5CBB: 01 10 01    ld   bc,$0110
5CBE: 10 01       djnz $5CC1
5CC0: 0D          dec  c
5CC1: 01 07 02    ld   bc,$0207
5CC4: 07          rlca
5CC5: 01 07 01    ld   bc,$0107
5CC8: 07          rlca
5CC9: 01 0D 01    ld   bc,$010D
5CCC: 0D          dec  c
5CCD: 01 10 01    ld   bc,$0110
5CD0: 10 02       djnz $5CD4
5CD2: 07          rlca
5CD3: 01 07 01    ld   bc,$0107
5CD6: 07          rlca
5CD7: 01 0D 01    ld   bc,$010D
5CDA: 0D          dec  c
5CDB: 01 10 01    ld   bc,$0110
5CDE: 10 02       djnz $5CE2
5CE0: 07          rlca
5CE1: 01 07 01    ld   bc,$0107
5CE4: 07          rlca
5CE5: 01 09 01    ld   bc,$0109
5CE8: 10 01       djnz $5CEB
5CEA: 10 01       djnz $5CED
5CEC: 10 01       djnz $5CEF
5CEE: 15          dec  d
5CEF: 01 15 01    ld   bc,$0115
5CF2: 13          inc  de
5CF3: 02          ld   (bc),a
5CF4: 12          ld   (de),a
5CF5: 01 10 02    ld   bc,$0210
5CF8: 0E 02       ld   c,$02
5CFA: FF          rst  $38
5CFB: FF          rst  $38
5CFC: FF          rst  $38
5CFD: FF          rst  $38
5CFE: FF          rst  $38
5CFF: FF          rst  $38

TBL_2
5D00: 02
5D01: 08 5D
5D03: 14 5D
5D05: 14 5D

5D07: FF          rst  $38
5D08: 01 08 0E    ld   bc,$0E08
5D0B: 00          nop
5D0C: 86          add  a,(hl)
5D0D: 5C          ld   e,h
5D0E: EE 03       xor  $03
5D10: FF          rst  $38
5D11: FF          rst  $38
5D12: FF          rst  $38
5D13: FF          rst  $38
5D14: 00          nop
5D15: 5C          ld   e,h
5D16: EE 03       xor  $03
5D18: FF          rst  $38
5D19: FF          rst  $38
5D1A: 70          ld   (hl),b
5D1B: 18 30       jr   $5D4D
5D1D: 17          rla
5D1E: 30 17       jr   nc,$5D37
5D20: 30 17       jr   nc,$5D39
5D22: 30 17       jr   nc,$5D3B
5D24: 28 1D       jr   z,$5D43
5D26: EE 03       xor  $03
5D28: E3          ex   (sp),hl
5D29: 06 D3       ld   b,$D3
5D2B: 03          inc  bc
5D2C: D3 03       out  ($03),a
5D2E: FF          rst  $38
5D2F: FF          rst  $38
5D30: 19          add  hl,de
5D31: 01 1A 01    ld   bc,$011A
5D34: 1B          dec  de
5D35: 01 1C 01    ld   bc,$011C
5D38: 21 02 1C    ld   hl,$1C02
5D3B: 01 21 02    ld   bc,$0221
5D3E: 1C          inc  e
5D3F: 02          ld   (bc),a
5D40: 1B          dec  de
5D41: 01 21 02    ld   bc,$0221
5D44: 1B          dec  de
5D45: 01 21 02    ld   bc,$0221
5D48: 1B          dec  de
5D49: 02          ld   (bc),a
5D4A: 1A          ld   a,(de)
5D4B: 01 21 02    ld   bc,$0221
5D4E: 1A          ld   a,(de)
5D4F: 01 21 02    ld   bc,$0221
5D52: 1A          ld   a,(de)
5D53: 02          ld   (bc),a
5D54: 19          add  hl,de
5D55: 01 1A 01    ld   bc,$011A
5D58: 1B          dec  de
5D59: 01 1C 02    ld   bc,$021C
5D5C: FF          rst  $38
5D5D: FF          rst  $38
5D5E: FF          rst  $38
5D5F: FF          rst  $38
5D60: 19          add  hl,de
5D61: 20 FF       jr   nz,$5D62
5D63: FF          rst  $38
5D64: 1A          ld   a,(de)
5D65: 01 19 01    ld   bc,$0119
5D68: 17          rla
5D69: 01 15 03    ld   bc,$0315
5D6C: 15          dec  d
5D6D: 01 1C 03    ld   bc,$031C
5D70: 1C          inc  e
5D71: 01 1E 02    ld   bc,$021E
5D74: 1A          ld   a,(de)
5D75: 02          ld   (bc),a
5D76: 15          dec  d
5D77: 02          ld   (bc),a
5D78: 1E 02       ld   e,$02
5D7A: 1C          inc  e
5D7B: 03          inc  bc
5D7C: 19          add  hl,de
5D7D: 01 19 01    ld   bc,$0119
5D80: 17          rla
5D81: 01 15 02    ld   bc,$0215
5D84: 17          rla
5D85: 06 19       ld   b,$19
5D87: 01 17 01    ld   bc,$0117
5D8A: 15          dec  d
5D8B: 03          inc  bc
5D8C: 15          dec  d
5D8D: 01 1C 03    ld   bc,$031C
5D90: 1C          inc  e
5D91: 01 1E 01    ld   bc,$011E
5D94: 1C          inc  e
5D95: 01 1A 02    ld   bc,$021A
5D98: 1E 02       ld   e,$02
5D9A: 21 02 25    ld   hl,$2502
5D9D: 02          ld   (bc),a
5D9E: 25          dec  h
5D9F: 02          ld   (bc),a
5DA0: 26 01       ld   h,$01
5DA2: 25          dec  h
5DA3: 01 23 02    ld   bc,$0223
5DA6: 21 05 FF    ld   hl,$FF05
5DA9: FF          rst  $38
5DAA: FF          rst  $38
5DAB: FF          rst  $38
5DAC: 10 03       djnz $5DB1
5DAE: 10 04       djnz $5DB4
5DB0: 10 04       djnz $5DB6
5DB2: 12          ld   (de),a
5DB3: 04          inc  b
5DB4: 12          ld   (de),a
5DB5: 04          inc  b
5DB6: 10 04       djnz $5DBC
5DB8: 10 04       djnz $5DBE
5DBA: 0B          dec  bc
5DBB: 04          inc  b
5DBC: 0B          dec  bc
5DBD: 04          inc  b
5DBE: 10 04       djnz $5DC4
5DC0: 10 04       djnz $5DC6
5DC2: 12          ld   (de),a
5DC3: 04          inc  b
5DC4: 12          ld   (de),a
5DC5: 04          inc  b
5DC6: 10 04       djnz $5DCC
5DC8: 09          add  hl,bc
5DC9: 04          inc  b
5DCA: 09          add  hl,bc
5DCB: 05          dec  b
5DCC: FF          rst  $38
5DCD: FF          rst  $38
5DCE: FF          rst  $38
5DCF: FF          rst  $38
5DD0: 01 05 0F    ld   bc,$0F05
5DD3: 00          nop
5DD4: 60          ld   h,b
5DD5: 5D          ld   e,l
5DD6: AC          xor  h
5DD7: 5D          ld   e,l
5DD8: AC          xor  h
5DD9: 5D          ld   e,l
5DDA: EE 07       xor  $07
5DDC: CC 1D FF    call z,$FF1D
5DDF: FF          rst  $38
5DE0: 30 5D       jr   nc,$5E3F
5DE2: 64          ld   h,h
5DE3: 5D          ld   e,l
5DE4: 64          ld   h,h
5DE5: 5D          ld   e,l
5DE6: EE 07       xor  $07
5DE8: FF          rst  $38
5DE9: FF          rst  $38
5DEA: 03          inc  bc
5DEB: D0          ret  nc
5DEC: 5D          ld   e,l
5DED: E0          ret  po
5DEE: 5D          ld   e,l
5DEF: DC 5D FF    call c,$FF5D
5DF2: FF          rst  $38
5DF3: FF          rst  $38
5DF4: 15          dec  d
5DF5: 01 1A 02    ld   bc,$021A
5DF8: 1D          dec  e
5DF9: 01 1C 01    ld   bc,$011C
5DFC: 1D          dec  e
5DFD: 01 1C 01    ld   bc,$011C
5E00: 1A          ld   a,(de)
5E01: 02          ld   (bc),a
5E02: 1D          dec  e
5E03: 01 1C 02    ld   bc,$021C
5E06: 1D          dec  e
5E07: 01 1A 01    ld   bc,$011A
5E0A: 1C          inc  e
5E0B: 01 1D 01    ld   bc,$011D
5E0E: 1C          inc  e
5E0F: 02          ld   (bc),a
5E10: 1D          dec  e
5E11: 01 1A 01    ld   bc,$011A
5E14: 15          dec  d
5E15: 01 11 01    ld   bc,$0111
5E18: 0E 03       ld   c,$03
5E1A: FF          rst  $38
5E1B: FF          rst  $38
5E1C: 11 01 11    ld   de,$1101
5E1F: 01 11 01    ld   bc,$0111
5E22: 11 01 11    ld   de,$1101
5E25: 01 11 01    ld   bc,$0111
5E28: 11 01 11    ld   de,$1101
5E2B: 01 10 01    ld   bc,$0110
5E2E: 10 01       djnz $5E31
5E30: 10 01       djnz $5E33
5E32: 10 01       djnz $5E35
5E34: 10 01       djnz $5E37
5E36: 10 01       djnz $5E39
5E38: 10 01       djnz $5E3B
5E3A: 10 01       djnz $5E3D
5E3C: 0E 02       ld   c,$02
5E3E: 0E 01       ld   c,$01
5E40: 10 01       djnz $5E43
5E42: 11 02 0E    ld   de,$0E02
5E45: 02          ld   (bc),a
5E46: 14          inc  d
5E47: 04          inc  b
5E48: 15          dec  d
5E49: 04          inc  b
5E4A: FF          rst  $38
5E4B: FF          rst  $38
5E4C: 0E 02       ld   c,$02
5E4E: 11 01 09    ld   de,$0901
5E51: 01 0B 01    ld   bc,$010B
5E54: 0C          inc  c
5E55: 01 0E 02    ld   bc,$020E
5E58: 11 01 09    ld   de,$0901
5E5B: 01 0B 01    ld   bc,$010B
5E5E: 0C          inc  c
5E5F: 01 0E 02    ld   bc,$020E
5E62: 11 01 09    ld   de,$0901
5E65: 01 0B 01    ld   bc,$010B
5E68: 0C          inc  c
5E69: 01 0E 01    ld   bc,$010E
5E6C: 09          add  hl,bc
5E6D: 01 05 01    ld   bc,$0105
5E70: 02          ld   (bc),a
5E71: 03          inc  bc
5E72: FF          rst  $38
5E73: FF          rst  $38
5E74: FF          rst  $38
5E75: 01 06 0F    ld   bc,$0F06
5E78: 00          nop
5E79: 80          add  a,b
5E7A: 5E          ld   e,(hl)
5E7B: FF          rst  $38
5E7C: FF          rst  $38
5E7D: FF          rst  $38
5E7E: FF          rst  $38
5E7F: FF          rst  $38
5E80: FF          rst  $38
5E81: FF          rst  $38
5E82: FF          rst  $38
5E83: FF          rst  $38
5E84: FF          rst  $38
5E85: FF          rst  $38
5E86: FF          rst  $38
5E87: FF          rst  $38
5E88: 03          inc  bc
5E89: 75          ld   (hl),l
5E8A: 5E          ld   e,(hl)
5E8B: 90          sub  b
5E8C: 5E          ld   e,(hl)
5E8D: 79          ld   a,c
5E8E: 5E          ld   e,(hl)
5E8F: FF          rst  $38
5E90: F4 5D 1C    call p,$1C5D
5E93: 5E          ld   e,(hl)
5E94: 4C          ld   c,h
5E95: 5E          ld   e,(hl)
5E96: 4C          ld   c,h
5E97: 5E          ld   e,(hl)
5E98: EE 09       xor  $09
5E9A: FF          rst  $38
5E9B: FF          rst  $38
5E9C: FF          rst  $38
5E9D: FF          rst  $38
5E9E: FF          rst  $38
5E9F: FF          rst  $38
5EA0: 0E 01       ld   c,$01
5EA2: 10 01       djnz $5EA5
5EA4: 13          inc  de
5EA5: 01 17 01    ld   bc,$0117
5EA8: 16 01       ld   d,$01
5EAA: 17          rla
5EAB: 01 16 01    ld   bc,$0116
5EAE: 17          rla
5EAF: 01 16 01    ld   bc,$0116
5EB2: 17          rla
5EB3: 01 16 01    ld   bc,$0116
5EB6: 18 01       jr   $5EB9
5EB8: 17          rla
5EB9: 01 15 01    ld   bc,$0115
5EBC: 17          rla
5EBD: 01 13 01    ld   bc,$0113
5EC0: 0E 01       ld   c,$01
5EC2: 13          inc  de
5EC3: 01 17 01    ld   bc,$0117
5EC6: 1A          ld   a,(de)
5EC7: 01 19 01    ld   bc,$0119
5ECA: 1A          ld   a,(de)
5ECB: 01 19 01    ld   bc,$0119
5ECE: 1A          ld   a,(de)
5ECF: 01 19 01    ld   bc,$0119
5ED2: 1A          ld   a,(de)
5ED3: 01 19 01    ld   bc,$0119
5ED6: 1C          inc  e
5ED7: 01 1A 01    ld   bc,$011A
5EDA: 19          add  hl,de
5EDB: 01 1A 01    ld   bc,$011A
5EDE: 17          rla
5EDF: 01 0E 01    ld   bc,$010E
5EE2: 10 01       djnz $5EE5
5EE4: 13          inc  de
5EE5: 01 17 01    ld   bc,$0117
5EE8: 16 01       ld   d,$01
5EEA: 17          rla
5EEB: 01 16 01    ld   bc,$0116
5EEE: 17          rla
5EEF: 01 16 01    ld   bc,$0116
5EF2: 17          rla
5EF3: 01 16 01    ld   bc,$0116
5EF6: 18 01       jr   $5EF9
5EF8: 17          rla
5EF9: 01 15 01    ld   bc,$0115
5EFC: 17          rla
5EFD: 01 13 01    ld   bc,$0113
5F00: 0E 01       ld   c,$01
5F02: 10 01       djnz $5F05
5F04: 13          inc  de
5F05: 01 17 01    ld   bc,$0117
5F08: 15          dec  d
5F09: 02          ld   (bc),a
5F0A: 0E 01       ld   c,$01
5F0C: 17          rla
5F0D: 01 15 02    ld   bc,$0215
5F10: 0E 01       ld   c,$01
5F12: 13          inc  de
5F13: 02          ld   (bc),a
5F14: 0E 02       ld   c,$02
5F16: 13          inc  de
5F17: 01 FF FF    ld   bc,$FFFF
5F1A: FF          rst  $38
5F1B: FF          rst  $38
5F1C: FF          rst  $38
5F1D: FF          rst  $38
5F1E: FF          rst  $38
5F1F: FF          rst  $38
5F20: A0          and  b
5F21: 5E          ld   e,(hl)
5F22: EE 03       xor  $03
5F24: 03          inc  bc
5F25: 06 0F       ld   b,$0F
5F27: 10 1C       djnz $5F45
5F29: 5F          ld   e,a
5F2A: FF          rst  $38
5F2B: FF          rst  $38
5F2C: FF          rst  $38
5F2D: FF          rst  $38
5F2E: FF          rst  $38
5F2F: FF          rst  $38
5F30: 03          inc  bc
5F31: 24          inc  h
5F32: 5F          ld   e,a
5F33: 20 5F       jr   nz,$5F94
5F35: 28 5F       jr   z,$5F96
5F37: FF          rst  $38
5F38: 09          add  hl,bc
5F39: 01 0E 01    ld   bc,$010E
5F3C: 10 01       djnz $5F3F
5F3E: 12          ld   (de),a
5F3F: 03          inc  bc
5F40: 13          inc  de
5F41: 01 13 02    ld   bc,$0213
5F44: 17          rla
5F45: 02          ld   (bc),a
5F46: 15          dec  d
5F47: 04          inc  b
5F48: 12          ld   (de),a
5F49: 02          ld   (bc),a
5F4A: 15          dec  d
5F4B: 02          ld   (bc),a
5F4C: 13          inc  de
5F4D: 03          inc  bc
5F4E: 12          ld   (de),a
5F4F: 01 13 02    ld   bc,$0213
5F52: 10 02       djnz $5F56
5F54: 12          ld   (de),a
5F55: 05          dec  b
5F56: 09          add  hl,bc
5F57: 01 0E 01    ld   bc,$010E
5F5A: 10 01       djnz $5F5D
5F5C: 12          ld   (de),a
5F5D: 03          inc  bc
5F5E: 13          inc  de
5F5F: 01 13 02    ld   bc,$0213
5F62: 17          rla
5F63: 02          ld   (bc),a
5F64: 15          dec  d
5F65: 04          inc  b
5F66: 12          ld   (de),a
5F67: 02          ld   (bc),a
5F68: 15          dec  d
5F69: 02          ld   (bc),a
5F6A: 13          inc  de
5F6B: 03          inc  bc
5F6C: 12          ld   (de),a
5F6D: 01 13 02    ld   bc,$0213
5F70: 10 02       djnz $5F74
5F72: 0E 05       ld   c,$05
5F74: FF          rst  $38
5F75: FF          rst  $38
5F76: FF          rst  $38
5F77: FF          rst  $38
5F78: 03          inc  bc
5F79: 90          sub  b
5F7A: 5F          ld   e,a
5F7B: 80          add  a,b
5F7C: 5F          ld   e,a
5F7D: 98          sbc  a,b
5F7E: 5F          ld   e,a
5F7F: FF          rst  $38
5F80: 38 5F       jr   c,$5FE1
5F82: 20 4A       jr   nz,$5FCE
5F84: 20 4A       jr   nz,$5FD0
5F86: 48          ld   c,b
5F87: 4A          ld   c,d
5F88: 48          ld   c,b
5F89: 4A          ld   c,d
5F8A: EE 0B       xor  $0B
5F8C: FF          rst  $38
5F8D: FF          rst  $38
5F8E: FF          rst  $38
5F8F: FF          rst  $38
5F90: 01 05 0F    ld   bc,$0F05
5F93: 00          nop
5F94: 8C          adc  a,h
5F95: 5F          ld   e,a
5F96: FF          rst  $38
5F97: FF          rst  $38
5F98: C4 4A E4    call nz,$E44A
5F9B: 4A          ld   c,d
5F9C: E4 4A 06    call po,$064A
5F9F: 4B          ld   c,e
5FA0: 06 4B       ld   b,$4B
5FA2: EE 0B       xor  $0B

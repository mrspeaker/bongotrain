;;; Bongo by JetSoft, 1983
;;; written by John Hutchinson

;;; picked apart and rebuilt by Mr Speaker, 2023.
;;; https://www.mrspeaker.net

;;; Builds to MAME-exact version of Bongo ROM zip file.
;;; Read README.org for details and building instructions.

;;; Overview:
;;; - BIG_RESET ($1000) inits and starts loop
;;; - Main loop is at MAIN_LOOP ($104b)
;;; - ... which calls UPDATE_EVERYTHING ($1170)
;;; - Also a NMI interrupt loop ($66)
;;; - ... which calls hardware-y stuff

;;; Important Bongo lore:
;;; - We decided "Bongo" is actually name of the lil' jumpy
;;;   guy in the corner of the screen, not the player.
;;;   He's complicated: celebrates the player's death,
;;;   but also parties with player on dino capture.

;;; Entry Point: $0000 - `hard_reset`.

    START_OF_RAM      = $8000

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
    p1_score          = $8014  ; (BCD score)
    p1_score_1        = $8015  ; (BCD score)
    p1_score_2        = $8016  ; (BCD score)
    p2_score          = $8017  ; (BCD score)
    p2_score_1        = $8018  ; (BCD score)
    p2_score_2        = $8019  ; (BCD score)
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
    _8046             = $8046  ; ?
    _8049             = $8049  ; ?
    _804A             = $804A  ; ?

    lava_tile_offset  = $804B  ; Current lava tile (offset?)

    1up_scr_pos       = $804C  ; I reckon its where the 1up bonus text is on screen
    1up_scr_pos_2     = $804E  ; ... but not used I reckon,
    1up_scr_pos_3     = $804F  ; ... as they decided not to clear the text

    1up_timer         = $8050  ; This is never read- but looks like was going to remove 1up text
    is_hit_cage       = $8051  ; did player trigger cage?

    sfx_val_1         = $8052  ; All used in similar looking sfx subs
    sfx_val_2         = $8053  ;
    sfx_val_3         = $8054  ;
    sfx_val_4         = $8055  ;
    sfx_val_5         = $8056  ;
    sfx_val_6         = $8057  ;

    speed_delay_p1    = $805B  ; speed for dino/rocks, start=1f, 10, d, then dec 2...
    speed_delay_p2    = $805C  ; ...until dead. Smaller delay = faster dino/rock fall
    dino_timer        = $805D  ; timer based on SPEED_DELAY (current round)

    bonuses           = $8060  ; How many bonuses collected
    bonus_mult        = $8062  ; Bonus multiplier.

    splash_anim_fr    = $8064  ; cycles 0-2 maybe... splash anim counter
    sfx_prev          = $8065  ; prevent retrigger effect?
    ch1_cur_id        = $8066  ; sfx id (?) OE when alive, 02 when dead etc
    ch2_cur_id        = $8067  ;
    ch3_cur_id        = $8068  ;

    extra_got_p1      = $8070  ; P1 Earned extra life
    extra_got_p2      = $8071  ; P2 Earned extra life

    hiscore_timer     = $8075  ; Countdown for entering time in hiscore screen
    hiscore_timer2    = $8076  ; 16 counter for countdown


    ;; Bunch of unused/debugs/tmps?
    _8080             = $8080  ; set to 3 in unused sub, never read
    _8086             = $8086  ; set in hiscore, never read
    _8090             = $8090  ; set to 1, never read?
    _8093             = $8093  ; set to $20 in coinage... hiscore, cursor?
    _8094             = $8094  ; unused? used with 8093
    _80FF             = $80FF  ; cleared at start (HARD_RESET)

    screen_xoff_col   = $8100  ; OFFSET and COL for each row of tiles
                               ; 40 bytes, Gets memcpy'd to $9800

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
    synthy_um_1       = $82A5  ; ?
    synth2            = $82A8  ; bunch of bytes for sfx
    synthy_um_2       = $82AD  ; no idea. Read once... written where?
    synth3            = $82B0  ; bunch of bytes for sfx
    synthy_um_3       = $82B5  ; ?
    synth1_um_b       = $82B8  ; ?
    synth2_um_b       = $82D0  ; ?
    synth3_um_b       = $82E8  ; ?

    hiscore           = $8300  ;
    hiscore_1         = $8301  ;
    hiscore_2         = $8302

    credits           = $8303  ; how many credits in machine
    coinage_2         = $8305  ; Coins? dunno
    coinage           = $8306  ; dunno what "coinage" is really.
    hiscore_name      = $8307  ; - $8310: Start of HI-SCORE text message area (10 bytes)

    tick_num          = $8312  ; adds 1 every tick
    ;; NOTE: TICK_MOD is sped up after round 1!
    tick_mod_fast     = $8315  ; % 3 in round 1, % 2 in round 2+
    tick_mod_slow     = $8316  ; % 6 in round 1, % 4 in round 2+. (offset by 1 from $8001)

    stack_location    = $83F0  ; I think?
    input_buttons     = $83F1  ; copied to 800C and 800D
    input_buttons_2   = $83F2  ; dunno what buttons


;;; ============ Bongo World Map  =============
;;;
;;;  1:  n_n  n_n  nTn  n_n   /   W
;;;  7:   \   n_n  nTn   /    W
;;; 12:   \   n_n  nTn  n_n   S
;;; 17:   \   n_n   S    \   S_S
;;; 22:   W    \   S_S
;;; 25:   W    \    S
;;;


;;;  constants

    ;; 16bit signed sub constants
    JMP_HL_OFFSET     = $4000
    MINUS_95          = $FFA1
    MINUS_64          = $FFC0
    MINUS_36          = $FFDC
    scr_line_prev     = $FFE0       ; -32 = previous screen line

    ;; 8bit constants
    screen_width      = $E0 ; 224
    scr_tile_w        = $1A ; 26 columns (just playable? TW=27.)
    scr_tile_h        = $1C ; 28 rows    (only playable area? TH=31.)
    num_screens       = $1B ; 27 screens

    round1_speed      = $1F
    round2_speed      = $10
    round3_speed      = $0D

    fr_rock_1         = $1D
    fr_spear          = $22
    fr_bird_1         = $23
    fr_bird_2         = $24
    fr_blue_1         = $34
    fr_blue_2         = $35

    ;; ========= 256 Tiles GFX ==========

    ;; first sixteen tiles are 0-9,A-F : Hex, lol!
    tile_0            = $00
    tile_F            = $0F

    tile_blank        = $10

    ;; Alphabet tile indexes
    __                = $10
    A_                = $11
    B_                = $12
    C_                = $13
    D_                = $14
    E_                = $15
    F_                = $16
    G_                = $17
    H_                = $18
    I_                = $19
    J_                = $1A
    K_                = $1B
    L_                = $1C
    M_                = $1D
    N_                = $1E
    O_                = $1F
    P_                = $20
    Q_                = $21
    R_                = $22
    S_                = $23
    T_                = $24
    U_                = $25
    V_                = $26
    W_                = $27
    X_                = $28
    Y_                = $29
    Z_                = $2A

    tile_hyphen       = $2B
    tile_sq_open      = $2C
    tile_sq_red       = $2D
    tile_sq_green     = $2E
    tile_sq_white     = $2F

    tile_circ_red     = $51
    tile_circ_green   = $52
    tile_circ_white   = $53

    tile_cage         = $74 ; - $7f
    tile_cursor       = $89 ; "up" arrow
    tile_lives        = $8A
    tile_copy         = $8B ; copyright

    tile_pik_crowna   = $8C ; pickups alt
    tile_pik_crossa   = $8D
    tile_pik_ringa    = $8E
    tile_pik_vasea    = $8F

    tile_lil_0        = $90 ; "bonus" figures
    tile_lil_1        = $91 ;
    tile_lil_2        = $92 ;
    tile_lil_3        = $93 ;
    tile_lil_4        = $94 ;
    tile_lil_5        = $95 ;
    tile_lil_6        = $96 ;
    tile_lil_7        = $97 ;
    tile_lil_8        = $98 ;
    tile_lil_9        = $99 ;
    tile_lil_10       = $9A ;
    tile_lil_00       = $9B ; thousands 00

    tile_pik_crown    = $9C ; pickups
    tile_pik_cross    = $9D
    tile_pik_ring     = $9E
    tile_pik_vase     = $9F

    tile_logo_st      = $A0 ; awesome BONGO logo
    tile_logo_end     = $B3

    tile_lvl_01       = $C0 ; current level markers
    tile_lvl_26       = $D9
    tile_lvl_cage     = $DA ; lil cage icon
    tile_lvl_done     = $DB ; mask out completed level

    tile_bonus_blank  = $E5

    tile_bonus_10_tl  = $E8 ; uncovered bonus score. top of 10
    tile_bonus_10_bl  = $E9 ; bottom of 10
    tile_bonus_00_tl  = $EA ; top-left of 00
    tile_bonus_00_bl  = $EB ; bottom-left of 00
    tile_bonus_20_tl  = $EC ; top-left of 20
    tile_bonus_20_bl  = $ED ; bottom-left of 20
    tile_bonus_30_tl  = $EE ; top-left of 30
    tile_bonus_30_bl  = $EF ; bottom-left of 30
    tile_bonus_40_tl  = $F0 ; top-left of 40
    tile_bonus_40_bl  = $F1 ; bottom-left of 40
    tile_bonus_00_tr  = $F2 ; top-right of 00
    tile_bonus_00_br  = $F3 ; bottom-right of 00

    ;; tile > $F8 is a platform
    tile_solid        = $F8 ; high-wire platform R
    tile_platform_r   = $FC
    tile_platform_c   = $FD
    tile_platform_l   = $FE

;;; hardware locations

    ;; =============== Video RAM: background tiles ==============

    ;; Background tiles layout is top-to-bottom, right-to-left (!).
    ;; The first visible tile at the top-right at $9040. The next tile
    ;; ($9041) is directly BELOW that. At $9040+$20 (32 tiles later) it
    ;; wraps to the previous column, until $93BF in the bottom left.

    screen_ram        = $9000 ; - 0x93ff  videoram
    start_of_tiles    = $9040 ; top-right tile

    ;; screen tile locations
    p2_score_digits   = $9061 ; score for player 2
    p2_timer_digits   = $9082 ; timer for player 1
    _908E             = $908E ; something in hiscore screen
    scr_hi_under_X    = $9090 ; hiscore screen, under X (wrap point)
    _9092             = $9092 ; something in hiscore screen
    scr_pik_r_W       = $90CB ; "W" highwire pickup, right
    _911A             = $911A ; pickup
    scr_lives_p2      = $9122 ; icons for lives, p2
    scr_pik_n_n       = $915A ; pickup right "n_n" levels
    _9184             = $9184 ; something in hiscore screen
    scr_cage_up       = $9189 ; top-right tile of cage at top of screen
    _918E             = $918E ; pickup
    scr_num_creds     = $9199
    scr_hiscore       = $91A1 ; trailing 0 of hiscore
    _91B1             = $91B1 ; pickup
    _91C9             = $91C9 ; cage location?
    _91D2             = $91D2 ; pickup
    _9217             = $9217 ; pickup
    scr_attract_cage  = $9224 ;
    _922B             = $922B ; pickup
    _9231             = $9231 ; pickup
    scr_bongo_logo    = $9248
    scr_hi_name_entry = $9277 ; as you enter your name
    _927A             = $927A ; pickup
    scr_hi_name       = $9280 ; hiscore name
    _92AB             = $92AB ; pickup
    scr_lives_p1      = $92C2 ; first "life" icon for p1
    scr_lvl_bg_start  = $92E0 ; pos (6,0): first tile in level background
    p1_score_digits   = $92E1
    scr_pik_S_top     = $92EE ; top-left pickup for "S" levels
    p1_timer_digits   = $9302
    attract_piks      = $9308 ; pickup location in attract screen
    scr_bonus_sq      = $934B ; top-right red square over bonus number
    scr_cursor_line_hs= $934E ; under the letters in hiscore entry
    scr_hs_timer      = $9362 ; second digit of 90 second timer in hiscore
    scr_unused_spiral = $93A0 ; the spiral transition routine

    end_of_tiles      = $93BF ; bottom left tile

    ;; $9400-$97FF seems to be mirrored to the first screen ($9000-$93FF).
    ;; Change a value in one, it's reflected instantly in the other

    xoff_col_ram      = $9800 ; xoffset and color data per tile row (attributes)
    sprites           = $9840 ; 0x9840 - 0x98ff is spriteram
    port_in0          = $A000 ;
    port_in1          = $A800 ;
    port_in2          = $B000 ;
    int_enable        = $B001 ; interrupt enable
    _B004             = $B004 ; "galaxian stars enable"?
    _B006             = $B006 ; set to 1 for P1 or
    _B007             = $B007 ; 0 for P2... why? Controls?
    watchdog          = $B800 ; main timer?
    _C000             = $C000 ;
    _C003             = $C003 ;


;;; ============ START OF BG1.BIN =============

hard_reset:
    and  d
    ld   (int_enable),a
    ld   (_80FF),a
    ld   a,$FF
    ld   (watchdog),a
    jp   clear_ram ; jumps back here after clear
_ret_hard_reset:
    ld   sp,stack_location
    call clear_ram_call_weird_a
    call check_credit_fault
    call write_out_0_and_1
    jp   call_setup_then_start_game


;;; ==========================================

;; Data? unused? If code, looks... odd
    db  $DD,$19        ; (add  ix,de)
unlikely_fn:           ; uncalled "err_um_call_0020" points here
    db  $DD,$19        ; (add  ix,de)
    db  $2B            ; (dec   hl)
    db  $10,$AF        ; (djnz $FFD4 ?)
    db  $ED,$67,$DD,$77
    db  $ED,$6F,$DD,$DD
    db  $19,$ED,$6F,$DD
    dc  7, $FF


;;; ============== reset vector ==============

;;  Reset vector
reset_vector:
    ld   a,(watchdog)
    jr   reset_vector

    dc 11, $FF

;;; ==========================================

;;; Called once at startup
;;; No idea what a "credit fault" is,
;;; but must be hardware issue?
check_credit_fault:
    ld   a,(port_in0)
    and  $83 ; 1000 0011
    ret  z
    call reset_xoff_sprites_and_clear_screen
    call draw_tiles_h
    db   $09, $00 ; CREDIT FAULT
    db   C_,R_,E_,D_,I_,T_,__,F_,A_,U_,L_,T_,$FF
    jr   check_credit_fault     ; loop!

    db   $FF

;;; =============== NMI Loop =================

;; Non-Maskable Interrupt handler. Fires every frame
nmi_loop:
    xor  a
    ld   (int_enable),a
    ld   a,(watchdog)
    call nmi_int_handler
    ld   a,(num_players)
    and  a
    jr   nz,_is_playing
    call did_player_press_start
_is_playing:
    ld   b,$01
    call tick_ticks ; update ticks...
    call copy_inp_to_buttons_and_check_buttons
    nop
    ld   a,(port_in0)
    bit  1,a
    jp   nz,_C003 ; c003?! Hardware function?
    retn ; NMI return

;;; ==========================================

    db   $FF

call_setup_then_start_game:
    call setup_then_start_game  ; jmps to pre_game_attractions...
    call set_hiscore_text       ; ...never gets here.


;;; ==========================================

reset_then_start_game:          ; also jumps here after game-over
    call wait_vblank
    ld   a,(credits)
    and  a
    jr   nz, play_attract_PRESS_P1P2
    call play_attract_screens
    call reset_xoff_sprites_and_clear_screen
    jr   reset_then_start_game

play_attract_PRESS_P1P2:
    call wait_vblank
    ld   a,(credits)
    cp   $01
    jr   nz,_multiple_credits
    call attract_press_p1_screen ; one credit
    jr   _done__stsg
_multiple_credits:
    call draw_one_or_two_player
_done__stsg:
    ld   a,(num_players)
    and  a
    jp   nz,start_game
    jr   play_attract_PRESS_P1P2

    db   $FF

;;; ==========================================

nmi_int_handler:
    exx
    call coinage_routine
    call copy_xoffs_and_cols_to_screen
    call call_player_all_sfx_chunks
    call copy_ports_to_buttons
    exx
    ret

    db   $FF

;;; ============== PRESS P1 ===============

attract_press_p1_screen:
    ld   a,$01
    ld   (_8090),a
    xor  a
    ld   (_B004),a
    ld   a,(credits)
    ld   b,a
    ld   a,(credits_umm)
    cp   b
    ret  z ; credits == credits_um
    nop
    nop
    nop
    call clear_screen
    ld   hl,header_text_data
    call draw_screen
    db   $00, $00 ; params to DRAW_SCREEN
    call draw_score
    call draw_tiles_h
    db   $09, $0B
    db   P_,R_,E_,S_,S_,$FF ; PRESS
    call draw_tiles_h
    db   $0C, $09
    db   O_,N_,E_,__,P_,L_,A_,Y_,E_,R_,$FF ; ONE PLAYER
    call draw_tiles_h
    db   $0F, $8B
    db   B_,U_,T_,T_,O_,N_,$FF ; BUTTON
    call draw_tiles_h
    db   $19, $09
    db   C_,R_,E_,D_,I_,T_,S_,$FF ; CREDITS
    ld   hl,credits
    xor  a
    rld                         ; roll in num credits
    ld   (scr_num_creds-0*$20),a ; 1's
    rld
    ld   (scr_num_creds-1*$20),a ; 10's
    rld
    ld   a,(credits)
    ld   (credits_umm),a
    ret

    dc   2, $FF

;;
draw_one_or_two_player:
    call _2430
    ld   a,(credits)
    ld   b,a
    ld   a,(credits_umm)
    cp   b
    nop
    call attract_press_p1_screen
    call draw_tiles_h
    db   $0C, $06; ONE OR TWO PLAYER
    db   O_,N_,E_,__,O_,R_,__,T_,W_,O_,__,P_,L_,A_,Y_,E_,R_,$FF
    ret

    dc   9,$FF

;;; Kind of think was just some random bytes left around
err_um_call_0020:
    call unlikely_fn
    ret

    dc   12,$FF

;;; ============= indirect jump: hl + 4k ==============

;;; Jumps to the address in HL + 4k.
;;; (called a lot, mostly via... JMP_HL_PLUS_4K)
;;; But why do this indirect-style jump? Oh! Perhaps the ROM
;;; might have been at different locations (Eg, 8k) on different
;;; hardware - so this is just a single place to change?
do_jmp_hl_plus_4k:
    push bc
    ld   bc,JMP_HL_OFFSET
    add  hl,bc
    pop  bc
    jp   (hl)

    dc   9,$FF

;;; ==========================================

;;; Did player start the game with P1/P2 button?
did_player_press_start:
    ld   a,(credits) ; check you have credits
    and  a
    ret  z
    ld   a,(input_buttons) ; P1 pressed?
    bit  0,a
    jr   z,_P2__dpps
    call clear_ram_x83_bytes
    ld   a,$01 ; start the game, 1 player
    ld   (num_players),a
    ld   a,(credits) ; use a credit
    dec  a
    daa
    ld   (credits),a
    ret
_P2__dpps:
    ld   a,(credits)
    dec  a
    ret  z
    ld   a,(input_buttons)
    bit  1,a ; is P2 pressed?
    ret  z
    call clear_ram_x83_bytes
    ld   a,$02 ; start the game, 2 player
    ld   (num_players),a
    ld   a,(credits)
    dec  a
    daa
    dec  a
    daa
    ld   (credits),a
    ret

    dc   5,$FF

;;; ==========================================

copy_ports_to_buttons:
    ld   a,(port_in0)
    ld   (controls),a
    ld   a,(input_buttons)
    ld   (buttons_1),a
    ld   a,(input_buttons_2)
    ld   (buttons_2),a
    ret

;;; ==========================================

;;; Indirect indirect jump to HL+4K
;;; Calls the sub that jumps to the location in (HL)+OFFSET
;;; But why all the inderection? Perphas do_jmp_hl_plus_4k location
;;; varied during development, and THIS sub was all they could
;;; rely on to be fixed address?
jmp_hl_plus_4k:
    jp   do_jmp_hl_plus_4k
    ret

;;; ===================== start game =====================

start_game:
    ld   a,$1F
    ld   (speed_delay_p1),a
    ld   (speed_delay_p2),a
    nop
    ld   a,(input_buttons_2) ; "num lives" from dip-switch settings
    and  0110b
    sra  a
    add  a,$02
    ld   (lives),a              ; set beginning lives
    ld   (lives_p2),a
    ld   a,(num_players)
    dec  a
    ld   (is_2_players),a ; 0 = 1P, 1 = 2P
    ld   a,$01
    ld   (player_num),a
    ld   a,(is_2_players)
    and  a
    jr   nz,_is_2P
    xor  a                      ; 1P only, zero p2 lives
    ld   (lives_p2),a
_is_2P:
    ld   a,$01                  ; set initial screen number
    ld   (screen_num),a
    ld   (screen_num_p2),a
    ld   (_8090),a
    ;; ... drops through ...

post_death_reset:
    ld   sp,stack_location ; hmm. sets stack pointer?
    ld   a,(player_num)
    xor  $01
    ld   (player_num),a
    ld   hl,lives
    add  a,l
    ld   l,a
    ld   a,(hl)
    and  a
    jr   nz,_more_lives         ; out of lives yet?
    ld   a,(player_num)
    xor  $01
    ld   (player_num),a
    ld   hl,lives
    add  a,l
    ld   l,a
    ld   a,(hl)
    and  a
    jp   z,game_over            ; yep, game over

_more_lives:                    ; some dip-switch shenanigans
    dec  a
    ld   (hl),a
    ld   a,(input_buttons)
    bit  7,a ; what is this "button"?!
    jr   z,_0260
    ld   a,(player_num)
    cp   $01
    jr   nz,_0260
    ld   a,$01
    ld   (_B006),a ; a = 1 if P1,
    ld   (_B007),a
    jr   _0267
_0260:
    xor  a ; 0 if P2
    ld   (_B006),a
    ld   (_B007),a
_0267:
    ld   a,(input_buttons_2)
    bit  3,a ; Infinite Lives DIP setting? resets lives on death
    jr   z,_done__ml
    ld   a,$03 ; set 3 lives
    ld   (lives),a
    ld   a,(lives_p2)
    and  a
    jr   z,_done__ml
    ld   a,$03
    ld   (lives_p2),a
_done__ml:
    jp   big_reset              ; reset the for next life

    dc   7, $FF


;;; ==========================================

coinage_routine:
    ld   a,(coinage)
    and  a
    jr   z,_029F
    dec  a
    ld   (coinage),a
    ret  nz
    ld   a,(port_in0)
    and  $03
    ret  z
    ld   a,$05
    ld   (coinage),a
    ret
_029F:
    ld   a,(port_in0)
    and  $03
    ret  z
    ld   b,a
    ld   a,$20
    ld   (_8093),a
    ld   a,b
    cp   $01
    jr   nz,_02B9
    ld   a,(coinage_2)
    inc  a
    ld   (coinage_2),a
    jr   _02C1
_02B9:
    ld   a,(coinage_2)
    add  a,$06
    ld   (coinage_2),a
_02C1:
    ld   a,$07
    ld   (coinage),a
    ld   a,(input_buttons)
    bit  6,a ; added credit
    jr   z,_02E3
    ld   a,(coinage_2)
    and  a
    ret  z
    ld   b,a
    ld   a,(credits)
_02D6:
    inc  a
    daa
    dec  b
    jr   nz,_02D6
    ld   (credits),a
    xor  a
    ld   (coinage_2),a
    ret
_02E3:
    ld   a,(coinage_2)
    and  a
    ret  z
    cp   $01
    ret  z
    ld   b,a
    ld   a,(credits)
_02EF:
    inc  a
    daa
    dec  b
    jr   z,_02F9
    dec  b
    jr   z,_0304
    jr   _02EF
_02F9:
    dec  a
    daa
    ld   (credits),a
    ld   a,$01
    ld   (coinage_2),a
    ret
_0304:
    ld   (credits),a
    xor  a
    ld   (coinage_2),a
    ret

    dc   4, $FF


;;; ============= Draw Tiles Horizontally ==============

;;; Draw sequence of tiles horizontally at (y, x)
;;; Data for the draw is located AFTER the call to this function
draw_tiles_h:
    ld   a,(watchdog)
    ld   hl,start_of_tiles
    pop  bc
    ld   a,(bc) ; y pos
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc) ; x pos
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
_loop__032E:
    ld   a,(bc) ; read data until 0xff
    inc  bc
    cp   $FF
    jr   nz,_next_tile
    push bc
    ret
_next_tile:
    ld   (hl),a
    ld   d,$FF
    ld   e,$E0
    add  hl,de ; $FFE0 = -32 (one column)
    jr   _loop__032E

    dc   10, $FF

;;; ============== setup, then start =====================

;; Clears RAM, sets the stack location
setup_then_start_game:
    nop                         ; I love seeing all the nops around
    nop                         ; feel very "hand made"... but I do
    nop                         ; wonder what they nopped!
    call reset_xoff_sprites_and_clear_screen
    ld   hl,START_OF_RAM ; reset $8000-$8088 to 0
_lp_0351:
    ld   (hl),$00
    inc  l
    jr   nz,_lp_0351
    inc  h
    ld   a,(watchdog)
    ld   a,h
    cp   $88
    jr   nz,_lp_0351
    ld   sp,stack_location
    ld   a,$01
    ld   (_8090),a
    jp   pre_game_attractions

    dc   6, $FF

;;; ================ attract screens =================

;;; Plays a sequence of attract screens
;;; - Bongo splash screen animation
;;; - EXTRA BONUS screen
;;; - YOUR BEING CHASED screen
play_attract_screens:
    call reset_xoff_sprites_and_clear_screen
    ld   hl,reset_sfx_something_1 - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ld   hl,attract_splash_bongo - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ld   hl,call_draw_extra_bonus_screen - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ld   hl,chased_by_a_dino_screen - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    nop      ; tantalizing nops...
    nop      ; were there more attract screens?
    nop
    ret

    db   $FF


;;; ==========================================

;;; Don't think it's called?
infinte_vblanks:
    call wait_vblank
    jr   infinte_vblanks

    dc   11, $FF

;;; ================ draw lives ====================

;;; Draw icons for the number of lives remaining
draw_lives:
    call set_lives_row_color
    ld   a,(lives)
    and  a
    ld   b,a
    ld   a,tile_lives
    jr   z,_done_p1_lives
    dec  b
    ld   (scr_lives_p1-0*$20),a
    jr   z,_done_p1_lives
    dec  b
    ld   (scr_lives_p1-1*$20),a
    jr   z,_done_p1_lives
    dec  b
    ld   (scr_lives_p1-2*$20),a
    jr   z,_done_p1_lives
    dec  b
    ld   (scr_lives_p1-3*$20),a
    jr   z,_done_p1_lives
    ld   (scr_lives_p1-4*$20),a
_done_p1_lives:
    ld   a,(lives_p2)
    and  a
    ld   b,a
    ret  z
    ld   a,tile_lives
    dec  b
    ld   (scr_lives_p2+0*$20),a
    ret  z
    dec  b
    ld   (scr_lives_p2+1*$20),a
    ret  z
    dec  b
    ld   (scr_lives_p2+2*$20),a
    ret  z
    dec  b
    ld   (scr_lives_p2+3*$20),a
    ret  z
    ld   (scr_lives_p2+4*$20),a
    ret

    db   $FF

;;; ==========================================

clear_after_game_over:
    xor  a
    ld   (num_players),a
    ld   (credits_umm),a
    jp   reset_then_start_game

    dc   6, $FF

    ld   c,$E0
_loop__vb:
    call wait_vblank
    inc  c
    jr   nz,_loop__vb
    ret

    dc  7, $FF


;;; ==========================================

set_lives_row_color:
    ld   a,$01
    ld   (screen_xoff_col+5),a  ; 3rd row
    ret

    dc   2, $FF


;;; ================ GAME OVER  ================

game_over:
    ld   hl,sfx_reset_a_bunch - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    call delay_60_vblanks
    call check_if_hiscore
    call reset_xoff_sprites_and_clear_screen
    xor  a
    ld   (_B004),a
    jp   set_hiscore_and_reset_game

    dc   10, $FF

;;; ==========================================

check_if_hiscore:
    call _check_if_hiscore_p1
    call _check_if_hiscore_p2
    ret

    dc   9, $FF

_check_if_hiscore_p1:
    ld   a,(p1_score_2)
    ld   c,a
    ld   a,(hiscore_2)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p1
    ret  nz
    ld   a,(p1_score_1)
    ld   c,a
    ld   a,(hiscore_1)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p1
    ret  nz
    ld   a,(p1_score)
    ld   c,a
    ld   a,(hiscore)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p1
    ret

    dc   6, $FF

_check_if_hiscore_p2:
    ld   a,(p2_score_2)
    ld   c,a
    ld   a,(hiscore_2)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p2
    ret  nz
    ld   a,(p2_score_1)
    ld   c,a
    ld   a,(hiscore_1)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p2
    ret  nz
    ld   a,(p2_score)
    ld   c,a
    ld   a,(hiscore)
    scf
    ccf
    sbc  a,c
    call c,hiscore_for_p2
    ret

    dc   22, $FF

    ld   c,$01
_04B2:
    call wait_vblank
    dec  c
    jr   nz,_04B2
    ret

    dc   1, $FF


;;; ============ dino timer ==============

;; count up timer - every SPEED_DELAY ticks
check_dino_timer:
    call move_dino_x
    ld   a,(player_num)
    and  a
    jr   nz,_04C8
    ld   a,(speed_delay_p1)
    jr   _04CB
_04C8:
    ld   a,(speed_delay_p2)
_04CB:
    ld   b,a
    ld   a,(dino_timer)
    inc  a
    cp   b ; have done SPEED_DELAY ticks?
    jr   nz,_04D4
    xor  a
_04D4:
    ld   (dino_timer),a
    and  a
    ret  nz
    call dino_pathfind_nopslide
    ret

    dc   3, $FF

;;; ==========================================

hiscore_for_p1:
    ld   a,(p1_score)
    ld   (hiscore),a
    ld   a,(p1_score_1)
    ld   (hiscore_1),a
    ld   a,(p1_score_2)
    ld   (hiscore_2),a
    pop  hl ; hmm
    ret

    dc   12, $FF

hiscore_for_p2:
    ld   a,(p2_score)
    ld   (hiscore),a
    ld   a,(p2_score_1)
    ld   (hiscore_1),a
    ld   a,(p2_score_2)
    ld   (hiscore_2),a
    pop  hl ; hmm
    ret

    dc   4, $FF

;;; ==========================================

;; who calls?
;; This looks suspicious. 25 bytes written
;; to $8038+, code is never called (or read?)
;; wpset 0518,18,rw doesn't trigger
    ld   hl,enemy_1_timer
    ld   (hl),$39 ; 57
    inc  hl
    ld   (hl),$39 ; enemy_2_active
    inc  hl
    ld   (hl),$39 ; enemy_2_timer
    inc  hl
    ld   (hl),$39 ; enemy_3_active
    inc  hl
    ld   (hl),$38
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl
    ld   (hl),$39
    inc  hl ; 8040
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
    call clear_jump_button
    ret

    dc   23, $FF


;;; ==========================================

setup_uncalled: ;looks a lot like call_setup_then_start_game
    call setup_then_start_game  ; but it return to below
                                ; (and and is called at init)

;;; ============ pre-game screens ================

;;; Handle attract mode and credit screens before
;;; player has started
pre_game_attractions:          ; jumps here after setup
    call set_hiscore_text

_loop__smp:
    call wait_vblank
    ld   a,(num_players)
    and  a
    jr   nz,_is_playing__smp
    ld   a,(credits)
    and  a
    jr   nz,_has_credits

    call play_attract_screens ;
    call reset_xoff_sprites_and_clear_screen
    jr   _loop__smp

_has_credits:
    cp   $01
    jr   nz,_2P
    call attract_press_p1_screen
    jr   _loop__smp
_2P:
    call draw_one_or_two_player
    jr   _loop__smp
_is_playing__smp:
    jp   nz,start_game
    jr   _loop__smp

    dc   8, $FF

;;; ==========================================

;;; who calls?
    ld   a,(credits)
    and  a
    jr   nz,_05C2
    call wait_vblank
    ret
_05C2:
    call wait_vblank
    pop  hl
    pop  hl
    pop  hl
    ret

    dc   7, $FF

;;; ==========================================

;;; Not really sure what this does - seems to
;;; take the hardware input and copy to variables

normalize_input:
    ld   a,(player_num)
    and  a
    jr   z,_05ED
;; p2
    ld   a,(buttons_1)
    bit  7,a
    jr   z,_05ED ; p1 too?
    ld   a,(buttons_1)
    and  $3C ; 0011 1100
    ld   b,a
    ld   a,(controls)
    and  $40 ; 0100 0000
    add  a,b
    ld   (controlsn),a
    ret
;; p1
_05ED:
    ld   a,(controls)
    and  $3C ; 0011 1100
    ld   b,a
    ld   a,(controls)
    and  $80 ; 1000 0000
    srl  a
    add  a,b
    ld   (controlsn),a
    ret

    dc   9, $FF

;;; ==========================================

player_frame_data_walk_right:
    db   $0C,$0E,$10,$0E,$0C,$12,$14,$12
    dc   8, $FF

;;; ==========================================

player_move_right:
    ld   a,(walk_anim_timer)
    inc  a
    and  $07 ; 0111
    ld   (walk_anim_timer),a
    ld   hl,player_frame_data_walk_right
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (player_frame),a
    inc  a
    ld   (player_frame_legs),a
    ld   a,(player_x)
    inc  a ; move right 3px.
    inc  a
    inc  a
    ld   (player_x),a
    ld   (player_x_legs),a
    nop
    nop
    nop
    ret

    dc   10, $FF

player_frame_data_walk_left:
    db   $8C,$8E,$90,$8E,$8C,$92,$94,$92
    dc   8, $FF

player_move_left:
    ld   a,(walk_anim_timer)
    inc  a
    and  $07
    ld   (walk_anim_timer),a
    ld   hl,player_frame_data_walk_left
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (player_frame),a
    inc  a
    ld   (player_frame_legs),a
    ld   a,(player_x)
    dec  a ; move left 3px
    dec  a
    dec  a
    ld   (player_x),a
    ld   (player_x_legs),a
    nop
    nop
    nop
    ret

    dc   10, $FF

;;; ================ Player input ================

player_input:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(player_died)
    and  a
    ret  nz ; dead, get out
    ld   a,(jump_tbl_idx)
    and  a
    ret  nz ; don't do this input if jumping?
    ld   a,(controlsn)
    bit  5,a ; jump pressed? 0010 0000
    jr   z,_no_jump
    call set_unused_804a_49
    bit  2,a ; not left? 0000 0100
    jr   z,_06AA
    call trigger_jump_right
    ret
_06AA:
    bit  3,a ; not right?
    jr   z,_06B2
    call trigger_jump_left
    ret
_06B2:
    call trigger_jump_straight_up
    ret
;; no jump: left/right?
_no_jump:
    bit  2,a ; is left?
    jr   z,_06BE
    call player_move_left
    ret
_06BE:
    bit  3,a ; is right?
    jr   z,_06C6
    call player_move_right
    ret
;; looks like bit 4 and 6 aren't used (up/dpwn?)
_06C6:
    bit  4,a ; ?
    jr   z,_06CE
    nop
    nop
    nop
    ret
;; bit 6?
_06CE:
    bit  6,a
    ret  z
    nop
    nop
    nop
    ret

    dc   3, $FF

;;; ============== Player Physics ===================

;; "Physics": do jumps according to jump lookup tables
player_physics:
    dc   5, 0                   ; some nops
    ld   a,(jump_tbl_idx)
    dec  a ; idx - 1
    ld   (jump_tbl_idx),a
    sla  a ; * 2
    sla  a ; * 2 = 4th byte in table row
    add  a,l
    ld   l,a
    ld   ix,player_x
    ld   a,(hl) ; reads from the PHYS_JUMP_LOOKUP_XXX tables
    add  a,(ix+$00) ; player x
    ld   (ix+$00),a ; player x
    ld   (ix+$04),a ; player_x_legs
    inc  hl
    ld   a,(hl)
    ld   (ix+$01),a ; frame
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a ; legs frame
    inc  hl
    ld   a,(hl)
    add  a,(ix+$07) ; player y legs?
    ld   (ix+$07),a
    sub  $10
    ld   (ix+$03),a ; player y
    ret


;;; ==========================================

;;; jump pressed, sets these... why?
;;; 804a and 8049 never read?
;;; wpset 804a,1,r never triggers?
set_unused_804a_49:
    push af
    ld   a,$A0
    ld   (_804A),a
    ld   a,$0F
    ld   (_8049),a
    pop  af
    ret

    dc   3, $FF
    db   $8C,$10 ; rando two bytes (addr?)
    dc   6, $FF

;; x-off, head-anim, leg-anim, yoff
phys_jump_lookup_left:
    db   $FA,$8C,$8D,$0C
    db   $FA,$8E,$8F,$0C
    db   $FA,$90,$91,$06
    db   $FA,$90,$96,$00
    db   $FA,$90,$91,$FA
    db   $FA,$8E,$8F,$F4
    db   $FA,$8C,$8D,$F4

    dc   12, $FF

;; x-off, head-anim, leg-anim, yoff
phys_jump_lookup_right:
    db   $06,$0C,$0D,$0C
    db   $06,$0E,$0F,$0C
    db   $06,$10,$11,$06
    db   $06,$10,$16,$00
    db   $06,$10,$11,$FA
    db   $06,$0E,$0F,$F4
    db   $06,$0C,$0D,$F4

    dc   8, $FF

;; only runs every "tick_mod_slow" frames
apply_jump_physics:
    ld   a,(tick_mod_slow) ; speeds up after round 1
    and  $07
    ret  nz
    ld   a,(player_died)
    and  a
    ret  nz ; dead, get out
    ld   a,(jump_tbl_idx) ; return if not mid jump tbl
    and  a
    ret  z
    ld   a,$01
    ld   (jump_triggered),a ; jump was triggererd
;; set the correct jump lookup table based on left, right, or none.
    ld   a,(controlsn)
    bit  2,a ; not left?
    jr   z,_0797
    ld   hl,phys_jump_lookup_left
    call player_physics
    ret
_0797:
    jp   phys_jump_set_right_or_up_lookup

    dc   6, $FF

;;; jump button, but not jumping, and on ground, right
trigger_jump_right:
    ld   a,(jump_triggered) ; already jumping, leave
    and  a
    ret  nz
    ld   a,(jump_tbl_idx) ; already jumping, leave
    and  a
    ret  nz
    call ground_check
    and  a
    ret  z
    ld   a,$07
    ld   (jump_tbl_idx),a
    ld   a,$8C
    ld   (player_frame),a
    ld   a,$8D
    jp   play_jump_sfx
    ret

    dc   1, $FF

;;; jump button, but not jumping, and on ground, left
trigger_jump_left:
    ld   a,(jump_triggered) ; already jumping, leave
    and  a
    ret  nz
    ld   a,(jump_tbl_idx) ; already jumping, leave
    and  a
    ret  nz
    call ground_check
    and  a
    ret  z
    ld   a,$07
    ld   (jump_tbl_idx),a
    ld   a,$0C
    ld   (player_frame),a
    ld   a,$0D
    jp   play_jump_sfx
    ret

    dc   1, $FF

;; Right or no direction checkt
phys_jump_set_right_or_up_lookup:
    bit  3,a ; right?
    jr   z,_07EB
    ld   hl,phys_jump_lookup_right
    call player_physics
    ret
_07EB:
    ld   hl,phys_jump_lookup_up ; not left or right?
    call player_physics
    ret

    dc   2, $FF

play_jump_sfx:
    ld   (player_frame_legs),a
    ld   a,$04 ; jump sfx
    ld   (ch2_sfx),a
    ret

    dc   3, $FF


;;; ==========================================

;; who calls? (free bytes)
;; this looks similar to other DRAW_TILES code, but tile data
;; is indirectly fetched via (bc) addresses.
;; I set a breakpoint here and played a bunch (even cutscene)
;; but could not get it to trigger... not used? debug?
draw_tile_unused:
    ld   bc,hard_reset
    nop
    nop
    nop
    nop
    db   $01,$3A,$00
    cp   b ; really?
;;
    ld   hl,start_of_tiles
    pop  bc ; stack return pointer into bc (ie, data)
    ld   a,(bc) ; start_y
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc) ; start_x
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
    ld   a,(bc) ; addr hi byte
    ld   e,a
    inc  bc
    ld   a,(bc) ; addr lo byte
    ld   d,a
    inc  bc
    push bc
_next_tile__082D:
    ld   a,(de)
    cp   $FF ; $FF delimited
    ret  z
    inc  de
    ld   (hl),a
    ld   b,$FF
    ld   c,$E0 ; Subtract 32 (one column)
    add  hl,bc
    jr   _next_tile__082D

    dc   6, $FF

;;; ================ Draw Screen ===================
    ;;
draw_screen:
    push hl
    exx
    pop  hl
    ld   d,h ; de = hl
    ld   e,l
    ld   hl,start_of_tiles
    pop  bc
    ld   a,(bc) ; param 1
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc) ; param 2
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
    pop  de ; ret ptr
    ld   ix,_802c
    ld   (ix+$00),$20
_lp_086B:
    ld   a,(de) ; ret
    ld   (hl),a
    inc  de ; ret + 1
    ld   bc,scr_line_prev
    dec  (ix+$00)
    xor  a
    cp   (ix+$00)
    jr   z,_done_0880
    add  hl,bc
    ld   a,(watchdog)
    jr   _lp_086B
_done_0880:
    exx
    ret

    dc   6, $FF

;;; ==========================================

clear_jump_button:
    ld   a,(controlsn)
    bit  5,a ; jump
    ret  nz
    xor  a
    ld   (jump_triggered),a
    ret

    dc   5, $FF

;;; ==========================================

init_player_sprite:
    ld   hl,player_x
    ld   (hl),$10 ; x
    inc  hl
    ld   (hl),$0C ; frame
    inc  hl
    ld   (hl),$12 ; color
    inc  hl
    ld   (hl),$CE ; y
    inc  hl
    ld   (hl),$10 ; x legs
    inc  hl
    ld   (hl),$0D ; frame legs
    inc  hl
    ld   (hl),$12 ; color legs
    inc  hl
    ld   (hl),$DE ; y legs
    call init_player_pos_for_screen
    ret

    dc   10, $FF

trigger_jump_straight_up:
    ld   a,(jump_triggered)
    and  a
    ret  nz
    ld   a,(jump_tbl_idx)
    and  a
    ret  nz
    call ground_check
    and  a
    ret  z
    ld   a,$07
    ld   (jump_tbl_idx),a
    ld   a,$17
    ld   (player_frame),a
    jp   face_backwards_and_play_jump_sfx

    dc   12, $FF

;;; ==========================================

move_bongo_right:
    ld   a,(tick_num)
    and  $07
    jr   nz,_0904
    ld   a,(bongo_anim_timer)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   (bongo_anim_timer),a
    ld   hl,bongo_lookup3
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (bongo_frame),a
_0904:
    ld   a,(tick_num)
    and  $01
    ret  nz
    ld   a,(bongo_x)
    inc  a
    ld   (bongo_x),a
    ret

    dc   6, $FF

bongo_lookup3:
    db   $29,$2A,$2B,$2A,$FF,$FF,$FF,$FF
_0920:
    db   $A9,$AA,$AB,$AA,$FF,$FF,$FF,$FF

    dc   8, $FF

;;; ==========================================

face_backwards_and_play_jump_sfx:
    ld   a,$18
    ld   (player_frame_legs),a
    ld   a,$04
    ld   (ch2_sfx),a
    ret

    dc   13, $FF

;; jumping straight up
;; x-off, head-anim, leg-anim, yoff
phys_jump_lookup_up:
    db   $00,$17,$18,$0C
    db   $00,$19,$1A,$0C
    db   $00,$1B,$1C,$06
    db   $00,$9B,$9C,$00
    db   $00,$99,$9A,$FA  ; -6
    db   $00,$97,$98,$F4  ; -12
    db   $00,$17,$18,$F4  ; -12

    dc   4, $FF


;;; =========== get tile from x/y ==============

;; Get tile from x/y
;; in: h = x, l = y
;; out: hl = screen addr of tile
get_tile_addr_from_xy:
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

    dc   8, $FF

;;; ============== ground check ==================

ground_check:
    ld   a,(player_y_legs)
    add  a,$10 ; +  16   : the ground
    srl  a ; /  2
    srl  a ; /  2
    and  $FE ; &  1111 1110
    ld   hl,screen_xoff_col
    add  a,l
    ld   l,a
    ld   a,(player_x_legs)
    sub  (hl)
    add  a,$08 ; offset of 8
    ld   h,a
    ld   a,(player_y_legs)
    add  a,$10
    ld   l,a
    call get_tile_addr_from_xy

    ld   a,(hl)
    and  tile_solid
    cp   tile_solid
    jr   z,_09B1
    xor  a ; walkable tile
    ret
_09B1:
    ld   a,$01 ; solid tile
    ret

    dc   12, $FF

;;; ==========================================

check_if_landed_on_ground:      ; only when big fall?
    ld   a,(player_died)
    and  a
    ret  nz ; dead, get out
    ld   a,(jump_tbl_idx)
    and  a
    jr   z,_jump_tble_idx_0
    and  $0C ; 1100 (only last 3 entries are falling)
    ret  nz ; not falling, leave
    call ground_check
    and  a
    ret  z ; ret if in air?
    xor  a ; clear jump_tbl_idx
    ld   (jump_tbl_idx),a
    ld   a,(player_frame)
    and  $80 ; set/clear face-left bit
    add  a,$0C ; reset to first frame
    ld   (player_frame),a
    inc  a
    ld   (player_frame_legs),a
    ret
_jump_tble_idx_0:
    call ground_check
    and  a
    jr   nz,_on_ground
    ld   a,(falling_timer)
    and  a
    ret  nz
    ld   a,$10 ; start falling timer
    ld   (falling_timer),a
    ret
_on_ground:
    xor  a ; reset
    ld   (falling_timer),a
    call snap_y_to_8
    ret

    dc   9, $FF

;;; ==========================================

move_bongo_left:
    ld   a,(tick_num)
    and  $07
    jr   nz,_0A24
    ld   a,(bongo_anim_timer)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   (bongo_anim_timer),a
    ld   hl,_0920
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (bongo_frame),a
_0A24:
    ld   a,(tick_num)
    and  $01
    ret  nz
    ld   a,(bongo_x)
    dec  a
    ld   (bongo_x),a
    ret

    db   $FF

;;; ==========================================

kill_player:
    nop ; weee, nopslide
    nop
    nop
    nop
    nop
    ld   a,$01
    ld   (player_died),a
    ret

    dc   2, $FF

;;; ==========================================

;; There's a bug in level one/two: if you jump of the
;; edge of level one, and hold jump... it bashes invisible
;; head barrier at the start of level two and dies.
;; (because of falling timer here).
add_gravity_and_check_big_fall:
    ld   a,(falling_timer) ; did we fall too far?
    and  a
    ret  z
    dec  a
    ld   (falling_timer),a
    and  a
    jr   nz,_fall_ok
    call kill_player ; yep.
    ret
;;
_fall_ok:
    ld   a,(player_y)
    inc  a ; kind of "gravity" pushing player down
    inc  a ; 2px when falling - push to ground
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    ret

    dc   10, $FF

;;; ==========================================

;; TODO: figure out what this does to gameplay. what if it was removed?
;; (Is this why it "snaps upwards" on my fake platform in nTn?)
snap_y_to_8:
    ld   a,(player_y)
    and  $F8 ; 1111 1000
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    ret

    dc   10, $FF

;;; ==========================================

check_head_hit_tile:
    ld   a,(player_died)
    and  a
    ret  nz ; player dead, get outta here
    ld   a,(player_y)
    add  a,$01
    srl  a
    srl  a
    and  $FE
    ld   hl,screen_xoff_col
    add  a,l
    ld   l,a
    ld   a,(player_x)
    sub  (hl)
    add  a,$08
    ld   h,a
    ld   a,(player_y)
    add  a,$01
    ld   l,a
    call get_tile_addr_from_xy
    ld   a,(hl)
    and  $C0 ; 1100 0000 ; bottom 2 rows of tilesheet - including platforms,
    cp   $C0 ; (and also bunch of non-level tiles)
    ret  nz
    call fall_under_a_ledge
    ret

    dc   9, $FF

;;; ==========================================

fall_under_a_ledge:
    ld   a,(falling_timer)
    and  a
    ret  nz ; falling? Get outta here
    xor  a
    ld   (jump_tbl_idx),a ; clear jump idx
    ld   a,$08
    ld   (falling_timer),a ; set low fall
    call wait_vblank
    call wait_vblank
    ret

    dc   3, $FF

;;; ==========================================

set_level_platform_xoffs:
    ld   a,(player_num)
    and  a
    jr   nz,_P2__slpx
    ld   a,(screen_num)
    jr   _0ADE
_P2__slpx:
    ld   a,(screen_num_p2)
_0ADE:
    dec  a ; scr - 1
    ld   hl,platform_scroll_data_addr
    sla  a ; scr - 1 * 2
    add  a,l
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   hl,platform_xoffs
    ld   d,$23
_next_row:
    ld   a,(bc)
    ld   (hl),a
    inc  bc
    inc  hl
    dec  d
    jr   nz,_next_row
    call reset_xoffs
    ret

    dc   7,$FF

;;; platform data. points to either $0c10 (moving) or $0c38 (static)
platform_scroll_data_addr:
    db $38,$0C,$38,$0C,$38,$0C,$38,$0C
    db $38,$0C,$38,$0C,$38,$0C,$38,$0C
    db $38,$0C,$38,$0C,$38,$0C,$38,$0C
    db $38,$0C,$38,$0C,$38,$0C,$10,$0C
    db $38,$0C,$38,$0C,$10,$0C,$38,$0C
    db $38,$0C,$38,$0C,$38,$0C,$38,$0C
    db $38,$0C,$38,$0C,$10,$0C

;; 70 zeros/nops. That's a lotta nops. (free bytes?)
    dc 70,$0

    dc 4,$FF

;;; ==========================================

move_moving_platform:
    ld   a,(ix+$01) ; $PLATFORM_XOFFS+1
    ld   (ix+$03),a
    bit  0,(ix+$02)
    jr   nz,_0B96
    inc  (iy+$00) ; move right
    inc  (iy+$02)
    inc  (iy+$04)
    ret
_0B96:
    dec  (iy+$00) ; move left
    dec  (iy+$02)
    dec  (iy+$04)
    ret

;;; ==========================================

reset_dino_counter:
    xor  a
    ld   (dino_counter),a
    ret

    dc   11, $FF

;;; ==========================================

moving_platforms:
    ld   ix,platform_xoffs
    ld   iy,screen_xoff_col+$38
    ld   d,$09 ; loop 9 times
_0BBA:
    ld   a,(ix+$01) ; xoff + 1
    and  a
    jr   z,_0BE6
    ld   a,(ix+$02) ; xoff + 2
    and  $FE
    jr   nz,_0BD6
    ld   a,(ix+$00) ; xoff
    and  $FE
    add  a,(ix+$02) ; xoff + 2
    xor  $01
    ld   (ix+$02),a ; xoff + 2
    jr   _0BDC
_0BD6:
    dec  (ix+$02)
    dec  (ix+$02)
_0BDC:
    ld   a,(ix+$03) ; xoff + 3
    and  a
    call z,move_moving_platform
    dec  (ix+$03)
_0BE6:
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
    jr   nz,_0BBA
    ret

    dc   18, $FF

;;; ==========================================

platform_moving_data: ; All "S" levels.
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $F0,$03,$80,$03
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00

    dc   4, $FF

platform_static_data: ; All non-"S" levels.
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00
    db   $00,$00,$00,$00

    dc   4, $FF

;;; ==========================================

animate_player_to_ground_if_dead:
    ld   a,(player_died)
    and  a
    ret  z ; player still alive... leave.
_loop__apg:
    call wait_vblank
    ld   a,(player_y) ; push player towards ground
    inc  a
    inc  a
    inc  a
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    scf
    ccf
    add  a,$10
    jr   c,_0C8E ; deaded.
    ld   a,(player_x)
    ld   h,a
    ld   a,(player_y_legs)
    add  a,$20
    ld   l,a
    call get_tile_addr_from_xy
    ld   a,(hl)
    cp   tile_blank ; are we still in the air?
    jr   z,_loop__apg ; keep falling
_0C8E:
    call do_death_sequence
    xor  a
    ld   (player_died),a ; clear died
    call post_death_reset
    ret

    dc   7, $FF

;;; ==========================================

delay_8_vblanks:
    ld   e,$08
_wait_8_vb:
    call wait_vblank
    dec  e
    jr   nz,_wait_8_vb
    ret

    dc   7, $FF

;;; ==========================================
;;; what's he so happy about hey?
bongo_jump_on_player_death:
    ld   e,$03 ; jumps 3 times
_0CB2:
    call start_bongo_jump
    call jump_bongo ; why twice? Checks before re-setting
    call wait_vblank ; (is this blocking?)
    dec  e
    jr   nz,_0CB2
    ret

    dc   1, $FF

;;; ==========================================

do_death_sequence:
    ld   a,$02
    ld   (ch1_sfx),a
    ld   (sfx_prev),a
    call reset_dino_counter
    call _done_if_zero
    call delay_8_vblanks
    ld   a,$26
    ld   (player_frame),a
    ld   a,$27
    ld   (player_frame_legs),a
    ld   a,(player_y_legs)
    ld   (player_y),a
    ld   a,(player_x)
    sub  $10
    ld   (player_x),a
    call delay_8_vblanks
    ld   a,(player_x)
    add  a,$08
    ld   (enemy_3_x),a
    ld   a,$28
    ld   (enemy_3_frame),a
    ld   a,$11
    ld   (enemy_3_col),a
    ld   a,(player_y)
    sub  $10
    ld   (enemy_3_y),a
    ld   d,$28
_lp_0D08:
    call bongo_jump_on_player_death
    ld   a,(enemy_3_y)
    dec  a
    dec  a
    ld   (enemy_3_y),a
    dec  d
_done_if_zero:
    jr   nz,_lp_0D08
    ret

;;; ==========================================
;; who calls?
move_player_towards_ground_for_a_while:
    ld   d,$08 ; 8 frames
_0D19:
    ld   a,(player_y)
    inc  a
    inc  a
    inc  a
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    call wait_vblank
    dec  d
    jr   nz,_0D19
    ret

    dc   2, $FF

;;; ==========================================

start_bongo_jump:
    ld   a,(bongo_jump_timer)
    and  a
    ret  nz
    ld   a,$10
    ld   (bongo_jump_timer),a
    ret

    dc   5, $FF


;;; ==========================================

;; Oooh, mystery function - commented out.
;; Think it was going to place Bongo on the
;; bottom right for levels where player is
;; up top. Only looks correct for those levels.
move_bongo_redacted:
    ret ; just rets.
    ld   a,(bongo_x)
    ld   h,a
    ld   (bongo_y),a
    add  a,$10
    ld   l,a
    call get_tile_addr_from_xy
    ld   a,(hl)
    scf
    ccf
    sub  $C0
    ret  c
    xor  a
    ld   (bongo_jump_timer),a
    ret

    dc   7, $FF

;;; ==========================================

jump_bongo:
    call move_bongo_redacted ; also called from UPDATE_EVERYTHING
    ld   a,(bongo_jump_timer)
    and  a
    ret  z
    dec  a
    ld   (bongo_jump_timer),a
    and  $08
    jr   z,_0D79
    ld   a,(bongo_y)
    dec  a
    dec  a
    ld   (bongo_y),a
    ret
_0D79:
    ld   a,(bongo_y)
    inc  a
    inc  a
    ld   (bongo_y),a
    ret

    dc   6, $FF

;;; ==========================================

on_the_spot_bongo:   ; animate on the spot (no left/right)
    ld   a,(tick_num)
    and  $07
    ret  nz
    ld   a,(bongo_anim_timer)
    inc  a
    and  $03
    nop
    nop
    nop
    ld   (bongo_anim_timer),a
    ld   hl,_bongo_data_wat
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (bongo_frame),a
    ret

    dc   12, $FF

_bongo_data_wat:
    db   $05,$06,$07,$08,$FF,$FF,$FF,$FF

;;; ============ Draw Bongo =================

draw_bongo:
    xor  a
    ld   (bongo_jump_timer),a
    ld   (bongo_dir_flag),a
    ld   (bongo_timer),a
    ld   a,(player_num)
    and  a
    jr   nz,_0DCD
    ld   a,(screen_num)
    jr   _0DD0
_0DCD:
    ld   a,(screen_num_p2)
_0DD0:
    dec  a
    sla  a
    ld   hl,bongo_lookup2
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (bongo_x),a
    inc  hl
    ld   a,(hl)
    ld   (bongo_y),a
    ld   a,$12
    ld   (bongo_col),a
    ld   a,$05
    ld   (bongo_frame),a
    ret

    dc   20, $FF

bongo_lookup2:
    db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
    db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
    db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
    db   $E0,$38,$E0,$38,$E0,$38,$D0,$38
    db   $E0,$38,$E0,$38,$D0,$38,$E0,$38
    db   $E0,$38,$E0,$38,$E0,$38,$E0,$38
    db   $E0,$38,$E0,$38,$D0,$38,$00,$00
    db   $00,$00,$00,$00,$00,$00,$FF,$FF


;;; ==========================================

bongo_move_and_animate:
    ld   a,(bongo_dir_flag)
    and  $03 ; left or right
    jr   nz,_0E4C
    call on_the_spot_bongo
    jr   _0E58
_0E4C:
    cp   $01
    jr   nz,_left
_right:
    call move_bongo_right
    jr   _0E58
_left:
    call move_bongo_left
_0E58:
    ld   a,(bongo_dir_flag)
    bit  2,a ; jump
    ret  z
    call start_bongo_jump
    ret

    dc   14, $FF

;;; ==========================================

bongo_animate_per_screen:
    ld   a,(tick_num)
    and  $07
    ret  nz
    ld   a,(player_num)
    and  a
    jr   nz,_0E81
    ld   a,(screen_num)
    jr   _0E84
_0E81:
    ld   a,(screen_num_p2)
_0E84:
    ld   b,a
    call bongo_run_when_player_close
    ld   a,b
    dec  a ; scr #
    sla  a ; * 2
    ld   hl,bongo_anim_lookup
    add  a,l
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    push bc
    pop  hl
    ld   a,(bongo_timer)
    inc  a
    cp   $20 ; timer hit top, reset
    jr   nz,_0E9F
    xor  a
_0E9F:
    ld   (bongo_timer),a
    add  a,l
    ld   l,a
    ld   a,(hl) ; animation lookup
    ld   (bongo_dir_flag),a
    ret

    dc   23, $FF

;; addr lookup: 2 bytes per screen, points to BONGO_ANIM_DATA
bongo_anim_lookup:
    db   $08,$0F,$08,$0F,$68,$0F,$08,$0F
    db   $08,$0F,$68,$0F,$08,$0F,$08,$0F
    db   $68,$0F,$08,$0F,$68,$0F,$08,$0F
    db   $08,$0F,$68,$0F,$08,$0F,$08,$0F
    db   $08,$0F,$08,$0F,$08,$0F,$08,$0F
    db   $68,$0F,$68,$0F,$08,$0F,$68,$0F
    db   $68,$0F,$08,$0F,$08,$0F

    dc   10, $00
    dc   8, $FF

;; this looks like bongo anim data
;; 4 = jump | 2 = left | 1 = right
bongo_anim_data:
    db   $01,$01,$01,$01,$06,$05,$02,$02
    db   $02,$02,$04,$00,$00,$00,$00,$00
    db   $00,$04,$02,$02,$02,$02,$05,$06
    db   $01,$01,$01,$01,$00,$00,$00,$00

    dc   8, $FF

;;; ==========================================
;;; when the player gets close, Bongo runs away
;;; (you can catch him on fast rounds though...
;;; ... but nothing happens)

bongo_run_when_player_close:
    ld   a,(bongo_x)
    scf
    ccf
    add  a,$08
    jr   nc,_0F44
    xor  a
    ld   (bongo_dir_flag),a ; stop moving
    ld   a,$FF
    ld   (bongo_x),a
    pop  hl
    ret
_0F44:
    ld   a,(player_y)
    scf
    ccf
    sub  $60
    jr   c,_0F4E
    ret
_0F4E:
    ld   a,(player_x)
    scf
    ccf
    add  a,$70
    ret  nc
    ld   a,$01 ; right
    ld   (bongo_dir_flag),a
    pop  hl
    ret

    dc   11, $FF

;; 32 bytes of something...
    db   $00,$00,$00,$00
    db   $04,$00,$00,$00
    db   $04,$00,$00,$00
    db   $04,$00,$00,$00
    db   $00,$00,$00,$00
    db   $04,$00,$00,$00
    db   $04,$00,$00,$00
    db   $04,$00,$00,$00

;;; ==========================================

draw_border_1:
;;  intro inside border top
    call draw_tiles_h
    db   $02, $02
    db   $E0 ; corner
    dc   22, $E7
    db   $DF ; corner
    db   $FF

;; intro inside border right
    call draw_tiles_v_copy
    db   $02, $03
    dc   24, $E6
    db   $FF

    jp   draw_border_1_b

;; couple of $0Fs in a sea of $FFs
    dc   10, $FF
    db   $0F
    dc   11, $FF
    db   $0F
    dc   2, $FF

header_text_data:
    db   __,__,__,__,P_,L_,1,__,__,__,__   ; PL1
    db   H_,I_,G_,H_,$2B,S_,C_,O_,R_,E_,__ ; HIGH-SCORE
    db   __,__,__,P_,L_,2,__,__,__         ; PL2
    db   $FF

;;; === END OF BG1.BIN, START OF BG2.BIN =======

;; Reset then run main loop.
;; Happens after death and new round
big_reset:
    ld   a,$50
    ld   (_unused_1),a ; never read?
    xor  a
    ld   (controlsn),a
    ld   (jump_tbl_idx),a
    ld   (player_died),a
    ld   (falling_timer),a
    ld   (is_hit_cage),a
    ld   (bonuses),a
    ld   (bonus_mult),a
    ld   a,$20
    ld   (player_max_x),a
    call init_score_and_screen_once
    call reset_xoff_sprites_and_clear_screen
    ld   hl,header_text_data ; loaded by DRAW_SCREEN
    call draw_screen
    nop
    nop
    call draw_bonus
    call copy_hiscore_name_to_screen_2
    call draw_score
    call draw_lives
    call init_player_sprite
    call draw_background
    call set_level_platform_xoffs
    call draw_bongo
    ld   a,$02 ; bottom row is red
    ld   (screen_xoff_col+$3F),a
;;; falls through to main loop:

;;; ============= Main loop ====================
main_loop:
    call set_tick_mod_3_and_add_score
    call update_screen_tile_animations
    call update_everything ; Main logic
    call wait_vblank
    ld   a,(watchdog) ; why load? ack?
    ld   a,(int_handler) ; why load?
    jr   main_loop

    rst  $38
    ret  p

    dc   15, $FF

;;; =============== Extra Life =================

extra_life:
    ld   a,(player_num)
    and  a
    jr   nz,_107A
    call _p1_extra_life
    ret
_107A:
    call _p2_extra_life
    ret

    dc   2, $FF

;; P1 extra life
_p1_extra_life:
    ld   a,(extra_got_p1)
    and  a
    ret  nz
    ld   a,(p1_score_1)
    scf
    ccf
    sub  $15 ; bonus at ??
    ret  c
    ld   a,$01
    ld   (extra_got_p1),a
    ld   a,(lives) ; Bonus life
    inc  a
    ld   (lives),a
    call draw_lives
    ld   a,$08
    ld   (sfx_id),a
    ret

    dc   6, $FF

;; P2 extra life
_p2_extra_life:
    ld   a,(extra_got_p2)
    and  a
    ret  nz
    ld   a,(p2_score_1)
    scf
    ccf
    sub  $15
    ret  c
    ld   a,$01
    ld   (extra_got_p2),a
    ld   a,(lives_p2) ; bonus life p2
    inc  a
    ld   (lives_p2),a
    call draw_lives
    ld   a,$08
    ld   (sfx_id),a
    ret

    dc   22, $FF

;;; ==========================================

set_tick_mod_3_and_add_score:
    ld   a,(tick_mod_3)
    inc  a
    cp   $03
    jr   nz,_10E9
    xor  a ; reset a
_10E9:
    ld   (tick_mod_3),a
    sla  a ; (tick % 3) * 4
    sla  a
    call jump_rel_a ; do one of the three funcs
_add_score:
    call add_score
    ret
_extra_life:
    call extra_life
    ret
_dino_collision:
    call test_then_dino_collision
    ret

    db   $FF

;;; ============= Tick ticks ==================

;; Ticks the main ticks and speed timers
tick_ticks:                     ;
    ld   a,(tick_num)
    inc  a
    ld   (tick_num),a ; only place tick_num is set
    call update_speed_timers
    ret

    dc   5, $FF


;;; ==========================================
;;; resets any current sfx id to 0
;;; I think this function did more originally... whatever the important
;;; part was (masking and bit-twiddling), the store was nopped out
;;; at the end of the sub.
reset_sfx_ids:
    push af
    push hl
    ld   hl,ch1_cur_id          ; sfx id
    xor  a                      ; cp: If A == N, then Z flag is set
    cp   (hl)                   ; state == 0?
    jr   nz,_has_sfx_id         ; no, off to ADD
    inc  hl                     ; yep, what about $8067 (ch2_cur_id)
    cp   (hl)                   ; == 0?
    jr   nz,_has_sfx_id
    inc  hl                     ; yep, what about $8068 (ch3_cur_id)
    cp   (hl)                   ; == 0?
    jr   z,_done__msf           ; no, all zero - don't clear
_has_sfx_id:
    ld   a,(hl)                 ; ...first non-zero channel cur id
    ld   (hl),$00               ; zero it...
    add  a,$18                  ; 0001 1000 ... add 24
_done__msf:
    and  $7F   ; 0111 1111      ; mask off top bit then...
    nop        ; ... noped out?! Does nothing with value,
    nop        ; because A is popped before ret?
    pop  hl
    pop  af
    ret

    dc   3, $FF

;;; ==========================================
;;
update_screen_tile_animations:
    ld   a,(tick_mod_6) ; set tick % 6
    inc  a
    cp   $06
    jr   nz,_1139
    xor  a
_1139:
    ld   (tick_mod_6),a
    sla  a ; tick * 2
    sla  a ; tick * 4
    call jump_rel_a ; anims one-in6-times
    call screen_tile_animations ; a = 0
    ret
    nop ; a = 1
    nop
    nop
    ret
    nop ; a = 2
    nop
    nop
    ret
    nop ; a = 3
    nop
    nop
    ret
    nop ; a = 4
    nop
    nop
    ret
    nop ; a = 5
    nop
    nop
    ret
    nop ; a = 6
    nop
    nop
    ret

    dc   17, $FF

;;; =============== Update Everything ===============

update_everything:
    call check_exit_stage_left
    call update_time_timer
    call normalize_input
    call player_input
    call apply_jump_physics ; tick_mod_slow
    call add_gravity_and_check_big_fall
    call animate_player_to_ground_if_dead
    call check_if_landed_on_ground
    call check_head_hit_tile
    call moving_platforms
    call player_pos_update
    call prevent_cloud_jump_redacted
    call check_done_screen
    call clear_jump_button
    call jump_bongo
    call move_bongo_redacted
    call bongo_move_and_animate
    call bongo_animate_per_screen
    call check_fall_off_bottom_scr
    call check_dino_timer
    call update_enemies
    call player_enemies_collision
    ld   hl,update_everything_more - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ret

    dc   7, $FF

;;; ==========================================

wrap_other_spears_left:
    ld   a,(enemy_2_x)
    cp   $70
    jr   z,_11DB
    cp   $71
    jr   z,_11DB
    cp   $72
    jr   z,_11DB
    cp   $73
    jr   z,_11DB
    cp   $74
    jr   z,_11DB
    cp   $00
    jr   nz,_11DE
_11DB:
    call set_spear_left_middle
;;
_11DE:
    ld   a,(enemy_3_x)
    cp   $60
    jr   z,_11F9
    cp   $61
    jr   z,_11F9
    cp   $62
    jr   z,_11F9
    cp   $63
    jr   z,_11F9
    cp   $64
    jr   z,_11F9
    cp   $00
    jr   nz,_11FC
_11F9:
    call set_spear_left_top
_11FC:
    ret

    dc   3, $FF

;;; ==========================================
;;;
player_pos_update:
    ld   a,(player_y_legs)
    ld   b,a
    ld   a,(pl_y_legs_copy) ; no idea what this is about
    cp   b
    jr   nz,_did_leg_thing ; legs copy different from legs?
    add  a,$08 ; they are the same.. add 8
    srl  a ; ...
    srl  a
    and  $3E ; 0011 1110 (62)
    ld   h,$81
    ld   l,a
    ld   a,(_8003)
    ld   c,a
    ld   a,(hl)
    cp   c
    ret  z
    sub  c
    ld   c,a
    ld   a,(player_x)
    add  a,c
    ld   (player_x),a
    ld   (player_x_legs),a
_did_leg_thing:
    ld   a,(player_y_legs)
    add  a,$08
    srl  a
    srl  a
    and  $3E
    ld   h,$81
    ld   l,a
    ld   a,(hl)
    ld   (_8003),a
    ld   a,(player_y_legs)
    ld   (pl_y_legs_copy),a
    ret

    dc   15, $FF

;;; ==========================================

;;; only called from PREVENT_CLOUD_JUMP_REDACTED
prevent_cloud_jump_redacted_2:
    push hl
    ld   a,(player_x)
    sub  (hl)
    ld   h,a
    ld   a,(player_y_legs)
    sub  $12
    ld   e,d
    sla  e
    sla  e
    sla  e
    add  a,e
    ld   l,a
    call get_tile_addr_from_xy
    nop
    nop
    nop
    nop
    ld   a,(hl)
    and  $C0
    cp   $C0
    jr   z,_127D
    ld   bc,MINUS_64
    add  hl,bc
    ld   a,(hl)
    and  $C0
    cp   $C0
    jr   nz,_1280
_127D:
    call fall_under_a_ledge
_1280:
    pop  hl
    ret

    dc   14, $FF


;;; ==========================================

;; ANOTHER commented out one!
;; This stops a player jumping up through a platform
;; from underneath it. Probably more realistic, but
;; good decision on the devs part to remove it it: it sucks!
prevent_cloud_jump_redacted:
    ret
    ld   a,(player_y_legs)
    add  a,$04
    srl  a
    srl  a
    and  $3E
    ld   l,a
    ld   h,$81
    ld   d,$04
_12A1:
    call prevent_cloud_jump_redacted_2
    dec  hl
    dec  hl
    dec  d
    jr   nz,_12A1
    ret

    dc  14, $FF

;;; ==========================================

draw_background:
;; draw first 6 columns
    call draw_tiles_h
    db   $03,$00
    db   $40,$42,$43,$42,$41,$40,$FF ; downward spikes
    call draw_tiles_h
    db   $09,$00
    db   $FE,$FD,$FD,$FD,$FD,$FC,$FF ; top left platform
    call draw_tiles_h
    db   $1E,$00
    db   $FE,$FD,$FD,$FD,$FD,$FC,$FF ; bottomleft platform
    call screen_reset
    ld   hl,scr_lvl_bg_start ; screen pos (6,0)
    ld   ix,(level_bg_ptr)
    ld   d,$17 ; call 23 columns = width - 6
_draw_column:                   ; because first 6 are constant
    call draw_screen_column_from_level_data
    nop
    nop
    nop
    dec  d
    jr   nz,_draw_column
reset_enemies_and_draw_bottom_row:
    ld   (screen_ram_ptr),hl ; hl = 9000 when hits here on death
    call reset_enemies
    ld   hl,add_screen_pickups - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    jp   draw_bottom_row_numbers

;;; ==========================================

;; scrolls the screen one tile - done in a loop for the transition
scroll_one_column:
    ld   e,$04 ; 4 loops of 2 pixels
    push hl
_1303:
    ld   hl,screen_xoff_col+$06
_1306:
    dec  (hl)
    dec  (hl)
    inc  hl
    inc  hl
    push hl
    call player_pos_update
    pop  hl
    ld   a,l
    cp   $3E
    jr   nz,_1306
    call wait_vblank
    dec  e
    jr   nz,_1303
    pop  hl
    ret

    dc   12, $FF


;;; ==========================================

;; ix = level data
;; hl = screen pos

;; Level BG data is FF separated, then split on 00.
;; Each row is a column of the screen, starting at col 6
;; first byte of segment is the row #
draw_screen_column_from_level_data:
    call clear_column_of_tiles
_lp_132B:
    ld   a,(ix+$00) ; ix + 0 (always 3?)
    push hl
    add  a,l
    ld   l,a
    inc  ix ; ix++
_draw_char:
    ld   a,(ix+$00)
    cp   $FF ; 0xff = EOL marker
    jr   z,_done_1343
    and  a ; 0x00 = segment marker
    jr   z,__next_seg
    ld   (hl),a
    inc  hl
    inc  ix ; ix++
    jr   _draw_char
_done_1343:
    inc  ix ; ix++
    pop  hl
    ld   bc,scr_line_prev
    add  hl,bc
    ld   a,h
    cp   $8F
    ret  nz
    ld   h,$93
    ret
__next_seg:
    inc  ix ; ix++
    pop  hl ; reset screen pos
    jr   _lp_132B

    dc   2, $FF

;;; ==========================================

during_transition_next:
    call bongo_runs_off_screen
    nop
    call screen_reset
    ld   ix,(level_bg_ptr)
    ld   hl,(screen_ram_ptr) ; must point to screen?
    ld   d,$15 ; 21 columns to scroll
_lp_1368:
    call draw_screen_column_from_level_data
    call scroll_one_column
    dec  d
    jr   nz,_lp_1368
_done_scrolling:
    ld   (level_bg_ptr),ix
    ld   (screen_ram_ptr),hl ; hl = 9160 on transition (e on HIGH-SCORE)
_reset_for_next_level:
    call clear_scr_to_blanks
    call draw_background
    xor  a
    ld   (pl_y_legs_copy),a
    ld   (_8003),a
    call init_player_pos_for_screen
    call draw_bongo
    call set_lives_row_color
    ret

    db   $FF


;;; ==========================================
;; "jump relative A": dispatches to address based on A
jump_rel_a:
    exx
    pop  hl ; stack RET pointer
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    exx
    ret ; sets PC to RET + A

    dc   7, $FF

;;; ==========================================
;;; Looks important. VBLANK?
wait_vblank:
    ld   b,$00
_13A2:
    ld   a,$01
    ld   (int_enable),a ; enable interrupts
    ld   a,(watchdog)
    ld   a,b
    cp   $01
    jr   nz,_13A2
    xor  a
    ld   (int_enable),a ; disable interrupts
    ld   a,(watchdog)
    ret

    db   $FF

;;; ==========================================

bongo_runs_off_screen:
    ld   hl,bongo_x
_13BB:
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $60
    jr   nz,_13BB
    ret

    dc   12, $FF

;;; ==========================================

update_time_timer:
    ld   a,(second_timer)
    inc  a
    ld   (second_timer),a
    cp   $3C
    ret  nz
    xor  a
    ld   (second_timer),a
    call update_time
    call draw_time
    ret

    dc   11, $FF

update_time:
    ld   a,(player_num)
    bit  0,a
    ld   hl,p1_time
    jr   z,_13FC
    inc  hl
    inc  hl
_13FC:
    ld   a,(hl)
    inc  a
    daa ; the A register is BCD corrected from flags
    ld   (hl),a
    cp   $60 ; minutes
    ret  nz
    ld   (hl),$00
    inc  hl
    ld   a,(hl)
    inc  a
    daa
    ld   (hl),a ; store it
    ret

    dc   5, $FF

;;; ==========================================

;; draws the player's time under score
;; ret's immediately: must have been removed! aww :(
draw_time:
    ret                         ; nooo! Put the timer back plz!
    ld   a,(player_num)
    bit  0,a
    jr   nz,_1436
;; p1 version
    xor  a
    ld   hl,p1_time
    rrd
    ld   (p1_timer_digits+0*$20),a ; digit 1
    rrd
    ld   (p1_timer_digits+1*$20),a ; digit 2
    rrd
    inc  hl
    rrd
    ld   (p1_timer_digits+3*$20),a ; digit 3
    rrd
    ld   (p1_timer_digits+4*$20),a ; digit 4
    rrd
    ret
;;  p1 version
_1436:
    xor  a
    ld   hl,p2_time
    rrd
    ld   (p2_timer_digits+0*$20),a ; digit 1
    rrd
    ld   (p2_timer_digits+1*$20),a ; digit 2
    rrd
    inc  hl
    rrd
    ld   (p2_timer_digits+3*$20),a ; digit 3
    rrd
    ld   (p2_timer_digits+4*$20),a ; digit 4
    rrd
    ret

    dc   12, $FF

;;; ==========================================

clear_ram_x83_bytes:
    ld   hl,START_OF_RAM
_loop__c83:
    ld   (hl),$00
    inc  l
    jr   nz,_loop__c83
    inc  h
    ld   a,h
    cp   $83
    jr   nz,_loop__c83
    ret

    dc   1, $FF

;;; ==========================================
;; lotsa calls here
reset_xoff_sprites_and_clear_screen:
    call reset_xoff_and_cols_and_sprites ; then nop slides
    nop ; ...
    nop ; ...
    nop
    nop
    nop
    inc  hl ; hl++ ?
    nop
    nop
    nop
    nop
    nop
    nop
    nop ; end of weird nopslide

;;; ==========================================
;;; Clears video RAM from $9000-$97FF
;;; I don't understand the $9400-$97ff screen.
;;; It's a mirror to the first, so this seems like
;;; clearing up to $9800 (instead of $9400) would
;;; be a waste of time?
clear_screen:
    ld   hl,screen_ram
_loop_cs:
    ld   (hl),tile_blank
    inc  l
    jr   nz,_loop_cs
    inc  h
    ld   a,h
    cp   $98     ; Hit $9800?
    jr   nz,_loop_cs
    ret

    db   $FF

;;; ==========================================

;; Lotsa calls here (via $1470);
reset_xoff_and_cols_and_sprites:    ; sets 128 locations to 0
    ld   hl,screen_xoff_col
_1493:
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $80 ; 128
    jr   nz,_1493
    ret

    dc   4, $FF

;;; ==========================================

clear_ram:
    ld   hl,START_OF_RAM ; = $8000
_14A3:
    ld   (hl),$00
    inc  hl
    ld   a,h
    cp   $84 ; 132
    jr   nz,_14A3
    jp   _ret_hard_reset ; Return

    dc   2, $FF

;;; ==========================================

screen_reset:
    ld   hl,play_tune_for_cur_screen - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    call copy_xoffs
;; set init player pos
    ld   a,$20
    ld   (player_max_x),a
    ld   a,(player_num)
    and  a
    jr   nz,_14C9
    ld   a,(screen_num)
    jr   _14CC
_14C9:
    ld   a,(screen_num_p2)
_14CC:
    ld   hl,level_bg_ptr_lookup
    ld   b,$00
    dec  a ; scr# - 1
    ld   c,a
    sla  c ; * 2
    add  hl,bc
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   (level_bg_ptr),bc
    ret

    dc   2, $FF

;;; ==========================================

reset_enemies_2:
    ld   a,(tick_mod_fast) ; faster in round 2
    and  $03
    ret  nz
    call enemy_1_reset
    call enemy_2_reset
    call enemy_3_reset
    ret

    dc   16, $FF

;; Points to the addr of each screen's level data
level_bg_ptr_lookup:
    db   $B0,$18,$B0,$18,$40,$21,$B0,$18
    db   $10,$1A,$40,$21,$70,$1E,$B0,$18
    db   $40,$21,$10,$1A,$40,$21,$70,$1E
    db   $B0,$18,$40,$21,$B0,$18,$00,$1D
    db   $70,$1E,$B0,$18,$00,$1D,$70,$1E
    db   $E0,$1F,$40,$21,$70,$1E,$E0,$1F
    db   $40,$21,$70,$1E,$00,$1D
    dc   6, $00

    dc   20, $FF

copy_xoffs_and_cols_to_screen:
    push hl
    push bc
    push de
    ld   hl,screen_xoff_col
    ld   de,xoff_col_ram
    ld   bc,$0080
    ldir ; LD (DE),(HL) repeated: copies a chunk of mem
    pop  de
    pop  bc
    pop  hl
    ret

    dc   2, $FF

;; Why?
animate_splash_pickup_nops:
    nop
    nop
animate_splash_pickups:
    ld   a,(attract_piks+$00)
    cp   tile_blank
    jr   z,_157D
    cp   tile_pik_crowna
    jr   nz,_1578
    ld   a,$9C
    ld   (attract_piks+$00),a
    jr   _157D
_1578:
    ld   a,tile_pik_crowna
    ld   (attract_piks+$00),a
;;
_157D:
    ld   a,(attract_piks+$04)
    cp   tile_blank
    jr   z,_1594
    cp   $8D
    jr   nz,_158F
    ld   a,$9D
    ld   (attract_piks+$04),a
    jr   _1594
_158F:
    ld   a,$8D
    ld   (attract_piks+$04),a
;;
_1594:
    ld   a,(attract_piks+$08)
    cp   tile_blank
    jr   z,_15AB
    cp   $8E
    jr   nz,_15A6
    ld   a,$9E
    ld   (attract_piks+$08),a
    jr   _15AB
_15A6:
    ld   a,$8E
    ld   (attract_piks+$08),a

_15AB:
    ld   a,(attract_piks+$0C)
    cp   tile_blank
    jr   z,_15C2
    cp   $8F
    jr   nz,_15BD
    ld   a,$9F
    ld   (attract_piks+$0C),a
    jr   _15C2
_15BD:
    ld   a,$8F
    ld   (attract_piks+$0C),a
_15C2:
    ret

    db   $FF

_15C4:
    push de
    ld   hl,animate_circle_border - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    pop  de
    ret

    dc   3, $FF

attract_bonus_screen:
    call reset_xoff_sprites_and_clear_screen
    call draw_border_1
    call animate_splash_screen
    ld   a,tile_pik_crowna
    ld   (attract_piks+$00),a
    call animate_splash_screen
    call draw_tiles_h
    db   $08,$10
    db   2,0,0,__,P_,T_,S_,$FF ;  200 PTS
    call animate_splash_screen
    ld   a,$8D
    ld   (attract_piks+$04),a
    call animate_splash_screen
    call draw_tiles_h
    db   $0C,$10
    db   4,0,0,__,P_,T_,S_,$FF ;  400 PTS
    call animate_splash_screen
    ld   a,$8E
    ld   (attract_piks+$08),a
    call animate_splash_screen
    call draw_tiles_h
    db   $10,$10
    db   6,0,0,__,P_,T_,S_,$FF ;  600 PTS
    call animate_splash_screen
    ld   a,$8F
    ld   (attract_piks+$0C),a
    call animate_splash_screen
    call draw_tiles_h
    db   $14,$10
    db   1,0,0,0,__,P_,T_,S_,$FF ;  1000 PTS
    call animate_splash_screen
    call animate_splash_screen
    call animate_splash_screen
    call animate_splash_screen
    ld   hl,attract_catch_dino - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ret

    db   $FF

clear_and_draw_screen:
    call reset_xoff_sprites_and_clear_screen
    ld   hl,header_text_data
    call draw_screen
    nop ; data
    nop
    call draw_score
    ret

    dc   6, $FF

;;; ==========================================

animate_splash_screen:
    ld   d,$10
_1662:
    call animate_splash_pickup_nops
    call _15C4
    ld   e,$04
_166A:
    push de
    call wait_for_start_button
    pop  de
    dec  e
    jr   nz,_166A
    dec  d
    jr   nz,_1662
    ret

    dc   2, $FF

;;; ==========================================
;;  tiles for the uncovered bonus amount
bonus_multplier_data:
    db   tile_bonus_10_tl
    db   tile_bonus_20_tl
    db   tile_bonus_30_tl
    db   tile_bonus_40_tl
    db   tile_bonus_10_bl
    db   tile_bonus_20_bl
    db   tile_bonus_30_bl
    db   tile_bonus_40_bl

;;; ==========================================

update_speed_timers:
    ld   a,(player_num)
    and  a
    jr   nz,_168B
    ld   a,(speed_delay_p1)
    jr   _168E
_168B:
    ld   a,(speed_delay_p2)
_168E:
    cp   round1_speed
    jr   nz,_16AB
;;  Round 1
    ld   a,(tick_mod_fast)
    inc  a
    cp   $03
    jr   nz,_169B
    xor  a
_169B:
    ld   (tick_mod_fast),a
    ld   a,(tick_mod_slow)
    inc  a
    cp   $06
    jr   nz,_16A7
    xor  a
_16A7:
    ld   (tick_mod_slow),a
    ret
;;; Round 2+
_16AB:
    ld   a,(tick_mod_fast)
    inc  a
    cp   $02
    jr   nz,_16B4
    xor  a
_16B4:
    ld   (tick_mod_fast),a
    ld   a,(tick_mod_slow)
    inc  a
    cp   $04
    jr   nz,_16C0
    xor  a
_16C0:
    ld   (tick_mod_slow),a
    ret

    dc   12, $FF

;;; ==========================================

draw_bonus:
TBB = tile_bonus_blank
    call draw_tiles_h
    db   $0A,$00
    db   $E0,$DC,$DD,$DE,$DF,$FF
    call draw_tiles_h
    db   $0B,$00
    db   $E1,TBB,TBB,TBB,$E6,$FF
    call draw_tiles_h
    db   $0C,$00
    db   $E1,TBB,TBB,TBB,$E6,$FF
    call draw_tiles_h
    db   $0D,$00
    db   $E2,$E3,$E3,$E3,$E4,$FF
    ret

    dc   3, $FF


;;; ==========================================
;; Adds whatever is in 801d
add_score:
    ld   a,(num_players)
    and  a
    ret  z
    ld   a,(player_num)
    and  a
    jr   nz,_1722
;;; player 1
    ld   a,(score_to_add) ; amount to add
    and  a
    ret  z ; nothing to add... leave.
    ld   c,a
    ld   h,$80 ; 8014 for p1 8017 for p2
    ld   b,$00
    ld   l,$14
    call add_amount_bdc
    call draw_score
    xor  a
    ld   (score_to_add),a ; clear
    ret
;;; player 2
_1722:
    ld   a,(score_to_add)
    and  a
    ret  z
    ld   c,a
    ld   h,$80
    ld   b,$00
    ld   l,$17
    call add_amount_bdc
    call draw_score
    xor  a
    ld   (score_to_add),a
    ret

    dc   23, $FF

;;; ==========================================
;;; Go to the next level when the player gets to the right edge
;;; of the screen, at the top or the bottom. This prevents the
;;; game transitioning if you jump of the moving platforms in
;;; the middle of the screen. (Though, it is possible to skip
;;; the tricky lava-jump "S_S" levels, if you carefully jump UNDER
;;; the platform on the bottom right!)
check_done_screen:
    scf
    ccf
    ld   a,(player_y) ; Test if player is at top or bottom
    add  a,$48 ; Y + 72 > 255?
    jr   c,_valid_exit_y ; ...yep, check x
    sub  $78 ; Y - 120 < 0?
    ret  nc ; ...no, can't finish level here...
;; check if gone past edge of screen
_valid_exit_y:
    ld   a,(player_x)
    scf
    ccf
    sub  screen_width ; out of screen?
    ret  c
    call transition_to_next_screen ; jump to next screen
    ret

;;; ==========================================
;;
clear_column_of_tiles:
    push hl
    ld   a,$03
    add  a,l
    ld   l,a
    ld   e,$1C ; 24 loops
_lp_176F:
    ld   (hl),tile_blank
    inc  hl
    dec  e
    jr   nz,_lp_176F
    pop  hl
    ret

    db   $FF

;;; ==========================================

transition_to_next_screen:
    call reset_dino
    ld   a,(player_num)
    and  a
    jr   nz,_178A
    ld   a,(screen_num)
    inc  a ; next screen if p1
    ld   (screen_num),a
    jr   _1791
_178A:
    ld   a,(screen_num_p2)
    inc  a ; next screen if p2
    ld   (screen_num_p2),a
_1791:
    call set_player_y_level_start
    call during_transition_next ; wipes to next
    call set_level_platform_xoffs
    ld   a,$02
;; I think that should be call not jump. It rets anyway.
    jp   reset_jump_and_redify_bottom_row
    ret

;; (might be just "add bcd to addr")
;; hl is either 8014 for p1 or 8017 for p2
;; c contains score to add
add_amount_bdc:
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

    dc   2, $FF

reset_jump_and_redify_bottom_row:
    ld   (screen_xoff_col+$3F),a ; set bottom row col
    xor  a
    ld   (jump_tbl_idx),a
    ld   (jump_triggered),a
    ret

    db   $FF

;;; ==========================================

reset_dino:
    xor  a
    ld   (dino_counter),a
    ld   a,(dino_x)
    ld   (dino_x_legs),a
    ret

    dc   5, $FF

draw_bonus_box:
    call draw_tiles_h
    db   $0A,$00
    db   $B8,$B4,$B5,$B6,$B7,$FF
    call draw_tiles_h
    db   $0B,$00
    db   $B9,$FF
    call draw_tiles_h
    db   $0B,$04
    db   $BE,$FF
    call draw_tiles_h
    db   $0C,$00
    db   $B9,$FF
    call draw_tiles_h
    db   $0C,$04
    db   $BE,$FF
    call draw_tiles_h
    db   $0D,$00
    db   $BA,$BB,$BB,$BB,$BC,$FF
    ret

    dc   5, $FF

reset_player_sprite_frame_col:
    ld   a,$0C
    ld   (player_frame),a
    inc  a
    ld   (player_frame_legs),a
    ld   a,$11
    ld   (player_col),a
    ld   (player_col_legs),a
    ret

    dc   6, $FF

;;; ==========================================

init_player_pos_for_screen:
    ld   a,(player_num)
    and  a
    jr   nz,_182B
    ld   a,(screen_num)
    jr   _182E
_182B:
    ld   a,(screen_num_p2)
_182E:
    ld   hl,player_start_pos_data
    dec  a
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (player_x),a
    ld   (player_x_legs),a
    inc  hl
    ld   a,(hl)
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    call reset_player_sprite_frame_col
    ret

    dc   5, $FF

;;; ==========================================
;; [x, y]
player_start_pos_data:
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$26
    db   $20,$26
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$26
    db   $20,$26
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$D0
    db   $20,$26
    db   $20,$D0
    db   $20,$D0
    db   $20,$26
    db   $20,$D0
    db   $20,$26
    db   $20,$26
    db   $20,$D0
    db   $20,$26
    db   $20,$26
    db   $20,$D0  ; cage

    dc   10, $00
    dc   8, $FF


;;; ==========================================

reset_xoffs:
    ld   hl,screen_xoff_col
_loop_rx:
    ld   (hl),$00
    inc  hl
    inc  hl
    ld   a,l
    cp   $40
    jr   nz,_loop_rx
    ret

    dc   11, $FF

;;; ==========================================
;; Level data for screens 1, 2, 4, 8, 13, 15, 18
;; (all `n_n` screens).
;; See by DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__n_n:
    db   $03,$41,$00,$09,$FE,$00,$1E,$39,$FF
    db   $03,$43,$00,$09,$FD,$45,$41,$00,$1B,$FE,$3B,$45,$45,$FF
    db   $03,$40,$00,$09,$FD,$42,$00,$1B,$FD,$3F,$3F,$3B,$FF
    db   $03,$43,$00,$09,$FC,$41,$00,$1B,$FD,$3B,$3B,$3F,$FF
    db   $03,$42,$00,$1B,$FD,$3F,$3B,$3B,$FF
    db   $03,$3F,$00,$1B,$FD,$3F,$3F,$3B,$FF
    db   $03,$3E,$43,$00,$1B,$FD,$3B,$3F,$3B,$FF
    db   $03,$3F,$40,$00,$1B,$FC,$47,$3B,$47,$FF
    db   $03,$3B,$42,$00,$1D,$3D,$3F,$FF
    db   $03,$3B,$40,$00,$1D,$3C,$3E,$FF
    db   $03,$3F,$43,$00,$1D,$3A,$3F,$FF
    db   $03,$3E,$41,$00,$1B,$FE,$10,$3D,$3E,$FF
    db   $03,$3B,$40,$00,$1B,$FD,$47,$3E,$47,$FF
    db   $03,$3F,$42,$00,$1B,$FD,$3B,$3B,$3B,$FF
    db   $03,$3E,$00,$1B,$FD,$3E,$3F,$3F,$FF
    db   $03,$42,$00,$09,$FE,$00,$1B,$FD,$3F,$3B,$3E,$FF
    db   $03,$43,$00,$09,$FD,$47,$41,$00,$1B,$FD,$3B,$3E,$3E,$FF
    db   $03,$41,$00,$09,$FD,$00,$1B,$FC,$3E,$3B,$3B,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FE,$FF
    db   $03,$43,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FD,$00,$1E,$FC,$FF

    dc   3, $FF

;;; ==========================================
;;; Skip level AFTER getting bonus
bonus_skip_screen:
;; Draws the Bongo Tree. I thought this must have been a glitch,
;; but nope: the Bongo Tree is meant to be like that!
    ld   a,$F0 ; right of screen (scrolls to left)
    ld   (player_x),a
    ld   (player_x_legs),a
    ld   a,$26 ; top of screen
    ld   (player_y_legs),a
    ld   a,$16
    ld   (player_y),a
    ld   a,$17 ; backwards player for both head and legs, lol
    ld   (player_frame),a
    ld   (player_frame_legs),a
    xor  a ; red and green for the bongo tree.
    ld   (player_col),a
    ld   (player_col_legs),a
    jp   transition_to_next_screen


;;; ==========================================
;; Clear screen to blanks
clear_scr_to_blanks:
    ld   hl,screen_ram
_19C3:
    inc  hl
    inc  hl
    inc  hl
    ld   d,$1D ; 29
_19C8:
    ld   (hl),tile_blank
    inc  hl
    dec  d
    jr   nz,_19C8
    ld   a,h
    cp   $94 ; 148
    jr   nz,_19C3
    nop
    nop
    nop
    nop
    nop
_clear_xoff_col_spr:  ; Same code as $RESET_XOFF_AND_COLS_AND_SPRITES
    ld   hl,screen_xoff_col
_19DB:
    ld   (hl),$00
    inc  hl
    ld   a,l
    cp   $80
    jr   nz,_19DB
_done_19E3:
    call wait_vblank
    ret

    dc   9, $FF

;;; ==========================================

check_fall_off_bottom_scr:
    ld   a,(player_y_legs)
    scf
    ccf
    add  a,$18 ; +24 (ground = 255-24?)
    ret  nc
    call do_death_sequence
    xor  a
    ld   (player_died),a
    call post_death_reset
    ret

    db   $FF

;;; ==========================================
;; Die if you go out the screen to the left (16px)
check_exit_stage_left:
    ld   a,(player_x)
    scf
    ccf
    sub  $10 ; out the start of the screen?
    ret  nc ; ... nope, you're good
    jp   call_do_death_sequence ; ... yep, you're dead
    ret

;; Level data for screens 5, 10
;; (`/` screens)
;; See DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__stairs_up:
    db   $03,$3F,$00,$1B,$FE,$30,$31,$3C,$FF
    db   $03,$3F,$3E,$3B,$40,$00,$1B,$FC,$10,$3A,$3F,$FF
    db   $03,$3B,$3B,$3E,$3F,$42,$00,$1B,$36,$10,$3D,$3F,$FF
    db   $03,$3F,$3B,$3F,$3E,$3B,$41,$00,$18,$FE,$30,$31,$10,$3C,$3F,$3E,$FF
    db   $03,$3F,$3B,$3E,$3B,$3E,$3F,$40,$00,$18,$FC,$00,$1D,$39,$3E,$FF
    db   $03,$3B,$3F,$3B,$3E,$3B,$41,$00,$18,$36,$10,$10,$3D,$3F,$3E,$3B,$FF
    db   $03,$3F,$3B,$3B,$3B,$00,$15,$FE,$30,$31,$30,$10,$3A,$3E,$3B,$3B,$3F,$FF
    db   $03,$3E,$3E,$3B,$00,$15,$FC,$00,$1A,$3C,$3F,$3E,$3E,$3F,$FF
    db   $03,$3B,$00,$15,$37,$10,$10,$10,$39,$3E,$3E,$3F,$3B,$3F,$FF
    db   $03,$3E,$42,$00,$12,$FE,$31,$30,$31,$10,$10,$10,$3A,$3F,$3E,$3B,$3E,$3F,$FF
    db   $03,$3F,$41,$00,$12,$FC,$00,$1A,$38,$3E,$3B,$3B,$3F,$FF
    db   $03,$3E,$40,$00,$12,$36,$00,$1B,$39,$3F,$3B,$3F,$FF
    db   $03,$42,$00,$0F,$FE,$30,$31,$00,$1B,$3C,$3F,$3E,$3E,$FF
    db   $03,$43,$00,$0F,$FC,$00,$1C,$3E,$3E,$3B,$FF
    db   $03,$41,$00,$0F,$37,$00,$1D,$3A,$3B,$FF
    db   $03,$42,$00,$0C,$FE,$34,$35,$36,$00,$1E,$3C,$FF
    db   $03,$41,$00,$0C,$FC,$00,$1E,$39,$FF
    db   $03,$40,$00,$0C,$36,$00,$1E,$3E,$FF
    db   $03,$42,$00,$09,$FE,$00,$1E,$FE,$FF
    db   $03,$43,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FC,$00,$1E,$FC,$FF

    ld   hl,(level_bg_ptr)
    ld   bc,$0014 ; add 20 bytes to bg_ptr
    add  hl,bc
    ld   (level_bg_ptr),hl
    ld   hl,(screen_ram_ptr)
    ld   bc,$0014 ; add 20 bytes to SCREEN_RAM_PTR
    add  hl,bc
    ld   (screen_ram_ptr),hl
    ret

    dc   3, $FF

;;; ==========================================

call_do_death_sequence:
    call do_death_sequence
    call post_death_reset
    ret

    db   $FF

;;; =============== unused? ====================
;; ? unused?
    ld   a,$03
    ld   (_8080),a
    call add_score
    call delay_60_vblanks
    ld   a,(player_num)
    and  a
    jr   nz,_1B66
    ld   hl,screen_num
    jr   _1B69
_1B66:
    ld   hl,screen_num_p2
_1B69:
    ld   a,(hl)
    inc  a
    daa
    ld   (hl),a
    call nopped_out_dispatch ; calls nothing (nopped dispatch) based on screen
    jp   big_reset

    dc   13, $FF

;;; ==========================================

init_score_and_screen_once:
    ld   a,(is_2_players)
    and  a
    jr   nz,_both
_2_players:
    ld   a,(did_init) ; $8022 never used anywhere else
    and  a
    jr   z,_did_init
    ret ; p2 hasn't inited?
_did_init:
    inc  a
    ld   (did_init),a ; (except here)
_both:
    call add_score
    call reset_xoff_sprites_and_clear_screen
;;
    nop
    nop
    call draw_lives
    ld   hl,header_text_data
    call draw_screen
    db   $00,$00 ; data
    call draw_score
    ld   a,(player_num)
    and  a
    jr   nz,_1BBD
    call draw_tiles_h
    db   $10,$0A
    db   $20,$1C,$11,$29,$15,$22,$10,$01,$FF ;  PLAYER 1
    jr   _1BCB
_1BBD:
    call draw_tiles_h
    db   $10,$0A
    db   $20,$1C,$11,$29,$15,$22,$10,$02,$FF ;  PLAYER 2
_1BCB:
    call play_intro_jingle
    ret

    ld   a,$08
    ld   (_8086),a
    ret

    dc   1, $FF

;;; ==========================================

draw_border_1_b:
    call draw_tiles_h
    db   $1B,$02
    db   $E2
    dc   22,$E3
    db   $E4,$FF

    jp   draw_border_1_c

    dc   9, $FF

;;; ==========================================

delay_18_vblanks:
    ld   e,$18
_loop_dv18:
    call wait_vblank
    dec  e
    jr   nz,_loop_dv18
    ret

    dc   7, $FF

;;; ==========================================

dino_caught_player_right:
    ld   a,(player_x)
    add  a,$08
    ld   (dino_x),a
    add  a,$08
    ld   (dino_x_legs),a
    ld   a,(player_y)
    ld   (dino_y),a
    add  a,$10
    ld   (dino_y_legs),a
    ld   a,$AC
    ld   (dino_frame),a
    ld   a,$B0
    ld   (dino_frame_legs),a
    call delay_18_vblanks
    ld   a,$AD
    ld   (dino_frame),a
    call delay_18_vblanks
    call kill_player
    ret

;;; ==========================================

play_intro_jingle:
    ld   a,$0F ; intro jingle
    ld   (sfx_id),a
    xor  a
    ld   (ch1_sfx),a
    call delay_60_vblanks
    ret

    dc   2, $FF

;;; ==========================================

dino_caught_player_left:
    ld   a,(player_x)
    sub  $08
    ld   (dino_x),a
    sub  $08
    ld   (dino_x_legs),a
    ld   a,(player_y)
    ld   (dino_y),a
    add  a,$10
    ld   (dino_y_legs),a
    ld   a,$2C
    ld   (dino_frame),a
    ld   a,$30
    ld   (dino_frame_legs),a
    call delay_18_vblanks
    ld   a,$2D
    ld   (dino_frame),a
    call delay_18_vblanks
    call kill_player
    ret

;;; ==========================================

_a_thing_1C81:                  ; surely not real code?
    db   $E9, $10,$40           ; jp (hl); djnz $1cc4
    ld   bc,_a_thing_1C81
    push bc
    push hl
    ret

    dc   6, $FF

;;; ==========================================

dino_got_player_left_or_right:
    ld   a,(player_x)
    ld   b,a
    ld   a,(dino_x)
    scf
    ccf
    sub  b
    jr   c,_1CA0
    call dino_caught_player_right
    ret
_1CA0:
    call dino_caught_player_left
    ret

    dc   12, $FF

;;; ==========================================

dino_collision:
    ld   a,(dino_x)
    ld   b,a
    ld   a,(player_x)
    sub  b
    scf
    ccf
    sub  $18
    jr   c,_1CC1
    add  a,$30
    ret  nc
_1CC1:
    ld   a,(dino_y)
_1CC4:
    ld   b,a
    ld   a,(player_y)
    sub  b
    scf
    ccf
    sub  $28
    jr   c,_1CD2
    add  a,$50
    ret  nc
_1CD2:
    call dino_got_player_left_or_right
    ret

    dc   2, $FF


;;; ==========================================

draw_border_1_c:
    call draw_tiles_v_copy
    db   $19,$03
    db   $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
    db   $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$FF
    ret

    dc   9, $FF

;;; ==========================================

;; Level data for screens: 16, 19, 27
;; (all `S` screens)
;; See by DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__S:
    db   $03,$3B,$3E,$3F,$00,$0F,$FE,$00,$1B,$FE,$10,$3D,$3E,$FF
    db   $03,$3E,$3E,$3F,$3E,$00,$0F,$FD,$00,$1B,$FD,$10,$3C,$3F,$FF
    db   $03,$3E,$3B,$3B,$3F,$3B,$00,$0F,$FD,$00,$1B,$FD,$10,$3A,$3B,$FF
    db   $03,$3B,$3E,$3B,$3F,$3F,$41,$00,$0F,$FD,$00,$1B,$FD,$10,$3C,$3B,$FF
    db   $03,$3B,$3E,$3F,$3B,$00,$0F,$FC,$00,$19,$35,$34,$3C,$10,$39,$3E,$FF
    db   $03,$3F,$3E,$3B,$3E,$00,$0D,$36,$31,$00,$18,$37,$10,$10,$10,$3D,$3F,$3E,$FF
    db   $03,$3B,$3B,$40,$00,$0C,$33,$00,$12,$FE,$00,$18,$FE,$10,$10,$3C,$3E,$3F,$3F,$FF
    db   $03,$3E,$40,$00,$0C,$FE,$00,$12,$FD,$00,$18,$FD,$10,$10,$3D,$3B,$3F,$3B,$FF
    db   $03,$3F,$41,$00,$0C,$FD,$00,$12,$FD,$00,$18,$FD,$10,$3A,$3F,$3F,$3E,$3B,$FF
    db   $03,$3F,$40,$00,$0C,$FD,$00,$12,$FD,$00,$18,$FD,$10,$38,$3E,$3F,$3E,$3B,$FF
    db   $03,$40,$00,$0C,$FD,$00,$12,$FD,$00,$18,$FD,$10,$10,$3A,$3B,$3B,$3F,$FF
    db   $03,$42,$00,$0C,$FC,$00,$12,$FC,$00,$18,$FC,$10,$10,$3A,$3F,$3E,$3B,$FF
    db   $03,$43,$00,$0A,$33,$31,$00,$17,$36,$10,$10,$3C,$3F,$3B,$3B,$3E,$FF
    db   $03,$41,$00,$0A,$36,$00,$16,$36,$10,$10,$3D,$3B,$3F,$3E,$3B,$3B,$FF
    db   $03,$43,$00,$09,$FE,$00,$15,$FE,$10,$10,$3A,$3E,$3F,$3B,$3F,$3B,$3F,$FF
    db   $03,$42,$00,$09,$FD,$00,$15,$FD,$10,$10,$10,$10,$3E,$3B,$3F,$3F,$3E,$FF
    db   $03,$41,$00,$09,$FD,$00,$15,$FD,$10,$10,$10,$10,$10,$3A,$3F,$3B,$3E,$FF
    db   $03,$40,$00,$09,$FD,$00,$15,$FC,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FE,$FF
    db   $03,$43,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FC,$00,$1E,$FC,$FF

    dc   12, $FF

;; Level data for screens 7, 12, 17, 20, 23, 26
;; (all `\` screens)
;; See by DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__stairs_down:
    db   $03,$42,$00,$0A,$30,$32,$00,$1D,$3C,$3F,$FF
    db   $03,$43,$00,$0C,$FE,$00,$1C,$3A,$3B,$3F,$FF
    db   $03,$41,$00,$0C,$FC,$00,$19,$38,$3E,$3B,$3F,$3F,$3B,$FF
    db   $03,$3B,$40,$00,$0D,$31,$32,$00,$16,$3A,$3F,$3E,$3B,$3B,$3E,$3F,$3B,$3F,$FF
    db   $03,$3B,$00,$0F,$FE,$00,$15,$39,$3E,$3E,$3F,$3B,$3F,$3F,$3B,$3E,$3F,$FF
    db   $03,$3F,$40,$00,$0F,$FC,$00,$14,$38,$3F,$3B,$3E,$3B,$3F,$3E,$3B,$3F,$3E,$3E,$FF
    db   $03,$3B,$3E,$41,$00,$10,$30,$32,$00,$14,$3A,$3B,$3F,$3E,$3F,$3F,$3B,$3B,$3E,$3F,$3E,$FF
    db   $03,$3E,$3F,$3B,$3B,$40,$00,$12,$FE,$3F,$3F,$3B,$3E,$3F,$3E,$3B,$3B,$3E,$3F,$3E,$3B,$FF
    db   $03,$3B,$3F,$3F,$3E,$40,$00,$12,$FD,$3B,$3F,$3E,$3B,$3E,$3F,$3F,$3B,$3B,$3F,$3E,$3E,$FF
    db   $03,$3F,$3F,$3E,$3B,$3B,$00,$16,$39,$3B,$3F,$3E,$3F,$3F,$3B,$3B,$3E,$FF
    db   $03,$3F,$3B,$3B,$3E,$40,$00,$15,$FE,$3B,$3E,$3F,$3B,$3E,$3F,$3B,$3E,$3F,$FF
    db   $03,$3B,$3F,$3E,$3E,$3B,$41,$00,$15,$FC,$3E,$3B,$3F,$3E,$3B,$3F,$3E,$3B,$3F,$FF
    db   $03,$3F,$3E,$3E,$3F,$3F,$00,$19,$3A,$3E,$3F,$3B,$3F,$3B,$FF
    db   $03,$3F,$3E,$3F,$3B,$40,$00,$18,$FE,$3B,$3E,$3F,$3F,$3E,$3B,$FF
    db   $03,$3F,$3E,$3E,$3B,$3F,$40,$00,$18,$FC,$3E,$3B,$3E,$3B,$3E,$3F,$FF
    db   $03,$3E,$3B,$3B,$41,$00,$1C,$38,$3F,$3F,$FF
    db   $03,$3F,$3E,$42,$00,$1B,$FE,$3E,$3B,$3B,$FF
    db   $03,$3F,$40,$00,$1B,$FC,$3B,$3E,$3F,$FF
    db   $03,$42,$00,$09,$FE,$00,$1E,$FE,$FF
    db   $03,$43,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FC,$00,$1E,$FC,$FF

    dc   27, $FF

;; Level data for screens 21, 24
;; (all `S_S` screens)
;; See by DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__S_S:
    db   $03,$42,$00,$1D,$3D,$3B,$FF
    db   $03,$41,$00,$0F,$FE,$00,$1B,$FE,$3F,$3E,$3B,$FF
    db   $03,$40,$00,$0F,$FD,$00,$1B,$FD,$3B,$3E,$3F,$FF
    db   $03     ; ...to be continued...
;;; ======END OF BG2.BIN, START OF BG3.BIN ===========
    db   $3F,$43,$00,$0F,$FC,$00,$1B,$FC,$3F,$3E,$3B,$FF
    db   $03,$3E,$3B,$41,$00,$0E,$36,$10,$32,$00,$1B,$38,$3B,$3F,$3E,$FF
    db   $03,$3B,$3E,$3E,$40,$00,$0D,$36,$10,$10,$10,$32,$00,$1A,$3D,$3B,$3B,$3F,$3F,$FF
    db   $03,$3B,$3E,$3E,$40,$00,$0C,$FE,$00,$12,$FE,$00,$18,$FE,$3E,$3F,$3B,$3B,$3E,$3F,$FF
    db   $03,$3F,$3E,$3B,$00,$0C,$FD,$00,$12,$FD,$00,$18,$FD,$3F,$3E,$3B,$3F,$3E,$3B,$FF
    db   $03,$3E,$3B,$41,$00,$0C,$FC,$00,$12,$FC,$00,$18,$FC,$3E,$3F,$3E,$3F,$3B,$3F,$FF
    db   $03,$3F,$42,$00,$19,$3C,$3F,$3E,$3B,$3B,$3F,$FF
    db   $03,$3B,$43,$00,$19,$3A,$3E,$3F,$3E,$3F,$3E,$FF
    db   $03,$3B,$42,$00,$19,$3C,$3B,$3B,$3E,$3B,$3B,$FF
    db   $03,$3F,$3F,$41,$00,$19,$3C,$3F,$3E,$3F,$3B,$3E,$FF
    db   $03,$3E,$43,$00,$1A,$3E,$3F,$3F,$3E,$3B,$FF
    db   $03,$3B,$3B,$40,$00,$0C,$FE,$00,$12,$FE,$00,$18,$FE,$3E,$3F,$3B,$3B,$3F,$3E,$FF
    db   $03,$3F,$00,$0C,$FD,$00,$12,$FD,$00,$18,$FD,$3E,$3E,$3F,$3B,$3F,$3B,$FF
    db   $03,$40,$00,$0C,$FC,$00,$12,$FC,$00,$18,$FC,$3F,$3E,$3B,$3B,$3E,$3F,$FF
    db   $03,$42,$00,$0B,$36,$00,$13,$32,$00,$19,$30,$31,$31,$30,$30,$FE,$FF
    db   $03,$43,$00,$0A,$36,$00,$14,$32,$00,$1E,$FD,$FF
    db   $03,$42,$00,$09,$FE,$00,$15,$FE,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$15,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FC,$00,$15,$FC,$00,$1E,$FC,$FF

    dc   6, $FF

;;; ==========================================
;; Waits 1 vblank, checks if credit is added yet
wait_for_start_button:
    call wait_vblank
    ld   a,(credits)
    and  a
    ret  z
;; credit added!
    call reset_xoff_and_cols_and_sprites
    jp   play_attract_PRESS_P1P2
;;
    dc   10, $FF

;;; ==========================================
;; Level data for screens 3, 6, 9, 11, 14, 22, 25
;; (all `nTn` and `W` levels)
;; See DRAW_SCREEN_FROM_LEVEL_DATA
level_bg__nTn:
    db   $03,$40,$00,$0A,$48,$00,$1E,$39,$FF
    db   $03,$41,$00,$0B,$48,$00,$1D,$3A,$3B,$FF
    db   $03,$3F,$46,$46,$46,$46,$46,$46,$46,$46,$FA,$00,$1B,$FE,$3E,$3F,$3E,$FF
    db   $03,$3E,$40,$44,$44,$44,$44,$44,$44,$44,$F8,$00,$1B,$FD,$3B,$3F,$3E,$FF
    db   $03,$42,$00,$0D,$48,$00,$1B,$FC,$3A,$3B,$3B,$FF
    db   $03,$3B,$3B,$41,$00,$0E,$48,$00,$1B,$3C,$3B,$3E,$3E,$FF
    db   $03,$3B,$3E,$00,$0F,$48,$00,$1B,$3A,$3E,$3F,$3F,$FF
    db   $03,$3F,$3F,$40,$46,$46,$46,$46,$46,$46,$46,$46,$46,$FA,$00,$18,$FE,$10,$10,$39,$3B,$3F,$3F,$FF
    db   $03,$3E,$3B,$3B,$41,$44,$44,$44,$44,$44,$44,$44,$44,$F8,$00,$18,$FD,$3F,$3E,$3B,$3F,$3E,$3B,$FF
    db   $03,$3F,$3B,$3E,$40,$00,$0F,$4A,$00,$18,$FC,$3F,$3F,$3E,$3E,$3B,$3E,$FF
    db   $03,$3B,$3E,$43,$00,$0F,$4A,$00,$1B,$3C,$3E,$3F,$3B,$FF
    db   $03,$3F,$41,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$FA,$00,$1B,$3C,$3B,$3F,$3E,$FF
    db   $03,$40,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$F8,$00,$1C,$39,$3E,$3F,$FF
    db   $03,$42,$00,$0F,$49,$00,$1C,$3C,$3B,$3B,$FF
    db   $03,$41,$00,$0E,$49,$00,$1B,$FE,$3F,$3E,$3B,$FF
    db   $03,$43,$00,$0D,$49,$00,$1B,$FC,$3E,$3F,$3B,$FF
    db   $03,$3F,$41,$46,$46,$46,$46,$46,$46,$46,$FA,$00,$1C,$39,$3E,$3B,$FF
    db   $03,$40,$44,$44,$44,$44,$44,$44,$44,$44,$F8,$00,$1D,$3C,$3F,$FF
    db   $03,$42,$00,$0B,$49,$00,$1E,$3C,$FF
    db   $03,$43,$00,$0A,$49,$00,$1E,$FE,$FF
    db   $03,$42,$00,$09,$FE,$00,$1E,$FD,$FF
    db   $03,$41,$00,$09,$FD,$00,$1E,$FD,$FF
    db   $03,$40,$00,$09,$FC,$00,$1E,$FC,$FF

;;; ==========================================

write_out_0_and_1:
    ld   a,$07
    out  ($00),a
    ld   a,$38
    out  ($01),a
    ret

    dc   15, $FF

;;; ==========================================

update_dino:
    ld   a,(hl)
    ld   (dino_x),a
    inc  hl
    ld   a,(hl)
    ld   (dino_y),a
    inc  hl
    ld   a,$12
    ld   (dino_col),a
    ld   (dino_col_legs),a
    ld   a,(hl) ; anim height (for hiding dino)
    and  $FC ; 1111 1100
    jr   z,_this
    and  $F8 ; 1111 1000
    jr   nz,_22C2
    ld   a,(dino_x)
    sub  $08
    jr   _22C7
_22C2:
    ld   a,(dino_x)
    add  a,$08
_22C7:
    ld   (dino_x_legs),a
    ld   a,(dino_y)
    add  a,$10
    ld   (dino_y_legs),a
    jr   _22D8
_this:
    xor  a
    ld   (dino_x_legs),a
_22D8:
    ld   a,(hl)
    sla  a
    ld   bc,dino_anim_lookup
    add  a,c
    ld   c,a
    ld   a,(bc)
    ld   (dino_frame),a
    inc  bc
    ld   a,(bc)
    ld   (dino_frame_legs),a
    call set_dino_dir
    jp   _23E0

    db   $FF

;;; ==========================================

dino_pathfind_nopslide:
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

;; Check if it's time to start the dino,
;; if started - follow path.
dino_pathfind:
    ld   a,(dino_counter)
    inc  a
    ld   (dino_counter),a
    ld   e,a
    scf
    ccf
    sub  $0B ; 11 ticks till dino time
    ret  c
    ld   a,(player_num) ; start dino!
    and  a
    jr   nz,_2313
    ld   a,(screen_num)
    jr   _2316
_2313:
    ld   a,(screen_num_p2)
_2316:
    dec  a
    ld   hl,dino_path_lookup
    sla  a ; screen # x 2
    add  a,l ; dino_lookup + scr*2
    ld   l,a
    ld   c,(hl)
    inc  hl
    ld   b,(hl)
    ld   a,e ; add dino counter
    sub  $0B
    sla  a
    sla  a
    add  a,c
    ld   l,a
    ld   h,b ; hl points to dino x/y
    call update_dino
    ret

    db   $FF

;;; ==========================================

;; location of path data for each screen
dino_path_lookup:
    db   $78,$23 ;  DINO_PATH_1 (screen1)
    db   $78,$23
    db   $00,$26 ;  DINO_PATH_2
    db   $78,$23
    db   $80,$26 ;  DINO_PATH_3
    db   $00,$27 ;  DINO_PATH_4
    db   $70,$27 ;  DINO_PATH_5
    db   $78,$23
    db   $00,$26
    db   $80,$26
    db   $00,$27
    db   $70,$27
    db   $78,$23
    db   $00,$26
    db   $78,$23
    db   $00,$28 ;  DINO_PATH_6
    db   $70,$27
    db   $78,$23
    db   $00,$28
    db   $70,$27
    db   $00,$2A ;  DINO_PATH_7
    db   $00,$27
    db   $70,$27
    db   $00,$2A
    db   $00,$27
    db   $70,$27
    db   $00,$28 ;  (screen 27)

    dc   10, $0
    dc   8, $FF

;; Nodes for dino to follow: 25 nodes,
;; four bytes per node: [ x, y, fr, _ ]
dino_path_1:
    db   $18,$E0,$00,$00,$1C,$E0,$01,$00
    db   $20,$E0,$02,$00,$28,$E0,$03,$00
    db   $30,$E0,$02,$00,$38,$E0,$01,$00
    db   $48,$C8,$00,$00,$50,$C8,$01,$00
    db   $58,$C8,$02,$00,$60,$C8,$03,$00
    db   $68,$C8,$02,$00,$70,$C8,$03,$00
    db   $80,$C8,$07,$00,$88,$C8,$05,$00
    db   $98,$C8,$03,$00,$A0,$C8,$02,$00
    db   $A8,$C8,$03,$00,$B0,$C8,$02,$00
    db   $B8,$C8,$03,$00,$C0,$C8,$01,$00
    db   $D0,$D0,$07,$00,$D8,$D0,$05,$00
    db   $E0,$D0,$06,$00,$E8,$D0,$05,$00
    db   $F0,$D0,$04,$00,$FF,$FF,$FF,$FF

;;
_23E0:
    ld   a,(dino_x)
    cp   $18
    ret  nz
    ld   a,$07
    ld   (sfx_id),a
    ret

    dc   20, $FF

;;; ==========================================

dino_anim_lookup:
    db   $2F,$00,$2E,$00
    db   $2D,$00,$2C,$00
    db   $2D,$30,$2C,$31
    db   $2D,$32
    db   $2C,$33,$AD,$B0
    db   $AC,$B1,$AD,$B2
    db   $AC,$B3

    dc   8, $FF

;;
copy_inp_to_buttons_and_check_buttons:
    ld   a,(port_in1)
    ld   (input_buttons),a
    ld   a,(port_in2)
    ld   (input_buttons_2),a
    call check_buttons_for_something
    ret

_2430:
    ld   b,$00
_2432:
    ld   a,(watchdog)
    dec  b
    jr   nz,_2432
    ret

    dc   23, $FF

;;; ==========================================

draw_score:
    xor  a
    ld   hl,p1_score
    rrd
    ld   (p1_score_digits+1*$20),a ; digit 2
    rrd
    ld   (p1_score_digits+2*$20),a ; digit 3
    rrd
    inc  l
    rrd
    ld   (p1_score_digits+3*$20),a ; digit 4
    rrd
    ld   (p1_score_digits+4*$20),a ; digit 4
    rrd
    inc  l
    rrd
    ld   (p1_score_digits+5*$20),a ; digit 5
    rrd
    rrd
    xor  a
    ld   (p1_score_digits+0*$20),a ; digit 0 - always 0.
    ld   hl,p2_score
    rrd
    ld   (p2_score_digits+1*$20),a ; digit 1
    rrd
    ld   (p2_score_digits+2*$20),a ; digit 2
    rrd
    inc  l
    rrd
    ld   (p2_score_digits+3*$20),a ; digit 3
    rrd
    ld   (p2_score_digits+4*$20),a ; digit 4
    rrd
    inc  l
    rrd
    ld   (p2_score_digits+5*$20),a ; digit 5
    rrd
    rrd
    xor  a
    ld   (p2_score_digits+0*$20),a ; digit 0 - always 0.
    ld   hl,hiscore
    rrd
    ld   (scr_hiscore+$20),a    ; last digit of highscore
    rrd
    ld   (scr_hiscore+$40),a
    rrd
    inc  l
    rrd
    ld   (scr_hiscore+$60),a
    rrd
    ld   (scr_hiscore+$80),a
    rrd
    inc  l
    rrd
    ld   (scr_hiscore+$A0),a    ; first digit of hiscore
    rrd
    rrd
    xor  a
    ld   (scr_hiscore),a  ; hiscore trailing 0
    call copy_hiscore_name_to_screen_2
    ret

    dc   13, $FF

;;; ==========================================

delay_60_vblanks:
    ld   h,$60
_24E2:
    call wait_vblank
    inc  h
    jr   nz,_24E2
    ret

    dc   3, $FF

;;; ==========================================

delay_8_play_sound:
    push bc
    ld   b,$08
_24EF:
    push bc
    call wait_vblank
    pop  bc
    djnz _24EF
    pop  bc
    ld   a,$0A
    ld   (sfx_id),a
    ret

    dc   3, $FF


;;; ==========================================
;;; Called?

_2500:
    ld   hl,hiscore
_2503:
    ld   (hl),$00
    inc  l
    ld   a,l
    cp   $E1                    ; why e1?
    jr   nz,_2503
    ret

    dc   12, $FF

;;; ==========================================

test_then_dino_collision:
    ld   a,(dino_counter)
    and  $F8
    ret  z
    call dino_collision
    ret

    dc   22, $FF

;; who calls? (free bytes)
;; Appears to draw [21] (the 21 in a box from the level indicators)
;; through a thick horizontal band in the middle of the screen.
;; ... for some reason
unused_draw_d4_everywhere:
    ld   de,$0016 ; +22 each outer loop?
    ld   c,$20
    ld   hl,screen_ram+$10
_j_1:                             ; 32 loops
    ld   b,$0A
_i_1:                             ; 10 loops
    ld   (hl),$D4 ; tile [21] (level indicator number)
    inc  hl
    dec  b
    jr   nz,_i_1
    add  hl,de
    dec  c
    ret  z
    jr   _j_1

    dc   3, $FF

;; (free bytes... if you don't want a cool transition)
;; whoa! Draws some weird spirtal cage flood-fill thing
;; inward spiral fill of screen, then clear.
;; (it's right in the dino code - maybe was supposed to happen
;; if you got caught by a dino, or if you caught the dino)
unused_spiral_cage_fill_transition:
    call reset_xoff_sprites_and_clear_screen
    call wait_vblank
    ld   hl,start_of_tiles
    ld   e,$79
    call _part_two
    ld   hl,scr_unused_spiral
    call _part_two
    ld   hl,screen_ram
    call _part_three
    ld   hl,screen_ram+$1F
    call _part_three
    ld   d,$10
    ld   hl,screen_ram+$61
_lp_2575:
    call _part_four
    call _part_five
    call _part_six
    call _part_seven
    dec  d
    jr   nz,_lp_2575
    call clear_screen
    ret
_part_two:
    ld   (hl),e
    inc  l
    ld   a,l
    and  $1F
    ret  z
    jr   _part_two
    dc   8, $FF
_part_three:
    ld   (hl),e
    ld   bc,$0020
    add  hl,bc
    ld   a,h
    cp   $94
    ret  z
    jr   _part_three
    dc   5, $FF
_part_four:
    call wait_vblank
_25AB:
    ld   (hl),e
    ld   bc,$0020
    add  hl,bc
    ld   a,(hl)
    cp   e
    jr   nz,_25AB
    sbc  hl,bc
    ret
    dc   9, $FF
_part_five:
    call wait_vblank
_25C3:
    ld   (hl),e
    inc  hl
    ld   a,(hl)
    cp   e
    jr   nz,_25C3
    dec  hl
    ret
    dc   5, $FF
_part_six:
    call wait_vblank
    ld   (hl),e
    ld   bc,$0020
    sbc  hl,bc
    ld   a,(hl)
    cp   e
    jr   nz,_part_six
    add  hl,bc
    ret
    dc   9, $FF
_part_seven:
    call wait_vblank
_25EB:
    ld   (hl),e
    dec  hl
    ld   a,(hl)
    cp   e
    jr   nz,_25EB
    inc  hl
    ret
    dc   13, $FF

;; Nodes for dino to follow: 31 nodes,
;; four bytes per node: [ x, y, fr, _ ]
dino_path_2:
    db   $18,$E0,$00,$00,$1C,$E0,$01,$00
    db   $20,$E0,$02,$00,$28,$E0,$03,$00
    db   $30,$E0,$02,$00,$38,$E0,$01,$00
    db   $40,$D8,$02,$00,$48,$D0,$04,$00
    db   $50,$C8,$00,$00,$58,$C8,$01,$00
    db   $60,$C8,$02,$00,$68,$CC,$03,$00
    db   $70,$CC,$02,$00,$70,$C0,$04,$00
    db   $80,$B0,$00,$00,$88,$B0,$01,$00
    db   $90,$B0,$07,$00,$98,$B8,$04,$00
    db   $A0,$C0,$05,$00,$A8,$B8,$06,$00
    db   $B0,$B8,$05,$00,$B8,$B8,$04,$00
    db   $C0,$C8,$07,$00,$C8,$C8,$05,$00
    db   $D0,$D0,$06,$00,$D8,$D0,$04,$00
    db   $E0,$D0,$05,$00,$E8,$D0,$06,$00
    db   $F0,$D0,$05,$00

    dc   12, $FF

;; Nodes for dino to follow: 27 nodes,
;; four bytes per node: [ x, y, fr, _ ]
dino_path_3:
    db   $18,$E0,$00,$00,$20,$E0,$01,$00
    db   $28,$E0,$02,$00,$30,$D0,$04,$00
    db   $38,$C0,$05,$00,$48,$B8,$06,$00
    db   $50,$B8,$04,$00,$58,$A8,$05,$00
    db   $58,$A0,$06,$00,$60,$A0,$04,$00
    db   $68,$90,$05,$00,$70,$88,$06,$00
    db   $78,$88,$04,$00,$80,$78,$05,$00
    db   $88,$70,$06,$00,$90,$70,$04,$00
    db   $98,$60,$05,$00,$A0,$58,$06,$00
    db   $A8,$58,$04,$00,$B0,$48,$05,$00
    db   $B8,$40,$06,$00,$C0,$40,$04,$00
    db   $C8,$30,$05,$00,$D0,$28,$06,$00
    db   $D8,$28,$04,$00,$E0,$28,$05,$00
    db   $E8,$28,$06,$00

    dc   20, $FF

;; Nodes for dino to follow: 24 nodes,
;; four bytes per node: [ x, y, fr, _ ]
dino_path_4:
    db   $18,$38,$00,$00,$20,$38,$01,$00
    db   $28,$38,$02,$00,$30,$38,$03,$00
    db   $38,$38,$07,$00,$40,$40,$04,$00
    db   $48,$40,$05,$00,$50,$40,$06,$00
    db   $58,$40,$04,$00,$68,$58,$05,$00
    db   $70,$58,$06,$00,$78,$58,$04,$00
    db   $80,$58,$05,$00,$88,$58,$06,$00
    db   $90,$58,$04,$00,$98,$58,$05,$00
    db   $A0,$58,$06,$00,$A8,$58,$04,$00
    db   $B8,$40,$05,$00,$C0,$40,$06,$00
    db   $C8,$40,$04,$00,$D0,$30,$05,$00
    db   $D8,$48,$06,$00,$E0,$28,$04,$00

    dc   16, $FF

;; Nodes for dino to follow: 24 nodes,
;; four bytes per node: [ x, y, fr, _ ]
dino_path_5:
    db   $18,$38,$00,$00,$20,$38,$01,$00
    db   $28,$38,$02,$00,$30,$38,$03,$00
    db   $38,$38,$02,$00,$40,$38,$07,$00
    db   $48,$40,$04,$00,$50,$40,$05,$00
    db   $58,$40,$06,$00,$60,$58,$04,$00
    db   $68,$58,$05,$00,$70,$58,$06,$00
    db   $78,$70,$04,$00,$80,$70,$05,$00
    db   $88,$70,$06,$00,$90,$88,$04,$00
    db   $98,$88,$05,$00,$A0,$88,$06,$00
    db   $A8,$A0,$04,$00,$B0,$A0,$05,$00
    db   $B8,$A0,$06,$00,$C0,$B8,$04,$00
    db   $C8,$B8,$05,$00,$D0,$B8,$06,$00
    db   $D8,$D0,$04,$00,$E0,$D0,$05,$00

    dc   8, $FF

;;; ==========================================
;;;
set_player_y_level_start:
    ld   a,(player_y)
    scf
    ccf
    add  a,$60 ; at top of screen?
    jr   nc,_27F4
    ld   a,$D0 ; no, set to bottom
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    ret
_27F4:
    ld   a,$28 ; yes, set to top
    ld   (player_y),a
    add  a,$10
    ld   (player_y_legs),a
    ret
;;;
    db   $FF

;; Nodes for dino to follow
;; four bytes per node: [ x, y, fr, _ ]
dino_path_6:
    db   $18,$E0,$00,$00,$20,$E0,$01,$00
    db   $28,$E0,$02,$00,$30,$D0,$04,$00
    db   $38,$D0,$05,$00,$40,$B8,$05,$00
    db   $48,$B8,$06,$00,$50,$B8,$04,$00
    db   $58,$B8,$05,$00,$60,$B8,$06,$00
    db   $68,$B8,$04,$00,$68,$A0,$05,$00
    db   $70,$A0,$06,$00,$78,$A0,$04,$00
    db   $80,$A0,$05,$00,$88,$A0,$06,$00
    db   $90,$A0,$04,$00,$98,$A0,$05,$00
    db   $A0,$88,$06,$00,$B0,$88,$04,$00
    db   $B0,$88,$08,$00,$A8,$88,$09,$00
    db   $A0,$88,$0A,$00,$90,$70,$08,$00
    db   $88,$70,$09,$00,$80,$70,$0A,$00
    db   $78,$70,$08,$00,$70,$70,$09,$00
    db   $68,$60,$0A,$00,$60,$58,$08,$00
    db   $58,$58,$09,$00,$50,$58,$0A,$00
    db   $48,$58,$04,$00,$50,$58,$05,$00
    db   $58,$58,$06,$00,$60,$58,$04,$00
    db   $68,$58,$05,$00,$70,$48,$06,$00
    db   $78,$40,$04,$00,$80,$40,$05,$00
    db   $88,$40,$06,$00,$90,$40,$04,$00
    db   $98,$40,$05,$00,$A0,$38,$06,$00
    db   $A8,$30,$04,$00,$B0,$28,$05,$00
    db   $B8,$28,$06,$00,$C0,$28,$04,$00
    db   $C8,$28,$05,$00,$D0,$28,$06,$00
    db   $D8,$28,$04,$00,$E0,$28,$05,$00

    dc   16, $FF

;;; ==========================================

move_dino_x:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(dino_x)
    and  a
    ret  z ; no dino out, leave
    ld   b,a
    ld   a,(dino_dir)
    add  a,b
    ld   (dino_x),a
    ld   a,(dino_x_legs)
    and  a
    ret  z
    ld   b,a
    ld   a,(dino_dir)
    add  a,b
    ld   (dino_x_legs),a
    ret

;;; ==========================================
;;; Called from NMI: so maybe this is the bit that
;;; plays the current samples of sfx
player_all_sfx_chunks:
    ld   hl,sfx_sumfin_0 - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    call reset_sfx_ids
    ld   hl,sfx_sumfin_1 - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ld   hl,sfx_sumfin_2 - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    call reset_sfx_ids
    ld   hl,sfx_queuer - JMP_HL_OFFSET
    jr   call_sfx_queuer_and_reset_sfx_ids

    dc   2, $FF

;;; ==========================================
;;
set_dino_dir:
    inc  hl
    inc  hl
    ld   b,(hl) ; read DINO_PATH_X
    ld   a,(dino_x)
    scf
    ccf
    sub  b
    jr   c,_292F ; reset
    ld   a,$FF
    jr   _2931
_292F:
    ld   a,$01
_2931:
    ld   (dino_dir),a
    ret

    dc   11, $FF

;;; ==========================================

call_sfx_queuer_and_reset_sfx_ids:
    call jmp_hl_plus_4k ; hl+4k = sfx_queuer
    call reset_sfx_ids
    ret

    dc   25, $FF

call_player_all_sfx_chunks:
    push ix
    call player_all_sfx_chunks
    pop  ix
    ret

    dc   24, $FF

got_a_bonus:
    ld   a,(bonuses)
    inc  a
    ld   (bonuses),a
    cp   $01
    jr   nz,_gab_2
    ld   a,tile_bonus_00_tr
    ld   (scr_bonus_sq+$00),a ; uncovering bonus red squares
    ret
_gab_2:
    cp   $02
    jr   nz,_gab_3
    ld   a,tile_bonus_00_br
    ld   (scr_bonus_sq+$01),a
    ret
_gab_3:
    cp   $03
    jr   nz,_gab_4
    ld   a,tile_bonus_00_tl
    ld   (scr_bonus_sq+$20),a
    ret
_gab_4:
    cp   $04
    jr   nz,_gab_5
    ld   a,tile_bonus_00_bl
    ld   (scr_bonus_sq+$21),a
    ret
_gab_5:
    cp   $05
    jr   nz,_gab_6
    ld   a,(bonus_mult)
    ld   hl,bonus_multplier_data
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (scr_bonus_sq+$40),a
    ret
;; 6 Bonuses got!
_gab_6:
    ld   a,(bonus_mult)
    ld   hl,bonus_multplier_data + 4
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (scr_bonus_sq+$41),a
    call do_bonus_flashing
    ld   c,$0A ; 10x
_gab_flash:
    ld   a,(bonus_mult)
    ld   b,a
    inc  b
_29D6:
    ld   a,$A0 ; 1000 in bdc
    ld   (score_to_add),a
    push bc
    call add_score
    pop  bc
    call delay_8_play_sound
    djnz _29D6
    dec  c
    jr   nz,_gab_flash
    ld   a,(bonus_mult)
    inc  a
    cp   $04 ; Cap bonus to 4x
    jr   nz,_gab_mult
    ld   a,$03
_gab_mult:
    ld   (bonus_mult),a
    xor  a
    ld   (bonuses),a
    call draw_bonus
    call bonus_skip_screen
    ret

;; Nodes for dino to follow
;; four bytes per node: [ x, y, fr, _ ]
dino_path_7:
    db   $18,$E0,$00,$00,$20,$E0,$01,$00
    db   $28,$E0,$02,$00,$30,$E0,$03,$00
    db   $38,$D0,$04,$00,$40,$C0,$05,$00
    db   $48,$B8,$06,$00,$48,$B8,$04,$00
    db   $50,$B8,$05,$00,$58,$B8,$06,$00
    db   $60,$B8,$04,$00,$68,$B0,$00,$00
    db   $70,$B0,$01,$00,$78,$B0,$02,$00
    db   $80,$B0,$03,$00,$88,$B8,$02,$00
    db   $98,$B8,$03,$00,$A8,$B8,$02,$00
    db   $B0,$B0,$03,$00,$B8,$B0,$02,$00
    db   $C0,$B0,$03,$00,$C8,$A0,$04,$00
    db   $D0,$90,$05,$00,$D8,$88,$06,$00
    db   $E0,$88,$08,$00,$D0,$88,$09,$00
    db   $D8,$80,$0A,$00,$C0,$70,$08,$00
    db   $B8,$70,$09,$00,$B0,$70,$0A,$00
    db   $90,$70,$08,$00,$80,$70,$09,$00
    db   $78,$70,$0A,$00,$70,$70,$08,$00
    db   $68,$70,$09,$00,$60,$60,$0A,$00
    db   $58,$58,$08,$00,$50,$58,$04,$00
    db   $58,$58,$05,$00,$60,$48,$06,$00
    db   $68,$40,$04,$00,$70,$40,$05,$00
    db   $78,$40,$06,$00,$80,$40,$04,$00
    db   $90,$40,$05,$00,$B0,$40,$06,$00
    db   $B8,$40,$04,$00,$C0,$40,$05,$00
    db   $C8,$40,$06,$00,$D0,$38,$04,$00
    db   $D8,$30,$05,$00,$E0,$28,$06,$00

;;; ==========================================

draw_bonus_state:
    call draw_bonus
    ld   a,(bonuses)
    ld   e,a
    xor  a
    ld   (bonuses),a
    ld   a,e
    and  a
    ret  z
_dbs_clear:
    call got_a_bonus ; clear out "got" bonuses
    dec  e
    jr   nz,_dbs_clear
    ret

    dc   27, $FF

;;; ==========================================

;; who calls? (free bytes)
    ld   a,(_8093)
    ld   b,a
    xor  a
    ld   (_8093),a
    ld   a,b
    and  a
    jr   nz,_done_2B14
    ld   a,(_8094)
    ld   b,a
    xor  a
    ld   (_8094),a
_done_2B14:
    ret

    dc   11, $FF

;;; ==========================================

;; who calls? (free bytes?)
    ld   b,a
    and  $F0
    jr   nz,_2B28
    xor  a
    jr   _2B3A
_2B28:
    cp   $10
    jr   nz,_2B30
    ld   a,$0A
    jr   _2B3A
_2B30:
    cp   $20
    jr   nz,_2B38
    ld   a,$14
    jr   _2B3A
_2B38:
    ld   a,$1E
_2B3A:
    ld   c,a
    ld   a,b
    and  $0F
    add  a,c
    ret

    dc   16, $FF

;;; ==========================================
;; Run enemy update subs, based on current screen
update_enemies:
    ld   a,(player_num)
    and  a
    jr   nz,_2B5B
    ld   a,(screen_num)
    jr   _2B5E
_2B5B:
    ld   a,(screen_num_p2)
_2B5E:
    dec  a ; scr#-1
    sla  a ; * 2
    sla  a ; * 2
    call jump_rel_a
    nop ; scr 1
    nop
    nop
    ret
    call enemy_pattern_scr_2
    ret
    nop ; scr 3
    nop
    nop
    ret
    call enemy_pattern_scr_4
    ret
    nop ; scr 5
    nop
    nop
    ret
    nop ; scr 6
    nop
    nop
    ret
    nop ; scr 7
    nop
    nop
    ret
    call enemy_pattern_scr_8
    ret
    call enemy_pattern_scr_9
    ret
    call enemy_pattern_scr_10
    ret
    call _3398 ; scr 11
    ret
    call _3470 ; scr 12
    ret
    call _3538 ; scr 13
    ret
    call _35B8 ; scr 14
    ret
    call _3658 ; scr 15
    ret
    nop ; scr 16
    nop
    nop
    ret
    call _3670 ; scr 17
    ret
    call _36D0 ; scr 18
    ret
    call _3760 ; scr 19
    ret
    call _37E8 ; scr 20
    ret
    nop ; scr 21
    nop
    nop
    ret
    call _3808 ; scr 22
    ret
    call _3868 ; scr 23
    ret
    call _3B68 ; scr 24
    ret
    call _3888 ; scr 25
    ret
    call enemy_pattern_scr_26
    ret
    call _3888 ; scr 27
    ret
    nop ; scr ?
    nop
    nop
    ret
    nop ; scr ?
    nop
    nop
    ret
    nop ; scr ?
    nop
    nop
    ret
    nop ; scr ?
    nop
    nop
    ret
    nop ; scr ? (32)
    nop
    nop
    ret

    dc   10, $FF

enemy_pattern_scr_10:
    call update_stair_up_blue_timer
    call _32F0
    ret

    dc   9, $FF

set_rock_1_b0_40:
    ld   a,$B0
    ld   (enemy_1_x),a
    ld   a,$40
    ld   (enemy_1_y),a
    ld   a,$1D
    ld   (enemy_1_frame),a
    ld   a,$15
    ld   (enemy_1_col),a
    ld   a,$01
    ld   (enemy_1_active),a
    ret

    dc   14, $FF

rock_fall_1:
    ld   a,(tick_mod_slow)
    and  $07
    ret  nz
    ld   a,(rock_fall_timer)
    inc  a
    cp   $0E ; has rock finished falling?
    jr   nz,_2C37
    xor  a ; reset
_2C37:
    ld   (rock_fall_timer),a
    and  a
    ret  nz
    call set_rock_1_b0_40
    ret

    dc   8, $FF

;;; ==========================================

enemy_pattern_scr_2:
    call rock_fall_1
    call update_enemy_1
    ret

    dc   9, $FF

;;; ==========================================

enemy_pattern_scr_4:
    call rock_fall_1
    call update_enemy_1
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    ret

    dc   11, $FF

;;; ==========================================
;;
hiscore_check_buttons:
    ld   a,(input_buttons)
    ld   b,a
    ld   a,(_9184)
    cp   $01
    jr   z,_2C7F
    bit  7,b
    jr   nz,_2C88
_2C7F:
    ld   a,(port_in0)
    bit  5,a ; jump?
    call nz,hiscore_select_letter
    ret
_2C88:
    bit  5,b ; jump?
    call nz,hiscore_select_letter
    ret

    dc   10, $FF

;;; ==========================================

enemy_pattern_scr_8:
    call rock_fall_1
    call update_enemy_1
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    call update_rock_left_timer
    call set_rock_3_fr_and_y
    ret

    dc   5, $FF

;;; ==========================================
;; wonder what this was for? No paths call anything
;; maybe a debug tool?
;; -- i've stolen this area for OGNOB mode.
nopped_out_dispatch:
    ld   a,(player_num)
    and  a
    jr   nz,_2CBB
    ld   a,(screen_num)
    jr   _2CBE
_2CBB:
    ld   a,(screen_num_p2)
_2CBE:
    dec  a ; scr - 1
    and  $07 ; & 0000 0111
    sla  a ; * 4
    sla  a
    call jump_rel_a
;; all nops, no calls...
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

    dc   16, $FF

;;; ==========================================

set_hiscore_and_reset_game:
    ld   hl,hiscore
    ld   a,(p1_score)
    cp   (hl)
    jr   nz,_2D1D
    inc  hl
    ld   a,(p1_score_1)
    cp   (hl)
    jr   nz,_2D1D
    inc  hl
    ld   a,(p1_score_2)
    cp   (hl)
    jr   nz,_2D1D
    call p1_got_hiscore
_2D1A:
    jp   clear_after_game_over
_2D1D:
    ld   hl,hiscore
    ld   a,(p2_score)
    cp   (hl)
    jr   nz,_2D1A
    inc  hl
    ld   a,(p2_score_1)
    cp   (hl)
    jr   nz,_2D1A
    inc  hl
    ld   a,(p2_score_2)
    cp   (hl)
    jr   nz,_2D1A
    call p2_got_hiscore
    jp   clear_after_game_over

    dc   14, $FF

p1_got_hiscore:
    xor  a
    ld   (_B006),a
    ld   (_B007),a
    ld   a,$01
    call enter_hiscore_screen
    ret

    dc   3, $FF

p2_got_hiscore:
    ld   a,(input_buttons)
    bit  7,a ; hmm what is bit 7 button?
    jr   z,_2D69
    ld   a,$01
    ld   (_B006),a
    ld   (_B007),a
    jr   _2D70
_2D69:
    xor  a
    ld   (_B006),a
    ld   (_B007),a
_2D70:
    ld   a,$02
    call enter_hiscore_screen
    ret

    dc   18, $FF

;;; ==========================================

enter_hiscore_screen:
    push af
    ld   hl,sfx_reset_a_bunch - JMP_HL_OFFSET
    call jmp_hl_plus_4k
    ld   a,$09 ; extra life /hiscore sfx
    ld   (ch1_sfx),a
    nop
    call reset_xoff_sprites_and_clear_screen
    call _37B8
    ld   hl,header_text_data
    call draw_screen ; draws the hiscore screen..
    db   $00, $00 ; params to DRAW_SCREEN
    call draw_tiles_h
    db   $04,$0A
    db   P_,L_,A_,Y_,E_,R_,$FF ;  PLAYER
    call draw_tiles_h
    db   $07,$03 ;  YOU BEAT THE HIGHEST
    db   Y_,O_,U_,__,B_,E_,A_,T_,__,T_,H_,E_,__,H_,I_,G_,H_,E_,S_,T_,$FF
    call draw_tiles_h
    db   $09,$03 ;  SCORE OF THE DAY
    db   S_,C_,O_,R_,E_,__,O_,F_,__,T_,H_,E_,__,D_,A_,Y_,$FF
    call draw_tiles_h
    db   $0B,$03
    db   P_,L_,E_,A_,S_,E_,__,E_,N_,T_,E_,R_,__,Y_,O_,U_,R_,__,N_,A_,M_,E_,$FF
    call draw_tiles_h
    db   $0D,$03
;; drawing the alphabet A-L
    db   A_,__,B_,__,C_,__,D_,__,E_,__,F_,__
    db   G_,__,H_,__,I_,__,J_,__,K_,__,L_,$FF
    call draw_tiles_h
    db   $0F,$03
;; drawing the alphabet M-X
    db   M_,__,N_,__,O_,__,P_,__,Q_,__,R_,__
    db   S_,__,T_,__,U_,__,V_,__,W_,__,X_,$FF
    call draw_tiles_h
    db   $11,$03
;; Y,Z... characters
    db   Y_,__,Z_,__,__,__,__,__,__,__
    db   $51,__,$52,__,$53,__,__,__,__,__ ; Circles
    db   $58,$59,$5A,$5B,$FF              ; Rub End
    call draw_tiles_h
    db   $17,$0A
    dc   10, tile_hyphen
    db   $FF
    call draw_score
    ld   a,$09 ; 90 seconds timer
    ld   (scr_hs_timer+$20),a       ; second digit
    xor  a
    ld   (scr_hs_timer+$00),a ; first digit
    ld   (hiscore_timer),a
    pop  af
    ld   iy,scr_hi_name_entry
    ld   (_9184),a ; something else on screen...
    call hiscore_clear_name
    ld   hl,scr_cursor_line_hs
set_cursor:
    ld   (hl),tile_cursor
    ld   ix,input_buttons
    ld   a,(_9184) ; read from screen set above?
    cp   $01 ; p1 (maybe)?
    jr   z,_2E93
    bit  7,(ix+$00)
    jr   nz,_2E97
_2E93:
    ld   ix,port_in0
_2E97:
    bit  3,(ix+$00) ; right?
    jr   z,_2EA0
    call hiscore_fwd_cursor
_2EA0:
    bit  2,(ix+$00) ; left?
    jr   z,_2EA9
    call hiscore_back_cursor
_2EA9:
    call hiscore_check_buttons
    nop
    nop
    nop
    nop
    nop
    nop
_check_if_letters_full:
    push hl
    push iy
    pop  hl
    ld   a,$37
    cp   l
    jr   nz,_2EC0
    ld   a,$91 ; 9137 = last letter pos
    cp   h
    jr   z,_done_2EC8
_2EC0:
    pop  hl
    ld   (hl),tile_cursor ; useless? Done in SET_CURSOR
    call hiscore_enter_timer
    jr   set_cursor
_done_2EC8:
    pop  hl
    call pop_hls_then_copy_hiscore_name
    ret

    dc   11, $FF

;;; ==========================================
;; called when entered a letter on name
hiscore_select_letter:
    ld   a,$10
    ld   (_8093),a
    ld   a,$90 ; did we press "end"?
    cp   h
    jr   nz,_enter_letter
    ld   a,$92
    cp   l
    jr   nz,_2EEB ; no!
    call pop_hls_then_copy_hiscore_name
    ret
_2EEB:
    ld   a,$D2 ; how about "rub"?
    cp   l
    jr   nz,_enter_letter ; nope...
    call hiscore_rub_letter
    ret
_enter_letter:
    dec  hl
    ld   a,(hl)
    inc  hl
    ld   (iy+$00),a ; draws letter on screen
    ld   de,scr_line_prev
    add  iy,de
    ret

    dc   16, $FF

;;; ==========================================

pop_hls_then_copy_hiscore_name:
    xor  a
    ld   (_8086),a
    pop  hl
    pop  hl
    call copy_hiscore_name_to_screen
    ret

    dc   6, $FF

;;; ==========================================

hiscore_rub_letter:
    ld   de,$0020
    add  iy,de
    ld   (iy+$00),$2B
    ld   a,$10
    ld   (scr_hi_name_entry+$20),a
    push hl
    push iy
    pop  hl
    ld   a,$92 ; 9297 = first letter pos
    cp   h
    jr   nz,_2F3C
    ld   a,$97
    cp   l
    jr   z,_2F3E
_2F3C:
    pop  hl
    ret
_2F3E:
    ld   de,scr_line_prev
    add  iy,de
    pop  hl
    ret

    dc   11, $FF

;;; ==========================================

hiscore_back_cursor:
    ld   (hl),$10
    ld   de,$0040
    add  hl,de
    ld   a,$93
    cp   h
    ret  nz
    ld   a,$92
    cp   l
    jr   nz,_2F63
    ld   hl,scr_hi_under_X
    ret
_2F63:
    ld   a,$90
    cp   l
    jr   nz,_2F6C
    ld   hl,_908E
    ret
_2F6C:
    ld   a,$8E
    cp   l
    ret  nz
    ld   hl,_9092
    ret

    dc   20, $FF

;;; ==========================================

hiscore_clear_name:
    push hl
    ld   hl,hiscore_name ; default is "HI-SCORE", clearing...
_2F8C:
    ld   (hl),tile_blank
    inc  hl
    ld   a,l
    cp   $11
    jr   nz,_2F8C
    pop  hl
    ret

    dc   3, $FF
    rra ; weird 0x1F. Dump error?
    dc   14, $FF

;;; ==========================================
;;
hiscore_fwd_cursor:
    ld   a,$10
    ld   (_8093),a
    ld   (hl),$10
    ld   de,$0040
    sbc  hl,de
    ld   a,$90
    cp   h
    ret  nz
    ld   a,$4E
    cp   l
    jr   nz,_2FC1
    ld   hl,scr_cursor_line_hs+$2 ; wrap line 1
    ret
_2FC1:
    ld   a,$50
    cp   l
    jr   nz,_2FCA
    ld   hl,scr_cursor_line_hs+$4 ; wrap line 2
    ret
_2FCA:
    ld   a,$52
    cp   l
    ret  nz
    ld   hl,scr_cursor_line_hs ; wrap line 3
    ret

    dc   3, $FF

_2FD5:
    call copy_hiscore_name_to_screen_2
    call delay_60_vblanks
    call reset_xoff_sprites_and_clear_screen
    ret

    db   $FF

;;; ==========================================

copy_hiscore_name_to_screen:
    ld   hl,hiscore_name
    ld   a,(scr_hi_name_entry-0*$20) ; char 1
    ld   (hl),a
    ld   a,(scr_hi_name_entry-1*$20) ; char 2
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-2*$20) ; char 3
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-3*$20) ; char 4
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-4*$20) ; char 5
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-5*$20) ; char 6
    inc  hl
    ld   (hl),a
;;; === END OF BG3.BIN, START OF BG4.BIN ======
    ld   a,(scr_hi_name_entry-6*$20) ; char 7
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-7*$20) ; char 8
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-8*$20) ; char 9
    inc  hl
    ld   (hl),a
    ld   a,(scr_hi_name_entry-9*$20) ; char 10
    inc  hl
    ld   (hl),a
    call _30C0
    call _2FD5
    jp   clear_after_game_over

    dc   3, $FF

    ld   c,$05
_3022:
    call wait_vblank
    dec  c
    jr   nz,_3022
    ret

    dc   15, $FF

;;; ==========================================
;; writes some chars to screen
;; actually - different screen loc than copy_msg 1!
copy_hiscore_name_to_screen_2:
    ld   a,(hiscore_name+0)
    ld   (scr_hi_name-0*$20),a   ; char 1
    ld   a,(hiscore_name+1)
    ld   (scr_hi_name-1*$20),a   ; char 2
    ld   a,(hiscore_name+2)
    ld   (scr_hi_name-2*$20),a   ; char 3
    ld   a,(hiscore_name+3)
    ld   (scr_hi_name-3*$20),a   ; char 4
    ld   a,(hiscore_name+4)
    ld   (scr_hi_name-4*$20),a   ; char 5
    ld   a,(hiscore_name+5)
    ld   (scr_hi_name-5*$20),a   ; char 6
    ld   a,(hiscore_name+6)
    ld   (scr_hi_name-6*$20),a   ; char 7
    ld   a,(hiscore_name+7)
    ld   (scr_hi_name-7*$20),a   ; char 8
    ld   a,(hiscore_name+8)
    ld   (scr_hi_name-8*$20),a   ; char 9
    ld   a,(hiscore_name+9)
    ld   (scr_hi_name-9*$20),a   ; char 10
    ret

    dc   11, $FF

;;; ==========================================
;; Writes HIGH-SCORE to bytes (later to screen)
set_hiscore_text:
    ld   hl,hiscore_name
    ld   (hl),$18 ; h
    inc  hl
    ld   (hl),$19 ; i
    inc  hl
    ld   (hl),$17 ; g
    inc  hl
    ld   (hl),$18 ; h
    inc  hl
    ld   (hl),tile_hyphen
    inc  hl
    ld   (hl),$23 ; s
    inc  hl
    ld   (hl),$13 ; c
    inc  hl
    ld   (hl),$1F ; o
    inc  hl
    ld   (hl),$22 ; r
    inc  hl
    ld   (hl),$15 ; e
;; set default hiscore
    ld   hl,hiscore
    ld   (hl),$00
    inc  hl
    ld   (hl),$05
    inc  hl
    ld   (hl),$00
    inc  hl
    ret

    dc   19, $FF

;;; ==========================================

_30C0:
    ld   c,$00
    ld   hl,hiscore_name+9
_30C5:
    ld   a,(hl)
    cp   $2B
    jr   nz,_30D8
    ld   (hl),$10
    dec  hl
    ld   a,(hl)
    cp   $2B
    jr   nz,_30D8
    ld   (hl),$10
    dec  hl
    inc  c
    jr   _30C5
_30D8:
    ld   a,c
    and  a
    ret  z
    dec  c
    call _30E8
    jr   _30D8

    dc   7, $FF

;;; ==========================================

_30E8:
    ld   d,$0A              ;hiscore name length
    ld   ix,hiscore_name+$08
_30EE:
    ld   a,(ix+$00)
    ld   (ix+$01),a
    dec  d
    dec  ix
    jr   nz,_30EE
    ld   a,tile_blank
    ld   (hiscore_name),a
    ret

    dc   9, $FF

;;; ==========================================
;;
hiscore_enter_timer:
    push hl
    push bc
    push iy
    push ix
    ld   c,$14
_3110:
    call wait_vblank
    dec  c
    jr   nz,_3110
    ld   a,(hiscore_timer2)
    inc  a
    ld   (hiscore_timer2),a
    and  $01
;; Bug! Jumps to middle of instruction! 0x93 = `sub e, rld (hl)`
;; I think maybe should be $3138? (28 17 instead of 28 14)
;; (hl) points to the cursor pos. `rld (hl)` makes the cursor into a "0" (tile 0x90),
;; but you don't see a visual glitch: because the cursor is re-drawn just
;; immediately after this sub returns ($2E80)
    jr   z,$3135
    ld   hl,hiscore_timer
    ld   a,(hl)
    dec  a
    daa
    call z,pop_hls_then_copy_hiscore_name
    ld   (hl),a ; load a into $HISCORE_TIMER
    xor  a
    rld
    ld   (scr_hs_timer+$20),a ; Timer countdown char 1
    rld
    ld   (scr_hs_timer+$00),a ; Timer countdown char 2
    rld
    pop  ix
    pop  iy
    pop  bc
    pop  hl
    ret

    db   $FF

;;; ==========================================

;; load rock pos (reset rock pos?)
update_enemy_1:
    ld   a,(enemy_1_active)
    and  a
    ret  z ; enemy not alive, return
;;  Move rock according to lookup table
    inc  a
    cp   $3C
    jr   nz,_314B
    xor  a
_314B:
    ld   (enemy_1_active),a
    ld   hl,rock_fall_lookup ; list of [frame,y pos]
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (enemy_1_frame),a
    inc  hl
    ld   a,(hl)
    ld   (enemy_1_y),a
    ret

    dc   9, $FF

;;; ==========================================

;; looks the same as 1?
enemy_pattern_scr_9:
    call rock_fall_1
    call update_enemy_1
    ret

    dc   17, $FF

;; ha, every frame is a lookup (like the jump table)
;; Format is: [frame, y pos]
rock_fall_lookup:
    db   $00,$00
    db   $1D,$52,$1D,$54,$1D,$56,$1D,$58
    db   $1D,$5A,$1D,$5C,$1D,$5E,$1D,$60
    db   $1D,$62,$1D,$64,$1D,$66,$1D,$68
    db   $1D,$6A,$1D,$6C,$1D,$6E,$1D,$71
    db   $1D,$73,$1D,$75,$1D,$78,$1D,$7A
    db   $1D,$7C,$1D,$7F,$1D,$81,$1D,$83
    db   $1D,$86,$1D,$88,$1D,$8A,$1D,$8D
    db   $1D,$8F,$1D,$91,$1D,$94,$1D,$96
    db   $1D,$98,$1D,$9B,$1D,$9D,$1D,$9F
    db   $1D,$A2,$1D,$A4,$1D,$A6,$1D,$AB
    db   $1D,$AD,$1D,$AF,$1D,$B2,$1D,$B4
    db   $1D,$B6,$1D,$B9,$1D,$BB,$1D,$BD
    db   $1D,$C0,$1D,$C2,$1D,$C4,$1D,$C6
    db   $1D,$C8,$1D,$CA,$1D,$CC,$1D,$CE
    db   $1E,$CE,$1F,$CE,$20,$CE,$21,$CE
    db   $21,$CE,$21,$CE

    dc   18, $FF

;;; ==========================================

set_bird_left_y_c4:
    ld   a,$F0
    ld   (enemy_2_x),a
    ld   a,$C4
    ld   (enemy_2_y),a
    ld   a,fr_bird_1
    ld   (enemy_2_frame),a
    ld   a,$16
    ld   (enemy_2_col),a
    ld   a,$01
    ld   (enemy_2_active),a
    ret

    dc   14, $FF

;;; ==========================================

wrap_bird_left_y_c4:
    ld   a,(enemy_2_x)
    and  a
    jr   z,_324D
    cp   $01
    jr   z,_324D
    cp   $02
    jr   z,_324D
    cp   $03
    jr   z,_324D
    cp   $04
    ret  nz
_324D:
    call set_bird_left_y_c4
    ret

    dc   15, $FF

;;; ==========================================

move_animate_bird_left:
    ld   a,(tick_mod_fast)
    and  $01
    ret  z
    ld   a,(enemy_2_active)
    and  a
    ret  z
    ld   a,(enemy_2_x) ; move left
    dec  a
    dec  a
    dec  a
    ld   (enemy_2_x),a
    ld   a,(tick_mod_fast)
    and  $02
    ret  nz
_animate_bird:
    ld   a,(enemy_2_frame)
    cp   fr_bird_1
    jr   nz,_3287
    ld   a,fr_bird_2
    ld   (enemy_2_frame),a
    ret
_3287:
    ld   a,fr_bird_1
    ld   (enemy_2_frame),a
    ret

    dc   35, $FF

;;; ==========================================

set_blue_meanie_a0_d0:
    ld   a,$A0
    ld   (enemy_1_x),a
    ld   a,$D0
    ld   (enemy_1_y),a
    ld   a,$17
    ld   (enemy_1_col),a
    ld   a,fr_blue_1
    ld   (enemy_1_frame),a
    ld   a,$01
    ld   (enemy_3_active),a ; why enemy_3?
    ret

    dc   6, $FF

;;; ==========================================

update_stair_up_blue_timer:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_2_timer)
    inc  a
    cp   $20
    jr   nz,_32DF
    xor  a
_32DF:
    ld   (enemy_2_timer),a
    and  a
    ret  nz
    call set_blue_meanie_a0_d0
    ret

    dc   8, $FF

;;; ==========================================

_32F0:
    ld   a,(enemy_3_active)
    and  a
    ret  z
    inc  a
    cp   $81
    jr   nz,_32FB
    xor  a
_32FB:
    ld   (enemy_3_active),a
    ld   b,a
    scf
    ccf
    sub  $40
    jr   nc,_3309
    call _3318
    ret
_3309:
    call _3340
    ret

    dc   11, $FF

;; blue-meanie up?
_3318:
    ld   a,(enemy_1_y) ; move up?
    dec  a
    dec  a
    ld   (enemy_1_y),a
    and  $03
    ret  nz
    ld   a,(enemy_1_frame)
    cp   fr_blue_1
    jr   z,_3330
    ld   a,fr_blue_1
    ld   (enemy_1_frame),a
    ret
_3330:
    ld   a,fr_blue_2
    ld   (enemy_1_frame),a
    ret

    dc   10, $FF

;; blue-meanie down?
_3340:
    ld   a,(enemy_1_y) ; move down?
    inc  a
    inc  a
    ld   (enemy_1_y),a
    ld   a,fr_blue_1
    ld   (enemy_1_frame),a
    ret

    dc   10, $FF

set_bird_left_y_40:
    ld   a,$F0
    ld   (enemy_2_x),a
    ld   a,$40
    ld   (enemy_2_y),a
    ld   a,fr_bird_1
    ld   (enemy_2_frame),a
    ld   a,$16
    ld   (enemy_2_col),a
    ld   a,$01
    ld   (enemy_2_active),a
    ret

    dc   6, $FF

;; if x pos < 4 then wrap the bird
wrap_bird_left_y_40:
    ld   a,(enemy_2_x)
    and  a
    jr   z,_wrap_bird_1
    cp   $01
    jr   z,_wrap_bird_1
    cp   $02
    jr   z,_wrap_bird_1
    cp   $03
    jr   z,_wrap_bird_1
    cp   $04
    ret  nz
_wrap_bird_1:
    call set_bird_left_y_40
    ret

    dc   7, $FF

;;; ==========================================

_3398:
    call wrap_bird_left_y_40
    call move_animate_bird_left
    ret

    dc   9, $FF

    call update_stair_up_blue_timer
    call _32F0
    ret

    dc   9, $FF

_33B8:
    ld   a,(enemy_3_active)
    and  a
    ret  z
    inc  a
    cp   $81
    jr   nz,_33C3
    xor  a
_33C3:
    ld   (enemy_3_active),a
    ld   b,a
    scf
    ccf
    sub  $40
    jr   nc,_33D1
    call _33D8
    ret
_33D1:
    call _3400
    ret

    dc   3, $FF

_33D8:
    ld   a,(enemy_1_y)
    dec  a
    dec  a
    ld   (enemy_1_y),a
    and  $03
    ret  nz
    ld   a,(enemy_1_frame)
    cp   fr_blue_1
    jr   nz,_33F0
    ld   a,fr_blue_2
    ld   (enemy_1_frame),a
    ret
_33F0:
    ld   a,fr_blue_1
    ld   (enemy_1_frame),a
    ret

    dc   10, $FF

_3400:
    ld   a,(enemy_1_y)
    inc  a
    inc  a
    ld   (enemy_1_y),a
    ret

    dc   15, $FF


_3418:
    ld   a,(enemy_4_active)
    and  a
    ret  z
    inc  a
    cp   $61
    jr   nz,_3423
    xor  a
_3423:
    ld   (enemy_4_active),a
    ld   b,a
    scf
    ccf
    sub  $30
    jr   nc,_3431
    call _3438
    ret
_3431:
    call _3458
    ret

    dc   3, $FF

_3438:
    ld   a,(enemy_2_y)
    dec  a
    dec  a
    ld   (enemy_2_y),a
    and  $03
    ret  nz
    ld   a,(enemy_2_frame)
    cp   fr_blue_1
    jr   nz,_3450
    ld   a,fr_blue_2
    ld   (enemy_2_frame),a
    ret
_3450:
    ld   a,fr_blue_1
    ld   (enemy_2_frame),a
    ret

    dc   2, $FF

_3458:
    ld   a,(enemy_2_y)
    inc  a
    inc  a
    ld   (enemy_2_y),a
    ret

    dc   15, $FF

;; wats this?
_3470:
    call _33B8
    call _3418
    call update_stairdown_blue_right_timer
    call update_stairdown_blue_left_timer
    ret

    dc   11, $FF

update_stairdown_blue_right_timer:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_2_timer)
    inc  a
    cp   $20
    jr   nz,_3497
    xor  a
_3497:
    ld   (enemy_2_timer),a
    and  a
    ret  nz
    call _34A8
    ret

    dc   8, $FF

_34A8:
    ld   a,fr_blue_1
    ld   (enemy_1_frame),a
    ld   a,$A4
    ld   (enemy_1_x),a
    ld   a,$AC
    ld   (enemy_1_y),a
    ld   a,$17
    ld   (enemy_1_col),a
    ld   a,$01
    ld   (enemy_3_active),a ; Why set enemy_3?
    ret

    dc   6, $FF

_34C8:
    ld   a,$80
    ld   (enemy_2_x),a
    ld   a,$7C
    ld   (enemy_2_y),a
    ld   a,fr_blue_1
    ld   (enemy_2_frame),a
    ld   a,$17
    ld   (enemy_2_col),a
    ld   a,$01
    ld   (enemy_4_active),a
    ret

    dc   6, $FF

;;; ==========================================

update_stairdown_blue_left_timer:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_3_timer)
    inc  a
    cp   $28
    jr   nz,_34F7
    xor  a
_34F7:
    ld   (enemy_3_timer),a
    and  a
    ret  nz
    call _34C8
    ret

    dc   16, $FF

;;  reset a bunch of thing to 255
reset_enemies:
    ld   a,$FF
    ld   (rock_fall_timer),a
    ld   (enemy_1_timer),a
    ld   (enemy_2_timer),a
    ld   (enemy_3_timer),a
    ld   (rock_left_timer),a
    ld   (_8040),a
    xor  a
;;;  reset a bunch of things to 0
    ld   (enemy_1_active),a
    ld   (enemy_2_active),a
    ld   (enemy_3_active),a
    ld   (enemy_4_active),a
    ld   (_803f),a
    ld   (enemy_6_active),a
    ret

;;; ==========================================
;;
_3538:
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    call rock_fall_1
    call update_enemy_1
    call update_rock_left_timer
    call set_rock_3_fr_and_y
    ret

    dc   5, $FF

set_rock_x_60:
    ld   a,$60
    ld   (enemy_3_x),a
    ld   a,$1D
    ld   (enemy_3_frame),a
    ld   a,$15
    ld   (enemy_3_col),a
    ld   a,$40
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (_803f),a
    ret

    dc   6, $FF

update_rock_left_timer:
    ld   a,(tick_mod_slow)
    and  $07
    ret  nz
    ld   a,(rock_left_timer)
    inc  a
    cp   $14
    jr   nz,_357F
    xor  a
_357F:
    ld   (rock_left_timer),a
    and  a
    ret  nz
    call set_rock_x_60
    ret

    dc   8, $FF

set_rock_3_fr_and_y:
    ld   a,(_803f)
    and  a
    ret  z
;;  Move rock according to lookup table
    inc  a
    cp   $40
    jr   nz,_359B
    xor  a
_359B:
    ld   (_803f),a
    ld   hl,rock_fall_lookup
    sla  a
    add  a,l
    ld   l,a
    ld   a,(hl)
    ld   (enemy_3_frame),a
    inc  hl
    ld   a,(hl)
    ld   (enemy_3_y),a
    ret

    dc   9, $FF

_35B8:
    call update_rock_left_timer
    call set_rock_3_fr_and_y
    call rock_fall_1
    call update_enemy_1
    ret

    dc   11, $FF

;; in screen 14
set_bird_right_y_bc:
    ld   a,$10
    ld   (enemy_3_x),a
    ld   a,$A3
    ld   (enemy_3_frame),a
    ld   a,$16
    ld   (enemy_3_col),a
    ld   a,$BC
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (enemy_6_active),a
    ret

    dc   6, $FF

;; any time x < 5?
wrap_bird_right_y_bc:
    ld   a,(enemy_3_x)
    and  a
    jr   z,_3605
    cp   $01
    jr   z,_3605
    cp   $02
    jr   z,_3605
    cp   $03
    jr   z,_3605
_3602:
    cp   $04
    ret  nz
_3605:
    call set_bird_right_y_bc
    ret

    dc   7, $FF

;;; ==========================================

move_animate_bird_right:
    ld   a,(tick_mod_fast)
    and  $01
    ret  z
    ld   a,(enemy_6_active)
    and  a
    ret  z
    ld   a,(enemy_3_x) ; move right
    inc  a
    inc  a
    inc  a
    ld   (enemy_3_x),a
    ld   a,(tick_mod_fast)
    and  $02
    ret  nz
    ld   a,(enemy_3_frame)
    cp   $A3
    jr   nz,_3637
    ld   a,$A4
    ld   (enemy_3_frame),a
    ret
_3637:
    ld   a,$A3
    ld   (enemy_3_frame),a
    ret

    dc   3, $FF

;;; ==========================================

check_buttons_for_something:
    push bc
    ld   a,(input_buttons)
    and  $3F ; 0011 1111
    ld   c,a
    ld   a,$0E
    out  ($00),a
    in   a,($02)
    ld   (input_buttons_2),a
    and  $C0
    add  a,c
    ld   (input_buttons),a
    pop  bc
    ret

_3658:
    call wrap_bird_right_y_bc
    call move_animate_bird_right
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    ret

    dc   11, $FF

_3670:
    call _33B8
    call _3418
    call update_stairdown_blue_right_timer
    call update_stairdown_blue_left_timer
    call _36A8
    call move_animate_bird_right
    ret

    dc   5, $FF

_3688:
    ld   a,$10
    ld   (enemy_3_x),a
    ld   a,$A3
    ld   (enemy_3_frame),a
    ld   a,$16
    ld   (enemy_3_col),a
    ld   a,$98
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (enemy_6_active),a
    ret

    dc   6, $FF

_36A8:
    ld   a,(enemy_3_x)
    and  a
    jr   z,_36BD
    cp   $01
    jr   z,_36BD
    cp   $02
    jr   z,_36BD
    cp   $03
    jr   z,_36BD
    cp   $04
    ret  nz
_36BD:
    call _3688
    ret

    dc   15, $FF

;;; ==========================================

_36D0:
    call wrap_bird_right_y_bc
    call move_animate_bird_right
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    call rock_fall_1
    call update_enemy_1
    ret

    dc   5, $FF

set_spear_left_y_94:
    ld   a,$F0
    ld   (enemy_3_x),a
    ld   a,fr_spear
    ld   (enemy_3_frame),a
    ld   a,$17
    ld   (enemy_3_col),a
    ld   a,$94
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (enemy_6_active),a
    ret

    dc   14, $FF


wrap_spear_left_y_94:
    ld   a,(enemy_3_x)
    and  a
    jr   z,_3725
    cp   $01
    jr   z,_3725
    cp   $02
    jr   z,_3725
    cp   $03
    jr   z,_3725
    cp   $04
    ret  nz
_3725:
    call set_spear_left_y_94
    ret

    dc   7, $FF

_3730:
    ld   a,(tick_mod_fast)
    and  $01
    ret  z
    ld   a,(enemy_6_active)
    and  a
    ret  z
    ld   a,(enemy_3_x)
    dec  a
    dec  a
    dec  a
    ld   (enemy_3_x),a
    ret

    dc   27, $FF

_3760:
    call wrap_spear_left_y_94
    call _3730
    call _3798
    call _37B8
    ret

    dc   11, $FF

_3778:
    ld   a,$F0
    ld   (enemy_2_x),a
    ld   a,fr_spear
    ld   (enemy_2_frame),a
    ld   a,$17
    ld   (enemy_2_col),a
    ld   a,$50
    ld   (enemy_2_y),a
    ld   a,$01
    ld   (enemy_2_active),a
    ret

    dc   6, $FF

_3798:
    ld   a,(enemy_2_x)
    and  a
    jr   z,_37AD
    cp   $01
    jr   z,_37AD
    cp   $02
    jr   z,_37AD
    cp   $03
    jr   z,_37AD
    cp   $04
    ret  nz
_37AD:
    call _3778
    ret

    dc   7, $FF

_37B8:
    ld   a,(tick_mod_fast)
    and  $01
    ret  z
    ld   a,(enemy_2_active)
    and  a
    ret  z
    ld   a,(enemy_2_x)
    dec  a
    dec  a
    dec  a
    dec  a
    ld   (enemy_2_x),a
    ret

    dc   26, $FF

_37E8:
    call wrap_spear_left_y_94
    call _3730
    call _3798
    call _37B8
    call _33B8
    call update_stairdown_blue_right_timer
    ret

    dc   13, $FF

_3808:
    call wrap_bird_left_y_40
    call move_animate_bird_left
    call wrap_bird_right_y_60
    call move_animate_bird_right
    ret

    dc   11, $FF

;; no! frame 23 is bird left.
set_bird_right_y_60:
    ld   a,$10
    ld   (enemy_3_x),a
    ld   a,fr_bird_1
    ld   (enemy_3_frame),a
    ld   a,$16
    ld   (enemy_3_col),a
    ld   a,$60
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (enemy_6_active),a
    ret

    dc   6, $FF

;; if bird < 4, wrap
;; i think this is bird left not right?
wrap_bird_right_y_60:
    ld   a,(enemy_3_x)
    and  a
    jr   z,_wrap_bird_2
    cp   $01
    jr   z,_wrap_bird_2
    cp   $02
    jr   z,_wrap_bird_2
    cp   $03
    jr   z,_wrap_bird_2
    cp   $04
    ret  nz
_wrap_bird_2:
    call set_bird_right_y_60
    ret

    dc   15, $FF

_3868:
    call update_stairdown_blue_right_timer
    call _33B8
    call _36A8
    call move_animate_bird_right
    call wrap_bird_left_y_c4
    call move_animate_bird_left
    ret

    dc   13, $FF

_3888:
    call wrap_bird_left_y_40
    call move_animate_bird_left
    call wrap_bird_right_y_60
    call move_animate_bird_right
    call _38C0
    call _38D0
    ret

    dc   5, $FF

_38A0:
    ld   a,$60
    ld   (enemy_1_y),a
    ld   a,$A3
    ld   (enemy_1_frame),a
    ld   a,$16
    ld   (enemy_1_col),a
    ld   a,$01
    ld   (enemy_3_active),a
    ret

    dc   11, $FF

_38C0:
    call _38A0
    ret

    dc   12, $FF

_38D0:
    ld   a,(enemy_3_x)
    sub  $50
    ld   (enemy_1_x),a
    ld   a,(enemy_3_frame)
    ld   (enemy_1_frame),a
    ret

    db   $FF

draw_bonus_box_b:
    call draw_tiles_h
    db   $0A,$00
    db   $E0,$DC,$DD,$DE,$DF,$FF
    call draw_tiles_h
    db   $0B,$00
    db   $E1,$FF
    call draw_tiles_h
    db   $0B,$04
    db   $E6,$FF
    call draw_tiles_h
    db   $0C,$00
    db   $E1,$FF
    call draw_tiles_h
    db   $0C,$04
    db   $E6,$FF
    call draw_tiles_h
    db   $0D,$00
    db   $E2,$E3,$E3,$E3,$E4,$FF
    ret

    dc   5, $FF

enemy_pattern_scr_26:
    call wrap_spear_left_bottom
    call update_3_spears_left
    ret

    dc   25, $FF

;;; ==========================================

set_spear_left_bottom:
    ld   a,(enemy_1_x)
    and  a
    ret  nz
    ld   a,screen_width+$10
    ld   (enemy_1_x),a
    ld   a,fr_spear
    ld   (enemy_1_frame),a
    ld   a,$17
    ld   (enemy_1_col),a
    ld   a,$C8
    ld   (enemy_1_y),a
    ld   a,$01
    ld   (enemy_1_active),a
    ret

    dc   9, $FF

;;; ==========================================

set_spear_left_middle:
    ld   a,(enemy_2_x)
    and  a
    ret  nz
    ld   a,screen_width+$10
    ld   (enemy_2_x),a
    ld   a,fr_spear
    ld   (enemy_2_frame),a
    ld   a,$17
    ld   (enemy_2_col),a
    ld   a,$98
    ld   (enemy_2_y),a
    ld   a,$01
    ld   (enemy_2_active),a
    ret

    dc   9, $FF

set_spear_left_top:
    ld   a,(enemy_3_x)
    and  a
    ret  nz
    ld   a,screen_width+$10
    ld   (enemy_3_x),a
    ld   a,fr_spear
    ld   (enemy_3_frame),a
    ld   a,$17
    ld   (enemy_3_col),a
    ld   a,$68
    ld   (enemy_3_y),a
    ld   a,$01
    ld   (enemy_3_active),a
    ret

    dc   9, $FF

;;; who calls? debug?
    ld   a,(p1_time) ; woah! P1 timer is used maybe?
    ld   (rock_fall_timer),a
    ret

    db   $FF

;;
wrap_spear_left_bottom:
    ld   a,(enemy_1_x)
    cp   $80
    jr   z,_39D3
    cp   $81
    jr   z,_39D3
    cp   $82
    jr   z,_39D3
    cp   $83
    jr   z,_39D3
    cp   $84
    jr   z,_39D3
    cp   $00
    jr   nz,_39D6
_39D3:
    call set_spear_left_bottom
_39D6:
    jp   wrap_other_spears_left

    dc   15, $FF

update_3_spears_left:           ; screen 26
    ld   a,(tick_mod_fast)
    and  $07
    ret  nz
    ld   a,(enemy_1_active) ; bottom spear
    and  a
    jr   z,_middle_spear
    inc  a
    cp   $40
    jr   nz,_3A02
    xor  a
    ld   (enemy_1_active),a
    ld   (enemy_1_x),a
    jr   _middle_spear
_3A02:
    ld   (enemy_1_active),a
    ld   a,(enemy_1_x)
    sub  $02
    ld   (enemy_1_x),a
;;
_middle_spear:
    ld   a,(enemy_2_active) ; middle spear
    and  a
    jr   z,_top_spear
    inc  a
    cp   $40
    jr   nz,_3A21
    xor  a
    ld   (enemy_2_active),a
    ld   (enemy_2_x),a
    jr   _top_spear
_3A21:
    ld   (enemy_2_active),a
    ld   a,(enemy_2_x)
    sub  $03
    ld   (enemy_2_x),a
;;
_top_spear:
    ld   a,(enemy_3_active) ; top spear
    and  a
    ret  z
    inc  a
    cp   $40
    jr   nz,_3A3E
    xor  a
    ld   (enemy_3_active),a
    ld   (enemy_3_x),a
    ret
_3A3E:
    ld   (enemy_3_active),a
    ld   a,(enemy_3_x)
    sub  $04
    ld   (enemy_3_x),a
    ret

    dc   6, $FF

;;
enemy_1_reset:
    ld   a,(enemy_1_active)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,_3A62
    xor  a
    ld   (enemy_1_x),a
    ld   (enemy_1_active),a
    ret
_3A62:
    ld   (enemy_1_active),a
    ld   a,(enemy_1_y)
    dec  a
    dec  a
    dec  a
    ld   (enemy_1_y),a
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_1_frame)
    cp   $36
    jr   nz,_3A81
    ld   a,$37
    ld   (enemy_1_frame),a
    ret
_3A81:
    ld   a,$36
    ld   (enemy_1_frame),a
    ret

    db   $FF

;;
enemy_2_reset:
    ld   a,(enemy_2_active)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,_3A9A
    xor  a
    ld   (enemy_2_x),a
    ld   (enemy_2_active),a
    ret
_3A9A:
    ld   (enemy_2_active),a
    ld   a,(enemy_2_y)
    dec  a
    dec  a
    dec  a
    ld   (enemy_2_y),a
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_2_frame)
    cp   $36
    jr   nz,_3AB9
    ld   a,$37
    ld   (enemy_2_frame),a
    ret
_3AB9:
    ld   a,$36
    ld   (enemy_2_frame),a
    ret

    dc   1, $FF

;; enemy 3
enemy_3_reset:
    ld   a,(enemy_3_active)
    and  a
    ret  z
    inc  a
    cp   $3A
    jr   nz,_3AD2
    xor  a
    ld   (enemy_3_x),a
    ld   (enemy_3_active),a
    ret
_3AD2:
    ld   (enemy_3_active),a
    ld   a,(enemy_3_y)
    dec  a
    dec  a
    dec  a
    ld   (enemy_3_y),a
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   a,(enemy_3_frame)
    cp   $36
    jr   nz,_3AF1
    ld   a,$37
    ld   (enemy_3_frame),a
    ret
_3AF1:
    ld   a,$36
    ld   (enemy_3_frame),a
    ret

    dc   1, $FF

;; enemy 1
set_enemy_1_98_c0:
    ld   hl,enemy_1_x
    ld   (hl),$98 ; x
    inc  hl
    ld   (hl),$36 ; frame
    inc  hl
    ld   (hl),$17 ; color
    inc  hl
    ld   (hl),$C0 ; y
    inc  hl
    ld   a,$01
    ld   (enemy_1_active),a
    ret

    dc   3, $FF

;; enemy 2
set_enemy_2_90_c0:
    ld   hl,enemy_2_x
    ld   (hl),$90 ; x
    inc  hl
    ld   (hl),$36 ; frame
    inc  hl
    ld   (hl),$17 ; color
    inc  hl
    ld   (hl),$C0 ; y
    inc  hl
    ld   a,$01
    ld   (enemy_2_active),a
    ret

    dc   3, $FF

;; enemy 3
set_enemy_3_90_c0:
    ld   hl,enemy_3_x
    ld   (hl),$90 ; x
    inc  hl
    ld   (hl),$36 ; frame
    inc  hl
    ld   (hl),$17 ; color
    inc  hl
    ld   (hl),$C0 ; y
    inc  hl
    ld   a,$01
    ld   (enemy_3_active),a
    ret

    dc   3, $FF

_3B40:
    call _3B78
    ld   a,(rock_fall_timer)
    inc  a
    cp   $60
    jr   nz,_3B4C
    xor  a
_3B4C:
    ld   (rock_fall_timer),a
    cp   $08
    jr   nz,_3B57
    call set_enemy_1_98_c0
    ret
_3B57:
    cp   $30
    jr   nz,_3B5F
    call set_enemy_2_90_c0
    ret
_3B5F:
    cp   $40
    ret  nz
    call set_enemy_3_90_c0
    ret

    dc   2, $FF

_3B68:
    call _3B40
    call reset_enemies_2
    nop
    nop
    nop
    nop
    nop
    nop
    ret

    dc   3, $FF

;;
_3B78:
    ld   a,(tick_mod_fast)
    and  $03
    ret  z
    pop  hl
    ret

;;; ==========================================

;; interesting algorithm for collision detection!
player_enemy_collision:
;; Check X
    ld   a,(iy+$00) ; points to enemy X
    sub  (ix+$00) ; minus player_x
    scf
    ccf ; (clear carry)
    sub  $0C ; is enemy to the right and X diff <= sprite width?
    jr   c,_check_y ; ... yes, check Y
    add  a,$18 ; no, but enemy might be to the left: try "+ width * 2"
    ret  nc ; no collision on X, leave.
_check_y:
    ld   a,(ix+$03) ; player Y pos (player_x addr + 3)
    sub  (iy+$03) ; minus enemy Y pos (enemy Y addr + 3)
    scf
    ccf ; (clear carry)
    sub  $0A ; is Y diff <= 10?
    jr   c,_hit ; ... yes - we collided.
    add  a,$21 ; no, but is player above? Check legs.
    ret  nc ; no - no collsions on Y, leave
_hit:
    call kill_player
    ret

    dc   6, $FF

;;; ==========================================

;; Always checks all 3 enemies. "Offscreen" enemies
;; have x = 0, so the "check x" test fails.
player_enemies_collision:
    ld   iy,enemy_1_x
    ld   ix,player_x
    call player_enemy_collision
    ld   iy,enemy_2_x
    call player_enemy_collision
    ld   iy,enemy_3_x
    call player_enemy_collision
    ret

    dc   6, $FF

copy_xoffs:
    ld   hl,screen_xoff_col+8  ; row 5?
_3BCB:
    ld   a,(screen_xoff_col+6)  ; row 4
    ld   (hl),a
    inc  hl
    inc  hl
    ld   a,l
    cp   $40
    jr   nz,_3BCB
    ret

    dc   1, $FF

;;; ==========================================

;; bytes after the call are:
;; start_x, start_y, tile 1, ...tile id, 0xFF
draw_tiles_v_copy:
    pop  ix
    ld   h,$00
    ld   l,(ix+$00) ; param 1
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    inc  ix
    ld   a,(ix+$00) ; param 2
    add  a,l
    ld   l,a
    ld   bc,start_of_tiles
    add  hl,bc
_3BEF:
    inc  ix
    ld   a,(ix+$00) ; read until 0xff
    cp   $FF
    jr   z,_3BFC
    ld   (hl),a
    inc  hl
    jr   _3BEF
_3BFC:
    inc  ix
    push ix
    ret

    dc   1, $FF

;;; ==========================================

screen_tile_animations:
    ld   a,(player_num)
    and  a
    jr   nz,_3C0D
    ld   a,(screen_num)
    jr   _3C10
_3C0D:
    ld   a,(screen_num_p2)
_3C10:
    cp   $01
    jr   z,bubble_lava
    cp   $02
    jr   z,bubble_lava
    cp   $04
    jr   z,bubble_lava
    cp   $08
    jr   z,bubble_lava
    cp   $0D
    jr   z,bubble_lava
    cp   $0F
    jr   z,bubble_lava
    cp   $12
    jr   z,bubble_lava
    cp   $15
    jr   z,bubble_lava_var
    cp   $18
    jr   z,bubble_lava_var
    ret

;;; ==========================================

bubble_lava:
    ld   a,(lava_tile_offset)
    inc  a
    cp   $04
    jr   nz,_3C3E
    xor  a
_3C3E:
    ld   (lava_tile_offset),a
    and  a
    jr   nz,bubble_lava_1
    call draw_tiles_h
    db   $1D,$0E
    db   $80,$80,$80,$80,$FF ;  red dash line
    ret

bubble_lava_1:
    cp   $01
    jr   nz,bubble_lava_2
    call draw_tiles_h
    db   $1D,$0E
    db   $85,$81,$87,$81,$FF
    ret

bubble_lava_2:
    cp   $02
    jr   nz,bubble_lava_3
    call draw_tiles_h
    db   $1D,$0E
    db   $86,$82,$88,$80,$FF
    ret

bubble_lava_3:
    call draw_tiles_h
    db   $1D,$0E
    db   $85,$83,$87,$82,$FF
    ret

bubble_lava_var:
    ld   a,(lava_tile_offset)
    inc  a
    cp   $04
    jr   nz,_3C81
    xor  a
_3C81:
    ld   (lava_tile_offset),a
    and  a
    jr   nz,bubble_lava_var_1
    call draw_tiles_h
    db   $19,$0F
    db   $80,$80,$80,$80,$80,$FF ;  Flat
    ret

bubble_lava_var_1:
    cp   $01
    jr   nz,bubble_lava_var_2
    call draw_tiles_h
    db   $19,$0F
    db   $85,$81,$84,$81,$87,$FF
    ret

bubble_lava_var_2:
    cp   $02
    jr   nz,bubble_lava_var_3
    call draw_tiles_h
    db   $19,$0F
    db   $86,$82,$88,$86,$82,$FF
    ret

bubble_lava_var_3:
    call draw_tiles_h
    db   $19,$0F
    db   $85,$83,$80,$83,$87,$FF
    ret

    db   $FF

;;; ==========================================
;; x, frame, color, y
cutscene_data:
    db   $80,$3A,$11,$70 ;  player
    db   $80,$3B,$11,$80 ;  player legs
    db   $94,$05,$12,$80 ;  bongo
    db   $00,$00,$12,$80 ;  dino (offscreen)
    db   $00,$00,$12,$80 ;  dino legs
    db   $6C,$00,$12,$80 ;  bambongo 1
    db   $A8,$00,$12,$80 ;  bambongo 2
    db   $00,$00,$12,$80 ;  unused?

;; CUTSCENE something
wait_vblank_8:
    ld   e,$08
_lp_3CE2:
    push hl
    push de
    call wait_vblank
    pop  de
    pop  hl
    dec  e
    jr   nz,_lp_3CE2
    ret

    dc   19, $FF

;;; ==========================================

;; player, player legs, bongo, dino_legs -bambongo1-dino-bambongo2
dance_frame_data:
    db   $3C,$3D,$06,$01
    db   $3A,$3B,$05,$00
    db   $3C,$3D,$06,$01
    db   $3A,$3B,$07,$02
    db   $3E,$3F,$08,$03
    db   $3A,$3B,$07,$02
    db   $3E,$3F,$08,$03
    db   $3A,$3B,$05,$00

;;; ==========================================

update_dance_frames:
    ld   a,(hl)
    ld   (player_frame),a
    inc  hl
    ld   a,(hl)
    ld   (player_frame_legs),a
    inc  hl
    ld   a,(hl)
    ld   (bongo_frame),a
    inc  hl
    ld   a,(hl)
    ld   (dino_frame_legs),a ; how is dino the same?!
    ld   (enemy_1_frame),a
    ld   (enemy_2_frame),a
    inc  hl
    ld   a,l
    and  $1F ; wrap dance at 32 bytes
    ld   l,a
    ret

    dc   9, $FF

;;; ==========================================
;;; Cut sceen
do_cutscene:
    ld   a,$06
    ld   (ch1_sfx),a
    ld   (sfx_prev),a
    call reset_xoff_sprites_and_clear_screen
    ld   hl,header_text_data
    call draw_screen
    nop ; params to DRAW_SCREEN
    nop
    call draw_lives
    call draw_score
    ld   hl,player_x ; destination
    ld   bc,cutscene_data ; src location
    ld   d,$20 ; 32 times do
_3D69:
    ld   a,(bc) ;      <-
    ld   (hl),a ;       |  (sets all sprites)
    inc  hl     ;       |
    inc  bc     ;       |
    dec  d      ;       |
    jr   nz,_3D69 ;    _|
    call draw_cage_and_scene
    ld   d,$80 ; 128 x animate cutscene
    xor  a
    ld   (dino_counter),a
    ld   hl,dance_frame_data
_lp_3D7C:
    call wait_vblank_8    ; draws gang <-
    call update_dance_frames    ;             |
    dec  d        ;             |
    jr   nz,_lp_3D7C ;         ____|
    call end_cutscene ; end of round cutscene
_cutscene_done:
    ld   a,(player_num) ; a = $8004 - which screen to use?
    and  a ; if a != 0
    jr   nz,_3D96 ; goto screen-set 2
    ld   a,$01 ; reset to screen 1
    ld   (screen_num),a ; set screen
    jp   big_reset
_3D96:
    ld   a,$01
    ld   (screen_num_p2),a ; player 2 screen
    jp   big_reset
    ret
    dc   1, $FF

;;; ==========================================

draw_cage_and_scene:            ; for cutscene
    ld   hl,screen_ram+$218
    ld   (hl),$66
    inc  hl
    ld   (hl),$67
    inc  hl
    ld   (hl),$6A
    inc  hl
    ld   (hl),$6B
    ld   hl,screen_ram+$1F8
    ld   (hl),$64
    inc  hl
    ld   (hl),$65
    inc  hl
    ld   (hl),$68
    inc  hl
    ld   (hl),$69
    ld   hl,screen_ram+$1D8
    ld   (hl),$6E
    inc  hl
    ld   (hl),$6F
    inc  hl
    ld   (hl),$6C
    inc  hl
    ld   (hl),$6D
    ld   a,$02 ; red
    ld   (screen_xoff_col+$31),a
    ld   (screen_xoff_col+$33),a
    ld   (screen_xoff_col+$35),a
    ld   (screen_xoff_col+$37),a
    call draw_tiles_h
    db   $1C,$00 ;  Row of upward spikes
    db   $38,$39,$3A,$39,$38,$39,$3C,$3D,$39,$3A,$38,$38,$3C,$3C,$3D,$3C
    db   $39,$3A,$38,$39,$38,$39,$3D,$3C,$39,$38,$3A,$3D,$3C,$39,$39,$38,$FF
    call draw_tiles_h
    db   $12,$00 ;  real long platform
    db   $FE,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
    db   $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FC,$FF
    ret

    db   $FF

;;; ==========================================

cutscene_run_offscreen:
    ld   a,$0C
    ld   (player_frame),a
    ld   a,$0D
    ld   (player_frame_legs),a
    ld   a,$29
    ld   (screen_xoff_col+$29),a
    ld   e,$70
_lp_3E33:
    push de
    call animate_player_right
    call move_bongo_right
    call move_bongo_right
    call wait_vblank
    pop  de
    dec  e
    jr   nz,_lp_3E33
    ret

    dc   11, $FF

delay_2_b:
    ld   e,$01
_lp_3E52:
    push de
    push ix
    call wait_vblank
    pop  ix
    pop  de
    dec  e
    jr   nz,_lp_3E52
    ret

    dc   1, $FF

;;; ==========================================

cutscene_jump_up_and_down:
    ld   ix,player_x
    call delay_2_b
    ld   d,$08
_lp_3E69:
    dec  (ix+$03)
    dec  (ix+$07)
    dec  (ix+$0b)
    call delay_2_b
    dec  d
    jr   nz,_lp_3E69
    ld   d,$08
_lp_3E7A:
    inc  (ix+$03)
    inc  (ix+$07)
    inc  (ix+$0b)
    call delay_2_b
    dec  d
    jr   nz,_lp_3E7A
    ret

    dc   38, $FF

end_cutscene:
    ld   a,$07 ; end of dance in cutscene
    ld   (ch1_sfx),a
    ld   hl,dino_x_legs ; set a bunch of bytes at 8150
    ld   (hl),$18 ; x
    inc  hl
    ld   (hl),$2E ; frame
    inc  hl
    ld   (hl),$12 ; color
    inc  hl
    ld   (hl),$70 ; y
    ld   hl,enemy_3_x ; and 815c
    ld   (hl),$11 ; x
    inc  hl
    ld   (hl),$30 ; frame
    inc  hl
    ld   (hl),$12 ; color
    inc  hl
    ld   (hl),$80 ; y
    call wait_vblank_8
    call cutscene_jump_up_and_down
    call cutscene_jump_up_and_down
    call cutscene_jump_up_and_down
    add  a,b
    call cutscene_run_offscreen
    ret

    dc   14, $FF

animate_player_right:
    ld   a,e
    and  $03
    ret  nz
    call player_move_right
    ret

    dc   8, $FF

clear_ram_call_weird_a:
    call clear_ram_x83_bytes
    ld   hl,load_a_val_really_weird - JMP_HL_OFFSET
    call jmp_hl_plus_4k ; seems to do nothing in sub
    ret

    dc   6, $FF

;;; ==========================================

;;; level tiles at the bottom of the screen
draw_bottom_row_numbers:
    call draw_tiles_h
    db   $1F,$00 ;  bottom row
    db   $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7
    db   $C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF
    db   $D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7
    db   $D8,$D9,$DA,$FF

;; falls through after drawing
_animate_red_level_indicator:
    ld   a,(player_num)
    and  a
    jr   nz,_3F3C
    ld   a,(screen_num)
    jr   _3F3F
_3F3C:
    ld   a,(screen_num_p2) ; a = scr
_3F3F:
    ld   hl,end_of_tiles
_lp_3F42:
    call delay_2_vblank ; slow things down
    dec  a
    jr   z,_done_3F50
    ld   (hl),tile_lvl_done
    ld   bc,scr_line_prev
    add  hl,bc
    jr   _lp_3F42
_done_3F50:
    call draw_bonus_state
    ret

    dc   1, $FF

delay_2_vblank:
    push af
    push hl
    ld   e,$01
_lp:
    push de
    call wait_vblank
    pop  de
    dec  e
    jr   nz,_lp
    pop  hl
    pop  af
    ret

    dc   2, $FF

;;; ==========================================

draw_jetsoft:
    call draw_tiles_h
    db   $0C,$0A ;  JETSOFT
    db   J_,E_,T_,S_,O_,F_,T_,$FF
    ret

;;; ==========================================

draw_proudly_presents:
    call draw_tiles_h
    db   $14,$07 ;  PROUDLY PRESENTS
    db   P_,R_,O_,U_,D_,L_,Y_,__,P_,R_,E_,S_,E_,N_,T_,$FF
    ret

    dc   2, $FF

;;; ==========================================

draw_copyright:
    call draw_tiles_h
    db   $10,$04
    db   tile_copy,1,9,8,3,$FF ;  (c) 1983
    call draw_tiles_h
    db   $12,$04
    db   J_,E_,T_,S_,O_,F_,T_,$FF ;  JETSOFT
    ret

    dc   3, $FF

blank_out_bottom_row:
    call draw_tiles_h
    db   $1F,$00 ;  Whole bunch of spaces over the level numbers
    dc   28, tile_blank
    db   $FF

    ret

    dc   5, $FF

;;; ==========================================

do_bonus_flashing:
    nop ; wonder what these did originally?
    nop ; 5 bytes?
    nop
    nop
    nop
    call draw_bonus_box
    call delay_8_play_sound
    call draw_bonus_box_b
    call delay_8_play_sound
    call draw_bonus_box
    call delay_8_play_sound
    call draw_bonus_box_b
    call delay_8_play_sound
    call draw_bonus_box
    call delay_8_play_sound
    call draw_bonus_box_b
    call delay_8_play_sound
    ret

    dc   6, $FF

;;; === END OF BG4.BIN, START OF BG5.BIN ======

int_handler:
    xor  a
    ld   (int_enable),a
    ld   a,(add_pickup_pat_8)
    nop
    nop
    nop
    ld   a,$FF
    ld   (watchdog),a
    ld   sp,stack_location
    ld   a,(add_pickup_pat_8)
    nop
    nop
    nop
    call hard_reset

    dc   5, $FF

;;; ==========================================

;; Looks like more general updates
update_everything_more:
    call add_move_score
    call pickup_tile_collision
    call 1up_timer_countdown
    call end_screen_logic
    call animate_all_pickups
    ret

    ret         ;? extra ret for fun
    dc   7, $FF

;; who calls?
;; What the heck is $c000?
;; RESET_VECTOR is 0x38, this is 4k higher... coincidence?
    ld   hl,_C000
    call jmp_hl
    ret

    dc   1, $FF

;;; ==========================================

add_pickup_pat_8:
    call add_pickup_pat_3
    ld   a,$8E
    ld   (_927A),a
    ret

    dc   7, $FF

;; Adds a bonus as you move right
;; Keeps track of "max x" - when you go past it,
;; it gets the diff (x - old max x) and adds it to bonus
add_move_score:
    ld   a,(player_x)
    scf
    ccf
    ld   hl,player_max_x
    sub  (hl)
    ret  c ; not furthest right, no bonus
;; adds the move score
    ld   b,a ; add position diff to score_to_add
    ld   a,(score_to_add)
    add  a,b
    ld   (score_to_add),a
    ld   a,(player_x) ; set new max X pos
    ld   (player_max_x),a
    ret

    dc   7, $FF

add_pickup_pat_5:
    ld   a,tile_pik_crowna
    ld   (_918E),a
    ret

    dc   2, $FF

add_pickup_pat_6:
    ld   a,$8D
    ld   (_91D2),a
    ret

    dc   2, $FF

;;
_4080:
    ld   a,(ix+$05)
    and  a
    jr   z,_408B
    dec  a
    ld   (ix+$05),a
    ret
_408B:
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

    dc   1, $FF

;; in: h = x, y = l
;; out: hl = screen pos of tile at xy
get_tile_scr_pos:
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

    dc   1, $FF

_40C0:
    ld   a,(ix+$05)
    and  a
    jr   z,_40CB
    dec  a
    ld   (ix+$05),a
    ret
_40CB:
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

    dc   2, $FF

add_pickup_pat_9:
    ld   a,$8F
    ld   (scr_pik_S_top),a
    ld   a,$8E
    ld   (_9217),a
    ret

    dc   1, $FF

;;; ; hit bonus
hit_bonus:
    ld   a,$03
    ld   (sfx_id),a
    ld   hl,got_a_bonus
    call jmp_hl
    ret

;; Called directly by SFX_SUMFIN_2
_4100:
    ld   a,(ix+$05)
    and  a
    jr   z,_410B
    dec  a
    ld   (ix+$05),a
    ret
_410B:
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

    dc   2, $FF

add_pickup_pat_10:
    ld   a,tile_pik_crowna
    ld   (_9217),a
    ld   a,$8D
    ld   (_9231),a
    ld   a,$8F
    ld   (_922B),a
    ret

    dc   8, $FF

;;; "set_synth_settings" subs are all almost identical
;;; except for variable (8068-8088) and hard-coded values
set_synth_settings_1:
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   (ch1_cur_id),a         ; sfx_id?
    sla  a
    ld   hl,sfx_synth_settings
    add  a,l
    ld   l,a                    ; ?  1 3 5 (ch 1,2,3)
    ld   a,$01
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$00                  ; ?  0 2 4 (ch 1,2,3)
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$08                  ; ?  8 9 A (ch 1,2,3)
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret

_4170:
    call add_pickup_pat_7
    ld   a,$8E
    ld   (_92AB),a
    ret

    dc   7, $FF

;;; "set_synth_settings" subs are all almost identical
;;; except for variable (8068-8088) and hard-coded values
set_synth_settings_2:
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   (ch2_cur_id),a         ; sfx_id
    sla  a
    ld   hl,sfx_synth_settings
    add  a,l
    ld   l,a
    ld   a,$03                  ; ?  1 3 5 (ch 1,2,3)
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$02                  ; ?  0 2 4 (ch 1,2,3)
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$09                  ; ?  8 9 A (ch 1,2,3)
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret

;; I reckon this is the tiles that say the points
;; Changes the tiles, then calls $HIT_BONUS
hit_bonus_draw_points:
    ld   b,a ; adds bonus score
    ld   a,(score_to_add)
    add  a,b
    ld   (score_to_add),a
    dec  hl
    dec  hl
    dec  hl
    dec  hl
    ld   (1up_scr_pos),hl
    ld   a,(hl)
    ld   (1up_scr_pos_2),a
    ld   a,tile_lil_0
    srl  b
    srl  b
    srl  b
    srl  b
    add  a,b
    ld   (hl),a
    ld   de,scr_line_prev
    add  hl,de
    ld   a,(hl)
    ld   (1up_scr_pos_3),a
    ld   (hl),tile_lil_00
    ld   a,$40 ; 64 countdown. Never read.
    ld   (1up_timer),a
    jp   hit_bonus

    dc   2, $FF

;; How do i get here?... what is this Weird load for?
weird_unsed_maybe_load:
    ld   a,(_4100)              ; +4k = $8100: screen_xoff_col attrs?
    ld   bc,jmp_hl_plus_4k      ; hmm, but can't jump to that.
    push bc                     ; dunno, why keeping these
    push hl
    ret

;; DRAW_CROWN_PIK_BOT_RIGHT (never called?)
_41EC:
    ld   a,tile_pik_crown
    ld   (scr_pik_n_n),a
    ret

;; DRAW_CROSS_PIK_BOT_RIGHT (never called?)
_41F2:
    ld   a,tile_pik_cross
    ld   (scr_pik_n_n),a
    ret

;; draw pikup cross, bot, right-er
draw_pikup_cross_bot_r:
    ld   a,tile_pik_cross
    ld   (_911A),a
    ret

    dc   2, $FF

;;
sfx_sumfin_0:
    ld   ix,synth1
    ld   a,(ix+$04)
    and  a
    jr   z,_i_2
    call set_synth_settings_1
    ld   (ix+$04),$00
    ret
_i_2:
    call _4080
    ret

;;; uncalled?
_4216:
    ld   a,tile_pik_crown
    ld   (_91B1),a
    ret

    dc   4, $FF

sfx_sumfin_1:
    ld   ix,synth2
    ld   a,(ix+$04)
    and  a
    jr   z,_i_3
    call set_synth_settings_2
    ld   (ix+$04),$00
    ret
_i_3:
    call _40C0
    ret

;;; uncalled?
_4236:
    ld   a,tile_pik_crown
    ld   (_918E),a
    ret

    dc   4, $FF

sfx_sumfin_2:
    ld   ix,synth3
    ld   a,(ix+$04)
    and  a
    jr   z,_i_4
    call set_synth_settings_3
    ld   (ix+$04),$00
    ret
_i_4:
    call _4100
    ret

    dc   2, $FF

pickup_tile_collision:
    ld   a,(player_x)
    add  a,$04 ; lol, 4 pixels to get pickup
    ld   h,a
    ld   a,(player_y)
    add  a,$18
    ld   l,a
    call get_tile_scr_pos
    ld   a,(hl)
    cp   tile_blank
    ret  z
;;
    cp   tile_pik_crowna
    jr   nz,_crossa
    ld   a,$20 ; 200 bonus
    ld   (hl),tile_blank
    call hit_bonus_draw_points
    ret
_crossa:
    cp   tile_pik_crossa
    jr   nz,_ringa
    ld   a,$40 ; 400 bonus
    ld   (hl),tile_blank
    call hit_bonus_draw_points
    ret
_ringa:
    cp   tile_pik_ringa
    jr   nz,_vasea
    ld   a,$60 ; 600 bonus
    ld   (hl),tile_blank
    call hit_bonus_draw_points
    ret
_vasea:
    cp   tile_pik_vasea
    ret  nz
    ld   a,$A0 ; 1000 bonus
    ld   (hl),tile_blank
    call hit_bonus_draw_points
    ret

;;; called? Draws a cross (same spot as "ADD_PICKUP_PAT_6", but A version)
;; might be old dud code
    ld   a,tile_pik_cross
    ld   (_91D2),a
    ret

;; Weird bug in it - same code as ADD_PICKUP_PAT_7,
;; but that called $ADD_PICKUP_PAT_5: not the middle of nowhere!
funky_looking_set_ring:
    ld   a,tile_pik_ringa
    ld   (scr_pik_r_W),a
    call _3602 ; <- that looks odd. Weird jump to middle of code
    ret

    dc   7, $FF

;;; "set_synth_settings" subs are all almost identical
;;; except for variable (8068-8088) and hard-coded values
set_synth_settings_3:
    ld   a,(ix+$00)
    and  a
    ret  z
    ld   (ch3_cur_id),a
    sla  a
    ld   hl,sfx_synth_settings
    add  a,l
    ld   l,a
    ld   a,$05                  ; diff
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    inc  hl
    ld   a,$04                  ; diff
    out  ($00),a
    ld   a,(hl)
    out  ($01),a
    ld   a,$0A                  ; diff
    out  ($00),a
    ld   a,(ix+$02)
    add  a,$00
    out  ($01),a
    ld   a,(ix+$03)
    ld   (ix+$05),a
    ret

;; My theory: the bonus-points text that appears
;; when you get a pickup, was supposed to disappear after 64 frames
;; but they gave up. That's my theory.
1up_timer_countdown:
    ld   a,(1up_timer)
    and  a
    ret  z
    dec  a
    ld   (1up_timer),a
    and  a
    ret

;; never called, cause my theory above...
blank_out_1up_text:
    ld   hl,(1up_scr_pos)
    ld   a,tile_blank
    nop
    ld   (hl),a
    ld   de,scr_line_prev ; -32 (next line up screen)
    add  hl,de
    ld   a,tile_blank
    nop
    ld   (hl),a
    ret

    dc   5, $FF

;; data?
    db   $F0,$70,$B0,$30,$D0,$50,$90,$10
    db   $E0,$60,$A0,$20,$C0,$40,$80,$00
    db   $FF,$FF
;;
    call draw_pikup_cross_bot_r
    ld   a,$9E
    ld   (_927A),a              ;draw some other pikup
    ret

    dc   5, $FF

sfx_something_ch_1:
    ld   l,(ix+$07)
    ld   h,(ix+$08)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    ld   iy,synth1
    ld   (iy+$00),a
    inc  hl
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
_433A:
    dec  b
    jr   z,_4340
    add  a,c
    jr   _433A
_4340:
    dec  a
    ld   (ix+$12),a
    call play_sfx_chunk_ch_1
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret

    dc   10, $FF

sfx_something_ch_2:
    ld   l,(ix+$09)
    ld   h,(ix+$0a)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    ld   iy,synth2
    ld   (iy+$00),a
    inc  hl
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
_437A:
    dec  b
    jr   z,_4380
    add  a,c
    jr   _437A
_4380:
    dec  a
    ld   (ix+$13),a
    call play_sfx_chunk_ch_2
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret

;; called?
    call funky_looking_set_ring
    ld   a,$9E
    ld   (_92AB),a
    ret

    dc   1, $FF

;;
sfx_what_1:
    ld   l,(ix+$0b)
    ld   h,(ix+$0c)
    ld   a,(hl)
    cp   $FF
    ret  z
    add  a,(ix+$11)
    inc  hl
    ld   iy,synth3
    ld   (iy+$00),a
    ld   b,(hl)
    ld   a,(ix+$0f)
    ld   c,a
_43BA:
    dec  b
    jr   z,_43C0
    add  a,c
    jr   _43BA
_43C0:
    dec  a
    ld   (ix+$14),a
    call sfx_sub_what_1
    ld   (iy+$02),a
    ld   a,(ix+$0e)
    ld   (iy+$03),a
    ld   a,$01
    ld   (iy+$04),a
    ret

    dc   10, $FF

    ld   a,$9F
    ld   (scr_pik_S_top),a
    ld   a,$9E
    ld   (_9217),a
    ret

    dc   1, $FF

    ld   a,$9C
    ld   (_9217),a
    ld   a,$9D
    ld   (_9231),a
    ld   a,$9F
    ld   (_922B),a
    ret

    dc   4, $FF

;;; SFX synth settings data
sfx_synth_settings:
    db   $03,$24,$03,$F6,$02,$CC,$02,$A4
    db   $02,$7E,$02,$5A,$02,$38,$02,$18
    db   $02,$FA,$01,$DE,$01,$C3,$01,$AA
    db   $01,$92,$01,$7B,$01,$66,$01,$52
    db   $01,$3F,$01,$2D,$01,$1C,$01,$0C
    db   $01,$00,$00,$EF,$00,$E2,$00,$D5
    db   $00,$C9,$00,$BE,$00,$B3,$00,$A9
    db   $00,$A0,$00,$96,$00,$8E,$00,$86
    db   $00,$7F,$00,$78,$00,$71,$00,$6B
    db   $00,$64,$00,$5F,$00,$59,$00,$54
    db   $00,$50,$00,$4B,$00,$47,$00,$43
    db   $00,$3F,$00,$3C,$00,$38,$00,$35
    db   $00,$32,$00,$2F,$00,$2C,$00,$2A
    db   $00,$28,$00,$25,$00,$23,$00,$21
    db   $00,$1F,$00,$1E,$00,$00,$01,$04
    db   $01,$07,$01

    dc   9, $FF

draw_cage_top:
    ld   a,(player_num)
    and  a
    jr   nz,_448F
    ld   a,(screen_num)
    jr   _4492
_448F:
    ld   a,(screen_num_p2)
_4492:
    cp   num_screens ; are we on screen 27?
    ret  nz ; Nope, leave.
    ld   a,tile_cage
    ld   (scr_cage_up+$20),a
    inc  a
    ld   (scr_cage_up+$21),a
    inc  a
    ld   (scr_cage_up+$40),a
    inc  a
    ld   (scr_cage_up+$41),a
    inc  a
    ld   (scr_cage_up+$22),a
    inc  a
    ld   (scr_cage_up+$23),a
    inc  a
    ld   (scr_cage_up+$42),a
    inc  a
    ld   (scr_cage_up+$43),a
    inc  a
    ld   (scr_cage_up+$02),a
    inc  a
    ld   (scr_cage_up+$03),a
    jr   _more_cage
;; notes
    db   $10,$01,$12,$03
    db   $14,$01,$15,$03
    db   $17,$01,$19,$03
    db   $1B,$01,$1C,$03
    db   $FF,$FF
    db   $1C,$01,$00,$03
    db   $1C,$01,$00,$03
    db   $1C,$01,$00,$03
    db   $1C,$01,$00,$03
    db   $FF,$FF

_more_cage:
    inc  a
    ld   (scr_cage_up+$00),a
    inc  a
    ld   (scr_cage_up+$01),a
    ret

    dc   19, $FF

;; sfx/tune player
;; plays a few samples of sfx each tick

sfx_01:; La Cucaracha
    ld   a,(ix+$12)
    and  a
    jr   z,sfx_02
    dec  a
    ld   (ix+$12),a
    ret

sfx_02:; Minor-key death ditti
    ld   l,(ix+$07)
    ld   h,(ix+$08)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,sfx_03
    ld   (ix+$07),l
    ld   (ix+$08),h
    call sfx_something_ch_1
    ret

sfx_03:; Pickup bling
    ld   l,(ix+$01)
    ld   h,(ix+$02)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,_4552
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
    call sfx_something_ch_1
    ret

_4552:
    cp   $FF
    ret  z

;;  not sfx routine?
    ld   (ix+$01),l
    ld   (ix+$02),h
    ld   (ix+$07),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$08),a
    call sfx_something_ch_1
    ret

    dc   1, $FF

add_pickup_pat_3:
    ld   a,$8D
    ld   (_911A),a
    ret

    dc   2, $FF

add_pickup_pat_4:
    ld   a,tile_pik_crowna
    ld   (_91B1),a
    ret

    dc   1, $FF

add_pickup_pat_7:
    ld   a,$8E
    ld   (scr_pik_r_W),a
    call add_pickup_pat_5
    ret

sfx_06:; cutscene dance start (also intro tune?)
    ld   a,(ix+$13)
    and  a
    jr   z,_458B
    dec  a
    ld   (ix+$13),a
    ret
;; sfxsomething #4
_458B:
    ld   l,(ix+$09)
    ld   h,(ix+$0a)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,_45A2
    ld   (ix+$09),l
    ld   (ix+$0a),h
    call sfx_something_ch_2
    ret

;; sfxsomething #5
_45A2:
    ld   l,(ix+$03)
    ld   h,(ix+$04)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,_45D2
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
    call sfx_something_ch_2
    ret

;; sfxsomething #6
_45D2:
    cp   $FF
    ret  z
    ld   (ix+$03),l
    ld   (ix+$04),h
    ld   (ix+$09),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0a),a
    call sfx_something_ch_2
    ret

    dc   1, $FF

;;
add_pickup_pat_2:
    ld   a,$8D
    ld   (scr_pik_n_n),a
    ret

    dc   18, $FF

;; sfxsomething #7
_4600:
    ld   a,(ix+$14)
    and  a
    jr   z,_460B
    dec  a
    ld   (ix+$14),a
    ret
_460B:
    ld   l,(ix+$0b)
    ld   h,(ix+$0c)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $FF
    jr   z,_4622
    ld   (ix+$0b),l
    ld   (ix+$0c),h
    call sfx_what_1
    ret

;; sfxsomething #8
_4622:
    ld   l,(ix+$05)
    ld   h,(ix+$06)
    inc  hl
    inc  hl
    ld   a,(hl)
    cp   $EE
    jr   nz,_4652
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
    call sfx_what_1
    ret

;; sfxsomething #9
_4652:
    cp   $FF
    ret  z
    ld   (ix+$05),l
    ld   (ix+$06),h
    ld   (ix+$0b),a
    inc  hl
    ld   a,(hl)
    ld   (ix+$0c),a
    call sfx_what_1
    ret

    dc   25, $FF

;;; sfx something #10
_4680:
    ld   ix,synth1_um_b
    ld   a,(ix+$0d)
    and  a
    jr   z,_46A1
    call sfx_01
    ld   a,(ix+$0d)
    dec  a
    jr   z,_46A1
    call sfx_06
    ld   a,(ix+$0d)
    dec  a
    dec  a
    jr   z,_46A1
    call _4600
    ret
_46A1:
    ret

    dc   14, $FF
;;
add_a_to_ret_addr:
    pop  hl
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    ret

    dc   9, $FF

zero_out_some_sfx:
    ld   hl,synth1_um_b
    ld   b,$18
_46C5:
    ld   (hl),$00
    inc  hl
    djnz _46C5
    ret

    dc   5, $FF

;; gets here on death and re-spawn
clear_sfx_1:
    call zero_out_some_sfx
    ld   a,(ch1_sfx)
    call point_hl_to_sfx_data
    ld   ix,synth1_um_b
    call do_something_with_sfx_data
    xor  a
    ld   (ch1_sfx),a
    ret

    dc   3, $FF

play_tune_for_cur_screen:
    ld   a,(num_players)
    and  a
    ret  z
    ld   a,(player_num)
    and  a
    jr   nz,_46F8
    ld   a,(screen_num)
    jr   _46FB
_46F8:
    ld   a,(screen_num_p2)
_46FB:
    dec  a ; scr - 1
    add  a,a ; ...
    add  a,a ; * 3
    call get_screen_tune_sfx_id
    ld   b,a
    ld   a,(sfx_prev)
    cp   b
    ret  z
    ld   a,b
    ld   (ch1_sfx),a ; wat sfx is this?
    ld   (sfx_prev),a
    ret

    dc   17, $FF

    halt ; only halt in file!
    dec  c
    dc   14, $FF

;;
point_hl_to_sfx_data:
    sla  a ; sfx id * 4
    sla  a
    call add_a_to_ret_addr
_sfx_data_lookup:
    nop ; sfx 0?
    nop
    nop
    ret
    ld   hl,sfx_1_data
    ret
    ld   hl,sfx_2_data
    ret
    ld   hl,sfx_3_data
    ret
    ld   hl,sfx_4_data
    ret
    ld   hl,sfx_5_data
    ret
    ld   hl,sfx_6_data
    ret
    ld   hl,sfx_7_data
    ret
    ld   hl,sfx_8_data
    ret
    ld   hl,sfx_9_data
    ret
    ld   hl,sfx_10_data
    ret
    ld   hl,sfx_11_data
    ret
    ld   hl,sfx_12_data
    ret
    ld   hl,sfx_13_data
    ret
    ld   hl,sfx_14_data
    ret
    ld   hl,sfx_15_data
    ret
    ld   hl,hard_reset
    ret
    ld   hl,hard_reset
    ret
    ld   hl,hard_reset
    ret
    ld   hl,hard_reset
    ret

    dc   9, $FF

;; hl = sfx data
;; ix = ... 82d0, 82e8, or 82b8
do_something_with_sfx_data:
    nop
    nop
    nop
    nop
    ld   a,(hl) ; 1. points at sfx data
    ld   (ix+$0d),a
    ld   b,a
    inc  hl
    ld   a,(hl) ; 2
    ld   (ix+$01),a
    inc  hl
    ld   a,(hl) ; 3
    ld   (ix+$02),a
    dec  b
    jr   z,_here ; branch...
    inc  hl
    ld   a,(hl) ; 4
    ld   (ix+$03),a
    inc  hl
    ld   a,(hl) ; 5
    ld   (ix+$04),a
    dec  b
    jr   z,_here
    inc  hl
    ld   a,(hl) ; 6
    ld   (ix+$05),a
    inc  hl
    ld   a,(hl) ; 7
    ld   (ix+$06),a
_here:
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
    call sfx_something_ch_1
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call sfx_something_ch_2
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call sfx_what_1
    ret

    dc   27, $FF

sfx_queuer:
    ld   a,(ch1_sfx)
    and  a
    jr   nz,_484B
    call _4680 ; play in ch1
    jr   _484E
_484B:
    call clear_sfx_1 ; ... kill ch1?
_484E:
    ld   a,(ch2_sfx) ; and try ch2?
    and  a
    jr   nz,_4859
    call _48E0 ; play in ch2?
    jr   _485C
_4859:
    call clear_sfx_2
_485C:
    ld   a,(sfx_id)
    and  a
    jr   nz,_4867
    call more_sfx_something
    jr   _done_486A
_4867:
    call play_sfx
_done_486A:
    ret

    dc   5, $FF

;;; called from PLAY_SFX...
zero_out_some_sfx_2:
    ld   hl,synth3_um_b
    ld   b,$18
_4875:
    ld   (hl),$00
    inc  hl
    djnz _4875
    ret

    dc   1, $FF

;;; more sfx something
more_sfx_something:
    ld   ix,synth3_um_b
    ld   a,(ix+$0d)
    and  a
    ret  z
    call _4600
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call sfx_01
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call sfx_06
    ret

    dc   2, $FF

play_sfx:
    call zero_out_some_sfx_2
    ld   a,(sfx_id)
    call point_hl_to_sfx_data
    ld   ix,synth3_um_b
    call do_something_with_sfx_data
    xor  a
    ld   (sfx_id),a
    ret

    dc   1, $FF

attract_your_being_chased_flash:
    call your_being_chased_dino_sprite
    call flash_border
    call flash_border
    call flash_border
    call flash_border
    ld   hl,reset_xoff_sprites_and_clear_screen
    call jmp_hl
    call flash_border
    ret

    dc   21, $FF

;;; Even more sfx something
_48E0:
    ld   ix,synth2_um_b
    ld   a,(ix+$0d)
    and  a
    ret  z
    call sfx_06
    ld   a,(ix+$0d)
    dec  a
    ret  z
    call _4600
    ld   a,(ix+$0d)
    dec  a
    dec  a
    ret  z
    call sfx_01
    ret

    dc   2, $FF

jump_rel_a_copy:  ; duplicate routine
    exx
    pop  hl
    ld   b,$00
    ld   c,a
    add  hl,bc
    push hl
    exx
    ret

    dc   7, $FF

zero_out_some_sfx_3:
    ld   hl,synth2_um_b
    ld   b,$18
_4915:
    ld   (hl),$00
    inc  hl
    djnz _4915
    ret

    dc   5, $FF

clear_sfx_2:
    call zero_out_some_sfx_3
    ld   a,(ch2_sfx)
    call point_hl_to_sfx_data
    ld   ix,synth2_um_b
    call do_something_with_sfx_data
    xor  a
    ld   (ch2_sfx),a
    ret

    dc   11, $FF

    nop
    nop
    ld   c,$00
    bit  0,a
    jr   z,_494A
    set  5,b
_494A:
    bit  1,a
    jr   z,_4950
    set  4,b
_4950:
    bit  2,a
    jr   z,_4956
    set  7,c
_4956:
    bit  3,a
    jr   z,_495C
    set  6,c
_495C:
    bit  4,a
    jr   z,_4962
    set  5,c
_4962:
    bit  5,a
    jr   z,_4968
    set  4,c
_4968:
    bit  6,a
    jr   z,_496E
    set  3,c
_496E:
    bit  7,a
    jr   z,_4974
    set  2,c
_4974:
    ld   a,b
    nop
    nop
    nop
    ld   a,c
    nop
    nop
    nop
    ret

    dc   3, $FF

    nop
    nop
    ld   c,$F0
    bit  0,a
    jr   z,_498A
    res  7,c
_498A:
    bit  1,a
    jr   z,_4990
    res  6,c
_4990:
    bit  2,a
    jr   z,_4996
    res  5,c
_4996:
    bit  3,a
    jr   z,_499C
    res  4,c
_499C:
    ld   a,c
    add  a,b
    nop
    nop
    nop
    ret

    dc   14, $FF

;; set the sfx value for the new screen
;; a contains offset of sfx to play for screen
get_screen_tune_sfx_id:
    call add_a_to_ret_addr
    ld   a,$0E ; scr 1
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
    ld   a,$0C ; scr 21: best tune
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

;; notes for haapy intro tune
    db   $15,$01,$17,$01,$19,$01,$1A,$02
    db   $1A,$02,$18,$02,$18,$02,$17,$02
    db   $17,$02,$16,$02,$16,$02,$15,$02
    db   $15,$02,$13,$02,$13,$02,$12,$01
    db   $0E,$01,$10,$01,$0E,$02,$FF,$FF
    db   $15,$01,$17,$01,$19,$01,$21,$01
    db   $26,$02,$21,$01,$26,$02,$21,$02
    db   $20,$01,$26,$02,$20,$01,$26,$02
    db   $20,$02,$1F,$01,$26,$02,$1F,$01
    db   $26,$02,$1F,$02,$1E,$01,$1F,$01
    db   $20,$01,$21,$02
    dc   12, $FF
    db   $13,$04,$1A,$04,$1A,$04,$18,$02
    db   $17,$02,$18,$02,$1A,$02,$1C,$02
    db   $1A,$0A,$FF,$FF,$1F,$02,$1E,$02
    db   $1C
    db   $04
    db   $1A
    db   $02
    db   $18,$02
    db   $17
    db   $04
    db   $15
    db   $02
    db   $13
    db   $02
    db   $15
    db   $02
    db   $17
    db   $0A
    db   $FF
    db   $FF
    db   $23
    db   $02
    db   $21,$02,$1F
    db   $02
    db   $1E,$02
    db   $1C
    db   $02
    db   $1A
    db   $02
    db   $18,$02
    db   $17
    db   $02
    db   $15
    db   $02
    db   $13
    db   $02
    db   $12
    db   $02
    db   $13
    db   $0A
    db   $FF
    db   $FF
    db   $15
    db   $03
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $17
    db   $04
    db   $17
    db   $04
    db   $1A
    db   $08
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $19
    db   $04
    db   $19
    db   $04
    db   $1A
    db   $05
    db   $FF
    db   $FF
    db   $15
    db   $03
    db   $15
    db   $02
    db   $15
    db   $02
    db   $15
    db   $02
    db   $15
    db   $02
    db   $13
    db   $02
    db   $13
    db   $02
    db   $10,$02
    db   $10,$02
    db   $10,$02
    db   $10,$02
    db   $0E,$02
    db   $0E,$02
    db   $09
    db   $02
    db   $09
    db   $01,$09,$02
    db   $FF
    db   $FF
    db   $15
    db   $20
    dc   4, $FF

;; sfx 15 notes/len
_4B0C:
    db   $15,$01,$1A,$02,$15,$01,$1A,$02
    db   $15,$02,$14,$01,$1A,$02,$14,$01
    db   $1A,$02,$14,$02,$13,$01,$1A,$02
    db   $13,$01,$1A,$02,$13,$02,$12,$02
    db   $09,$02,$0E
    db   0x2
    dc   2, $FF
_4B32:
    db   $01,$05,$0F,$00 ; len/vel/vol/trans
_4B36:
    dw   _4B0C  ; notes
    dc   4, $FF
    dw   _4B48
    dc   2, $FF

sfx_15_data:
    db   $03
    dw   _4B32
    dw   _4B36
    dw   _4B36
    db   $FF
_4B48:
    db   $00,$01
    dc   6, $FF

;;
your_being_chased_dino_sprite:
    ld   hl,player_x
    ld   (hl),$85 ; x
    inc  hl
    ld   (hl),$2C ; frame
    inc  hl
    ld   (hl),$12 ; color
    inc  hl
    ld   (hl),$90 ; y
    inc  hl
    ld   (hl),$7E ; x legs
    inc  hl
    ld   (hl),$30 ; frame legs
    inc  hl
    ld   (hl),$12 ; color legs
    inc  hl
    ld   (hl),$A0 ; y legs
    inc  hl
    ret

    dc   116, $FF ; 116 free bytes!

;; sfx 2? notes
_4BE0:
    db   $0E,$04,$0E,$02,$0C,$02,$0E,$04
    db   $11,$02,$10,$02,$0E,$02,$0E,$02
    db   $0C,$02,$0E,$10
    dc   2, $FF

    db   $09
    db   $04
    db   $07
    db   $02
    db   $09
    db   $04
    db   $1A
    db   $02
    db   $18,$02
    db   $18,$02
    db   $09
    db   $02
    db   $09
    db   $02
    db   $07
    db   $02
    db   $09
    db   $04
    dc   38, $FF
_4C30:
    db   $32,$4C,$FF
    db   $FF
    db   $FF
    db   $FF
_4C36:
    db   $01,$04,$0F
    db   $00
    dw   _4BE0  ; point at notes
    db   $FF
    db   $FF
_4C3E:
    db   $F6,$4B
    db   $FF
    db   $FF
    db   $0C
    db   $0C
    db   $FF
    db   $FF

sfx_2_data:
    db   $03
    dw   _4C36
    dw   _4C3E
    dw   _4C30

    dc   3, $FF

;;
add_screen_pickups:
    call draw_cage_top
    ld   a,(player_num)
    and  a
    jr   z,_4C5E
    ld   a,(screen_num_p2)
    jr   _4C61
_4C5E:
    ld   a,(screen_num)
_4C61:
    dec  a ; scr - 1
    add  a,a
    add  a,a ; * 3
    call jump_rel_a_copy
;; One per screen
    call add_pickup_pat_1
    ret
    call add_pickup_pat_2
    ret
    call add_pickup_pat_3
    ret
    call add_pickup_pat_1
    ret
    call add_pickup_pat_4
    ret
    call add_pickup_pat_5
    ret
    call add_pickup_pat_6
    ret
    call add_pickup_pat_2
    ret
    call add_pickup_pat_3
    ret
    call add_pickup_pat_4
    ret
    call add_pickup_pat_7
    ret
    call add_pickup_pat_6
    ret
    call add_pickup_pat_1
    ret
    call add_pickup_pat_8
    ret
    call add_pickup_pat_2
    ret
    call add_pickup_pat_9
    ret
    call add_pickup_pat_6
    ret
    call add_pickup_pat_2
    ret
    call add_pickup_pat_9
    ret
    call add_pickup_pat_6
    ret
    call add_pickup_pat_10
    ret
    call add_pickup_pat_7
    ret
    call add_pickup_pat_6
    ret
    call add_pickup_pat_10
    ret
    call _4170
    ret
    call add_pickup_pat_6
    ret
    nop ; screen 27
    nop ; (no pickups)
    nop
    ret
    nop
    nop
    nop
    ret

    dc   12, $FF

add_pickup_pat_1:
    ld   a,tile_pik_crowna
    ld   (scr_pik_n_n),a
    ret

    dc   1, $FF

;; Runs every frame as cage drops...
;; hl contains screen location of cage
;; so `l` is used as CAGE_Y
check_dino_cage_collision:
    ld   a,(dino_x)
    sub  $84 ; is dino x >= 0x84 (132)?
    scf
    ccf ; ...
    sub  $18 ; and < 132 + 24 (156) ?
    ret  nc ; no: return.
    ld   a,(dino_y) ; yes! check y
    srl  a
    srl  a
    srl  a
    ld   b,a ; b = y / 8
    ld   a,l ; cage_y
    and  $1F ; & 00011111 (?)
    sub  b ; - b
    scf
    ccf ; (... -2)
    jp   check_dino_cage_collision_cont

    dc   1, $FF

draw_cage_tiles:
    call reset_3_row_xoffs
    push hl
    dec  hl
    ld   (hl),tile_blank ; column 1
    inc  hl
    ld   (hl),tile_cage + 2
    inc  hl
    ld   (hl),$77
    inc  hl
    ld   (hl),$7A
    inc  hl
    ld   (hl),$7B
    ld   bc,MINUS_36
    add  hl,bc
    ld   (hl),tile_blank ; column 2
    inc  hl
    ld   (hl),tile_cage
    inc  hl
    ld   (hl),tile_cage + 1
    inc  hl
    ld   (hl),$78
    inc  hl
    ld   (hl),$79
    add  hl,bc
    ld   (hl),tile_blank ; column 3
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

    dc   2, $FF

;; hl = cage screen addr, so l = "Y pos"
;; starts at 0xC9 (201) and incs to 0xDC (220)
trigger_cage_fall:
    call setup_cage_sfx_and_screen
_update_cage_fall:
    call draw_cage_tiles
    push hl
_4D47:
    ld   hl,wait_vblank ; blocks action as cage falls
    call jmp_hl
    ld   a,(tick_num)
    and  $03
    jr   nz,_4D47
    pop  hl
    inc  hl ; move cage down
    call check_dino_cage_collision
    ld   a,$DC ; did cage hit ground?
    cp   l
    ret  z
    jr   _update_cage_fall ; nope, loop

    dc   1, $FF

reset_3_row_xoffs:              ; which ones?
    xor  a
    ld   (screen_xoff_col+$26),a
    ld   (screen_xoff_col+$28),a
    ld   (screen_xoff_col+$2A),a
    ret

    dc   9, $FF

end_screen_logic:
    ld   a,(player_num) ; are we on end screen?
    and  a
    jr   nz,_4D7F
    ld   a,(screen_num)
    jr   _4D82
_4D7F:
    ld   a,(screen_num_p2)
_4D82:
    cp   $1B ; // check is screen 27
    ret  nz
    call check_player_cage_collision
    ret

    dc   7, $FF

check_player_cage_collision:
    ld   a,(is_hit_cage)
    and  a
    ret  nz
    ld   a,(player_x)
    sub  $70
    scf
    ccf
    sub  $20
    ret  nc
    ld   a,(player_y)
    sub  $30
    scf
    ccf
    sub  $1C
    ret  nc
    ld   a,$01 ; Yep, trigger cage
    ld   (is_hit_cage),a
    call trigger_cage_fall
    ret

    dc   2, $FF

check_dino_cage_collision_cont:
    sub  $02 ; less than 2 diff?
    ret  nc ; no, no Y collision
    jp   done_caged_dino ; yes, caged the dino

    dc   6, $FF

;;
wait_vblank_40:
    ld   l,$40
_lp_4DC2:
    push hl
    ld   hl,wait_vblank
    call jmp_hl
    pop  hl
    dec  l
    jr   nz,_lp_4DC2
    ret

    dc   2, $FF

done_caged_dino:
    xor  a
    ld   (dino_x),a
    ld   (dino_x_legs),a
_loop__cage_dino:
    call draw_cage_tiles
    push hl
    ld   hl,wait_vblank
    call jmp_hl
    pop  hl
    inc  hl
    ld   a,$DC
    cp   l
    jr   nz,_loop__cage_dino
    ld   a,$91
    ld   (dino_x),a
    ld   a,$38
    ld   (dino_frame),a
    ld   a,$12
    ld   (dino_col),a
    ld   a,$D7
    ld   (dino_y),a
    ld   a,$8A
    ld   (dino_x_legs),a
    ld   a,$39
    ld   (dino_frame_legs),a
    ld   a,$12
    ld   (dino_col_legs),a
    ld   a,$E7
    ld   (dino_y_legs),a
    call wait_vblank_40
    call speed_up_for_next_round
    ld   hl,do_cutscene
    call jmp_hl
    ret

    dc   3, $FF

attract_splash_bongo:
    call draw_border_and_jetsoft
    call jmp_hl ; hl = $DRAW_JETSOFT
    call flash_border
    ld   hl,draw_proudly_presents
    call jmp_hl
    call flash_border
    ld   hl,clear_and_draw_screen
    call jmp_hl
    ld   a,$07
    ld   (screen_num),a
    ld   (screen_num_p2),a
    ld   hl,draw_background
    call jmp_hl
    ld   hl,blank_out_bottom_row
    call jmp_hl
    ld   hl,scr_bongo_logo ; draw the BONGO logo
    ld   b,tile_logo_st
    ld   c,$05
_loop_4E53:
    ld   (hl),b ; top right
    inc  b
    inc  hl
    ld   (hl),b ; bottom right
    inc  b
    ld   de,$001F
    add  hl,de
    ld   (hl),b ; top left
    inc  b
    inc  hl
    ld   (hl),b ; bottom left
    ld   de,MINUS_95
    add  hl,de
    inc  b
    call wait_30_for_start_button
    dec  c
    jr   nz,_loop_4E53
    ld   hl,draw_copyright
    call jmp_hl
    jp   attract_animate_player_up_stairs

    dc   1, $FF

;;
setup_cage_sfx_and_screen:
    push af
    ld   a,$05
    ld   (sfx_id),a
    pop  af
    ld   hl,_91C9
    ret

draw_border_and_jetsoft:
    ld   hl,draw_border_1
    call jmp_hl
    ld   hl,draw_jetsoft
    ret

    dc   6, $FF

;; This totally does nothing but waste some
;; cycles right? A reg is not even used after
;; Maybe it was nopped out? debug?
load_a_val_really_weird:
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
    call jump_rel_a_copy
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38
    rst  $38

;; on splash screen something... wait a bunch
wait_60_for_start_button:
    call wait_15_for_start_button
    call wait_15_for_start_button
    call wait_15_for_start_button
    call wait_15_for_start_button
    ret

    dc   5, $FF

wait_15_for_start_button:
    ld   d,$0E
_loop__w15:
    push hl
    push bc
    push de
    ld   hl,wait_for_start_button
    call jmp_hl
    pop  de
    pop  bc
    pop  hl
    dec  d
    jr   nz,_loop__w15
    ret

;; what 30 for start
wait_30_for_start_button:
    call wait_15_for_start_button
    call wait_15_for_start_button
    ret

    dc   5, $FF

speed_up_for_next_round:
    ld   a,(player_num)
    and  a
    jr   nz,_4EEB
    ld   hl,speed_delay_p1
    jr   _4EEE
_4EEB:
    ld   hl,speed_delay_p2
_4EEE:
    ld   a,(hl)
    cp   round1_speed
    jr   nz,_4EF6
    ld   (hl),round2_speed ; round 2 = $10
    ret
_4EF6:
    cp   round2_speed
    jr   nz,_4EFD
    ld   (hl),round3_speed ; round 3 = $0d
    ret
_4EFD:
    jp   even_more_faster_dino ; round 4+ = get 2 faster each time!

pickups_lookup:
PCA = tile_pik_crowna
    db   $91,$5A,PCA,$00,$00,$00,$00,$00,$00 ;  up to 3 pickups per screen
    db   $91,$5A,$8D,$00,$00,$00,$00,$00,$00 ;  pos (hi), pos (lo), pickup symbol
    db   $91,$1A,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$5A,PCA,$00,$00,$00,$00,$00,$00
    db   $91,$B1,PCA,$00,$00,$00,$00,$00,$00
    db   $91,$8E,PCA,$00,$00,$00,$00,$00,$00
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$5A,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$1A,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$B1,PCA,$00,$00,$00,$00,$00,$00
    db   $90,$CB,$8E,$91,$8E,PCA,$00,$00,$00
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$5A,PCA,$00,$00,$00,$00,$00,$00
    db   $92,$7A,$8E,$91,$1A,$8D,$00,$00,$00
    db   $91,$5A,$8D,$00,$00,$00,$00,$00,$00
    db   $92,$EE,$83,$92,$17,$8E,$00,$00,$00
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $91,$5A,$8D,$00,$00,$00,$00,$00,$00
    db   $92,$EE,$83,$92,$17,$8E,$00,$00,$00
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $92,$17,PCA,$92,$31,$8D,$92,$2B,$8F
    db   $90,$CB,$8E,$91,$8E,PCA,$00,$00,$00
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $92,$17,PCA,$92,$31,$8D,$92,$2B,$8F
    db   $90,$CB,$8E,$91,$8E,PCA,$92,$AB,$8E
    db   $91,$D2,$8D,$00,$00,$00,$00,$00,$00
    db   $00,$00,$00,$00,$00,$00,$00,$00,$00 ;  Screen 27 (cage - no pickups)
    db   $00,$00,$00,$00,$00,$00,$00,$00,$00
    db   $00,$00

    dc   2, $FF

;;; === END OF BG5.BIN, START OF BG6.BIN ======

animate_pickups:
    ld   b,(hl)
    inc  hl
    ld   c,(hl)
    inc  hl
    ld   a,(bc)
    cp   $10
    jr   z,_501A
    ld   e,a
    and  $F0
    cp   $80
    jr   nz,_5016
    ld   a,e
    add  a,$10
    ld   (bc),a
    jr   _501A
_5016:
    ld   a,e
    sub  $10
    ld   (bc),a
_501A:
    inc  hl
    ret

;; Decrease the speed timer further each round
even_more_faster_dino:
    dec  a
    dec  a
    ld   (hl),a
    ret

animate_all_pickups:
    ld   a,(tick_num)
    and  $03
    ret  nz
    ld   hl,pickups_lookup
    ld   a,(player_num)
    and  a
    jr   z,_5034
    ld   a,(screen_num_p2)
    jr   _5037
_5034:
    ld   a,(screen_num)
_5037:
    dec  a ; Get screen x 9
    ld   b,a
    add  a,a
    add  a,a
    add  a,a
    add  a,b
    add  a,l ; index into PICKUPS table
    ld   l,a
    ld   a,(hl) ; Find pickup screen addr
    and  a
    ret  z
    call animate_pickups
    ld   a,(hl)
    and  a
    ret  z
    call animate_pickups
    ld   a,(hl)
    and  a
    ret  z
    call animate_pickups
    ret

    dc   1, $FF

sfx_3_data:
    db   $03
    dw   _5084
    dw   _5090
    dw   _508C
    dc   6, $FF
;; notes
    db   $0C
    db   $01,$0E,$01
    db   $10,$01
    db   $11,$01,$13
    db   $03
    db   $FF
    db   $FF
    db   $13
    db   $01,$15,$01
    db   $17
    db   $01,$18,$01
    db   $1A
    db   $03
    db   $FF
    db   $FF
    db   $18,$01
    db   $1A
    db   $01,$1C,$01
    db   $1D
    db   $01,$1F,$03
    db   $FF
    db   $FF
_5084:
    db   $02
    db   $02
    db   $0F
    db   $10,$60
    db   $50
    db   $FF
    db   $FF
_508C:
    db   $6E
    db   $50
    db   $FF
    db   $FF
_5090:
    db   $6C
    db   $50
    db   $FF
    db   $FF
;; sfx 4 notes
_5094:
    db   $00,$01,$02,$01,$04,$01,$06,$01
    db   $08,$01,$0A,$01,$0C,$01,$0E,$01
    dc   8, $FF
_50AC:
    dc   4, $FF
_50B0:
    db   $01,$01,$0F,$00 ; len/vel/vol/trans
    dw   _5094
    dc   2, $FF
    db   $94
    db   $10
    db   $FF,$FF

sfx_4_data:
    db   $03
    dw   _50B0
    dw   _50C8
    dw   _50C8
    dc   5, $FF
_50C8:
    dw   _50AC  ; really? Middle of $ff's
    dc   2, $FF
;; notes
    db   $18,$01
    db   $17
    db   $01,$15,$01
    db   $13
    db   $01,$11,$01
    db   $10,$01
    db   $0E,$01
    db   $0C
    db   $01,$0B,$01
    db   $09
    db   $01,$07,$01
    db   $05
    db   $01,$04,$01
    db   $02
    db   $01,$00,$01
    db   $FF
    db   $FF

sfx_5_data:
    db   $03
    db   $F4,$50,$F4
    db   $51
    db   $F4,$51,$FF
    db   $03
    db   $03
    db   $0F
    db   $10,$CC
    db   $50
    db   $FF
    db   $FF
    db   $2B
    db   $02
    db   $34
    db   $02
    db   $34
    db   $02
    db   $34
    db   $02
    db   $32,$01,$34
    db   $01,$32,$01
    db   $30,$01
    db   $2F
    db   $01,$2D,$01
    db   $2B
    db   $02
    db   $2D
    db   $02
    db   $2D
    db   $02
    db   $32,$01,$34
    db   $01,$26,$02
    db   $FF
    db   $FF
    db   $37
    db   $02
    db   $2F
    db   $02
    db   $32,$04,$FF
    db   $FF
    db   $2B
    db   $01,$26,$01
    db   $23
    db   $01,$26,$01
    db   $1F
    db   $04
    db   $FF
    db   $FF
    db   $0C
    db   $01,$10,$01
    db   $13
    db   $01,$10,$01
    db   $0C
    db   $01,$0C,$01
    db   $0E,$01
    db   $10,$01
    db   $0B
    db   $01,$0C,$01
    db   $0B
    db   $01,$09,$01
    db   $07
    db   $01,$07,$01
    db   $09
    db   $01,$0B,$01
    db   $09
    db   $01,$0B,$01
    db   $09
    db   $01,$07,$01
    db   $06,$01
    db   $06,$01
    db   $07
    db   $01,$09,$01
    db   $FF
    db   $FF
    db   $07
    db   $01,$07,$01
    db   $0B
    db   $01,$0C,$01
    db   $0E,$01
    db   $07
    db   $01,$0B,$01
    db   $0E,$01
    db   $FF
    db   $FF
    db   $07
    db   $01,$0C,$01
    db   $0B
    db   $01,$09,$01
    db   $07
    db   $04
    db   $FF
    db   $FF
_5182:
    db   $01,$08,$0F
    db   $00
    db   $32,$51,$1E
    db   $51
    db   $FC,$50,$26
    db   $51
    db   $FC,$50,$1E
    db   $51
    db   $FC,$50,$26
    db   $51
    db   $FF
    db   $FF
    db   $FF
    db   $FF

sfx_6_data:
    db   $02
    dw   _5182
    dw   _51A8
    dw   _51A8
    dc   2, $FF
    db   $98,$11
    dc   2, $FF
    db   $FF
_51A8:
    db   $FC,$50,$64
    db   $51
    db   $32,$51,$76
    db   $51
    db   $32,$51,$64
    db   $51
    db   $32,$51,$76
    db   $51
    db   $FF
    db   $FF
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $0C
    db   $02
    db   $18,$02
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $03
    db   $03
    db   $0F
    db   $10,$BA
    db   $51
    db   $FF
    db   $FF
    db   $CA,$11,$FF
    db   $FF
    db   $F8
    db   $51
    db   $FF
    db   $FF

sfx_7_data:
    db   $03,$DA,$51,$E6,$51,$F4,$51,$FF
    db   $FF
    db   $FF
    dw   _51F8
    dc   2, $FF
_51F8:
    dc   8, $FF

play_sfx_chunk_ch_1:
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,_520F
    ld   a,$02
    ld   (sfx_val_4),a
    jr   _5225
_520F:
    ld   a,(sfx_val_4)
    and  a
    jr   z,_5225
    dec  a
    ld   (sfx_val_4),a
    ld   a,(sfx_val_1)
    and  a
    jr   z,_5223
    dec  a
    ld   (sfx_val_1),a
_5223:
    pop  hl
    ret
_5225:
    ld   a,l
    cp   $D0
    jr   nz,_5231
    ld   a,$02
    ld   (sfx_val_1),a
    jr   _523D
_5231:
    ld   a,(sfx_val_1)
    and  a
    jr   z,_523D
    dec  a
    ld   (sfx_val_1),a
    pop  hl
    ret
_523D:
    ld   a,(ix+$10)
    ret

    dc   15, $FF

;; triggers every few frames.
;; Maybe play current chunk of tune?
;; looks the same as above funk (ch1?)
play_sfx_chunk_ch_2:
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,_525F
    ld   a,$02
    ld   (sfx_val_5),a
    jr   _5275
_525F:
    ld   a,(sfx_val_5)
    and  a
    jr   z,_5275
    dec  a
    ld   (sfx_val_5),a
    ld   a,(sfx_val_2)
    and  a
    jr   z,_5273
    dec  a
    ld   (sfx_val_2),a
_5273:
    pop  hl
    ret
_5275:
    ld   a,l
    cp   $D0
    jr   nz,_5281
    ld   a,$02
    ld   (sfx_val_2),a
    jr   _528D
_5281:
    ld   a,(sfx_val_2)
    and  a
    jr   z,_528D
    dec  a
    ld   (sfx_val_2),a
    pop  hl
    ret
_528D:
    ld   a,(ix+$10)
    ret

    dc   15, $FF

;;??
sfx_sub_what_1:
    push ix
    pop  hl
    ld   a,l
    cp   $E8
    jr   nz,_52AF
    ld   a,$02
    ld   (sfx_val_6),a
    jr   _52C5
_52AF:
    ld   a,(sfx_val_6)
    and  a
    jr   z,_52C5
    dec  a
    ld   (sfx_val_6),a
    ld   a,(sfx_val_3)
    and  a
    jr   z,_52C3
    dec  a
    ld   (sfx_val_3),a
_52C3:
    pop  hl
    ret
_52C5:
    ld   a,l
    cp   $D0
    jr   nz,_52D1
    ld   a,$02
    ld   (sfx_val_3),a
    jr   _52DD
_52D1:
    ld   a,(sfx_val_3)
    and  a
    jr   z,_52DD
    dec  a
    ld   (sfx_val_3),a
    pop  hl
    ret
_52DD:
    ld   a,(ix+$10)
    ret

    dc   1, $FF

;;
attract_animate_player_up_stairs:
    call wait_60_for_start_button
    ld   hl,player_x
    ld   (hl),$D8 ; x (right of screen)
    inc  hl
    ld   (hl),$8D ; frame
    inc  hl
    ld   (hl),$11 ; color
    inc  hl
    ld   (hl),$E0 ; y (bottom of screen)
    inc  hl
    ld   (hl),$D8 ; x legs
    inc  hl
    ld   (hl),$8D ; frame legs
    inc  hl
    ld   (hl),$11 ; color legs
    inc  hl
    ld   (hl),$F0 ; y legs
    ld   e,$06
_jump_up_stair:
    call attract_jump_up_one_stair
    dec  e
    jr   nz,_jump_up_stair
    ld   hl,bongo_x ; using bongo - but it shows dino
    ld   (hl),$20 ; x (left of screen)
    inc  hl
    ld   (hl),$2D ; frame
    inc  hl
    ld   (hl),$12 ; color
    inc  hl
    ld   (hl),$28 ; y (top of screen)
    inc  hl
    ld   (hl),$19 ; x legs
    inc  hl
    ld   (hl),$30 ; frame legs
    inc  hl
    ld   (hl),$12 ; color legs
    inc  hl
    ld   (hl),$38 ; y legs
    call attract_jump_down_stairs
    jp   call_attract_bonus_screen

    dc   1, $FF

;;; On the splash screen, player animates jumping
;;; up one stair (this repeats for each stair)
attract_jump_up_one_stair:
    ld   d,$00
_lp_532A:
    ld   hl,attract_player_up_stair_data
    ld   a,d
    add  a,a
    add  a,a
    add  a,l
    ld   l,a
    ld   ix,player_x
    ld   a,(hl)
    ld   (ix+$01),a ; frame
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a ; frame leg
    inc  hl
    ld   a,(hl)
    add  a,(ix+$00) ; x-offset
    ld   (ix+$00),a ; x
    ld   (ix+$04),a ; x legs
    inc  hl
    ld   a,(hl)
    add  a,(ix+$03) ; y-offset
    ld   (ix+$03),a ; y
    sub  $10
    ld   (ix+$07),a ; y legs
    push de
    ld   hl,wait_for_start_button
    call jmp_hl
    ld   hl,wait_for_start_button
    call jmp_hl
    ld   hl,wait_for_start_button
    call jmp_hl
    pop  de
    inc  d
    ld   a,d
    cp   $06
    jr   nz,_lp_532A
    call wait_30_for_start_button
    ret

    dc   11, $FF

;; frame, frame leg, x-off, y-off
attract_player_up_stair_data:
    db   $8D,$8C,$FC,$F4 ;  jumping up stairs
    db   $8F,$8E,$FC,$F6
    db   $91,$90,$FC,$F8
    db   $96,$92,$FC,$F8
    db   $94,$93,$FC,$06 ;  frames are swapped!  head on the bottom!
    db   $8D,$8C,$FC,$08

attract_animate_dino_head:
    ld   a,(bongo_frame)
    cp   $2D
    jr   nz,_53A6
    ld   a,$2C
    ld   (bongo_frame),a
    jr   _done_54AB
_53A6:
    ld   a,$2D
    ld   (bongo_frame),a
_done_54AB:
    ret

attract_jump_down_stairs:
    ld   e,$06 ; 6 stairs down
_53AE:
    call attract_jump_down_one_stair
    call attract_animate_dino_head
    dec  e
    jr   nz,_53AE
    ret

;; identical to jump up, but point at down data.
attract_jump_down_one_stair:
    ld   d,$00
_loop__53BA:
    ld   hl,attract_player_down_stair_data
    ld   a,d
    add  a,a
    add  a,a
    add  a,l
    ld   l,a
    ld   ix,player_x
    ld   a,(hl)
    ld   (ix+$01),a ; frame
    inc  hl
    ld   a,(hl)
    ld   (ix+$05),a ; frame leg
    inc  hl
    ld   a,(hl)
    add  a,(ix+$00) ; x-offset
    ld   (ix+$00),a ; x
    ld   (ix+$04),a ; x legs
    inc  hl
    ld   a,(hl)
    add  a,(ix+$03) ; y-offset
    ld   (ix+$03),a ; y
    sub  $10
    ld   (ix+$07),a ; y legs
    push de
    ld   hl,wait_for_start_button
    call jmp_hl
    ld   hl,wait_for_start_button
    call jmp_hl
    ld   hl,wait_for_start_button
    call jmp_hl
    pop  de
    inc  d
    ld   a,d
    cp   $06
    jr   nz,_loop__53BA
    call wait_15_for_start_button
    ret

    dc   3, $FF

;; frame, frame leg, x-off, y-off
attract_player_down_stair_data:
    db   $0D,$0C,$04,$F8
    db   $0F,$0E,$04,$00
    db   $11,$10,$04,$08
    db   $16,$12,$04,$08
    db   $14,$13,$04,$08 ;  WHAT?! Wrong on the way down too! Head and legs flipped.
    db   $0D,$0C,$04,$08

    dc   8, $FF

call_attract_bonus_screen:
    ld   hl,attract_bonus_screen
    call jmp_hl
    ret

    dc   1, $FF

attract_cage_falls_on_dino:
    ld   hl,scr_attract_cage
_lp_5433:
    call draw_cage_tiles
    push hl
    call attract_animate_pickups_and_wait
    nop
    nop
    nop
    pop  hl
    inc  hl
    ld   a,$39 ; check if cage hit ground
    cp   l
    jr   nz,_lp_5433
    ld   a,$38 ; caged dino sprite
    ld   (player_frame),a
    inc  a
    ld   (player_frame_legs),a
    ret

    dc   2, $FF

attract_dino_runs_along_ground:
    ld   ix,player_x ; this is a dino on attract screen
    ld   a,$79
    cp   (ix+$00)
    ret  z
    inc  (ix+$00) ; dino runs along ground
    inc  (ix+$04)
    ld   a,(tick_num)
    and  $03
    jr   nz,_548B
    ld   a,(ix+$05)
    inc  a
    cp   $33
    jr   nz,_5471
    ld   a,$31
_5471:
    ld   (ix+$05),a
    ld   a,(tick_num)
    and  $0F
    cp   $05
    jr   nz,_5483
    ld   (ix+$01),$2C
    jr   _548B
_5483:
    cp   $08
    jr   nz,_548B
    ld   (ix+$01),$2D
_548B:
    call attract_animate_pickups_and_wait
    nop
    nop
    nop
    jr   attract_dino_runs_along_ground

    dc   1, $FF

attract_catch_dino:
    ld   hl,player_x ; oi! You made the player a dinosaur!
    ld   (hl),$07 ; x
    inc  hl
    ld   (hl),$2D ; frame : 2d is dino?
    inc  hl
    ld   (hl),$12 ; colr
    inc  hl
    ld   (hl),$BF ; y
    inc  hl
    ld   (hl),$00 ; x legs
    inc  hl
    ld   (hl),$30 ; frame legs
    inc  hl
    ld   (hl),$12 ; col legs
    inc  hl
    ld   (hl),$CF ; y legs
    ld   hl,scr_attract_cage
    call draw_cage_tiles
    call attract_dino_runs_along_ground
    call attract_dino_cage_invert
    call attract_cage_falls_on_dino
    call attract_dino_cage_invert
    ret

    dc   1, $FF

;;
attract_animate_pickups_and_wait:
    ld   a,(tick_num)
    and  $03
    jr   nz,_54CF
    ld   hl,animate_splash_pickup_nops
    call jmp_hl
_54CF:
    ld   hl,wait_for_start_button
    call jmp_hl
    ret

    dc   2, $FF

attract_dino_cage_invert:
    ld   e,$20
_54DA:
    push de
    call attract_animate_pickups_and_wait
    pop  de
    dec  e
    jr   nz,_54DA
    ret

    rst  $38

;; notes
    db   $2D
    db   $02
    db   $2D
    db   $01,$2D,$01
    db   $2D
    db   $02
    db   $2A,$02,$2D
    db   $02
    db   $32,$04,$FF
    db   $FF
    db   $21,$02,$21
    db   $01,$21,$01
    db   $21,$02,$1E
    db   $02
    db   $21,$02,$26
    db   $04
    db   $FF
    db   $FF
    db   $01,$03,$0F
    db   $00
    db   $E4,$54,$FF
    db   $FF
    db   $F4,$54,$FF
    db   $FF
    dw   _556C
    db   $FF
    db   $FF

sfx_8_data:
    db   $03,$04,$55,$08,$55,$08,$55,$FF
    db   $FF,$FF,$FF,$FF

;; mabye sfx?
reset_sfx_something_1:
    xor  a
    ld   (_8046),a
    ld   a,(synthy_um_1)
    and  a
    jr   nz,_552F
    ld   a,$F9
    nop
    nop
    nop
_552F:
    ld   a,(synthy_um_2)
    and  a
    jr   nz,_553A
    ld   a,$FD
    nop
    nop
    nop
_553A:
    ld   a,(synthy_um_3)
    and  a
    jr   nz,_5545
    ld   a,$FB
    nop
    nop
    nop
_5545:
    ld   a,$FF
    nop
    nop
    nop
    ret

    dc   5, $FF

;; sfx notes + data
    db   $10,$01,$0B,$01,$08,$01,$FF,$FF
    db   $04,$04,$0F,$10,$50,$55,$FF,$FF

sfx_10_data:
    db   $03,$58,$55,$5C,$55,$5C,$55,$FF
    db   $6A,$55,$FF,$FF
_556C:
    db   $FF,$FF,$FF,$FF

;; bytes after the call are
;; start_y, start_x, tile 1, ...tile x, 0xFF
draw_tiles_h_copy:
    ld   a,(watchdog) ; is this ack? "A" not used
    ld   hl,start_of_tiles
    pop  bc ; stack return pointer into bc (ie, data)
    ld   a,(bc) ; start_y
    inc  bc
    add  a,l
    ld   l,a
    ld   a,(bc) ; start_x
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
_lp_558E:
    ld   a,(bc) ; each character until 0xff
    inc  bc
    cp   $FF
    jr   nz,_5596
    push bc
_done_5595:
    ret
_5596:
    ld   (hl),a ; writes to screen loc
    ld   d,$FF
    ld   e,$E0
    add  hl,de
    jr   _lp_558E

    dc   2, $FF

chased_by_a_dino_screen:
    ld   hl,reset_xoff_sprites_and_clear_screen
    call jmp_hl
    call draw_buggy_border
    nop
    nop
    nop
    call flash_border
    call draw_tiles_h_copy
    db   $08,$0B
;; BEWARE
    db   B_,E_,W_,A_,R_,E_,$FF
    call flash_border
    call draw_tiles_h_copy
    db   $0C,$05
;; YOUR BEING CHASED
    db   Y_,O_,U_,R_,__,B_,E_,I_,N_,G_,__,C_,H_,A_,S_,E_,D_,$FF
    call flash_border
    call draw_tiles_h_copy
    db   $10,$07
;; BY A DINOSAUR (classic!)
    db   B_,Y_,__,A_,__,D_,I_,N_,O_,S_,A_,U_,R_,$FF
    jp   attract_your_being_chased_flash

    dc   2, $FF

;;  notes
    db   $A1,$02,$C3,$02,$A1,$02,$C3,$02
    db   $A1,$02,$C3,$02,$A1,$02,$C3,$02
    db   $FF,$FF,$FF,$FF
    db   $00
    db   $02
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $0E,$0E
    db   $FF
    db   $FF
    db   $E0
    db   $15
    db   $FF
    db   $FF
    db   $44
    db   $15
    db   $48
    db   $15
    db   $48
    db   $15
    db   $A0
    db   $15
    db   $A0
    db   $15
    db   $EE,$09
    db   $FF
    db   $FF
    db   $70
    db   $18,$70
    db   $18,$30
    db   $17
    db   $B0
    db   $18,$EE
    db   $05
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $0E,$02
    db   $13
    db   $04
    db   $13
    db   $04
    db   $13
    db   $02
    db   $13
    db   $06,$1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $02
    db   $1E,$06
    db   $1C
    db   $04
    db   $1E,$02
    db   $1C
    db   $02
    db   $1A
    db   $06,$17
    db   $04
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $13
    db   $02
    db   $17
    db   $02
    db   $18,$02
    db   $1A
    db   $02
    db   $1A
    db   $04
    db   $1A
    db   $04
    db   $1A
    db   $06,$1A
    db   $02
    db   $18,$06
    db   $18,$04
    db   $18,$02
    db   $18,$02
    db   $18,$02
    db   $17
    db   $02
    db   $17
    db   $02
    db   $13
    db   $04
    db   $17
    db   $04
    db   $18,$02
    db   $0E,$02
    db   $FF
    db   $FF
    db   $09
    db   $02
    db   $0B
    db   $04
    db   $0B
    db   $04
    db   $0B
    db   $02
    db   $0C
    db   $06,$15
    db   $04
    db   $15
    db   $04
    db   $15
    db   $02
    db   $1A
    db   $06,$18
    db   $04
    db   $1A
    db   $02
    db   $18,$02
    db   $15
    db   $06,$13
    db   $04
    db   $FF
    db   $FF
    db   $0E,$02
    db   $13
    db   $02
    db   $13
    db   $02
    db   $15
    db   $02
    db   $15
    db   $04
    db   $15
    db   $04
    db   $15
    db   $06,$15
    db   $02
    db   $13
    db   $06,$13
    db   $04
    db   $13
    db   $02
    db   $13
    db   $02
    db   $13
    db   $02
    db   $13
    db   $02
    db   $13
    db   $02
    db   $0E,$04
    db   $13
    db   $04
    db   $13
    db   $02
    db   $15
    db   $02
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $05
    db   $05
    db   $0C
    db   $00
    db   $0C
    db   $16,$30
    db   $16,$30
    db   $16,$50
    db   $16,$50
    db   $16,$EE
    db   $09

draw_buggy_border:
    ld   a,$01
    call set_row_colors
    ld   hl,draw_border_1
;; THIS IS A BUG! It's supposed to call draw_border
;; to put the inner rounded border on the beautiful
;; "YOUR BEING CHASED BY A DINO" screen, but the typo
;; jumps to middle of nowhere, that happens to be
;; ... 0x40 (ld b,b), 0xC9 (ret). Phew, does nothing...
;; It's supposed to be: call $5C81 (JMP_HL)
;;
;; (err, did they call everything by hand without labels?!)
    call $4C81 ; bad jump, no inner border for us :(
    ret

    dc   4, $FF

;; ??? who knows...
    db   $03,$C0
    db   $16,$A0
    db   $18,$22
    db   $16,$FF

;;
sfx_reset_a_bunch:
    call zero_out_some_sfx
    call zero_out_some_sfx_2
    call zero_out_some_sfx_3
    call reset_sfx_something_1
    ret

    dc   3, $FF

;; notes
    db   $12
    db   $01,$0E,$01
    db   $12
    db   $01,$0E,$01
    db   $10,$01
    db   $0D
    db   $01,$10,$01
    db   $0D
    db   $01,$0E,$01
    db   $0B
    db   $01,$0E,$01
    db   $0B
    db   $01,$0D,$01
    db   $09
    db   $01,$0D,$01
    db   $09
    db   $01,$04,$01
    db   $06,$01
    db   $07
    db   $01,$09,$01
    db   $0B
    db   $01,$0D,$01
    db   $0E,$01
    db   $10,$01
    db   $0E,$02
    db   $09
    db   $02
    db   $0E,$04
    db   $FF
    db   $FF
    db   $A1
    db   $02
    db   $C3,$02,$A1
    db   $02
    db   $C3,$02,$A1
    db   $02
    db   $C3,$02,$A1
    db   $02
    db   $C3,$02,$A1
    db   $02
    db   $C3,$01,$C3
    db   $01,$A0,$02
    db   $A0
    db   $02
    db   $D3,$01
    db   $D3,$01
    db   $D3,$01
    db   $D3,$01
    db   $C0
    db   $02
    db   $C1
    db   $02
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
_5760:
    db   $01,$08,$0F
    db   $10,$F8
    db   $56
    db   $FF
    db   $FF
_5768:
    db   $80
    db   $57
    db   $FF
    db   $FF
_576C:
    db   $6E
    db   $57
    db   $FF
    db   $FF

sfx_9_data:
    db   $02
    dw   _5760
    dw   _5768
    dw   _576C
    dc   9, $FF
    db   $15
    db   $01,$0E,$01
    db   $15
    db   $01,$0E,$01
    db   $15
    db   $01,$10,$01
    db   $15
    db   $01,$10,$01
    db   $13
    db   $01,$0E,$01
    db   $13
    db   $01,$0E,$01
    db   $10,$01
    db   $09
    db   $01,$10,$01
    db   $09
    db   $01,$09,$01
    db   $0B
    db   $01,$09,$01
    db   $07
    db   $01,$06,$01
    db   $04
    db   $01,$02,$01
    db   $04
    db   $01,$02,$02
    db   $06,$02
    db   $02
    db   $04
    dc   10, $FF

call_draw_extra_bonus_screen:
    jp   draw_extra_bonus_screen
;;; How is this different to the other extra bonus screen?...
;;; does it ever get here?
    call jmp_hl
    ld   hl,draw_border_1
    call jmp_hl
    call draw_tiles_h_copy
    db   $08,$08
    db   E_,X_,T_,R_,A_,__,B_,O_,N_,U_,S_,$FF
    call draw_tiles_h_copy
    db   $09,$08
    dc   11, tile_hyphen        ; hyphens under EXTRA BONUS
    db   $FF
    call wait_60_for_start_button
    call wait_60_for_start_button
    call draw_tiles_h_copy
    db   $0C,$07
    db   P_,I_,C_,K_,__,U_,P_,__,6,__,B_,O_,N_,U_,S_,$FF
    call draw_tiles_h_copy
    db   $10,$07
    db   O_,B_,J_,E_,C_,T_,S_,__,W_,I_,T_,H_,O_,U_,T_,$FF
    call draw_tiles_h_copy
    db   $14,$07
    db   L_,O_,S_,I_,N_,G_,__,A_,__,L_,I_,F_,E_,$FF
    call wait_60_for_start_button
    call wait_60_for_start_button
    call draw_tiles_h_copy
    db   $17,$0B
    db   $E0,$DC,$DD,$DE,$DF,$FF
    call draw_tiles_h_copy
    db   $18,$0B
    db   $E1,$E8,$EA,$F2,$E6,$FF
    call draw_tiles_h_copy
    db   $19,$0B
    db   $E1,$E9,$EB,$F3,$E6,$FF
    call draw_tiles_h_copy
    db   $1A,$0B
    db   $E2,$E3,$E3,$E3,$E4,$FF
    call wait_60_for_start_button
    call wait_60_for_start_button
    call wait_60_for_start_button
    call wait_60_for_start_button
    ret

;; notes
    db   $A2,$01,$A2,$01,$A2,$01,$A2,$01
    db   $B2,$01,$B2,$01,$B2,$01,$B2,$01
    db   $C2,$01,$C2,$01,$C2,$01,$C2,$01
    db   $D2,$01,$D2,$01,$D2,$01,$D2,$01
    db   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db   $0C,$16,$78,$16,$78,$16,$96,$16
    db   $96,$16,$EE,$09,$FF,$FF,$FF,$FF
    db   $A1,$02,$C3,$02,$A1,$02,$C3,$02
    db   $A1,$02,$C3,$02,$A1,$02,$C3,$02
    db   $A0,$02,$D3,$01,$D3,$01,$D3,$01
    db   $D3,$01,$FF,$FF,$FF,$FF,$FF,$FF

;; bytes after the call are:
;; start_x, start_y, tile 1, ...tile id, 0xFF
draw_tiles_v:
    pop  ix ; pops next addr (eg, data) from stack
    ld   h,$00
    ld   l,(ix+$00) ; start_x
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    add  hl,hl
    inc  ix ; start_y
    ld   a,(ix+$00)
    add  a,l
    ld   l,a
    ld   bc,start_of_tiles
    add  hl,bc
_58E7:
    inc  ix ; read data until 0xff
    ld   a,(ix+$00)
    cp   $FF
    jr   z,_58F4
    ld   (hl),a
    inc  hl
    jr   _58E7
_58F4:
    inc  ix
    push ix
    ret

    dc   7, $FF

draw_splash_circle_border_1:
    call draw_tiles_h_copy
    db   $01,$01 ;  start pos
;; splash screen circle border (26 = tiles)
;; Top Row 1
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$FF

;; left side 1
    call draw_tiles_v
    db   $01,$02 ;  start pos
    db   $53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53
    db   $52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$FF

;; right side 1
    call draw_tiles_v
    db   $1A,$02 ; start pos (1a = scr_tile_w)
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$FF

;; Bottom row 1
    call draw_tiles_h_copy
    db   $1C,$01 ;  start pos (1C = scr_tile_h)
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$FF
    ret

    dc   7, $FF

draw_splash_circle_border_2:
    call draw_tiles_h_copy
    db   $01,$01
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$FF
;;
    call draw_tiles_v
    db   $01,$02
    db   $52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52
    db   $51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$FF
;;
    call draw_tiles_v
    db   $1A,$02
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$FF
;;
    call draw_tiles_h_copy
    db   $1C,$01
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$FF
;;
    ret

    dc   7, $FF

draw_splash_circle_border_3:
    call draw_tiles_h_copy
    db   $01,$01
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$FF
;;
    call draw_tiles_v
    db   $01,$02
    db   $51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$52,$51
    db   $53,$52,$51,$53,$52,$51,$53,$52,$51,$53,$FF
;;
    call draw_tiles_v
    db   $1A,$02
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52
    db   $53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$FF
;;
    call draw_tiles_h_copy
    db   $1C,$01
    db   $51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$53,$51
    db   $52,$53,$51,$52,$53,$51,$52,$53,$51,$52,$FF
;;
    ret

    dc   7, $FF

;; fancy wait for start button
_5A98:
    push hl
    push bc
    push de
    ld   hl,wait_for_start_button
    call jmp_hl
    pop  de
    pop  bc
    pop  hl
    ret

    dc   3, $FF

;; Splash screen animated circle border
flash_border:
    ld   e,$05
_5AAA:
    ld   d,$05
_5AAC:
    push de
    call draw_splash_circle_border_1
    call _5A98
    pop  de
    dec  d
    jr   nz,_5AAC
    ld   d,$05
_5AB9:
    push de
    call draw_splash_circle_border_2
    call _5A98
    pop  de
    dec  d
    jr   nz,_5AB9
    ld   d,$05
_5AC6:
    push de
    call draw_splash_circle_border_3
    call _5A98
    pop  de
    dec  d
    jr   nz,_5AC6
    dec  e
    jr   nz,_5AAA
    ret

    dc   3, $FF

set_row_colors:
    ld   b,a
    ld   hl,screen_xoff_col+1 ; col for row 1
_5ADC:
    ld   (hl),b
    inc  hl
    inc  hl
    ld   a,l
    cp   $41
    jr   nz,_5ADC
    ret

    dc   1, $FF

set_screen_color_to_4:
    ld   a,$04
    call set_row_colors
    ret

    dc   4, $FF

;;; How is this different to the other extra bonus screen?
draw_extra_bonus_screen:
    ld   hl,reset_xoff_sprites_and_clear_screen
    call jmp_hl
    ld   hl,draw_border_1
    call jmp_hl
    call set_screen_color_to_4
    call draw_tiles_h_copy
    db   $08,$08
;; EXTRA BONUS
    db   E_,X_,T_,R_,A_,__,B_,O_,N_,U_,S_,$FF
    call draw_tiles_h_copy
    db   $09,$08
    dc   11, tile_hyphen        ; hyphen underline
    db   $FF
    call flash_border
    call flash_border
    call draw_tiles_h_copy
    db   $0C,$07
    db   P_,I_,C_,K_,__,U_,P_,__,6,__,B_,O_,N_,U_,S_,$FF
    call draw_tiles_h_copy
    db   $10,$07
    db   O_,B_,J_,E_,C_,T_,S_,__,W_,I_,T_,H_,O_,U_,T_,$FF
    call draw_tiles_h_copy
    db   $14,$07
    db   L_,O_,S_,I_,N_,G_,__,A_,__,L_,I_,F_,E_,$FF
    call flash_border
    call draw_tiles_h_copy
    db   $17,$0B
    db   $E0,$DC,$DD,$DE,$DF,$FF
    call draw_tiles_h_copy
    db   $18,$0B
    db   $E1
    db   tile_bonus_blank
    db   tile_bonus_blank
    db   tile_bonus_blank
    db   $E6,$FF
    call draw_tiles_h_copy
    db   $19,$0B
    db   $E1
    db   tile_bonus_blank
    db   tile_bonus_blank
    db   tile_bonus_blank
    db   $E6,$FF
    call draw_tiles_h_copy
    db   $1A,$0B
    db   $E2,$E3,$E3,$E3,$E4,$FF
    call flash_border
    call flash_border
    call attract_10000_bonus
    ret

    dc   11, $FF

animate_circle_border:
    ld   a,(splash_anim_fr)
    inc  a
    cp   $03
    jr   nz,_5BB1
    xor  a
_5BB1:
    ld   (splash_anim_fr),a
    and  a
    jr   nz,_border_1_2
    call draw_splash_circle_border_3
    ret
_border_1_2:
    cp   $01
    jr   nz,_5BC3
    call draw_splash_circle_border_2
    ret
_5BC3:
    call draw_splash_circle_border_1
    ret

    dc   1, $FF

;;
attract_10000_bonus:
    ld   a,tile_bonus_00_tr     ; 0000 top-right
    ld   (screen_ram+$1F8),a
    call flash_border
    ld   a,tile_bonus_00_br     ; 0000 bottom-right
    ld   (screen_ram+$1F9),a
    call flash_border
    ld   a,tile_bonus_00_tl     ; 0000 top-left
    ld   (screen_ram+$218),a
    call flash_border
    ld   a,tile_bonus_00_bl     ; 0000 bottom-left
    ld   (screen_ram+$219),a
    call flash_border
    ld   a,tile_bonus_10_tl     ; 10 top
    ld   (screen_ram+$238),a
    call flash_border
    ld   a,tile_bonus_10_bl     ; 10 bottom
    ld   (screen_ram+$239),a
    call flash_border
    call flash_border
    call flash_border
    ret

    dc   1, $FF

;; notes
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$1A,$03
    db   $1E,$02
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$1A,$03
    db   $1E,$02
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$1A,$01
    db   $21,$01,$21
    db   $01,$21,$01
    db   $21,$03,$23
    db   $01,$1E,$01
    db   $1C
    db   $04
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$19,$03
    db   $1C
    db   $02
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$19,$03
    db   $1C
    db   $02
    db   $15
    db   $01,$15,$01
    db   $15
    db   $01,$15,$01
    db   $21,$01,$21
    db   $01,$21,$01
    db   $21,$02,$23
    db   $01,$1E,$02
    db   $1A
    db   $04
    dc   12, $FF
    dw   _5C62
_5C62:
    dc   31, $FF

jmp_hl:
    jp   (hl)
    ld   b,b
    ld   b,c
    ret

    dc   1, $FF

;; Yet more note-looking data
    db   $06,$01
    db   $06,$01
    db   $06,$01
    db   $0E,$01
    db   $09
    db   $01,$12,$01
    db   $10,$01
    db   $0E,$01
    db   $06,$01
    db   $06,$01
    db   $06,$01
    db   $0E,$01
    db   $09
    db   $01,$12,$01
    db   $10,$01
    db   $0E,$01
    db   $06,$01
    db   $06,$01
    db   $06,$01
    db   $0E,$01
    db   $09
    db   $01,$12,$01
    db   $10,$01
    db   $0E,$01
    db   $12
    db   $01,$12,$01
    db   $12
    db   $01,$10,$01
    db   $10,$01
    db   $0D
    db   $01,$07,$02
    db   $07
    db   $01,$07,$01
    db   $07
    db   $01,$0D,$01
    db   $0D
    db   $01,$10,$01
    db   $10,$02
    db   $07
    db   $01,$07,$01
    db   $07
    db   $01,$0D,$01
    db   $0D
    db   $01,$10,$01
    db   $10,$02
    db   $07
    db   $01,$07,$01
    db   $07
    db   $01,$09,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $15
    db   $01,$15,$01
    db   $13
    db   $02
    db   $12
    db   $01,$10,$02
    db   $0E,$02
    dc   6, $FF

sfx_1_data:
    db   $02
    dw   _5D08
    dw   _5D14
    dw   _5D14
    db   $FF
_5D08:
    db   $01,$08,$0E,$00,$86,$5C,$EE,$03
    dc   4, $FF
_5D14:
    db   $00,$5C
    db   $EE,$03
    db   $FF
    db   $FF
    db   $70
    db   $18,$30
    db   $17
    db   $30,$17
    db   $30,$17
    db   $30,$17
    db   $28,$1D
    db   $EE,$03
    db   $E3
    db   $06,$D3
    db   $03
    db   $D3,$03
    db   $FF
    db   $FF
    db   $19
    db   $01,$1A,$01
    db   $1B
    db   $01,$1C,$01
    db   $21,$02,$1C
    db   $01,$21,$02
    db   $1C
    db   $02
    db   $1B
    db   $01,$21,$02
    db   $1B
    db   $01,$21,$02
    db   $1B
    db   $02
    db   $1A
    db   $01,$21,$02
    db   $1A
    db   $01,$21,$02
    db   $1A
    db   $02
    db   $19
    db   $01,$1A,$01
    db   $1B
    db   $01,$1C,$02
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $19
    db   $20,$FF
    db   $FF
    db   $1A
    db   $01,$19,$01
    db   $17
    db   $01,$15,$03
    db   $15
    db   $01,$1C,$03
    db   $1C
    db   $01,$1E,$02
    db   $1A
    db   $02
    db   $15
    db   $02
    db   $1E,$02
    db   $1C
    db   $03
    db   $19
    db   $01,$19,$01
    db   $17
    db   $01,$15,$02
    db   $17
    db   $06,$19
    db   $01,$17,$01
    db   $15
    db   $03
    db   $15
    db   $01,$1C,$03
    db   $1C
    db   $01,$1E,$01
    db   $1C
    db   $01,$1A,$02
    db   $1E,$02
    db   $21,$02,$25
    db   $02
    db   $25
    db   $02
    db   $26,$01
    db   $25
    db   $01,$23,$02
    db   $21,$05,$FF
    db   $FF
    db   $FF
    db   $FF
    db   $10,$03
    db   $10,$04
    db   $10,$04
    db   $12
    db   $04
    db   $12
    db   $04
    db   $10,$04
    db   $10,$04
    db   $0B
    db   $04
    db   $0B
    db   $04
    db   $10,$04
    db   $10,$04
    db   $12
    db   $04
    db   $12
    db   $04
    db   $10,$04
    db   $09
    db   $04
    db   $09
    db   $05
    db   $FF
    db   $FF
    db   $FF
    db   $FF
_5DD0:
    db   $01,$05,$0F
    db   $00
    db   $60
    db   $5D
    db   $AC
    db   $5D
    db   $AC
    db   $5D
    db   $EE,$07
_5DDC:
    db   $CC,$1D,$FF
    db   $FF
_5DE0:
    db   $30,$5D
    db   $64
    db   $5D
    db   $64
    db   $5D
    db   $EE,$07
    db   $FF
    db   $FF

sfx_11_data:
    db   $03
    dw   _5DD0
    dw   _5DE0
    dw   _5DDC
    db   $FF
    db   $FF
    db   $FF
    db   $15
    db   $01,$1A,$02
    db   $1D
    db   $01,$1C,$01
    db   $1D
    db   $01,$1C,$01
    db   $1A
    db   $02
    db   $1D
    db   $01,$1C,$02
    db   $1D
    db   $01,$1A,$01
    db   $1C
    db   $01,$1D,$01
    db   $1C
    db   $02
    db   $1D
    db   $01,$1A,$01
    db   $15
    db   $01,$11,$01
    db   $0E,$03
    db   $FF
    db   $FF
    db   $11,$01,$11
    db   $01,$11,$01
    db   $11,$01,$11
    db   $01,$11,$01
    db   $11,$01,$11
    db   $01,$10,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $10,$01
    db   $0E,$02
    db   $0E,$01
    db   $10,$01
    db   $11,$02,$0E
    db   $02
    db   $14
    db   $04
    db   $15
    db   $04
    db   $FF
    db   $FF
    db   $0E,$02
    db   $11,$01,$09
    db   $01,$0B,$01
    db   $0C
    db   $01,$0E,$02
    db   $11,$01,$09
    db   $01,$0B,$01
    db   $0C
    db   $01,$0E,$02
    db   $11,$01,$09
    db   $01,$0B,$01
    db   $0C
    db   $01,$0E,$01
    db   $09
    db   $01,$05,$01
    db   $02
    db   $03
    db   $FF
    db   $FF
    db   $FF
    db   $01,$06,$0F
    db   $00
    db   $80
    db   $5E
    dc   13, $FF

sfx_12_data:
    db   $03,$75,$5E,$90,$5E,$79,$5E,$FF
    db   $F4,$5D,$1C
    db   $5E
    db   $4C
    db   $5E
    db   $4C
    db   $5E
    db   $EE,$09
    dc   6, $FF
    db   $0E,$01
    db   $10,$01
    db   $13
    db   $01,$17,$01
    db   $16,$01
    db   $17
    db   $01,$16,$01
    db   $17
    db   $01,$16,$01
    db   $17
    db   $01,$16,$01
    db   $18,$01
    db   $17
    db   $01,$15,$01
    db   $17
    db   $01,$13,$01
    db   $0E,$01
    db   $13
    db   $01,$17,$01
    db   $1A
    db   $01,$19,$01
    db   $1A
    db   $01,$19,$01
    db   $1A
    db   $01,$19,$01
    db   $1A
    db   $01,$19,$01
    db   $1C
    db   $01,$1A,$01
    db   $19
    db   $01,$1A,$01
    db   $17
    db   $01,$0E,$01
    db   $10,$01
    db   $13
    db   $01,$17,$01
    db   $16,$01
    db   $17
    db   $01,$16,$01
    db   $17
    db   $01,$16,$01
    db   $17
    db   $01,$16,$01
    db   $18,$01
    db   $17
    db   $01,$15,$01
    db   $17
    db   $01,$13,$01
    db   $0E,$01
    db   $10,$01
    db   $13
    db   $01,$17,$01
    db   $15
    db   $02
    db   $0E,$01
    db   $17
    db   $01,$15,$02
    db   $0E,$01
    db   $13
    db   $02
    db   $0E,$02
    db   $13
    db   $01,$FF,$FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $A0
    db   $5E
    db   $EE,$03
    db   $03
    db   $06,$0F
    db   $10,$1C
    db   $5F
    dc   6, $FF

sfx_13_data:
    db   $03,$24,$5F,$20,$5F,$28,$5F,$FF
    db   $09
    db   $01,$0E,$01
    db   $10,$01
    db   $12
    db   $03
    db   $13
    db   $01,$13,$02
    db   $17
    db   $02
    db   $15
    db   $04
    db   $12
    db   $02
    db   $15
    db   $02
    db   $13
    db   $03
    db   $12
    db   $01,$13,$02
    db   $10,$02
    db   $12
    db   $05
    db   $09
    db   $01,$0E,$01
    db   $10,$01
    db   $12
    db   $03
    db   $13
    db   $01,$13,$02
    db   $17
    db   $02
    db   $15
    db   $04
    db   $12
    db   $02
    db   $15
    db   $02
    db   $13
    db   $03
    db   $12
    db   $01,$13,$02
    db   $10,$02
    db   $0E,$05
    db   $FF
    db   $FF
    db   $FF
    db   $FF

sfx_14_data:
    db   $03,$90,$5F,$80,$5F,$98,$5F,$FF
    db   $38,$5F
    db   $20,$4A
    db   $20,$4A
    db   $48
    db   $4A
    db   $48
    db   $4A
    db   $EE,$0B
    db   $FF
    db   $FF
    db   $FF
    db   $FF
    db   $01,$05,$0F
    db   $00
    db   $8C
    db   $5F
    db   $FF
    db   $FF
    db   $C4,$4A,$E4
    db   $4A
    db   $E4,$4A,$06
    db   $4B
    db   $06,$4B
    db   $EE,$0B

    dc   92, $FF ; to 0x5fff

;;; ======= END OF BG6.BIN ======

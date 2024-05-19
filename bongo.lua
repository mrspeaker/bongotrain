-- Bongo x Bongo, by Mr Speaker.
-- https://www.mrspeaker.net

--[[
   Welcome to Bongo x Bongo. This script makes modifications to the game
   Bongo, written by John Hutchinson for JetSoft in 1983.

   * General cheatin' and tweaks for practising
   * OGNOB mode: new challenge - try to complete the game in reverse!
   * New main character and colour themes
   * Random stuff I found unused in the game code
   * ... and much more!

   SETTINGS

   Changing the variables below to enable features. Most settings are true/false options
   for enabling or disabling. For example, to turn off the "infinite lives" feature:

      infinite_lives = false

   There are tonnes of things to set - some are really useful if you're trying to
   improve your Bongo runs, some are just for fun, and a bunch are things I was
   testing when I found it buried in unused code in the Bongo ROM dump.

   RUNNING

   As a prerequisite, you should already be able to load and play Bongo on
   MAME. To run this script, you need to supply it as an extra argument when
   running MAME from the command line:

   `mame bongo -autoboot_script ./bongo.lua`

   Where the path `./bongo.lua` points to the file you are currently reading.

   (If you don't know how to run MAME from command line, you'll have to
   do a bit of googlin'. Instead of clicking on mame.exe you need to run
   that from a command prompt as described here:
   https://easyemu.mameworld.info/mameguide/getting_started/running_mame.html)

--]]

start_screen = 1 -- [1 - 27]. Screen to start the game. 27 is the dino screen.
loop_screens = {}--{13,14,18,21,25,27} -- Loop if you want to practise levels, eg:
-- {}: no looping, normal Bongo sequence
-- {14}: repeat screen 14 over and over
-- {14, 18, 26}: repeat a sequence of screens
round = 2 -- starting round (1: initial speed, 2+: faster)
-- 1: default Bongo speed for dinosaur and enemies
-- 2: faster movement for player and enemies, and dinosaur starts earlier
-- 3+: each round after 2, the player and enemeies are the same speed,
--     but the dinosaur starts earlier and earlier and earlier...
infinite_lives = true
fast_death = true             -- restart fast after death
fast_wipe = true              -- fast transition to next screen
disable_dino = false          -- no pesky dino (oh, but also now you can't catch 'im)
disable_round_speed_up = true -- don't get faster after catching dino
disable_bonus_skip = false    -- don't skip screen on 6xbonus
disable_cutscene = true       -- don't show the awesome cutscene
reset_score = false           -- reset score to 0 on death and new screen
collision_indicator = false   -- show where ground and pickup collisions occur
-- Bongo is bad at picking things up because of his bongoitis and bad knees.
-- This setting shows you exactly where collisions will occur. As you walk
-- the ground will "cycle" so you can see which tile the game thinks you are on.
--   *Middle line*  shows exactly where the tile collision happenss.
--   *Back line*    shows you where pickup collision will happen.
-- So you need to get the back line over a pickup before you actally pick anything up.

allow_skip = true             -- use player1/player to navigate screens while playing
-- P1: skip forward one screen
-- P2: skip back one screen
-- P1 + P2: reset back to attract screen
theme = 0                     -- color theme (0-7). 0 = default, 7 = best one
technicolor = false           -- randomize theme every death
head_style = 0                -- 0 = normal, 1 = dance, 2 = dino, 3 = bongo, 4 = shy guy

ognob_mode = true             -- open-world Bongo. Can go out left or right.

--[[
                ======= Official OGNOB MODE Rules =======

   You've caught the dinosaur and danced with Bongo & friends, but your knees
   can handle more? Then exit stage left... and try your luck in the wild world
   of Ognob.

   Ognob competitive settings:

   * ognob_mode         = true
   * start_screen       = 1
   * loop_screens       = {}
   * round              = 2
   * infinite_lives     = false (hardcore), true (easy)
   * disable_dino       = true (good luck otherwise...)
   * disable_bonus_skip = true
   * allow_skip         = false

   Start on screen 1, and make your way left. Your not being chased by a
   dinosaur, yet many challenges lay ahead of you. Make it all the way
   back to screen 1 to lay claim to the title, The Honourable Earl of Ognob.

--]]


-- Removed features I found in the code, and tweaks/tests
show_timers = false             -- speed run timers! Don't know why they removed them
prevent_cloud_jump = false     -- makes jumping from underneath really crap!
alt_bongo_place = false        -- maybe supposed to put lil guy on the ground for highwire levels?
one_px_moves = false           -- test how it feels moving 1px per frame, not 3px per 3 frames.
-- I think this is the reason Bongo is so hard. This is responsible for Bongo 50/50s.
-- Every three frames the player will move three pixels. The ground collision detection has
-- *four* frames of leeway: so making a jump from the edge of a S_S level has a very
-- small margin to be out - and the chunky three-pixel movement makes it even harder to
-- get right. This setting shows kind of what a smooth movement would be like
fix_jump_bug = false           -- don't die when holding jump on new screen
-- Theres a nasty bug that sometimes comes up in game play: if you jump off a platform
-- into the next screen, then if you hold jump while the next screen starts - sometimes
-- the player does a weird stunted tripple-jump and just... dies. This fixes it.

fix_all_the_lil_bugs = true
   -- ====== A bunch of bugs I found while spelunking... ===========
   -- * fix call to draw inner border on YOUR BEING CHASED screen
   -- * add other missing inner border in empty attract screen
   -- * fixed the pointy stair-down platform
   -- * don't jump to wrong byte in hiscore timer code (0x3108).
   --   (no visual changes, but hey.)
   -- * in BONGO attract screen, jumping up and down stairs the player's head
   --   and legs are switched for one frame of animation (really!). Fix it!
   -- * subjective typography fix: align 1000 bonus better
   -- * add the cool spiral transition to attract mode. Code was just sitting there.

-- NOTE: to get some bytes for features, I broke P2 handling I think.
-- Probably One-player only now.



-- Bongo world map

-- 01:  n_n  n_n  nTn  n_n   /   W
-- 07:   \   n_n  nTn   /    W
-- 12:   \   n_n  nTn  n_n   S
-- 17:   \   n_n   S    \   S_S
-- 22:   W    \   S_S
-- 25:   W    \    S



-- =====================================================================================
-- =============================== end of settings =====================================
-- =====================================================================================



--  Warning traveller ...
-- ... You can look at the code,
-- ... but you can not unlook at the code

                           -- Mr Speaker


--------------- General helpers ----------------

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function flatten(list)
  if type(list) ~= "table" then return { list } end
  local flat = {}
  for _, el in ipairs(list) do
    for _, val in ipairs(flatten(el)) do
      flat[#flat + 1] = val
    end
  end
  return flat
end

function print_pairs(o)
   for tag, device in pairs(o) do print(tag) end
end
function yn(v)
   if v == true then
      return "Y"
   end
   return "N"
end


local evs = {
   game_start = {},
   game_over = {},
   screen_change = {},
   died = {}
}
function add_ev(name, func)
   local ev = evs[name]
   ev[#ev+1]=func
end
function fire_ev(name, ...)
   for _, f in ipairs(evs[name]) do
      f(...)
   end
end

------------------- MAME machine -----------------------

local debug_mame = true

cpu = manager.machine.devices[":maincpu"]
cpudebug = cpu.debug
mem = cpu.spaces["program"]
io = cpu.spaces["io"]
gfx1 = manager.machine.memory.regions[":gfx1"]

if debug_mame == true then
   print("=== bongo trainer dbg ===")
   print_pairs(manager.machine.devices)
   print("gfx size: "..dump(gfx1.size))
   print("io:"..dump(io.map.entries))
   --print_pairs(cpu.state) -- prints all cpu flags, regs

   -- cpudebug:wpset(mem, "rw", 0xc080, 1, "1","{ printf \"Read @ %08X\n\",wpaddr ; g }")
   -- cpudebug:wpset(mem, "rw", 0x10d4bc, 1, 'printf "Read @ %08X\n",wpaddr ; g')
   print("=== end dbg ===")
end

------------------- MAME Helpers ---------------------

function poke(addr, bytes)
   if type(bytes)=="number" then bytes = {bytes} end
   bytes = flatten(bytes) -- you should be scared by now...
   for i = 1, #bytes do
      mem:write_u8(addr + (i - 1), bytes[i])
   end
end

function poke_rom(addr, bytes)
   if type(bytes) == "number" then bytes = {bytes} end
   bytes = flatten(bytes)
   for i = 1, #bytes do
      mem:write_direct_u8(addr + (i - 1), bytes[i])
   end
end

function peek(addr)
   return mem:read_u8(addr)
end

function peek_rom(addr)
   return mem:read_direct_u8(addr)
end

function poke_gfx(color, addr, byte)
   if color & 1 == 1 then
      gfx1:write_u8(addr, byte)
   end

   if color & 2 == 2 then
      gfx1:write_u8(addr + 0x1000, byte)
   end
end

function get_pc()
   return cpu.state["PC"].value
end

function set_pc(addr)
   cpu.state["PC"].value = addr
end
function set_sp(addr)
   cpu.state["SP"].value = addr
end

-- return an array with hi/lo bytes of a 16bit value
function x(v)
   return { v & 0xff, v >> 8 }
end

function is_on_game_screen()
   return peek(0x93a9) == 0xFE -- platform tile in top left
end


----------------- Scratch pad -------------------

-- poke_rom(0x069D, 0x20); -- autojump

-- try colorizing player
--poke_rom(0x8a2,8)
--poke_rom(0x1811,8)
--nope. poke_rom(0x149b,{0x3d,col,0x32,0x42,0x81,0x32,0x46,0x81,0xc9}

-- length, velocity, volume, transpose

poke_rom(0x1c42, 0xf);
--poke_rom(0x4c46, 1);
--poke_rom(0x4c3a, 0x3);

--poke_rom(0x50b0, {0x2,0x2,0xf,0x0,0x1,0x2,0x1,0x2});
--poke_rom(0x4b0c, {0x15,0x01,0x17,0x01,0x19,0x01,0x1A,0x02,0x1A,0x02,0x18,0x02,0x18,0x02,0x17,0x02})
--poke_rom(0x4b40,{0x3})
------------------ z/80 opcodes -----------------

NOP = 0x00
JR = 0x18
JR_NZ = 0x20
LD_HL = 0x21
INC_HL = 0x23
JR_Z = 0x28
LD_MEM_A = 0x32
LD_HLP = 0x36
SCF = 0x37
JR_C = 0x38
LD_A_MEM = 0x3a
INC_A = 0x3c
DEC_A = 0x3d
LD_A = 0x3e
CCF = 0x3f
LD_B_A = 0x47
LD_HL_A = 0x77
LD_A_B = 0x78
LD_A_L = 0x7d
LD_A_HL = 0x7e
AND_A = 0xA7
RET_NZ = 0xC0
JP = 0xC3
ADD_A = 0xC6
RET_Z = 0xC8
RET = 0xC9
CALL = 0xCD
SUB = 0xD6
RET_C = 0xD8
XOR_A = 0xAF
AND = 0xE6
OR = 0xF6
CP = 0xFE

--- RAM locations ---

SCREEN_NUM = 0x8029
PLAYER_LEFT_Y = 0x8077
OGNOB_TRIGGER = 0x8078

--- Constants -----

TILE_BLANK = 0x10

---------------------------------------------------------

-- change color palette
-- (seems to also mess up a couple of tiles under P2 on load?)
function set_theme(col)
   -- patches RESET_XOFF_AND_COLS_AND_SPRITES
   -- change screen colors (resets xoffs and cols seperately)
   -- by adding an extra: `ld (hl), $col, inc hl` for the color
   poke_rom(0x1496, {
     LD_HLP,    col,
     INC_HL,
     LD_A_L,
     CP,        0x80,
     JR_NZ,     0xF5,
     RET
   })
   -- the routine above was duplicated, so just call instead.
   poke_rom(0x19d8, {
     CALL,  x(0x1490), -- RESET_XOFF_AND_COLS_AND_SPRITES
     0,0,0,0,0,0,0,0
   })
   -- bottom row color
   poke_rom(0x1047, col)
   poke_rom(0x179B, col)
   poke_rom(0x179B, col)
end

function do_reset_score()
   poke(0x8014, {0, 0, 0})
end

function do_reset_time()
   poke(0x8007, {0, 0})
end

function do_disable_bonus_skip()
   local GOT_A_BONUS = 0x29c0
   poke_rom(GOT_A_BONUS, { JP, x(0x29f5) }) -- jump to end of sub
   poke_rom(0x29FC, { NOP, NOP, NOP }) -- but don't skip screen
end

----------- bug fixes -------------

if fix_all_the_lil_bugs == true then
   -- bugfix: fix call to draw inner border on YOUR BEING CHASED screen
   poke_rom(0x56da, 0x5c) -- (was typo'd as 0x4c)

   -- bugfix: the pointy stair-down platform
   poke_rom(0x1f01, 0xfc)

   -- subjective typography fix: align 1000 bonus better
   poke_rom(0x162d, 0x0f)

   -- bugfix: don't jump to wrong byte in hiscore something.
   -- no visual changes, but hey.
   poke_rom(0x3120, 0x17)

   -- bugfix: in BONGO attract screen, jumping up stairs the player's
   -- head and legs are switched for one frame of animation. Fix it!
   poke_rom(0x5390, { 0x93, 0x94 }) -- on the way up
   poke_rom(0x5418, { 0x13, 0x14 }) -- on the way down

   -- subjective bugfix: add inner border to empty attract screen
   poke_rom(0x48C7, {
      CALL,  x(0x56D0), -- call DRAW_BUGGY_BORDER
      CALL,  x(0x5aA8), -- call original FLASH_BORDER
      RET
   })

   -- add the cool spiral transition to attract mode
   -- (if not ognob, because I need the bytes for that)
   if ognob_mode == false then
      poke_rom(0x038b, { CALL, x(0x2550) }) -- cool transition!
   end

end

-- what to do about Bongo Tree.
-- feels wrong to "fix" it.
-- poke_rom(0x19b7, {0,0,0, 0,0,0})

------------- settings -------------

if infinite_lives == true then
   poke_rom(0x26c, { NOP, NOP }) -- act like DIP switch on
end

if fast_death == true then
   -- return early from DO_DEATH_SEQUENCE
   poke_rom(0x0CCB, {
     CALL, x(0x0ca0),  -- delay 8 vblanks to delay a little
     CALL, x(0x0ca0),  -- delay 8 vblanks (still pretty short)
     RET, NOP, NOP     -- return after dino reset
   });
end

if fast_wipe == true then
   -- skip parts of $DURING_TRANSITION_NEXT
   poke_rom(0x1358, { JR, 0x1e, NOP }) -- jumps to $_RESET_FOR_NEXT_LEVEL
   -- speeds up transition even more: skips $CLEAR_SCR_TO_BLANKS ...
   poke_rom(0x1378, { CALL, x(0x1490) }) -- ...and just does RESET_XOFF_AND_COLS_AND_SPRITES
   -- don't do bottom "level indicator" animation.
   poke_rom(0x3F42, { NOP, NOP, NOP }) -- saves 2 vblanks-per-screen-number
end

if disable_dino == true then
   poke_rom(0x22FE, RET); -- ret from timer start check
end

if disable_round_speed_up == true then
   poke_rom(0x4EE3, RET); -- return early
end

if disable_cutscene == true then
   poke_rom(0x3d48, {
     XOR_A,
     LD_MEM_A, x(0x802d),  -- reset DINO_COUNTER
     JP,       x(0x3D88)   -- _CUTSCENE_DONE
   });
end

if disable_bonus_skip == true then
   do_disable_bonus_skip()
end

-- not doing by default because it changes how the game plays
if fix_jump_bug == true then
   poke_rom(0x14dd, {
     XOR_A,                -- reset falling_timer on screen reset
     LD_MEM_A,  x(0x8011), -- FALLING_TIMER
     RET,
     LD_A_MEM,  x(0x0815), -- Existing: used to start at $14e0,
     AND,       0x03,      -- now starts $14e2
     RET_NZ,
     CALL,      x(0x3a50), -- ENEMY_1_RESET
     CALL,      x(0x3a88), -- ENEMY_2_RESET
     CALL,      x(0x3ac0), -- ENEMY_3_RESET
     RET
   })
   poke_rom(0x3b6c, 0xe2) -- bump call addr to $14e2
end

if alt_bongo_place == true then
   --Bongo on ground for high-wire levels (I think)
   poke_rom(0x0d40, NOP); -- nop out ret
end

if show_timers == true then
   --enable's hidden speed-run timers!
   poke_rom(0x1410, NOP); -- nop out ret
end

if prevent_cloud_jump == true then
   -- PREVENT_CLOUD_JUMP_REDACTED
   poke_rom(0x1290, NOP); -- nop out ret
end

if theme ~= 0 then
   set_theme(theme)
end

if one_px_moves == true then
   poke_rom(0x068D, NOP) -- run every frame, not every 3
   poke_rom(0x0632, { NOP,NOP }) -- nop 2x inc
   poke_rom(0x0672, { NOP,NOP }) -- nop 2x dec
end

if head_style > 0 then
   local flip_x = function(v) return v + 0x80 end
   local fr = ({0x3e, 0x2c, 0x05, 0x17})[head_style]
   local fl = ({flip_x(0x3e), flip_x(0x2c), 0x07, flip_x(0x17)})[head_style]
   local jump_fr = ({0x3a, 0x2c + 2, 0x05, 0x19})[head_style]

   poke_rom(0x063A, { LD_A, fr, LD_MEM_A, x(0x8141), RET }) -- player_move_right
   poke_rom(0x067a, { LD_A, fl, LD_MEM_A, x(0x8141), RET })  -- player_move_left
   poke_rom(0x1819, { LD_A, fr, LD_MEM_A, x(0x8141), RET }) -- reset_player
   poke_rom(0x07d5, fr) -- trigger_jump_left
   poke_rom(0x07b5, fl) -- trigger_jump_right
   poke_rom(0x08d5, jump_fr) -- trigger_jump_straight_up
   poke_rom(0x09de, { NOP, NOP, NOP }) -- check_if_landed reset
   poke_rom(0x06FA, { NOP, NOP, NOP }) -- player_physics frame set
end

if collision_indicator == true then
   -- draw in empty "solid" tile graphics (otherwise it draws holes)
   for i = 0, 7 do
      poke_gfx(2, 0xf9 * 0x8 + i, 0x7f)
      poke_gfx(1, 0xfb * 0x8 + i, 0x7f)
      poke_gfx(2, 0xff * 0x8 + i, 0x7f)
   end

   -- draw a "collision pole" in player graphics
   local feet_frames = {0x135, 0x13d, 0x145, 0x14d, 0x155, 0x161}
   for i, v in pairs(feet_frames) do
      -- middle pole
      poke_gfx(1, v * 0x8 + 7, 0x55)
      poke_gfx(2, v * 0x8 + 7, 0xAA)

      -- blank out columns next
      poke_gfx(3, v * 0x8 + 5, 0x00)
      poke_gfx(3, v * 0x8 + 6, 0x00)
      poke_gfx(3, v * 0x8 + 8 + 8, 0x00)
      poke_gfx(3, v * 0x8 + 8 + 8 + 1, 0x00)

      -- fwd/back markers
      --poke_gfx(2, v * 0x8, 0x3f)
      poke_gfx(1, v * 0x8 + 8 + 8 + 3, 0x55)
      poke_gfx(2, v * 0x8 + 8 + 8 + 3, 0xAA)
      poke_gfx(3, v * 0x8 + 8 + 8 + 2, 0x00)
      poke_gfx(3, v * 0x8 + 8 + 8 + 4, 0x00)
   end

   --- rotate through tiles as player walks
   poke_rom(0x09AD, {
     JR_Z, 0x7, -- jump to SOLID
     -- WALKABLE
     LD_A_HL,
     INC_A,
     AND, 0xef,
     NOP, --LD_HL_A, -- don't print empties!
     XOR_A,  -- 0 = walkable tile
     RET,
     -- SOLID:
     LD_A_HL,
     INC_A,
     OR, 0xFC,
     LD_HL_A,
     LD_A, 0x1, -- 1 = solid tile
     RET
   })
end

------------- RAM hacks -------------

run_started = false
loop_len = #loop_screens
loop_idx = 0

LIVES = 0x8032
cur_lives = -1
-- Game doesn't update LIVES on final death, so can't be hooked.
-- This patch sets LIVES to 0xff so it fires, then in the tap
-- can check this (and return 0 to set it back to 0)
poke_rom(0x0410, { CALL, x(0x0426) }) -- jump down to some free bytes
poke_rom(0x0426, {
  LD_A,     0xff,                   -- set lives to 0xff marker
  LD_MEM_A, x(LIVES),
  LD_HL,    x(0x16e8),              -- replace original code form 0x410
  RET
})
tap1 = mem:install_write_tap(LIVES, LIVES, "writes", function(offset, lives)
   -- clear score on death
   if reset_score == true then
      do_reset_score()
   end

   if technicolor == true then
      set_theme(math.random(16))
   end

   -- Player deaths
   if run_started then
      -- deal with init or bonus lives (plus init-write weirdness)
      if cur_lives == -1 or lives > cur_lives then
         cur_lives = lives
      end
      local game_over = false
      if lives == 0xff then -- my game-over marker
         lives = -1
         game_over = true
      end

      if game_over or lives < cur_lives then
         fire_ev("died", lives + 1)
         cur_lives = lives
      end
      if game_over then
         fire_ev("game_over")
         run_started = false
         return 0
      end
   end
end)

local last_screen = 1
add_ev("game_start", function()
   last_screen = 1
end)
tap2 = mem:install_write_tap(SCREEN_NUM, SCREEN_NUM, "writes", function(offset, data)
   if data == 0 then
      return
   end

   -- loop screens
   if data == 1 and not run_started then
      -- player has started
      run_started = true
      fire_ev("game_start")

      -- go to round 2 if requested
      local SPEED_DELAY_P1 = 0x805b
      if round > 1 and peek(SPEED_DELAY_P1) == 0x1f then
         local speeds = { 0x1f, 0x10, 0x0d, 0x0b, 9, 7, 5, 3 }
         poke(SPEED_DELAY_P1, speeds[round])
      end

      if loop_len == 0 then
         return start_screen
      end
   end

   if not run_started then
      return
   end

   -- reset score on screen change
   if reset_score == true then
      do_reset_score()
   end

   if data ~= last_screen then
      fire_ev("screen_change", data, last_screen)
      last_screen = data
   end

   if loop_len > 0 then
      local next = loop_screens[loop_idx + 1]
      loop_idx = (loop_idx + 1) % loop_len -- um, why does this work? "next" should mod?
      return next
   end

end)

local START_OF_TILES = 0x9040 -- top right tile
local TW = 27
local TH = 31
--    END_OF_TILES      $93BF ; bottom left tile
function draw_tile(x, y, tile)
   poke(START_OF_TILES + (TW - x) * 32 + y, tile)
end

-- What?
if false then
ground = 0x90fe -- rando ground tile on screen
w = {0x0e, 0x0a, 0x22, 0x1c, 0x0e, 0x3b, 0x3e, 0x22, 0x25, 0x1c, 0x0e, 0x23}
tap3 = mem:install_write_tap(ground, ground, "writes", function(offset, data)
   if data == 0x3e then
      local pos = 0x929e
      for i, v in pairs(w) do
         poke(pos - (i - 1) * 0x20, v);
      end
   end
end)
end

-- p1/p2 button to skip forward/go back screens
if allow_skip == true then
   buttons = false
   BUTTONS = 0x800c
   tap_buttons = mem:install_write_tap(BUTTONS, BUTTONS, "writes", function(offset, data)
     local val = data & 3 -- 1: p1, 2: p2
     if buttons == true and val == 0 then
        -- button released (stops repeats)
        buttons = false
     end
     if not buttons and (val > 0) then
        buttons = true
        -- Don't transition unless playing
        if not is_on_game_screen() then
           return
        end

        if val == 3 then -- both p1 & p2: reset
           set_pc(0x0410) -- game over
           return
        end

        local cur = peek(SCREEN_NUM)
        -- TODO: this doesn't work properly when you have loop selections.
        if val == 1 then -- p1 button. wrap on cage screen.
           if cur == 27 then
              poke(SCREEN_NUM, 0) -- 0 as it get incremented... somewhere else
           end
        end
        if val == 2 then -- p2 button, go back screen
           if cur <= 1 then
              poke(SCREEN_NUM, 26)
           else
              poke(SCREEN_NUM, cur - 2)
           end
        end

        -- Triggers next level. Checks that $SCREEN_XOFF_COL+6 is 0
        -- (this is what is scrolled while transitioning: to prevent double-triggering)
        if peek(0x8106) == 0 then
           set_pc(0x1778)
        end
     end
   end)
end

-------------------- OGNOB mode -------------------

-- Open-world mode: freely wander left or right
if ognob_mode == true then

   local OGNOB_MODE_ADDR = 0x2538

   -- on EXIT_STAGE_LEFT, call $OGNOB_MODE
   poke_rom(0x1a0c, { CALL, x(OGNOB_MODE_ADDR) })

   --[[
      The main OGNOB_MODE routine. Does what would happen
      during a normal screen switch, but also sets
      PLAYER_LEFT_Y (0x8077: my variable) that indicates
      the player is left-transitioning. It gets cleared if
      you go through a normal right-transitioning.
   -- ]]
   poke_rom(OGNOB_MODE_ADDR, {
     LD_A_MEM,  x(0x8143),        -- PLAYER_Y
     LD_MEM_A,  x(PLAYER_LEFT_Y), -- (was using 8099 - but seemed to affect 8029?! How?!)

     -- TRANSITION_TO_NEXT_SCREEN
     CALL,      x(0x17C0),        -- RESET_DINO
     -- get the previous screen
     LD_A_MEM,  x(SCREEN_NUM),
     CP,        0x1,       -- screen 1?
     JR_NZ,     0x2,       -- don't reset
     LD_A,      0x1C,      -- screen 28 (1 extra, that gets dec-d)
     DEC_A,
     LD_MEM_A,  x(SCREEN_NUM),

     -- DURING_TRANSITION_NEXT
     CALL,      x(0x14B0), -- SCREEN_RESET
     CALL,      x(0x1490), -- RESET_XOFF_AND_COLS_AND_SPRITES
     CALL,      x(0x12B8), -- DRAW_BACKGROUND
     CALL,      x(0x1820), -- INIT_PLAYER_POS_FOR_SCREEN
     CALL,      x(0x0db8), -- DRAW_BONGO

     -- SET_PLAYER_LEFT: PC must be OGNOB_MODE_ADDR+0x25
     LD_A,      0xE0 - 1,  -- very right edge of screen
     LD_MEM_A,  x(0x8140), -- PLAYER_X
     LD_MEM_A,  x(0x8144), -- PLAYER_X_LEGS
     LD_A_MEM,  x(PLAYER_LEFT_Y), -- (mine)
     -- Set player to top or bottom depending where they entered the screen
     -- dodgy (should do like INIT_PLAYER_POS_FOR_SCREEN, but eh.
     SCF,
     CCF,                  -- clear carry
     SUB, 0x70,            -- ~ middle of screen height
     JR_C, 4,
     LD_A, 0xD0,           -- set to bottom of screen
     JR, 2,
     LD_A, 0x26,           -- set to top of screen
     LD_MEM_A,  x(0x8143), -- PLAYER_Y
     ADD_A,     0x10,
     LD_MEM_A,  x(0x8147), -- PLAYER_Y_LEGS

     LD_A_MEM,  x(0x8141), -- PLAYER_FRAME
     ADD_A,     0x80,      -- flip x
     LD_MEM_A,  x(0x8141), -- PLAYER_FRAME
     LD_A_MEM,  x(0x8145), -- PLAYER_FRAME_LEGS
     ADD_A,     0x80,      -- flip x
     LD_MEM_A,  x(0x8145), -- PLAYER_FRAME_LEGS

     -- after DURING_TRANSTION_NEXT
     CALL,      x(0x0AD0), -- SET_LEVEL_PLATFORM_XOFFS
     LD_A,      0x02,
     CALL,      x(0x17B4), -- RESET_JUMP_AND_REDIFY_BOTTOM_ROW

     -- trigger 0x8078 so I can catch it in hook
     LD_A,      0x1,
     LD_MEM_A,  x(OGNOB_TRIGGER),
     RET,
   })

   local SET_PLAYER_LEFT = OGNOB_MODE_ADDR + 0x25 -- careful! Address will change if above modified.

   -- Patch end of INIT_PLAYER_SPRITE after death:
   -- reset to right side of screen if ognob-ing
   poke_rom(0x08b5, {
     LD_A_MEM,  x(PLAYER_LEFT_Y),
     CP,        0x0,
     RET_Z,
     CALL,      x(SET_PLAYER_LEFT),
     RET
   })

   local SET_PLAYER_LEFT_LOC = 0x1886 -- some free bytes here

   -- Patch TRANSITION_TO_NEXT_SCREEN to account for
   -- being able to go right out of cage screen.
   poke_rom(0x177B, {
     CALL, x(SET_PLAYER_LEFT_LOC), -- (breaks P2 handling!)
     NOP, NOP, NOP
   })

   -- Reset PLAYER_LEFT_Y on right-transition,
   -- and wrap level if right-transition on cage screen (possible now!)
   -- Used some free (looking) bytes at 0x1886...
   poke_rom(SET_PLAYER_LEFT_LOC, {
      XOR_A,
      LD_MEM_A,  x(PLAYER_LEFT_Y),
      LD_A_MEM,  x(SCREEN_NUM),
      CP,        0x1b,      -- is it 27?
      RET_C,                -- nah, carry on
      XOR_A,
      LD_MEM_A,  x(SCREEN_NUM), -- yep - reset to 0
      RET
   })

   -- Patch SET_SPEAR_LEFT_BOTTOM to fix insta-death spears
   -- Not enough bytes, so overwriting color set, but then
   -- doing this in SET_SPEAR_LEFT_MIDDLE. lol.
   poke_rom(0x3947, {
     -- original code, moved up 3 bytes...
     LD_A,      0xC8,       -- original y value
     LD_MEM_A,  x(0x8157),  -- ENEMY_1_Y
     LD_A,      0x01,       -- original active value
     LD_MEM_A,  x(0x8037),  -- ENEMY_1_ACTIVE

     -- fix screen 26 spears insta-death
     LD_A_MEM,  x(PLAYER_LEFT_Y), -- is left side?
     AND_A,
     RET_Z,
     LD_A,      0xC6,       -- New Y value (2 higher - misses head!)
     LD_MEM_A,  x(0x8157),  -- ENEMY_1_Y
     RET
   })

   -- Patch SET_SPEAR_LEFT_MIDDLE to set the bottom spear color.
   -- Had to be done here because of the bytes we stole above!
   poke_rom(0x397E, {
     LD_A,      0x17,      -- set spear color
     LD_MEM_A,  x(0x8156), -- ENEMY_1_COL
     RET
   })

   -- extra platforms to make Bongo backwards-compatible (tee hee)
   poke_rom(0x1e02, 0xfe) -- S, entry point bottom-right
   poke_rom(0x21ea, 0xfc) -- nTn helper step

   -- Prevent score-accumulation from moving ognob. (too hard to do properly)
   -- Patch UPDATE_EVERYTHING_MORE to conditionally call
   -- ADD_MOVE_SCORE only when not Ognobbing.
   poke_rom(0x4020, { CALL, x(0x4030) }) -- jump to some free bytes
   poke_rom(0x4030, {
     LD_A_MEM,  x(PLAYER_LEFT_Y),
     AND_A,
     RET_NZ,
     JP,        x(0x4050), -- ADD_MOVE_SCORE
   })

   -- track an Ognob run
   local ognobbing = false
   is_ognob_win = false
   local ognob_done = add_ev("screen_change", function(cur, last)
     if cur == 1 and last == 27 then
        ognobbing = false
        ognob_stop()
     end
     if cur == 27 and last == 1 then
        ognobbing = true
        ognob_start()
     end

     -- You did it!
     if ognobbing == true and last == 2 and cur == 1 then
        ognob_win()
     end
   end)

   add_ev("game_over", function()
      ognobbing = false
   end)

   function ognob_stop()
      -- clear OGNOB text
      for i = 1, 5 do
         draw_tile(i-1, TH-2, TILE_BLANK)
      end
      is_ognob_win = false
   end

   -- begin your ognob run
   function ognob_start()
      do_reset_time()
      do_reset_score()
      poke(0x801D, 10) -- 100 starting points to force re-draw
      -- draw OGNOB text
      local ogtxt = {31,23,30,31,18}
      for i = 1, 5 do
         draw_tile(i-1,TH-2,ogtxt[i])
      end
      is_ognob_win = false
   end

   function ognob_win()
      local ogtxt = {31,23,30,31,18,0x10}
      for j = 3, TH do
         for i = 0, 5 do
            draw_tile(i,j,ogtxt[(j+i) % #ogtxt + 1])
         end
      end
      is_ognob_win = true
   end

   -- tap (and OGNOB_TRIGGER) is because the screen write that fires
   -- ognob_win happens BEFORE screen drawing etc, so any changes we make
   -- will get overwritten by the original code. This tap happens
   -- AFTER the original reseting and drawing.
   tap_ognob = mem:install_write_tap(OGNOB_TRIGGER, OGNOB_TRIGGER, "writes", function(offset, data)
      if is_ognob_win then
         -- Play win song
         poke(0x8042, 0x6) -- ch1 sfx
         poke(0x8065, 0x6) -- prev sfx (or something)
         -- remove pickup from last screen, so can't trigger bonus skip!
         poke(0x915a, TILE_BLANK)
      end
   end)

end




---- Bongo always -----

-- Bongo trainer, by Mr Speaker.
-- https://www.mrspeaker.net

-- press P1/P2 during game to skip forward/back screens.

start_screen = 1 -- screen number (1-27), if not looping
loop_screens = {}--{13,14,18,21,25,27} -- if you want to practise levels, eg:
-- {}: no looping, normal sequence
-- {14}: repeat screen 14 over and over
-- {14, 18, 26}: repeat a sequence of screens
round = 2 -- starting round

-- Serious bizness
infinite_lives = true
fast_death = true       -- restart fast after death
fast_wipe = true        -- fast transition to next screen
disable_dino = true     -- no pesky dino (oh, but also now you can't catch 'im)
disable_round_speed_up = true -- don't get faster after catching dino
disable_bonus_skip = false    -- don't skip screen on 6xbonus
disable_cutscene = true       -- don't show the awesome cutscene
reset_score = false     -- reset score to 0 on death and new screen
tile_indicator = false  -- middle line = block check pos. Back line = pickup check pos

-- Non-so-serious bizness
theme = 0               -- color theme (0-7). 0 =  default, 7 = best one
technicolor = false     -- randomize theme every death
head_style = 2          -- 0 = normal, 1 = dance, 2 = dino, 3 = bongo, 4 = shy guy
ognob_mode = true       -- Open-world Bongo. Can go out left or right.
                        -- ...are you brave enough to do all levels in Ognob?

-- Removed features I found in the code, and tweaks/tests
show_timers = true      -- speed run timers! Don't know why they removed them
prevent_cloud_jump = false -- makes jumping from underneath really crap!
alt_bongo_place = false -- I think was supposed to put guy on the ground for highwire levels
one_px_moves = false    -- test how it feels moving 1px per frame, not 3px per 3 frames.
fix_jump_bug = false    -- hold down jump after transitioning screen from high jump
                        -- doesn't kill you.


-----------------------------------
-- Bongo world map
-- 01:  n_n  n_n  nTn  n_n   /   W
-- 07:   \   n_n  nTn   /    W
-- 12:   \   n_n  nTn  n_n   S
-- 17:   \   n_n   S    \   S_S
-- 22:   W    \   S_S
-- 25:   W    \    S
-----------------------------------



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

local evs = {
   game_start = {},
   screen_change = {},
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

cpu = manager.machine.devices[":maincpu"]
cpudebug = cpu.debug
mem = cpu.spaces["program"]
--io = cpu.spaces["io"]
gfx = manager.machine.devices[":gfxdecode"]
gfx1 = manager.machine.memory.regions[":gfx1"]

print_pairs(manager.machine.devices)
print(dump(gfx1.size))
--print(dump(io.map.entries))
--print_pairs(cpu.state) -- prints all cpu flags, regs

-- cpudebug:wpset(programSpace, "rw", 0xc080, 1, "1","{ printf \"Read @ %08X\n\",wpaddr ; g }")
-- cpudebug:wpset(programSpace, "rw", 0x10d4bc, 1, 'printf "Read @ %08X\n",wpaddr ; g')

-------------- MAME Helpers -------------

function poke(addr, bytes)
   if type(bytes)=="number" then bytes = {bytes} end
   bytes = flatten(bytes)
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

-- return an array with  hi/lo bytes of a 16bit value
function x(v)
   return { v & 0xff, v >> 8 }
end

function on_switch_screen(cur, last)
 --
end

------------- Scratch pad -------------


-- poke_rom(0x069D, 0x20); -- autojump

-- try colorizing player
--poke_rom(0x8a2,8)
--poke_rom(0x1811,8)
--nope. poke_rom(0x149b,{0x3d,col,0x32,0x42,0x81,0x32,0x46,0x81,0xc9}

------------- z/80 op codes --------------

NOP = 0x00
JR = 0x18
JR_NZ = 0x20
INC_HL = 0x23
JR_Z = 0x28
LD_MEM_A = 0x32
LD_HL = 0x36
LD_A_MEM = 0x3a
INC_A = 0x3c
DEC_A = 0x3d
LD_A = 0x3e
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
RET_C = 0xD8
XOR_A = 0xAF
AND = 0xE6
OR = 0xF6
CP = 0xFE

--- RAM locations ---

SCREEN_NUM = 0x8029
PLAYER_LEFT_Y = 0x8077

---------------------------------------------------------

-- change color palette
-- (seems to also mess up a couple of tiles under P2 on load?)
function set_theme(col)
   -- patches RESET_XOFF_AND_COLS_AND_SPRITES
   -- change screen colors (resets xoffs and cols seperately)
   -- by adding an extra: `ld (hl), $col, inc hl` for the color
   poke_rom(0x1496, {
     LD_HL,     col,
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
   poke(0x8014, {0, 0, 0});
end

function do_disable_bonus_skip()
   local GOT_A_BONUS = 0x29c0
   poke_rom(GOT_A_BONUS, { JP, x(0x29f5) }) -- jump to end of sub
   poke_rom(0x29FC, { NOP, NOP, NOP }) -- but don't skip screen
end

----------- bug fixes -------------

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
   CALL,  0xD0,0x56, -- call DRAW_BUGGY_BORDER
   CALL,  0xA8,0x5a, -- call original FLASH_BORDER
   RET
})

-- add the cool spiral transition to attract mode
poke_rom(0x038b, { CALL, x(0x2550) }) -- cool transition!

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
     CALL, 0xa0,0x0c,  -- delay 8 vblanks
     CALL, 0xa0,0x0c,  -- delay 8 vblanks (still pretty short)
     RET, NOP, NOP     -- return after dino reset
   });
end

if fast_wipe == true then
   -- skip parts of $DURING_TRANSITION_NEXT
   poke_rom(0x1358, { JR,0x1e, NOP }) -- jumps to $_RESET_FOR_NEXT_LEVEL
   -- speeds up transition even more: skips $CLEAR_SCR_TO_BLANKS ...
   poke_rom(0x1378, { CALL, 0x90, 0x14 }) -- ...and just does RESET_XOFF_AND_COLS_AND_SPRITES
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
     LD_MEM_A, 0x2d,0x80, -- reset DINO_COUNTER
     JP,        0x88,0x3D  -- _CUTSCENE_DONE
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

if tile_indicator == true then
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

add_ev("game_start", function ()
   print("game started")
end)


LIVES = 0x8032
tap1 = mem:install_write_tap(LIVES, LIVES, "writes", function(offset, data)
   -- clear score on death
   if reset_score == true then
      do_reset_score()
   end

   if technicolor == true then
      set_theme(math.random(16))
   end
end)

local last_screen = 1
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

-- Change bg
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

-- p1/p2 button to skip forward/go back screens
pbuttons = false
buttons = 0x800c
PLAYER_X = 0x8140
tap4 = mem:install_write_tap(buttons, buttons, "writes", function(offset, data)
  local val = data & 3 -- 1: p1, 2: p2
  if pbuttons == true and val == 0 then
     -- button released (stops repeats)
     pbuttons = false
  end
  if not pbuttons and (val > 0) then
     pbuttons = true
     local is_playing = peek(PLAYER_X) > 0 -- 0 == not set
     if is_playing then
        local cur = peek(SCREEN_NUM)
        -- this doesn't work properly when you have loop selections.
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
        -- (this is what is scrolled while transitioning)
        if peek(0x8106) == 0 then
           set_pc(0x1778)
        end

     end
   end
end)

-- Player uses up a credit
credit_addr = 0x8303
credits = 0
tap5 = mem:install_write_tap(credit_addr, credit_addr, "writes", function(offset, data)
  -- figure out when hit start
  if data == credits - 1 then
     run_started = false -- credit started, but level not started yet...
     -- TODO: should this be set false on death? (yes!)
  end
  credits = data
end)

-------------------- OGNOB mode -------------------

-- Open-world mode: freely wander left or right
if ognob_mode == true then

   -- TODO: If you do a full Ognob run, there should be something on screen 1.
   local OGNOB_MODE_ADDR = 0x0800

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

     RET
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

   -- No bonuses when bongo-ing
   do_disable_bonus_skip()

   -- track an Ognob run
   local ognobbing = false
   add_ev("screen_change", function(cur, last)
     if cur == 27 and last == 1 then
        print("Begin Ognob run...")
        ognobbing = true
     end
   end)
end

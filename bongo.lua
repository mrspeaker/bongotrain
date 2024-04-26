-- Bongo trainer, by Mr Speaker.
-- https://www.mrspeaker.net

start_screen = 1 -- screen number (1-27), if not looping
loop_screens = {}--{13,14,18,21,25,27} -- if you want to practise levels, eg:
-- {}: no looping, normal sequence
-- {14}: repeat screen 14 over and over
-- {14, 18, 26}: repeat a sequence of screens
round = 2 -- starting round

-- Serious bizness
infinite_lives = true
fast_death = true    -- restart super fast after death
fast_wipe = true  -- don't do slow transition to next screen
disable_dino = false   -- no pesky dino... but also now you can't catch him
disable_round_speed_up = true -- don't get faster after catching dino
no_bonuses = false    -- don't skip screen on bonus
skip_cutscene = true  -- don't show the cutscene
clear_score = false -- reset score to 0 on death and new screen
tile_indicator = false -- see where the game things tiles are

-- Non-so-serious bizness
theme = 0 -- color theme (0-7). 0 =  default, 7 = best one
technicolor = false -- randomize theme every death
head_style = 0 -- 0 = normal, 1 = dance, 2 = dino, 3 = bongo, 4 = shy guy

extra_s_platform = false -- Adds a way to escape dino on S levels, for fun
fix_jump_bug = false -- hold down jump after transitioning screen from high jump
                     -- doesn't kill you.

-- Removed features I found in the code
show_timers = true -- speed run timers! Don't know why they removed them
prevent_cloud_jump = false -- makes jumping from underneath really crap!
alt_bongo_place = false -- I think was supposed to put guy on the ground for highwire levels

-----------------------------------
-- Bongo world map
-- 01:  n_n  n_n  nTn  n_n   /   W
-- 07:   \   n_n  nTn   /    W
-- 12:   \   n_n  nTn  n_n   S
-- 17:   \   n_n   S    \   S_S
-- 22:   W    \   S_S
-- 25:   W    \    S
-----------------------------------

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
function print_pairs(o)
   for tag, device in pairs(o) do print(tag) end
end

cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
io = cpu.spaces["io"]
gfx = manager.machine.devices[":gfxdecode"]
gfx1 = manager.machine.memory.regions[":gfx1"]

print_pairs(manager.machine.devices)
print(dump(gfx1.size))

-------------- Helpers -------------

function poke(addr, bytes)
   if type(bytes)=="number" then bytes = {bytes} end
   for i = 1, #bytes do
      mem:write_u8(addr + (i - 1), bytes[i])
   end
end

function poke_rom(addr, bytes)
   if type(bytes) == "number" then bytes = {bytes} end
   for i = 1, #bytes do
      mem:write_direct_u8(addr + (i - 1), bytes[i])
   end
end

function peek(addr)
   return mem:read_u8(addr)
end

function poke_gfx(color, addr, byte)
   if color & 1 == 1 then
      gfx1:write_u8(addr, byte)
   end

   if color & 2 == 2 then
      gfx1:write_u8(addr + 0x1000, byte)
   end
end

function on_game_start()
   started = false -- triggered below
end

------------- ROM hacks -------------

-- poke_rom(0x069D, 0x20); -- autojump lol
--poke_rom(0x1494,0x1)
--poke_rom(0x19dc,0x2)
--

-- try colorizing player
--poke_rom(0x8a2,8)
--poke_rom(0x1811,8)
--nope. poke_rom(0x149b,{0x3d,col,0x32,0x42,0x81,0x32,0x46,0x81,0xc9}

--poke_rom(0x3225, 0);

NOP = 0x00
JR = 0x18
JR_NZ = 0x20
INC_HL = 0x23
JR_Z = 0x28
LD_ADDR_A = 0x32
LD_HL = 0x36
LD_A_ADDR = 0x3a
INC_A = 0x3c
LD_A = 0x3e
LD_B_A = 0x47
LD_HL_A = 0x77
LD_A_B = 0x78
LD_A_L = 0x7d
LD_A_HL = 0x7e
RET_NZ = 0xC0
JP = 0xC3
RET = 0xC9
CALL = 0xCD
XOR_A = 0xAF
AND = 0xE6
OR = 0xF6
CP = 0xFE

if tile_indicator == true then
   -- draw in empty "solid" tile graphics (otherwise it draws holes)
   for i = 0, 7 do
      poke_gfx(2, 0xf9 * 0x8 + i, 0x7f)
      poke_gfx(1, 0xfb * 0x8 + i, 0x7f)
      poke_gfx(2, 0xff * 0x8 + i, 0x7f)
   end

   -- draw a "collision pole" in player graphics
   local foots = {0x135, 0x13d, 0x145, 0x14d, 0x155, 0x161}
   for i, v in pairs(foots) do
      -- middle pole
      poke_gfx(1, v * 0x8 + 7, 0x55)
      poke_gfx(2, v * 0x8 + 7, 0xAA)

      -- fwd/back markers
      poke_gfx(2, v * 0x8, 0x3f)
      poke_gfx(2, v * 0x8 + 8 + 8 + 7, 0x3f)

      -- blank out columns next
      poke_gfx(3, v * 0x8 + 6, 0x00)
      poke_gfx(3, v * 0x8 + 8 + 8, 0x00)
   end

   --- rotate through tiles as player walks
   poke_rom(
      0x09AD,
      {
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
         OR, 0xF8,
         LD_HL_A,
         LD_A, 0x1, -- 1 = solid tile
         RET
   })
end

-- change color palette
-- (seems to also mess up a couple of tiles under P2 on load?)
function set_theme(col)
   -- change screen colors (resets xoffs and cols seperately)
   -- adds an extra: `ld (hl), $col, inc hl` for the color
   poke_rom(0x1496, {
               LD_HL, col,
               INC_HL,
               LD_A_L,
               CP, 0x80,
               JR_NZ, 0xF5,
               RET
   })
   -- the routine above was duplicated, so just call instead.
   poke_rom(0x19d8,{
               CALL,0x90,0x14,
               0,0,0,0,0,0,0,0})
   -- bottom row color
   poke_rom(0x1047, col)
   poke_rom(0x179B, col)
   poke_rom(0x179B, col)
end

-- not doing by default as it changes how the game plays
function do_jump_bug_fix()
   poke_rom(0x14dd, {XOR_A,                -- reset falling_timer on
                     LD_ADDR_A, 0x11,0x80, -- ld  ($8011),a   ; screen_reset
                     RET,
                     LD_A_ADDR, 0x15,0x83, -- Existing: used to start $14e0,
                     AND, 0x03,            -- now starts $14e2
                     RET_NZ,
                     CALL, 0x50,0x3a,
                     CALL, 0x88,0x3a,
                     CALL, 0xc0,0x3a,
                     RET})
   poke_rom(0x3b6c, 0xe2) -- bump call addr to $14e2
end

if head_style > 0 then
   local flip_x = function(v) return v + 0x80 end
   local fr = ({0x3e, 0x2c, 0x05, 0x17})[head_style]
   local fl = ({flip_x(0x3e), flip_x(0x2c), 0x07, flip_x(0x17)})[head_style]
   local jump_fr = ({0x3a, 0x2c + 2, 0x05, 0x19})[head_style]

   poke_rom(0x063A, { LD_A,fr, LD_ADDR_A,0x41,0x81, RET }) -- player_move_right
   poke_rom(0x067a, { LD_A,fl, LD_ADDR_A,0x41,0x81, RET })  -- player_move_left
   poke_rom(0x1819, { LD_A,fr, LD_ADDR_A,0x41,0x81, RET }) -- reset_player
   poke_rom(0x07d5, fr) -- trigger_jump_left
   poke_rom(0x07b5, fl) -- trigger_jump_right
   poke_rom(0x08d5, jump_fr) -- trigger_jump_straight_up
   poke_rom(0x09de, { NOP, NOP, NOP }) -- check_if_landed reset
   poke_rom(0x06FA, { NOP, NOP, NOP }) -- player_physics frame set
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
-- bugfix: in attract screen, jumping up stairs the player's
-- head and legs are flipped for one frame of animation. Fix it!
poke_rom(0x5390, { 0x93,0x94 }) -- on the way up
poke_rom(0x5418, { 0x13,0x14 }) -- on the way down
-- subjective bugfix: add inner border to empty attract screen
poke_rom(0x48C7, {
   CALL,0xD0,0x56, -- call DRAW_BUGGY_BORDER
   CALL,0xA8,0x5a, -- call original FLASH_BORDER
   RET
})

-- what to do about Bongo Tree.
-- feels wrong to "fix" it.
-- poke_rom(0x19b7, {0,0,0, 0,0,0})

if fix_jump_bug == true then
   do_jump_bug_fix()
end

------------- settings -------------

if fast_death == true then
   -- return early from DO_DEATH_SEQUENCE
   poke_rom(0x0CCB, { RET, NOP, NOP }); -- return after dino reset
end

if fast_wipe == true then
   poke_rom(0x1358, { JR,0x1e, NOP }) -- jumps to $_RESET_FOR_NEXT_LEVEL
end

if disable_round_speed_up == true then
   poke_rom(0x4EE3, RET); -- return early
end

if skip_cutscene == true then
   poke_rom(
      0x3d48,
      {
         XOR_A,
         LD_ADDR_A, 0x2d,0x80, -- reset DINO_COUNTER
         JP, 0x88,0x3D -- jp _CUTSCENE_DONE
      }
   );
end

if no_bonuses == true then
   local GOT_A_BONUS = 0x29c0
   poke_rom(GOT_A_BONUS, { JP, 0xf5,0x29 }) -- jump to end of sub
   poke_rom(0x29FC, { NOP, NOP, NOP }) -- but don't skip screen
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

if disable_dino == true then
   poke_rom(0x22FE, RET); -- ret from timer start check
end

if extra_s_platform == true then
   poke_rom(0x1d00, {0x0c, 0xfe, 0x10, 0x10}) -- extra platform on S lol
end

if theme ~= 0 then
   set_theme(theme)
end

------------- RAM hacks -------------

started = false
loop_len = #loop_screens
loop_idx = 0

lives_addr = 0x8032
tap1 = mem:install_write_tap(lives_addr, lives_addr, "writes", function(offset, data)
   -- clear score on death
   if clear_score == true then
      poke(0x8014, {0, 0, 0});
   end

   if technicolor == true then
      set_theme(math.random(16))
   end

   -- infinite lives
   if infinite_lives == true and data < 3 then
      return 3
   end
end)

screen_addr = 0x8029
tap2 = mem:install_write_tap(screen_addr, screen_addr, "writes", function(offset, data)
   -- loop screens
   if data == 1 and not started then
      -- player has started
      started = true
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

   if started and loop_len > 0 then
      local next = loop_screens[loop_idx + 1]
      loop_idx = (loop_idx + 1) % loop_len
      return next
   end

   if clear_score == true then
      -- reset score on screen change
      poke(0x8014, {0, 0, 0});
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

-- p1/p2 button to skip/go back screens
pbuttons = false
buttons = 0x800c
tap4 = mem:install_write_tap(buttons, buttons, "writes", function(offset, data)
  local val = data & 3 -- 1: p1, 2: p2
  if pbuttons == true and val == 0 then
     -- button released (stops repeats)
     pbuttons = false
  end
  if not pbuttons and (val > 0) then
     pbuttons = true
     local is_playing = peek(0x8034)
     if is_playing then
        if val == 2 then -- p2 button, go back screen
           local cur = peek(screen_addr)
           if cur > 1 then
              poke(screen_addr, cur - 2)
           end
        end
        poke(0x8140, 0xe0);
     end
   end
end)

-- Fire "on_game_start" event player uses up a credit
credit_addr = 0x8303
credits = 0
tap5 = mem:install_write_tap(credit_addr, credit_addr, "writes", function(offset, data)
  -- figure out when hit start
  if data == credits - 1 then
     -- we started
     on_game_start()
  end
  credits = data
end)

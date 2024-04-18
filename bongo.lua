-- Bongo Training Montage --

start_screen = 8 -- screen number (1-27), if not looping
loop_screens = {} -- if you want to practise levels, eg:
-- {}: no looping, normal sequence
-- {14}: repeat screen 14 over and over
-- {14, 18, 26}: repeat a sequence of screens
round = 3 -- starting round

infinite_lives = true
disable_round_speed_up = true -- don't get faster after catching dino
skip_cutscene = false  -- don't show the cutscene
disable_dino = false   -- no pesky dino... but also now you can't catch him
fast_death = false    -- restart super fast after death (oops, messes with dino!)
clear_score = true    -- reset score to 0 on death and new screen

theme = 7 -- color theme (0-7). 0 =  default, 7 = best one
technicolor = false -- randomize theme every death

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


cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
gfx = manager.machine.devices[":gfxdecode"]
for tag, device in pairs(manager.machine.devices) do print(tag) end

--for k, v in pairs(mem.state) do print(k) end
--pal = manager.machine.devices[":gfxdecode"]
print("daf?")
dump(gfx.spaces)
dump(manager.machine.devices)
print("odon");

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

------------- ROM hacks -------------

-- poke_rom(0x069D, 0x20); -- autojump lol
poke_rom(0x1d00, {0x0c, 0xfe, 0x10, 0x10}) -- extra platform on S lol
--poke_rom(0x1494,0x1) -- mmm, blue
--poke_rom(0x19dc,0x2) -- mmm, blue
--
poke_rom(0x56da,0x5c) -- bugfix: draws inner border on YOUR BEING scrren

-- colorised 7 is best
function set_theme(col)
   -- change screen colors (resets xoffs and cols seperately)
   -- adds an extra: `ld (hl), $col, inc hl`
   poke_rom(0x1496,{ 0x36,col,0x23,0x7D,0xFE,0x80,0x20,0xF5,0xC9 })
   -- the routine above was duplicated, so just call instead.
   poke_rom(0x19d8,{0xCD,0x90,0x14,0,0,0,0,0,0,0,0})
   -- bottom row color
   poke_rom(0x1047,col)
   poke_rom(0x179B,col)
end

if fast_death == true then
   -- return early from DO_DEATH_SEQUENCE
   poke_rom(0x0CC0, 0xC9); -- return early
   poke_rom(0x0CC1, 0x00); -- nop out orignal
end

if disable_round_speed_up == true then
   poke_rom(0x4EE3, 0xC9); -- return early
end

if skip_cutscene == true then
   --0xc3 0x8B 0x3D
   poke_rom(0x3d48, {0xC3, 0x8B, 0x3D});
end

if alt_bongo_place == true then
   --Bongo on ground for high-wire levels (I think)
   poke_rom(0x0d40, 0x0); -- nop out ret
end

if show_timers == true then
   --enable's hidden speed-run timers!
   poke_rom(0x1410, 0x0); -- nop out ret
end

if prevent_cloud_jump == true then
   -- PREVENT_CLOUD_JUMP_REDACTED
   poke_rom(0x1290, 0x0); -- nop out ret
end

if disable_dino == true then
   poke_rom(0x22FE, 0xC9); -- ret from timer start check
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
      if technicolor == true then
         set_theme(math.random(16))
      end
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
         local speeds = { 0x1f, 0x10, 0xd, 0xb, 9, 7, 5, 3 }
         poke(SPEED_DELAY_P1, speeds[round]) -- round2 speed
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
-- todo: should respect loops?
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

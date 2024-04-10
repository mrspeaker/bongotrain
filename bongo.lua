-- Bongo Training Montage --

start_screen = 1 -- used if not looping
loop_screens = {14,13,18,13,18,13,10,13,14,18,24,25} --{13,14,17,18,24,25,27} -- if you want to practise levels, eg:
-- {}: no looping
-- {14}: repeat screen 14 over and over (screens are 1 to 27)
-- {14, 18, 26}: repeat a sequence of screens
round_two = true -- start in round two

infinite_lives = true
disable_round_speed_up = true -- don't get faster after catching dino
skip_cutscene = true -- don't show the cutscene
disable_dino = false   -- no pesky dino... but now you can't catch him
fast_death = false    -- restart super fast after death (oops, messes with dino!)

-- Removed features I found in the code
show_timers = true -- speed run timers! Don't know why they removed them
prevent_cloud_jump = false -- makes jumping from underneath really crap!
alt_bongo_place = false -- I think was supposed to put guy on the ground for highwire levels
---------------------

mem = manager.machine.devices[":maincpu"].spaces["program"]

if fast_death == true then
   -- return early from DO_DEATH_SEQUENCE
   mem:write_direct_u8(0x0CC0, 0xC9); -- return early
   mem:write_direct_u8(0x0CC1, 0x00); -- nop out orignal
end

if disable_round_speed_up == true then
   mem:write_direct_u8(0x4EE3, 0xC9); -- return early
end

if skip_cutscene == true then
   --0xc3 0x8B 0x3D
   mem:write_direct_u8(0x3D48+0, 0xC3); -- jp
   mem:write_direct_u8(0x3D48+1, 0x8B); -- jp
   mem:write_direct_u8(0x3D48+2, 0x3D); -- jp
end

if alt_bongo_place == true then
   --Bongo on ground for high-wire levels (I think)
   mem:write_direct_u8(0x0d40, 0x0); -- nop out ret
end

if show_timers == true then
   --enable's hidden speed-run timers!
   mem:write_direct_u8(0x1410, 0x0); -- nop out ret
end

if prevent_cloud_jump == true then
   -- PREVENT_CLOUD_JUMP_REDACTED
   mem:write_direct_u8(0x1290, 0x0); -- nop out ret
end

if disable_dino == true then
   --mem:write_direct_u8(0x1CD1, 0xC9); -- dino collision
   mem:write_direct_u8(0x22FE, 0xC9); -- ret from timer start check
end

started = false
loop_len = #loop_screens
loop_idx = 0

screen_addr = 0x8029
lives_addr = 0x8032
tap1 = mem:install_write_tap(screen_addr, lives_addr, "writes", function(offset, data)
   -- infinite lives
   if infinite_lives == true and offset == lives_addr and data < 3 then
      return 3
   end

   -- loop screens
   if offset == screen_addr then
      if data == 1 and not started then
         -- player has started
         started = true
         -- go to round 2 if requested
         local SPEED_DELAY_P1 = 0x805b
         if round_two == true and mem:read_u8(SPEED_DELAY_P1) == 0x1f then
            mem:write_u8(SPEED_DELAY_P1, 0x10) -- round2 speed
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
   end
end)

-- Change bg
ground = 0x90fe
w = {0x0e, 0x0a, 0x22, 0x1c, 0x0e, 0x3b, 0x3e, 0x22, 0x25, 0x1c, 0x0e, 0x23}
tap2 = mem:install_write_tap(ground, ground, "writes", function(offset, data)
   if data == 0x3e then
      local pos = 0x929e
      for i, v in pairs(w) do
         mem:write_u8(pos - (i - 1) * 0x20, v);
      end
   end
end)


-- p1/p2 button to skip/go back screens
pbuttons = false
tap3 = mem:install_write_tap(0x800c, 0x800c, "writes", function(offset, data)
  local val = data & 3 -- 1: p1, 2: p2
  if pbuttons == true and val == 0 then
     -- button released (stops repeats)
     pbuttons = false
  end
  if not pbuttons and (val > 0) then
     pbuttons = true
     local is_playing = mem:read_u8(0x8034)
     if is_playing then
        if val == 2 then -- p2 button, go back screen
           local cur = mem:read_u8(screen_addr)
           if cur > 1 then
              mem:write_u8(screen_addr,cur - 2);
           end
        end
        mem:write_u8(0x8140, 0xE0);
     end
   end
end)


--tap4 = mem:install_write_tap(0x815d, 0x815d, "writes", function(offset, data)
--                                return 0xA4
--end)

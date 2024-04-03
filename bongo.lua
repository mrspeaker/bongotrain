-- Bongo Training Montage --

start_screen = 1 -- used if not looping
loop_screens = {} -- if you want to practise levels, eg:
-- {}: no looping
-- {14}: repeat screen 14 over and over (screens are 1 to 27)
-- {14, 18, 26}: repeat a sequence of screens

mem = manager.machine.devices[":maincpu"].spaces["program"]

--enable's hidden speed-run timers!
mem:write_direct_u8(0x1410, 0x0); -- nop out ret

--mem:write_direct_u8(0x0d40, 0x0); -- nop out ret
--mem:write_direct_u8(0x1CD1, 0xC9); -- dino collision


started = false
loop_len = #loop_screens
loop_idx = 0

screen_addr = 0x8029
lives_addr = 0x8032
tap1 = mem:install_write_tap(screen_addr, lives_addr, "writes", function(offset, data)
   -- infinite lives
   if offset == lives_addr and data < 3 then
      return 3
   end

   -- loop screens
   if offset == screen_addr then
      if data == 1 and not started then
         -- player has started
         started = true
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

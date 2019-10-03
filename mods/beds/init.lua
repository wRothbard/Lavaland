-- This version of the beds mod is part of Glitchtest
-- Copyright 2018 James Stevenson
-- GNU GPL 3

minetest.settings:set("time_speed", 1)

beds = {}
beds.player = {}
beds.bed_position = {}
beds.pos = {}
beds.spawn = {}
beds.formspec = "size[8,15;false]" ..
	"no_prepend[]" ..
	"bgcolor[#080808BB;true]" ..
	"button_exit[2,12;4,0.75;leave;Leave Bed]" ..
""
local t = os.date("*t")
minetest.after(1, minetest.set_timeofday, (t.hour * 60 + t.min) / 1440)
beds.night_toggle = false
beds.selected = {}
beds.beds = {}
beds.beds_public = {}
local store = minetest.get_mod_storage()
if store:get_string("beds") ~= "" then
	beds.beds = minetest.deserialize(store:get_string("beds"))
end
if store:get_string("beds_public") ~= "" then
	beds.beds_public = minetest.deserialize(store:get_string("beds_public"))
end
local modpath = minetest.get_modpath("beds")
local step = 0

local bell = false

minetest.register_globalstep(function(dtime)
	if step < 59 then
		step = step + dtime
		return
	end
	local t = os.date("*t")
	if t.min == 0 and not bell then
		music.seq("bell", t.hour)
		bell = true
	elseif t.min == 1 and bell then
		bell = false
	end
	if beds.night_toggle then
		minetest.set_timeofday(((t.hour + 12) % 24 * 60 + t.min) / 1440)
	else
		minetest.set_timeofday((t.hour * 60 + t.min) / 1440)
	end
	store:set_string("beds", minetest.serialize(beds.beds))
	store:set_string("beds_public", minetest.serialize(beds.beds_public))
	step = 0
end)

minetest.register_on_shutdown(function()
	store:set_string("beds", minetest.serialize(beds.beds))
	store:set_string("beds_public", minetest.serialize(beds.beds_public))

end)
dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")

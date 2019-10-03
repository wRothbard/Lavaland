music = {}
--music.players = {}

dofile(minetest.get_modpath("music") .. "/sounds.lua")

local rand = math.random

function music.play(sss, spt)
	if type(sss) == "string" then
		sss = {name = sss}
	end
	spt = spt or {}
	return minetest.sound_play(sss, spt)
end

local function show_piano(pos, node, clicker, itemstack, pointed_thing)
	local fs = "size[12,3]" ..
	""
	for i = 1, 10 do
		fs = fs .. "button[" .. i .. ",0;1,1;pin" .. i .. ";]"
	end
	minetest.show_formspec(clicker:get_player_name(), "music:piano",
			fs)
end

music.seq = function(name, times)
	times = times % 12
	for i = 1, times do
		minetest.after(i * 3, function()
			local handle = music.play("music_bell", {pitch = 0.443, gain = 0.44})
			minetest.sound_fade(handle, -0.06, 0)
		end)
	end
end

--[[
minetest.register_abm({
	label = "Lava sounds",
	nodenames = "lava:source",
	neighbors = {"obsidian:obsidian"},
	interval = 6.0,
	chance = 3,
	catch_up = false,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local o = minetest.get_objects_inside_radius(pos, 3)
		for i = 1, #o do
			local p = o[i]
			if p:is_player() then
				local name = p:get_player_name()
				local n = music.players[name]
				if n < 3 then
					music.players[name] = n + 1
					pos.y = pos.y - 5
					minetest.sound_play("lava", {
						pos = pos,
						gain = rand(),
						pitch = rand(),
					})
					minetest.after(rand(5, 10), function()
						if music.players[name] then
							music.players[name] = music.players[name] - 1
						end
					end)
					break
				end
			end
		end
	end,
})

minetest.register_on_joinplayer(function(player)
	music.players[player:get_player_name()] = 0
end)

minetest.register_on_leaveplayer(function(player)
	music.players[player:get_player_name()] = nil
end)
--]]

minetest.register_chatcommand("hum", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		music.play("music_square", {
			to_player = name,
			loop = true,
			gain = 0.06,
			pitch = 0.0334,
		})
	end,
})

minetest.register_chatcommand("m", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Not in game!"
		end
		local spt = {object = player}
		param = param:split(" ")
		if not param[1] then
			param[1] = ""
		end
		if param[2] then
			spt.pitch = tonumber(param[2])
		end
		music.play(param[1], spt)
	end,
})

minetest.register_chatcommand("p", {
	func = function(name, param)
		show_piano(nil, nil, minetest.get_player_by_name(name))
	end,
})

minetest.register_node("music:piano", {
	description = "Piano",
	on_rightclick = show_piano,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "music:piano" then
		local spt = {}
		if fields.pin1 then
			spt.pitch = 0.5
		elseif fields.pin2 then
			spt.pitch = 0.56
		elseif fields.pin3 then
			spt.pitch = 0.62
		elseif fields.pin4 then
			spt.pitch = 0.68
		elseif fields.pin5 then
			spt.pitch = 0.74
		elseif fields.pin6 then
			spt.pitch = 0.80
		elseif fields.pin7 then
			spt.pitch = 0.86
		elseif fields.pin8 then
			spt.pitch = 0.92
		elseif fields.pin9 then
			spt.pitch = 0.98
		elseif fields.pin10 then
			spt.pitch = 1.04
		end
		spt.pitch = spt.pitch and spt.pitch * 0.6
		spt.object = player
		spt.gain = 0.2
		local h = music.play("music_bell", spt)
		minetest.sound_fade(h, -0.23, 0)
	end
end)

print("loaded music")

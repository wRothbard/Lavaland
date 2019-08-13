mapgen = {}
mapgen.homes = {}

local ss = minetest.settings:get("static_spawnpoint")

if ss then
	ss = minetest.string_to_pos(ss)
else
	ss = {x = 0, y = 5, z = 0}
end

minetest.register_chatcommand("sethome", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Not a player!"
		end

		local pos = player:get_pos()
		mapgen.homes[name] = pos
		local meta = player:get_meta()
		meta:set_string("home", minetest.pos_to_string(pos))
	end,
})

minetest.register_chatcommand("home", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Not a player!"
		end

		local pos = mapgen.homes[name]
		if not pos then
			return false, "No home set!"
		end

		player:set_pos(pos)
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.spawn then
		player:set_pos(ss)
		minetest.sound_play("mapgen_item", {pos = ss, gain = 0.3})
	elseif formname == "" and fields.home then
		local name = player:get_player_name()
		local pos = mapgen.homes[name]
		if pos then
			player:set_pos(pos)
		else
			minetest.chat_send_player(name, "No home set!")
		end
	end
end)

minetest.set_mapgen_setting("mg_name", "singlenode")

minetest.register_on_generated(function(minp, maxp, seed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local a = VoxelArea:new{
		MinEdge = {x = emin.x, y = emin.y, z = emin.z},
		MaxEdge = {x = emax.x, y = emax.y, z = emax.z},
	}
	local data = vm:get_data()
	local c_lava = minetest.get_content_id("lava:source")
	local c_floor = minetest.get_content_id("map:floor")
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				if y < 1 then
					if y > -17 then
						local vi = a:index(x, y, z)
						data[vi] = c_lava
					else--if y > -2017 then
						local vi = a:index(x, y, z)
						data[vi] = c_floor
					end
				end
			end
		end
	end
	vm:set_data(data)
	--[[
	vm:calc_lighting(
		{x = minp.x - 16, y = minp.y, z = minp.z - 16},
		{x = maxp.x + 16, y = maxp.y, z = maxp.z + 16}
	)
	--]]
	vm:write_to_map(data)
end)

minetest.register_on_joinplayer(function(player)
	local home = player:get_meta():get_string("home")
	if home ~= "" then
		mapgen.homes[player:get_player_name()] = minetest.string_to_pos(home)
	end
end)

minetest.register_on_leaveplayer(function(player)
	mapgen.homes[player:get_player_name()] = nil
end)

print("loaded mapgen")

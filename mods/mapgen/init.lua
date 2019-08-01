local ss = minetest.settings:get("static_spawnpoint")

if ss then
	ss = minetest.string_to_pos(ss)
else
	ss = {x = 0, y = 5, z = 0}
end

minetest.register_chatcommand("spawn", {
	func = function(name)
		minetest.get_player_by_name(name):set_pos(ss)
		minetest.sound_play("mapgen_item", {pos = ss, gain = 0.3})
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.spawn then
		player:set_pos(ss)
		minetest.sound_play("mapgen_item", {pos = ss, gain = 0.3})
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
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				if y < 1 then
					local vi = a:index(x, y, z)
					data[vi] = c_lava
				end
			end
		end
	end
	vm:set_data(data)
	vm:calc_lighting(
		{x = minp.x - 16, y = minp.y, z = minp.z - 16},
		{x = maxp.x + 16, y = maxp.y, z = maxp.z + 16}
	)
	vm:write_to_map(data)
end)

print("mapgen loaded")

spawn = {}

local ss = minetest.settings:get("static_spawnpoint")

if ss then
	ss = minetest.string_to_pos()
else
	ss = {x = 0, y = 5, z = 0}
end

spawn.pos = ss

minetest.register_chatcommand("spawn", {
	func = function(name)
		minetest.get_player_by_name(name):set_pos(ss)
		minetest.sound_play("mapgen_item", {pos = ss})
	end,
})

print("loaded spawn")

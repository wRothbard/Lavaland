spawn = {}

local ss = minetest.settings:get("static_spawnpoint")

if ss then
	ss = minetest.string_to_pos()
else
	ss = {x = -24.8, y = 1.5, z = 135.3}
end

spawn.pos = ss

minetest.register_chatcommand("spawn", {
	description = "Teleport to spawn",
	params = "",
	privs = "interact",
	func = function(name)
		minetest.get_player_by_name(name):set_pos({x = -24.8, y = 1.5, z = 135.3})
		minetest.sound_play("mapgen_item", {pos = ss})
	end,
})

minetest.register_chatcommand("setspawn", {
	description = "Set your respawn location",
	params = "",
	privs = "interact",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "You must be in the game for this command to work."
		end
		local pos = player:get_pos()
		beds.spawn[name] = pos
		return true, "Your respawn position has been saved."
	end,
})

print("loaded spawn")

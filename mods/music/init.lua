music = {}
music.players = {}

music.sounds = {
	material = {
		metal = {},
		stone = {},
		wood = {},
		water = {},
		glass = {},
		lava = {},
	},
	player = {
		breath = {},
		damage = {},
	},
	nodes = {
		stone = {
			footstep = {
				name = "stone_hard_footstep",
				gain = 0.3,
			},
			dug = {
				name = "stone_hard_footstep",
				gain = 0.1,
			},
		},
		wood = {
			footstep = {
				name = "trees_wood_footstep",
				gain = 0.3,
			},
		},
	},
}
music.sounds.nodes["furnace"] = music.sounds.nodes.stone

local rand = math.random

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

print("music loaded")

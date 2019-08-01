minetest.register_node("obsidian:node", {
	description = "Obsidian",
	tiles = {"obsidian.png"},
	--sounds = default.node_sound_stone_defaults(),
	groups = {oddly_breakable_by_hand = 1},
})

print("obsidian loaded")

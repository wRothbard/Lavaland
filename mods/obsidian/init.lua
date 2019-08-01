minetest.register_node("obsidian:node", {
	description = "Obsidian",
	tiles = {"obsidian.png"},
	sounds = {
		footstep = "obsidian_footstep",
	},
	groups = {oddly_breakable_by_hand = 1, cracky = 3},
})

minetest.register_craftitem("obsidian:shard", {
	description = "Obsidian Shard",
	inventory_image = "obsidian_shard.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "obsidian:shard 9",
	recipe = {"obsidian:node"},
})

minetest.register_craft({
	output = "obsidian:node",
	recipe = {
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
	},
})

print("obsidian loaded")

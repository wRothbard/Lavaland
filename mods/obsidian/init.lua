local sounds = {
	footstep = {name = "obsidian_footstep", gain = 0.3},
	dig = {name = "obsidian_footstep", gain = 1.0},
	dug = {name = "obsidian_footstep", gain = 1.0},
}

minetest.register_alias("obsidian:node", "obsidian:obsidian")
minetest.register_node("obsidian:obsidian", {
	description = "Obsidian",
	tiles = {"obsidian.png"},
	sounds = sounds,
	groups = {oddly_breakable_by_hand = 1, cracky = 3},
})

minetest.register_craftitem("obsidian:shard", {
	description = "Obsidian Shard",
	inventory_image = "obsidian_shard.png",
})

minetest.register_craft({
	output = "obsidian:obsidian",
	recipe = {
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "obsidian:shard 9",
	recipe = {"obsidian:obsidian"},
})

minetest.register_craft({
	type = "cooking",
	output = "obsidian:glass",
	recipe = "obsidian:shard",
})

minetest.register_node("obsidian:glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"obsidian_glass.png", "obsidian_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	is_ground_content = false,
	sunlight_propagates = true,
	sounds = sounds,
	groups = {cracky = 3},
})

print("obsidian loaded")

-- Obsidian
minetest.register_node("obsidian:obsidian", {
	description = "Obsidian",
	tiles = {"obsidian_obsidian.png"},
	sounds = music.sounds.nodes.obsidian,
	groups = {oddly_breakable_by_hand = 1, cracky = 3, obsidian = 1},
})

minetest.register_alias("obsidian:node", "obsidian:obsidian")

minetest.register_craft({
	output = "obsidian:obsidian",
	recipe = {
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
		{"obsidian:shard", "obsidian:shard", "obsidian:shard"},
	},
})

-- Obsidian Brick
minetest.register_node("obsidian:brick", {
	description = "Obsidian Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"obsidian_brick.png"},
	is_ground_content = false,
	sounds = music.sounds.nodes.obsidian,
	groups = {cracky = 2, level = 2, obsidian = 1},
})

minetest.register_craft({
	output = "obsidian:brick 4",
	recipe = {
		{"obsidian:obsidian", "obsidian:obsidian"},
		{"obsidian:obsidian", "obsidian:obsidian"}
	}
})

-- Obsidian Block
minetest.register_node("obsidian:block", {
	description = "Obsidian Block",
	tiles = {"obsidian_block.png"},
	is_ground_content = false,
	sounds = music.sounds.nodes.obsidian,
	groups = {cracky = 2, level = 2, obsidian = 1},
})

minetest.register_craft({
	output = "obsidian:block 9",
	recipe = {
		{"obsidian:obsidian", "obsidian:obsidian", "obsidian:obsidian"},
		{"obsidian:obsidian", "obsidian:obsidian", "obsidian:obsidian"},
		{"obsidian:obsidian", "obsidian:obsidian", "obsidian:obsidian"},
	}
})

-- Obsidian Shard
minetest.register_craftitem("obsidian:shard", {
	description = "Obsidian Shard",
	inventory_image = "obsidian_shard.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "obsidian:shard 9",
	recipe = {"obsidian:obsidian"},
})

-- Obsidian Glass
minetest.register_node("obsidian:glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {"obsidian_glass.png", "obsidian_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	is_ground_content = false,
	sunlight_propagates = true,
	sounds = music.sounds.material.glass,
	groups = {cracky = 3, obsidian = 1},
})

minetest.register_craft({
	type = "cooking",
	output = "obsidian:glass",
	recipe = "obsidian:shard",
})

print("loaded obsidian")

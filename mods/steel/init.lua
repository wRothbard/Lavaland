local sounds = {
	footstep = {name = "default_metal_footstep", gain = 0.4},
	dig = {name = "default_dig_metal", gain = 0.5},
	dug = {name = "default_dug_metal", gain = 0.5},
	place = {name = "default_place_node_metal", gain = 0.5},
}

minetest.register_craftitem("steel:ingot", {
	description = "Steel Ingot",
	inventory_image = "steel_ingot.png"
})

minetest.register_alias("stone:iron_lump", "steel:iron_lump")
minetest.register_craftitem("steel:iron_lump", {
	description = "Iron Lump",
	inventory_image = "stone_iron_lump.png"
})

minetest.register_node("steel:block", {
	description = "Steel Block",
	tiles = {"steel_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = sounds,
})

minetest.register_craft({
	output = "steel:block",
	recipe = {
		{"steel:ingot", "steel:ingot", "steel:ingot"},
		{"steel:ingot", "steel:ingot", "steel:ingot"},
		{"steel:ingot", "steel:ingot", "steel:ingot"},
	},
})

minetest.register_craft({
	type = "cooking",
	output = "steel:ingot",
	recipe = "steel:iron_lump",
})

print("steel loaded")

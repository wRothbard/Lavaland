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
	sounds = music.sounds.material.metal,
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
	type = "shapeless",
	output = "steel:ingot 9",
	recipe = {"steel:block"},
})

minetest.register_craft({
	type = "cooking",
	output = "steel:ingot",
	recipe = "steel:iron_lump",
})

print("loaded steel")

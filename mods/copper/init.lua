minetest.register_node("copper:block", {
	description = "Copper Block",
	tiles = {"copper_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	--sounds = default.node_sound_metal_defaults(),
})

minetest.register_craftitem("copper:lump", {
	description = "Copper Lump",
	inventory_image = "copper_lump.png"
})

minetest.register_craftitem("copper:ingot", {
	description = "Copper Ingot",
	inventory_image = "copper_ingot.png"
})

minetest.register_craft({
	output = "copper:block",
	recipe = {
		{"copper:ingot", "copper:ingot", "copper:ingot"},
		{"copper:ingot", "copper:ingot", "copper:ingot"},
		{"copper:ingot", "copper:ingot", "copper:ingot"},
	}
})

minetest.register_craft({
	output = "copper:ingot 9",
	recipe = {
		{"copper:block"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "copper:ingot",
	recipe = "copper:lump",
})

print("loaded copper")

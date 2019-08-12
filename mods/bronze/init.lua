minetest.register_craftitem("bronze:ingot", {
	description = "Bronze Ingot",
	inventory_image = "default_bronze_ingot.png"
})

minetest.register_node("bronze:block", {
	description = "Bronze Block",
	tiles = {"default_bronze_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	--sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bronze:ingot 9",
	recipe = {
		{"copper:ingot", "copper:ingot", "copper:ingot"},
		{"copper:ingot", "steel:ingot", "copper:ingot"},
		{"copper:ingot", "copper:ingot", "copper:ingot"},
	}
})

minetest.register_craft({
	output = "bronze:block",
	recipe = {
		{"bronze:ingot", "bronze:ingot", "bronze:ingot"},
		{"bronze:ingot", "bronze:ingot", "bronze:ingot"},
		{"bronze:ingot", "bronze:ingot", "bronze:ingot"},
	}
})

minetest.register_craft({
	output = "bronze:ingot 9",
	recipe = {
		{"bronze:block"},
	}
})

print("loaded bronze")

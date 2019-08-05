local sounds = {
	footstep = {name = "default_metal_footstep", gain = 0.4},
	dig = {name = "default_dig_metal", gain = 0.5},
	dug = {name = "default_dug_metal", gain = 0.5},
	place = {name = "default_place_node_metal", gain = 0.5},
}

minetest.register_craftitem("steel:ingot", {
	description = "Steel Ingot",
	inventory_image = "default_steel_ingot.png"
})

minetest.register_node("steel:block", {
	description = "Steel Block",
	tiles = {"default_steel_block.png"},
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

print("steel loaded")

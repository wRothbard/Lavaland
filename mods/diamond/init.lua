minetest.register_craftitem("diamond:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png",
})

minetest.register_node("diamond:block", {
	description = "Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3, trade_value = 15,},
	sounds = music.sounds.material.metal,
})

minetest.register_craft({
	output = "diamond:block",
	recipe = {
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
	}
})

minetest.register_craft({
	output = "diamond:diamond 9",
	recipe = {
		{"diamond:block"},
	}
})

print("loaded diamond")

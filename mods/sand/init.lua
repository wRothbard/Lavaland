minetest.register_node("sand:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	--sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("sand:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {crumbly = 1, cracky = 3},
	--sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("sand:sandstone_brick", {
	description = "Sandstone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_sandstone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	--sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("sand:sandstone_block", {
	description = "Sandstone Block",
	tiles = {"default_sandstone_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	--sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type = "shapeless",
	output = "sand:sand 2",
	recipe = {"gravel:gravel"},
})

minetest.register_craft({
	output = "sand:sandstone",
	recipe = {
		{"sand:sand", "sand:sand"},
		{"sand:sand", "sand:sand"},
	}
})

minetest.register_craft({
	output = "sand:sand 4",
	recipe = {
		{"sand:sandstone"},
	}
})

minetest.register_craft({
	output = "sand:sandstone_brick 4",
	recipe = {
		{"sand:sandstone", "sand:sandstone"},
		{"sand:sandstone", "sand:sandstone"},
	}
})

minetest.register_craft({
	output = "sand:sandstone_block 9",
	recipe = {
		{"sand:sandstone", "sand:sandstone", "sand:sandstone"},
		{"sand:sandstone", "sand:sandstone", "sand:sandstone"},
		{"sand:sandstone", "sand:sandstone", "sand:sandstone"},
	}
})

print("sand loaded")

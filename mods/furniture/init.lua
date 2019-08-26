minetest.register_node("furniture:chair", {
	description = "Chair",
	tiles = {"xdecor_wood.png"},
	sounds = music.sounds.nodes.wood,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 2},
	on_rotate = screwdriver.rotate_simple,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
                	{-0.3125, -0.5, 0.1875, -0.1875, 0.5, 0.3125},
			{0.1875, -0.5, 0.1875, 0.3125, 0.5, 0.3125},
			{-0.1875, 0.0625, 0.21875, 0.1875, 0.4375, 0.28125},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.125, -0.1875},
			{0.1875, -0.5, -0.3125, 0.3125, -0.125, -0.1875},
			{-0.3125, -0.125, -0.3125, 0.3125, 0, 0.1875}
		}
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		cozy.sit(clicker)
		clicker:move_to(pos)
		return itemstack
	end
})

minetest.register_craft({
	output = "furniture:chair",
	recipe = {
		{"group:stick", "", ""},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"}
	}
})

minetest.register_node("furniture:table", {
	description = "Table",
	tiles = {"xdecor_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = music.sounds.nodes.wood,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
			{-0.15625, -0.5, -0.15625, 0.15625, 0.375, 0.21875},
		},
	},
})

minetest.register_craft({
	output = "furniture:table",
	recipe = {
		{"shapes:slab_wood", "shapes:slab_wood", "shapes:slab_wood"},
		{"", "group:stick", ""},
		{"", "group:stick", ""}
	}
})

print("loaded furniture")

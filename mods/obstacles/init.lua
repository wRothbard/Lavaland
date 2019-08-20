minetest.register_node("obstacles:baricade", {
	description = "Baricade",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	inventory_image = "xdecor_baricade.png",
	tiles = {"xdecor_baricade.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	damage_per_second = 4,
	selection_box = {type = "fixed", fixed = {
		-0.5,
		-0.5,
		-0.5,
		0.5,
		-0.2,
		0.5
	}},
	collision_box = {type = "fixed", fixed = {
		-0.5,
		-0.5,
		-0.5,
		0.5,
		-0.2,
		0.5
	}},
})

minetest.register_craft({
	output = "obstacles:baricade",
	recipe = {
		{"group:stick", "", "group:stick"},
		{"", "steel:ingot", ""},
		{"group:stick", "", "group:stick"}
	}
})

minetest.register_node("obstacles:cobweb", {
	description = "Cobweb",
	drawtype = "plantlike",
	tiles = {"xdecor_cobweb.png"},
	paramtype = "light",
	inventory_image = "xdecor_cobweb.png",
	liquid_viscosity = 8,
	liquidtype = "source",
	liquid_alternative_flowing = "obstacles:cobweb",
	liquid_alternative_source = "obstacles:cobweb",
	liquid_renewable = false,
	liquid_range = 0,
	walkable = false,
	selection_box = {type = "regular"},
	groups = {snappy = 3, liquid = 3, flammable = 3},
	sounds = music.sounds.nodes.leaves,
})

minetest.register_craft({
	output = "obstacles:cobweb",
	recipe = {
		{"farming:cotton", "", "farming:cotton"},
		{"", "farming:cotton", ""},
		{"farming:cotton", "", "farming:cotton"}
	}
})

print("loaded obstacles")

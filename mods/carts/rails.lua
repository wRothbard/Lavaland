carts:register_rail("carts:rail", {
	description = "Rail",
	tiles = {
		"carts_rail_straight.png", "carts_rail_curved.png",
		"carts_rail_t_junction.png", "carts_rail_crossing.png"
	},
	inventory_image = "carts_rail_straight.png",
	wield_image = "carts_rail_straight.png",
	groups = carts:get_rail_groups(),
}, {})

minetest.register_craft({
	output = "carts:rail 18",
	recipe = {
		{"steel:ingot", "group:wood", "steel:ingot"},
		{"steel:ingot", "", "steel:ingot"},
		{"steel:ingot", "group:wood", "steel:ingot"},
	}
})

minetest.register_alias("default:rail", "carts:rail")


carts:register_rail("carts:powerrail", {
	description = "Powered Rail",
	tiles = {
		"carts_rail_straight_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"
	},
	groups = carts:get_rail_groups(),
}, {acceleration = 5})

minetest.register_craft({
	output = "carts:powerrail 18",
	recipe = {
		{"steel:ingot", "group:wood", "steel:ingot"},
		{"steel:ingot", "mese:crystal", "steel:ingot"},
		{"steel:ingot", "group:wood", "steel:ingot"},
	}
})


carts:register_rail("carts:brakerail", {
	description = "Brake Rail",
	tiles = {
		"carts_rail_straight_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"
	},
	groups = carts:get_rail_groups(),
}, {acceleration = -3})

minetest.register_craft({
	output = "carts:brakerail 18",
	recipe = {
		{"steel:ingot", "group:wood", "steel:ingot"},
		{"steel:ingot", "coal:lump", "steel:ingot"},
		{"steel:ingot", "group:wood", "steel:ingot"},
	}
})

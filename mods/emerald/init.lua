minetest.register_craftitem("emerald:emerald", {
	description = "Emerald",
	inventory_image = "emerald_emerald.png",
})

minetest.register_node("emerald:block", {
	description = "Emerald Block",
	tiles = {"emerald_block.png"},
	groups = {cracky = 2},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	output = "emerald:emerald 9",
	recipe = {{"emerald:block"}}
})

minetest.register_craft({
	output = "emerald:block",
	recipe = {
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"},
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"},
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"}
	}
})

print("loaded emerald")

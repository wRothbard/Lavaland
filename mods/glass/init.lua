minetest.register_node("glass:glass", {
	description = "Glass",
	drawtype = "glasslike_framed",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3, glass = 1},
	sounds = music.sounds.material.glass,
})

minetest.register_craft({
	type = "cooking",
	output = "glass:glass",
	recipe = "sand:sand",
})

print("loaded glass")

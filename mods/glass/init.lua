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

for i = 2, #dye.dyes do
	local color = dye.dyes[i][1]
	local name = dye.dyes[i][2]
	local colorize = "^[colorize:" .. dye.dyes[i][3] .. ":191"

	minetest.register_node("glass:glass_" .. color, {
		description = "Glass (" .. name .. ")",
		drawtype = "glasslike_framed",
		tiles = {
			"default_glass.png" .. colorize,
			"default_glass_detail.png" .. colorize,
		},
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {cracky = 3, oddly_breakable_by_hand = 3, glass = 1},
		sounds = music.sounds.material.glass,
	})
	minetest.register_craft({
		type = "shapeless",
		output = "glass:glass_" .. color,
		recipe = {"glass:glass", "dye:" .. color},
	})
end

minetest.register_craft({
	type = "cooking",
	output = "glass:glass",
	recipe = "sand:sand",
})

print("loaded glass")

for k, v in ipairs(dye.dyes) do
	beds.register_bed("beds:bed_" .. v[1], {
		description = v[2] .. " Bed",
		inventory_image = "beds_bed.png^(wool_" .. v[1] .. ".png^[mask:beds_blanket.png)",
		wield_image = "beds_bed.png^(wool_" .. v[1] .. ".png^[mask:beds_blanket.png)",
		tiles = {
			bottom = {
				"wool_" .. v[1] .. ".png^[transformR90",
				"default_wood.png",
				"[combine:16x16:0,0=wool_" .. v[1] ..
						[[.png:0,11=default_wood.png\^[transformR180]],
				"([combine:16x16:0,0=wool_" .. v[1] ..
						[[.png:0,11=default_wood.png\^[transformR180)^[transformFX]],
				"[combine:16x16",
				"[combine:16x16:0,7=wool_" .. v[1] ..
						[[.png:0,11=default_wood.png\^[transformR180]],
			},
			top = {
				"(wool_" .. v[1] ..
						[[.png^[combine:16x16:8,0=beds_bed_top_top.png\^[transformR180)^[transformR90]],
				"default_wood.png",
				"(beds_bed_side_top_r.png^[combine:8x4:-8,0=wool_" ..
						v[1] .. [[.png)^[lowpart:27:default_wood.png\^[transformFX]],
				"((beds_bed_side_top_r.png^[combine:8x4:-8,0=wool_" ..
						v[1] .. [[.png)^[lowpart:27:default_wood.png\^[transformFX)^[transformFX]],
				"beds_bed_side_top.png^[lowpart:27:default_wood.png",
				"[combine:16x16",
			}
		},
		nodebox = {
			bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
			top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
		},
		selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
		recipe = {
			{"wool:" .. v[1], "wool:" .. v[1], "wool:white"},
			{"group:wood", "group:wood", "group:wood"}
		},
	})
	minetest.register_craft({
		type = "fuel",
		recipe = "beds:bed_" .. v[1] .. "_bottom",
		burntime = 12,
	})
end

minetest.register_tool("tools:pick_mese_bone", {
	description = "Mese Bone Pickaxe",
	inventory_image = "tools_mesepick_bone.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
			cracky = {
				times = {
					[1] = 3.6,
					[2] = 2.4,
					[3] = 1.2
				},
				uses = 20,
				maxlevel = 3
			},
		},
		damage_groups = {
			fleshy = 5
		},
	},
	sound = {
		breaks = "default_tool_breaks"
	},
	groups = {
		pickaxe = 1
	}
})

minetest.register_craft({
	output = "tools:pick_mese_bone",
	recipe = {
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"", "bones:bone", ""},
		{"", "bones:bone", ""},
	},
})

print("tools loaded")

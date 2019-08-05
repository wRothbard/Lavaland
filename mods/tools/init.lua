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

minetest.register_tool("tools:sword_mese_bone", {
	description = "Mese Sword",
	inventory_image = "tools_mesesword_bone.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craft({
	output = "tools:sword_mese_bone",
	recipe = {
		{"mese:crystal"},
		{"mese:crystal"},
		{"bones:bone"},
	},
})

print("tools loaded")

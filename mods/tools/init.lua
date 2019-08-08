minetest.register_tool("tools:pick_mese_bone", {
	description = "Mese Bone Pickaxe",
	inventory_image = "tools_mese_pick_bone.png",
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

minetest.register_tool("tools:pick_mese", {
	description = "Mese Pickaxe",
	inventory_image = "tools_mese_pick.png",
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
				uses = 10,
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
	output = "tools:pick_mese",
	recipe = {
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	},
})

minetest.register_tool("tools:axe_mese_bone", {
	description = "Mese Bone Axe",
	inventory_image = "tools_mese_axe_bone.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_craft({
	output = "tools:axe_mese_bone",
	recipe = {
		{"mese:crystal", "mese:crystal", ""},
		{"mese:crystal", "bones:bone", ""},
		{"", "bones:bone", ""},
	},
})

minetest.register_tool("tools:axe_mese", {
	description = "Mese Axe",
	inventory_image = "tools_mese_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=10, maxlevel=3},
		},
		damage_groups = {fleshy=6},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_craft({
	output = "tools:axe_mese",
	recipe = {
		{"mese:crystal", "mese:crystal", ""},
		{"mese:crystal", "group:stick", ""},
		{"", "group:stick", ""},
	},
})

minetest.register_tool("tools:shovel_mese_bone", {
	description = "Mese Bone Shovel",
	inventory_image = "tools_mese_shovel_bone.png",
	wield_image = "tools_mese_shovel_bone.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1}
})

minetest.register_craft({
	output = "tools:shovel_mese_bone",
	recipe = {
		{"mese:crystal"},
		{"bones:bone"},
		{"bones:bone"},
	},
})

minetest.register_tool("tools:shovel_mese", {
	description = "Mese Shovel",
	inventory_image = "tools_mese_shovel.png",
	wield_image = "tools_mese_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=9, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1}
})

minetest.register_craft({
	output = "tools:shovel_mese",
	recipe = {
		{"mese:crystal"},
		{"group:stick"},
		{"group:stick"},
	},
})

minetest.register_tool("tools:sword_mese_bone", {
	description = "Mese Bone Sword",
	inventory_image = "tools_mese_sword_bone.png",
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

minetest.register_tool("tools:sword_mese", {
	description = "Mese Sword",
	inventory_image = "tools_mese_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=10, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craft({
	output = "tools:sword_mese",
	recipe = {
		{"mese:crystal"},
		{"mese:crystal"},
		{"group:stick"},
	},
})

print("tools loaded")

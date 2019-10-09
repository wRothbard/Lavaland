minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})

-- bug net
minetest.register_alias("fireflies:bug_net", "tools:bug_net")
minetest.register_tool("tools:bug_net", {
	description = "Bug Net",
	inventory_image = "fireflies_bugnet.png",
	on_use = function(itemstack, player, pointed_thing)
		if not pointed_thing or pointed_thing.type ~= "node" or
				minetest.is_protected(pointed_thing.under,
						player:get_player_name()) then
			return
		end
		local node_name = minetest.get_node(pointed_thing.under).name
		local inv = player:get_inventory()
		if minetest.get_item_group(node_name, "catchable") == 1 then
			minetest.set_node(pointed_thing.under, {name = "air"})
			local stack = ItemStack(node_name.." 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.add_item(pointed_thing.under, node_name.." 1")
			end
		end
		itemstack:add_wear(256)
		return itemstack
	end
})

minetest.register_craft( {
	output = "tools:bug_net",
	recipe = {
		{"farming:string", "farming:string"},
		{"farming:string", "farming:string"},
		{"group:stick", ""}
	}
})

minetest.register_tool("tools:bug_net_mese", {
	description = "Mese Bug Net",
	inventory_image = "fireflies_bugnet_mese.png",
	on_use = function(itemstack, player, pointed_thing)
		if not pointed_thing or pointed_thing.type ~= "node" or
				minetest.is_protected(pointed_thing.under,
						player:get_player_name()) then
			return
		end
		local node_name = minetest.get_node(pointed_thing.under).name
		local inv = player:get_inventory()
		if minetest.get_item_group(node_name, "catchable") == 1 then
			minetest.set_node(pointed_thing.under, {name = "air"})
			local stack = ItemStack(node_name.." 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.add_item(pointed_thing.under, node_name.." 1")
			end
		end
		itemstack:add_wear(256)
		return itemstack
	end
})

minetest.register_craft( {
	output = "tools:bug_net_mese",
	recipe = {
		{"mese:crystal_fragment", "mese:crystal_fragment"},
		{"mese:crystal_fragment", "mese:crystal_fragment"},
		{"group:stick", ""}
	}
})

minetest.register_alias("mobs:shears", "tools:shears")
minetest.register_tool("tools:shears", {
	description = "Steel Shears",
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2, tool = 1, trade_value = 3,},
})

minetest.register_craft({
	output = "tools:shears",
	recipe = {
		{"", "steel:ingot", ""},
		{"", "group:stick", "steel:ingot"},
	}
})

minetest.register_tool("tools:crystalline_bell", {
	description = "Crystalline Bell",
	inventory_image = "tools_crystalline_bell.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.under
		if minetest.is_protected(pos, user:get_player_name()) then
			return
		end
		local node = minetest.get_node(pos)
		local growth_stage = 0
		if node.name == "mese:crystal_ore4" then
			growth_stage = 4
		elseif node.name == "mese:crystal_ore3" then
			growth_stage = 3
		elseif node.name == "mese:crystal_ore2" then
			growth_stage = 2
		elseif node.name == "mese:crystal_ore1" then
			growth_stage = 1
		end
		if growth_stage == 4 then
			node.name = "mese:crystal_ore3"
			minetest.swap_node(pos, node)
		elseif growth_stage == 3 then
			node.name = "mese:crystal_ore2"
			minetest.swap_node(pos, node)
		elseif growth_stage == 2 then
			node.name = "mese:crystal_ore1"
			minetest.swap_node(pos, node)
		end -- TODO Take last stage.
		if growth_stage > 1 then
			itemstack:add_wear(65535 / 100)
			local player_inv = user:get_inventory()
			local stack = ItemStack("mese:crystal")
			if player_inv:room_for_item("main", stack) then
				player_inv:add_item("main", stack)
			end
			return itemstack
		end
	end,
})

minetest.register_craft({
	output = "tools:crystalline_bell",
	recipe = {
		{"diamond:diamond"},
		{"glass:glass"},
		{"group:stick"},
	}
})

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

-- Diamond
minetest.register_tool("tools:shovel_diamond", {
	description = "Diamond Shovel",
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1}
})

minetest.register_tool("tools:pick_diamond", {
	description = "Diamond Pickaxe",
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_tool("tools:sword_diamond", {
	description = "Diamond Sword",
	inventory_image = "default_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_tool("tools:axe_diamond", {
	description = "Diamond Axe",
	inventory_image = "default_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_craft({
	output = "tools:sword_diamond",
	recipe = {
		{"diamond:diamond"},
		{"diamond:diamond"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "tools:axe_diamond",
	recipe = {
		{"diamond:diamond", "diamond:diamond"},
		{"diamond:diamond", "group:stick"},
		{"", "group:stick"},
	}
})

minetest.register_craft({
	output = "tools:shovel_diamond",
	recipe = {
		{"diamond:diamond"},
		{"group:stick"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "tools:pick_diamond",
	recipe = {
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

print("loaded tools")

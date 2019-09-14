minetest.register_craftitem("mese:crystal", {
	description = "Mese Crystal",
	inventory_image = "mese_crystal.png",
})

local sounds = {
	footstep = {name = "mese_footstep", gain = 0.3},
	dig = {name = "mese_footstep", gain = 1.0},
	dug = {name = "mese_footstep", gain = 1.0},
}

minetest.register_alias("mese:node", "mese:mese")
minetest.register_node("mese:mese", {
	description = "Mese",
	tiles = {"mese_mese.png"},
	paramtype = "light",
	groups = {cracky = 2, level = 2},
	sounds = music.sounds.nodes.mese,
	light_source = minetest.LIGHT_MAX,
})

minetest.register_craft({
	output = "mese:mese",
	recipe = {
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "mese:crystal 9",
	recipe = {"mese:mese"}
})

-- Mese Crystals by RealBadAngel
minetest.register_node("mese:crystal_ore1", {
	description = "Mese Crystal Ore",
	mesh = "mese_crystal_ore1.obj",
	tiles = {"mese_crystal_texture.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	drop = "mese:crystal 1",
	use_texture_alpha = true,
	sounds = music.sounds.material.glass,
	light_source = 7,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	walkable = false,
	damage_per_second = 2,
})

minetest.register_node("mese:crystal_ore2", {
	description = "Mese Crystal Ore",
	mesh = "mese_crystal_ore2.obj",
	tiles = {"mese_crystal_texture.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	drop = "mese:crystal 2",
	use_texture_alpha = true,
	sounds = music.sounds.material.glass,
	light_source = 8,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	walkable = false,
	damage_per_second = 2,
})

minetest.register_node("mese:crystal_ore3", {
	description = "Mese Crystal Ore",
	mesh = "mese_crystal_ore3.obj",
	tiles = {"mese_crystal_texture.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	drop = "mese:crystal 3",
	use_texture_alpha = true,
	sounds = music.sounds.material.glass,
	light_source = 9,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	walkable = false,
	damage_per_second = 2,
})

minetest.register_node("mese:crystal_ore4", {
	description = "Mese Crystal Ore",
	mesh = "mese_crystal_ore4.obj",
	tiles = {"mese_crystal_texture.png"},
	paramtype = "light",
	drawtype = "mesh",
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	drop = "mese:crystal 4",
	use_texture_alpha = true,
	sounds = music.sounds.material.glass,
	light_source = 10,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	walkable = false,
	damage_per_second = 2,
})

minetest.register_craftitem("mese:crystal_seed", {
	description = "Mese Crystal Seed",
	inventory_image = "mese_crystal_seed.png",
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		if node.name == "obsidian:obsidian" then
			local pos1 = pointed_thing.above
			local node1 = minetest.get_node(pos1)
			if node1.name == "air" then 
				node.name = "mese:crystal_ore1"
				local name = user:get_player_name()
				if minetest.is_protected(pos, name) then
					minetest.record_protection_violation(pos, name)
					return itemstack
				end
				itemstack:take_item()
				minetest.add_node(pos1, node)
				music.play("glass_hard", {gain = 0.5})
				return itemstack
			end
		end
	end,
})

local function check_lava (pos)
	local name = minetest.get_node(pos).name
	if name == "lava:source" or name == "lava:flowing" then 
		return 1
	else
		return 0
	end
end

local function grow_mese_crystal_ore(pos, node)
	local pos1 = {x = pos.x, y = pos.y, z = pos.z}
	pos1.y = pos1.y - 1
	local name = minetest.get_node(pos1).name
	if name ~= "obsidian:obsidian" then
		return
	end

	local lava_count = 0
	pos1.z = pos.z - 1
	lava_count = lava_count + check_lava(pos1)
	pos1.z = pos.z + 1
	lava_count = lava_count + check_lava(pos1)
	pos1.z = pos.z
	pos1.x = pos.x - 1
	lava_count = lava_count + check_lava(pos1)
	pos1.x = pos.x + 1
	lava_count = lava_count + check_lava(pos1)
	if lava_count < 2 then
		return
	end

	if node.name == "mese:crystal_ore3" then
		node.name = "mese:crystal_ore4"
		minetest.swap_node(pos, node)
	elseif node.name == "mese:crystal_ore2" then
		node.name = "mese:crystal_ore3"
		minetest.swap_node(pos, node)
	elseif node.name == "mese:crystal_ore1" then
		node.name = "mese:crystal_ore2"
		minetest.swap_node(pos, node)
	end
end

minetest.register_abm({
	nodenames = {"mese:crystal_ore1", "mese:crystal_ore2",
			"mese:crystal_ore3"},
	neighbors = {"obsidian:obsidian", "lava:source"},
	interval = 80,
	chance = 20,
	action = function(...)
		grow_mese_crystal_ore(...)
	end
})

minetest.register_abm({
	nodenames = {"obsidian:obsidian"},
	neighbors = {"water:source"},
	interval = 80,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y + 1
		local nn = minetest.get_node(pos).name
		if nn ~= "air" then
			return
		end

		local pos1 = {x = pos.x, y = pos.y - 1, z = pos.z}
		local lava_count = 0
		pos1.z = pos.z - 1
		lava_count = lava_count + check_lava(pos1)
		pos1.z = pos.z + 1
		lava_count = lava_count + check_lava(pos1)
		pos1.z = pos.z
		pos1.x = pos.x - 1
		lava_count = lava_count + check_lava(pos1)
		pos1.x = pos.x + 1
		lava_count = lava_count + check_lava(pos1)
		if lava_count < 2 then
			return
		end

		minetest.set_node(pos, {name = "mese:crystal_ore1"})
	end,
})

minetest.register_craftitem("mese:crystal_fragment", {
	description = "Mese Crystal Fragment",
	inventory_image = "mese_crystal_fragment.png",
	on_use = function(itemstack, user, pointed_thing)
		local hp = user:get_hp()
		if hp < user:get_properties().hp_max then
			user:set_hp(user:get_hp() + 3)
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craft({
	type = "shapeless",
	output = "mese:crystal_fragment 9",
	recipe = {"mese:crystal"},
})

minetest.register_craft({
	output = "mese:crystal",
	recipe = {
		{"mese:crystal_fragment", "mese:crystal_fragment", "mese:crystal_fragment"},
		{"mese:crystal_fragment", "mese:crystal_fragment", "mese:crystal_fragment"},
		{"mese:crystal_fragment", "mese:crystal_fragment", "mese:crystal_fragment"},
	},
})

minetest.register_craft({
	output = "mese:crystal_seed 3",
	recipe = {
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"mese:crystal", "obsidian:shard", "mese:crystal"},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
	}
})

minetest.register_node("mese:lamp", {
	description = "Mese Lamp",
	drawtype = "glasslike",
	tiles = {"default_meselamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	--sounds = default.node_sound_glass_defaults(),
	light_source = minetest.LIGHT_MAX,
})

minetest.register_node("mese:post_light", {
	description = "Mese Post Light",
	tiles = {"default_mese_post_light_top.png", "default_mese_post_light_top.png",
		"default_mese_post_light_side_dark.png", "default_mese_post_light_side_dark.png",
		"default_mese_post_light_side.png", "default_mese_post_light_side.png"},
	wield_image = "default_mese_post_light_side.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-2 / 16, -8 / 16, -2 / 16, 2 / 16, 8 / 16, 2 / 16},
		},
	},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = music.sounds.nodes.wood,
})

minetest.register_craft({
	output = "mese:lamp",
	recipe = {
		{"glass:glass"},
		{"mese:crystal"},
	}
})

minetest.register_craft({
	output = "mese:post_light 3",
	recipe = {
		{"", "glass:glass", ""},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"", "group:wood", ""},
	}
})

print("loaded mese")

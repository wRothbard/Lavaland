minetest.register_craftitem("mese:crystal", {
	description = "Mese Crystal",
	inventory_image = "mese_crystal.png",
})

local sounds = {
	footstep = {name = "mese_footstep", gain = 0.3},
	dig = {name = "mese_footstep", gain = 1.0},
	dug = {name = "mese_footstep", gain = 1.0},
}

minetest.register_node("mese:node", {
	description = "Mese",
	tiles = {"mese.png"},
	paramtype = "light",
	groups = {cracky = 2, level = 2},
	sounds = sounds,
	light_source = minetest.LIGHT_MAX,
})

minetest.register_craft({
	output = "mese:node",
	recipe = {
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
		{"mese:crystal", "mese:crystal", "mese:crystal"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "mese:crystal 9",
	recipe = {"mese:node"}
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
	sounds = sounds,
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
	sounds = sounds,
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
	sounds = sounds,
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
	sounds = sounds,
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
				itemstack:take_item()
				node.name = "mese:crystal_ore1"
				minetest.place_node(pos1, node)
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
		local l = minetest.find_node_near(pos, 1, "lava:source")
		if l then
			minetest.set_node(pos, {name = "mese:crystal_ore1"})
		end
	end,
})

minetest.register_craftitem("mese:crystal_fragment", {
	description = "Mese Crystal Fragment",
	inventory_image = "mese_crystal_fragment.png",
	on_use = minetest.item_eat(3),
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
	output = "mese:crystal_seed",
	recipe = {
		{'mese:crystal','mese:crystal','mese:crystal'},
		{'mese:crystal','obsidian:shard','mese:crystal'},
		{'mese:crystal','mese:crystal','mese:crystal'},
	}
})

print("mese loaded")

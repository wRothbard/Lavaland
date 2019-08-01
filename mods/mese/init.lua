minetest.register_craftitem("mese:crystal", {
	description = "Mese Crystal",
	inventory_image = "mese_crystal.png",
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
	--sounds = default.node_sound_stone_defaults(),
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
	--sounds = default.node_sound_stone_defaults(),
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
	--sounds = default.node_sound_stone_defaults(),
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
	--sounds = default.node_sound_stone_defaults(),
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
		if node.name == "obsidian:node" then
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
	if name ~= "obsidian:node" then
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
	neighbors = {"obsidian:node", "lava:source"},
	interval = 80,
	chance = 20,
	action = function(...)
		grow_mese_crystal_ore(...)
	end
})

minetest.register_abm({
	nodenames = {"obsidian:node"},
	neighbors = {"water:source"},
	interval = 80,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y + 1
		local nn = minetest.get_node(pos).name
		local a = minetest.find_node_near(pos, 1, {"lava:source", "air"})
		if nn == "air" and a then
			minetest.set_node(pos, {name = "mese:crystal_ore1"})
		end
	end,
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

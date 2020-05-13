trees = {}
local random = math.random

minetest.register_craftitem("trees:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	groups = {stick = 1, flammable = 2},
})

minetest.register_craft({
	output = "trees:stick 4",
	recipe = {
		{"group:wood"},
	}
})

function trees.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end

local function is_snow_nearby(pos)
	return minetest.find_node_near(pos, 1, {"group:snowy"})
end

function trees.grow_sapling(pos)
	if not trees.can_grow(pos) then
		-- try again 5 min later
		minetest.get_node_timer(pos):start(300)
		return
	end
	local node = minetest.get_node(pos)
	if node.name == "trees:sapling" then
		trees.grow_new_apple_tree(pos)
	elseif node.name == "trees:aspen_sapling" then
		trees.grow_new_aspen_tree(pos)
	end
end

minetest.register_lbm({
	name = "trees:convert_saplings_to_node_timer",
	nodenames = {"trees:sapling", "trees:aspen_sapling"},
	action = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end
})

function trees.grow_new_apple_tree(pos)
	local path = minetest.get_modpath("trees") ..
			"/schematics/apple_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 3, y = pos.y - 1, z = pos.z - 3},
			path, "random", nil, false)
end

function trees.grow_new_aspen_tree(pos)
	local path = minetest.get_modpath("trees") ..
		"/schematics/aspen_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "0", nil, false)
end

minetest.register_alias("default:tree", "trees:tree")
minetest.register_node("trees:tree", {
	description = "Apple Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = music.sounds.nodes.wood,
	on_place = minetest.rotate_node,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("placed", "true")
	end,
	after_dig_node = map.fell_tree
})

minetest.register_alias("default:aspen_tree", "trees:aspen_tree")
minetest.register_node("trees:aspen_tree", {
	description = "Aspen Tree",
	tiles = {"default_aspen_tree_top.png", "default_aspen_tree_top.png",
		"default_aspen_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = music.sounds.nodes.wood,
	on_place = minetest.rotate_node,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("placed", "true")
	end,
	after_dig_node = map.fell_tree
})

minetest.register_node("trees:wood", {
	description = "Apple Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = music.sounds.nodes.wood,
})

minetest.register_node("trees:aspen_wood", {
	description = "Aspen Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_aspen_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = music.sounds.nodes.wood,
})

minetest.register_alias("default:apple", "trees:apple")
minetest.register_node("trees:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1},
	on_use = minetest.item_eat(2),
	sounds = music.sounds.nodes.wood,
	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "trees:apple", param2 = 1})
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if oldnode.param2 == 0 then
			minetest.set_node(pos, {name = "trees:apple_mark"})
			minetest.get_node_timer(pos):start(random(300, 1500))
		end
	end,
})

minetest.register_alias("default:apple_mark", "trees:apple_mark")
minetest.register_node("trees:apple_mark", {
	description = "Apple Marker",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	on_timer = function(pos, elapsed)
		if not minetest.find_node_near(pos, 1, "trees:leaves") then
			minetest.remove_node(pos)
		elseif minetest.get_node_light(pos) < 11 then
			minetest.get_node_timer(pos):start(200)
		else
			minetest.set_node(pos, {name = "trees:apple"})
		end
	end
})

function trees.sapling_on_place(itemstack, placer, pointed_thing,
		sapling_name, minp_relative, maxp_relative, interval)
	-- Position of sapling
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local pdef = node and minetest.registered_nodes[node.name]

	if pdef and pdef.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
		return pdef.on_rightclick(pos, node, placer, itemstack, pointed_thing)
	end

	if not pdef or not pdef.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		pdef = node and minetest.registered_nodes[node.name]
		if not pdef or not pdef.buildable_to then
			return itemstack
		end
	end

	local player_name = placer and placer:get_player_name() or ""
	-- Check sapling position for protection
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return itemstack
	end
	-- Check tree volume for protection
	if minetest.is_area_protected(
			vector.add(pos, minp_relative),
			vector.add(pos, maxp_relative),
			player_name,
			interval) then
		minetest.record_protection_violation(pos, player_name)
		-- Print extra information to explain
		minetest.chat_send_player(player_name,
			itemstack:get_definition().description .. " will intersect protection " ..
			"on growth")
		return itemstack
	end

	minetest.log("action", player_name .. " places node "
			.. sapling_name .. " at " .. minetest.pos_to_string(pos))

	local newnode = {name = sapling_name}
	local ndef = minetest.registered_nodes[sapling_name]
	minetest.set_node(pos, newnode)

	itemstack:take_item()

	return itemstack
end

minetest.register_node("trees:sapling", {
	description = "Apple Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = trees.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = music.sounds.nodes.leaves,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = trees.sapling_on_place(itemstack, placer, pointed_thing,
			"trees:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

minetest.register_node("trees:aspen_sapling", {
	description = "Aspen Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_aspen_sapling.png"},
	inventory_image = "default_aspen_sapling.png",
	wield_image = "default_aspen_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = trees.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = music.sounds.nodes.leaves,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = trees.sapling_on_place(itemstack, placer, pointed_thing,
			"trees:aspen_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 12, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

-- Leafdecay
--

-- Prevent decay of placed leaves

local after_place_leaves = function(pos, placer, itemstack, pointed_thing)
	if placer and placer:is_player() and not placer:get_player_control().sneak then
		local node = minetest.get_node(pos)
		node.param2 = 1
		minetest.set_node(pos, node)
	end
end

-- Leafdecay
local function leafdecay_after_destruct(pos, oldnode, def)
	for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, def.radius),
			vector.add(pos, def.radius), def.leaves)) do
		local node = minetest.get_node(v)
		local timer = minetest.get_node_timer(v)
		if node.param2 ~= 1 and not timer:is_started() then
			timer:start(random(20, 120) / 10)
		end
	end
end

local function leafdecay_on_timer(pos, def)
	if minetest.find_node_near(pos, def.radius, def.trunks) then
		return false
	end

	local node = minetest.get_node(pos)
	local drops = minetest.get_node_drops(node.name)
	for _, item in ipairs(drops) do
		local is_leaf
		for _, v in pairs(def.leaves) do
			if v == item then
				is_leaf = true
			end
		end
		if minetest.get_item_group(item, "leafdecay_drop") ~= 0 or
				not is_leaf then
			minetest.add_item({
				x = pos.x - 0.5 + random(),
				y = pos.y - 0.5 + random(),
				z = pos.z - 0.5 + random(),
			}, item)
		end
	end

	minetest.remove_node(pos)
	minetest.check_for_falling(pos)
end

local function register_leafdecay(def)
	assert(def.leaves)
	assert(def.trunks)
	assert(def.radius)
	for _, v in pairs(def.trunks) do
		minetest.override_item(v, {
			after_destruct = function(pos, oldnode)
				leafdecay_after_destruct(pos, oldnode, def)
			end,
		})
	end
	for _, v in pairs(def.leaves) do
		minetest.override_item(v, {
			on_timer = function(pos)
				leafdecay_on_timer(pos, def)
			end,
		})
	end
end

minetest.register_alias("default:leaves", "trees:leaves")
minetest.register_node("trees:leaves", {
	description = "Apple Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {"trees:sapling"},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {"trees:leaves"},
			}
		}
	},
	sounds = music.sounds.nodes.leaves,
	after_place_node = after_place_leaves,
})

minetest.register_alias("default:aspen_leaves", "trees:aspen_leaves")
minetest.register_node("trees:aspen_leaves", {
	description = "Aspen Tree Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_aspen_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"trees:aspen_sapling"}, rarity = 20},
			{items = {"trees:aspen_leaves"}}
		}
	},
	sounds = music.sounds.nodes.leaves,
	after_place_node = after_place_leaves,
})

local grasses = {"grass:grass_1", "grass:grass_2", "grass:grass_3",
		"grass:grass_4", "grass:grass_5"}

minetest.register_abm({
	nodenames = grasses,
	neighbors = {"group:soil"},
	interval = 60.0,
	chance = 3,
	catch_up = false,
	action = function(pos)
		if not minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name:match("dirt") then
			return
		end
		local p1 = {x = pos.x + 2, y = pos.y, z = pos.z + 2}
		local p2 = {x = pos.x - 2, y = pos.y, z = pos.z - 2}
		local g = minetest.find_nodes_in_area(p1, p2, grasses)
		if #g >= 20 then
			if minetest.find_node_near(pos, 9, {"trees:sapling", "trees:tree"}) then
				return
			end
			minetest.place_node(pos, {name = "trees:sapling"})
		end
	end,
})

minetest.register_abm({
	nodenames = {"dirt:dirt", "dirt:grass"},
	neighbors = {"air"},
	interval = 30,
	chance = 10,
	catch_up = false,
	action = function(pos, node)
		pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		local un = minetest.get_node(pos)
		if un and un.name then
			if un.name ~= "air" and un.name ~= "mobs:spawner" and 
					minetest.registered_nodes[un.name] and
					not minetest.registered_nodes[un.name].buildable_to then
				return
			end
		else
			return
		end
		local o = minetest.get_objects_inside_radius(pos, 1)
		for i = 1, #o do
			local object = o[i]
			local entity = object:get_luaentity()
			if not (entity and entity.age) or entity.dropped_by or
					not (entity.itemstring and
					entity.itemstring == "trees:sapling") then
				break
			end
			if entity.age > 3 then
				local p = object:get_pos()
				object:remove()
				minetest.set_node(p, {name = "trees:sapling"})
				return
			end
		end
	end,
})

minetest.register_craft({
	output = "trees:wood 4",
	recipe = {
		{"trees:tree"},
	}
})

minetest.register_craft({
	output = "trees:aspen_wood 4",
	recipe = {
		{"trees:aspen_tree"},
	}
})

register_leafdecay({
	trunks = {"trees:tree"},
	leaves = {"trees:apple", "trees:leaves"},
	radius = 3,
})

register_leafdecay({
	trunks = {"trees:aspen_tree"},
	leaves = {"trees:aspen_leaves"},
	radius = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "grass:junglegrass",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 1,
})

print("loaded trees")

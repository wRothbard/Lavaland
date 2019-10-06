local random = math.random

local get_inv = function(pos)
	local t = {"bones:bone", "bones:bone", "bones:skull"}
	local inv = minetest.get_meta(pos):get_inventory()
	local list = inv:get_list("main")
	if list then
		for _, v in pairs(list) do
			local n = v:get_name()
			if n ~= "" then
				t[#t + 1] = v
			end
		end
	end
	return t
end

local function duengen(pointed_thing)
	local pos = pointed_thing.under
	local n = minetest.get_node_or_nil(pos)

	if not n or not n.name then
		return
	end

	local stage = ""
	if n.name == "trees:sapling" and minetest.get_node_light(pos) > 12 then
		if random(1, 20) < 5 then
			minetest.set_node(pos, {name = "air"})
			trees.grow_new_apple_tree(pos)
		end

	elseif string.find(n.name, "farming:wheat_") ~= nil then
		stage = tonumber(string.sub(n.name, 15))
		if random(1, 7) < stage / 3 then
			minetest.set_node(pos, {name="farming:wheat_8"})
		elseif stage < 7 then
			minetest.set_node(pos, {name="farming:wheat_" .. stage + random(1, 2)})
		end

	elseif string.find(n.name, "farming:cotton_") ~= nil then
		stage = tonumber(string.sub(n.name, 16))
		if random(1, 7) < stage / 3 then
			minetest.set_node(pos, {name="farming:cotton_8"})
		elseif stage < 7 then
			minetest.set_node(pos, {name="farming:cotton_" .. stage + random(1, 2)})
		end
		--[[
		if stage == 1 then
			minetest.set_node(pos, {name="farming:cotton_" .. random(stage, 2)})
		else
			minetest.set_node(pos, {name="farming:cotton"})
		end
		--]]
	--[[
	elseif string.find(n.name, "farming:pumpkin_") ~= nil then
		stage = tonumber(string.sub(n.name, 17))
		if stage == 1 then
			minetest.set_node(pos, {name = "farming:pumpkin_" .. random(stage, 2)})
		else
			minetest.set_node(pos, {name = "farming:pumpkin"})
		end
	elseif n.name == "default:dry_dirt" then
		for i = -2, 3, 1 do
		for j = -3, 2, 1 do
			local p = {x = pos.x + i, y = pos.y, z = pos.z + j}
			local n2 = minetest.get_node_or_nil(p)

			if n2 and n2.name and n2.name == "default:dry_dirt" and minetest.find_node_near(p, 6, {"group:water"}) then
				if random(1, 6) > 3 then
					minetest.set_node(pointed_thing.under, {name = "default:grass"})
				else
					minetest.set_node(p, {name = "default:grass"})
				end
			end
		end
		end
	--]]
	end
end

minetest.register_node("bones:bones", {
	description = "Bones",
	tiles = {
		"bones_top.png^[transform2",
		"bones_bottom.png",
		"bones_side.png",
		"bones_side.png",
		"bones_rear.png",
		"bones_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {bones = 1, dig_immediate = 3},
	sounds = music.sounds.nodes.bones,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
		meta:set_string("formspec", "size[8,9]" ..
				"list[context;main;0,0;8,4]" ..
				"list[current_player;main;0,5;8,4]" ..
				"listring[]")
	end,
	on_dig = function(pos, node, digger)
		inventory.throw_inventory(pos, get_inv(pos))
		minetest.set_node(pos, {name = "air"})
	end,
	on_blast = function(pos)
		local t = get_inv(pos)
		minetest.set_node(pos, {name = "air"})
		return t
	end,
	on_timer = function(pos, elapsed)
		local timer = minetest.get_node_timer(pos)
		timer:set(elapsed, elapsed + 0.1)
		if timer:get_elapsed() > 1667 then
			minetest.dig_node(pos)
		else
			return 
		end
	end,
})

minetest.register_abm({
	nodenames = {"bones:bones"},
	interval = 60,
	chance = 100,
	catch_up = false,
	action = function(pos, node)
		local timer = minetest.get_node_timer(pos)
		if timer and not timer:is_started() then
			timer:start(1.0)
		end
	end,
})

minetest.register_craftitem("bones:meal", {
	description = "Bone Meal",
	inventory_image = "default_bone_meal.png",
	liquids_pointable = false,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" then
			duengen(pointed_thing)
			itemstack:take_item()
			return itemstack
		end
	end
})

minetest.register_craftitem("bones:bone", {
	description = "Bone",
	inventory_image = "bones_bone.png",
})

minetest.register_craftitem("bones:skull", {
	description = "Skull",
	inventory_image = "bones_skull.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "bones:bones",
	recipe = {"bones:bone", "bones:skull"},
})

minetest.register_craft({
	output = "bones:meal 9",
	type = "shapeless",
	recipe = {"bones:bone"},
})

minetest.register_craft({
	output = "bones:meal 9",
	type = "shapeless",
	recipe = {"bones:skull"},
})

print("loaded bones")

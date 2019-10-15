local rand = math.random

minetest.register_node("water:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = music.sounds.nodes.glass,
})

minetest.register_node("water:packed_ice", {
	description = "Packed Ice",
	tiles = {"water_packed_ice.png"},
	paramtype = "light",
	groups = {cracky = 1, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = music.sounds.nodes.glass,
})

minetest.register_craft({
	type = "shapeless",
	output = "water:ice 2",
	recipe = {"bucket:bucket_water", "water:ice"},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})

minetest.register_craft({
	output = "water:packed_ice",
	recipe = {
		{"water:ice", "water:ice"},
		{"water:ice", "water:ice"}
	}
})

minetest.register_node("water:source", {
	description = "Water Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 191,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "water:flowing",
	liquid_alternative_source = "water:source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = music.sounds.nodes.water,
})

minetest.register_node("water:flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"water_water.png"},
	special_tiles = {
		{
			name = "water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 191,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "water:flowing",
	liquid_alternative_source = "water:source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
			cools_lava = 1},
	sounds = music.sounds.nodes.water,
})

minetest.register_abm({
	label = "Cobble generator",
	nodenames = {"water:flowing", "water:source"},
	neighbors = {"stone:stone", "obsidian:obsidian",
			"group:stone", "group:soil"},
	interval = 30,
	chance = 10,
	catch_up = false,
	action = function(pos, node)
		local dist = 1
		local r = rand()
		if r > 0.5 and r < 0.9 then
			dist = 2
		elseif r >= 0.9 then
			dist = 3
		end
		local p1 = {x = pos.x + dist, y = pos.y + dist, z = pos.z + dist}
		local p2 = {x = pos.x - dist, y = pos.y - dist, z = pos.z - dist}
		local a = minetest.find_nodes_in_area(p1, p2,
				{"stone:stone", "obsidian:obsidian"})
		for i = 1, #a do
			if rand() < 0.5 then
				break
			end
			local an = a[i]
			local n = minetest.get_node(an)
			local ann = n.name
			local m = minetest.get_meta(an)
			local d = m:get_int("d")
			if ann == "stone:stone" then
				if d > rand(5) * 5 then
					minetest.swap_node(an, {name = "stone:cobble"})
					break
				end
				d = d + rand(2) * 5
			elseif ann == "obsidian:obsidian" then
				if d > rand(6) * 6 then
					minetest.swap_node(an, {name = "stone:stone"})
					break
				end
				d = d + rand(2) * 3
			end
			m:set_int("d", d)
		end
	end,
})

minetest.register_abm({
	label = "Ice spread",
	nodenames = "water:ice",
	neighbors = "water:source",
	interval = 300,
	chance = 34,
	catch_up = false,
	action = function(pos, node)
		local p1 = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}
		local p2 = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}
		local water = minetest.find_nodes_in_area(p1, p2, {"water:source"})
		minetest.swap_node(water[rand(#water)], {name = "water:ice"})
	end,
})

minetest.register_abm({
	label = "Moss growth",
	nodenames = {"stone:cobble"},
	neighbors = {"group:water", "group:lava"},
	interval = 12,
	chance = 80,
	catch_up = false,
	action = function(pos, node)
		local la = minetest.find_node_near(pos, 1, "group:lava")
		if la then
			minetest.set_node(pos, {name = "stone:stone"})
		else
			minetest.set_node(pos, {name = "stone:mossycobble"})
		end
	end
})

minetest.register_abm({
	label = "Water drop",
	nodenames = {"water:source"},
	neighbors = {"water:flowing", "air"},
	interval = 3,
	chance = 4,
	catch_up = false,
	action = function(pos, node)
		local pb = {x = pos.x, y = pos.y - 1, z = pos.z}
		local nb = minetest.get_node(pb)
		if not nb.name then
			return
		end
		if nb.name == "water:flowing" or nb.name == "air" then
			minetest.remove_node(pos)
			minetest.set_node(pb, {name = "water:source"})
		end
	end,
})

local minerals = {
	{name = "stone:stone_with_emerald", chance = 75},
	{name = "stone:stone_with_diamond", chance = 60},
	{name = "stone:stone_with_gold", chance = 40},
	{name = "stone:stone_with_coal", chance = 25},
	{name = "stone:stone_with_copper", chance = 20},
	{name = "stone:stone_with_iron", chance = 15},
}

local cool_lava = function(pos, node)
	if node.name == "lava:source" then
		minetest.set_node(pos, {name = "obsidian:obsidian"})
	else -- Lava flowing
		local n = minerals[rand(#minerals)]
		if rand() < 0.334 and rand(100) > n.chance then
			n = n.name
		else
			n = "stone:stone"
		end
		minetest.set_node(pos, {name = n})
	end
	pos.y = pos.y - 2
	minetest.sound_play("water_cool_lava",
			{pos = pos, max_hear_distance = 16, gain = 0.15})
end

minetest.register_abm({
	label = "Lava source cooling",
	nodenames = {"lava:source"},
	neighbors = {"group:cools_lava", "group:water"},
	interval = 4,
	chance = 2,
	catch_up = false,
	action = function(...)
		cool_lava(...)
	end,
})

minetest.register_abm({
	label = "Lava flowing cooling",
	nodenames = {"lava:flowing"},
	neighbors = {"group:cools_lava", "group:water"},
	interval = 3,
	chance = 2,
	catch_up = false,
	action = function(...)
		cool_lava(...)
	end,
})

print("loaded water")

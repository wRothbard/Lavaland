local rand = math.random

minetest.register_node("water:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = music.sounds.nodes.glass,
})

minetest.register_abm({
	nodenames = "water:ice",
	neighbors = "group:water",
	interval = 60,
	chance = 3,
	catch_up = false,
	action = function(pos, node)
		local p1 = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}
		local p2 = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}
		local water = minetest.find_nodes_in_area(p1, p2, {"group:water"})
		if #water > 4 then
			minetest.set_node(water[rand(#water)], {name = "water:ice"})
		end
	end,
})

minetest.register_craft({
	type = "shapeless",
	output = "water:ice 2",
	recipe = {"bucket:bucket_water", "water:ice"},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
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
	alpha = 160,
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
	alpha = 160,
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

local minerals = {
	"stone:stone_with_iron",
	"stone:stone_with_coal",
	"stone:stone_with_copper",
	"stone:stone_with_gold",
	"stone:stone_with_diamond",
}

local cool_lava = function(pos, node)
	if node.name == "lava:source" then
		minetest.set_node(pos, {name = "obsidian:obsidian"})
	else -- Lava flowing
		local n = "stone:stone"
		if rand() < 0.15 then
			n = minerals[rand(#minerals)]
		end
		minetest.set_node(pos, {name = n})
	end
	pos.y = pos.y - 2
	minetest.sound_play("water_cool_lava",
			{pos = pos, max_hear_distance = 16, gain = 0.15})
end

minetest.register_abm({
	label = "Lava cooling",
	nodenames = {"lava:source", "lava:flowing"},
	neighbors = {"group:cools_lava", "group:water"},
	interval = 2,
	chance = 2,
	catch_up = false,
	action = function(...)
		cool_lava(...)
	end,
})

print("loaded water")

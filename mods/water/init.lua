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
	--sounds = default.node_sound_water_defaults(),
})

minetest.register_node("water:flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"water.png"},
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
	--sounds = default.node_sound_water_defaults(),
})

local cool_lava = function(pos, node)
	if node.name == "lava:source" then
		minetest.set_node(pos, {name = "obsidian:node"})
	else -- Lava flowing
		minetest.set_node(pos, {name = "stone:stone"})
	end
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
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

print("water loaded")

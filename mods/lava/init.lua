minetest.register_abm({
	nodenames = {"lava:source"},
	neighbors = {"lava:flowing", "air"},
	interval = 3,
	chance = 2,
	catch_up = false,
	action = function(pos, node)
		local pb = {x = pos.x, y = pos.y - 1, z = pos.z}
		local nb = minetest.get_node(pb)
		if not nb.name then
			return
		end
		if nb.name == "lava:flowing" or nb.name == "air" then
			minetest.remove_node(pos)
			minetest.set_node(pb, {name = "lava:source"})
		end
	end,
})

minetest.register_node("lava:source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "lava:flowing",
	liquid_alternative_source = "lava:source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1},
})

minetest.register_node("lava:flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"lava.png"},
	special_tiles = {
		{
			name = "lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = minetest.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "lava:flowing",
	liquid_alternative_source = "lava:source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1,
		not_in_creative_inventory = 1},
})

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 360,
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

minetest.register_craft({
	type = "fuel",
	recipe = "lava:source",
	burntime = 360,
})

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
	if action == "put" and inventory_info.stack:get_name() == "lava:source" then
		player:set_hp(0)
		minetest.set_node(player:get_pos(), {name = "lava:source"})
	end
end)

print("loaded lava")

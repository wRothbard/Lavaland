local rand = math.random

minetest.register_node("grass:grass_1", {
	description = "Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_grass_1.png"},
	-- Use texture of a taller grass stage in inventory
	inventory_image = "default_grass_3.png",
	wield_image = "default_grass_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1,
			grass = 1, flammable = 1, trade_value = 2},
	floodable = true,
	sounds = music.sounds.nodes.leaves,
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("grass:grass_" .. rand(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("grass:grass_1 " ..
				itemstack:get_count() - (1 - ret:get_count()))
	end,
	on_flood = function(pos, oldnode, newnode)
		local name = oldnode.name
		local drops = minetest.get_node_drops(name)
		for i = 1, #drops do
			minetest.add_item(pos, drops[i])
		end
	end,
})

for i = 2, 5 do
	minetest.register_node("grass:grass_" .. i, {
		description = "Grass",
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_grass_" .. i .. ".png"},
		inventory_image = "default_grass_" .. i .. ".png",
		wield_image = "default_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drop = "grass:grass_1",
		groups = {snappy = 3, flora = 1, attached_node = 1,
				not_in_creative_inventory = 1, grass = 1,
				flammable = 1, trade_value = 2},
		floodable = true,
		sounds = music.sounds.nodes.leaves,
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -3 / 16, 6 / 16},
		},
		on_flood = function(pos, oldnode, newnode)
			local name = oldnode.name
			local drops = minetest.get_node_drops(name)
			for i = 1, #drops do
				minetest.add_item(pos, drops[i])
			end
		end,
	})
end

minetest.register_node("grass:dry_shrub", {
	description = "Dry Shrub",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	wield_image = "default_dry_shrub.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 4,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {flora = 1, snappy = 3, flammable = 3, attached_node = 1, trade_value = 2},
	sounds = music.sounds.nodes.leaves,
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "trees:stick 2",
	recipe = {"grass:dry_shrub"},
})

minetest.register_node("grass:jungle", {
	description = "Jungle Grass",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.69,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, trade_value = 2},
	sounds = music.sounds.nodes.grass,
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
	on_flood = function(pos, oldnode, newnode)
		local name = oldnode.name
		local drops = minetest.get_node_drops(name)
		for i = 1, #drops do
			minetest.add_item(pos, drops[i])
		end
	end,
})

local fsnn = {
	"farming:cotton_6",
	"farming:wheat_6",
	"farming:carrot_5",
	"grass:jungle",
	"grass:dry_shrub",
	"flowers:rose",
	"flowers:tulip",
	"flowers:dandelion_yellow",
	"flowers:chrysanthemum_green",
	"flowers:geranium",
	"flowers:viola",
	"flowers:dandelion_white",
	"flowers:tulip_black",
	"flowers:mushroom_red",
	"flowers:mushroom_brown",
	"grass:grass_1",
	"grass:grass_2",
	"grass:grass_3",
	"grass:grass_4",
	"grass:grass_5",
}

minetest.register_abm({
	label = "Flora spread",
	nodenames = {"dirt:grass"},
	neighbors = fsnn,
	chance = 50,
	interval = 150,
	catch_up = false,
	action = function(pos, node)
		pos.y = pos.y + 1
		local p1 = {x = pos.x + 1, y = pos.y, z = pos.z + 1}
		local p2 = {x = pos.x - 1, y = pos.y, z = pos.z - 1}
		local a, b = minetest.find_nodes_in_area(p1, p2, fsnn)
		if #a >= 8 then
			minetest.set_node(pos, {name = fsnn[rand(#fsnn)]})
		end
	end,
})

minetest.register_abm({
	label = "Grass atop mossycobble",
	nodenames = {"stone:mossycobble"},
	neighbors = {"air"},
	chance = 5,
	interval = 60,
	catch_up = false,
	action = function(pos, node)
		pos.y = pos.y + 1
		local node = minetest.get_node(pos)
		if node and node.name and node.name == "air" then
			minetest.set_node(pos, {name = "grass:grass_" .. rand(5)})
		end
	end,
})

minetest.register_abm({
	label = "Grass spread",
	nodenames = {"dirt:dirt"},
	neighbors = {"air", "group:grass"},
	interval = 6,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		-- Check for darkness: night, shadow or under a light-blocking node
		-- Returns if ignore above
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 13 then
			return
		end

		-- Look for spreading dirt-type neighbours
		local p2 = minetest.find_node_near(pos, 1, "group:spreading_dirt_type")
		if p2 then
			local n3 = minetest.get_node(p2)
			minetest.set_node(pos, {name = n3.name})
			return
		end

		-- Else, any seeding nodes on top?
		local name = minetest.get_node(above).name
		-- Snow check is cheapest, so comes first
		if minetest.get_item_group(name, "grass") ~= 0 then
			minetest.set_node(pos, {name = "dirt:grass"})
		end
	end
})

minetest.register_abm({
	label = "Grass covered",
	nodenames = {"group:spreading_dirt_type"},
	interval = 8,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "dirt:dirt"})
		end
	end
})

print("loaded grass")

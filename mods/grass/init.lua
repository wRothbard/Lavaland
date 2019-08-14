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
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1},
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
			not_in_creative_inventory = 1, grass = 1, flammable = 1},
		sounds = music.sounds.nodes.leaves,
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -3 / 16, 6 / 16},
		},
	})
end

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
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
	sounds = music.sounds.nodes.grass,
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
})

local sn = {
	"grass:jungle",
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
}

minetest.register_abm({
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

local node_names = {"grass:grass_1", "grass:grass_2", "grass:grass_3",
		"grass:grass_4", "grass:grass_5"}

minetest.register_abm({
	nodenames = {"dirt:grass"},
	neighbors = node_names,
	chance = 30,
	interval = 90,
	catch_up = false,
	action = function(pos, node)
		pos.y = pos.y + 1
		local p1 = {x = pos.x + 1, y = pos.y, z = pos.z + 1}
		local p2 = {x = pos.x - 1, y = pos.y, z = pos.z - 1}
		local a, b = minetest.find_nodes_in_area(p1, p2, node_names)
		if #a >= 8 then
			minetest.set_node(pos, {name = sn[rand(#sn)]})
		end
	end,
})

print("loaded grass")

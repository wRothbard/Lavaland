minetest.register_alias("default:stone", "stone:stone")

minetest.register_node("stone:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"stone_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = "coal:lump",
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:stone", {
	description = "Stone",
	tiles = {"stone_stone.png"},
	groups = {cracky = 3, stone = 1, oddly_breakable_by_hand = 1},
	drop = "stone:cobble",
	legacy_mineral = true,
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"stone_stone.png^stone_mineral_copper.png"},
	groups = {cracky = 2},
	drop = "copper:lump",
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"stone_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2, oddly_breakable_by_hand = 1},
	drop = "gold:lump",
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"stone_stone.png^stone_mineral_iron.png"},
	groups = {cracky = 2, oddly_breakable_by_hand = 1},
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 5,
				items = {"stone:cobble"}
			},
{
				rarity = 3,
				items = {"stone:cobble", "steel:iron_lump 2"}
			},
			{
				items = {"stone:cobble", "steel:iron_lump"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:cobble", {
	description = "Cobblestone",
	tiles = {"stone_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2, oddly_breakable_by_hand = 2},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	type = "cooking",
	output = "steel:ingot",
	recipe = "steel:iron_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "stone:stone",
	recipe = "stone:cobble",
})

minetest.register_node("stone:brick", {
	description = "Stone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	output = "stone:brick 4",
	recipe = {
		{"stone:stone", "stone:stone"},
		{"stone:stone", "stone:stone"},
	}
})

minetest.register_node("stone:block", {
	description = "Stone Block",
	tiles = {"stone_block.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	output = "stone:block 9",
	recipe = {
		{"stone:stone", "stone:stone", "stone:stone"},
		{"stone:stone", "stone:stone", "stone:stone"},
		{"stone:stone", "stone:stone", "stone:stone"},
	}
})

minetest.register_node("stone:mossycobble", {
	description = "Mossy Cobblestone",
	tiles = {"stone_mossycobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1, oddly_breakable_by_hand = 2},
	sounds = music.sounds.nodes.stone, 
})

minetest.register_abm({
	label = "Moss growth",
	nodenames = {"stone:cobble"},
	neighbors = {"group:water", "group:lava"},
	interval = 9,
	chance = 75,
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
print("loaded stone")

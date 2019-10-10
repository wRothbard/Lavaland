minetest.register_alias("default:stone", "stone:stone")

local xp_add = function(pos, oldnode, oldmetadata, digger)
	local lvl = stats.update_stats(digger, {level = ""})
	stats.add_xp(digger, (10 * ((0.1 * lvl.level) + 1)), true)
end

minetest.register_node("stone:coalstone_tile", {
	description = "Coal Stone Tile",
	tiles = {"stone_coalstone_tile.png"},
	groups = {cracky = 1, trade_value = 5},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	output = "stone:coalstone_tile 4",
	recipe = {
		{"coal:block", "stone:stone"},
		{"stone:stone", "coal:block"}
	}
})

minetest.register_node("stone:rune", {
	description = "Stone Rune",
	tiles = {"stone_rune.png"},
	groups = {cracky = 2, stone = 1, oddly_breakable_by_hand = 1},
	sounds = music.sounds.nodes.stone,
})

minetest.register_craft({
	output = "stone:rune 4",
	recipe = {
		{"stone:stone", "stone:stone", "stone:stone"},
		{"stone:stone", "", "stone:stone"},
		{"stone:stone", "stone:stone", "stone:stone"},
	},
})

minetest.register_node("stone:stone", {
	description = "Stone",
	tiles = {"stone_stone.png"},
	groups = {cracky = 3, stone = 1, oddly_breakable_by_hand = 1},
	drop = "stone:cobble",
	legacy_mineral = true,
	sounds = music.sounds.nodes.stone,
})

minetest.register_node("stone:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"stone_stone.png^default_mineral_coal.png"},
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
				items = {"stone:cobble", "coal:lump 2"}
			},
			{
				items = {"stone:cobble", "coal:lump"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
	after_dig_node = xp_add,
})

minetest.register_node("stone:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"stone_stone.png^stone_mineral_copper.png"},
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
				items = {"stone:cobble", "copper:lump 2"}
			},
			{
				items = {"stone:cobble", "copper:lump"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
	after_dig_node = xp_add,
})

minetest.register_node("stone:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"stone_stone.png^default_mineral_gold.png"},
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
				items = {"stone:cobble", "gold:lump 2"}
			},
			{
				items = {"stone:cobble", "gold:lump"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
	after_dig_node = xp_add,
})

minetest.register_node("stone:stone_with_diamond", {
	description = "Diamond Ore",
	tiles = {"stone_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1},
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 5,
				items = {"stone:cobble"}
			},
			{
				rarity = 3,
				items = {"stone:cobble", "diamond:diamond 2"}
			},
			{
				items = {"stone:cobble", "diamond:diamond"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
	after_dig_node = xp_add,
})

minetest.register_node("stone:stone_with_emerald", {
	description = "Emerald Ore",
	tiles = {"stone_stone.png^stone_mineral_emerald.png"},
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
				items = {"stone:cobble", "emerald:emerald 2"}
			},
			{
				items = {"stone:cobble", "emerald:emerald"}
			},
		}
	},
	sounds = music.sounds.nodes.stone,
	after_dig_node = xp_add,
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
	after_dig_node = xp_add,
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

print("loaded stone")

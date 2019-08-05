minetest.register_alias("default:stone", "stone:stone")

minetest.register_node("stone:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1, oddly_breakable_by_hand = 1},
	--drop = 'default:cobble',
	legacy_mineral = true,
	sounds = {
		footstep = {name = "stone_hard_footstep", gain = 0.3},
		dug = {name = "stone_hard_footstep", gain = 1.0},
	},
})

minetest.register_node("stone:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2, oddly_breakable_by_hand = 1},
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 2,
				items = {"stone:stone", "stone:iron_lump 2"}
			},
			{
				items = {"stone:stone", "stone:iron_lump"}
			},
		}
	},
})

minetest.register_craftitem("stone:iron_lump", {
	description = "Iron Lump",
	inventory_image = "default_iron_lump.png"
})

minetest.register_craft({
	type = "cooking",
	output = "steel:ingot",
	recipe = "stone:iron_lump",
})

print("stone loaded")

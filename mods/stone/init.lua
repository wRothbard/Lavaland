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

print("stone loaded")

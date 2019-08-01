minetest.register_node("bones:bones", {
	description = "Bones",
	tiles = {
		"bones_top.png^[transform2",
		"bones_bottom.png",
		"bones_side.png",
		"bones_side.png",
		"bones_rear.png",
		"bones_front.png"
	},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand = 2},
	drop = {
		max_items = 2,
		items = {
			{rarity = 2, items = {"bones:bone"}},
			{rarity = 3, items = {"bones:skull"}},
			{rarity = 1, items = {"bones:bones"}},
		},
	},
	--sounds = default.node_sound_gravel_defaults(),
})

minetest.register_craftitem("bones:bone", {
	description = "Bone",
	inventory_image = "bones_bone.png",
})

minetest.register_craftitem("bones:skull", {
	description = "Skull",
	inventory_image = "bones_skull.png",
})

print("bones loaded")

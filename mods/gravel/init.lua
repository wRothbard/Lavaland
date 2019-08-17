minetest.register_node("gravel:gravel", {
	description = "Gravel",
	tiles = {"gravel_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	--sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"gravel:flint"}, rarity = 16},
			{items = {"gravel:gravel"}}
		}
	}
})

minetest.register_craftitem("gravel:flint", {
	description = "Flint",
	inventory_image = "gravel_flint.png"
})

minetest.register_craft({
	type = "shapeless",
	output = "gravel:gravel 2",
	recipe = {"stone:cobble"},
})

print("loaded gravel")

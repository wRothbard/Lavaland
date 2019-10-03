minetest.register_node("gold:block", {
	description = "Gold Block",
	tiles = {"default_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = music.sounds.material.metal,
})

minetest.register_craftitem("gold:ingot", {
	description = "Gold Ingot",
	inventory_image = "default_gold_ingot.png"
})

minetest.register_craftitem("gold:lump", {
	description = "Gold Lump",
	inventory_image = "default_gold_lump.png"
})

minetest.register_craft({
	type = "cooking",
	output = "gold:ingot",
	recipe = "gold:lump",
})

minetest.register_craft({
	output = "gold:block",
	recipe = {
		{"gold:ingot", "gold:ingot", "gold:ingot"},
		{"gold:ingot", "gold:ingot", "gold:ingot"},
		{"gold:ingot", "gold:ingot", "gold:ingot"},
	}
})

minetest.register_craft({
	output = "gold:ingot 9",
	recipe = {
		{"gold:block"},
	}
})

minetest.register_alias("shop:coin", "gold:coin")
minetest.register_craftitem("gold:coin", {
	description = "Gold Coin",
	inventory_image = "shop_coin.png",
})

minetest.register_craft({
	output = "gold:coin 9",
	recipe = {
		{"gold:ingot"},
	}
})

minetest.register_craft({
	output = "gold:ingot",
	recipe = {
		{"gold:coin", "gold:coin", "gold:coin"},
		{"gold:coin", "gold:coin", "gold:coin"},
		{"gold:coin", "gold:coin", "gold:coin"}
	}
})

print("loaded gold")

minetest.register_craftitem("diamond:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png",
})

minetest.register_node("diamond:block", {
	description = "Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3, trade_value = 15,},
	sounds = music.sounds.material.metal,
})

minetest.register_craft({
	output = "diamond:block",
	recipe = {
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
		{"diamond:diamond", "diamond:diamond", "diamond:diamond"},
	}
})

minetest.register_craft({
	output = "diamond:diamond 9",
	recipe = {
		{"diamond:block"},
	}
})

minetest.register_craftitem("diamond:fragment", {
	description = "Diamond Fragment",
	inventory_image = "diamond_fragment.png",
})

minetest.register_craft({
        output = "diamond:fragment 9",
        recipe = {
                {"diamond:diamond"},
        }
})

minetest.register_craft({
        output = "diamond:diamond",
        recipe = {
                {"diamond:fragment", "diamond:fragment", "diamond:fragment"},
                {"diamond:fragment", "diamond:fragment", "diamond:fragment"},
                {"diamond:fragment", "diamond:fragment", "diamond:fragment"}
        }
})

minetest.register_craftitem("diamond:coin", {
	description = "Diamond Coin",
	inventory_image = "diamond_coin.png",
})

minetest.register_craft({
        output = "diamond:coin 9",
        recipe = {
                {"diamond:fragment"},
        }
})

minetest.register_craft({
        output = "diamond:fragment",
        recipe = {
                {"diamond:coin", "diamond:coin", "diamond:coin"},
                {"diamond:coin", "diamond:coin", "diamond:coin"},
                {"diamond:coin", "diamond:coin", "diamond:coin"}
        }
})

print("loaded diamond")

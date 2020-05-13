minetest.register_craftitem("emerald:emerald", {
	description = "Emerald",
	inventory_image = "emerald_emerald.png",
	groups = {trade_value = 30},
})

minetest.register_node("emerald:block", {
	description = "Emerald Block",
	tiles = {"emerald_block.png"},
	groups = {cracky = 2},
	sounds = music.sounds.material.metal,
})

minetest.register_craft({
	output = "emerald:emerald 9",
	recipe = {{"emerald:block"}}
})

minetest.register_craft({
	output = "emerald:block",
	recipe = {
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"},
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"},
		{"emerald:emerald", "emerald:emerald", "emerald:emerald"}
	}
})

minetest.register_craftitem("emerald:fragment", {
	description = "Emerald Fragment",
	inventory_image = "emerald_fragment.png",
})

minetest.register_craft({
        output = "emerald:fragment 9",
        recipe = {
                {"emerald:emerald"},
        }
})

minetest.register_craft({
        output = "emerald:emerald",
        recipe = {
                {"emerald:fragment", "emerald:fragment", "emerald:fragment"},
                {"emerald:fragment", "emerald:fragment", "emerald:fragment"},
                {"emerald:fragment", "emerald:fragment", "emerald:fragment"}
        }
})

minetest.register_craftitem("emerald:coin", {
	description = "Emerald Coin",
	inventory_image = "emerald_coin.png",
})

minetest.register_craft({
        output = "emerald:coin 9",
        recipe = {
                {"emerald:fragment"},
        }
})

minetest.register_craft({
        output = "emerald:fragment",
        recipe = {
                {"emerald:coin", "emerald:coin", "emerald:coin"},
                {"emerald:coin", "emerald:coin", "emerald:coin"},
                {"emerald:coin", "emerald:coin", "emerald:coin"}
        }
})

print("loaded emerald")

minetest.register_alias("stone:coal_lump", "coal:lump")
minetest.register_craftitem("coal:lump", {
	description = "Coal Lump",
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1, flammable = 1}
})

minetest.register_alias("stone:coalblock", "coal:block")
minetest.register_node("coal:block", {
	description = "Coal Block",
	tiles = {"default_coal_block.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = music.sounds.nodes.stone,
	after_destruct = function(pos, oldnode)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name == "fire:permanent_flame" then
			minetest.remove_node(pos)
		end
	end,
	on_ignite = function(pos, igniter)
		local flame_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(flame_pos).name == "air" then
			minetest.set_node(flame_pos, {name = "fire:permanent_flame"})
		end
	end,
})

minetest.register_craft({
	output = "coal:block",
	recipe = {
		{"coal:lump", "coal:lump", "coal:lump"},
		{"coal:lump", "coal:lump", "coal:lump"},
		{"coal:lump", "coal:lump", "coal:lump"},
	}
})

minetest.register_craft({
	output = "coal:lump 9",
	recipe = {
		{"coal:block"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "coal:lump",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "coal:block",
	burntime = 370,
})

print("loaded coal")

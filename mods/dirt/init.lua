local sounds = {
	dirt = {},
	grass = {},
}
sounds.grass = sounds.dirt
sounds.grass.footstep = {}

minetest.register_node("dirt:dirt", {
	description = "Dirt",
	tiles = {"dirt_dirt.png"},
	groups = {crumbly = 3, soil = 1, oddly_breakable_by_hand = 3},
	sounds = sounds.dirt,
})

minetest.register_node("dirt:grass", {
	description = "Dirt with Grass",
	tiles = {"dirt_grass.png", "dirt_dirt.png",
		{name = "dirt_dirt.png^dirt_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, oddly_breakable_by_hand = 3},
	drop = "dirt:dirt",
	sounds = sounds.grass,
})

minetest.register_abm({
	nodenames = {"stone:mossycobble"},
	neighbors = {
		"grass:grass_4",
		"grass:grass_5"
	},
	interval = 30,
	chance = 3,
	catch_up = false,
	action = function(pos, node)
		local grass = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if grass and grass.name:match("grass") then
			minetest.set_node(pos, {name = "dirt:dirt"})
		end
	end,
})

minetest.register_abm({
	nodenames = {"dirt:dirt"},
	neighbors = {
		"grass:grass_4",
		"grass:grass_5",
	},
	interval = 30,
	chance = 3,
	catch_up = false,
	action = function(pos, node)
		local grass = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if grass and grass.name:match("grass") then
			minetest.set_node(pos, {name = "dirt:grass"})
		end
	end,
})

print("dirt loaded")

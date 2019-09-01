-- mobs/nodes.lua is part of Glitchtest
-- Copyright 2018 James Stevenson
-- GNU GPL 3

minetest.register_node("mobs:spawner", {
	description = "I spawn things!",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
	drop = "",
	air_equivalent = true,
	paramtype = "light",
	inventory_image = "air.png",
	floodable = true,
	pointable = false,
	sunlight_propagates = true,
	walkable = false,
	diggable = false,
	buildable_to = true,
	wield_image = "air.png",
	on_blast = function()
	end,
	on_timer = mobs.on_timer,
	--[[
		floor, 9 walkable
		area, 18 air
	--]]
})

minetest.register_abm({
	label = "Spawner Limiter",
	nodenames = {"mobs:spawner"},
	--neighbors = {},
	interval = 12,
	chance = 1,
	catch_up = false,
	action = mobs.abm_action,
})

--minetest.register_lbm()
--minetest.register_on_mapgen()

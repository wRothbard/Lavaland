-- mobs/players.lua is part of Glitchtest
-- Glitchtest is Copyright 2018, 2019 James Stevenson
-- Released under a GNU GPL 3 license

local undercrowd = mobs.undercrowd
local stepper = 0
--[[
local log = function(entry)
	minetest.log("action", entry)
end
--]]

minetest.register_on_mods_loaded(function()
	for node, def in pairs(minetest.registered_nodes) do
		if def.walkable then
			local g = def.groups
			g.reliable = 1
			minetest.override_item(node, {
				groups = g,
			})
		end
	end
end)

minetest.register_globalstep(function(dtime)
	if stepper < 12 then
		stepper = stepper + dtime
		return
	else
		stepper = 0
	end

	local players = minetest.get_connected_players()
	for i = 1, #players do
		local player = players[i]
		if player == "" then
			break
		end

		local pos = player:get_pos()
		if not pos then
			break
		end

		if undercrowd(pos, 32) > 3 then
			--log("globalstep: Undercrowd is greater than three in a 32 radius area, breaking.")
			break
		end

		if minetest.find_node_near(pos, 8, "mobs:spawner") then
			--log("globalstep: Found nearby spawner, breaking.")
			break
		end

		local node = minetest.get_node_or_nil(pos)
		if not node then
			break
		end

		local node_name = node.name
		if node_name ~= "air" then
			pos.y = pos.y + 1
		end

		node = minetest.get_node_or_nil(pos)
		if not node then
			break
		end

		node_name = node.name
		if node_name ~= "air" then
			--log("globalstep: No air found for spawner insertion, breaking.")
			break
		end

		local added = minetest.add_node(pos, {name = "mobs:spawner"})
		if not added then
			break
		--else
			--log("globalstep: Added spawner.")
		end

		minetest.get_node_timer(pos):start(0)
	end
end)

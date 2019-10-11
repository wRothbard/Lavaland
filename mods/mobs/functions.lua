-- mobs/functions.lua is part of Glitchtest
-- Glitchtest is Copyright 2018, 2019 James Stevenson
-- Released under a GNU GPL 3 license

local debug = false
local delay = minetest.settings:get("dedicated_server_step")
local stepper = 0
local random = math.random

local function log(message, name)
	if not debug then
		return
	end
	local o = minetest.get_connected_players()
	for i = 1, #o do
		local p = o[i]
		local n = p:get_player_name()
		if minetest.check_player_privs(n, "server") then
			name = name or n
			break
		end
	end
	if name then
		minetest.chat_send_player(name, message)
	end
	print(message)
end

local erase = function(pos)
	log("erase: start")
	local node = minetest.get_node_or_nil(pos)
	if not node then
		return
	end

	local node_name = node.name
	if not node_name then
		return
	end

	if node_name == "mobs:spawner" then
		minetest.set_node(pos, {name = "air"})
		log("erase: erased spawner")
	end
end

local limiter = function(pos, radius, limit, immediate_surrounding, surrounding)
	log("limiter: start")
	radius = radius or 6.67
	limit = limit or radius * 3
	immediate_surrounding = immediate_surrounding or
			minetest.get_objects_inside_radius(pos, radius)

	if #immediate_surrounding > 6 then
		log("limiter: found > 6 in immediate_surrounding, returning true")
		return true
	end

	local surrounding = surrounding or
			minetest.get_objects_inside_radius(pos, radius * 3)

	if #surrounding > 18 then
		local h = 0
		for i = 1, #surrounding do
			local s = surrounding[i]
			local sl = s:get_luaentity()
			if sl and sl.health then
				h = h + 1
			end
			if s:is_player() then
				h = h + 4
			end
		end
		if h > limit then
			return true
		end
	end
end

local spawner_limiter = function(pos, node, active_object_count, active_object_count_wider)
	log("spawner_limiter: start")
	local timer = minetest.get_node_timer(pos)
	if not timer:is_started() or timer:get_elapsed() > 12 or
			limiter(pos) then
		erase(pos)
		log("spawner_limiter: erase() called due to missing or expired timer, or limiter() returning true")
	end
end

local check_for_player = function(pos, radius)
	log("check_for_player: start")
	radius = radius or 32
	local objects_in_radius = minetest.get_objects_inside_radius(pos, radius)
	for i = 1, #objects_in_radius do
		local object = objects_in_radius[i]
		local player = object:is_player()
		if player then
			return true
		end
	end
	return
end

local redo = function(pos, radius)
	log("redo: start")
	radius = radius or 1

	local p1 = {
		x = pos.x - radius,
		y = pos.y - radius,
		z = pos.z - radius,
	}

	local p2 = {
		x = pos.x + radius,
		y = pos.y + radius,
		z = pos.z + radius,
	}

	local n = minetest.find_node_near(pos, radius, "mobs:spawner")
	if n then
		local t = minetest.get_node_timer(n)
		if not t:is_started() then
			t:start(0)
		end
	end

	local a = minetest.find_nodes_in_area_under_air(p1, p2, "group:reliable")
	if a and a[1] then
		local an = a[random(#a)]
		local np = {
			x = an.x,
			y = an.y + 1,
			z = an.z,
		}
		log("redo: added spawner")
		minetest.set_node(np, {name = "mobs:spawner"})
	end
end

on_timer = function(pos, elapsed)
	log("on_timer: start")
	local timer = minetest.get_node_timer(pos)
	if not timer then
		log("on_timer: no timer, returning")
		return
	end

	if elapsed < 12 then
		timer:set(12, elapsed + delay) 
		return
	end

	if check_for_player(pos) then
		log("on_timer: nearby player found, resetting timer")
		timer:start(0)
		return
	end

	if limiter(pos) then
		log("on_timer: limiter is true, returning")
		return
	end

	local node = minetest.get_node_or_nil({
		x = pos.x,
		y = pos.y - 1,
		z = pos.z,
	})

	if node and node.name then
		local node_below = minetest.registered_nodes[node.name]
		if node_below and not node_below.walkable then
			log("on_timer: erasing, no node below!")
			erase(pos)
			return
		end
	end

	local light = minetest.get_node_light(pos)
	log("on_timer: light: " .. tostring(light))

	local mobs = {
		"mobs:rat",
		"mobs:npc",
	}

	local tod = (minetest.get_timeofday() or 0) * 24000
	local night = tod > 19000 or tod < 06000
	local protected = minetest.is_protected(pos, ":mobs")
	if (night or not protected) and light < 10 then
		local mobs_to_insert = {
			"mobs:dungeon_master",
			"mobs:oerkki",
			"mobs:zombie" .. random(4),
		}
		for i = 1, #mobs_to_insert do
			mobs[#mobs + 1] = mobs_to_insert[i]
		end
	end
	local mobs_to_insert = {
		"mobs:sheep_white",
		"mobs:kitten",
		"mobs:bunny",
	}
	for i = 1, #mobs_to_insert do
		mobs[#mobs + 1] = mobs_to_insert[i]
	end
	local mob = mobs[random(#mobs)]
	local colbox = minetest.registered_entities[mob].collisionbox
	local spawn_pos = {
		x = pos.x,
		y = pos.y + 1.6,
		z = pos.z,
	}
	local p1 = {
		x = spawn_pos.x + colbox[1],
		y = spawn_pos.y + colbox[2],
		z = spawn_pos.z + colbox[3],
	}
	local p2 = {
		x = spawn_pos.x + colbox[4],
		y = spawn_pos.y + colbox[5],
		z = spawn_pos.z + colbox[6],
	}
	-- Check mob's collisionbox for adequate space to spawn.
	local d = vector.distance(p1, p2)
	local r, s = minetest.find_nodes_in_area(p1, p2, "air", true)
	if s["air"] < d then
		log("on_timer: redoing!")
		return redo(pos)
	end

	minetest.add_entity(spawn_pos, mob)
	log("on_timer: Entity added, erasing.")
	erase(pos)

	log("on_timer: spawned: " .. mob)
end

mobs.undercrowd = function(pos, radius)
	log("mobs.undercrowd: start")
	radius = radius or 8
	local r = minetest.get_objects_inside_radius(pos, radius)
	local t = 0
	for _, v in pairs(r) do
		local s = v:get_luaentity()
		if not s then
			break
		end
		if s.owner ~= "" then
			break
		end
		if s.health > 0 then
			t = t + 1
		end
		if t > 5 then
			v:remove()
		end
	end
	return t
end

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

		if mobs.undercrowd(pos, 32) > 3 then
			log("globalstep: Undercrowd is greater than three in a 32 radius area, breaking")
			break
		end

		if minetest.find_node_near(pos, 8, "mobs:spawner") then
			log("globalstep: Found nearby spawner, breaking")
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
			log("globalstep: No air found for spawner insertion, breaking")
			break
		end

		local added = minetest.add_node(pos, {name = "mobs:spawner"})
		if not added then
			break
		else
			log("globalstep: Added spawner")
		end

		minetest.get_node_timer(pos):start(0)
	end
end)

minetest.register_abm({
	label = "Spawner Limiter",
	nodenames = {"mobs:spawner"},
	--neighbors = {},
	interval = 12,
	chance = 1,
	catch_up = false,
	action = spawner_limiter,
})

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
	on_timer = on_timer,
})

minetest.register_chatcommand("mobs", {
	privs = "server",
	func = function(name, param)
		param = param:split(" ")
		local arg1 = param[1]
		local arg2 = param[2]
		arg2 = arg2 == "off" or arg2 == "disabled" or
				arg2 == "0" or arg2 == "false"
		if arg1 == "debug" then
			if arg2 then
				debug = false
				return true, "Mobs debugging disabled"
			else
				debug = true
				return true, "Mobs debugging enabled"
			end
		end
	end,
})

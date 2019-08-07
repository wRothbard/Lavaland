-- mobs/functions.lua is part of Glitchtest
-- Glitchtest is Copyright 2018, 2019 James Stevenson
-- Released under a GNU GPL 3 license

local delay = minetest.settings:get("dedicated_server_step")

--[[
local log = function(entry)
	minetest.log("action", entry)
end
--]]

local random = math.random
--log("Your lucky number is: " .. random(10) + random(10))

local erase = function(pos)
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
		--log("Erased spawner.")
	end
end

local limiter = function(pos, radius, limit, immediate_surrounding, surrounding)
	radius = radius or 6.67
	limit = limit or radius * 3
	immediate_surrounding = immediate_surrounding or
			minetest.get_objects_inside_radius(pos, radius)

	if #immediate_surrounding > 6 then
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

mobs.abm_action = function(pos, node, active_object_count, active_object_count_wider)
	local timer = minetest.get_node_timer(pos)
	if not timer:is_started() or timer:get_elapsed() > 12 or
			limiter(pos) then
		erase(pos)
		--log("ABM: Spawner limited.")
	end
end

local check_for_player = function(pos, radius)
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
		--log("redo: Added spawner.")
		minetest.set_node(np, {name = "mobs:spawner"})
	end
end

mobs.on_timer = function(pos, elapsed)
	local timer = minetest.get_node_timer(pos)
	if not timer then
		--log("No timer, returning.")
		return
	end

	if elapsed < 12 then
		timer:set(12, elapsed + delay) 
		return
	end

	if check_for_player(pos) then
		--log("on_timer: Nearby player found, resetting timer.")
		timer:start(0)
		return
	end

	if limiter(pos) then
		--log("on_timer: Limiter is true, returning.")
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
			--log("redo: Erasing, no node below!")
			erase(pos)
			return
		end
	end

	local light = minetest.get_node_light(pos)

	local mobs = {
		"mobs:rat",
		"mobs:npc",
	}
	local biome = minetest.get_biome_name(minetest.get_biome_data(pos).biome)
	local tod = (minetest.get_timeofday() or 0) * 24000
	local night = tod > 19000 or tod < 06000
	local protection = minetest.find_node_near(pos, 13,
			{"protector:protect", "protector:protect2"}, true)
	if not protection and (biome == "underground" or night) and
				light < 3 then
		local mobs_to_insert = {
			"mobs:dungeon_master",
			"mobs:oerkki",
			"mobs:zombie" .. random(4),
		}
		for i = 1, #mobs_to_insert do
			mobs[#mobs + 1] = mobs_to_insert[i]
		end
	end
	if biome ~= "underground" then
		local mobs_to_insert = {
			"mobs:sheep_white",
			"mobs:kitten",
			"mobs:bunny",
		}
		for i = 1, #mobs_to_insert do
			mobs[#mobs + 1] = mobs_to_insert[i]
		end
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
		--log("redo: Redoing!")
		return redo(pos)
	end

	minetest.add_entity(spawn_pos, mob)
	--log("on_timer: Entity added, erasing.")
	erase(pos)

	--minetest.chat_send_all("Spawned " .. mob .. "!")
	--log("Spawned " .. mob .. "!")
end

mobs.undercrowd = function(pos, radius)
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

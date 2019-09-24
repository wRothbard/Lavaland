bases = {}

local boom = function(pos)
	tnt.boom(pos, {ignore_protection = true, explode_center = true, radius = 4})
end

local damage = function(pos, res, amt)
	local n = minetest.get_node(pos)
	if not (n and n.name:match("bases:")) then
		return
	end
	amt = amt or 0
	local meta = minetest.get_meta(pos)
	local st = meta:get("integrity")
	if not st then
		st = 5000
	end
	st = st - amt
	if st <= 0 then
		minetest.remove_node(pos)
		minetest.add_item(pos, "bases:base")
	else
		meta:set_int("integrity", st)
	end
	if res then
		return st
	end
end

local cycle = function(pos, name)
	local meta = minetest.get_meta(pos)
	local team = teams.get_team(name)
	local base = meta:get("base")
	if not base or base == "blue" then
		base = "red"
	elseif base == "red" then
		base = "green"
	elseif base == "green" then
		base = "blue"
	end
	minetest.swap_node(pos, {name = "bases:base_" .. base})
	meta:set_string("base", base)
	bases[base] = pos
end

local on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	cycle(pos, clicker:get_player_name())
end

local on_punch = function(pos, node, puncher, pointed_thing)
	boom(pos)
end

local on_timer = function(pos, elapsed)
	if elapsed > 667 then
		minetest.remove_node(pos)
		minetest.add_item(pos, "bases:base")
		boom(pos)
	end
	local wt = minetest.get_node_timer(pos)
	wt:set(0.1, elapsed + 0.1)
end

local on_blast = function(pos)
	damage(pos, nil, 100)
	return
end

local after_place_node = function(pos, placer, itemstack, pointed_thing)
	if not minetest.check_player_privs(placer, "game_master") then
		minetest.remove_node(pos)
	end
end

local check_air = function(pos)
	local n = minetest.get_node(pos)
	return n and (n.name == "air" or
			n.name == "mobs:spawner" or
			n.name == "bases:base_red" or
			n.name == "bases:base_blue" or
			n.name == "bases:base_green")
end

minetest.register_node("bases:base", {
	description = "Base",
	tiles = {"stone_rune.png^(bases_base.png^[opacity:99)"},
	on_rightclick = on_rightclick,
	can_dig = function() end,
	after_place_node = after_place_node,
})

minetest.register_node("bases:base_green", {
	description = "Base Active (Green, You Hacker You!)",
	tiles = {"stone_rune.png^(bases_base_green.png^[opacity:99)"},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	drop = "",
	on_rightclick = on_rightclick,
	on_punch = on_punch,
	can_dig = function() end,
	on_timer = on_timer,
	on_blast = on_blast,
	after_place_node = after_place_node,
})

minetest.register_node("bases:base_red", {
	description = "Base Active (Red, You Hacker You!)",
	tiles = {"stone_rune.png^(bases_base_red.png^[opacity:99)"},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	drop = "",
	on_rightclick = on_rightclick,
	on_punch = on_punch,
	can_dig = function() end,
	on_timer = on_timer,
	on_blast = on_blast,
	after_place_node = after_place_node,
})

minetest.register_node("bases:base_blue", {
	description = "Base Active (Blue, You Hacker You!)",
	tiles = {"stone_rune.png^(bases_base_blue.png^[opacity:99)"},
	groups = {snappy = 1},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	drop = "",
	on_rightclick = on_rightclick,
	on_punch = on_punch,
	can_dig = function() end,
	on_timer = on_timer,
	on_blast = on_blast,
	after_place_node = after_place_node,
})

minetest.register_abm({
	nodenames = {"bases:base_green", "bases:base_red", "bases:base_blue"},
	interval = 2,
	chance = 1,
	catch_up = false,
	action = function(pos, node)
		local t = minetest.get_node_timer(pos)
		if not t:is_started() then
			t:start(0.1)
		end
		for xi = -3, 3 do
			for yi = -3, 3 do
				for zi = -3, 3 do
					if not (xi == 0 and yi == 0 and zi == 0) then
						local np = {x = pos.x + xi, y = pos.y + yi, z = pos.z + zi}
						if not check_air(np) then
							boom(np)
						end
					end
				end
			end
		end
	end,
})

minetest.register_privilege("game_master", "Can administer games.")

print("loaded bases")

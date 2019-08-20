hunger = {}

local players = {}

hunger.status = function(player)
	return math.ceil(players[player:get_player_name()])
end

local function cons(player)
	local name = player:get_player_name()
	local hp = player:get_hp()
	if hp > 0 then
		local sat = players[name]
		if not sat then
			return
		end

		local vel = player:get_player_velocity()
		local x = vel.x ~= 0
		local y = vel.y ~= 0
		local z = vel.z ~= 0
		if sat <= 0 then
			sat = 0
			player:set_hp(player:get_hp() - 4)
		elseif x or y or z then
			sat = sat - 0.05
		else
			sat = sat - 0.01
		end
		players[name] = sat
		hud.update(player, "hunger", "number", sat, {name = "hunger"})

		if sat > 16 and hp < player:get_properties().hp_max then
			player:set_hp(hp + 1)
		end
	else
		players[name] = 0
		hud.update(player, "hunger", "number", 0)
	end
	minetest.after(3, function()
		cons(player)
	end)
end

minetest.register_on_item_eat(function(hp_change, replace_with_item,
		itemstack, user, pointed_thing)
	local name = user:get_player_name()
	local sat = players[name]
	if sat < 20 and hp_change > 0 then
		itemstack:take_item()
		sat = sat + hp_change
		if sat > 20 then
			sat = 20
		end
		players[name] = sat
		local xp_inc = math.ceil(hp_change / 2)
		if xp_inc < 1 then
			xp_inc = 1
		end
		stats.add_xp(user, xp_inc)
	elseif hp_change < 0 then
		players[name] = sat / 2
		itemstack:take_item()
		user:set_hp(user:get_hp() + hp_change)
	end
	hud.update(user, "hunger", "number", nil, {name = "hunger"})
	return itemstack
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local meta = player:get_meta()
	local sat = meta:get_int("satiation")
	if sat == 0 then
		sat = 20
	end
	players[name] = sat
	cons(player)
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	players[name] = 0
	hud.update(player, "hunger", "number", nil, {name = "hunger"})
end)

minetest.register_on_respawnplayer(function(player)
	players[player:get_player_name()] = 20
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player:get_meta():set_int("satiation", players[name])
	players[name] = nil
end)

print("loaded hunger")

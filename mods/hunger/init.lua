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
		if sat <= 1 then
			sat = 1
			player:set_hp(player:get_hp() - 4)
		else
			sat = sat - 0.05
		end
		players[name] = sat
		hud.update(player, "hunger", "number", sat, {name = "hunger"})

		if sat > 16 and hp < player:get_properties().hp_max then
			player:set_hp(hp + 1)
		end
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
	elseif hp_change < 0 then
		itemstack:take_item()
		user:set_hp(user:get_hp() + hp_change)
	end
	hud.update(user, "hunger", "number", nil, {name = "hunger"})
	return itemstack
end)

minetest.register_on_respawnplayer(function(player)
	players[player:get_player_name()] = 20
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

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player:get_meta():set_int("satiation", players[name])
	players[name] = nil
end)

print("loaded hunger")

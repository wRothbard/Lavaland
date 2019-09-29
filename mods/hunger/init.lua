hunger = {}

local function cons(player)
	local name = player:get_player_name()
	local hp = player:get_hp()
	if hp > 0 then
		local sat = stats.update_stats(player, {sat = ""})
		if not sat then
			return
		end

		sat = sat.sat
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
		sat = tostring(sat):sub(1, 4)
		sat = tonumber(sat)
		stats.update_stats(player, {sat = sat})
		hud.update(player, "hunger", "number", sat, {name = "hunger"})

		if sat > 16 and hp < player:get_properties().hp_max and
				player:get_breath() > 0 then
			player:set_hp(hp + 1)
		end
	else
		stats.update_stats(player, {sat = 0})
		hud.update(player, "hunger", "number", 0)
	end
	minetest.after(5, function()
		cons(player)
	end)
end

minetest.register_on_item_eat(function(hp_change, replace_with_item,
		itemstack, user, pointed_thing)
	local name = user:get_player_name()
	local s = stats.update_stats(user, {sat = "", sat_max = ""})
	local sat = s.sat
	local sat_max = s.sat_max
	if sat < sat_max and hp_change > 0 then
		itemstack:take_item()
		sat = sat + hp_change
		if sat > sat_max then
			sat = sat_max
		end
		stats.update_stats(user, {sat = sat})
		local xp_inc = math.ceil(hp_change / 2)
		if xp_inc < 1 then
			xp_inc = 1
		end
		stats.add_xp(user, xp_inc, true)
	elseif hp_change < 0 then
		stats.update_stats(user, {sat = sat / 2})
		itemstack:take_item()
		user:set_hp(user:get_hp() + hp_change)
	end
	hud.update(user, "hunger", "number", nil, {name = "hunger"})
	return itemstack
end)

minetest.register_on_joinplayer(function(player)
	cons(player)
end)

minetest.register_on_dieplayer(function(player)
	stats.update_stats(player, {sat = 0})
	hud.update(player, "hunger", "number", nil, {name = "hunger"})
end)

minetest.register_on_respawnplayer(function(player)
	 stats.update_stats(player, {sat_max = 20, sat = 20})
end)

print("loaded hunger")

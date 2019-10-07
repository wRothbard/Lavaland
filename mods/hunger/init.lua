hunger = {}

local poisoned = {}

local function snd(pos)
	music.play("hunger_eat", {pos = pos, gain = 0.67})
end

local function cons(player)
	local name = player:get_player_name()
	local hp = player:get_hp()
	if hp > 0 then
		local sat = stats.update_stats(player, {sat = "", sat_max = ""})
		if not sat then
			return
		end

		local sat_max = sat.sat_max
		if not sat_max then
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

		if sat > sat_max * 0.75 and hp < player:get_properties().hp_max and
				player:get_breath() > 0 then
			player:set_hp(hp + 1)
		end
	else
		stats.update_stats(player, {sat = 0})
		hud.update(player, "hunger", "number", 0)
	end
	local m = player:get_meta()
	local poison = m:get_int("poison")
	if poison > 0 and poisoned[name] then
		minetest.after(1, function()
			if not minetest.get_player_by_name(name) then
				return
			end
			local h = player:get_hp()
			if h ~= 0 then
				player:set_hp(h / 1.1)
			end
		end)
		poison = poison - 1
		m:set_int("poison", poison)
	else
		m:set_int("poison", 0)
	end
	minetest.after(5, function()
		cons(player)
	end)
end

local function poison(player, amount)
	hud.message(player, "Poison!")
	local name = player:get_player_name()
	poisoned[name] = true
	local m = player:get_meta()
	local a = m:get_int("poison")
	a = a + amount
	m:set_int("poison", a)
end

minetest.register_on_item_eat(function(hp_change, replace_with_item,
		itemstack, user, pointed_thing)
	local name = user:get_player_name()
	local s = stats.update_stats(user, {sat = "", sat_max = ""})
	local sat = s.sat
	local sat_max = s.sat_max

	if sat < sat_max and hp_change > 0 then
		itemstack:take_item()
		snd(user:get_pos())
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
		snd(user:get_pos())
		minetest.after(0.18, function()
			if minetest.get_player_by_name(user:get_player_name()) then
				user:set_hp(user:get_hp() + hp_change)
			end
		end)
	end
	local g = minetest.get_item_group(itemstack:get_name(), "poison")
	if g > 0 then
		poison(user, g)
	end
	hud.update(user, "hunger", "number", nil, {name = "hunger"})
	return itemstack
end)

minetest.register_on_joinplayer(function(player)
	cons(player)
end)

minetest.register_on_dieplayer(function(player)
	poisoned[player:get_player_name()] = nil
	stats.update_stats(player, {sat = 0})
	hud.update(player, "hunger", "number", nil, {name = "hunger"})
end)

minetest.register_on_respawnplayer(function(player)
	stats.update_stats(player, {sat_max = 20, sat = 20})
end)

minetest.register_on_leaveplayer(function(player)
	poisoned[player:get_player_name()] = nil
end)

print("loaded hunger")

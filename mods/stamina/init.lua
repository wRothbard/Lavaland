stamina = {}

local players = {}
local timers = {}

stamina.add_stamina = function(player, amount)
	local name = player:get_player_name()
	local t = timers[name]
	if not t then
		return
	end
	local z = minetest.get_us_time()
	if z - t < 10000 and amount < 0 then
		return
	end
	timers[name] = z
	local s = players[name]
	if not s then
		s = 0
	end
	local stam_max = stats.update_stats(player, {stam_max = ""}).stam_max
	s = s + amount or 0
	if s < 0 then
		s = 0
	elseif s > stam_max then
		s = stam_max
	end
	players[name] = s
end

stamina.get_stamina = function(player)
	local name = player:get_player_name()
	return players[name]
end

minetest.register_on_respawnplayer(function(player)
	players[player:get_player_name()] = 20
end)

minetest.register_on_joinplayer(function(player)
	local stam_max = stats.update_stats(player, {stam_max = ""}).stam_max
	local name = player:get_player_name()
	players[name] = stam_max
	timers[name] = minetest.get_us_time()
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	timers[name] = nil
end)

print("loaded stamina")

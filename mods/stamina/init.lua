stamina = {}

local players = {}

stamina.add_stamina = function(player, amount)
	local name = player:get_player_name()
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
	players[player:get_player_name()] = stam_max
end)

minetest.register_on_leaveplayer(function(player)
	players[player:get_player_name()] = nil
end)

print("loaded stamina")

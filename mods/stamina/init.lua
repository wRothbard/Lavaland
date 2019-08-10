stamina = {}

local players = {}

stamina.add_stamina = function(player, amount)
	local name = player:get_player_name()
	local s = players[name]
	if not s then
		s = 0
	end

	s = s + amount or 0
	if s < 0 then
		s = 0
	elseif s > 20 then
		s = 20
	end
	players[name] = s
end

stamina.get_stamina = function(player)
	local name = player:get_player_name()
	return players[name]
end

minetest.register_on_joinplayer(function(player)
	stamina.add_stamina(player, 1)

end)

print("loaded stamina")
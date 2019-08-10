hud = {}

local players = {}

minetest.hud_replace_builtin("breath", {
	hud_elem_type = "statbar",
	position = {x = 1, y = 0.5},
	text = "bubble.png",
	number = 10,
	direction = 3,
	size = {x = 24, y = 24},
	offset = {x = -48, y = 32},
})

sb_stamina = {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	text = "bubble.png",
	number = 0,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = 25, y = -(48 + 24 + 16)},
}

hud.update = function(player, elem, stat, value)
	local name = player:get_player_name()
	player:hud_change(players[name][elem], stat, value)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {
		stamina = -1,
		armor = -1,
		hunger = -1,
	}

	players[name].stamina = player:hud_add(sb_stamina)
end)

print("loaded hud")

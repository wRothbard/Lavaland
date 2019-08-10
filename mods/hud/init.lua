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
	text = "bubble.png^[colorize:green:100",
	number = 0,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = 25, y = -(48 + 24 + 16)},
}

sb_armor = {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	text = "shields_inv_shield_steel.png",
	number = 20,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = (-10 * 24) - 25, y = -(48 + 48 + 16)},
}

hud.update = function(player, elem, stat, value, modifier)
	local name = player:get_player_name()
	
	local cooldown = modifier and modifier.name == "cooldown"
	local armor = modifier and modifier.name == "armor"

	if cooldown then
		player:hud_change(players[name][elem],
				"text", "bubble.png^[colorize:" ..
				modifier.action .. ":100")
	elseif armor then
		local inv = minetest.get_inventory({type = "detached",
				name = name .. "_armor"})
		local count = 0
		local wear = 0
		for _, list in pairs(inv:get_lists()) do
			for k, item in pairs(list) do
				if not item:is_empty() then
					count = count + 1
					wear = wear + item:get_wear()
				end
			end
		end
		local d = 65535 * count - wear
		local bar = d / (65535 / 2) * 2

		player:hud_change(players[name][elem],
				"number", bar)
	else
		player:hud_change(players[name][elem], stat, value)
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {
		stamina = -1,
		armor = -1,
		hunger = -1,
	}

	players[name].stamina = player:hud_add(sb_stamina)
	players[name].armor = player:hud_add(sb_armor)
end)

print("loaded hud")

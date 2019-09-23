hud = {}

local players = {}
local messages = {}

minetest.hud_replace_builtin("breath", {
	hud_elem_type = "statbar",
	position = {x = 1, y = 0.5},
	text = "bubble.png",
	number = 10,
	direction = 3,
	size = {x = 24, y = 8},
	offset = {x = -48, y = 32},
})

local sb_stamina = {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	text = "hud_sb_stamina_green.png",
	number = 0,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = 25, y = -(48 + 24 + 16)},
}

local sb_armor = {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	text = "hud_sb_armor.png",
	number = 0,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = 25, y = -(48 + 48 + 16)},
}

local sb_hunger = {
	hud_elem_type = "statbar",
	position = {x = 0.5, y = 1},
	text = "hud_sb_hunger.png",
	number = 20,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = (-10 * 24) - 25, y = -(48 + 48 + 16)},
}

local hmsg = {
	hud_elem_type = "text",
	name = "hmsg",
	number = 0xFFFFFF,
	position = {x = 0.02, y = 0.7},
	text = "",
	scale = {x = 100, y = 25},
	alignment = {x = 1, y = -1},
}

hud.update = function(player, elem, stat, value, modifier)
	local name = player:get_player_name()
	if not players[name] then
		return
	end
	
	local cooldown = modifier and modifier.name == "cooldown"
	local armor = modifier and modifier.name == "armor"
	local hungry = modifier and modifier.name == "hunger"
	local stamina = modifier and modifier.name == "stamina"

	if cooldown then
		player:hud_change(players[name][elem],
				"text", "hud_sb_stamina_" .. modifier.action .. ".png")
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
		bar = math.ceil(bar)
		player:hud_change(players[name][elem],
				"number", bar)
	elseif hungry then
		local s = stats.update_stats(player, {sat_max = "", sat = ""})
		local sat = s.sat
		local sat_max = s.sat_max
		local bar = 20 / (sat_max / sat)
		player:hud_change(players[name][elem],
				"number", math.ceil(bar))
	elseif stamina then
		local stam = stamina.get_stamina(player)
		local stam_max = stats.update_stats(player, {stam_max = ""}).stam_max
		local bar = 20 / (stam_max / stam)
		player:hud_change(players[name][elem],
				"number", bar)
	else
		player:hud_change(players[name][elem], stat, value)
	end
end

local gen_string = function(name)
	local output = ""
	for i = 4, 1, -1 do
		local mm = messages[name][i]
		output = output .. "\n" .. mm
	end
	return output
end

local timer = function(player)
	local name = player:get_player_name()
	messages[name][5] = messages[name][5] + 1
	minetest.after(9, function()
		if not minetest.get_player_by_name(name) then
			return
		end
		for i = 4, 1, -1 do
			if messages[name] and messages[name][i] and
					messages[name][i] ~= "" then
				messages[name][i] = ""
				player:hud_change(players[name].messages, "text", gen_string(name))
				messages[name][5] = messages[name][5] - 1
				break
			end
		end
	end)
end

function hud.message(player, message)
	local name
	if type(player) ~= "string" then
		name = player:get_player_name()
	else
		name = player
		player = minetest.get_player_by_name(name)
	end
	local m = messages[name]
	if not m then
		return
	end
	for i = 4, 2, -1 do
		local mm = m[i]
		m[i] = m[i - 1]
	end
	m[1] = message
	player:hud_change(players[name].messages, "text", gen_string(name))
	if messages[name][5] <= 4 then
		timer(player)
	end
end

local waypoint = {
	name = "",
	text = "",
	number = 0xFFFFFF,
	world_pos = {x = 0, y = 0, z = 0},
}

function hud.waypoint(player, det)
	local name = player:get_player_name()
	local w = players[name].waypoints
	if not det then
		for i = 1, #w do
			player:hud_remove(w[i].id)
		end
		return
	end
	local d = waypoint
	d.pos = det.pos or {x = 0, y = 0, z = 0}
	local id = player:hud_add(d)
	players[name].waypoints[#w + 1] = {id = id}
end

minetest.register_chatcommand("hmsg", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Not in-game!"
		end
		hud.message(player, param)
	end,
})

minetest.register_on_player_hpchange(function(player, hp_change)
	if hp_change < 0 then
		hud.update(player, "armor", "number", nil, {name = "armor"})
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {
		stamina = player:hud_add(sb_stamina),
		armor = player:hud_add(sb_armor),
		hunger = player:hud_add(sb_hunger),
		messages = player:hud_add(hmsg),
		waypoints = {}
	}
	messages[name] = {[1] = "", [2] = "", [3] = "", [4] = "", [5] = 1}
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	messages[name] = nil
end)

print("loaded hud")

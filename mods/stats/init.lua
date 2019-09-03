stats = {}

local rand = math.random

local players = {}

local base_stats = {
	hp = 20,
	hp_max = 20,
	breath = 11,
	breath_max = 11,
	stam = 20,
	stam_max = 20,
	sat = 20,
	sat_max = 20,
	xp = 0,
	level = 1,
}

stats.update_stats = function(player, status_table)
	if not status_table then
		return
	end
	if not player then
		return
	end
	local name = player:get_player_name()
	if not players[name] then
		return
	end
	local res = {}
	for s, v in pairs(status_table) do
		if s == "hp_max" then
			if v ~= "" then
				player:set_properties({hp_max = v})
				players[name].hp_max = v
			end
			res.hp_max = player:get_properties().hp_max
		elseif s == "hp" then
			if v ~= "" then
				player:set_hp(v)
			end
			res.hp = player:get_hp()
		elseif s == "breath_max" then
			if v ~= "" then
				player:set_properties({breath_max = v})
				players[name].breath_max = v
			end
			res.breath_max = player:get_properties().breath_max
		elseif s == "breath" then
			res.breath = player:get_breath()
		elseif s == "stam_max" then
			if not players[name].stam_max then
				players[name].stam_max = 20
			end
			if v ~= "" then
				players[name].stam_max = v
			end
			res.stam_max = players[name].stam_max
		elseif s == "stam" then
			res.stam = stamina.get_stamina(player)
		elseif s == "sat_max" then
			if not players[name].sat_max then
				players[name].sat_max = 20
			end
			if v ~= "" then
				players[name].sat_max = v
			end
			res.sat_max = players[name].sat_max
		elseif s == "sat" then
			--[[
			if not players[name].sat then
				players[name].sat = hunger.status(player)
			end
			--]]
			if v ~= "" then
				hunger.status(player, v)
			end
			res.sat = hunger.status(player)
		elseif s == "xp" then
			if v ~= "" then
				players[name].xp = v
			end
			res.xp = players[name].xp
		elseif s == "level" then
			if v ~= "" then
				players[name].level = v
			end
			res.level = players[name].level
		end
	end
	return res
end

stats.add_xp = function(player, amount, notify)
	if not player then
		return
	end
	local name = player:get_player_name()
	if not players[name] then
		return
	end
	---[[
	if player_api.player_attached[name] == true then
		-- TODO FIXME Why do I detach from boats if I add XP?
		return
	end
	--]]
	local x = stats.update_stats(player, {
		xp = "",
		level = "",
		hp = "",
		hp_max = "",
		sat_max = "",
		stam_max = "",
		breath_max = "",
	})
	local lvl = tonumber(x.level)
	local xp = tonumber(x.xp)
	if notify then
		hud.message(player, "+" .. amount .. " XP")
	end
	local ttl = xp + amount
	if ttl >= 100 * lvl then
		-- Level up
		local max = x.hp_max
		if max < 100 then
			max = max + rand(1, 3)
			stats.update_stats(player, {hp_max = max})
			x.hp_max = nil
		end
		local max_sat = x.sat_max
		if max_sat < 100 then
			max_sat = max_sat + rand(1, 3)
			stats.update_stats(player, {sat_max = max_sat})
			x.sat_max = nil
		end
		hunger.status(player, max_sat)
		local max_stam = x.stam_max
		if max_stam < 100 then
			max_stam = max_stam + rand(1, 3)
			stats.update_stats(player, {stam_max = max_stam})
			x.stam_max = nil
		end
		local max_breath = x.breath_max
		if max_breath < 100 then
			max_breath = max_breath + rand(1, 3)
			stats.update_stats(player, {breath_max = max_breath})
			x.breath_max = nil
		end
		x.hp = max
		x.xp = (xp + amount) % (100 * lvl)
		x.level = lvl + 1
		hud.message(player, "Level up!  New level is " ..
				x.level .. ".")
	else
		x.xp = xp + amount
	end
	stats.update_stats(player, x)
end

stats.save = function(player)
	local meta = player:get_meta()
	local name = player:get_player_name()
	if not name then
		return
	end

	meta:set_string("stats", minetest.serialize(players[name]))
end

local function activity_xp_boost(player)
	if minetest.get_player_by_name(player:get_player_name()) and
			player:get_hp() > 0 then
		local vel = player:get_player_velocity()
		local x = vel.x ~= 0
		local y = vel.y ~= 0
		local z = vel.z ~= 0
		local moving = x or y or z
		local amt = 3
		if moving then
			amt = 6 
		end
		stats.add_xp(player, amt)
	end
	minetest.after(12, function()
		activity_xp_boost(player)
	end)
end

function stats.show_status(player)
	local name = player:get_player_name()
	local formspec = "size[8,7.25]" ..
		"real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;help;Help]" ..
		"button[6,0;1,1;more;>]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"label[3,0.25;Status]" ..
		"list[detached:" .. name .. "_clothing;clothing;3,1;4,1]" ..
		"item_image[3,1;1,1;clothing:hat_grey]" ..
		"item_image[4,1;1,1;clothing:shirt_grey]" ..
		"item_image[5,1;1,1;clothing:pants_grey]" ..
		"item_image[6,1;1,1;clothing:cape_grey]" ..
		"list[detached:" .. name .. "_skin;skin;7,1;1,1]" ..
		"image[7,1;1,1;skins_skin_bg.png]" ..
		"list[detached:" .. name .. "_armor;armor;3,2;5,1]" ..
		"item_image[3,2;1,1;3d_armor:helmet_steel]" ..
		"item_image[4,2;1,1;3d_armor:chestplate_steel]" ..
		"item_image[5,2;1,1;3d_armor:leggings_steel]" ..
		"item_image[6,2;1,1;3d_armor:boots_steel]" ..
		"item_image[7,2;1,1;3d_armor:shield_steel]" ..
		"list[current_player;main;0,3.25;8,1;]" ..
		"list[current_player;main;0,4.5;8,3;8]" ..
		forms.get_hotbar_bg(0, 3.25) ..
	""
	minetest.show_formspec(name, "stats:status", formspec)
end

function stats.show_more(player)
	local name = player:get_player_name()
	local x = stats.update_stats(player, {
		hp = "",
		hp_max = "",
		breath = "",
		breath_max = "",
		stam = "",
		stam_max = "",
		sat = "",
		sat_max = "",
		xp = "",
		level = "",
	})
	local str = ""
	for k, v in pairs(x) do
		str = str .. k .. "," .. v .. ","
	end
	str = str:sub(1, -2)
	local formspec = "size[8,7.25]" ..
		"real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;help;Help]" ..
		"button[6,0;1,1;status;<]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"button_exit[0.5,3;2,1;sit;Sit]" ..
		"button_exit[0.5,4;2,1;lay;Lay]" ..
		"label[3,0.25;Status]" ..
		"tablecolumns[text;text,padding=3]" ..
		"table[3,1;4.75,6.2;stats;" .. str .. ";1]" ..
	""
	minetest.show_formspec(name, "stats:more", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if (formname == "" and fields.status) or
			(formname == "help:help" and fields.status) or
			(formname == "stats:more" and fields.status) then
		stats.show_status(player)
	elseif formname == "stats:status" and fields.more then
		stats.show_more(player)
	elseif (formname == "stats:status" or
				formname:match("help:") or
				formname == "stats:more") then
		if fields.spawn then
			player:set_pos(mapgen.spawn)
			minetest.sound_play("mapgen_item", {pos = mapgen.spawn, gain = 0.3})
		elseif fields.home then
			local name = player:get_player_name()
			local pos = mapgen.homes[name]
			if pos then
				player:set_pos(pos)
			else
				minetest.chat_send_player(name, "No home set!")
			end
		elseif fields.sit then
			cozy.sit(player)
		elseif fields.lay then
			cozy.lay(player)
		end
	end
end)

minetest.register_privilege("moderator", "Can moderate.")

minetest.register_on_joinplayer(function(player)
	if not player then
		return
	end

	local name = player:get_player_name()

	local meta = player:get_meta()
	local p_stats = meta:get("stats")
	if p_stats then
		p_stats = minetest.deserialize(p_stats)
	end

	if not p_stats then
		p_stats = base_stats
		meta:set_string("stats", minetest.serialize(p_stats))
	end

	players[name] = p_stats
	p_stats.hp = nil
	stats.update_stats(player, p_stats)

	minetest.after(1, function()
		activity_xp_boost(player)
	end)
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	players[name] = base_stats

	local meta = player:get_meta()
	meta:set_string("stats", minetest.serialize(base_stats))
end)

minetest.register_on_leaveplayer(function(player)
	stats.save(player)
	players[player:get_player_name()] = nil
end)

minetest.register_chatcommand("stats", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if param and param ~= "" then
			local culm = {}
			local split = param:split(" ")
			for i = 1, #split do
				local s = split[i]
				culm[s] = ""
			end

			local res = stats.update_stats(player, culm)
			local str = ""
			for k, v in pairs(res) do
				str = str .. k .. ": " .. v .. ", "
			end
			str = str:sub(1, -3)
			return true, str
		else
			if not player then
				return false, "Invalid usage."
			end
			stats.show_more(player)
		end
	end,
})

minetest.register_chatcommand("save", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "No player."
		end

		stats.save(player)
		return true, "Saved."
	end,
})

local function autosave()
	local c_players = minetest.get_connected_players()
	for i = 1, #c_players do
		local player = c_players[i]
		if not player then
			break
		end

		stats.save(player)
	end
	minetest.after(55, function()
		autosave()
	end)
end

minetest.register_on_shutdown(function()
	autosave()
end)

autosave()

print("loaded stats")

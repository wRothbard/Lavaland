stats = {}

local players = {}

local base_stats = {
	hp = 20,
	hp_max = 20,
	breath = 11,
	breath_max = 11,
	xp = 0,
	level = 1,
}

stats.update_stats = function(player, status_table)
	if not player then
		return
	end
	local res = {}
	for s, v in pairs(status_table) do
		local name = player:get_player_name()
		if s == "hp_max" then
			if v ~= "" then
				player:set_properties({hp_max = v})
			end
			res.hp_max = player:get_properties().hp_max
		elseif s == "hp" then
			if v ~= "" then
				player:set_hp(v)
			end
			res.hp = player:get_hp()
		elseif s == "breath" then
		elseif s == "breath_max" then
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

local function show_status(player)
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

local function show_more(player)
	local name = player:get_player_name()
	local x = stats.update_stats(player, {
		hp = "",
		hp_max = "",
		breath_max = "",
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
		show_status(player)
	elseif formname == "stats:status" and fields.more then
		show_more(player)
	elseif (formname == "stats:status" or
				formname == "help:help" or
				formname == "stats:more") and fields.spawn then
		player:set_pos(mapgen.spawn)
		minetest.sound_play("mapgen_item", {pos = mapgen.spawn, gain = 0.3})
	elseif (formname == "stats:status" or
				formname == "help:help" or
				formname == "stats:more") and fields.home then
		local name = player:get_player_name()
		local pos = mapgen.homes[name]
		if pos then
			player:set_pos(pos)
		else
			minetest.chat_send_player(name, "No home set!")
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
	else
		p_stats = base_stats
		meta:set_string("stats", minetest.serialize(p_stats))
	end

	players[name] = p_stats
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	players[name] = base_stats

	local meta = player:get_meta()
	meta:set_string("stats", minetest.serialize(base_stats))
end)

minetest.register_on_leaveplayer(function(player)
	local meta = player:get_meta()
	local name = player:get_player_name()
	meta:set_string("stats", minetest.serialize(players[name]))
	players[name] = nil
end)

minetest.register_chatcommand("stats", {
	func = function(name, param)
		local culm = {}
		local split = param:split(" ")
		for i = 1, #split do
			local s = split[i]
			culm[s] = ""
		end

		local res = stats.update_stats(minetest.get_player_by_name(name), culm)
		local str = ""
		for k, v in pairs(res) do
			str = str .. k .. ": " .. v .. ", "
		end
		str = str:sub(1, -3)
		return true, str
	end,
})

print("loaded stats")

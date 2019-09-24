local players = {}
local tolc = {}

local function manage(name, param)
	if not param or param == "" then
		param = name
	end
	local player = minetest.get_player_by_name(param)
	if not player then
		return false, "Not a player!"
	end
	local inv = minetest.get_inventory({type = "player",
			name = param})
	local tbl = "Yellow," .. inv:get_stack("flags", 1):get_count() .. "," ..
			"Red," .. inv:get_stack("flags", 2):get_count() .. "," ..
			"DOB," .. players[name].dob .. "]"
	local fs = "size[8,8]" ..
		"real_coordinates[true]" ..
		--forms.title_bar(0, -1, 8, 1) ..
		"field[0,0;7,1;search;;]" ..
		"field_close_on_enter[search;false]" ..
		"button[7,0;1,1;ok;OK]" ..
		"tablecolumns[text;text,align=right,padding=2]" ..
		"table[0,1;8,7;flags;" .. tbl .. "]" ..
	""
	minetest.show_formspec(name, "flags:manage", fs)
end

local function judge(player, flag)
	local inv = player:get_inventory()
	if flag == "yellow" then
		local s = inv:get_stack("flags", 1)
		if s:get_name() == "flags:yellow" then
			s = s:get_count()
		else
			s = ItemStack("flags:yellow")
		end
		if type(s) == "number" and s > 0 then
			s = ItemStack("flags:yellow " .. s + 1)
		end
		inv:set_stack("flags", 1, s)
		if inv:get_stack("flags", 1):get_count() > 8 then
			inv:set_stack("flags", 1, "")
			judge(player, "red")
		end
		manage(player:get_player_name())
	elseif flag == "red" then
		local s = inv:get_stack("flags", 2)
		if s:get_name() == "flags:red" then
			s = s:get_count()
		else
			s = ItemStack("flags:red")
		end
		if type(s) == "number" and s > 0 then
			s = ItemStack("flags:red " .. s + 1)
		end
		inv:set_stack("flags", 2, s)
		if inv:get_stack("flags", 2):get_count() > 2 then
			inv:set_stack("flags", 2, "")
			minetest.kick_player(player:get_player_name(),
					"Suspended.")
		else
			manage(player:get_player_name())
		end
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "flags:manage" then
		return
	end
	if fields.search and fields.search ~= "" then
		if minetest.check_player_privs(player, "judge") then
			manage(player:get_player_name(), fields.search)
		end
	end
end)

minetest.register_craftitem("flags:red", {
	description = "Red Flag",
	inventory_image = "default_paper.png^[colorize:red",
})

minetest.register_craftitem("flags:yellow", {
	description = "Yellow Flag",
	inventory_image = "default_paper.png^[colorize:yellow",
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local meta = player:get_meta()
	local flags = meta:get("flags")
	if flags then
		flags = minetest.deserialize(flags)
		if not flags.dob then
			flags.dob = os.date("%Y%m%d")
		end
		players[name] = flags
	else
		players[name] = {
			dob = os.date("%Y%m%d")
		}
	end
	local inv = player:get_inventory()
	inv:set_size("flags", 2)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	tolc[name] = nil
end)

minetest.register_chatcommand("manage", {
	privs = "judge",
	func = function(name, param)
		manage(name, param)
	end,
})

minetest.register_privilege("judge", "Can administer games.")

minetest.register_chatcommand("flag", {
	privs = "judge",
	func = function(name, param)
		param = param:split(" ")
		local target = minetest.get_player_by_name(param[1])
		if not target then
			return false, "Not a target!"
		end
		local flag = param[2]
		judge(target, flag)
	end,
})

minetest.register_on_cheat(function(player, cheat)
	if not player:is_player() then
		return
	end
	if cheat.type == "interacted_while_dead" then
		local name = player:get_player_name()
		local now = minetest.get_us_time()
		local lc = tolc[name] or now
		tolc[name] = now
		local t = (tolc[name] - lc) * 0.000001
		if t > 0 and t < 1 then
			player:set_hp(1)
			player:set_hp(0)
			minetest.chat_send_player(name, "Something went wrong in the life/death cycle.")
			tolc[name] = nil
			judge(player, "yellow")
		end
	end
end)

minetest.register_on_protection_violation(function(pos, name)
	local player = minetest.get_player_by_name(name)
	local now = minetest.get_us_time()
	local lc = tolc[name] or now
	tolc[name] = now
	local t = (tolc[name] - lc) * 0.000001
	if t > 0 and t < 2.5 then
		player:set_hp(player:get_hp() - 1)
		minetest.chat_send_player(name, "Yellow flag.")
		tolc[name] = nil
		judge(player, "yellow")
	end
end)

print("loaded flags")

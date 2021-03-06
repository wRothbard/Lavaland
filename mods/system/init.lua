minetest.register_chatcommand("who", {
	description = "Print your username",
	params = "",
	privs = "shout",
	func = function(name, param)
		return true, name
	end,
})

minetest.register_chatcommand("w", {
	description = "Show current item",
	params = "[dump]",
	privs = "interact",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Not in-game!"
		end
		local w = player:get_wielded_item()
		if param == "dump" and
				minetest.check_player_privs(name, "server") then
			print(dump(w:to_table()))
		end
		minetest.chat_send_player(name, w:to_string())
	end,
})

minetest.register_chatcommand("registered", {
	description = "Print registered stuff",
	params = "[stuff]",
	privs = "server",
	func = function(name, param)
		if param == "entities" then
			print(dump(minetest.registered_entities))
		elseif param == "object_refs" then
			print(dump(minetest.object_refs))
		elseif param == "luaentities" then
			print(dump(minetest.luaentities))
		end
	end,
})

minetest.register_chatcommand("is_protected", {
	description = "Display protection for position",
	params = "",
	privs = "interact",
	func = function(name, param)
		local p = minetest.get_player_by_name(name)
		if not p then
			return true, "Not in-game!"
		end
		p = p:get_pos()
		if param == "" then
			return true, tostring(minetest.is_protected(p, ""))
		else
			return true, tostring(minetest.is_protected(p, param))
		end
	end,
})

print("loaded system")

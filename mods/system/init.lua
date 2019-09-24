minetest.register_chatcommand("w", {
	description = "Show current item",
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

print("loaded system")

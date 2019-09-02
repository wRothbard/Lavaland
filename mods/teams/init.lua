local players = {}

minetest.register_on_leaveplayer(function(player)
	players[player:get_player_name()] = nil
end)

minetest.register_chatcommand("team", {
	params = "[set <name>]",
	func = function(name, param)
		if param == "" then
			return true, players[name]
		end
		param = param:split(" ")
		if param[1] == "show" then
			local s = ""
			for k, v in pairs(players) do
				s = s .. v .. ","
			end
			s = s:sub(1, -2)
			return true, s
		elseif param[1] == "set" then
			local n = param[2]:gsub("%W", "")
			players[name] = n
			return true, n
		end
	end,
})

print("loaded teams")

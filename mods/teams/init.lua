teams = {}

local players = {}

teams.get_team = function(name)
	return players[name]
end

local function set_clothing(player, team)
	local name = player:get_player_name()
	local d_inv = minetest.get_inventory({type = "detached",
			name = name .. "_clothing"})
	local itemss = {}
	for i = 1, d_inv:get_size("clothing") do
		local stack = d_inv:get_stack("clothing", i)
		if stack:get_count() > 0 then
			table.insert(itemss, stack)
			d_inv:set_stack("clothing", i, nil)
			clothing:run_callbacks("on_unequip", player, i, stack)
		end
	end
	local c = {"hat", "shirt", "pants", "cape"}
	for i = 1, 4 do
		local stack = ItemStack({name = "clothing:" .. c[i] .. "_" .. team})
		d_inv:set_stack("clothing", i, stack)
		clothing:run_callbacks("on_equip", player, i, stack)
	end
	clothing.save(player, d_inv)
	clothing:set_player_clothing(player)
	inventory.throw_inventory(player:get_pos(), itemss)
end

teams.set_team = function(name, team)
	if not team then
		return
	end
	local player = minetest.get_player_by_name(name)
	if not player then
		return
	end
	if team == "red" or team == "blue" or
			team == "green" then
		set_clothing(player, team)
	end
	players[name] = team
end

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
			return true, "Your team is: " .. teams.get_team(name)
		elseif param[1] == "set" then
			local n = param[2]:gsub("%W", "")
			teams.set_team(name, n)
			return true, "Your team is now set to " .. n
		end
	end,
})

print("loaded teams")

local players = {}
local timer = 1

local function is_ring(player)
	local i = player:get_inventory():get_stack("backpack", 1):get_name()
	local name = player:get_player_name()
	if i == "rings:muddy_vision" and players[name].ring ~= i then
		players[name].ring = i
		player:set_properties({nametag = "\n"})
		return
	end
	if players[name].ring ~= "" then
		if players[name].ring == "rings:muddy_vision" then
			player:set_properties({nametag = ""})
		end
		players[name].ring = ""
	end
end

local function query()
	for name, ring in pairs(players) do
		local player = minetest.get_player_by_name(name)
		if not player then
			break
		end
		is_ring(player)
	end
end

minetest.register_craftitem("rings:muddy_vision", {
	description = "Ring of Muddy Vision",
	inventory_image = "rings_muddy_vision.png",
})

minetest.register_craft({
	output = "rings:muddy_vision",
	recipe = {
		{"obsidian:shard", "mese:crystal_fragment", "obsidian:shard",},
		{"mese:crystal_fragment", "", "mese:crystal_fragment",},
		{"obsidian:shard", "mese:crystal_fragment", "obsidian:shard",},
	},
})

--[[
minetest.register_craftitem("rings:invisibility", {})
minetest.register_craft({})
minetest.register_craftitem("rings:levitation", {})
minetest.register_craft({})
--]]

minetest.register_on_joinplayer(function(player)
	players[player:get_player_name()] = {ring = ""}
	is_ring(player)
end)

minetest.register_on_leaveplayer(function(player)
	players[player:get_player_name()] = nil
end)

minetest.register_globalstep(function(dtime)
	if timer > 0 then
		if timer > 59 then
			timer = 0
			return
		end
		timer = timer + dtime
		return
	end
	query()
	timer = timer + dtime
end)

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
	is_ring(player)
end)

print("loaded rings")

rings = {}

local players = {}
local timer = 1

local function throw_armor(player)
	local name = player:get_player_name()
	local d_inv = minetest.get_inventory({type = "detached",
			name = name .. "_armor"})
	local itemss = {}
	for i = 1, d_inv:get_size("armor") do
		local stack = d_inv:get_stack("armor", i)
		if stack:get_count() > 0 then
			table.insert(itemss, stack)
			armor:set_inventory_stack(player, i, nil)
			armor:run_callbacks("on_unequip", player, i, stack)
		end
	end
	armor:set_player_armor(player)
	inventory.throw_inventory(player:get_pos(), itemss)
end

local function throw_clothing(player)
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
	clothing.save(player, d_inv)
	clothing:set_player_clothing(player)
	inventory.throw_inventory(player:get_pos(), itemss)
end

local function is_ring(player)
	local inv = player:get_inventory()
	local s = inv:get_stack("backpack", 1)
	local i = s:get_name()
	local name = player:get_player_name()
	if i == "rings:muddy_vision" then
		if players[name].ring ~= i then
			players[name].ring = i
			player:set_properties({nametag = "\n"})
		end
		s:add_wear(500)
		inv:set_stack("backpack", 1, s)
		rings[name] = i
		return
	elseif i == "rings:invisibility" then
		if players[name].ring ~= i then
			players[name].ring = i
			player:set_properties({nametag = "\n"})
			local skin = inv:get_stack("skin", 1)
			if skin ~= "" then
				inventory.throw_inventory(player:get_pos(),
						{skin})
			end
			inv:set_list("skin", {})
			local d_inv = minetest.get_inventory({type = "detached",
					name = name .. "_skin"})
			d_inv:set_list("skin", {})
			multiskin.set_player_skin(player, "default_blank.png")
			multiskin.update_player_visuals(player)
			wieldview:update_wielded_item(player, true)
			throw_armor(player)
			throw_clothing(player)
		end
		s:add_wear(1000)
		inv:set_stack("backpack", 1, s)
		rings[name] = i
		return
	elseif i == "rings:levitation" then
		if players[name].ring ~= i then
			players[name].ring = i
			--
		end
		s:add_wear(2500)
		inv:set_stack("backpack", 1, s)
	end
	-- Cancel
	if players[name].ring ~= "" then
		if players[name].ring == "rings:muddy_vision" then
			player:set_properties({nametag = ""})
		elseif players[name].ring == "rings:invisibility" then
			player:set_properties({nametag = ""})
			local gender = player:get_meta():get_string("gender")
			multiskin.set_player_skin(player, "player_" .. gender .. ".png")
			multiskin.update_player_visuals(player)
		end
		players[name].ring = ""
		rings[name] = nil
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

minetest.register_tool("rings:muddy_vision", {
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

minetest.register_tool("rings:invisibility", {
	description = "Ring of Invisibility",
	inventory_image = "rings_muddy_vision.png^[colorize:white:90",
})

minetest.register_craft({
	output = "rings:invisibility",
	recipe = {
		{"diamond:diamond", "mese:crystal_fragment", "diamond:diamond",},
		{"mese:crystal_fragment", "", "mese:crystal_fragment",},
		{"diamond:diamond", "mese:crystal_fragment", "diamond:diamond",},
	}
})

--[[
minetest.register_craftitem("rings:levitation", {})
minetest.register_craft({})
--]]

minetest.register_on_joinplayer(function(player)
	players[player:get_player_name()] = {ring = ""}
	minetest.after(2, is_ring, player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	rings[name] = nil
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

armor:register_on_equip(function(player)
	local name = player:get_player_name()
	if rings[name] and rings[name] == "rings:invisibility" then
		throw_armor(player)
	end
end)

clothing:register_on_equip(function(player)
	local name = player:get_player_name()
	if rings[name] and rings[name] == "rings:invisibility" then
		throw_clothing(player)
	end
end)

print("loaded rings")

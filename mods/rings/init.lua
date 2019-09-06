rings = {}

local players = {}
local timer = 1
local flying = {}
local breaking = {}

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

local function governor(player)
	minetest.after(0.18, function()
		local name = player:get_player_name()
		if not minetest.get_player_by_name(name) then
			return
		end
		local vel = player:get_player_velocity()
		vel = vector.normalize(vel)
		if vel.x > 1 or vel.y > 1 or vel.z > 1 then
			return
		end
		player:add_player_velocity({x = -vel.x, y = -vel.y, z = -vel.z})
		breaking[name] = false
	end)
end

local function flight(player)
	local name = player:get_player_name()
	if not minetest.get_player_by_name(name) then
		return
	end
	if not (rings[name] and rings[name] == "rings:levitation") then
		return
	end
	if not flying[name] then
		flying[name] = true
		player:set_physics_override({
			speed = 0,
			gravity = 0,
			jump = 0,
		})
	end
	if not breaking[name] then
		local hs = player:get_player_velocity()
		local control = player:get_player_control()
		local dir = player:get_look_dir()
		local v = vector.new(dir)
		v.y = 0
		v = vector.normalize(v)
		v = vector.multiply(v, 3)
		local hss = hs.x < 6 and hs.x > -6 and
				hs.z < 6 and hs.z > -6
		if control.jump and hs.y < 6 then
			player:add_player_velocity({x = 0, y = 3, z = 0})
		end
		if control.sneak and hs.y > -6 then
			player:add_player_velocity({x = 0, y = -3, z = 0})
		end
		if control.up and hss then
			player:add_player_velocity({x = v.x, y = 0, z = v.z})
		elseif control.down and hss then
			player:add_player_velocity({x = -v.x, y = 0, z = -v.z})
		end
		if control.left and hss then
			local yaw = player:get_look_horizontal()
			if yaw <= 0.75 or yaw >= 5.75 then
				player:add_player_velocity({x = -v.z, y = 0, z = -v.x})
			elseif yaw <= 5.75 and yaw >= 3.75 then
				player:add_player_velocity({x = -v.z, y = 0, z = v.x})
			elseif yaw <= 3.75 and yaw >= 2.5 then
				player:add_player_velocity({x = -v.z, y = 0, z = -v.x})
			elseif yaw <= 2.5 and yaw >= 0.75 then
				player:add_player_velocity({x = -v.z, y = 0, z = v.x})
			end
		elseif control.right and hss then
			local yaw = player:get_look_horizontal()
			if yaw <= 0.75 or yaw >= 5.75 then
				player:add_player_velocity({x = v.z, y = 0, z = v.x})
			elseif yaw <= 5.75 and yaw >= 3.75 then
				player:add_player_velocity({x = v.z, y = 0, z = -v.x})
			elseif yaw <= 3.75 and yaw >= 2.5 then
				player:add_player_velocity({x = v.z, y = 0, z = v.x})
			elseif yaw <= 2.5 and yaw >= 0.75 then
				player:add_player_velocity({x = v.z, y = 0, z = -v.x})
			end
		end
		governor(player)
		breaking[name] = true
	end
	minetest.after(0.09, function()
		flight(player)
	end)
end

local function is_ring(player)
	local inv = player:get_inventory()
	local s = inv:get_stack("backpack", 1)
	local i = s:get_name()
	local name = player:get_player_name()
	if i == "rings:muddy_vision" then
		rings[name] = i
		if players[name].ring ~= i then
			players[name].ring = i
			player:set_properties({nametag = "\n"})
		end
		s:add_wear(500)
		inv:set_stack("backpack", 1, s)
		return
	elseif i == "rings:invisibility" then
		rings[name] = i
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
		return
	elseif i == "rings:levitation" then
		rings[name] = i
		if players[name].ring ~= i then
			players[name].ring = i
			--flight(player)
		end
		s:add_wear(2500)
		inv:set_stack("backpack", 1, s)
		return
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
		elseif players[name].ring == "rings:levitation" then
			player:set_physics_override({
				speed = 1,
				gravity = 1,
				jump = 1,
			})
			flying[name] = false
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

minetest.register_tool("rings:levitation", {
	description = "Ring of Levitation",
	inventory_image = "rings_muddy_vision.png^[colorize:red:90",
})

minetest.register_craft({
	type = "shapeless",
	output = "rings:levitation",
	recipe = {"rings:invisibility", "rings:muddy_vision"},
})

minetest.register_on_joinplayer(function(player)
	players[player:get_player_name()] = {ring = ""}
	minetest.after(3, is_ring, player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	rings[name] = nil
	if flying[name] then
		flying[name] = nil
	end
	if breaking[name] then
		breaking[name] = nil
	end
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
	if inventory_info.to_list == "backpack" or inventory_info.from_list == "backpack" then
		is_ring(player)
	end
end)

armor:register_on_equip(function(player)
	local name = player:get_player_name()
	if rings[name] and rings[name] == "rings:invisibility" then
		throw_armor(player)
		is_ring(player)
	end
end)

clothing:register_on_equip(function(player)
	local name = player:get_player_name()
	if rings[name] and rings[name] == "rings:invisibility" then
		throw_clothing(player)
		is_ring(player)
	end
end)

print("loaded rings")

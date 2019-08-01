local sprinting = {}

local function control(player, field)
	local controls = player:get_player_control()
	if field then
		return controls[field]
	else
		return controls
	end
end

local function physics(player, enabled)
	if enabled then
		player:set_physics_override({
			speed = 2,
			jump = 2,
			gravity = 0.9,
		})
	else
		player:set_physics_override({
			speed = 1,
			jump = 1,
			gravity = 1,
		})
	end
end

local function sprint(player)
	local name = player:get_player_name()
	local aux1 = control(player, "aux1")
	local s = sprinting[name]
	if s and not aux1 then
		sprinting[name] = false
		physics(player, false)
	elseif aux1 and not s then
		sprinting[name] = true
		physics(player, true)
	end
	minetest.after(0, function()
		sprint(player)
	end)
end

minetest.register_item(":", {
	type = "none",
	wield_image = "player_wieldhand.png",
	wield_scale = {x = 1, y = 1, z = 2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			oddly_breakable_by_hand = {
				times = {
					[1] = 5.00,
					[2] = 3.00,
					[3] = 1.00,
				},
				uses = 0,
			},
		},
		damage_groups = {fleshy = 1},
	},
})

minetest.register_on_dieplayer(function(player, reason)
	local pos = player:get_pos()
	local old_node = minetest.get_node(pos)
	if old_node.name == "lava:source" then
		minetest.set_node(pos, {name = "water:source"})
	end
	local an = minetest.find_node_near(pos, 3, "air", true)
	if an then
		minetest.set_node(an, {name = "bones:bones"})
	end
end)

minetest.register_on_joinplayer(function(player)
	player:set_physics_override({
		sneak_glitch = true,
		sneak = true,
		new_move = false,
	})
	sprinting[player:get_player_name()] = false
	sprint(player)
end)

minetest.register_on_leaveplayer(function(player)
	sprinting[player:get_player_name()] = nil
end)

print("player loaded")

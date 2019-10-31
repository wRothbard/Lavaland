cozy = {}
cozy.players = {}

local sprinting = {}
local players = {}
local cooldown = {}
local accelerating = {}
local dead = {}

dofile(minetest.get_modpath("player") .. "/api.lua")

player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"player_male.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160},
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

local function control(player, field)
	local controls = player:get_player_control()
	if field then
		return controls[field]
	else
		return controls
	end
end

local function physics(player, enabled, cancel)
	if enabled then
		player:set_physics_override({
			speed = 2,
			jump = 1.5,
			gravity = 0.96,
			new_move = false,
			sneak_glitch = true,
			sneak = true,
		})
	elseif cancel then
		player:set_physics_override({
			speed = 0,
			jump = 0,
			gravity = 2,
			new_move = true,
			sneak_glitch = false,
			sneak = false,
		})
	else
		player:set_physics_override({
			speed = 1,
			jump = 1,
			gravity = 1,
			new_move = true,
			sneak_glitch = false,
			sneak = true,
		})
	end
end

cozy.reset = function(player, pos, state)
	local name = player:get_player_name()
	if cozy.players[name] then
		cozy.players[name] = nil
	end
	physics(player)
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player_api.player_attached[name] = false
	player_api.set_animation(player, "stand", 30)
end

local function reset(player, old_pos)
	if not player then
		return
	end
	local pos = player:get_pos()
	pos = vector.round(pos)
	if not old_pos then
		old_pos = pos
	end
	if not vector.equals(pos, old_pos) then
		cozy.reset(player)
	end
	local name = player:get_player_name()
	if not cozy.players[name] then
		return
	end
	local c = player:get_player_control()
	c = c.jump or c.up or c.down or c.left or c.right
	if c then
		cozy.reset(player)
		return
	end
	minetest.after(0.09, function()
		reset(player, pos)
	end)
end

cozy.sit = function(player, pos, state)
	local name = player:get_player_name()
	if rings.players[name] and rings.players[name] == "rings:levitation" then
		return
	end
	if cozy.players[name] and cozy.players[name] == "sit" then
		cozy.reset(player)
	else
		cozy.players[name] = "sit"
		physics(player, nil, true)
		player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = true
		player_api.set_animation(player, "sit", 30)
		reset(player)
	end
end

cozy.lay = function(player, pos, state)
	local name = player:get_player_name()
	if rings.players[name] and rings.players[name] == "rings:levitation" then
		return
	end
	if cozy.players[name] and cozy.players[name] == "lay" then
		cozy.reset(player)
	else
		cozy.players[name] = "lay"
		physics(player, nil, true)
		player:set_eye_offset({x = 0, y = -13, z = 0}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = true
		player_api.set_animation(player, "lay", 0)
		reset(player)
	end
end

local function boost(player, old_pos)
	local name = player:get_player_name()
	local vel = player:get_player_velocity()
	local sneak = player:get_player_control().sneak 
	if vel.y >= 6.5 and players[name] < 1 and
			sneak and accelerating[name] then
		players[name] = players[name] + 1
		local boost = vector.multiply(vel, 0.35)
		player:add_player_velocity(boost)
	elseif vel.y <= 0 and not sneak then
		players[name] = 0
	end
end

local function sprint(player)
	if not player then
		return
	end

	local stam = stamina.get_stamina(player)
	if not stam then
		return
	end

	local name = player:get_player_name()
	local attached = player_api.player_attached[name]
	if not attached and not (rings.players[name] and
			rings.players[name] == "rings:levitation") then
		local max_stam = stats.update_stats(player, {stam_max = ""}).stam_max
		local pos = player:get_pos()
		local c = control(player)
		local s = sprinting[name]
		local vel = player:get_player_velocity()
		local y = vel.y < -10 

		if vel.x > 5 or vel.z > 5 or
				vel.x < -5 or vel.z < -5 then
			accelerating[name] = true
		else
			accelerating[name] = false
		end

		if stam >= 1 and not s and c.aux1 and
				not cooldown[name] and not y then
			sprinting[name] = true
			physics(player, true)
		elseif s and (not c.aux1 or stam < 1 or y) then
			sprinting[name] = false
			physics(player, false)
		end

		if sprinting[name] and stam > 0 and
				(c.up or c.down or c.left or
				c.right or c.jump) then
			if players[name] <= 1 then
				boost(player, pos)
			end
			stamina.add_stamina(player, -0.1)
		elseif stam < max_stam and not cooldown[name] then
			stamina.add_stamina(player, 0.25)
		end

		if stam < 1 and not cooldown[name] then
			cooldown[name] = true
			stamina.add_stamina(player, -20)
			minetest.after(2, stamina.add_stamina, player, 1)
			hud.update(player, "stamina", nil, nil, {
				name = "cooldown",
				action = "red",
			})
		elseif stam >= max_stam and cooldown[name] then
			cooldown[name] = false
			hud.update(player, "stamina", nil, nil, {
				name = "cooldown",
				action = "green",
			})
		elseif cooldown[name] then
			if stam >= 1 and stam < max_stam then
				stamina.add_stamina(player, 0.25)
			end
		end

		if player:get_hp() == 0 then
			hud.update(player, "stamina", "number", 0)
		else
			local sss = stamina.get_stamina(player)
			local ss = stats.update_stats(player,
					{stam_max = ""}).stam_max
			local s = 20 / (ss / sss)
			hud.update(player, "stamina", "number", s)
		end
	end
	minetest.after(0, function()
		sprint(player)
	end)
end

local function breath_air(player)
	if not minetest.get_player_by_name(player:get_player_name()) then
		return
	end
	local bm = player:get_properties().breath_max
	if player:get_breath() < bm then
		local _, ba = armor:get_valid_player(player)
		if ba then
			ba = ba:get_list("armor")
			local d = 0
			for i = 1, 5 do
				if ba[i]:get_name():sub(-6) == "bronze" then
					d = d + 1
				end
			end
			if d == 5 then
				armor:punch(player)
				player:set_breath(bm)
			end
		end
	end
	minetest.after(6, function()
		breath_air(player)
	end)
end

local formspec_prepend = "bgcolor[#080808BB;false]" ..
		"background[1,1;1,1;player_background.png;true]" ..
		"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF"

local formspec_default = "size[8,7.25]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;status;Status]" ..
		--"button[6,2;1,1;autocraft;AC]" ..
		"button[6,0;1,1;chat;...]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"list[current_player;craft;3,0;3,3;]" ..
		"list[current_player;craftpreview;7,1;1,1;]" ..
		"image[6,1;1,1;player_arrow.png^[transformR270]" ..
		"list[current_player;backpack;7,2;1,1;]" ..
		"list[current_player;main;0,3.25;8,1;]" ..
		"list[current_player;main;0,4.5;8,3;8]" ..
		"listring[current_player;main]" ..
		"listring[current_player;craft]" ..
		forms.get_hotbar_bg(0, 3.25)

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
			snappy = {
				times = {
					[1] = 5.00,
					[2] = 3.00,
					[3] = 1.00,
				},
				uses = 0,
			},
			crumbly = {
				times = {
					[1] = 5.00,
					[2] = 3.00,
					[3] = 1.00,
				},
				uses = 0,
			},
			choppy = {
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

local bp = {
	meta = {
		infotext = "Leather Backpack",
		inventory = "return {\"bucket:bucket_water\", \"stone:cobble 50\", \"mese:crystal_fragment 10\", \"farming:bread 13\", \"mobs:meat\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\"}",
		description = "Leather Backpack"
	},
	metadata = "",
	count = 1,
	name = "backpacks:backpack_leather",
	wear = 0,
}

minetest.register_on_newplayer(function(player)
	local inv = player:get_inventory()
	local s_items = {
		"warpstones:diamond",
		"tools:pick_mese_bone",
		"torch:torch 25",
		"craftguide:book",
		"wool:red",
		"wool:green",
		"wool:blue",
		"gold:block",
		ItemStack(bp),
		"walkie:talkie",
	}
	for i = 1, #s_items do
		local s = s_items[i]
		inv:add_item("main", s)
	end
	minetest.after(1, help.show, player, "NewPlayerInfo")
end)

minetest.register_on_dieplayer(function(player, reason)
	local name = player:get_player_name()
	if dead[name] then
		minetest.chat_send_player(name, "It would appear you are in limbo!")
		return
	end
	if reason.type == "punch" and reason.object and
			reason.object:is_player() then
		minetest.chat_send_all(reason.object:get_player_name() ..
				" punched out " .. name .. ".")
	elseif reason.type == "drown" then
		minetest.chat_send_all(player:get_player_name() ..
				" drowned!")
	elseif reason.type == "node_damage" and reason.node == "lava:source" or
			reason.node == "lava:flowing" then
		minetest.chat_send_all(player:get_player_name() ..
				" melted in lava!")
	elseif reason.type == "fall" then
		minetest.chat_send_all(player:get_player_name() ..
				" fell to their death!")
	end

	local p_inv = player:get_inventory()
	local items = {}
	for k, list in pairs(p_inv:get_lists()) do
		if k ~= "bed" and k ~= "backpack" and
				k ~= "flags" then
			local wit
			for i, n in pairs(list) do
				if not n:is_empty() then
					if n:get_name() == "walkie:talkie" and
							not wit then
						wit = n
					else
						items[#items + 1] = n
					end
				end
			end
			p_inv:set_list(k, {})
			if wit then
				p_inv:set_stack("main", 1, wit)
			end
		end
	end

	minetest.get_inventory({type = "detached", name = name .. "_skin"}):set_list("skin", {})
	if not (rings.players[name] and rings.players[name] == "rings:invisibility") then
		local gender = player:get_meta():get("gender")
		multiskin.set_player_skin(player, "player_" .. gender .. ".png")
		multiskin.update_player_visuals(player)
	end

	local pos = player:get_pos()
	local old_node = minetest.get_node(pos)
	if old_node.name:match("lava") then
		minetest.set_node(pos, {name = "water:source"})
	end
	pos = minetest.find_node_near(pos, 3, "air", true) or pos
	minetest.set_node(pos, {name = "bones:bones"})
	minetest.chat_send_player(name, "Bones placed at: " .. minetest.pos_to_string(vector.round(pos)))
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8 * 4)
	meta:set_string("formspec", "size[8,9]" ..
			"list[context;main;0,0;8,4]" ..
			"list[current_player;main;0,5;8,4]" ..
			"listring[]")
	inv:set_list("main", items)
	meta:set_string("infotext", "" .. name .. "'s bones.")
	meta:set_string("owner", name)
	minetest.after(1, function()
		minetest.get_node_timer(pos):start(1.0)
	end)

	dead[name] = true
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	dead[name] = false
	stats.update_stats(player, {
		hp_max = 20,
		hp = 20,
		xp = 0,
		level = 1,
		sat_max = 20,
		sat = 20,
		stam_max = 20,
		stam = 20,
		breath = 11,
		breath_max = 11,
	})
	hud.update(player, "hunger", "number", nil, {name = "hunger"})
	if not beds.spawn[name] then
		player:set_pos(spawn.pos)
		return true
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()

	sprinting[name] = false
	cooldown[name] = false
	players[name] = 0
	accelerating[name] = false

	if player:get_hp() == 0 then
		dead[name] = true
	else
		dead[name] = false
	end

	player:set_physics_override({
		sneak_glitch = false,
		sneak = true,
		new_move = true,
	})

	player_api.player_attached[name] = false
	player_api.set_model(player, "character.b3d")
	player:set_local_animation(
		{x = 0,   y = 79},
		{x = 168, y = 187},
		{x = 189, y = 198},
		{x = 200, y = 219},
		30
	)

	player:set_formspec_prepend(formspec_prepend)
	player:set_inventory_formspec(formspec_default)

	-- HUD
	player:hud_set_hotbar_image("player_hotbar.png")
	player:hud_set_hotbar_selected_image("player_hotbar_selected.png")
	player:hud_set_flags({
		minimap = true,
		minimap_radar = true,
	})

	-- Zoom
	player:set_properties({
		zoom_fov = 34,
	})

	sprint(player)
	breath_air(player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	sprinting[name] = nil
	cooldown[name] = nil
	players[name] = nil
	accelerating[name] = nil
	dead[name] = nil
	if cozy.players[name] then
		cozy.reset(player)
	end
end)

minetest.register_chatcommand("sit", {
	description = "Sit down",
	params = "",
	privs = "interact",
	func = function(n)
		local p = minetest.get_player_by_name(n)
		if not p then
			return false, "Must be in-game."
		end
		cozy.sit(p)
	end,
})

minetest.register_chatcommand("lay", {
	description = "Lay down",
	params = "",
	privs = "interact",
	func = function(n)
		local p = minetest.get_player_by_name(n)
		if not p then
			return false, "Must be in-game."
		end
		cozy.lay(p)
	end,
})

minetest.register_chatcommand("zoom_fov", {
	description = "Set zoom FOV",
	params = "<fov>",
	privs = "interact",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "You must be in-game!"
		end

		param = tonumber(param)
		if param and param > 11 and
				param < 145 then
			player:set_properties({zoom_fov = zoom_fov})
		end
	end,
})

print("loaded player")

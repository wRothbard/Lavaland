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
			jump = 1.5,
			gravity = 0.96,
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

local formspec_prepend = "bgcolor[#080808BB;false]" ..
		"background[1,1;1,1;player_background.png;true]" ..
		"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF"

local function get_hotbar_bg(x, y)
	local out = ""
	for i= 0, 7, 1 do
		out = out .. "image[" .. x + i ..
				"," .. y .. ";1,1;player_hb_bg.png]"
	end
	return out
end

local formspec_default = "size[8,7.25]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button_exit[0.5,0;2,1;status;Status]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"list[current_player;craft;3,0;3,3;]" ..
		"list[current_player;craftpreview;7,1;1,1;]" ..
		"image[6,1;1,1;player_arrow.png^[transformR270]" ..
		"list[current_player;main;0,3.25;8,1;]" ..
		"list[current_player;main;0,4.5;8,3;8]" ..
		"listring[current_player;main]" ..
		"listring[current_player;craft]" ..
		get_hotbar_bg(0, 3.25)

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
	if old_node.name:match("lava") then
		minetest.set_node(pos, {name = "water:source"})
	end
	local an = minetest.find_node_near(pos, 3, "air", true)
	if an then
		minetest.set_node(an, {name = "bones:bones"})
		local p_inv = player:get_inventory()
		local meta = minetest.get_meta(an)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
		meta:set_string("formspec", "size[8,9]" ..
				"list[context;main;0,0;8,4]" ..
				"list[current_player;main;0,5;8,4]" ..
				"listring[]")
		inv:set_list("main", p_inv:get_list("main"))
		p_inv:set_list("main", {})
	end
end)

minetest.register_on_joinplayer(function(player)
	sprinting[player:get_player_name()] = false
	player:set_physics_override({
		sneak_glitch = true,
		sneak = true,
		new_move = false,
	})
	player:set_formspec_prepend(formspec_prepend)
	player:set_inventory_formspec(formspec_default)
	player:hud_set_hotbar_image("player_hotbar.png")
	player:hud_set_hotbar_selected_image("player_hotbar_selected.png")
	sprint(player)
end)

minetest.register_on_leaveplayer(function(player)
	sprinting[player:get_player_name()] = nil
end)

print("player loaded")

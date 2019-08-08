stats = {}

function stats.get_hotbar_bg(x, y)
	local out = ""
	for i= 0, 7, 1 do
		out = out .. "image[" .. x + i ..
				"," .. y .. ";1,1;player_hb_bg.png]"
	end
	return out
end

local function show_status(player)
	local name = player:get_player_name()
	local formspec = "size[8,7.25]" ..
		"real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;help;Help]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"list[detached:" .. name .. "_clothing;clothing;3,1;4,1]" ..
		"item_image[3,1;1,1;clothing:hat_grey]" ..
		"item_image[4,1;1,1;clothing:shirt_grey]" ..
		"item_image[5,1;1,1;clothing:pants_grey]" ..
		"item_image[6,1;1,1;clothing:cape_grey]" ..
		"list[detached:" .. name .. "_skin;skin;7,1;1,1]" ..
		"image[7,1;1,1;skins_skin_bg.png]" ..
		"list[detached:" .. name .. "_armor;armor;3,2;5,1]" ..
		"item_image[3,2;1,1;3d_armor:helmet_steel]" ..
		"item_image[4,2;1,1;3d_armor:chestplate_steel]" ..
		"item_image[5,2;1,1;3d_armor:leggings_steel]" ..
		"item_image[6,2;1,1;3d_armor:boots_steel]" ..
		"item_image[7,2;1,1;3d_armor:shield_steel]" ..
		"list[current_player;main;0,3.25;8,1;]" ..
		"list[current_player;main;0,4.5;8,3;8]" ..
		stats.get_hotbar_bg(0, 3.25) ..
	""
	minetest.show_formspec(name, "stats:status", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.status then
		show_status(player)
	end
end)

minetest.register_privilege("moderator", "Can moderate.")

print("stats loaded")

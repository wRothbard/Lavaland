local function show_formspec(player, input)
	local name = player:get_player_name()
	local formspec = "size[8,7.25]" .. "real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;status;Status]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"label[1,4;2 small bones + 3 mese crystals = pickaxe]" ..
	""

	minetest.show_formspec(name, "help:help", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "stats:status" and
			fields.help then
		show_formspec(player)
	end
end)

print("help loaded")

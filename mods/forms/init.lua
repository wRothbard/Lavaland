forms = {}

forms.get_hotbar_bg = function(x, y)
	local out = ""
	for i= 0, 7, 1 do
		out = out .. "image[" .. x + i ..
				"," .. y .. ";1,1;player_hb_bg.png]"
	end
	return out
end

forms.exit_button = function(x, y, w, h)
	x = x or 0
	y = y or 0
	w = w or 7.44
	h = h or -0.034
	return "button_exit[" .. w + x .. "," ..
			h + y .. ";0.7,0.667;;x]"
end

forms.help_button = function(x, y, w, h)
	x = x or 0
	y = y or 0
	w = w or 6.94
	h = h or -0.034
	return "button[" .. w + x .. "," ..
			h + y .. ";0.7,0.667;help;?]"
end

forms.title_bar = function(x, y, w, h)
	x = x or 0
	y = y or 0
	w = w or 8
	h = h or 1
	return "container[" .. x .. "," .. y .. ";" .. w .. "," .. h .. "]" ..
		--"box[0,0;8,1;black]" ..
		"label[0,0;WTF]" ..
		forms.help_button() ..
		forms.exit_button() ..
	"container_end[]"
end

forms.message = function(player, message, dialog, formname, title, no_chat_msg)
	if not player then
		return
	end

	local name
	if type(player) == "string" then
		name = player
		player = minetest.get_player_by_name(name)
	else
		name = player:get_player_name()
	end

	if not message then
		message = "This space intentionally left blank."
	end

	if not no_chat_msg then
		minetest.chat_send_player(name, message)
	end

	message = minetest.formspec_escape(message)
	local formspec = "size[8,4]" ..
		forms.exit_button() ..
		"textarea[0.35,0.5;8,4;;;" ..
				message .. "]" ..
	""
	if title then
		formspec = formspec .. "label[0,0;" .. title .. "]"
	end

	if formname then
		formspec = formspec ..
			"button_exit[1,3;2,1;cancel;Cancel]" ..
			"button_exit[6,3;1,1;ok;OK]" ..
		""
	else
		formname = "forms:message_dialog"
	end

	if dialog then
		return minetest.after(0, minetest.show_formspec,
				name, formname, formspec)
	else
		return formspec
	end
end

print("loaded forms")

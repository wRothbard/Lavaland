chat = {}

local store = minetest.get_mod_storage()
local stored_chat = store:get("chat")
if stored_chat then
	chat = minetest.deserialize(stored_chat)
end

local save_timer = 0

local function save()
	store:set_string("chat", minetest.serialize(chat))
end

local function show_chat(name)
	local chatbox = ""
	for i = 1, #chat do
		chatbox = chatbox .. chat[i] .. "\n"
	end
	local chat_fs = "size[8,7.25]" ..
		"field[0.06,7.12;6.89,1;chatsend;;]" ..
		"textarea[0.08,-0.28;8.5,8.3;;;" .. chatbox .. "]" ..
		"field_close_on_enter[chatsend;false]" ..
		"image_button[6.54,6.89;0.83,0.83;chat_update.png;update;]" ..
		"button[7.24,6.81;1,1;ok;OK]" ..
	""
	minetest.show_formspec(name, "chat:chat", chat_fs)
end

local function add_chat(name, message)
	for i = #chat, 1, -1 do
		if i < 1000 then
			chat[i + 1] = chat[i]
		end
	end
	chat[1] = "<" .. name .. "> " .. message
end

minetest.register_chatcommand("chat", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Must be in-game to use /chat."
		end
		show_chat(name)
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.chat then
		show_chat(player:get_player_name())
	elseif formname == "chat:chat" and (fields.chatsend or fields.ok) then
		local name = player:get_player_name()
		if fields.chatsend == "" or fields.update then
			show_chat(name)
		else
			local thing = minetest.formspec_escape(fields.chatsend)
			add_chat(name, thing)
			show_chat(name)
			minetest.chat_send_all("<" .. name .. "> " .. thing)
		end
	end
end)

minetest.register_on_chat_message(function(name, message)
	add_chat(name, minetest.formspec_escape(message))
end)

minetest.register_on_shutdown(function()
	save()
end)

minetest.register_globalstep(function(dtime)
	if save_timer > 60 then
		save()
		save_timer = 0
	else
		save_timer = save_timer + dtime
	end
end)

print("loaded chat")

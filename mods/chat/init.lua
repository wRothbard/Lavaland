chat = {}

local function show_chat(name)
	local chatbox = "<jas> hi\n<jas1> hi\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd\nd"
	local chat_fs = "size[16,12]" ..
		"real_coordinates[true]" ..
		"textarea[0,0;16,11;;;" .. chatbox .. "]" ..
		"field[0,11;15,1;chatsend;;]" ..
		"field_close_on_enter[chatsend;false]" ..
		"button[15,11;1,1;ok;OK]" ..
		"box[-0.2,-0.2;16.4,12.4;black]" ..
		"box[-0.1,-0.1;16.2,12.2;#888888]" ..
		"bgcolor[black;false]" ..
	""
	minetest.show_formspec(name, "chat:chat", chat_fs)
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

print("loaded chat")

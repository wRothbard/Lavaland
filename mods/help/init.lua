local pages = {}

local store = minetest.get_mod_storage()
local saved = store:get("pages")
if saved then
	saved = minetest.deserialize(saved)
	if saved then
		pages = saved
	end
end

if not pages[1] then
	pages[1] = {title = "Help",
			text = "This is the help system." ..
			"\nType /new_page to create a new help page."}
end

minetest.register_privilege("help", "Can edit help documentation.")

local function show_formspec(player, page_num)
	page_num = page_num or 1
	local name = player:get_player_name()
	local editor = minetest.check_player_privs(name, {help = true})
	local page_str = ""
	for i = 1, #pages do
		local t = pages[i].title
		page_str = page_str .. "," .. t
	end
	page_str = page_str:sub(2, -1)
	local text = pages[page_num].text

	local formspec = "size[8,7.25]" .. "real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;status;Status]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"label[3,0.25;Help]" ..
		"table[3,1;4.8,2;toc;" .. page_str .. ";" .. page_num .. "]" ..
		"textarea[0.24,3.2;8.08,5.08;;;" .. text .. "]" ..
	""
	if editor then
		formspec = formspec ..
				"button[5,0;2,1;edit;Edit]"
	end

	minetest.show_formspec(name, "help:help_" .. page_num, formspec)
end

local function show_formspec_editor(player, page_num)
	page_num = page_num or 1
	local name = player:get_player_name()
	local page_str = ""
	for i = 1, #pages do
		local t = pages[i].title
		page_str = page_str .. "," .. t
	end
	page_str = page_str:sub(2, -1)
	local text = pages[page_num].text

	local formspec = "size[8,7.25]" .. "real_coordinates[]" ..
		"button_exit[0.5,1;2,1;home;Home]" ..
		"button[0.5,0;2,1;status;Status]" ..
		"button_exit[7,0;1,1;quit;X]" ..
		"button_exit[0.5,2;2,1;spawn;Spawn]" ..
		"label[3,0.25;Help]" ..
		"button[5,0;2,1;save;Save]" ..
		"table[3,1;4.8,2;toc;" .. page_str .. ";" .. page_num .. "]" ..
		"textarea[0.24,3.2;8.08,5.08;text;;" .. text .. "]" ..
	""

	minetest.show_formspec(name, "help:edit_" .. page_num, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if (formname == "stats:status" or
			formname == "stats:more") and
			fields.help then
		show_formspec(player)
		return
	end

	if string.match(formname, "help:help_") then
		local page = tonumber(formname:sub(11, -1))

		if fields.toc then
			page = tonumber(fields.toc:sub(5, 5))
			show_formspec(player, page)
			return
		elseif fields.edit then
			local privs = minetest.check_player_privs(player, {help = true})
			if not privs then
				return
			end
			show_formspec_editor(player, page)
			return
		end
	elseif string.match(formname, "help:edit_") then
		local privs = minetest.check_player_privs(player, {help = true})
		if not privs then
			return
		end
		local page = tonumber(formname:sub(11, -1))

		if fields.save then
			pages[page].text = fields.text
			store:set_string("pages", minetest.serialize(pages))
		end

		show_formspec(player, page)
		return
	end
end)

minetest.register_chatcommand("rename_page", {
	privs = "help",
	func = function(name, param)
		param = param:split(" ")
		if #param ~= 2 then
			return false, "Invalid usage!"
		end
		for k, v in pairs(pages) do
			if v and v.title == param[1] then
				pages[k] = pages[#pages]
				pages[#pages].title = param[2]:gsub("%W", "")
			end
		end

		store:set_string("pages", minetest.serialize(pages))

		return true, "Renamed."
	end,
})

minetest.register_chatcommand("delete_page", {
	privs = "help",
	func = function(name, param)
		if not minetest.check_player_privs(name, {kick = true}) then
			return false, "Not high enough privs."
		end
		for k, v in pairs(pages) do
			if v and v.title == param then
				pages[k] = pages[#pages]
				pages[#pages] = nil
			end
		end

		store:set_string("pages", minetest.serialize(pages))

		return true, "Deleted."
	end,
})

minetest.register_chatcommand("new_page", {
	privs = "help",
	func = function(name, param)
		if not param then
			return false, "No name supplied."
		end

		param = param:gsub("%W", "")
		if param == "" then
			return false, "Error."
		end

		pages[#pages + 1] = {
			title = param,
			text = "",
		}

		store:set_string("pages", minetest.serialize(pages))
		return true, param .. " created."
	end,
})

print("loaded help")

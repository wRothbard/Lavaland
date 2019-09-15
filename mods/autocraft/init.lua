local these_items = {}

local function find_item(itemstring)
	return these_items[itemstring]
end

local function can_craft(input, rep)
	local res = 0
	for i = 1, #rep do
		local it = rep[i]
		local itt = input[it]
		if itt then
			if itt > 1 then
				input[it] = itt - 1
			else
				input[it] = nil
			end
			res = res + 1
		end
	end
	return res == #rep
end

local function craft_it(player, item)
	print(dump(item))
	--[[
	local s = ItemStack(vv.output)
	for i = 1, #vv.items do
		if not inv:remove_item("main", vv.items[i]) then
			return
		end
	end
	if inv:room_for_item("main", s) then
		inv:add_item("main", s)
	else
		inventory.throw_inventory(player:get_pos(), {s})
	end
	--]]
end

local function make_list(player)
	local result = {}
	local mok = {}
	local inv = player:get_inventory()
	for _, it in pairs(inv:get_list("main")) do
		local itt = it:get_name()
		if itt ~= "" then
			if mok[itt] then
				mok[itt] = mok[itt] + it:get_count()
			else
				mok[itt] = it:get_count()
			end
		end
	end
	for _, v in pairs(these_items) do
		for _, vv in pairs(v) do
			if can_craft(mok, vv.items) then
				result[#result + 1] = vv.output
			end
		end
	end
	return result
end

minetest.register_on_mods_loaded(function()
	for _, item in pairs(minetest.registered_items) do
		local name = item.name
		local rep = minetest.get_all_craft_recipes(name)
		if rep then
			for _, v in pairs(rep) do
				if v.type == "normal" then
					local ti = these_items[name]
					if ti then
						these_items[name][#ti + 1] = v
					else
						these_items[name]= {v}
					end
				end
			end
		end
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.autocraft then
		print(dump(make_list(player)))
	end
end)

minetest.register_chatcommand("ac", {
	func = function(name, param)
		if param == "" then
			return false, "Need a name."
		end
		local res = find_item(param)
		if res then
			craft_it(minetest.get_player_by_name(name), res)
		end
	end,
})

print("loaded autocraft")

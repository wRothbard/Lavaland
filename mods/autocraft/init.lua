local these_items = {}

minetest.register_on_mods_loaded(function()
	for _, item in pairs(minetest.registered_items) do
		local name = item.name
		local rep = minetest.get_craft_recipe(name)
		if rep.method == "normal" then
			these_items[#these_items + 1] = {name = name, recipe = rep}
		end
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "" and fields.autocraft then
		local inv = player:get_inventory()
		local goods = {}
		local main = inv:get_list("main")
		for i = 1, #main do
			if main[i]:get_name() ~= "" then
				goods[#goods + 1] = main[i]
			end
		end
		for _, v in pairs(these_items) do
			local gi = #v.recipe.items
			local g = 0
			for _, vv in pairs(v.recipe.items) do
				if inv:contains_item("main", vv) then
					g = g + 1
				end
			end
			if g == gi then
				print(v.name)
			end
		end
	end
end)

minetest.register_chatcommand("ac", {
	func = function(name, param)
		if param == "" then
			return false, "Need a name."
		end
		for k, v in pairs(these_items) do
			if v.name == param then
				print(dump(these_items[k]))
			end
		end
	end,
})

print("loaded autocraft")

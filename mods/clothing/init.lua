local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/api.lua")
dofile(modpath.."/clothing.lua")
dofile(modpath.."/loom.lua")

local function is_clothing(item)
	return minetest.get_item_group(item, "clothing") > 0 or
			minetest.get_item_group(item, "cape") > 0
end

local function save_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local is_empty = true
	local clothes = {}
	for i = 1, 4 do
		local stack = clothing_inv:get_stack("clothing", i)
		-- Move all non-clothes back to the player inventory
		if not stack:is_empty() and not is_clothing(stack:get_name()) then
			player_inv:add_item("main",
					clothing_inv:remove_item("clothing", stack))
			stack:clear()
		end
		if not stack:is_empty() then
			clothes[i] = stack:to_string()
			is_empty = false
		end
	end
	local meta = player:get_meta()
	if is_empty then
		meta:set_string("clothing:inventory", nil)
	else
		meta:set_string("clothing:inventory",
				minetest.serialize(clothes))
	end
end
clothing.save = save_clothing_metadata

local function load_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local clothing_meta = player:get_attribute("clothing:inventory")
	local clothes = clothing_meta and minetest.deserialize(clothing_meta) or {}
	local dirty_meta = false
	if not clothing_meta then
		-- Backwards compatiblity
		for i = 1, 4 do
			local stack = player_inv:get_stack("clothing", i)
			if not stack:is_empty() then
				clothes[i] = stack:to_string()
				dirty_meta = true
			end
		end
	end
	-- Fill detached slots
	clothing_inv:set_size("clothing", 4)
	for i = 1, 4 do
		clothing_inv:set_stack("clothing", i, clothes[i] or "")
	end

	if dirty_meta then
		-- Requires detached inventory to be set up
		save_clothing_metadata(player, clothing_inv)
	end

	-- Clean up deprecated garbage after saving
	player_inv:set_size("clothing", 0)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local clothing_inv = minetest.create_detached_inventory(name.."_clothing",{
		on_put = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_equip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_unequip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			save_clothing_metadata(player, inv)
			clothing:set_player_clothing(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local item = stack:get_name()
			if is_clothing(item) then
				return 1
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	}, name)

	load_clothing_metadata(player, clothing_inv)
	minetest.after(2, function(name)
		-- Ensure the ObjectRef is valid after 1s
		clothing:set_player_clothing(minetest.get_player_by_name(name))
	end, name)
end)

print("loaded clothing")

-- Mailbox mod for Lavaland
-- Based on X-Decor's Mailbox
-- Copyright 2019 James Stevenson
-- GNU GPL 3

minetest.register_craft({
	output = "mailbox:mailbox",
	recipe = {
		{"bronze:ingot", "steel:ingot", "bronze:ingot"},
		{"steel:ingot", "papyrus:paper", "steel:ingot"},
		{"bronze:ingot", "steel:ingot", "bronze:ingot"},
	},
})

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	if not player then
		return
	end
	local meta = minetest.get_meta(pos)
	if not meta then
		return
	end
	local name = player:get_player_name()
	if name == meta:get_string("owner") then
		return
	end

	local inv = meta:get_inventory()
	local overflow = inv:add_item("mailbox", stack)
	inv:set_list("send", {})
	if overflow:get_name() == "" then
	elseif overflow then
		pos.y = pos.y + 1
		minetest.add_item(pos, overflow)
		minetest.chat_send_player(name, "Mailbox is full!")
	end
end

local function on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	if not clicker then
		return
	end
	local meta = minetest.get_meta(pos)
	if not meta then
		return
	end
	local inv = meta:get_inventory()
	local spos = minetest.pos_to_string(pos):sub(2, -2)
	local name = clicker:get_player_name()
	local owner = meta:get_string("owner")
	if owner ~= name then
		minetest.show_formspec(name, "mailbox:send",
			"size[8,5.667;]" ..
			forms.exit_button() ..
			"label[0,0;Send " .. owner .. " some mail!]" ..
			"list[nodemeta:" .. spos .. ";send;3.5,0.667;1,1]" ..
			"list[current_player;main;0,1.9;8,1]" ..
			"list[current_player;main;0,3;8,3;8]" ..
			"listring[nodemeta:" .. spos .. ";send]" ..
			"listring[current_player;main]" ..
			forms.get_hotbar_bg(0, 1.9) ..
		"")
		return
	end
	local selected = "false"
	if minetest.get_node(pos).name == "mailbox:letterbox" then
		selected = "true"
	end
	minetest.show_formspec(name, "mailbox:mailbox_" .. spos,
		"size[8,9.334]" ..
		"checkbox[0,0;books_only;Only allow written books;" .. selected .. "]" ..
		"list[nodemeta:" .. spos .. ";mailbox;0,1;8,4;]" ..
		"list[current_player;main;0,5.5;8,1;]" ..
		"list[current_player;main;0,6.6;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";mailbox]" ..
		"listring[current_player;main]" ..
		forms.get_hotbar_bg(0, 5.5) ..
	"")
end

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	local player_name = player:get_player_name()
	local inv = meta:get_inventory()
	return inv:is_empty("mailbox") and
			player and (player_name == owner or
			protector.can_interact_with_node(player, pos))
end

minetest.register_node("mailbox:mailbox", {
	description = "Mailbox",
	tiles = {
		"mailbox_top.png",
		"mailbox_botton.png",
		"mailbox_side.png",
		"mailbox_side.png",
		"mailbox_logo.png",
		"mailbox_logo.png",
	},
	paramtype2 = "facedir",
	on_rotate = screwdriver.rotate_simple,
	sounds = music.sounds.material.metal,
	groups = {cracky = 2},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		if not meta then
			return
		end
		local name = placer:get_player_name()
		meta:set_string("owner", name)
		meta:set_string("infotext", name .. "'s Mailbox")
		local inv = meta:get_inventory()
		if not inv then
			return
		end
		inv:set_size("mailbox", 8 * 4)
		inv:set_size("send", 1)
	end,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
})

minetest.register_node("mailbox:letterbox", {
	description = "Letterbox (you hacker you!)",
	tiles = {
		"mailbox_letterbox_top.png", "mailbox_letterbox_bottom.png",
		"mailbox_letterbox_side.png", "mailbox_letterbox_side.png",
		"mailbox_letterbox.png", "mailbox_letterbox.png",
	},
	groups = {cracky = 2},
	on_rotate = screwdriver.rotate_simple,
	sounds = music.sounds.material.metal,
	paramtype2 = "facedir",
	drop = "mailbox:mailbox",
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	on_metadata_inventory_put = on_metadata_inventory_put,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.get_node(pos).name == "mailbox:letterbox" and
				stack:get_name() ~= "books:book_written" then
			minetest.chat_send_player(player:get_player_name(),
					"This mailbox accepts only written books!")
			return 0
		end
		return 1
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname:sub(1, 16) ~= "mailbox:mailbox_" then
		return
	end

	if fields.books_only then
		local pos = minetest.string_to_pos(formname:sub(17))
		local node = minetest.get_node(pos)
		if node.name == "mailbox:mailbox" then
			node.name = "mailbox:letterbox"
			minetest.swap_node(pos, node)
		else
			node.name = "mailbox:mailbox"
			minetest.swap_node(pos, node)
		end
	end
end)

print("loaded mailbox")

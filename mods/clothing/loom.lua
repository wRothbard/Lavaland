minetest.register_node("clothing:loom", {
	description = "Loom",
	tiles = {
		"clothing_loom_top.png",
		"clothing_loom_bottom.png",
		"clothing_loom_side2.png",
		"clothing_loom_side1.png",
		"clothing_loom_front.png",
		"clothing_loom_front.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.1875}, -- NodeBox1
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.1875}, -- NodeBox3
			{-0.375, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox4
			{-0.5, 0, -0.125, 0.5, 0.0625, 0.1875}, -- NodeBox5
			{-0.5, 0.3125, 0.1875, 0.5, 0.5, 0.25}, -- NodeBox6
			{-0.5, 0.3125, -0.1875, 0.5, 0.5, -0.125}, -- NodeBox7
			{-0.375, -0.1875, -0.5, -0.3125, -0.125, 0.5}, -- NodeBox8
			{0.3125, -0.1875, -0.5, 0.375, -0.125, 0.5}, -- NodeBox9
			{-0.4375, -0.1875, -0.5, 0.4375, -0.125, -0.4375}, -- NodeBox10
			{-0.4375, -0.1875, 0.4375, 0.4375, -0.125, 0.5}, -- NodeBox11
			{-0.375, -0.5, 0.375, -0.3125, -0.125, 0.4375}, -- NodeBox12
			{0.3125, -0.5, 0.375, 0.375, -0.125, 0.4375}, -- NodeBox13
			{-0.375, -0.5, -0.4375, -0.3125, -0.125, -0.375}, -- NodeBox14
			{0.3125, -0.5, -0.4375, 0.375, -0.125, -0.375}, -- NodeBox15
			{-0.3125, -0.4375, -0.25, 0.3125, 0, 0.25}, -- NodeBox16
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.5,0.5}
		},
	},
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
			"size[8,8;]" ..
			forms.exit_button() ..
			"label[1,0.35;Input Wool]" ..
			"list[current_name;input;1,1;1,1;]" ..
			"item_image_button[2,1;1,1;clothing:hat_grey;hat; ]" ..
			"item_image_button[3,1;1,1;clothing:shirt_grey;shirt; ]" ..
			"item_image_button[4,1;1,1;clothing:pants_grey;pants; ]" ..
			"item_image_button[5,1;1,1;clothing:cape_grey;cape; ]" ..
			"label[6,2;Output]" ..
			"list[current_name;output;6,1;1,1;]" ..
			"list[current_player;main;0,4;8,1;]" ..
			forms.get_hotbar_bg(0, 4) ..
			"list[current_player;main;0,5.2;8,3;8]" ..
			"listring[current_player;main]" ..
			"listring[current_name;input]" ..
			"listring[current_player;main]" ..
			"listring[current_name;output]" ..
			"listring[current_player;main]" ..
		"")
		meta:set_string("infotext", "Loom")
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("output", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("input") or not inv:is_empty("output") then
			return false
		end
		return true
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("input") then
			return
		end
		local output = nil
		local qty = nil

		if fields["hat"] then
			output = "clothing:hat_"
			qty = "1"
		elseif fields["shirt"] then
			output = "clothing:shirt_"
			qty = "1"
		elseif fields["pants"] then
			output = "clothing:pants_"
			qty = "1"
		elseif fields["cape"] then
			output = "clothing:cape_"
			qty = "1"
		end

		if output and qty then
			local inputstack = inv:get_stack("input", 1)
			local outputstack = inv:get_stack("output", 1)
			local woolcol = inputstack:get_name()
			if woolcol then
				local color = woolcol:gsub("wool:", "")
				local stack = output..color.." "..qty
				if minetest.registered_items[output..color] and
						inv:room_for_item("output", stack) then
					inv:add_item("output", stack)
					inputstack:take_item()
					inv:set_stack("input", 1, inputstack)
				end
			end
		end
	end,
})

--Craft

minetest.register_craft({
	output = "clothing:loom",
	recipe = {
		{"group:stick", "group:wood", "group:stick"},
		{"group:stick", "group:wood", "group:stick"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

minetest.register_node("bones:bones", {
	description = "Bones",
	tiles = {
		"bones_top.png^[transform2",
		"bones_bottom.png",
		"bones_side.png",
		"bones_side.png",
		"bones_rear.png",
		"bones_front.png"
	},
	paramtype2 = "facedir",
	groups = {bones = 1, dig_immediate = 3},
	sounds = music.sounds.nodes.bones,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
		meta:set_string("formspec", "size[8,9]" ..
				"list[context;main;0,0;8,4]" ..
				"list[current_player;main;0,5;8,4]" ..
				"listring[]")
	end,
	on_dig = function(pos, node, digger)
		local t = {"bones:bone", "bones:bone", "bones:skull"}
		local inv = minetest.get_meta(pos):get_inventory()
		for k, v in pairs(inv:get_list("main")) do
			local n = v:get_name()
			if n ~= "" then
				t[#t + 1] = n
			end
		end
		inventory.throw_inventory(pos, t)
		minetest.set_node(pos, {name = "air"})
	end,
})

minetest.register_craftitem("bones:bone", {
	description = "Bone",
	inventory_image = "bones_bone.png",
})

minetest.register_craftitem("bones:skull", {
	description = "Skull",
	inventory_image = "bones_skull.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "bones:bones",
	recipe = {"bones:bone", "bones:skull"},
})

print("loaded bones")

local rand = math.random

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
	groups = {oddly_breakable_by_hand = 2, cracky = 3, crumbly = 1},
	drop = {
		max_items = 2,
		items = {
			{rarity = 2, items = {"bones:bone"}},
			{rarity = 3, items = {"bones:skull"}},
			{rarity = 1, items = {"bones:bones"}},
		},
	},
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
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		for k, v in pairs(oldmetadata.inventory.main) do
			local n = v:get_name()
			if n ~= "" then
				local obj = minetest.add_item(pos, n)
				if obj then
					obj:get_luaentity().collect = true
					obj:set_acceleration({x = 0, y = -10, z = 0})
					obj:set_velocity({x = rand(-2, 2),
							y = rand(1, 4),
							z = rand(-2, 2)})
				end
			end
		end
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

print("loaded bones")

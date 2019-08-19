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
	on_timer = function(pos, elapsed)
		local timer = minetest.get_node_timer(pos)
		timer:set(elapsed, elapsed + 0.1)
		if timer:get_elapsed() > 666 then
			minetest.dig_node(pos)
		else
			return 
		end
	end,
})

minetest.register_abm({
	nodenames = {"bones:bones"},
	interval = 60,
	chance = 100,
	catch_up = false,
	action = function(pos, node)
		local timer = minetest.get_node_timer(pos)
		if timer and not timer:is_started() then
			timer:start(1.0)
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

minetest.register_craft({
	type = "shapeless",
	output = "bones:bones",
	recipe = {"bones:bone", "bones:skull"},
})

print("loaded bones")

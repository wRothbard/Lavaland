local hive = {}
local honey_max = 16

function hive.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local formspec = [[ size[8,5.8;]
			label[0,0.2;Artificial Hive]
			image[7,0;1,1;hive_bee.png]
			image[6,0;1,1;hive_layout.png]
			list[context;honey;6,0;1,1;]
			list[current_player;main;0,1.75;8,1;]
			list[current_player;main;0,3;8,3;8]
			listring[current_player;main]
			listring[context;honey] ]] ..
			forms.get_hotbar_bg(0,1.75)

	meta:set_string("formspec", formspec)
	meta:set_string("infotext", "Artificial Hive")
	inv:set_size("honey", 1)

	local timer = minetest.get_node_timer(pos)
	timer:start(math.random(64, 128))
end

function hive.timer(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	local honeystack = inv:get_stack("honey", 1)
	local honey = honeystack:get_count()

	local radius = 4
	local minp = vector.add(pos, -radius)
	local maxp = vector.add(pos, radius)
	local flowers = minetest.find_nodes_in_area_under_air(minp, maxp, "group:flower")

	if minetest.get_node_light(flowers[math.random(#flowers)]) < 9 then
		return true
	end
	if #flowers > 2 and honey < honey_max then
		inv:add_item("honey", "hive:honey")
	elseif honey == honey_max then
		local timer = minetest.get_node_timer(pos)
		timer:stop()
		return true
	end

	return true
end

minetest.register_node("hive:hive", {
	description = "Artificial Hive",
	tiles = {"xdecor_hive_top.png", "xdecor_hive_top.png",
		 "xdecor_hive_side.png", "xdecor_hive_side.png",
		 "xdecor_hive_side.png", "xdecor_hive_front.png"},
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 1},
	sounds = music.sounds.nodes.fallback,
	paramtype2 = "facedir",
	on_construct = hive.construct,
	on_timer = hive.timer,

	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("honey")
	end,

	on_punch = function(_, _, puncher)
		puncher:set_hp(puncher:get_hp() - 2)
	end,

	allow_metadata_inventory_put = function()
		return 0
	end,

	on_metadata_inventory_take = function(pos, _, _, stack)
		if stack:get_count() == honey_max then
			local timer = minetest.get_node_timer(pos)
			timer:start(math.random(64, 128))
		end
	end
})

-- Craft items

minetest.register_craftitem("hive:honey", {
	description = "Honey",
	inventory_image = "xdecor_honey.png",
	wield_image = "xdecor_honey.png",
	on_use = minetest.item_eat(2),
	groups = {
		food_honey = 1,
		food_sugar = 1,
		flammable = 2,
		not_in_creative_inventory = 1,
	},
})

-- Recipes

minetest.register_craft({
	output = "hive:hive",
	recipe = {
		{"group:stick", "group:stick", "group:stick"},
		{"papyrus:paper", "papyrus:paper", "papyrus:paper"},
		{"group:stick", "group:stick", "group:stick"}
	}
})

print("loaded hive")

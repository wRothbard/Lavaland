local S = function(s)
	return s
end

local function on_use(itemstack, user, pointed_thing)
	local n = itemstack:get_name()
	if n:match("helmet") then
		n = 1
	elseif n:match("chestplate") then
		n = 2
	elseif n:match("leggings") then
		n = 3
	elseif n:match("boots") then
		n = 4
	elseif n:match("shield") then
		n = 5
	end
	local _, inv = armor:get_valid_player(user)
	local stack = inv:get_stack("armor", n)
	inventory.throw_inventory(user:get_pos(), {stack})
	armor:set_inventory_stack(user, n, itemstack)
	armor:set_player_armor(user)
	itemstack:take_item()
	return itemstack
end

-- Obsidian
armor:register_armor("3d_armor:helmet_obsidian", {
	description = S("Obsidian Helmet"),
	inventory_image = "3d_armor_inv_helmet_obsidian.png",
	groups = {armor_head = 1, armor_use = 800},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:chestplate_obsidian", {
	description = S("Obsidian Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_obsidian.png",
	groups = {armor_torso = 1, armor_use = 800},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:leggings_obsidian", {
	description = S("Obsidian Leggings"),
	inventory_image = "3d_armor_inv_leggings_obsidian.png",
	groups = {armor_legs = 1, armor_use = 800},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:boots_obsidian", {
	description = S("Obsidian Boots"),
	inventory_image = "3d_armor_inv_boots_obsidian.png",
	groups = {armor_feet = 1, armor_use = 800},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:shield_obsidian", {
	description = S("Obsidian Shield"),
	inventory_image = "shields_inv_shield_obsidian.png",
	groups = {armor_shield = 1, armor_use = 800},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	reciprocate_damage = true,
	on_use = on_use,
})

-- Steel
armor:register_armor("3d_armor:helmet_steel", {
	description = S("Steel Helmet"),
	inventory_image = "3d_armor_inv_helmet_steel.png",
	groups = {armor_head = 1, armor_use = 700},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:chestplate_steel", {
	description = S("Steel Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_steel.png",
	groups = {armor_torso = 1, armor_use = 700},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:leggings_steel", {
	description = S("Steel Leggings"),
	inventory_image = "3d_armor_inv_leggings_steel.png",
	groups = {armor_legs = 1, armor_use = 700},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:boots_steel", {
	description = S("Steel Boots"),
	inventory_image = "3d_armor_inv_boots_steel.png",
	groups = {armor_feet = 1, armor_use = 700},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:shield_steel", {
	description = S("Steel Shield"),
	inventory_image = "shields_inv_shield_steel.png",
	groups = {armor_shield = 1, armor_use = 700},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

-- Mese
armor:register_armor("3d_armor:helmet_mese", {
	description = S("Mese Helmet"),
	inventory_image = "3d_armor_inv_helmet_mese.png",
	groups = {armor_head = 1, armor_use = 300},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:chestplate_mese", {
	description = S("Mese Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_mese.png",
	groups = {armor_torso = 1, armor_use = 300},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:leggings_mese", {
	description = S("Mese Leggings"),
	inventory_image = "3d_armor_inv_leggings_mese.png",
	groups = {armor_legs = 1, armor_use = 300},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:boots_mese", {
	description = S("Mese Boots"),
	inventory_image = "3d_armor_inv_boots_mese.png",
	groups = {armor_feet = 1, armor_use = 300},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:shield_mese", {
	description = S("Mese Shield"),
	inventory_image = "shields_inv_shield_gold.png",
	groups = {armor_shield = 1, armor_use = 300},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumbly = 3, level = 2},
	on_use = on_use,
})

-- Bronze
armor:register_armor("3d_armor:helmet_bronze", {
	description = S("Bronze Helmet"),
	inventory_image = "3d_armor_inv_helmet_bronze.png",
	groups = {armor_head = 1, armor_use = 600},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 3, snappy = 2, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:chestplate_bronze", {
	description = S("Bronze Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_bronze.png",
	groups = {armor_torso = 1, armor_use = 600},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 3, snappy = 2, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:leggings_bronze", {
	description = S("Bronze Leggings"),
	inventory_image = "3d_armor_inv_leggings_bronze.png",
	groups = {armor_legs = 1, armor_use = 600},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 3, snappy = 2, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:boots_bronze", {
	description = S("Bronze Boots"),
	inventory_image = "3d_armor_inv_boots_bronze.png",
	groups = {armor_feet = 1, armor_use = 600},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 3, snappy = 2, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

armor:register_armor("3d_armor:shield_bronze", {
	description = S("Bronze Shield"),
	inventory_image = "shields_inv_shield_bronze.png",
	groups = {armor_shield = 1, armor_use = 600},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 2},
	on_use = on_use,
})

-- Diamond
armor:register_armor("3d_armor:helmet_diamond", {
	description = S("Diamond Helmet"),
	inventory_image = "3d_armor_inv_helmet_diamond.png",
	groups = {armor_head = 1, armor_use = 100},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 2, snappy = 1, choppy = 1, level = 3},
	on_use = on_use,
})

armor:register_armor("3d_armor:chestplate_diamond", {
	description = S("Diamond Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_diamond.png",
	groups = {armor_torso = 1, armor_use = 100},
	armor_groups = {fleshy = 20},
	damage_groups = {cracky = 2, snappy = 1, choppy = 1, level = 3},
	on_use = on_use,
})

armor:register_armor("3d_armor:leggings_diamond", {
	description = S("Diamond Leggings"),
	inventory_image = "3d_armor_inv_leggings_diamond.png",
	groups = {armor_legs = 1, armor_use = 100},
	armor_groups = {fleshy = 20},
	damage_groups = {cracky = 2, snappy = 1, choppy = 1, level = 3},
	on_use = on_use,
})

armor:register_armor("3d_armor:boots_diamond", {
	description = S("Diamond Boots"),
	inventory_image = "3d_armor_inv_boots_diamond.png",
	groups = {armor_feet = 1, armor_use = 100},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 2, snappy = 1, choppy = 1, level = 3},
	on_use = on_use,
})

armor:register_armor("3d_armor:shield_diamond", {
	description = S("Diamond Shield"),
	inventory_image = "shields_inv_shield_diamond.png",
	groups = {armor_shield = 1, armor_use = 100},
	armor_groups = {fleshy = 15},
	damage_groups = {cracky = 2, snappy = 1, choppy = 1, level = 3},
	on_use = on_use,
})

for k, v in pairs(armor.materials) do
	minetest.register_craft({
		output = "3d_armor:helmet_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "3d_armor:chestplate_"..k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:leggings_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:boots_"..k,
		recipe = {
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:shield_"..k,
		recipe = {
			{v, v, v},
			{v, v, v},
			{"", v, ""},
		},
	})
end

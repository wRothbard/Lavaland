local S = function(s)
	return s
end

-- Obsidian
armor:register_armor("3d_armor:helmet_obsidian", {
	description = "Obsidian Helmet",
	inventory_image = "3d_armor_inv_helmet_obsidian.png",
	groups = {armor_head = 1, armor_use = 800},
	armor_groups = {fleshy = 10},
	damage_groups = {cracky = 1, snappy = 2, choppy = 2, crumly = 3, level = 2},
})
armor:register_armor("3d_armor:chestplate_obsidian", {
	description = S("Obsidian Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_obsidian.png",
	groups = {armor_torso=1, armor_use=800},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:leggings_obsidian", {
	description = S("Obsidian Leggings"),
	inventory_image = "3d_armor_inv_leggings_obsidian.png",
	groups = {armor_legs=1, armor_use=800},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:boots_obsidian", {
	description = S("Obsidian Boots"),
	inventory_image = "3d_armor_inv_boots_obsidian.png",
	groups = {armor_feet=1, armor_use=800},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:shield_obsidian", {
	description = ("Obsidian Shield"),
	inventory_image = "shields_inv_shield_obsidian.png",
	groups = {armor_shield=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	reciprocate_damage = true,
})

-- Steel
armor:register_armor("3d_armor:helmet_steel", {
	description = S("Steel Helmet"),
	inventory_image = "3d_armor_inv_helmet_steel.png",
	groups = {armor_head=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})
armor:register_armor("3d_armor:chestplate_steel", {
	description = S("Steel Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_steel.png",
	groups = {armor_torso=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})
armor:register_armor("3d_armor:leggings_steel", {
	description = S("Steel Leggings"),
	inventory_image = "3d_armor_inv_leggings_steel.png",
	groups = {armor_legs=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})
armor:register_armor("3d_armor:boots_steel", {
	description = S("Steel Boots"),
	inventory_image = "3d_armor_inv_boots_steel.png",
	groups = {armor_feet=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})
armor:register_armor("3d_armor:shield_steel", {
	description = ("Steel Shield"),
	inventory_image = "shields_inv_shield_steel.png",
	groups = {armor_shield=1, armor_heal=0, armor_use=700},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	reciprocate_damage = true,
})

if armor.materials.bronze then
	armor:register_armor("3d_armor:helmet_bronze", {
		description = S("Bronze Helmet"),
		inventory_image = "3d_armor_inv_helmet_bronze.png",
		groups = {armor_head=1, armor_heal=6, armor_use=600},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_bronze", {
		description = S("Bronze Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_bronze.png",
		groups = {armor_torso=1, armor_heal=6, armor_use=600},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_bronze", {
		description = S("Bronze Leggings"),
		inventory_image = "3d_armor_inv_leggings_bronze.png",
		groups = {armor_legs=1, armor_heal=6, armor_use=600},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_bronze", {
		description = S("Bronze Boots"),
		inventory_image = "3d_armor_inv_boots_bronze.png",
		groups = {armor_feet=1, armor_heal=6, armor_use=600},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:shield_bronze", {
		description = S("Bronze Shield"),
		inventory_image = "shields_inv_shield_bronze.png",
		groups = {armor_shield=1, armor_heal=6, armor_use=600},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
		reciprocate_damage = true,
	})
end

if armor.materials.diamond then
	armor:register_armor("3d_armor:helmet_diamond", {
		description = S("Diamond Helmet"),
		inventory_image = "3d_armor_inv_helmet_diamond.png",
		groups = {armor_head=1, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	})
	armor:register_armor("3d_armor:chestplate_diamond", {
		description = S("Diamond Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_diamond.png",
		groups = {armor_torso=1, armor_use=100},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	})
	armor:register_armor("3d_armor:leggings_diamond", {
		description = S("Diamond Leggings"),
		inventory_image = "3d_armor_inv_leggings_diamond.png",
		groups = {armor_legs=1, armor_use=100},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	})
	armor:register_armor("3d_armor:boots_diamond", {
		description = S("Diamond Boots"),
		inventory_image = "3d_armor_inv_boots_diamond.png",
		groups = {armor_feet=1, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	})
	armor:register_armor("3d_armor:shield_diamond", {
		description = S("Diamond Shield"),
		inventory_image = "shields_inv_shield_diamond.png",
		groups = {armor_shield=1, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
		reciprocate_damage = true,
	})
end

-- Mese
armor:register_armor("3d_armor:helmet_mese", {
	description = S("Mese Helmet"),
	inventory_image = "3d_armor_inv_helmet_mese.png",
	groups = {armor_head=1, armor_use=300},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:chestplate_mese", {
	description = S("Mese Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_mese.png",
	groups = {armor_torso=1, armor_use=300},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:leggings_mese", {
	description = S("Mese Leggings"),
	inventory_image = "3d_armor_inv_leggings_mese.png",
	groups = {armor_legs=1, armor_use=300},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:boots_mese", {
	description = S("Mese Boots"),
	inventory_image = "3d_armor_inv_boots_mese.png",
	groups = {armor_feet=1, armor_use=300},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})
armor:register_armor("3d_armor:shield_mese", {
		description = S("Mese Shield"),
		inventory_image = "shields_inv_shield_gold.png",
		groups = {armor_shield=1, armor_heal=6, armor_use=300},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
		reciprocate_damage = true,
	})

if armor.materials.gold then
	armor:register_armor("3d_armor:helmet_gold", {
		description = S("Gold Helmet"),
		inventory_image = "3d_armor_inv_helmet_gold.png",
		groups = {armor_head=1, armor_heal=6, armor_use=400},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
	})
	armor:register_armor("3d_armor:chestplate_gold", {
		description = S("Gold Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_gold.png",
		groups = {armor_torso=1, armor_heal=6, armor_use=400},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
	})
	armor:register_armor("3d_armor:leggings_gold", {
		description = S("Gold Leggings"),
		inventory_image = "3d_armor_inv_leggings_gold.png",
		groups = {armor_legs=1, armor_heal=6, armor_use=400},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
	})
	armor:register_armor("3d_armor:boots_gold", {
		description = S("Gold Boots"),
		inventory_image = "3d_armor_inv_boots_gold.png",
		groups = {armor_feet=1, armor_heal=6, armor_use=400},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
	})
	armor:register_armor("3d_armor:shield_gold", {
		description = S("Gold Shield"),
		inventory_image = "shields_inv_shield_gold.png",
		groups = {armor_shield=1, armor_heal=6, armor_use=400},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
		reciprocate_damage = true,
	})
end
--[[
if armor.materials.mithril then
	armor:register_armor("3d_armor:helmet_mithril", {
		description = S("Mithril Helmet"),
		inventory_image = "3d_armor_inv_helmet_mithril.png",
		groups = {armor_head=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:chestplate_mithril", {
		description = S("Mithril Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_mithril.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:leggings_mithril", {
		description = S("Mithril Leggings"),
		inventory_image = "3d_armor_inv_leggings_mithril.png",
		groups = {armor_legs=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:boots_mithril", {
		description = S("Mithril Boots"),
		inventory_image = "3d_armor_inv_boots_mithril.png",
		groups = {armor_feet=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("shields:shield_mithril", {
		description = S("Mithril Shield"),
		inventory_image = "shields_inv_shield_mithril.png",
		groups = {armor_shield=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
		reciprocate_damage = true,
	})
end
if armor.materials.crystal then
	armor:register_armor("3d_armor:helmet_crystal", {
		description = S("Crystal Helmet"),
		inventory_image = "3d_armor_inv_helmet_crystal.png",
		groups = {armor_head=1, armor_heal=12, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:chestplate_crystal", {
		description = S("Crystal Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_crystal.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:leggings_crystal", {
		description = S("Crystal Leggings"),
		inventory_image = "3d_armor_inv_leggings_crystal.png",
		groups = {armor_legs=1, armor_heal=12, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("3d_armor:boots_crystal", {
		description = S("Crystal Boots"),
		inventory_image = "3d_armor_inv_boots_crystal.png",
		groups = {armor_feet=1, armor_heal=12, armor_use=100, physics_speed=1,
				physics_jump=0.5, armor_fire=1},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
	})
	armor:register_armor("shields:shield_crystal", {
		description = S("Crystal Shield"),
		inventory_image = "shields_inv_shield_crystal.png",
		groups = {armor_shield=1, armor_heal=12, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
		reciprocate_damage = true,
	})
end
--]]
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

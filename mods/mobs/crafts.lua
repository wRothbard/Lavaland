local S = mobs.intllib

minetest.register_craftitem("mobs:rotten_flesh", {
	description = "Rotten Flesh",
	inventory_image = "mobs_rotten_flesh.png",
	on_use = minetest.item_eat(-2),
})
minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:rotten_flesh",
	cooktime = 20,
})

local hairball_items = {
	"trees:stick", "coal:lump", "default:dry_shrub", "flowers:rose",
	"mobs:rat", "grass:grass_1", "farming:seed_wheat", "dye:green",
	"farming:seed_cotton", "gravel:flint", "trees:sapling", "dye:white",
	"default:clay_lump", "papyrus:paper", "default:dry_grass_1", "dye:red",
	"farming:string", "default:acacia_bush_sapling",
	"default:bush_sapling", "copper:lump", "iron:lump",
	"dye:black", "dye:brown", "obsidian:shard", "default:tin_lump"
}
minetest.register_craftitem("mobs:hairball", {
	description = S("Lucky Hairball"),
	inventory_image = "farming_string.png^(farming_string.png^[transformFYR90)",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:get_pos()
		local dir = user:get_look_dir()
		local newpos = {x = pos.x + dir.x, y = pos.y + dir.y + 1.5, z = pos.z + dir.z}
		local item = hairball_items[math.random(1, #hairball_items)]
		if item ~= "" then
			minetest.add_item(newpos, {name = item})
		end
		minetest.sound_play("default_place_node_hard", {
			pos = newpos,
			gain = 0.8,
		})
		itemstack:take_item()
		return itemstack
	end,
})

-- name tag
minetest.register_craftitem("mobs:nametag", {
	description = S("Name Tag"),
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	type = "shapeless",
	output = "mobs:nametag",
	recipe = {"paper:paper", "dye:black", "farming:string"},
})

-- leather
minetest.register_craftitem("mobs:leather", {
	description = S("Leather"),
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2},
	on_use = minetest.item_eat(1),
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = S("Raw Meat"),
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2},
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = S("Meat"),
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 10,
})

-- shears (right click to shear animal)
minetest.register_tool("mobs:shears", {
	description = S("Steel Shears"),
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2, tool = 1, trade_value = 3,},
})
minetest.register_craft({
	output = "mobs:shears",
	recipe = {
		{"", "steel:ingot", ""},
		{"", "group:stick", "steel:ingot"},
	}
})

-- items that can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "mobs:nametag",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:leather",
	burntime = 4,
})

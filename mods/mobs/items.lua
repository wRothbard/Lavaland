local S = mobs.intllib

-- Hairball
local hairball_items = {
	"trees:stick", "coal:lump",
	"grass:dry_shrub",
	"flowers:rose",
	"mobs:rat",
	"grass:grass_1",
	"farming:seed_wheat",
	"dye:green",
	"farming:seed_cotton",
	"gravel:flint",
	"trees:sapling",
	"dye:white",
	--"default:clay_lump",
	"papyrus:papyrus",
	"papyrus:paper",
	--"default:dry_grass_1",
	"dye:red",
	"farming:string",
	--"default:acacia_bush_sapling",
	--"default:bush_sapling",
	"copper:lump",
	"iron:lump",
	"dye:black",
	"dye:brown",
	"obsidian:shard",
	--"default:tin_lump",
	"skins:shadowzone_by_crazyginger72",
	"skins:pirate_girl_by_misty",
	"skins:thewillyrex_by_edwar_masterchieft",
	"skins:c55_by_jordach",
	"skins:summer_by_lizzie",
	"skins:sam_mese_tee_by_oochainlynxoo",
	"skins:jayne_by_andromeda",
	"skins:cheapie_by_lovehart",
	"skins:alien_by_jmf",
	"skins:worker_by_krock",
	"skins:calinou_by_calinou",
	"skins:ladyvioletkitty_by_lordphoenixmh",
	"skins:stef325_by_stef325",
	"skins:ruby",
	"skins:marie",
	"water:ice",
	"tools:shears",
	"flowers:waterlily",
	"craftguide:book",
}

minetest.register_craftitem("mobs:hairball", {
	description = S("Lucky Hairball"),
	groups = {trade_value = 15, flammable = 1},
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

-- Nametag
minetest.register_craftitem("mobs:nametag", {
	description = S("Name Tag"),
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2, trade_value = 3},
})

minetest.register_craft({
	type = "shapeless",
	output = "mobs:nametag",
	recipe = {"paper:paper", "dye:black", "farming:string"},
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:nametag",
	burntime = 3,
})

-- Leather
minetest.register_craftitem("mobs:leather", {
	description = S("Leather"),
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2, trade_value = 2},
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:leather",
	burntime = 4,
})

-- Raw meat
minetest.register_craftitem("mobs:rotten_flesh", {
	description = "Rotten Flesh",
	inventory_image = "mobs_rotten_flesh.png",
	groups = {poison = 5, flammable = 1, trade_value = 2},
	on_use = minetest.item_eat(-10),
})

minetest.register_craftitem("mobs:meat_raw", {
	description = S("Raw Meat"),
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2, trade_value = 2},
})

minetest.register_craftitem("mobs:meat", {
	description = S("Meat"),
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2, trade_value = 5},
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 10,
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:rotten_flesh",
	cooktime = 20,
})

minetest.register_alias("paper:paper", "papyrus:paper")
minetest.register_craftitem("papyrus:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
	groups = {flammable = 3},
})

minetest.register_craft({
	output = "papyrus:paper",
	recipe = {
		{"papyrus:papyrus", "papyrus:papyrus", "papyrus:papyrus"},
	}
})

minetest.register_node("papyrus:papyrus", {
	description = "Papyrus",
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
	groups = {snappy = 3, flammable = 2},
	sounds = music.sounds.nodes.leaves,

	after_dig_node = function(pos, node, metadata, digger)
		map.dig_up(pos, node, digger)
	end,
})

local function grow_papyrus(pos, node)
	pos.y = pos.y - 1
	local name = minetest.get_node(pos).name
	if name ~= "dirt:grass" and name ~= "dirt:dirt" then
		return
	end
	if not minetest.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "papyrus:papyrus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if minetest.get_node_light(pos) < 13 then
		return
	end
	minetest.set_node(pos, {name = "papyrus:papyrus"})
	return true
end

minetest.register_abm({
	label = "Grow papyrus",
	nodenames = {"papyrus:papyrus"},
	neighbors = {"dirt:dirt", "dirt:grass"},
	interval = 14,
	chance = 71,
	action = function(...)
		grow_papyrus(...)
	end
})

print("loaded papyrus")

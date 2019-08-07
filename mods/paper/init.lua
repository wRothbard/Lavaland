minetest.register_craftitem("paper:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
	groups = {flammable = 3},
})

minetest.register_craft({
	output = "default:paper",
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"},
	}
})

print("paper loaded")

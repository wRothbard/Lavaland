farming.register_hoe(":farming:hoe_wood", {
	description = "Wooden Hoe",
	inventory_image = "farming_tool_woodhoe.png",
	max_uses = 20,
	material = "group:wood",
	groups = {hoe = 1, flammable = 2, trade_value = 3},
})

farming.register_hoe(":farming:hoe_steel", {
	description = "Wooden Hoe",
	inventory_image = "farming_tool_steelhoe.png",
	max_uses = 100,
	material = "steel:ingot",
	groups = {hoe = 1, trade_value = 4},
})

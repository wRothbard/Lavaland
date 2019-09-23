minetest.register_tool("staves:teleportation", {
	description = "Staff of Teleportation",
	inventory_image = "default_stick.png",
})

minetest.register_entity("staves:teleportation_projectile", {
	textures = {"default_stick.png"},
})

minetest.register_tool("staves:destruction", {
	description = "Staff of Destruction",
	inventory_image = "default_stick.png",
})

minetest.register_entity("staves:destruction_projectile", {
})

print("loaded staves")

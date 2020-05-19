if minetest.get_modpath("hopper") then
	hopper:add_container({
		{"top", "chests:chest", "main"},
		{"bottom", "chests:chest", "main"},
		{"side", "chests:chest", "main"},

		{"top", "furnace:furnace", "dst"},
		{"bottom", "furnace:furnace", "src"},
		{"side", "furnace:furnace", "fuel"},

		{"top", "furnace:furnace_active", "dst"},
		{"bottom", "furnace:furnace_active", "src"},
		{"side", "furnace:furnace_active", "fuel"},

		{"bottom", "chests:chest_locked", "main"},
		{"side", "chests:chest_locked", "main"},

		{"top", "chests:chest_open", "main"},
		{"bottom", "chests:chest_open", "main"},
		{"side", "chests:chest_open", "main"},

		{"bottom", "chests:chest_locked_open", "main"},
		{"side", "chests:chest_locked_open", "main"},

		{"void", "chests:chest", "main"},
		{"void", "chests:chest_open", "main"},
		{"void", "furnace:furnace", "src"},

		{"top", "pipeworks:autocrafter", "dst"},
		{"bottom", "pipeworks:autocrafter", "src"},
		{"side", "pipeworks:autocrafter", "dst"},
		{"void", "pipeworks:autocrafter", "dst"},
	})
end

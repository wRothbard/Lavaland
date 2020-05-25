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
		{"side", "pipeworks:autocrafter", "src"},
		{"void", "pipeworks:autocrafter", "src"},
	})
end

local stairs_mod = minetest.get_modpath("stairs")
local stairs_redo = stairs_mod and stairs.mod

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

if stairs_redo then

	if minetest.get_modpath("birthstones") then
		local stones = { "alexandrite", "amethyst", "aquamarine", "diamond", "emerald", "garnet",
			"opal", "peridot", "ruby", "sapphire", "topaz", "zircon"}
		for _, stone in ipairs(stones) do
			local name = firstToUpper(stone)
			stairs.register_all(stone.."block", "birthstones:"..stone.."block",
				{ cracky = 1, level = 3 },
				{ "birthstones_"..stone.."_block.png" },  -- XXX later on would be nice to export birthstones.get_block_tiles()
				name,
				stairs.stone)
		end
	end

	-- lavaland emeralds
	if minetest.get_modpath("emerald") then
		stairs.register_all("emeraldblock", "emerald:block",
			{ cracky = 2 },
			{ "emerald_block.png" },
			"Emerald",
			stairs.metal)
	end
end

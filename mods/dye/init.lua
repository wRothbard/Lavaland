dye = {}

-- Make dye names and descriptions available globally

dye.dyes = {
	{"white",      "White",		"#d2d2d2"},
	{"grey",       "Grey",		"#7f7f7f"},
	{"dark_grey",  "Dark Grey",	"#383838"},
	{"black",      "Black",		"#222222"},
	{"violet",     "Violet",	"#410473"},
	{"blue",       "Blue",		"#00438a"},
	{"cyan",       "Cyan",		"#007f87"},
	{"dark_green", "Dark Green",	"#216600"},
	{"green",      "Green",		"#59d11c"},
	{"yellow",     "Yellow",	"#fedc0e"},
	{"brown",      "Brown",		"#552b00"},
	{"orange",     "Orange",	"#ca4812"},
	{"red",        "Red",		"#a21010"},
	{"magenta",    "Magenta",	"#c10266"},
	{"pink",       "Pink",		"#ff8d8d"},
}

-- Define items

for _, row in ipairs(dye.dyes) do
	local name = row[1]
	local description = row[2]
	local groups = {dye = 1, trade_value = 2}
	groups["color_" .. name] = 1

	minetest.register_craftitem("dye:" .. name, {
		inventory_image = "dye_" .. name .. ".png",
		description = description .. " Dye",
		groups = groups
	})

	minetest.register_craft({
		output = "dye:" .. name .. " 4",
		recipe = {
			{"group:flower,color_" .. name}
		},
	})
end

-- Manually add coal -> black dye

minetest.register_craft({
	output = "dye:black 4",
	recipe = {
		{"group:coal"}
	},
})

-- Manually add blueberries->violet dye

minetest.register_craft({
	output = "dye:violet 2",
	recipe = {
		{"default:blueberries"}
	},
})

-- Mix recipes

local dye_recipes = {
	-- src1, src2, dst
	-- RYB mixes
	{"red", "blue", "violet"}, -- "purple"
	{"yellow", "red", "orange"},
	{"yellow", "blue", "green"},
	-- RYB complementary mixes
	{"yellow", "violet", "dark_grey"},
	{"blue", "orange", "dark_grey"},
	-- CMY mixes - approximation
	{"cyan", "yellow", "green"},
	{"cyan", "magenta", "blue"},
	{"yellow", "magenta", "red"},
	-- other mixes that result in a color we have
	{"red", "green", "brown"},
	{"magenta", "blue", "violet"},
	{"green", "blue", "cyan"},
	{"pink", "violet", "magenta"},
	-- mixes with black
	{"white", "black", "grey"},
	{"grey", "black", "dark_grey"},
	{"green", "black", "dark_green"},
	{"orange", "black", "brown"},
	-- mixes with white
	{"white", "red", "pink"},
	{"white", "dark_grey", "grey"},
	{"white", "dark_green", "green"},
}

for _, mix in pairs(dye_recipes) do
	minetest.register_craft({
		type = "shapeless",
		output = "dye:" .. mix[3] .. " 2",
		recipe = {"dye:" .. mix[1], "dye:" .. mix[2]},
	})
end

print("loaded dye")

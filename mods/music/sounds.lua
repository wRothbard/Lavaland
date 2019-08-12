music.sounds = {
	material = {
		metal = {},
		stone = {},
		wood = {},
		water = {},
		glass = {},
		lava = {},
	},
	player = {
		breath = {},
		damage = {},
	},
	nodes = {
		fallback = {
			footstep = {
				name = "",
				gain = 1.0,
			},
			dug = {
				name = "default_dug_node",
				gain = 0.25,
			},
			place = {
				name = "default_place_node_hard",
				gain = 1.0,
			},
		},
		stone = {
			footstep = {
				name = "stone_footstep",
				gain = 0.3,
			},
			dig = {
				name = "stone_dig",
				gain = 0.5,
			},
			dug = {
				name = "stone_dug",
				gain = 0.9,
				pitch = 1.5,
			},
			place = {
				name = "stone_place",
				gain = 1.0,
			},
		},
		wood = {
			footstep = {
				name = "trees_wood_footstep",
				gain = 0.3,
			},
		},
		dirt = {
			footstep = {
				name = "dirt_footstep",
				gain = 0.4,
			},
			dug = {
				name = "dirt_footstep",
				gain = 1.0,
			},
			place = {
				name = "default_place_node",
				gain = 1.0,
			},
		},
	},
}

music.sounds.nodes["furnace"] = music.sounds.nodes.stone

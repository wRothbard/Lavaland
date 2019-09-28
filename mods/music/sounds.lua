music.sounds = {
	material = {
		metal = {
			footstep = {
				name = "default_metal_footstep",
				gain = 0.4,
			},
			dig = {
				name = "default_dig_metal",
				gain = 0.5,
			},
			dug = {
				name = "default_dug_metal",
				gain = 0.5,
			},
			place = {
				name = "default_place_node_metal",
				gain = 0.5,
			},
		},
		stone = {},
		wood = {
			footstep = {
				name = "trees_wood_footstep",
				gain = 0.3,
			},
			dug = {
				name = "trees_wood_footstep",
				gain = 1.0,
			},
		},
		water = {},
		glass = {
			footstep = {
				name = "glass_hard",
				gain = 1.0,
				pitch = 0.7,
				fade = 8.0,
			},
			dig = {
				name = "glass_hard",
			},
			dug = {
				name = "glass_glass",
			},
			place = {
				name = "glass_hard",
			},
		},
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
			dig = {
			},
			dug = {
				name = "default_dug_node",
				gain = 0.25,
			},
			place = {
				name = "default_place_node_hard",
				gain = 1.0,
			},
			place_failed = {
			},
			fall = {
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
				--pitch = 1.1,
			},
			place = {
				name = "stone_place",
				gain = 1.0,
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
				name = "nodes_place",
				gain = 1.0,
			},
		},
		wood = {
			footstep = {
				name = "trees_wood",
				gain = 0.34,
				pitch = 0.67,
			},
			dig = {
				name = "trees_wood",
				gain = 0.67,
			},
			dug = {
				name = "trees_wood_hard",
				gain = 0.69,
			},
			place = {
				name = "trees_wood_hard",
				gain = 0.72,
			},
		},
		leaves = {
			footstep = {
				name = "grass_footstep",
				gain = 0.45,
			},
			dug = {
				name = "grass_footstep",
				gain = 0.7,
			},
			place = {
				name = "grass_footstep",
				gain = 1.0,
			},
		},
		sand = {
			footstep = {
				name = "default_sand_footstep",
				gain = 0.12,
			},
			dug = {
				name = "default_sand_footstep",
				gain = 0.24,
			},
			place = {
				name = "default_place_node",
				gain = 1.0,
			},
		},
		bones = {
			footstep = {
				name = "bones_footstep",
				gain = 0.4,
			},
			dug = {
				name = "bones_footstep",
				gain = 1.0,
			},
			place = {
				name = "nodes_place",
				gain = 1.0,
			},
		},
		water = {
			footstep = {
				name = "water_footstep",
				gain = 0.2,
			},
		},
		obsidian = {
			footstep = {
				name = "obsidian_obsidian",
				gain = 0.67,
				pitch = 0.9,
			},
			dig = {
				name = "obsidian_obsidian",
				gain = 0.89,
				pitch = 0.7,
			},
			dug = {
				name = "obsidian_obsidian",
				gain = 0.89,
				pitch = 1.1,
			},
			place = {
				name = "obsidian_obsidian",
				gain = 0.99,
			},
		},
		plants = {
			place = {
				name = "nodes_place",
				gain = 0.25,
			},
			dug = {
				name = "dirt_footstep",
				gain = 0.2,
			},
			dig = {
				name = "",
				gain = 0,
			},
			footstep = {
				name = "dirt_footstep",
				gain = 0.4,
			},
		},
		mese = {
			footstep = {
				name = "mese_footstep",
				gain = 0.3
			},
			dig = {
				name = "mese_footstep",
				gain = 1.0
			},
			dug = {
				name = "mese_footstep",
				gain = 1.0
			},
		},
		lava = {
			footstep = {
				name = "water_cool_lava",
				gain = 0.24,
				pitch = 0.9,
				fade = 1.0,
			},
		},
	},
}

music.sounds.nodes["furnace"] = music.sounds.nodes.stone

-- Rat by PilzAdam

local S = mobs.intllib
mobs:register_mob("mobs:rat", {
	--stepheight = 0.6,
	type = "animal",
	passive = true,
	hp_min = 1,
	hp_max = 1,
	armor = 200,
	collisionbox = {-0.25, -1, -0.25, 0.25, -0.9, 0.25},
	visual = "mesh",
	mesh = "mobs_rat.b3d",
	textures = {
		{"mobs_rat.png"},
		{"mobs_rat2.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_rat",
	},
	walk_velocity = 1,
	--run_velocity = 2,
	runaway = false,
	--jump_height = 6,
	--jump = false,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
	},
	lava_damage = 4,
	on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 50, 90, 100, true, "mobs:rat")
	end,
})

mobs:register_egg("mobs:rat", S("Rat"), "mobs_rat_inventory.png", 0)

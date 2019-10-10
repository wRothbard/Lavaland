local S = mobs.intllib
-- Bunny by ExeterDad
mobs:register_mob("mobs:bunny", {
	--stepheight = 0.6,
	type = "animal",
	passive = true,
	reach = 1,
	hp_min = 6,
	hp_max = 6,
	armor = 100,
	collisionbox = {-0.268, -0.5, -0.268,  0.268, 0.167, 0.268},
	visual = "mesh",
	mesh = "mobs_bunny.b3d",
	drawtype = "front",
	textures = {
		{"mobs_bunny_grey.png"},
		{"mobs_bunny_brown.png"},
		--{"mobs_bunny_white.png"},
	},
	--sounds = {},
	makes_footstep_sound = false,
	walk_velocity = 1,
	run_velocity = 2,
	runaway = true,
	--runaway_from = {"player"},
	--jump = true,
	--jump_height = 6,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 2},
		{name = "mobs:leather", chance = 2, min = 1, max = 2},
	},
	lava_damage = 4,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 15,
		walk_start = 16,
		walk_end = 24,
		punch_start = 16,
		punch_end = 24,
	},
	follow = {"grass:grass_1", "farming:carrot"},
	--view_range = 8,
	--replace_rate = 10,
	--replace_what = {"farming:carrot_7", "farming:carrot_8", "farming_plus:carrot"},
	--replace_with = "air",
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 4, true, true) then
			return
		end
		if mobs:protect(self, clicker) then
			return
		end
		if mobs:capture_mob(self, clicker, 20, false, nil) then
			return
		end

		-- by right-clicking owner can switch between staying and walking
		if self.owner and self.owner == clicker:get_player_name() then
			if self.order ~= "stand" then
				self.order = "stand"
				self.state = "stand"
				self.object:set_velocity({x = 0, y = 0, z = 0})
				mobs:set_animation(self, "stand")
			else
				self.order = ""
				mobs:set_animation(self, "stoodup")
			end
		end
	end,
	attack_type = "dogfight",
	damage = 5,
})

mobs:register_egg("mobs:bunny", S("Bunny"), "mobs_bunny_inv.png", 1)

minetest.register_craft({
	type = "shapeless",
	recipe = {"mobs:bunny"},
	output = "mobs:leather 3",
})

minetest.register_craft({
	type = "shapeless",
	recipe = {"mobs:bunny_set"},
	output = "mobs:leather 3",
})

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
		{name = "mobs:leather", chance = 1, min = 0, max = 1},
	},
	water_damage = 1,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 2,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 15,
		walk_start = 16,
		walk_end = 24,
		punch_start = 16,
		punch_end = 24,
	},
	follow = {"default:grass_1", "default:grass_2", "default:grass_3", "default:grass_4", "default:grass_5",},
	--view_range = 8,
	--replace_rate = 10,
	--replace_what = {"farming:carrot_7", "farming:carrot_8", "farming_plus:carrot"},
	--replace_with = "air",
	--[[
	on_spawn = function(self)
		local pos = self.object:get_pos() ; pos.y = pos.y - 1
		-- white snowy bunny
		if minetest.find_node_near(pos, 1,
				{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then
			self.base_texture = {"mobs_bunny_white.png"}
			self.object:set_properties({textures = self.base_texture})
		-- brown desert bunny
		elseif minetest.find_node_near(pos, 1,
				{"default:desert_sand", "default:desert_stone"}) then
			self.base_texture = {"mobs_bunny_brown.png"}
			self.object:set_properties({textures = self.base_texture})
		-- grey stone bunny
		elseif minetest.find_node_near(pos, 1,
				{"default:stone", "default:gravel"}) then
			self.base_texture = {"mobs_bunny_grey.png"}
			self.object:set_properties({textures = self.base_texture})
		end
		return true -- run only once, false/nil runs every activation
	end,
	--]]
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 4, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 50, 50, 90, false, nil) then return end

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
mobs:register_egg("mobs:bunny", S("Bunny"), "mobs_bunny_inv.png", 0)

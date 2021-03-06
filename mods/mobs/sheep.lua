-- mobs/sheep.lua is part of Glitchtest
-- Copyright 2018 James Stevenson
-- GNU GPL 3

-- Sheep by PilzAdam, texture converted to minetest by AMMOnym from Summerfield pack
local S = mobs.intllib
local all_colours = {
	{"black",      S("Black"),      "#000000b0"},
	{"blue",       S("Blue"),       "#015dbb70"},
	{"brown",      S("Brown"),      "#663300a0"},
	{"cyan",       S("Cyan"),       "#01ffd870"},
	{"dark_green", S("Dark Green"), "#005b0770"},
	{"dark_grey",  S("Dark Grey"),  "#303030b0"},
	{"green",      S("Green"),      "#61ff0170"},
	{"grey",       S("Grey"),       "#5b5b5bb0"},
	{"magenta",    S("Magenta"),    "#ff05bb70"},
	{"orange",     S("Orange"),     "#ff840170"},
	{"pink",       S("Pink"),       "#ff65b570"},
	{"red",        S("Red"),        "#ff0000a0"},
	{"violet",     S("Violet"),     "#2000c970"},
	{"white",      S("White"),      "#abababc0"},
	{"yellow",     S("Yellow"),     "#e3ff0070"},
}

for _, col in ipairs(all_colours) do
	mobs:register_mob("mobs:sheep_"..col[1], {
		--stepheight = 0.6,
		type = "animal",
		passive = true,
		hp_min = 5,
		hp_max = 10,
		armor = 100,
		collisionbox = {-0.5, -1, -0.5, 0.5, 0.3, 0.5},
		visual = "mesh",
		mesh = "mobs_sheep.b3d",
		textures = {
			{"mobs_sheep_base.png^(mobs_sheep_wool.png^[colorize:" ..
					col[3] .. ")"},
		},
		gotten_texture = {"mobs_sheep_shaved.png"},
		gotten_mesh = "mobs_sheep_shaved.b3d",
		makes_footstep_sound = true,
		sounds = {
			gain = (math.random(60, 93) / 100 + math.random() / 11) / 3,
			distance = 24,
			random = "mobs_sheep",
			damage = "mobs_sheep",
			death = "mobs_sheep",
			war_cry = "mobs_sheep",
			attack = "mobs_sheep",
			shoot_attack = "mobs_sheep",
			fuse = "mobs_sheep",
			explode = "mobs_sheep",
		},
		walk_velocity = 1,
		run_velocity = 2,
		runaway = true,
		--jump = true,
		--jump_height = 6,
		pushable = true,
		drops = {
			{name = "mobs:meat_raw", chance = 1, min = 1, max = 2},
		},
		lava_damage = 5,
		glow = 1,
		animation = {
			speed_normal = 15,
			speed_run = 15,
			stand_start = 0,
			stand_end = 80,
			walk_start = 81,
			walk_end = 100,
		},
		follow = {"farming:wheat", "grass:grass_5"},
		--view_range = 8,
		--replace_rate = 10,
		--replace_what = {"default:grass_3", "default:grass_4", "default:grass_5", "farming:wheat_8"},
		--replace_with = "air",
		--replace_offset = -1,
		on_rightclick = function(self, clicker)
			-- Sound the alarm!
			if not self.clicked then
				local gain = math.random(60, 93) / 100 + math.random() / 11
				local pitch = 0.96 + math.random(1, 7) / 100 + math.random() / 11
				local sh = minetest.sound_play("mobs_sheep", {
					gain = gain,
					pitch = pitch,
					object = self.object,
					max_hear_distance = 128,
				})
				minetest.after(0.35, minetest.sound_fade, sh, -1, 0.0)
				self.clicked = true
			else
				self.clicked = false
			end
			--are we feeding?
			if mobs:feed_tame(self, clicker, 8, true, true) then
				--if full grow fuzz
				if self.gotten == false then
					self.object:set_properties({
						textures = {"mobs_sheep_base.png^(mobs_sheep_wool.png^[colorize:" .. col[3] .. ")"},
						mesh = "mobs_sheep.b3d",
					})
				end

				return
			end
			local item = clicker:get_wielded_item()
			local itemname = item:get_name()
			local name = clicker:get_player_name()
			--are we giving a haircut>
			if itemname == "tools:shears" then
				if self.gotten ~= false or self.child ~= false then
					return
				end
				self.gotten = true -- shaved
				local obj = minetest.add_item(
					self.object:get_pos(),
					ItemStack( "wool:" .. col[1] .. " " .. math.random(1, 3) )
				)
				if obj then
					obj:setvelocity({
						x = math.random(-1, 1),
						y = 5,
						z = math.random(-1, 1)
					})
				end
				item:add_wear(650) -- 100 uses
				clicker:set_wielded_item(item)
				self.object:set_properties({
					textures = {"mobs_sheep_shaved.png"},
					mesh = "mobs_sheep_shaved.b3d",
				})
				return
			end
			if itemname:find("dye:") then
				if self.gotten == false	and
						self.child == false and
						self.tamed == true and
						name == self.owner then
					local colr = string.split(itemname, ":")[2]
					for _, c in pairs(all_colours) do
						if c[1] == colr then
							local pos = self.object:get_pos()
							self.object:remove()
							local mob = minetest.add_entity(pos, "mobs:sheep_" .. colr)
							local ent = mob:get_luaentity()
							ent.owner = name
							ent.tamed = true
							item:take_item()
							clicker:set_wielded_item(item)
							break
						end
					end
				end
				return
			end
			-- protect mod with mobs:protector item
			if mobs:protect(self, clicker) then return end
			--are we capturing?
			if mobs:capture_mob(self, clicker, 20, false, nil) then return end
		end
	})
	mobs:register_egg("mobs:sheep_"..col[1], S("@1 Sheep", col[2]), "wool_"..col[1]..".png", 1)
end

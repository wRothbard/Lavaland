local cooldown = {}
local boom = {radius = 3}

minetest.register_tool("staves:teleportation", {
	description = "Staff of Teleportation",
	inventory_image = "default_stick.png",
})

minetest.register_entity("staves:fireball", {
	description = "Fireball",
	visual = "sprite",
	textures = {"mobs_fireball.png"},
	glow = 14,
	on_activate = function(self, staticdata, dtime_s)
		self.owner = staticdata or "singleplayer"
	end,
	on_step = function(self, dtime)
		local step = self.step or 0
		self.step = step + 1
		local pos = self.object:get_pos()
		if step > 36 then
			self.object:remove()
			return tnt.boom(pos, boom)
		end
		local objects = minetest.get_objects_inside_radius(pos, 0.85)
		for i = 1, #objects do
			if objects[i]:is_player() then
				if objects[i]:get_player_name() ~= self.owner then
					self.object:remove()
					return tnt.boom(pos, boom)
				end
			elseif objects[i]:get_luaentity().horny ~= nil then
				-- It's a mob!
				self.object:remove()
				return tnt.boom(pos, boom)
			end
		end
		local node = minetest.get_node_or_nil(pos)
		if not node then
			return
		end
		local node_name = node.name
		if not node_name then
			return
		end
		local node_def = minetest.registered_nodes[node_name]
		if not node_def then
			return
		end
		local walkable = node_def.walkable
		if not walkable then
			return
		end
		self.object:remove()
		return tnt.boom(pos, boom)
	end,
})

minetest.register_tool("staves:destruction", {
	description = "Staff of Destruction",
	inventory_image = "default_stick.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		if not cooldown[name] then
			cooldown[name] = true
			minetest.after(1, function()
				if cooldown[name] then
					cooldown[name] = nil
				end
			end)
			local pos = user:get_pos()
			pos.y = pos.y + 1.25
			local dir = user:get_look_dir()
			pos = vector.add(pos, dir)
			local arrow = minetest.add_entity(pos, "staves:fireball", name)
			arrow:set_acceleration(dir)
			arrow:set_velocity(vector.multiply(dir, 12))
			itemstack:add_wear(1000)
		end
		return itemstack
	end,
})

minetest.register_on_leaveplayer(function(player)
	cooldown[player:get_player_name()] = nil
end)

print("loaded staves")

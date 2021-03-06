local use_multiskin = minetest.global_exists("multiskin")
local armor_def = setmetatable({}, {
	__index = function()
		return setmetatable({
			groups = setmetatable({}, {
				__index = function()
					return 0
				end})
			}, {
			__index = function()
				return 0
			end
		})
	end,
})
local armor_textures = setmetatable({}, {
	__index = function()
		return setmetatable({}, {
			__index = function()
				return "blank.png"
			end
		})
	end
})

armor = {
	timer = 0,
	elements = {"head", "torso", "legs", "feet", "shield"},
	def = armor_def,
	textures = armor_textures,
	default_skin = "player_male.png",
	materials = {
		obsidian = "obsidian:obsidian",
		steel = "steel:ingot",
		mese = "mese:crystal",
		bronze = "bronze:ingot",
		diamond = "diamond:diamond",
	},
	registered_groups = {["fleshy"]=100},
	registered_callbacks = {
		on_update = {},
		on_equip = {},
		on_unequip = {},
		on_damage = {},
		on_destroy = {},
	},
	migrate_old_inventory = true,
	version = "0.4.9",
}
armor.config = {
	init_delay = 2,
	init_times = 10,
	bones_delay = 1,
	update_time = 1,
	drop = minetest.get_modpath("bones") ~= nil,
	destroy = false,
	level_multiplier = 1,
	heal_multiplier = 1,
	material_obsidian = true,
	material_steel = true,
	material_mese = true,
	material_bronze = true,
	material_diamond = true,
	punch_damage = true,
}

-- Armor Registration

armor.register_armor = function(self, name, def)
	minetest.register_tool(name, def)
end

armor.register_armor_group = function(self, group, base)
	base = base or 100
	self.registered_groups[group] = base
end

-- Armor callbacks

armor.register_on_update = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_update, func)
	end
end

armor.register_on_equip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_equip, func)
	end
end

armor.register_on_unequip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_unequip, func)
	end
end

armor.register_on_damage = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_damage, func)
	end
end

armor.register_on_destroy = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_destroy, func)
	end
end

armor.run_callbacks = function(self, callback, player, index, stack)
	if stack then
		local def = stack:get_definition() or {}
		if type(def[callback]) == "function" then
			def[callback](player, index, stack)
		end
	end
	local callbacks = self.registered_callbacks[callback]
	if callbacks then
		for _, func in pairs(callbacks) do
			func(player, index, stack)
		end
	end
end

armor.update_player_visuals = function(self, player)
	local name = self:get_valid_player(player, "[update_player_visuals]")
	if not name then
		return
	end
	local textures = {
		"blank.png",
		"blank.png",
		self.textures[name].armor,
		self.textures[name].wielditem,
	}
	if use_multiskin then
		multiskin.textures[name] = textures
		multiskin.update_player_visuals(player)
	else
		textures[1] = armor.default_skin
		player_api.set_textures(player, textures)
	end
	self:run_callbacks("on_update", player)
end

armor.set_player_armor = function(self, player)
	local name, armor_inv = self:get_valid_player(player, "[set_player_armor]")
	if not name then
		return
	end
	local state = 0
	local count = 0
	local material = {count=1}
	local preview = "3d_armor_preview.png"
	local texture = "blank.png"
	local textures = {}
	local physics = {}
	local attributes = {}
	local levels = {}
	local groups = {}
	local change = {}
	if use_multiskin then
		preview = multiskin.get_preview(player) or preview
	end
	for group, _ in pairs(self.registered_groups) do
		change[group] = 1
		levels[group] = 0
	end
	local list = armor_inv:get_list("armor")
	if type(list) ~= "table" then
		return
	end
	for i, stack in pairs(list) do
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			for _, element in pairs(self.elements) do
				if def.groups["armor_"..element] then
					if def.armor_groups then
						for group, level in pairs(def.armor_groups) do
							if levels[group] then
								levels[group] = levels[group] + level
							end
						end
					else
						local level = def.groups["armor_"..element]
						levels["fleshy"] = levels["fleshy"] + level
					end
					break
				end
				-- DEPRECATED, use armor_groups instead
				if def.groups["armor_radiation"] and levels["radiation"] then
					levels["radiation"] = def.groups["armor_radiation"]
				end
			end
			local item = stack:get_name()
			local tex = def.texture or item:gsub("%:", "_")
			tex = tex:gsub(".png$", "")
			local prev = def.preview or tex.."_preview"
			prev = prev:gsub(".png$", "")
			texture = texture.."^"..tex..".png"
			preview = preview.."^"..prev..".png"
			state = state + stack:get_wear()
			count = count + 1
			local mat = string.match(item, "%:.+_(.+)$")
			if material.name then
				if material.name == mat then
					material.count = material.count + 1
				end
			else
				material.name = mat
			end
		end
	end
	for group, level in pairs(levels) do
		if level > 0 then
			level = level * armor.config.level_multiplier
			if material.name and material.count == #self.elements then
				level = level * 1.1
			end
		end
		local base = self.registered_groups[group]
		self.def[name].groups[group] = level
		if level > base then
			level = base
		end
		groups[group] = base - level
		change[group] = groups[group] / base
	end
	player:set_armor_groups(groups)
	self.textures[name].armor = texture
	self.textures[name].preview = preview
	self.def[name].level = self.def[name].groups.fleshy or 0
	self.def[name].state = state
	self.def[name].count = count
	self:update_player_visuals(player)
end

armor.punch = function(self, player, hitter, time_from_last_punch, tool_capabilities)
	local name, armor_inv = self:get_valid_player(player, "[punch]")
	if not name then
		return
	end
	local state = 0
	local count = 0
	local recip = true
	local default_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1}
	local list = armor_inv:get_list("armor")
	for i, stack in pairs(list) do
		if stack:get_count() == 1 then
			local name = stack:get_name()
			local use = minetest.get_item_group(name, "armor_use") or 0
			local damage = use > 0
			local def = stack:get_definition() or {}
			if type(def.on_punched) == "function" then
				damage = def.on_punched(player, hitter, time_from_last_punch,
					tool_capabilities) ~= false and damage == true
			end
			if damage == true and tool_capabilities then
				local damage_groups = def.damage_groups or default_groups
				local level = damage_groups.level or 0
				local groupcaps = tool_capabilities.groupcaps or {}
				local uses = 0
				damage = false
				for group, caps in pairs(groupcaps) do
					local maxlevel = caps.maxlevel or 0
					local diff = maxlevel - level
					if diff == 0 then
						diff = 1
					end
					if diff > 0 and caps.times then
						local group_level = damage_groups[group]
						if group_level then
							local time = caps.times[group_level]
							if time then
								local dt = time_from_last_punch or 0
								if dt > time / diff then
									if caps.uses then
										uses = caps.uses * math.pow(3, diff)
									end
									damage = true
									break
								end
							end
						end
					end
				end
				if damage == true and recip == true and hitter and
						def.reciprocate_damage == true and uses > 0 then
					local item = hitter:get_wielded_item()
					if item and item:get_name() ~= "" then
						item:add_wear(65535 / uses)
						hitter:set_wielded_item(item)
					end
					-- reciprocate tool damage only once
					recip = false
				end
			end
			if damage == true and hitter == "fire" then
				damage = minetest.get_item_group(name, "flammable") > 0
			end
			if damage == true then
				self:damage(player, i, stack, use)
			end
			state = state + stack:get_wear()
			count = count + 1
		end
	end
	self.def[name].state = state
	self.def[name].count = count
end

armor.damage = function(self, player, index, stack, use)
	local old_stack = ItemStack(stack)
	stack:add_wear(use)
	self:run_callbacks("on_damage", player, index, stack)
	self:set_inventory_stack(player, index, stack)
	if stack:get_count() == 0 then
		self:run_callbacks("on_unequip", player, index, old_stack)
		self:run_callbacks("on_destroy", player, index, old_stack)
		self:set_player_armor(player)
	end
end

armor.serialize_inventory_list = function(self, list)
	local list_table = {}
	for _, stack in ipairs(list) do
		table.insert(list_table, stack:to_string())
	end
	return minetest.serialize(list_table)
end

armor.deserialize_inventory_list = function(self, list_string)
	local list_table = minetest.deserialize(list_string)
	local list = {}
	for _, stack in ipairs(list_table or {}) do
		table.insert(list, ItemStack(stack))
	end
	return list
end

armor.load_armor_inventory = function(self, player)
	local msg = "[load_armor_inventory]"
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", S("3d_armor: Player name is nil @1", msg))
		return
	end
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not armor_inv then
		minetest.log("warning", S("3d_armor: Detached armor inventory is nil @1", msg))
		return
	end
	local armor_list_string = player:get_attribute("3d_armor_inventory")
	if armor_list_string then
		armor_inv:set_list("armor", self:deserialize_inventory_list(armor_list_string))
		return true
	end
end

armor.save_armor_inventory = function(self, player)
	local msg = "[save_armor_inventory]"
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", S("3d_armor: Player name is nil @1", msg))
		return
	end
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not armor_inv then
		minetest.log("warning", S("3d_armor: Detached armor inventory is nil @1", msg))
		return
	end
	player:get_meta():set_string("3d_armor_inventory", self:serialize_inventory_list(armor_inv:get_list("armor")))
end

armor.set_inventory_stack = function(self, player, i, stack)
	local msg = "[set_inventory_stack]"
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", "3d_armor: Player name is nil "..msg)
		return
	end
	local armor_inv = minetest.get_inventory({type="detached",
			name = name .. "_armor"})
	if not armor_inv then
		minetest.log("warning", S("3d_armor: Detached armor inventory is nil @1", msg))
		return
	end
	armor_inv:set_stack("armor", i, stack)
	self:save_armor_inventory(player)
end

armor.get_valid_player = function(self, player, msg)
	msg = msg or ""
	if not player then
		minetest.log("warning", "3d_armor: Player reference is nil "..msg)
		return
	end
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", "3d_armor: Player name is nil "..msg)
		return
	end
	local inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not inv then
		minetest.log("warning", "3d_armor: Player inventory is nil "..msg)
		return
	end
	return name, inv
end

armor.drop_armor = function(pos, stack)
	local node = minetest.get_node_or_nil(pos)
	if node then
		local obj = minetest.add_item(pos, stack)
		if obj then
			obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
		end
	end
end

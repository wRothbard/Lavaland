local function auto_pickup(player)
	if not player then
		return
	end

	local pos = player:get_pos()
	if not pos then
		return
	end

	local o = minetest.get_objects_inside_radius(player:get_pos(), 0.667)
	for i = 1, #o do
		local obj = o[i]
		local p = obj:is_player()
		if not p then
			local ent = obj:get_luaentity()
			if ent.age and ent.age > 0.5 then
				obj:remove()
				local inv = player:get_inventory()
				local add = inv:add_item("main", ent.itemstring)
				if add then
					minetest.add_item(player:get_pos(), add)
				end
				minetest.sound_play("items_plop", {pos = obj:get_pos()})
			end
		end
	end

	minetest.after(0, function()
		auto_pickup(player)
	end)
end

minetest.registered_entities["__builtin:item"].set_item = function(self, item)
	local stack = ItemStack(item or self.itemstring)
	self.itemstring = stack:to_string()
	if self.itemstring == "" then
		-- item not yet known
		return
	end

	-- Backwards compatibility: old clients use the texture
	-- to get the type of the item
	local itemname = stack:is_known() and stack:get_name() or "unknown"
	if itemname == "lava:source" then
		local pos = self.object:get_pos()
		if pos then
			self.object:remove()
			minetest.set_node(pos, {name = "lava:source"})
		end
	end

	local max_count = stack:get_stack_max()
	local count = math.min(stack:get_count(), max_count)
	local size = 0.2 + 0.1 * (count / max_count) ^ (1 / 3)
	local coll_height = size * 0.75

	self.object:set_properties({
		is_visible = true,
		visual = "wielditem",
		textures = {itemname},
		visual_size = {x = size, y = size},
		collisionbox = {-size, -coll_height, -size,
			size, coll_height, size},
		selectionbox = {-size, -size, -size, size, size, size},
		automatic_rotate = math.pi * 0.5 * 0.2 / size,
		wield_item = self.itemstring,
	})
end

minetest.registered_entities["__builtin:item"].on_punch = function(self, hitter)
	local inv = hitter:get_inventory()
	if inv and self.itemstring ~= "" then
		local left = inv:add_item("main", self.itemstring)
		if left and not left:is_empty() then
			self:set_item(left)
			return
		end
		minetest.sound_play("items_plop", {pos = self.object:get_pos()})
	end
	self.itemstring = ""
	self.object:remove()
end

minetest.register_on_joinplayer(function(player)
	auto_pickup(player)
end)

print("loaded items")

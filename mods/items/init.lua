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

print("items loaded")

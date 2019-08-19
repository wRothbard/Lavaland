inventory = {}

local rand = math.random

function inventory.get_inventory_drops(pos, inventory, drops)
	local inv = minetest.get_meta(pos):get_inventory()
	local n = #drops
	for i = 1, inv:get_size(inventory) do
		local stack = inv:get_stack(inventory, i)
		if stack:get_count() > 0 then
			drops[n+1] = stack:to_table()
			n = n + 1
		end
	end
end

function inventory.throw_inventory(pos, list, intensity)
	for _, item in pairs(list) do
		local o = minetest.add_item(pos, item)
		if o then
			o:get_luaentity().collect = true
			o:set_acceleration({x = 0, y = -10, z = 0})
			o:set_velocity({x = rand(-2, 2),
					y = rand(1, 4),
					z = rand(-2, 2)})
		end

	end
end

print("loaded inventory")

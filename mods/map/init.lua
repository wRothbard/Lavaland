map = {}
--[[
minetest.register_node("map:floor", {
	description = "Map Floor (You hacker you!)",
	tiles = {"map_floor.png"},
	on_blast = function(pos, intensity)
	end,
})
--]]
function map.dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end

print("loaded map")

map = {}

function map.dig_up(pos, node, digger)
	if digger == nil then
		return
	end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end

function map.fell_tree(pos, oldnode, oldmetadata, digger)
	local nn = minetest.get_node(pos)
	if nn and nn.name == "trees:tree" then
		print("remove")
		minetest.remove_node(pos)
	end
	local p1 = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}
	local p2 = {x = pos.x - 1, y = pos.y, z = pos.z + 1}
	local a = minetest.find_nodes_in_area(p1, p2, {"trees:tree"})
	for i = 1, #a do
		map.fell_tree(a[i])
	end
end

print("loaded map")

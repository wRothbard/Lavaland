map = {}

map.selected = {}

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
	oldmetadata = oldmetadata or minetest.get_meta(pos):to_table()
	local pla = oldmetadata.fields.placed
	pla = pla == "true" or nil
	if pla then
		return
	end
	local treenodename
	if oldnode == nil then
		treenodename = "trees:tree"
	else
		treenodename = oldnode.name
	end
	local p1 = {x = pos.x - 1, y = pos.y, z = pos.z - 1}
	local p2 = {x = pos.x + 1, y = pos.y + 2, z = pos.z + 1}
	local a = minetest.find_nodes_in_area(p1, p2, {treenodename})
	for i = 1, #a do
		local an = a[i]
		minetest.remove_node(an)
		minetest.add_item(an, treenodename)
		-- if an.y == pos.y + 1 and
				-- an.x == pos.x and an.z == pos.z then
			map.fell_tree(an, oldnode, oldmetadata, digger)
		-- end
	end
end

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if map.selected[name] then
		map.selected[name] = nil
	end
end)

print("loaded map")

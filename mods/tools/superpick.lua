local function kill_node(pos, _, puncher)
	if puncher:get_wielded_item():get_name() == "tools:superpick" then
		if not minetest.check_player_privs(
				puncher:get_player_name(), {superpick = true}) then
			puncher:set_wielded_item("")
			return
		end

		local nn = minetest.get_node(pos).name
		if nn == "air" then
			return
		end
		inventory.throw_inventory(pos, minetest.get_node_drops(nn))
		minetest.remove_node(pos)
		minetest.check_for_falling(pos)
	end
end

minetest.register_privilege("superpick", {description = "Ability to wield the mighty superpick!"})

minetest.register_craftitem("tools:supersetter", {
	description = "Super Setter",
	inventory_image = "farming_tool_mesehoe.png^obsidian_shard.png",
	groups = {not_in_creative_inventory = 1},
	on_use = function(_, user, pointed_thing)
		if not minetest.check_player_privs(user, "superpick") then
			return {name = "default:pick_steel"}
		end
		local alt = user:get_player_control().sneak
		local pos = pointed_thing.type == "node" and pointed_thing.under
		if pos then
			local node = minetest.get_node(pos)
			minetest.remove_node(pos)
			inventory.throw_inventory(pos,
					minetest.get_node_drops(node.name))
			if not alt then
				minetest.check_for_falling(pos)
			end
		end
	end,
})

minetest.register_tool("tools:superpick", {
	description = "Super Pick",
	inventory_image = "tools_mese_pick.png^obsidian_shard.png",
	range = 11,
	groups = {not_in_creative_inventory = 1},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 3,
		groupcaps = {
			unbreakable =   {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			dig_immediate = {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			fleshy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			choppy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			bendy =		{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			cracky =	{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			crumbly =	{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			snappy =	{times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3}
		},
		damage_groups = {fleshy = 1000}
	}
})

minetest.register_on_mods_loaded(function()
	for node in pairs(minetest.registered_nodes) do
		local def = minetest.registered_nodes[node]
		for i in pairs(def) do
			if i == "on_punch" then
				local rem = def.on_punch
				local function new_on_punch(pos, new_node, puncher, pointed_thing)
					kill_node(pos, new_node, puncher)
					return rem(pos, new_node, puncher, pointed_thing)
				end
				minetest.override_item(node, {
					on_punch = new_on_punch
				})
			end
		end
	end
end)

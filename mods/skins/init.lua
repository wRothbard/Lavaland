skins = {}

skins.list = {
	"alien_by_jmf",
	"thewillyrex_by_edwar_masterchieft",
	"worker_by_krock",
	"calinou_by_calinou",
}

local players = {}

for i = 1, #skins.list do
	local skin = skins.list[i]
	local skin_image = "skins_" .. skin .. "_inv.png"
	minetest.register_craftitem("skins:" .. skin, {
		description = skin,
		inventory_image = skin_image,
		groups = {skin = 1},
	})
end

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("skin", 1)

	local name = player:get_player_name()
	local d_inv = {
		allow_put = function(inv, listname, index, stack, player)
			local r = minetest.get_item_group(stack:get_name(), "skin") > 0
			if r then
				return 1
			else
				return 0
			end
		end,
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack("skin", 1, stack)
			local skin = "skins_" .. stack:get_name():sub(7, -1) .. ".png"
			multiskin.set_player_skin(player, skin)
			multiskin.update_player_visuals(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			local gender = player:get_meta():get_string("gender")
			if gender == "" then
				gender = "male"
			end

			multiskin.set_player_skin(player, "player_" .. gender .. ".png")
			multiskin.update_player_visuals(player)

			player:get_inventory():set_stack("skin", 1, "")
		end,
	}
	players[name] = minetest.create_detached_inventory(name .. "_skin", d_inv)
	players[name]:set_size("skin", 1)
	players[name]:set_stack("skin", 1, inv:get_stack("skin", 1))
end)

print("skins loaded")

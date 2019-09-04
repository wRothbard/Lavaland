skins = {}
skins.list = {}

local ls = minetest.get_dir_list(minetest.get_modpath("skins") .. "/textures")
for i = 1, #ls do
	local l = ls[i]
	if l ~= "skins_skin_bg.png" and not l:match("_inv.png") then
		skins.list[#skins.list + 1] = l:sub(7, -5)
	end
end

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
	local meta = player:get_meta()
	local gender = meta:get("gender")
	if not gender then
		gender = "male"
		if math.random() > 0.5 then
			gender = "female"
		end
		meta:set_string("gender", gender)
	end

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

	minetest.after(2, function()
		if not minetest.get_player_by_name(name) then
			return
		end
		local m_skin = meta:get_string("multiskin_skin")
		if m_skin == "player_male.png" or m_skin == "player_female.png" then
			multiskin.set_player_skin(player, "player_" .. gender .. ".png")
			multiskin.update_player_visuals(player)
		end
	end)
end)

minetest.register_chatcommand("gender", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Muse be in-game."
		end

		local meta = player:get_meta()
		local gender = meta:get("gender")

		if param ~= "female" and param ~= "male" then
			return true, "You're gender is " .. gender .. "."
		end

		if param == gender then
			return false, "You're already " .. gender .. "."
		end
		
		gender = param

		multiskin.set_player_skin(player, "player_" .. gender .. ".png")
		multiskin.update_player_visuals(player)

		meta:set_string("gender", gender)

		local inv = player:get_inventory()
		local skin_item = inv:get_stack("skin", 1):get_name()
		if skin_item ~= "" then
			inventory.throw_inventory(player:get_pos(),
					{skin_item})
		end
		inv:set_list("skin", {})
		local d_inv = minetest.get_inventory({type = "detached",
				name = name .. "_skin"})
		d_inv:set_list("skin", {})
	end,
})

print("loaded skins")

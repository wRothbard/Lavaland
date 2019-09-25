local ar = {pvp = {}, b = {}}
local as = AreaStore()
local ms = minetest.get_mod_storage()
local wa = ms:get("wa")
if wa then
	wa = minetest.deserialize(wa)
	if wa then
		ar = wa
		for i = 1, #ar.pvp do
			as:insert_area(ar.pvp[i][1], ar.pvp[i][2], "nopvp")
		end
		for i = 1, #ar.b do
			as:insert_area(ar.b[i][1], ar.b[i][2], "base")
		end
	end
end

local function ppp(pos, t)
	local p = as:get_areas_for_pos(pos)
	for k, v in pairs(p) do
		if k then
			if t then
				local t = as:get_area(k, true, true)
				if t.data == "base" then
					return true
				else
					return false
				end
			else
				return true, k
			end
		end
	end
	return false
end
warpstones = {ppp = ppp}

warpstones.base = function(pos)
	local a, p = warpstones.ppp(pos)
	if a then
		as:remove_area(p)
		ar.b[p] = nil
		ms:set_string("wa", minetest.serialize(ar))
	else
		local p1, p2 = s_protect.get_area_bounds(pos)
		as:insert_area(p1, p2, "base")
		table.insert(ar.b, {p1, p2})
		ms:set_string("wa", minetest.serialize(ar))
	end
end

local selected = {}
local function show_rest(name, pos)
	minetest.show_formspec(name, "warpstones:emerald",
		"size[8,8]" ..
		"button[0,0;1.5,1;show;Show]" ..
		"button[1.5,0;1.5,1;set;Set]" ..
	"")
end

local function warp_formspec(name)
	local dest = selected[name]
	if dest then
		dest = minetest.get_meta(dest):get_string("destination")
	end
	return "size[7.76,2.9]" ..
		forms.exit_button(-0.25, -0.1) ..
		"field[1.15,1.2;5.25,1;warp;Destination;" .. dest .. "]" ..
		"button_exit[6,0.88;1,1;ok;OK]" ..
		"field_close_on_enter[warp;true]" ..
	""
end

local warps = {
	mese = "yellow",
	--amethyst = "0x542164CC",
	diamond = "blue",
	--ruby = "red",
	emerald = "emerald",
}

local timer
local on_punch = function(pos, node, puncher, pointed_thing)
	if node.name == "warpstones:diamond" then
		local meta = minetest.get_meta(pos)
		if meta and meta:get_string("warp") ~= "" and
				meta:get_string("state") == "" then
			local sid = minetest.sound_play("warpstones_woosh", {
				object = puncher,
			})
			meta:set_string("state", "timeout")
			local warp = minetest.deserialize(meta:get_string("warp"))
			local p = puncher:get_pos()
			forms.message(puncher, "Hold still.")
			timer = function(p, player, time, meta, sid, warp)
				if vector.equals(p, player:get_pos()) then
					if time >= 4.4 then
						minetest.sound_fade(sid, -1, 0)
						meta:set_string("state", "")
						player:set_pos(warp)
						warp.y = warp.y + 2
						forms.message(player, "Warped to "
								.. meta:get_string("destination")
								.. ".")
						return minetest.sound_play("items_plop",
								{pos = warp, max_hear_distance = 64})
					end
					minetest.after(0.334, timer, p,
							player, time + 0.334, meta, sid, warp)
				else
					forms.message(puncher,
							"Stand still for 5 seconds after punching to warp.")
					minetest.sound_fade(sid, -0.89, 0)
					meta:set_string("state", "")
					return
				end
			end
			return timer(p, puncher, 0, meta, sid, warp)
		elseif meta:get_string("state") == "timeout" then
			forms.message(puncher, "Waiting.")
		else
			forms.message(puncher, "No destination set.")
		end
	end
end

local on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	local name = clicker:get_player_name()
	selected[name] = pos
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if node.name == "warpstones:diamond" then
		if name ~= owner then
			forms.message(name, "Only the owner of this warpstone can set its destination.", true)
			return
		end
		minetest.show_formspec(name, "warpstones:diamond", warp_formspec(name))
		return
	elseif node.name == "warpstones:mese" then
		if name ~= owner then
			stats.show_more(clicker)
		else
			stats.show_more(clicker, true)
		end
		return
	elseif node.name == "warpstones:emerald" then
		show_rest(name, pos)
	end
end

local on_blast = function()
end

local after_dig_node = function(pos, oldnode, oldmetadata, digger)
	if oldnode.name == "warpstones:mese" then
		local name = digger:get_player_name()
		selected[name] = oldmetadata
		forms.message(digger, "Would you like to apply the stored class and level?",
				true, "warpstones:stats_apply")
	end
end

local after_place_node = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local name = placer:get_player_name()
	if not name or not meta then
		return
	end
	meta:set_string("owner", name)
	local spos = minetest.pos_to_string(pos)
	if itemstack:get_name() == "warpstones:mese" then
		--print(dump(itemstack:get_meta():to_table()))
		forms.message(placer, "Would you like to save your current stats to this warpstone?  " ..
				"Doing so will reset your character's stats and place them in the crystal.",
				true, "warpstones:stats_save_" .. spos)
	elseif itemstack:get_name() == "warpstones:diamond" then
		meta:set_string("infotext", "Uninitialized warpstone\n" ..
				"Right-click to set destination.")
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname == "warpstones:diamond" then
		local w = fields.warp
		if w then
			local b = beds.beds[name]
			if b and b[w] then
				local n = minetest.get_meta(selected[name])
				selected[name] = nil
				if n then
					n:set_string("warp",
							minetest.serialize(b[w]))
					n:set_string("destination", w)
					n:set_string("infotext", "Warp to " .. w ..
							"\nPunch and stand still to warp")
				end
				return
			end
			for _, warps in pairs(beds.beds_public) do
				for warp, pos in pairs(warps) do
					if w == warp then
						local n = minetest.get_meta(selected[name])
						selected[name] = nil
						if n then
							n:set_string("warp",
									minetest.serialize(pos))
							n:set_string("destination", w)
							n:set_string("infotext", "Warp to " .. w ..
									"\nPunch and stand still to warp")
						end
						return
					end
				end
			end
		end
	end
	if formname == "warpstones:stats_apply" and fields.ok then
		local codex = minetest.deserialize(selected[name].fields.codex)
		selected[name] = nil
		stats.update_stats(player, codex)
	elseif formname == "warpstones:stats_apply" and fields.quit then
		--print("try save stats in crystal")
		--local codex = minetest.deserialize(selected[name].fields.codex)
		--local inv = player:get_inventory()
		--show formspec with slot for warpstone, save stats to it on place.
	elseif formname:sub(1, 22) == "warpstones:stats_save_" and fields.ok then
		local s = stats.update_stats(player, {
			level = "",
			xp = "",
			hp = "",
			hp_max = "",
			breath_max = "",
			stam_max = "",
			sat_max = "",
			sat = "",
			--breath,
			--stam,
		})
		local hp = s.hp
		local mpos = minetest.string_to_pos(formname:sub(24, -2))
		local meta = minetest.get_meta(mpos)
		meta:set_string("infotext",
				"Mese Warpstone\nOwned by " .. name ..
				"\nLevel: " .. tostring(s.level) .. ", " ..
				"XP: " .. tostring(s.xp) ..
				"\nHP: " .. tostring(hp) .. "/" ..
				tostring(s.hp_max))
		meta:set_string("codex", minetest.serialize(s))
		if hp > 20 then
			hp = 20
		end
		--[[
		local breath = player:get_breath()
		if breath > 20 then
			breath = 20
		end
		--]]
		stats.update_stats(player, {
			hp_max = 20,
			hp = hp,
			xp = 0,
			level = 1,
			breath_max = 11,
			--breath = breath,
			stam_max = 20,
			--stam = 20,
			sat_max = 20,
			sat = 20,
		})
	end
	if formname == "warpstones:emerald" then
		local pos = selected[name] --player:get_pos()
		if fields.set then
			if minetest.is_protected(pos, name) then
				return
			end
			local a, p = ppp(pos)
			if a then
				as:remove_area(p)
				ar.pvp[p] = nil
				ms:set_string("wa", minetest.serialize(ar))
			else
				local p1, p2 = s_protect.get_area_bounds(pos)
				as:insert_area(p1, p2, "nopvp")
				table.insert(ar.pvp, {p1, p2})
				ms:set_string("wa", minetest.serialize(ar))
			end
		elseif fields.show then
			minetest.chat_send_player(name, tostring(ppp(pos)))
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	if not player then
		return
	end
	selected[player:get_player_name()] = nil
end)

for label, color in pairs(warps) do
	minetest.register_node("warpstones:" .. label, {
		visual = "mesh",
		mesh = "warps_warpstone.obj",
		description = label .. " Warp Stone",
		tiles = {"warpstones_" .. label .. ".png"},
		drawtype = "mesh",
		wield_scale = {x = 1.5, y = 1.5, z = 1.5},
		stack_max = 1,
		sunlight_propagates = true,
		walkable = false,
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = true,
		groups = {cracky = 3, oddly_breakable_by_hand = 1},
		light_source = 11,
		sounds = music.sounds.nodes.glass,
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25,  0.25, 0.5, 0.25}
		},
		on_rightclick = on_rightclick,
		--on_blast = on_blast,
		after_place_node = after_place_node,
		after_dig_node = after_dig_node,
		on_punch = on_punch,
	})
	local mat = "mese:mese"
	if label ~= "mese" then
		mat = label .. ":block"
	end
	minetest.register_craft({
		output = "warpstones:" .. label,
		recipe = {
			{"group:glass", "group:glass", "group:glass"},
			{"group:glass", mat, "group:glass"},
			{"group:glass", "group:glass", "group:glass"}
		}
	})
end

print("loaded warpstones")

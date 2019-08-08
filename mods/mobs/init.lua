mobs = {}

local path = minetest.get_modpath(minetest.get_current_modname())
dofile(path .. "/functions.lua")
dofile(path .. "/players.lua")
dofile(path .. "/api.lua")
dofile(path .. "/crafts.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/npc.lua")
dofile(path .. "/sheep.lua")
dofile(path .. "/rat.lua")
dofile(path .. "/bunny.lua")
dofile(path .. "/kitten.lua")
dofile(path .. "/dungeon_master.lua")
dofile(path .. "/oerkki.lua")
dofile(path .. "/zombies.lua")

print("loaded mobs")

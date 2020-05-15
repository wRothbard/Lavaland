default = {}

default.node_sound_wood_defaults = function () return music.sounds.nodes.wood end
default.node_sound_glass_defaults = function () return music.sounds.material.glass end
default.node_sound_metal_defaults = function () return music.sounds.nodes.metal end
default.node_sound_stone_defaults = function () return music.sounds.nodes.stone end
default.node_sound_leaves_defaults = function () return music.sounds.nodes.leaves end
default.node_sound_dirt_defaults = function () return music.sounds.nodes.dirt end
default.node_sound_sand_defaults = function () return music.sounds.nodes.sand end

minetest.register_alias("default:steel_ingot", "steel:ingot")
minetest.register_alias("steel:sheet_metal", "steel:ingot")
minetest.register_alias("default:sign_wall_wood", "signs:sign_wall_wood")
minetest.register_alias("default:sign_wall_steel", "signs:sign_wall_steel")
minetest.register_alias("default:glass", "glass:glass")
minetest.register_alias("default:obsidian_glass", "obsidian:glass")
minetest.register_alias("default:fence_wood", "fences:fence_wood")
-- XXX when these woods/fences are added, probably want to revisit these aliases
minetest.register_alias("default:fence_acacia_wood", "fences:fence_wood")
minetest.register_alias("default:fence_aspen_wood", "fences:fence_wood")
minetest.register_alias("default:fence_junglewood", "fences:fence_wood")
minetest.register_alias("default:fence_pine_wood", "fences:fence_wood")
minetest.register_alias("default:stone_brick", "stone:brick")
minetest.register_alias("default:stonebrick", "stone:brick")
minetest.register_alias("default:dirt", "dirt:dirt")

default.get_hotbar_bg = forms.get_hotbar_bg
default.gui_bg     = ""
default.gui_bg_img = ""
default.gui_slots  = ""

print("loaded default")

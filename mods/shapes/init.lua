-- Minetest 0.4 mod: stairs
-- See README.txt for licensing and other information.


-- Global namespace for functions

shapes = {}

local function rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end

		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end

local function warn_if_exists(nodename)
	if minetest.registered_nodes[nodename] then
		minetest.log("warning", "Overwriting stairs node: " .. nodename)
	end
end


-- Register stair
-- Node will be called stairs:stair_<subname>

function shapes.register_stair(subname, recipeitem, groups, images, description,
		sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	warn_if_exists("shapes:stair_" .. subname)
	minetest.register_node(":shapes:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		-- Recipe matches appearence in inventory
		minetest.register_craft({
			output = "shapes:stair_" .. subname .. " 8",
			recipe = {
				{"", "", recipeitem},
				{"", recipeitem, recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use stairs to craft full blocks again (1:1)
		minetest.register_craft({
			output = recipeitem .. " 3",
			recipe = {
				{"shapes:stair_" .. subname, "shapes:stair_" .. subname},
				{"shapes:stair_" .. subname, "shapes:stair_" .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = "shapes:stair_" .. subname,
				burntime = math.floor(baseburntime * 0.75),
			})
		end
	end
end


-- Register slab
-- Node will be called stairs:slab_<subname>

function shapes.register_slab(subname, recipeitem, groups, images, description,
		sounds, worldaligntex)
	-- Set world-aligned textures
	local slab_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			slab_images[i] = {
				name = image,
			}
			if worldaligntex then
				slab_images[i].align_style = "world"
			end
		else
			slab_images[i] = table.copy(image)
			if worldaligntex and image.align_style == nil then
				slab_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.slab = 1
	warn_if_exists("shapes:slab_" .. subname)
	minetest.register_node(":shapes:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			local under = minetest.get_node(pointed_thing.under)
			local wield_item = itemstack:get_name()
			local player_name = placer and placer:get_player_name() or ""

			if under and under.name:find("^shapes:slab_") then
				-- place slab using under node orientation
				local dir = minetest.dir_to_facedir(vector.subtract(
					pointed_thing.above, pointed_thing.under), true)

				local p2 = under.param2

				-- Placing a slab on an upside down slab should make it right-side up.
				if p2 >= 20 and dir == 8 then
					p2 = p2 - 20
				-- same for the opposite case: slab below normal slab
				elseif p2 <= 3 and dir == 4 then
					p2 = p2 + 20
				end

				-- else attempt to place node with proper param2
				minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
				itemstack:take_item()
				return itemstack
			else
				return rotate_and_place(itemstack, placer, pointed_thing)
			end
		end,
	})

	if recipeitem then
		minetest.register_craft({
			output = "shapes:slab_" .. subname .. " 6",
			recipe = {
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use 2 slabs to craft a full block again (1:1)
		minetest.register_craft({
			output = recipeitem,
			recipe = {
				{"shapes:slab_" .. subname},
				{"shapes:slab_" .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = "shapes:slab_" .. subname,
				burntime = math.floor(baseburntime * 0.5),
			})
		end
	end
end

-- Register inner stair
-- Node will be called stairs:stair_inner_<subname>

function shapes.register_stair_inner(subname, recipeitem, groups, images,
		description, sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	warn_if_exists("shapes:stair_inner_" .. subname)
	minetest.register_node(":shapes:stair_inner_" .. subname, {
		description = "Inner " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
				{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		minetest.register_craft({
			output = "shapes:stair_inner_" .. subname .. " 7",
			recipe = {
				{"", recipeitem, ""},
				{recipeitem, "", recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = "shapes:stair_inner_" .. subname,
				burntime = math.floor(baseburntime * 0.875),
			})
		end
	end
end


-- Register outer stair
-- Node will be called stairs:stair_outer_<subname>

function shapes.register_stair_outer(subname, recipeitem, groups, images,
		description, sounds, worldaligntex)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	warn_if_exists("shapes:stair_outer_" .. subname)
	minetest.register_node(":shapes:stair_outer_" .. subname, {
		description = "Outer " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		minetest.register_craft({
			output = "shapes:stair_outer_" .. subname .. " 6",
			recipe = {
				{"", recipeitem, ""},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = "shapes:stair_outer_" .. subname,
				burntime = math.floor(baseburntime * 0.625),
			})
		end
	end
end


-- Stair/slab registration function.
-- Nodes will be called stairs:{stair,slab}_<subname>

function shapes.register_shapes(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, worldaligntex)
	shapes.register_stair(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	shapes.register_stair_inner(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	shapes.register_stair_outer(subname, recipeitem, groups, images, desc_stair,
		sounds, worldaligntex)
	shapes.register_slab(subname, recipeitem, groups, images, desc_slab,
		sounds, worldaligntex)
end


-- Register default stairs and slabs
shapes.register_shapes(
	"wood",
	"trees:wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"default_wood.png"},
	"Wooden Stair",
	"Wooden Slab",
	music.sounds.nodes.wood,
	false
)
--[[
shapes.register_shapes(
	"junglewood",
	"default:junglewood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"default_junglewood.png"},
	"Jungle Wood Stair",
	"Jungle Wood Slab",
	default.node_sound_wood_defaults(),
	false
)

shapes.register_shapes(
	"pine_wood",
	"default:pine_wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_pine_wood.png"},
	"Pine Wood Stair",
	"Pine Wood Slab",
	default.node_sound_wood_defaults(),
	false
)

shapes.register_shapes(
	"acacia_wood",
	"default:acacia_wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"default_acacia_wood.png"},
	"Acacia Wood Stair",
	"Acacia Wood Slab",
	default.node_sound_wood_defaults(),
	false
)

shapes.register_shapes(
	"aspen_wood",
	"default:aspen_wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_aspen_wood.png"},
	"Aspen Wood Stair",
	"Aspen Wood Slab",
	default.node_sound_wood_defaults(),
	false
)
--]]
shapes.register_shapes(
	"stone",
	"stone:stone",
	{cracky = 3},
	{"stone_stone.png"},
	"Stone Stair",
	"Stone Slab",
	{},
	true
)

shapes.register_shapes(
	"cobble",
	"stone:cobble",
	{cracky = 3},
	{"stone_cobble.png"},
	"Cobblestone Stair",
	"Cobblestone Slab",
	{},
	true
)

shapes.register_shapes(
	"mossycobble",
	"stone:mossycobble",
	{cracky = 3},
	{"stone_mossycobble.png"},
	"Mossy Cobblestone Stair",
	"Mossy Cobblestone Slab",
	{},
	true
)

shapes.register_shapes(
	"stonebrick",
	"stone:brick",
	{cracky = 2},
	{"stone_brick.png"},
	"Stone Brick Stair",
	"Stone Brick Slab",
	{},
	false
)

shapes.register_shapes(
	"stone_block",
	"stone:block",
	{cracky = 2},
	{"stone_block.png"},
	"Stone Block Stair",
	"Stone Block Slab",
	{},
	true
)
--[[
shapes.register_shapes(
	"desert_stone",
	"default:desert_stone",
	{cracky = 3},
	{"default_desert_stone.png"},
	"Desert Stone Stair",
	"Desert Stone Slab",
	default.node_sound_stone_defaults(),
	true
)

shapes.register_shapes(
	"desert_cobble",
	"default:desert_cobble",
	{cracky = 3},
	{"default_desert_cobble.png"},
	"Desert Cobblestone Stair",
	"Desert Cobblestone Slab",
	default.node_sound_stone_defaults(),
	true
)

shapes.register_shapes(
	"desert_stonebrick",
	"default:desert_stonebrick",
	{cracky = 2},
	{"default_desert_stone_brick.png"},
	"Desert Stone Brick Stair",
	"Desert Stone Brick Slab",
	default.node_sound_stone_defaults(),
	false
)

shapes.register_shapes(
	"desert_stone_block",
	"default:desert_stone_block",
	{cracky = 2},
	{"default_desert_stone_block.png"},
	"Desert Stone Block Stair",
	"Desert Stone Block Slab",
	default.node_sound_stone_defaults(),
	true
)
--]]
shapes.register_shapes(
	"sandstone",
	"sand:sandstone",
	{crumbly = 1, cracky = 3},
	{"default_sandstone.png"},
	"Sandstone Stair",
	"Sandstone Slab",
	music.sounds.nodes.stone,
	true
)

shapes.register_shapes(
	"sandstonebrick",
	"sand:sandstone_brick",
	{cracky = 2},
	{"default_sandstone_brick.png"},
	"Sandstone Brick Stair",
	"Sandstone Brick Slab",
	music.sounds.nodes.stone,
	false
)

shapes.register_shapes(
	"sandstone_block",
	"default:sandstone_block",
	{cracky = 2},
	{"default_sandstone_block.png"},
	"Sandstone Block Stair",
	"Sandstone Block Slab",
	music.sounds.nodes.stone,
	true
)
--[[
shapes.register_shapes(
	"desert_sandstone",
	"default:desert_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_desert_sandstone.png"},
	"Desert Sandstone Stair",
	"Desert Sandstone Slab",
	default.node_sound_stone_defaults(),
	true
)

shapes.register_shapes(
	"desert_sandstone_brick",
	"default:desert_sandstone_brick",
	{cracky = 2},
	{"default_desert_sandstone_brick.png"},
	"Desert Sandstone Brick Stair",
	"Desert Sandstone Brick Slab",
	default.node_sound_stone_defaults(),
	false
)

shapes.register_shapes(
	"desert_sandstone_block",
	"default:desert_sandstone_block",
	{cracky = 2},
	{"default_desert_sandstone_block.png"},
	"Desert Sandstone Block Stair",
	"Desert Sandstone Block Slab",
	default.node_sound_stone_defaults(),
	true
)

shapes.register_shapes(
	"silver_sandstone",
	"default:silver_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_silver_sandstone.png"},
	"Silver Sandstone Stair",
	"Silver Sandstone Slab",
	default.node_sound_stone_defaults(),
	true
)

shapes.register_shapes(
	"silver_sandstone_brick",
	"default:silver_sandstone_brick",
	{cracky = 2},
	{"default_silver_sandstone_brick.png"},
	"Silver Sandstone Brick Stair",
	"Silver Sandstone Brick Slab",
	default.node_sound_stone_defaults(),
	false
)

shapes.register_shapes(
	"silver_sandstone_block",
	"default:silver_sandstone_block",
	{cracky = 2},
	{"default_silver_sandstone_block.png"},
	"Silver Sandstone Block Stair",
	"Silver Sandstone Block Slab",
	default.node_sound_stone_defaults(),
	true
)
--]]
shapes.register_shapes(
	"obsidian",
	"obsidian:obsidian",
	{cracky = 3, level = 2},
	{"obsidian_obsidian.png"},
	"Obsidian Stair",
	"Obsidian Slab",
	music.sounds.nodes.obsidian,
	true
)

shapes.register_shapes(
	"obsidianbrick",
	"obsidian:brick",
	{cracky = 2, level = 2},
	{"obsidian_brick.png"},
	"Obsidian Brick Stair",
	"Obsidian Brick Slab",
	music.sounds.nodes.obsidian,
	false
)

shapes.register_shapes(
	"obsidian_block",
	"obsidian:block",
	{cracky = 2, level = 2},
	{"obsidian_block.png"},
	"Obsidian Block Stair",
	"Obsidian Block Slab",
	music.sounds.nodes.obsidian,
	true
)
--[[
shapes.register_shapes(
	"brick",
	"default:brick",
	{cracky = 3},
	{"default_brick.png"},
	"Brick Stair",
	"Brick Slab",
	default.node_sound_stone_defaults(),
	false
)
--]]
shapes.register_shapes(
	"steelblock",
	"steel:block",
	{cracky = 1, level = 2},
	{"steel_block.png"},
	"Steel Block Stair",
	"Steel Block Slab",
	music.sounds.material.metal,
	true
)
--[[
shapes.register_shapes(
	"tinblock",
	"default:tinblock",
	{cracky = 1, level = 2},
	{"default_tin_block.png"},
	"Tin Block Stair",
	"Tin Block Slab",
	default.node_sound_metal_defaults(),
	true
)
--]]
shapes.register_shapes(
	"copperblock",
	"copper:block",
	{cracky = 1, level = 2},
	{"copper_block.png"},
	"Copper Block Stair",
	"Copper Block Slab",
	music.sounds.material.metal,
	true
)

shapes.register_shapes(
	"bronzeblock",
	"bronze:block",
	{cracky = 1, level = 2},
	{"default_bronze_block.png"},
	"Bronze Block Stair",
	"Bronze Block Slab",
	music.sounds.material.metal,
	true
)
--]]
shapes.register_shapes(
	"goldblock",
	"gold:block",
	{cracky = 1},
	{"default_gold_block.png"},
	"Gold Block Stair",
	"Gold Block Slab",
	music.sounds.material.metal,
	true
)
--[[
shapes.register_shapes(
	"ice",
	"default:ice",
	{cracky = 3, cools_lava = 1, slippery = 3},
	{"default_ice.png"},
	"Ice Stair",
	"Ice Slab",
	default.node_sound_glass_defaults(),
	true
)

shapes.register_shapes(
	"snowblock",
	"default:snowblock",
	{crumbly = 3, cools_lava = 1, snowy = 1},
	{"default_snow.png"},
	"Snow Block Stair",
	"Snow Block Slab",
	default.node_sound_snow_defaults(),
	true
)
--]]
-- Glass stair nodes need to be registered individually to utilize specialized textures.

shapes.register_stair(
	"glass",
	"glass:glass",
	{cracky = 3},
	{"stairs_glass_split.png", "default_glass.png",
	"stairs_glass_stairside.png^[transformFX", "stairs_glass_stairside.png",
	"default_glass.png", "stairs_glass_split.png"},
	"Glass Stair",
	{},
	false
)

shapes.register_slab(
	"glass",
	"glass:glass",
	{cracky = 3},
	{"default_glass.png", "default_glass.png", "stairs_glass_split.png"},
	"Glass Slab",
	{},
	false
)

shapes.register_stair_inner(
	"glass",
	"glass:glass",
	{cracky = 3},
	{"stairs_glass_stairside.png^[transformR270", "default_glass.png",
	"stairs_glass_stairside.png^[transformFX", "default_glass.png",
	"default_glass.png", "stairs_glass_stairside.png"},
	"Glass Stair",
	{},
	false
)

shapes.register_stair_outer(
	"glass",
	"glass:glass",
	{cracky = 3},
	{"stairs_glass_stairside.png^[transformR90", "default_glass.png",
	"stairs_glass_outer_stairside.png", "stairs_glass_stairside.png",
	"stairs_glass_stairside.png^[transformR90","stairs_glass_outer_stairside.png"},
	"Glass Stair",
	{},
	false
)

shapes.register_stair(
	"obsidian_glass",
	"obsidian:glass",
	{cracky = 3},
	{"stairs_obsidian_glass_split.png", "obsidian_glass.png",
	"stairs_obsidian_glass_stairside.png^[transformFX", "stairs_obsidian_glass_stairside.png",
	"obsidian_glass.png", "stairs_obsidian_glass_split.png"},
	"Obsidian Glass Stair",
	{},
	false
)

shapes.register_slab(
	"obsidian_glass",
	"obsidian:glass",
	{cracky = 3},
	{"obsidian_glass.png", "obsidian_glass.png", "stairs_obsidian_glass_split.png"},
	"Obsidian Glass Slab",
	{},
	false
)

shapes.register_stair_inner(
	"obsidian_glass",
	"obsidian:glass",
	{cracky = 3},
	{"stairs_obsidian_glass_stairside.png^[transformR270", "obsidian_glass.png",
	"stairs_obsidian_glass_stairside.png^[transformFX", "obsidian_glass.png",
	"obsidian_glass.png", "stairs_obsidian_glass_stairside.png"},
	"Obsidian Glass Stair",
	{},
	false
)

shapes.register_stair_outer(
	"obsidian_glass",
	"obsidian:glass",
	{cracky = 3},
	{"stairs_obsidian_glass_stairside.png^[transformR90", "obsidian_glass.png",
	"stairs_obsidian_glass_outer_stairside.png", "stairs_obsidian_glass_stairside.png",
	"stairs_obsidian_glass_stairside.png^[transformR90","stairs_obsidian_glass_outer_stairside.png"},
	"Obsidian Glass Stair",
	{},
	false
)

print("loaded shapes")

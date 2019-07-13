
------------------------------------
--CRAFTING
------------------------------------


------------------------------------
--FUEL
------------------------------------
--decay as fuel (peat-like, or maybe dry it first)

------------------------------------
--BIOLOGICAL
------------------------------------
--[[]
minetest.register_craft({
	output = 'ecobots2:bot_chunks',
	recipe = {
		{'ecobots2:bot_chunk', 'ecobots2:bot_chunk', 'ecobots2:bot_chunk'},
		{'ecobots2:bot_chunk', 'ecobots2:bot_chunk', 'ecobots2:bot_chunk'},
		{'ecobots2:bot_chunk', 'ecobots2:bot_chunk', 'ecobots2:bot_chunk'},
	}
})
]]


------------------------------------
--LIGHTS
------------------------------------

------------------------------------
-- STORAGE
------------------------------------
--[[
minetest.register_craft({
	output = 'default:chest_skeleton',
	recipe = {
		{'ecobots2:skeleton', 'ecobots2:skeleton', 'ecobots2:skeleton'},
		{'ecobots2:skeleton', '', 'ecobots2:skeleton'},
		{'ecobots2:skeleton', 'ecobots2:skeleton', 'ecobots2:skeleton'},
	}
})
]]

------------------------------------
-- COOKING
------------------------------------


------------------------------------
--LADDERS
------------------------------------

------------------------------------
--DOORS
------------------------------------

------------------------------------
--BUILDING MATERIAL
------------------------------------

stairs.register_stair_and_slab(
	"duramen",
	"ecobots2:duramen",
	{cracky = 1},
	{"ecobots2_duramen.png"},
	"Duramen Stair",
	"Duramen Slab",
	default.node_sound_stone_defaults(),
	false
)


stairs.register_stair_and_slab(
	"skeleton",
	"ecobots2:skeleton",
	{choppy = 1},
	{"ecobots2_skeleton.png"},
	"Skeleton Stair",
	"Skeleton Slab",
	default.node_sound_wood_defaults(),
	false
)

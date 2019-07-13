
------------------------------------
--NON_LIVING BLOCKS.
--both biotic and abiotic
------------------------------------


------------------------------------
--ALIEN CLAY
------------------------------------
minetest.register_node("ecobots2:alien_clay", {
	description = "Alien Clay",
	tiles = {"ecobots2_alien_clay.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})


------------------------------------
--ALIEN SILT
------------------------------------
minetest.register_node("ecobots2:alien_silt", {
	description = "Alien Silt",
	tiles = {"ecobots2_alien_silt.png"},
	groups = {crumbly = 3, falling_node = 1},
	sounds = default.node_sound_dirt_defaults(),
})

------------------------------------
--ALIEN SAND
------------------------------------
minetest.register_node("ecobots2:alien_sand", {
	description = "Alien Sand",
	tiles = {"ecobots2_alien_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

------------------------------------
--ALIEN STONES
------------------------------------
minetest.register_node("ecobots2:alien_stones", {
	description = "Alien Stones",
	tiles = {"ecobots2_alien_stones.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
})


------------------------------------
--ALIEN LAVA
--and own cooling mechanics, otherwise get default
------------------------------------

------------------------------------
--ALIEN IGNEOUS ROCK
------------------------------------
minetest.register_node("ecobots2:alien_igneous_rock", {
	description = "Alien Igneous Rock",
	tiles = {"ecobots2_alien_igneous_rock.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, stone = 1},
})


------------------------------------
--ALIEN SEDIMENTARY ROCK
------------------------------------
minetest.register_node("ecobots2:alien_sedimentary_rock", {
	description = "Alien Sedimentary Rock",
	tiles = {"ecobots2_alien_sedimentary_rock.png"},
	groups = {crumbly = 1, cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

------------------------------------
--ALIEN METAMORPHIC ROCK
------------------------------------
minetest.register_node("ecobots2:alien_metamorphic_rock", {
	description = "Alien Metamorphic Rock",
	tiles = {"ecobots2_alien_metamorphic_rock.png"},
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

------------------------------------
--ALIEN ICE
------------------------------------
minetest.register_node("ecobots2:alien_ice", {
	description = "Alien Ice",
	drawtype = "glasslike",
	tiles = {"ecobots2_alien_ice.png"},
	paramtype = "light",
	use_texture_alpha = true,
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults(),
})

------------------------------------
--WATER
------------------------------------
minetest.register_abm({
	label = "Freeze water",
	nodenames = {"ecobots2:alien_water_source", "ecobots2:alien_water_flowing"},
	neighbors = {
		"air",
	},
	interval = 60,
	chance = 30,
	catch_up = false,
	action = function(pos, node)
		minetest.set_node(pos, {name = "ecobots2:alien_ice"})
	end
})

minetest.register_node("ecobots2:alien_water_source", {
	description = "Alien Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "ecobots2_alien_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "ecobots2_alien_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 100,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "ecobots2:alien_water_flowing",
	liquid_alternative_source = "ecobots2:alien_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 100, r = 0, g = 74, b = 66},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("ecobots2:alien_water_flowing", {
	description = "Alien Flowing Water",
	drawtype = "flowingliquid",
	tiles = {"ecobots2_alien_water.png"},
	special_tiles = {
		{
			name = "ecobots2_alien_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "ecobots2_alien_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 100,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "ecobots2:alien_water_flowing",
	liquid_alternative_source = "ecobots2:alien_water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 100, r = 0, g = 74, b = 66},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})




------------------------------------
--Dead Matter & Waste
------------------------------------
minetest.register_node("ecobots2:alien_soil", {
	description = "Alien Soil",
	tiles = {"ecobots2_alien_soil.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})


minetest.register_node("ecobots2:decay", {
	description = "Decaying Matter",
	tiles = {"ecobots2_decay.png"},
	groups = {crumbly = 3, falling_node = 1},
	sounds = ecobots2.node_sound_mud(),
})


minetest.register_node("ecobots2:skeleton", {
	description = "Skeleton",
	tiles = {"ecobots2_skeleton.png"},
	groups = {choppy = 1, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("ecobots2:duramen", {
	description = "Duramen",
	tiles = {"ecobots2_duramen.png"},
	groups = {cracky = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})



minetest.register_node("ecobots2:waste_gas", {
	description = "Waste Gas",
	drawtype = "airlike",
  --drawtype = "glasslike",--better performance without being visible
	tiles = {"ecobots2_waste_gas.png"},
  paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	groups = {not_in_creative_inventory = 1, flammable = 3},
  use_texture_alpha = true,
	post_effect_color = {a = 50, r = 40, g = 40, b = 40},
  drowning = 1,
  on_blast = function(pos, intensity)
    minetest.set_node(pos, {name = "air"})
  end,
  --dissappate
  on_construct = function(pos)
    minetest.get_node_timer(pos):start(90)
  end,
  on_timer = function(pos, elapsed)
    minetest.set_node(pos, {name = "air"})
  end,

})


---------------------------------------------
--BOT CHUNKS
--digging gives 1 chunk. Make into a block. Dry and eat

--[[
minetest.register_craftitem("ecobots2:bot_chunk", {
	description = "Chunk of an Alien Organism",
	inventory_image = "ecobots2_chunk.png",
	groups = {flammable = 3},
	on_use = minetest.item_eat(-9),
})
]]

minetest.register_node("ecobots2:dried_bot_chunks", {
	description = "Dried Chunks of Alien Organism",
  --drawtype = "allfaces",
	tiles = {"ecobots2_chunks_dry.png",},
	paramtype = "light",
	groups = {snappy = 3, flammable = 3, falling_node = 1, not_in_creative_inventory = 1,},
	sounds = default.node_sound_gravel_defaults(),
	on_use = minetest.item_eat(2),

})


minetest.register_node("ecobots2:bot_chunks", {
	description = "Chunks of Alien Organism",
	tiles = {"ecobots2_chunks.png",},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, falling_node = 1, slippery = 1},
	sounds = ecobots2.node_sound_living(),
	--decay or dry
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(120,240))
	end,
	on_timer = function(pos, elapsed)
		local light = ((minetest.get_node_light({x = pos.x, y = pos.y+1, z = pos.z})) or 0)
		if pos.y > 21 and light > 14 then
			minetest.set_node(pos, {name = "ecobots2:dried_bot_chunks"})
		else
			minetest.set_node(pos, {name = "ecobots2:decay"})
		end
	end,
})



------------------------------------
-- --BUILT ITEMS
------------------------------------
--[[
default.chest.register_chest("ecobots2:chest_skeleton", {
	description = "Skeleton Chest",
	tiles = {
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 3, oddly_breakable_by_hand = 3},
	protected = false,
})

default.chest.register_chest("ecobots2:chest_skeleton_locked", {
	description = "Skeleton Chest (locked)",
	tiles = {
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png",
		"ecobots2_skeleton.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 3, oddly_breakable_by_hand = 3},
	protected = true,
})
]]

------------------------------------
--MAPGEN
------------------------------------
minetest.clear_registered_decorations()
minetest.clear_registered_biomes()
minetest.clear_registered_ores()

--[[
The planet is cold and harsh. Everthing has been shaped by biological activity.
It is geologically active.



Biomes:

- Habitable (temp)
	Fields of biocrust, with pockets of dormant bot, dormant virus, dormant hypha
	Sedimentary rock,
- Dormant (ww)
	fields of dormant bots
	Sedimentary rock
- cold desert (cd)
	sand
	Sedimentary rock.
- Frozen (cw)
	ice sheet.
	Metamorphic rock
- Fire	(wd)
	igneous rock and lava oceans
Each above has an ocean equivalent, with Metamorphic rock (except fire)

- mountains:
	ice coated Sedimentary rock.
- underground	Metamorphic rock
- underground	Igneous rock

Ores:
Surface (crust, sand, ice ):
	- living: dormant. decay
Sedimentary:
	- living: skeleton, duramen, decay, ice
	- intrusions: Metamorphic, igneous
Metamorphic:
	- intrusions: Sedimentary, igneous
igneous:
	- intrusions: Metamorphic




]]
------------------------------------
--ORES
------------------------------------

--------------
--Biological:

--Duramen Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:duramen",
		wherein = {"ecobots2:skeleton", "ecobots2:alien_sedimentary_rock", "ecobots2:alien_soil"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.3,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 7221, octaves = 3, persist = 0.70
		}
})

--Skeleton Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:skeleton",
		wherein = {"ecobots2:duramen", "ecobots2:alien_sedimentary_rock","ecobots2:alien_soil"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.9,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 8221, octaves = 3, persist = 0.70
		}
})



--Decay Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:decay",
		wherein = {"ecobots2:skeleton", "ecobots2:duramen", "ecobots2:alien_sedimentary_rock", "ecobots2:alien_ice", "ecobots2:alien_soil"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.3,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 9221, octaves = 3, persist = 0.70
		}
})

--Soil Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:decay",
		wherein = {"ecobots2:skeleton", "ecobots2:duramen", "ecobots2:alien_ice"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.3,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 9221, octaves = 3, persist = 0.70
		}
})



--------------
--Sediments:

--Ice Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:alien_ice",
		wherein = {"ecobots2:alien_sedimentary_rock",	"ecobots2:alien_soil",
		 "ecobots2:alien_sand", "ecobots2:alien_silt", "ecobots2:alien_clay", "ecobots2:alien_stones", "ecobots2:biocrust", },
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.4,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 4311, octaves = 3, persist = 0.70
		}
})

--Stones
minetest.register_ore({
		ore_type = "sheet",
		ore =  "ecobots2:alien_stones",
		wherein = {"ecobots2:duramen", "ecobots2:alien_sedimentary_rock", "ecobots2:alien_igneous_rock",
		"ecobots2:alien_metamorphic_rock",	"ecobots2:alien_soil", "ecobots2:alien_ice",
		  "ecobots2:alien_silt", "ecobots2:alien_clay", "ecobots2:alien_sand", "ecobots2:biocrust", },
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.4,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 5411, octaves = 3, persist = 0.70
		}
})


--Sand
minetest.register_ore({
		ore_type = "sheet",
		ore =  "ecobots2:alien_sand",
		wherein = {"ecobots2:alien_sedimentary_rock",	"ecobots2:alien_soil", "ecobots2:alien_ice",
		  "ecobots2:alien_silt", "ecobots2:alien_clay", "ecobots2:alien_stones", "ecobots2:biocrust", },
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.4,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 6511, octaves = 3, persist = 0.70
		}
})

--Silt
minetest.register_ore({
		ore_type = "sheet",
		ore =  "ecobots2:alien_silt",
		wherein = {"ecobots2:alien_sedimentary_rock",	"ecobots2:alien_soil", "ecobots2:alien_ice",
		  "ecobots2:alien_sand", "ecobots2:alien_clay", "ecobots2:alien_stones", "ecobots2:biocrust", },
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.4,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 7611, octaves = 3, persist = 0.70
		}
})

--Clay
minetest.register_ore({
		ore_type = "sheet",
		ore =  "ecobots2:alien_clay",
		wherein = {"ecobots2:alien_sedimentary_rock",	"ecobots2:alien_soil", "ecobots2:alien_ice",
		  "ecobots2:alien_silt", "ecobots2:alien_sand", "ecobots2:alien_stones", "ecobots2:biocrust", },
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.4,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 8711, octaves = 3, persist = 0.70
		}
})

--------------------
--Dormant Sheet
minetest.register_ore({
		ore_type = "sheet",
		ore = "ecobots2:dormant_photobot",
		wherein = {"ecobots2:duramen", "ecobots2:skeleton", "ecobots2:alien_ice",
		 "ecobots2:alien_soil", "ecobots2:decay", "ecobots2:biocrust"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 2,
		y_min = -3,
		y_max = 31000,
		noise_threshold = 0.3,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 106661, octaves = 3, persist = 0.70
		}
})


---------------------------------
--!!!Placeholder
--Minerals
minetest.register_ore({
		ore_type = "sheet",
		ore = "default:coalblock",
		wherein = {"default:stone", "default:desert_stone", "default:obsidian", "default:cave_ice"},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 3,
		y_min = -31000,
		y_max = -50,
		noise_threshold = 0.5,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 2013, octaves = 3, persist = 0.70
		}
	})



minetest.register_ore({
		ore_type = "sheet",
		ore = "default:stone_with_iron",
		wherein = {"default:desert_stone", "default:stone",},
		clust_scarcity = 1,
		clust_num_ores = 1,
		clust_size = 3,
		y_min = -31000,
		y_max = -50,
		noise_threshold = 0.5,
		noise_params = {
			offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
			seed = 2773, octaves = 3, persist = 0.70
		}
	})



------------------------------------
--BIOMES
------------------------------------
-------------------
local t = 50
local l = 25
local h = 75

--Heights
local mt_max = 31000
local mt_min = 100

local land_max = 120
local land_min = 2

local ocean_max = 4
local ocean_min = -120

local underg_max = -100
local underg_min = -31000

--local base_max = -1050
--local base_min = -31000
------------------------

--------------------
--Dormant (ww)
minetest.register_biome({
	name = "dormant",
	node_top = "ecobots2:biocrust",
	depth_top = 1,
	node_filler = "ecobots2:skeleton",
	depth_filler = 4,
	node_stone = "ecobots2:alien_sedimentary_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 1,
	node_riverbed = "ecobots2:duramen",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = land_max,
	y_min = land_min,
	heat_point = h,
	humidity_point = h,
})

--Dormant Ocean (ww)
minetest.register_biome({
	name = "dormant_ocean",
	node_top = "ecobots2:alien_silt",
	depth_top = 1,
	node_filler = "ecobots2:alien_clay",
	depth_filler = 3,
	node_stone = "ecobots2:alien_metamorphic_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 1,
	node_riverbed = "ecobots2:alien_sand",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = h,
	humidity_point = h,
})

--------------------
--Habitable (t)
minetest.register_biome({
	name = "habitable",
	node_top = "ecobots2:biocrust",
	depth_top = 1,
	node_filler = "ecobots2:alien_soil",
	depth_filler = 6,
	node_stone = "ecobots2:alien_sedimentary_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 1,
	node_riverbed = "ecobots2:alien_sand",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = land_max,
	y_min = land_min,
	heat_point = t,
	humidity_point = t,
})

--habitable ocean (t)
minetest.register_biome({
	name = "habitable_ocean",
	node_top = "ecobots2:alien_sand",
	depth_top = 1,
	node_filler = "ecobots2:alien_silt",
	depth_filler = 2,
	node_stone = "ecobots2:alien_metamorphic_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 1,
	node_riverbed = "ecobots2:alien_sand",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = t,
	humidity_point = t,
})

--------------------
--cold desert (cd)
minetest.register_biome({
	name = "cold_desert",
	node_top = "ecobots2:alien_sand",
	depth_top = 1,
	node_filler = "ecobots2:alien_stones",
	depth_filler = 6,
	node_stone = "ecobots2:alien_sedimentary_rock",
	node_riverbed = "ecobots2:alien_stones",
	depth_riverbed = 2,
	--node_water = "",
	y_max = land_max,
	y_min = land_min,
	heat_point = l,
	humidity_point = l,
})

--cold desert ocean (cd)
minetest.register_biome({
	name = "cold_desert_ocean",
	node_top = "ecobots2:alien_stones",
	depth_top = 1,
	node_filler = "ecobots2:alien_clay",
	depth_filler = 1,
	node_stone = "ecobots2:alien_metamorphic_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 1,
	node_riverbed = "ecobots2:alien_stones",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = l,
	humidity_point = l,
})



--------------------
-- frozen (cw)
minetest.register_biome({
	name = "frozen",
	--node_dust = "default:snowblock",
	node_top = "ecobots2:alien_ice",
	depth_top = 6,
	node_filler = "ecobots2:alien_stones",
	depth_filler = 1,
	node_stone = "ecobots2:alien_metamorphic_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 5,
	node_river_water = "ecobots2:alien_ice",
	node_riverbed = "ecobots2:alien_ice",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = land_max,
	y_min = land_min,
	heat_point = l,
	humidity_point = h,
})

--frozen ocean
minetest.register_biome({
	name = "frozen_ocean",
	node_dust = "ecobots2:alien_ice",
	node_top = "ecobots2:alien_stones",
	depth_top = 1,
	node_filler = "ecobots2:alien_clay",
	depth_filler = 1,
	node_stone = "ecobots2:alien_metamorphic_rock",
	node_riverbed = "ecobots2:alien_stones",
	depth_riverbed = 2,
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 15,
	node_water = "ecobots2:alien_water_source",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = l,
	humidity_point = h,
})


--------------------
-- fire
minetest.register_biome({
	name = "fire",
	node_top = "ecobots2:alien_sand",
	depth_top = 1,
	node_filler = "ecobots2:alien_stones",
	depth_filler = 1,
	node_stone = "ecobots2:alien_igneous_rock",
	node_water_top = "ecobots2:alien_igneous_rock",
	depth_water_top = 1,
	node_river_water = "ecobots2:alien_igneous_rock",
	node_riverbed = "ecobots2:alien_igneous_rock",
	depth_riverbed = 2,
	node_water = "default:lava_source",
	y_max = land_max,
	y_min = land_min,
	heat_point = h,
	humidity_point = l,
})

--solid fire ocean
minetest.register_biome({
	name = "fire_ocean",
	node_stone = "ecobots2:alien_igneous_rock",
	node_riverbed = "ecobots2:alien_igneous_rock",
	depth_riverbed = 2,
	node_water_top = "ecobots2:alien_igneous_rock",
	depth_water_top = 1,
	node_water = "ecobots2:alien_igneous_rock",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = h,
	humidity_point = l,
})

--fire ocean
minetest.register_biome({
	name = "fire_ocean",
	node_stone = "ecobots2:alien_igneous_rock",
	node_riverbed = "ecobots2:alien_igneous_rock",
	depth_riverbed = 2,
	--node_water_top = "ecobots2:alien_igneous_rock",
	--depth_water_top = 1,
	node_water = "default:lava_source",
	y_max = ocean_max,
	y_min = ocean_min,
	heat_point = h + 10,
	humidity_point = l -10,
})


-- Fire Underground

minetest.register_biome({
	name = "fire_underground",
	node_top = "ecobots2:alien_stones",
	depth_top = 1,
	node_stone = "ecobots2:alien_igneous_rock",
	y_max = underg_max,
	y_min = underg_min,
	heat_point = h,
	humidity_point = l,
})

---------------------
--mountains
minetest.register_biome({
	name = "mountains",
	--node_dust = "default:snowblock",
	node_top = "ecobots2:alien_ice",
	depth_top = 1,
	node_filler = "ecobots2:alien_stones",
	depth_filler = 1,
	node_stone = "ecobots2:alien_sedimentary_rock",
	node_water_top = "ecobots2:alien_ice",
	depth_water_top = 3,
	node_river_water = "ecobots2:alien_ice",
	node_riverbed = "ecobots2:alien_stones",
	depth_riverbed = 2,
	node_water = "ecobots2:alien_water_source",
	y_max = mt_max,
	y_min = mt_min,
	heat_point = t,
	humidity_point = t,
})

---------------------
-- Underground

minetest.register_biome({
	name = "underground",
	node_top = "ecobots2:alien_stones",
	depth_top = 1,
	node_stone = "ecobots2:alien_metamorphic_rock",
	y_max = underg_max,
	y_min = underg_min,
	heat_point = t,
	humidity_point = t,
})

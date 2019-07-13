------------------------------------
--PHOTOBOT BLOCKS
--contains node registrations,
--and associated code for photobot and related living blocks
------------------------------------




------------------------------------
--Dormant
--because mapgen cant do metadata
--awakened by player
------------------------------------
local awaken = function(pos)
	if math.random(1,5) <= 4 then
		minetest.set_node(pos, {name = "ecobots2:decay"})
		return
	else
		local c =  math.random(1,50)
		--roll again to unleash some of the extra bot types
		if c == 1 then
			minetest.set_node(pos, {name = "ecobots2:infected_photobot"})
		elseif c == 2 then
			minetest.set_node(pos, {name = "ecobots2:hyphal_mass"})
		elseif c == 3 then
			minetest.set_node(pos, {name = "ecobots2:biocrust"})
		else
			--awake
			minetest.set_node(pos, {name = "ecobots2:photobot"})
			--METADATA
			local meta = minetest.get_meta(pos)
			--Random starting conditions
			--RK select
			local RK = meta:set_int("RK", math.random(1,80))
			--Energy
			local E = meta:set_int("E", math.random(1,40))
			--Waste
			local W = meta:set_int("W", math.random(100,200))
			--Age
			local A = meta:set_int("A",math.random(10,100))
		end
	end
end


minetest.register_node("ecobots2:dormant_photobot", {
	description = "Dormant Organism",
	tiles = {"ecobots2_dormant.png"},
	drop = "ecobots2:decay",
	groups = {cracky = 1, live_bot = 1},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		if math.random(1,10) == 1 then
			--awake
			awaken(pos)
		end
	end,
	--kill rather than scatter when blown up
	on_blast = function(pos, intensity)
		minetest.set_node(pos, {name = "ecobots2:decay"})
		minetest.check_for_falling(pos)
	end,
})

-- Awaken
minetest.register_abm{
	nodenames = {"ecobots2:dormant_photobot"},
  interval = 30,
  chance = 10,
  action = function(pos, node, active_object_count, active_object_count_wider)
		--are other live ones near?
		local l = minetest.find_node_near(pos, 1, {"ecobots2:photobot"})
		if l then
			awaken(pos)
		end

		--is player in radius?
		local objs = minetest.get_objects_inside_radius(pos, 2)
		for k, player in pairs(objs) do
			if player:get_player_name()~="" then
				--awake
				awaken(pos)
			end
		end
	end,
}



------------------------------------
--Photosynthetic Bot
------------------------------------



minetest.register_node("ecobots2:photobot", {
	description = "Photosynthetic Organism",
  --drawtype = "allfaces",
	tiles = {"ecobots2_photobot.png",},
	paramtype = "light",
  drop = "ecobots2:bot_chunks",
	groups = {snappy = 2, flammable = 2, falling_node = 1, live_bot = 1, not_in_creative_inventory = 1,},
	--slippery = 1
	sounds = ecobots2.node_sound_living(),
  --set up a new node
  on_construct = function(pos)

    --start metabolic cycle
    --Get Metadata.
    local meta = minetest.get_meta(pos)
    local RK = meta:get_int("RK")
    local MR = math.random(5 + (RK/6),10 + (RK/3))
    minetest.get_node_timer(pos):start(MR)

    --set up initial metadata
    --is handled by the parent, for inheritance
  end,

  --Carry out metabolism
  on_timer = function(pos, elapsed)
    ecobots2.metabolism(pos)
    -- Restart timer
		return true
	end,

})

----------------------
--PHLOEM

minetest.register_node("ecobots2:phloem", {
	description = "Phloem",
	tiles = {"ecobots2_phloem.png"},
	groups = {choppy = 2, flammable = 1, live_bot = 1, not_in_creative_inventory = 1,},
	drop = "ecobots2:skeleton",
	sounds = default.node_sound_wood_defaults(),
	--set up a new node
	on_construct = function(pos)
		--start circulatory cycle
		minetest.get_node_timer(pos):start(105)
	end,
	--Carry out circulatory
	on_timer = function(pos, elapsed)
		ecobots2.phloem_circ(pos)
		-- Restart timer
		return true
	end,
})

----------------------
--SPORANGIUM

minetest.register_node("ecobots2:photobot_sporangium", {
	description = "Sporangium",
	drawtype = "nodebox",
	tiles = {"ecobots2_photobot.png",},
	paramtype = "light",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, -0.3, 0.1},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, -0.3, 0.1},
	},
  drop = "",
	is_ground_content = false,
	groups = {snappy = 2, flammable = 2, falling_node = 1, live_bot = 1, not_in_creative_inventory = 1,},
	--slippery = 1
	sounds = ecobots2.node_sound_living(),

  --set up a new node
  on_construct = function(pos)

    --start release cycle
    --Get Metadata.
    local meta = minetest.get_meta(pos)
    local RK = meta:get_int("RK")
    local MR = 5 + (RK/4)
    minetest.get_node_timer(pos):start(MR)

    --set up initial metadata
    --is handled by the parent, for inheritance
  end,

  --Carry out metabolism
  on_timer = function(pos, elapsed)
    ecobots2.sporangium(pos)
    -- Restart timer
		return true
	end,

  --Save it's meta when dug?
  --preserve_metadata = function(pos, oldnode, oldmeta, drops)
  --end,
})




------------------------------------
--NEPHRON
--A waste excretor, putting it in a less harmful form
--made by phloem
------------------------------------
minetest.register_node("ecobots2:nephron", {
	description = "Nephron",
	tiles = { "ecobots2_photobot.png", "ecobots2_nephron.png","ecobots2_photobot.png",
"ecobots2_photobot.png","ecobots2_photobot.png","ecobots2_photobot.png" },
	groups = {snappy = 2, flammable = 2, live_bot = 1, not_in_creative_inventory = 1,},
	--slippery = 1
	drop = "ecobots2:bot_chunks",
	sounds = ecobots2.node_sound_living(),
	--set up a new node
	on_construct = function(pos)
		--start circulatory cycle
		minetest.get_node_timer(pos):start(120)
	end,
	--Carry out circulatory
	on_timer = function(pos, elapsed)
		ecobots2.nephron_circ(pos)
		-- Restart timer
		return true
	end,
})



------------------------------------
--DERMIS
--stable equivalent of photobot. For a mature superorganism
--produced by phloem,
-- non-dividing. Photosynthetic, non-excreting
------------------------------------

minetest.register_node("ecobots2:dermis", {
	description = "Dermis",
	tiles = { "ecobots2_dermis.png"},
	groups = {snappy = 1, flammable = 2, live_bot = 1, not_in_creative_inventory = 1,},
	--slippery = 1
	drop = "ecobots2:bot_chunks",
	sounds = ecobots2.node_sound_living(),
	--set up a new node
	on_construct = function(pos)
		--start metabolic cycle
		minetest.get_node_timer(pos):start(math.random(60,240))
	end,
	--Carry out metabolism
	on_timer = function(pos, elapsed)
		ecobots2.derm_metabolism(pos)
		-- Restart timer
		return true
	end,
})


------------------------------------
--TRICHOME?
--hair on top of dermis
------------------------------------




------------------------------------
--LYMPH?
--produce roaming macrophages.
--needs a disease or threat to treat.
------------------------------------

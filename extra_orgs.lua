------------------------------------
--EXTRA ORGS
-- additional supporting organisms,
-- not the main show, so done more simply
------------------------------------




------------------------------------
--PHAGE
--decomposer, lives in decay, lives a short time -> spores, removes or stabilizes substrate.
------------------------------------
--phage? (only release at night, infect low E) spread by infected spores (self.infected). Either on touch, or new block is infected
--use entity to provide refugia, random jumps would leave everyone vulnerable
-- kill phloem/support tissue etc on touch
-- infect bot
--want an endemic virus, so low impact, slow growth i.e. no black death plagues

local phage_metabolism = function(pos)

  --lifespan
  local L = 45
  --Get age.
  local meta = minetest.get_meta(pos)
  local A = meta:get_int("A")

  --minetest.chat_send_all("PHAGE"..A)

  --to old, die
  if A >= L then
    minetest.set_node(pos, {name = "air"})
    minetest.check_for_falling(pos)
  else
    --spawn
    local sppos = minetest.find_node_near(pos,1,{"air", "ecobots2:waste_gas"})
    if sppos then
      local spore = minetest.add_entity(sppos, "ecobots2:phage")
      local ent = spore:get_luaentity()

      if not ent then
        spore:remove()
        return
      end

      --start speed
      local vc = 0.05
      local vcy = 0.05

      ent.object:set_velocity({
        x = math.random(-vc,vc),
        y = math.random(-vcy,vcy),
        z = math.random(-vc,vc),
      })

      minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end

    --live another day
    meta:set_int("A", A + 1)
    --shake to stop weird floaty
    minetest.check_for_falling(pos)
  end

end







minetest.register_node("ecobots2:infected_photobot", {
	description = "Infected Alien Organism",
  --drawtype = "allfaces",
	tiles = {"ecobots2_infected_photobot.png",},
	paramtype = "light",
  drop = "ecobots2:bot_chunks",
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2, falling_node = 1},
	--slippery = 1
	sounds = ecobots2.node_sound_living(),
  --set up a new node
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local A = meta:set_int("A", 0)
    --start cycle
    minetest.get_node_timer(pos):start(math.random(30,120))
  end,
  --Carry out metabolism
  on_timer = function(pos, elapsed)
    phage_metabolism(pos)
    -- Restart timer
    return true
  end,


})


------------------------------------
--HYPHAL MASS
--decomposer, lives in decay, lives a short time -> spores, removes or stabilizes substrate.
------------------------------------

local hyphal_metabolism = function(pos)

  --lifespan
  local L = 30
  --Get age.
  local meta = minetest.get_meta(pos)
  local A = meta:get_int("A")

    --minetest.chat_send_all("HYPHA"..A)

  -- almost dead?
  if A == L-1 then
    --spawn
    --already too many entities... just pick a random, same effect?.
    --loop through finding locations and spawning
    local cn = 0
    while cn <= 5 do
      local spo = ecobots2.get_ranpos(pos, 3, "ecobots2:decay")
      if spo then
        minetest.set_node(spo, {name = "ecobots2:hyphal_mass"})
        minetest.sound_play("ecobots2_flesh_footstep", {gain = 0.1, pos = spo, max_hear_distance = 5})
      end
      minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
      cn = cn + 1
    end
    meta:set_int("A", A + 1)
    return
  elseif A >= L then
    --select random. If it by chance gets air, it is likely exposed
    local ac = ecobots2.get_ranpos(pos, 1, "air")
    if ac then
      --erode
      minetest.set_node(pos, {name = "air"})
      minetest.check_for_falling(pos)
      return
    else
      --stabilize
      minetest.set_node(pos, {name = "ecobots2:alien_soil"})
      return
    end
  else
    --live another day
    meta:set_int("A", A + 1)
    --shake to stop weird floaty
    minetest.check_for_falling(pos)
  end
end


minetest.register_node("ecobots2:hyphal_mass", {
	description = "Hyphal Mass",
	tiles = {"ecobots2_hyphal_mass.png"},
  light_source = 5,
  is_ground_content = true,
	groups = {crumbly = 3, falling_node = 1},
	sounds = ecobots2.node_sound_mud(),
  --set up a new node
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local A = meta:set_int("A", 0)
    --start cycle
    minetest.get_node_timer(pos):start(math.random(60,120))
  end,
  --Carry out metabolism
  on_timer = function(pos, elapsed)
    hyphal_metabolism(pos)
    -- Restart timer
    return true
  end,
})


------------------------------------
--BIOCRUST
--Weakly Photosynthetic, like grass
------------------------------------

minetest.register_node("ecobots2:biocrust", {
	description = "Alien Soil with Biocrust",
  tiles = {"ecobots2_biocrust.png", "ecobots2_alien_soil.png",
		{name = "ecobots2_alien_soil.png^ecobots2_biocrust_side.png",
			tileable_vertical = false}},
  drop = "ecobots2:alien_soil",
  is_ground_content = true,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})



minetest.register_abm({
	label = "Biocrust spread",
	nodenames = {"ecobots2:alien_soil"},
	neighbors = {
		"air",
		"ecobots2:biocrust",
	},
	interval = 60,
	chance = 30,
	catch_up = false,
	action = function(pos, node)
		-- Check for darkness: night, shadow or under a light-blocking node
		-- Returns if ignore above
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 4 then
			return
		end

		-- Look for spreading dirt-type neighbours
		local p2 = minetest.find_node_near(pos, 1, "ecobots2:biocrust")
		if p2 then
			minetest.set_node(pos, {name = "ecobots2:biocrust"})
			return
		end

	end
})

minetest.register_abm({
	label = "Biocrust covered",
	nodenames = {"ecobots2:biocrust"},
	interval = 8,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "ecobots2:alien_soil"})
		end
	end
})

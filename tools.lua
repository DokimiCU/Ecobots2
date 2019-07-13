
------------------------------------
--TOOLS
--for debug, and gameplay
------------------------------------

------------------------------------
--GROW LAMP
------------------------------------


------------------------------------
--GENETIC TAGGER
--ISOTOPE ...flow
------------------------------------


------------------------------------
--DORMANCY RELEASER
------------------------------------

------------------------------------
--DORMANCY INDUCER
------------------------------------


------------------------------------
--CLEANER
------------------------------------


------------------------------------
--CIRCULATION RESTORER
------------------------------------




------------------------------------
--CONTAINMENT VESSEL
------------------------------------
--[[FAILED!!!!
local capture = function(user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "SPECIMEN CAPTURE:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO CAPTURE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  local node_name = minetest.get_node(pointed_thing.under).name
  local inv = user:get_inventory()
  if minetest.get_item_group(node_name, "live_bot") == 1 then

    local stack = ItemStack("ecobots2:specimen")

    local meta = minetest.get_meta(pointed_thing.under)
    local E = meta:get_int("E")
    local W = meta:get_int("W")
    local A = meta:get_int("A")
    local RK = meta:get_int("RK")


    if inv:get_stack("main", 1) == "ecobots2:specimen_container" then
			inv:set_stack("main", 1, stack)

      local meta_i = stack:get_meta()
      meta:set_string("nn", node_name )
      meta_i:set_int("E", E)
      meta_i:set_int("W", W)
      meta_i:set_int("A", A)
      meta_i:set_int("RK", RK)


      minetest.set_node(pointed_thing.under, {name = "air"})
      minetest.chat_send_player(name, minetest.colorize("#cc6600","SPECIMEN CAPTURED"))
      minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
		else
      minetest.chat_send_player(name, minetest.colorize("#cc0000", "NO ROOM IN INVENTORY!"))
      minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
		end

	end
end



local release = function(itemstack, user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "SPECIMEN RELEASE:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "CANNOT RELEASE HERE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  else
    local inv = user:get_inventory()
    local meta = itemstack:get_meta()
    local nn = meta:get_string("nn")
    local E = meta:get_int("E")
    local W = meta:get_int("W")
    local A = meta:get_int("A")
    local RK = meta:get_int("RK")

    inv:set_stack("main", 1, "")
    local posu = {x = pointed_thing.under.x, y = pointed_thing.under.y + 1, z = pointed_thing.under.z}

    minetest.set_node(posu, {name = nn})

    local meta_i = minetest.get_meta(posu)
    meta_i:set_int("E", E)
    meta_i:set_int("W", W)
    meta_i:set_int("A", A)
    meta_i:set_int("RK", RK)

  end

end


--all digging produces dead stuff, this method captures with saved metadata
minetest.register_craftitem("ecobots2:specimen_sampler", {
	description = "Specimen Sampler",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		capture(user, pointed_thing)
	end,
})

--for the saved specimen
minetest.register_craftitem("ecobots2:specimen_container", {
	description = "Specimen Container",
	inventory_image = "ecobots2_specimen_empty.png",
	stack_max = 1,

})

--saved specimen
minetest.register_craftitem("ecobots2:specimen", {
	description = "Specimen",
	inventory_image = "ecobots2_specimen_empty.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		release(itemstack, user, pointed_thing)
	end,
})
]]



------------------------------------
--METABOLIC INDUCER
------------------------------------
local metab_induce = function(user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "METABOLIC INDUCTION:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO INDUCE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  --what are we seeing?
  local n = minetest.get_node(pointed_thing.under).name

  if n == "ecobots2:photobot" then
    ecobots2.metabolism(pointed_thing.under)
    local meta = minetest.get_meta(pointed_thing.under)
    local A = meta:get_int("A")
    local E = meta:get_int("E")
    local W = meta:get_int("W")
    minetest.chat_send_player(name, minetest.colorize("#cc6600","METABOLIC CYCLE INDUCED"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","AGE: "..A))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","ENERGY: "..E))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","WASTE: "..W))
    minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
  else
    minetest.chat_send_player(name, minetest.colorize("#cc0000","UNABLE TO INDUCE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
  end

end


minetest.register_craftitem("ecobots2:metab_inducer", {
	description = "Metabolic Inducer",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		metab_induce(user, pointed_thing)
	end,
})


------------------------------------
--FEEDER
------------------------------------

local feed_inject = function(user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "FEED INJECTION:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO FEED!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  --what are we seeing?
  local n = minetest.get_node(pointed_thing.under).name

  if n == "ecobots2:photobot"
 	or n == "ecobots2:photobot_sporangium"  then
    --chance of death
    local c = math.random(1,200)
    if c == 1 then
      minetest.set_node(pointed_thing.under, {name = "ecobots2:decay"})
      minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
      minetest.chat_send_player(name, minetest.colorize("#cc0000","LETHAL FAILURE!"))
    else
      local meta = minetest.get_meta(pointed_thing.under)
      local E = meta:get_int("E")
      --add feed
      local e = E + (math.random(1,50))
      if e > 2500 then
        minetest.set_node(pointed_thing.under, {name = "ecobots2:decay"})
        minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
        minetest.chat_send_player(name, minetest.colorize("#cc0000","LETHAL OVERFEEDING!"))
      else
        meta:set_int("E", e)
        minetest.chat_send_player(name, minetest.colorize("#cc6600","SUCCESS: NEW ENERGY LEVEL = "..e))
        minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
      end
    end
  else
    minetest.chat_send_player(name, minetest.colorize("#cc0000","UNABLE TO FEED!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
  end
end



minetest.register_craftitem("ecobots2:feed_injector", {
	description = "Feed Injector",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		feed_inject(user, pointed_thing)
	end,
})



------------------------------------
--LIGHT METER
------------------------------------

local light_meter = function(user, pointed_thing)

  local name =user:get_player_name()
  local pos = user:getpos()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "LIGHT MEASUREMENT:"))

  local light = ((minetest.get_node_light({x = pos.x, y = pos.y, z = pos.z})) or 0)

  minetest.chat_send_player(name, minetest.colorize("#cc6600","LIGHT LEVEL = "..light))
  minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})

end


minetest.register_craftitem("ecobots2:light_meter", {
	description = "Light Meter",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		light_meter(user, pointed_thing)
	end,
})


------------------------------------
--MUTAGENIC PROBE
------------------------------------

local muta_probe = function(user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "MUTAGENIC ACTION:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO MUTATE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  --what are we seeing?
  local n = minetest.get_node(pointed_thing.under).name

  if n == "ecobots2:photobot"
 	or n == "ecobots2:photobot_sporangium"  then
    --chance of death
    local c = math.random(1,30)
    if c == 1 then
      minetest.set_node(pointed_thing.under, {name = "ecobots2:decay"})
      minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
      minetest.chat_send_player(name, minetest.colorize("#cc0000","LETHAL MUTATION!"))
    else
      local meta = minetest.get_meta(pointed_thing.under)
      local RK = meta:get_int("RK")
      --mutate RK
      local r = RK + (math.random(-5,6))
      if r > 100 then
        r = 100
      end
      if r < 1 then
        r = 1
      end
      meta:set_int("RK", r)
      minetest.chat_send_player(name, minetest.colorize("#cc6600","MUTAGENIC SUCCESS: NEW RK = "..r))
      minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
    end
  else
    minetest.chat_send_player(name, minetest.colorize("#cc0000","UNABLE TO MUTATE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
  end
end



minetest.register_craftitem("ecobots2:mutagenic_probe", {
	description = "Mutagenic Probe",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		muta_probe(user, pointed_thing)
	end,
})


------------------------------------
--SPORE STIMULANT
------------------------------------
local stim_spore = function(user, pointed_thing)

  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "SPORE STIMULATION:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO STIMULATE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  --what are we seeing?
  local n = minetest.get_node(pointed_thing.under).name

  if n == "ecobots2:photobot"
 	or n == "ecobots2:photobot_sporangium"  then
    if ecobots2.sporangium(pointed_thing.under) then
      minetest.chat_send_player(name, minetest.colorize("#cc6600","SPORE RELEASE SUCCESSFUL"))
      minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
    else
      minetest.chat_send_player(name, minetest.colorize("#cc0000","SPORE RELEASE FAILED"))
      minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    end
  else
    minetest.chat_send_player(name, minetest.colorize("#cc0000","UNABLE TO STIMULATE!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
  end

end


minetest.register_craftitem("ecobots2:spore_inducer", {
	description = "Spore Inducer",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		stim_spore(user, pointed_thing)
	end,
})

------------------------------------
--ANALYZER
--gives meta data for bots
------------------------------------


local analyze = function(user, pointed_thing)


  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "LIFE SIGNS ANALYSIS:"))

  if minetest.is_protected(pointed_thing.under, name) then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "PROTECTION FIELD!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  if not pointed_thing or pointed_thing.type ~= "node" then
    minetest.chat_send_player(name, minetest.colorize("#cc0000", "NOTHING TO SCAN!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
    return
  end

  --what are we seeing?
  --!!!!use live bot group
  --if minetest.get_item_group(nn, "live_bot") == 1 then
  local n = minetest.get_node(pointed_thing.under).name

  if minetest.get_item_group(n, "live_bot") == 1 then

    local meta = minetest.get_meta(pointed_thing.under)
    local E = meta:get_int("E")
    local W = meta:get_int("W")
    local A = meta:get_int("A")
    local RK = meta:get_int("RK")
    local D = minetest.registered_nodes[n].description

    minetest.chat_send_player(name, minetest.colorize("#cc6600","NAME: "..D))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","ENERGY: " ..E))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","WASTE: " ..W))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","AGE: " ..A))
    minetest.chat_send_player(name, minetest.colorize("#cc6600","GENOME: " ..RK))
    minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})
  else
    minetest.chat_send_player(name, minetest.colorize("#cc0000","NO READING!"))
    minetest.sound_play("ecobots2_tool_bad", {gain = 0.2, pos = pos, max_hear_distance = 5})
  end

end


minetest.register_craftitem("ecobots2:analyzer", {
	description = "Life Signs Analyzer",
	inventory_image = "ecobots2_analyzer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		analyze(user, pointed_thing)
	end,
})


------------------------------------
--COMPUTER ANALYZER
--plug in analyzer and get average readings, reset analyzer
------------------------------------

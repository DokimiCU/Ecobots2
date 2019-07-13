------------------------------------
--SUPPORT FUNCTIONS
--for supporting blocks e.g. phloem
--i.e. anything not the main bot
--these cannot divide,

------------------------------------
--Max stores in support (phloem, nephron)
--(this is also in bot functions...same value)
local skms = 2500

-----------------------------------
--SPORANGIUM
------------------------------------

ecobots2.sporangium = function(pos)

  local meta = minetest.get_meta(pos)
  local E = meta:get_int("E")
  local Es = meta:get_int("Es")
  local RK = meta:get_int("RK")


  --for tool
  if Es == 0 then
    Es = E/4
    if Es < 1 then
      minetest.set_node(pos, {name = "ecobots2:decay"})
      return false
    end
  end

  --No energy for a new spore?
  if E < Es then
    minetest.set_node(pos, {name = "air"})
    return false
  end


  --add entity

  local sppos = minetest.find_node_near(pos,1,{"air"})
  if sppos then
    local spore = minetest.add_entity(pos, "ecobots2:spore")
    local ent = spore:get_luaentity()

    if not ent then
      spore:remove()
      return
    end

    --transfer energy and genes to spore
    ent.E = Es
    ent.RK = RK

    --start speed
    local vc = 0.04
    local vcy = 0.002

    ent.object:set_velocity({
      x = math.random(-vc,vc),
      y = math.random(-vcy,vcy),
      z = math.random(-vc,vc),
    })

    --Use up energy supply
    meta:set_int("E", E - Es)
    minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
    return true
  else
    --must keep itself alive while waits to find air
    --basal use
    E = E - 1
  end


end






-----------------------------------
--PHLOEM CIRCULATION
--flows waste and energy through the phloem
--adds phloem supported bots
------------------------------------


-- Called by phloem node timer
ecobots2.phloem_circ = function(pos)

  --killed by enviro conditions
  if ecobots2.env_limits(pos) then
    minetest.set_node(pos, {name = "ecobots2:skeleton"})
    return
  end

  --meta for waste dump and circ
  local meta = minetest.get_meta(pos)
  local W = meta:get_int("W")
  local E = meta:get_int("E")
  --basal use
  E = E - 1
  W = W + 1

  --find a neighboring phloem
  local neigh = minetest.find_node_near(pos, 1, {"ecobots2:phloem"})

  --"Dry" up. No energy flowing here. or form dermis
  if E <= 0 then
    local c = math.random(1,50)
    if c == 1 then
      if neigh then
        --be absorbed by neighbor
        local meta_n = minetest.get_meta(neigh)
        local En = meta_n:get_int("E")
        local Wn = meta_n:get_int("W")
        --transfer corpse resources and remove corpse
        meta_n:set_int("E", En + E + 2 )
        meta_n:set_int("W", Wn + W + 2)
        minetest.set_node(pos, {name = "air"})
      else
        minetest.set_node(pos, {name = "ecobots2:skeleton"})
        return
      end
    else
      E = 0
    end
  elseif E > skms/4 then
    local posa = {x = pos.x, y = pos.y + 1, z = pos.z}
    local light = ((minetest.get_node_light(posa)) or 0)
    if light >= 13 then
      minetest.sound_play("ecobots2_dug_flesh", {gain = 0.1, pos = pos, max_hear_distance = 5})
      minetest.set_node(posa, {name = "ecobots2:dermis"})
      --set up dermis meta.
      local meta_d = minetest.get_meta(posa)
      meta_d:set_int("E", 40)
      meta_d:set_int("W", 0)
      meta_d:set_int("A", 0)
      E = E - 42
    end
  end

  --flows
  if neigh then

    --get meta for checks
    local meta_n = minetest.get_meta(neigh)

    --Move E from High to low
    local En = meta_n:get_int("E")
    --has some to give, and neighbor has less
    if E > 20 and En + 10 < E then
      meta_n:set_int("E", En + 10)
      E = E - 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    --has room to take and neighbor has more
    elseif E < skms and En > E + 10 then
      meta_n:set_int("E", En - 10)
      E = E + 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end

    --Move W from High to low
    local Wn = meta_n:get_int("W")
    --has some to give, and neighbor has less
    if W > 10 and Wn + 10 < W then
      meta_n:set_int("W", Wn + 10)
      W = W - 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    --has room to take and neighbor has more
    elseif W < skms and Wn > W + 10 then
      W = W + 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end
  end

  --Excrete Waste when at high Capacity..forming a hard coating
  -- takes energy to do this
  --occassionally form a nephron if has a location
  --if lacks somewhere to dump and is at capacity, becomes blocked.
  if W >= 800 and E > 12 then
    local ch = math.random(1,100)
    if ch == 1 then
      local posu = {x = pos.x, y = pos.y - 1, z = pos.z}
      local pnode = minetest.get_node(posu).name
      if pnode == "air" or pnode == "ecobots2:waste_gas" then
        minetest.sound_play("ecobots2_dug_flesh", {gain = 0.1, pos = pos, max_hear_distance = 5})
        minetest.set_node(posu, {name = "ecobots2:nephron"})
        E = E - 10
        --set up nephron's meta.
        local meta_nep = minetest.get_meta(posu)
        meta_nep:set_int("E", 8)
        meta_nep:set_int("W", 0)
        meta_nep:set_int("A", 0)
      end
    else
      local dump = minetest.find_node_near(pos, 1, {"air","ecobots2:waste_gas"})
      if dump then
        W = W - 800
        E = E - 10
        minetest.set_node(dump, {name = "ecobots2:duramen"})
      elseif W >= skms then
        minetest.set_node(pos, {name = "ecobots2:duramen"})
        return
      end
    end
  end

  --update age..just for curiosity
  local A = meta:get_int("A")
  meta:set_int("A", A + 1)
  --update W E
  meta:set_int("E", E)
  meta:set_int("W", W)


end


-----------------------------------
--NEPHRON CIRCULATION
--takes waste from nearby phloem and excretes it
--phloem should have placed it underneath, so drains down.
------------------------------------


-- Called by nephron node timer
ecobots2.nephron_circ = function(pos)

  --killed by enviro conditions
  if ecobots2.env_limits(pos) then
    minetest.set_node(pos, {name = "ecobots2:decay"})
    minetest.check_for_falling(pos)
    return
  end

  --meta for check
  local meta = minetest.get_meta(pos)
  local W = meta:get_int("W")
  local E = meta:get_int("E")
  --basal use
  E = E - 1
  W = W + 1

  -- die if no energy
  if E <= 0 then
    minetest.set_node(pos, {name = "ecobots2:duramen"})
    return
  end

  --check neighbors. Die if no phloem.
  local neigh = minetest.find_node_near(pos, 1, {"ecobots2:phloem"})
  if neigh then
    --meta for check
    local meta_n = minetest.get_meta(neigh)
    local En = meta_n:get_int("E")
    local Wn = meta_n:get_int("W")

    --suck some energy, a little more than needed for excretion
    if En > 4 and E < skms then
      E = E + 3
      meta_n:set_int("E", En - 3)
    end

    --take the waste
    if Wn > 50 and W < skms -50 then
      meta_n:set_int("W", Wn - 50)
      W = W + 50
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end

    --with enough E it can excrete
    if E > 6 and W >= 800 then
      --check not blocked
      local posu = {x = pos.x, y = pos.y - 1, z = pos.z}
      local pnode = minetest.get_node(posu).name
      if pnode == "air" or pnode == "ecobots2:waste_gas" then
        --clear, flush the pipes!
        minetest.set_node(posu, {name = "ecobots2:alien_water_flowing"})
        W = W - 800
        E = E - 4
      elseif W >= skms then
        --we are blocked. Too blocked?
        minetest.set_node(pos, {name = "ecobots2:duramen"})
        return
      end
    end

  else
    minetest.set_node(pos, {name = "ecobots2:duramen"})
    return
  end

  --update meta.
  meta:set_int("E", E)
  meta:set_int("W", W)
  --update age..just for curiosity
  local A = meta:get_int("A")
  meta:set_int("A", A + 1)


end



-----------------------------------
--DERMIS METABOLISM
--Phloem dependant.
--Photosynthetic, lower light needs, low E and W and basal
--moves waste to phloem
--digests live_bot obscuring it above
--spawn trichomes above?
------------------------------------

ecobots2.derm_metabolism = function(pos)

  --killed by enviro conditions
  if ecobots2.env_limits(pos) then
    minetest.set_node(pos, {name = "ecobots2:decay"})
    minetest.check_for_falling(pos)
    return
  end

  --METADATA
  local meta = minetest.get_meta(pos)
  local E = meta:get_int("E")
  local W = meta:get_int("W")
  local A = meta:get_int("A")

  --minetest.chat_send_all("metabolism E"..E)


  --ENERGY
  local light = ((minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z})) or 0)

  if E < skms then
    if light >= 12 then
      E = E + 6
      W = W + 2
    elseif light >= 6 then
      E = E + 3
      W = W + 1
    elseif light <= 0 then
      --digest live bots above
      local apos = {x = pos.x, y = pos.y + 1, z = pos.z}
      local nn = minetest.get_node(apos).name
      if minetest.get_item_group(nn, "live_bot") == 1 then
        --take its energy and waste
        local meta_a = minetest.get_meta(apos)
        local Ea = meta_a:get_int("E")
        local Wa = meta_a:get_int("W")

        E = E + Ea
        W = W + Wa
        --remove
        minetest.set_node(apos, {name = "air"})
        --knock incase a stack
        minetest.check_for_falling(apos)
      elseif nn == "ecobots2:duramen" then
        --absord waste
        minetest.set_node(apos, {name = "air"})
        W = W + 800
      elseif nn == "ecobots2:skeleton" then
        --absord waste
        minetest.set_node(apos, {name = "air"})
        W = W + 100
      elseif nn == "ecobots2:phloem" then
        --absord waste
        minetest.set_node(apos, {name = "air"})
        --take its energy and waste
        local meta_a = minetest.get_meta(apos)
        local Ea = meta_a:get_int("E")
        local Wa = meta_a:get_int("W")

        E = E + Ea
        W = W + Wa + 100
      end
    end
  end


  --BASAL use of Energy sustain itself
  --use up energy
  E = E - 2
  --produce waste
  W = W + 2

  --SHARE with Phloem
  --Energy Osmosis...high to low
  --find a neighboring phloem
  local neigh = minetest.find_node_near(pos, 1, {"ecobots2:phloem"})
  if neigh then

    --get meta for checks
    local meta_n = minetest.get_meta(neigh)

    --Move E from High to low
    local En = meta_n:get_int("E")
    --has some to give, and neighbor has less
    if E > 20 and En + 10 < E then
      meta_n:set_int("E", En + 10)
      E = E - 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    --has room to take and neighbor has more
    elseif E < skms and En > E + 10 then
      meta_n:set_int("E", En - 10)
      E = E + 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end

    --Move W from High to low
    local Wn = meta_n:get_int("W")
    --has some to give, and neighbor has less
    if W > 10 and Wn + 10 < W then
      meta_n:set_int("W", Wn + 10)
      W = W - 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    --has room to take and neighbor has more
    elseif W < skms and Wn > W + 10 then
      meta_n:set_int("W", Wn - 10)
      W = W + 10
      minetest.sound_play("ecobots2_gurgle", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end

    --no energy left? Phloem shall absorb ye
    if E <= 0 then
      meta_n:set_int("E", En + 2 )
      meta_n:set_int("W", Wn + 2 )
      minetest.set_node(pos, {name = "ecobots2:waste_gas"})
      minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
      minetest.check_for_falling(pos)
      return
    end

    --too much waste... solidify
    if W > skms then
      minetest.set_node(pos, {name = "ecobots2:duramen"})
      return
    end

  else
    --no phloem...cannot live unsupported.
    --any non-neighbor deaths are this anyway
    minetest.set_node(pos, {name = "ecobots2:decay"})
    minetest.check_for_falling(pos)
    return
  end


  --We made it through a cycle. Get Older. Live another day
  --update all the metadata
  meta:set_int("A", A + 1)
  meta:set_int("E", E)
  meta:set_int("W", W)


end

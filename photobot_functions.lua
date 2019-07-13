
-----------------------------------
--FUNCTIONS
--metabolic cycle for bots
--CURRENTLY only set up for photobot
------------------------------------

----------------------------------
--CLASS & Misc
----------------------------------
--clonal, spores, support, basal, max_store, parental investment,
--attach rules: g, gf, lf
local p1 = {cln = false, spo = false, sup = false, bsl = 1, mst = 400, pin = 4 }
local p2 = {cln = false, spo = false, sup = false, bsl = 2, mst = 600, pin = 14 }
local p3 = {cln = false, spo = false, sup = false, bsl = 3, mst = 800, pin = 32 }
local p4 = {cln = false, spo = false, sup = false, bsl = 4, mst = 1000, pin = 60 }
local p5 = {cln = true, spo = false, sup = false, bsl = 5, mst = 1200, pin = 100 }
local p6 = {cln = true, spo = false, sup = false, bsl = 6, mst = 1400, pin = 154 }
local p7 = {cln = true, spo = false, sup = true, bsl = 7, mst = 1600, pin = 224 }
local p8 = {cln = true, spo = false, sup = true, bsl = 8, mst = 1800, pin = 312 }
local p9 = {cln = true, spo = true, sup = true, bsl = 9, mst = 2000, pin = 420 }
local p10 = {cln = true, spo = true, sup = true, bsl = 10, mst = 2200, pin = 550 }

--Max stores in support (phloem, nephron)
--(this is also in sup functions...same value)
local skms = 2500




-----------------------------------
--REPRODUCTION
------------------------------------


--ASEXUAL REPRODUCTION
ecobots2.division = function(pos, RK, p_inv, sup, E, W)

  --count to see if overcrowded
  local prad = 2
  local plim = 7
  local ps, cn = minetest.find_nodes_in_area(
			{x = pos.x - prad, y = pos.y - prad, z = pos.z - prad},
			{x = pos.x + prad, y = pos.y + prad, z = pos.z + prad}, {"ecobots2:photobot"})
  local num_bot = (cn["ecobots2:photobot"] or 0)

  --clean up isolates
  if num_bot <=2 then
    minetest.check_for_falling(pos)
  end

  if num_bot >= plim then
    --support structure bots sacrifice self when overcrowded
    if sup then
      --infrequent or growth is too aggressive
      local d = math.random(1,20)
      if d == 1 then
        minetest.set_node(pos, {name = "ecobots2:phloem"})
        --set up phloems metadata
        local meta = minetest.get_meta(pos)
        meta:set_int("E", E + 2)
        meta:set_int("W", W + 2)
      end
    end
    return false

  else
    --not crowded, find location for new bot.
    --select growth shape.
    local c = math.random(1,(110-RK))
    local pos_new = nil
    if c <= 5 then
      --Pillar (less common)
      pos_new =  ecobots2.get_posu(pos, 1, "air")
    else
      --Leafy (most common, especially in low RK)
      pos_new = ecobots2.get_possi(pos, 1, "air")
    end

    if not pos_new then
      --no new location
      return false
    else
      --add new bot
      minetest.set_node(pos_new, {name = "ecobots2:photobot"})
      minetest.sound_play("ecobots2_dug_flesh", {gain = 0.1, pos = pos, max_hear_distance = 5})
      -- update childs meta.
      local meta = minetest.get_meta(pos_new)
      --update all the metadata
      meta:set_int("A", 0)
      meta:set_int("E", p_inv)
      meta:set_int("W", 0)
      --mutate RK
      local r = RK + (math.random(-2,2))
      if r > 100 then
        r = 100
      end
      if r < 1 then
        r = 1
      end
      --r = math.floor(r)
      meta:set_int("RK", r)
      --success then return true so it can update parent
      return true
    end
  end
end








-------------------------------------
--MAIN
-------------------------------------

ecobots2.metabolism = function(pos)

  --killed by enviro conditions
  if ecobots2.env_limits(pos) then
    minetest.set_node(pos, {name = "ecobots2:decay"})
    minetest.check_for_falling(pos)
    return
  end

  --METADATA
  local meta = minetest.get_meta(pos)
  --RK select
  local RK = meta:get_int("RK")
  --Energy
  local E = meta:get_int("E")
  --Waste
  local W = meta:get_int("W")
  --Age
  local A = meta:get_int("A")

  --minetest.chat_send_all("metabolism E"..E)
  --minetest.chat_send_all("metabolism W"..W)
  --minetest.chat_send_all("metabolism RK"..RK)
  --minetest.chat_send_all("metabolism A"..A)


  --CLASS
  local class
  if RK <= 10 then
    class = p1
  elseif RK <= 20 then
    class = p2
  elseif RK <= 30 then
    class = p3
  elseif RK <= 40 then
    class = p4
  elseif RK <= 50 then
    class = p5
  elseif RK <= 60 then
    class = p6
  elseif RK<= 70 then
    class = p7
  elseif RK <= 80 then
    class = p8
  elseif RK <= 90 then
    class = p9
  elseif RK <= 100 then
    class = p10
  end



  --unpack resused:
  local max_st = class.mst
  local clonal = class.cln
  local sup = class.sup
  local p_inv = class.pin



  --ENERGY
  local light = ((minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z})) or 0)

  if E < max_st then
    if light >= 14 then
      E = E + 15 + (RK/4)
      W = W + 3
    elseif light >= 13 then
      E = E + 10
      W = W + 2
    elseif light >= 12 then
      E = E + 5
      W = W + 1
    elseif light <= 0 and sup then
      --structures form if self shaded
      local apos = {x = pos.x, y = pos.y + 1, z = pos.z}
      if minetest.get_node(apos).name == "ecobots2:photobot" then
        minetest.set_node(pos, {name = "ecobots2:phloem"})
      end
    end
  end


  --BASAL use of Energy sustain itself
  --basal rate of use becomes more costly with age
  local basal = class.bsl + (A/10)
  --slow down at night
  if light < 5 then
    basal = basal/5
  end
  --use up energy
  E = E - basal
  --produce waste
  W = W + basal



  --CLONAL co-op?
  if clonal then
    --find a neighbor, or phloem
    local neigh = minetest.find_node_near(pos, 1, {"ecobots2:photobot","ecobots2:phloem"})
    if neigh then

      --get meta for checks
      local meta_n = minetest.get_meta(neigh)
      --is it a bot or skeleton
      local name = minetest.get_node(neigh).name

      if name == "ecobots2:phloem" then
        --Do we have excess E to store?
        if E >= max_st then
          local En = meta_n:get_int("E")
          --has room?
          if En < skms - 50 then
            --give surplus
            meta_n:set_int("E", En + 50)
            E = E - 50
          end
        --Getting hungry?
        elseif E < max_st/5 then
          local En = meta_n:get_int("E")
          --Draw on reserves if it is enough to meet basal needs
          if En >= basal then
            meta_n:set_int("E", En - basal)
            E = E + basal
          end
        --no food transfer? Just offload all waste
        else
          local Wn = meta_n:get_int("W")
          if Wn < skms then
            meta_n:set_int("W", Wn + W)
            W = W - W
          end
        end
      --not a phloem
      else
        local An = meta_n:get_int("A")
        --only feed young
        if An < A then
          local En = meta_n:get_int("E")
          if En < E + 20 then
            meta_n:set_int("E", En + 10)
            E = E - 10
          end
        end
        --load waste on old
        if An > A then
          local Wn = meta_n:get_int("W")
          if Wn < W + 20 then
            meta_n:set_int("W", Wn + 10)
            W = W - 10
          end
        end
      end
    end
  end


  --EXCRETION of waste
  --once it has an excretable amount then push it out.
  if W >= 100 then
    --local dump = minetest.find_node_near(pos, 1, {"air","ecobots2:waste_gas"})
    local dump = ecobots2.get_ranpos(pos, 1, "air")
    if dump then
      W = W - 100
      minetest.set_node(dump, {name = "ecobots2:waste_gas"})
      minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
    end
  end


  --REPRODUCE?
  --Only reproduce when in good condition... slows everything from spamming.
  --only in presence of energy source or they all suicide
  if light >= 14 then
    local cost = max_st/10 + p_inv
    if E > cost + 10 and W < cost + 10 then
      --sporers must decide which method to use
      if class.spo then
        --not many or spams
        if math.random(1,150) == 1 then
          --produce sporangium
          local posu = ecobots2.get_posu(pos,1,"air")
          if posu then
            minetest.set_node(posu, {name = "ecobots2:photobot_sporangium"})
            minetest.sound_play("ecobots2_dug_flesh", {gain = 0.1, pos = pos, max_hear_distance = 5})
            local meta_s = minetest.get_meta(posu)
            --invest into the sporangium and transfer genome
            meta_s:set_int("E",cost)
            meta_s:set_int("Es",cost/2)
            meta_s:set_int("RK", RK)
            --use energy
            E = E - cost
            W = W + cost
          end
        else
          --division. Call division function.
          local had_kid = ecobots2.division(pos, RK, p_inv, sup, E, W)
          --add cost to the parent
          if had_kid then
            E = E - cost
            W = W + cost
          end
        end
      else
        --division. Call division function.
        local had_kid = ecobots2.division(pos, RK, p_inv, sup, E, W)
        --add cost to the parent
        if had_kid then
          E = E - cost
          W = W + cost
        end
      end
    end
  end



  --DEATH?
  --We used up to much...choked on our waste... farwell
  if E <= 0 or W > max_st then
    --Special deaths
    if sup then
      --builders of support structures will join to the skeleton if one exists
      if minetest.find_node_near(pos, 1, {"ecobots2:phloem"}) then
        minetest.set_node(pos, {name = "ecobots2:phloem"})
        --set up Skeletons metadata
        if E < 0 then
          E = 0
        end
        meta:set_int("E", E + 2)
        meta:set_int("W", W + 2)
      end
    elseif clonal then
      --all sup are clonal, so only if no skeleton is near.
      --clonal self sacrifical let it's corpse be absorbed by a neighbour.
      --find a neighbor
      local neigh = ecobots2.get_ranpos(pos, 1, "ecobots2:photobot")
      if neigh then
        local meta_n = minetest.get_meta(neigh)
        local En = meta_n:get_int("E")
        local Wn = meta_n:get_int("W")
        --transfer corpse resources and remove corpse
        meta_n:set_int("E", En + 2 )
        meta_n:set_int("W", Wn + 2 )
        minetest.set_node(pos, {name = "ecobots2:waste_gas"})
        minetest.sound_play("ecobots2_spore_release", {gain = 0.1, pos = pos, max_hear_distance = 5})
      else
        --no friends... normal death
        minetest.set_node(pos, {name = "ecobots2:decay"})
        minetest.check_for_falling(pos)
      end
    else
      --not sup or clonal
      --regular death
      minetest.set_node(pos, {name = "ecobots2:decay"})
      minetest.check_for_falling(pos)
    end

  --We made it through a cycle. Get Older. Live another day
  else
    --update all the metadata
    meta:set_int("A", A + 1)
    meta:set_int("E", E)
    meta:set_int("W", W)
  end

end

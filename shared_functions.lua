------------------------------------
--SHARED FUNCTIONS
--generic stuff

------------------------------------

-----------------------------------
--POSITION SELECTION
------------------------------------


--Stab in the dark to see if it is the target node
ecobots2.get_ranpos = function(pos, r, t)
  local ranpos = {x = pos.x + math.random(-r,r), y = pos.y + math.random(-r,r), z = pos.z + math.random(-r,r)}

  if minetest.get_node(ranpos).name == t and ranpos ~= pos then
    return ranpos
  else
    return false
  end
end



--Stab in the dark to see if it is the target node UP/DOWN
--Pillar growth
ecobots2.get_posu = function(pos, r, t)
  local ranpos = {x = pos.x, y = pos.y + 1, z = pos.z}

  if minetest.get_node(ranpos).name == t then
    return ranpos
  else
    return false
  end
end


--Stab in the dark to see if it is the target node SIDES
-- leafy growth
ecobots2.get_possi = function(pos, r, t)
  local ranpos = {x = pos.x + math.random(-r,r), y = pos.y, z = pos.z + math.random(-r,r)}

  if minetest.get_node(ranpos).name == t and ranpos ~= pos then
    return ranpos
  else
    return false
  end
end


--Environmental limits, i.e. stuff that kills it.
--returns true if death, false if live.
ecobots2.env_limits = function(pos)
--fire...handled by flammable group.

  --altitude.. too high dies from radiation
  if pos.y > 120 then
    if math.random(1,10) == 1 then
      return true
    end
  elseif pos.y > 60 then
    if math.random(1,100) == 1 then
      return true
    end
  elseif pos.y > 30 then
    if math.random(1,200) == 1 then
      return true
    end
  end

  --[["Toxic" :self poisoning. Freezing.
  if minetest.find_node_near(pos, 1, {"ecobots2:waste_gas","ecobots2:alien_water_source", "ecobots2:alien_water_flowing", "ecobots2:alien_ice"}) then
    --roll small chance of death.
    if math.random(1,1000) == 1 then
      return true
    end
  end
]]
  return false
end

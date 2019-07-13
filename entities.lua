
------------------------------------
--ENTITIES
--e.g. mobile spores
------------------------------------



------------------------------------
--COMMON
------------------------------------

------------------------------------
--STATIC DATA


-- get entity staticdata
local staticdata = function(self)

	local tmp = {}

	for _,stat in pairs(self) do

		local t = type(stat)

		if  t ~= "function"
		and t ~= "nil"
		and t ~= "userdata" then
			tmp[_] = self[_]
		end
	end

	--print('===== '..self.name..'\n'.. dump(tmp)..'\n=====\n')
	return minetest.serialize(tmp)
end


-----------
-- ACTIVATE

-- activate spore and reload settings
local activate = function(self, staticdata)


	-- load entity variables
	local tmp = minetest.deserialize(staticdata)

	if tmp then
		for _,stat in pairs(tmp) do
			self[_] = stat
		end
	end

end


------------------------------------
------------------------------------
--SPORES
--released by photobot
------------------------------------


------------
-- GERMINATE
local grow_spore = function(pos, E, RK)
	--see if inside a solid (so doesn't replace it)
	local nodep = minetest.get_node_or_nil(pos)

	if nodep and minetest.registered_nodes[nodep.name] then
		--is it solid?
		if minetest.registered_nodes[nodep.name].walkable == true then
			--do we have space near?
			local sppos = minetest.find_node_near(pos,1,{"air"})
			if sppos then
				--create bot, set meta, then give a kick
				minetest.set_node(sppos, {name = "ecobots2:photobot"})
				local meta = minetest.get_meta(sppos)
				meta:set_int("E", E)
				meta:set_int("A", 0)
				meta:set_int("W", 0)
				meta:set_int("RK", RK)

				minetest.check_for_falling(sppos)

			--	minetest.chat_send_all("Germinate In")
			end
		else
			--look under and see if a solid
			local posu = {x = pos.x, y = pos.y - 1, z = pos.z}
			local node = minetest.get_node_or_nil(posu)

			if node and minetest.registered_nodes[node.name] then

				if minetest.registered_nodes[node.name].walkable == true then
					--create bot, set meta, then give a kick
					minetest.set_node(pos, {name = "ecobots2:photobot"})
					local meta = minetest.get_meta(pos)
					meta:set_int("E", E)
					meta:set_int("A", 0)
					meta:set_int("W", 0)
					meta:set_int("RK", RK)

					minetest.check_for_falling(pos)

					--minetest.chat_send_all("Germinate On")
				end
			end
		end
	end

end



minetest.register_entity("ecobots2:spore", {

	hp_max = 1,
  physical = true,
  weight = 1,
  --collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
	collisionbox = {0,0,0, 0,0,0},
  visual = "sprite",
  visual_size = {x=0.65, y=0.65},
	textures = {"ecobots2_spore.png"},
  spritediv = {x=1, y=1},
  initial_sprite_basepos = {x=0, y=0},
  is_visible = true,
  makes_footstep_sound = false,
  automatic_rotate = true,

	timer = 0,
	RK = 0,
	E = 0,



	get_staticdata = function(self)
			return staticdata(self)
		end,

	on_activate = function(self, staticdata, dtime)
		return activate(self, staticdata)
	end,

	on_step = function(self, dtime)

		--to save juice
		if math.random(1,5) == 1 then

			self.timer = self.timer + 1

			--movement
			local pos = self.object:get_pos()
			local v = self.object:get_velocity()

			--Swarm around any other entity
			local objs = minetest.get_objects_inside_radius(pos, 2)
			local ent = nil


			for n = 1, #objs do

				ent = objs[n]:get_luaentity()

				if objs[n]:get_player_name() ~= ""  then
					--check not in the same place
					local pos_ent = objs[n]:getpos()
					if pos ~= pos_ent then
						--copy velocity
						local v_ent = objs[n]:get_player_velocity()
						local vc = math.random(0.9,2)
						self.object:set_velocity({
							x = v_ent.x/vc,
							y = v_ent.y/vc,
							z = v_ent.z/vc,
						})
						break
					end
				elseif ent then
					if ent.name == self.name then
						--check not in the same place
						local pos_ent = ent.object:getpos()
						if pos ~= pos_ent then
							--copy velocity..sometimes
							local c = math.random(1,100)
							if c <=25 then

								local v_ent = ent.object:get_velocity()

								self.object:set_velocity({
									x = v_ent.x,
									y = v_ent.y,
									z = v_ent.z,
								})
								--minetest.chat_send_all("SWARM")
							elseif c ==100 then
								local v_ent = ent.object:get_velocity()

								self.object:set_velocity({
									x = math.random(-v_ent.z*2,v_ent.z*2),
									y = -v_ent.y,
									z = math.random(-v_ent.x*2,v_ent.x*2),
								})
								--minetest.chat_send_all("outta here")
							end
							break
						end
					end
				end
			end


			--speed control
			if v.x == 0 or v.y == 0 or v.z == 0 then
				--Random drifting
				local c = math.random(1,25)
				if c==1 then
					self.object:set_velocity({
						x = math.random(-v.x,v.x),
						y = math.random(-v.y,v.y),
						z = math.random(-v.z,v.z),
					})
				end
			end

			--germinate when of age
			if self.timer > 250 then
				grow_spore(pos, self.E, self.RK)
				self.object:remove() ;
				return
			end

		end

	end,
})





------------------------------------
------------------------------------
--PHAGE
--virus
------------------------------------



------------
-- INFECT
local grow_phage = function(pos,self, v)
	--see if inside a solid (so doesn't replace it)
	local nodep = minetest.get_node_or_nil(pos)

	local name
	if nodep then
		name = nodep.name
	else
		return false
	end

	--is it infectable of killable?
	--chance of attempting infection
	if math.random(1,8) == 1 then
		if name == "ecobots2:photobot" then
			--only infect the tired
			local meta = minetest.get_meta(pos)
			local E = meta:get_int("E")
			if E <= 400 then
				minetest.set_node(pos, {name = "ecobots2:infected_photobot"})
				minetest.check_for_falling(pos)
				minetest.sound_play("ecobots2_flesh_footstep", {gain = 0.1, pos = spo, max_hear_distance = 5})
				return true
			end
		elseif name == "ecobots2:phloem" then
			minetest.set_node(pos, {name = "ecobots2:skeleton"})
			minetest.check_for_falling(pos)
			minetest.sound_play("ecobots2_flesh_footstep", {gain = 0.1, pos = spo, max_hear_distance = 5})
			return true
		elseif name == "ecobots2:nephron" then
			minetest.set_node(pos, {name = "ecobots2:duramen"})
			minetest.check_for_falling(pos)
			minetest.sound_play("ecobots2_flesh_footstep", {gain = 0.1, pos = spo, max_hear_distance = 5})
			return true
		elseif name == "ecobots2:photobot_sporangium" then
			minetest.set_node(pos, {name = "air"})
			minetest.check_for_falling(pos)
			minetest.sound_play("ecobots2_flesh_footstep", {gain = 0.1, pos = spo, max_hear_distance = 5})
			return true
		else
			--attempted infection, was not target
			return false
		end
	else
		--did not attempt infection
		return false
	end

end



minetest.register_entity("ecobots2:phage", {

	hp_max = 1,
  physical = true,
  weight = 1,
  --collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
	collisionbox = {0,0,0, 0,0,0},
  visual = "sprite",
  visual_size = {x=0.1, y=0.1},
	textures = {"ecobots2_phage.png"},
  spritediv = {x=1, y=1},
  initial_sprite_basepos = {x=0, y=0},
  is_visible = true,
  makes_footstep_sound = false,
  automatic_rotate = true,

	timer = 0,


	get_staticdata = function(self)
			return staticdata(self)
		end,

	on_activate = function(self, staticdata, dtime)
		return activate(self, staticdata)
	end,

	on_step = function(self, dtime)

		--to save juice
		if math.random(1,20) == 1 then

			self.timer = self.timer + 1

			local pos = self.object:get_pos()
			local v = self.object:get_velocity()

			--infect, or die of age
			if grow_phage(pos, self, v) or self.timer > 60 then
				self.object:remove() ;
			else
				--speed control
				if v.x == 0 or v.y == 0 or v.z == 0 then
					--Random drifting
					local c = math.random(1,5)
					if c==1 then
						self.object:set_velocity({
							x = math.random(-v.x,v.x),
							y = math.random(-v.y,v.y),
							z = math.random(-v.z,v.z),
						})
					end
				end
			end
		end
	end,
})

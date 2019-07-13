------------------------------------
--SOUNDS
------------------------------------

--Living things e.g bots, like cutting a slab of meat
function ecobots2.node_sound_living(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "ecobots2_flesh_footstep", gain = 0.4}
	table.dug = table.dug or
			{name = "ecobots2_dug_flesh", gain = 0.5}
	table.place = table.place or
			{name = "ecobots2_place_flesh", gain = 1.0}
	return table
end



--mud  e.g. decay, actual mud
function ecobots2.node_sound_mud(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "ecobots2_mud_footstep", gain = 0.4}
	table.dug = table.dug or
			{name = "ecobots2_mud_footstep", gain = 0.5}
	table.place = table.place or
			{name = "ecobots2_mud_footstep", gain = 1.0}
	return table
end

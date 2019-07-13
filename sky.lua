
local init_cloud = function(player)
	player:set_clouds({color="#c5b9a2FC", density=1, height=1, thickness=30, speed ={x=0, z=0}})
end

minetest.register_on_joinplayer(init_cloud)
minetest.register_on_respawnplayer(init_cloud)

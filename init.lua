

--Orange-Tree
--Bottom trunk, has no leafs, on it there grows a growwood1 or growwood2
minetest.register_node("growingtrees:groworangewood1", {
	description = "Orange tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	is_ground_content = true,
	drop = 'default:tree',
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

--Orange-Tree
--Middle-trunk, has leafs type1, on it there grows growwood2 or growwood3

minetest.register_node("growingtrees:groworangewood2", {
	description = "Orange tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	is_ground_content = true,
	drop = 'default:tree',
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

--Orange-Tree
--Top-Trunk, stops growing into the sky. Has leafs type1 around it.
minetest.register_node("growingtrees:groworangewood3", {
	description = "Orange tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	is_ground_content = true,
	drop = 'default:tree',
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

--Orange-Tree
--inner leafs, produce more leafs around it of both types.
minetest.register_node("growingtrees:groworangeleaves", {
	description = "Orange tree",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	paramtype2 = "leafgeneration",
	drop = 'default:leaves',
	groups = {snappy=3, flammable=2},	
	sounds = default.node_sound_leaves_defaults(),
})



--Orange-Tree
--Fruits: Orange
minetest.register_node("growingtrees:orange", {
	description = "Orange",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"growingtrees_orange.png"},
	inventory_image = "growingtrees_orange.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2},
	on_use = minetest.item_eat(4),
	sounds = default.node_sound_defaults(),
})


--from an orange there grows an orange-tree
minetest.register_abm(
	{nodenames = {"growingtrees:orange"},
	interval = 2,
	chance = 2,
	action = function(pos)
		local may_fall = false
		local may_roll = false
		local may_grow = false
		local may_sink = false
		local may_dirt = false
		local may_rott = false
		
		local stuff_around = 0
		local my_xshift = 0
		local my_yshift = 0
		local my_zshift = 0
		
		--print('I\'m on '..minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name)
		
		-- the orange may fall if there is air under it AND it is not attached (enough) to tree-components
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
			stuff_around = 0
			my_xshift = -1
			my_yshift = -1
			my_zshift = -1
			while my_zshift <= 1 do
				while my_yshift <= 1 do				
					while my_xshift <= 1 do
						if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangeleaves" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:orange" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood1" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood2" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood3" then stuff_around = stuff_around+1 end
						my_xshift = my_xshift+1
					end				
					my_yshift = my_yshift+1
					my_xshift = -1
				end
				my_zshift = my_zshift+1
				my_yshift = -1
			end
			
			if stuff_around <= 3 then
				may_fall = true
			end
		end
		
		--The orange may roll around if it's on ground
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "air" and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:groworangeleaves" and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:orange" and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:groworangewood1" and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:groworangewood2" and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:groworangewood3" then
			may_roll = true
			print('may_roll 1')
		end
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "air" and is_orange_stuff({x=pos.x, y=pos.y-1, z=pos.z}) == false then
			may_roll = true
			print('may_roll 2')
		end
		
		--The orange may grow if it's on dirt and under dirt and above the dirt there should be air and it has to be day
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:dirt" and minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "default:dirt" and minetest.env:get_node({x=pos.x, y=pos.y+2, z=pos.z}).name == "air" and minetest.env:get_timeofday() > 0.25 and minetest.env:get_timeofday() < 0.75 then
			may_grow = true
		end
		
		--The orange may sink into ground if it's on dirt and air above
		if (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:dirt" or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:dirt_with_grass" or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:dirt_with_grass_footsteps" or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:water_source") and minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air" then
			may_sink = true
		end
		
		--The orange may dirt itself if it is on dirt and under air and there should be some dirt around the orange
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:dirt" and minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air" then
			stuff_around = 0
			my_xshift = -1
			my_yshift = 1
			my_zshift = -1
			while my_zshift <= 1 do
				while my_xshift <= 1 do					
					if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name ~= "air" then stuff_around = stuff_around+1 end
					--print(my_xshift..' '..my_yshift..' '..my_zshift)
					my_xshift = my_xshift+1
				end	
				my_xshift = -1
				my_zshift = my_zshift+1
			end
			
			if stuff_around > 1 then
				may_dirt = true
			end
		end
		
		--The Orange may rot if it's on ground
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "growingtrees:groworangeleaves" and minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name ~= "air" then may_rott = true end
		
		--if may_fall then print ('The Orange may fall down') end
		--if may_roll then print ('The Orange may roll around') end
		--if may_grow then print ('The Orange may grow to a tree') end
		--if may_sink then print ('The Orange may sink into ground') end
		--if may_dirt then print ('The Orange may borrow itself') end
		--if may_rott then print ('The Orange may rot') end
		
		--if may_fall==false then print ('The Orange may NOT fall down') end
		--if may_roll==false then print ('The Orange may NOT roll around') end
		--if may_grow==false then print ('The Orange may NOT grow to a tree') end
		--if may_sink==false then print ('The Orange may NOT sink into ground') end
		--if may_dirt==false then print ('The Orange may NOT borrow itself') end
		--if may_rott==false then print ('The Orange may rot') end
		
		local my_randomevent = math.random(100)
		if my_randomevent <= 18 then
			if may_fall then
				my_xshift = 0
				my_yshift = -1
				my_zshift = 0
				print('falling')
				while minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "air" do
					my_yshift = my_yshift-1
				end
				minetest.env:remove_node(pos)
				minetest.env:add_node({x=pos.x+my_xshift, y=pos.y+my_yshift+1, z=pos.z+my_zshift},{name="growingtrees:orange"})
			end
		elseif my_randomevent <= 36 then
			if may_roll then
				my_xshift = math.random(-1,1)
				my_yshift = 0
				my_zshift = math.random(-1,1)
				
				if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "air" then
					print('rolling x='..pos.x+my_xshift..' y='..pos.y+my_yshift..' z='..pos.z+my_zshift)
					minetest.env:remove_node(pos)
					minetest.env:add_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift},{name="growingtrees:orange"})					
				else
					if may_roll then
						my_xshift = math.random(-1,1)
						my_yshift = 0
						my_zshift = math.random(-1,1)
					
						if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "air" then
							print('rolling')
							minetest.env:remove_node(pos)
							minetest.env:add_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift},{name="growingtrees:orange"})
						else 
							print('failed to roll')
						end
					end				
				end
			end
		elseif my_randomevent <= 54 then
			if may_grow then
				--first check if there's another orange-tree around				
				my_xshift = -5
				my_yshift = 0
				my_zshift = -5
				stuff_around = 0
				while my_xshift <= 5 do
					while my_yshift <= 5 do
						while my_zshift <= 5 do
							if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood1" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood2" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood3" then
								stuff_around = stuff_around+1
							end
							my_zshift = my_zshift+1
						end
						my_zshift = -5
						my_yshift = my_yshift+1
					end
					my_yshift = 0
					my_xshift = my_xshift+1
				end
				local grow_start = math.random(1,2)
				minetest.env:add_node(pos,{name="default:dirt"})
				if stuff_around == 0 then
					--there is no other orange-tree(-trunk) around so lets grow
					if math.random(10) == 1 then
						print('growing a mamut tree')
						minetest.env:add_node({x=pos.x-1, y=pos.y+grow_start, z=pos.z  },{name="growingtrees:groworangewood1"})
						minetest.env:add_node({x=pos.x,   y=pos.y+grow_start, z=pos.z-1},{name="growingtrees:groworangewood1"})
						minetest.env:add_node({x=pos.x+1, y=pos.y+grow_start, z=pos.z  },{name="growingtrees:groworangewood1"})
						minetest.env:add_node({x=pos.x,   y=pos.y+grow_start, z=pos.z+1},{name="growingtrees:groworangewood1"})
						minetest.env:add_node({x=pos.x,   y=pos.y+grow_start, z=pos.z  },{name="growingtrees:groworangewood1"})
					else
						print('growing a tree')
						minetest.env:add_node({x=pos.x, y=pos.y+grow_start, z=pos.z},{name="growingtrees:groworangewood1"})
					end
				else
					--there is another orange-tree near, lets get up
					print('failed to grow (another tree is near), raising.')
					minetest.env:add_node(pos,{name="default:dirt"})
					minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z},{name="growingtrees:orange"})
				end
			end
		elseif my_randomevent <= 68 then
			if may_sink then
				--first check if there's another orange-tree around				
				my_xshift = -5
				my_yshift = 0
				my_zshift = -5
				local new_xshift = math.random(-1,1)
				local new_zshift = math.random(-1,1)
				stuff_around = 0
				local stuff_around2 = 0
				while my_xshift <= 5 do
					while my_yshift <= 5 do
						while my_zshift <= 5 do
							if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood1" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood2" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood3" then
								stuff_around = stuff_around+1
								if my_xshift < 0 then new_xshift =  1 end
								if my_xshift > 0 then new_xshift = -1 end
								if my_zshift < 0 then new_zshift =  1 end
								if my_zshift > 0 then new_zshift = -1 end
							end
							if is_orange_wood({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}) then
								stuff_around2 = stuff_around2+1
							end
							my_zshift = my_zshift+1
						end
						my_zshift = -5
						my_yshift = my_yshift+1
					end
					my_yshift = 0
					my_xshift = my_xshift+1
				end
				print('countet stuff around: '..stuff_around..' : '..stuff_around2);
				if stuff_around == 0 then
					--there is no other orange-tree(-trunk) around so lets sink
					print('sinking')
					if (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "default:water_source") then
						minetest.env:add_node({x=pos.x, y=pos.y-1, z=pos.z},{name="growingtrees:orange"})
						minetest.env:add_node({x=pos.x, y=pos.y-2, z=pos.z},{name="default:dirt"})
					end
					minetest.env:remove_node(pos)
				else
					--there is another orange-tree near, lets roll away from it					
					my_xshift = new_xshift
					my_yshift = 0
					my_zshift = new_zshift
					
					if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "air" then
						print('rolling away from another tree')
						minetest.env:remove_node(pos)
						minetest.env:add_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift},{name="growingtrees:orange"})
					else
						print('Tried to roll away from a tree but theres no air')
					end
				end
			end
		elseif my_randomevent <= 90 then
			if may_dirt then
				print('"dirting"')
				minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z},{name="default:dirt"})
			end
		elseif my_randomevent <= 100 then
			if may_rott then
				print('rotting')
				minetest.env:remove_node(pos)
			end
		end

	end,
})


-- on a bottom-trunk of an orange-tree there might grow another bottom-trunk or a mid-trunk
minetest.register_abm(
	{nodenames = {"growingtrees:groworangewood1"},
	interval = 5,
	chance = 3,
	action = function(pos)
		if minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air" or minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "growingtrees:groworangeleaves" then
			local nextwood = math.random(7);
			if (minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name ~= "air" or minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z-1}).name ~= "air" or minetest.env:get_node({x=pos.x+1, y=pos.y, z=pos.z}).name ~= "air" or minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+1}).name ~= "air") then nextwood = math.random(5) end
			--print (minetest.env:get_node({x=pos.x-1, y=pos.y, z=pos.z}).name)
			--print (minetest.env:get_node({x=pos.x+1, y=pos.y, z=pos.z}).name)
			--print (minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z-1}).name)
			--print (minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+1}).name)
			if nextwood <= 4 then
				minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="growingtrees:groworangewood1"})
			else
				minetest.env:add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="growingtrees:groworangewood2"})
			end
						
		end
	end,
})

-- on a middle-trunk of an orange-tree there might grow another middlöe-trunk or a top-trunk
minetest.register_abm(
	{nodenames = {"growingtrees:groworangewood2"},
	interval = 1,
	chance = 6,
	action = function(pos)
		pos.y=pos.y+1
		if minetest.env:get_node(pos).name == "air" or minetest.env:get_node(pos).name == "growingtrees:groworangeleaves" then
			local nextwood = math.random(2);
			if nextwood == 1 then
				minetest.env:add_node(pos, {name="growingtrees:groworangewood2"})
			end
			if nextwood == 2 then
				minetest.env:add_node(pos, {name="growingtrees:groworangewood3"})
			end
		end
	end,
})

--a mid-trunk might produce leaves around it...
minetest.register_abm(
	{nodenames = {"growingtrees:groworangewood2"},
	interval = 1,
	chance = 5,
	action = function(pos)
		local growdirection = math.random(4)
		if growdirection == 1 then
			pos.x = pos.x+1
		end
		if growdirection == 2 then
			pos.x = pos.x-1
		end
		if growdirection == 3 then
			pos.z = pos.z+1
		end
		if growdirection == 4 then
			pos.z = pos.z-1
		end
		if minetest.env:get_node(pos).name == "air" and (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'air' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangeleaves' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood2'  or minetest.env:get_node({pos.x, pos.y-1, pos.z}).name ~= 'growingtrees:groworangewood3') and (minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'air' or minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangeleaves' or minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangewood2'  or minetest.env:get_node({pos.x, pos.y-2, pos.z}).name ~= 'growingtrees:groworangewood3') then
			minetest.env:add_node(pos, {name="growingtrees:groworangeleaves", param2=10})
		end
	end,
})



--a top-trunk might produce leaves around it...
minetest.register_abm(
	{nodenames = {"growingtrees:groworangewood3"},
	interval = 1,
	chance = 5,
	action = function(pos)
		local growdirection = math.random(5)
		if growdirection == 1 then
			pos.x = pos.x+1
		end
		if growdirection == 2 then
			pos.x = pos.x-1
		end
		if growdirection == 3 then
			pos.y = pos.y+1
		end
		if growdirection == 4 then
			pos.z = pos.z+1
		end
		if growdirection == 5 then
			pos.z = pos.z-1
		end
		if minetest.env:get_node(pos).name == "air" and (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'air' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangeleaves' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood2'  or minetest.env:get_node({pos.x, pos.y-1, pos.z}).name ~= 'growingtrees:groworangewood3') then
			minetest.env:add_node(pos, {name="growingtrees:groworangeleaves", param2=10})
		end
	end,
})


--a leaf might produce more leaves around it...
minetest.register_abm(
	{nodenames = {"growingtrees:groworangeleaves"},
	interval = 1,
	chance = 5,
	action = function(pos,node)
		if (node.param2 > 0 and node.param2 < 50) then
			minetest.env:add_node(pos, {name="growingtrees:groworangeleaves", param2=node.param2-2})
			local growdirection = math.random(5)
			if growdirection == 1 then
				pos.x = pos.x+1
			end
			if growdirection == 2 then
				pos.x = pos.x-1
			end
			if growdirection == 4 then
				minetest.env:add_node(pos, {name="growingtrees:groworangeleaves", param2=node.param2+1})
				pos.y = pos.y+1
			end
			if growdirection == 3 then
				pos.z = pos.z+1
			end
			if growdirection == 4 then
				pos.z = pos.z-1
			end
			if minetest.env:get_node(pos).name == "air" and (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'air' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangeleaves' or minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood2'  or minetest.env:get_node({pos.x, pos.y-1, pos.z}).name ~= 'growingtrees:groworangewood3') then
				--print("leavgen: "..node.param2)
				local growingthing = math.random(30)
				if growingthing <29 then
					minetest.env:add_node(pos, {name="growingtrees:groworangeleaves", param2=node.param2-2})
				else
					minetest.env:add_node(pos, {name="growingtrees:orange"})
				end
			end
		end
	end,
})


--a leaf has a chance to disapear if no orangetree-stuff is around
minetest.register_abm(
	{nodenames = {"growingtrees:groworangeleaves"},
	interval = 5,
	chance = 10,
	action = function(pos,node)
		local stuff_around = 0
		local my_xshift = -1
		local my_yshift = -1
		local my_zshift = -1 -- -1 -1 -1
		while my_zshift <= 1 do
			while my_yshift <= 1 do				
				while my_xshift <= 1 do
					if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangeleaves" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:orange" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood1" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood2" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood3" then stuff_around = stuff_around+1 end
					if minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood1" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood2" or minetest.env:get_node({x=pos.x+my_xshift, y=pos.y+my_yshift, z=pos.z+my_zshift}).name == "growingtrees:groworangewood3" then stuff_around = stuff_around+1 end
					my_xshift = my_xshift+1
				end				
				my_yshift = my_yshift+1
				my_xshift = -1
			end
			my_zshift = my_zshift+1
			my_yshift = -1
		end
			
		if stuff_around <= 8 or (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'air' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangeleaves' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood2'  and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood3' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:orange') or (minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'air' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangeleaves' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangewood2'  and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangewood3' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:orange') then
			print('leaf decal; stuff around:'..stuff_around..'; below:'..minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name..' and:'..minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name)
			minetest.env:remove_node(pos)
			if (math.random(50) == 1) then
				if (minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'air' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangeleaves' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood2'  and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:groworangewood3' and minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= 'growingtrees:orange') then minetest.env:remove_node({x=pos.x, y=pos.y-1, z=pos.z}) end
				if (minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'air' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangeleaves' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangewood2'  and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:groworangewood3' and minetest.env:get_node({x=pos.x, y=pos.y-2, z=pos.z}).name ~= 'growingtrees:orange') then minetest.env:remove_node({x=pos.x, y=pos.y-2, z=pos.z}) end
				print('DESTROYER!!!');
			end
		else
			--print('no leaf decal; stuff around:'..stuff_around)
		end
	end,
})

function is_trunk(pos)
	if minetest.env:get_node(pos).name == "default:tree" then return true end
	if is_orange_wood(pos) then return true end
	return false
	
end

function is_orange_stuff(pos)
	if minetest.env:get_node(pos).name == "growingtrees:orange" then return true end
	if minetest.env:get_node(pos).name == "growingtrees:groworangeleaves" then return true end
	if is_orange_wood(pos) then return true end
	return false
end

function is_orange_wood(pos)
	if minetest.env:get_node(pos).name == "growingtrees:groworangewood1" then return true end
	if minetest.env:get_node(pos).name == "growingtrees:groworangewood2" then return true end
	if minetest.env:get_node(pos).name == "growingtrees:groworangewood3" then return true end
	return false
end

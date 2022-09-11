--[[

Aerial – Minetest mod that allows characters to fly with equipped wings

]]

--[[
	Globals
]]

-- Global mod table
aerial = {
	name = "aerial",
	wings = {},
	flight = {}
}

-- i18n
local S = minetest.get_translator(minetest.get_current_modname())

--[[
	Items
]]

-- Register wings armor type
if minetest.global_exists("armor") and armor.elements then
	table.insert(armor.elements, "wings")
end

-- Create wing registration mechanism
aerial.register_wings = function(material,description,flammable,jump,flyspeed)
	-- Define wing values
	local wingname = aerial.name .. ":wings_" .. material
	local wing = {
		description = S(description),
		inventory_image = "aerial_inv_wings_" .. material .. ".png",
		groups = {
			armor_wings = 1,
			armor_heal = 0,
			armor_use = 0,
			armor_feather = 1,
			physics_jump = jump,
			flammable = flammable
		},
		armor_groups = {},
		damage_groups = {},
		flyspeed = flyspeed,
		name = wingname,
		can_fly = (flyspeed ~= 0)
	}

	-- Save wing in a defined set of wings
	aerial.wings[wingname] = wing

	-- Register wing with 3D Armor
	armor:register_armor(wingname,wing)

	-- Register wing crafting recipe
	local n = armor.materials[material]
	minetest.register_craft({
		output = wingname,
		recipe = {
			{n, "", n},
			{n,  n, n},
			{n, "", n}
		},
	})

	-- Register wing as fuel if it's flammable
	if flammable > 0 then
		minetest.register_craft({
			type = "fuel",
			recipe = wingname,
			burntime = 8,
		})
	end

	-- Register wing visual entity
	minetest.register_entity(wingname, {
		visual = 'mesh',
		mesh = 'wings.b3d',
		visual_size = {x=8, y=8},
		collisionbox = {0},
		physical = false,
		backface_culling = false,
		pointable = false,
		textures = {"aerial_uv_wings_" .. material .. ".png"},

		on_activate = function(self, staticdata)
			minetest.after(.1, function()
					local parent = self.object:get_attach()
					if not parent then
						self.object:remove()
					end
			end)
		end,
	})
end

-- Create wood wings
if armor.materials.wood and minetest.settings:get_bool("aerial_wings_wood",true) then
	aerial.register_wings("wood","Wooden Wings",1,0,0)
end

-- Create cactus wings
if armor.materials.cactus and minetest.settings:get_bool("aerial_wings_cactus",true) then
	aerial.register_wings("cactus","Cactus Wings",1,0,0)
end

-- Create bronze wings
if armor.materials.bronze and minetest.settings:get_bool("aerial_wings_bronze",true) then
	aerial.register_wings("bronze","Bronze Wings",0,0.5,-0.1)
end

-- Create steel wings
if armor.materials.steel and minetest.settings:get_bool("aerial_wings_steel",true) then
	aerial.register_wings("steel","Steel Wings",0,0.6,0.5)
end

-- Create gold wings
if armor.materials.gold and minetest.settings:get_bool("aerial_wings_gold",true) then
	aerial.register_wings("gold","Golden Wings",0,1,1.4)
end

-- Create diamond wings
if armor.materials.diamond and minetest.settings:get_bool("aerial_wings_diamond",true) then
	aerial.register_wings("diamond","Diamond Wings",0,1.5,2)
end

--[[
	Flight logic
]]

-- Flight class
Flight = {
	-- Flight state enum values
	NO_WINGS = 0,
	GROUNDED = 1,
	FLYING = 2,
	SUBMERGED = 3,

	-- Flight object getter
	get = function(player)
		return aerial.flight[player:get_player_name()]
	end,

	-- Flight 'constructor'
	new = function(player)
		local playername = player:get_player_name()
		aerial.flight[playername] = {
			player = player,
			wing = nil,
			speed = 0,
			state = Flight.NO_WINGS,
			entity = nil,
			swapped = false,

			-- Equip wings
			equip = function(flight,wing)
				-- Unequip existing wings with swap=true if replaced with new wings
				if flight.wing then
					flight:unequip(flight.wing,true)
				end

				-- Make wings model visible on player
				local wings_entity = minetest.add_entity(player:get_pos(),wing.name)
				wings_entity:set_attach(player, '', {x=0,y=0.75,z=-2.75})

				-- Set flight values
				flight.wing = wing
				flight.speed = wing.flyspeed
				flight.entity = wings_entity
				flight.state = Flight.GROUNDED
		
				-- Grant flight if wings are capable of flight, revoke flight otherwise
				if wing.can_fly then
					flight:grant()
				else
					flight:revoke()
				end

				-- Prevent fall damage due to feather fall lag
				local groups = player:get_armor_groups()
				groups.fall_damage_add_percent = -9001
				player:set_armor_groups(groups)
			end,
		
			-- Unequip wings
			unequip = function(flight,item,swap)
				-- Remove existing wing model from player
				flight.entity:remove()

				-- Terminate flight if other wings were not swapped in
				if not swap then
					-- Stop flight
					flight:stop()

					-- Remove flight values
					flight.speed = 0
					flight.state = Flight.NO_WINGS
					flight.entity = nil
					flight.wing = nil

					-- Revoke fly privilege
					flight:revoke()

					-- Remove fall damage protection
					local groups = player:get_armor_groups()
					groups.fall_damage_add_percent = nil
					player:set_armor_groups(groups)
				else
					flight.swapped = true
				end
			end,
		
			-- Start flying
			start = function(flight)
				-- Add wing speed if player is flying
				if flight.state ~= Flight.FLYING then
					player:set_physics_override({ speed = player:get_physics_override().speed + flight.speed })
				end

				-- Set flight state
				flight.state = Flight.FLYING

				-- Animate wings while in flight
				flight.entity:set_animation({x = 0, y = 19}, 24)
			end,
		
			-- Stop flying
			stop = function(flight)
				-- Remove wing speed if player is flying
				if flight.state == Flight.FLYING then
					player:set_physics_override({ speed = player:get_physics_override().speed - flight.speed })
				end

				-- Set flight state
				flight.state = Flight.GROUNDED

				-- Wings are still when not in flight
				flight.entity:set_animation()
			end,
		
			-- Grant fly privilege to player if flyspeed is non-zero
			grant = function(flight)
				local privs = minetest.get_player_privs(playername)
				privs.fly = true
				minetest.set_player_privs(playername, privs)
			end,
		
			-- Revoke fly privilege from player
			revoke = function(flight)
				local privs = minetest.get_player_privs(playername)
				privs.fly = nil
				minetest.set_player_privs(playername, privs)
			end
		}
	end,

	-- Flight 'deconstructor'
	delete = function(player)
		aerial.flight[player:get_player_name()] = nil
	end
}

-- Register handler for when wings are equipped
armor:register_on_equip(function(player, index, stack)
	local wing = aerial.wings[stack:get_name()]
	if wing then
		Flight.get(player):equip(wing)
	end
end)

-- Register handler for when wings are unequipped
armor:register_on_unequip(function(player, index, stack)
	local wing = aerial.wings[stack:get_name()]
	if wing then
		local flight = Flight.get(player)
		if flight.swapped then
			flight.swapped = false
		else
			flight:unequip(wing)
		end
	end
end)

-- Register joined players with flight tracker; on_equip gets called after
minetest.register_on_joinplayer(Flight.new)

-- Remove disconnected players from flight tracker
minetest.register_on_leaveplayer(Flight.delete)

-- Node flight grounding detection
function nodesAreGrounding(coords)
	for _,coord in ipairs(coords) do
		if minetest.registered_nodes[minetest.get_node(coord).name].walkable then
			return true
		end
	end
	return false
end

-- Node liquid detection
function nodeIsLiquid(coords)
	return minetest.registered_nodes[minetest.get_node(coords).name].liquidtype ~= "none"
end

-- Flight detection and state management
local interval = tonumber(minetest.settings:get("aerial_flight_tick_ms")) / 1000
local stime = interval + 1
minetest.register_globalstep(function(dtime)
	-- Only check per interval
	stime = stime + dtime
	if stime >= interval then
		stime = stime % interval
	else
		return
	end

	-- Iterate over flights
	for _,flight in pairs(aerial.flight) do repeat
		-- Nothing to do if player has no wings
		if flight.state == Flight.NO_WINGS then
			break
		end

		-- Get player's location
		local pos = flight.player:get_pos()

		-- Can't fly when submerged in liquids
		if nodeIsLiquid(pos) then
			if flight.state ~= Flight.SUBMERGED then
				flight:stop()
				flight:revoke()
				flight.state = Flight.SUBMERGED
			end
			break
		elseif flight.state == Flight.SUBMERGED then
			if flight.wing.can_fly then
				flight:grant()
			end
			flight.state = Flight.GROUNDED
		end

		-- Set coords below player's location
		pos.y = pos.y - 1
		local adj = {pos}

		-- Ledge detection if player is likely to be standing on a node
		local ymod = math.abs(pos.y) % 1
		if ymod >= 0.5 and ymod < 0.575 then
			-- Get x/z fraction parts
			local xmod = math.abs(pos.x) % 1
			local zmod = math.abs(pos.z) % 1

			-- Corner coords at x/z edges
			local xcorner = {}
			local zcorner = {}

			-- x/z offsets
			local xoffset = pos.x >= 0 and 0.5 or -0.5
			local zoffset = pos.z >= 0 and 0.5 or -0.5

			-- If x meets upper tolerance
			if xmod > 0.5 and xmod < 0.875 then
				table.insert(adj,{ x = pos.x - xoffset, y = pos.y, z = pos.z })
				table.insert(xcorner,pos.x - xoffset)
			end

			-- If x meets lower tolerance
			if xmod < 0.575 and xmod > 0.2 then
				table.insert(adj,{ x = pos.x + xoffset, y = pos.y, z = pos.z })
				table.insert(xcorner,pos.x + xoffset)
			end

			-- If z meets upper tolerance
			if zmod > 0.5 and zmod < 0.875 then
				table.insert(adj,{ x = pos.x, y = pos.y, z = pos.z - zoffset })
				table.insert(zcorner,pos.z - zoffset)
			end

			-- If z meets lower tolerance
			if zmod < 0.575 and zmod > 0.2 then
				table.insert(adj,{ x = pos.x, y = pos.y, z = pos.z + zoffset })
				table.insert(zcorner,pos.z + zoffset)
			end

			-- Add corner nodes
			for _,xcoord in ipairs(xcorner) do
				for _,zcoord in ipairs(zcorner) do
					table.insert(adj,{x = xcoord, y = pos.y, z = zcoord})
				end
			end
		end

		-- Flight state transitions
		if flight.state == Flight.GROUNDED and not nodesAreGrounding(adj) then
			flight:start()
		elseif flight.state == Flight.FLYING and nodesAreGrounding(adj) then
			flight:stop()
		end
	until true end
end)
-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.make)

function _M:run()
	local list = {}
	local escort_count = 0
	game.player.advance_zones_data = {}

	game:registerDialog(require('engine.dialogs.GetText').new("Advance Through Zones", "Enter a comma delimited list of zones or zone tiers to clear", 1, 9999, function(text)
		
		list = self:getZones(text)
		game.player.no_inventory_access = true
		game.player.invulnerable = true

		for i, zone in ipairs(list) do
			game.player.advance_zones_data[i] = {name=zone, data=self:clearZone(zone)}
			escort_count = escort_count + game.player.advance_zones_data[i].data.escort_count
		end
		game.player.no_inventory_access = nil
		game.player.invulnerable = nil

		-- Do some analysis of where the experience came from and show it
		for i, zone in ipairs(game.player.advance_zones_data) do
			local exp_list = self:getExpBreakdown(zone.data)
			game.log(("%s:  Level %0.2f to %0.2f (#LIGHT_STEEL_BLUE#+%0.2f#LAST#)"):format(zone.name, zone.data.start_level, zone.data.end_level, zone.data.end_level - zone.data.start_level ))
			game.log(exp_list)
		end

		local old_name = game.zone.short_name  -- Change the zone name each iteration so the quest id is different
		for i = 1, escort_count do
			if escort_count == 0 then break end
			game.zone.short_name = game.zone.short_name..i
			game.player:grantQuest("escort-duty")
			for _, e in pairs(game.level.entities) do
				if e.quest_id then
					e.invulnerable = true
					-- Make giving the reward their first action so it happens after the dialogs are closed
					e.act = function(self)
						self.on_die = nil
						game.player:setQuestStatus(self.quest_id, engine.Quest.DONE)
						local Chat = require "engine.Chat"
						Chat.new("escort-quest", self, game.player, {npc=self}):invoke()
						self:disappear()
						self:removed()
						game.party:removeMember(self, true)
					end
				end
			end
			game.zone.short_name = old_name
		end

		-- Drop unimportant stuff on the ground, leave important things in transmog
		local drop_list = {}
		game.player:inventoryApply(game.player:getInven("INVEN"), function(inven, item, o)
		if o.randart_able and o.slot and not (o.unique or o.rare) and not o.greater_ego then
			drop_list[#drop_list+1] = {inven, item}
		end
		end)

		for _, item in ripairs(drop_list) do
			game.player:dropFloor(item[1], item[2], false, true)
		end

		game.log("#RED#Low value items have been dropped on the ground.#LAST#")
	end))
end

function _M:getExpBreakdown(zone_data)
	local total = 0
	local ranks = {}
	for _, level in ipairs(zone_data) do
		-- Total the exp from the levels by rank
		for _, act in ipairs(level.exp_list) do
			ranks[act.rank_name] = ranks[act.rank_name] or {}
			ranks[act.rank_name].rank = act.rank
			ranks[act.rank_name].rank_color = act.rank_color
			ranks[act.rank_name].exp = (ranks[act.rank_name].exp or 0) + act.exp
			ranks[act.rank_name].amt = (ranks[act.rank_name].amt or 0) + 1

			total = total + act.exp
		end
	end

	local str = ""
	local order = function(a, b) return a[2].rank > b[2].rank end
	for rank, vals in table.orderedPairs2(ranks, order) do
		local pct = math.floor(vals.exp / total * 100)
		str = str..vals.rank_color..rank.."#LAST# "..tostring(pct).."%% ("..vals.amt..")\n"
	end

	return str
end

-- Gets a full zone list from a comma delmited string of tier identifiers and zone names
function _M:getZones(zones)
	if not zones then return end
	local list = {}
	local list2 = {}
	for word in zones:gmatch('[^,%s]+') do
		list[#list+1] = word
	end

	local is_template = false
	for i,zone in ipairs(list) do
		-- Check if were a template instead of a zone name
		if game.state.birth.zone_tiers then
			for _, template in ipairs(game.state.birth.zone_tiers) do
				if template.name == zone then
					is_template = template
				end
			end
		end

		if is_template then
			-- bonus_tier_zones handles special start zones and such, races/classes define a condition to be met to add them to a zone list
			if game.state.birth.bonus_zone_tiers then
				for _, template in ipairs(game.state.birth.bonus_zone_tiers) do
					if template.name == zone and template.condition(game.player) then
						for i, zone in ipairs(template) do
							list2[#list2+1] = zone
						end
					end
				end
			end

			for i, zone in ipairs(is_template) do
				list2[#list2+1] = zone
			end
		else
			list2[#list2+1] = zone
		end
		is_template = false
	end
	return list2
end

function _M:clearLevel()
	local act = game.player
	local data = {}
	data.items_list = {}
	data.items_skipped = {}
	data.exp_list = {}
	data.ranks = {}
	data.total_exp = 0
	data.start_level = act:getExpChart(act.level+1)
	data.end_level = act.level

	-- Ensure any early turn state stuff happens like NPCs spawning their escorts
	for i = 1,20 do
		game.player.energy.value = 0
		game:tick(game.level)
	end

	local l = {}
	for uid, e in pairs(game.level.entities) do
		if e.__is_actor and not game.party:hasMember(e) and (act:reactionToward(e) < 0) then l[#l+1] = e end
	end
	
	-- Technically we should simulate this with actual player movement in case kill sequence is important.. not worth the effort
	for i, e in ipairs(l) do
		local rname, rcolor = e:TextRank()
		data.exp_list[#data.exp_list+1] = {exp=e:worthExp(act), name=e.name, rank=e.rank, rank_name = rname:capitalize(), rank_color = rcolor }
		data.ranks[e:TextRank()] = data.ranks[e:TextRank()] or 0
		data.ranks[e:TextRank()] = data.ranks[e:TextRank()] + 1
		data.total_exp = data.total_exp + e:worthExp(act)
		e:die(act)
	end

	-- Grab all items on the map
	for x = 0, game.level.map.w - 1 do for y = 0, game.level.map.h - 1 do
		for i = game.level.map:getObjectTotal(x, y), 1, -1 do
			local o = game.level.map:getObject(x, y, i)
			if o and self:pickupObject(i, x, y) then
				if act:transmoFilter(o) then o.__transmo = true end
				data.items_list[#data.items_list + 1] = o  -- Store items incase we want to do analysis on drops or some such.. should clone?
			end
		end
	end end

	data.end_level = act:getExpChart(act.level+1)
	return data
end

-- TODO:  
--	- Let zones define special behavior instead of just modify level count or reject being allowed (Celestial start, ...)
--	- More stats
--	- Log multiple run stats
--  - Better UI
function _M:clearZone(zone, escort_zones)
	if not game:changeLevelCheck(1, zone) then game.log("Unable to level change to floor 1 of "..zone) end
	if game.zone.debug_auto_clear and game.zone.debug_auto_clear == 0 then game.log(zone.." is not valid for autoclear") end
	
	local cur_exp, max_exp = game.player.exp, game.player:getExpChart(game.player.level+1)
	local start_level = game.player.level + math.min(1, math.max(0, cur_exp / max_exp))
	local data = {start_level = start_level, end_level = start_level, escort_count = 0}
	local old_random_escort_levels = table.clone(game.player.random_escort_levels, true)
	game.player.random_escort_levels = nil
	
	local get_fake_escort = function()
		local escort_zone_name = game.zone.short_name
		local escort_zone_offset = 0	
		if game.zone.tier1_escort then
			escort_zone_offset = game.zone.tier1_escort - 1
			game.player.entered_tier1_zones = game.player.entered_tier1_zones or {}
			game.player.entered_tier1_zones.seen = game.player.entered_tier1_zones.seen or {}
			game.player.entered_tier1_zones.nb = game.player.entered_tier1_zones.nb or 0
			if not game.player.entered_tier1_zones.seen[game.zone.short_name] then
				game.player.entered_tier1_zones.nb = game.player.entered_tier1_zones.nb + 1
				game.player.entered_tier1_zones.seen[game.zone.short_name] = game.player.entered_tier1_zones.nb
			end
			escort_zone_name = "tier1."..game.player.entered_tier1_zones.seen[game.zone.short_name]
		end
		if old_random_escort_levels and old_random_escort_levels[escort_zone_name] and old_random_escort_levels[escort_zone_name][game.level.level - escort_zone_offset] then
			old_random_escort_levels[escort_zone_name][game.level.level - escort_zone_offset] = nil  -- Remove the zone from the escort list
			return escort_zone_name
		end
	end

	game:changeLevel(1, zone)
	
	if get_fake_escort() then data.escort_count = data.escort_count + 1 end
	local max_floors = game.zone.debug_auto_clear_max_levels and game.zone.debug_auto_clear_max_levels or game.zone.max_level

	local i = 1
	while game.level.level < (max_floors) and i < 20 do
		data[#data+1] = self:clearLevel()
		if not game:changeLevelCheck(game.level.level + 1, game.zone.short_name) then
			game.log("Unable to level change to floor "..i.." of "..zone)
			break 
		end
		game:changeLevel(game.level.level + 1, game.zone.short_name)
		if get_fake_escort() then data.escort_count = data.escort_count + 1 end

		i = i + 1
	end
	data[#data+1] = self:clearLevel()
	cur_exp, max_exp = game.player.exp, game.player:getExpChart(game.player.level+1)
	data.end_level = game.player.level + math.min(1, math.max(0, cur_exp / max_exp))
	game.player.random_escort_levels = old_random_escort_levels

	return data
end

-- Modified Object.pickupFloor so we don't have to move to each space, suppress dialogs, filter stuff, etc
function _M:pickupObject(i, x, y)
	local ShowPickupFloor = require_first("mod.dialogs.ShowPickupFloor", "engine.dialogs.ShowPickupFloor")
	local act = game.player
	local inven = act:getInven(act.INVEN_INVEN)
	if not inven then return end
	local o = game.level.map:getObject(x, y, i)
	if o then
		o.no_unique_lore = true
		local prepickup = o:check("on_prepickup", act, i)
		if not prepickup then
			local num = o:getNumber()
			local ok, slot, ro = act:addObject(act.INVEN_INVEN, o)
			if ok then
				local newo = inven[slot] -- get exact object added or stack (resolves duplicates)
				game.level.map:removeObject(x, y, i)
				if ro then -- return remaining stack to floor
					game.level.map:addObject(x, y, ro)
					num = num - ro:getNumber()
				end
				act:sortInven(act.INVEN_INVEN)
				-- Apply checks to whole stack (including already carried) assuming homogeneous stack
				-- num added passed to functions to allow checks on part of the stack
				newo:check("on_pickup", act, num)
				act:check("on_pickup_object", newo, num)

				slot = act:itemPosition(act.INVEN_INVEN, newo, true) or 1
				local letter = ShowPickupFloor:makeKeyChar(slot)

				return inven[slot], num
			else
				return
			end
		elseif prepickup == "skip" then
			return
		else
			return true
		end
	end
end

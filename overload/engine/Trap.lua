-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
local Entity = require "engine.Entity"
local Map = require "engine.Map"

--- Describes a trap
-- @classmod engine.Trap
module(..., package.seeall, class.inherit(Entity))

_M.display_on_seen = true
_M.display_on_remember = true
_M.display_on_unknown = false
_M.__is_trap = true
_M.__position_aware = true

function _M:init(t, no_default)
	t = t or {}

	assert(t.triggered, "no trap triggered action")

	Entity.init(self, t, no_default)

	if self.disarmable == nil then
		self.disarmable = true
	end

	self.detect_power = self.detect_power or 1
	self.disarm_power = self.disarm_power or 1

	self.known_by = {}
	self:loaded()
end

function _M:loaded()
	Entity.loaded(self)
	-- known_by table is a weak table on keys, so that it does not prevent garbage collection of actors
	setmetatable(self.known_by, {__mode="k"})
end

--- Setup minimap color for this entity
-- You may overload this method to customize your minimap
function _M:setupMinimapInfo(mo, map)
	mo:minimap(240, 240, 0)
end

--- Do we have enough energy
function _M:enoughEnergy(val)
	val = val or game.energy_to_act
	return self.energy.value >= val
end

--- Use some energy
function _M:useEnergy(val)
	val = val or game.energy_to_act
	self.energy.value = self.energy.value - val
end

--- Get trap name
-- Can be overloaded to do trap identification if needed
function _M:getName()
	return self.name
end

--- Setup the trap
function _M:setup()
end

--- Set the known status for the given actor
function _M:setKnown(actor, v)
	self.known_by[actor] = v
end

--- Get the known status for the given actor
function _M:knownBy(actor)
	return self.all_know or self.known_by[actor]
end

--- Can we disarm this trap?
function _M:canDisarm(x, y, who)
	if not self.disarmable then return false end
	return true
end

--- Try to disarm the trap
function _M:disarm(x, y, who)
	if not self:canDisarm(x, y, who) then
		game.logSeen(who, "%s fails to disarm a trap (%s).", who.name:capitalize(), self:getName())
		return false
	end
	game.logSeen(who, "%s disarms a trap (%s).", who.name:capitalize(), self:getName())
	game.level.map:remove(x, y, Map.TRAP)
	if self.removed then
		self:removed(x, y, who)
	end

	self:onDisarm(x, y, who)
	return true
end

--- Trigger the trap
function _M:trigger(x, y, who)
	-- Try to disarm
	if self:knownBy(who) then
		if self:disarm(x, y, who) then
			return
		end
	end

	if not self:canTrigger(x, y, who) then return end

	if self.message == nil then
		game.logSeen(who, "%s triggers a trap (%s)!", who.name:capitalize(), self:getName())
	elseif self.message == false then
		-- Nothing
	else
		local tname = who.name
		local str = self.message
		--str = str:gsub("@target@", "%%s")
		--str = str:gsub("@Target@", "%%s")
		game.logSeen(who, str, tname)
	end
	local known, del = false, false
	if self.summoner then self.summoner.__project_source = self end -- intermediate projector source
	if self.triggered then known, del = self:triggered(x, y, who) end
	if self.summoner then self.summoner.__project_source = nil end
	if known then
		self:setKnown(who, true, x, y)
		game.level.map:updateMap(x, y)
	end
	if del then
		game.level.map:remove(x, y, Map.TRAP)
		if self.removed then self:removed(x, y, who) end
	end
end

--- When moving on a trap, trigger it
function _M:on_move(x, y, who, forced)
	if not forced then self:trigger(x, y, who) end
end

--- Called when disarmed
function _M:onDisarm(x, y, who)
end

--- Called when triggered
function _M:canTrigger(x, y, who)
	return true
end

--- Return the kind of the entity
function _M:getEntityKind()
	return "trap"
end

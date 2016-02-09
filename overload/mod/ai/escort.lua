-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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

local Astar = require "engine.Astar"

-- AI for the escort quest
-- the NPC will run toward the portal, if hostiles are in sight he attacks them
newAI("escort_quest", function(self)
	if self.ai_state.tactic_escort_rest then
		self.ai_state.tactic_escort_rest = self.ai_state.tactic_escort_rest - 1
		-- Rest
		if self.ai_state.tactic_escort_rest > 0 then self:useEnergy() return true
		-- Cooldown
		elseif self.ai_state.tactic_escort_rest < -20 then self.ai_state.tactic_escort_rest = nil
		end
	end

	if self:runAI("target_simple") then
		-- One in "talent_in" chance of using a talent
		if rng.chance(self.ai_state.talent_in or 6) and self:reactionToward(self.ai_target.actor) < 0 then
			self:runAI("dumb_talented")
		end
		if not self.energy.used then
			local dist = self.ai_target.actor and core.fov.distance(self.x, self.y, self.ai_target.actor.x, self.ai_target.actor.y)
			if self:reactionToward(self.ai_target.actor) < 0 and dist <= 10 and self:hasLOS(self.ai_target.actor.x, self.ai_target.actor.y, "block_move") and not self:hasLOS(self.escort_target.x, self.escort_target.y, "block_move") then
				self:runAI("flee_dmap")
				if not self.ai_state.fleeing_msg then
					self.ai_state.fleeing_msg = true
					local enemy = self.ai_target.actor
					local dir = game.level.map:compassDirection(enemy.x-self.x, enemy.y-self.y)
					if dir == "northwest" then dir = "西北方向"
					elseif dir == "northeast" then dir = "东北方向"
					elseif dir == "southwest" then dir = "西南方向"
					elseif dir == "southeast" then dir = "东南方向"
					elseif dir == "east" then dir = "东面"
					elseif dir == "west" then dir = "西面"
					elseif dir == "south" then dir = "南面"
					elseif dir == "north" then dir = "北面"
					end
					self:doEmote("救命！"..(dir and (" %s 在 %s!"):format(self:canSee(enemy) and npcCHN:getName(enemy.name) or "Something", dir) or ""))
				end
			else
				self:runAI("move_escort")
				self.ai_state.fleeing_msg = nil
			end
		end
		return true
	end
	if not self.energy.used then
		self:runAI("move_escort")
		return true
	end
end)

newAI("move_escort", function(self)
	if self.escort_target then
		-- Randomly stop to give time to the player
		if rng.percent(35) then self:useEnergy() return true end

		local tx, ty = self.escort_target.x, self.escort_target.y
		local a = Astar.new(game.level.map, self)
		local path = self.escort_path
		if path and path[1] and core.fov.distance(self.x, self.y, path[1].x, path[1].y) > 1 then self.escort_path = nil path = nil end
		if not path or #path == 0 then path = a:calc(self.x, self.y, tx, ty) end
		if not path then
			return self:runAI("move_simple")
		else
			self.escort_path = {}
			local ret = self:move(path[1].x, path[1].y)
			if self.x == path[1].x and self.y == path[1].y then
				for i = 1, 3 do if path[i+1] then self.escort_path[i] = path[i+1] end end
			end
			return ret
		end
	end
end)


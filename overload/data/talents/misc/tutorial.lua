-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

-- race & classes
newTalentType{ type="tutorial", name = "tutorial", hide = true, description = "Tutorial-specific talents." }

newTalent{
	name = "Shove", short_name = "TUTORIAL_PHYS_KB",
	type = {"tutorial", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		if self:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist()) then
			target:knockback(self.x, self.y, 1)
		else
			game.logSeen(target, "%s resists the shove!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[将 目 标 击 退 一 码。]])
	end,
}

newTalent{
	name = "Mana Gale", short_name = "TUTORIAL_SPELL_KB",
	type = {"tutorial", 1},
	points = 5,
	range = 3,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if self:checkHit(self:combatSpellpower(), target:combatPhysicalResist()) then
			target:knockback(self.x, self.y, self:getTalentLevel(t))
			game.logSeen(target, "%s is knocked back by the gale!", target.name:capitalize())
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatSpellpower())
		else
			game.logSeen(target, "%s remains firmly planted in the face of the gale!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		local dist = self:getTalentLevel(t)
		return ([[施 放 一 股 强 力 的 魔 法 风 暴， 将 目 标 击 退 %d 码。]]):format(dist)
	end,
}

newTalent{
	name = "Telekinetic Punt", short_name = "TUTORIAL_MIND_KB",
	type = {"tutorial", 1},
	points = 5,
	range = 3,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if self:checkHit(self:combatMindpower(), target:combatPhysicalResist()) then
			target:knockback(self.x, self.y, 1)
			game.logSeen(target, "%s is knocked back by the telekinetic blow!", target.name:capitalize())
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatMindpower())
		else
			game.logSeen(target, "%s holds its ground!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[使 用 念 力 将 目 标 击 退 的 一 次 强 力 打 击。]])
	end,
}

newTalent{
	name = "Blink", short_name = "TUTORIAL_SPELL_BLINK",
	type = {"tutorial", 1},
	points = 5,
	range = 3,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if self:checkHit(self:combatSpellpower(), target:combatSpellResist()) then
			target:knockback(self.x, self.y, 1)
			game.logSeen(target, "%s is teleported a short distance!", target.name:capitalize())
			target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
		else
			game.logSeen(target, "%s resists the teleportation!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[将 目 标 轻 微 的 传 送 至 远 处。]])
	end,
}

newTalent{
	name = "Fear", short_name = "TUTORIAL_MIND_FEAR",
	type = {"tutorial", 1},
	points = 5,
	range = 3,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if self:checkHit(self:combatMindpower(), target:combatMentalResist()) then
			target:knockback(self.x, self.y, 1)
			game.logSeen(target, "%s retreats in terror!", target.name:capitalize())
			target:crossTierEffect(target.EFF_BRAINLOCKED, self:combatMindpower())
		else
			game.logSeen(target, "%s shakes off the fear!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[尝 试 恐 惧 目 标 使 其 逃 跑。]])
	end,
}

newTalent{
	name = "Bleed", short_name = "TUTORIAL_SPELL_BLEED",
	type = {"tutorial", 1},
	points = 5,
	range = 5,
	random_ego = "attack",
	cooldown = 0,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if target then
			target:setEffect(self.EFF_CUT, 10, {power=1, apply_power=self:combatSpellpower()})
		end
		return true
	end,
	info = function(self, t)
		return ([[制 造 10 回 合 的 流 血 效 果。]])
	end,
}

newTalent{
	name = "Confusion", short_name = "TUTORIAL_MIND_CONFUSION",
	type = {"tutorial", 1},
	points = 5,
	range = 3,
	random_ego = "attack",
	cooldown = 6,
	requires_target = true,
	tactical = { ATTACK = 2},
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		if target then
			target:setEffect(self.EFF_CONFUSED, 5, {power=100, apply_power=self:combatMindpower()})
		end
		return true
	end,
	info = function(self, t)
		return ([[使 用 你 的 精 神 力 量 使 目 标 混 乱 5 回 合。]])
	end,
}

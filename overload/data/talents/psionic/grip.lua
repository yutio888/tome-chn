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

newTalent{
	name = "Bind",
	type = {"psionic/grip", 1},
	require = psi_cun_high1,
	points = 5,
	random_ego = "attack",
	cooldown = 25,
	psi = 10,
	tactical = { DISABLE = 2 },
	range = function(self, t)
		local r = 5
		local mult = 1 + 0.01*self:callTalent(self.T_REACH, "rangebonus")
		return math.floor(r*mult)
	end,
	getDuration = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 3, 10))
	end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=0, selffire=false, talent=t} end,
	action = function(self, t)
		local dur = t.getDuration(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(self.EFF_PSIONIC_BIND, dur, {power=1, apply_power=self:combatMindpower()})
		else
			return
		end
		return true
	end,
	info = function(self, t)
		local dur = t.getDuration(self, t)
		return ([[用 巨 大 的 束 缚 超 能 力 值 捆 住 目 标 %d 回 合。 
		 受 精 神 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(dur)
	end,
}

newTalent{
	name = "Greater Telekinetic Grasp",
	type = {"psionic/grip", 4},
	require = psi_cun_high4,
	hide = true,
	points = 5,
	mode = "passive",
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.50) end, -- Limit < 100%
	stat_sub = function(self, t) -- called by _M:combatDamage in mod\class\interface\Combat.lua
		return self:combatTalentScale(t, 0.64, 0.80)
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "disarm_immune", t.getImmune(self, t))
	end,
	info = function(self, t)
		local boost = 100 * t.stat_sub(self, t)
		return ([[用 细 致 的 操 控 来 增 加 你 的 肉 体 支 配 和 灵 能 支 配。 
		 此 技 能 有 以 下 效 果： 
		 增 加 %d%% 缴 械 免 疫。 
		 当 使 用 充 能 武 器 造 成 伤 害 时， 用 %d%% 意 志 和 灵 巧（ 通 常 60%%） 来 代 替 力 量 和 敏 捷 决 定 伤 害。 
		 在 等 级 5 时， 意 念 装 备 的 宝 石 或 灵 晶 的 品 质 提 升 一 级。]]):
		format(t.getImmune(self, t)*100, boost)
	end,
}
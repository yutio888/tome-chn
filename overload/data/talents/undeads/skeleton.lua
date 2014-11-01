-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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
	name = "Skeleton",
	type = {"undead/skeleton", 1},
	mode = "passive",
	require = undeads_req1,
	points = 5,
	statBonus = function(self, t) return self:combatTalentScale(t, 2, 10, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_STR]=t.statBonus(self, t)})
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_DEX]=t.statBonus(self, t)})
	end,
	info = function(self, t)
		return ([[调 整 你 的 骷 髅 体 质， 增 加 %d 点 力 量 和 敏 捷。]]):
		format(t.statBonus(self, t))
	end,
}

newTalent{
	name = "Bone Armour",
	type = {"undead/skeleton", 2},
	require = undeads_req2,
	points = 5,
	cooldown = 30,
	tactical = { DEFEND = 2 },
	getShield = function(self, t)
		return 3.5*self:getDex()+self:combatTalentScale(t, 120, 400) + self:combatTalentLimit(t, 0.1, 0.01, 0.05)*self.max_life
	end,

	action = function(self, t)
		self:setEffect(self.EFF_DAMAGE_SHIELD, 10, {color={0xcb/255, 0xcb/255, 0xcb/255}, power=t.getShield(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[在 你 的 周 围 制 造 一 个 能 吸 收 %d 点 伤 害 的 骨 盾。 持 续 10 回 合。 
		受 敏 捷 影 响， 护 盾 的 最 大 吸 收 值 有 额 外 加 成。]]):
		format(t.getShield(self, t))
	end,
}

newTalent{
	name = "Resilient Bones",
	type = {"undead/skeleton", 3},
	require = undeads_req3,
	points = 5,
	mode = "passive",
	range = 1,
	-- called by _M:on_set_temporary_effect function in mod.class.Actor.lua
	durresist = function(self, t) return self:combatTalentLimit(t, 1, 0.1, 5/12) end, -- Limit < 100%
	info = function(self, t)
		return ([[你 的 骨 头 充 满 弹 性， 至 多 减 少 %d%% 所 有 负 面 状 态 持 续 的 时 间。]]):
		format(100 * t.durresist(self, t))
	end,
}

newTalent{ short_name = "SKELETON_REASSEMBLE",
	name = "Re-assemble",
	type = {"undead/skeleton",4},
	require = undeads_req4,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 41, 25)) end, -- Limit cooldown >10
	getHeal = function(self, t)
		return self:combatTalentScale(t, 100, 500) + self:combatTalentLimit(t, 0.1, 0.01, 0.05)*self.max_life
	end,
	tactical = { HEAL = 2 },
	is_heal = true,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 5 then
			self:attr("self_resurrect", 1)
		end
	end,
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 4 then
			self:attr("self_resurrect", -1)
		end
	end,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(t.getHeal(self, t), t)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[重 新 组 合 你 的 骨 头， 治 疗 你 %d 点 生 命 值。 
		在 等 级 5 时 你 将 会 得 到 重 塑 自 我 的 能 力， 被 摧 毁 后 可 以 原 地 满 血 复 活。（ 仅 限 1 次）]]):
		format(t.getHeal(self, t))
	end,
}

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
	name = "Strength of Purpose",
	type = {"chronomancy/temporal-combat", 1},
	require = temporal_req1,
	mode = "sustained",
	points = 5,
	sustain_stamina = 50,
	sustain_paradox = 100,
	cooldown = 18,
	tactical = { BUFF = 2 },
	getPower = function(self, t) return math.ceil(self:combatTalentScale(t, 1.5, 7.5, 0.75) + self:combatTalentStatDamage(t, "wil", 5, 20)) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		return {
			stats = self:addTemporaryValue("inc_stats", {[self.STAT_STR] = t.getPower(self, t)}),
			phys = self:addTemporaryValue("combat_physresist", t.getPower(self, t)),
			particle = self:addParticles(Particles.new("temporal_focus", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("inc_stats", p.stats)
		self:removeTemporaryValue("combat_physresist", p.phys)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你 已 经 学 会 通 过 控 制 时 空 的 流 动 来 增 强 力 量。 
		 增 加 %d 点 力 量 和 物 理 豁 免。 
		 受 意 志 影 响， 效 果 按 比 例 加 成。]]):format(power)
	end
}

newTalent{
	name = "Invigorate",
	type = {"chronomancy/temporal-combat", 2},
	require = temporal_req2,
	points = 5,
	paradox = 10,
	cooldown = 24,
	tactical = { STAMINA = 2 },
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(self:getTalentLevel(t)*getParadoxModifier(self, pm), 14, 4, 8)) end, -- Limit < 14
	getPower = function(self, t) return self:combatTalentScale(t, 1.5, 5) end,
	action = function(self, t)
		self:setEffect(self.EFF_INVIGORATE, t.getDuration(self,t), {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 接 下 来 的 %d 回 合 里， 每 回 合 你 可 以 回 复 %0.1f 点 体 力， 并 且 正 在 冷 却 的 技 能 会 以 双 倍 速 度 刷 新。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成。]]):format(duration, power)
	end,
}

newTalent{
	name = "Quantum Feed",
	type = {"chronomancy/temporal-combat", 3},
	require = temporal_req3,
	mode = "sustained",
	points = 5,
	sustain_stamina = 50,
	sustain_paradox = 100,
	cooldown = 18,
	tactical = { BUFF = 2 },
	getPower = function(self, t) return self:combatTalentScale(t, 1.5, 7.5, 0.75) + self:combatTalentStatDamage(t, "wil", 5, 20) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		return {
			stats = self:addTemporaryValue("inc_stats", {[self.STAT_MAG] = t.getPower(self, t)}),
			spell = self:addTemporaryValue("combat_spellresist", t.getPower(self, t)),
			particle = self:addParticles(Particles.new("arcane_power", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("inc_stats", p.stats)
		self:removeTemporaryValue("combat_spellresist", p.spell)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你 已 经 学 会 通 过 控 制 时 空 的 流 动 来 增 强 魔 力。 
		 增 加 %d 点 魔 法 和 法 术 豁 免。 
		 受 意 志 影 响， 效 果 按 比 例 加 成。]]):format(power)
	end
}

newTalent{
	name = "Damage Smearing",
	type = {"chronomancy/temporal-combat",4},
	require = temporal_req4,
	points = 5,
	paradox = 25,
	cooldown = 25,
	tactical = { DEFEND = 2 },
	no_energy = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(self:getTalentLevel(t) * getParadoxModifier(self, pm), 25, 3, 7)) end, -- Limit < 25
	action = function(self, t)
		self:setEffect(self.EFF_DAMAGE_SMEARING, t.getDuration(self,t), {})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 接 下 来 %d 回 合 内， 你 转 化 所 有 受 到 的 非 时 空 伤 害 为 持 续 6 回 合 的 时 空 伤 害 释 放 出 去。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成。]]):format (duration)
	end,
}

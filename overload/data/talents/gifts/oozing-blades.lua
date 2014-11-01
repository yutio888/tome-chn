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
	name = "Oozebeam",
	type = {"wild-gift/oozing-blades", 1},
	require = gifts_req_high1,
	points = 5,
	equilibrium = 4,
	cooldown = 3,
	tactical = { ATTACKAREA = { NATURE = 2 },  DISABLE = 1 },
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 290) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.SLIME, dam)
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "ooze_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在 你 的 心 灵 利 刃 里 充 填 史 莱 姆 能 量， 延 展 攻 击 范 围, 形 成 一 道 射 线， 造 成 %0.1f 点 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.NATURE, dam))
	end,
}

newTalent{
	name = "Natural Acid",
	type = {"wild-gift/oozing-blades", 2},
	require = gifts_req_high2,
	points = 5,
	mode = "passive",
	getResist = function(self, t) return self:combatTalentMindDamage(t, 10, 40) end,
	-- called in data.timed_effects.physical.lua for the NATURAL_ACID effect
	getNatureDamage = function(self, t, level)
		return self:combatTalentScale(t, 5, 15, 0.75)*math.min(5, level or 1)^0.5/2.23
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5, "log")) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists", {[DamageType.NATURE]=t.getResist(self, t)})
	end,
	info = function(self, t)
		return ([[ 你 的 自 然 抗 性 增 加 %d%%。
		 当 你 造 成 酸 性 伤 害 时 ， 你 的 自 然 伤 害 增 加 %0.1f%%， 持 续 %d 回 合。
		 伤 害 加 成 能 够 积 累 到 最 多 4 倍 （ 1 回 合 至 多 触 发 1 次 ） ， 最 大 值 %0.1f%%。
		 受 精 神 强 度 影 响 ， 抗 性 和 伤 害 加 成 有 额 外 加 成 。]]):
		format(t.getResist(self, t), t.getNatureDamage(self, t, 1), t.getDuration(self, t), t.getNatureDamage(self, t, 5))
	end,
}

newTalent{
	name = "Mind Parasite",
	type = {"wild-gift/oozing-blades", 3},
	require = gifts_req_high3,
	points = 5,
	equilibrium = 12,
	cooldown = 15,
	range = 6,
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime", trail="slimetrail"}} end,
	tactical = { DISABLE = 2 },
	requires_target = true,
	getChance = function(self, t) return math.max(0, self:combatLimit(self:combatTalentMindDamage(t, 10, 70), 100, 39, 9, 86, 56)) end, -- Limit < 100%
	getNb = function(self, t) return math.ceil(self:combatTalentLimit(t, 4, 1, 2)) end,
	getTurns = function(self, t) return math.ceil(self:combatTalentLimit(t, 20, 2, 12)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target then
				target:setEffect(target.EFF_MIND_PARASITE, 6, {chance=t.getChance(self, t), nb=t.getNb(self, t), turns=t.getTurns(self, t)})
			end
		end, {type="slime"})

		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		return ([[你 利 用 你 的 心 灵 利 刃 朝 你 的 敌 人 发 射 一 团 蠕 虫。 
		 当 攻 击 击 中 时， 它 会 进 入 目 标 大 脑， 并 在 那 里 待 6 回 合， 干 扰 对 方 使 用 技 能 的 能 力。 
		 每 次 对 方 使 用 技 能 时， 有 %d%% 概 率 %d 个 技 能 被 打 入 %d 个 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 概 率 有 额 外 加 成。]]):
		format(t.getChance(self, t), t.getNb(self, t), t.getTurns(self, t))
	end,
}

newTalent{
	name = "Unstoppable Nature",
	type = {"wild-gift/oozing-blades", 4},
	require = gifts_req_high4,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 15,
	cooldown = 30,
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	tactical = { BUFF = 2 },
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 15, 50) end, -- Limit < 100%
	getChance = function(self, t) return math.max(0,self:combatTalentLimit(t, 100, 14, 70)) end, -- Limit < 100%
	freespit = function(self, t, target)
		if game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
					break
				end
			end
		else
			for _, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
					break
				end
			end
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")

		local particle
		if core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=0.5, npow=4, time_factor=2000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
		else
			particle = self:addParticles(Particles.new("master_summoner", 1))
		end
		return {
			resist = self:addTemporaryValue("resists_pen", {[DamageType.NATURE] = t.getResistPenalty(self, t)}),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local chance = t.getChance(self, t)
		return ([[你 的 周 围 充 满 了 自 然 力 量， 忽 略 目 标 %d%% 的 自 然 伤 害 抵 抗。 
		 同 时， 每 次 你 使 用 自 然 力 量 造 成 伤 害 时， 有 %d%% 概 率 你 的 一 个 粘 液 软 泥 怪 会 向 目 标 释 放 喷 吐， 这 个 攻 击 不 消 耗 时 间。]])
		:format(ressistpen, chance)
	end,
}

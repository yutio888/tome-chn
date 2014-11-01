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
	name = "Blastwave",
	type = {"spell/wildfire",1},
	require = spells_req_high1,
	points = 5,
	mana = 12,
	cooldown = 5,
	tactical = { ATTACKAREA = { FIRE = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 2 },
		CURE = function(self, t, target)
			if self:attr("burning_wake") and self:attr("cleansing_flame") then
				return 1
			end
	end },
	direct_hit = true,
	requires_target = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 180) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, DamageType.FIREKNOCKBACK, {dist=3, dam=self:spellCrit(t.getDamage(self, t))})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_fire", {radius=tg.radius})
		if self:attr("burning_wake") then
			game.level.map:addEffect(self,
				self.x, self.y, 4,
				DamageType.INFERNO, self:attr("burning_wake"),
				tg.radius,
				5, nil,
				{type="inferno"},
				nil, self:spellFriendlyFire()
			)
		end
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[从 你 身 上 释 放 出 一 波 %d 码 半 径 范 围 的 火 焰， 击 退 范 围 内 所 有 目 标 并 使 它 们 进 入 3 回 合 灼 烧 状 态， 共 造 成 %0.2f 火 焰 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

newTalent{
	name = "Burning Wake",
	type = {"spell/wildfire",2},
	require = spells_req_high2,
	mode = "sustained",
	points = 5,
	sustain_mana = 40,
	cooldown = 30,
	tactical = { BUFF=2, ATTACKAREA = { FIRE = 1 } },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 55) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/fire")
		local cft = self:getTalentFromId(self.T_CLEANSING_FLAMES)
		self:addShaderAura("burning_wake", "awesomeaura", {time_factor=3500, alpha=0.6, flame_scale=0.6}, "particles_images/wings.png")
		return {
			bw = self:addTemporaryValue("burning_wake", t.getDamage(self, t)),
			cf = self:addTemporaryValue("cleansing_flames", cft.getChance(self, cft)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("burning_wake")
		self:removeTemporaryValue("burning_wake", p.bw)
		self:removeTemporaryValue("cleansing_flames", p.cf)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 的 火 球 术、 火 焰 冲 击、 爆 裂 火 球 和 火 焰 新 星 都 会 在 地 上 留 下 燃 烧 的 火 焰， 每 回 合 对 经 过 者 造 成 %0.2f 火 焰 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, damage))
	end,
}

newTalent{
	name = "Cleansing Flames",
	type = {"spell/wildfire",3},
	require = spells_req_high3,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return self:getTalentLevelRaw(t) * 10 end,
	info = function(self, t)
		return ([[当 你 的 无 尽 之 炎 激 活 时， 你 的 地 狱 火 和 无 尽 之 炎 均 有 %d%% 概 率 净 化 目 标 身 上 一 种 状 态。（ 物 理， 法 术， 诅 咒 或 巫 术） 
		 如 果 目 标 是 敌 人， 则 净 化 其 增 益 状 态。 
		 如 果 目 标 时 友 方 单 位， 则 净 化 负 面 状 态（ 仍 然 有 燃 烧 效 果）。]]):format(t.getChance(self, t))
	end,
}

newTalent{
	name = "Wildfire",
	type = {"spell/wildfire",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getFireDamageIncrease = function(self, t) return self:getTalentLevelRaw(t) * 2 end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 17, 50) end, --Limit < 100%
	getResistSelf = function(self, t) return math.min(100, self:getTalentLevel(t) * 14) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/fire")

		local particle
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			particle = self:addParticles(Particles.new("shader_wings", 1, {infinite=1, x=bx, y=by}))
		else
			particle = self:addParticles(Particles.new("wildfire", 1))
		end
		return {
			dam = self:addTemporaryValue("inc_damage", {[DamageType.FIRE] = t.getFireDamageIncrease(self, t)}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.FIRE] = t.getResistPenalty(self, t)}),
			selfres = self:addTemporaryValue("resists_self", {[DamageType.FIRE] = t.getResistSelf(self, t)}),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		self:removeTemporaryValue("resists_self", p.selfres)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local selfres = t.getResistSelf(self, t)
		return ([[使 身 上 缠 绕 火 焰， 增 加 %d%% 所 有 火 系 伤 害 并 无 视 目 标 %d%% 火 焰 抵 抗。 
		 同 时， 减 少 %d%% 对 自 己 造 成 的 火 焰 伤 害。]])
		:format(damageinc, ressistpen, selfres)
	end,
}

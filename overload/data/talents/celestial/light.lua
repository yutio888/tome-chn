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
	name = "Healing Light",
	type = {"celestial/light", 1},
	require = spells_req1,
	points = 5,
	random_ego = "defensive",
	cooldown = 10,
	positive = -10,
	tactical = { HEAL = 2 },
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 20, 440) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:spellCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true, size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[一 束 充 满 活 力 的 阳 光 照 耀 着 你， 治 疗 你 %d 点 生 命 值。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

newTalent{
	name = "Bathe in Light",
	type = {"celestial/light", 2},
	require = spells_req2,
	random_ego = "defensive",
	points = 5,
	cooldown = 15,
	positive = -20,
	tactical = { HEAL = 3 },
	range = 0,
	radius = 2,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 4, 80) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.HEALING_POWER, self:spellCrit(t.getHeal(self, t)),
			self:getTalentRadius(t),
			5, nil,
			{overlay_particle={zdepth=6, only_one=true, type="circle", args={img="sun_circle", a=10, speed=0.04, radius=self:getTalentRadius(t)}}, type="healing_vapour"},
			nil, true
		)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t)
		local duration = t.getDuration(self, t)
		return ([[圣 光 倾 泻 在 你 周 围 %d 码 范 围 内， 每 回 合 治 疗 所 有 单 位 %0.2f 生 命 值, 给 予 其 等 量 的 护 盾 , 并 增 加 此 范 围 内 所 有 人 %d%% 治 疗 效 果。 此 效 果 持 续 %d 回 合。 
		 如 果 已 经 存 在 护 盾， 则 护 盾 将 会 增 加 等 量 数 值 ，如 果 护 盾 持 续 时 间 不 足 2 回 合，会 延 长 至 2 回 合。
		 当 同 一 个 护 盾 被 刷 新 20 次 后 ， 将 会 因 为 不 稳 定 而 破 碎 。
		 它 同 时 会 照 亮 此 区 域。 
		 受 魔 法 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(radius, heal, heal / 2, duration)
	end,
}

newTalent{
	name = "Barrier",
	type = {"celestial/light", 3},
	require = spells_req3,
	points = 5,
	random_ego = "defensive",
	positive = -20,
	cooldown = 15,
	tactical = { DEFEND = 2 },
	getAbsorb = function(self, t) return self:combatTalentSpellDamage(t, 30, 370) end,
	action = function(self, t)
		self:setEffect(self.EFF_DAMAGE_SHIELD, 10, {color={0xe1/255, 0xcb/255, 0x3f/255}, power=self:spellCrit(t.getAbsorb(self, t))})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local absorb = t.getAbsorb(self, t)
		return ([[一 个 持 续 10 回 合 的 保 护 性 圣 盾 围 绕 着 你， 可 吸 收 %d 点 伤 害。 
		 受 法 术 强 度 影 响， 圣 盾 的 最 大 吸 收 量 有 额 外 加 成。]]):
		format(absorb)
	end,
}

newTalent{
	name = "Providence",
	type = {"celestial/light", 4},
	require = spells_req4,
	points = 5,
	random_ego = "defensive",
	positive = -20,
	cooldown = 30,
	tactical = { HEAL = 1, CURE = 2 },
	getRegeneration = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		self:setEffect(self.EFF_PROVIDENCE, t.getDuration(self, t), {power=t.getRegeneration(self, t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local regen = t.getRegeneration(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 位 于 圣 光 的 保 护 下， 每 回 合 回 复 %d 生 命 值 并 随 机 移 除 1 种 负 面 状 态， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(regen, duration)
	end,
}


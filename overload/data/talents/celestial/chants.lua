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

local function cancelChants(self)
	local chants = {self.T_CHANT_OF_FORTITUDE, self.T_CHANT_OF_FORTRESS, self.T_CHANT_OF_RESISTANCE, self.T_CHANT_OF_LIGHT}
	for i, t in ipairs(chants) do
		if self:isTalentActive(t) then
			self:forceUseTalent(t, {ignore_energy=true})
		end
	end
end

-- Synergizes with melee classes (escort), Weapon of Wrath, healing mod (avoid overheal > healing efficiency), and low spellpower
newTalent{
	name = "Chant of Fortitude",
	type = {"celestial/chants", 1},
	mode = "sustained",
	require = divi_req1,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { BUFF = 2 },
	range = 10,
	getResists = function(self, t) return self:combatTalentSpellDamage(t, 5, 70) end,
	getLifePct = function(self, t) return self:combatTalentLimit(t, 1, 0.05, 0.20) end, -- Limit < 100% bonus
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	activate = function(self, t)
		cancelChants(self)
		local power = t.getResists(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		
		local ret = {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamageOnMeleeHit(self, t)}),
			phys = self:addTemporaryValue("combat_physresist", power),
			spell = self:addTemporaryValue("combat_spellresist", power),
			life = self:addTemporaryValue("max_life", t.getLifePct(self, t)*self.max_life),
			particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("combat_physresist", p.phys)
		self:removeTemporaryValue("combat_spellresist", p.spell)
		self:removeTemporaryValue("max_life", p.life)
		return true
	end,
	info = function(self, t)
		local saves = t.getResists(self, t)
		local life = t.getLifePct(self, t)
		local damageonmeleehit = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 %d 点 物 理 及 法 术 豁 免 并 增 加 %0.1f%% 最 大 生 命 值。(当 前 增 加:  %d).
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 豁 免 和 伤 害 受 法 术 强 度 加 成 ， 生 命 值 受 技 能 等 级 影 响 。]]):
		format(saves, life*100, life*self.max_life, damDesc(self, DamageType.LIGHT, damageonmeleehit))
	end,
}

-- Mostly the same code as Sanctuary
-- Just like Fortress we limit the interaction with spellpower a bit because this is an escort reward
-- This can be swapped to reactively with a projectile already in the air
newTalent{
	name = "Chant of Fortress",
	type = {"celestial/chants", 2},
	mode = "sustained",
	require = divi_req2,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { BUFF = 2 },
	range = 10,
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	getDamageChange = function(self, t)
		return -self:combatTalentLimit(t, 50, 14, 30) -- Limit < 50% damage reduction
	end,
	activate = function(self, t)
		cancelChants(self)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamageOnMeleeHit(self, t)}),
			particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		return true
	end,
	info = function(self, t)
		local range = -t.getDamageChange(self, t)
		local damageonmeleehit = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀, 距 离 3 及 以 上 的 敌 人 对 你 的 伤 害 减 少 %d%%。
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 伤 害 减 少 量 受 技 能 等 级 加 成 ， 光 系 伤 害 受 法 强 加 成。]]):
		format(range, damDesc(self, DamageType.LIGHT, damageonmeleehit))
	end,
}

-- Escorts can't give this one so it should have the most significant spellpower scaling
-- Ideally at high spellpower this would almost always be the best chant to use, but we can't guarantee that while still differentiating the chants in interesting ways
-- People that don't want to micromanage/math out when the other chants are better will like this and it should still outperform Fortitude most of the time
newTalent{
	name = "Chant of Resistance",
	type = {"celestial/chants",3},
	mode = "sustained",
	require = divi_req3,
	points = 5,
	cooldown = 12,
	sustain_positive = 20,
	dont_provide_pool = true,
	tactical = { BUFF = 2 },
	no_energy = true,
	range = 10,
	getResists = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	activate = function(self, t)
		cancelChants(self)
		local power = t.getResists(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamageOnMeleeHit(self, t)}),
			res = self:addTemporaryValue("resists", {all = power}),
			particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("resists", p.res)
		return true
	end,
	info = function(self, t)
		local resists = t.getResists(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 %d%% 全 体 抵 抗。 
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(resists, damDesc(self, DamageType.LIGHT, damage))
	end,
}

-- Extremely niche in the name of theme
-- A defensive chant is realistically always a better choice than an offensive one but we can mitigate this by giving abnormally high value at low talent investment
newTalent{
	name = "Chant of Light",
	type = {"celestial/chants", 4},
	mode = "sustained",
	require = divi_req4,
	points = 5,
	cooldown = 12,
	sustain_positive = 5,
	no_energy = true,
	dont_provide_pool = true,
	tactical = { BUFF = 2 },
	range = 10,
	getLightDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 20, 50) end,
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	getLite = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	activate = function(self, t)
		cancelChants(self)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamageOnMeleeHit(self, t)}),
			phys = self:addTemporaryValue("inc_damage", {[DamageType.LIGHT] = t.getLightDamageIncrease(self, t), [DamageType.FIRE] = t.getLightDamageIncrease(self, t)}),
			lite = self:addTemporaryValue("lite", t.getLite(self, t)),
			particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("inc_damage", p.phys)
		self:removeTemporaryValue("lite", p.lite)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getLightDamageIncrease(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local lite = t.getLite(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 光 系 与 火 系 充 能， 造 成 %d%% 点 额 外 伤 害。 
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 你 的 光 照 范 围 同 时 增 加 %d 码。 
		 同 时 只 能 激 活 1 个 圣 歌 ，另 外 此 赞 歌 消 耗 能 量 较 少。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damageinc, damDesc(self, DamageType.LIGHT, damage), lite)
	end,
}

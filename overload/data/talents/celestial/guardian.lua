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

-- Core offensive scaler for 1H/S as we have no Shield Mastery
-- Core defense roughly to be compared with Absorption Strike, but in truth 1H/S gets a lot of its defense from cooldown management+Suncloak/etc
-- Its important that this can crit but its also spamming the combat log, unsure of solution
-- Flag if its a crit once for each turn then calculate damage manually?
newTalent{
	name = "Shield of Light",
	type = {"celestial/guardian", 1},
	mode = "sustained",
	require = divi_req_high1,
	points = 5,
	cooldown = 10,
	sustain_positive = 10,
	tactical = { BUFF = 2 },
	range = 10,
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 5, 22) end,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.1, 0.8, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield of Light without a shield!")
			return nil
		end

		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
		}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if hitted and not target.dead and weapon and not self.turn_procs.shield_of_light then
			self:attackTargetWith(target, weapon.special_combat, DamageType.LIGHT, t.getShieldDamage(self, t))
			self.turn_procs.shield_of_light = true
		end
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 你 的 盾 牌 充 满 光 系 能 量， 每 次 受 到 攻 击 会 消 耗 2 点 正 能 量 并 恢 复 %0.2f 生 命 值。 
		 如 果 你 没 有 足 够 的 正 能 量， 此 效 果 无 法 触 发。 
		 同 时 ，每 回 合 一 次 ，近 战 攻 击 命 中 时 会 附 加 一 次 盾 击 ， 造 成 %d%% 光 系 伤 害。
		 受 法 术 强 度 影 响， 恢 复 量 有 额 外 加 成。]]):
		format(heal, t.getShieldDamage(self, t)*100)
	end,
}

-- Shield of Light means 1H/Shield builds actually care about positive energy, so we can give this a meaningful cost and power
-- Spamming Crusade+whatever is always more energy efficient than this
newTalent{
	name = "Brandish",
	type = {"celestial/guardian", 2},
	require = divi_req_high2,
	points = 5,
	cooldown = 8,
	positive = 25,
	tactical = { ATTACK = {LIGHT = 2} },
	requires_target = true,
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 3) end,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 2, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	getLightDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 200) end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Brandish without a shield!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- First attack with weapon
		self:attackTarget(target, nil, t.getWeaponDamage(self, t), true)
		-- Second attack with shield
		local speed, hit = self:attackTargetWith(target, shield.special_combat, nil, t.getShieldDamage(self, t))

		-- Light Burst
		if hit then
			local tg = {type="ball", range=1, selffire=true, radius=self:getTalentRadius(t), talent=t}
			self:project(tg, x, y, DamageType.LITE, 1)
			tg.selffire = false
			local grids = self:project(tg, x, y, DamageType.LIGHT, self:spellCrit(t.getLightDamage(self, t)))
			game.level.map:particleEmitter(x, y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
			game:playSoundNear(self, "talents/flame")
		end

		return true
	end,
	info = function(self, t)
		local weapondamage = t.getWeaponDamage(self, t)
		local shielddamage = t.getShieldDamage(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[用 你 的 武 器 对 目 标 造 成 %d%% 伤 害， 同 时 盾 击 目 标 造 成 %d%% 伤 害。 如 果 盾 牌 击 中 目 标， 则 会 产 生 光 系 爆 炸， 对 范 围 内 除 你 以 外 的 所 有 目 标 造 成 %0.2f 光 系 范 围 伤 害（ 半 径 %d 码） 并 照 亮 受 影 响 区 域。 
		 受 法 术 强 度 影 响， 光 系 伤 害 有 额 外 加 成。]]):
		format(100 * weapondamage, 100 * shielddamage, damDesc(self, DamageType.LIGHT, lightdamage), radius)
	end,
}

newTalent{
	name = "Retribution",
	type = {"celestial/guardian", 3},
	require = divi_req_high3, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_positive = 20,
	cooldown = 10,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	tactical = { DEFEND = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 400) end,
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Retribution without a shield!")
			return nil
		end
		local power = t.getDamage(self, t)
		self.retribution_absorb = power
		self.retribution_strike = power
		game:playSoundNear(self, "talents/generic")
		return {
			shield = self:addTemporaryValue("retribution", power),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("retribution", p.shield)
		self.retribution_absorb = nil
		self.retribution_strike = nil
		return true
	end,
	callbackOnRest = function(self, t)
		-- Resting requires no enemies in view so we can safely clear all stored damage
		-- Clear the stored damage by setting the remaining absorb to the max
		self.retribution_absorb = self.retribution
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local absorb_string = ""
		if self.retribution_absorb and self.retribution_strike then
			absorb_string = ([[#RED#Absorb Remaining: %d]]):format(self.retribution_absorb)
		end

		return ([[吸 收 你 收 到 的 一 半 伤 害。 一 旦 惩 戒 之 盾 吸 收 %0.2f 伤 害 值， 它 会 产 生 光 系 爆 炸， 在 %d 码 半 径 范 围 内 造 成 等 同 吸 收 值 的 伤 害 并 中 断 技 能 效 果。 
		 受 法 术 强 度 影 响， 伤 害 吸 收 值 有 额 外 加 成。
		%s]]):
		format(damage, self:getTalentRange(t), absorb_string)
	end,
}

-- Moderate damage but very short CD
-- Spamming this on cooldown keeps positive energy up and gives a lot of cooldown management 
newTalent{
	name = "Crusade",
	type = {"celestial/guardian", 4},
	require = divi_req_high4,
	random_ego = "attack",
	points = 5,
	cooldown = 5,
	positive = -20,
	tactical = { ATTACK = {LIGHT = 2} },
	range = 1,
	requires_target = true,
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1.2) end,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1.2, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	getCooldownReduction = function(self, t) return math.ceil(self:combatTalentScale(t, 1, 3)) end,
	getDebuff = function(self, t) return 1 end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Crusade without a shield!")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		
		local hit = self:attackTarget(target, DamageType.LIGHT, t.getWeaponDamage(self, t), true)
		if hit then self:talentCooldownFilter(nil, 1, t.getCooldownReduction(self, t), true) end

		local hit2 = self:attackTargetWith(target, shield.special_combat, DamageType.LIGHT, t.getShieldDamage(self, t))
		if hit2 then self:removeEffectsFilter({status = "detrimental"}, t.getDebuff(self, t)) end

		return true
	end,
	info = function(self, t)
		local weapon = t.getWeaponDamage(self, t)*100
		local shield = t.getShieldDamage(self, t)*100
		local cooldown = t.getCooldownReduction(self, t)
		local cleanse = t.getDebuff(self, t)
		return ([[你 用 武 器 攻 击 造 成 %d%% 光 系 伤 害 ， 再 用 盾 牌 攻 击 造 成 %d%% 光 系 伤 害。
			如 果 第 一 次 攻 击 命 中 ， 随 机 %d 个 技 能 cd 时 间 减 1。
			如 果 第 二 次 攻 击 命 中， 除 去 你 身 上 至 多 %d 个 debuff。]]):
		format(weapon, shield, cooldown, cleanse)
	end,
}


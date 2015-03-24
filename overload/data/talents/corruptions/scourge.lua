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

local DamageType = require "engine.DamageType"

newTalent{
	name = "Rend",
	type = {"corruption/scourge", 1},
	require = corrs_req1,
	points = 5,
	vim = 9,
	cooldown = 6,
	range = 1,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = {PHYSICAL = 2} },
	requires_target = true,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Rend without two weapons!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.6))
		local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, self:combatTalentWeaponDamage(t, 0.8, 1.6)))
		DamageType:projectingFor(self, nil)

		-- Try to bleed !
		if hit1 then
			if target:canBe("cut") then
				target:setEffect(target.EFF_CUT, 5, {power=self:combatTalentSpellDamage(t, 5, 40), src=self, apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the cut!", target.name:capitalize())
			end
		end
		if hit2 then
			if target:canBe("cut") then
				target:setEffect(target.EFF_CUT, 5, {power=self:combatTalentSpellDamage(t, 5, 40), src=self, apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the cut!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[向 目 标 挥 舞 2 把 武 器， 每 次 攻 击 造 成 %d%% 伤 害。 每 次 攻 击 会 使 目 标 流 血， 每 回 合 造 成 %0.2f 伤 害， 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 流 血 效 果 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.6), self:combatTalentSpellDamage(t, 5, 40))
	end,
}

newTalent{
	name = "Ruin",
	type = {"corruption/scourge", 2},
	mode = "sustained",
	require = corrs_req2,
	points = 5,
	sustain_vim = 40,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 40) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self, t))
		return ([[专 注 于 你 带 来 的 瘟 疫， 每 次 近 战 攻 击 会 造 成 %0.2f 枯 萎 伤 害（ 同 时 每 击 恢 复 你 %0.2f 生 命 值）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(dam, dam * 0.4)
	end,
}

newTalent{
	name = "Acid Strike",
	type = {"corruption/scourge", 3},
	require = corrs_req3,
	points = 5,
	vim = 18,
	cooldown = 12,
	range = 1,
	radius = 1,
	requires_target = true,
	is_melee = true,
	tactical = { ATTACK = {ACID = 2}, DISABLE = 1 },
	target = function(self, t)
		-- Tries to simulate the acid splash
		return {type="ballbolt", range=1, radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Acid Strike without two weapons!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, DamageType.ACID, self:combatTalentWeaponDamage(t, 0.8, 1.6))
		local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, DamageType.ACID, self:getOffHandMult(offweapon.combat, self:combatTalentWeaponDamage(t, 0.8, 1.6)))
		DamageType:projectingFor(self, nil)

		-- Acid splash !
		if hit1 or hit2 then
			local tg = self:getTalentTarget(t)
			tg.x = target.x
			tg.y = target.y
			self:project(tg, target.x, target.y, DamageType.ACID, self:spellCrit(self:combatTalentSpellDamage(t, 10, 130)))
		end

		return true
	end,
	info = function(self, t)
		return ([[用 每 把 武 器 打 击 目 标， 每 次 攻 击 造 成 %d%% 酸 性 武 器 伤 害。 
		 如 果 有 至 少 一 次 攻 击 命 中 目 标， 则 会 产 生 酸 系 溅 射， 对 临 近 目 标 的 敌 人 造 成 %0.2f 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 溅 射 伤 害 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.6), damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 130)))
	end,
}

newTalent{
	name = "Dark Surprise",
	type = {"corruption/scourge", 4},
	require = corrs_req4,
	points = 5,
	vim = 14,
	cooldown = 8,
	range = 1,
	is_melee = true,
	requires_target = true,
	tactical = { ATTACK = {DARKNESS = 1, BLIGHT = 1}, DISABLE = 2 },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Dark Surprise without two weapons!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		DamageType:projectingFor(self, {project_type={talent=t}})
		local speed1, hit1 = self:attackTargetWith(target, weapon.combat, DamageType.DARKNESS, self:combatTalentWeaponDamage(t, 0.6, 1.4))

		if hit1 then
			self.turn_procs.auto_phys_crit = true
			local speed2, hit2 = self:attackTargetWith(target, offweapon.combat, DamageType.BLIGHT, self:getOffHandMult(offweapon.combat, self:combatTalentWeaponDamage(t, 0.6, 1.4)))
			self.turn_procs.auto_phys_crit = nil
			if hit2 and target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, 4, {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(self, "%s resists the darkness.", target.name:capitalize())
			end
		end
		DamageType:projectingFor(self, nil)

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 主 武 器 打 击 目 标 并 造 成 %d%% 暗 影 武 器 伤 害。 
		 如 果 主 武 器 命 中， 则 你 会 使 用 副 武 器 打 击 目 标 并 造 成 %d%% 枯 萎 武 器 伤 害， 此 次 攻 击 必 定 暴 击。 
		 如 果 副 武 器 命 中， 则 目 标 会 被 致 盲 4 回 合。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.6, 1.4), 100 * self:combatTalentWeaponDamage(t, 0.6, 1.4))
	end,
}


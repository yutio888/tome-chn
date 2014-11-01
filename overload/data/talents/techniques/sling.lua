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
	name = "Sling Mastery",
	type = {"technique/archery-sling", 1},
	points = 5,
	require = { stat = { dex=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	ammo_mastery_reload = function(self, t)
		return math.floor(self:getTalentLevel(t) / 2)
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, 'ammo_mastery_reload', t.ammo_mastery_reload(self, t))
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[提 高 %d 点 物 理 强 度。 同 时 提 高 %d%% 投 石 索 伤 害。 
		同 时 增 加 %d 装 填 效 果 。]]):format(damage, inc * 100, reloads)
	end,
}

newTalent{
	name = "Eye Shot",
	type = {"technique/archery-sling", 2},
	no_energy = "fake",
	points = 5,
	cooldown = 8,
	stamina = 15,
	require = techs_dex_req2,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { blind = 2 } },
	getBlindDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("sling") then if not silent then game.logPlayer(self, "You require a sling for this talent.") end return false end return true end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("blind") then
			target:setEffect(target.EFF_BLINDED, t.getBlindDur(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists!", target.name:capitalize())
		end
	end,
	action = function(self, t)
		if not self:hasArcheryWeapon("sling") then game.logPlayer(self, "You must wield a sling!") return nil end

		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.5)})
		return true
	end,
	info = function(self, t)
		return ([[你 对 目 标 的 眼 睛 射 出 一 发 子 弹， 致 盲 目 标 %d 回 合 并 造 成 %d%% 伤 害。 
		受 命 中 影 响， 致 盲 概 率 有 额 外 加 成。]])
		:format(t.getBlindDur(self, t),	100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

newTalent{
	name = "Inertial Shot",
	type = {"technique/archery-sling", 3},
	no_energy = "fake",
	points = 5,
	cooldown = 8,
	stamina = 15,
	require = techs_dex_req3,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("sling") then if not silent then game.logPlayer(self, "You require a sling for this talent.") end return false end return true end,
	archery_onhit = function(self, t, target, x, y)
		if target:checkHit(self:combatAttack(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
			target:knockback(self.x, self.y, 4)
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatAttack())
			game.logSeen(target, "%s is knocked back!", target.name:capitalize())
		else
			game.logSeen(target, "%s stands firm!", target.name:capitalize())
		end
	end,
	action = function(self, t)
		if not self:hasArcheryWeapon("sling") then game.logPlayer(self, "You must wield a sling!") return nil end

		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.5)})
		return true
	end,
	info = function(self, t)
		return ([[你 射 出 一 发 强 力 的 子 弹， 对 目 标 造 成 %d%% 伤 害 并 击 退 目 标。 
		受 命 中 影 响， 击 退 概 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

newTalent{
	name = "Multishot",
	type = {"technique/archery-sling", 4},
	no_energy = "fake",
	points = 5,
	cooldown = 12,
	stamina = 35,
	require = techs_dex_req4,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 3 } },
	getShots = function(self, t, fake)
		local count = self:combatTalentScale(t, 2.8, 4.3, "log")
		if fake then return count end
		return math.floor(count) + (rng.percent(100*(count - math.floor(count))) and 1 or 0)
	end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("sling") then if not silent then game.logPlayer(self, "You require a sling for this talent.") end return false end return true end,
	action = function(self, t)
		if not self:hasArcheryWeapon("sling") then game.logPlayer(self, "You must wield a sling!") return nil end
		local targets = self:archeryAcquireTargets(nil, {multishots=t.getShots(self, t)})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 0.3, 0.7)})
		return true
	end,
	info = function(self, t)
		return ([[你 向 目 标 射 出 平 均 %0.1f 子 弹， 每 发 子 弹 造 成 %d%% 伤 害。 ]]):format(t.getShots(self, t, true), 100 * self:combatTalentWeaponDamage(t, 0.3, 0.7))
	end,
}

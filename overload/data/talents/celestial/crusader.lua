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

-- NOTE:  2H may seem to have more defense than 1H/Shield at a glance but this isn't true
-- Mechanically, 2H gets bigger numbers on its defenses because they're all active, they don't do anything when you get hit at range 10 before you've taken an action unlike Retribution/Shield of Light
-- Thematically, 2H feels less defensive for the same reason--when you get hit it hurts, but you're encouraged to be up in their face fighting

-- Part of 2H core defense to be compared with Shield of Light, Retribution, etc
newTalent{
	name = "Absorption Strike",
	type = {"celestial/crusader", 1},
	require = divi_req_high1,
	points = 5,
	cooldown = 8,
	positive = -7,
	tactical = { ATTACK = 2, DISABLE = 1 },
	range = 1,
	requires_target = true,
	getWeakness = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	getNumb = function(self, t) return math.min(30, self:combatTalentScale(t, 1, 15, 0.75)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 2.3) end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)
		if hit then
			
			self:project({type="ball", radius=2, selffire=false}, self.x, self.y, function(px, py)
				local a = game.level.map(px, py, Map.ACTOR)
				if a then
					-- No power check, this is essentially a defensive talent in debuff form.  Instead of taking less damage passively 2H has to stay active, but we still want the consistency of a sustain/passive
					a:setEffect(a.EFF_ABSORPTION_STRIKE, 5, {power=t.getWeakness(self, t), numb = t.getNumb(self, t)})
				end
			end)
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 你 用 双 手 武 器 攻 击 敌 人 ， 造 成 %d%% 武 器 伤 害。
		 如 果 攻 击 命 中 ， 半 径 2 以 内 的 敌 人 光 系 抗 性 下 降 %d%% ，伤 害 下 降 %d%%, 持 续 5 回 合 。]]):
		format(100 * damage, t.getWeakness(self, t), t.getNumb(self, t))
	end,
}

-- Part of 2H core defense to be compared with Shield of Light, Retribution, etc
newTalent{
	name = "Mark of Light",
	type = {"celestial/crusader", 2},
	require = divi_req_high2,
	points = 5,
	no_energy = true,
	cooldown = 15,
	positive = 20,
	tactical = { DISABLE=2, HEAL=2 },
	range = 5,
	requires_target = true,
	getPower = function(self, t) return self:combatTalentLimit(t, 100, 15, 50) end, --Limit < 100%
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 5 then return nil end
		target:setEffect(target.EFF_MARK_OF_LIGHT, 5, {src=self, power=t.getPower(self, t)})
		
		return true
	end,
	info = function(self, t)
		return ([[你 用 光 标 记 目 标 5 回 合，你 对 它 近 战 攻 击 时 ， 将 受 到 相 当 于 %d%% 伤 害 的 治 疗 。]]):
		format(t.getPower(self, t))
	end,
}

-- Sustain because dealing damage is not strictly beneficial (radiants) and because 2H needed some sustain cost
newTalent{
	name = "Righteous Strength",
	type = {"celestial/crusader",3},
	require = divi_req_high3,
	points = 5,
	mode = "sustained",
	sustain_positive = 20,
	getArmor = function(self, t) return self:combatTalentScale(t, 5, 30) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 120) end,
	getCrit = function(self, t) return self:combatTalentScale(t, 3, 10, 0.75) end,
	getPower = function(self, t) return self:combatTalentScale(t, 5, 15) end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "combat_physcrit", t.getCrit(self, t))
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnCrit = function(self, t, kind, dam, chance, target)
		if not self:hasTwoHandedWeapon() then return end
		if kind ~= "physical" or not target then return end
		if self.turn_procs.righteous_strength then return end
		self.turn_procs.righteous_strength = true

		target:setEffect(target.EFF_LIGHTBURN, 5, {apply_power=self:combatSpellpower(), src=self, dam=t.getDamage(self, t)/5, armor=t.getArmor(self, t)})
		self:setEffect(self.EFF_RIGHTEOUS_STRENGTH, 4, {power=t.getPower(self, t), max_power=t.getPower(self, t) * 3})
	end,
	info = function(self, t)
		return ([[ 当 装 备 双 手 武 器 时 ， 你 的 暴 击 率 增 加 %d%%, 同 时 你 的 近 战 暴 击 会 引 发 光 明 之 力 ， 增 加 %d%% 物 理 和 光 系 伤 害 加 成 ， 最 多 叠 加 3 倍 。
		同 时 ， 你 的 近 战 暴 击 会 在 目 标 身 上 留 下 灼 烧 痕 迹 ， 5 回 合 内 造 成 %0.2f 光 系 伤 害， 同 时 减 少 %d 护 甲 。
		伤 害 受 法 强 加 成 。]]):
		format(t.getCrit(self, t), t.getPower(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getArmor(self, t))
	end,
}

-- Low damage, 2H Assault has plenty of AoE damage strikes, this one is fundamentally defensive or strong only if Light is scaled up
-- Part of 2H core defense to be compared with Shield of Light, Retribution, etc
newTalent{
	name = "Flash of the Blade",
	type = {"celestial/crusader", 4},
	require = divi_req_high4,
	random_ego = "attack",
	points = 5,
	cooldown = 9,
	positive = 15,
	tactical = { ATTACKAREA = {LIGHT = 2} },
	range = 0,
	radius = 2,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	get1Damage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 1.3) end,
	get2Damage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1.5) end,
	action = function(self, t)
		local tg1 = self:getTalentTarget(t) tg1.radius = 1
		local tg2 = self:getTalentTarget(t)
		self:project(tg1, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				self:attackTarget(target, nil, t.get1Damage(self, t), true)
			end
		end)

		self:project(tg2, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				self:attackTarget(target, DamageType.LIGHT, t.get2Damage(self, t), true)
			end
		end)

		if self:getTalentLevel(t) >= 4 then
			self:setEffect(self.EFF_FLASH_SHIELD, 1, {})
		end

		self:addParticles(Particles.new("meleestorm", 2, {radius=2, img="spinningwinds_yellow"}))
		self:addParticles(Particles.new("meleestorm", 1, {img="spinningwinds_yellow"}))
		return true
	end,
	info = function(self, t)
		return ([[ 旋 转 一 周 ， 同 时 将 光 明 之 力 充 满 武 器 。
		 半 径 1 以 内 的 敌 人 将 受 到 %d%% 武 器 伤 害 ， 同 时 半 径 2 以内 的 敌  人将 受 到 %d%% 光 系 武 器 伤害 。
		 技 能 等 级 4 或 以 上 时 ， 在 旋 转 时 你 会 制 造  一层  护盾 ， 吸 收 1 回 合 内 的 所 有 攻 击 。]]):
		format(t.get1Damage(self, t) * 100, t.get2Damage(self, t) * 100)
	end,
}

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
	name = "Phase Shot",
	type = {"chronomancy/temporal-archery", 1},
	require = temporal_req1,
	points = 5,
	paradox = 3,
	cooldown = 3,
	no_energy = "fake",
	range = 10,
	tactical = { ATTACK = {TEMPORAL = 2} },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	requires_target = true,
	action = function(self, t)
		local tg = {type="bolt"}
		local targets = self:archeryAcquireTargets(tg)
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1.1, 1.9) * getParadoxModifier(self, pm), damtype=DamageType.TEMPORAL, apr=1000})
		return true
	end,
	info = function(self, t)
		local weapon = 100 * (self:combatTalentWeaponDamage(t, 1.1, 1.9) * getParadoxModifier(self, pm))
		return ([[你 射 出 一 枚 在 相 位 空 间 外 的 子 弹， 这 使 它 可 以 忽 视 敌 方 护 甲。 此 次 射 击 会 对 目 标 造 成 %d%% 时 空 武 器 伤 害。 
		 受 紊 乱 值 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, weapon))
	end
}

newTalent{
	name = "Unerring Shot",
	type = {"chronomancy/temporal-archery", 2},
	require = temporal_req2,
	points = 5,
	paradox = 5,
	cooldown = 8,
	no_energy = "fake",
	range = 10,
	tactical = { ATTACK = {PHYSICAL = 2} },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	requires_target = true,
	action = function(self, t)
		local tg = {type="bolt"}
		local targets = self:archeryAcquireTargets(tg)
		if not targets then return end
		self:setEffect(self.EFF_ATTACK, 1, {power=100})
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1.1, 2.1) * getParadoxModifier(self, pm)})
		return true
	end,
	info = function(self, t)
		local weapon = 100 * (self:combatTalentWeaponDamage(t, 1.1, 1.9) * getParadoxModifier(self, pm))
		return ([[你 集 中 注 意 力 射 出 极 精 准 的 一 箭， 造 成 %d%% 武 器 伤 害。 接 下 来 的 一 次 攻 击 因 时 空 延 续 保 持 攻 击 加 成。 
		 伤 害 受 紊 乱 值 影 响 按 比 例 加 成。]])
		:format(weapon)
	end,
}

newTalent{
	name = "Perfect Aim",
	type = {"chronomancy/temporal-archery", 3},
	require = temporal_req3,
	mode = "sustained",
	points = 5,
	sustain_paradox = 225,
	cooldown = 10,
	tactical = { BUFF = 2 },
	no_energy = true,
	getPower = function(self, t) return 10 + (self:combatTalentSpellDamage(t, 10, 40)) end,
	activate = function(self, t)
		local power = t.getPower(self, t)
		return {
		ccp = self:addTemporaryValue("combat_critical_power", power),
		pid = self:addTemporaryValue("combat_physcrit", power / 2),
		sid = self:addTemporaryValue("combat_spellcrit", power / 2),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_critical_power", p.ccp)
		self:removeTemporaryValue("combat_physcrit", p.pid)
		self:removeTemporaryValue("combat_spellcrit", p.sid)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[集 中 你 的 注 意 力 瞄 准， 增 加 你 的 暴 击 加 成 %d%% 并 提 高 你 的 物 理 和 法 术 暴 击 率 %d%% 。 
		 受 魔 法 影 响， 效 果 按 比 例 加 成。]]):format(power, power / 2)
	end,
}

newTalent{
	name = "Quick Shot",
	type = {"chronomancy/temporal-archery", 4},
	require = temporal_req4,
	points = 5,
	paradox = 10,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 13, 5)) end, -- Limit >0
	no_energy = true,
	range = 10,
	tactical = { ATTACK = {PHYSICAL = 2} },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	requires_target = true,
	action = function(self, t)
		local old = self.energy.value
		local targets = self:archeryAcquireTargets()
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.5) * getParadoxModifier(self, pm)})
		self.energy.value = old
		return true
	end,
	info = function(self, t)
		local weapon = 100 * (self:combatTalentWeaponDamage(t, 1, 1.5) * getParadoxModifier(self, pm))
		return ([[你 暂 停 时 间 给 你 足 够 的 空 闲 射 出 一 支 箭， 造 成 %d%% 伤 害。 
		 伤 害 受 紊 乱 值 影 响， 按 比 例 加 成， 另 外 技 能 等 级 提 高 可 以 降 低 冷 却 时 间。]]):format(weapon)
	end,
}

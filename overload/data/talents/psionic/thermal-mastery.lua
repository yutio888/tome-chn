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
	name = "Transcendent Pyrokinesis",
	type = {"psionic/thermal-mastery", 1},
	require = psi_wil_high1,
	points = 5,
	psi = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 10, 30) end,
	getDamagePenalty = function(self, t) return self:combatTalentLimit(t, 100, 15, 50) end, --Limit < 100%
	getPenetration = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 10, 20), 100, 4.2, 4.2, 13.4, 13.4) end, -- Limit < 100%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 30, 5, 10)) end, --Limit < 30
	action = function(self, t)
		self:setEffect(self.EFF_TRANSCENDENT_PYROKINESIS, t.getDuration(self, t), {power=t.getPower(self, t), penetration=t.getPenetration(self, t), weaken=t.getDamagePenalty(self, t)})
		self:removeEffect(self.EFF_TRANSCENDENT_TELEKINESIS)
		self:removeEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS)
		self:alterTalentCoolingdown(self.T_THERMAL_SHIELD, -1000)
		self:alterTalentCoolingdown(self.T_THERMAL_STRIKE, -1000)
		self:alterTalentCoolingdown(self.T_THERMAL_AURA, -1000)
		self:alterTalentCoolingdown(self.T_THERMAL_LEECH, -1000)
		self:alterTalentCoolingdown(self.T_PYROKINESIS, -1000)
		return true
	end,
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 热 能 突 破 极 限， 增 加 你 的 火 焰 和 寒 冷 伤 害 %d%% ， 火 焰 和 寒 冷 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 热 能 护 盾， 热 能 吸 取， 热 能 光 环 和 意 念 风 暴 的 冷 却 时 间。
		根 据 情 况， 热 能 光 环 获 得 其 中 一 种 强 化： 热 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 热 能 光 环 的 伤 害 加 成。
		你 的 热 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		意 念 风 暴 附 带 火 焰 冲 击 效 果。
		热 能 吸 取 将 会 降 低 敌 人 的 伤 害 %d%% 。
		热 能 打 击 的 第 二 次 寒 冷 / 冻 结 攻 击 将 会 产 生 半 径 为 1 的 爆 炸。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 超 能 系 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getDamagePenalty(self, t))
	end,
}

newTalent{
	name = "Brainfreeze",
	type = {"psionic/thermal-mastery", 2},
	require = psi_wil_high2, 
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	psi = 20,
	tactical = { ATTACK = { COLD = 3} },
	range = function(self,t) return self:combatTalentScale(t, 4, 6) end,
	getDamage = function (self, t)
		return self:combatTalentMindDamage(t, 12, 340)
	end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=0, selffire=false, talent=t} end,
	action = function(self, t)
		local dam = t.getDamage(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		
		self:project(tg, x, y, DamageType.COLD, self:mindCrit(rng.avg(0.8*dam, dam)), {type="mindsear"})
		target:setEffect(target.EFF_BRAINLOCKED, 4, {apply_power=self:combatMindpower()})
		
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[迅 速 的 抽 取 敌 人 大 脑 的 热 量， 造 成 %0.1f 寒 冷 伤 害。
		受 到 技 能 影 响 的 生 物 将 被 锁 脑 四 回 合， 随 机 技 能 进 入 冷 却， 并 冻 结 冷 却 时 间。
		受 精 神 强 度 影 响， 伤 害 和 锁 脑 几 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, dam))
	end,
}

newTalent{
	name = "Heat Shift",
	type = {"psionic/thermal-mastery", 3},
	require = psi_wil_high3,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 35,
	tactical = { DISABLE = 4 },
	range = 6,
	radius = function(self,t) return self:combatTalentScale(t, 2, 4) end,
	getDuration = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 4, 8))
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 60) end,
	getArmor = function(self, t) return self:combatTalentMindDamage(t, 10, 20) end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t, friendlyfire=false} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		local armor = t.getArmor(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				--local cold = DamageType:get("COLD").projector(self, tx, ty, DamageType.COLD, dam)
				local cold = DamageType.defaultProjector(self, tx, ty, DamageType.COLD, dam)
				if act:canBe("pin") and act:canBe("stun") and not act:attr("fly") and not act:attr("levitation") then
					act:setEffect(act.EFF_FROZEN_FEET, dur, {apply_power=self:combatMindpower()})
				end
				--local fire = DamageType:get("FIRE").projector(self, tx, ty, DamageType.FIRE, dam)
				local fire = DamageType.defaultProjector(self, tx, ty, DamageType.FIRE, dam)
				if act:canBe("disarm") then
					act:setEffect(act.EFF_DISARMED, dur, {apply_power=self:combatMindpower()})
				end
				if cold>0 and fire>0 then
					act:setEffect(act.EFF_SUNDER_ARMOUR, dur, {power = armor})
				end
			end
		end)
		return true
	end,
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[在 半 径 %d 范 围 内， 将 所 有 敌 人 身 上 的 热 量 转 移 到 武 器 上， 把 敌 人 冻 僵 在 地 面， 多 余 的 热 量 则 令 他 们 无 法 使 用 武 器 和 盔 甲。 
		造 成 %0.1f 寒 冷 伤 害 和 %0.1f 火 焰 伤 害， 并 对 敌 人 施 加 定 身 （ 冻 足） 和 缴 械 状 态， 持 续 %d 回 合。
		受 到 两 种 伤 害 影 响 的 单 位 也 会 降 低 %d 护 甲 和 豁 免。
		受 精 神 强 度 影 响，施 加 状 态 的 几 率 和 持 续 时 间 有 额 外 加 成。]]):
		format(rad, damDesc(self, DamageType.COLD, dam), damDesc(self, DamageType.FIRE, dam), dur, t.getArmor(self, t))
	end,
}

newTalent{
	name = "Thermal Balance",
	type = {"psionic/thermal-mastery", 4},
	require = psi_wil_high4,
	points = 5,
	psi = 0,
	cooldown = 10,
	range = function(self,t) return self:combatTalentScale(t, 4, 6) end,
	radius = function(self,t) return self:combatTalentScale(t, 2, 4) end,
	tactical = { ATTACKAREA = { FIRE = 3, COLD = 2 }, PSI = 2 },
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 50, 150) end,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		
		local dam=self:mindCrit(t.getDamage(self, t))
		local dam1 = dam * (self:getMaxPsi() - self:getPsi()) / self:getMaxPsi()
		local dam2 = dam * self:getPsi() / self:getMaxPsi()
		
		self:project(tg, x, y, DamageType.COLD, dam1)
		self:project(tg, x, y, DamageType.FIRE, dam2)

		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=1.1, a=255, limit_life=16, grow=true, speed=0, img="fireice_nova", radius=tg.radius})
		
		self:incPsi(self:getMaxPsi()/2 - self:getPsi())
		
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local dam1 = dam * (self:getMaxPsi() - self:getPsi()) / self:getMaxPsi()
		local dam2 = dam * self:getPsi() / self:getMaxPsi()
		return ([[根 据 当 前 的 意 念 力 水 平， 你 在 火 焰 和 寒 冷 中 寻 求 平 衡。
		你 对 敌 人 施 放 一 次 爆 炸， 根 据 当 前 的 意 念 力 造 成 %0.1f 火 焰 伤 害， 根 据 意 念 力 最 大 值 与 当 前 值 的 差 值 造 成 %0.1f 寒 冷 伤 害， 爆 炸 半 径 为 %d 。
		这 个 技 能 会 使 你 当 前 的 意 念 力 变 为 最 大 值 的 一 半。
		受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, dam2), damDesc(self, DamageType.COLD, dam1), self:getTalentRadius(t))
	end,
}


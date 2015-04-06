-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

local Map = require "engine.Map"

newTalent{
	name = "Skullcracker",
	type = {"technique/thuggery", 1},
	points = 5,
	cooldown = 12,
	stamina = 20,
	tactical = { DISABLE = { confusion = 2 }, ATTACK = { PHYSICAL = 1 } },
	require = techs_req1,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 3.2, 5.3)) end,
	getConfusion = function(self, t) return self:combatStatLimit("dex", 50, 25, 45) end, --Limit < 50%
	getDamage = function(self, t)
		local o = self:getInven(self.INVEN_HEAD) and self:getInven(self.INVEN_HEAD)[1]

		local add = 0
		if o then
			add = 15 + o:getPriceFlags() * 0.3 * math.sqrt(o:getPowerRank() + 1) * (o:attr("metallic") and 1 or 0.5) * (o.skullcracker_mult or 1)
		end

		local totstat = self:getStat("str")
		local talented_mod = math.sqrt((self:getTalentLevel(t) + (o and o.material_level or 1)) / 10) + 1
		local power = math.max(self.combat_dam + add, 1)
		power = (math.sqrt(power / 10) - 1) * 0.8 + 1
--		print(("[COMBAT HEAD DAMAGE] power(%f) totstat(%f) talent_mod(%f)"):format(power, totstat, talented_mod))
		return self:rescaleDamage(totstat / 1.5 * power * talented_mod)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local dam = t.getDamage(self, t)

		local _, hitted = self:attackTargetWith(target, nil, nil, nil, dam)

		if hitted then
			if target:canBe("confusion") then
				target:setEffect(target.EFF_CONFUSED, t.getDuration(self, t), {power=t.getConfusion(self, t), apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the headblow!", target.name:capitalize())
			end
			if target:attr("dead") then
				world:gainAchievement("HEADBANG", self, target)
			end
		end
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		return ([[你 用 前 额 猛 击 敌 人 头 部（ 或 者 任 意 你 能 找 到 的 有 效 位 置）， 造 成 %0.2f 物 理 伤 害。 如 果 
		此 次 攻 击 命 中， 则 目 标 会 混 乱( %d%% 强 度) %d 回 合。 
		受 头 盔 品 质、 力 量 和 物 理 伤 害 影 响， 伤 害 有 额 外 加 成。 
		受 敏 捷 和 命 中 影 响， 混 乱 强 度 和 概 率 有 额 外 加 成。 ]]):
		format(dam, t.getConfusion(self, t), duration)
	end,
}

newTalent{
	name = "黑暗出身",short_name ="RIOT-BORN",
	type = {"technique/thuggery", 2},
	mode = "passive",
	points = 5,
	require = techs_req2,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.5) end,
	passives = function(self, t, p)
		local immune = t.getImmune(self, t)
		self:talentTemporaryValue(p, "stun_immune", immune)
		self:talentTemporaryValue(p, "confusion_immune", immune)
	end,
	info = function(self, t)
		return ([[你 与 生 俱 来 的 暴 力 倾 向 使 你 在 战 斗 时 增 加 %d%% 震 慑 和 混 乱 抵 抗。]]):
		format(t.getImmune(self, t)*100)
	end,
}
newTalent{
	name = "Vicious Strikes",
	type = {"technique/thuggery", 3},
	mode = "passive",
	points = 5,
	require = techs_req3,
	critpower = function(self, t) return self:combatTalentScale(t, 6, 25, 0.75) end,
	getAPR = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
		self:talentTemporaryValue(p, "combat_apr", t.getAPR(self, t))
	end,
	info = function(self, t)
		return ([[你 知 道 如 何 击 中 目 标 弱 点， 使 你 获 得 +%d%% 暴 击 伤 害 加 成 和 %d 护 甲 穿 透。]]):
		format(t.critpower(self, t), t.getAPR(self, t))
	end,
}

newTalent{
	name = "Total Thuggery",
	type = {"technique/thuggery", 4},
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_stamina = 40,
	no_energy = true,
	require = techs_req4,
	range = 1,
	tactical = { BUFF = 2 },
	getCrit = function(self, t) return self:combatTalentStatDamage(t, "dex", 10, 50) / 1.5 end,
	getPen = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "str", 10, 50), 100, 0, 0, 35.7, 35.7) end, -- Limit to <100%
	getDrain = function(self, t) return self:combatTalentLimit(t, 0, 11, 6) end, -- Limit to >0 stam
	activate = function(self, t)
		local ret = {
			crit = self:addTemporaryValue("combat_physcrit", t.getCrit(self, t)),
			pen = self:addTemporaryValue("resists_pen", {[DamageType.PHYSICAL] = t.getPen(self, t)}),
			drain = self:addTemporaryValue("stamina_regen_on_hit", - t.getDrain(self, t)),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("resists_pen", p.pen)
		self:removeTemporaryValue("stamina_regen_on_hit", p.drain)
		return true
	end,
	info = function(self, t)
		return ([[你 疯 狂 地 杀 戮， 试 图 尽 快 击 倒 你 的 敌 人。 
		战 斗 中， 每 次 攻 击 增 加 +%d%% 暴 击 率 和 +%d%% 物 理 抵 抗 穿 透， 但 是 每 次 攻 击 消 耗 %0.1f 体 力。]]):
		format(t.getCrit(self, t), t.getPen(self, t), t.getDrain(self, t))
	end,
}


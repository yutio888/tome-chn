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

-- Empty Hand adds extra scaling to gauntlet and glove attacks based on character level.

newTalent{
	name = "Empty Hand",
	type = {"technique/unarmed-other", 1},
	innate = true,
	hide = true,
	mode = "passive",
	points = 1,
	no_unlearn_last = true,
	on_learn = function(self, t)
		local fct = function()
			self.before_empty_hands_combat = self.combat
			self.combat = table.clone(self.combat, true)
			self.combat.physspeed = math.min(0.6, self.combat.physspeed or 1000)
			if not self.combat.sound then self.combat.sound = {"actions/punch%d", 1, 4} end
			if not self.combat.sound_miss then self.combat.sound_miss = "actions/melee_miss" end
		end
		if type(self.combat.dam) == "table" then
			game:onTickEnd(fct)
		else
			fct()
		end
	end,
	on_unlearn = function(self, t)
		self.combat = self.before_empty_hands_combat
	end,
	getDamage = function(self, t) return self.level * 0.5 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[当 你 徒 手 或 仅 装 备 手 套 和 臂 铠 时 提 高 %d 物 理 强 度。 
		受 技 能 等 级 影 响， 效 果 有 额 外 加 成。 ]]):
		format(damage)
	end,
}

-- This is by far the most powerful weapon tree in the game, loosely because you lose 2 weapon slots to make use of it and weapon stats are huge
-- Regardless, it gives much less damage than most weapon trees and is slightly more frontloaded
newTalent{
	name = "Unarmed Mastery",
	type = {"technique/unarmed-training", 1},
	points = 5,
	require = { stat = { cun=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 4 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[提 高 %d 物 理 强 度， 增 加 %d%% 所 有 徒 手 伤 害（ 包 括 抓 取 / 徒 手 技）。 
		注 意： 徒 手 战 斗 时 格 斗 家 随 等 级 每 级 增 加 0.5 物 理 强 度。（ 当 前 提 高 %0.1f 物 理 强 度） 你 的 攻 击 速 度 提 高 40%% 。]]):
		format(damage, 100*inc, self.level * 0.5)
	end,
}

newTalent{
	name = "Unified Body",
	type = {"technique/unarmed-training", 2},
	require = techs_cun_req2,
	mode = "passive",
	points = 5,
	tactical = { BUFF = 2 },
	getStr = function(self, t) return math.ceil(self:combatTalentScale(t, 1.5, 7.5, 0.75) + self:combatTalentStatDamage(t, "cun", 2, 10)) end,
	getCon = function(self, t) return math.ceil(self:combatTalentScale(t, 1.5, 7.5, 0.75) + self:combatTalentStatDamage(t, "dex", 5, 25)) end,

	passives = function(self, t, tmptable)
		self:talentTemporaryValue(tmptable, "inc_stats", {[self.STAT_CON] = t.getCon(self, t)})
		self:talentTemporaryValue(tmptable, "inc_stats", {[self.STAT_STR] = t.getStr(self, t)})	
	end,
	callbackOnStatChange = function(self, t, stat, v)
		if stat == self.STAT_DEX or stat == self.STAT_CUN then
			self:updateTalentPassives(t)
		end
	end,
	info = function(self, t)
		return ([[你 对 徒 手 格 斗 的 掌 握 强 化 了 你 的 身 体 ， 增 加 %d 力 量 （基 于 灵 巧 ） ， %d 体 质 （ 基 于 敏 捷 ）。]]):format(t.getStr(self, t), t.getCon(self, t))
	end
}

newTalent{
	name = "Heightened Reflexes",
	type = {"technique/unarmed-training", 3},
	require = techs_cun_req3,
	mode = "passive",
	points = 5,
	getPower = function(self, t) return self:combatTalentScale(t, 0.1, 2, 0.75) end,
	do_reflexes = function(self, t)
		self:setEffect(self.EFF_REFLEXIVE_DODGING, 1, {power=t.getPower(self, t)})
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[当 你 被 抛 射 物 锁 定 时， 增 加 你 %d%% 整 体 速 度 1 回 合。 
		除 了 移 动 外 的 任 何 动 作 均 会 打 破 此 效 果。]]):
		format(power * 100)
	end,
}

-- It's a bit wierd that this works against mind attacks
newTalent{
	name = "Reflex Defense",
	type = {"technique/unarmed-training", 4},
	require = techs_cun_req4, -- bit icky since this is clearly dex, but whatever, cun turns defense special *handwave*
	points = 5,
	mode = "passive",
	getDamageReduction = function(self, t) 
		return self:combatTalentLimit(t, 1, 0.15, 0.50) * self:combatLimit(self:combatDefense(), 1, 0.15, 10, 0.5, 50) -- Limit < 100%, 25% for TL 5.0 and 50 defense
	end,
	getDamagePct = function(self, t)
		return self:combatTalentLimit(t, 0.1, 0.3, 0.15) -- Limit trigger > 10% life
	end,
	callbackOnHit = function(self, t, cb)
		if ( cb.value > (t.getDamagePct(self, t) * self.max_life) ) then
			local damageReduction = cb.value * t.getDamageReduction(self, t)
			cb.value = cb.value - damageReduction
			game.logPlayer(self, "#GREEN#你通过身体复杂的变形来减轻#ORCHID#" .. math.ceil(damageReduction) .. "#LAST#点伤害.")
		end
		return cb.value
	end, 
	info = function(self, t)
		return ([[你 对 生 理 的 了 解 让 你 能 在 新 的 领 域 运 用 你 的 闪 避 神 经。 
		 每 次 你 受 到 超 过 %d%% 最 大 生 命 的 伤 害 时 ， 减 少 %d%% （ 基 于 闪 避）。]]):
		format(t.getDamagePct(self, t)*100, t.getDamageReduction(self, t)*100 )
	end,
}


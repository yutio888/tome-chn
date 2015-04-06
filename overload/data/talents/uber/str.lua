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

uberTalent{
	name = "Flexible Combat",
	mode = "passive",
	on_learn = function(self, t)
		self:attr("unharmed_attack_on_hit", 1)
		self:attr("show_gloves_combat", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("unharmed_attack_on_hit", -1)
		self:attr("show_gloves_combat", -1)
	end,
	info = function(self, t)
		return ([[每 当 你 进 行 近 战 攻 击 时， 有 60％ 几 率 追 加 一 次 额 外 的 徒 手 攻 击。  ]])
		:format()
	end,
}

uberTalent{
	name = "You Shall Be My Weapon!", short_name="TITAN_S_SMASH", image = "talents/titan_s_smash.png",
	mode = "activated",
	require = { special={desc="体型至少为巨大（使用也要满足此条件）", fct=function(self) return self.size_category and self.size_category >= 5 end} },
	requires_target = true,
	tactical = { ATTACK = 4 },
	on_pre_use = function(self, t) return self.size_category and self.size_category >= 4 end,
	cooldown = 10,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local hit = self:attackTarget(target, nil, 3.5 + 0.8 * (self.size_category - 4), true)

		if target:attr("dead") or not hit then return true end

		local dx, dy = (target.x - self.x), (target.y - self.y)
		local dir = util.coordToDir(dx, dy, 0)
		local sides = util.dirSides(dir, 0)

		target:knockback(self.x, self.y, 5, function(t2)
			local d = rng.chance(2) and sides.hard_left or sides.hard_right
			local sx, sy = util.coordAddDir(t2.x, t2.y, d)
			local ox, oy = t2.x, t2.y
			t2:knockback(sx, sy, 2, function(t3) return true end)
			if t2:canBe("stun") then t2:setEffect(t2.EFF_STUNNED, 3, {}) end
		end)
		if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, 3, {}) end
		return true
	end,
	info = function(self, t)
		return ([[对 敌 人 进 行 一 次 猛 击， 造 成 350％ 的 武 器 伤 害 并 击 退 目 标 6 码。 
		所 有 击 退 路 径 上 的 敌 人 会 被 撞 至 一 旁 并 被 震 慑 3 回 合。
		体 型 超 过  “Big” 时， 每 增 加 一 级 ， 额 外 增 加 80%% 武 器 伤 害。 ]])
		:format()
	end,
}

uberTalent{
	name = "Massive Blow",
	mode = "activated",
	require = { special={desc="曾 挖 掉 至 少 30 块 石 头 / 树 木 / 等 等， 并 且 使 用 双 手 武 器 造 成 超 过 50000 点 伤 害", fct=function(self) return 
		self.dug_times and self.dug_times >= 30 and 
		self.damage_log and self.damage_log.weapon.twohanded and self.damage_log.weapon.twohanded >= 50000
	end} },
	requires_target = true,
	tactical = { ATTACK = 4 },
	cooldown = 10,
	is_melee = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local destroyed = false
		target:knockback(self.x, self.y, 4, nil, function(g, x, y)
			if g:attr("dig") and not destroyed then
				DamageType:get(DamageType.DIG).projector(self, x, y, DamageType.DIG, 1)
				destroyed = true
			end
		end)

		self:attackTarget(target, nil, 1.5 + (destroyed and 3.5 or 0), true)
		return true
	end,
	info = function(self, t)
		return ([[对 敌 人 进 行 一 次 猛 击， 造 成 150％ 的 武 器 伤 害 并 击 退 目 标 4 码。 
		如 果 敌 人 在 击 退 时 撞 上 墙 壁， 墙 壁 会 被 撞 毁 且 对 敌 人 造 成 额 外 的 350％ 武 器 伤 害。  ]])
		:format()
	end,
}

uberTalent{
	name = "Steamroller",
	mode = "passive",
	require = { special={desc="习得冲锋技能", fct=function(self) return self:knowTalent(self.T_RUSH) end} },
	info = function(self, t)
		return ([[当 你 使 用 冲 锋 时， 冲 锋 目 标 会 被 标 记。 在 接 下 来 两 轮 之 内 杀 掉 冲 锋 对 象， 则 冲 锋 技 能 会 冷 却 完 毕。 
		每 当 此 技 能 触 发 时， 你 获 得 1 个 增 加 20％ 伤 害 的 增 益 效 果， 最 大 叠 加 至 100％。
		冲 锋 现 在 只 消 耗 2 点 体 力 。]])
		:format()
	end,
}

uberTalent{
	name = "Irresistible Sun",
	cooldown = 25,
	requires_target = true,
	range = 5,
	tactical = { ATTACKAREA = 50, CLOSEIN = 30 },  -- someone loves this talent :P
	require = { special={desc="曾造成50000点以上的光系或者火系伤害", fct=function(self) return
		self.damage_log and (
			(self.damage_log[DamageType.FIRE] and self.damage_log[DamageType.FIRE] >= 50000) or
			(self.damage_log[DamageType.LIGHT] and self.damage_log[DamageType.LIGHT] >= 50000)
		)
	end} },
	action = function(self, t)
		self:setEffect(self.EFF_IRRESISTIBLE_SUN, 6, {dam=50 + self:getStr() * 1.7})
		return true
	end,
	info = function(self, t)
		local dam = (50 + self:getStr() * 1.7) / 3
		return ([[你 获 得 6 回 合 的 星 之 引 力， 将 周 围 5 码 范 围 内 的 所 有 生 物 向 你 拉 扯， 并 对 所 有 敌 人 造 成 %0.2f 火 焰、 %0.2f 光 系 和 %0.2f 物 理 伤 害。 
		最 靠 近 你 的 敌 人 受 到 额 外 的 200％ 伤 害。 
		受 力 量 影 响， 伤 害 值 有 额 外 加 成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

uberTalent{
	name = "I Can Carry The World!", short_name = "NO_FATIGUE",
	mode = "passive",
	require = { special={desc="能够使用板甲", fct=function(self) return self:getTalentLevelRaw(self.T_ARMOUR_TRAINING) >= 3 end} },
	on_learn = function(self, t)
		self:attr("max_encumber", 500)
		self.inc_stats[self.STAT_STR] = (self.inc_stats[self.STAT_STR] or 0) + 40
  		self:onStatChange(self.STAT_STR, 40)
	end,
	info = function(self, t)
		return ([[你 是 如 此 强 壮， 永 不 疲 倦。 疲 劳 值 永 久 为 0 且 负 重 上 限 增 加 500 点 并 且 增 加 40 点 力 量 。 ]])
		:format()
	end,
}

uberTalent{
	name = "Legacy of the Naloren",
	mode = "passive",
	require = { special={desc="站在萨拉苏尔一方并且杀死厄库尔维斯克", fct=function(self)
		if game.state.birth.ignore_prodigies_special_reqs then return true end
		local q = self:hasQuest("temple-of-creation")
		return q and not q:isCompleted("kill-slasul") and q:isCompleted("kill-drake")
	end} },
	-- _M:levelup function in mod.class.Actor.lua updates the talent levels with character level
	bonusLevel = function(self, t) return math.ceil(self.level/10) end,
	callbackOnLevelup = function(self, t, new_level)
		return t.updateTalent(self, t)
	end,
	updateTalent = function(self, t)
		local p = self.talents_learn_vals[t.id] or {}
		if p.__tmpvals then
			for i = 1, #p.__tmpvals do
				self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
			end
			p.__tmpvals = nil
		end
		self:talentTemporaryValue(p, "can_breath", {water = 1})
		self.__show_special_talents[self.T_EXOTIC_WEAPONS_MASTERY] = true
		self:talentTemporaryValue(p, "talents_inc_cap", {T_EXOTIC_WEAPONS_MASTERY=t.bonusLevel(self,t)})
		self:talentTemporaryValue(p, "talents", {T_EXOTIC_WEAPONS_MASTERY=t.bonusLevel(self,t)})
		self:talentTemporaryValue(p, "talents_inc_cap", {T_SPIT_POISON=t.bonusLevel(self,t)})
		self:talentTemporaryValue(p, "talents", {T_SPIT_POISON=t.bonusLevel(self,t)})
	end,
	passives = function(self, t, p)
		-- talents_inc_cap field referenced by _M:getMaxTPoints in mod.dialogs.LevelupDialog.lua
		self.talents_inc_cap = self.talents_inc_cap or {}
		t.callbackOnLevelup(self, t)
	end,
	on_learn = function(self, t)
		require("engine.ui.Dialog"):simplePopup("Legacy of the Naloren", "Slasul will be happy to know your faith in his cause. You should return to speak to him.")
	end,
	info = function(self, t)
		local level = t.bonusLevel(self,t)
		return ([[你 站 在 萨 拉 苏 尔 一 方 并 帮 助 他 解 决 了 厄 库 尔 维 斯 克。 你 现 在 可 以 轻 松 的 在 水 下 呼 吸。 
	         同 时， 你 能 轻 易 学 会 如 何 使 用 三 叉 戟 和 其 他 异 形 武 器（ 获 得 %d 级 异 形 武 器 掌 握）， 并 且 可 以 像 娜 迦 一 样 喷 吐 毒 素（ 等 级 %d） 。 技 能 等 级 随 人 物 等 级 增 长。   
		 此 外， 若 萨 拉 苏 尔 仍 然 存 活， 他 还 会 送 你 一 份 大 礼 …]])
		:format(level, level)
	end,
}

uberTalent{
	name = "Superpower",
	mode = "passive",
	info = function(self, t)
		return ([[强 壮 的 身 体 才 能 承 载 强 大 的 灵 魂。 而 强 大 的 灵 魂 却 可 以 创 造 一 个 强 壮 的 身 体。 
		获 得 相 当 于 你 50％ 力 量 值 的 精 神 强 度 增 益。 
		此 外， 你 的 所 有 武 器 都 会 有 额 外 的 30％ 意 志 修 正 加 成。  ]])
		:format()
	end,
}

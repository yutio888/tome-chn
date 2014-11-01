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

uberTalent{
	name = "Spectral Shield",
	mode = "passive",
	require = { special={desc="掌 握 格 挡 技 能， 曾 释 放 过 100 个 法 术， 且 格 挡 强 度 超 过 200", fct=function(self)
		return self:knowTalent(self.T_BLOCK) and self:getTalentFromId(self.T_BLOCK).getBlockValue(self) >= 200 and self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 100
	end} },
	on_learn = function(self, t)
		self:attr("spectral_shield", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("spectral_shield", -1)
	end,
	info = function(self, t)
		return ([[向 护 盾 中 灌 注 魔 法 序 列， 使 格 挡 技 能 能 够 格 挡 任 何 类 型 的 伤 害。]])
		:format()
	end,
}

uberTalent{
	name = "Aether Permeation",
	mode = "passive",
	require = { special={desc="拥 有 至 少 25% 以 上 的 奥 术 抗 性， 并 且 曾 去 过 无 尽 虚 空", fct=function(self)
		return (game.state.birth.ignore_prodigies_special_reqs or self:attr("planetary_orbit")) and self:combatGetResist(DamageType.ARCANE) >= 25
	end} },
	on_learn = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "force_use_resist", DamageType.ARCANE)
		self:talentTemporaryValue(ret, "force_use_resist_percent", 66)
		return ret
	end,
	on_unlearn = function(self, t)
	end,
	info = function(self, t)
		return ([[在 你 的 周 围 创 造 一 层 厚 实 的 以 太 层， 任 何 伤 害 均 会 使 用 奥 术 抵 抗 代 替 原 本 攻 击 类 型 抵 抗 进 行 抵 抗 计 算。 
		实 际 上， 你 的 所 有 抵 抗 约 等 于 你 66％ 的 奥 术 抵 抗。 ]])
		:format()
	end,
}

uberTalent{
	name = "Mystical Cunning", image = "talents/vulnerability_poison.png",
	mode = "passive",
	require = { special={desc="掌握陷阱或者毒药技能", fct=function(self)
		return self:knowTalent(self.T_VILE_POISONS) or self:knowTalent(self.T_TRAP_MASTERY)
	end} },
	on_learn = function(self, t)
		self:attr("combat_spellresist", 20)
		if self:knowTalent(self.T_VILE_POISONS) then self:learnTalent(self.T_VULNERABILITY_POISON, true, nil, {no_unlearn=true}) end
		if self:knowTalent(self.T_TRAP_MASTERY) then self:learnTalent(self.T_GRAVITIC_TRAP, true, nil, {no_unlearn=true}) end
	end,
	on_unlearn = function(self, t)
		self:attr("combat_spellresist", -20)
	end,
	info = function(self, t)
		return ([[ 通 过 对 奥 术 之 力 的 研 究， 你 开 发 出 了 新 的 陷 阱 和 毒 药（ 由 学 习 此 进 阶 时 掌 握 的 技 能 决 定） 
		你 可 以 学 会： 
		弱 点 毒 药： 降 低 所 有 抗 性 并 造 成 奥 术 伤 害。 
		黑 洞 陷 阱： 每 回 合， 5 码 范 围 内 的 所 有 敌 人 会 被 吸 入 并 受 到 时 空 伤 害。 
		同 时， 你 的 魔 法 豁 免 永 久 提 高 20 点。]])
		:format()
	end,
}

uberTalent{
	name = "Arcane Might",
	mode = "passive",
	info = function(self, t)
		return ([[你 学 会 如 何 利 用 自 己 潜 在 的 奥 术 力 量， 将 它 们 注 入 你 的 武 器。 
		所 有 武 器 均 有 额 外 的 50％ 魔 法 加 成。]])
		:format()
	end,
}

uberTalent{
	name = "Temporal Form",
	cooldown = 30,
	require = { special={desc="曾 释 放 过 1000 个 以 上 的 技 能 并 且 成 功 进 入 过 相 位 现 实。  ", fct=function(self) return
		self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 1000 and (game.state.birth.ignore_prodigies_special_reqs or self:attr("temporal_touched"))
	end} },
	no_energy = true,
	is_spell = true,
	requires_target = true,
	range = 10,
	tactical = { BUFF = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_TEMPORAL_FORM, 10, {})
		return true
	end,
	info = function(self, t)
		return ([[你 可 以 扭 曲 周 围 的 时 间 线， 转 换 成 时 空 元 素 “ 泰 鲁 戈 洛 斯 ” 形 态， 持 续 10 回 合。 
		在 这 种 形 态 中， 你 对 定 身、 流 血、 致 盲、 震 慑 免 疫， 获 得 30％ 时 空 抵 抗 和 20％ 的 时 空 抵 抗 穿 透。 
		你 造 成 的 伤 害 的 50%% 转 化 为 时 空 伤 害。 
		同 时， 你 的 时 空 伤 害 增 益 等 于 你 所 有 类 型 的 伤 害 增 益 中 的 最 大 值， 此 外， 还 增 加 30％ 额 外 时 空 伤 害 增 益。
		转 换 成 此 形 态 会 增 加 400 点 紊 乱 值， 并 获 得 400 点 意 志 掌 控 力，当 效 果 结 束 后 会 自 动 消 失。 ]])
		:format()
	end,
}

uberTalent{
	name = "Blighted Summoning",
	mode = "passive",
	require = { special={desc="曾 召 唤 了 100 个 以 上 此 技 能 相 关 的 召 唤 生 物（ 炼 金 傀 儡 视 作 100 单 位）", fct=function(self)
		return self:attr("summoned_times") and self:attr("summoned_times") >= 100
	end} },
	on_learn = function(self, t)
		local golem = self.alchemy_golem
		if not golem then return end
		golem:learnTalentType("corruption/reaving-combat", true)
		golem:learnTalent(golem.T_CORRUPTED_STRENGTH, true, 3)
	end,
	bonusTalentLevel = function(self, t) return math.ceil(3*self.level/50) end, -- Talent level for summons
	-- called by _M:addedToLevel and by _M:levelup in mod.class.Actor.lua
	doBlightedSummon = function(self, t, who)
		if not self:knowTalent(self.T_BLIGHTED_SUMMONING) then return false end
		if who.necrotic_minion then who:incIncStat("mag", self:getMag()) end
		local tlevel = self:callTalent(self.T_BLIGHTED_SUMMONING, "bonusTalentLevel")
		-- learn specified talent if present
		if who.blighted_summon_talent then 
			who:learnTalent(who.blighted_summon_talent, true, tlevel)
			if who.talents_def[who.blighted_summon_talent].mode == "sustained" then -- Activate sustained talents by default
				who:forceUseTalent(who.blighted_summon_talent, {ignore_energy=true})
			end 
		elseif who.name == "war hound" then
			who:learnTalent(who.T_CURSE_OF_DEFENSELESSNESS,true,tlevel)
		elseif who.subtype == "jelly" then
			who:learnTalent(who.T_VIMSENSE,true,tlevel)
		elseif who.subtype == "minotaur" then
			who:learnTalent(who.T_LIFE_TAP,true,tlevel)
		elseif who.name == "stone golem" then
			who:learnTalent(who.T_BONE_SPEAR,true,tlevel)
		elseif who.subtype == "ritch" then
			who:learnTalent(who.T_DRAIN,true,tlevel)
		elseif who.type =="hydra" then
			who:learnTalent(who.T_BLOOD_SPRAY,true,tlevel)
		elseif who.name == "rimebark" then
			who:learnTalent(who.T_POISON_STORM,true,tlevel)	
		elseif who.name == "treant" then
			who:learnTalent(who.T_CORROSIVE_WORM,true,tlevel)
		elseif who.name == "fire drake" then
			who:learnTalent(who.T_DARKFIRE,true,tlevel)
		elseif who.name == "turtle" then
			who:learnTalent(who.T_CURSE_OF_IMPOTENCE,true,tlevel)
		elseif who.subtype == "spider" then
			who:learnTalent(who.T_CORROSIVE_WORM,true,tlevel)
		elseif who.subtype == "skeleton" then
			who:learnTalent(who.T_BONE_GRAB,true,tlevel)
		elseif who.subtype == "giant" and who.undead then
			who:learnTalent(who.T_BONE_SHIELD,true,tlevel)
		elseif who.subtype == "ghoul" then
				who:learnTalent(who.T_BLOOD_LOCK,true,tlevel)
		elseif who.subtype == "vampire" or who.subtype == "lich" then
			who:learnTalent(who.T_DARKFIRE,true,tlevel)
		elseif who.subtype == "ghost" or who.subtype == "wight" then
			who:learnTalent(who.T_BLOOD_BOIL,true,tlevel)
		elseif who.subtype == "shadow" then
			local tl = who:getTalentLevelRaw(who.T_EMPATHIC_HEX)
			tl = tlevel-tl
			if tl > 0 then who:learnTalent(who.T_EMPATHIC_HEX, true, tl) end		
		elseif who.type == "thought-form" then
			who:learnTalent(who.T_FLAME_OF_URH_ROK,true,tlevel)
		elseif who.subtype == "yeek" then
			who:learnTalent(who.T_DARK_PORTAL, true, tlevel)
		elseif who.name == "bloated ooze" then
			who:learnTalent(who.T_BONE_SHIELD,true,math.ceil(tlevel*2/3))
		elseif who.name == "mucus ooze" then
			who:learnTalent(who.T_VIRULENT_DISEASE,true,tlevel)
		else
--			print("Error: attempting to apply talent Blighted Summoning to incorrect creature type")
			return false
		end
		return true
	end,
	info = function(self, t)
		local tl = t.bonusTalentLevel(self, t)
		return ([[ 你 将 枯 萎 元 素 注 入 你 的 召 唤 兽 体 内， 给 予 它 们 新 的 技 能( 等 级 %d )： 
		- 战 争 猎 犬 : 衰 竭 诅 咒  - 黑 果 冻 怪 : 活 力 感 知 
		- 米 诺 陶 : 生 命 源 泉 - 岩 石 傀 儡 : 白 骨 之 矛 
		- 火 焰 里 奇 : 枯 萎 吸 收 - 三 头 蛇 : 鲜 血 喷 射 
		- 雾 凇 : 剧 毒 风 暴 - 火 龙 : 黑 暗 之 炎 
		- 乌 龟 : 虚 弱 诅 咒 - 蜘 蛛 : 腐 蚀 蠕 虫 
		- 骷 髅 : 白 骨 之 握 或 白 骨 之 矛 - 骨 巨 人 : 骨 盾 
		- 食 尸 鬼 : 鲜 血 禁 锢 - 吸 血 鬼 / 巫 妖 : 黑 暗 之 炎 
		- 梦 靥 / 尸 妖 : 鲜 血 沸 腾 
		- 炼 金 傀 儡 : 堕 落 力 量 和 掠 夺 格 斗 系 技 能 树 
		- 阴 影 : 转 移 邪 术 - 精 神 体 战 士 : 乌 鲁 洛 克 之 焰 
		- 树 人 : 腐 蚀 蠕 虫 - 夺 心 魔 精 英 : 黑 暗 之 门 
		- 食 尸 鬼 傀 儡 : 撕 裂 
		- 浮 肿 软 泥 怪 : 白 骨 护 盾 ( 等 级 %d )
		- 粘 液 软 泥 怪 : 剧 毒 瘟 疫 
		 你 的 死 灵 召 唤 和 自 然 召 唤 会 得 到 魔 法 加 成。
		 技 能 等 级 随 人 物 等 级 增 加。 
		 其 他 种 族 和 物 品 召 唤 物 也 有 可 能 被 影 响。]])
		 :format(tl,math.ceil(tl*2/3))
	end,
-- Note: Choker of Dread Vampire, and Mummified Egg-sac of Ungol? spiders handled by default
-- Crystal Shard summons use specified talent
}

uberTalent{
	name = "Revisionist History",
	cooldown = 30,
	no_energy = true,
	is_spell = true,
	no_npc_use = true,
	require = { special={desc="曾经至少进行过一次时空穿越", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("time_travel_times") and self:attr("time_travel_times") >= 1) end} },
	action = function(self, t)
		if game._chronoworlds and game._chronoworlds.revisionist_history then
			self:hasEffect(self.EFF_REVISIONIST_HISTORY).back_in_time = true
			self:removeEffect(self.EFF_REVISIONIST_HISTORY)
			return nil -- the effect removal starts the cooldown
		end

		if checkTimeline(self) == true then return end

		game:onTickEnd(function()
			game:chronoClone("revisionist_history")
			self:setEffect(self.EFF_REVISIONIST_HISTORY, 19, {})
		end)
		return nil -- We do not start the cooldown!
	end,
	info = function(self, t)
		return ([[你 现 在 可 以 控 制 不 远 的 过 去。 使 用 技 能 后 获 得 一 个 持 续 20 轮 的 时 空 效 果。 
		 在 效 果 持 续 时 间 内， 再 次 使 用 技 能 即 可 回 到 第 
		 一 次 使 用 的 时 间 点 重 新 来 过。 
 		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 
		 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。  ]])
		:format()
	end,
}
newTalent{
	name = "Unfold History", short_name = "REVISIONIST_HISTORY_BACK",
	type = {"uber/other",1},
	cooldown = 30,
	no_energy = true,
	is_spell = true,
	no_npc_use = true,
	action = function(self, t)
		if game._chronoworlds and game._chronoworlds.revisionist_history then
			self:hasEffect(self.EFF_REVISIONIST_HISTORY).back_in_time = true
			self:removeEffect(self.EFF_REVISIONIST_HISTORY)
			return nil -- the effect removal starts the cooldown
		end
		return nil -- We do not start the cooldown!
	end,
	info = function(self, t)
		return ([[改 写 历 史 ， 返 回 到 修 正 历 史 施 法 点 。]])
		:format()
	end,
}

uberTalent{
	name = "Cauterize",
	mode = "passive",
	cooldown = 12,
	require = { special={desc="曾 承 受 过 至 少 7500 点 火 焰 伤 害， 并 且 至 少 曾 释 放 过 1000 次 法 术  ", fct=function(self) return
		self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 1000 and self.damage_intake_log and self.damage_intake_log[DamageType.FIRE] and self.damage_intake_log[DamageType.FIRE] >= 7500
	end} },
	trigger = function(self, t, value)
		self:startTalentCooldown(t)

		if self.player then world:gainAchievement("AVOID_DEATH", self) end
		self:setEffect(self.EFF_CAUTERIZE, 8, {dam=value/10})
		return true
	end,
	info = function(self, t)
		return ([[你 的 心 炎 是 如 此 强 大。 每 当 你 受 到 必 死 的 攻 击 时， 你 的 身 体 会 被 圣 焰 所 环 绕。 
		 圣 焰 会 修 复 伤 口， 完 全 吸 收 此 次 攻 击 伤 害， 但 是 它 们 将 会 继 续 燃 烧， 持 续 8 回 合。 
		 每 回 合 圣 焰 会 对 你 造 成 10％ 刚 才 吸 收 的 伤 害（ 此 伤 害 会 自 动 忽 略 护 甲 和 抵 抗）。 
		 警 告： 此 技 能 有 冷 却 时 间， 慎 用。  ]])
	end,
}

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

-- Generic requires for racial based on talent level
racial_req1 = {
	level = function(level) return 0 + (level-1)  end,
}
racial_req2 = {
	level = function(level) return 8 + (level-1)  end,
}
racial_req3 = {
	level = function(level) return 16 + (level-1)  end,
}
racial_req4 = {
	level = function(level) return 24 + (level-1)  end,
}

------------------------------------------------------------------
-- Highers' powers
------------------------------------------------------------------
newTalentType{ type="race/higher", name = "higher", generic = true, description = "The various racial bonuses a character can have." }

newTalent{
	short_name = "HIGHER_HEAL",
	name = "Gift of the Highborn",
	type = {"race/higher", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 45, 25)) end, -- Limit >10
	tactical = { HEAL = 2 },
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	action = function(self, t)
		self:setEffect(self.EFF_REGENERATION, 10, {power=5 + self:getWil() * 0.5})
		return true
	end,
	info = function(self, t)
		return ([[召 唤 高 贵 血 统 来 使 你 的 身 体 以 %d 点 每 回 合 的 速 率 恢 复， 持 续 10 回 合。 
		 受 意 志 影 响， 生 命 恢 复 量 有 额 外 增 益。]]):format(5 + self:getWil() * 0.5)
	end,
}

newTalent{
	name = "Overseer of Nations",
	type = {"race/higher", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getSight = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getESight = function(self, t) return math.ceil(self:combatTalentScale(t, 0.3, 2.3, "log", 0, 2)) end,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.1, 0.4) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "blind_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "sight", t.getSight(self, t))
		self:talentTemporaryValue(p, "infravision", t.getESight(self, t))
		self:talentTemporaryValue(p, "heightened_senses", t.getESight(self, t))
	end,
	info = function(self, t)
		return ([[虽 然 高 贵 血 统 并 不 意 味 着 统 治 他 人（ 当 然 也 没 有 特 别 的 意 愿 去 那 样 做）， 但 是 他 们 经 常 承 担 更 高 的 义 务。 
		 他 们 的 本 能 使 得 他 们 比 别 人 有 更 强 的 直 觉。 
		 增 加 %d%% 目 盲 免 疫 , 提 高 %d 点 最 大 视 野 范 围 并 提 高 %d 光 照、 夜 视 及 感 应 范 围。]]):
		format(t.getImmune(self, t) * 100, t.getSight(self, t), t.getESight(self, t))
	end,
}

newTalent{
	name = "Born into Magic",
	type = {"race/higher", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 19, 7)) end, -- Limit > 0
	getSave = function(self, t) return self:combatTalentScale(t, 5, 25, 0.75) end,
	power = function(self, t) return self:combatTalentScale(t, 7, 25) end,
	trigger = function(self, t, damtype)
		self:startTalentCooldown(t)
		self:setEffect(self.EFF_BORN_INTO_MAGIC, 5, {damtype=damtype})
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellresist", t.getSave(self, t))
		self:talentTemporaryValue(p, "resists",{[DamageType.ARCANE]=t.power(self, t)})
	end,
	info = function(self, t)
		local netpower = t.power(self, t)
		return ([[高 等 人 类 们 最 初 是 在 厄 流 纪 前 由 红 衣 主 神 们 创 造 的。 他 们 天 生 具 有 魔 法 天 赋。 
		 提 高 +%d 点 法 术 豁 免 和 %d%% 奥 术 抵 抗。
		 每 次 释 放 伤 害 法 术 时 ， 5 回 合 内 该 伤 害 类 型 获 得 15%% 伤 害 加 成 。 （ 该 效 果 有 冷 却 时 间。）]]):
		format(t.getSave(self, t), netpower)
	end,
}

newTalent{
	name = "Highborn's Bloom",
	type = {"race/higher", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 20, 47, 35)) end, -- Limit >20
	tactical = { MANA = 2, VIM = 2, EQUILIBRIUM = 2, STAMINA = 2, POSITIVE = 2, NEGATIVE = 2, PARADOX = 2, PSI = 2 },
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 2, 6.1)) end,  --  Limit to < 10
	action = function(self, t)
		self:setEffect(self.EFF_HIGHBORN_S_BLOOM, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[激 活 你 的 内 在 潜 力， 以 提 高 你 的 能 力。 
		 在 接 下 来 %d 回 合 中 可 无 消 耗 使 用 技 能。 
		 你 的 能 量 值 仍 需 要 满 足 使 用 这 些 技 能 的 最 低 能 量 需 求， 且 技 能 仍 有 几 率 会 失 败。]]):format(duration)
	end,
}

------------------------------------------------------------------
-- Shaloren's powers
------------------------------------------------------------------
newTalentType{ type="race/shalore", name = "shalore", generic = true, is_spell=true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "SHALOREN_SPEED",
	name = "Grace of the Eternals",
	type = {"race/shalore", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 46, 30)) end,  -- Limit to >10 turns
	getSpeed = function(self, t) return self:combatStatScale(math.max(self:getDex(), self:getMag()), 0.1, 0.476, 0.75) end,
	tactical = { DEFEND = 1 },
	action = function(self, t)
		self:setEffect(self.EFF_SPEED, 8, {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[召 唤 不 朽 的 恩 赐 之 力 来 增 加 你 %d%% 的 基 础 速 度， 持 续 8 回 合。 
		 受 敏 捷 和 魔 法 中 较 高 一 项 影 响 ， 速 度 会 有 额 外 的 提 升。]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

newTalent{
	name = "Magic of the Eternals",
	type = {"race/shalore", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	critChance = function(self, t) return self:combatTalentScale(t, 3, 10, 0.75) end,
	critPower = function(self, t) return self:combatTalentScale(t, 6, 25, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physcrit", t.critChance(self, t))
		self:talentTemporaryValue(p, "combat_spellcrit", t.critChance(self, t))
		self:talentTemporaryValue(p, "combat_mindcrit", t.critChance(self, t))
		self:talentTemporaryValue(p, "combat_critical_power", t.critPower(self, t))
	end,
	info = function(self, t)
		return ([[因 为 永 恒 精 灵 的 自 然 魔 法， 现 实 发 生 了 轻 微 的 扭 曲。 
		 提 高 %d%% 的 暴 击 概 率 和 %d%% 暴 击 伤 害。]]):
		format(t.critChance(self, t), t.critPower(self, t))
	end,
}

newTalent{
	name = "Secrets of the Eternals",
	type = {"race/shalore", 3},
	require = racial_req3,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 47, 35)) end, -- Limit > 5
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 21, 45) end, -- Limit < 100%
	getInvis = function(self, t) return self:combatStatScale("mag" , 7, 25) end,
	mode = "sustained",
	no_energy = true,
	activate = function(self, t)
		self.invis_on_hit_disable = self.invis_on_hit_disable or {}
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			invis = self:addTemporaryValue("invis_on_hit", t.getChance(self, t)),
			power = self:addTemporaryValue("invis_on_hit_power", t.getInvis(self, t)),
			talent = self:addTemporaryValue("invis_on_hit_disable", {[t.id]=1}),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("invis_on_hit", p.invis)
		self:removeTemporaryValue("invis_on_hit_power", p.power)
		self:removeTemporaryValue("invis_on_hit_disable", p.talent)
		return true
	end,
	info = function(self, t)
		return ([[作 为 埃 亚 尔 仅 存 的 古 老 种 族， 永 恒 精 灵 在 漫 长 的 岁 月 里 学 习 到 如 何 用 他 们 与 生 俱 来 的 精 神 魔 法 保 护 自 己。 
		%d%% 的 概 率 使 自 身 进 入 隐 形 状 态（ %d 点 隐 形 等 级）， 当 承 受 至 少 10%% 总 生 命 值 的 伤 害 时 触 发， 持 续 5 回 合。]]):
		format(t.getChance(self, t), t.getInvis(self, t))
	end,
}

newTalent{
	name = "Timeless",
	type = {"race/shalore", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 20, 47, 35)) end, -- Limit to >20
	getEffectGood = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getEffectBad = function(self, t) return math.floor(self:combatTalentScale(t, 2.9, 10.01, "log")) end,
	tactical = {
		BUFF = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.status == "beneficial" then nb = nb + 1 end
			end
			return nb
		end,
		CURE = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end,
	},
	action = function(self, t)
		local target = self
		local todel = {}
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.type ~= "other" then
				if e.status == "beneficial" then
					p.dur = math.min(p.dur*2, p.dur + t.getEffectGood(self, t))
				elseif e.status == "detrimental" then
					p.dur = p.dur - t.getEffectBad(self, t)
					if p.dur <= 0 then todel[#todel+1] = eff_id end
				end
			end
		end
		while #todel > 0 do
			target:removeEffect(table.remove(todel))
		end

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and self.talents_cd[tid] then tids[#tids+1] = t end
		end
		while #tids > 0 do
			local tt = rng.tableRemove(tids)
			if not tt then break end
			self.talents_cd[tt.id] = self.talents_cd[tt.id] - t.getEffectGood(self, t)
			if self.talents_cd[tt.id] <= 0 then self.talents_cd[tt.id] = nil end
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[世 界 在 不 断 的 变 老， 而 你 似 乎 永 恒 不 变。 对 于 你 来 说， 时 间 是 不 同 寻 常 的。 
		 减 少 %d 回 合 负 面 状 态 的 持 续 时 间 ， 减 少 技 能 %d 回 合 冷 却 时 间 直 至 冷 却 并 增 加 %d 回 合 增 益 状 态 的 持 续 时 间（ 至 多 延 长 为 剩 余 时 间 的 两 倍）。]]):
		format(t.getEffectBad(self, t), t.getEffectGood(self, t), t.getEffectGood(self, t))
	end,
}

------------------------------------------------------------------
-- Thaloren's powers
------------------------------------------------------------------
newTalentType{ type="race/thalore", name = "thalore", generic = true, is_nature=true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "THALOREN_WRATH",
	name = "Wrath of the Woods",
	type = {"race/thalore", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit > 5
	getPower = function(self, t) return self:combatStatScale("wil", 11, 20) end,
	tactical = { ATTACK = 1, DEFEND = 1 },
	action = function(self, t)
		self:setEffect(self.EFF_ETERNAL_WRATH, 5, {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[召 唤 远 古 森 林 之 力， 提 高 %d%% 所 有 伤 害 并 减 少 %d%% 所 承 受 伤 害 5 回 合。 
		 受 意 志 影 响 , 此 效 果 有 额 外 加 成。]]):
		format(t.getPower(self, t), t.getPower(self, t))
	end,
}

newTalent{
	name = "Unshackled",
	type = {"race/thalore", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getSave = function(self, t) return self:combatTalentScale(t, 6, 25, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physresist", t.getSave(self, t))
		self:talentTemporaryValue(p, "combat_mentalresist", t.getSave(self, t))
	end,
	info = function(self, t)
		return ([[自 然 精 灵 一 度 自 由 的 生 活 在 他 们 热 爱 的 森 林， 从 不 关 心 外 界 的 事 物。 
		 提 高 物 理 和 精 神 豁 免 +%d 点。]]):
		format(t.getSave(self, t))
	end,
}

newTalent{
	name = "Guardian of the Wood",
	type = {"race/thalore", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getDiseaseImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.75) end, -- Limit < 100%
	getBResist = function(self, t) return self:combatTalentScale(t, 3, 10) end,
	getAllResist = function(self, t) return self:combatTalentScale(t, 2, 6.5) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "disease_immune", t.getDiseaseImmune(self, t))
		self:talentTemporaryValue(p, "resists",{[DamageType.BLIGHT]=t.getBResist(self, t)})
		self:talentTemporaryValue(p, "resists",{all=t.getAllResist(self, t)})
	end,
	info = function(self, t)
		return ([[你 是 森 林 的 一 部 分， 它 保 护 你 免 受 侵 蚀。 
		 提 高 %d%% 疾 病 抵 抗、 %0.1f%% 枯 萎 抵 抗 和 %0.1f%% 所 有 抵 抗。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getBResist(self, t), t.getAllResist(self, t))
	end,
}

newTalent{
	name = "Nature's Pride",
	type = {"race/thalore", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 46, 34)) end, -- limit >8
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = { stun = 1, knockback = 1 } },
	range = 4,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		for i = 1, 2 do
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				if i == 1 then return else break end
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "immovable", subtype = "plants",
				display = "#",
				name = "treant", color=colors.GREEN,
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/immovable_plants_treant.png", display_h=2, display_y=-1}}},
				desc = "A very strong near-sentient tree.",

				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

				rank = 3,
				life_rating = 13,
				max_life = resolvers.rngavg(50,80),
				infravision = 10,

				autolevel = "none",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=2, },
				stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
				combat = { dam=resolvers.levelup(resolvers.rngavg(15,25), 1, 1.3), atk=resolvers.levelup(resolvers.rngavg(15,25), 1, 1.6), dammod={str=1.1} },
				inc_stats = {
					str=25 + self:combatScale(self:getWil() * self:getTalentLevel(t), 0, 0, 100, 500, 0.75),
					dex=18,
					con=10 + self:combatTalentScale(t, 3, 10, 0.75),
				},
				level_range = {1, nil}, exp_worth = 0,
				silent_levelup = true,

				resists = {all = self:combatGetResist(DamageType.BLIGHT)},

				combat_armor = 13, combat_def = 8,
				resolvers.talents{ [Talents.T_STUN]=self:getTalentLevelRaw(t), [Talents.T_KNOCKBACK]=self:getTalentLevelRaw(t), [Talents.T_TAUNT]=self:getTalentLevelRaw(t), },

				faction = self.faction,
				summoner = self, summoner_gain_exp=true,
				summon_time = 8,
				ai_target = {actor=target}
			}
			setupSummon(self, m, x, y)
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[自 然 与 你 同 在， 你 可 以 时 刻 感 受 到 森 林 的 召 唤。 
		 召 唤 2 个 精 英 树 人， 持 续 8 回 合。 
		 树 人 的 所 有 抵 抗 取 决 于 你 的 枯 萎 抵 抗， 并 且 可 以 震 慑、 击 退 和 嘲 讽 敌 人。 
		 受 意 志 影 响， 它 们 的 力 量 会 有 额 外 加 成。]]):format()
	end,
}

------------------------------------------------------------------
-- Dwarves' powers
------------------------------------------------------------------
newTalentType{ type="race/dwarf", name = "dwarf", generic = true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "DWARF_RESILIENCE",
	name = "Resilience of the Dwarves",
	type = {"race/dwarf", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 45, 25)) end, -- Limit >8
	getParams = function(self, t)
		return {
			armor = self:combatStatScale("con", 7, 25),
			physical = self:combatStatScale("con", 12, 30, 0.75),
			spell = self:combatStatScale("con", 12, 30, 0.75),
		}
	end,
	tactical = { DEFEND = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_DWARVEN_RESILIENCE, 8, t.getParams(self, t))
		return true
	end,
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召 唤 矮 人 一 族 的 传 奇 血 统 来 增 加 你 +%d 点 护 甲 值， +%d 点 法 术 豁 免 和 +%d 物 理 豁 免， 持 续 8 回 合。 
		 受 你 的 体 质 影 响， 此 效 果 有 额 外 加 成。]]):
		format(params.armor, params.physical, params.spell)
	end,
}

newTalent{
	name = "Stoneskin",
	type = {"race/dwarf", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	armor = function(self, t) return self:combatTalentScale(t, 6, 30) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "auto_stoneskin", t.armor(self, t))
	end,
	info = function(self, t)
		return ([[矮 人 皮 肤 是 一 种 复 杂 的 结 构， 它 可 以 在 受 到 打 击 后 自 动 硬 化。 
		当 被 击 打 时 有 15%% 的 概 率 增 加 %d 点 护 甲 值， 持 续 5 回 合。]]):
		format(t.armor(self, t))
	end,
}

newTalent{
	name = "Power is Money",
	type = {"race/dwarf", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getMaxSaves = function(self, t) return self:combatTalentScale(t, 8, 35) end,
	getGold = function(self, t) return self:combatTalentLimit(t, 40, 85, 65) end, -- Limit > 40
	-- called by _M:combatPhysicalResist, _M:combatSpellResist, _M:combatMentalResist in mod.class.interface.Combat.lua
	getSaves = function(self, t)
		return util.bound(self.money / t.getGold(self, t), 0, t.getMaxSaves(self, t))
	end,
	info = function(self, t)
		return ([[金 钱 是 矮 人 王 国 的 心 脏， 它 控 制 了 所 有 其 他 决 策。 
		 基 于 你 的 金 币 持 有 量， 增 加 物 理、 精 神 和 法 术 抵 抗。 
		+1 豁 免 值 每 %d 单 位 金 币， 最 大 +%d (currently +%d)。]]):
		format(t.getGold(self, t), t.getMaxSaves(self, t), t.getSaves(self, t))
	end,
}

newTalent{
	name = "Stone Walking",
	type = {"race/dwarf", 4},
	require = racial_req4,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit >5
	range = 1,
	no_npc_use = true,
	getRange = function(self, t)
		return math.max(1, math.floor(self:combatScale(0.04*self:getCon() + self:getTalentLevel(t), 2.4, 1.4, 10, 9)))
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), nolock=true, simple_dir_request=true, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		self:probabilityTravel(x, y, t.getRange(self, t))
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[虽 然 矮 人 的 起 源 对 其 他 种 族 来 说 始 终 是 不 解 之 谜， 但 是 很 显 然 他 们 的 起 源 与 石 头 密 不 可 分。 
		 你 可 以 指 定 任 何 一 堵 墙 并 立 刻 穿 过 它， 出 现 在 另 一 侧。 
		 移 动 距 离 最 大 %d 码（ 受 体 质 和 分 类 天 赋 等 级 影 响 有 额 外 加 成）]]):
		format(range)
	end,
}

------------------------------------------------------------------
-- Halflings' powers
------------------------------------------------------------------
newTalentType{ type="race/halfling", name = "halfling", generic = true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "HALFLING_LUCK",
	name = "Luck of the Little Folk",
	type = {"race/halfling", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25)) end, -- Limit >5
	getParams = function(self, t)
		return {
			physical = self:combatStatScale("cun", 15, 60, 0.75),
			spell = self:combatStatScale("cun", 15, 60, 0.75),
			mind = self:combatStatScale("cun", 15, 60, 0.75),
			}
	end,
	tactical = { ATTACK = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_HALFLING_LUCK, 5, t.getParams(self, t))
		return true
	end,
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召 唤 小 不 点 的 幸 运 和 机 智 来 提 高 你 %d%% 的 物 理、 法 术 和 精 神 暴 击 率 和 %d 点 物 理、 法 术 和 精 神 豁 免 5 回 合。 
		 受 灵 巧 影 响， 此 效 果 有 额 外 增 益。]]):
		format(params.mind, params.mind)
	end,
}

newTalent{
	name = "Duck and Dodge",
	type = {"race/halfling", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getThreshold = function(self, t) return math.max(10, (15 - self:getTalentLevelRaw(t))) / 100 end,
	getEvasionChance = function(self, t) return 50 end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 1.3, 3.3)) end,
	-- called by _M:onTakeHit function in mod.class.Actor.lua for trigger 
	getDefense = function(self) 
		local oldevasion = self:hasEffect(self.EFF_EVASION)
		return self:getStat("lck")/200*(self:combatDefenseBase() - (oldevasion and oldevasion.defense or 0)) -- Prevent stacking
	end,
	info = function(self, t)
		local threshold = t.getThreshold(self, t)
		local evasion = t.getEvasionChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 强 大 的 人 品 在 关 键 时 刻 总 能 保 你 一 命。 
		每 当 一 次 攻 击 对 你 造 成 %d%% 生 命 值 或 更 多 伤 害 时，你 可 以 获 得 额 外 %d%% 闪 避 率 和 %d 点 闪 避（ 基 于 幸 运 和 其 他 闪 避 相 关 数 值 ）， 持 续 %d 回 合 。]]):
		format(threshold * 100, evasion, t.getDefense(self), duration)
	end,
}

newTalent{
	name = "Militant Mind",
	type = {"race/halfling", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	info = function(self, t)
		return ([[半 身 人 曾 是 一 个 有 组 织 纪 律 的 种 族， 敌 人 越 多 他 们 越 团 结。 
		 如 果 有 2 个 或 多 个 敌 人 在 你 的 视 野 里， 每 个 敌 人 都 会 使 你 的 所 有 强 度 和 豁 免 提 高 %0.1f 。（ 最 多 5 个 敌 人）]]):
		format(self:getTalentLevel(t) * 1.5)
	end,
}

newTalent{
	name = "Indomitable",
	type = {"race/halfling", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 45, 25)) end, -- limit >10
	tactical = { DEFEND = 1,  CURE = 1 },
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local effs = {}

		-- Go through all effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.stun or e.subtype.pin then -- Daze is stun subtype
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
			end
		end
	
		self:setEffect(self.EFF_FREE_ACTION, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[半 身 人 以 骁 勇 善 战 闻 名 于 世， 他 们 曾 经 在 战 场 上 对 抗 其 他 种 族 上 千 年。 
		 立 刻 移 除 2 种 震 慑、 眩 晕 和 定 身 状 态， 并 使 你 对 震 慑、 眩 晕 和 定 身 免 疫 %d 回 合。 
		 使 用 此 技 能 不 消 耗 回 合。]]):format(duration, count)
	end,
}

------------------------------------------------------------------
-- Orcs' powers
------------------------------------------------------------------
newTalentType{ type="race/orc", name = "orc", generic = true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "ORC_FURY",
	name = "Orcish Fury",
	type = {"race/orc", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 46, 30)) end, -- Limit to >5 turns
	getPower = function(self, t) return self:combatStatScale("wil", 12, 30) end,
	tactical = { ATTACK = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_ORC_FURY, 5, {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[激 活 你 对 杀 戮 和 破 坏 的 渴 望， 增 加 %d%% 所 有 伤 害， 持 续 5 回 合。 
		 受 意 志 影 响， 增 益 有 额 外 加 成。]]):
		format(t.getPower(self, t))
	end,
}

newTalent{
	name = "Hold the Ground",
	type = {"race/orc", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getSaves = function(self, t) return self:combatTalentScale(t, 6, 25, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physresist", t.getSaves(self, t))
		self:talentTemporaryValue(p, "combat_mentalresist", t.getSaves(self, t))
	end,
	info = function(self, t)
		return ([[其 他 种 族 对 兽 族 的 猎 杀 持 续 了 上 千 年， 不 管 是 否 正 义。 他 们 已 经 学 会 忍 受 那 些 会 摧 毁 弱 小 种 族 的 灾 难。 
		 增 加 +%d 物 理 和 精 神 豁 免。]]):
		format(t.getSaves(self, t))
	end,
}

newTalent{
	name = "Skirmisher",
	type = {"race/orc", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	getPen = function(self, t) return self:combatTalentLimit(t, 20, 7, 15) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists_pen", {all = t.getPen(self, t)})
	end,
	info = function(self, t)
		return ([[兽 人 们 经 历 了 许 多 次 战 争， 并 获 胜 了 许 多 次。 
		 增 加 %d%% 所 有 伤 害 穿 透。]]):
		format(t.getPen(self, t))
	end,
}

newTalent{
	name = "Pride of the Orcs",
	type = {"race/orc", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 46, 30)) end, -- Limit to >10
	remcount  = function(self,t) return math.ceil(self:combatTalentScale(t, 0.5, 3, "log", 0, 3)) end,
	heal = function(self, t) return 25 + 2.3* self:getCon() + self:combatTalentLimit(t, 0.1, 0.01, 0.05)*self.max_life end,
	is_heal = true,
	tactical = { DEFEND = 1, HEAL = 2, CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				nb = nb + 1
			end
		end
		return nb
	end },
	action = function(self, t)
		local target = self
		local effs = {}

		-- Go through all temporary effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.remcount(self,t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end
		self:attr("allow_on_heal", 1)
		self:heal(t.heal(self, t), t)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
		end
		self:attr("allow_on_heal", -1)
		return true
	end,
	info = function(self, t)
		return ([[呼 唤 兽 族 荣 耀 来 和 敌 人 拼 搏。 
		 治 疗 %d 生 命 值 并 移 除 %d 个 负 面 状 态。 
		 受 体 质 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(t.heal(self, t), t.remcount(self,t))
	end,
}

------------------------------------------------------------------
-- Yeeks' powers
------------------------------------------------------------------
newTalentType{ type="race/yeek", name = "yeek", is_mind=true, generic = true, description = "The various racial bonuses a character can have." }
newTalent{
	short_name = "YEEK_WILL",
	name = "Dominant Will",
	type = {"race/yeek", 1},
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 47, 35)) end, -- Limit >10
	getduration = function(self) return math.floor(self:combatStatScale("wil", 5, 14)) end,
	range = 4,
	no_npc_use = true,
	requires_target = true,
	direct_hit = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or target.dead or target == self then return end
			if not target:canBe("instakill") or target.rank > 3 or target:attr("undead") or game.party:hasMember(target) or not target:checkHit(self:getWil(20, true) + self.level * 1.5, target.level) then
				game.logSeen(target, "%s resists the mental assault!", target.name:capitalize())
				return
			end
			target:takeHit(1, self)
			target:takeHit(1, self)
			target:takeHit(1, self)
			target:setEffect(target.EFF_DOMINANT_WILL, t.getduration(self), {src=self})
		end)
		return true
	end,
	info = function(self, t)
		return ([[粉 碎 目 标 的 意 志， 使 你 可 以 完 全 控 制 它 的 行 动 %s 回 合。 
		 当 技 能 结 束 时， 你 的 意 志 会 脱 离 而 目 标 会 因 大 脑 崩 溃 而 死 亡。 
		 此 技 能 无 法 用 于 稀 有 怪, bosses 或 不 死 族。 
		 受 你 的 意 志 影 响， 持 续 时 间 有 额 外 加 成。]]):format(t.getduration(self))
	end,
}

newTalent{
	name = "Unity",
	type = {"race/yeek", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.17, 0.6) end, -- Limit < 100%
	getSave = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "confusion_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "silence_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "combat_mentalresist", t.getSave(self, t))
	end,
	info = function(self, t)
		return ([[你 的 思 维 和 精 神 网 络 变 的 更 加 协 调 并 且 增 强 对 负 面 效 果 的 抵 抗。 
		 增 加 %d%% 混 乱 和 沉 默 抵 抗 并 增 加 你 +%d 点 精 神 豁 免。]]):
		format(100*t.getImmune(self, t), t.getSave(self, t))
	end,
}

newTalent{
	name = "Quickened",
	type = {"race/yeek", 3},
	require = racial_req3,
	points = 5,
	mode = "passive",
	speedup = function(self, t) return self:combatTalentScale(t, 0.04, 0.15, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "global_speed_base", t.speedup(self, t))
		self:recomputeGlobalSpeed()
	end,
	info = function(self, t)
		return ([[基 于 “ 精 神 网 络 ”， 夺 心 魔 新 陈 代 谢 很 快， 思 维 很 快 并 且 献 祭 也 很 快。 
		 增 加 %0.1f%% 整 体 速 度。]]):format(100*t.speedup(self, t))
	end,
}

newTalent{
	name = "Wayist",
	type = {"race/yeek", 4},
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 6, 47, 35)) end, -- Limit >6
	range = 4,
	no_npc_use = true,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		for i = 1, 3 do
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "humanoid", subtype = "yeek",
				display = "y",
				name = "yeek mindslayer", color=colors.YELLOW,
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_yeek_yeek_mindslayer.png", display_h=2, display_y=-1}}},
				desc = "A wayist that came to help.",

				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

				rank = 3,
				life_rating = 8,
				max_life = resolvers.rngavg(50,80),
				infravision = 10,

				autolevel = "none",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=2, },
				stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
				inc_stats = {
					str=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					mag=10,
					cun=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					wil=self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75),
					dex=18,
					con=10 + self:combatTalentScale(t, 2, 10, 0.75),
				},
				resolvers.equip{
					{type="weapon", subtype="longsword", autoreq=true},
					{type="weapon", subtype="dagger", autoreq=true},
				},

				level_range = {1, nil}, exp_worth = 0,
				silent_levelup = true,

				combat_armor = 13, combat_def = 8,
				resolvers.talents{
					[Talents.T_KINETIC_SHIELD]={base=1, every=5, max=5},
					[Talents.T_KINETIC_AURA]={base=1, every=5, max=5},
					[Talents.T_CHARGED_AURA]={base=1, every=5, max=5},
				},

				faction = self.faction,
				summoner = self, summoner_gain_exp=true,
				summon_time = 6,
				ai_target = {actor=target}
			}
			setupSummon(self, m, x, y)
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[通 过 夺 心 魔 的 精 神 网 络， 迅 速 召 集 帮 手。 
		 在 你 周 围 召 唤 3 个 夺 心 魔 精 英 ，持 续 6 回 合。]])
	end,
}

-- Yeek's power: ID
newTalent{
	short_name = "YEEK_ID",
	name = "Knowledge of the Way",
	type = {"base/race", 1},
	no_npc_use = true,
	no_unlearn_last = true,
	mode = "passive",
	on_learn = function(self, t) self.auto_id = 100 end,
	info = function(self, t)
		return ([[你 可 以 与 维 网 取 得 联 系 并 寻 找 资 料， 增 加 你 脑 
		 内 信 息， 可 以 帮 你 辨 识 所 有 你 不 能 辨 识 的 物 品。]])
	end,
}

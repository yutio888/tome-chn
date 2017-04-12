local DamageType = require "engine.DamageType"
timeEffectCHN:newEffect{
	id = "DEMON_BLADE",
	enName = "Demon blade",
	chName = "恶魔之刃",
	type = "魔法",
	subtype = "恶魔",
	desc = function(self,eff) return("近 战 攻 击 将 附 加 半 径 1 的 火 球 ，伤 害 %0.2f"):format(eff.dam)
	end,
}

timeEffectCHN:newEffect{
	id = "FIERY_TORMENT",
	enName = "Fiery Torment",
	chName = "灼魂之罚",
	desc = function(self, eff) return ("目 标 的 火 焰 抗 性 下 降 %d%% , 并 会 被 恶 魔 空 间 的 火 焰 灼 伤 。 效 果 结 束 时 将 受 到 %d 火 焰 伤 害 ， 并 追 加 %d%% 效 果 期 间 受 到 的 总 伤 害。"):format(eff.power, eff.finaldam, eff.rate*100) end,
	type = "魔法",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "DESTROYER_FORM",
	enName = "Destroyer",
	chName = "毁灭者",
	desc = function(self, eff) return ("目 标 变 形 为 强 大 的 恶 魔 。"):format() end,
	type = "魔法",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "VORACIOUS_BLADE", 
	enName = "Voracious Blade",
	chName = "饕鬄之刃",
	desc = function(self, eff) return ("接 下 来 的 %d 次 近 战 攻 击 必 定 暴 击 。 效 果 期 间 增  加 %d%% 暴 击 系 数 。"):format(eff.hits, eff.power) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "RAGING_FLAMES",
	enName = "Raging flames",
	chName = "熊熊烈焰",
	desc = function(self, eff) return ("接 下 来 一 次 近 战 攻 击 必 定 触 发 焚 尽 强 击 ， 且 焚 尽 强 击 伤 害 增 加 %d%% 。"):format(eff.power * 100) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "CURSED_FLAMES",
	enName = "Devouring flames",
	chName = "吞噬之焰",
	desc = function(self, eff) return ("该 生 物 身 上 的 火 焰 正 向 来 源 生 物 提 供 能 量 ，  每 回 合 给 予 其 %d 生 命 与 %d 活 力。"):format(eff.heal, eff.vim) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "INFERNAL_FEAR",
	enName = "Overwhelming Fear",
	chName = "无尽恐惧",
	desc = function(self, eff) return ("目 标 对 打 败 你 失 去 信 心 ， 伤 害 减 少 %d%%， 速 度 减 慢 %d%% 。"):format(eff.power*eff.stacks, eff.slow_power*eff.stacks*100) end,
	type = "精神",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "HOPELESS",
	enName = "Abandoned hope",
	chName = "绝望",
	desc = function(self, eff) return ("目 标 精 神 破 碎 ， 不 能 行 动 。") end,
	type = "其他",
	subtype = "恐惧",
}

timeEffectCHN:newEffect{
	id = "SUFFERING_IMMUNE",
	enName = "Suffered",
	chName = "被折磨",
	desc = function(self, eff) return ("目 标 最 近 被 折 磨 过  ， 暂 时 不 能 继 续 折 磨。") end,
	type = "其他",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "PURIFIED_BY_FIRE",
	enName = "Cleansing flames",
	chName = "净化之焰",
	desc = function(self, eff) return ("目 标 被 火 焰 净 化 ， 每 回 合 损 失 %0.2f%% 最 大 生 命 值 的 生 命。"):format(eff.power*100) end,
	type = "其他",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "REBIRTH_BY_FIRE",
	enName = "Blazing Rebirth",
	chName = "烈焰重生",
	desc = function(self, eff) return ("目 标 正 在 燃 烧 ， 每 回 合 损 失 %d 生 命 值 ， 和 半 径 %d 内 的 正 在 燃 烧 的 敌 人 分 摊 。"):format(eff.power, eff.radius) end,
	type = "其他",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "FIERY_GRASP",
	enName = "Fiery Grasp",
	chName = "炙炎之牢",
	desc = function(self, eff)
		if eff.silence == 1 then
			return ("目 标 着 火 了 ， 每 回 合 受 到 %0.2f 点 火 焰 伤 害 并 被 沉 默 。"):format(eff.power, text) 
		else
			return ("目 标 着 火 了 ， 每 回 合 受 到 %0.2f 点 火 焰 伤 害。"):format(eff.power, text) 
		end
	end,
	type = "物理",
	subtype = "火焰/定身",
	status = "detrimental",
}
timeEffectCHN:newEffect{
	id = "FIRE_SHIELD",
	enName = "Fiery Aegis",
	chName = "火焰守护",
	desc = function(self, eff) return ("目 标 被 一 层 魔 法 护 盾 包 围 ， 吸 收 %d/%d 伤 害 。 护 盾 破 碎 时 在 半 径 %d 范 围 内 造 成 %d 伤 害 。"):format(self.fiery_aegis_damage_shield_absorb, eff.power, eff.radius, eff.power) end,
	type = "魔法",
	subtype = "奥术/护盾",
}
timeEffectCHN:newEffect{
	id = "SURGE_OF_POWER",
	enName = "Surge of Power",
	chName = "力量之潮",
	desc = function(self, eff) return ("目 标 直 到 -%d 生 命 才 会 死 去。 "):format(eff.power) end,
	type = "物理",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "RECKLESS_PEN",
	enName = "Recklessness",
	chName = "舍身",
	desc = function(self, eff) return ("目 标 获 得 %d%% 全 体 抗 性 穿 透 。"):format(eff.power) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED",
	enName = "Demon Seed",
	chName = "恶魔之种",
	desc = function(self, eff) return ("目 标 被 恶 魔 之 种 感 染 ， 死 亡 时 施 法 者 将 得 到 成 熟 的 种 子。"):format() end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "OSMOSIS_REGEN",
	enName = "Osmosis Regeneration",
	chName = "渗透吸收",
	desc = function(self, eff) return ("效 果 期 间 ， 你 总 计 回 复 %0.2f 生 命。"):format(eff.power) end,
	type = "魔法",
	subtype = "治疗",
}

timeEffectCHN:newEffect{
	id = "ACIDIC_BATH",
	enName = "Acidic Bath",
	chName = "酸浴",
	desc = function(self, eff) return ("获 得%d%% 酸 性 抗 性 与 %d%%酸 性 伤 害 吸 收。"):format(eff.res, eff.aff) end,
	type = "魔法",
	subtype = "抗性/治疗",
}

timeEffectCHN:newEffect{
	id = "BURNING_PLAGUE",
	enName = "Plaguefire",
	chName = "瘟疫之焰",
	desc = function(self, eff) return ("目 标 着 火 ， 每 回 合 受 到 %0.2f 火 焰 伤 害 。 死 亡  时 火 焰 将 爆 炸。"):format(eff.power) end,
	type = "物理",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_CORRUPT_LIGHT",
	enName = "Corrupted Light",
	chName = "腐化之光",
	desc = function(self, eff) return ("目 标 能 量 溢 出 ，  增 加 %d%% 全 体 伤 害 。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_ARMOURED_LEVIATHAN",
	enName = "Armoured Leviathan",
	chName = "重装上阵",
	desc = function(self, eff) return ("增 加 %d 力 量 与 魔 法。"):format(eff.power) end,
	type = "魔法",
	subtype = "护甲",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_DOOMED_NATURE",
	enName = "Doomed Nature",
	chName = "自然末日",
	desc = function(self, eff) return ("目 标 被 枯 萎 力 量 感 染，使 用 自 然 技 能 时 有 %d%% 几 率 失 败 并 释 放 半 径 1 的 火 球  ， 伤 害 %0.2f。"):format(eff.chance, eff.dam) end,
	type = "魔法",
	subtype = "枯萎/诅咒",
}

timeEffectCHN:newEffect{
	id = "DEMONIC_CUT",
	enName = "Demonic Cut",
	chName = "恶魔伤口",
	desc = function(self, eff) return ("巨 大 的 恶 魔 伤 口 每 回 合 造 成 %0.2f 暗 影 伤 害 。 当 伤 害 来 源 击 中 目 标 时 将 会 恢 复 %d 生 命 。"):format(eff.dam, eff.heal) end,
	type = "魔法",
	subtype = "伤口/切割/流血/黑暗",
}

timeEffectCHN:newEffect{
	id = "LINK_OF_PAIN",
	enName = "Link of Pain",
	chName = "苦痛链接",
	desc = function(self, eff) return ("当 目 标 受 伤 害 时  ， 牺 牲 生 物 也 会 承 受 %d%% 的 伤 害。"):format(eff.power) end,
	type = "魔法",
	subtype = "仪式/黑暗",
}

timeEffectCHN:newEffect{
	id = "ONLY_ASHES_LEFT",
	enName = "Only Ashes Left",
	chName = "唯余灰烬",
	desc = function(self, eff) return ("目 标 被 黑 暗 灼 烧 ， 每 回 合 受  到 %0.2f 伤 害 直 到 死 亡 或 离 开。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "SHATTERED_MIND",
	enName = "Shattered Mind",
	chName = "精神破碎",
	desc = function(self, eff) return ("目 标 使 用 技 能 时 有 %d%% 几 率 失 败 。 目 标 全 体 豁 免 下 降 %d 点。"):format(eff.fail, eff.save) end,
	type = "魔法",
}

timeEffectCHN:newEffect{
	id = "DARK_REIGN",
	enName = "Dark Reign",
	chName = "黑暗支配",
	long_desc = function(self, eff) local p = 1 for i = 1, eff.stacks do p = p * 0.92 end p = 100 * (1 - p)
		return ("全 体 伤 害 吸 收 增 加 %d%%.\n直 到 %d 生 命 不 会 死 亡。"):format(p, -((eff.die_at or 0) * eff.stacks)) end,

	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "BLOOD_PACT",
	enName = "Blood Pact",
	chName = "鲜血契约",
	desc = function(self, eff) return ("你 的 所 有 伤 害 转 化 为 暗 影 伤 害。"):format() end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "BLACKICE",
	enName = "Blackice",
	chName = "黑冰",
	desc = function(self, eff) return ("剩余次数：%d"):format(eff.stacks) end,
	type = "魔法",
	subtype = "黑暗/寒冷",
}

timeEffectCHN:newEffect{
	id = "BLACKICE_DET",
	enName = "Blackice",
	chName = "黑冰",
	desc = function(self, eff) return ("火 焰 抗 性 下 降%d%% 。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗/寒冷",
	status = "detrimental",
}


timeEffectCHN:newEffect{
	id = "FIRE_HAVEN",
	enName = "Fire Haven",
	chName = "火焰庇护",
	desc = "目 标 被 火 焰 围 绕 ， 获 得 40%% 火 焰 伤 害 吸 收 ， 但 减 少 15%% 枯 萎 抗 性。 ",
	type = "其他",
	subtype = "地面",

}

timeEffectCHN:newEffect{
	id = "BLEAK_OUTCOME",
	enName = "Bleak Outcome",
	chName = "悲惨结局",
	desc = function(self, eff) return ("死 亡 后 提 供 %d 倍 活 力。"):format(eff.stacks) end,
	type = "魔法",
	subtype = "活力/枯萎/诅咒",
}

timeEffectCHN:newEffect{
	id = "STRIPPED_LIFE",
	enName = "Stripped Life",
	chName = "生命剥夺",
	desc = function(self, eff) return ("法 术 强 度 增 加 %d。"):format(eff.power) end,
	type = "魔法",
	subtype = "活力/枯萎",
}

timeEffectCHN:newEffect{
	id = "OMINOUS_SHADOW_CHARGES",
	enName = "Ominous Shadow Charges",
	chName = "不祥黑影-累积",
	desc = function(self, eff) return ("剩 余 数 目：%d 。"):format(eff.stacks) end,
	type = "魔法",
	subtype = "黑暗",
}


timeEffectCHN:newEffect{
	id = "OMINOUS_SHADOW",
	enName = "Ominous Shadow",
	chName = "不详黑影",
	desc = function(self, eff) return ("提 供 隐 形 (强度 %d)"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "CORRUPTION_OF_THE_DOOMED",
	enName = "Corruption of the Doomed",
	chName = "腐化形态",
	desc = function(self, eff) return ("目标变形为多瑟顿。"):format() end,
	type = "魔法",
	subtype = "枯萎/奥术",
}

timeEffectCHN:newEffect{
	id = "STONE_VINE",
	enName = "Stone Vine",
	chName = "岩石藤蔓",
	desc = function(self, eff) return ("岩 石 藤 蔓 将 目 标 钉 在 地 上 ， 每 回 合 造 成 %0.1f 点 物 理 %s 伤 害。"):format(eff.dam, eff.arcanedam and (" 和 %0.1f 点 奥 术 "):format(eff.arcanedam) or "") end,
	type = "物理",
	subtype = "大地/定身",
}

timeEffectCHN:newEffect{
	id = "DWARVEN_RESILIENCE",
	enName = "Dwarven Resilience",
	chName = "矮人防御",
	desc = function(self, eff)
		if eff.mid_ac then
			return (" 目 标 皮 肤 石 化， 提 升 %d 护 甲 值， 提 升 %d 物 理 豁 免 和 %d 法 术 豁 免。同 时 所 有 非 物 理 伤 害 减 免 %d 点。"):format(eff.armor, eff.physical, eff.spell, eff.mid_ac)
		else
			return (" 目 标 皮 肤 石 化， 提 升 %d 护 甲 值， 提 升 %d 物 理 豁 免 和 %d 法 术 豁 免。"):format(eff.armor, eff.physical, eff.spell)
		end
	end,
	type = "物理",
	subtype = "大地",
}
timeEffectCHN:newEffect{
	id = "ELDRITCH_STONE",
	enName = "Eldritch Stone Shield",
	chName = "岩石护盾",
	desc = function(self, eff)
		return ("目 标 被 一 层 岩 石 护 盾 围 绕 ， 吸 收 %d/%d 伤 害 。 当 护 盾 消 失 时 ， 破 碎 的 岩 石会 产 生 一 次 爆 炸 ， 造 成 至 多 %d（当 前 %d）点 伤 害 ， 爆 炸 半 径 为 %d。"):
		format(eff.power, eff.max, eff.maxdam, math.min(eff.maxdam, self:getEquilibrium() - self:getMinEquilibrium()), eff.radius)
	end,
	type = "魔法",
	subtype = "大地/护盾",
}
timeEffectCHN:newEffect{
	id = "STONE_LINK_SOURCE",
	enName = "Stone Link",
	chName = "岩石链接",
	desc = function(self, eff) return ("目 标 保 护 身 边 半 径 %d 内 所 有 友 方 生 物，将 伤 害 转 移 至 自 身。"):format(eff.rad) end,
	type = "魔法",
	subtype = "大地/护盾",
}
timeEffectCHN:newEffect{
	id = "DEEPROCK_FORM",
	enName = "Deeprock Form",
	chName = "深岩形态",
	desc = function(self, eff)
		local xs = ""
		if eff.arcaneDam and eff.arcanePen then
			xs = xs..(", %d%% 奥 术 伤 害 与 %d%% 奥 术 抗 性 穿 透 "):format(eff.arcaneDam, eff.arcanePen)
		end
		if eff.natureDam and eff.naturePen then
			xs = (", %d%% 自 然 伤 害 与 %d%% 自 然 抗 性 穿 透"):format(eff.natureDam, eff.naturePen)..xs
		end
		if eff.immune then
			xs = (", %d%% 流 血 、 毒 素 、 疾 病 和 震 慑 免 疫"):format(eff.immune*100)..xs
		end
		return ("目 标 变 成 巨 型 深 岩 元 素， 增 加 两 点 体 型%s，%d%% 物 理 伤 害 与 %d%% 物 理 抗 性 穿 透。%s"):format(xs, eff.dam, eff.pen, eff.useResist and " 同 时，将 使 用 物 理 抗 性 代 替 所 有 伤 害 抗 性。" or "")
	end,
	type = "魔法",
	subtype = "大地/元素",
}
--Orc DLC
timeEffectCHN:newEffect{
	id = "STRAFING",
	enName = "Strafing",
	chName = "扫射中",
	desc = function(self, eff) return ("目 标 在 移 动 中 射 击 ， 效 果 结 束 后 恢 复 %s 弹 药 。"):format(self.player and self:callTalent(self.T_STRAFE, "getReload", eff.turns).." " or "") end,
	type = "物理",
	subtype ="策略",
}

timeEffectCHN:newEffect{
	id = "STARTLING_SHOT",
	enName = "Startled",
	chName = "惊讶",
	desc = function(self, eff) return ("目 标 因 一 发 未 射 中 它 的 子 弹 而 惊 讶 ， 下 次 被 攻 击 将 受 到 %d%% 伤 害 。"):format(eff.power*100) end,
	type = "物理",
	subtype ="策略",
}

timeEffectCHN:newEffect{
	id = "IRON_GRIP",
	enName = "Iron Grip",
	chName = "铁腕",
	desc = function(self, eff) return ("目 标 被 碾 压，处 于 定 身 状 态 ，护 甲 和 闪 避 下 降 %d。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_OVERHEAT",
	enName = "Bullet Mastery: Overheated",
	chName = "子弹掌握：过热",
	desc = function(self, eff) return ("子 弹 处 于 过 热 状 态：在 5 回 合 内 造 成 %d 火 焰 伤 害"):format(self:damDesc(DamageType.FIRE, eff.power)) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_SUPERCHARGE",
	enName = "Bullet Mastery: Supercharged",
	chName = "子弹掌握：超速",
	desc = function(self, eff) return ("子 弹 处 于 超 速 状 态：能 够 穿 透 多 个 目 标 , 同 时 提 高 护 甲 穿 透 %d 点。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_PERCUSIVE",
	enName = "Bullet Mastery: Percussive",
	chName = "子弹掌握：冲击",
	desc = function(self, eff) return ("子 弹 处 于 冲 击 状 态：%d%% 概 率 击 退， %d%% 概 率 震 慑 。"):format(eff.power, eff.stunpower) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_COMBUSTIVE",
	enName = "Bullet Mastery: Combustive",
	chName = "子弹掌握： 爆炸",
	desc = function(self, eff) return ("子 弹 处 于 爆 炸 状 态: 对 2 码 范 围 内 的 敌 人 造 成 %d 火 焰 伤 害"):format(self:damDesc(DamageType.FIRE, eff.power)) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "UNCANNY_RELOAD",
	enName = "Uncanny Reload",
	chName = "神秘装填术",
	desc = function(self, eff) return ("蒸 汽 枪 不 消 耗 子 弹 。"):format() end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "CLOAK",
	enName = "Cloak",
	chName = "潜行披风",
	desc = function(self, eff) return ("目 标 被 暗 影 披 风 包 裹 ， 获 得 潜 行 能 力 。 ") end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "PAIN_SUPPRESSOR_SALVE",
	enName = "Pain Suppressor Salve",
	chName = "痛苦压制药剂",
	desc = function(self, eff) return ("获 得 -%d 生 命 下 限 和 %d%% 全 体 伤 害 抗 性 。"):format(eff.die_at, eff.resists) end,
	type = "物理",
	subtype ="自然",
}

timeEffectCHN:newEffect{
	id = "FROST_SALVE",
	enName = "Frost Salve",
	chName = "寒霜药剂",
	desc = function(self, eff) return ("获 得 %d%% 寒 冷 、 暗 影 和 自 然 伤 害 吸 收 。"):format(eff.power) end,
	type = "物理",
	subtype ="冰霜",
}

timeEffectCHN:newEffect{
	id = "FIERY_SALVE",
	enName = "Fiery Salve",
	chName = "烈火药剂",
	desc = function(self, eff) return ("获 得 %d%% 火 焰 、 光 明 和 闪 电 伤 害 吸 收 。"):format(eff.power) end,
	type = "物理",
	subtype ="火焰",
}

timeEffectCHN:newEffect{
	id = "WATER_SALVE",
	enName = "Water Salve",
	chName = "静水药剂",
	desc = function(self, eff) return ("获 得 %d%% 枯 萎 、 精 神 和 酸 性 伤 害 吸 收。"):format(eff.power) end,
	type = "物理",
	subtype ="水",
}

timeEffectCHN:newEffect{
	id = "UNSTOPPABLE_FORCE_SALVE",
	enName = "Unstoppable Force Salve",
	chName = "势不可挡药剂",
	desc = function(self, eff) return ("增 加 全 豁 免 %d ， 增 加 治 疗 系 数 %d%% ."):format(eff.power, eff.power / 2) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "SLOW_TALENT",
	enName = "Slow Talents",
	chName = "技能减速",
	desc = function(self, eff) return ("攻 击 ， 施 法 和 精 神 速 度 下 降 %d%% 。"):format(eff.power * 100) end,
	type = "物理",
	subtype ="减速",
}

timeEffectCHN:newEffect{
	id = "SUPERCHARGE_TINKERS",
	enName = "Supercharge Tinkers",
	chName = "插件超频",
	desc = function(self, eff) return ("获 得 %d 蒸 汽 强 度 和 %d 蒸 汽 技 能 暴 击 率 。"):format(eff.power, eff.crit) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "OVERCHARGE_SAWS",
	enName = "Overcharge Saws",
	chName = "链锯过载",
	desc = function(self, eff) return ("增 加 %d%% 链 锯 相 关 技 能 有 效 等 级"):format(eff.power) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "ALGID_RAGE",
	enName = "Algid Rage",
	chName = "霜寒暴怒",
	desc = function(self, eff) return ("你 有 %d%% 几 率 把 目 标 冻 在 冰 块 中 3 回 合"):format(eff.power) end,
	type = "物理",
	subtype ="ice",
}

timeEffectCHN:newEffect{
	id = "RITCH_LARVA_EGGS",
	enName = "Larvae Infestation",
	chName = "里奇幼虫寄生",
	desc = function(self, eff)
		local source = eff.src or self
		return ("目 标 被 %d 个 里 奇 幼 虫 寄 生%s. 在 发 育 期 结 束 后， 幼 虫 会 从 寄 主 体 内 钻 出， 每 个 幼 虫 造 成 %0.2f 物 理 和 %0.2f 火 焰 伤 害。"):format(eff.nb,
		eff.turns < eff.gestation and ("， 每 回 合 受 到 %0.2f 物 理 伤 害( 随 回 合 递 增)"):format(
		source:damDesc("PHYSICAL", self.tempeffect_def.EFF_RITCH_LARVA_EGGS.gestation_damage(self, eff, eff.turns + 1))) or "",
		eff.gestation, source:damDesc("PHYSICAL", eff.dam/2), source:damDesc("FIRE", eff.dam/2))
	end,
	type = "物理",
	subtype ="疾病",
}

timeEffectCHN:newEffect{
	id = "TECH_OVERLOAD",
	enName = "Tech Overload",
	chName = "系统过载",
	desc = function(self, eff) return ("蒸 汽 容 量 翻 倍 ， 蒸 汽 回 复 速 度 下 降 。 "):format() end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "CONTINUOUS_BUTCHERY",
	enName = "Continuous Butchery",
	chName = "无尽屠戮",
	desc = function(self, eff) return ("链 锯 伤 害 增 加 %d%%。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "EXPLOSIVE_WOUND",
	enName = "Explosive Saw",
	chName = "爆炸飞锯",
	desc = function(self, eff) return ("你 被 飞 锯 击 伤 ， 每 回 合 受 到 %0.2f 物 理 伤 害 %s。持 续 时 间 结 束 后， 链 锯 爆 炸 ，造 成 %0.2f 的 火 焰 伤 害 并 飞 回， 并 将 你 拉 扯 %d 格 。"):format(eff.power, eff.silence and " 并 被 沉 默" or "", eff.src:damDesc(DamageType.FIRE, eff.power_final), eff.range) end,
	type = "物理",
	subtype ="伤口/切割/流血",
}

timeEffectCHN:newEffect{
	id = "SUBCUTANEOUS_METALLISATION",
	enName = "Subcutaneous Metallisation",
	chName = "金属内皮",
	desc = function(self, eff) return ("全 伤 害 减 免 %d."):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/抗性",
}

timeEffectCHN:newEffect{
	id = "PAIN_ENHANCEMENT_SYSTEM",
	enName = "Pain Enhancement System",
	chName = "痛苦强化系统",
	desc = function(self, eff) return ("全 属 性 增 加 %d。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/power",
}

timeEffectCHN:newEffect{
	id = "NET_PROJECTOR",
	enName = "Net Projector",
	chName = "束网弹射器",
	desc = function(self, eff) return ("你 被 电 网 定 身 ， 全 抗 性 下 降 %d%%。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/定身",
}

timeEffectCHN:newEffect{
	id = "FURNACE_MOLTEN_POINT",
	enName = "Molten Point",
	chName = "融化点数",
	desc = function(self, eff) return ("%d 点。"):format(eff.stacks) end,
	type = "其他",
	subtype ="火焰",
}

timeEffectCHN:newEffect{
	id = "PRESSURE_SUIT",
	enName = "Pressure-enhanced Slashproof Combat Suit",
	chName = "抗压战斗服",
	desc = function(self, eff) return ("当 你 被 击 中 时 ， 这 套 服 装 下 隐 藏 的 引 擎 将 使 你 迅 速 切 换 位 置 ， 完 全 避 免 被 攻 击 。") end,
	type = "物理",
	subtype ="蒸汽",
}

timeEffectCHN:newEffect{
	id = "MOLTEN_IRON_BLOOD",
	enName = "Molten Iron Blood",
	chName = "液态钢铁",
	desc = function(self, eff) return ("全 体 伤 害 抗 性 增 加 %d%% ， 新 负 面 状 态 持 续 时 间 下 降 %d%%， %0.2f 火 焰 反 击 伤 害 。 "):format(eff.resists, eff.reduction, eff.dam) end,
	type = "物理",
	subtype ="蒸汽科技/超能/火焰/抗性",
}

timeEffectCHN:newEffect{
	id = "SEARED",
	enName = "Seared",
	chName = "烧焦",
	desc = function(self, eff) return ("火 焰 抗 性 下 降 %d%% ，精 神 豁 免 下 降 %d."):format(eff.power, eff.power) end,
	type = "物理",
	subtype ="灵能/火焰",
}

timeEffectCHN:newEffect{
	id = "AWESOME_TOSS",
	enName = "Awesome Toss",
	chName = "致命翻转",
	desc = function(self, eff) return ("全 抗 性 增 加 %d%%， 每 回 合 随 机 攻 击 两 名 敌 人 。"):format(eff.resist) end,
	type = "物理",
	subtype ="蒸汽科技/致命/抗性",
}

timeEffectCHN:newEffect{
	id = "MARKED_LONGARM",
	enName = "Marked for Death",
	chName = "死亡印记",
	desc = function(self, eff) return ("远 程 闪 避 减 少 %d, 受 到 额 外 %d%% 伤 害 。"):format(eff.def, eff.dam) end,
	type = "物理",
	subtype ="蒸汽",
}

timeEffectCHN:newEffect{
	id = "ITCHING_POWDER",
	enName = "Itching Powder",
	chName = "痒痒粉",
	desc = function(self, eff) return ("太 痒 了 ， 行 动 会 失 败 。"):format() end,
	type = "物理",
	subtype ="粉末",
}

timeEffectCHN:newEffect{
	id = "SMOKE_COVER",
	enName = "Smoke Cover",
	chName = "烟雾覆盖",
	desc = function(self, eff) return ("%d%% 几 率 吸 收 伤 害 ， %d 潜 行 强 度 。"):format(eff.power, eff.stealth) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "MAGNETISED",
	enName = "Magnetised",
	chName = "磁化",
	desc = function(self, eff) return ("你 被 磁 化 ，闪 避 下 降 %d， 疲 劳 增 加 %d。"):format(eff.power, eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "BLOODSTAR",
	enName = "Bloodstar",
	chName = "血液灵晶",
	desc = function(self, eff) return ("持 续 吸 血 ，每 回 合 受 到 %0.2f 物 理 伤 害 并 治 疗 攻 击 者 一 半 伤 害 值 。"):format(eff.dam) end,
	type = "物理",
	subtype ="血液/吸取/治疗",
}

timeEffectCHN:newEffect{
	id = "HEART_CUT",
	enName = "Heartrended",
	chName = "心脏切割",
	desc = function(self, eff) return ("恶 毒 的 伤 口 在 流 血 ， 每 回 合 造 成 %0.2f 物 理 伤 害 。 "):format(eff.power) end,
	type = "物理",
	subtype ="伤口/切割/流血",
}

timeEffectCHN:newEffect{
	id = "METAL_POISONING",
	enName = "Metal Poisoning",
	chName = "金属中毒",
	desc = function(self, eff) return ("目 标 重 金 属 中 毒 ， 每 回 合 受 到 %0.2f 枯 萎 伤 害 ， 整 体 速 度 下 降 %d%% 。"):format(eff.power, eff.speed) end,
	type = "物理",
	subtype ="毒素/枯萎",
}

timeEffectCHN:newEffect{
	id = "MOSS_TREAD",
	enName = "Moss Tread",
	chName = "苔藓之踏",
	desc = function(self, eff) return ("脚 下 长 出 苔 藓 。"):format() end,
	type = "物理",
	subtype ="苔藓",
}

timeEffectCHN:newEffect{
	id = "STIMPAK",
	enName = "Stimulus",
	chName = "兴奋剂",
	desc = function(self, eff) return ("抵 抗 疼 痛 ， 受 到 的 伤 害 减 少 %0.2f。效 果 结 束 后 受 到 %d 点 不 可 阻 挡 的 伤 害 。"):format(eff.power, (eff.power/3)*0.05 * self.max_life) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "TO_THE_ARMS",
	enName = "To The Arms",
	chName = "切臂",
	desc = function(self, eff) return ("你 造 成 的 伤 害 减 少 %d%% 。"):format(eff.power) end,
	type = "物理",
	subtype ="残废",
}

timeEffectCHN:newEffect{
	id = "CELESTIAL_ACCELERATION",
	enName = "Celestial Acceleration",
	chName = "天体加速",
	desc = function(self, eff)
		local strings = {}
		if eff.move then
			strings[#strings + 1] = ("移 动 速 度 增 加 %d%%。"):format(eff.move * 100)
		end 
		if eff.cast then
			strings[#strings + 1] = ("施 法 速 度 增 加 %d%%。"):format(eff.cast * 100)
		end 
		if eff.attack then
			strings[#strings + 1] = ("攻 击 速 度 增 加 %d%%。"):format(eff.attack * 100)
		end 
		if eff.mind then
			strings[#strings + 1] = ("精 神 速 度 增 加 %d%%。"):format(eff.mind * 100)
		end 
		if eff.power then
			strings[#strings + 1] = ("整 体 速 度 增 加 %d%%。"):format(eff.power * 100)
		end
		
		return table.concat(strings, " ")
	end,
	type = "其他",
	subtype ="加速",
}

timeEffectCHN:newEffect{
	id = "OUTSIDE_THE_STARSCAPE",
	enName = "Outside the Starscape",
	chName = "星界之外",
	desc = function(self, eff) return ("该 单 位 处 于 星 界 外 ， 不 能 被 星 界 内 单 位 伤 害 。") end,
	type = "其他",
	subtype = "空间",
}

timeEffectCHN:newEffect{
	id = "MINDWALL_CONFUSED",
	enName = "Mindblasted",
	chName = "精神震爆",
	desc = function(self, eff) return ("目 标 混 乱 ， %d%% 几 率 随 机 行 动 ， 不 能 完 成 复 杂 行 为 。"):format(eff.power) end,
	type = "其他",
	subtype ="混乱",
}

timeEffectCHN:newEffect{
	id = "AERYN_SUN_SHIELD",
	enName = "Shield of the Sun",
	chName = "日光之盾",
	desc = function(self, eff) return ("太 阳 的 力 量 保 护 着 目 标。") end,
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "AERYN_SUN_REZ",
	enName = "A Light in the Darkness",
	chName = "黑暗之光",
	desc = function(self, eff) return ("太 阳 的 力 量 充 盈 着 目 标 。") end,
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "X_RAY",
	enName = "X-Ray Vision",
	chName = "X光视觉",
	desc = function(self, eff) return ("能 看 见 *任 何 *事 物 。") end,
	type = "其他",
	subtype = "其他",
}

timeEffectCHN:newEffect{
	id = "NEKTOSH_WAND",
	enName = "Aiming!",
	chName = "瞄准!",
	desc = function(self, eff) return ("正 瞄 准 发 射 强 力 激 光 。 离 开 ！") end,
	type = "其他",
	subtype = "其他",
}

timeEffectCHN:newEffect{
	id = "GESTALT_STEAM",
	enName = "Gestalt",
	chName = "格式塔",
	desc = function(self, eff) return ("获 得 %d 蒸 汽 强 度."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "FORCED_GESTALT",
	enName = "Forced Gestalt",
	chName = "强力格式塔",
	desc = function(self, eff) return ("获 得 %d 全 体 强 度."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "FORCED_GESTALT_FOE",
	enName = "Forced Gestalt",
	chName = "强力格式塔",
	desc = function(self, eff) return ("全 体 强 度 下 降 %d."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "MIND_DRONE",
	enName = "Mind Drone",
	chName = "精神雄蜂",
	desc = function(self, eff) return ("技 能 失 败 率 %d%%, 恐 惧 和 睡 眠 免 疫 下 降  %d%%."):format(eff.fail, eff.reduction) end,
	type = "精神",
	subtype = "超能/蒸汽/干扰",
}

timeEffectCHN:newEffect{
	id = "NEGATIVE_BIOFEEDBACK",
	enName = "Negative Biofeedback",
	chName = "负反馈",
	desc = function(self, eff) return ("物 理 豁 免 下 降 %d,护 甲 和 闪 避 下 降 %d."):format(eff.save * eff.stacks, eff.power * eff.stacks) end,
	type = "精神",
	subtype = "超能/生物/物理/豁免",
}

timeEffectCHN:newEffect{
	id = "LUCID_SHOT",
	enName = "Unclear Thoughts",
	chName = "不清醒",
	desc = function(self, eff) return ("不 能 区 分 敌 人 和 盟 友。"):format() end,
	type = "精神",
	subtype = "混乱",
}

timeEffectCHN:newEffect{
	id = "PSY_WORM",
	enName = "Psy Worm",
	chName = "超能蠕虫",
	desc = function(self, eff) return ("被 超 能 蠕 虫 感 染 , 每 回 合 受 到 %0.2f 精 神 伤 害 。 若 处 于 震 慑 或 恐 惧 状 态 ， 伤 害 加 倍 。 能 传 播 至 周 围 生 物 。"):format(eff.power) end,
	type = "精神",
	subtype = "超能",
}

timeEffectCHN:newEffect{
	id = "NO_HOPE",
	enName = "No Hope",
	chName = "绝望",
	desc = function(self, eff) return ("伤 害 减 少 40%%."):format() end,
	type = "精神",
	subtype = "超能/恐惧",
}

timeEffectCHN:newEffect{
	id = "ALL_SIGHT",
	enName = "All Seeing",
	chName = "看穿一切",
	desc = function(self, eff) return ("能 看 见 周 围 的 一 切 存 在 。"):format() end,
	type = "精神",
	subtype = "超能",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_AMAKTHEL",
	enName = "Curse of Amakthel",
	chName = "阿马克泰尔的诅咒",
	desc = function(self, eff) return ("所 有 新 负 面 状 态 持 续 时 间 加 倍 。"):format() end,
	type = "精神",
	subtype ="超能/诅咒",
}

timeEffectCHN:newEffect{
	id = "TINKER_VIRAL",
	enName = "Viral Injection",
	chName = "病毒注射",
	desc = function(self, eff) return ("目 标 被 疾 病 感 染， %d 属 性 下 降 %d ， 每 回 合 受 到 %0.2f 枯 萎 伤 害 。"):format(eff.num_stats, eff.power, eff.dam) end,
	type = "魔法",
	subtype = "疾病/枯萎",
}

timeEffectCHN:newEffect{
	id = "STEAM_SHIELD",
	enName = "Steam Shield",
	chName = "蒸汽护盾",
	desc = function(self, eff) return ("目 标 被 魔 法 蒸 气 护 盾 包 围 ，吸 收 %d/%d 伤 害 ， 获 得 %d 火 焰 反 击 伤 害 。"):format(self.damage_shield_absorb, eff.power, self:damDesc(DamageType.FIRE, eff.retaliate)) end,
	type = "魔法",
	subtype ="奥术/护盾",
}

timeEffectCHN:newEffect{
	id = "TWILIT_ECHOES",
	enName = "Twilit Echoes",
	chName = "微光回响",
	desc = function(self, eff) return ([[目 标 感 受 到 光 暗 伤 害 的 回 响 。 每 点 光 明 伤 害 减 速 %0.2f%% ,最 高 %d%% （ %d 伤害）。暗 影 伤 害 在 该 地 格 %d 回 合 内 每 回 合 造 成 %d%% 伤 害，每 次 受 到 伤 害 时 将 刷 新 效 果 。]])
		:format(eff.slow_per * 100, eff.slow_max * 100, eff.slow_max / eff.slow_per, eff.echo_dur, eff.dam_factor * 100) end,
	type = "魔法",
	subtype ="黑暗/光明",
}

timeEffectCHN:newEffect{
	id = "ECHOED_LIGHT",
	enName = "Echoed Light",
	chName = "光明回响",
	desc = function(self, eff) return ([[目 标 减 速 %d%%。（上限 %d%%）]])
		:format(eff.power * 100, eff.max * 100) end,
	type = "魔法",
	subtype ="减速",
}

timeEffectCHN:newEffect{
	id = "FLIP_SWAP",
	enName = "Mirror Worlded",
	chName = "镜像世界",
	desc = function(self, eff) return ("该 单 位 即 将 切 换 空 间 。") end,
	type = "魔法",
	subtype ="时空",
}

timeEffectCHN:newEffect{
	id = "STARSCAPE",
	enName = "Starscape",
	chName = "星界",
	desc = function(self, eff) return ("召 唤 星 界 ， 减 速 所 有 生 物 67%%。") end,
	type = "魔法",
	subtype = "天体",
}

timeEffectCHN:newEffect{
	id = "VAMPIRIC_SURGE",
	enName = "Vampiric Surge",
	chName = "吸血",
	desc = function(self, eff) return ("将 %d%% 伤 害 值 转 化 为 治 疗。"):format(eff.power) end,
	type = "魔法",
	subtype ="堕落",
}

timeEffectCHN:newEffect{
	id = "TEMPORAL_RIPPLES",
	enName = "Temporal Ripples",
	chName = "时空涟漪",
	desc = function(self, eff) return ("攻 击 者 将 %d%% 伤 害 值 转 化 为 治 疗 。"):format(eff.power) end,
	type = "魔法",
	subtype ="时空/时间",
}

timeEffectCHN:newEffect{
	id = "DEATH_MOMENTUM",
	enName = "Death Momentum",
	chName = "死亡波动",
	desc = function(self, eff) return ("层 数 %d"):format(eff.stacks) end,
	type = "魔法",
	subtype ="亡灵",
}
timeEffectCHN:newEffect{
	id = "CAMPFIRE",
	enName = "Warm",
	chName = "温暖",
	desc = function(self, eff) return "目 标 被 营 火 温 暖 。 蒸 汽 回 复 +6 ， 震 慑 免 疫 +30% ， 体 力 回 复 + 4." end,
	type = "其他",
	subtype = "地面",
}

timeEffectCHN:newEffect{
	enName = "Sun Radiance",
	id = "SUNWELL",
	chNmae = "日光",
	desc = function(self, eff) return "目 标 处 于 阳 光 的 效 果 下 。 增 加 2 点 照 明 和 视 野 ， 3 0 % 目 盲 免 疫 ,   2 0 看 穿 潜 行 能 力   和 3 0 % 光 明 抗 性。"end,
	type = "其他",
	subtype = "地面",
}

timeEffectCHN:newEffect{
	enName = "Moon Radiance", id = "MOONWELL",
	chName = "月光",
	desc = function(self, eff) return"目 标 处 于 月 光 的 效 果 下 。 减 少 1 点 照 明 和 视 野 ， 获 得 3 0 % 震 慑 免 疫 ,   10 潜 行 能 力   和 3 0 % 暗 影 抗 性."end,
	type = "其他",
	subtype = "地面",

}



--possessor
timeEffectCHN:newEffect{
	id = "OMINOUS_FORM",
	enName = "Ominous Form",
	chName = "不详躯体",
	desc = function (self, eff) return "你 偷 取 了 当 前 形 态 ， 并 和 它 共 享 伤 害 与治 疗 。"  end,
	type = "其他",
	subtype = "超能/支配",
}
timeEffectCHN:newEffect{
	id = "POSSESSION",
	enName = "Assume Form",
	chName = "附身",
	desc = function (self, eff) return "你 使 用 你 最 近 消 灭 的 敌 人 的 身 体 。 在 这 个 状 态 下你 不 能 被 治 疗 。"  end,
	type = "其他",
	subtype = "超能/支配",
}
timeEffectCHN:newEffect{
	id = "POSSESSION_AFTERSHOCK",
	enName = "Possession Aftershock",
	chName = "支配余震",
	desc = function (self, eff) return ("目 标 正 承 受 支 配 身 体 被 摧 毁 的 余 震，伤 害 减 少 60%%, 移 动 速 度 减 少 50%%."):format()  end,
	type = "其他",
	subtype = "震慑/支配/超能",
}
timeEffectCHN:newEffect{
	id = "POSSESS",
	enName = "Possess",
	chName = "支配",
	desc = function (self, eff) return ("目 标 被 超 能 力 网 困 住，将 会 被 支 配， 每 回 合 受 到 %0.2f 精 神 伤 害。"):format(eff.power)  end,
	type = "其他",
	subtype = "超能/支配/精神",
}
timeEffectCHN:newEffect{
	id = "PSYCHIC_WIPE",
	enName = "Psychic Wipe",
	chName = "精神鞭打",
	desc = function (self, eff) return ("空 灵 手 指 摧 毁 目 标 大 脑， 每 回 合 造 成 %0.2f 精 神 伤 害 ， 并 减 少 %d 精 神 豁 免。"):format(eff.dam, eff.reduct)  end,
	type = "精神",
	subtype = "超能/精神",
}
timeEffectCHN:newEffect{
	id = "GHASTLY_WAIL",
	enName = "Ghastly Wail",
	chName = "恐怖嚎叫",
	desc = function (self, eff) return "目 标 被 眩 晕 ， 不 能 移 动，减 半 伤 害 、 闪 避 、 豁 免 、 命 中 、 强 度 ，受 伤 害 后 解 除。"  end,
	type = "精神",
	subtype = "震慑/超能",
}
timeEffectCHN:newEffect{
	id = "MIND_STEAL_REMOVE",
	enName = "Mind Steal",
	chName = "精神窃取",
	desc = function (self, eff) return ("偷取技能: %s"):format(self:getTalentFromId(eff.tid).name)  end,
	type = "其他",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "MIND_STEAL",
	enName = "Mind Steal",
	chName = "精神窃取",
	desc = function (self, eff) return ("偷取技能: %s"):format(self:getTalentFromId(eff.tid).name)  end,
	type = "其他",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "WRITHING_PSIONIC_MASS",
	enName = "Writhing Psionic Mass",
	chName = "扭曲装甲",
	desc = function (self, eff) return ("所 有 抗 性 增 加 %d%%, 被 暴 击 率 减 少 %d%%。"):format(eff.resists, eff.crit)  end,
	type = "物理",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "PSIONIC_DISRUPTION",
	enName = "Psionic Disruption",
	chName = "灵能瓦解",
	desc = function (self, eff) return ("%d 层。 每 层 效 果 每 回 合 造 成 %0.2f 精 神 伤 害。"):format(eff.stacks, eff.dam)  end,
	type = "精神",
	subtype = "超能/伤害",
}
timeEffectCHN:newEffect{
	id = "PSIONIC_BLOCK",
	enName = "Psionic Block",
	chName = "灵能格挡",
	desc = function (self, eff) return ("%d%% 几 率 无 视 伤 害 并 反 击 %0.2f 精 神 伤 害。"):format(eff.chance, eff.dam)  end,
	type = "精神",
	subtype = "超能/伤害",
}
timeEffectCHN:newEffect{
	id = "SADIST",
	enName = "Sadist",
	chName = "虐待狂",
	desc = function (self, eff) return ("精 神 强 度 ( 原 始 值 ) 增 加 %d。"):format(eff.stacks * eff.power)  end,
	type = "精神",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "RADIATE_AGONY",
	enName = "Radiate Agony",
	chName = "痛苦辐射",
	desc = function (self, eff) return ("所 有 伤 害 减 少 %d%%."):format(eff.power)  end,
	type = "精神",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "TORTURE_MIND",
	enName = "Tortured Mind",
	chName = "精神拷打",
	desc = function (self, eff) return ("%d 项技能不能使用。"):format(eff.nb)  end,
	type = "精神",
	subtype = "超能/锁定",
}

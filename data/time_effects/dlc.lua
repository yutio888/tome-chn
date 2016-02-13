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


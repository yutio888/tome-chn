local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_JELLY_PBAOE",
	name = "果冻散布",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 1 码 范 围 内 的 地 板 上 散 布 腐 蚀 性 的 粘 液 ， 持 续 %d 回 合， 对 上 面 所 有 的 敌 对 生 物 造 成 %d 自 然 伤 害。]]):format(duration, damDesc(self, DamageType.NATURE, damage))
	end,
}
registerTalentTranslation{
	id = "T_JELLY_MITOTIC_SPLIT",
	name = "有丝分裂",
	info = function(self, t)
		return ([[当 受 到 最 大 生 命 值 %d%% 的 攻 击 的 时 候， 有 %d%% 的 几 率 分 裂。]]):format(t.getDamage(self, t), t.getChance(self, t))
	end,
}
registerTalentTranslation{
	id = "T_WAR_HOUND",
	name = "契约：战争猎犬",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 战 争 猎 犬 来 攻 击 敌 人， 持 续 %d 回 合。 
		 战 争 猎 犬 是 非 常 好 的 基 础 近 战 单 位。 
		 它 拥 有 %d 点 力 量， %d 点 敏 捷 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 猎 犬 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.dex, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_JELLY",
	name = "契约：果冻怪",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 果 冻 怪 来 攻 击 敌 人， 持 续 %d 回 合。 
		 果 冻 怪 不 会 移 动。 
		 它 拥 有 %d 点 体 质 和 %d 点 力 量。 
		 每 当 果 冻 怪 受 到 伤 害 时， 你 降 低 等 同 于 它 受 到 伤 害 值 的 10 ％ 失 衡 值。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 果 冻 怪 的 体 质 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.str)
	end,
}

registerTalentTranslation{
	id = "T_MINOTAUR",
	name = "契约：米诺陶",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 米 诺 陶 来 攻 击 敌 人， 持 续 %d 回 合。 米 诺 陶 不 会 呆 很 长 时 间， 但 是 它 们 会 造 成 极 大 伤 害。 
		 它 拥 有 %d 点 力 量， %d 点 体 质 和 %d 点 敏 捷。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 米 诺 陶 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self,t), incStats.str, incStats.con, incStats.dex)
	end,
}

registerTalentTranslation{
	id = "T_STONE_GOLEM",
	name = "契约：岩石傀儡",
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召 唤 一只 岩 石 傀 儡 来 攻 击 敌 人， 持 续 %d 回 合。 岩 石 傀 儡 是 可 怕 的 敌 人 并 且 不 可 阻 挡。 
		 它 有 %d 点 力 量， %d 点 体 质 和 %d 点 敏 捷。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 傀 儡 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con, incStats.dex)
	end,
}


return _M

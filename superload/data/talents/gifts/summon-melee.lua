local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WAR_HOUND",
	name = "契约：战争猎犬",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 战 争 猎 犬 来 攻 击 敌 人， 持 续 %d 回 合。 
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
		return ([[召 唤 1 只 果 冻 怪 来 攻 击 敌 人， 持 续 %d 回 合。 
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
		return ([[召 唤 1 只 米 诺 陶 来 攻 击 敌 人， 持 续 %d 回 合。 米 诺 陶 不 会 呆 很 长 时 间， 但 是 它 们 会 造 成 极 大 伤 害。 
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
		return ([[召 唤 1 只 岩 石 傀 儡 来 攻 击 敌 人， 持 续 %d 回 合。 岩 石 傀 儡 是 可 怕 的 敌 人 并 且 不 可 阻 挡。 
		 它 有 %d 点 力 量， %d 点 体 质 和 %d 点 敏 捷。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 傀 儡 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con, incStats.dex)
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TAUNT",
	name = "嘲讽",
	info = function(self, t)
		return ([[强 制 %d 码 范 围 内 的 所 有 敌 对 目 标 攻 击 你。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_SHELL_SHIELD",
	name = "甲壳护盾",
	info = function(self, t)
		return ([[隐 藏 在 你 的 甲 壳 下， 增 加 %d%% 全 体 伤 害 抗 性 ， 持 续 %d 回 合。]]):format(t.resistPower(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPIDER_WEB",
	name = "蜘蛛之网",
	info = function(self, t)
		return ([[朝 你 的 目 标 投 掷 一 个 网， 若 目 标 被 击 中 则 被 困 在 原 地 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TURTLE",
	name = "契约：乌龟",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 乌 龟 来 吸 引 敌 人 攻 击， 持 续 %d 回 合。 
		 乌 龟 具 有 很 强 的 生 命 力， 并 不 能 造 成 很 多 伤 害。 
		 然 而， 它 们 会 周 期 性 的 嘲 讽 敌 人 并 用 龟 壳 保 护 自 己。
		 它 拥 有 %d 点 体 质， %d 点 敏 捷 和 18 点 意 志。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 乌 龟 的 体 质 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.dex)
	end,
}

registerTalentTranslation{
	id = "T_SPIDER",
	name = "契约：蜘蛛",
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召 唤 1 只 蜘 蛛 来 扰 乱 敌 人， 持 续 %d 回 合。 
		 蜘 蛛 可 以 使 敌 人 中 毒 并 向 目 标 撒 网， 将 目 标 固 定 在 地 上。 
		 它 拥 有 %d 点 敏 捷， %d 点 力 量， 18 点 意 志 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 蜘 蛛 的 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.dex, incStats.str, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_FRANTIC_SUMMONING",
	name = "疯狂召唤",
	info = function(self, t)
		local reduc = t.getReduc(self, t)
		return ([[你 专 注 于 自 然， 使 你 的 召 唤 速 度 提 升（ %d%% 的 正 常 召 唤 时 间）， 并 且 即 使 在 高 自 然 失 衡 值 下 也 不 会 失 败， 持 续 %d 回 合。 
		 当 此 技 能 激 活 时， 某 个 随 机 的 召 唤 天 赋 会 冷 却。 
		 每 次 你 进 行 召 唤， 疯 狂 召 唤 的 效 果 会 减 少 1 回 合。]]):
		format(100 - reduc, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUMMON_CONTROL",
	name = "精确控制",
	info = function(self, t)
		return ([[允 许 你 直 接 控 制 任 一 召 唤 兽。 
		 召 唤 兽 会 出 现 在 界 面 上， 1 次 单 击 就 可 以 使 你 切 换 控 制。 
		 同 时 你 可 以 用 Ctrl+Tab 进 行 切 换。 
		 当 控 制 召 唤 兽 时， 你 的 召 唤 兽 会 增 加 存 在 时 间 %d 回 合 并 减 少 %d%% 所 承 受 伤 害。 
		 受 灵 巧 影 响， 伤 害 减 免 有 额 外 加 成。]]):format(t.lifetime(self,t), t.DamReduc(self,t))
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RITCH_FLAMESPITTER_BOLT",
	name = "火焰喷射",
	message = "@Source@ 喷出火焰!",
	info = function(self, t)
		return ([[吐 出 一 枚 火 球 造 成 %0.2f 火 焰 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}
registerTalentTranslation{
	id = "T_WILD_RITCH_FLAMESPITTER_BOLT",
	name = "火焰喷射",
	message = "@Source@ 喷出火焰!",
	info = function(self, t)
		return ([[吐 出 一 枚 火 球 造 成 %0.2f 火 焰 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}
registerTalentTranslation{
	id = "T_FLAME_FURY",
	name = "火焰之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[发 射 一 道 火 焰 波， 范 围 %d 码 内 的 敌 人 被 击 退 并 引 燃， 造 成 %0.2f 火 焰 伤 害 持 续 3 回 合。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ACID_BREATH",
	name = "酸液吐息",
	message = "@Source@ 喷出酸液!",
	info = function(self, t)
		return ([[向 单体目标 喷 射 酸 液 造 成 %0.2f 伤 害。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}

registerTalentTranslation{
	id = "T_ACID_SPIT_HYDRA",
	name = "酸液喷吐",
	message = "@Source@ 呼出酸液!",
	info = function(self, t)
		return ([[向 敌人 喷 射 酸 液 造 成 %0.2f 伤 害。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}


registerTalentTranslation{
	id = "T_LIGHTNING_BREATH_HYDRA",
	name = "闪电吐息",
	message = "@Source@ 呼出闪电!",
	info = function(self, t)
		return ([[向敌人喷 出 闪 电 吐 息 造 成 %d 到 %d 伤 害。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):
		format(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}

registerTalentTranslation{
	id = "T_LIGHTNING_SPIT_HYDRA",
	name = "闪电喷吐",
	message = "@Source@ 喷出闪电!",
	info = function(self, t)
		return ([[向单体敌人喷吐闪电 造 成 %d 到 %d 伤 害。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):
		format(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}


registerTalentTranslation{
	id = "T_POISON_BREATH",
	name = "毒性吐息",
	message = "@Source@ 呼出毒液!",
	info = function(self, t)
		return ([[向敌人施 放 剧 毒 吐 息 至 你 的 目 标 造 成 %d 伤 害， 持 续 数 回 合。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}

registerTalentTranslation{
	id = "T_POISON_SPIT_HYDRA",
	name = "毒性喷吐",
	message = "@Source@ 喷出毒液!",
	info = function(self, t)
		return ([[向单体敌人施 放 剧 毒 喷吐 至 你 的 目 标 造 成 %d 伤 害， 持 续 数 回 合。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}


registerTalentTranslation{
	id = "T_WINTER_S_FURY",
	name = "严冬之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[一 阵 激 烈 的 冰 风 暴 环 绕 施 法 者 造 成 每 回 合 %0.2f 冰 冷 伤 害， 有 效 范 围 3 码， 持 续 %d 回 合。 
		 有 25%% 几 率 使 受 伤 害 目 标 被 冰 冻。 
		 受 意 志 影 响 , 伤 害 和 持 续 时 间 有 额 外 加 成。]]):format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_WINTER_S_GRASP",
	name = "严冬抓握",
	info = function(self, t)
		return ([[将 目 标 抓 取 到 自 己 的 身 边 ，用 寒 霜 覆 盖 它 ，使 其 移 动 速 度 减 少 50%% ，持 续 %d 回 合 。
		 寒 冰 还 会 对 其 造 成 %0.2f 寒 冷 伤 害 。
		 伤 害 和 减 速 几 率 受 精 神 强 度 加 成 。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentMindDamage(t, 5, 140)))
	end,
}

registerTalentTranslation{
	id = "T_RITCH_FLAMESPITTER",
	name = "契约：火焰里奇",
	message = "@Source@ 召唤出火焰里奇!",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 火焰里 奇 来 燃 烧 敌 人， 持 续 %d 回 合。 火焰里 奇很脆弱， 但 是 它 们 可 以 远 远 地 燃 烧 敌 人。 
		 它 拥 有 %d 点 意 志， %d 点 灵 巧 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、抗 性 穿 透、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 火焰里 奇 的 意 志 和 灵 巧 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_HYDRA",
	name = "契约：三头蛇",
	message = "@Source@ 召唤出三头蛇!",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 三 头 蛇 来 摧 毁 敌 人， 持 续 %d 回 合。 
		 三 头 蛇 可 以 喷 出 毒 系、 酸 系、 闪 电 吐 息。 
		 它 拥 有 %d 点 意 志， %d 点 体 质 和 18 点 力 量。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 三 头 蛇 的 意 志 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.con, incStats.str)
	end,
}

registerTalentTranslation{
	id = "T_RIMEBARK",
	name = "契约：雾凇",
	message = "@Source@ 召唤出雾凇",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 棵 雾 凇 来 来 骚 扰 敌 人， 持 续 %d 回 合。 
		 雾 凇 不 可 移 动， 但 是 永 远 有 寒 冰 风 暴 围 绕 着 它 们， 伤 害 并 冰 冻 3 码 半 径 范 围 内 的 任 何 人。 
		 它 拥 有 %d 点 意 志， %d 点 灵 巧 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 雾 凇 的 意 志 和 灵 巧 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_FIRE_DRAKE",
	name = "契约：火龙",
	message = "@Source@ 召唤出火龙",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 一只 火 龙 来 摧 毁 敌 人， 持 续 %d 回 合。 
		 火 龙 是 可 以 从 很 远 的 地 方 烧 毁 敌 人 的 强 大 生 物。 
		 它 拥 有 %d 点 力 量， %d 点 体 质 和 38 点 意 志。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 火 龙 的 力 量 和 体 质 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con)
	end,
}


return _M

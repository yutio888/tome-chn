local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REALIGN",
	name = "重组",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local cure = t.numCure(self, t)
		return ([[用 你 的 精 神 力 量  重 组 并 调 整 你 的 身 体 ， 移 除 最 多 %d 负 面 物 理 状 态  并 治 愈 %d 生 命。
		受 精 神 强 度 影 响，治 疗 量 有 额 外 加 成。]]):
		format(cure, heal)
	end,
}

registerTalentTranslation{
	id = "T_RESHAPE_WEAPON/ARMOUR",
	name = "武器护甲改造",
	info = function(self, t)
		local weapon_boost = t.damBoost(self, t)
		local arm = t.armorBoost(self, t)
		local fat = t.fatigueBoost(self, t)
		return ([[操 纵 力 量 从 分 子 层 面 重 组 、平 衡 、磨 砺 一 件 武 器 、盔 甲 或 者 盾 牌 （灵 晶 不 能 被 调 整 ，因 为 他 们 已 经 是 完 美 的 自 然 形 态 ）
		永 久 提 高 武 器 %d 命 中 和 伤 害 。
		你 每 件 身 上 的 护 甲 和 盾 牌 增 加 你 %d 护 甲 ，同 时 减 少 %d 疲 劳 。
		该 技 能 效 果 受 精 神 强 度 影 响，且 不 能 对  同 一 件 物 品 重 复 使 用。]]):
		format(weapon_boost, arm, fat)
	end,
}

registerTalentTranslation{
	id = "T_MATTER_IS_ENERGY",
	name = "宝石能量",
	info = function(self, t)
		local amt = t.energy_per_turn(self, t)
		return ([[任 何 优 秀 的 心 灵 杀 手 都 知 道 ，物 质 就 是 能 量 。遗 憾 的 是 ，大 多 数 物 质 由 于 分 子 成 分 的 复 杂 性 无 法 转 换 。然 而 ，宝 石 有 序 的 晶 体 结 构 使 得 部 分 物 质 转 化 为 能 量 成 为 可 能 。
		这 个 技 能 消 耗 一 个 宝 石 ，在 5~13 回 合 内 ，每 回 合 获 得 %d 能 量 ，持 续 回 合 取 决 于 所 用 的 宝 石 品 质 。
		在 持 续 时 间 内 同 时 获 得 一 个 共 振 领 域 提 供 宝 石 的 效 果 ]]):
		format(amt)
	end,
}

registerTalentTranslation{
	id = "T_RESONANT_FOCUS",
	name = "共振聚焦",
	info = function(self, t)
		local inc = t.bonus(self,t)
		return ([[通 过 小 心 的 同 步 你 的 精 神 和 灵 能 聚 焦 的 共 振 频 率 ，强 化 灵 能 聚 焦 的 效 果 
		对 于 武 器 ，提 升 你 的 意 志 和 灵 巧 来 代 替 力 量 和 敏 捷 的 百 分 比 ，从 60%%  到  %d%%.
		对 于 灵 晶 ，提 升 %d%% 将 敌 人 抓 取 过 来 的几 率 .
		对 于 宝 石 ，提 升 %d 额 外 全 属 性。]]):
		format(60+inc, inc, math.ceil(inc/5))
	end,
}

return _M

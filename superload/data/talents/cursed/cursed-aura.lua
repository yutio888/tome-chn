local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DEFILING_TOUCH",
	name = "诅咒之触",
	info = function(self, t)
		return ([[
		你 的 诅 咒 之 触 弥 漫 于 你 附 近 的 所 有 东 西， 给 予 找 到 的 每 个 物 品 1 个 随 机 诅 咒。 当 你 穿 戴 1 件 诅 咒 装 备 时， 你 增 加 那 种 诅 咒 的 效 果。 最 初 诅 咒 是 有 害 的， 但 是 当 装 备 多 件 物 品 并 且 学 到 黑 暗 礼 物 时， 诅 咒 会 变 的 非 常 有 益。 
		等 级 1 —— 诅 咒 武 器
		等 级 2 —— 诅 咒 盔 甲 和 斗 篷
		等 级 3 —— 诅 咒 盾 牌 和 头 盔
		等 级 4 —— 诅 咒 手 套 、 靴 子 和 腰 带
		等 级 6 —— 诅 咒 戒 指
		等 级 7 —— 诅 咒 项 链
		等 级 8 —— 诅 咒 灯 具
		等 级 9 —— 诅 咒 工 具 / 图 腾 / 项 圈 /魔 棒
		等 级 10 ——诅 咒 弹 药
		在 等 级 5 时， 你 可 以 激 活 此 技 能 形 成 1 个 光 环， 增 加 2 级 你 选 择 的 诅 咒 效 果( 当 前 %s)。 
		同 时 ， 技 能 等 级 在 5 以 上 时 会 减 轻 诅 咒 的 负 面 效 果（ 现 在 减 少 %d%% ） ]]):
		format(t.getCursedAuraName(self, t), (1-t.cursePenalty(self, t))*100)
	end,
}

registerTalentTranslation{
	id = "T_DARK_GIFTS",
	name = "黑暗礼物",
	info = function(self, t)
		local level = math.min(4, self:getTalentLevelRaw(t))
		local xs = t.curseBonusLevel(self,t)
		return ([[你 的 诅 咒 带 来 黑 暗 的 礼 物。 解 锁 所 有 诅 咒 第 %d 层 效 果， 并 允 许 你 在 诅 咒 达 到 该 等 级 时 获 得 此 效 果。 
		 在 等 级 5 时， 因 诅 咒 带 来 的 幸 运 惩 罚 降 到 1 。
		 等 级 5 以 上 时 增 加 诅 咒 效 果 （ 当 前 增 加 %0.1f ）]]):
		format(level, xs)
	end,
}

registerTalentTranslation{
	id = "T_RUINED_EARTH",
	name = "毁灭大地",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local incDamage = t.getIncDamage(self, t)

		return ([[诅 咒 你 周 围 %d 码 半 径 范 围 的 大 地， 持 续 %d 回 合。 
		 任 何 站 在 大 地 上 的 目 标 将 会 被 虚 弱， 减 少 它 们 %d%% 的 伤 害。]]):format(range, duration, incDamage)
	end,
}

registerTalentTranslation{
	id = "T_CHOOSE_CURSED_SENTRY",
	name = "选择诅咒守卫",
	info = function(self, t) 
        return [[选择你的诅咒护卫。]] 
    end,
}
registerTalentTranslation{
	id = "T_CURSED_SENTRY",
	name = "诅咒护卫",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local attackSpeed = t.getAttackSpeed(self, t)*100

		return ([[将 部 分 活 性 诅 咒 能 量 灌 输 到 你 背 包 里 的 1 把 武 器 上， 使 其 悬 浮 在 空 中。 这 个 类 似 于 诅 咒 护 卫 的 武 器 会 自 动 攻 击 附 近 的 敌 人， 持 续 %d 回 合。 
		  攻 击 速 度： %d%% 。
		  当 你 第 一 次 选 择 武 器 后 ， 只 要 武 器 仍 旧 在 背 包 里 ， 就 会 被 记 住 。 使 用 “ 选 择 诅 咒 护 卫 ” 技 能 来 切 换 武 器 。
		  技 能 等 级 3 时 ， 你 能 将 具 有 高 级 词 缀 的 武 器 化 为 守 卫 。
		  技 能 等 级 5 时 ， 你 能 将 神 器 化 为 守 卫。
		  ]]):format(duration, attackSpeed)
	end,
}



return _M

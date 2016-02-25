local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONTINUOUS_BUTCHERY",
	name = "无尽屠戮",
	info = function(self, t)
		return ([[用 链 锯 缠 绕 指 定 目 标 5 回 合 。
		 使 用 链 锯 对 此 目 标 造 成 伤 害 时 ，伤 害 增 加 %d%% （ 其 他 链 锯 技 能 也 可 以 加 成 ）。
		 当 攻 击 其 他 目 标 时 ， 伤 害 加 成 效 果 结 束。
		 #{italic}#切碎他们 ！！#{normal}#
		]]):
		format(t.getInc(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVE_SAW",
	name = "爆炸飞锯",
	info = function(self, t)
		return ([[你 用 自 动 蒸 汽 弹 射 器 向 敌 人 发 射 一 把 链 锯 ， 造 成 %0.2f 物 理 伤 害 并 沉 默 敌 人 ，持 续 4 回 合。
		持 续 时 间 结 束 后， 链 锯 爆 炸 ，造 成 %0.2f 的 火 焰 伤 害 并 飞 回， 将 目 标 向 你 的 位 置 拉 扯 %d 格 。 
		伤 害 随 蒸 汽 强 度 增 加 。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamP(self, t)), damDesc(self, DamageType.FIRE, t.getDamF(self, t)), t.range(self, t))
	end,}

registerTalentTranslation{
	id = "T_MOW_DOWN",
	name = "肢解",
	info = function(self, t)
		return ([[杀 死 敌 人 时 ， 迅 速 将 部 分 残 躯 扔 进 蒸 汽 引 擎 ， 恢 复 %d 蒸 汽 值 。
		造 成 暴 击 时 也 有 %d%% 概 率 切 下 敌 人 的 躯 体 扔 进 引 擎。
		任 意 一 种 行 为 都 会 恐 惧 4 格 内 的 敌 人 ， 造 成 %d 回 合 的 锁 脑 效 果。
		#{italic}#变成肉酱吧 ！！#{normal}#]]):
		format(t.getRegen(self, t), t.getChance(self, t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_TECH_OVERLOAD",
	name = "系统过载",
	info = function(self, t)
		local inc = t.getIncrease(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[你 开 启 全 部 插 件 的 超 频 模 式 ， 清 除 最 多 % d 个 蒸 汽 科 技 技 能 （ %d 层 级 或 以 下） 的 CD ， 直 接 恢 复 %d%% 蒸 汽 值。
		 在 6 回 合 内 ， 蒸 汽 值 最 大 值 翻 倍 ， 但 是 恢 复 值 减 半 。
		#{italic}#科技至尊、死亡之主 ！！#{normal}#]]):
		format(talentcount, maxlevel, inc)
	end,}

return _M
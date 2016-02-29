local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSYSHOT",
	name = "灵能射击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[当 使 用 蒸 汽 枪 时 ， 增 加 物 理 强 度 %d 和 武 器 伤 害 %d%% 。
		当 你 的 子 弹 击 中 目 标 时 ， 你 利 用 动 能 将 副 手 的 灵 晶 射 出 ， 造 成 %d%% 武 器 伤 害 （ 必 定 命 中 ），
		当 开 启 心 灵 利 刃 时 ， 灵 晶 无 法 被 射 出 。
		能 主 动 使 用 ， 造 成 %d%% 精 神 武 器 伤 害 。]]):format(damage, inc * 100, t.mindstarMult(self, t) * 100, t.getShootDamage(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_BOILING_SHOT",
	name = "沸腾射击",
	info = function(self, t)
		return ([[使 用 灵 能 加 热 子 弹 ， 造 成 %d%% 武 器 伤 害 。
		子 弹 命 中 处 于 湿 润 状 态 的 目 标 时 将 气 化 ， 除 去 湿 润 状 态 ， 在 半 径 4 范 围 内 造 成 %0.2f 火 焰 伤 害 。
		]]):format(100 * t.getDam(self, t), damDesc(self, DamageType.FIRE, t.getSplash(self, t)))
	end,}

registerTalentTranslation{
	id = "T_BLUNT_SHOT",
	name = "迟钝射击",
	info = function(self, t)
		return ([[发 射 相 对 低 能 量 的 子 弹 ， 造 成 %d%% 武 器 伤 害 。
		子 弹 命 中 时 将 产 生 4 码 锥 形 冲 击 波 ， 震 慑 范 围 内 所 有 生 物 %d 回 合 。]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_VACUUM_SHOT",
	name = "真空射击",
	info = function(self, t)
		return ([[将 灵 能 蒸 汽 装 置 安 装 在 子 弹 上 ， 造 成 %d%% 武 器 伤 害 。
		子 弹 命 中 时 ， 将 抽 取 周 围 空 气 ，吸 引 半 径 %d 范 围 内 所 有 生 物 。]])
		:format(100 * t.getDam(self, t), self:getTalentRadius(t))
	end,}
return _M
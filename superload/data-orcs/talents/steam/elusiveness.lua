local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLIP_AWAY",
	name = "身如游鱼",
	info = function(self, t)
		return ([[用 小 型 喷 射 引 擎 强 化 你 的 机 动 性 ， 可 以 穿 过 直 线 上 连 续 的 %d 个 敌 人 。
	穿 越 后 ， 会 急 速 前 进 % d 码 。 ]])
		:format(t.getRange(self, t), t.getAway(self, t))
	end,}

registerTalentTranslation{
	id = "T_AGILE_GUNNER",
	name = "动若脱兔",
	info = function(self, t)
		local p = self:isTalentActive(t.id)
		local cur = 0
		if p then cur = math.min(p.nb_foes, t.getMax(self, t)) * 20 end
		return ([[被 猎 杀 的 危 险 令 你 激 动 不 已 。
		半 径 %d 内 每 有 一 个 敌 人 ，你 获 得 20%% 移 动 速 度 （ 最 多 %d%% ） 。
		当 前 加 成 ： %d%%。]])
		:format(self:getTalentRadius(t), t.getMax(self, t) * 20, cur)
	end,}

registerTalentTranslation{
	id = "T_AWESOME_TOSS",
	name = "致命翻转",
	info = function(self, t)
		return ([[在 惊 人 的 灵 巧 和 科 技 力 量 下， 你 将 你 的 蒸 汽 枪 翻 转 指 向 天 空 ， 持 续 旋 转 3 回 合 。
		每 回 合 ，蒸 汽 枪 将 随 机 射 击 2 次 ， 造 成 %d%% 武 器 伤 害 。
		效 果 持 续 期 间 ， 你 视 为 被 缴 械 ， 不 能 攻 击 。
		这 场 表 演 如 此 引 人 注 目 ，你 的 敌 人 都 被 吸 引 ， 使 你 的 伤 害 抗 性 增 加 %d%%。]])
		:format(100 * t.getMultiple(self, t), t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_DAZZLING_JUMP",
	name = "炫目大跳",
	info = function(self, t)
		return ([[当 你 的 敌 人 被 致 命 翻 转 吸 引 时 ， 你 启 动 强 力 的 蒸 汽 引 擎 ， 跳 向 空 中 ， 将 目 标 踢 走 %d 码。 
		这 次 攻 击 冲 击 力 非 常 大 ，半 径 3 以 内 所 有 生 物 将 被 减 速 %d%% ， 持 续 4 回 合 。
		反 冲 力 也 让 你 后 退 %d 码 。]])
		:format(t.getRange(self, t), t.getSlow(self, t), t.getAway(self, t))
	end,}
return _M
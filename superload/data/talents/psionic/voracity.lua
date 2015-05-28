local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_KINETIC_LEECH",
	name = "动能吸取",
	info = function(self, t)
		local range = self:getTalentRadius(t)
		return ([[你 从 周 围 吸 取 动 能，来 增 加 自 己 的 超 能 力 值 。
		减 少 %d 码 半 径 范 围 内 的 敌 人 %d%% (最 多 %d%% ) 速 度，同 时 每 个 目 标 吸 取 %0.1f( 最 多 %0.1f ) 点 体 力 。 
		从 第 一 个 目 标 处 你 获 得 %d(最 多 %d ) 超 能 力 值，之 后 每 个 目 标 减 少 20%%.
		当 超 能 力 值 减 少 时 ， 技 能 效 果 会 加 强。]])
		:format(range, t.getSlow(self, t)*100, t.getSlow(self, t, 0)*100, t.getDam(self, t), t.getDam(self, t, 0), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_LEECH",
	name = "热能吸取",
	info = function(self, t)
		local range = self:getTalentRadius(t)
		return ([[你 从 周 围 吸 取 热 能，来 增 加 自 己 的 超 能 力 值 。
		冻 结 %d 码 半 径 范 围 内 的 敌 人 %d （ 最 多 %d ）回 合，同 时 对 每 个 目 标 造 成 %0.1f （ 最   多 %0.1f ） 点 寒 冷 伤 害 。 
		从 第 一 个 目 标 处 你 获 得 %d （ 最 多 %d ）超 能 力 值，之 后 每 个 目 标 减 少 20%%.
		当 超 能 力 值 减 少 时 ， 技 能 效 果 会 加 强。]])
		:format(range, t.getDur(self, t), t.getDur(self, t, 0), damDesc(self, DamageType.COLD, t.getDam(self, t)), damDesc(self, DamageType.COLD, t.getDam(self, t, 0)), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_CHARGE_LEECH",
	name = "电能吸取",
	info = function(self, t) 
		local range = self:getTalentRadius(t)
		return ([[你 从 周 围 吸 取 电 能，来 增 加 自 己 的 超 能 力 值 。
		对 %d 码 半 径 范 围 内 的 敌 人 造 成 %0.1f ( 最 多 %0.1f ） 点 闪 电 伤 害，同 时 有 %d%% （   最 多 %d%% ）几 率 使 之 眩 晕 3 回 合。 
		从 第 一 个 目 标 处 你 获 得 %d ( 最 多 %d ) 超 能 力 值，之 后 每 个 目 标 减 少 20%%.
		当 超 能 力 值 减 少 时 ， 技 能 效 果 会 加 强。]])
		:format(range,t.getDam(self, t), t.getDam(self, t, 0),  t.getDaze(self, t), t.getDaze(self, t, 0), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_INSATIABLE",
	name = "贪得无厌",
	info = function(self, t)
		local recover = t.getPsiRecover(self, t)
		return ([[增 加 超 能 力 值 上 限 %d. 每 次 杀 死 敌 人 获 得 %0.1f超 能 力 值 ， 每 次 精 神 暴 击 获 得 %0.1f 超 能 力 值。]]):format(5 * recover, recover, 0.5*recover)
	end,
}


return _M

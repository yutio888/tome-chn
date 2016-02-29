local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMSAW_MASTERY",
	name = "链锯掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使 用 链 锯 时 ， 提 高 物 理 强 度 %d ，提 高 武 器 伤 害 %d%% 。]])
		:format(damage, inc * 100)
	end,}

registerTalentTranslation{
	id = "T_OVERHEAT_SAWS",
	name = "过热链锯",
	info = function(self, t)
		return ([[用 蒸 汽 包 裹 链 锯 ， 对 近 战 攻 击 命 中 的 目 标 在 3 回 合 内 造 成 %0.2f 点 火 焰 伤 害 （ 可 以 叠 加 ） 。
		#{italic}#滚烫的蒸汽，死吧！#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TEMPEST_OF_METAL",
	name = "金属狂怒",
	info = function(self, t)
		return ([[持 续 挥 舞 你 的 链 锯 ， 每 次 你 攻 击 时 对 周 围 敌 人 造 成 %d%% 武 器 伤 害。
		你 狂 乱 的 动 作 使 你 很 难 被 命 中 ， %d%% 几 率 无 视 伤 害。
		伤 害 无 效 概 率 随 蒸 汽 强 度 提 高 。
		#{italic}#感受金属之怒吧！！#{normal}#]])
		:format(30, t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_OVERCHARGE_SAWS",
	name = "链锯过载",
	info = function(self, t)
		return ([[链 锯 引 擎 临 时 进 入 过 载 模 式 ， 增 加 %d%% 的 链 锯 相 关 技 能 有 效 等 级 , 持续 %d 回 合 。
		#{italic}#无尽地痛苦#{normal}#]])
		:format(t.getPower(self, t), t.getDur(self, t))
	end,}
return _M
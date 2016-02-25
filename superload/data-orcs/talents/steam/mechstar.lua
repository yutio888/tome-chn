local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_METALSTAR",
	name = "金属灵晶",
	info = function(self, t)
		return ([[迅 速 将 金 属 粒 子 聚 集 在 灵 晶 周 围 ， 并 将 灵 能 聚 焦 于  其 中 。
		金 属 粒 子 将 产 生 大 爆 炸 ， 击 退（ %d 码 ） 并 眩 晕 （ %d 回 合 ） 半 径 %d 内 所 有 敌 人。
		]])	
		:format(t.getKnockback(self, t), t.getDur(self, t), self:getTalentRadius(t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTAR",
	name = "血液灵晶",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[每 次 你 使 用 灵 晶 射 击 时 ， 你 将 与 灵 晶 碎 片 建 立 血 液  超 能 力 联 系 ， 持  续 %d 回 合 。
		每 回 合 目 标 将 受 到 %0.2f 物 理 伤 害 ， 一 半 伤 害 值 将 转 化 为 治 疗 。
		每 增 加 一 名 额 外 目 标 ， 其 带 来 的 治 疗 量 进 一 步 减 半 。
		当 目 标 距 离 超 过 金 属 灵 晶 范 围 （ 当 前 %d ） 的 两 倍 时 ，效 果 中 止 。
		该 伤 害 不 会 打 断 眩 晕 效 果 ， 受 蒸 汽 强 度 加 成 。]])
		:format(t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(mt) * 2)
	end,}

registerTalentTranslation{
	id = "T_STEAMSTAR",
	name = "蒸汽灵晶",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[你 的 血 液 灵 晶 效 果 同 时 造 成 %0.2f 火 焰 伤 害。
		火 焰 同 时 产 生 蒸 汽 ，每 回 合 提 供 %d 蒸 汽 ， 从 每 个 额 外 目 标 处 获 得 的 蒸 汽 数 量 减 少 66%%。
		该 伤 害 不 会 打 断 眩 晕 效 果 ， 受 蒸 汽 强 度 加 成 。]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getSteam(self, t))
	end,}

registerTalentTranslation{
	id = "T_DEATHSTAR",
	name = "死亡灵晶",
	info = function(self, t)
		return ([[每 次 你 使 用 射 击 类 技 能 命 中 一 个 被 血 液 灵 晶 影 响 的 目 标 时 ，随 机 另 一 项 冷 却 中 的 射 击 类 技 能 冷 却 时 间 减 少 %d 回 合 。]])
		:format(t.getReduct(self, t))
	end,}
return _M
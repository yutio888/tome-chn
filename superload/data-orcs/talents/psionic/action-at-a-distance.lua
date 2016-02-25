local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONDENSATE",
	name = "冷凝",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在 你 敌 人 身 边 的 %d 码 内 冷 凝 热 蒸 汽。 对 他 们 造 成 %0.2f 火 焰 伤 害 并 浸 湿 他 们 4 回 合。 被 浸 湿 的 敌 人 的 震 撼 抗 性 会 减 半。
		伤 害 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_SOLIDIFY_AIR",
	name = "固化空气",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 集 中 精 神 力 把 你 前 方 的 锥 形 空 间 内 的 空 气 凝 聚 成 固 态。
		任 何 陷 入 其 中 的 生 物 都 会 受 到 %0.2f 的 物 理 伤 害。
		任 何 没 被 生 物 占 据 的 地 方 会 被 固 化 空 气 占 满， 阻 路 %d 回 合。
		伤 害 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCONDUCTION",
	name = "超导",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 道 闪 电 劈 向 你 的 目 标， 造 成 %0.2f 到 %0.2f 闪 电 伤 害。
		如 果 目 标 被 浸 湿 了， 那 么 闪 电 扩 散， 对 半 径 %d 码 内 的 所 有 单 位 造 成 同 样 的 伤 害。
		所 有 被 劈 中 的 单 位 都 会 被 烧 焦 4 回 合， 降 低 他 们 的 火 焰 抗 性 %d%% 和 精 神 豁 免 %d。
		伤 害 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage) / 3, damDesc(self, DamageType.LIGHTNING, damage), self:getTalentRadius(t), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_NEGATIVE_BIOFEEDBACK",
	name = "负反馈",
	info = function(self, t)
		return ([[每 当 你 使 用 精 神 技 能 造 成 伤 害 时， 你 对 你 的 敌 人 施 加 一 个 负 反 馈， 能 叠 加 至 %d 层 并 持 续 5 回 合。
		每 层 都 会 降 低 他 们 %d 的 物 理 豁 免 和 %d 的 防 御 与 护 甲。
		这 个 效 果 每 回 合 只 能 触 发 一 次。]]):
		format(t.getNb(self, t), t.getSave(self, t), t.getPower(self, t))
	end,}
return _M
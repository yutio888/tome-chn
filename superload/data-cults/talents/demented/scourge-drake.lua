local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TENTACLED_WINGS",
	name = "触手之翼",
	info = function(self, t)
		return ([[你 向 前 方 半 径 %d 的 锥 形 区 域 内 发 射 触 手。
		任 何 在 范 围 内 的 敌 人 将 会 被 触 手 缠 绕 并 受 到 %d%% 枯 萎 武 器 伤 害，如 果 攻 击 命 中 ， 该 生 物 还 会 被 拉 向 你。]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t) * 100))
	end,
}

registerTalentTranslation{
	id = "T_DECAYING_GROUNDS",
	name = "腐朽之地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 使 一 个 区 域 枯 萎 ， 把 它 们 变 成 腐 朽 之 地 ， 持 续 %d 回 合 。 
		所 有 在 其 中 的 生 物 每 回 合 受 到 %0.2f 枯 萎 伤 害 ，并 且 所 有 技 能 冷 却 时 间 增 加 %d%% 回 合 ， 持 续 3 回 合 。
		伤 害 受 你 的 法 术 强 度 或 者 精 神 强 度 两 者 中 更 高 一 方 影 响。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.DARKNESS, damage), t.getPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_AUGMENT_DESPAIR",
	name = "扩大绝望",
	info = function(self, t)
		return ([[你 选 取 一 个 目 标 ， 将 你 的 疯 狂 和 仇 恨 灌 注 于 它 ， 扩 大 它 的 绝 望 。 
		增 加 负 面 效 果 的 持 续 时 间 %d 回 合 ， 并 且 每 有 一 个 负 面 效 果 ， 造 成 %0.2f 点 枯 萎 伤 害 。 ( 每 个 效 果 造 成 前 一 个 效 果 75%% 伤 害。)。
		伤 害 受 你 的 法 术 强 度 或 者 精 神 强 度 两 者 中 更 高 一 方 影 响。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)))
	end,
}


registerTalentTranslation{
	id = "T_MAGGOT_BREATH",
	name = "蛆虫吐息",
	info = function(self, t)
		return ([[你 向 半 径 为 %d 的 锥 形 区 域 内 吐 出 一 道 由 蛆 虫 尸 体 组 成 的 波 浪 。
		任 何 在 范 围 内 的 目 标 受 到 %0.2f 枯 萎 伤 害 ，  并 被 残 废 恶 疾 感 染 ， 持 续 1 0 回 合 。
		残 废 恶 疾 减 慢 目 标 %d%% 速 度，并 且 每 回 合 造 成 %0.2f 枯 萎 伤 害。
		伤 害 随 法 术 强 度 增 加 而 增 加 ， 暴 击 率 基 于 法 术 暴 击 。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)), t.getSlow(self, t) * 100, damDesc(self, DamageType.BLIGHT, t.getDiseaseDamage(self, t)))
	end,
}

return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_ELECTROKINESIS",
	name = "卓越电能",
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 电 能 突 破 极 限， 增 加 你 的 闪 电 伤 害 %d%% ， 闪 电 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 电 能 护 盾， 电 能 吸 取， 充 能 光 环 和 头 脑 风 暴 的 冷 却 时 间。
		根 据 情 况， 充 能 光 环 获 得 其 中 一 种 强 化： 充 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 充 能 光 环 的 伤 害 加 成。
		你 的 电 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		头 脑 风 暴 附 带 致 盲 效 果。
		电 能 吸 取 附 带 混 乱 效 果 （ %d%% 概 率）。
		电 能 打 击 的 第 二 次 闪 电 / 致 盲 攻 击 将 会 对 半 径 3 格 之 内 的 最 多 3 名 敌 人 产 生 连 锁 反 应。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 卓 越 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getConfuse(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THOUGHT_SENSE",
	name = "心电感应",
	info = function(self, t)
		return ([[感 知 半 径 %d 范 围 内 生 物 的 精 神 活 动 ， 效 果 持 续 %d 回 合。
		这 个 技 能 暴 露 他 们 的 位 置， 并 增 加 你 的 防 御 %d 。
		受 精 神 强 度 影 响， 持 续 时 间、 闪 避、 和 半 径 有 额 外 加 成。]]):format(t.radius(self, t), t.getDuration(self, t), t.getDefense(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STATIC_NET",
	name = "静电网络",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 半 径 %d 范 围 中 散 布 一 个 持 续 %d 回 合 的 静 电 捕 网。
		站 在 网 中 的 敌 人 受 到 %0.1f 的 闪 电 伤 害 并 被 减 速 %d%% 。
		当 你 在 网 中 穿 梭， 你 的 武 器 上 会 逐 渐 累 加 静 电 充 能， 让 你 的 下 一 次 攻 击 造 成 额 外 %0.1f 的 闪 电 伤 害。
		受 精 神 强 度 影 响， 技 能 效 果 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), duration, damDesc(self, DamageType.LIGHTNING, damage), t.getSlow(self, t), damDesc(self, DamageType.LIGHTNING, t.getWeaponDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_HEARTSTART",
	name = "心跳复苏",
	info = function(self, t)
		return ([[储 存 一 次 电 力 充 能 用 来 在 之 后 挽 救 你 的 生 命。
		当 这 个 技 能 激 活 时， 如 果 你 的 生 命 值 被 减 低 到 0 以 下， 这 个 技 能 将 会 进 入 冷 却， 解 除 你 的 震 慑 / 晕 眩 / 冰 冻 状 态， 使 你 的 生 命 值 最 多 为 - %d 时 不 会 死 亡， 效 果 持 续 %d 回 合。
		受 精 神 强 度 和 最 大 生 命 值 影 响， 承 受 的 致 命 伤 害 有 额 外 加 成。.]]):
		format(t.getPower(self, t), t.getDuration(self, t))
	end,
}


return _M

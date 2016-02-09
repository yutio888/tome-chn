local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_TELEKINESIS",
	name = "卓越动能",
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 动 能 突 破 极 限， 增 加 你 的 物 理 伤 害 %d%% ， 物 理 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 动 能 护 盾， 动 能 吸 取， 动 能 光 环 和 心 灵 鞭 笞 的 冷 却 时 间。
		根 据 情 况， 动 能 光 环 获 得 其 中 一 种 强 化： 动 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 动 能 光 环 的 伤 害 加 成。
		你 的 动 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		心 灵 鞭 笞 附 带 震 慑 效 果。
		动 能 吸 取 会 使 敌 人 进 入 睡 眠。
		动 能 打 击 会 对 相 邻 的 两 个 敌 人 进 行 攻 击。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 卓 越 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_KINETIC_SURGE",
	name = "动能爆发",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[
		使 用 你 的 念 动 力 增 强 你 的 力 量， 使 你 能 够 举 起 一 个 相 邻 的 敌 人 或 者 你 自 己 并 投 掷 到 半 径 %d 范 围 的 任 意 位 置。 
		敌 人 落 地 时 受 到 %0.1f 物 理 伤 害， 并 被 震 慑 %d 回 合。 落 点 周 边 半 径 2 格 内 的 所 有 其 他 单 位 受 到 %0.1f 物 理 伤 害 并 被 从 你 身 边 被 退。
		这 个 技 能 无 视 被 投 掷 目 标 %d%% 的 击 退 抵 抗， 如 果 目 标 抵 抗 击 退， 只 受 到 一 半 伤 害。
		
		对 你 自 己 使 用 时 ， 击 退 线 路 上 所 有 目 标 并 造 成  %0.1f 物 理 伤 害 。
		同 时 能 破 坏 至 多 %d 面 墙 壁。
		受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		受 精 神 强 度 和 力 量 影 响， 投 掷 距 离 有 额 外 加 成。]]):
		format(range, dam, math.floor(range/2), dam/2, t.getKBResistPen(self, t), dam, math.floor(range/2))
	end,
}

registerTalentTranslation{
	id = "T_DEFLECT_PROJECTILES",
	name = "弹道偏移",
	info = function(self, t)
		local chance, spread = t.getEvasion(self, t)
		return ([[你 学 会 分 配 一 部 分 注 意 力， 用 精 神 力 击 落、 抓 取 或 偏 斜 飞 来 的 发 射 物。 
		所 有 以 你 为 目 标 的 发 射 物 有 %d%% 的 几 率 落 在 半 径 %d 格 范 围 内 的 其 他 地 点。
		如 果 你 愿 意， 你 可 以 使 用 精 神 力 来 抓 住 半 径 10 格 内 的 所 有 发 射 物， 并 投 回 以 你 为 中 心 半 径 %d 格 内 的 任 意 地 点， 这 么 做 会 打 断 你 的 集 中 力， 并 使 这 个 持 续 技 能 进入 冷 却。
		要 想 这 样 做 ， 取 消 该 持 续 技 即 可。]]):
		format(chance, spread, self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	id = "T_IMPLODE",
	name = "碎骨压制",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[用 粉 碎 骨 头 的 力 量 紧 紧 锁 住 目 标 ， 定 身 并 减 速 目 标 50%% ， 持 续  %d 回 合 ， 每 回 合 造 成 %0.1f 物 理 伤 害。
		受 精 神 强 度 影 响， 持 续 时 间 和 伤 害 有 额 外 加 成。]]):format(dur, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M

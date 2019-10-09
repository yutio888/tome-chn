local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING_SPEED",
	name = "闪电加速",
	info = function(self, t)
		return ([[你 转 化 为 闪 电， 增 加 %d%% 移 动 速 度， 持 续 %d 回 合。 
		 同 时 提 供 30%% 物 理 伤 害 抵 抗 和 100%% 闪 电 抵 抗。 
		 除 了 移 动 外， 任 何 动 作 都 会 打 断 此 效 果。 
		 注 意： 由 于 你 的 移 动 速 度 非 常 快， 游 戏 回 合 时 间 会 显 得 非 常 慢。 
		 这 个 技 能 还 能 被 动 提 升 你 %d%% 移 动 速 度。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%% 。]])
		 :format(t.getSpeed(self, t), t.getDuration(self, t), t.getPassiveSpeed(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_STATIC_FIELD",
	name = "静电力场",
	info = function(self, t)
		local percent = t.getPercent(self, t)
		local litdam = t.getDamage(self, t)
		return ([[制 造 一 个 %d 码 范 围 的 静 电 力 场。 任 何 范 围 内 的 目 标 至 多 会 丢 失 %0.1f%% 当 前 生 命 值（精 英 或 稀 有 %0.1f%% 史 诗 或 Boss %0.1f%% 精 英 Boss %0.1f%% ）该 伤 害 不 能 抵 抗 ， 但 可 以 被 物 理 豁 免 减 少 。 
		 之 后 ， 会 造 成 额 外 %0.2f 闪 电 伤 害 ， 无 视 怪 物 阶 级。
		  受 精 神 强 度 影 响， 生 命 丢 失 量 和 闪 电 伤 害 有 额 外 加 成。闪 电 伤 害 可 以 暴 击。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%% 。]]):format(self:getTalentRadius(t), percent, percent/1.5, percent/2, percent/2.5, damDesc(self, DamageType.LIGHTNING, litdam))
	end,
}

registerTalentTranslation{
	id = "T_TORNADO",
	name = "龙卷风",
	info = function(self, t)
		local rad = t.getRadius(self, t)
		return ([[召 唤 一个 龙 卷 风，它会向着目标极为缓慢地移动，并在目标移动时跟随目标，最多移动20次。
		 每当它移动时，半径2范围内的所有敌人会受 到 %0.2f 闪 电 伤 害，并被击退2格。
		 当它碰到目标的时候，会在%d码范围内引发爆炸，击退目标，并造成 %0.2f 闪电和 %0.2f 物理伤害。
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%% 。]]):format(
			damDesc(self, DamageType.LIGHTNING, t.getMoveDamage(self, t)),
			rad,
			damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)),
			damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		)
	end,
}

registerTalentTranslation{
	id = "T_LIGHTNING_BREATH",
	name = "闪电吐息",
	message = "@Source@ 呼出闪电!",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 闪 电。 
		 此 范 围 内 的 目 标 会 受 到 %0.2f ～ %0.2f 闪 电 伤 害 并 被 眩 晕 3 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%% 。]]):format(
			self:getTalentRadius(t),
			damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage)
		)
	end,
}


return _M

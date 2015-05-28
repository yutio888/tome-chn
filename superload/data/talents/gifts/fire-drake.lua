local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WING_BUFFET",
	name = "龙翼飓风",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你召 唤 一 阵 强 风 ， 击 退 半 径 %d 码 内 的 敌 人 至 多 3 格 ， 并 造 成 %d%% 武 器 伤 害。
		同 时， 每 个 技 能 等 级 增 加 你 的 物 理 强 度 和 命 中 4 点 。
		每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%% 。]]):format(self:getTalentRadius(t),damage*100)
	end,
}

registerTalentTranslation{
	id = "T_BELLOWING_ROAR",
	name = "怒意咆哮",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 发 出 一 声 咆 哮 使 %d 码 半 径 范 围 内 的 敌 人 陷 入 彻 底 的 混 乱， 持 续 3 回 合。 
		 如 此 强 烈 的 咆 哮 使 你 的 敌 人 受 到 %0.2f 物 理 伤 害。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%% 。]]):format(radius, self:combatTalentStatDamage(t, "str", 30, 380))
	end,
}

registerTalentTranslation{
	id = "T_DEVOURING_FLAME",
	name = "火焰吞噬",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[你 喷 出 一 片 火 焰， 范 围 内 的 目 标 每 回 合 会 受 到 %0.2f 火 焰 伤 害（ 影 响 半 径 %d ）， 持 续 %d 回 合。 
		 火 焰 会 无 视 使 用 者 ， 并 吸 收 10%% 伤 害 治 疗 自 身。
		 伤 害 受 精 神 强 度 加 成 。 技 能 可 暴 击。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%% 。]]):format(damDesc(self, DamageType.FIRE, dam), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_FIRE_BREATH",
	name = "火焰吐息",
	info = function(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 火 焰。 此 范 围 内 的 目 标 会 在 3 回 合 内 受 到 %0.2f 火 焰 伤 害，且 有 25%% 几 率 进 入 火 焰 震 慑 状 态 3 回 合 。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成， 暴 击 几 率 基 于 你 的 精 神 暴 击 率。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 650)))
	end,
}


return _M

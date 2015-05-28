local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHOOT",
	name = "射击",
	info = function(self, t)
		return ([[使 用 弓 箭 、 投 石 索 或 者 其 他 什 么 东 西 发 射 ！]])
	end,
}

registerTalentTranslation{
	id = "T_STEADY_SHOT",
	name = "稳固射击",
	info = function(self, t)
		return ([[稳 固 的 射 击， 造 成 %d%% 基 础 伤 害。]]):format(self:combatTalentWeaponDamage(t, 1.1, 2.2) * 100)
	end,
}

registerTalentTranslation{
	id = "T_AIM",
	name = "瞄准",
	info = function(self, t)
		local vals = t.getCombatVals(self, t)
		return ([[你 进 入 心 如 止 水 的 状 态， 专 注 瞄 准， 增 加 你 %d 点 物 理 强 度， %d 点 命 中， %d 点 护 甲 穿 透， %d%% 暴 击 率， 但 是 减 少 你 %d%% 射 速。 
		受 敏 捷 影 响， 此 效 果 有 额 外 加 成。]]):
		format(vals.dam, vals.atk, vals.apr, vals.crit, -vals.speed * 100)
	end,
}

registerTalentTranslation{
	id = "T_RAPID_SHOT",
	name = "急速射击",
	info = function(self, t)
		local vals = t.getCombatVals(self, t)
		return ([[你 转 换 成 一 种 流 畅 和 快 速 的 射 击 姿 势， 增 加 你 %d%% 射 击 速 度 但 减 少 %d 点 命 中， %d 物 理 强 度 和 %d%% 暴 击 率。]]):
		format(vals.speed*100, vals.atk, vals.dam, vals.crit)
	end,
}

registerTalentTranslation{
	id = "T_RELAXED_SHOT",
	name = "宁神射击",
	info = function(self, t)
		return ([[你 未 尽 全 力 射 出 一 支 箭， 造 成 %d%% 伤 害。 
		这 个 短 暂 的 放 松 允 许 你 回 复 %d 体 力。]]):format(self:combatTalentWeaponDamage(t, 0.5, 1.1) * 100, 12 + self:getTalentLevel(t) * 8)
	end,
}

registerTalentTranslation{
	id = "T_FLARE",
	name = "照明箭",
	info = function(self, t)
		local rad = 1
		if self:getTalentLevel(t) >= 3 then rad = rad + 1 end
		if self:getTalentLevel(t) >= 5 then rad = rad + 1 end
		return ([[你 射 出 一 支 燃 烧 的 箭 矢 造 成 %d%% 火 焰 伤 害 并 照 亮 %d 码 半 径。 
		在 等 级 3 时， 会 有 概 率 致 盲 目 标 3 回 合。]]):
		format(self:combatTalentWeaponDamage(t, 0.5, 1.2) * 100, rad)
	end,
}

registerTalentTranslation{
	id = "T_CRIPPLING_SHOT",
	name = "致残射击",
	info = function(self, t)
		return ([[你 射 出 一 支 致 残 矢， 造 成 %d%% 伤 害 并 减 少 目 标 %d%% 速 度 持 续 7 回 合。 
		受 命 中 影 响， 伤 害 和 命 中 率 有 额 外 加 成。 ]]):format(self:combatTalentWeaponDamage(t, 1, 1.5) * 100, util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4) * 100)
	end,
}

registerTalentTranslation{
	id = "T_PINNING_SHOT",
	name = "束缚射击",
	info = function(self, t)
		return ([[你 射 出 一 支 束 缚 之 箭 对 目 标 造 成 %d%% 伤 害 并 束 缚 目 标 %d 回 合。 
		受 你 敏 捷 影 响， 定 身 概 率 有 额 外 加 成。]])
		:format(self:combatTalentWeaponDamage(t, 1, 1.4) * 100,
		t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SCATTER_SHOT",
	name = "环形射击",
	info = function(self, t)
		return ([[你 在 %d 码 半 径 区 域 内 射 出 多 支 呈 环 形 分 布 的 箭 矢， 造 成 %d%% 伤 害 并 震 慑 你 的 目 标 %d 回 合。 
		受 命 中 影 响， 震 慑 概 率 有 额 外 加 成。]])
		:format(self:getTalentRadius(t), self:combatTalentWeaponDamage(t, 0.5, 1.5) * 100, t.getStunDur(self,t))
	end,
}


return _M

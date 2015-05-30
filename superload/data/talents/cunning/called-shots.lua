local _M = loadPrevious(...)

-- calc_all is so the info can show all the effects.
local sniper_bonuses = function(self, calc_all)
	local bonuses = {}
	local t = self:getTalentFromId("T_SKIRMISHER_SLING_SNIPER")
	local level = self:getTalentLevel(t)

	if level > 0 or calc_all then
		bonuses.crit_chance = self:combatTalentScale(t, 3, 10)
		bonuses.crit_power = self:combatTalentScale(t, 0.1, 0.2, 0.75)
	end
	if level >= 5 or calc_all then
		bonuses.resists_pen = {[DamageType.PHYSICAL] = self:combatStatLimit("cun", 100, 15, 50)} -- Limit < 100%
	end
	return bonuses
end

registerTalentTranslation{
	id = "T_SKIRMISHER_KNEECAPPER",
	name = "膝盖杀手",
	info = function(self, t)
		return ([[射 击 敌 人 的 膝 盖 （ 或 者 任 何 活 动 肢 体 上 的 重 要 部 位）， 造 成 %d%% 武 器 伤 害， 并 将 敌 人 击 倒 （ 定 身 %d 回 合） 并 在 之 后 降 低 其 移 动 速 度 %d%% %d 回合 。
		这 个 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。
		受 灵 巧 影 响， 减 速 效 果 有 额 外 加 成。]])
		:format(t.damage_multiplier(self, t) * 100,
				t.pin_duration(self, t),
				t.slow_power(self, t) * 100,
				t.slow_duration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_THROAT_SMASHER",
	name = "致命狙击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[对 敌 人 进 行 一 次 特 殊 的 射 击。
		这 个 技 能 专 注 于 精 准 的 远 程 狙 击， 造 成 %d%% 的 基 础 远 程 伤 害 以 及 受 距 离 加 成 的 额 外 伤 害。
		在 零 距 离， 伤 害 加 成 （ 惩 罚） 为 %d%% ， 在 最 大 射 程 （ %d 格）， 伤 害 加 成 为 %d%% 。
		这 个 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。]])
		:format(t.damage_multiplier(self, t) * 100, t.getDistanceBonus(self, t, 1)*100, range, t.getDistanceBonus(self, t, range)*100)

	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_NOGGIN_KNOCKER",
	name = "爆头连射",
	info = function(self, t)
		return ([[对 敌 人 的 脆 弱 部 位 （ 通 常 是 头 部） 迅 速 地 连 射 三 次。
		每 次 射 击 造 成 %d%% 远 程 伤 害 并 试 图 震 慑 目 标 或 增 加 震 慑 的 持 续 时 间 1 回 合。
		这 些 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。
		受 命 中 影 响， 晕 眩 几 率 增 加。]])
		:format(t.damage_multiplier(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SLING_SNIPER",
	name = "投石大师",
	info = function(self, t)
		local bonuses = sniper_bonuses(self, true)
		return ([[你 对 射 击 的 掌 握 程 度 无 与 伦 比。 你 的 精 准 射 击 系 技 能 获 得 %d%% 额 外 暴 击 几 率 和 %d%% 额 外 暴 击 伤 害。 
		在 第 3 级 时， 所 有 精 准 射 击 系 技 能 冷 却 时 间 降 低 两 回 合。
		在 第 5 级 时， 你 的 精 准 射 击 技 能 获 得 %d%% 物 理 抗 性 穿 透]])
		:format(bonuses.crit_chance,
			bonuses.crit_power * 100,
			bonuses.resists_pen[DamageType.PHYSICAL])
	end,
}



return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISPERSE_MAGIC",
	name = "驱散",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[驱 散 目 标 身 上 的 %d 种 魔 法 效 果（ 敌 方 单 位 的 增 益 状 态 和 友 方 单 位 的 负 面 状 态）。 
		 在 等 级 3 时 可 以 选 择 目 标。]]):
		format(count)
	end,
}

registerTalentTranslation{
	id = "T_SPELLCRAFT",
	name = "法术亲和",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你 学 会 精 确 调 节 你 的 攻 击 技 能。 
		 你 试 图 控 制 自 己 的 攻 击 性 魔 法， 尝 试 在 攻 击 范 围 中 留 出 空 隙， 避 免 伤 及 自 身， %d%% 成 功 概 率。 
		 如 果 你 的 法 术 强 度 等 级 超 过 目 标 法 术 豁 免 等 级， 你 的 攻 击 法 术 将 会 对 目 标 产 生 法 术 冲 击。 此 技 能 将 赋 予 你 提 高 %d 法 术 强 度 的 加 成 用 于 判 定 目 标 的 法 术 豁 免。 被 法 术 冲 击 目 标 暂 时 减 少 20%% 伤 害 抵 抗。]]):
		format(chance, self:combatTalentSpellDamage(t, 10, 320) / 4)
	end,
}

registerTalentTranslation{
	id = "T_QUICKEN_SPELLS",
	name = "快速施法",
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[减 少 %d%% 所 有 法 术 冷 却 时 间。]]):
		format(cooldownred * 100)
	end,
}

registerTalentTranslation{
	id = "T_METAFLOW",
	name = "奥术流动",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[ 你 对 奥 术 的 精 通 使 你 能 重 置 法 术 的 冷 却 时 间。 
		 重 置 至 多 %d 个法 术 的 冷 却 ， 对 技 能 层 次 %d 或 更 低 的 技 能 有 效。]]):
		format(talentcount, maxlevel)
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_COMBAT",
	name = "影之格斗",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local manacost = t.getManaCost(self, t)
		return ([[在 你 的 武 器 上 注 入 一 股 黑 暗 的 能 量， 每 次 攻 击 会 造 成 %.2f 暗 影 伤 害 并 消 耗 %.2f 点 法 力。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), manacost)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_CUNNING",
	name = "影之狡诈",
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		return ([[你 的 充 分 准 备 提 高 了 你 的 魔 法 运 用 能 力。 增 加 相 当 于 你 %d%% 灵 巧 的 法 术 强 度。]]):
		format(spellpower)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_FEED",
	name = "暗影充能",
	info = function(self, t)
		local manaregen = t.getManaRegen(self, t)
		return ([[你 学 会 从 暗 影 中 汲 取 能 量。 
		 当 此 技 能 激 活 时， 每 回 合 回 复 %0.2f 法 力 值。 
		 同 时， 你 的 攻 击 速 度 和 施 法 速 度 获 得 %0.1f%% 的 提 升。]]):
		format(manaregen, t.getAtkSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOWSTEP",
	name = "暗影突袭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[通 过 阴 影 突 袭 你 的 目 标， 眩 晕 它 %d 回 合 并 用 你 所 有 武 器 对 目 标 造 成 %d%% 暗 影 武 器 伤 害。 
		 被 眩 晕 的 目 标 受 到 显 著 伤 害 ， 但 任 何 对 目 标 的 伤 害 会 解 除 眩 晕。 
		 当 你 使 用 暗 影 突 袭 时， 目 标 必 须 在 视 野 范 围 内。]]):
		format(duration, t.getDamage(self, t) * 100)
	end,
}




return _M

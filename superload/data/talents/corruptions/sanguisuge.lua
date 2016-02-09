local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_DRAIN",
    name = "枯萎吸收",
	info = function(self, t)
		return ([[射 出 1 枚 枯 萎 之 球， 对 目 标 造 成 %0.2f 枯 萎 伤 害。 同 时 补 充 20%% 伤 害 值 作 为 活 力。 
		 活 力 回 复 量 受 目 标 分 级 影 响（ 高 级 怪 提 供 更 多 活 力）。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 25, 200)))
	end,
}

registerTalentTranslation{
    id = "T_BLOODCASTING",
    name = "血祭施法",
	info = function(self, t)
		return ([[当 法 术 消 耗 大 于 你 当 前 的 活 力 值 时， 你 的 堕 落 系 法 术 会 用 生 命 代 替 活 力 被 消 耗， 持 续 %d 回 合。]]):
		format(t.getDuration(self,t))
	end,
}

registerTalentTranslation{
    id = "T_ABSORB_LIFE",
    name = "生命吞噬",
	info = function(self, t)
		return ([[当 你 杀 死 敌 人 时， 你 会 吸 收 目 标 生 命。 
		 当 此 技 能 激 活 时， 每 回 合 会 消 耗 0.5 点 活 力； 当 你 杀 死 一 个 非 不 死 族 单 位 时， 会 获 得 %0.1f 点 活 力（ 此 外 自 然 增 长 受 意 志 影 响）。]]):
		format(t.VimOnDeath(self, t))
	end,
}

registerTalentTranslation{
    id = "T_LIFE_TAP",
    name = "生命源泉",
	info = function(self, t)
		return ([[解 除 生 命 的 限 制 获 得 强 大 的 力 量， 增 加 %0.1f%% 所 有 伤 害， 持 续 7 回 合。]]):
		format(t.getMult(self,t))
	end,
}

return _M

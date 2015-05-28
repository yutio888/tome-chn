local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_PACIFICATION_HEX",
    name = "宁神邪术",
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 眩 晕 它 和 2 码 球 形 范 围 内 的 一 切， 持 续 3 回 合。 同 时， 每 回 合 有 %d%% 概 率 再 次 眩 晕 目 标， 持 续 20 回 合。 
		 受 法 术 强 度 影 响， 概 率 有 额 外 加 成。]]):format(t.getchance(self,t))
	end,
}

registerTalentTranslation{
    id = "T_BURNING_HEX",
    name = "燃烧邪术",
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 诅 咒 它 和 2 码 球 形 范 围 内 的 一 切， 持 续 20 回 合。 每 次 受 影 响 的 对 象 消 耗 资 源 （ 体 力、 法 力、 活 力 等 ） 时，将 会 受 到 %0.2f 点 火 焰 伤 害。 
		 同 时， 对 方 使 用 的 技 能 的 冷 却 时 间 延 长 %d%% +1 个 回 合。  
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 4, 90)), t.getCDincrease(self, t)*100)
	end,
}

registerTalentTranslation{
    id = "T_EMPATHIC_HEX",
    name = "转移邪术",
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 诅 咒 目 标 和 2 码 球 形 范 围 内 的 一 切。 每 当 目 标 造 成 伤 害 时， 它 们 也 会 受 到 %d%% 相 同 伤 害， 持 续 20 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.recoil(self,t))
	end,
}

registerTalentTranslation{
    id = "T_DOMINATION_HEX",
    name = "支配邪术",
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 使 它 成 为 你 的 奴 隶， 持 续 %d 回 合。 
		 如 果 你 对 目 标 造 成 伤 害， 则 目 标 会 脱 离 诅 咒。]]):format(t.getDuration(self, t))
	end,
}

return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILLFUL_TORMENTER",
	name = "施虐之心",
	info = function(self, t)
		return ([[你 将 精 神 集 中 于 一 个 目 标： 摧 毁 所 有 敌 人。 
		 增 加 你 %d 点 活 力 上 限。]]):
		format(t.VimBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_LOCK",
	name = "鲜血禁锢",
	info = function(self, t)
		return ([[掌 控 敌 人 的 血 液 和 肉 体。 在 2 码 范 围 内， 任 何 被 鲜 血 禁 锢 攻 击 到 的 敌 人 的 治 疗 或 回 复 将 不 能 超 过 当 前 生 命 值， 持 续 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERKILL",
	name = "赶尽杀绝",
	info = function(self, t)
		return ([[当 你 杀 死 一 个 敌 人 后， 多 余 的 伤 害 不 会 消 失。 
		 反 之 %d%% 的 伤 害 会 溅 落 在 2 码 范 围 内， 造 成 枯 萎 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.oversplash(self,t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_VENGEANCE",
	name = "血之复仇",
	info = function(self, t)
		local l, c = t.getPower(self, t)
		return ([[当 你 遭 受 到 超 过 至 少 %d%% 总 生 命 值 的 伤 害 时， 你 有 %d%% 概 率 降 低 所 有 技 能 1 回 合 冷 却 时 间。 
		 受 法 术 强 度 影 响， 概 率 有 额 外 加 成。]]):
		format(l, c)
	end,
}



return _M

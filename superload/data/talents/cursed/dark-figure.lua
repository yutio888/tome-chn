local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RADIANT_FEAR",
	name = "恐惧辉耀",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[恐 惧 %d 码 半 径 内 的 目 标 以 驱 逐 他 们， 持 续 %d 回 合。]]):format(radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_SUPPRESSION",
	name = "诅咒抑制",
	info = function(self, t)
		local percent = t.getPercent(self, t)
		return ([[长 年 对 抗 诅 咒 的 经 历 使 你 能 够 自 我 控 制。 大 部 分 非 魔 法 效 果 的 持 续 时 间 减 少 %d%% 。]]):format(percent)
	end,
}

registerTalentTranslation{
	id = "T_CRUEL_VIGOR",
	name = "残酷活力",
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 被 周 围 的 死 亡 所 鼓 舞。 你 每 杀 死 一 个 单 位 提 供 你 %d%% 的 速 度， 持 续 %d 更 多 回 合。]]):format(100 + speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_PITY",
	name = "怜悯",
	info = function(self, t)
		local range = t.range(self, t)
		return ([[你 收 起 可 怕 的 本 质 伪 装 成 可 怜 虫。 那 些 在 %d 码 外 看 到 你 的 敌 人 将 忽 略 你。 
		 当 你 攻 击 或 使 用 技 能 时， 它 们 会 看 穿 你 的 本 质， 怜 悯 技 能 将 失 效。]]):format(range)
	end,
}




return _M

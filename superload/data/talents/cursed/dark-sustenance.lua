local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FEED",
	name = "吸食精华",
	info = function(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[吸 食 敌 人 的 精 华。 只 要 目 标 停 留 在 视 野 里， 你 每 回 合 会 从 其 身 上 吸 取 %0.1f 仇 恨 值。 
		如果你没有开启吸食精华，你会自动从最近的敌人身上吸食精华。
		 受 精 神 强 度 影 响， 怒 气 吸 取 量 有 额 外 加 成。]]):format(hateGain)
	end,
}

registerTalentTranslation{
	id = "T_DEVOUR_LIFE",
	name = "吞噬生命",
	info = function(self, t)
		local regen = t.getLifeRegen(self, t)
		return ([[你的吸食效果会吸收目标的生命。降低目标%d的生命回复率，将一半的回复量加到自己身上。
		技能效果随精神强度提升。]]):format(regen)
	end,
}

registerTalentTranslation{
	id = "T_FEED_POWER",
	name = "强化吸食",
	info = function(self, t)
		local damageGain = t.getDamageGain(self, t)
		return ([[提 高 你 的 吸食 能 力， 降 低 目 标 %d%% 伤 害 并 增 加 你 自 己 同 样 数 值 的 伤 害。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):format(damageGain)
	end,
}

registerTalentTranslation{
	id = "T_FEED_STRENGTHS",
	name = "腐蚀吸食",
	info = function(self, t)
		local resistGain = t.getResistGain(self, t)
		return ([[提 高 你 的 吸食 能 力， 降 低 目 标 %d%% 负 面 状 态 抵 抗 并 增 加 你 同 样 数 值 的 状 态 抵 抗。 
		 对 “ 所 有 ” 抵 抗 无 效。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):format(resistGain)
	end,
}



return _M

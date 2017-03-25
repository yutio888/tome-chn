local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_TUNNEL",
	name = "暗影通道",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[用 一 片 黑 暗 笼 罩 你 的 亡 灵 随 从。 
		 黑 暗 会 传 送 他 们 到 你 身 边 并 使 他 们 增 加 %d%% 闪 避， 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 闪 避 率 有 额 外 加 成。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_THE_MEEK",
	name = "驯服诅咒",
	info = function(self, t)
		return ([[通 过 阴 影， 从 安 全 地 区 召 唤 %d 个 无 害 生 物。 
		 这 些 生 物 会 受 到 仇 恨 诅 咒， 吸 引 附 近 所 有 的 敌 人 的 攻 击。 
		 若 这 些 生 物 被 敌 人 杀 死， 你 有 70%% 概 率 增 加 1 个 灵 魂。]]):
		format(math.ceil(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_FORGERY_OF_HAZE",
	name = "暗影分身",
	info = function(self, t)
		return ([[你 使 用 暗 影 复 制 自 己， 生 成 一 个 分 身， 持 续 %d 回 合。 
		 你 的 分 身 继 承 你 的 天 赋 和 属 性， 继 承 %d%% 生 命 值 和 %d%% 伤 害。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_FROSTDUSK",
	name = "幽暗极冰",
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local affinity = t.getAffinity(self, t)
		return ([[ 让 幽 暗 极 冰 围 绕 你， 增 加 你 %0.1f%% 所 有 的 暗 影 系 和 冰 冷 系 伤 害 并 无 视 目 标 %d%% 暗 影 抵 抗。 
		 此 外， 你 受 到 的 所 有 暗 影 伤 害 可 治 疗 你。 治 疗 量 为 %d%% 暗 影 伤 害 值。]])
		:format(damageinc, ressistpen, affinity)
	end,
}


return _M

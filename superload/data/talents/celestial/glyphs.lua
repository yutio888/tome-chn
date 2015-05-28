local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLYPH_OF_PARALYSIS",
	name = "麻痹圣印",
	info = function(self, t)
		local dazeduration = t.getDazeDuration(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 用 光 能 在 地 上 刻 画 圣 印。 所 有 经 过 的 目 标 会 被 眩 晕 %d 回 合。 
		 圣 印 视 为 隐 藏 陷 阱 （ %d 侦 查 强 度 , %d 点 解 除 强 度 , 基 于 魔 法 ） 持 续 %d 回 合。]]):format(dazeduration, t.trapPower(self,t)*0.8, t.trapPower(self,t), duration)
	end,
}

registerTalentTranslation{
	id = "T_GLYPH_OF_REPULSION",
	name = "冲击圣印",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 用 光 能 在 地 上 刻 画 圣 印。 所 有 经 过 的 目 标 会 受 到 %0.2f 伤 害 并 被 击 退。 
		 圣 印 视 为 隐 藏 陷 阱 （ %d 侦 查 强 度 , %d 点 解 除 强 度 , 基 于 魔 法 ） 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), t.trapPower(self, t)*0.8, t.trapPower(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_GLYPH_OF_EXPLOSION",
	name = "爆炸圣印",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 用 光 能 在 地 上 刻 画 圣 印。 所 有 经 过 的 目 标 会 触 发 光 系 爆 炸， 爆 炸 对 1 码 范 围 内 的 所 有 目 标 造 成 %0.2f 伤 害。 
		 圣 印 视 为 隐 藏 陷 阱 （ %d 侦 查 强 度 , %d 点 解 除 强 度 , 基 于 魔 法 ） 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), t.trapPower(self, t)*0.8, t.trapPower(self, t)*0.8, duration)
	end,
}

registerTalentTranslation{
	id = "T_GLYPH_OF_FATIGUE",
	name = "疲劳圣印",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 用 光 能 在 地 上 刻 画 圣 印。 所 有 经 过 的 目 标 会 减 速 %d%% ， 持 续 5 回 合。 
		 圣 印 视 为 隐 藏 陷 阱 （ %d 侦 查 强 度 , %d 点 解 除 强 度 , 基 于 魔 法 ） 持 续 %d 回 合。]]):
		format(100 * slow, t.trapPower(self, t), t.trapPower(self, t), duration)
	end,
}

return _M

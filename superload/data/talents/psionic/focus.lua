local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MINDLASH",
	name = "心灵鞭笞",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[汇 聚 能 量 形 成 一 道 光 束 鞭 笞 敌 人 ，造 成 %d 点 物 理 伤 害 并 使 他 们 失 去 平 衡 两 轮 （-15%% 全 局 速 度 ）。
		受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成 。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

registerTalentTranslation{
	id = "T_PYROKINESIS",
	name = "意念燃烧",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[对 %d 范 围 内 的 所 有 敌 人 ， 用 意 念 使 组 成 其 身 体 的 分 子 活 化 并 引 燃 他 们 ， 在 6 回 合 内 造 成 %0.1f 火 焰 伤 害 。]]):
		format(radius, damDesc(self, DamageType.FIREBURN, dam))
	end,
}

registerTalentTranslation{
	id = "T_BRAIN_STORM",
	name = "头脑风暴",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[念 力 电 离 空 气 ，将 等 离 子 体 球 掷 向 敌 人 。
		等 离 子 球 会 因 碰 撞 而 爆 炸 ，造 成 半 径 为 %d 的 %0.1f 闪 电 伤 害 。
		此 技 能 将 施 加 锁 脑 状 态 。
		受 精 神 强 度 影 响，伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.LIGHTNING, dam) )
	end,
}

registerTalentTranslation{
	id = "T_IRON_WILL",
	name = "钢铁意志",
	info = function(self, t)
		return ([[ 钢 铁 意 志 提 高 %d%% 震 慑 免 疫， 并 使 得 你 每 回 合 有 %d%% 的 几 率 从 随 机 一 个 精 神 效 果 中 恢 复。]]):
		format(t.stunImmune(self, t)*100, t.cureChance(self, t)*100)
	end,
}


return _M

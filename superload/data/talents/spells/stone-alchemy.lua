local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CREATE_ALCHEMIST_GEMS",
	name = "制造炼金宝石",
	info = function(self, t)
		return ([[从 自 然 宝 石 中 制 造 40 ～ 80 个 炼 金 宝 石。 
		 许 多 法 术 需 要 使 用 炼 金 宝 石。 
		 每 种 宝 石 拥 有 不 同 的 特 效。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_EXTRACT_GEMS",
	name = "宝石提炼",
	info = function(self, t)
		local material = ""
		if self:getTalentLevelRaw(t) >=1 then material=material.."	-铁\n" end
		if self:getTalentLevelRaw(t) >=2 then material=material.."	-钢\n" end
		if self:getTalentLevelRaw(t) >=3 then material=material.."	-矮人钢\n" end
		if self:getTalentLevelRaw(t) >=4 then material=material.."	-蓝锆石\n" end
		if self:getTalentLevelRaw(t) >=5 then material=material.."	-沃瑞钽" end
		return ([[从 金 属 武 器 和 护 甲 中 提 取 宝 石。 在 此 技 能 下 你 可 以 从 以 下 材 料 中 提 取： 
		%s]]):format(material)
	end,
}

registerTalentTranslation{
	id = "T_IMBUE_ITEM",
	name = "装备附魔",
	info = function(self, t)
		return ([[在 %s 上 附 魔 宝 石（ 最 大 材 质 等 级 %d ）， 使 其 获 得 额 外 增 益。
		 你 只 能 给 每 个 装 备 附 魔 1 次， 并 且 此 效 果 是 永 久 的。]]):format(self:knowTalent(self.T_CRAFTY_HANDS) and "胸 甲、 腰 带 或 头 盔" or "胸 甲", self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_GEM_PORTAL",
	name = "宝石传送",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[使 用 5 块 宝 石 的 粉 末 标 记 一 块 不 可 通 过 区 域， 你 可 以 立 即 越 过 障 碍 物 并 出 现 在 另 一 端。 
		 有 效 范 围 %d 码。]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_STONE_TOUCH",
	name = "石化之触",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[触 摸 敌 人 使 其 进 入 石 化 状 态， 持 续 %d 回 合。 
		 石 化 状 态 的 怪 物 不 能 动 作 或 回 复 生 命， 且 非 常 脆 弱。 
		 如 果 对 石 化 状 态 的 怪 物 进 行 的 单 次 打 击， 造 成 超 过 其 30%% 生 命 值 的 伤 害， 它 会 碎 裂 并 死 亡。 
		 石 化 状 态 的 怪 物 对 火 焰 和 闪 电 有 很 高 的 抵 抗， 并 且 对 物 理 攻 击 也 会 增 加 一 些 抵 抗。 
		 等 级 3 时 触 摸 会 成 为 一 束 光 束。 
		 此 技 能 可 能 对 震 慑 免 疫 的 怪 物 无 效， 尤 其 是 石 系 怪 物 或 某 些 特 定 BOSS。]]):
		format(duration)
	end,
}


return _M

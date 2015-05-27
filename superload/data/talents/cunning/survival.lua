local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEIGHTENED_SENSES",
	name = "强化感知",
	info = function(self, t)
		return ([[你 注 意 到 他 人 注 意 不 到 的 细 节， 甚 至 能 在 阴 影 区 域 “ 看 到 ” 怪 物， %d 码 半 径 范 围。 
		 注 意 此 能 力 不 属 于 心 灵 感 应， 仍 然 受 到 视 野 的 限 制。 
		 同 时 你 的 细 致 观 察 也 能 使 你 发 现 周 围 的 陷 阱 (%d 侦 查 强 度 )。 
		 在 等 级 3 时， 你 学 会 拆 除 已 发 现 的 陷 阱 (%d 拆 除 强 度 )。 
		 受 灵 巧 影 响， 陷 阱 侦 查 强 度 和 拆 除 强 度 有 额 外 加 成。]]):
		format(t.sense(self,t),t.trapPower(self,t),t.trapPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CHARM_MASTERY",
	name = "饰品掌握",
	info = function(self, t)
		return ([[你 灵 活 的 头 脑， 使 你 可 以 更 加 有 效 的 使 用 饰 品（ 魔 杖、 图 腾 和 项 圈）， 减 少 %d%% 饰 品 的 冷 却 时 间。]]):
		format(t.cdReduc(self:getTalentLevel(t))) 
	end,
}

registerTalentTranslation{
	id = "T_PIERCING_SIGHT",
	name = "洞察视界",
	info = function(self, t)
		return ([[你 比 大 多 数 人 都 更 加 注 意 仔 细 观 察 周 围 的 动 静， 使 你 能 发 觉 隐 形 和 潜 行 的 生 物。 
		 提 升 侦 测 潜 行 等 级 %d 并 提 升 侦 测 隐 形 等 级 %d 。 
		 受 灵 巧 影 响， 你 的 侦 查 强 度 有 额 外 加 成。]]):
		format(t.seePower(self,t), t.seePower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_EVASION",
	name = "强化闪避",
	info = function(self, t)
		local chance, def = t.getChanceDef(self,t)
		return ([[你 敏 捷 的 身 手 允 许 你 预 判 即 将 到 来 的 攻 击， 允 许 你 有 %d%% 的 概 率 完 全 躲 避 它 们 并 提 供 %d 点 闪 避 ， 持 续 %d 回 合。 
		 受 意 志 影 响， 持 续 时 间 有 额 外 加 成； 
		 受 灵 巧 和 敏 捷 影 响， 闪 避 率 和 闪 避 有 额 外 加 成。]]):
		format(chance, def,t.getDur(self))
	end,
}



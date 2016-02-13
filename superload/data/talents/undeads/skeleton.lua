local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKELETON",
	name = "骷髅体质",
	info = function(self, t)
		return ([[调 整 你 的 骷 髅 体 质， 增 加 %d 点 力 量 和 敏 捷。]]):
		format(t.statBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BONE_ARMOUR",
	name = "骨质盔甲",
	info = function(self, t)
		return ([[在 你 的 周 围 制 造 一 个 能 吸 收 %d 点 伤 害 的 骨 盾。 持 续 10 回 合。 
		受 敏 捷 影 响， 护 盾 的 最 大 吸 收 值 有 额 外 加 成。]]):
		format(t.getShield(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RESILIENT_BONES",
	name = "弹力骨骼",
	info = function(self, t)
		return ([[你 的 骨 头 充 满 弹 性， 至 多 减 少 %d%% 所 有 负 面 状 态 持 续 的 时 间。]]):
		format(100 * t.durresist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKELETON_REASSEMBLE",
	name = "重组",
	info = function(self, t)
		return ([[重 新 组 合 你 的 骨 头， 治 疗 你 %d 点 生 命 值。 
		在 等 级 5 时 你 将 会 得 到 重 塑 自 我 的 能 力， 被 摧 毁 后 可 以 原 地 满 血 复 活。（ 仅 限 1 次）]]):
		format(t.getHeal(self, t))
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEAL",
	name = "奥术重组",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 你 的 身 体 充 满 奥 术 能 量， 将 其 重 组 为 原 始 状 态， 治 疗 %d 点 生 命 值。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_SHIELDING",
	name = "强化护盾",
	info = function(self, t)
		local shield = t.getShield(self, t)
		local dur = t.getDur(self, t)
		return ([[使 你 的 周 身 围 绕 着 强 烈 的 奥 术 能 量。 
		 你 的 每 个 伤 害 护 盾、 时 间 护 盾、 转 移 护 盾、 干 扰 护 盾 的 强 度 上 升 %d%% 。 
		 在 等 级 5 时， 它 会 增 加 1 回 合 所 有 护 盾 的 持 续 时 间。 
		 受 法 术 强 度 影 响， 护 盾 强 度 有 额 外 加 成。]]):
		format(shield, dur)
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_SHIELD",
	name = "奥术护盾",
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[使 你 的 周 身 围 绕 着 保 护 性 的 奥 术 能 量。 
		 每 当 你 获 得 一 个 直 接 治 疗 时（ 非 持 续 恢 复 效 果） 你 会 自 动 获 得 一 个 护 盾， 护 盾 强 度 为 治 疗 量 的 %d%% ， 持 续 3 回 合。 
		 如 果 新 护 盾 的 量 和 持 续 时 间 比 当 前 护 盾 大 或 相 等，将 会 取 代 之。
		 受 法 术 强 度 影 响， 护 盾 强 度 有 额 外 加 成。]]):
		format(shield)
	end,
}

registerTalentTranslation{
	id = "T_AEGIS",
	name = "守护印记",
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[释 放 奥 术 能 量 充 满 当 前 保 护 你 的 魔 法 护 盾， 进 一 步 强 化 它， 提 高 %d%% 最 大 伤 害 吸 收 值。 
		 它 会 影 响 最 多 %d 种 护 盾 效 果。 
		 可 被 充 能 的 护 盾 有： 伤 害 护 盾， 时 间 护 盾， 转 移 护 盾 和 干 扰 护 盾。 
		 受 法 术 强 度 影 响， 充 能 强 度 有 额 外 加 成。]]):
		format(shield, t.getNumEffects(self, t))
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OSMOSIS_SHIELD",
	name = "渗透护盾",
	info = function(self, t)
		return ([[你 的 盾 牌 充 满 了 恶 魔 能 量 ，带 来 一 层 魔 法 护 盾 ，每 回 合 受 到 第 一 次 伤 害 时 给 予 你 持 续 3 回 合 的 治 疗 （基 于 格 挡 值 ），治 疗 效 果 可 以 叠 加 。
		 治 疗 量 等 于 5+ %d%% 格 挡 值 （当 前 %d 点 ）。
		 技 能 等 级 3 时 ，如 果 伤 害 在 治 疗 量 两 倍 以 上 ，有 %d%% 几 率 解 除 你 一 个 负 面 物 理 状 态 。
		 在 休 息 和 跑 步 时 ，该 技 能 自 动 终 止 。
		#{bold}#开 启 护 盾 不 消 耗 时 间 ，关 闭 护 盾 消 耗 时 间 。#{normal}#]])
		:format(self:combatTalentLimit(t, 50, 15, 40), t.getAbsorb(self, t), t.getChance(self, t))
	end,
}


registerTalentTranslation{
	id = "T_HARDENED_CORE",
	name = "硬化之核",
	info = function(self, t)
		return ([[从 恶 魔 家 乡 中 学 习 ，强 化 自 身 。
		 增 加 10 + %d%% 总 护 甲 值 ,每 点 力 量 提 供 %d%% 法 术 强 度 。]]):
		format((self:combatTalentScale(t, 1.1, 1.6)-1) * 100, self:combatTalentScale(t, 20, 40, 0.75))
	end,
}


registerTalentTranslation{
	id = "T_DEMONIC_MADNESS",
	name = "疯狂旋转",
	info = function(self, t)
		return ([[你 疯 狂 旋 转 你 的 盾 牌 ，攻 击 周 围 生 物 ，造 成 %d%% 暗 影 盾 牌 伤 害 并 使 其 混 乱 %d 回 合 。
		 技 能 等 级 4 时 ，你 自 动 进 入 格 挡 状 态 。]]):
		format(t.getDam(self, t) * 100, t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_BLIGHTED_SHIELD",
	name = "枯萎能量",
	info = function(self, t)
		return ([[你 的 盾 牌 充 满 强 大 的 枯 萎 能 量 。每 次 你 格 挡 并 附 加 反 击 状 态 时 ，目 标 将 被 虚 弱 诅 咒 感 染 ， 5 回 合 内 降 低 %d%% 伤 害。
		 效 果 受 法 术 强 度 加 成 。]]):format(t.imppower(self,t))
	end,
}


return _M

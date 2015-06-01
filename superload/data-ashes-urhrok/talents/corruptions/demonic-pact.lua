local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEMON_SEED",
	name = "恶魔之种",
	info = function(self, t)
		local shield, weapon = t.getDam(self, t)
		return ([[对 目 标 造 成 %d%% 枯 萎 武 器 伤 害 。如 果 攻 击 命 中 ，你 将 用 盾 牌 攻 击 目 标 ，造 成 %d%% 盾 牌 伤 害 并 眩 晕 %d 回 合。
		 如 果 武 器 命 中 并 且 没 有 杀 死 目 标 ，一 个 恶 魔 之 种 将 试 图 进 入 目 标 的 体 内 。
		 种 子 需 要 足 够 强 大 的 宿 主 来 成 长 。存 活 几 率 ：
			 普 通 生 物 		5%%
			 精 英 生 物 		20%%
			 稀 有 与 史 诗 生 物 	50%%	
			 Boss 			100%%
		 种 子 只 能 寄 生 在 有 经 验 的 生 物 里 ，不 能 寄 生 在 召 唤 物 中 。
		 当 宿 主 死 亡 时 ，种 子 将 吸 收 宿 主 的 活 力 ，成 长 为 一 个 特 定 的 恶 魔 种 子 ，能 用 于 召 唤 恶 魔 。
		 如 果 已 有 更 高 级 的 恶 魔 种 子 ，你 将 不 能 制 造 同 类 型 的 低 级 恶 魔 种 子 。
		 高 技 能 等 级 将 带 来 更 强 大 的 种 子。]])
		:format(weapon * 100, shield * 100, t.getDazeDuration(self, t))
	end,
}


registerTalentTranslation{
	id = "T_BIND_DEMON",
	name = "恶魔结合",
	info = function(self, t)
		return ([[你 能 通 过 恶 魔 种 子 来 临 时 召 唤 恶 魔 %d 回 合 。
		 召 唤 出 来 的 恶 魔 能 回 复 生 命 ，并 且 保 持 上 一 次 召 唤 结 束 时 的 生 命 值 。
		 如 果 恶 魔 死 亡 ，将 不 能 再 使 用 同 一 个 种 子 进 行 召 唤 。

		 随 着 你 对 恶 魔 力 量 的 了 解 更 加 深 入 ，你 能 将 更 多 的 种 子 与 你 的 装 备 结 合 。
		 技 能 等 级 2 时 你 能 将 种 子 与 第 一 个 戒 指 结 合 。
		 技 能 等 级 3 时 你 能 将 种 子 与 盾 牌 结 合 。
		 技 能 等 级 4 时 你 能 将 种 子 与 第 二 个 戒 指 结 合 。
		 技 能 等 级 5 时 你 能 将 种 子 与 护 甲 结 合 。
		]]):
		format(t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_TWISTED_PORTAL",
	name = "扭曲传送",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[传 送 自 己 %d 码 ，误 差 %d 。
		 在 离 开 的 位 置 ，你 将 随 机 召 唤 一 个 恶 魔 ，持 续 %d 回 合 。
		 如 果 目 标 地 点 不 在 视 线 内 ，有 一 定 几 率 失 败 。
		 该 技 能 需 要 至 少 一 个 未 召 唤 的 存 活 的 恶 魔 种 子 。
		 传 送 半 径 受 法 术 强 度 加 成 。]]):format(range, radius, t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_SUFFUSE_LIFE",
	name = "生命能量",
	info = function(self, t)
		local healpct, rezchance, leech = t.getVals(self, t)
		return ([[你 吸 取 敌 方 生 物 的 生 命 来 治 疗 恶 魔 种 子 和 你 。
		 每 次 你 杀 死 生 物 时 ，一 个 随 机 的 生 命 不 足 100%% 的 恶 魔 种 子 将 受 到 %d%% 生 命 值 的 治 疗 。
		 如 果 该 生 物 是 精 英 或 者 更 高 级 别 ，你 有 %d%% 几 率 复 活 一 个 死 亡 的 恶 魔 种 子 。
		 技 能 等 级 4 时 ，你 开 始 学 会 治 疗 自 身 ，每 次 造 成 伤 害 时 回 复 自 身 %d%% 伤 害 值 的 生 命 。]]):
		format(healpct, rezchance, leech)
	end,
}


return _M

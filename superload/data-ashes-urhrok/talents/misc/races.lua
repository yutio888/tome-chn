local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HASTE_OF_THE_DOOMED",
	name = "加速",
	info = function(self, t)
		local v = t.getPower(self, t)
		return ([[加 速 自 身 ， 以 至 于 脱 离 空 间 ， 传 送 半 径 %d 。
		你 在 同 一 回 合 内 至 多 连 用 两 次 该 技 能，且 第 二 次 使 用 会 消 耗 时 间。
		之 后 ， 你 停 留 在 相 位 外 5 回 合 ， 闪 避 增 加 %d , 全 体 抗 性 增 加 %d%% 。
		效 果 受 意 志 加 成。]]):
		format(self:getTalentRange(t), v, v)
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE_OF_THE_DOOMED",
	name = "强韧",
	info = function(self, t)
		return ([[你 在 恶 魔 空 间 忍受 的 折 磨 让 你 更 加 强 韧。
		所 有 负 面 状 态 持 续 时 间 减 少 %d%% , 同 时 你 能 摆 脱 %d%% 暴 击 伤 害 。]]):
		format(t.effectsReduce(self, t), t.critResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTION_OF_THE_DOOMED",
	name = "腐化",
	info = function(self, t)
		return ([[你 原 本 的 隐 身 技 能 被 腐 化 扭 曲 了 。
		 当 你 受 到 一 次 伤 害 超 过 10%% 总 生 命 值 时 ，有 %d%% 几 率 转 变 成 多 瑟 顿 形 态 5 回 合 。
		 在 多 瑟 顿 形 态 下 ：
		-  你 获 得 永 久 潜 行 (强 度 %d )
		-  你 的 暗 影 伤 害 增 加 %d%%
		-  每 当 你 造 成 超 过 %d 点 的 非 物 理 非 精 神 伤 害 时 ，在 半 径 1 的 范 围 内 产 生 一 次 暗 影 爆 炸 ，造 成 额 外 50%% 伤 害 （每 回 合 至 多 1 次 ）。
		-  变 形 时 重 置 种 族 技 能 “加 速 ”与 种 族 技 能 “无 情 ”
		]]):
		format(t.getChance(self, t), t.getStealth(self, t), t.getDarkness(self, t), t.getThreshold(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PITILESS",
	name = "无情",
	info = function(self, t)
		return ([[你 对 目 标 的 精 神 进 行 冲 击 。
		 他 所 有 正 在 冷 却 中 的 技 能 冷 却 时 间 延 长 %d 回 合 ，所 有 负 面 魔 法 、物 理 、精 神 效 果 延 长 %d 回 合 ，所 有 正 面 魔 法 、物 理 、精 神 效 果 缩 短 %d 回 合 。]]):
		format(t.getEffectGood(self, t), t.getEffectBad(self, t), t.getEffectGood(self, t))
	end,
}


return _M

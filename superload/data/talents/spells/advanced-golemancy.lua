local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GOLEMANCY_LIFE_TAP",
	name = "生命分流",
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你 汲 取 傀 儡 的 生 命 能 量 来 恢 复 自 己。 恢 复 %d 点 生 命。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_GEM_GOLEM",
	name = "宝石傀儡",
	info = function(self, t)
		return ([[在 傀 儡 身 上 镶 嵌 2 颗 宝 石， 它 可 以 得 到 宝 石 加 成 并 改 变 近 战 攻 击 类 型。 你 可 以 移 除 并 镶 嵌 不 同 种 类 的 宝 石， 移 除 行 为 不 会 破 坏 宝 石。 
		 可 用 宝 石 等 级： %d
		 宝 石 会 在 傀 儡 的 物 品 栏 中 改 变 成 功 。 ]]):format(self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_SUPERCHARGE_GOLEM",
	name = "超能傀儡",
	info = function(self, t)
		local regen, turns, life = t.getPower(self, t)
		return ([[你 激 活 傀 儡 的 特 殊 模 式， 提 高 它 每 回 合 %0.2f 生 命 回 复 速 度， 持 续 %d 回 合。 
		 如 果 你 的 傀 儡 死 亡， 它 会 立 刻 复 活， 复 活 时 保 留 %d%% 生 命 值。 
		 此 技 能 激 活 时 你 的 傀 儡 处 于 激 怒 状 态， 可 增 加 25%% 伤 害。]]):
		format(regen, turns, life)
	end,
}

registerTalentTranslation{
	id = "T_RUNIC_GOLEM",
	name = "符文傀儡",
	info = function(self, t)
		return ([[增 加 傀 儡 %0.2f 生 命、 法 力 和 耐 力 回 复。 
		 在 等 级 1 、 3 、 5 时， 傀 儡 会 增 加 1 个 新 的 符 文 孔。 
		 即 使 没 有 此 天 赋， 傀 儡 默 认 也 有 3 个 符 文 孔。]]):
		format(self:getTalentLevelRaw(t))
	end,
}


return _M

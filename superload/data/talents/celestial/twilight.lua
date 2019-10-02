local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TWILIGHT",
	name = "黄昏",
	info = function(self, t)
		return ([[你 处 于 黑 暗 和 光 明 之 间， 能 够 将 15 点 正 能 量 转 化 为 %d 负 能 量。 
		 此 外， 这 也 会 影 响 正 负 能 量 的 固 有 值， 数 值 为 它 们 最 大 值 的 %d%% 。 
		 每 回 合 正 负 能 量 值 会 缓 慢 的 上 升 / 下 降， 而 不 是 归 0 。 
		 受 灵 巧 影 响， 效 果 有 额 外 加 成。]]):
		format(t.getNegativeGain(self, t), t.getRestValue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE_TELEPORT",
	name = "跃迁之门：传送",
	info = function(self, t)
		return ([[在 %d 码 范 围 以 内 你 可 以 立 即 传 送 至 你 的 跃 迁 之 门。]]):format(t.getRange(self, t))
 	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE",
	name = "跃迁之门",
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[在 你 的 位 置 制 造 1 个 阴 影 跃 迁 之 门， 当 你 激 活 这 个 技 能 时 你 可 以 使 用 跃 迁 之 门： 传 送 技 能 将 你 传 送 至 此（ 跃 迁 之 门 必 须 在 你 %d 码 范 围 以 内）。 
		 注 意： 当 此 技 能 激 活 且 楼 梯 位 于 跃 迁 之 门 下 方 时， 楼 梯 将 不 可 使 用。 你 必 须 取 消 此 技 能 方 可 使 用 楼 梯 离 开 该 区 域。 
		 在 等 级 4 时， 你 可 以 制 造 2 个 跃 迁 之 门。]]):format(range)
 	end,
}

registerTalentTranslation{
	id = "T_MIND_BLAST",
	name = "心灵震爆",
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		return ([[在 %d 码 半 径 范 围 内 释 放 一 股 精 神 冲 击 ， 摧 毁 目 标 的 意 志 ， 对 其 造 成 %0.2f 暗 影 伤 害， 并 使 其 混 乱 ( %d%% 几 率 随 机 行 动 ）， 持 续 %d 回 合 。
		伤 害 受 法 术 强 度 加 成 ， 持 续 时 间 受 灵 巧 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getConfuseEfficency(self,t), duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_SIMULACRUM",
	name = "阴影幻象",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[用 阴 影 复 制 一 个 敌 对 目 标 的 幻 象  。 这 个 幻 象 会 立 刻 攻 击 它 的 原 型 ， 持 续 %d 回 合 。
		幻 象 拥 有 %d%% 的 目 标 生 命， +50%% 暗 影 伤 害 抵 抗， -50%% 光 系 伤 害 抵 抗 ， 造 成 -50%% 的 伤 害。
		持 续 时 间 和 幻 象 生 命 受 你 的 灵 巧 加 成。]]):
		format(duration, t.getPercent(self, t))
	end,
}
registerTalentTranslation{
	id = "T_JUMPGATE_TWO",
	name = "跃迁之门II",
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT_TWO)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[在 你 当 前 位 置 创 造 第 2 个 跃 迁 之 门， 你 可 以 使 用 跃 迁 之 门： 传 送 技 能 将 你 传 送 至 这 个 位 置， 距 离 不 超 过 %d 码。]]):format(range)
	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE_TELEPORT_TWO",
	name = "跃迁之门：传送II",
	info = function(self, t)
		return ([[立 即 传 送 你 至 先 前 创 造 的 第 2 个 跃 迁 之 门， 距 离 不 超 过 %d 码。]]):format(t.getRange(self, t))
	end,
}

return _M

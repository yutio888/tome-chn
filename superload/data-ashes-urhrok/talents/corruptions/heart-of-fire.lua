local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BURNING_SACRIFICE",
	name = "燃烧献祭",
	info = function(self, t)
	local mult = t.getMult(self, t) * 100
	local dam = t.getDam(self, t) * 100
	return ([[每 次 你 击 杀 一 个 燃 烧 的 敌 对 生 物 时 ，会 立 刻 对 一 个 随 机 相 邻 敌 对 生 物 进 行 一 次 攻 击， 造 成 %d%% 武 器 伤 害。
	另 外 ， 焚 尽 强 击 必 定 被 此 效 果 触 发 （ 或 者 下 一 次 攻 击 ） ，对 所 有 击 中 的 敌 对 生 物 造 成 %d%% 倍 伤 害。
	此 效 果 每 5 回 合 才 能 触 发 一 次 。]]):format(dam, mult)
	end,
}


registerTalentTranslation{
	id = "T_DEVOURING_FLAMES",
	name = "火焰守护",
	info = function(self, t)
	return ([[吸 取 燃 烧 中 的 烈 焰 ， 将 自 己 包 裹 其 中。
	除 去 半 径 5 内 的 敌 方 生 物 身 上 的 燃 烧 效 果 ， 同 时 制 造 一 层 持 续 %d 轮 的 %d 强 度 的 护 盾 ， 每 吸 收 一 层 燃 烧 效 果 护盾 强 度 增 加 15%% 。
	当 护 盾 效 果 结 束 时 ， 将 在 半 径 %d 范 围 内 释 放 一 次 火 焰 爆 炸 ， 灼 烧 周 围 生 物 3 回 合 ， 造 成 等 于 护 盾 初 始 值 的 伤 害 。]]):format(t.getDur(self, t), t.getBaseShield(self, t), t.getRange(self, t))
	end,
}


registerTalentTranslation{
	id = "T_INFERNO_NEXUS",
	name = "吞噬之焰",
	info = function(self, t)
	return ([[恶 魔 之 炎 抚 育 你 成 长 。 每 次 你 近 战 攻 击 命 中 时 ， 你 对 目 标 施 加 诅 咒 ， 只 要 其 处 于 燃 烧 状 态 ， 你 每 回 合 获 得 %0.2f 生 命 与 %0.2f 活 力 。 
	同 时，在 你 周 围 10 码 范 围 内 ，所 有 被 诅 咒 火 焰 燃 烧 的 敌 方 生 物 会 将 诅 咒 传 播 至 半 径 1 内 的 燃 烧 生 物 上 ，并 造 成 %d 火 焰 伤 害 同时 给 予 你 等 量 治 疗。]]):format(t.getHeal(self, t), t.getVim(self, t),  t.getDam(self, t))
	end,
}

		

registerTalentTranslation{
	id = "T_BLAZING_REBIRTH",
	name = "烈焰重生",
	info = function(self, t)
	return ([[生 命 值 恢 复 为 满 值 ， 但 治 疗 值 转 化 为 持 续 %d 回 合 的 伤 害 。 
	伤 害 会 平 均 分 配 给 你 自 己 和 %d 码 范 围 内 的 燃 烧 敌 对 生 物。
	你 受 到 的 伤 害 无 法 减 免 ， 敌 对 生 物 受 到 火 焰 伤 害。]]):format(t.getDur(self, t), t.getRange(self, t))
	end,
}


return _M

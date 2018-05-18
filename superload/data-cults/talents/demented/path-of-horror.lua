local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_CARRION_FEET",
	name = "蠕动之足",
	info = function(self, t)
		return ([[蠕 虫 在 你 脚 下 不 断 产 生，它们 在 你 行 走 的 时 候  不 断 爆 裂， 被 动 地 增 加 你 %d%% 移 动 速 度。
		你 也 可 以 激 活 这 个 天 赋 来 引 爆 更 多 的 蠕 虫 ， 让 你 跳 跃 到 %d 码 外 的 可 见 地 形 。
		着 陆 时 会 有 更 多 的 蠕 虫 爆 裂， 形 成 范 围 2 码 的 脓 液 喷 射  ； 范 围 内 的 生 物 下 回 合 造 成 的 伤 害 降 低 70%% 。
		如 果 有 敌 人 受 到 脓 液 喷 射 的 影 响 ， 你 会 得 到 额 外 20 点 疯 狂 值。]]):
		format(t.getPassiveSpeed(self, t)*100, self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	name = "恐怖进化",
	id = "T_DECAYING_GUTS",
	info = function(self, t)
		return ([[你 的 突 变 强 化 了 你的 攻 击 能 力。
		你 获 得 %d 命 中 和 %d 法 术 强 度 。
		技 能 效 果 会 随 着 你 的 魔 法 属 性 增 强。]])
		:format(t.getAccuracy(self, t), t.getSpellpower(self, t))
	end,
}

registerTalentTranslation{
	name = "巨型变异", 
	id = "T_CULTS_OVERGROWTH",
	info = function(self, t)
		return ([[你 激 发 了 一 次 持 续 %d 回 合 的 体 细 胞 急 速 变 异。
		你 的 身 体 急 速 变 大 ， 获 得 + 2 体 型 ， 并 使 你 能 够 在 行 走 时 随 意 撞 碎 墙 壁 。 增 加 %d%% 全 体 伤 害 和 %d%% 全 体 伤 害 抗 性。
		你 的 巨 大 体 型 使 你 在 每 次 行 走 时 都 导 致 一 场 小 型 的 地 震 ， 破 坏 并 重 组 周 围 的 地 形 。]]):
		format(t.getDur(self, t), t.getDam(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_ONE",
	name = "终极异变",
	info = function(self, t)
		return ([[你 终 于 解 开 了 这 具 变 异 身 体 的 最 终 力 量！
		你 获 得 %d%% 震 慑 免 疫 , %d%% 几 率 无 视 受 到 的 暴 击， 并 且 增 加 %d%% 黑 暗 及 枯 萎 伤 害。]]):
		format(t.getImmunities(self, t) * 100, t.getCritResist(self, t), t.getDam(self, t))
	end,
}

return _M

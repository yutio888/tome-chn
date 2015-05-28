local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONGEAL_TIME",
	name = "时间凝固",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local proj = t.getProj(self, t)
		return ([[制 造 一 个 扭 曲 时 间 的 力 场， 减 少 目 标 %d%% 的 整 体 速 度， 目 标 所 释 放 的 抛 射 物 减 速 %d%% ， 持 续 7 回 合。]]):
		format(100 * slow, proj)
	end,
}

registerTalentTranslation{
	id = "T_TIME_SHIELD",
	name = "时光之盾",
	info = function(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		local time_reduc = t.getTimeReduction(self,t)
		return ([[这 个 复 杂 的 法 术 在 施 法 者 周 围 立 刻 制 造 一 个 时 间 屏 障， 吸 收 你 受 到 的 伤 害。 
		 一 旦 达 到 最 大 伤 害 吸 收 值（ %d ） 或 持 续 时 间（ %d 回 合） 结 束， 存 储 的 能 量 会 治 疗 你， 持 续 5 回合 ，每 回 合 回 复 总 吸 收 伤 害 的 10%% ( 强 化 护 盾 技 能 会 影 响 该 系 数 )。   
		 当 激 活 时 光 之 盾 时， 所 有 新 获 得 的 负 面 魔 法、 物 理 和 精 神 效 果 都 会 减 少 %d%% 回 合 的 持 续 时 间。 
		 受 法 术 强 度 影 响， 最 大 吸 收 值 有 额 外 加 成。 ]]):
		format(maxabsorb, duration, time_reduc)
	end,
}

registerTalentTranslation{
	id = "T_TIME_PRISON",
	name = "时光之牢",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[将 目 标 从 时 光 的 流 动 中 移 出， 持 续 %d 回 合。 
		 在 此 状 态 下， 目 标 不 能 动 作 也 不 能 被 伤 害。 
		 对 于 目 标 来 说， 时 间 是 静 止 的， 技 能 无 法 冷 却， 也 没 有 能 量 回 复 … … 
		 受 法 术 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_OF_SPEED",
	name = "时间加速",
	info = function(self, t)
		local haste = t.getHaste(self, t)
		return ([[增 加 施 法 者 %d%% 整 体 速 度。]]):
		format(100 * haste)
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INVOKE_DARKNESS",
	name = "黑夜降临",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 出 一 片 黑 暗， 对 目 标 造 成 %0.2f 暗 影 伤 害。 
		 在 等 级 3 时， 它 会 生 成 暗 影 射 线。 
		 在 等 级 5 时， 你 的 黑 夜 降 临 系 法 术 不 会 再 伤 害 亡 灵 随 从。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_DEATH",
	name = "死亡之环",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从 地 上 召 唤 出 持 续 5 回 合 的 黑 暗 之 雾。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。 
		 任 何 生 物 走 进 去 都 会 吸 入 混 乱 毒 素 或 致 盲 毒 素。 
		 对 1 个 生 物 每 次 只 能 产 生 1 种 毒 素 效 果。 
		 毒 素 效 果 持 续 %d 回 合 并 造 成 %0.2f 暗 影 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getBaneDur(self,t), damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_FEAR_THE_NIGHT",
	name = "暗夜恐惧",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 前 方 锥 形 范 围 内 造 成 %0.2f 暗 影 伤 害（ %d 码 半 径 范 围）。 
		 任 何 受 影 响 的 怪 物 须 进 行 一 次 精 神 豁 免 鉴 定， 否 则 会 被 击 退 4 码 以 外。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_RIGOR_MORTIS",
	name = "尸僵症",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dur = t.getDur(self, t)
		local minion = t.getMinion(self, t)
		return ([[发 射 1 个 黑 暗 之 球 在 范 围 内 造 成 %0.2f 暗 影 系 伤 害（ %d 码 半 径）。 
		 被 击 中 的 目 标 将 会 感 染 尸 僵 症 并 减 少 整 体 速 度： %d%% 。 
		 亡 灵 随 从 对 这 些 目 标 额 外 造 成 伤 害： %d%% 。 
		 此 效 果 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 你 的 伤 害 和 亡 灵 随 从 的 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t), speed, minion, dur)
	end,
}


return _M

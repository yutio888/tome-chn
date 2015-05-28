local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FLAME",
	name = "火球术",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 一 个 火 球， 使 目 标 进 入 灼 烧 状 态 并 在 3 回 合 内 造 成 %0.2f 火 焰 伤 害。 
		 在 等 级 5 时， 火 焰 会 有 穿 透 效 果。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_FLAMESHOCK",
	name = "火焰冲击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local stunduration = t.getStunDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 前 方 制 造 一 片 %d 码 半 径 锥 形 范 围 的 火 焰。 
		 任 何 在 此 范 围 的 目 标 会 被 燃 烧 的 火 焰 震 慑 ， 共 受 到 %0.2f 点 火 焰 伤 害，持 续 %d 回 合。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage), stunduration)
	end,
}

registerTalentTranslation{
	id = "T_FIREFLASH",
	name = "爆裂火球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向 你 的 目 标 发 射 一 枚 爆 裂 火 球， 造 成 %0.2f 火 焰 伤 害， 有 效 范 围 %d 码。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_INFERNO",
	name = "地狱火",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向 地 上 释 放 一 片 火 焰， 每 回 合 可 对 敌 我 双 方 造 成 %0.2f 火 焰 伤 害， 半 径 %d 码， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius, duration)
	end,
}


return _M

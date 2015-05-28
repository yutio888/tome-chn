local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GRASPING_MOSS",
	name = "减速苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local slow = t.getSlow(self, t)
		local pin = t.getPin(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下， 半 径 %d 的 范 围 内 生 长 出 苔 藓。 
		 每 回 合 苔 藓 对 半 径 内 的 敌 人 会 造 成 %0.2f 点 自 然 伤 害。 
		 这 种 苔 藓 又 厚 又 滑， 所 有 经 过 的 敌 人 的 移 动 速 度 会 被 降 低 %d%% ， 并 有 %d%% 概 率 被 定 身 4 回 合。 
		 苔 藓 持 续 %d 个 回 合。 
		 苔 藓 系 技 能 无 需 使 用 时 间， 但 会 让 同 系 其 他 技 能 进 入 3 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), slow, pin, duration)
	end,
}

registerTalentTranslation{
	id = "T_NOURISHING_MOSS",
	name = "生命苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local heal = t.getHeal(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在 你 的 脚 下， 半 径 %d 的 范 围 内 生 长 出 苔 藓。 
		 每 回 合 苔 藓 对 半 径 内 的 敌 人 会 造 成 %0.2f 点 自 然 伤 害。 
		 这 种 苔 藓 具 有 吸 血 功 能， 会 治 疗 使 用 者， 数 值 等 于 造 成 伤 害 的 %d%% 。 
		 苔 藓 持 续 %d 个 回 合。 
		 苔 藓 系 技 能 无 需 使 用 时 间， 但 会 让 同 系 其 他 技 能 进 入 3 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), heal, duration)
	end,
}

registerTalentTranslation{
	id = "T_SLIPPERY_MOSS",
	name = "光滑苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local fail = t.getFail(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在 你 的 脚 下， 半 径 %d 的 范 围 内 生 长 出 苔 藓。 
		 每 回 合 苔 藓 对 半 径 内 的 敌 人 会 造 成 %0.2f 点 自 然 伤 害。 
		 这 种 苔 藓 十 分 光 滑， 会 使 所 有 受 影 响 的 敌 人 有 %d%% 概 率 不 能 做 出 复 杂 行 动。
		 苔 藓 持 续 %d 个 回 合。 
		 苔 藓 系 技 能 无 需 使 用 时 间， 但 会 让 同 系 其 他 技 能 进 入 3 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), fail, duration)
	end,
}

registerTalentTranslation{
	id = "T_HALLUCINOGENIC_MOSS",
	name = "迷幻苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local power = t.getPower(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在 你 的 脚 下， 半 径 %d 的 范 围 内 生 长 出 苔 藓。 
		 每 回 合 苔 藓 对 半 径 内 的 敌 人 会 造 成 %0.2f 点 自 然 伤 害。 
		 这 种 苔 藓 上 沾 满 了 奇 怪 的 液 体， 有 %d%% 概 率 让 对 方 混 乱 （ %d%% 强 度） 2 个 回 合。  
		 苔 藓 持 续 %d 个 回 合。 
		 苔 藓 系 技 能 无 需 使 用 时 间， 但 会 让 同 系 其 他 技 能 进 入 3 回 合 的 冷 却。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), chance, power, duration)
	end,
}


return _M

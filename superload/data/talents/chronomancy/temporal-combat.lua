local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FOLD_FATE",
	name = "命运折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local resists = t.getResists(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 你 用 武 器 折 叠 命 中 时 ，有 %d%% 几 率 在 半 径 %d 内 造 成 额 外 %0.2f 时 空 伤 害 。
		 受 影 响 的 生 物 可 能 减 少 %d%% 物 理 和 时 空 抗 性 %d 回 合 。
		 这 个 效 果 有 冷 却 时 间 。当 处 于 冷 却 状 态 被 触 发 时 ，会 减 少 重 力 折 叠 和 扭 曲 折 叠 1 回 合 冷 却 时 间 。]])
		:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage), resists, duration)
	end,
}

registerTalentTranslation{
	id = "T_FOLD_WARP",
	name = "扭曲折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[当 你 用 武 器 折 叠 命 中 时 ，有 %d%% 几 率 在 半 径 %d 内 造 成 额 外 %0.2f 物 理 和 %0.2f 时 空 伤 害 。
		 受 影 响 的 生 物 可 能 被 震 慑 、 致 盲 、 定 身 或 混 乱 %d 回 合 。
		 这 个 效 果 有 冷 却 时 间 。当 处 于 冷 却 状 态 被 触 发 时 ，会 减 少 重 力 折 叠 和 命 运 折 叠 1 回 合 冷 却 时 间 。]])
		:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

registerTalentTranslation{
	id = "T_FOLD_GRAVITY",
	name = "重力折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 你 用 武 器 折 叠 命 中 时 ，有 %d%% 几 率 在 半 径 %d 内 造 成 额 外 %0.2f 物 理( 重 力) 伤 害 。
		 受 影 响 的 生 物 可 能 被 减 速 %d%% ，持 续 %d 回 合 。
		 这 个 效 果 有 冷 却 时 间 。当 处 于 冷 却 状 态 被 触 发 时 ，会 减 少 扭 曲 折 叠 和 命 运 折 叠 1 回 合 冷 却 时 间 。]])
		:format(chance, radius, damDesc(self, DamageType.PHYSICAL, damage), slow, duration)
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_FOLDING",
	name = "武器折叠",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local chance = t.getChance(self, t)
		return ([[将 时 空 折 叠 在 武 器 \ 弹 药 上，造 成 额 外 %0.2f 时 空 伤 害。
		同 时 武 器 命 中 时 你 有 %d%% 几 率 获 得 10%% 回 合 的 时 间 。
		伤 害 受 法 术 强 度 加 成 。]]):format(damDesc(self, DamageType.TEMPORAL, damage), chance)
	end,
}

registerTalentTranslation{
	id = "T_INVIGORATE",
	name = "鼓舞",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[接 下 来 的 %d 回 合 里 ， 你 回 复 %0.1f 生 命 ， 同 时 不 具 有 固 定 冷 却 时 间 的 技 能 会 加 倍 冷 却 速 度 。
		生 命 回 复 受 法 术 强 度 加 成 。]]):format(duration, power)
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_MANIFOLD",
	name = "多态武器",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		local resists = t.getResists(self, t)
		return ([[你 现 在 有 %d%% 几 率 将 命 运 、重 力 或 扭 曲 之 力 折 叠 进 你 的 武 器 。
		 命 运 ：半 径 %d 内 造 成 %0.2f 时 空 伤 害 ，并 降 低 %d%% 物 理 和 时 空 抗 性 。
		 扭 曲 ：半 径 %d 内 造 成 %0.2f 物 理 %0.2f 时 空 伤 害 ，并 可 能 震 慑 、致 盲 、混 乱 或 者 定 身 %d 回 合 。
		 重 力 ：半 径 %d 内 造 成 %0.2f 物 理 伤 害 ，并 减 速 （ %d%% ） %d 回 合 。
		 每 项 效 果 有 8 回 合 冷 却 时 间 。
		 当 处 于 冷 却 中 的 效 果 被 触 发 时 ，将 减 少 另 外 两 个 效 果 的 冷 却 1 回 合 。]])
			:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage), resists, radius, damDesc(self, DamageType.PHYSICAL, damage/2), damDesc(self, DamageType.TEMPORAL, damage/2), duration, radius,
		 damDesc(self, DamageType.PHYSICAL, damage), slow, duration)
	end,
}

registerTalentTranslation{
	id = "T_BREACH",
	name = "破灭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[ 使 用 远 程 或 近 战 武 器 攻 击 目 标，造 成 %d%% 武 器 伤害 。
		如 果 攻 击 命 中 ， 你 将 摧 毁 目 标 的 防 御 ， 减 半 护 甲 硬 度 ， 震 慑 定 身 致 盲 混 乱 免 疫。]])
		:format(damage, duration)
	end,
}

return _M

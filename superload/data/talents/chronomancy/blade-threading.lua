local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARP_BLADE",
	name = "扭曲灵刃",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[使 用 你 的 近 战 武 器 攻 击 敌 人 ，造 成  %d%%  的 物 理 和 时 空 属 性 的 武 器 伤 害 。如 果 任 意 一 次 攻 击 命 中 ，你 可 以 晕 眩 、致 盲 、束 缚 或 者 混 乱 目 标  %d  回 合 。
		 
		 激 活 螺 旋 灵 刃 技 能 可 以 自 由 切 换 到 你 的 双 持 武 器 （必 须 装 备 在 副 武 器 栏 位 上 ）。此 外 ，当 你 使 用 近 战 攻 击 时 也 会 触 发 这 个 效 果 ]])
		:format(damage, duration)
	end,
}

registerTalentTranslation{
	id = "T_BLINK_BLADE",
	name = "闪烁灵刃",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[传 送 到 目 标 面 前 ，并 使 用 你 的 近 战 武 器 攻 击 目 标 ，造 成  %d%%  伤 害 。然 后 随 机 传 送 到 第 二 个 目 标 面 前 ，攻 击 并 造 成  %d%%  伤 害 。
		 闪 烁 灵 刃 可 以 命 中 同 一 个 目 标 多 次 。]])
		:format(damage, damage)
	end,
}

registerTalentTranslation{
	id = "T_BLADE_SHEAR",
	name = "灵刃切变",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local shear = t.getShear(self, t)
		local radius = self:getTalentRadius(t)
		return ([[攻 击 至 多 三 个 相 邻 目 标 ，造 成  %d%%  武 器 伤 害 。任 何 一 次 攻 击 命 中 将 会 制 造 一 次 时 空 切 变 ，造 成  %0.2f  武 器 伤 害 ，攻 击 半 径 为  %d  的 锥 形 内 的 目 标 。		 
		随 后 的 每 次 命 中 都 将 增 加 切 变 的 伤 害  25%% 。   被 切 变 将 血 量 减 少 到 最 大 值  20%%  以 下 的 目 标 将 会 立 刻 死 亡 。
		受 法 术 强 度 影 响 ，切 变 的 伤 害 有 额 外 加 成 。]])
		:format(damage, damDesc(self, DamageType.TEMPORAL, shear), radius)
	end,
}

registerTalentTranslation{
	id = "T_BLADE_WARD",
	name = "灵刃守卫",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[双 持 时 你 有 %d%% 几 率 格 挡 近 战 攻 击。]])
		:format(chance)
	end,
}


return _M

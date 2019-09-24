local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLASH",
	name = "削砍",
	info = function(self, t)
		local healFactorChange = t.getHealFactorChange(self, t)
		local woundDuration = t.getWoundDuration(self, t)
		return ([[野 蛮 的 削 砍 你 的 目 标 造 成 %d%% （ 0 仇 恨） 至 %d%% （ 100+ 仇 恨） 伤 害。 
		等 级 3 时 攻 击 附 带 诅 咒， 降 低 目 标 治 疗 效 果 %d%% 持 续 %d 回 合， 效 果 可 叠 加。 
		伤害比例受力量值加成。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -healFactorChange * 100, woundDuration)
	end,
}

registerTalentTranslation{
	id = "T_FRENZY",
	name = "狂乱之袭",
	info = function(self, t)
		local attackChange = t.getAttackChange(self, t)
		return ([[对 附 近 目 标 进 行 4 次 攻 击 每 个 目 标 造 成 %d%% （ 0 仇 恨 值） 至 %d%% （ 100+ 仇 恨 值）。 附 近 被 追 踪 的 目 标 会 被 优 先 攻 击。 
		 等 级 3 时 你 的 猛 烈 攻 击 会 同 时 降 低 目 标 %d 的 命 中， 持 续 3 回 合。 
		 伤 害 加 成 和 命 中 减 值 受力量值加成。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -attackChange)
	end,
}

registerTalentTranslation{
	id = "T_RECKLESS_CHARGE",
	name = "鲁莽冲撞",
	info = function(self, t)
		local level = self:getTalentLevelRaw(t)
		local maxAttackCount = t.getMaxAttackCount(self, t)
		local size
		if level >= 5 then
			size = "大型"
		elseif level >= 3 then
			size = "中型"
		else
			size = "小型"
		end
		return ([[冲 过 你 的 目 标， 途 经 的 所 有 目 标 受 到 %d%% （ 0 仇 恨） 至 %d%% （ 100+ 仇 恨） 伤 害。 %s 体 型 的 目 标 会 被 你 弹 开。 你 最 多 可 以 攻 击 %d 次， 并 且 你 对 路 径 上 的 敌 人 可 造 成 不 止 1 次 攻 击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, size, maxAttackCount)
	end,
}

registerTalentTranslation{
	id = "T_CLEAVE",
	name = "分裂攻击",
	info = function(self, t)
		return ([[当激活时，你的每一次武器攻击都会攻击一个临近的目标，造成%d%%（0仇恨值）到%d%% （100仇恨值）的物理伤害。不顾一切的杀戮会带给你厄运（-3幸运）。
		分裂攻击、杀意涌动和无所畏惧不能同时开启，并且激活一个也会使另外两个进入冷却。
		当使用双手武器时，分裂攻击会造成25%%的额外伤害。
		分裂攻击伤害受力量值加成。]]):
		format( t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100)
	end,
}




return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARP_MINE_TOWARD",
	name = "时空地雷：接近",
	info = function(self, t)
		local damage = self:callTalent(self.T_WARP_MINES, "getDamage")/2
		local duration = self:callTalent(self.T_WARP_MINES, "getDuration")
		local detect = self:callTalent(self.T_WARP_MINES, "trapPower") * 0.8
		local disarm = self:callTalent(self.T_WARP_MINES, "trapPower")
		return ([[ 在半径 1 的范围里埋设地雷，将敌人传送至你身边并造成 %0.2f 物理和 %0.2f 时空伤害。
		地雷是隐藏的陷阱（ %d 侦查强度 %d 解除强度基于魔法），持续 %d 回合。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration)
	end,
}

registerTalentTranslation{
	id = "T_WARP_MINE_AWAY",
	name = "时空地雷：远离",
	info = function(self, t)
		local damage = self:callTalent(self.T_WARP_MINES, "getDamage")/2
		local duration = self:callTalent(self.T_WARP_MINES, "getDuration")
		local detect = self:callTalent(self.T_WARP_MINES, "trapPower") * 0.8
		local disarm = self:callTalent(self.T_WARP_MINES, "trapPower")
		return ([[在半径 1 的范围里埋设地雷，将敌人传送远离你身边并造成 %0.2f 物理和 %0.2f 时空伤害。
		地雷是隐藏的陷阱（ %d 侦查强度 %d 解除强度基于魔法），持续 %d 回合。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration) 
	end,
}

registerTalentTranslation{
	id = "T_WARP_MINES",
	name = "时空地雷",
	info = function(self, t)
		local range = t.getRange(self, t)
		local damage = t.getDamage(self, t)/2
		local detect = t.trapPower(self,t)*0.8
		local disarm = t.trapPower(self,t)
		local duration = t.getDuration(self, t)
		return ([[学会在半径 1 的范围内埋设时空地雷，造成 %0.2f 物理和 %0.2f 时空伤害。
		时空地雷能将敌人传送，到你身边或者传到远处。
		地雷是隐藏的陷阱（ %d 侦查强度 %d 解除强度基于魔法），持续 %d 回合，有 10 回合冷却时间。
		在该技能上投入点数能增加时空折叠系技能的半径。
		地雷伤害受法术强度加成。

		当前半径： %d]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration, range) --I5
	end,
}

registerTalentTranslation{
	id = "T_SPATIAL_TETHER",
	name = "时空束缚",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)/2
		local radius = self:getTalentRadius(t)
		return ([[将目标束缚于某处 %d 回合。
		每回合，目标每离开该处 1 格，便有 %d%% 几率传送回去，并在传送点周围造成 %0.2f 物理 %0.2f 时空伤害的 %d 半径的爆炸。
		伤害受法术强度加成。]])
		:format(duration, chance, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_BANISH",
	name = "放逐",
	info = function(self, t)
		local range = t.getTeleport(self, t)
		local duration = t.getDuration(self, t)
		return ([[将半径 3 以内的敌人随机传送。
		敌人将会传送至距离你 %d 至 %d 码的范围内，并被震慑、致盲、混乱或者定身 %d 回合。
		传送几率与法术强度相关。]]):format(range / 2, range, duration)
	end,
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_ANCHOR",
	name = "禁传区",
	info = function(self, t)
		local damage = t.getDamage(self, t)/2
		local duration = t.getDuration(self, t)
		return ([[制造一个半径 3 的禁传区，持续 %d 轮，并眩晕其中所有目标 2 回合。
		试图传送的敌人将受到 %0.2f 物理 %0.2f 时空伤害。
		伤害受法术强度加成。]]):format(duration, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

return _M

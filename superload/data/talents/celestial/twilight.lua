local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TWILIGHT",
	name = "黄昏",
	info = function(self, t)
		return ([[你处于黑暗和光明之间，能够将 15 点正能量转化为 %d 负能量。 
		受灵巧影响，效果有额外加成。]]):
		format(t.getNegativeGain(self, t))
	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE_TELEPORT",
	name = "跃迁之门：传送",
	info = function(self, t)
		return ([[在 %d 码范围以内你可以立即传送至你的跃迁之门。]]):format(t.getRange(self, t))
 	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE",
	name = "跃迁之门",
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[在你的位置制造 1 个阴影跃迁之门，当你激活这个技能时你可以使用跃迁之门：传送技能将你传送至此（跃迁之门必须在你 %d 码范围以内）。 
		 注意：当此技能激活且楼梯位于跃迁之门下方时，楼梯将不可使用。你必须取消此技能方可使用楼梯离开该区域。 
		 在等级 4 时，你可以制造 2 个跃迁之门。]]):format(range)
 	end,
}

registerTalentTranslation{
	id = "T_MIND_BLAST",
	name = "心灵震爆",
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		return ([[在 %d 码半径范围内释放一股精神冲击，摧毁目标的意志，对其造成 %0.2f 暗影伤害，并使其混乱 ( %d%% 几率随机行动），持续 %d 回合。
		伤害受法术强度加成，持续时间受灵巧加成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getConfuseEfficency(self,t), duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_SIMULACRUM",
	name = "阴影幻象",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[用阴影复制一个敌对目标的幻象  。这个幻象会立刻攻击它的原型，持续 %d 回合。
		幻象拥有 %d%% 的目标生命， +50%% 暗影伤害抵抗， -50%% 光系伤害抵抗，造成 -50%% 的伤害。
		持续时间和幻象生命受你的灵巧加成。]]):
		format(duration, t.getPercent(self, t))
	end,
}
registerTalentTranslation{
	id = "T_JUMPGATE_TWO",
	name = "跃迁之门II",
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT_TWO)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[在你当前位置创造第 2 个跃迁之门，你可以使用跃迁之门：传送技能将你传送至这个位置，距离不超过 %d 码。]]):format(range)
	end,
}

registerTalentTranslation{
	id = "T_JUMPGATE_TELEPORT_TWO",
	name = "跃迁之门：传送II",
	info = function(self, t)
		return ([[立即传送你至先前创造的第 2 个跃迁之门，距离不超过 %d 码。]]):format(t.getRange(self, t))
	end,
}

return _M

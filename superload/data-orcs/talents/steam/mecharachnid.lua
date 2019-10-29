local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MECHARACHNID_LINK",
	name = "机械蜘蛛链接",
	info = function(self, t) return ([[连接到它的主人。]]) end,
}

registerTalentTranslation{
	id = "T_MECHARACHNID",
	name = "机械蜘蛛",
	info = function(self, t)
		return ([[你建造一台强大的机械蜘蛛，和你并肩作战。你可以给机械蜘蛛装备 2 把蒸汽枪，弹药，以及任何你喜欢的护甲。
如果机械蜘蛛死了，这一技能会重建它，并恢复它 %d%% 的最大生命值。
你的机械蜘蛛获得 %d 级蒸汽枪掌握、蒸汽链锯掌握、强化命中和重甲训练技能。]]):
		format(t.getPower(self,t), self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_STORMCOIL_GENERATOR",
	name = "风暴线圈发电机",
	info = function(self, t)
		return ([[你给机械蜘蛛装备风暴线圈发电机，这一装置可以产生强大的电力立场。当受到超过最大生命值 15%% 的伤害的时候，超过的伤害将会被降低 %d%% ，并被转化为能量，增加机械蜘蛛 %d%% 的整体速度，持续 2 回合。]])
		:format(t.getDamageReduction(self,t)*100, t.getSpeed(self,t)*100)
	end,
}
	
registerTalentTranslation{
	id = "T_MECHARACHNID_CHASSIS",
	name = "机械蜘蛛底盘",
	info = function(self, t)
		return ([[你给机械蜘蛛装备了新的底盘，让他们可以适用于不同的场合。这些底盘可以给机械蜘蛛带来一个新的技能大系，让它们可以在尾部装备一把武器，并且它们获得 %d 职业技能点，用于加点在底盘所给予的新技能上。
		
		在战斗外，你可以使用这个技能，来从两种底盘中选择一种（默认底盘：强袭）
		- 强袭：重视近身格斗和防御能力的装甲底盘，尾部装备蒸汽链锯。
		- 武装：重视远程攻击的强火力地盘，尾部装备一把额外的蒸汽枪。
		
		尾部武器平常不会攻击，只会用于特殊的技能攻击。]]):
		format(t.getNb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_MECHARACHNID_PILOTING",
	name = "驾驶机械蜘蛛",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = t.getDamage(self,t)
		local resist = t.getResist(self,t)
		return ([[跳入机械蜘蛛，直接控制它 %d 回合。当控制它的时候，它所造成的所有伤害增加 %d%%， 抗性增加 %d%% ，所有技能冷却时间减半。]]):
		format(duration, dam, resist)
	end,
}


registerTalentTranslation{
	id = "T_OVERRUN",
	name = "超速撞击",
	info = function(self, t)
		return ([[你冲向敌人，用尾部蒸汽链锯进行攻击，造成 %d%% 伤害，并嘲讽半径 %d 码内的所有敌人。
		装备蒸汽链锯的时候，你使用敏捷代替力量值计算装备需求和计算武器伤害，并且增加你蒸汽链锯的伤害 %d%% 。]]):
		format(t.getSawDamage(self,t)*100, self:getTalentRadius(t), t.getPercentInc(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DEFENSIVE_PROTOCOL",
	name = "防御协议",
	info = function(self, t)
		local ev, spread = t.getEvasion(self, t)
		local dam = t.getDamage(self,t)*100
		return ([[强化机械蜘蛛的近身战斗能力，增加近战和远程闪避率 %d%% ，你每回合会自动用尾部的蒸汽链锯打击临近的敌人，造成 %d%% 伤害。]])
		:format(ev, dam)
	end,
}

registerTalentTranslation{
	id = "T_PINCER_STRIKE",
	name = "钢爪钳制",
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local slow = t.getSlow(self,t)
		return ([[你用蒸汽链锯打击敌人，造成 %d%% 伤害。如果攻击命中，你会试图钳制住敌人。这会定身它们，降低他们 %d%% 战斗、法术和精神速度，并且每回合你会用蒸汽链锯对它们进行一次自动的，无法回避的打击，造成 %d%% 伤害。如果你离敌人的距离超过 1 码，该技能自动终止。]])
		:format(dam*2, dur, slow, dam)
	end,
}

registerTalentTranslation{
	id = "T_AUTOMATED_REPAIR_SYSTEM",
	name = "自动修理",
	info = function(self, t)
		local life = t.getLife(self,t)
		local heal = t.getHeal(self,t)
		local resist = t.getResist(self,t)
		return ([[当生命值降低到 0 点以下的时候，你会启动自动修理模式。在自动修理模式下，你不能活动，生命值下限为 -%d ，每回合恢复 %0.1f 生命值，并且所有抗性增加 %d%%。这一效果直到你的生命值完全恢复或者你被摧毁才会终止。
		这一效果具有冷却时间。]])
		:format(life, heal, resist)
	end,
}

registerTalentTranslation{
	id = "T_GAUSS_CANNON",
	name = "电磁炮",
	info = function(self, t)
		return ([[用尾部蒸汽枪发射充能射击，击穿所有敌人，无视护甲，造成 %d%% 闪电武器伤害。
		使用这一技能不需要消耗时间。]]):
		format(t.getDamage(self,t)*100)
	end,
}

registerTalentTranslation{
	id = "T_MAGNETIC_ACCELERATOR",
	name = "磁性加速",
	info = function(self, t)
		local speed = t.getSpeed(self,t)
		local crit = t.getCritPower(self,t)
		local range = self:getTalentRange(t)
		return ([[增强你的能量输出，你的抛射物速度加快 %d%% ，暴击伤害增加 %d%% ，你每回合会自动填弹。
		另外，你可以主动激活这一技能，获得超人的移动速度，立刻移动到 %d 码范围内的某个内。]]):
		format(speed, crit, range)
	end,
}

registerTalentTranslation{
	id = "T_HAYWIRE_MISSILES",
	name = "导弹乱射",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		return ([[用尾部蒸汽枪发射导弹弹幕，在半径 %d 码区域内造成 %d%% 闪电蒸汽枪伤害，并震慑目标 2 回合。
		震慑几率受命中率加成。]])
		:format(rad, dam)
	end,
}

registerTalentTranslation{
	id = "T_ADVANCED_TARGETING_SYSTEM",
	name = "高级瞄准",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local pen = t.getResistPen(self,t)
		return ([[强化你的瞄准能力，你的所有远程攻击有 %d%% 几率触发一次尾部蒸汽枪的射击，造成 100%% 闪电武器伤害。
		另外，你的物理和闪电伤害抗性穿透增加 %d%% 。]]):
		format(chance, pen)
	end,
}

registerTalentTranslation{
	id = "T_TAIL_ATTACHMENT",
	name = "尾部武器",
	info = function(self, t)
		return ([[在尾部装备选定好的武器。]])
	end,
}

return _M
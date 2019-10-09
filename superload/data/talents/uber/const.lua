local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRACONIC_BODY",
	name = "龙族之躯",
	["require.special.desc"] = "熟悉龙之世界",
	info = function(self, t)
		return ([[你的身体如龙般坚固，当生命值下降到 30％以下时，恢复 40％的最大生命值。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_BLOODSPRING",
	name = "血如泉涌",
	["require.special.desc"] = "梅琳达被献祭",
	info = function(self, t)
		return ([[当敌人的单次攻击造成超过你 15%% 总生命值伤害时，产生持续 4 回合的血之狂潮，造成 %0.2f 枯萎伤害并治疗你相当于 50％伤害值的生命，同时击退敌人。 
		 受体质影响，伤害有额外加成。  ]])
		:format(100 + self:getCon() * 3)
	end,
}

registerTalentTranslation{
	id = "T_ETERNAL_GUARD",
	name = "永恒防御",
	["require.special.desc"] = "掌握格挡技能",
	info = function(self, t)
		return ([[你的格挡技能持续时间 2 回合，并且你可以反击任意数量的敌人。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_NEVER_STOP_RUNNING",
	name = "永不止步",
	["require.special.desc"] = "掌握至少20级使用体力的技能",
	info = function(self, t)
		return ([[当技能激活时，你可以挖掘出体能的极限，移动不会耗费回合，但是每移动一码需消耗 12 点体力。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ARMOUR_OF_SHADOWS",
	name = "影之护甲",
	["require.special.desc"] = "曾造成超过50000点暗影伤害",
	info = function(self, t)
		return ([[你懂得如何融入阴影，当你站在黑暗地形上时将增加 %d 点护甲、 50％护甲硬度和 20%% 闪避。
		同时，你造成的暗影伤害会使你当前所在区域和目标区域陷入黑暗。  
		被动增加 %d 潜行强度。
		 受体质影响, 护甲加值有额外加成。]])
		 :format(t.ArmourBonus(self,t), t.getStealth(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPINE_OF_THE_WORLD",
	name = "世界之脊",
	info = function(self, t)
		return ([[你的后背坚若磐石。当你受到物理效果影响时，你的身体会硬化，在 5 回合内对所有其他物理效果免疫。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_FUNGAL_BLOOD",
	name = "真菌之血",
	["require.special.desc"] = "能使用纹身",
	info = function(self, t)
		return ([[真菌充斥在你的血液中，每当使用纹身时你都会储存 %d 的真菌能量。 
		 当使用此技能时，可释放能量治愈伤口 ( 恢复值不超过 %d ),  并解除至多 10 个负面魔法效果。 
		 真菌之力保存 6 回合，每回合减少 10 点或 10%% 。  
		 受体质影响，真菌能量的保存数量和治疗上限有额外加成。]])
		:format(t.fungalPower(self, t), t.healmax(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTED_SHELL",
	name = "堕落之壳",
	["require.special.desc"] = "承受过至少 7500 点枯萎伤害并和大堕落者一起摧毁伊格。",
	info = function(self, t)
		return ([[多亏了你在堕落能量上的新发现，你学到一些方法来增强你的体质。但是只有当你有一副强壮的体魄时方能承受这剧烈的变化。 
		 增加你 500 点生命上限， %d 点闪避， %d 护甲值，20%% 护甲硬度 , %d 所有豁免，你的身体已经突破了自然界的范畴和大自然的限制。 
		 受体质影响，豁免、护甲和闪避有额外加成。]])
		:format(self:getCon() / 3, self:getCon() / 3.5, self:getCon() / 3)
	end,
}

return _M

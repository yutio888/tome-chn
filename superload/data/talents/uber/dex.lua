local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FLEXIBLE_COMBAT",
	name = "自由格斗",
	info = function(self, t)
		return ([[每当你进行近战攻击时，有 50％几率追加一次额外的徒手攻击。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_THROUGH_THE_CROWD",
	name = "穿梭人群",
	["require.special.desc"] = "同时拥有至少6名同伴",
	info = function(self, t)
		return ([[你习惯与大部队一起:
		--你可以与友好生物进行一次换位，消耗 1/10 回合。
		--激活该技能时你不会伤害友方生物。 
		--视野内每有一名友好生物，你获得 10 点全体豁免和 3%% 整体速度（最多15%% ）。
		--所有队友同时获得穿梭人群技能。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_SWIFT_HANDS",
	name = "疾影手",
	info = function(self, t)
		return ([[你的手指灵巧的超乎想象，切换主/ 副武器 ( 默认 Q 键 )、装备/ 卸下装备不再消耗回合。 
		该效果一回合只能触发一次。
		同时，当装备有附加技能的物品时，其附加技能也会冷却完毕。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_WINDBLADE",
	name = "剑刃风暴",
	["require.special.desc"] = "曾使用双持武器造成超过50000点伤害",
	info = function(self, t)
		return ([[你挥动武器疯狂旋转，产生剑刃风暴，对 4 码范围内所有敌人造成 320％的武器伤害，并缴械它们 4 回合。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_WINDTOUCHED_SPEED",
	name = "和风守护",
	["require.special.desc"] = "掌握至少10级使用失衡值的技能",
	info = function(self, t)
		return ([[你和大自然产生共鸣，在与奥术势力的战斗中受到她的赐福。 
		你的整体速度永久提高 20%% ，技能冷却时间缩短 10%% ，且不会触发压力式陷阱。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_CRAFTY_HANDS",
	name = "心灵手巧",
	["require.special.desc"] = "学会5级的附魔技能",
	info = function(self, t)
		return ([[你心灵手巧，打造技艺已趋于炉火纯青，可以给头盔和腰带镶嵌宝石。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ROLL_WITH_IT",
	name = "随波逐流",
	["require.special.desc"] = "曾被击退50次以上",
	info = function(self, t)
		return ([[ 你学会选择在需要的时候借力抽身，受到的所有物理伤害降低 %d%% 。 
		当被近战或者远程攻击命中时，你会借势后退一码 ( 这个效果每轮只能触发一次 )，并获得 1 回合的 200％移动加速。
		受敏捷影响，伤害降低幅度增加，且作用于物理抗性后。]])
		:format(100*(1-t.getMult(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_VITAL_SHOT",
	name = "要害射击",
	["require.special.desc"] = "曾使用远程武器造成50000点伤害",
	info = function(self, t)
		return ([[你对着目标要害射出一发，使目标受到重创。 
		受到攻击的敌人将会承受 450％武器伤害，并且由于受到重创，还会被震慑和残废 ( 减少 50％攻击、施法和精神速度 )5 回合。 
		受命中影响，震慑和残废几率有额外加成。]]):format()
	end,
}

return _M

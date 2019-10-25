local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PUSH_KICK",
	name = "强力踢",
	message = "@Source@ 使出强力干扰踢击.",
	info = function(self, t)
		local damage = t.getDamage(self, t) *100
		return ([[每有一个连击点，对目标造成 %d%% 武器伤害，并解除目标一项物理持续技能。 
		等级 3 时，魔法持续技能也会受影响。
		等级 5 时，精神持续技能也会受影响。 
		使用该技能将除去全部连击点。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_STRIKES",
	name = "无情打击",
	info = function (self,t)
		local stamina = t.getStamina(self, t)
		local chance = t.getChance(self, t)
		return ([[当获得一个连击点时, 你有 %d%% 几率获得一个额外的连击点. 另外, 每当你获得连击点时, 你会恢复 %0.2f 体力,如果你将超过 5 个连击点改为获得 %0.2f 体力 .]])
		:format(chance, stamina, stamina*2)
	end,
}

registerTalentTranslation{
	id = "T_BREATH_CONTROL",
	name = "空手格挡",
	message = "@Source@ 准备格挡攻击.",
	info = function(self, t)
		local block = t.getBlock(self, t)
		local maxblock = block*5
		return ([[硬化身体，每有一点连击点就能格挡 %d 点伤害（至多 %d ）,持续 2 回合。
			当前格挡值: %d
			使用该技能会除去所有连击点。
			伤害吸收受物理强度加成。]])
		:format(block, block * 5, block * self:getCombo())
	end,
}

registerTalentTranslation{
	id = "T_TOUCH_OF_DEATH",
	name = "点穴术",
	message = "@Source@ 击中了目标致命穴道。",
	info = function (self,t)
		local damage = t.getDamage(self, t) * 100
		local mult = t.getMult(self,t)
		local finaldam = damage+(damage*(((mult/100)+1)^2))+(damage*(((mult/100)+1)^3))+(damage*(((mult/100)+1)^4))
		local radius = self:getTalentRadius(t)
		return ([[使用你深刻的解剖学知识，击中敌人的穴道造成 %d%% 武器伤害, 无视防御和闪避.
		这次攻击在敌人身上造成可怕的内伤，在四回合内造成相当于攻击伤害的 100%% 的物理伤害 , 每回合增加 %d%% (4 回合后, 总共造成 %d%% 伤害).
		如果目标死在该效果下, 他们身体会爆炸，并让半径 %d 内的敌人受到等于他们当前回合的点穴伤害的物理伤害，并给你 4 点连击点.]])
		:format(damage, mult, finaldam, radius)
	end,
}


		
	


return _M

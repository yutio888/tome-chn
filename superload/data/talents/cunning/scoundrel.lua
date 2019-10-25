local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LACERATING_STRIKES",
	name = "撕裂挥击",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[你的近战和远程攻击有 %d%% 的几率撕裂敌人，使其在 4 回合内受到 100%% 的额外流血伤害。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_SCOUNDREL",
	name = "街霸战术",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local crit = t.getCritPenalty(self, t)
		local dur = t.getDuration(self,t)
		return ([[你的近战和远程攻击制造的伤口会使敌人分心，使目标的暴击系数减少 %d%% ，持续 5 回合。
		此外，你的攻击还有 %d%% 的几率造成痛苦的创伤，使敌人随机遗忘一项技能，持续 %d 回合。这一效果每回合最多只能触发一次。]]):format(crit, chance, dur)
	end,
}



registerTalentTranslation{
	id = "T_MISDIRECTION",
	name = "误导",
	info = function(self, t)
		return ([[你制造混乱的技巧已趋于巅峰。现在，即便是你最简单的动作也会迷惑敌人，使他们看不透你的行踪。 
		敌人试图对你施加物理负面状态时，有 %d%% 几率失败。此外，如果你周围有敌人，这一效果将会被转移到这个敌人身上，持续时间变为 %d%% 。 
		你获得 %d 闪避。
		施加负面状态几率受命中影响。
		闪避加成受灵巧影响]]):
		format(t.getChance(self,t),t.getDuration(self,t), t.getDefense(self, t))
		end,
}
registerTalentTranslation{
	id = "T_FUMBLE",
	name = "笨拙",
	info = function (self,t)
		local stacks = t.getStacks(self, t)
		local dam = t.getDamage(self, t)
		return ([[你的近程和远程攻击会让敌人难以集中精力于复杂的行动，在下一次使用技能时有 3%% 的几率失败，这一效果可以叠加，最多叠加至 %d%% 。
		如果因任何原因，敌人技能使用失败，对方将弄伤自己，造成 %0.2f 物理伤害。
		如果敌人是因笨拙效果而技能使用失败，将会移除笨拙效果。
		伤害受灵巧加成。
	  ]]):format(stacks*3, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M

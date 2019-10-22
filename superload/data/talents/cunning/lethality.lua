local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LETHALITY",
	name = "刺杀掌握",
	info = function(self, t)
		local critchance = t.getCriticalChance(self, t)
		local power = t.critpower(self, t)
		return ([[你学会寻找并打击目标弱点。你的攻击有 %0.1f%% 更大几率出现暴击且暴击伤害增加 %0.1f%% 。同时，当你使用匕首时，你的灵巧点数会代替力量影响额外伤害。]]):
		format(critchance, power)
	end,
}

registerTalentTranslation{
	id = "T_EXPOSE_WEAKNESS",
	name = "弱点暴露",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[集中精力试探目标，寻找其弱点 ,造成 %d%% 武器伤害。
		在接下来的  %d  回合内，你获得  %d  护甲穿透， %d  命中， %d%%  所有伤害穿透。
		学习这一技能还会使你的近战和弓箭攻击永久获得  %d  护甲穿透。
		护甲穿透和命中加成受灵巧加成。]]):
		format(100 * damage, duration, t.getAPRBuff(self, t), t.getAccuracy(self, t), t.getPenetration(self, t), t.getAPR(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLADE_FLURRY",
	name = "剑刃乱舞",
	info = function (self,t)
		return ([[如疾风般挥舞武器，攻击速度增加  %d%%  ，每次攻击追加一名目标，造成  %d%%  武器伤害。
该技能每回合抽取 4 点体力。]]):format(t.getSpeed(self, t)*100, t.getDamage(self,t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SNAP",
	name = "灵光一闪",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[你的快速反应使你能够重置至多 %d 个层级不超过 %d 的战斗技能（灵巧类或格斗类）的冷却时间。]]):
		format(talentcount, maxlevel)
	end,
}




return _M

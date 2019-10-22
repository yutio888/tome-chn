local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MECHANICAL_ARMS",
	name = "机械巨臂",
	info = function(self, t)
		return ([[你使用灵能操控背后的两个恐怖的机械巨臂。
		每个基础回合机械巨臂能够使用灵晶自动攻击 3 码内的最多两个敌人，造成 %d%% 武器伤害。
		被机械巨臂攻击的目标伤害降低 %d%% ，持续 5 回合。]]):
		format(t.getDam(self, t) * 100, t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_LUCID_SHOT",
	name = "醒神射击",
	info = function(self, t)
		return ([[对一个敌人进行一次强力射击，造成 %d%% 的武器伤害。
		目标三码范围内被恐惧或者噩梦效果影响的生物将被突然惊醒而处于迷失状态，无法分辨敌我，持续 %d 回合。]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSY_WORM",
	name = "心灵蠕虫",
	info = function(self, t)
		return ([[对一个敌人进行一次灵能强化射击，造成 %d%% 精神武器伤害，同时使目标感染持续 8 回合的心灵蠕虫。
		蠕虫每回合造成 %0.2f 精神伤害，并为你回复 %d 点超能力。
		如果目标处于震慑或者恐惧状态，效果翻倍。
		另外，蠕虫每回合有 25%% 的概率感染 3 码内的所有其他敌人。]])
		:format(100 * t.getDam(self, t), damDesc(self, DamageType.MIND, t.getWorm(self, t)), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_NO_HOPE",
	name = "无助深渊",
	info = function(self, t)
		return ([[操纵敌人的思维，让敌人失去战胜你的希望。
		降低敌人 40%% 的全部伤害，持续 %d 回合。]]):
		format(t.getDur(self, t))
	end,}
return _M
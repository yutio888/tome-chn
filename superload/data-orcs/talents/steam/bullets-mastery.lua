local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OVERHEAT_BULLETS",
	name = "过热子弹",
	info = function(self, t)
		return ([[使用蒸汽进行子弹的过热处理。
		接下来的 %d 回合内，你的子弹会点燃目标，在 5 回合内造成 %0.2f 火焰伤害（大多数射击技能一次发射两枚弹药）。
		一次只能使用一种弹药强化能力。]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_BULLETS",
	name = "超速子弹",
	info = function(self, t)
		return ([[精心打磨子弹，接下来的 %d 回合内，你的子弹能够穿透多个目标。
		同时提高护甲穿透 %d 点。
		一次只能使用一种弹药强化能力。]]):
		format(t.getTurns(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_PERCUSSIVE_BULLETS",
	name = "冲击子弹",
	info = function(self, t)
		return ([[为了提高子弹的冲击力，换用了巨型子弹。
		接下来的 %d 回合内，你的子弹击中时有 %d%% 概率击退目标 3 码，同时有 %d%% 概率震慑目标 3 回合。
		击退和震慑概率受蒸汽强度影响。
		一次只能使用一种弹药强化能力。]]):
		format(t.getTurns(self, t), t.getKBChance(self, t), t.getStunChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMBUSTIVE_BULLETS",
	name = "爆炸子弹",
	info = function(self, t)
		return ([[在子弹上覆盖了可燃材料。在接下来的 %d 回合，子弹在击中目标后都会爆炸，对 2 码范围内的敌人造成 %0.2f 火焰伤害（大多数射击技能一次发射两枚弹药）。
		伤害随蒸汽强度提高。
		一次只能使用一种弹药强化能力。]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}
return _M
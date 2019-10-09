local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VAPOROUS_STEP",
	name = "蒸汽步",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你集中精神来将一些你发动机中的蒸汽意念移动到远方。 
		每回合蒸汽都会在那里累积，最多 %d 层。
		当你解除状态时，你会释放累积的精神力和蒸汽，瞬间移动到该地点并制造一个半径 4 码的炙热的蒸汽爆炸。
		爆炸将造成 %0.2f 乘以每层 33%% 的火焰伤害并附加浸湿状态。
		如果目标地点已经被占据或不在视线之内，则技能将失败。
		伤害会随着你的蒸汽值增加。]]):
		format(t.getMaxCharge(self, t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_INHALE_VAPOURS",
	name = "吸入蒸汽",
	info = function(self, t)
		return ([[当你解除蒸汽步时，如果意念移动成功了，你会吸入一些蒸汽，回复 %d 蒸汽和 %d 生命。
		效果会乘以蒸汽步的层数乘以 33%% 。
		治疗量会随着你的精神强度增加。]]):
		format(t.getSteam(self, t), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_FOG",
	name = "心灵迷雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你将你发动机里的蒸汽塑形为持续 %d 回合的心灵迷雾。
		任何陷入其中的敌人每回合都会受到 %0.2f 的伤害，并被烧焦，降低他们 %d%% 火焰抗性和 %d 精神豁免。
		伤害会随着你的精神强度增加。]]):
		format(duration, damDesc(self, DamageType.MIND, damage), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCERTAINTY_PRINCIPLE",
	name = "测不准原理",
	info = function(self, t)
		return ([[你能在心灵迷雾中使用你被技术强化过的心灵力量来掌握空间的量子态本质。
		当你将被击中时，你会闪现到一个临近的位置。
		这个效果有冷却时间。]]):
		format()
	end,}
return _M
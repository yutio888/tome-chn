local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONTINUOUS_BUTCHERY",
	name = "无尽屠戮",
	info = function(self, t)
		return ([[用链锯缠绕指定目标 5 回合。
		使用链锯对此目标造成伤害时，伤害增加 %d%% （其他链锯技能也可以加成）。
		当攻击其他目标时，伤害加成效果结束。
		#{italic}#切碎他们！！#{normal}#
		]]):
		format(t.getInc(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVE_SAW",
	name = "爆炸飞锯",
	info = function(self, t)
		return ([[你用自动蒸汽弹射器向敌人发射一把链锯，造成 %0.2f 物理伤害并沉默敌人，持续 4 回合。
		持续时间结束后，链锯爆炸，造成 %0.2f 的火焰伤害并飞回，将目标向你的位置拉扯 %d 格。 
		伤害随蒸汽强度增加。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamP(self, t)), damDesc(self, DamageType.FIRE, t.getDamF(self, t)), t.range(self, t))
	end,}

registerTalentTranslation{
	id = "T_MOW_DOWN",
	name = "肢解",
	info = function(self, t)
		return ([[杀死敌人时，迅速将部分残躯扔进蒸汽引擎，恢复 %d 蒸汽值。
		造成暴击时也有 %d%% 概率切下敌人的躯体扔进引擎。
		任意一种行为都会恐惧 4 格内的敌人，造成 %d 回合的锁脑效果。
		#{italic}#变成肉酱吧！！#{normal}#]]):
		format(t.getRegen(self, t), t.getChance(self, t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_TECH_OVERLOAD",
	name = "系统过载",
	info = function(self, t)
		local inc = t.getIncrease(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[你开启全部插件的超频模式，清除最多 % d 个蒸汽科技技能（ %d 层级或以下）的 CD ，直接恢复 %d%% 蒸汽值。
		在 6 回合内，蒸汽值最大值翻倍，但是恢复值减半。
		#{italic}#科技至尊、死亡之主！！#{normal}#]]):
		format(talentcount, maxlevel, inc)
	end,}

return _M
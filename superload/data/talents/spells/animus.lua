local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONSUME_SOUL",
	name = "消耗灵魂",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[ 粉碎你捕获的一个灵魂，利用其能量回复自己 %d 点生命， %d 点法力。
		受法术强度影响，治疗量有额外加成。]]):
		format(heal, heal / 3)
	end,
}

registerTalentTranslation{
	id = "T_ANIMUS_HOARDER",
	name = "灵魂储存",
	info = function(self, t)
		local max, chance = t.getMax(self, t), t.getChance(self, t)
		return ([[ 你对灵魂的渴望与日俱增。当你杀死一个生物时，你利用强大的力量抹去它的仇恨，有 %d%% 概率获得额外一个灵魂，同时你能获得的最大灵魂数增加  %d 。]]):
		format(chance, max)
	end,
}

registerTalentTranslation{
	id = "T_ANIMUS_PURGE",
	name = "仇恨净化",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 试图粉碎你敌人的灵魂，造成 %0.2f 点暗影伤害（但不会杀死它）。 
		如果剩余生命少于 %d%% , 你将试图控制其身体。
		如果成功，对方将成为你永久的傀儡，不受你的死灵光环影响，并得到两个灵魂。 
		傀儡能力与生前相同 , 受黑暗共享的影响，在制造时生命恢复满值，之后不能以任何方式被治疗。
		任何时候，这种方式只能控制一个生物，在已经存在傀儡时使用该技能会让原来的傀儡消失。
		boss、不死族和召唤物不会变成傀儡。 
		受法术强度影响，伤害和概率有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getMaxLife(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_OF_THE_DEAD",
	name = "亡者精华",
	info = function(self, t)
		local nb = t.getnb(self, t)
		return ([[  粉碎两个灵魂，接下来的 %d 个法术获得额外效果： 
                  受影响的法术有：
		亡灵分流：获得治疗量一半的护盾 
                  亡灵召唤：额外召唤两个不死族
                  亡灵组合：额外召唤一个骨巨人
                  黑夜降临：攻击变成锥形
                  暗影通道：被传送的不死族同时受到相当于 30%% 最大生命值的治疗
                  骨灵冷火：冰冻概率增加至 100%%
                  寒冰箭：每个寒冰箭都变成射线
                  消耗灵魂：效果增加 50%%]]):
		format(nb)
	end,
}

registerTalentTranslation{
	id = "T_HUSK_DESTRUCT",
	name = "自爆",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[毁灭自己，在半径 %d 的范围造成 %0.2f 点暗影伤害。
		只有当主人死去时才能使用。]]):format(rad, damDesc(self, DamageType.DARKNESS, 50 + 10 * self.level))
	end,
}


return _M

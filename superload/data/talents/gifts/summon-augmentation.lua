local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAGE",
	name = "狂暴",
	info = function(self, t)
		return ([[当一个召唤兽被杀死时，激发周围半径 5 范围内所有的召唤兽，使他们的所有属性增加 %d ，持续5回合。]]):format(t.incStats(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DETONATE",
	name = "引爆",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[献祭一只召唤兽，使它在 %d 码范围内爆炸。
		-火焰里奇：形成一个火球，造成 %d 伤害，并火焰震慑敌人。
		-三头蛇：范围内所有友方单位获得 %d%% 闪电、酸液和自然伤害吸收，并获得每回合 %d 生命回复，持续 7 回合。
		-雾凇：形成一个冰球，造成 %d 伤害，可能冰冻敌人。
		-火龙：形成一片火焰，每回合造成 %d 伤害。
		-战争猎犬：形成锋利的球，让周围的生物在 6 回合内受到 %0.1f 点流血伤害。
		-果冻怪：形成一片能减速的淤泥，造成 %d 自然伤害，并使敌人减速 %0.1f%% 。
		-米诺陶斯：眩晕敌人 5 回合（强度 %d%% ）
		-岩石傀儡：使周围的友方单位获得 %d 护甲值和 %d%% 护甲强度，持续 5 回合。
		-乌龟：给所有友方单位提供一个甲壳护盾，所有抗性提升 %d%% ，持续 5 回合。
		-蜘蛛：将所有敌人击退 %d 格。
		此外，随机的某个召唤技能会冷却完毕。
		引爆产生的负面效果不会影响到你或你的召唤兽。
		效果受精神强度加成，可以暴击。]]):format(radius, t.explodeSecondary(self,t), t.hydraAffinity(self,t), t.hydraRegen(self,t), t.explodeSecondary(self,t), t.explodeFire(self,t), t.explodeBleed(self,t) / 6, t.explodeSecondary(self,t), t.jellySlow(self,t) * 100, t.minotaurConfuse(self,t), t.golemArmour(self,t), t.golemHardiness(self,t), t.shellShielding(self,t), t.spiderKnockback(self,t)) 
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE",
	name = "体质强化",
	info = function(self, t)
		return ([[提升你所有召唤物的生命值 %0.1f%% ，并延长所有召唤物的存活时间 %d 回合。]]):format(100*t.incLife(self, t), t.incDur(self,t))
	end,
}

registerTalentTranslation{
	id = "T_PHASE_SUMMON",
	name = "次元召唤",
	info = function(self, t)
		return ([[与一只召唤兽调换位置。这会干扰你的敌人，使你和该召唤兽获得 50%% 闪避状态，持续 %d 回合。]]):format(t.getDuration(self, t))
	end,
}


return _M

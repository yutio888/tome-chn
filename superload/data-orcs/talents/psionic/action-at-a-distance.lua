local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONDENSATE",
	name = "冷凝",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在你敌人身边的 %d 码内冷凝热蒸汽。对他们造成 %0.2f 火焰伤害并浸湿他们 4 回合。被浸湿的敌人的震撼抗性会减半。
		伤害会随着你的精神强度增加。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_SOLIDIFY_AIR",
	name = "固化空气",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你集中精神力把你前方的锥形空间内的空气凝聚成固态。
		任何陷入其中的生物都会受到 %0.2f 的物理伤害。
		任何没被生物占据的地方会被固化空气占满，阻路 %d 回合。
		伤害会随着你的精神强度增加。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCONDUCTION",
	name = "超导",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤一道闪电劈向你的目标，造成 %0.2f 到 %0.2f 闪电伤害。
		如果目标被浸湿了，那么闪电扩散，对半径 %d 码内的所有单位造成同样的伤害。
		所有被劈中的单位都会被烧焦 4 回合，降低他们的火焰抗性 %d%% 和精神豁免 %d。
		伤害会随着你的精神强度增加。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage) / 3, damDesc(self, DamageType.LIGHTNING, damage), self:getTalentRadius(t), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_NEGATIVE_BIOFEEDBACK",
	name = "负反馈",
	info = function(self, t)
		return ([[每当你使用精神技能造成伤害时，你对你的敌人施加一个负反馈，能叠加至 %d 层并持续 5 回合。
		每层都会降低他们 %d 的物理豁免和 %d 的防御与护甲。
		这个效果每回合只能触发一次。]]):
		format(t.getNb(self, t), t.getSave(self, t), t.getPower(self, t))
	end,}
return _M
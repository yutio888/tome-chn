local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASSIVE_PHYSIQUE",
	name = "强壮体魄",
	info = function(self, t)
		return ([[长期打铁，让你的身体格外强壮，增加 %d 力量和体质。
		技能等级 5 时，你的肌肉是如此巨大，体型增大一个等级。]])
		:format(math.floor(2 * self:getTalentLevel(t)))
	end,}

registerTalentTranslation{
	id = "T_ENDLESS_ENDURANCE",
	name = "永不疲倦",
	info = function(self, t)
		return ([[长时间的锻造工作让你拥有不可思议的持久力和无尽的活力。
		你的治疗系数增加 %d%% ，生命恢复增加 %0.2f 。
		你力大无穷，很难被阻止，定身抗性增加 %d%% 。]])
		:format(self:getTalentLevel(t) * 2, self:getTalentLevel(t), self:getTalentLevel(t) * 15)
	end,}

registerTalentTranslation{
	id = "T_LIFE_IN_THE_FLAMES",
	name = "浴火而生",
	info = function(self, t)
		return ([[长时间的锻造工作让你对疼痛和火焰的忍耐力提高。
		火焰抗性增加 %d%% ，物理抗性增加 %d%% 。
		技能等级 5 时，你对火焰抗性极高，从而免疫燃烧状态。]])
		:format(self:getTalentLevel(t) * 5, self:getTalentLevel(t) * 3)
	end,}

registerTalentTranslation{
	id = "T_CRAFTS_EYE",
	name = "匠师之眼",
	info = function(self, t)
		return ([[你能够像找到自己工作的错误一样轻易发现敌人防御的弱点。
		获得 %d 的护甲穿透和 %d%% 的暴击伤害加成。
		技能等级 5 时，能够自如的与潜行和隐形生物战斗，无视减免。]])
		:format(self:getTalentLevel(t) * 4, self:getTalentLevel(t) * 5)
	end,}
return _M
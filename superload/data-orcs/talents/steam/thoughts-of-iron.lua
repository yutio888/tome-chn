local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MOLTEN_IRON_BLOOD",
	name = "铁水血液",
	info = function(self, t)
		return ([[使用灵能改变你的血液，使之成为融化的铁水。
 		任何近战攻击你的生物将受到 %0.2f 火焰伤害。
		你全体伤害抗性增加 %d%% ，同时所有新负面状态持续时间下降 %d%% 。 
		]]):format(damDesc(self, DamageType.FIRE, t.getSplash(self, t)), t.getResists(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_DRONES",
	name = "精神雄蜂",
	info = function(self, t)
		return ([[将灵能和蒸汽科技结合，你在身边制造 5 只精神雄蜂飞向目标。
		雄蜂接触到生物时，将进入其大脑 6 回合，干扰思考能力。 
 		受影响的生物有 %d%% 几率使用技能失败，同时恐惧和睡眠免疫减少 %d%% 。]]):
		format(t.getFail(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_MIRROR",
	name = "灵能之镜",
	info = function(self, t)
		return ([[解除 %d 项负面精神状态  ，并将每个状态随机转移至半径 5 以内的敌人上。]])
		:format(t.getNum(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_INJECTION",
	name = "精神注射",
	info = function(self, t)
		local faked = false
		if not self.inscriptions_data.MIND_INJECTION then self.inscriptions_data.MIND_INJECTION = {power=t.getPower(self, t), cooldown_mod=t.getCooldownMod(self, t), cooldown=1} faked = true end
		local data = self:getInscriptionData(t.short_name)
		if faked then self.inscriptions_data.MIND_INJECTION = nil end
		return ([[与身体建立直接的灵能链接，让你使用药剂更有效率 , 获得 %d%% 效果和 %d%% 冷却系数修正。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}
return _M
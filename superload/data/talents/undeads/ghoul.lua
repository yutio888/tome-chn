local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GHOUL",
	name = "食尸者",
	info = function(self, t)
		return ([[增强食尸鬼的身体，增加 %d 点力量和体质。
		你的身体对伤害抗性极高，任何一次伤害不会让你失去超过 %d%% 最大生命。]])
		:format(t.statBonus(self, t), t.getMaxDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GHOULISH_LEAP",
	name = "定向跳跃",
	info = function(self, t)
		return ([[跳向你的目标。
		落地后你的整体速度增加 %d%% ，持续 4 回合。]]):format(t.getSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RETCH",
	name = "亡灵唾液",
	info = function(self, t)
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		return ([[向你周围的空地上呕吐，治疗任何在这空地上的不死族并伤害敌方单位。 
		持续 %d 回合并造成 %d 点枯萎伤害或治疗 %d 点生命值。
		呕吐范围内的生物有 %d%% 概率失去一项物理效果。不死族解除负面效果，其他生物失去正面效果。
		当你站在你的呕吐范围内时，暂时取消种族特性中的 -20%% 整体速度效果。]]):format(t.getduration(self, t), damDesc(self, DamageType.BLIGHT, dam), dam * 1.5, t.getPurgeChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GNAW",
	name = "食尸鬼侵蚀",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local ghoul_duration = t.getGhoulDuration(self, t)
		local disease_damage = t.getDiseaseDamage(self, t)
		return ([[撕咬你的目标造成 %d%% 伤害。 
		如果你的攻击命中，目标会感染食尸鬼腐烂疫病持续 %d 回合。 
		食尸鬼腐烂疫病每回合造成 %0.2f 枯萎伤害。 
		目标被杀死时会变成你的可以完全控制的食尸鬼傀儡。 
		食尸鬼傀儡可以使用侵蚀、定向跳跃、震慑、腐烂疫病。
		受体质影响，枯萎伤害按比例加成。 ]]):
		format(100 * damage, duration, damDesc(self, DamageType.BLIGHT, disease_damage), ghoul_duration)
	end,
}


return _M

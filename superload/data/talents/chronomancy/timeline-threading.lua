local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RETHREAD",
	name = "重组",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local targets = t.getTargetCount(self, t)
		return ([[重组时间线，对一个目标造成  %0.2f 时空伤害。然后再对半径 10 内的另一个目标造成等量伤害。
		重组  能击中至多 %d 个目标，不会重复击中同一个目标，也不会击中施法者。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), targets)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FUGUE",
	name = "时间复制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接下来 %d 回合， 2 个你的镜像进入你的时间线。
		当技能生效时，所有你或者你的镜像造成的伤害会减少 2/3 ，所有你或者镜像受到的伤害会由你们三者均分。
		开启时该技能不会正常冷却。你能直接控制你的镜像，给他们指令，或者调整技能使用策略。
		你和镜像不会互相伤害。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_BRAID_LIFELINES",
	name = "生命线编织",
	info = function(self, t)
		local braid = t.getBraid(self, t)
		local duration = t.getDuration(self, t)
		return ([[你的重组技能将目标的生命线编织在一起 %d 回合。
		受影响的生物将受到其他受影响生物受到的 %d%% 伤害.
		伤害受法术强度加成。]])
		:format(duration, braid)
	end,
}

registerTalentTranslation{
	id = "T_CEASE_TO_EXIST",
	name = "存在抹杀",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return ([[接下来 %d 回合，你尝试抹杀目标在当前时间线的存在，降低目标物理和时空抗性 %d%% 。
		如果你在法术生效期间击杀了目标，你将会返回到你释放该法术的时间点，而目标将被杀死。
		这个法术分离的时间线。法术生效期间，其余分离时间线的法术将无法成功试用。
		抗性减少程度受法术强度加成。]])
		:format(duration, power)
	end,
}


return _M

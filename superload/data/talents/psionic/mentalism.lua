local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSYCHOMETRY",
	name = "共鸣之心",
	info = function(self, t)
		local max = t.getPsychometryCap(self, t)
		return ([[与你装备着的超能力、自然和反魔超能力值所制造的物品产生共鸣，增加你 %0.2f 点或 %d%% 物品材质等级数值（取较小值）的物理和精神强度。 
		此效果可以叠加，并且适用于所有符合条件的已穿戴装备。]]):format(max, 100*t.getMaterialMult(self,t))
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_SHIELDING",
	name = "精神屏障",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[净化你当前所有的精神状态，并在接下来的 6 回合内免疫新增的精神状态。最多一共（净化和免疫）能影响 %d 种精神状态。 
		此技能使用时不消耗回合。]]):format(count)
	end,
}

registerTalentTranslation{
	id = "T_PROJECTION",
	name = "灵魂出窍",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[激活此技能可以使你的灵魂出窍，持续 %d 回合。在此效果下，你处于隐形状态（ +%d 强度），并且可以看到隐形和潜行单位（ +%d 侦查强度），还可以穿过墙体，并且无需呼吸。 
		你受到的所有伤害都会与身体共享，当你处于此形态下你只能对“鬼魂”类怪物造成伤害，或者通过激活一种精神通道来造成伤害。 
		注：后一种情况下只能造成精神伤害。 
		要回到你的身体里，只需释放灵魂体的控制即可。]]):format(duration, power/2, power)
	end,
}

registerTalentTranslation{
	id = "T_MIND_LINK",
	name = "精神通道",
	info = function(self, t)
		local damage = t.getBonusDamage(self, t)
		local range = self:getTalentRange(t) * 2
		return ([[用精神通道连接目标。当精神通道连接时，你对其造成的精神伤害增加 %d%% ，同时你可以感知与目标同种类型的单位。 
		在同一时间内只能激活一条精神通道，当目标死亡或超出范围（ %d 码）时，通道中断。 
		受精神强度影响，精神伤害按比例加成。]]):format(damage, range)
	end,
}


return _M

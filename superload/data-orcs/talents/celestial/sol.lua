local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SOLAR_ORB",
	name = "日光球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[发射一个光球造成 %0.2f 的光伤害然后折返, 再次造成相同的伤害并且当回到你身上的时候减少一半 (%d) 的冷却时间. 伤害随着你的法术强度增加. 球体最多飞行 %d 然后折回你.]]):
		format(damDesc(self, DamageType.LIGHT, damage), cooldownred, self:getTalentRange(t) * 4)
	end,}

registerTalentTranslation{
	id = "T_SOLAR_WIND",
	name = "太阳风",
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local slow = t.getSlowFromSpeed(speed)
		return ([[开启时, 增加发射出去的抛射物 %d%% 速度, 减少射向你的抛射物 %d%% 速度. 增加和减少随着你的法术强度提高.]]):
		format(speed, slow)
	end,}

registerTalentTranslation{
	id = "T_LUCENT_WRATH",
	name = "光之愤怒",
	info = function(self, t)
		local delay = t.getDelay(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[%d 回合后, 在 (范围 %d) 的目标区域发出一束激光, 造成 %0.2f 伤害并照明区域.]]):
		format(delay, radius, damDesc(self, DamageType.LIGHT, damage))
		
	end,}

registerTalentTranslation{
	id = "T_LIGHTSPEED",
	name = "光速",
	info = function(self, t)
		local turn = t.getTurn(self, t)
		return ([[立刻获得 %d%% 额外回合.]]):
		format(turn * 100)
	end,}

return _M

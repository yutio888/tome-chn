local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LUNAR_ORB",
	name = "月光之球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local restore = t.getNegative(self, t)
		return ([[向目标方向射出一道宇宙能量. 直到碰到墙或者到达地图边缘, 对敌人造成 %0.2f 的暗影伤害并回复 %d 负能量. 负能量回复量最大为 %d, 每击中一个敌人将少回复 25%% 的负能量, 被击中的敌人将注意到你.]]):
		format(damDesc(self, DamageType.DARKNESS, damage), restore, restore * 4)
	end,}

registerTalentTranslation{
	id = "T_ASTRAL_PATH",
	name = "星光大道",
	info = function(self, t)
		return ([[在 %d 码内发射一个负能量球.
		当负能量球到达目的地时, 会将你传送到其位置.
		其飞行速度 (%d%%) 将随着你的移动速度增加.]]):format(t.range(self, t), t.proj_speed(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_GALACTIC_PULSE",
	name = "银河脉冲",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在 8 码内发出一个缓慢移动的螺旋宇宙能量.
		当它移动时, 会把相邻的目标拉向它, 造成 %0.2f 暗影伤害并每击中一次回复 1 点负能量.]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,}

registerTalentTranslation{
	id = "T_SUPERNOVA",
	name = "超新星",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local pin = t.getPinDuration(self, t)
		return ([[释放你所有的负能量在 %d 码范围内造成 (范围 %d) 的大规模暗能量爆发.
		造成 %0.2f 的暗影伤害并定身被击中的敌人 %d 回合.
		伤害及定身机率随法术强度增加, 伤害、范围、和定身持续时间全部随着负能量和技能等级增加.]]):
		format(radius, self:getTalentRange(t), damDesc(self, DamageType.DARKNESS, damage), pin)
	end,}
return _M
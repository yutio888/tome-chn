local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_OVERGROWTH",
	name = "过度生长",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local slow = t.getSlow(self, t)
		local pin = t.getPin(self, t)
		local radius = self:getTalentRadius(t)
		return ([[瞬间在半径 %d 码的区域内长出苔藓圈。
		每回合苔藓会对其中的敌人造成 %0.2f 的自然伤害。
		这些又厚又粘的苔藓会让途经他们的敌人移动速度下降 %d%% 并且有 %d%% 的几率被定身 4 回合。
		苔藓能持续 %d 回合。
		苔藓技能都是瞬发的，但是会让其他的苔藓技能进入冷却 3 回合。
		伤害会随着你的精神强度增加。]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), slow, pin, duration)
	end,
}

registerTalentTranslation{
	id = "T_TALOSIS_CEASEFIRE",
	name = "停火",
	info = function(self, t)
		return ([[你向一个敌人射出一发威力无穷的子弹，造成 %d%% 伤害并眩晕他们 %d 回合。
		眩晕几率会随着你的蒸汽强度增加。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_GUN_SUREKILL",
	name = "一击必杀",
	info = function(self, t)
		return ([[你向一个敌人射出一发无比致命的子弹，造成 %d%% 伤害。
		如果能杀死敌人，那么伤害会提升你暴击伤害系数的一半。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_SMASH",
	name = "火箭重击",
	info = function(self, t)
		return ([[借助火箭向前突击。
		如果目标地点已被占据，那么你到达的时候会对目标进行一次近战攻击并击退他和任何被他撞到的目标 4 码。
		这个攻击会造成 180% 武器伤害。
		你必须突击至少 2 格。]])
	end,}
registerTalentTranslation{
	id = "T_LASER_POWERED_SMASH",
	name = "激光重击",
	info = function(self, t)
		return ([[释放光锤的终极力量，攻击半径 1 码范围内的所有敌人。
		这一攻击会在每个受影响的目标身上引发半径为 1 的爆炸，造成 50% 武器伤害，并致盲他们 4 回合。]])
	end,
}
return _M
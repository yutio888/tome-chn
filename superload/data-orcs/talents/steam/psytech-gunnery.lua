local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSYSHOT",
	name = "灵能射击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[当使用蒸汽枪时，增加武器伤害 %d%% 。
		当你的子弹击中目标时，你利用动能将副手的灵晶射出，造成 %d%% 武器伤害（必定命中），
		当开启心灵利刃时，灵晶无法被射出。
		能主动使用，造成 %d%% 精神武器伤害。]]):format(inc * 100, t.mindstarMult(self, t) * 100, t.getShootDamage(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_BOILING_SHOT",
	name = "沸腾射击",
	info = function(self, t)
		return ([[使用灵能加热子弹，造成 %d%% 武器伤害。
		子弹命中处于湿润状态的目标时将气化，除去湿润状态，在半径 4 范围内造成 %0.2f 火焰伤害。
		]]):format(100 * t.getDam(self, t), damDesc(self, DamageType.FIRE, t.getSplash(self, t)))
	end,}

registerTalentTranslation{
	id = "T_BLUNT_SHOT",
	name = "迟钝射击",
	info = function(self, t)
		return ([[发射相对低能量的子弹，造成 %d%% 武器伤害。
		子弹命中时将产生 4 码锥形冲击波，震慑范围内所有生物 %d 回合。]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_VACUUM_SHOT",
	name = "真空射击",
	info = function(self, t)
		return ([[将灵能蒸汽装置安装在子弹上，造成 %d%% 武器伤害。
		子弹命中时，将抽取周围空气，吸引半径 %d 范围内所有生物。]])
		:format(100 * t.getDam(self, t), self:getTalentRadius(t))
	end,}
return _M
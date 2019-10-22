local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARROW_STITCHING",
	name = "重叠灵矢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local penalty = t.getDamagePenalty(self, t)
		return ([[发射一支灵矢造成  %d%%  武器伤害，并且根据可用空间，召唤最多两个守卫，各自发射一枚灵矢然后回到他们自己的时间线中。
		守卫处在现实位面之外，灵矢的伤害减少  %d%%  ，但能够穿过友好目标。同时，你发射的所有来自射击或者其他技能的箭矢，都可以穿透友军并且不会造成伤害。
		
		激活螺旋灵弓技能可以自由切换到你的弓（必须装备在副武器栏位上）。此外，当你使用远程攻击时也会触发这个效果。]])
		:format(damage, penalty)
	end,
}

	
registerTalentTranslation{
	id = "T_SINGULARITY_ARROW",
	name = "奇点之矢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local radius = self:getTalentRadius(t)
		local aoe = t.getDamageAoE(self, t)
		return ([[发射一支灵矢造成  %d%%  武器伤害。当灵矢到达目标地点或者击中目标后，会牵引半径  %d  并造成  %0.2f  物理伤害。
		从第二个单位起，每增加一个被牵引的单位，会使伤害增加  %0.2f (最多增加  %0.2f  额外伤害 ).
		目标离牵引中心的距离越远受到的伤害就越低  (每格减少 20%% ).
		受法术强度影响，额外伤害有加成。]])
		:format(damage, radius, damDesc(self, DamageType.PHYSICAL, aoe), damDesc(self, DamageType.PHYSICAL, aoe/8), damDesc(self, DamageType.PHYSICAL, aoe/2))
	end,
}

registerTalentTranslation{
	id = "T_ARROW_ECHOES",
	name = "灵矢回声",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[在下面的  %d  回合中，你从当前所在位置对目标发射最多  %d  支灵矢，每支对目标造成  %d%%  武器伤害。  
		这些射击不消耗弹药。]])
		:format(duration, duration, damage)
	end,
}

registerTalentTranslation{
	id = "T_ARROW_THREADING",
	name = "螺旋灵矢",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		return ([[当你发射的箭矢命中时，将会使你的紊乱值向预设值调谐  %0.2f  点。]])
		:format(tune)
	end,
}

return _M

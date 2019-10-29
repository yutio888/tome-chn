local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ELECTRON_INCANTATION",
	name = "电子充能",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[每当你释放一个科技法术，你都会储存它一部分的能量，用来超载你的奥术发电机。每消耗 10 点法力值就会增加它产生的 4 点蒸汽值，持续 4 回合。
		此外，这些能量会在你周围 3 码半径内溢出，造成 %0.2f 伤害。（伤害类型基于你使用的科技法术的类型）
		这个法术只可以在你刚刚施放了一个科技法术，且中途没有释放过其他法术的时候使用。
		技能伤害受法术强度提升。]]):format(damage)
	end,
}

return _M
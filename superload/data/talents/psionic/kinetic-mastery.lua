local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_TELEKINESIS",
	name = "卓越动能",
	info = function(self, t)
		return ([[在 %d 回合中你的动能突破极限，增加你的物理伤害 %d%% ，物理抗性穿透 %d%% 。
		额外效果：
		重置动能护盾，动能吸取，动能光环和心灵鞭笞的冷却时间。
		根据情况，动能光环获得其中一种强化：动能光环的半径增加为 2 格。你的所有武器获得动能光环的伤害加成。
		你的动能护盾获得 100%% 的吸收效率，并可以吸收两倍伤害。
		心灵鞭笞附带震慑效果。
		动能吸取会使敌人进入睡眠。
		动能打击会对相邻的两个敌人进行攻击。
		受精神强度影响，伤害和抗性穿透有额外加成。
		同一时间只有一个卓越技能产生效果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_KINETIC_SURGE",
	name = "动能爆发",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[
		使用你的念动力增强你的力量，使你能够举起一个相邻的敌人或者你自己并投掷到半径 %d 范围的任意位置。 
		敌人落地时受到 %0.1f 物理伤害，并被震慑 %d 回合。落点周边半径 2 格内的所有其他单位受到 %0.1f 物理伤害并被从你身边被退。
		这个技能无视被投掷目标 %d%% 的击退抵抗，如果目标抵抗击退，只受到一半伤害。
		
		对你自己使用时，击退线路上所有目标并造成  %0.1f 物理伤害。
		同时能破坏至多 %d 面墙壁。
		受精神强度影响，伤害和投掷距离有额外加成。 ]]):
		format(range, dam, math.floor(range/2), dam/2, t.getKBResistPen(self, t), dam, math.floor(range/2))
	end,
}

registerTalentTranslation{
	id = "T_DEFLECT_PROJECTILES",
	name = "弹道偏移",
	info = function(self, t)
		local chance, spread = t.getEvasion(self, t)
		return ([[你学会分配一部分注意力，用精神力击落、抓取或偏斜飞来的发射物。 
		所有以你为目标的发射物有 %d%% 的几率落在半径 %d 格范围内的其他地点。
		如果你愿意，你可以使用精神力来抓住半径 10 格内的所有发射物，并投回以你为中心半径 %d 格内的任意地点，这么做会打断你的集中力，并使这个持续技能进入冷却。
		要想这样做，取消该持续技即可。]]):
		format(chance, spread, self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	id = "T_IMPLODE",
	name = "碎骨压制",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[用粉碎骨头的力量紧紧锁住目标，定身并减速目标 50%% ，持续  %d 回合，每回合造成 %0.1f 物理伤害。
		受精神强度影响，持续时间和伤害有额外加成。]]):format(dur, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M

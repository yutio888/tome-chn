local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DWARVEN_HALF_EARTHEN_MISSILES",
	name = "岩石飞弹",
	info = function(self, t)
		local count = 2
		if self:getTalentLevel(t) >= 5 then
			count = count + 1
		end
		local damage = t.getDamage(self, t)
		return ([[释放出 %d 个岩石飞弹射向任意射程内的目标。每个飞弹造成 %0.2f 物理伤害和每回合 %0.2f 流血伤害，持续 5 回合。 
		 在等级 5 时，你可以额外释放一个飞弹。 
		 受法术强度影响，伤害有额外加成]]):format(count,damage/2, damage/12)
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_SPLIT",
	name = "元素分裂",
	info = function(self, t)
		return ([[深入你的矮人血统，召唤岩石和水晶分身为你作战，持续 %d 回合。
		水晶分身会使用飞弹攻击敌人。
		岩石分身会嘲讽敌人来保护你。
		处于深岩形态时，该技能不能使用。
		]]):format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POWER_CORE",
	name = "能量核心",
	info = function(self, t)
		return ([[你的分身学会新的技能。
		水晶分身 : 尖刺之雨——被动技能，令周围敌人流血。
		岩石分身 : 岩石链接——一层保护护盾，将周围友方受到的所有伤害转移至岩石分身。
		技能等级为 %d 。]]):
		format(math.floor(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_DWARVEN_UNITY",
	name = "矮人的团结",
	info = function(self, t)
		return ([[你呼唤你的分身的帮助。
		岩石分身将和你交换位置，同时原位置半径 %d 内的敌人将会转为以岩石分身为目标。
		水晶分身将立即发射等级 %d 的岩石飞弹，目标是岩石分身（如死亡，则改为你自己）半径 %d 周围的敌人。]]):
		format(self:getTalentRadius(t), self:getTalentLevelRaw(t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_MERGEBACK",
	name = "重吸收",
	info = function(self, t)
		local nb = t.getRemoveCount(self, t)
		local dam = t.getDamage(self, t)
		local heal = t.getHeal(self, t)
		return ([[重吸收你的分身，清除合计至多 %d 个负面状态。
		每个分身将治疗你 %d 生命值，并在半径 3 的范围内造成 %0.2f 点自然伤害。]]):
		format(nb, heal,dam)
	end,
}

registerTalentTranslation{
	id = "T_STONE_LINK",
	name = "岩石链接",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制造一层半径 %d 的护盾，将友方受到的伤害转移过来，持续 5 回合。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_RAIN_OF_SPIKES",
	name = "岩刺之雨",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[ 在身边发射尖刺，半径 %d 内的敌人在 6 回合内流血 %0.2f 点。
		伤害受法术强度加成。]]):format(radius, dam)
	end,
}


return _M

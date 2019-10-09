local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRIKING_STANCE",
	name = "攻击姿态",
	info = function(self, t)
		local attack = t.getAttack(self, t)
		local damage = t.getDamage(self, t)
		return ([[增加你 %d 命中。你攻击系技能 ( 拳术、终结技 ) 伤害增加 %d%% , 同时减少 %d 受到的伤害。
		受敏捷影响，伤害按比例加成。受力量影响，伤害减免有额外加成。 ]]):
		format(attack, damage, t.getFlatReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DOUBLE_STRIKE",
	name = "双重打击",
	message = "@Source@ 打出两记快拳.",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对目标进行 2 次快速打击，每次打击造成 %d%% 伤害并使你的姿态切换为攻击姿态，如果你已经在攻击姿态且此技能已就绪，那么此技能会自动取代你的普通攻击 ( 并触发冷却 )。 
		任何一次打击都会使你获得 1 点连击点。在等级 4 或更高等级时若 2 次打击都命中你可以获得 2 点连击点。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_SPINNING_BACKHAND",
	name = "旋风打击",
	message = "@Source@ 使出旋风拳法",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local charge =t.chargeBonus(self, t, t.range(self, t)-1)*100
		return ([[对你面前的敌人使用一次旋风打击，造成 %d%% 伤害。 
		如果你离目标较远，旋转时你会自动前行，根据移动距离增加至多 %d%% 伤害。 
		此次攻击会移除任何你正在维持的抓取效果并增加 1 点连击点。 
		在等级 4 或更高时，你每次连击均会获得 1 点连击点。 ]])
		:format(damage, charge)
	end,
}

registerTalentTranslation{
	id = "T_AXE_KICK",
	name = "斧踢",
	message = "@Source@ 抬起腿使出毁灭斧踢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[ 施展一次毁灭性的的踢技，造成 %d%% 伤害。
		 如果攻击命中，对方的大脑受到伤害，不能使用技能，持续 %d 回合，同时你获得 2 连击点。 ]])
		:format(damage, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLURRY_OF_FISTS",
	name = "流星拳",
	message = "@Source@ 打出流水般的快拳.",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对目标造成 3 次快速打击，每击造成 %d%% 伤害。 
		此攻击使你得到 1 点连击点。 
		在等级 4 或更高时，你每次连击都可以获得 1 点连击点。]])
		:format(damage)
	end,
}


return _M

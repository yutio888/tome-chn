local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ABSORPTION_STRIKE",
	name = "吸能一击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 你用双手武器攻击敌人，造成 %d%% 武器伤害。
		 如果攻击命中，半径 2 以内的敌人光系抗性下降 %d%% ，伤害下降 %d%%, 持续 5 回合。]]):
		format(100 * damage, t.getWeakness(self, t), t.getNumb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MARK_OF_LIGHT",
	name = "光之印记",
	info = function(self, t)
		return ([[你用光标记目标 3 回合，你对它近战攻击时，将受到相当于 %d%% 伤害的治疗。]]):
		format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RIGHTEOUS_STRENGTH",
	name = "光明之力",
	info = function(self, t)
		return ([[ 当装备双手武器时，你的暴击率增加 %d%%, 同时你的近战暴击会引发光明之力，增加 %d%% 物理和光系伤害加成，最多叠加 3 倍。
		同时，你的近战暴击会在目标身上留下灼烧痕迹， 5 回合内造成 %0.2f 光系伤害，同时减少 %d 护甲。
		伤害受法强加成。]]):
		format(t.getCrit(self, t), t.getPower(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getArmor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLASH_OF_THE_BLADE",
	name = "闪光之刃",
	info = function(self, t)
		return ([[ 旋转一周，同时将光明之力充满武器。
		 半径 1 以内的敌人将受到 %d%% 武器伤害，同时半径 2 以内的敌人将受到 %d%% 光系武器伤害。
		 技能等级 4 或以上时，在旋转时你会制造一层护盾，吸收 1 回合内的所有攻击。]]):
		format(t.get1Damage(self, t) * 100, t.get2Damage(self, t) * 100)
	end,
}

return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FLAME_LEASH",
	name = "火焰束缚",
	info = function(self, t)
		return ([[火焰触须从你的手中伸出，在锥形范围内伸展。
		被火焰触须抓住的生物将被拉过来，同时移动速度减少 %d%% ，持续 4 回合。
		每个触须会留下火焰痕迹，每回合造成 %0.2f 火焰伤害，持续 4 回合。
		伤害受法术强度加成。]])
		:format(t.getSlow(self, t) * 100, t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_BLADE",
	name = "恶魔之刃",
	info = function(self, t)
		return ([[向你的武器灌输火焰之力，持续 5 回合。
		每次近战攻击时会释放一个火球，在半径 1 的范围内造成 %0.2f 火焰伤害。
		这个效果每回合只能触发一次。
		伤害受法术强度加成。]]):
		format(t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_LINK_OF_PAIN",
	name = "苦痛链接",
	info = function(self, t)
		return ([[使用恶魔之力，你在源生物与牺牲生物间构造痛苦链接，持续 %d 回合。
		每次源生物受到伤害时， %d%% 伤害由牺牲生物承受。
		当牺牲生物因此效果死亡时，你将获得能量，减少所有技能冷却时间 1 回合。]]):
		format(t.getDur(self, t), t.getPower(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_HORNS",
	name = "恶魔之角",
	info = function(self, t)
		return ([[你的盾牌上长出临时的恶魔之角。
		你盾击敌人造成 %d%% 伤害。
		如果攻击命中，目标将被恶魔角刺穿，流血 5 回合，合计受到额外 50%% 黑暗伤害。
		每次你攻击被恶魔角刺穿的目标时，你回复 %d 生命 (每回合至多 1 次 )。
		治疗效果受法术强度加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 2, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), t.getHeal(self, t))
	end,
}


return _M

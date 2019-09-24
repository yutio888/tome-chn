local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BONE_SPEAR",
	name = "白骨之矛",
		info = function(self, t)
		return ([[ 释 放 一 根 骨 矛， 对 一 条 线 上 的 目 标 造 成 %0.2f 物 理 伤 害。这些目标每具有一个魔法负面效果，就额外受到%d%%的伤害。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.PHYSICAL, t.getBonus(self, t)*100))
	end,
}

registerTalentTranslation{
	id = "T_BONE_GRAB",
	name = "白骨之握",
	info = function(self, t)
		return ([[抓住目标将其传送到你的身边，或将身边的目标丢到最多6格之外。从地上冒出一根骨刺，将其定在那里，持续%d回合。
		骨刺同时也会造成%0.2f物理伤害。
		伤害受法术强度加成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_BONE_SPIKE",
	name = "白骨尖刺",
	info = function(self, t)
		return ([[每当你使用一个非瞬发的技能，你朝周围所有具有3个或以上魔法负面效果的敌人射出骨矛，对一条直线上的敌人造成%d伤害。
		伤害受法术强度加成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)) )
	end,
}

registerTalentTranslation{
	id = "T_BONE_SHIELD",
	name = "白骨护盾",
	info = function(self, t)
		return ([[制造一圈白骨护盾围绕你。每个护盾能完全吸收一次攻击伤害。
		启动时制造%d个骨盾。
		如果你的骨盾不满，每%d个回合将会自动补充一层骨盾。
		这一技能只会在攻击伤害超过%d时触发，受法术强度加成。]]):
		format(t.getNb(self, t), t.getRegen(self, t), t.getThreshold(self, t))
	end,
}



return _M

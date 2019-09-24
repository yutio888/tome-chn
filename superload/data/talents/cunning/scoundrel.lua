local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LACERATING_STRIKES",
	name = "撕裂挥击",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[你的近战和远程攻击有%d%%的几率撕裂敌人，使其在4回合内受到100%%的额外流血伤害。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_SCOUNDREL",
	name = "街霸战术",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local crit = t.getCritPenalty(self, t)
		local dur = t.getDuration(self,t)
		return ([[你的近战和远程攻击制造的伤口会使敌人分心，使目标的暴击系数减少%d%%，持续5回合。
		此外，你的攻击还有%d%%的几率造成痛苦的创伤，使敌人随机遗忘一项技能，持续%d回合。这一效果每回合最多只能触发一次。]]):format(crit, chance, dur)
	end,
}



registerTalentTranslation{
	id = "T_MISDIRECTION",
	name = "误导",
	info = function(self, t)
		return ([[你 制 造 混 乱 的 技 巧 已 趋 于 巅 峰。 现 在， 即 便 是 你 最 简 单 的 动 作 也 会 迷 惑 敌 人， 使 他 们 看 不 透 你 的 行 踪。 
		 敌 人 试 图 对 你 施 加 物 理 负 面 状 态 时，有 %d%% 几 率失败。此外，如果你周围有敌人，这一效果将会被转移到这个敌人身上，持 续 时 间 变 为 %d%%。 
		 你获得%d闪避。
		 施 加 负 面 状 态 几 率 受 命 中 影 响。闪避加成受灵巧影响]]):
		 format(t.getChance(self,t),t.getDuration(self,t), t.getDefense(self, t))
		end,
}
registerTalentTranslation{
	id = "T_FUMBLE",
	name = "笨拙",
	info = function (self,t)
		local stacks = t.getStacks(self, t)
		local dam = t.getDamage(self, t)
		return ([[你的近程和远程攻击会让敌人难以集中精力于复杂的行动，在下一次使用技能时有3%%的几率失败，这一效果可以叠加，最多叠加至%d%%。
		如 果因任何原因，敌人技 能 使 用 失 败 ，对 方 将 弄 伤 自 己 ，造 成 %0.2f 物 理 伤 害。
		如果敌人是因笨拙效果而技能使用失败，将会移除笨拙效果。
		伤 害 受 灵 巧 加 成 。
	   ]]):format(stacks*3, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M

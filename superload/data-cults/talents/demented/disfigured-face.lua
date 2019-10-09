local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DISEASED_TONGUE",
	name = "疫病之舌",
	info = function(self, t)
		return ([[ 你的舌头化作疫病触手，让你能 #{italic}#舔舐#{normal}# 锥形范围内的敌人。
		被舔舐的敌人受到无视护甲的 %d%% 触手伤害并获得一种持续 %d 回合的随机疾病，每回合造成 %0.2f 枯萎伤害并减少力量、敏捷或体质 %d 点。
		如果你至少命中了一名敌人，你获得 %d 疯狂值。
		疾病伤害随法术强度而增加。]]):
		format(
			t.getDamageTentacle(self, t) * 100,
			t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamageDisease(self, t)), t.getDiseasePower(self, t),
			t.getInsanity(self, t)
		)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVED_FACE",
	name = "溶解之脸",
	info = function(self, t)
		return ([[你用脸贴近敌人，让其部分融化为血肉，对锥形范围内敌人造成 %0.2f 暗影伤害，持续 5 回合（总伤害 %0.2f ）。
		每回合目标身上的每种疾病将使其受到额外 %0.2f 枯萎伤害。]])
		:format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), damDesc(self, DamageType.BLIGHT, 0.7 * t.getDamage(self, t) / 5))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_HAIRS",
	name = "苦痛之发",
	info = function(self, t)
		return ([[短时间内你的头上生长出恐怖的头发，每根头发的末梢长着一只令人毛骨悚然的眼睛。
		你用这些眼睛凝视目标区域，部分石化范围内目标，降低其 %d%% 移速并使其处于 7 回合的脆弱状态。
		脆弱状态的目标每次受到伤害时有 35%% 几率增加 %d%% 伤害。
		该效果不能被豁免。
		]]):
		format(t.getSpeed(self, t) * 100, t.getBrittle(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLIMPSE_OF_TRUE_HORROR",
	name = "恐怖无边",
	info = function(self, t)
		return ([[ 每次你使用该系技能时，你就能展现何为真正的恐怖。
		如果目标未能通过法术豁免，将处于 2 回合恐惧状态，使用技能有 %d%% 几率失败。
		同时，敌人的恐惧和痛苦能激励你的意志，在 2 回合内增加你 %d%% 暗影和枯萎伤害抗性穿透。
		技能效果受法术强度加成。]]):
		format(t.getFail(self, t), t.getPen(self, t))
	end,
}
return _M

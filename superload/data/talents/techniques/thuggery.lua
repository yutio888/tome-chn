local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKULLCRACKER",
	name = "铁头功",
	info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		return ([[你用前额猛击敌人头部（或者任意你能找到的有效位置），造成 %0.2f 物理伤害。如果 
		此次攻击命中，则目标会混乱( %d%% 强度) %d 回合。 
		受头盔品质、力量和物理伤害影响，伤害有额外加成。 
		混乱强度受敏捷加成，几率受命中加成。]]):
		format(dam, t.getConfusion(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_VICIOUS_STRIKES",
	name = "恶毒打击",
	info = function(self, t)
		return ([[你知道如何击中目标弱点，使你获得 +%d%% 暴击伤害加成和 %d 护甲穿透。]]):
		format(t.critpower(self, t), t.getAPR(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RIOT-BORN",
	name = "黑暗出生",
	info = function(self, t)
		return ([[你与生俱来的暴力意识令你在战斗中获得 %d%% 震慑和混乱免疫。]]):
		format(t.getImmune(self, t)*100)
	end,
}
registerTalentTranslation{
	id = "T_TOTAL_THUGGERY",
	name = "不择手段",
	info = function(self, t)
		return ([[你疯狂地杀戮，试图尽快击倒你的敌人。 
		增加 %d%% 攻击速度， %d%% 暴击率和 %d%% 物理抵抗穿透，但是每次攻击消耗 6 点体力。
		该效果在休息或者奔跑时自动解除。
		]]):
		format(t.getSpeed(self,t)*100, t.getCrit(self, t), t.getPen(self, t))
	end,
}


return _M

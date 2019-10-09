local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEIGHTENED_SENSES",
	name = "强化感知",
	info = function(self, t)
		return ([[你注意到他人注意不到的细节，甚至能在阴影区域“看到”怪物， %d 码半径范围。 
		 注意此能力不属于心灵感应，仍然受到视野的限制。 
		 同时你的细致观察也能使你发现周围的陷阱 ( %d 侦查强度 )。  
		 受灵巧影响，陷阱侦查强度有额外加成。]]):
		format(t.sense(self,t),t.seePower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DEVICE_MASTERY",
	name = "装置掌握",
	info = function(self, t)
		return ([[你灵活的头脑，使你可以更加有效的使用装置（魔杖、图腾和项圈），减少 %d%% 饰品的冷却时间。
		同时，你对装置的知识让你能够解除被发现的陷阱（+ %d 解除强度，随灵巧提升）。
		]]):
		format(t.cdReduc(self, t), t.trapDisarm(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TRACK",
	name = "追踪",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		return ([[感知范围 %d 内的敌人，持续 %d 回合。
		范围随灵巧提升而提升。]]):format(rad, t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DANGER_SENSE",
	name = "危机感知",
	info = function (self,t)
		return ([[你拥有了更高级  的自我保护感知力，敏锐的直觉让你察觉到他人会忽略的危险。
		你感知陷阱的能力提升了（ +%d 点侦察强度）。
		对你发动的攻击的暴击率减少 %0.1f%% ，同时潜行单位因未被发现而对你造成的额外伤害的倍率减小 %d%% 。
		你获得一次机会重新抵抗未成功抵抗的负面效果，豁免为正常豁免 %d 。
		侦测点数和豁免  随灵巧提升。]]):
		format(t.trapDetect(self, t), t.critResist(self, t), t.getUnseenReduction(self, t)*100, -t.savePenalty(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DISARM_TRAP",
	name = "解除陷阱",
	info = function (self,t)
		local tdm = self:getTalentFromId(self.T_DEVICE_MASTERY)
		local t_det, t_dis = self:attr("see_traps") or 0, tdm.trapDisarm(self, tdm)
		return ([[你搜索周围地格的陷阱（ %d 侦察强度），并尝试解除 ( %d 解除强度，基于技能 %s)。
		解除陷阱有最低技能等级需求，且你必须能够移动到陷阱的所在格，尽管你仍然留在你的当前位置。
		解除陷阱失败可能会触发陷阱。
		Your skill improves with your your Cunning.]]):format(t_det, t_dis, tdm.name)
	end,
}
return _M

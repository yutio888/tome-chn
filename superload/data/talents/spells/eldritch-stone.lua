local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_SPIKES",
	name = "岩石尖刺",
	info = function(self, t)
		local xs = ""
		if self:knowTalent(self.T_POISONED_SPIKES) then
			xs = ("中毒 6 回合受到合计 %0.1f 点自然伤害（同时减少 %d%% 治疗效果） "):format(self:callTalent(self.T_POISONED_SPIKES, "getDamage"), self:callTalent(self.T_POISONED_SPIKES, "getHeal"))
		end
		if self:knowTalent(self.T_ELDRITCH_SPIKES) then
			xs = xs..(", 受到 %0.1f 点奥术伤害（同时沉默 %d 回合）,"):format(self:callTalent(self.T_ELDRITCH_SPIKES, "getDamage"), self:callTalent(self.T_ELDRITCH_SPIKES, "getSilence"))
		end
		if self:knowTalent(self.T_IMPALING_SPIKES) then
			xs = xs..(" 受到 %0.1f 点物理伤害（同时缴械 %d 回合）,"):format( self:callTalent(self.T_IMPALING_SPIKES, "getDamage"), self:callTalent(self.T_IMPALING_SPIKES, "getDisarm"))
		end
		return ([[在半径 %d 的锥形范围内，从地下爆发岩石尖刺。
		范围内的生物将 %s 在 6 回合内受到 %0.1f 物理伤害。
		伤害受法术强度加成，负面状态附加几率受法术强度和物理强度较高一项影响。]])
		:format(self:getTalentRadius(t), xs ~="" and xs.." 并 " or "", t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISONED_SPIKES",
	name = "剧毒尖刺",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用毒素覆盖岩石尖刺，使生物中毒 6 回合，造成合计 %0.1f 自然伤害，并减少 %d%% 治疗效果。]]):
		format( t.getDamage(self, t), t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_SPIKES",
	name = "奥术尖刺",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用奥术能量填充岩石尖刺，造成 %0.1f 奥术伤害，并沉默 %d 回合。]]):
		format( t.getDamage(self, t), t.getSilence(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPALING_SPIKES",
	name = "穿透尖刺",
	info = function(self, t)
		return ([[强化你的岩石尖刺，造成 %0.1f 物理伤害，并缴械 %d 回合。]]):
		format( t.getDamage(self, t), t.getDisarm(self, t))
	end,
}


return _M

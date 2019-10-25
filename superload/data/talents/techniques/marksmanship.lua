local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASTER_MARKSMAN",
	name = "射击精通",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reload = t.getReload(self,t)
		local chance = t.getChance(self,t)
		return ([[使用弓和投石索时 %d%% 武器伤害， 30物理强度和 %d 填弹速度。
		射击技能有 %d%% 几率标记目标。
		标记持续 5 回合，令你能感知到目标，同时让他们面对爆头、齐射和精巧射击更脆弱。]]):
format(inc * 100, reload, chance)
	end,
}
registerTalentTranslation{
	id = "T_FIRST_BLOOD",
	name = "第一滴血",
	info = function (self,t)
		local bleed = t.getBleed(self,t)*100
		local sta = t.getStamina(self,t)
		return ([[你趁敌人尚未防备（90%% 血量以上）施展攻击，射击、稳固射击和爆头使敌人流血 5 回合造成额外 %d%% 伤害，标记概率增加 50%% 。
此外，你的射击、稳固射击和爆头回复 %0.1f 体力。]])
		:format(bleed, sta)
	end,
}
registerTalentTranslation{
	id = "T_FLARE",
	name = "闪光弹",
	info = function (self,t)
		local blind = t.getBlindDuration(self,t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local def = t.getDefensePenalty(self,t)
		return ([[发射闪光弹，致盲敌人 %d 回合, 标记他们 2 回合并照亮 %d 格范围 %d 回合。范围内的敌人降低 %d 闪避和潜行强度，不能从隐匿技能得到任何加成。
		状态效果几率受命中加成，闪避削减受敏捷加成。]])
		:format(blind, rad, dur, def)
	end,
}
registerTalentTranslation{
	id = "T_TRUESHOT",
	name = "专注射击",
	info = function (self,t)
		local dur = t.getDuration(self,t)
		local speed = t.getSpeed(self,t)*100
		local mark = t.getMarkChance(self,t)
		return ([[进入专注状态 %d 回合，远程攻击速度增加 %d%% ，射击不消耗弹药，标记概率增加 %d%% 。]]):
		format(dur, speed, mark)
	end,
}

return _M

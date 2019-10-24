local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_JINXED_TOUCH",	
	name = "厄运之触",
	info = function(self, t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		return ([[你的触碰伴随着熵之诅咒，为目标带来悲惨的命运。每当你对目标造成伤害时，目标将被厄运诅咒 5 回合。厄运可以叠加 10 层，每层减少 %0.2f 豁免和防御， %0.2f%% 暴击率。
		每个目标每回合只能受到一层诅咒。如果在过去 2 回合里目标消失在你的视线中，所有诅咒都会消退。]]):
		format(saves, crit)
	end,
}
registerTalentTranslation{
	id = "T_PREORDAIN",	
	name = "命中注定",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[你微妙地影响因果，让你的敌人更加不幸。六层以上的每层厄运诅咒将使敌人获得 %d%% 技能失败率。]]):
		format(chance)
	end,
}
registerTalentTranslation{
	id = "T_LUCKDRINKER",	
	name = "幸运汲取",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		local avoid = t.getAvoid(self,t)
		return ([[每当你向敌人施加厄运诅咒，有 %d%% 几率吸取敌人的运气为你所用，持续 5 回合。这个效果最多叠加 10 层，每层增加 %0.2f 豁免和防御， %0.2f%% 暴击率。
		如果你同时学  会了命中注定，六层以上的每层幸运使你获得 %d%% 几率完全避免受到的伤害。]]):
		format(chance, saves, crit, avoid)
	end,
}
registerTalentTranslation{
	id = "T_FATEBREAKER",	
	name = "打破宿命",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local life = t.getLife(self,t)
		return ([[在你和目标之间建立一个持续 %d 回合的命运链接。如果在这期间你收到了致命的伤害，你将条件反射般扭曲现实，尝试迫使目标在你的位置死亡并中断连接。 
		在 1 回合内，只要目标还活着，你会将所有受到的伤害作为时空和暗影伤害转移给目标。
		同时，你身上的幸运效果和目标携带的厄运效果将被消耗，每层  效果将会治疗 %d 点生命值。]]):
		format(dur, life)
	end,
}
return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMERGENCY_STEAM_PURGE",
	name = "紧急蒸汽净化",
	info = function(self, t)
		return ([[你打开所有蒸汽阀，释放半径 %d 的蒸汽冲击波，造成 %0.2f 火焰伤害。
		若你有至少 50 点蒸汽，气体的温度将变得极高，能烧伤感知器官，令受影响的生物目盲 %d 回合。 
		效果受当前蒸汽值加成。 1 点蒸汽值时，强度仅为 1 0 0 点蒸汽值的 15%% 。
		当前强度系数 %d%% 。]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getDur(self, t), t.getFactor(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_INNOVATION",
	name = "创新",
	info = function(self, t)
		return ([[你对物理学的了解令你能以全新的方式改进装备。
		增加大师制作或者蒸汽科技的装备提供的属性、豁免、护甲和闪避 %d%% 。]])
		:format(t.getFactor(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_TINKERS",
	name = "插件超频",
	info = function(self, t)
		return ([[消耗大量蒸汽，令所有配件和蒸汽技能超频工作 %d 回合。
		超频期间，你获得 %d 蒸汽强度和 %d 蒸汽技能暴击率。 ]])
		:format(t.getDur(self, t), t.getBoost(self, t))
	end,}

registerTalentTranslation{
	id = "T_LAST_ENGINEER_STANDING",
	name = "背水一战",
	info = function(self, t)
		return ([[成为大师意味着你经历了更多危险，你的计算力也超越凡人。
		增加 %d 灵巧， %d 物理豁免， %d%% 自身伤害抗性， %d%% 几率避免暴击。]])
		:format(self:getTalentLevel(t) * 2, t.physSave(self, t), t.selfResist(self, t), t.critResist(self, t))
	end,}
return _M
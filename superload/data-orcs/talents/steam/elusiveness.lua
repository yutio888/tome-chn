local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLIP_AWAY",
	name = "身如游鱼",
	info = function(self, t)
		return ([[用小型喷射引擎强化你的机动性，可以穿过直线上连续的 %d 个敌人。
	穿越后，会急速前进 %d 码。 ]])
		:format(t.getRange(self, t), t.getAway(self, t))
	end,}

registerTalentTranslation{
	id = "T_AGILE_GUNNER",
	name = "动若脱兔",
	info = function(self, t)
		local p = self:isTalentActive(t.id)
		local cur = 0
		if p then cur = math.min(p.nb_foes, t.getMax(self, t)) * 20 end
		return ([[被猎杀的危险令你激动不已。
		半径 %d 内每有一个敌人，你获得 20%% 移动速度（最多 %d%% ）。
		当前加成： %d%%。]])
		:format(self:getTalentRadius(t), t.getMax(self, t) * 20, cur)
	end,}

registerTalentTranslation{
	id = "T_AWESOME_TOSS",
	name = "致命翻转",
	info = function(self, t)
		return ([[在惊人的灵巧和科技力量下，你将你的蒸汽枪翻转指向天空，持续旋转 3 回合。
		每回合，蒸汽枪将随机射击 2 次，造成 %d%% 武器伤害。
		效果持续期间，你视为被缴械，不能攻击。
		这场表演如此引人注目，你的敌人都被吸引，使你的伤害抗性增加 %d%%。]])
		:format(100 * t.getMultiple(self, t), t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_DAZZLING_JUMP",
	name = "炫目大跳",
	info = function(self, t)
		return ([[当你的敌人被致命翻转吸引时，你启动强力的蒸汽引擎，跳向空中，将目标踢走 %d 码。 
		这次攻击冲击力非常大，半径 3 以内所有生物将被减速 %d%% ，持续 4 回合。
		反冲力也让你后退 %d 码。]])
		:format(t.getRange(self, t), t.getSlow(self, t), t.getAway(self, t))
	end,}
return _M
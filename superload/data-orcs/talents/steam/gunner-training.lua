local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMGUN_MASTERY",
	name = "蒸汽枪掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[当你使用蒸汽枪时，增加 30 物理强度和 %d%% 武器伤害。
		你的装填弹药速率增加 %d 。]]):format(inc * 100, reloads)
	end,}

registerTalentTranslation{
	id = "T_DOUBLE_SHOTS",
	name = "双重射击",
	info = function(self, t)
		return ([[你快速地射击两次，每次射击造成 %d%% 伤害，并震慑目标 %d 回合。
		震慑成功率受蒸汽强度加成。]]):format(100 * t.getMultiple(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCANNY_RELOAD",
	name = "神秘装填",
	info = function(self, t)
		return ([[你集中精力于蒸汽枪弹药 %d 回合。
		效果持续期间不消耗弹药。]])
		:format(t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_STATIC_SHOT",
	name = "静电射击",
	info = function(self, t)
		return ([[你射出一发特制电击子弹。
		子弹击中目标时，将变形为闪电榴弹，电击 %d 范围内所有目标，造成 %d%% 电击武器伤害。
		被电击的目标失去至多 %d 项非魔法效果（仅第一发有效）。
		该技能不消耗弹药。]])
		:format(self:getTalentRadius(t), 100 * t.getMultiple(self, t), t.getRemoveCount(self, t))
	end,}
return _M
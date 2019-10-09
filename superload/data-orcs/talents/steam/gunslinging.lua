local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRAFE",
	name = "扫射",
	info = function(self, t)
		local nb = t.getNb(self, t)
		return ([[你学会如何在移动中射击。
		在射击（100%% 武器伤害，射程 -1 ）的同时你能移动到相邻的一格。
		该技能在冷却前能激活连续 %d 个回合，消耗时间取决于蒸汽速度和移动速度较慢者。
		扫射结束后，你立刻获得 %d 到 %d 弹药（取决于扫射期间你消耗的弹药与你的弹药容量）。]]):
		format(nb, t.getReload(self, t, 1), t.getReload(self, t, nb + 1))
	end,}

registerTalentTranslation{
	id = "T_STARTLING_SHOT",
	name = "惊艳射击",
	info = function(self, t)
		return ([[你故意朝目标射出偏离的子弹，令其惊讶 3 回合。
		若目标未通过精神豁免检定，将后退 2 步。
		惊讶状态下的目标在下一次攻  击中将受到额外 %d%% 伤害。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1.5, 3))
	end,}

registerTalentTranslation{
	id = "T_EVASIVE_SHOTS",
	name = "反击射击",
	info = function(self, t)
		return ([[开启引擎强化反射神经，你能进行反击射击 , 造成 %d%% 武器伤害。
		反击射击是当你闪避或躲避近战、远程攻击时触发的自动  射击。
		反击射击一回合只能触发一次，且照常消耗弹药。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.5))
	end,}

registerTalentTranslation{
	id = "T_TRICK_SHOT",
	name = "魔术射击",
	info = function(self, t)
		local main, ammo, off = self:hasDualArcheryWeapon("steamgun")
		local accy = main and ammo and self:combatAttackRanged(main.combat, ammo.combat) or 0
		local ricoaccy = 1-t.ricochetAccuracy(self, t)
		return ([[你的灵敏让你能射出同时击中多个敌人的子弹。
		你精确地瞄准敌人，子弹命中后将弹射至其他目标上。
		子弹最多弹射 %d 次，只能在第一个目标周围 5 码范围内弹射，不会命中同一个目标两次。
		第一次命中将造成 %d%% 武器伤害，之后每次弹射下降 %d%% 伤害和 %d （ %d%% ）命中。]]):
		format(t.getNb(self, t), 100 * t.damageMult(self, t), (1-t.ricochetDamage(self, t))*100, accy*ricoaccy, ricoaccy*100)
	end,}
return _M
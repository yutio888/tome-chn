local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TO_THE_ARMS",
	name = "切臂",
	info = function(self, t)
		return ([[用链锯攻击目标手臂，造成 %d%% 武器伤害并尝试致残目标 %d 回合。
		致残状态的敌人造成的伤害减少 %d%% 。
		致残几率受物理强度影响。
		#{italic}#杀人如砍瓜切菜 !#{normal}#]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.6), t.getDuration(self, t), t.getMaim(self, t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTREAM",
	name = "涌血",
	info = function(self, t)
		return ([[你 " 轻柔 " 地将链锯放在目标的伤口上，造成 %d%% 武器伤害并加深伤  口。
		所有流血伤口持续时间增加 %d 回合，伤害增加 %d%% （每项流血最多触发一次）。
		效果触发时，血流将喷射而出，对 4 码锥形范围内所有生物造成 %0.2f 物理伤害。
		伤害受蒸汽强度加成。 
		#{italic}#一切技术，皆为屠杀 !#{normal}#]]):
		format(self:combatTalentWeaponDamage(t, 0.3, 1.1) * 100, t.getDuration(self, t), t.getDamageInc(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SPINAL_BREAK",
	name = "断脊",
	info = function(self, t)
		return ([[你尝试撕裂敌人的脊柱，减少其 %d%% 整体速度 4 回合，并造成 %d%% 武器伤害。
		同时敌人将失去 %d 项物理效果。
		技能等级 3 时，同时除去 %d 项物理或魔法维持技能。
		#{italic}#切碎他们，折磨他们，收割他们！#{normal}#]]):
		format(t.getSlow(self, t) * 100, self:combatTalentWeaponDamage(t, 0.6, 1.5) * 100, t.getRemoveCount(self, t), t.getRemoveCount(self, t))
	end,}


registerTalentTranslation{
	id = "T_GORESPLOSION",
	name = "爆尸",
	info = function(self, t)
		return ([[每次击杀敌人时，将爆炸物和榴弹封入尸体，引发一场半径 %d 的大爆炸。
		任何被击中的敌人将在 6  回合内受到 %0.2f 流血伤害。
		同时榴弹将损伤他们的发声器官，沉默 %d 回合。
		#{italic}#使用战争技术的精华——榴弹。为了制造血和骚乱！#{normal}#]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t) / 6), t.getDuration(self, t))
	end,}

return _M
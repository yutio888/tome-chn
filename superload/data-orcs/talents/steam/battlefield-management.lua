local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SAWWHEELS",
	name = "链锯轮滑",
	info = function(self, t)
		return ([[把链锯深深插入地面，作为履带，增强自己的行动能力（移动速度增加 %d%% ）。
		在你移动路线两侧的敌人被链锯割断，被击退 3 码。
		攻击或者使用其他技能的动作都会中断效果 , 同时冲击力对周围的敌人造成 %d%% 武器伤害。你需要至少移动五次来达到最高伤害，否则伤害会降低。若不移动则没有伤害。 
		#{italic}#冲锋！死亡之轮！！#{normal}#]]):
		format(t.getSpeed(self, t), self:combatTalentWeaponDamage(t, 1, 2) * 100)
	end,}

registerTalentTranslation{
	id = "T_GRINDING_SHIELD",
	name = "利齿护盾",
	getSawwheelDamage = function(self, t) return math.floor(self:combatTalentScale(t, 10, 80)) end,
	info = function(self, t)
		local ev, spread = t.getEvasion(self, t)
		local flat = t.getFlatMax(self, t)
		return ([[围绕自身快速旋转链锯，形成一堵链锯齿形成的墙壁。
		所有近战伤害降低 %d%% ，有 %d%% 的概率回避投射物，并且受到的一击伤害不会超过最大生命值的 %d%% 。
		#{italic}#用死亡链锯拆了他们的骨头！！#{normal}#]])
		:format(ev, ev, flat)
	end,}

-- Core highest damage potential strike
registerTalentTranslation{
	id = "T_PUNISHMENT",
	name = "惩戒",
	info = function(self, t)
		return ([[用链锯猛力拍击目标，造成 100%% + 每个物理、魔法或者精神状态 %d%% 加成的伤害（最多 7 个）。
		持续技能不视作状态。
		#{italic}# 钢铁惩戒！！#{normal}#]]):
		format(t.getBonus(self, t))
	end,}

-- Needs new bonus for Saw Wheels
registerTalentTranslation{
	id = "T_BATTLEFIELD_VETERAN",
	name = "战场老兵",
	info = function(self, t)
		return ([[你是一名坚毅的老兵，经历了大量战争仍然能够幸存，有着丰富的战斗经验。
		链锯轮滑的伤害增加 %d%% 。
		利齿护盾让你超越生存下限，在 -%d 的生命下仍然生存。
		惩戒有 %d%% 的概率触发：对象每具备一个效果，就降低惩戒 1 回合冷却时间。
		#{italic}#一切尽在掌控！！#{normal}#]]):
		format(t.getSawwheelDamage(self, t), t.getLife(self, t), t.getChance(self, t))
	end,}
return _M
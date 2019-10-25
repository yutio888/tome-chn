local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEMON_SEED_FIRE_BOLTS",
	name = "近战火球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[当你近战攻击命中时，有 %d%% 几率释放至多 %d 个火球，造成 %0.2f 点火焰伤害。
		伤害受法术强度加成]]):
		format(self:getTalentLevel(t) * 5 + 20, 1+math.ceil(self:getTalentLevel(t) / 2), damage)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_FIERY_CLEANSING",
	name = "火焰净化",
	info = function(self, t)
		return ([[消耗 10%% 最大生命值，解除至多 %d 个负面状态。]]):
		format(t.getNb(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_FARSTRIKE",
	name = "远程打击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[扔出武器攻击远处敌人，造成 %d%% 武器伤害。]]):
		format(t.getDamage(self, t)*100)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_CORROSIVE_SLASHES",
	name = "腐蚀鞭笞",
	info = function(self, t)
		return ([[用酸液覆盖武器，近战伤害转变为酸性。
		近战攻击获得 %d 护甲穿透。]]):
		format(t.getArmorPen(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACIDIC_BATH",
	name = "酸浴",
	info = function(self, t)
		return ([[在半径 4 的范围内制造持续 %d 回合的酸池，造成 %0.2f 酸性伤害（包括自己）。
		你获得 40%% 酸性抗性与 %d%% 酸性伤害吸收。
		伤害受法术强度加成。
		The damage scales with your Spellpower.]]):
		format(t.getDuration(self, t),t.getDamage(self, t), t.getAffinity(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_BLIGHTED_PATH",
	name = "枯萎之路",
	info = function(self, t)
		return ([[每次你行走、移动时，你获得一次枯萎充能。你最多能积累 %d 次充能。
		当你取消该技能时，你能选择回复自己或攻击近身目标。每次充能可以回复 %0.2f 点活力或造成 %0.2f 枯萎伤害。
		伤害受法术强度加成。]]):
		format(t.getMaxCharges(self, t), t.getVim(self, t),t.getDamage(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_CORRUPT_LIGHT",
	name = "腐化之光",
	info = function(self, t)
		return ([[在半径 %d 范围内扩散黑暗。每一块原本被照亮的地形，都在接下来的 %d 回合里增加你的伤害。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_SHADOWMELD",
	name = "暗影融合",
	info = function(self, t)
		return ([[每当你站在黑暗地形时，你能与黑暗融合，获得 %d 潜行强度。
		你的灯具不会计算在内，同时效果激活时灯具将自动关闭。
		移动会取消该效果。
		潜行强度受法术强度加成。]]):
		format(t.getStealth(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_BLOOD_SHIELD",
	name = "鲜血护盾",
	info = function(self, t)
		return ([[在盾牌中引导毁灭之力，使你受到的全体伤害减少 15%% 格挡值。
		每次你被近战攻击命中时，你的盾牌会自动反击，造成 %d%% 格挡值的火焰暗影混合伤害。]]):
		format(0.35 * t.getPercent(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_SILENCE",
	name = "沉默",
	info = function(self, t)
		return ([[腐化目标，使之沉默 %d 回合。]]):
		format(t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_FIERY_PORTAL",
	name = "火焰传送门",
	info = function(self, t)
		return ([[制造两个连接在一起的传送门，持续 %d 回合。]]):
		format(t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_DOOM_TENDRILS",
	name = "末日触须",
	info = function(self, t)
		return ([[你化身为末日之柱，在周围 2 码的范围内产生火焰触须。
		被火焰触须击中的敌人每回合受到 %0.2f 火焰伤害。
		受到伤害的生物同时会被定身。]]):
		format(t.getDamage(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_DOOMED_NATURE",
	name = "自然末日",
	info = function(self, t)
		return ([[你诅咒目标 5 回合，割裂其与自然的联系。
		每次被诅咒的目标试图使用自然力量时，有 %d%% 几率失败并制造一个火球，对半径 1 内的生物造成 %0.2f 火焰伤害。
		伤害受你的意志加成。]]):
		format(t.getChance(self, t), t.getDamage(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACID_BURST",
	name = "酸性爆发",
	info = function(self, t)
		return ([[每次你格挡攻击时，将释放少量酸性气体，在半径 3 的范围内造成持续 %d 回合的 %d 伤害。
		伤害受法术强度加成。]]):
		format( t.getDuration(self,t), t.getDamage(self,t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACID_CONE",
	name = "锥形酸液",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[每次近战暴击时，将释放一股锥形酸液，造成 %d 伤害并融化墙壁。
		伤害受法术强度加成。]]):
		format(damage)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ARMOURED_LEVIATHAN",
	name = "重装上阵",
	info = function(self, t)
		return ([[你利用盾牌来强化自身，力量和魔法增加 10%% 格挡值 ,持续 %d 回合。]]):
		format(t.getDuration(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_FLASH_BLOCK",
	name = "瞬间格挡",
	info = function(self, t)
		return ([[在闪电般的速度中，你瞬间举起盾牌格挡。]]):
		format()
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_BLACKICE",
	name = "黑冰",
	info = function(self, t)
		return ([[每次你用非火焰伤害杀死生物时，你获得一次黑冰充能，持续 20 回合，最多累计 %d 次。
		任何时候，你能消耗一次充能，降低一个生物 %d%% 火焰抗性 7 回合。]]):
		format(t.getStack(self, t), t.getRes(self, t))
	end,
}


return _M

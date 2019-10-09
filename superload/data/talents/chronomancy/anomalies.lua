local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ANOMALY_REARRANGE",
	name = "异常：重排",
	message = "@Source@ 引发了时空重排",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[将半径 %d 范围内最多五个单位传送到十格外。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TELEPORT",
	name = "异常：传送",
	message = "@Source@ 改变了现实。",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		return ([[将半径 %d 范围内最多五个单位传送到 %d 格外。]]):format(radius, range)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SWAP",
	name = "异常：换位",
	message = "@Source@ 和周围一个目标交换了位置。",
	info = function(self, t)
		return ([[你和一个随机目标交换位置]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DISPLACEMENT_SHIELD",
	name = "异常：相位护盾",
	message = "@Source@ 将伤害转移至周围目标。",
	info = function(self, t)
		return ([[施法者所承受的伤害有 50%% 的概率转移给指定连接的目标。 
		一旦吸收伤害达到上限（ %d ），持续时间到了或目标死亡，护盾会破碎掉。 ]]):format(getAnomalyDamage(self, t)*2)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_WORMHOLE",
	name = "异常：虫洞",
	message = "@Source@折叠了两点的空间。",
	info = function(self, t)
		return ([[建立一个连接附近的随机格子和十格外的随机格子的虫洞。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_PROBABILITY_TRAVEL",
	name = "异常：相位移动",
	message = "@Source@ 让几名目标进入相位空间。",
	info = function(self, t)
		return ([[将半径 %d 范围内最多五个单位可以穿墙移动 %d 格]]):
		format(getAnomalyDuration(self, t)*2, getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_BLINK",
	name = "异常：闪烁",
	message = "@Source@ 让几名目标随机闪烁。",
	info = function(self, t)
		return ([[让半径 %d 范围内最多五个单位每回合在 %d 格内传送。]]):
		format(self:getTalentRadius(t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SUMMON_TOWNSFOLK",
	name = "异常：召唤村民",
	message = "一些无辜的村民被传送至战斗中。",
	info = function(self, t)
		return ([[将无辜的村民拖入战斗。]])
	end,
}

-- Temporal
registerTalentTranslation{
	id = "T_ANOMALY_SLOW",
	name = "异常：减速",
	message = "@Source@ 制造出缓慢的时空气泡",
	info = function(self, t)
		return ([[让半径 %d 范围内最多五个单位减速 %d%% 。]]):
		format(self:getTalentRadius(t), t.getSlow(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_HASTE",
	name = "异常：加速",
	message = "@Source@ 制造出迅速的时空气泡",
	info = function(self, t)
		return ([[让半径 %d 范围内最多五个单位增加整体速度 %d%% 。]]):
		format(self:getTalentRadius(t), t.getHaste(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_STOP",
	name = "异常：停止",
	message = "@Source@ 制造出停滞的时空气泡",
	info = function(self, t)
		return ([[震慑半径 %d 范围内最多五个单位。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_BUBBLE",
	name = "异常：时空气泡",
	message = "@Source@ 将几名目标移出时间",
	info = function(self, t)
		return ([[将半径 %d  范围内最多五个单位从时光的流动中移出。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_SHIELD",
	name = "异常：时间盾",
	message = "@Source@ 在几名目标周围制造了时间护盾",
	info = function(self, t)
		return ([[将半径 %d  范围内最多五个单位覆盖时光之盾。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_INVIGORATE",
	name = "异常：鼓舞",
	message = "@Source@ 鼓舞了几名目标",
	info = function(self, t)
		return ([[鼓舞半径 %d  范围内最多五个单位。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_CLONE",
	name = "异常：克隆",
	message = "@Source@ 克隆了周围生物",
	info = function(self, t)
		return ([[克隆范围内一个随机单位。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_STORM",
	name = "异常：时空风暴",
	message = "@Source@ 制造了时空风暴",
	info = function(self, t)
		local duration = self:combatScale(getParadoxSpellpower(self, t), 4, 10, 12, 100, 0.75)/2
		local damage = self:combatScale(getParadoxSpellpower(self, t), 10, 10, 50, 100, 0.75)
		return ([[召唤一场时空风暴 %d ~ %d 回合，每回合造成 %0.2f ~ %0.2f 时空伤害。]])
		:format(duration/2, duration, damDesc(self, DamageType.TEMPORAL, damage/3),  damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

-- Physical
registerTalentTranslation{
	id = "T_ANOMALY_GRAVITY_PULL",
	name = "异常：重力牵引",
	message = "@Source@ 增加了附近重力",
	info = function(self, t)
		return ([[增加周围的重力，吸引半径 %d 范围内的目标。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DIG",
	name = "异常：挖掘",
	message = "@Source@ 将周围的地形化为尘土",
	info = function(self, t)
		return ([[挖掘半径 %d 范围内的所有地形。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_ENTOMB",
	name = "异常：埋葬",
	message = "@Source@ 制造出石墙",
	info = function(self, t)
		return ([[将一个单位用岩石墙环绕。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_ENTROPY",
	name = "异常：熵",
	message = "@Source@ 增加了周围的熵",
	info = function(self, t)
		return ([[让半径 %d 范围内最多五个单位的三到六个技能进入冷却 %d 回合。]]):
		format(getAnomalyRadius(self, t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_GRAVITY_WELL",
	name = "异常：重力井",
	message = "@Source@ 增加了周围的重力",
	info = function(self, t)
		return ([[在半径 %d 范围内制造重力井，定身最多五个单位。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_QUAKE",
	name = "异常：地震",
	message = "@Source@ 制造了地震",
	info = function(self, t)
		return ([[在半径 %d 范围内制造地震。]]):
		format(getAnomalyRadius(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_FLAWED_DESIGN",
	name = "异常：不完美设计",
	message = "@Source@ 降低了几名目标的抵抗",
	info = function(self, t)
		return ([[将半径 %d 范围内最多五个单位的抗性降低 %d%% 。]]):format(self:getTalentRadius(t), getAnomalyEffectPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DUST_STORM",
	name = "异常：尘土风暴",
	message = "@Source@ 制造了尘土风暴",
	info = function(self, t)
		return ([[召唤三到六个尘土风暴。]]):format()
	end,
}

-- Major
-- Major anomalies can't be manually targeted
registerTalentTranslation{
	id = "T_ANOMALY_BLAZING_FIRE",
	name = "异常：燃烧之炎",
	message = "@Source@ 触发了大火",
	info = function(self, t)
		return ([[召唤三到六个燃烧之炎。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_CALCIFY",
	name = "异常：石化",
	message = "@Source@ 石化了几名目标",
	info = function(self, t)
		return ([[将半径 %d 范围内最多五个单位变成石头 %d 回合。]]):
		format(getAnomalyRadius(self, t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_CALL",
	name = "异常：召唤",
	message = "@Source@ 将几名目标传送过来",
	info = function(self, t)
		return ([[将三到六个单位召唤到施法者身边。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DEUS_EX",
	name = "异常：神佑",
	message = "命运的天平倾斜了。",
	info = function(self, t)
		return ([[显著强化和加速目标 %d 回合。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_EVIL_TWIN",
	name = "异常：邪恶双生子",
	message = "@Source@ 的邪恶双胞胎从另一条时空线赶来",
	info = function(self, t)
		return ([[复制施法者。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_INTERSECTING_THREADS",
	name = "异常：时间线紊乱",
	message = "@Source@ 让两条时间线交汇",
	info = function(self, t)
		return ([[复制半径十格范围内所有生物。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_MASS_DIG",
	name = "异常：范围挖掘",
	message = "@Source@ 挖开了一大块区域",
	info = function(self, t)
		return ([[在三到六个半径 %d 范围的圆里摧毁所有地形。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SPHERE_OF_DESTRUCTION",
	name = "异常：毁灭之球",
	message = "@Source@ 制造了毁灭之球",
	info = function(self, t)
		return ([[召唤一个毁灭之球。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TORNADO",
	name = "异常：龙卷风",
	message = "@Source@ 制造了龙卷风",
	info = function(self, t)
		return ([[召唤三到六道飓风]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_METEOR",
	name = "异常：陨石",
	message = "@Source@ 从天空召唤一颗陨石",
	info = function(self, t)
		return ([[召唤一颗陨石从天空坠落。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SPACETIME_TEAR",
	name = "异常：空间撕裂",
	message = "@Source@ 撕裂了时空",
	info = function(self, t)
		return ([[在时空的构造上撕开一个洞。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SUMMON_TIME_ELEMENTAL",
	name = "异常：召唤时间元素",
	message = "@Source@ 吸引了一些时空元素",
	info = function(self, t)
		return ([[召唤时间元素。]]):
		format()
	end,
}

--[[registerTalentTranslation{
	id = "",
	name = "Anomaly Terrain Change",
	info = function(self, t)
		return (Random Terrain in a ball.)
	end,
}

registerTalentTranslation{
	id = "",
	name = "Anomaly Stat Reorder",
	info = function(self, t)
		return (Target loses stats.)
	end,
}

registerTalentTranslation{
	id = "",
	name = "Anomaly Heal",
	info = function(self, t)
		return (Target is healed to full life.)
	end,
}


registerTalentTranslation{
	id = "",
	name = "Anomaly Vertigo",
	info = function(self, t)
		return ()
	end,
}

}]]

return _M

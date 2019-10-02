local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ANOMALY_REARRANGE",
	name = "异常：重排",
	message = "@Source@ 引发了时空重排",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[将 半 径 %d 范 围 内 最 多 五 个 单 位 传 送 到 十 格 外 。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TELEPORT",
	name = "异常：传送",
	message = "@Source@ 改变了现实。",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		return ([[将 半 径 %d 范 围 内 最 多 五 个 单 位 传 送 到 %d 格 外 。]]):format(radius, range)
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
		return ([[施 法 者 所 承 受 的 伤 害 有 50%% 的 概 率 转 移 给 指 定 连 接 的 目 标。 
		一 旦 吸 收 伤 害 达 到 上 限（ %d ）， 持 续 时 间 到 了 或 目 标 死 亡， 护 盾 会 破 碎 掉。 ]]):format(getAnomalyDamage(self, t)*2)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_WORMHOLE",
	name = "异常：虫洞",
	message = "@Source@折叠了两点的空间。",
	info = function(self, t)
		return ([[建 立 一 个 连 接 附 近 的 随 机 格 子 和 十 格 外 的 随 机 格 子 的 虫 洞 。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_PROBABILITY_TRAVEL",
	name = "异常：相位移动",
	message = "@Source@ 让几名目标进入相位空间。",
	info = function(self, t)
		return ([[将 半 径 %d 范 围 内 最 多 五 个 单 位 可 以 穿 墙 移 动 %d 格]]):
		format(getAnomalyDuration(self, t)*2, getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_BLINK",
	name = "异常：闪烁",
	message = "@Source@ 让几名目标随机闪烁。",
	info = function(self, t)
		return ([[让 半 径 %d 范 围 内 最 多 五 个 单 位 每 回 合 在 %d 格 内 传 送 。]]):
		format(self:getTalentRadius(t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SUMMON_TOWNSFOLK",
	name = "异常：召唤村民",
	message = "一些无辜的村民被传送至战斗中。",
	info = function(self, t)
		return ([[将 无 辜 的 村 民 拖 入 战 斗 。]])
	end,
}

-- Temporal
registerTalentTranslation{
	id = "T_ANOMALY_SLOW",
	name = "异常：减速",
	message = "@Source@ 制造出缓慢的时空气泡",
	info = function(self, t)
		return ([[让 半 径 %d 范 围 内 最 多 五 个 单 位 减 速 %d%% 。]]):
		format(self:getTalentRadius(t), t.getSlow(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_HASTE",
	name = "异常：加速",
	message = "@Source@ 制造出迅速的时空气泡",
	info = function(self, t)
		return ([[让 半 径 %d 范 围 内 最 多 五 个 单 位 增 加 整 体 速 度 %d%% 。]]):
		format(self:getTalentRadius(t), t.getHaste(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_STOP",
	name = "异常：停止",
	message = "@Source@ 制造出停滞的时空气泡",
	info = function(self, t)
		return ([[震 慑 半 径 %d 范 围 内 最 多 五 个 单 位 。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_BUBBLE",
	name = "异常：时空气泡",
	message = "@Source@ 将几名目标移出时间",
	info = function(self, t)
		return ([[将 半 径 %d  范 围 内 最 多 五 个 单 位 从 时 光 的 流 动 中 移 出 。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_SHIELD",
	name = "异常：时间盾",
	message = "@Source@ 在几名目标周围制造了时间护盾",
	info = function(self, t)
		return ([[将 半 径 %d  范 围 内 最 多 五 个 单 位 覆 盖 时 光 之 盾 。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_INVIGORATE",
	name = "异常：鼓舞",
	message = "@Source@ 鼓舞了几名目标",
	info = function(self, t)
		return ([[鼓 舞 半 径 %d  范 围 内 最 多 五 个 单 位。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_CLONE",
	name = "异常：克隆",
	message = "@Source@ 克隆了周围生物",
	info = function(self, t)
		return ([[克 隆 范 围 内 一 个 随 机 单 位 。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TEMPORAL_STORM",
	name = "异常：时空风暴",
	message = "@Source@ 制造了时空风暴",
	info = function(self, t)
		local duration = self:combatScale(getParadoxSpellpower(self, t), 4, 10, 12, 100, 0.75)/2
		local damage = self:combatScale(getParadoxSpellpower(self, t), 10, 10, 50, 100, 0.75)
		return ([[召 唤 一 场 时 空 风 暴 %d ~ %d 回 合 ， 每 回 合 造 成 %0.2f ~ %0.2f 时 空 伤 害 。]])
		:format(duration/2, duration, damDesc(self, DamageType.TEMPORAL, damage/3),  damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

-- Physical
registerTalentTranslation{
	id = "T_ANOMALY_GRAVITY_PULL",
	name = "异常：重力牵引",
	message = "@Source@ 增加了附近重力",
	info = function(self, t)
		return ([[增 加 周 围 的 重 力 ， 吸 引 半 径 %d 范 围 内 的 目 标 。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DIG",
	name = "异常：挖掘",
	message = "@Source@ 将周围的地形化为尘土",
	info = function(self, t)
		return ([[挖 掘 半 径 %d 范 围 内 的 所 有 地 形 。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_ENTOMB",
	name = "异常：埋葬",
	message = "@Source@ 制造出石墙",
	info = function(self, t)
		return ([[将 一 个 单 位 用 岩 石 墙 环 绕 。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_ENTROPY",
	name = "异常：熵",
	message = "@Source@ 增加了周围的熵",
	info = function(self, t)
		return ([[让 半 径 %d 范 围 内 最 多 五 个 单 位 的 三 到 六 个 技 能 进 入 冷 却 %d 回 合 。]]):
		format(getAnomalyRadius(self, t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_GRAVITY_WELL",
	name = "异常：重力井",
	message = "@Source@ 增加了周围的重力",
	info = function(self, t)
		return ([[在 半 径 %d 范 围 内 制 造 重 力 井 ， 定 身 最 多 五 个 单 位 。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_QUAKE",
	name = "异常：地震",
	message = "@Source@ 制造了地震",
	info = function(self, t)
		return ([[在 半 径 %d 范 围 内 制 造 地 震 。]]):
		format(getAnomalyRadius(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_FLAWED_DESIGN",
	name = "异常：不完美设计",
	message = "@Source@ 降低了几名目标的抵抗",
	info = function(self, t)
		return ([[将 半 径 %d 范 围 内 最 多 五 个 单 位 的 抗 性 降 低 %d%% 。]]):format(self:getTalentRadius(t), getAnomalyEffectPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DUST_STORM",
	name = "异常：尘土风暴",
	message = "@Source@ 制造了尘土风暴",
	info = function(self, t)
		return ([[召 唤 三 到 六 个 尘 土 风 暴 。]]):format()
	end,
}

-- Major
-- Major anomalies can't be manually targeted
registerTalentTranslation{
	id = "T_ANOMALY_BLAZING_FIRE",
	name = "异常：燃烧之炎",
	message = "@Source@ 触发了大火",
	info = function(self, t)
		return ([[召 唤 三 到 六 个 燃 烧 之 炎 。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_CALCIFY",
	name = "异常：石化",
	message = "@Source@ 石化了几名目标",
	info = function(self, t)
		return ([[将 半 径 %d 范 围 内 最 多 五 个 单 位 变 成 石 头 %d 回 合 。]]):
		format(getAnomalyRadius(self, t), getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_CALL",
	name = "异常：召唤",
	message = "@Source@ 将几名目标传送过来",
	info = function(self, t)
		return ([[将 三 到 六 个 单 位 召 唤 到 施 法 者 身 边 。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_DEUS_EX",
	name = "异常：神佑",
	message = "命运的天平倾斜了。",
	info = function(self, t)
		return ([[显 著 强 化 和 加 速 目 标 %d 回 合。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_EVIL_TWIN",
	name = "异常：邪恶双生子",
	message = "@Source@ 的邪恶双胞胎从另一条时空线赶来",
	info = function(self, t)
		return ([[复 制 施 法 者 。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_INTERSECTING_THREADS",
	name = "异常：时间线紊乱",
	message = "@Source@ 让两条时间线交汇",
	info = function(self, t)
		return ([[复 制 半 径 十 格 范 围 内 所 有 生 物 。]]):format(getAnomalyDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_MASS_DIG",
	name = "异常：范围挖掘",
	message = "@Source@ 挖开了一大块区域",
	info = function(self, t)
		return ([[在 三 到 六 个 半 径 %d 范 围 的 圆 里 摧 毁 所 有 地 形 。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SPHERE_OF_DESTRUCTION",
	name = "异常：毁灭之球",
	message = "@Source@ 制造了毁灭之球",
	info = function(self, t)
		return ([[召 唤 一 个 毁 灭 之 球 。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_TORNADO",
	name = "异常：龙卷风",
	message = "@Source@ 制造了龙卷风",
	info = function(self, t)
		return ([[召 唤 三 到 六 道 飓 风]]):format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_METEOR",
	name = "异常：陨石",
	message = "@Source@ 从天空召唤一颗陨石",
	info = function(self, t)
		return ([[召 唤 一 颗 陨 石 从 天 空 坠 落 。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SPACETIME_TEAR",
	name = "异常：空间撕裂",
	message = "@Source@ 撕裂了时空",
	info = function(self, t)
		return ([[在 时 空 的 构 造 上 撕 开 一 个 洞 。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_ANOMALY_SUMMON_TIME_ELEMENTAL",
	name = "异常：召唤时间元素",
	message = "@Source@ 吸引了一些时空元素",
	info = function(self, t)
		return ([[召 唤 时 间 元 素。]]):
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

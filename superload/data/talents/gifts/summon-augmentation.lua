local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAGE",
	name = "狂暴",
	info = function(self, t)
		return ([[当一个召唤兽被杀死时，激发周围半径5范围内所有的召唤兽，使他们的所有属性增加%d，持续5回合。]]):format(t.incStats(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DETONATE",
	name = "引爆",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[献 祭 一只 召 唤 兽， 使 它 在 %d 码 范 围 内 爆 炸。 
		- 火焰里奇： 形 成 一个火球，造成 %d 伤害，并火焰震慑敌人。
		- 三 头 蛇： 范围内所有友方单位获得%d%%闪电、酸液和自然伤害吸收，并获得每回合%d生命回复，持续7回合。
		- 雾 凇： 形 成 一个 冰 球，造成 %d 伤害，可能冰冻敌人。
		- 火 龙： 形 成 一 片 火 焰，每回合造成 %d 伤害 。
		- 战 争 猎 犬： 形 成锋利的球，让周围的生物在6回合内受到%0.1f点流血伤害。
		- 果冻怪： 形 成 一 片 能 减 速 的 淤 泥，造成%d自然伤害，并使敌人减速%0.1f%%。
		- 米 诺 陶 斯： 眩晕敌人5回合（强度 %d%%）
		- 岩 石 傀 儡： 使周围的友方单位获得%d护甲值和 %d%% 护甲强度，持续5回合。
		- 乌 龟： 给 所 有 友 方 单 位 提 供 一个甲壳护 盾，所有抗性提升%d%%，持续5回合。 
		- 蜘 蛛： 将所有敌人击退%d格。
		此 外， 随 机 的 某 个 召 唤 技 能 会 冷 却 完 毕。 
		引爆 产 生 的 负 面 效 果 不 会 影 响 到 你 或 你 的 召 唤 兽。
		效果受精神强度加成，可以暴击。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE",
	name = "体质强化",
	info = function(self, t)
		return ([[提升你所有召唤物的生命值%0.1f%%，并延长所有召唤物的存活时间%d回合。]]):format(100*t.incLife(self, t), t.incDur(self,t))
	end,
}

registerTalentTranslation{
	id = "T_PHASE_SUMMON",
	name = "次元召唤",
	info = function(self, t)
		return ([[与 一只 召 唤 兽 调 换 位 置。 这 会 干 扰 你 的 敌 人， 使 你 和 该 召 唤 兽 获 得 50%% 闪 避 状 态， 持 续 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}


return _M

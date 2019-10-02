local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAGE",
	name = "狂暴",
	info = function(self, t)
		return ([[当一个召唤兽被杀死时，激发周围半径 5 范围内所有的召唤兽，使他们的所有属性增加 %d ，持续5回合。]]):format(t.incStats(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DETONATE",
	name = "引爆",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[献 祭 一 只 召 唤 兽 ，使 它 在 %d 码 范 围 内 爆 炸 。
		-火 焰 里 奇 ：形 成 一 个 火 球 ，造 成 %d 伤 害 ，并 火 焰 震 慑 敌 人 。
		-三 头 蛇 ：范 围 内 所 有 友 方 单 位 获 得 %d%% 闪 电 、酸 液 和 自 然 伤 害 吸 收 ，并 获 得 每 回 合 %d 生 命 回 复 ，持 续 7 回 合 。
		-雾 凇 ：形 成 一 个 冰 球 ，造 成 %d 伤 害 ，可 能 冰 冻 敌 人 。
		-火 龙 ：形 成 一 片 火 焰 ，每 回 合 造 成 %d 伤 害 。
		-战 争 猎 犬 ：形 成 锋 利 的 球 ，让 周 围 的 生 物 在 6 回 合 内 受 到 %0.1f 点 流 血 伤 害 。
		-果 冻 怪 ：形 成 一 片 能 减 速 的 淤 泥 ，造 成 %d 自 然 伤 害 ，并 使 敌 人 减 速 %0.1f%% 。
		-米 诺 陶 斯 ：眩 晕 敌 人 5 回 合 （强 度 %d%% ）
		-岩 石 傀 儡 ：使 周 围 的 友 方 单 位 获 得 %d 护 甲 值 和 %d%%护 甲 强 度 ，持 续 5 回 合 。
		-乌 龟 ：给 所 有 友 方 单 位 提 供 一 个 甲 壳 护 盾 ，所 有 抗 性 提 升 %d%% ，持 续 5 回 合 。
		-蜘 蛛 ：将 所 有 敌 人 击 退 %d 格 。
		 此 外 ，随 机 的 某 个 召 唤 技 能 会 冷 却 完 毕 。
		 引 爆 产 生 的 负 面 效 果 不 会 影 响 到 你 或 你 的 召 唤 兽 。
		 效 果 受 精 神 强 度 加 成 ，可 以 暴 击 。]]):format(radius, t.explodeSecondary(self,t), t.hydraAffinity(self,t), t.hydraRegen(self,t), t.explodeSecondary(self,t), t.explodeFire(self,t), t.explodeBleed(self,t) / 6, t.explodeSecondary(self,t), t.jellySlow(self,t) * 100, t.minotaurConfuse(self,t), t.golemArmour(self,t), t.golemHardiness(self,t), t.shellShielding(self,t), t.spiderKnockback(self,t)) 
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE",
	name = "体质强化",
	info = function(self, t)
		return ([[提 升 你 所 有 召 唤 物 的 生 命 值 %0.1f%% ，并 延 长 所 有 召 唤 物 的 存 活 时 间 %d 回 合 。]]):format(100*t.incLife(self, t), t.incDur(self,t))
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

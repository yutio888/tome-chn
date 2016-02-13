local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAGE",
	name = "狂暴",
	info = function(self, t)
		return ([[提 升 1 只 召 唤 兽 的 杀 戮 速 度， 增 加 它 %d 点 所 有 属 性， 持 续 10 回 合。]]):format(self:combatTalentMindDamage(t, 10, 100)/4)
	end,
}

registerTalentTranslation{
	id = "T_DETONATE",
	name = "引爆",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[献 祭 1 只 召 唤 兽， 使 它 在 %d 码 范 围 内 爆 炸。 
		- 里 奇 之 焰： 形 成 1 个 火 球。 
		- 三 头 蛇： 形 成 1 个 电 球、 酸 液 球 或 毒 球。 
		- 雾 凇： 形 成 1 个 冰 球。 
		- 火 龙： 形 成 一 片 火 焰。 
		- 战 争 猎 犬： 形 成 1 个 能 造 成 物 理 伤 害 的 球。 
		- 史 莱 姆： 形 成 一 片 能 减 速 的 淤 泥。 
		- 米 诺 陶 斯： 形 成 1 团 锋 利 的 刺 球， 切 割 所 有 敌 人。 
		- 岩 石 傀 儡： 击 退 所 有 敌 人。 
		- 乌 龟： 给 所 有 友 方 单 位 提 供 1 个 小 护 盾。 
		- 蜘 蛛： 定 住 周 围 所 有 的 敌 人。 
		 此 外， 随 机 的 某 个 召 唤 技 能 会 冷 却 完 毕。 
		 献 祭 产 生 的 负 面 效 果 不 会 影 响 到 你 或 你 的 召 唤 兽。
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE",
	name = "体质强化",
	info = function(self, t)
		return ([[提 升 你 所 有 召 唤 物 %d 点体质，并 在 计 算 召 唤 物 剩 余 时 间 时 增 加 %0.1f 点 技 能 等 级。]]):format(t.incCon(self, t), self:getTalentLevel(t))
	end,
}

registerTalentTranslation{
	id = "T_PHASE_SUMMON",
	name = "次元召唤",
	info = function(self, t)
		return ([[与 1 只 召 唤 兽 调 换 位 置。 这 会 干 扰 你 的 敌 人， 使 你 和 该 召 唤 兽 获 得 50%% 闪 避 状 态， 持 续 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}


return _M

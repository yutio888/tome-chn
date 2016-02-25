local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMERGENCY_STEAM_PURGE",
	name = "紧急蒸汽净化",
	info = function(self, t)
		return ([[你 打 开 所 有 蒸 汽 阀， 释 放 半 径 %d 的 蒸 汽 冲 击 波 ， 造 成 %0.2f 火 焰 伤 害 。
		若 你 有 至 少 50 点 蒸 汽 ， 气 体 的 温 度 将 变 得 极 高 ， 能 烧 伤 感 知 器 官 ， 令 受 影 响 的 生 物 目 盲 %d 回 合 。 
		效 果 受 当 前 蒸 汽 值 加 成 。 1 点 蒸 汽 值 时 ， 强 度 仅 为 1 0 0 点 蒸 汽 值 的 15%% 。
		当 前 强 度 系 数 %d%% 。]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getDur(self, t), t.getFactor(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_INNOVATION",
	name = "创新",
	info = function(self, t)
		return ([[你 对 物 理 学 的 了 解 令 你 能 以 全 新 的 方 式 改 进 装 备 。
		增 加 大 师 制 作 或 者 蒸 汽 科 技 的 装备 提 供 的 属 性 、 豁 免 、 护 甲 和 闪 避 %d%% 。]])
		:format(t.getFactor(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_TINKERS",
	name = "插件超频",
	info = function(self, t)
		return ([[消 耗 大 量 蒸 汽 ， 令 所 有 配 件 和 蒸 汽 技 能 超 频 工 作 %d 回 合 。
		超 频 期 间 ， 你 获 得 %d 蒸 汽 强 度 和 %d 蒸 汽 技 能 暴 击 率 。 ]])
		:format(t.getDur(self, t), t.getBoost(self, t))
	end,}

registerTalentTranslation{
	id = "T_LAST_ENGINEER_STANDING",
	name = "背水一战",
	info = function(self, t)
		return ([[成 为 大 师 意 味 着 你 经 历 了 更 多 危 险 ， 你 的 计 算 力 也 超 越 凡 人 。
		增 加 %d 灵 巧 ， %d 物 理 豁 免 ， %d%% 自 身 伤 害 抗 性， %d%% 几 率 避 免 暴 击 。]])
		:format(self:getTalentLevel(t) * 2, t.physSave(self, t), t.selfResist(self, t), t.critResist(self, t))
	end,}
return _M
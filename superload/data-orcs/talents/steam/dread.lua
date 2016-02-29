local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MECHANICAL_ARMS",
	name = "机械巨臂",
	info = function(self, t)
		return ([[你 使 用 灵 能 操 控 背 后 的 两 个 恐 怖 的 机 械 巨 臂 。
		每 个 基 础 回 合 机 械 巨 臂 能 够 使 用 灵 晶 自 动 攻 击 3 码 内 的 最 多 两 个 敌 人 ， 造 成 %d%% 武 器 伤 害。
		被 机 械 巨 臂 攻 击 的 目 标 伤 害 降 低 %d%% ， 持 续 5 回 合 。]]):
		format(t.getDam(self, t) * 100, t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_LUCID_SHOT",
	name = "醒神射击",
	info = function(self, t)
		return ([[对 一 个 敌 人 进 行 一 次 强 力 射 击 ， 造 成 %d%% 的 武 器 伤 害 。
		目 标 三 码 范 围 内 被 恐 惧 或 者 噩 梦 效 果 影 响 的 生 物 将 被 突 然 惊 醒 而 处 于 迷 失 状 态 ， 无 法 分 辨 敌 我 ， 持 续 %d 回合 。]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSY_WORM",
	name = "心灵蠕虫",
	info = function(self, t)
		return ([[对 一 个 敌 人 进 行 一 次 灵 能 强 化 射 击 ， 造 成 %d%% 精 神 武 器 伤 害 ，同 时 使 目 标 感 染 持 续 8 回 合 的 心 灵 蠕 虫 。
		蠕 虫 每 回 合 造 成 %0.2f 精 神 伤 害 ， 并 为 你 回 复 %d 点 超 能 力 。
		如 果 目 标 处 于 震 慑 或 者 恐 惧 状 态 ，效 果 翻 倍。
		另 外 ， 蠕 虫 每 回 合 有 25%% 的 概 率 感 染 3 码 内 的 所 有 其 他 敌 人 。]])
		:format(100 * t.getDam(self, t), damDesc(self, DamageType.MIND, t.getWorm(self, t)), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_NO_HOPE",
	name = "无助深渊",
	info = function(self, t)
		return ([[操 纵 敌 人 的 思 维 ， 让 敌 人 失 去 战 胜 你 的 希 望 。
		降 低 敌 人 40%% 的 全 部 伤 害 ， 持 续 %d 回 合 。 ]]):
		format(t.getDur(self, t))
	end,}
return _M
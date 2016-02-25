local _M = loadPrevious(...)

------------------------------------------------------------------
-- Yetis' powers
------------------------------------------------------------------

registerTalentTranslation{
	id = "T_ALGID_RAGE",
	name = "寒冰之怒",
	info = function(self, t)
		return ([[你 的 雪 人 早 已 适 应 寒 冷 的 环 境。
		在 5 回 合 中 你 造 成 的 所 有 伤 害 都 有 %d%% 几 率 把 目 标 冻 在 冰 块 中 3 回 合。
		在 霜 寒 暴 怒 生 效 中 你 可 以 轻 松 的 穿 透 冰 块， 减 少 50%% 他 们 所 吸 收 的 伤 害。
		数 值 会 随 着 你 的 意 志 提 升。]]):
		format(t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_THICK_FUR",
	name = "厚实毛皮",
	info = function(self, t)
		return ([[你 厚 实 的 雪 人 毛 皮 能 像 盾 牌 一 样 保 护 你， 为 你 提 供 %d%% 寒 冷 抗 性， %d%% 物 理 抗 性 和 %d 魔 法 豁 免。.]]):
		format(t.getCResist(self, t), t.getPResist(self, t), t.getSave(self, t))
	end,}

registerTalentTranslation{
	id = "T_RESILIENT_BODY",
	name = "坚韧身躯",
	info = function(self, t)
		return ([[你 的 雪 人 身 躯 面 对 负 面 状 态 十 分 坚 韧。
		每 当 你 被 一 个 负 面 的 物 理， 魔 法 或 精 神 状 态 击 中 时， 你 的 身 体 会 反 射 性 地 触 发 恢 复 之 力。
		这 个 效 果 会 治 疗 你 %d 生 命 值， 且 每 回 合 最 多 触 发 3 次。
		治 疗 值 会 随 着 你 的 体 质 增 加。]]):
		format(t.heal(self, t))
	end,}

registerTalentTranslation{
	id = "T_MINDWAVE",
	name = "脑波冲击",
	info = function(self, t)
		return ([[你 自 主 地 将 你 的 雪 人 大 脑 的 一 小 部 分 烧 熟， 以 此 来 在 半 径 %d 码 的 锥 形 里 释 放 一 发 强 大 的 精 神 冲 击。		
		任 何 陷 入 精 神 冲 击 的 敌 人 都 会 受 到 %0.2f 精 神 伤 害 并 被 混 乱 （35%% 强 度） %d 回 合。
		伤 害 会 随 着 你 的 体 质 增 加， 应 用 强 度 则 为 你 物 理， 法 术， 精 神 强 度 中 的 最 高 者。]]):
		format(t.radius, t.getDamage(self, t), t.getDur(self, t))
	end,}

------------------------------------------------------------------
-- Whitehooves' powers
------------------------------------------------------------------
registerTalentTranslation{
	id = "T_WHITEHOOVES",
	name = "白蹄",
	info = function(self, t)
		return ([[强 化 你 的 死 灵 身 躯， 增 加 %d 的 力 量 和 魔 力。
		每 次 你 移 动 时 都 会 获 得 1 层 （最 多 %d 层） 死 亡 波 纹， 提 升 20%% 你 的 移 动 速 度。
		如 果 回 合 内 你 没 有 移 动， 那 么 你 会 失 去 一 层 死 亡 波 纹。]])
		:format(t.statBonus(self, t), self:getTalentLevelRaw(t) + (self.DM_Bonus or 0))
	end,}

registerTalentTranslation{
	id = "T_DEAD_HIDE",
	name = "亡者之皮",
	info = function(self, t)
		return ([[你 的 死 灵 皮 肤 在 重 压 之 下 会 变 得 更 加 坚 硬。 每 层 死 亡 波 纹 都 会 提 供 %d 的 伤 害 减 免。	]]):
		format(t.getFlatResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_LIFELESS_RUSH",
	name = "无生突袭",
	info = function(self, t)
		return ([[你 唤 起 你 的 死 灵 之 力， 瞬 间 获 得 最 大 层 数 的 死 亡 波 纹。
		死 亡 波 纹 只 会 在 %d 回 合 后 开 始 衰 减。
		除 此 之 外， 每 层 死 亡 波 纹 还 会 提 供 +%d%% 的 全 部 伤 害。]]):
		format(t.getDur(self, t), t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_ESSENCE_DRAIN",
	name = "吸取精华",
	info = function(self, t)
		return ([[你 对 你 的 敌 人 释 放 出 一 波 黑 暗 能 量， 造 成 %0.2f 暗 影 伤 害。
		黑 暗 会 吸 取 他 的 一 部 分 生 命 精 华 （只 对 活 着 的 目 标 有 效） 来 延 长 死 亡 波 纹 在 消 耗 下 一 层 前 的 持 续 时 间 %d 回 合。
		只 能 在 你 有 死 亡 波 纹 的 时 候 使 用。
		伤 害 会 随 着 你 的 魔 力 增 长。]]):
		format(t.getDamage(self, t), t.getDur(self, t))
	end,}

return _M
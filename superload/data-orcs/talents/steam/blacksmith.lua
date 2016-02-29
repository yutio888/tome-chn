local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASSIVE_PHYSIQUE",
	name = "强壮体魄",
	info = function(self, t)
		return ([[长 期 打 铁 ， 让 你 的 身 体 格 外 强 壮 ， 增 加 %d 力 量 和 体 质 。
		技 能 等 级 5 时 ， 你 的 肌 肉 是 如 此 巨 大 ， 体 型 增 大 一 个 等 级 。]])
		:format(math.floor(2 * self:getTalentLevel(t)))
	end,}

registerTalentTranslation{
	id = "T_ENDLESS_ENDURANCE",
	name = "永不疲倦",
	info = function(self, t)
		return ([[长 时 间 的 锻 造 工 作 让 你 拥 有 不 可 思 议 的 持 久 力 和 无 尽 的 活 力。
		你 的 治 疗 系 数 增 加 %d%% ， 生 命 恢 复 增 加 %0.2f 。
		你 力 大 无 穷 ， 很 难 被 阻 止 ， 定 身 抗 性 增 加 %d%% 。]])
		:format(self:getTalentLevel(t) * 2, self:getTalentLevel(t), self:getTalentLevel(t) * 15)
	end,}

registerTalentTranslation{
	id = "T_LIFE_IN_THE_FLAMES",
	name = "浴火而生",
	info = function(self, t)
		return ([[长 时 间 的 锻 造 工 作 让 你 对 疼 痛 和 火 焰 的 忍 耐 力 提 高 。
		火 焰 抗 性 增 加 %d%% ， 物 理 抗 性 增 加 %d%% 。
		技 能 等 级 5 时 ， 你 对 火 焰 抗 性 极 高 ， 从 而 免 疫 燃 烧 状 态 。]])
		:format(self:getTalentLevel(t) * 5, self:getTalentLevel(t) * 3)
	end,}

registerTalentTranslation{
	id = "T_CRAFTS_EYE",
	name = "匠师之眼",
	info = function(self, t)
		return ([[你 能 够 像 找 到 自 己 工 作 的 错 误 一 样 轻 易 发 现 敌 人 防 御 的 弱 点。
		获 得 %d 的 护 甲 穿 透 和 %d%% 的 暴 击 伤 害 加 成。
		技 能 等 级 5 时 ， 能 够 自 如 的 与 潜 行 和 隐 形 生 物 战 斗 ， 无 视 减 免 。]])
		:format(self:getTalentLevel(t) * 4, self:getTalentLevel(t) * 5)
	end,}
return _M
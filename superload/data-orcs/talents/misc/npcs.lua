local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PETRIFYING_GAZE",
	name = "石化凝视",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[凝 视 你 的 敌 人 并 把 他 石 化 %d 回 合。
		被 石 化 的 生 物 不 能 行 动， 回 血， 并 且 非 常 脆 弱。
		如 果 被 石 化 的 生 物 一 次 性 受 到 了 超 过 总 生 命 值 30%% 的 伤 害， 那 么 他 会 破 碎 并 死 去。
		被 石 化 的 生 物 对 火 焰 和 闪 电 有 着 很 高 的 抗 性， 并 对 物 理 攻 击 有 着 一 定 的 抗 性。]]):
		format(duration)
	end,}

registerTalentTranslation{
	id = "T_GNASHING_MAW",
	name = "撕咬",
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标， 造 成 %d%% 伤 害。 如 果 攻 击 命 中 了， 目 标 的 命 中 会 被 降 低 %d， 持 续 %d 回 合。
		命 中 降 低 会 随 着 你 的 物 理 强 度 增 长。]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,}

local sandtrap = nil
registerTalentTranslation{
	id = "T_SANDRUSH",
	name = "潜沙突袭",
	info = function(self, t)
		return ([[潜 入 沙 中 向 距 离 你 %d 码 的 目 标 发 起 突 袭 攻 击。
		在 你 的 跃 出 点 会 出 现 最 多 9 个 持 续 %d 回 合 （基 于 你 的 力 量） 的 沙 坑。
		你 必 须 突 袭 至 少 2 码。]]):format(t.range(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_RITCH_LARVA_INFECT",
	name = "里奇幼虫寄生",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		local Pdam, Fdam = self:damDesc(DamageType.PHYSICAL, dam/2), self:damDesc(DamageType.FIRE, dam/2)
		return ([[用 你 的 产 卵 器 蜇 目 标 一 下， 将 %d 个 幼 虫 注 入 目 标 体 内 以 完 成 他 们 的 孵 化 流 程。
		在 一 个 5 回 合 的 发 育 周 期 内， 幼 虫 们 会 以 受 害 者 的 血 肉 为 食， 每 回 合 造 成 %0.2f 到 %0.2f 的 物 理 伤 害 （随 着 他 们 的 成 长 增 多）。
		在 发 育 期 结 束 后， 幼 虫 会 从 寄 主 体 内 钻 出， 每 个 幼 虫 造 成 %0.2f 物 理 和 %0.2f 火 焰 伤 害。
		]]):format(nb, nb*Pdam*2*.05, nb*Pdam*2*.25, Pdam, Fdam)
	end,}

registerTalentTranslation{
	id  = "T_AMAKTHEL_SLUMBER",
	name = "沉睡中...",
	info = function(self, t)
		return ([[死 神 正 在 沉 睡。 起 码 现 在 是。]])
	end,}

registerTalentTranslation{
	id = "T_AMAKTHEL_TENTACLE_SPAWN",
	name = "衍生触手", 
	info = function(self, t)
		return ([[死 神 想 要 逗 逗 你……]])
	end,}

registerTalentTranslation{
	id = "T_CURSE_OF_AMAKTHEL",
	name = "阿马克泰尔的诅咒",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[创 造 一 片 诅 咒 之 地 （半 径 %d 码） %d 回 合。 任 何 陷 入 其 中 的 敌 人 都 会 被 诅 咒， 任 何 他 们 新 得 到 的 负 面 状 态 的 持 续 时 间 都 会 翻 倍。
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_TEMPORAL_RIPPLES",
	name = "时空涟漪",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[创 造 一 片 半 径 %d 码 的 时 间 错 乱 之 地 %d 回 合。 任 何 站 在 其 中 的 敌 人 受 到 的 伤 害 都 会 治 疗 攻 击 者 200%% 伤 害 数 额 的 生 命。
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_SAW_STORM",
	name = "锯刃风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[召 唤 由 旋 转 的 锯 刃 组 成 的 风 暴 来 撕 裂 你 的 敌 人， 对 每 个 接 近 者 造 成 %d 物 理 伤 害 并 使 其 流 血， 持 续 %d 回 合。
]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,}

registerTalentTranslation{
	id = "T_RAZOR_SAW",
	name = "剃刀飞锯",
	info = function(self, t)
		return ([[发 射 一 个 动 能 十 足 的 锯 刃， 对 一 条 线 内 的 所 有 目 标 造 成 %0.2f 物 理 伤 害。
		伤 害 会 随 着 你 的 精 神 强 度 增 长。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 60, 300)))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_DASH",
	name = "火箭突进",
	info = function(self, t)
		return ([[使 用 火 箭 向 前 突 进。
		如 果 目 标 地 点 已 被 占 据， 那 么 你 对 那 里 的 目 标 进 行 一 次 近 战 攻 击。
		攻 击 会 造 成 130% 武 器 伤 害。
		你 必 须 至 少 突 进 2 码。]])
	end,}

-- Solely used to track the achievement
registerTalentTranslation{
	id = "T_ACHIEVEMENT_MIND_CONTROLLED_YETI",
	name = "精神控制的雪人",
	info = function(self, t)
		return "雪人重击！"
	end,}


return _M
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPACETIME_TUNING",
	name = "时空协调",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		local preference = self.preferred_paradox
		local sp_modifier = getParadoxModifier(self, t) * 100
		local spellpower = getParadoxSpellpower(self, t)
		local after_will, will_modifier, sustain_modifier = self:getModifiedParadox()
		local anomaly = self:paradoxFailChance()
		return ([[设 置 自 己 的 紊 乱 值。
		休 息 或 等 待 时 ， 你 每 回 合 将 自 动 调 节 %d 点 紊 乱 值 趋 向 于 你 的 设 定 值。
		你 的 紊 乱 值 会 修 正 所 有 时 空 法 术 的 持 续 时 间 和 法 术 强度。
		设 定 的 紊 乱 值:  %d
		紊 乱 值 修 正 率:  %d%%
		时 空 法 术 强 度:  %d
		意 志 修 正 数 值: -%d
		紊 乱 维 持 数 值: +%d
		修 正 后 紊 乱 值:  %d
		当 前 异 常 几 率:  %d%%]]):format(tune, preference, sp_modifier, spellpower, will_modifier, sustain_modifier, after_will, anomaly)
	end,
}

-- Talents from older versions to keep save files compatable
registerTalentTranslation{
	id = "T_SLOW",
	name = "扭曲力场",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[在 %d 码 半 径 范 围 内 制 造 1 个 时 间 扭 曲 力 场， 持 续 %d 回 合。 同 时 减 少 %d%% 目 标 整 体 速 度， 持 续 3 回 合， 当 目 标 处 于 此 范 围 内 时 每 回 合 造 成 %0.2f 时 空 伤 害。 
		 受 法 术 强 度 影 响， 减 速 效 果 和 伤 害 有 额 外 加 成。]]):
		format(radius, duration, 100 * slow, damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_SPACETIME_MASTERY",
	name = "时空掌握",
	info = function(self, t)
		local cooldown = t.cdred(self, t, 10)
		local wormhole = t.cdred(self, t, 20)
		return ([[你 对 时 空 的 掌 握 让 你 减 少 空 间 跳 跃 、 时 空 放 逐 、 时 空 交 换 、 时 空 觉 醒 的 冷 却 时 间 %d 个 回 合 ， 减 少 虫 洞 跃 迁 的 冷 却 时 间 %d 个  回 合 。 同 时 当 你 对 目 标 使 用 可 能 造 成 连 续 紊 乱 的 技 能 （ 时 空 放 逐 、 时 间 跳 跃 ） 时 增 加 %d%% 的 法 术 强 度 。]]):
		format(cooldown, wormhole, t.getPower(self, t)*100)

	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_FEED",
	name = "量子充能",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你 已 经 学 会 通 过 控 制 时 空 的 流 动 来 增 强 魔 力。 
		 增 加 %d 点 魔 法 和 法 术 豁 免。 
		 受 意 志 影 响， 效 果 按 比 例 加 成。]]):format(power)
	end,
}

registerTalentTranslation{
	id = "T_MOMENT_OF_PRESCIENCE",
	name = "预知之门",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 集 中 意 识 提 升 你 的 潜 行 侦 测、 隐 形 侦 测、 闪 避 和 命 中 几 率 %d 持 续 %d 回 合。 
		 如 果 你 已 经 激 活 了 命 运 之 网 技 能， 你 将 得 到 一 个 基 于 50%% 命 运 之 网 获 得 提 升 点 数 的 增 益。 
		 此 技 能 不 需 要 施 法 时 间。]]):
		format(power, duration)
	end,
}

registerTalentTranslation{
	id = "T_GATHER_THE_THREADS",
	name = "聚集螺旋",
	info = function(self, t)
		local primary = t.getThread(self, t)
		local reduction = t.getReduction(self, t)
		return ([[你 开 始 从 其 他 时 间 线 搜 集 能 量， 初 始 增 加 %0.2f 法 术 强 度 并 且 每 回 合 逐 渐 增 加 %0.2f 法 术 强 度。 
		 此 效 果 会 因 为 使 用 技 能 而 中 断， 否 则 此 技 能 会 在 5 回 合 后 结 束。 
		 当 此 技 能 激 活 时， 每 回 合 你 的 紊 乱 值 会 降 低 %d 点。 
		 此 技 能 不 会 打 断 时 空 调 谐， 激 活 时 空 调 谐 技 能 也 同 样 不 会 打 断 此 技 能。]]):format(primary + (primary/5), primary/5, reduction)
	end,
}

registerTalentTranslation{
	id = "T_ENTROPIC_FIELD",
	name = "熵光领域",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[制 造 一 个 领 域 围 绕 自 己， 减 少 所 有 抛 射 物 %d%% 的 速 度 并 增 加 %d%% 物 理 伤 害 抵 抗。 
		 受 法 术 强 度 影 响， 效 果 按 比 例 加 成。]]):format(power, power / 2)
	end,
}

registerTalentTranslation{
	id = "T_FADE_FROM_TIME",
	name = "时光凋零",
	info = function(self, t)
		local resist = t.getResist(self, t)
		local dur = t.getdurred(self,t)
		return ([[你 将 部 分 身 体 移 出 时 间 线， 持 续 10 回 合.
		 增 加 你 %d%% 所 有 伤 害 抵 抗， 减 少 %d%% 负 面 状 态 持 续 时 间 并 减 少 20%% 你 造 成 的 伤 害。 
		 抵 抗 加 成、 状 态 减 少 值 和 伤 害 惩 罚 会 随 法 术 持 续 时 间 的 增 加 而 逐 渐 减 少。 
		 受 法 术 强 度 影 响， 效 果 按 比 例 加 成。]]):
		format(resist, dur)
	end,
}

registerTalentTranslation{
	id = "T_PARADOX_CLONE",
	name = "无序克隆",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 召 唤 未 来 的 自 己 和 你 一 起 战 斗， 持 续 %d 回 合。 当 技 能 结 束 后， 在 未 来 的 某 个 时 间 点， 你 会 被 拉 回 到 过 去， 协 助 你 自 己 战 斗。 
		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。 ]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_DISPLACE_DAMAGE",
	name = "伤害转移",
	info = function(self, t)
		local displace = t.getDisplaceDamage(self, t) * 100
		return ([[空 间 在 你 身 边 折 叠， 转 移 %d%% 伤 害 到 范 围 内 随 机 1 个 敌 人 身 上。
		]]):format(displace)
	end,
}

registerTalentTranslation{
	id = "T_REPULSION_FIELD",
	name = "排斥之环",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 用 %d 码 半 径 范 围 的 重 力 吸 收 光 环 围 绕 自 己， 击 退 所 有 单 位 并 造 成 %0.2f 物 理 伤 害。 此 效 果 持 续 %d 回 合。 对 定 身 状 态 目 标 额 外 造 成 50%% 伤 害。 
		 这 股 爆 炸 性 冲 击 波 可 能 会 对 目 标 造 成 多 次 伤 害， 这 取 决 于 攻 击 半 径 和 击 退 效 果。 
		 受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_CLONE",
	name = "时空复制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage_penalty = t.getDamagePenalty(self, t)
		return ([[你 复 制 目 标， 从 其 他 时 间 线 上 召 唤 出 复 制 体， 持 续 %d 回 合 。 持 续 时 间 将 会 除 以 目 标 分 级 的 一 半 ， 且 复 制 体 只 拥 有 目 标 %d%% 的 生 命 ， 造 成 的 伤 害 减 少 %d%% 。
		如 果 你 复 制 了 一 个 敌 人 ， 复 制 体 会 立 刻 瞄 准 那 个 被 你 复 制 的 敌 人 。 
		受 法 术 强 度 加 成 ， 生 命 值 和 伤 害 惩 罚 按 比 例 减 小 。]]):
		format(duration, 100 - damage_penalty, damage_penalty)
	end,
}

registerTalentTranslation{
	id = "T_DAMAGE_SMEARING",
	name = "时空转化",
	info = function(self, t)
		local percent = t.getPercent(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[你 转 化 所 有 受 到 的 %d%% 的 非 时 空 伤 害 为 持 续 %d 回 合 的 时 空 伤 害 释 放 出 去。 
		 造 成 的 伤 害 无 视 抗 性 和 伤 害 吸 收 。]]):format(percent, duration)
	end,
}

registerTalentTranslation{
	id = "T_PHASE_SHIFT",
	name = "相位切换",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[切换你的相位 %d 回合；任何将会对你造成超过你最大生命值 10%% 伤害的攻击会把你传送到一个相邻的格子里，并且这次伤害减少50%% （每回合只能发生一次）。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_SWAP",
	name = "时空交换",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getConfuseDuration(self, t)
		local power = t.getConfuseEfficency(self, t)
		return ([[你 控 制 时 间 的 流 动 来 使 你 和 %d 码 范 围 内 的 某 个 怪 物 交 换 位 置。 目 标 会 混 乱（ %d%% 强 度） %d 回 合。 
		 受 法 术 强 度 影 响， 法 术 命 中 率 有 额 外 加 成 。]]):format (range, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_WAKE",
	name = "时空苏醒",
	info = function(self, t)
		local stun = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[暴 力 地 折 叠 你 和 另 外 一 个 点 之 间 的 空 间。 你 传 送 到 目 标 地 点 并 造 成 时 空 的 苏 醒 ， 震 慑 路 径 上 的 所 有 目 标 %d 回 合 并 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 （ 折 叠 ） 伤 害 
		 受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(stun, damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

registerTalentTranslation{
	id = "T_CARBON_SPIKES",
	name = "碳化钉刺",
	info = function(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local armor = t.getArmor(self, t)
		return ([[脆 弱 的 碳 化 钉 刺 从 你 的 肉 体、 衣 服 和 护 甲 中 伸 出 来， 增 加 %d 点 护 甲 值。 同 时， 在 6 回 合 内 对 攻 击 者 造 成 总 计 %0.2f 点 流 血 伤 害。 每 次 你 受 到 攻 击 时， 护 甲 增 益 效 果 减 少 1 点。 每 回 合 会 自 动 回 复 1 点 护 甲 增 益 至 初 始 效 果。 
		 如 果 护 甲 增 益 降 到 1 点 以 下， 则 技 能 会 被 中 断， 效 果 结 束。 
		 受 法 术 强 度 影 响， 护 甲 增 益 和 流 血 伤 害 有 额 外 加 成。]]):
		format(armor, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DESTABILIZE",
	name = "时空裂隙",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[使 目 标 所 处 的 时 空 出 现 裂 隙， 每 回 合 造 成 %0.2f 时 空 伤 害， 持 续 10 回 合。 如 果 目 标 在 被 标 记 时 死 亡， 则 会 产 生 4 码 半 径 范 围 的 时 空 爆 炸， 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 伤 害。 
		 如 果 目 标 死 亡 时 处 于 连 续 紊 乱 状 态 ， 则 爆 炸 产 生 的 所 有 伤 害 会 转 化 为 时 空 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), damDesc(self, DamageType.TEMPORAL, explosion/2), damDesc(self, DamageType.PHYSICAL, explosion/2))
	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_SPIKE",
	name = "量子钉刺",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[试 图 将 目 标 分 离 为 分 子 状 态， 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 伤 害 , 技 能 结 束 后 若 目 标 生 命 值 不 足 20%% 则 可 能 会 被 立 刻 杀 死。 
		 量 子 钉 刺 对 受 时 空 紊 乱 和 / 或 连 续 紊 乱 的 目 标 会 多 造 成 50％ 的 伤 害。 
		 受 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

return _M

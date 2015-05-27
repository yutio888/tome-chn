local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRAP_MASTERY",
	name = "陷阱大师",
	info = function(self, t)
		local detect_power = t.getPower(self, t)
		local disarm_power = t.getPower(self, t)*1.25
		return ([[学 会 如 何 使 用 陷 阱。 你 将 会 学 到 新 的 陷 阱 如 下： 
		 等 级 1 ： 爆 炸 陷 阱 
		 等 级 2 ： 兽 夹 陷 阱 
		 等 级 3 ： 弹 射 陷 阱 
		 等 级 4 ： 缴 械 陷 阱 
		 等 级 5 ： 颠 茄 陷 阱 
		 同 时 你 还 可 以 向 世 界 上 特 定 的 人 学 习 新 陷 阱。 
		 同 时 提 高 你 %d%% 的 陷 阱 效 果。（ 此 效 果 对 每 个 陷 阱 都 有 效） 并 让 陷 阱 更 难 被 发 现、 被 解 除 （ %d 点 侦 测 强 度， %d 点 解 除 强 度 ， 基 于 灵 巧）。
		 当 陷 阱 消 失 时， 如 果 效 果 未 触 发， 回 复 80%% 体 力 消 耗。]]):
		format(t.getTrapMastery(self,t), detect_power, disarm_power) 
	end,
}

registerTalentTranslation{
	id = "T_LURE",
	name = "诱饵",
	info = function(self, t)
		local t2 = self:getTalentFromId(self.T_TAUNT)
		local rad = t2.radius(self, t)	
		return ([[抛 出 一 个 持 续 %d 回 合 的 诱 饵 来 吸 引 %d 码 半 径 内 的 敌 人。 
		 在 等 级 5 时， 当 诱 饵 被 摧 毁 时， 它 会 自 动 触 发 在 它 周 围 2 码 范 围 内 的 陷 阱（ 可 鉴 定 某 些 陷 阱 是 否 能 被 触 发 )。 
		 此 技 能 不 会 打 断 潜 行 状 态。]]):format(t.getDuration(self,t), rad)
	end,
}

registerTalentTranslation{
	id = "T_STICKY_SMOKE",
	name = "粘性烟雾",
	info = function(self, t)
		return ([[向 敌 人 抛 出 1 个 爆 炸 范 围 为 %d 码 半 径 的 烟 雾 弹， 降 低 目 标 %d 码 可 见 范 围， 持 续 5 回 合。 
		 被 烟 雾 弹 影 响 的 目 标 不 会 影 响 你 进 入 潜 行， 即 使 他 们 跟 你 很 靠 近 也 无 法 影 响。 
		 此 技 能 不 会 打 断 潜 行 状 态。]]):
		format(self:getTalentRadius(t), t.getSightLoss(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TRAP_LAUNCHER",
	name = "陷阱投掷",
	info = function(self, t)
		return ([[允 许 你 制 造 可 自 动 布 置 的 陷 阱， 你 可 以 将 它 投 掷 到 %d 码 以 外。
		等 级 5 时 你 投 掷 陷 阱 时 不 再 发 出 声 音 ， 不 会 打 破 潜 行 。 ]]):format(trap_range(self, t))
	end,
}

registerTalentTranslation{
	id = "T_EXPLOSION_TRAP",
	name = "爆炸陷阱",
	info = function(self, t)
		return ([[放 置 一 个 爆 炸 陷 阱。 在 2 码 半 径 范 围 内 对 目 标 造 成 %0.2f 火 焰 伤 害 持 续 数 回 合。 
		 高 等 级 诱 饵 能 触 发 这 个 陷 阱。]]):
		format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_BEAR_TRAP",
	name = "兽夹陷阱",
	info = function(self, t)
		return ([[放 置 一 个 兽 夹 陷 阱。 夹 住 敌 人 产 生 定 身 效 果 并 造 成 每 回 合 %0.2f 点 流 血 伤 害， 持 续 5 回 合。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))) 
	end,
}

registerTalentTranslation{
	id = "T_CATAPULT_TRAP",
	name = "弹射陷阱",
	info = function(self, t)
		return ([[放 置 一 个 弹 射 陷 阱。 击 退 经 过 的 敌 人 %d 码， 并 附 加 眩 晕 效 果。]]):
		format(t.getDistance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DISARMING_TRAP",
	name = "缴械陷阱",
	info = function(self, t)
		return ([[放 置 一 个 缴 械 陷 阱。 经 过 的 目 标 受 到 %0.2f 点 酸 性 伤 害， 并 被 缴 械 %d 回 合。 ]]):
		format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NIGHTSHADE_TRAP",
	name = "颠茄陷阱",
	info = function(self, t)
		return ([[放 置 一 个 涂 了 颠 茄 毒 素 的 陷 阱， 造 成 %0.2f 自 然 伤 害 并 震 慑 目 标 4 回 合。]]):
		format(damDesc(self, DamageType.NATURE, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_FLASH_BANG_TRAP",
	name = "闪光陷阱",
	info = function(self, t)
		return ([[放 置 一 个 闪 光 陷 阱。 产 生 一 个 2 码 范 围 的 爆 炸， 致 盲 或 眩 晕 目 标 %d 回 合。
		 范 围 内 所 有 人 将 受 到 %0.2f 点 物 理 伤 害 。
		 持 续 时 间 受 陷 阱 大 师 等 级 加 成。 
		 高 级 诱 饵 可 触 发 这 个 陷 阱。]]):
		format(t.getDuration(self, t), damDesc(self, engine.DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_POISON_GAS_TRAP",
	name = "毒气陷阱",
	info = function(self, t)
		return ([[ 放 置 一 个 毒 气 陷 阱， 在 3 码 范 围 内 产 生 毒 云 爆 炸， 持 续 4 回 合。 
		 每 回 合 毒 云 对 目 标 造 成 %0.2f 自 然 伤 害， 持 续 5 回 合。 
		 高 级 诱 饵 可 触 发 这 个 陷 阱。 ]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_GRAVITIC_TRAP",
	name = "引力陷阱",
	info = function(self, t)
		return ([[ 放 置 一 个 引 力 陷 阱， 将 附 近 5 码 范 围 内 的 敌 人 拉 向 它。
		 每 回 合 陷 阱 对 所 有 目 标 造 成 %0.2f 时 空 伤 害。]]):
		format(damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)))
	end,
}



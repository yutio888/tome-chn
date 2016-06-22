local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MUCUS",
	name = "粘液",
	info = function(self, t)
		local dur = t.getDur(self, t)
		local dam = t.getDamage(self, t)
		local equi = t.getEqui(self, t)
		return ([[你 开 始 在 你 经 过 或 站 立 的 地 方 滴 落 粘 液， 持 续 %d 回 合。 
		 粘 液 每 回 合 自 动 放 置 ， 持 续 %d 回 合 。
		 在 等 级 4 时， 粘 液 会 扩 展 到 1 码 半 径 范 围。 
		 粘 液 会 使 所 有 经 过 的 敌 人 中 毒， 每 回 合 造 成 %0.1f 自 然 伤 害， 持 续 5 回 合（ 可 叠 加）。 
		 站 在 自 己 的 粘 液 上 时 ， 你 每 回 合 回 复 %0.1f 失 衡 值 。
		 每 个 经 过 粘 液 的 友 方 单 位， 每 回 合 将 和 你 一 起 回 复 1 点 失 衡 值。  
		 受 精 神 强 度 影 响， 伤 害 和 失 衡 值 回 复 有 额 外 加 成。 
		 在 同 样 的 位 置 站 在 更 多 的 粘 液 上 会 强 化 粘 液 效 果 ， 增 加 1 回 合 持 续 时 间 。]]):
		format(dur, dur, damDesc(self, DamageType.NATURE, dam), equi)
	end,
}

registerTalentTranslation{
	id = "T_ACID_SPLASH",
	name = "酸液飞溅",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 召 唤 大 自 然 的 力 量， 将 %d 码 半 径 范 围 内 的 地 面 转 化 为 酸 性 淤 泥 区， 对 所 有 目 标 造 成 %0.1f 酸 性 伤 害 并 在 区 域 内 制 造 粘 液。 
		 同 时 如 果 你 有 任 何 粘 液 软 泥 怪 存 在， 则 会 向 视 线 内 的 某 个 被 淤 泥 击 中 的 随 机 目 标 释 放 史 莱 姆 喷 吐（ 较 低 强 度）。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_MUCUS_OOZE_SPIT",
	name = "粘液喷吐",
	info = function(self, t)
		return ([[喷 射 一 道 射 线 造 成 %0.2f 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.SLIME, self:combatTalentMindDamage(t, 8, 80)))
	end,
}

registerTalentTranslation{
	id = "T_LIVING_MUCUS",
	name = "粘液伙伴",
	info = function(self, t)
		return ([[你 的 粘 液 有 了 自 己 的 感 知。 每 回 合 有 %d%% 几 率， 随 机 一 个 滴 有 你 的 粘 液 的 码 子 会 产 生 一 只 粘 液 软 泥 怪。 
		 粘 液 软 泥 怪 会 存 在 %d 回 合 ，会 向 任 何 附 近 的 敌 人 释 放 史 莱 姆 喷 吐。 
		 同 时 场 上 可 存 在 %d 只 粘 液 软 泥 怪。 ( 基 于 你 的 灵 巧 值 )
		 每 当 你 造 成 一 次 精 神 暴 击， 你 的 所 有 粘 液 软 泥 怪 的 存 在 时 间 会 延 长 2 回 合。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(t.getChance(self, t), t.getSummonTime(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OOZEWALK",
	name = "粘液探戈",
	info = function(self, t)
		local nb = t.getNb(self, t)
		local energy = t.getEnergy(self, t)
		return ([[你 暂 时 性 的 和 粘 液 融 为 一 体， 净 化 你 身 上 %d 物 理 或 魔 法 负 面 效 果。 
		 然 后， 你 可 以 闪 现 到 视 野 内 任 何 有 粘 液 覆 盖 的 区 域。
		 此 技 能 消 耗 %d%% 回 合。 
		 只 有 当 你 站 在 粘 液 区 时 才 能 使 用。]]):
		format(nb, (energy) * 100)
	end,
}


return _M

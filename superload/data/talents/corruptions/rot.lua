local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INFECTIOUS_BITE",
	name = "传染性啃咬",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local poison = t.getPoisonDamage(self, t)
		return ([[啃 咬 目 标，造 成 %d%% 武 器 伤 害。  
		如 果 攻 击 击 中 目 标 你 会 注 入 瘟 疫 病 毒,  造 成 %0.2f 枯 萎 伤 害 并 在 4 回 合 内 造 成 %0.2f 枯 萎 伤 害。
		伤 害 受 法术 强 度 加 成。]])
		:format(damage, damDesc(self, DamageType.BLIGHT, poison/4), damDesc(self, DamageType.BLIGHT, poison) )
	end,
}

registerTalentTranslation{
	id = "T_INFESTATION",
	name = "侵扰",
	info = function(self, t)
	local resist = t.getResist(self,t)
	local affinity = t.getAffinity(self,t)
	local dam = t.getDamage(self,t)
	local reduction = t.getDamageReduction(self,t)*100
		return ([[你 的 身 体 已 经 腐 败 ,增 加 %d%% 枯 萎 和 酸 性 抗 性 , %d%% 枯 萎 伤 害 吸 收。
		每 次 生 命 值 损 失 大 于 15%% 时,伤 害 将 减 少 %d%% ，同 时 在 相 邻 的 格 子 生 成 蠕 虫, 攻 击 你 的 敌 人 5 回合 。
		你 同 时 只 能 拥 有 5 只 蠕 虫 。 。
		蠕 虫 死 亡 时 将 爆 炸 ， 产 生 半 径 2 的 枯 萎 毒 池 ， 持 续 5 回 合 ，造 成 %0.2f 枯 萎 伤 害 并 治 疗 你 %d 。]]):
		format(resist, affinity, reduction, damDesc(self, DamageType.BLIGHT, dam), dam)
	end,
}

registerTalentTranslation{
	id = "T_WORM_WALK",
	name = "蠕虫行走",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t) * 100
		local vim = t.getVim(self, t)

		return ([[你 解 体 为 蠕 虫 ， 并 在 目 标 处 合 并。（误 差 %d）
如 果 对 蠕 虫 团 使 用 ， 你 和 它 合 体  ， 治 疗 %d%% 最 大 生 命 值 , 回 复 %d 活 力 。]]):
format (radius, heal, vim)
	end,
}

registerTalentTranslation{
	id = "T_PESTILENT_BLIGHT",
	name = "致命枯萎",
	info = function(self, t)
	local chance = t.getChance(self,t)
	local duration = t.getDuration(self,t)
		return ([[每 次 造 成 枯 萎 伤 害 ，有 %d%% 几 率 令 目 标 腐 烂 ， 沉 默 、致 盲 、 缴 械 或 者 定 身 %d 回 合。 该 效 果 有 冷 却 时 间。
技 能 等 级 4 时 ， 该 效 果 对 半 径 1 内 所 有 目 标 有 效 。
同 时 ， 你 的 蠕 虫 在 近 战 攻 击 中 有 %d%% 几 率 附 加 沉 默 、 致 盲 、 缴 械 或 定 身 效 果 ， 持 续 2 回 合 。
负 面 状 态 施 加 成 功 率 受 法 术 强 度 影 响。]]):
		format(chance, duration, chance/2)
	end,
}

registerTalentTranslation{
	id = "T_WORM_ROT",
	name = "腐烂蠕虫",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local burst = t.getBurstDamage(self, t)
		return ([[使 目 标 感 染 腐 肉 寄 生 幼 虫 持 续 5 回 合。 每 回 合 会 移 除 目 标 一 个 物 理 增 益 效 果 并 造 成 %0.2f 酸 系 和 %0.2f 枯 萎 伤 害。 
		 如 果 5 回 合 后 未 被 清 除 则 幼 虫 会 孵 化 造 成 %0.2f 枯 萎 伤 害， 移 除 这 个 效 果 但 是 会 在 目 标 处 成 长 为 一 条 成 熟 的 腐 肉 虫。
		 伤 害 受 法 术 强 度 加 成。]]):
		format(damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.BLIGHT, (burst)))
	end,
}


return _M

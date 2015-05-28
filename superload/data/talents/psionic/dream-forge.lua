local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FORGE_SHIELD",
	name = "熔炉屏障",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[当 你 将 要 承 受 一 次 超 过 15 ％ 最 大 生 命 值 的 攻 击 时， 你 会 锻 造 一 个 熔 炉 屏 障 来 保 护 自 己， 减 少 %0.2f 点 所 有 该 类 型 攻 击 伤 害 于 下 %d 回 合。 
		 熔 炉 屏 障 能 够 同 时 格 挡 多 种 类 型 的 伤 害， 但 是 每 一 种 已 拥 有 的 格 挡 类 型 会 使 伤 害 临 界 点 上 升 15 ％。
		 如 果 你 完 全 格 挡 了 某 一 攻 击 者 的 伤 害， 则 此 攻 击 者 受 到 持 续 1 回 合 的 反 击 DEBUFF（ 200 ％ 普 通 近 身 或 远 程 伤 害）。 
		 在 等 级 5 时， 格 挡 效 果 将 持 续 2 回 合。 
		 受 精 神 强 度 影 响， 格 挡 值 按 比 例 加 成。]]):format(power, dur)
	end,
}

registerTalentTranslation{
	id = "T_FORGE_BELLOWS",
	name = "熔炉风箱",
	info = function(self, t)
		local blast_damage = t.getBlastDamage(self, t)/2
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local forge_damage = t.getForgeDamage(self, t)/2
		return ([[将 梦 之 熔 炉 的 风 箱 打 开， 朝 向 你 的 四 周， 对 锥 形 范 围 内 敌 人 造 成 %0.2f 精 神 伤 害， %0.2f 燃 烧 伤 害 并 造 成 击 退 效 果。 锥 型 范 围 的 半 径 为 %d 码 。
		 空 旷 的 地 面 有 50 ％ 几 率 转 化 为 持 续 %d 回 合 的 熔 炉 外 壁。 熔 炉 外 壁 阻 挡 移 动， 并 对 周 围 敌 人 造 成 %0.2f 的 精 神 伤 害 和 %0.2f 的 火 焰 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 和 击 退 几 率 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.MIND, blast_damage), damDesc(self, DamageType.FIRE, blast_damage), radius, duration, damDesc(self, DamageType.MIND, forge_damage), damDesc(self, DamageType.FIRE, forge_damage))
	end,
}

registerTalentTranslation{
	id = "T_FORGE_ARMOR",
	name = "熔炉护甲",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local defense = t.getDefense(self, t)
		local psi = t.getPsiRegen(self, t)
		return([[你 的 熔 炉 屏 障 技 能 现 在 可 以 增 加 你 %d 点 护 甲， %d 点 闪 避， 并 且 当 你 被 近 战 或 远 程 攻 击 击 中 时 给 予 你 %0.2f 超 能 力 值。 
		 受 精 神 强 度 影 响， 增 益 按 比 例 加 成。]]):format(armor, defense, psi)
	end,
}

registerTalentTranslation{
	id = "T_DREAMFORGE",
	name = "梦之熔炉",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)/2
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local fail = t.getFailChance(self,t)
		return ([[你 将 脑 海 里 锻 造 的 冲 击 波 向 四 周 释 放。 
		 每 回 合 当 你 保 持 静 止， 你 将 会 锤 击 梦 之 熔 炉， 对 周 围 敌 人 造 成 精 神 和 燃 烧 伤 害。 
		 此 效 果 将 递 增 5 个 回 合， 直 至 %d 码 最 大 范 围， %0.2f 最 大 精 神 伤 害 和 %0.2f 最 大 燃 烧 伤 害。 
		 此 刻， 你 将 会 打 破 那 些 听 到 熔 炉 声 的 敌 人 梦 境， 减 少 它 们 %d 精 神 豁 免， 并 且 由 于 敲 击 熔 炉 的 
		 巨 大 回 声， 它 们 将 获 得 一 个 %d%% 的 法 术 失 败 率， 持 续 %d 回 合。 
		 梦 境 破 碎 有 %d%% 几 率 对 你 的 敌 人 产 生 锁 脑 效 果。 
		 受 精 神 强 度 影 响， 伤 害 和 梦 境 打 破 效 果 按 比 例 加 成。]]):
		format(radius, damDesc(self, DamageType.MIND, damage), damDesc(self, DamageType.FIRE, damage), power, fail, duration, chance)
	end,
}


return _M

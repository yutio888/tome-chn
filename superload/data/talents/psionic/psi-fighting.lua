local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TELEKINETIC_SMASH",
	name = "灵能冲击",
	info = function(self, t)
		return ([[凝 集 你 的 意 念 ，用 主 手 武 器 和 念 动 武 器 狂 莽 地 砸 击 你 的 目 标 ，造 成 %d%% 武 器 伤 害 。
		 如 果 你 的 主 手 武 器 命 中 ，将 震 慑 目 标 %d 回 合 。
		 此 次 攻 击 根 据 意 志 和 灵 巧 来 判 定 伤 害 和 命 中 ，取 代 力 量 和 敏 捷 。
		 此 次 攻 击 中 任 何 激 活 光 环 的 伤 害 附 加 将 会 沿 用 到 武 器 上 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.9, 1.5), t.duration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_AUGMENTATION",
	name = "心灵强化",
	info = function(self, t)
		local inc = t.getMult(self, t)
		local str_power = inc*self:getWil()
		local dex_power = inc*self:getCun()
		return ([[当 开 启 时 ， 你 为 了 你 的 血 肉 之 躯 精 准 地 灌 布 精 神 之 力 。 分 别 增 加 意 志 和 灵 巧 的 %d%% 至 力 量 和 敏 捷。
		力 量 增 加 %d 点
		敏 捷 增 加 %d 点]]):
		format(inc*100, str_power, dex_power)
	end,
}

registerTalentTranslation{
	id = "T_WARDING_WEAPON",
	name = "武器格挡",
	info = function(self, t)
		return ([[用 意 念 进 行 防 御 。
		 下 一 个 回 合 ，你 的 念 动 武 器 会 完 全 格 挡 对 你 的 第 一 次 近 战 攻 击 ，并 反 击 攻 击 者 造 成 %d%% 武 器 伤 害 。
		 技 能 等 级 3 时 你 还 能 缴 械 攻 击 者 3 回 合 。
		 技 能 等 级 5 时 每 回 合 你 有 %d%% 几 率 被 动 格 挡 一 次 近 战 攻 击 ，并 消 耗 1 5 点 超 能 力 值 。 几 率 受 灵 巧 加 成 。 
		 这 个 技 能 需 要 一 把 主 手 武 器 和 一 把 念 动 武 器 。]]):
		format(100 * t.getWeaponDamage(self, t), t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPALE",
	name = "灵能突刺",
	info = function(self, t)
		return ([[将 你 的 意 志 灌 入 你 的 念 动 武 器 ，使 它 猛 力 推 进 并 刺 穿 你 的 目 标 并 恶 毒 的 绞 开 它 的 身 体 。
		 这 次 攻 击 将 造 成 %d%% 武 器 伤 害 ，并 使 目 标 流 血 4 回 合 ，累 计 造 成 %0.1f 物 理 伤 害 。
		 在 3 级 时 ，武 器 将 势 不 可 挡 地 突 进 ，有 %d%% 几 率 击 碎 目 标 身 上 一 个 临 时 性 的 伤 害 护 盾 （如 果 存 在 ）。
		 判 定 此 次 攻 击 的 伤 害 和 命 中 时 ，意 志 和 灵 巧 讲 替 代 力 量 和 敏 捷 。
		 流 血 伤 害 随 精 神 强 度 增 加 。]]):
		format(100 * t.getWeaponDamage(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self,t)), t.getShatter(self, t))
	end,
}


return _M

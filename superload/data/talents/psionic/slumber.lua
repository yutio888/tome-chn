local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLUMBER",
	name = "催眠",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[目 标 进 入 持 续 %d 回 合 的 深 睡 眠， 使 其 无 法 进 行 任 何 动 作。 目 标 每 承 受 %d 伤 害， 睡 眠 的 持 续 时 间 减 少 一 回 合。 
		 当 催 眠 结 束 时， 目 标 会 饱 受 失 眠 的 痛 苦， 持 续 回 合 等 于 已 睡 眠 的 回 合 数（ 但 最 多 5 回 合）， 失 眠 状 态 的 每 一 个 剩 余 回 合 数 会 让 目 标 获 得 %d%% 睡 眠 免 疫。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 有 额 外 加 成。]]):format(duration, power, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_RESTLESS_NIGHT",
	name = "不眠之夜",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return([[被 你 沉 睡 的 目 标 在 醒 来 时 每 行 走 一 回 合 将 承 受 %0.2f 精 神 伤 害， 持 续 5 回 合。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

registerTalentTranslation{
	id = "T_SANDMAN",
	name = "睡魔",
	info = function(self, t)
		local power_bonus = t.getSleepPowerBonus(self, t) - 1
		local insomnia = t.getInsomniaPower(self, t)
		return([[增 加 %d%% 你 对 被 睡 眠 目 标 在 睡 眠 回 合 减 少 前 所 能 造 成 的 伤 害， 并 且 减 少 %d%% 你 造 成 的 失 眠 效 果 所 增 加 的 睡 眠 免 疫。 
		 这 些 效 果 将 即 时 反 映 在 技 能 描 述 中。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 的 增 益 效 果 按 比 例 加 成。]]):format(power_bonus * 100, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_DREAMSCAPE",
	name = "梦境空间",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return([[进 入 某 个 睡 眠 状 态 目 标 的 梦 境 中， 持 续 %d 回 合。 
		 当 你 位 于 梦 境 空 间 中 时， 你 将 会 遇 到 目 标 无 敌 的 睡 眠 形 态， 每 4 回 合 它 会 制 造 出 1 个 梦 境 守 卫 来 保 护 它 的 心 灵。 
		 除 非 目 标 激 活 了 清 晰 梦 境， 否 则 梦 境 守 卫 造 成 的 普 通 伤 害 只 有 50 ％。 
		 当 梦 境 空 间 的 效 果 结 束 时， 你 每 摧 毁 一 个 梦 境 守 卫， 目 标 生 命 值 会 减 少 10 ％， 并 且 受 到 持 续 1 回 合 的 锁 脑 效 果（ 可 叠 加）。 
		 在 梦 境 空 间 中 时， 你 的 伤 害 会 提 高 %d%% 。 
		 受 精 神 强 度 影 响， 伤 害 增 益 有 额 外 加 成。]]):format(duration, power)
	end,
}


return _M

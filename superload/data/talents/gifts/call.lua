local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MEDITATION",
	name = "冥想",
	info = function(self, t)
		local boost = 1 + (self.enhance_meditate or 0)

		local pt = (2 + self:combatTalentMindDamage(t, 20, 120) / 10) * boost
		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
		local rest = 0.5 * self:getTalentLevelRaw(t)
		return ([[你 进 入 冥 想， 与 大 自 然 进 行 沟 通。 
		 冥 想 时 每 回 合 你 能 回 复 %d 失 衡 值， 你 的 精 神 豁 免 提 高 %d ， 你 的 治 疗 效 果 提 高 %d%% 。 
		 冥 想 时 你 无 法 集 中 精 力 攻 击， 你 和 你 的 召 唤 物 造 成 的 伤 害 减 少 50 ％。 
		 另 外， 你 在 休 息 时（ 即 使 未 开 启 冥 想） 会 自 动 进 入 冥 想 状 态， 使 你 每 回 合 能 回 复 %d 点 失 衡 值。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(pt, save, heal, rest)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_TOUCH",
	name = "自然之触",
	info = function(self, t)
		return ([[对 你 自 己 或 某 个 目 标 注 入 大 自 然 的 能 量， 治 疗 %d 点 生 命 值（ 对 不 死 族 无 效）。 
		 受 精 神 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(20 + self:combatTalentMindDamage(t, 20, 500))
	end,
}

registerTalentTranslation{
	id = "T_EARTH_S_EYES",
	name = "大地之眼",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local radius_esp = t.radius_esp(self, t)
		return ([[利 用 你 与 大 自 然 的 联 系， 你 可 以 查 看 自 身 周 围 %d 码 半 径 范 围 的 区 域。 
		 同 时， 当 你 处 于 冥 想 状 态 时， 你 还 可 以 查 看 自 身 周 围 %d 码 半 径 范 围 中 怪 物 的 位 置。]]):
		format(radius, radius_esp)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_BALANCE",
	name = "自然平衡",
	info = function(self, t)
		return ([[你 与 大 自 然 间 的 深 刻 联 系， 使 你 能 够 立 刻 冷 却 %d 个 技 能 层 次 不 超 过 %d 的 自 然 系 技 能。]]):
		format(t.getTalentCount(self, t), t.getMaxLevel(self, t))
	end,
}


return _M

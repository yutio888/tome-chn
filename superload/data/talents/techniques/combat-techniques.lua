local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RUSH",
	name = "冲锋",
	info = function(self, t)
		return ([[快 速 冲 向 你 的 目 标， 如 果 目 标 被 撞 到， 那 么 你 将 获 得 一 次 无 消 耗 的 攻 击， 伤 害 为 120% 基 础 武 器 伤 害。 
		如 果 此 次 攻 击 命 中， 那 么 目 标 会 被 眩 晕 3 回 合。 
		你 必 须 从 至 少 2 码 以 外 开 始 冲 锋。]])
	end,
}

registerTalentTranslation{
	id = "T_PRECISE_STRIKES",
	name = "精准打击",
	info = function(self, t)
		return ([[你 集 中 精 神 攻 击， 减 少 你 %d%% 攻 击 速 度 并 增 加 你 %d 点 命 中 和 %d%% 暴 击 率。 
		受 敏 捷 影 响， 此 效 果 有 额 外 加 成。]]):
		format(10, t.getAtk(self, t), t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PERFECT_STRIKE",
	name = "完美打击",
	info = function(self, t)
		return ([[你 已 经 学 会 专 注 你 的 攻 击 来 命 中 目 标， 增 加 %d 命 中 并 使 你 在 攻 击 你 看 不 见 的 目 标 时 不 再 受 到 额 外 惩 罚， 持 续 %d 回 合。]]):format(t.getAtk(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_SPEED",
	name = "急速",
	info = function(self, t)
		return ([[通 过 严 格 的 训 练 你 已 经 学 会 在 短 时 间 内 爆 发 你 的 速 度， 提 高 你 %d%% 速 度 5 回 合。]]):format(100*t.getSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_QUICK_RECOVERY",
	name = "快速恢复",
	info = function(self, t)
		return ([[你 专 注 于 战 斗， 使 得 你 可 以 更 快 的 回 复 体 力（ +%0.1f 体 力 / 回 合）。]]):format(t.getStamRecover(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FAST_METABOLISM",
	name = "快速代谢",
	info = function(self, t)
		return ([[你 专 注 于 战 斗， 使 你 可 以 更 快 的 回 复 生 命 值（ +%0.1f 生 命 值 / 回 合）。]]):format(t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPELL_SHIELD",
	name = "法术抵抗",
	info = function(self, t)
		return ([[严 格 的 训 练 使 得 你 对 某 些 法 术 效 果 具 有 更 高 的 抗 性（ +%d 法 术 豁 免）。]]):format(self:getTalentLevel(t) * 9)
	end,
}

registerTalentTranslation{
	id = "T_UNENDING_FRENZY",
	name = "无尽怒火",
	info = function(self, t)
		return ([[你 陶 醉 在 敌 人 的 死 亡 中， 每 杀 死 一 个 敌 人 回 复 %d 体 力 值。]]):format(t.getStamRecover(self, t))
	end,
}


return _M

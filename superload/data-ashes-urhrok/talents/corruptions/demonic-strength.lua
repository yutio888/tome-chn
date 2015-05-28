local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISMEMBER",
	name = "肢解",
	info = function(self, t)
	return ([[当 近 战 攻 击 暴 击 时， 致 残 你 的 目 标，降 低 %d%% 移 动 速 度 和 %d 命 中 ，持 续 %d 回合 。
	同 时 ，增 加 %d%% 近 战 暴 击 率。]]):format(t.getSlow(self, t), t.getAcc(self, t), t.getDuration(self, t), t.statBonus(self, t))
	end,
}


registerTalentTranslation{
	id = "T_SURGE_OF_POWER",
	name = "力量之潮",
	info = function(self, t)
	return ([[你 使 用 体 内 蕴 藏 的 活 力 强 化 自 己 的 身 体 ， 恢 复 %d%% 最 大 体 力 值（ %d 点）和 %d%% 最 大 生 命 值 （ %d 点）。
	同 时 让 你 在 -%d 生 命 时 才 会 死 亡 ， 此 效 果 持 续 8 回 合。
	此 技 能 瞬 发 ， 恢 复 值 受 法 术 强 度 加 成。]]):
	format(t.stamValue(self, t) * 100, t.stamValue(self, t) * self.max_stamina,  t.getHeal(self, t)*100, t.getHeal(self, t) * self.max_life, t.getPower(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMONIC_BLOOD",
	name = "恶魔之血",
	info = function(self, t)
	return ([[你 体 内 涌 动 着 恶 魔 之 血 ，增 加 %d 点 法 术 强 度 和 %d 点 活 力 上 限。
	同 时 获 得 相 当 于 当 前 活 力 %d%% 的 全 伤 害 加 成 （ 当 前 %d%% ） 。]]):
	format(t.statBonus(self, t),t.vimBonus(self, t),(t.atkBonus(self, t)),(t.atkBonus(self, t)/100)*self:getVim())
	end,
}


registerTalentTranslation{
	id = "T_ABYSSAL_SHIELD",
	name = "深渊护盾",
	info = function(self, t)
	return ([[深 渊 气 息 围 绕 着 你 ， 增 加 %d 点 护 甲 ， 增 加 %0.2f 点 火 焰 、 %0.2f 点 枯 萎 近 战 反 击 伤 害。
	同 时 你 的 活 力 会 增 强 你 的 防 御 ， 减 少 相 当 于 当 前 活 力 %d%% 的 伤 害 （ 目 前 为 %d 点），但 不 会 减 少 超 过 原 伤 害 的 一 半 。 此 效 果会 消 耗 等 同 于 5%% 减 少 伤 害 值 的 活 力。
	伤 害 值 受 法 术 强 度 加 成 。]]):
		format(	t.statBonus(self, t),t.getDamage(self,t),t.getDamage(self,t),t.defBonus(self, t),(t.defBonus(self, t)/100)*self:getVim())
	end,
}


return _M

local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISENGAGE",
	name = "后跳",
	info = function (self,t)
		return ([[指 定 目 标 ， 向 后 跳 跃 %d 格 ， 可 以 跃 过 途 中 所 有 生 物 。
		你 必 须 选 择 可 见 目 标 ， 必 须 以 近 乎 直 线 的 轨 迹 后 跳 。
		落 地 后 ， 你 获 得 3 回 合 %d%% 移 动 速 度 加 成 ， 采 取 除 移 动 外 的 行 动 会 提 前 终 止。
		移 动 速 度 和 跳 跃 距 离 会 受 疲 劳 值 影 响 。]]):
		format(t.getDist(self, t), t.getSpeed(self,t), t.getNb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_EVASION",
	name = "闪避",
	info = function (self,t)
		local chance, def = t.getChanceDef(self,t)
		return ([[你 的 战 斗 技 巧 和 反 射 神 经 让 你 能 迅 速 躲 闪 攻 击 ，获 得 %d%% 几 率 躲 闪 近 战 与 远 程 攻 击 ，闪 避 增 加 %d ，持 续 %d 回 合 。
		 躲 闪 几 率 和 闪 避 加 成 受 敏 捷 加 成 。]]):
		format(chance, def,t.getDur(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TUMBLE",
	name = "翻筋斗",
	info = function (self,t)
		return ([[你 迅 速 地 移 动 至 范 围 内 可 见 的 位 置 ，跃 过 路 径 上 所 有 敌 人 。
		 该 技 能 在 身 着 重 甲 时 不 能 使 用 ，使 用 后 你 会 进 入 疲 劳 状 态 ，增 加 移 动 系 技 能 消 耗 %d%% （可 以 叠 加 ），%d 回 合 后 解 除 。]]):format(t.getExhaustion(self,t),t.getDuration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TRAINED_REACTIONS",
	name = "特种训练",
	info = function (self,t)
		local stam = t.getStamina(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t, true)*100
		return ([[经 过 训 练 后 ，你 脚 步 轻 快 ，神 经 敏 锐 。
		 技 能 开 启 时 ，你 会 对 任 何 将 超 过 你 %d%% 最 大 生 命 值 的 伤 害 做 出 反 应 。
		 消 耗 %0.1f 体 力 ，你 将 减 少 %d%% 伤 害 。
		 身 着 重 甲 时 无 法 使 用 。
		 伤 害 减 免 受 闪 避 加 成 。]])
		:format(trigger, stam, reduce)
	end,
}


return _M

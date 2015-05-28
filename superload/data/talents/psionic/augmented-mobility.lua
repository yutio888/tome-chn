local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKATE",
	name = "极速滑行",
	info = function(self, t)
		return ([[用 念 力 使 自 己 漂 浮 。
		这 使 你 能 在 战 斗 中 快 速 滑 行 ，增 加 你 的 移 动 速 度 %d%% 。
		它 同 样 使 你 更 容 易 被 推 开 (-%d%%  击 退 抗 性 )。]]): 
		format(t.getSpeed(self, t)*100, t.getKBVulnerable(self, t)*100) 
	end,
}

registerTalentTranslation{
	id = "T_QUICK_AS_THOUGHT",
	name = "灵动迅捷",
	info = function(self, t)
		local inc = t.speed(self, t)
		local percentinc = 100 * inc
		local boost = t.getBoost(self, t)
		return ([[用 灵 能 围 绕 你 的 躯 体 ，通 过 思 想 直 接 高 效 控 制 身 体 ，而 不 是 通 过 神 经 和 肌 肉 。
		增 加 %d 命 中 、 %0.1f%% 暴 击 率 和 %d%% 攻 击 速 度， 持 续  %d  回 合。 
		受 精 神 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(boost, 0.5*boost, percentinc, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MINDHOOK",
	name = "心灵钩爪",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[用 灵 能 将 远 处 的 敌 人 抓 过 来。
		至 多 对 半 径 %d 的 敌 人 有 效 。
		范 围 和 冷 却 时 间 受 技 能 等 级 影 响 。]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_TELEKINETIC_LEAP",
	name = "灵能跳跃",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[使 用 灵 能 ，精 准 地 跳 向 %d 码 外 的 地 点。]]):
		format(range)
	end,
}


return _M

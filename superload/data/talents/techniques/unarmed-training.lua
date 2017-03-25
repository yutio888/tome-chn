local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMPTY_HAND",
	name = "空手道",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[当 你 徒 手 或 仅 装 备 手 套 和 臂 铠 时 提 高 %d 物 理 强 度。 
		受 技 能 等 级 影 响， 效 果 有 额 外 加 成。 ]]):
		format(damage)
	end,
}

registerTalentTranslation{
	id = "T_UNARMED_MASTERY",
	name = "徒手大师",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[提 高 %d 物 理 强 度， 增 加 %d%% 所 有 徒 手 伤 害（ 包 括 抓 取 / 徒 手 技）。 
		注 意： 徒 手 战 斗 时 格 斗 家 随 等 级 每 级 增 加 0.5 物 理 强 度。（ 当 前 提 高 %0.1f 物 理 强 度） 你 的 攻 击 速 度 提 高 20%% 。]]):
		format(damage, 100*inc, self.level * 0.5)
	end,
}

registerTalentTranslation{
	id = "T_UNIFIED_BODY",
	name = "强化身躯",
	info = function(self, t)
		return ([[你 对 徒 手 格 斗 的 掌 握 强 化 了 你 的 身 体 ， 增 加 %d 力 量 （基 于 灵 巧 ） ， %d 体 质 （ 基 于 敏 捷 ）。]]):format(t.getStr(self, t), t.getCon(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HEIGHTENED_REFLEXES",
	name = "高度反射",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[当 你 被 抛 射 物 锁 定 时， 增 加 你 %d%% 整 体 速 度 1 回 合。 
		除 了 移 动 外 的 任 何 动 作 均 会 打 破 此 效 果。]]):
		format(power * 100)
	end,
}

registerTalentTranslation{
	id = "T_REFLEX_DEFENSE",
	name = "闪避神经",
	info = function(self, t)
		return ([[你 对 生 理 的 了 解 让 你 能 在 新 的 领 域 运 用 你 的 闪 避 神 经。 
		 攻 击 姿 态 的 减 伤 效 果 增 强 %d%% ，对 你 的 暴 击 伤 害 的 暴 击 系 数 下 降 %d%% 。]]):
		format(t.getFlatReduction(self,t), t.critResist(self,t) )
	end,
}


return _M

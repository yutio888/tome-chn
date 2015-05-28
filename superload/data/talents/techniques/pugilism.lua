local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRIKING_STANCE",
	name = "攻击姿态",
	info = function(self, t)
		local attack = t.getAttack(self, t)
		local damage = t.getDamage(self, t)
		return ([[增 加 你 %d 命 中。 你 攻 击 系 技 能 ( 拳 术、 终 结 技 ) 伤 害 增 加 %d%% , 同 时 减 少 %d 受 到 的 伤 害。
		受 敏 捷 影 响， 伤 害 按 比 例 加 成 。受 力 量 影 响，伤 害 减 免 有 额 外 加 成。 ]]):
		format(attack, damage, t.getFlatReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DOUBLE_STRIKE",
	name = "双重打击",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对 目 标 进 行 2 次 快 速 打 击， 每 次 打 击 造 成 %d%% 伤 害 并 使 你 的 姿 态 切 换 为 攻 击 姿 态， 如 果 你 已 经 在 攻 击 姿 态 且 此 技 能 已 就 绪， 那 么 此 技 能 会 自 动 取 代 你 的 普 通 攻 击 ( 并 触 发 冷 却 )。 
		任 何 一 次 打 击 都 会 使 你 获 得 1 点 连 击 点。 在 等 级 4 或 更 高 等 级 时 若 2 次 打 击 都 命 中 你 可 以 获 得 2 点 连 击 点。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_SPINNING_BACKHAND",
	name = "旋风打击",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local charge =t.chargeBonus(self, t, t.range(self, t)-1)*100
		return ([[对 你 面 前 的 敌 人 使 用 一 次 旋 风 打 击， 造 成 %d%% 伤 害。 
		如 果 你 离 目 标 较 远， 旋 转 时 你 会 自 动 前 行， 根 据 移 动 距 离 增 加 至 多 %d%% 伤 害。 
		此 次 攻 击 会 移 除 任 何 你 正 在 维 持 的 抓 取 效 果 并 增 加 1 点 连 击 点。 
		在 等 级 4 或 更 高 时， 你 每 次 连 击 均 会 获 得 1 点 连 击 点。 ]])
		:format(damage, charge)
	end,
}

registerTalentTranslation{
	id = "T_AXE_KICK",
	name = "斧踢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[ 施 展 一 次 毁 灭 性 的 的 踢 技 ，造 成 %d%% 伤 害 。
		 如 果 攻 击 命 中 ， 对 方 的 大 脑 受 到 伤 害 ，不 能 使 用 技 能 ， 持 续 %d 回 合 ， 同 时 你 获 得 2 连 击 点。 ]])
		:format(damage, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLURRY_OF_FISTS",
	name = "流星拳",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对 目 标 造 成 3 次 快 速 打 击， 每 击 造 成 %d%% 伤 害。 
		此 攻 击 使 你 得 到 1 点 连 击 点。 
		在 等 级 4 或 更 高 时， 你 每 次 连 击 都 可 以 获 得 1 点 连 击 点。]])
		:format(damage)
	end,
}


return _M

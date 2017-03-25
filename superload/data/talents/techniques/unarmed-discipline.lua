local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PUSH_KICK",
	name = "强力踢",
	info = function(self, t)
		local damage = t.getDamage(self, t) *100
		return ([[每 有 一 个 连 击 点， 对 目 标 造 成 %d%% 武 器 伤 害，并 解 除 目 标 一 项 物 理 持 续 技 能。 
		等 级 3 时，魔 法 持 续 技 能 也 会 受 影 响。
		等 级 5 时，精 神 持 续 技 能 也 会 受 影 响。 
		使 用 该 技 能 将 除 去 全 部 连 击 点。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_STRIKES",
	name = "无情打击",
	info = function (self,t)
		local stamina = t.getStamina(self, t)
		local chance = t.getChance(self, t)
		return ([[当 获 得 一 个 连 击 点 时, 你 有 %d%% 几 率 获 得 一 个 额 外 的 连 击 点. 另 外, 每 当 你 获 得 连 击 点 时, 你 会 恢 复 %0.2f 体 力,如 果 你 将 超 过 5 个 连 击 点 改 为 获 得 %0.2f 体 力 .]])
		:format(chance, stamina, stamina*2)
	end,
}

registerTalentTranslation{
	id = "T_BREATH_CONTROL",
	name = "空手格挡",
	info = function(self, t)
		local block = t.getBlock(self, t)
		local maxblock = block*5
		return ([[硬 化 身 体 ，每 有 一 点 连 击 点 就 能 格 挡 %d 点 伤 害（至 多 %d ）,持 续 2 回 合。
			当 前 格 挡 值:  %d
			使 用 该 技 能 会 除 去 所 有 连 击 点。
			伤 害 吸 收 受 物 理 强 度 加 成。]])
		:format(block, block * 5, block * self:getCombo())
	end,
}

registerTalentTranslation{
	id = "T_TOUCH_OF_DEATH",
	name = "死亡接触",
	info = function (self,t)
		local damage = t.getDamage(self, t) * 100
		local mult = t.getMult(self,t)
		local finaldam = damage+(damage*(((mult/100)+1)^2))+(damage*(((mult/100)+1)^3))+(damage*(((mult/100)+1)^4))
		local radius = self:getTalentRadius(t)
		local life = t.getLifePercent(self,t)
		return ([[使 用 你 深 刻 的 解 剖 学 知 识, 击 中 敌 人 的 弱 点 造 成 %d%% 武 器 伤 害, 无 视 防 御 和 闪 避.
		这 次 攻 击 在 敌 人 身 上 造 成 可 怕 的 创 伤, 在 四 回 合 内 造 成 100%% 原 始 伤 害 的 物 理 伤 害 ,  每 回 合 增 加 %d%% (4 回 合 后, 总 共 造 成 %d%% 伤 害).
		如 果 目 标 死 在 该 效 果 下, 他 们 身 体 会 爆 炸 并 让 半 径 %d 内 的 敌 人 受 到 等 于 他 们 最 大 生 命 值 %d%% (除 以 阶 级) 的 物 理 伤 害 并 给 你 4 点 连 击 点.]])
		:format(damage, mult, finaldam, radius, life)
	end,
}


		
	


return _M

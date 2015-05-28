local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UPPERCUT",
	name = "上钩拳",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local stun = t.getDuration(self, t, 0)
		local stunmax = t.getDuration(self, t, 5)
		return ([[一 次 终 结 的 上 钩 拳， 对 目 标 造 成 %d%% 伤 害 并 可 能 震 慑 目 标 %d 到 %d 回 合 （ 由 你 的 连 击 点 数 决 定）。 
		受 物 理 强 度 影 响， 震 慑 概 率 有 额 外 加 成。 
		使 用 此 技 能 会 消 耗 当 前 的 所 有 连 击 点。]])
		:format(damage, stun, stunmax)
	end,
}

registerTalentTranslation{
	id = "T_CONCUSSIVE_PUNCH",
	name = "金刚碎",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local area = t.getAreaDamage(self, t) * 0.25
		local areamax = t.getAreaDamage(self, t) * 1.25
		local radius = self:getTalentRadius(t)
		return ([[一 次 强 力 的 冲 击， 对 目 标 造 成 %d%% 武 器 伤 害。 如 果 此 次 攻 击 命 中， 则 会 对 %d 码 半 径 内 所 有 目 标 造 成 %0.2f ～ %0.2f 物 理 伤 害（ 由 你 的 连 击 点 数 决 定）。 
		受 力 量 影 响， 范 围 伤 害 按 比 例 加 成， 每 1 点 连 击 点 范 围 上 升 1 码。 
		使 用 此 技 能 会 消 耗 当 前 所 有 连 击 点。]])
		:format(damage, radius, damDesc(self, DamageType.PHYSICAL, area), damDesc(self, DamageType.PHYSICAL, areamax))
	end,
}

registerTalentTranslation{
	id = "T_BUTTERFLY_KICK",
	name = "蝴蝶踢",
	info = function(self, t)
		return ([[你 旋 转 着 飞 踢 过 去 ， 对 半 径 1 内 的 敌 人 造 成 %d%% 武 器 伤 害。
		 每 一 点 连 击 点 增 加 1 点 攻 击 范 围 和 10%% 伤 害 。
		 使 用 该 技 能 需 要 至 少 一 点 连 击 点 。]]):format(t.getDamage(self, t)*100)	
	end,
}

registerTalentTranslation{
	id = "T_HAYMAKER",
	name = "收割之刃",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local maxDamage = damage * 2
		local stamina = t.getStamina(self, t, 0)/self.max_stamina*100
		local staminamax = t.getStamina(self, t, 5)/self.max_stamina*100
		return ([[一 次 强 烈 的 终 结 追 击， 对 目 标 造 成 %d%% 伤 害， 每 1 点 连 击 点 额 外 造 成 20%% 的 伤 害 ，至多 %d%% 。 
		如 果 目 标 生 命 低 于 20%% ， 则 会 被 立 刻 杀 死。 
		用 此 技 能 杀 死 目 标 会 立 刻 回 复 你 %d%% 到 %d%% 最 大 体 力 值（ 由 你 的 连 击 点 数 决 定）。 
		使 用 此 技 能 会 消 耗 当 前 所 有 连 击 点。]])
		:format(damage, maxDamage, stamina, staminamax)
	end,
}


return _M

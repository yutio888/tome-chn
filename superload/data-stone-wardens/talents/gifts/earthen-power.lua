local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONESHIELD",
	name = "岩石坚盾",
	info = function(self, t)
		local m, mm, e, em = t.getValues(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[每 回 合 第 一 次 承 受 伤 害 时 ， 你 将 %d%% 的 伤 害 转 化 为 法 力 ( 至 多 %0.2f 点 ) ， %d%% 的 伤 害 转 化 为 失 衡 值 ( 至 多 回 复 %0.2f)。
		增 加 物 理 强 度 %d , 增 加 盾 牌 伤 害 %d%% , 并 让 你 能 够 双 持 盾 牌 。
		同 时 ， 你 的 近 战 攻 击 附 带 一 次 盾 牌 攻 击 。]]):format(100 * m, mm, 100 * e, em, damage, inc*100)
	end,
}

registerTalentTranslation{
	id = "T_STONE_FORTRESS",
	name = "岩石壁垒",
	info = function(self, t)
		return ([[当 你 使 用 钢 筋 铁 骨 时 ， 你 的 皮 肤 会 变 得 非 常 坚 硬 ， 甚 至 能 吸 收 非 物 理 攻 击。
		所 有 非 物 理 伤 害 减 免 %d%% 护 甲 值 （ 无 视 护 甲 硬 度 ）。]]):
		format(t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHARDS",
	name = "岩石碎片",
	info = function(self, t)
		return ([[尖 锐 的 岩 石 碎 片 从 盾 牌 生 长 出 来。
		每 次 你 承 受 近 战 攻 击 时 ， 你 能 利 用 这 些 碎 片 反 击 攻 击 者 ， 造 成 %d%% 自 然 伤 害 。
		每 回 合 只 能 反 击 一 次 。]]):
		format(self:combatTalentWeaponDamage(t, 0.4, 1) * 100)
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_STONE",
	name = "岩石护盾",
	info = function(self, t)
		local power = t.getPower(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制 造 一 层 持 续 7 回 合 的 岩 石 护 盾 ， 吸 收 至 多 %d 点 伤 害。
		你 的 失 衡 值 将 会 上 升 两 倍 伤 害 吸 收 量。 
		护 盾 破 碎 时 ， 所 有 超 过 最 小 值 的 失 衡 值 将 被 转 化 为 法 力 ， 同 时 释 放 奥 术 能 量 风 暴 , 造 成 等 同 于 转 化 失 衡 值 的 奥 术 伤 害 （ 至 多 %d 点 ） ， 伤 害 半 径 %d 。
		同 时 ， 你 休 息 时 获 得 每 回 合 %0.2f 回 魔 速 度。
		护 盾 值 受 法 术 强 度 加 成 。]]):format(power, t.maxDamage(self, t), radius, t.manaRegen(self, t))
	end,
}


return _M

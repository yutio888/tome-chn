local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACID_INFUSION",
	name = "酸液充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[ 将 酸 性 能 量 填 充 至 炼 金 炸 弹 ， 能 致 盲 敌 人 。
		 你 造 成 的 酸 性 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_CAUSTIC_GOLEM",
	name = "酸液覆体",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local dam = self.alchemy_golem and self.alchemy_golem:damDesc(engine.DamageType.ACID, t.getDamage(self, t)) or 0
		return ([[当 你 的 酸 性 充 能 激 活 时 ， 若 你 的 炸 弹 击 中 了 你 的 傀 儡 ， 酸 液 会 覆 盖 傀 儡 %d 回 合 。
		 当 傀 儡 被 酸 液 覆盖时，任 何 近 战 攻 击 有 %d%% 概 率 产 生 一 次 范 围 4 的 锥 形 酸 液 喷 射 ， 造 成 %0.1f 点 伤 害 （ 每 回 合 至 多 一 次 ）。

		 受 法 术 强 度 、技 能 等 级 和 傀 儡 伤 害 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(duration, chance, dam)
	end,
}

registerTalentTranslation{
	id = "T_CAUSTIC_MIRE",
	name = "腐蚀之地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 一 小 块 酸 液 覆 盖 了 目 标 地 面 ，散 落 在 半 径 %d 的 范 围 内 ， 每 回 合 造 成 %0.1f 点 酸 性 伤 害 ， 持续 %d 回 合 。
		 受 影 响 的 生 物 同 时 会 减 速 %d%% 。
		 受 法 术 强 度 影 响 ，伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.ACID, damage), duration, slow)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVING_ACID",
	name = "酸液溶解",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 酸 液 在 目 标 周 围 爆 发 ， 造 成 %0.1f 点 酸 性 伤 害。
		 酸 性 伤 害 具 有 腐 蚀 性 ， 有 一 定 概 率 除 去 至多 %d 个 物 理 / 精 神 状 态 效 果 或 是 精 神 持 续 效 果。
		 受 法 术 强 度 影 响 ， 伤 害 和 几 率 额 外 加 成 。]]):format(damDesc(self, DamageType.ACID, damage), t.getRemoveCount(self, t))
	end,
}


return _M

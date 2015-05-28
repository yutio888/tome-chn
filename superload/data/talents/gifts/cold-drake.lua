local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ICE_CLAW",
	name = "冰爪",
	info = function(self, t)
		return ([[你 召 唤 强 大 的 冰 龙 之 爪，在 半 径 %d 范 围 内 造 成 %d%% 寒 冰 武 器 伤 害，有 一 定 几 率 冻 结 目 标。
		 同 时 ， 该 技 能 每 等 级 增 加 物 理、 法 术 与 精 神 豁 免 4 点。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%% 。]]):format(self:getTalentRadius(t),100 * t.damagemult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ICY_SKIN",
	name = "冰肤术",
	info = function(self, t)
		local life = t.getLifePct(self, t)
		return ([[你 的 皮 肤 上 覆 盖 了 寒 冰 ， 血 肉 更 加 坚 硬。 增 加 %d%% 最 大 生 命 与 %d 护 甲 值。
		同 时 ， 你 对 近 战 命 中 你 的 目 标 造 成 %0.2f 寒 冷 伤 害 。
		每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%% 。
		生 命 加 成 受 技 能 等 级 影 响，护 甲 和 伤 害 受 精 神 强 度 加 成。]]):format(life * 100, t.getArmor(self, t), damDesc(self, DamageType.COLD, t.getDamageOnMeleeHit(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_ICE_WALL",
	name = "冰墙术",
	info = function(self, t)
		local icerad = t.getIceRadius(self, t)
		local icedam = t.getIceDamage(self, t)
		return ([[召 唤 一 条 长 度 %d 的 冰 墙 ， 持 续 %d 回 合 。冰 墙 是 透 明 的 ， 但 能 阻 挡 抛 射 物 和 敌 人 。
		冰 墙 会 释 放 极 度 寒 气， 每 格 墙 壁 对 半 径 %d 内 的 敌 人 造 成 %0.2f 伤 害 ， 并 有 25%% 几 率 冻 结 。 寒 气 不 会 伤 害 释 放 者 及 其 召 唤 物 。
		每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%% 。]]):format(3 + math.floor(self:getTalentLevel(t) / 2) * 2, t.getDuration(self, t), damDesc(self, DamageType.COLD, icedam),  icerad)
	end,
}

registerTalentTranslation{
	id = "T_ICE_BREATH",
	name = "冰息术",
	info = function(self, t)
		return ([[向 前 方 %d 码 范 围 施 放 一 个 锥 形 冰 冻 吐 息， 范 围 内 所 有 目 标 受 到 %0.2f 寒 冷 伤 害， 减 速 20%% , 并 有 25%% 几 率 被 冻 结 数 回 合（ 敌 人 等 级 较 高 时 冰 冻 时 间 缩 短）。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.COLD, self:combatTalentStatDamage(t, "str", 30, 500)))
	end,
}


return _M

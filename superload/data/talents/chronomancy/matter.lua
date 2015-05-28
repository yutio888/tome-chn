local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DUST_TO_DUST",
	name = "土归土",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[发 射 一 道 射 线 ，令 物 质 归 于 尘 土 ，造 成 %0.2f 时 空 与 %0.2f 物 理 伤 害 。
		 也 可 以 以 自 己 为 目 标 ，制 造 一 个 围 绕 自 己 %d 码 的 领 域 ，在 3 回 合 内 造 成 伤 害 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage / 2), damDesc(self, DamageType.PHYSICAL, damage / 2), radius)
	end,
}

registerTalentTranslation{
	id = "T_MATTER_WEAVING",
	name = "物质编织",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local immune = t.getImmunity(self, t) * 100
		return ([[你 的 血 肉 被 改 变， 对 伤 害 的 抗 性 提 高 。
		增 加 %d 护 甲， %d%% 震 慑 与 割 伤 免 疫。
		护 甲 加 成 受 魔 法 加 成 。]]):
		format(armor, immune)
	end,
}

registerTalentTranslation{
	id = "T_MATERIALIZE_BARRIER",
	name = "物质屏障",
	info = function(self, t)
		local length = t.getLength(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制 造 一 层 坚 实 的 物 质 墙 ，长 度 为 %d ，持 续 %d 回 合。
		当 墙 壁 被 挖 掘 时 ， 会 产 生 半 径 %d 的 爆 炸，范 围 内 敌 人 会 进 入 流 血 状 态， 6 回 合 内 受 到 %0.2f 物 理 伤 害 。]])
		:format(length, duration, radius, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DISINTEGRATION",
	name = "裂解",
	info = function(self, t)
		local digs = t.getDigs(self, t)
		local chance = t.getChance(self, t)
		return ([[你 造 成 物 理 和 时 空 伤 害 时， 有 %d%% 几 率 除 去 一 项 物 理 或 魔 法 增 益 效 果。
		每 个 生 物 每 回 合 只 能 被 除 去 一 项 效 果。
		同 时 ， 你 的 土 归 土 技 能 能 挖 至 多 %d 格 内 的 墙 壁 。]]):
		format(chance, digs)
	end,
}

return _M

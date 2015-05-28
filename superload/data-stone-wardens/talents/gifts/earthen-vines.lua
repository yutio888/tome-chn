local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_VINES",
	name = "岩石藤蔓",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local turns, dam, arcanedam = t.getValues(self, t)
		local xs = arcanedam and (" 和 %0.1f奥术伤害"):format(arcanedam) or ""
		return ([[你 周 围 的 地 面 开 始 生 成 岩 石 藤 蔓。
		每 回 合 藤 蔓 将 试 图 抓 住 半 径 %d 内 的 一 个 随 机 目 标 。
		受 影 响 的 目 标 将 被 定 身 ， 同 时 每 回 合 受 到 %0.1f 物 理 伤 害 %s, 持 续 %d 回 合 。
		被 岩 石 藤 蔓 抓 住 的 生 物 每 回 合 有 一 定 几 率 逃 脱 ， 如 果 距 离 你 超 过 %d 码 则 自 动 逃 脱 。 
		该 技 能 开 启 时 ， 移 动 速 度 下 降 50%% 。
		定 身 几 率 和 伤 害 受 法 术 强 度 与 技 能 等 级 加 成。]]):
		format(rad, dam, xs, turns, rad+4)
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_VINES",
	name = "奥术藤蔓",
	info = function(self, t)
		return ([[每 次 藤 蔓 造 成 伤 害 时 ， 你 回 复 %0.1f 点 失 衡 值 与 %0.1f 点 法 力 值。
		同 时 藤 蔓 会 附 加 %0.1f 奥 术 伤 害 。]])
		:format(t.getEquilibrium(self, t), t.getMana(self, t), t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ROCKWALK",
	name = "岩石漫步",
	info = function(self, t)
		return ([[吸 收 一 条 岩 石 藤 蔓 ，并 将 自 己 拉 到 被 困 住 的 怪 物 附 近 （ 最 大 半 径 %d ）。
		吸 收 岩 石 藤 蔓 会 治 疗 你 %0.2f 点 生 命 值。
		使 用 这 个 技 能 不 会 打 破 岩 石 身 躯。]])
		:format(self:getTalentRange(t) ,100 + self:combatTalentStatDamage(t, "wil", 40, 630))
	end,
}

registerTalentTranslation{
	id = "T_ROCKSWALLOW",
	name = "岩石吞噬",
	info = function(self, t)
		return ([[将 半 径 %d 内 的 目 标 连 同 岩 石 藤 蔓 一 起 拉 过 来 ， 造 成 %0.1f 物 理 伤 害 。
		伤 害 受 法 术 强 度 加 成 。]])
		:format(self:getTalentRange(t), 80 + self:combatTalentStatDamage(t, "wil", 40, 330))
	end,
}


return _M

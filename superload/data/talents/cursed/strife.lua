local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DOMINATE",
	name = "压制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local armorChange = t.getArmorChange(self, t)
		local defenseChange = t.getDefenseChange(self, t)
		local resistPenetration = t.getResistPenetration(self, t)
		return ([[将 注 意 力 转 移 到 附 近 目 标 并 用 你 强 大 的 气 场 压 制 它。 如 果 目 标 未 能 通 过 精 神 强 度 豁 免 鉴 定， 目 标 %d 回 合 内 将 无 法 移 动 并 受 到 更 多 伤 害。 目 标 降 低 %d 点 护 甲 值、 %d 点 闪 避， 并 且 你 对 目 标 的 攻 击 会 增 加 %d%% 抵 抗 穿 透。 如 如 果 目 标 与 你 相 邻 , 那 么 此 技 能 会 附 加 一 次 近 战 攻 击。 
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(duration, -armorChange, -defenseChange, resistPenetration)
	end,
}

registerTalentTranslation{
	id = "T_PRETERNATURAL_SENSES",
	name = "第七感觉",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local sense = t.sensePower(self, t)
		return ([[你 的 第 7 感 能 让 你 能 在 狩 猎 中 发 现 下 个 牺 牲 品。 
		 你 能 感 觉 到 %0.1f 码 半 径 范 围 内 的 敌 人。 
		 在 10 码 半 径 范 围 内 你 总 能 看 见 被 追 踪 的 目 标。
		 同 时 增 加 你 的 侦 测 潜 行 等 级 %d ， 侦 测 隐 形 等 级 %d 。
		 受 意 志 影 响， 侦 测 强 度 有 额 外 加 成。 ]]):
		format(range, sense, sense)
	end,
}

registerTalentTranslation{
	id = "T_BLINDSIDE",
	name = "闪电突袭",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.7, 1.9)
		local defenseChange = t.getDefenseChange(self, t)
		return ([[你 闪 电 般 的 出 现 在 %d 码 范 围 内 的 敌 人 身 边， 造 成 %d%% （ 0 仇 恨） ～ %d%% （ 100+ 仇 恨） 的 伤 害。 
		 你 闪 电 般 的 突 袭 使 敌 人 没 有 提 防， 增 加 %d 点 额 外 闪 避， 持 续 1 回 合。 
		 受 力 量 影 响， 闪 避 值 有 额 外 加 成。]]):format(self:getTalentRange(t), multiplier * 30, multiplier * 100, defenseChange)
	end,
}

registerTalentTranslation{
	id = "T_REPEL",
	name = "无所畏惧",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[在 猛 烈 的 攻 击 面 前， 你 选 择 直 面 威 胁 而 不 是 躲 藏。 
		 当 技 能 激 活 时， 你 有 %d%% 概 率 抵 挡 一 次 近 程 攻 击。 不 顾 一 切 的 防 御 会 带 给 你 厄 运（ -3 幸 运）。 
		 分 裂 攻 击， 杀 意 涌 动 和 无 所 畏 惧 不 能 同 时 开 启， 并 且 激 活 其 中 一 个 也 会 使 另 外 两 个 进 入 冷 却。 
		 受 力 量 和 是 否 装 备 盾 牌 影 响， 概 率 有 额 外 加 成。]]):format(chance)
	end,
}



return _M

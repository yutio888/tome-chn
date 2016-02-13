local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSIBLADES",
	name = "心灵利刃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[将 你 的 精 神 能 量 灌 入 你 所 装 备 的 灵 晶 中， 使 其 生 成 心 灵 利 刃。 
		 灵 晶 所 产 生 的 心 灵 利 刃 会 进 行 %0.2f 伤 害 修 正 加 成（ 从 属 性 中 获 得 的 伤 害 值）， 增 加 %0.2f 护 甲 穿 透。
		 心 灵 利 刃 将 使 灵 晶 附 加 的 精 神 强 度、 意 志 和 灵 巧 变 为 %0.2f 倍。  
		 同 时 ，还 会 增 加 %d 点 物 理 强 度 与 %d%% 武 器 伤 害。]]):
		format(t.getStatmult(self, t), t.getAPRmult(self, t), t.getPowermult(self, t), damage, 100 * inc) 
	end,
}

registerTalentTranslation{
	id = "T_THORN_GRAB",
	name = "荆棘之握",
	info = function(self, t)
		return ([[你 通 过 心 灵 利 刃 接 触 你 的 目 标， 将 自 然 的 怒 火 带 给 你 的 敌 人。 
		 荆 棘 藤 蔓 会 抓 取 目 标， 使 其 减 速 %d%% ， 并 且 每 回 合 造 成 %0.2f 自 然 伤 害， 持 续 10 回 合。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 伤 害 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(100*t.speedPenalty(self,t), damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 15, 250) / 10 * get_mindstar_power_mult(self)), get_mindstar_power_mult(self))
	end,
}

registerTalentTranslation{
	id = "T_LEAVES_TIDE",
	name = "叶刃风暴",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local c = t.getChance(self, t)
		return ([[向 四 周 粉 碎 利 刃， 在 你 周 围 的 3 码 半 径 范 围 内 形 成 一 股 叶 刃 风 暴， 持 续 7 回 合。 
		 被 叶 刃 击 中 的 目 标 会 开 始 流 血， 每 回 合 受 到 %0.2f 点 伤 害（ 可 叠 加）。 
		 所 有 被 叶 刃 覆 盖 的 同 伴， 获 得 %d%% 概 率 完 全 免 疫 任 何 伤 害。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 伤 害 和 免 疫 几 率 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(dam, c, get_mindstar_power_mult(self))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_EQUILIBRIUM",
	name = "自然均衡",
	info = function(self, t)
		return ([[你 用 主 手 心 灵 利 刃 攻 击 敌 人 造 成 %d%% 武 器 伤 害， 用 副 手 心 灵 利 刃 传 导 敌 人 所 受 的 伤 害 能 量 来 治 疗 友 方 单 位。 
		 治 疗 最 大 值 为 %d 。 受 到 治 疗 效 果 的 目 标 失 衡 值 会 降 低 治 疗 量 的 10%% 。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 最 大 治 疗 值 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(self:combatTalentWeaponDamage(t, 2.5, 4) * 100, t.getMaxDamage(self, t), get_mindstar_power_mult(self))
	end,
}


return _M

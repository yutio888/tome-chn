local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MITOSIS",
	name = "有丝分裂",
	info = function(self, t)
		local xs = self:knowTalent(self.T_REABSORB) and ([[同 时， 当 这 个 技 能 开 启 时 ， 每 回 合 回 复 %0.1f 点 失 衡 值 。
		]]):format(self:callTalent(self.T_REABSORB, "equiRegen")) or ""
		return ([[你 的 身 体 构 造 变 的 像 软 泥 怪 一 样。 
		 当 你 受 到 攻 击 时， 你 有 几 率 分 裂 出 一 个 浮 肿 软 泥 怪， 其 生 命 值 为 你 所 承 受 的 伤 害 值 的 两 倍（ 最 大 %d ）。 
		 分 裂 几 率 为 你 损 失 生 命 百 分 比 的 %0.2f 倍。
		 你 所 承 受 的 所 有 伤 害 会 在 你 和 浮 肿 软 泥 怪 间 均 摊。 
		 你 同 时 最 多 只 能 拥 有 %d 只 浮 肿 软 泥 怪（ 基 于 你 的 灵 巧 值 和 技 能 等 级 ）。
		 浮 肿 软 泥 怪 对 非 均 摊 的伤 害 的 抗 性 很 高（ 50%% 对 全 部 伤 害 的 抗 性 ）,同 时 生 命 回 复 快。
		 受 精 神 强 度 影 响， 最 大 生 命 值 有 额 外 加 成。 
		 受 灵 巧 影 响， 几 率 有 额 外 加 成。]]):
		format(t.getMaxHP(self, t), t.getChance(self, t)*3/100, t.getMax(self, t), t.getSummonTime(self, t), t.getOozeResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_REABSORB",
	name = "强化吸收",
	info = function(self, t)
		return ([[ 你 随 机 吸 收 一 个 紧 靠 你 的 浮 肿 软 泥 怪， 获 得 40%% 对 全 部 伤 害 的 抗 性， 持 续 %d 个 回 合。 
		 同 时 你 会 释 放 一 股 反 魔 能 量， 在 %d 半 径 内 造 成 %0.2f 点 法 力 燃 烧 伤 害。 
		 如 果 有 丝 分 裂 技 能 开 启 ， 每 回 合 你 将 回 复 %0.1f 点 失 衡 值 。
		 受 精 神 强 度 影 响， 伤 害 、 持 续 时 间 和 失 衡 值 回 复 有 额 外 加 成。 ]]):
		format(t.getDuration(self, t), 3,damDesc(self, DamageType.ARCANE, t.getDam(self, t)),	 t.equiRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CALL_OF_THE_OOZE",
	name = "软泥召唤",
	info = function(self, t)
		return ([[立 刻 召 集 所 有 的 浮 肿 软 泥 怪 来 战 斗， 如 果 现 有 浮 肿 软 泥 怪 数 目 比 最 大 值 小， 最 多 可 以 制 造 %d 个 浮 肿 软 泥 怪， 每 一 个 的 生 命 值 不 能 超 过 有 丝 分 裂 技 能 允 许 的 生 命 最 大 值 的 %d%% 。 
		 每 一 个 浮 肿 软 泥 怪 将 被 传 送 到 其 视 野 内 的 敌 人 附 近，并 吸 引 其 注 意 力 。 
		 利 用 这 一 形 势， 你 将 对 浮 肿 软 泥 怪 面 对 的 敌 人 各 造 成 一 次 近 战 酸 性 伤 害， 数 值 为 武 器 伤 害 的 %d%% 。 ]]):
		format(t.getMax(self, t), t.getLife(self, t), t.getModHP(self, t)*100, t.getWepDamage(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_INDISCERNIBLE_ANATOMY",
	name = "奇异骨骼",
	info = function(self, t)
		return ([[ 你 身 体 里 的 内 脏 全 都 融 化 在 一 起， 隐 藏 了 你 的 要 害 部 位。 
		 所 有 直 接 对 你 的 暴 击 伤 害（ 物 理、 精 神、 法 术） 的 暴 击 加 成 减 少 %d%% （ 不 会 少 于 普 通 伤 害） 。 
		 你 将 额 外 获 得 %d%% 的 疾 病、 毒 素、 切 割 和 目 盲 免 疫。 ]]):
		format(t.critResist(self, t), 100*t.immunities(self, t))
	end,
}


return _M

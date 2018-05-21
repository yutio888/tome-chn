local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_VOID_STARS",
	name = "虚无之星",
	info = function(self, t)
		local power = t.getReduction(self,t)*100
		local regen = t.getRegen(self,t)
		return ([[形 成 围 绕 你 旋 转, 为 你 抵 御 伤 害 的 虚 无 之 星 。
		每 当 受 到 超 过 10%% 最 大 生 命 的 伤 害 时 ， 消 耗 一 颗 虚 无 之 星 ，使 受 到 的 伤 害 减 少 %d%%， 自 己 受 到 等 同 于 减 免 伤 害 40%% 的 熵 能 反 冲。
		此 技 能 只 有 装 备 轻 甲 时 生 效。]]):
		format(power, regen)
	end,
}

registerTalentTranslation{
	id = "T_NULLMAIL",
	name = "虚空护甲",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local power = t.getAbsorb(self, t)
		return ([[用 无 数 微 小 的 虚 空 之 星 强 化 护 甲 ， 护 甲 值 提 高 %d .
		每 次 虚 无 之 星 完 全 消 耗 后 ， 生 成 一 个 持 续 4 回 合 吸 收 %d 伤 害 的 护 盾 。 在 虚 无 之 星 完 全 恢 复 前 无 法 再 次 生 成 护 盾。]]):
		format(armor, power)
	end,
}

registerTalentTranslation{
	id = "T_BLACK_MONOLITH",
	name = "黑色巨石",
	info = function(self, t)
		return ([[消 耗 一 枚 虚 无 之 星 ， 在 目 标 位 置 召 唤 持 续 %d 回 合 的 虚 无 巨 石 。 巨 石 非 常 坚 固 ， 无 法 移 动 ， 每 半 回 合 对 2 码 范 围 内 敌 人 施 加 眩 晕 ( 基 于 本 体 法 术 强 度 ).
			基 于 你 的 魔 法 属 性 ， 巨 石 获 得 %d 生 命 回 复 和 %d%% 全 抗.]]):
		format(t.getDur(self, t), self:getTalentRadius(t), t.getLifeRating(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_REAVE",
	name = "精华收割",
	info = function(self, t)
		local damage = t.getDamage(self, t)/2
		local nb = t.getNb(self,t)
		return ([[撕 开 目 标 的 核 心 部 位 ，汲 取 生 命 转 化 为 虚 空 之 星 。 目 标 受 到 %0.2f 黑 暗 和 %0.2f 时 空 伤 害 ， 你 获 得 %d 虚 空 之 星 。
		伤 害 随 法 术 强 度 升 高 。]]):
		format(damDesc(self, DamageType.DARKNESS, (damage)), damDesc(self, DamageType.TEMPORAL, (damage)), nb)
	end,
}
return _M

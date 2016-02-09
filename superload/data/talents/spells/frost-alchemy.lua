local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FROST_INFUSION",
	name = "冰霜充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[将 寒 冰 能 量 填 充 至 炼 金 炸 弹 ， 能 冰 冻 敌 人 。
		 你 造 成 的 寒 冰 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_ICE_ARMOUR",
	name = "寒冰护甲",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = self.alchemy_golem and self.alchemy_golem:damDesc(engine.DamageType.COLD, t.getDamage(self, t)) or 0
		local armor = t.getArmor(self, t)
		return ([[当 你 的 寒 冰 充 能 激 活 时 ， 若 你 的 炸 弹 击 中 了 你 的 傀 儡 ， 冰 霜 会 覆 盖 傀 儡 %d 回 合 。
		 冰 霜 会 增 加 傀 儡 %d 点 护 甲 ， 同 时 受 到 近 战 攻 击 时 ， 会 反 击 攻 击 方 %0.1f 点 寒 冷 伤 害 ， 同 时 傀 儡 造 成 的 一 半 伤 害 转 化 为 寒 冰 伤 害 。
		 受 法 术 强 度 、 技 能 等 级 和 傀 儡 伤 害 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(duration, armor, dam)
	end,
}

registerTalentTranslation{
	id = "T_FLASH_FREEZE",
	name = "极速冻结",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在 半 径 %d 的 范 围 内 激 发 寒 冰 能 量 ， 造 成 %0.1f 点 寒 冷 伤 害 ， 同 时 将 周 围 的 生 物 冻 结 在 地 面 上 %d 个 回 合。 
		 受 影 响 的 生 物 能 够 行 动 ， 但 不 能 移 动。
		 受 法 术 强 度 影 响 ， 持 续 时 间 有 额 外 加 成 。]]):format(radius, damDesc(self, DamageType.COLD, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_ICE",
	name = "冰霜之躯",
	info = function(self, t)
		local resist = t.getResistance(self, t)
		local crit = t.critResist(self, t)
		return ([[ 将 你 的 身 体 转 化 为 纯 净 的 寒 冰 体 ， 你 受 到 的 寒 冰 伤 害 的 %d%% 会 治 疗 你 ， 同 时 你 的 物 理 抗 性 增 加 %d%% 。
		对 你 的 直 接 暴 击 会 减 少 %d%% 暴 击 系 数 ， 但 不 会 少 于 普 通 伤 害 。 
 		受 法 术 强 度 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(t.getAffinity(self, t), resist, resist * 0.6, crit)
	end,
}


return _M

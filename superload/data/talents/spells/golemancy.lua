local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INTERACT_GOLEM",
	name = "检查傀儡",
	info = function(self, t)
		return ([[和 你 的 傀 儡 交 互， 检 查 它 的 物 品、 技 能 等。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_REFIT_GOLEM",
	name = "改装傀儡",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[与 你 的 傀 儡 进 行 交 互： 
		- 如 果 它 被 摧 毁， 你 将 耗 费 一 些 时 间 重 新 安 装 傀 儡（ 需 要 15 个 炼 金 宝 石）。 
		- 如 果 它 还 存 活， 你 可 以 修 整 它 使 其 恢 复 %d 生 命 值。（ 耗 费 2 个 炼 金 宝 石）。 法 术 强 度、 炼 金 宝 石 和 强 化 傀 儡 技 能 都 会 影 响 治 疗 量。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_POWER",
	name = "强化傀儡",
	info = function(self, t)
		if not self.alchemy_golem then return "提 高 傀 儡 的 武 器 熟 练 度， 增 加 它 的 命 中、 物 理 强 度 和 伤 害。" end
		local rawlev = self:getTalentLevelRaw(t)
		local olda, oldd = self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY]
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = 1 + rawlev, rawlev
		local ta, td = self:getTalentFromId(Talents.T_WEAPON_COMBAT), self:getTalentFromId(Talents.T_WEAPONS_MASTERY)
		local attack = ta.getAttack(self.alchemy_golem, ta)
		local power = td.getDamage(self.alchemy_golem, td)
		local damage = td.getPercentInc(self.alchemy_golem, td)
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = olda, oldd
		return ([[提 高 傀 儡 的 武 器 熟 练 度， 增 加 它 %d 点 命 中、 %d 物 理 强 度 和 %d%% 伤 害。]]):
		format(attack, power, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_RESILIENCE",
	name = "坚韧傀儡",
	info = function(self, t)
		if not self.alchemy_golem then return " 提 高 傀 儡 护 甲 熟 练 度 和 伤 害 抵 抗 和 治 疗 系 数。 " end
		local rawlev = self:getTalentLevelRaw(t)
		local oldh, olda = self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR]
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = rawlev, 1 + rawlev
		local th, ta, ga = self:getTalentFromId(Talents.T_THICK_SKIN), self:getTalentFromId(Talents.T_ARMOUR_TRAINING), self:getTalentFromId(Talents.T_GOLEM_ARMOUR)
		local res = th.getRes(self.alchemy_golem, th)
		local heavyarmor = ta.getArmor(self.alchemy_golem, ta) + ga.getArmor(self.alchemy_golem, ga)
		local hardiness = ta.getArmorHardiness(self.alchemy_golem, ta) + ga.getArmorHardiness(self.alchemy_golem, ga)
		local crit = ta.getCriticalChanceReduction(self.alchemy_golem, ta) + ga.getCriticalChanceReduction(self.alchemy_golem, ga)
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = oldh, olda

		return ([[提 高 傀 儡 护 甲 熟 练 度 和 伤 害 抵 抗。 
		 增 加 %d%% 所 有 伤 害 抵 抗； 增 加 %d 点 护 甲 和 %d%% 护 甲 韧 性； 当 装 备 1 件 锁 甲 或 板 甲 时， 减 少 %d%% 被 暴 击 率； 增 加 %d%% 治 疗 效 果。 
		 傀 儡 可 以 使 用 所 有 类 型 的 护 甲， 包 括 板 甲。]]):
		format(res, heavyarmor, hardiness, crit, t.getHealingFactor(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_INVOKE_GOLEM",
	name = "傀儡召返",
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你 将 傀 儡 拉 到 你 身 边， 使 它 暂 时 性 增 加 %d 点 近 战 物 理 强 度， 持 续 5 回 合。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_PORTAL",
	name = "傀儡传送",
	info = function(self, t)
		return ([[使 用 此 技 能 后， 你 和 傀 儡 将 会 交 换 位 置。 
		 你 的 敌 人 会 被 混 乱， 那 些 之 前 攻 击 你 的 敌 人 将 有 %d%% 概 率 转 而 攻 击 傀 儡。]]):
		format(math.min(100, self:getTalentLevelRaw(t) * 15 + 25))
	end,
}


return _M

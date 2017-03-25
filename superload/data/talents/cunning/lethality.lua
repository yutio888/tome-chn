local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LETHALITY",
	name = "刺杀掌握",
	info = function(self, t)
		local critchance = t.getCriticalChance(self, t)
		local power = t.critpower(self, t)
		return ([[你 学 会 寻 找 并 打 击 目 标 弱 点。 你 的 攻 击 有 %0.1f%% 更 大 几 率 出 现 暴 击 且 暴 击 伤 害 增 加 %0.1f%% 。 同 时， 当 你 使 用 匕 首 时， 你 的 灵 巧 点 数 会 代 替 力 量 影 响 额 外 伤 害。]]):
		format(critchance, power)
	end,
}

registerTalentTranslation{
	id = "T_EXPOSE_WEAKNESS",
	name = "弱点暴露",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local bonus = damDesc(self, DamageType.PHYSICAL, t.getBonusDamage(self, t))
		local duration = t.getDuration(self, t)
		return ([[集 中 精 力 试 探 目 标 ， 寻 找 其 弱 点 ,造 成 %d%% 武 器 伤 害。
		试 探 攻 击 未 命 中 将 使 你 接 下 来 的 攻 击 命 中 追 加 %d 点 有 效 值。
		试 探 攻 击 命 中 将 使 你 接 下 来 的 攻 击 武 器 伤 害 增 加 %0.1f，护 甲 穿 透 增 加 %d 。
		以 上 效 果 持 续 %d 回合 。
		此 外， 你 额 外 获 得 %d 护 甲 穿 透。
		效 果 受 灵 巧 加 成 。]]):
		format(100 * damage, duration, t.getAccuracy(self, t), bonus, t.penetration(self, t), t.getAPR(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLADE_FLURRY",
	name = "剑刃乱舞",
	info = function (self,t)
		return ([[如 疾 风 般 挥 舞 武 器 ，攻 击 速 度 增 加  %d%%  ，每 次 攻 击 追 加 一 名 目 标 ，造 成  %d%%  武 器 伤 害 。
该 技 能 每 回 合 抽 取 6 点 体 力 。]]):format(t.getSpeed(self, t)*100, t.getDamage(self,t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SNAP",
	name = "灵光一闪",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[你 的 快 速 反 应 使 你 能 够 重 置 至 多 %d 个 层 级 不 超 过 %d 的 战 斗 技 能（ 灵 巧 类 或 格 斗 类） 的 冷 却 时 间。]]):
		format(talentcount, maxlevel)
	end,
}




return _M

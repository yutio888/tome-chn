local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LETHALITY",
	name = "刺杀掌握",
	info = function(self, t)
		local critchance = t.getCriticalChance(self, t)
		local power = t.critpower(self, t)
		return ([[你 学 会 寻 找 并 打 击 目 标 弱 点。 你 的 攻 击 有 %0.2f%% 更 大 几 率 出 现 暴 击 且 暴 击 伤 害 增 加 %0.1f%% 。 同 时， 当 你 使 用 匕 首 时， 你 的 灵 巧 点 数 会 代 替 力 量 影 响 额 外 伤 害。]]):
		format(critchance, power)
	end,
}

registerTalentTranslation{
	id = "T_DEADLY_STRIKES",
	name = "穿甲击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local apr = t.getArmorPierce(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 对 目 标 造 成 %d%% 的 伤 害。 如 果 你 的 攻 击 命 中， 你 会 增 加 %d 点 护 甲 穿 透， 持 续 %d 回 合。 
		 受 你 的 灵 巧 影 响， 护 甲 穿 透 有 额 外 加 成。]]):
		format(100 * damage, apr, duration)
	end,
}

registerTalentTranslation{
	id = "T_WILLFUL_COMBAT",
	name = "意志之刃",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 专 注 于 你 的 攻 击， 持 续 %d 回 合， 增 加 每 次 攻 击 %d 点 物 理 强 度。 
		 受 你 的 灵 巧 与 意 志 影 响， 效 果 有 额 外 加 成。]]):
		format(duration, damage)
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




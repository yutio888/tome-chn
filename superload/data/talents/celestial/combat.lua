local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WEAPON_OF_LIGHT",
	name = "光明之刃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local shieldflat = t.getShieldFlat(self, t)
		return ([[使 你 的 武 器 充 满 太 阳 能 量， 每 击 造 成 %0.2f 光 系 伤 害。 
		 如 果 你 同 时 打 开 了 临 时 伤 害 护 盾 ，近 战 攻 击 会 增 加 护 盾 %d 强 度 。
		 充 能 后 的 护 盾 持 续 时 间 若 不 足 2 回 合 ，会 被 延 长 至 2 回 合。
		 如 果 同 一 层 护 盾 被 延 长 了 20 次 ， 将 会 变 得 不 稳 定 而 破 碎。
		 受 法 术 强 度 影 响， 伤 害 和 护 盾 加 成 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), shieldflat)
	end,
}

registerTalentTranslation{
	id = "T_WAVE_OF_POWER",
	name = "圣光冲击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[你 用 圣 光 释 放 一 次 近 程 打 击， 造 成 %d%% 武 器 伤 害。 
		如 果 目 标 在 近 战 范 围 以 外 ， 有 一 定 几 率 进 行 二 次 打 击 ，造 成 %d%% 武 器 伤 害。
		二 次 打 击 几 率 随 距 离 增 加 ， 距 离 2 时 为 %0.1f%% ， 距 离 最 大（ %d ）时 几 率 为 %0.1f%% 。
		受 力 量 影 响， 攻 击 距 离 有 额 外 加 成。]]):
		format(t.getDamage(self, t)*100, t.getDamage(self, t, true)*100, t.SecondStrikeChance(self, t, 2), range,t.SecondStrikeChance(self, t, range))
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_OF_WRATH",
	name = "愤怒之刃",
	info = function(self, t)
		local martyr = t.getMartyrDamage(self, t)
		local damagepct = t.getLifeDamage(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 使 用 武 器 攻 击 时 ， 造 成 相 当 于 %d%% 你 已 损 失 的 生 命 值 的 火 焰 伤 害 , 至 多 %d 点,当 前 %d 点 
		然 后 令 目 标 进 入 殉 难 状 态，受 到 %d%% 自 己 造 成 的 伤 害 ，持 续 4 回 合。]]):
		format(damagepct*100, t.getMaxDamage(self, t, 10, 400), damage, martyr)
	end,
}

registerTalentTranslation{
	id = "T_SECOND_LIFE",
	name = "第二生命",
	info = function(self, t)
		return ([[任 何 使 你 生 命 值 降 到 1 点 以 下 的 攻 击 都 会 激 活 第 二 生 命， 自 动 中 断 此 技 能 并 将 你 的 生 命 值 恢 复 到 1 点,然 后 受 到 %d 点 治 疗。]]):
		format(t.getLife(self, t))
	end,
}

return _M

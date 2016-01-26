local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_FADE",
	name = "隐形",
	info = function(self, t)
		return ([[你 从 视 线 中 消 失 并 无 敌， 直 到 下 一 回 合 开 始。]])
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_PHASE_DOOR",
	name = "相位之门",
	info = function(self, t)
		return ([[小 范 围 内 将 你 传 送 一 段 距 离。]])
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_BLINDSIDE",
	name = "灵异打击",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.9, 1.9)
		return ([[你 以 难 以 置 信 的 速 度 闪 现 至 附 近 %d 码 的 一 个 目 标 身 边 并 造 成 %d%% 伤 害。]]):format(self:getTalentRange(t), multiplier * 100)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_LIGHTNING",
	name = "暗影闪电",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用 闪 电 打 击 目 标 造 成 %0.2f 到 %0.2f 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_FLAMES",
	name = "暗影之火",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用 火 焰 灼 烧 你 的 目 标 造 成 %0.2f 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIREBURN, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_REFORM",
	name = "重组",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[当 阴 影 受 到 伤 害 或 被 杀 死， 有 %d%% 几 率 重 组 并 免 受 伤 害。]]):format(chance)
	end,
}

registerTalentTranslation{
	id = "T_CALL_SHADOWS",
	name = "召唤阴影",
	info = function(self, t)
		local maxShadows = t.getMaxShadows(self, t)
		local level = t.getLevel(self, t)
		local healLevel = t.getHealLevel(self, t)
		local blindsideLevel = t.getBlindsideLevel(self, t)
		local avoid_master_damage = t.getAvoidMasterDamage(self, t)
		return ([[当 此 技 能 激 活 时， 你 可 以 召 唤 %d 个 等 级 %d 的 阴 影 帮 助 你 战 斗。 每 个 阴 影 需 消 耗 6 点 仇 恨 值 召 唤。 
		 阴 影 是 脆 弱 的 战 士， 它 们 能 够： 使 用 奥 术 重 组 治 疗 自 己（ 等 级 %d ）， 使 用 灵 异 打 击 突 袭 目 标（ 等 级 %d ）， 使 用 相 位 之 门 进 行 传 送。
		 阴 影 无 视 %d%% 主 人 造 成 的 伤 害。]]):format(maxShadows, level, healLevel, blindsideLevel, avoid_master_damage)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_WARRIORS",
	name = "阴影战士",
	info = function(self, t)
		local combatAtk = t.getCombatAtk(self, t)
		local incDamage = t.getIncDamage(self, t)
		local dominateChance = t.getDominateChance(self, t)
		local dominateLevel = t.getDominateLevel(self, t)
		local fadeCooldown = math.max(3, 8 - self:getTalentLevelRaw(t))
		return ([[将 仇 恨 注 入 你 的 阴 影， 强 化 他 们 的 攻 击。 他 们 获 得 %d%% 额 外 命 中 和 %d%% 额 外 伤 害 加 成。 
		 他 们 疯 狂 的 攻 击 可 以 令 他 们 控 制 对 手， 提 高 控 制 目 标 的 所 有 伤 害 4 回 合（ 等 级 %d ， %d%% 几 率 1 码 范 围）。 
		 它 们 同 时 拥 有 消 隐 的 能 力， 免 疫 所 有 伤 害 直 到 下 一 回 合 开 始（ %d 回 合 冷 却 时 间）。]]):format(combatAtk, incDamage, dominateLevel, dominateChance, fadeCooldown)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_MAGES",
	name = "阴影法师",
	info = function(self, t)
		local closeAttackSpellChance = t.getCloseAttackSpellChance(self, t)
		local farAttackSpellChance = t.getFarAttackSpellChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local lightningLevel = t.getLightningLevel(self, t)
		local flamesLevel = t.getFlamesLevel(self, t)
		return ([[灌 输 魔 力 给 你 的 阴 影 使 它 们 学 会 可 怕 的 法 术。 你 的 阴 影 获 得 %d 点 法 术 强 度 加 成。 
		 你 的 阴 影 可 以 用 闪 电 术 攻 击 附 近 的 目 标（ 等 级 %d ， %d%% 几 率 1 码 范 围）。 
		 等 级 3 时 你 的 阴 影 可 以 远 距 离 使 用 火 焰 术 灼 烧 你 的 敌 人（ 等 级 %d ， %d%% 几 率 2 到 6 码 范 围）。 
		 等 级 5 时 你 的 阴 影 在 被 击 倒 时 有 一 定 几 率 重 组 并 重 新 加 入 战 斗（ 50%% 几 率）。]]):format(spellpowerChange, lightningLevel, closeAttackSpellChance, flamesLevel, farAttackSpellChance)
	end,
}

registerTalentTranslation{
	id = "T_FOCUS_SHADOWS",
	name = "聚集阴影",
	info = function(self, t)
		local defenseDuration = t.getDefenseDuration(self, t)
		local blindsideChance = t.getBlindsideChance(self, t)
		return ([[将 你 的 阴 影 聚 集 至 单 一 目 标。 如 果 目 标 为 友 善 则 保 护 目 标 %d 回 合。 如 目 标 为 敌 对 则 有 %d%% 几 率 使 用 灵 异 打 击 攻 击 目 标。 
		 如 果 你 的 阴 影 数 目 少 于 最 大 值 ， 将 在 聚 集 前 召 唤 出 来。
		 该 技 能 不 消 耗 任 何 能 量。]]):format(defenseDuration, blindsideChance)
	end,
}




return _M

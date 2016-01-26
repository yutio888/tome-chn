local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FRENZIED_BITE",
	name = "狂乱撕咬",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local heal_penalty = t.getHealingPenalty(self, t)
		return ([[撕 咬 目 标 造 成 %d%% 武 器 伤 害。 减 少 目 标 治 疗 效 果 %d%% 并 造 成 %d%% 武 器 伤 害 的 流 血 伤 害 持 续 5 回 合。 
		 只 有 在 狂 乱 状 态 下 可 以 使 用。]]):format(damage, heal_penalty, bleed)
	end,
}

registerTalentTranslation{
	id = "T_FRENZIED_LEAP",
	name = "狂乱跳跃",
	info = function(self, t)
		return ([[跳 向 范 围 内 目 标。 只 有 在 狂 乱 状 态 下 可 以 使 用。]])
	end,
}

registerTalentTranslation{
	id = "T_GNASHING_TEETH",
	name = "咬牙切齿",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local power = t.getPower(self, t) *100
		return ([[ 咬 伤 目 标 ， 造 成 %d%% 武 器 伤 害 ， 可 能 让 目 标 进 入 流 血 状 态 ， 在 五 回 合 内 造 成 %d%% 武 器 伤 害 。 
		 如 果 目 标 进 入 流 血 状 态 ， 吞 噬 者 会 进 入 狂 热 状 态 %d 回 合 （ 也 会 让 周 围 的 其 他 吞 噬 者 进 入 狂 热 状 态 ） 。
		 狂 热 状 态 会 增 加 整 体 速 度 %d%% , 物 理 暴 击 率 %d%% , 同 时 降 至 -%d%% 生 命 时 才 会 死 去 。]]):
		format(damage, bleed, t.getDuration(self, t), power, power, power)
	end,
}

registerTalentTranslation{
	id = "T_ABYSSAL_SHROUD",
	name = "堕入深渊",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local light_reduction = t.getLiteReduction(self, t)
		local darkness_resistance = t.getDarknessPower(self, t)
		return ([[制 造 一 个 3 码 范 围 的 黑 暗 深 渊 持 续 %d 回 合。 深 渊 会 造 成 每 回 合 %0.2f 黑 暗 伤 害 并 降 低 %d 光 照 范 围， 同 时 使 其 中 生 物 的 暗 影 抵 抗 减 少 %d%% 。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, (damage)), light_reduction, darkness_resistance)
	end,
}

registerTalentTranslation{
	id = "T_ECHOES_FROM_THE_VOID",
	name = "虚空回音",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 释 放 虚 空 的 混 乱， 使 目 标 每 回 合 强 制 进 行 精 神 豁 免 鉴 定， 持 续 6 回 合， 未 通 过 豁 免 则 在 原 伤 害 基 础 上 造 成 %0.2f 精 神 伤 害（ 由 精 神 和 自 然 伤 害 基 础 伤 害 决 定）。]]):
		format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

registerTalentTranslation{
	id = "T_VOID_SHARDS",
	name = "虚空碎片",
	info = function(self, t)
		local number = self:getTalentLevelRaw(t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[召 唤 %d 个 虚 空 碎 片。 碎 片 会 进 入 不 稳 定 状 态， 造 成 每 回 合 %0.2f 时 空 伤 害 持 续 5 回 合。 它 们 在 不 稳 定 状 态 下 死 亡 会 发 生 爆 炸 造 成 4 码 范 围 %0.2f 时 空 和 %0.2f 物 理 伤 害。]]):
		format(number, damDesc(self, DamageType.TEMPORAL, (damage)), damDesc(self, DamageType.TEMPORAL, (explosion/2)), damDesc(self, DamageType.PHYSICAL, (explosion/2)))
	end,
}

--registerTalentTranslation{
--	id = "T_WORM_ROT",
--	name = "腐烂蠕虫",
--	info = function(self, t)
--		local duration = t.getDuration(self, t)
--		local damage = t.getDamage(self, t)
--		local burst = t.getBurstDamage(self, t)
--		return ([[使 目 标 感 染 腐 肉 寄 生 幼 虫 持 续 %d 回 合。 每 回 合 会 移 除 目 标 一 个 物 理 增 益 效 果 并 造 成 %0.2f 酸 系 和 %0.2f 枯 萎 伤 害。 
--		 如 果 5 回 合 后 未 被 清 除 则 幼 虫 会 孵 化 造 成 %0.2f 酸 系 伤 害， 移 除 这 个 效 果 但 是 会 在 目 标 处 成 长 为 一 条 成 熟 的 腐 肉 虫。]]):
--		format(duration, damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.ACID, (burst)))
--	end,
--}

registerTalentTranslation{
	id = "T_KNIFE_STORM",
	name = "刀刃风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[ 召 唤 旋 转 剑 刃 风 暴 将 敌 人 切 成 碎 片 ， 对 进 入 风 暴 的 敌 人 造 成 %d 点 物 理 伤 害 并 令 其 流 血 %d 回 合 。 
		 受 精 神 强 度 影 响 ， 伤 害 和 流 血 持 续 时 间 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_PSIONIC_PULL",
	name = "念力牵引",
	info = function(self, t)
		return ([[将 5 码 范 围 内 的 目 标 拉 向 你 并 造 成 %d 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 120)))
	end,
}

registerTalentTranslation{
	id = "T_RAZOR_KNIFE",
	name = "刀锋之刃",
	info = function(self, t)
		return ([[对 一 条 直 线 目 标 发 射 一 把 锋 利 的 刀 刃 造 成 %0.2f 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 200)))
	end,
}

registerTalentTranslation{
	id = "T_SLIME_WAVE",
	name = "史莱姆冲击波",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 1 码 范 围 内 形 成 一 个 史 莱 姆 墙， 每 隔 2 回 合 范 围 会 扩 大， 直 至 %d 码， 造 成 %0.2f 史 莱 姆 伤 害 持 续 %d 回 合。 
		 受 精 神 强 度 影 响， 伤 害 及 持 续 时 间 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TENTACLE_GRAB",
	name = "触须之握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[抓 住 一 个 目 标 并 将 其 拉 至 身 边， 并 抓 取 %d 回 合。 
		 同 时 每 回 合 造 成 %0.2f 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(duration, damDesc(self, DamageType.SLIME, damage))
	end,
}

registerTalentTranslation{
	id = "T_OOZE_SPIT",
	name = "凝胶喷射",
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 液 造 成 %0.2f 自 然 伤 害 并 降 低 其 30%% 移 动 速 度 持 续 3 回 合。 
		 受 敏 捷 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "dex", 30, 290)))
	end,
}

registerTalentTranslation{
	id = "T_OOZE_ROOTS",
	name = "史莱姆迁移",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		return ([[变 成 史 莱 姆 遁 入 地 下， 并 在 %d 至 %d 范 围 内 重 新 出 现。]]):format(range, radius)
	end,
}

registerTalentTranslation{
	id = "T_ANIMATE_BLADE",
	name = "虚空利刃",
	info = function(self, t)
		return ([[划 破 空 间， 从 异 次 元 召 唤 出 一 把 虚 空 利 刃， 持 续 10 回 合。]])
	end,
}


registerTalentTranslation{
	id = "T_DRENCH",
	name = "浸湿",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 身 边 %d 范 围 内 制 造 水 流 ， 令 所 有 生 物 湿 润。
		效 果 受 法 术 强 度 加 成。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_SUCKERS",
	name = "吸血者",
	info = function(self, t)
		local Pdam, Fdam = self:damDesc(DamageType.PHYSICAL, self.level/2), self:damDesc(DamageType.ACID, self.level/2)
		return ([[抓 住 目 标 ，吸 取 他 们 的 血 液 ， 每 回 合 造 成 %0.2f 物 理 和 %0.2f 酸 性 伤 害 。
		5 回 合 后 脱 落 并 繁 殖。
		伤 害 随 等 级 上 升 。
		]]):format(Pdam, Fdam)
	end,
}

return _M

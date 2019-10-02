local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GHOUL",
	name = "食尸者",
	info = function(self, t)
		return ([[增 强 食 尸 鬼 的 身 体， 增 加 %d 点 力 量 和 体 质。
		你 的 身 体 对 伤 害 抗 性 极 高， 任 何 一 次 伤 害 不 会 让 你 失 去 超 过 %d%% 最 大 生 命。]])
		:format(t.statBonus(self, t), t.getMaxDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GHOULISH_LEAP",
	name = "定向跳跃",
	info = function(self, t)
		return ([[跳 向 你 的 目 标。
		落 地 后 你 的 整 体 速 度 增 加 %d%% ，持 续 4 回 合 。]]):format(t.getSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RETCH",
	name = "亡灵唾液",
	info = function(self, t)
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		return ([[向 你 周 围 的 空 地 上 呕 吐， 治 疗 任 何 在 这 空 地 上 的 不 死 族 并 伤 害 敌 方 单 位。 
		持 续 %d 回 合 并 造 成 %d 点 枯 萎 伤 害 或 治 疗 %d 点 生 命 值。
		呕 吐 范 围 内 的 生 物 有 %d%% 概 率 失 去 一 项 物 理 效 果 。不 死 族 解 除 负 面 效 果 ， 其 他 生 物 失 去 正 面 效 果。
		当 你 站 在 你 的 呕 吐 范 围 内 时 ，暂 时 取 消 种 族 特 性 中 的 -20%% 整 体 速 度 效 果。]]):format(t.getduration(self, t), damDesc(self, DamageType.BLIGHT, dam), dam * 1.5, t.getPurgeChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GNAW",
	name = "侵蚀",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local ghoul_duration = t.getGhoulDuration(self, t)
		local disease_damage = t.getDiseaseDamage(self, t)
		return ([[撕 咬 你 的 目 标 造 成 %d%% 伤 害。 
		如 果 你 的 攻 击 命 中， 目 标 会 感 染 食 尸 鬼 腐 烂 疫 病 持 续 %d 回 合。 
		食 尸 鬼 腐 烂 疫 病 每 回 合 造 成 %0.2f 枯 萎 伤 害。 
		目 标 被 杀 死 时 会 变 成 你 的可以完全控制的 食 尸 鬼 傀 儡。 
		食 尸 鬼 傀 儡 可 以 使 用 侵 蚀 、 定 向 跳 跃 、 震 慑 、 腐 烂 疫 病 。
		他 们 部 分 技 能 等 级 受 该 技 能 等 级 影 响。
		受 体 质 影 响， 枯 萎 伤 害 按 比 例 加 成。 ]]):
		format(100 * damage, duration, damDesc(self, DamageType.BLIGHT, disease_damage), ghoul_duration)
	end,
}


return _M

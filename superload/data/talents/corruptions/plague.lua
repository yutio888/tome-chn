local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VIRULENT_DISEASE",
	name = "剧毒瘟疫",
	info = function(self, t)
		return ([[每当你造成一个非疾病的枯萎伤害时，你将会对目标施加一项疾病，每回合造成%0.2f枯萎伤害，持续6回合，并降低其一项物理能力值（力量、体质、敏捷）%d。三种疾病可以叠加。
		剧毒瘟疫总是会使目标感染一项其所没有的疾病，并试图附加一项对目标有着最大负面效果的疾病。
		疾病会优先附加在目标周围感染疾病数量最多的单位身上。
		疾病效果随法术强度提升。]]):
		format(damDesc(self, DamageType.BLIGHT, 7 + self:combatTalentSpellDamage(t, 6, 45)), self:combatTalentSpellDamage(t, 5, 35))
	end,
}

registerTalentTranslation{
	id = "T_CYST_BURST",
	name = "瘟疫爆发",
	info = function(self, t)
		return ([[使 目 标 的 疾 病 爆 发， 每 种 疾 病 造 成 %0.2f 枯 萎 伤 害。 
		 同 时 会 向 %d 码 半 径 范 围 内 任 意 敌 人 散 播 衰 老、 虚 弱、 腐 烂 或 传 染 性 疾 病，疾病的持续时间最少为6回合。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		 format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 115)), self:getTalentRadius(t))
		end,
}

registerTalentTranslation{
	id = "T_CATALEPSY",
	name = "僵硬瘟疫",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[所 有 %d 码 球 形 范 围 内 感 染 疾 病 的 目 标 进 入 僵 硬 状 态， 震 慑 它 们 %d 回 合 并 立 即 爆 发 %d%% 剩 余 所 有 疾 病 伤 害。]]):
		format(radius, duration, damage * 100)
	end,
}

registerTalentTranslation{
	id = "T_EPIDEMIC",
	name = "传染病",
	info = function(self, t)
		return ([[使 目 标 感 染 1 种 传 染 性 极 强 的 疾 病， 每 回 合 造 成 %0.2f 伤 害， 持 续 6 回 合。 
		 如 果 目 标 受 到 非 疾 病 造 成 的 任 何 枯 萎 伤 害， 则 感 染 者 会 自 动 向 周 围 2 码 球 形 范 围 目 标 散 播 一 种 随 机 疾 病。
		 疾 病 传 播 概 率 受 造 成 的 枯 萎 伤 害 影 响， 且 当 枯 萎 伤 害 超 过 最 大 生 命 值 35%% 时 必 定 传 播 。
		 任 何 感 染 疾 病 单 位 同 时 会 减 少 %d%% 治 疗 效 果 和 %d%% 疾 病 免 疫。 
		 传 染 病 是 一 种 极 强 的 疾 病， 以 至 于 它 可 以 完 全 忽 略 目 标 的 疾 病 免 疫。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成； 受 枯 萎 伤 害 影 响， 传 染 疾 病 的 概 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 70)), 40 + self:getTalentLevel(t) * 4, 30 + self:getTalentLevel(t) * 6)
	end,
}



return _M

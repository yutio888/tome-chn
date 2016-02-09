local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GOLEM_KNOCKBACK",
	name = "击退",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 将 其 击 退 并 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 击 退 几 率 有 额 外 加 成。]]):format(100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_TAUNT",
	name = "嘲讽",
	info = function(self, t)
		return ([[你 的 傀 儡 嘲 讽 %d 码 半 径 范 围 的 敌 人， 强 制 他 们 攻 击 傀 儡。]]):format(self:getTalentRadius(t)) 
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_CRUSH",
	name = "压碎",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getPinDuration(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 将 其 推 倒 在 地 持 续 %d 回 合， 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 定 身 几 率 有 加 成。]]):
		format(duration, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_POUND",
	name = "敲击",
	info = function(self, t)
		local duration = t.getDazeDuration(self, t)
		local damage = t.getGolemDamage(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 践 踏 周 围 2 码 范 围， 眩 晕 所 有 目 标 %d 回 合 并 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 眩 晕 几 率 有 额 外 加 成。]]):
		format(duration, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_BEAM",
	name = "眼睛光束",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从 你 的 眼 睛 中 发 射 一 束 光 束， 造 成 %0.2f 火 焰 伤 害， %0.2f 冰 冷 伤 害 或 %0.2f 闪 电 伤 害。 
		 受 傀 儡 的 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.COLD, damage), damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_REFLECTIVE_SKIN",
	name = "反射皮肤",
	info = function(self, t)
		return ([[你 的 傀 儡 皮 肤 闪 烁 着 艾 尔 德 里 奇 能 量。 
		 所 有 对 其 造 成 的 伤 害 有 %d%% 被 反 射 给 攻 击 者。 
		 傀 儡 仍 然 受 到 全 部 伤 害。 
		 受 傀 儡 的 法 术 强 度 影 响， 伤 害 反 射 值 有 额 外 加 成。]]):
		format(t.getReflect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_ARCANE_PULL",
	name = "奥术牵引",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你 的 傀 儡 将 %d 码 范 围 内 的 敌 人 牵 引 至 身 边， 并 造 成 %0.2f 奥 术 伤 害。]]):
		format(rad, dam)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_MOLTEN_SKIN",
	name = "熔岩皮肤",
	info = function(self, t)
		return ([[使 傀 儡 的 皮 肤 变 成 灼 热 岩 浆， 发 出 的 热 量 可 以 将 3 码 范 围 内 的 敌 人 点 燃， 在 3 回 合 内 每 回 合 造 成 %0.2f 灼 烧 伤 害 持 续 %d 回 合。 
		 灼 烧 可 叠 加， 他 们 在 火 焰 之 中 持 续 时 间 越 长 受 到 伤 害 越 高。 
		 此 外 傀 儡 获 得 %d%% 火 焰 抵 抗。 
		 熔 岩 皮 肤 不 能 影 响 傀 儡 的 主 人。 
		 受 法 术 强 度 影 响， 伤 害 和 抵 抗 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 120)), 5 + self:getTalentLevel(t), 30 + self:combatTalentSpellDamage(t, 12, 60))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_DESTRUCT",
	name = "自爆",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[傀 儡 引 爆 自 己， 摧 毁 傀 儡 并 产 生 一 个 火 焰 爆 炸， %d 码 有 效 范 围 内 造 成 %0.2f 火 焰 伤 害。 
		 这 个 技 能 只 有 傀 儡 的 主 人 死 亡 时 能 够 使 用。]]):format(rad, damDesc(self, DamageType.FIRE, 50 + 10 * self.level))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_ARMOUR",
	name = "护甲掌握",
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local critreduce = t.getCriticalChanceReduction(self, t)
		local dir = self:getTalentLevelRaw(t) >= 3 and "In" or "De"
		return ([[傀 儡 学 会 重 新 组 装 重 甲 和 板 甲， 以 便 更 加 适 用 于 傀 儡。 
		 当 装 备 重 甲 或 板 甲 时， %s 增 加 护 甲 强 度 %d 点 , 护 甲 韧 性 %d%% ， 并 且 减 少 %d%% 暴 击 伤 害。]]):
		format(dir, armor, hardiness, critreduce)
	end,
}

registerTalentTranslation{
	id = "T_DROLEM_POISON_BREATH",
	name = "毒性吐息",
	info = function(self, t)
		return ([[ 对 你 的 敌 人 喷 吐 毒 雾 ， 在 几 个 回 合 内 造 成 %d 点 伤 害 。 受 魔 法 影 响 ， 伤 害 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "mag", 30, 460)))
	end,
}


return _M

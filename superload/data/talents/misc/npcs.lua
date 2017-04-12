local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MULTIPLY",
	name = "繁殖",
	info = function(self, t)
		return ([[复 制 你 自 身！]])
	end,
}

registerTalentTranslation{
	id = "T_CRAWL_POISON",
	name = "毒爪",
	info = function(self, t)
		return ([[爪 击 你 的 目 标 造 成 %d%% 毒 素 伤 害 并 使 目 标 中 毒。]]):
		format(100*t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CRAWL_ACID",
	name = "酸爪",
	info = function(self, t)
		return ([[爪 击 你 的 目 标 并 附 带 酸 性 效 果。]])
	end,
}

registerTalentTranslation{
	id = "T_SPORE_BLIND",
	name = "致盲孢子",
	info = function(self, t)
		return ([[向 目 标 喷 射 孢 子，使 目 标 致 盲 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPORE_POISON",
	name = "毒性喷射",
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 性 孢 子， 造 成 %d%% 伤 害 并 使 其 中 毒。]]):
		format(100 * t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STUN",
	name = "震慑",
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害。 如 果 攻 击 命 中 则 可 震 慑 目 标 %d 回 合。 
		 受 物 理 强 度 影 响， 震 慑 几 率 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DISARM",
	name = "缴械",
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 并 试 图 缴 械 目 标 %d 回 合。 
		 受 物 理 强 度 影 响， 缴 械 几 率 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CONSTRICT",
	name = "压迫",
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 则 可 令 目 标 进 入 压 迫 状 态 %d 回 合。 
		 受 物 理 强 度 影 响， 压 迫 强 度 有 额 外 加 成]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_KNOCKBACK",
	name = "击退",
	info = function(self, t)
		return ([[使 用 武 器 打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 则 可 击 退 目 标 至 多 4 格。 
		 受 物 理 强 度 影 响， 击 退 几 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 1.5, 2))
	end,
}

registerTalentTranslation{
	id = "T_BITE_POISON",
	name = "毒性撕咬",
	info = function(self, t)
		return ([[撕 咬 目 标， 造 成 %d%% 徒 手 伤 害 并 使 其 中 毒。]]):format(100 * t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUMMON",
	name = "召唤",
	info = function(self, t)
		return ([[召 唤 随 从。]])
	end,
}

registerTalentTranslation{
	id = "T_ROTTING_DISEASE",
	name = "腐烂疫病",
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %0.2f 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 体 质。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DECREPITUDE_DISEASE",
	name = "衰老疫病",
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %0.2f 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 敏 捷。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WEAKNESS_DISEASE",
	name = "衰弱疫病",
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %0.2f 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 力 量。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MIND_DISRUPTION",
	name = "精神崩溃",
	info = function(self, t)
		return ([[试 图 使 目 标 混 乱 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WATER_BOLT",
	name = "水弹",
	info = function(self, t)
		return ([[浓 缩 周 围 的 水 份 形 成 水 弹 攻 击 目 标 造 成 %0.1f 冰 冻 伤 害。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

name = "Flame Bolt"
registerTalentTranslation{
	id = "T_FLAME_BOLT",
	name = "火焰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释 放 火 焰 箭 ， 在 3 回 合 内 对 目 标 造 成 %0.2f 点 伤 害。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ICE_BOLT",
	name = "寒冰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释 放 寒 冰 箭 ， 对 目 标 造 成 %0.2f 点 冰 冻 伤 害。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_BLIGHT_BOLT",
	name = "枯萎箭",
	info = function(self, t)
		return ([[释 放 枯 萎 箭 ， 对 目 标 造 成 %0.2f 点 枯 萎 伤 害。
		该 法 术 的 暴 击 率 增 加 %0.2f%% 。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 1, 180)), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WATER_JET",
	name = "水之喷射",
	info = function(self, t)
		return ([[浓 缩 周 围 的 水 份 喷 射 目 标 造 成 %0.1f 冰 冻 伤 害 并 震 慑 目 标 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_VOID_BLAST",
	name = "虚空爆炸",
	info = function(self, t)
		return ([[施 放 虚 空 能 量 形 成 爆 炸 气 旋 向 目 标 缓 慢 移 动， 对 途 径 目 标 造 成 %0.2f 奥 术 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.ARCANE, self:combatTalentSpellDamage(t, 15, 240)))
	end,
}

registerTalentTranslation{
	id = "T_RESTORATION",
	name = "自然治愈",
	info = function(self, t)
		local curecount = t.getCureCount(self, t)
		return ([[召 唤 自 然 的 力 量 治 愈 你 的 身 体， 移 除 %d 个 毒 素 和 疫 病 不 良 效 果。]]):
		format(curecount)
	end,
}

registerTalentTranslation{
	id = "T_REGENERATION",
	name = "再生",
	info = function(self, t)
		local regen = t.getRegeneration(self, t)
		return ([[召 唤 自 然 的 力 量 治 愈 你 的 身 体， 每 回 合 回 复 %d 生 命 值 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(regen)
	end,
}

registerTalentTranslation{
	id = "T_GRAB",
	name = "抓取",
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 定 身 目 标 %d 回 合， 定 身 几 率 受 物 理 强 度 影 响。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.4), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_INK",
	name = "致盲墨汁",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[向 目 标 喷 射 黑 色 墨 汁， 致 盲 %d 锥 形 范 围 内 目 标 %d 回 合， 致 盲 几 率 受 物 理 强 度 影 响。]]):format(t.radius(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_SPIT_POISON",
	name = "毒性喷吐",
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 液 造 成 共 计 %0.2f 毒 素 伤 害， 持 续 6 回 合。 
		 受 力 量 或 敏 捷（ 取 较 高 值） 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_SPIT_BLIGHT",
	name = "枯萎喷吐",
	info = function(self, t)
		return ([[喷 吐 目 标 造 成 %0.2f 枯 萎 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):format(t.getDamage(self,t))
	end,
}

registerTalentTranslation{
	id = "T_RUSHING_CLAWS",
	name = "冲锋抓击",
	info = function(self, t)
		return ([[快 速 向 目 标 冲 锋， 并 使 用 爪 子 将 目 标 定 身 5 回 合。 
		 至 少 距 离 目 标 2 码 以 外 才 能 施 放。]])
	end,
}

registerTalentTranslation{
	id = "T_THROW_BONES",
	name = "投掷白骨",
	info = function(self, t)
		return ([[向 目 标 投 掷 白 骨 造 成 %0.2f 物 理 流 血 伤 害，最 远 距 离 %d。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_LAY_WEB",
	name = "撒网",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		return ([[投 掷 一 个 隐 形 的 蜘 蛛 网(侦 察 强 度 %d , 解 除 强 度 %d )，持 续 %d 回 合， 困 住 所 有 经 过 它 的 非 蜘 蛛 生 物 %d 回 合。]]):
		format(t.getDetect(self, t), t.getDisarm(self, t), dur*5, dur)
	end,
}

registerTalentTranslation{
	id = "T_DARKNESS",
	name = "黑暗",
	info = function(self, t)
		return ([[制 造 黑 暗， 阻 挡 所 有 光 线（ 强 度 %d 范 围 %d 码）， 并 能 使 你 传 送 一 小 段 距 离。 
		 受 敏 捷 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.darkPower(self, t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_THROW_BOULDER",
	name = "投掷巨石",
	info = function(self, t)
		return ([[向 目 标 投 掷 一 块 巨 大 的 石 头， 造 成 %0.2f 伤 害 并 将 其 击 退 %d 码,投 掷 半 径 %d。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_HOWL",
	name = "嚎叫",
	info = function(self, t)
		return ([[呼 唤 同 伴 回 援（ 范 围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_SHRIEK",
	name = "尖啸",
	info = function(self, t)
		return ([[呼 唤 同 伴（ 范 围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_CRUSH",
	name = "压碎",
	info = function(self, t)
		return ([[对 目 标 的 腿 部 进 行 重 击， 造 成 %d%% 武 器 伤 害， 如 果 攻 击 命 中， 则 目 标 无 法 移 动， 持 续 %d 回 合。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.4), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SILENCE",
	name = "沉默",
	info = function(self, t)
		return ([[施 放 念 力 攻 击 沉 默 目 标 %d 回 合，沉 默 几 率 受 精 神 强 度 加 成。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TELEKINETIC_BLAST",
	name = "念力爆炸",
	info = function(self, t)
		return ([[施 放 念 力 攻 击 击 退 目 标 至 多 3 格 并 造 成 %0.2f 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:damDesc(engine.DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_BLIGHTZONE",
	name = "枯萎区域",
	info = function(self, t)
		return ([[蒸 腾 目 标 区 域（ 4 码 范 围） 造 成 每 回 合 %0.2f 枯 萎 伤 害 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, engine.DamageType.BLIGHT, self:combatTalentSpellDamage(t, 5, 65)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INVOKE_TENTACLE",
	name = "召唤触须",
	info = function(self, t)
		return ([[召 唤 触 须 攻 击 目 标。触 须 死 亡 时 ， 你 受 到 触 须 2/3 生 命 值 的 伤 害。]])
	end,
}

registerTalentTranslation{
	id = "T_EXPLODE",
	name = "爆炸",
	info = function(self, t)
		return ([[使 目 标 爆 炸 并 放 出 耀 眼 光 芒 造 成 %d 伤 害。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_BOLT",
	name = "元素弹",
	info = function(self, t)
		return ([[发 射 一 枚 随 机 元 素 属 性 的 魔 法 飞 弹 缓 慢 飞 行 攻 击 目 标 造 成 %d 伤 害， 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VOLCANO",
	name = "火山爆发",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[召 唤 一 个 小 型 火 山 持 续 %d 回 合。 每 回 合 它 会 朝 你 的 目 标 喷 射 %d 熔 岩， 造 成 %0.2f 火 焰 伤 害 和 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDuration(self, t), t.nbProj(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,
}

registerTalentTranslation{
	id = "T_SPEED_SAP",
	name = "减速",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[降 低 目 标 30%% 速 度 并 在 3 回 合 内 造 成 %0.2f 时 空 伤 害。]]):format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DREDGE_FRENZY",
	name = "挖掘魔狂乱",
	info = function(self, t)
		local range = t.radius(self,t)
		local power = t.getPower(self,t) * 100
		return ([[使 %d 码 内 的 挖 掘 魔 陷 入 狂 乱 %d 回 合。
		狂 乱 会 使 其 全 体 速 度 上 升 %d%%, 物 理 暴 击 提 升 %d%%, 生 命 值 直 至 -%d%% 才 会 死 亡。]]):		
		format(range, t.getDuration(self, t), power, power, power)
	end,
}

registerTalentTranslation{
	id = "T_SEVER_LIFELINE",
	name = "生命离断",
	info = function(self, t)
		return ([[引 导 法 术 离 断 目 标 的 生 命 线， 如 果 4 回 合 之 后 目 标 仍 然 在 视 线 内 则 会 立 即 死 亡(%d 时 空 伤 害 )。]]):format(damDesc(self, "TEMPORAL", t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_CALL_OF_AMAKTHEL",
	name = "阿玛克塞尔的召唤",
	info = function(self, t)
		return ([[将 10 格 内 所 有 敌 人 往 身 边 拉 1 格。]])
	end,
}

registerTalentTranslation{
	id = "T_GIFT_OF_AMAKTHEL",
	name = "阿玛克塞尔的礼物",
	info = function(self, t)
		return ([[召 唤 一 只 黏 糊 糊 的 爬 虫 10 回 合。]])
	end,
}

registerTalentTranslation{
	id = "T_STRIKE",
	name = "怒火石拳",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 一 个 石 拳 造 成 %0.2f 物 理 伤 害 并 击 退 目 标 3 格。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_VAPOUR",
	name = "腐蚀酸雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码 半 径 范 围 内 升 起 一 片 腐 蚀 性 的 酸 雾， 造 成 %0.2f 毒 系 伤 害， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_MANAFLOW",
	name = "法力涌动",
	info = function(self, t)
		local restoration = t.getManaRestoration(self, t)
		return ([[将 自 己 包 围 在 法 力 的 河 水 中， 每 回 合 回 复 %d 点 法 力 值， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 法 力 回 复 有 额 外 加 成。]]):
		format(restoration)
	end,
}

registerTalentTranslation{
	id = "T_INFERNAL_BREATH",
	name = "炼狱吐息",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[对 %d 码 范 围 吐 出 黑 暗 之 火。 所 有 非 恶 魔 生 物 受 到 %0.2f 火 焰 伤 害， 并 在 接 下 来 继 续 造 成 每 回 合 %0.2f 的 持 续 火 焰 伤 害。 恶 魔 则 会 治 疗 同 等 数 值 的 生 命 值。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 350)), damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 70)))
	end,
}

registerTalentTranslation{
	id = "T_FROST_HANDS",
	name = "霜冻之手",
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[将 你 的 双 手 笼 罩 在 寒 冰 之 中 每 次 近 战 攻 击 造 成 %0.2f 冰 冷 伤 害， 并 提 高 %d%% 冰 冷 伤 害。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_METEOR_RAIN",
	name = "流星雨",
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[使 用 奥 术 力 量 召 唤 %d 个 陨 石， 冲 击 地 面 对 2 码 范 围 内 造 成 %0.2f 火 焰 和 %0.2f 物 理 伤 害。 
		 被 击 中 的 地 面 同 时 形 成 熔 岩 持 续 8 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

registerTalentTranslation{
	id = "T_HEAL_NATURE",
	name = "自然治愈",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 身 体 吸 收 自 然 能 量， 治 疗 %d 生 命 值。 
		 受 精 神 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_CALL_LIGHTNING",
	name = "召唤闪电",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 股 强 烈 的 闪 电 束 造 成 %0.2f 至 %0.2f 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_FADE",
	name = "消隐",
	info = function(self, t)
		return ([[你 淡 出 视 野， 使 你 隐 形 至 下 一 回 合。]])
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_PHASE_DOOR",
	name = "相位之门",
	info = function(self, t)
		return ([[在 小 范 围 内 传 送 你。]])
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_BLINDSIDE",
	name = "灵异打击",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 1.1, 1.9)
		return ([[你 以 难 以 分 辨 的 速 度 闪 现 到 %d 码 范 围 内 的 某 个 目 标 面 前， 造 成 %d%% 伤 害。]]):format(self:getTalentRange(t), multiplier)
	end,
}

registerTalentTranslation{
	id = "T_SUSPENDED",
	name = "停滞",
	info = function(self, t)
		return ([[除 非 受 到 伤 害， 否 则 目 标 无 法 行 动。]])
	end,
}

registerTalentTranslation{
	id = "T_FROST_GRAB",
	name = "冰霜飞爪",
	info = function(self, t)
		return ([[抓 住 目 标 并 使 其 传 送 至 你 身 边， 冰 冻 目 标 使 其 移 动 速 度 50%% 持 续 %d 回 合。
		冰 同 时 也 会 造 成 %0.2f 冰 冷 伤 害。
		伤 害 受 你 的 法 术 强 度 加 成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentSpellDamage(t, 5, 140)))
	end,
}

registerTalentTranslation{
	id = "T_BODY_SHOT",
	name = "崩拳",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local drain = self:getTalentLevel(t) * 2
		local daze = t.getDuration(self, t, 0)
		local dazemax = t.getDuration(self, t, 5)
		return ([[A对 目 标 的 身 体 发 出 强 烈 的 一 击， 造 成 %d%% 伤 害， 每 点 连 击 点 消 耗 %d 目 标 体 力 并 眩 晕 目 标 %d 到 %d 回 合（ 由 你 的 连 击 点 数 决 定）。 
		受 物 理 强 度 影 响， 眩 晕 概 率 有 额 外 加 成。 
		使 用 此 技 能 会 消 耗 当 前 所 有 连 击 点。]])
		:format(damage, drain, daze, dazemax)
	end,
}


registerTalentTranslation{
	id = "T_COMBO_STRING",
	name = "强化连击",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[当 获 得 1 个 连 击 点 时 有 %d%% 概 率 
		额 外 获 得 1 个 连 击 点。 
		此 外 你 的 连 击 点 持 续 时 间 会 延 长 %d 回 合。 
		受 灵 巧 影 响， 额 外 连 击 点 获 得 概 率 有 额 外 加 成。]]):
		format(chance, duration)
	end,
}

registerTalentTranslation{
	id = "T_STEADY_MIND",
	name = "冷静思维",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local saves = t.getMental(self, t)
		return ([[大 量 的 训 练 使 你 能 保 持 清 醒 的 头 脑， 增 加 %d 近 身 闪 避 和 %d 精 神 豁 免。 
		受 敏 捷 影 响， 闪 避 按 比 例 加 成； 
		受 灵 巧 影 响， 精 神 豁 免 按 比 例 加 成。]]):
		format(defense, saves)
	end,
}

registerTalentTranslation{
	id = "T_MAIM",
	name = "关节技：碎骨",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local maim = t.getMaim(self, t)
		return ([[抓 取 目 标 并 给 予 其 %0.2f 物 理 伤 害。 
		如 果 目 标 已 被 抓 取， 则 目 标 会 被 致 残， 减 少 %d 伤 害 和 30%% 整 体 速 度 持 续 %d 回 合。 
		抓 取 效 果 受 你 已 有 的 抓 取 技 能 影 响。 
		受 物 理 强 度 影 响， 伤 害 按 比 例 加 成。 ]])
		:format(damDesc(self, DamageType.PHYSICAL, (damage)), maim, duration)
	end,
}

registerTalentTranslation{
	id = "T_BLOODRAGE",
	name = "血怒",
	info = function(self, t)
		return ([[每 当 你 让 一 个 敌 人 扑 街， 你 会 漏 出 一 股 汹 涌 的 霸 气， 增 加 你 2 点 力 量， 上 限 %d ， 持 续 %d 回 合。]]):
		format(math.floor(self:getTalentLevel(t) * 6), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERPOWER",
	name = "压制",
	info = function(self, t)
		return ([[用 你 的 武 器 和 盾 牌 压 制 目 标 并 分 别 造 成 %d%% 武 器 和 %d%% 2 次 盾 牌 反 击 伤 害。
		如 果 上 述 攻 击 命 中， 那 么 目 标 会 被 击 退。
		受 命 中 影 响， 击 退 的 概 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
	end,
}

registerTalentTranslation{
	id = "T_PERFECT_CONTROL",
	name = "完美控制",
	info = function(self, t)
		local boost = t.getBoost(self, t)
		local dur = t.getDuration(self, t)
		return ([[用 灵 能 围 绕 你 的 身 体， 通 过 思 想 高 效 控 制 身 体， 允 许 你 不 使 用 肌 肉 和 神 经 操 纵 身 体。 
		 增 加 %d 点 命 中 和 %0.2f%% 暴 击 概 率， 持 续 %d 回 合。]]):
		format(boost, 0.5*boost, dur)
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_CHARGE",
	name = "毁灭冲锋",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDam(self, t))
		return ([[冲 锋 %d 码 。
		路 径 上 的 敌 人 会 被 击 退 并 受 到 %d 至 %d 点 物 理 伤 害。
		技 能 等 级 5 时 你 能 冲 过 墙 壁 。]]):
		format(range, 2*dam/3, dam)
	end,
}

		
registerTalentTranslation{
	id = "T_TELEKINETIC_THROW",
	name = "动能投掷",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[Use your telekinetic power to enhance your strength, allowing you to pick up an adjacent enemy and hurl it anywhere within radius %d. 
		Upon landing, your target takes %0.1f Physical damage and is stunned for 4 turns.  All other creatures within radius 2 of the landing point take %0.1f Physical damage and are knocked away from you.
		This talent ignores %d%% of the knockback resistance of the thrown target, which takes half damage if it resists being thrown.
		The damage improves with your Mindpower and the range increases with both Mindpower and Strength.]]):
		format(range, dam, dam/2, t.getKBResistPen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_REACH",
	name = "意念扩展",
	info = function(self, t)
		return ([[]])
	end,
}

registerTalentTranslation{
	id = "T_RELOAD",
	name = "装填弹药",
	info = function(self, t)
		return ([[立 刻 装 填 %d 弹 药 。之 后 缴 械 2 回 合。
		装 填 弹 药 不 会 打 破 潜 行。]])
		:format(self:reloadRate())
	end,
}
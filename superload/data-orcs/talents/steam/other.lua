local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLOBAL_MEDICAL_CD",
	name = "药物注射器",
	info = function(self, t)
		return ""
	end,}

registerTalentTranslation{
	id = "T_MEDICAL_URGENCY_VEST",
	name = "紧急药物处理",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[该 药 物 注 射 器 注 射 药 物 效 率 为 %d%% ，冷 却 时 间 修 正 为 %d%% 。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_LIFE_SUPPORT",
	name = "生命支持系统",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[生 命 支 持 系 统 允 许 使 用 药 物 效 率 为 %d%% ，冷 却 时 间 修 正 为 %d%% 。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_CREATE_TINKER",
	name = "制造附着物",
	info = function(self, t)
		return ([[允许你制造附着物。]])
	end,}

registerTalentTranslation{
	id = "T_TINKER_WEAPON_AUTOMATON_1H",
	name = "武装机器人：单手模式",
	info = function(self, t)
		return ([[部 署 一 个 装 备 单 手 武 器 的 武 装 机 器 人 。武 装 机 器 人 将 自 动 选 择 武 器 ,武 器 不 会 掉 落 。选 中 时 ,武 装 机 器 人 将 自 动 匹 配 技 能 等 级 ,你 的 状 态 和 其 他 数 据 都 会 被 描 述 。	  
		]]):format()
	end,}

registerTalentTranslation{
	id = "T_TINKER_HAND_CANNON",
	name = "手炮",
	info = function(self, t)
		return ([[向 在 %d  码 范 围 内 的 一 个 敌 人 开 火 造 成 %d%% 的 武 器 伤 害 。如 果 手 炮 是 由 沃 瑞 坦 钢 制 作 的 ，你 能 多 一 次 额 外 的 射 击 。射 击 是 远 程 攻 击 将 会 触 发 弹 药 特 效 。
]]):
		format(self:getTalentRange(t), t.getDamage(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_TINKER_FATAL_ATTRACTOR",
	name = "致命诱饵",
	info = function(self, t)
		return ([[快 速 创 建 一 个 灵 能 增 强 金 属 诱 饵 ，引 诱 敌 人 反 弹 %d%%  攻 击 者 的 伤 害 。
诱 饵 有 %d 生 命 值 ，持 续 5 回 合 。
伤 害 、生 命 值 、抗 性 和 护 甲 值 取 决 于 你 的 蒸 汽 强 度 。
]]):
		format(t.getReflection(self, t), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ROCKET_BOOTS",
	name = "火箭靴", 
	info = function(self, t)
		return ([[激 活 火 箭 靴 ，从 你 的 靴 子 上 发 射 巨 大 的 火 焰 ，增 加 你 的 移 动 速 度 %d%%。
每 次 移 动 都 会 留 下 一 道 火 焰 持 续 4 回 合 的 伤 害 为  %0.2f  的 火 焰 。
做 任 何 其 他 行 动 都 会 打 断 效 果 。
#{italic}#烧 毁 他 们 !#{normal}#]]):
		format(100 * (0.5 + self:getTalentLevel(t) / 2), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IRON_GRIP",
	name = "铁腕", 
	info = function(self, t)
		return ([[激 活 活 塞 碾 压 你 的 目 标 在 %d  回 合 内 造 成  %d%%  的 徒 手 伤 害 .
同 时 目 标 被 定 身 而 且 他 的 护 甲 和 闪 避 减 少  %d  。
#{italic}#压 碎 他 们 的 骨 头 !#{normal}#]]):
		format(t.getDur(self, t), self:combatTalentWeaponDamage(t, 1.2, 2.1) * 100, t.getReduc(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SPRING_GRAPPLE",
	name = "弹簧飞爪",
	info = function(self, t)
		return ([[抓 住 目 标 把 目 标 向 你 拉 拢 ，造 成 %d%%  的 徒 手 伤 害 ，如 果 命 中 ，目 标 定 身  %d  回 合 。
]]):
		format(self:combatTalentWeaponDamage(t, 0.8, 1.8) * 100, t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_CANNISTER_LAUNCHER",
	name = "毒罐发射装置", 
	info = function(self, t)
		return ([[发 射 一 个 充 满 有 毒 气 体 的 罐 子 。
每 2 回 合 在 此 周 围 发 出 一 个 半 径 为 3 码 的 毒 雾 。
毒 雾 在 5 回 合 内 造 成 %0.2f 的 自 然 伤 害 。
发 生 器 有 %d  点 生 命 值 持 续 8 回 合 。当 它 被 摧 毁 或 持 续 时 间 结 束 会 发 出 最 后 一 片 毒 雾 。
伤 害 ，生 命 值 ，抗 性 和 护 甲 值 取 决 于 你 的 蒸 汽 强 度 。
从 创 造 者 处 继 承 伤 害 和 穿 透 。]]):
		format(damDesc(self, DamageType.NATURE, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_POWERED_ARMOUR",
	name = "蒸汽动力装甲",
	info = function(self, t)
		return ([[激 活 盔 甲 的 主 动 防 御 系 统 。
　 　 你 的 盔 甲 被 电 流 的 覆 盖 。他 会 减 弱 的 对 你 的 物 理 攻 击 。
     除 了 精 神 伤 害 所 有 伤 害 直 接 减 少  %d  点 。
     盔 甲 有 时 会 漏 电 ，每 回 合 有  50%%  的 几 率 电 击 周 围 1 码 范 围 内 的 目 标 ，造 成  %0.2f  到  %0.2f  点 闪 电 伤 害 。
    效 果 随 蒸 汽 强 度 增 加 。]]):
		format(t.getRes(self, t), t.getDam(self, t) / 3, t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VIRAL_NEEDLEGUN",
	name = "病毒针枪",
	info = function(self, t)
		return ([[你 射 出 一 片 枯 萎 的 针 ，打 击  %d  码 锥 形 范 围 内 的 目 标 ，造 成 %0.2f  的 物 理 伤 害 。
每 个 命 中 目 标 都 有 %d%%  几 率 感 染 一 种 随 机 疾 病 ，造 成 %0.2f  枯 萎 伤 害 同 时 降 低 体 质 ，力 量 或 敏 捷 %d 点 持 续 20 回 合 。
		伤 害 和 疾 病 效 果 随 蒸 汽 强 度 增 加 ]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.damage(self, t)), t.diseaseChance(self, t), damDesc(self, DamageType.BLIGHT, t.diseaseDamage(self, t)), t.diseaseStat(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAND_SHREDDER",
	name = "砂土粉碎",
	info = function(self, t)
		return ([[你 分 解 砂 土 墙 。嘣 ~~~]])
	end,}

registerTalentTranslation{
	id = "T_FLAMETHROWER",
	name = "火焰喷射器",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[喷 出 一 片 锥 形 半 径 为  %d  的 火 焰 
　 　 伤 害 随 蒸 汽 强 度 增 加 。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_MASS_REPAIR",
	name = "大规模修复",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local radius = self:getTalentRadius(t)
		return ([[释 放 一 片 锥 形 半 径  %d  码 的 修 理 器 ,修 复 机 械 生 物 (蒸 汽 蜘 蛛 ) %d  生 命 值 。
　 　 治 疗 量 随 蒸 汽 强 度 增 加 。]]):
		format(radius, heal)
--		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ARCANE_DISRUPTION_WAVE",
	name = "奥术干扰波 ",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[制 造 一 场 奥 术 干 扰 波 ，沉 默  %d  码 范 围 内 受 影 响 的 目 标 %d 回 合 ，包 括 使 用 者 。
沉 默 几 率 随 蒸 汽 强 度 增 加 。]]):
		format(rad,t.getduration(self,t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_YEEK_WILL",
	name = "精神碾压",
	info = function(self, t)
		return ([[粉 碎 你 的 受 害 者 的 内 心 ,给 你 完 全 控 制 其 行 为 6 回 合 。
　 　 当 效 果 结 束 时 ,你 抽 出 了 自 己 的 思 维 ，受 害 者 的 身 体 会 崩 溃 , 死 亡。
　 　 稀 有 怪 、boss 、亡 灵 不 受 控 制 。
		]]):format()
	end,}

registerTalentTranslation{
	id = "T_TINKER_SHOCKING_TOUCH",
	name = "电击之触",
	info = function(self, t)
		return ([[接 触 生 物 释 放 电 流 ,造 成 %0.2f 闪 电 伤 害 。
如 果 这 个 插 件 材 质 大 于 1 级 ,电 弧 可 以 传 递 到 2 码 范 围 内 的 另 一 个 目 标 。
触 电 的 敌 人 数 目 不 会 大 于 插 件 材 质 等 级 。
伤 害 随 蒸 汽 强 度 增 加 。]]):format(damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLASH_POWDER",
	name = "闪光粉",
	info = function(self, t)
		return ([[扔 一 把 尘 土 ,迅 速 氧 化 ,释 放 出 眩 目 的 光 芒 。
　 　致 盲 锥 形 半 径 %d 码 内 的 生 物 %d  回 合 。
     致 盲 强 度 随 蒸 汽 强 度 增 加 。]]):format(self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ITCHING_POWDER",
	name = "痒痒粉",
	info = function(self, t)
		return ([[释 放 一 把 痒 痒 粉 。
　 　锥 形 半 径 %d 码 内 的 生 物 %d 回 合 内 很 痒 ,导 致 它 们 释 放 技 能 %d%% 几 率 失 败 。
     致 痒 强 度 随 蒸 汽 强 度 增 加 。]]):format(self:getTalentRadius(t), t.duration(self, t), t.failChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_THUNDER_GRENADE",
	name = "闪电榴弹",
	info = function(self, t)
		return ([[向 你 的 敌 人 投 掷 手 榴 弹 ,造 成  %0.2f  物 理 伤 害 ，半 径 %d  码 。
　 　 目 标 也 会 震 慑  %d  回 合 。
　 　 震 慑 强 度 随 蒸 汽 强 度 增 加 。]]):format(t.getDamage(self, t), self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_PROJECT_SAW",
	name = "发射链锯",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 激 活 隐 藏 的 弹 簧 来 弹 射 一 个 你 的 敌 人 。任 何 生 物 被 抓 后 造 成  %0.2f  物 理 伤 害 和 5 回 合 内 一 半 的 流 血 伤 害 。
伤 害 随 蒸 汽 强 度 增 加 。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_BOLT",
	name = "闪电球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释 放 一 个 闪 电 球 ，造 成  %0.2f  闪 电 伤 害 。
伤 害 随 蒸 汽 强 度 增 加 。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SENTRY",
	name = "伏特守卫",
	info = function(self, t)
		return ([[在 某 个 位 置 处 放 置 一 个 带 电 的 哨 兵 装 置 。
每 一 个 回 合 ，它 会 向 附 近 的 敌 人 发 射 一 个 闪 电 球 。
闪 电 球 造 成  %0.2f  闪 电 伤 害 。
哨 兵 有 %d  的 生 命 ，持 续 10 回 合 。]]):
		format(damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_EXPLOSIVE_SHELL",
	name = "爆炸弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 在 射 程 内 制 造 一 场 特 殊 的 爆 炸 。
　 　 当 每 一 个 弹 片 击 中 它 的 目 标 ,造 成 正 常 蒸 汽 枪 伤 害 和 半 径 %d 码 内 的 爆 炸 ，造 成 %0.2f 的 物 理 伤 害 ,
　 　 这 个 技 能 不 使 用 弹 药 。]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLARE_SHELL",
	name = "闪光弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 在 射 程 内 制 造 一 场 特 殊 的 爆 炸 。
　 　 当 每 一 个 弹 片 击 中 它 的 目 标 ,造 成 正 常 蒸 汽 枪 伤 害 和 半 径 %d 码 内 的 爆 炸 ，致 盲 %d  回 合 。
　 　 这 个 技 能 不 使 用 弹 药 。]])
		:format(self:getTalentRadius(t), t.duration(self, t))
	end,
	}

registerTalentTranslation{
	id = "T_TINKER_INCENDIARY_SHELL",
	name = "燃烧弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 在 射 程 内 制 造 一 场 特 殊 的 爆 炸 。
　 　 当 每 一 个 弹 片 击 中 它 的 目 标 ,造 成 正 常 蒸 汽 枪 伤 害 和 半 径 2 码 内 的 燃 烧 ，伤 害 %d 。
     这 燃 烧 不 持 久 ,马 上 燃 烧 半 径 为 1 码 ，造 成  %0.2f 火 焰 伤 害 。
　 　 这 个 技 能 不 使 用 弹 药 。]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SOLID_SHELL",
	name = "固实弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 固 体 打 击 目 标 造 成 %d%%  武 器 伤 害 。
　 　 击 退 目 标 %d 码 。
     这 个 技 能 不 使 用 弹 药 ]])
		:format(100*t.getMultiple(self, t), t.knockback(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IMPALER_SHELL",
	name = "穿刺弹", 
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 %d%%  武 器 伤 害 。
击 退 目 标 2 码 并 定 身  %d  回 合 。
     这 个 技 能 不 使 用 弹 药 ]])
		:format(100*t.getMultiple(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAW_SHELL",
	name = "链锯弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 %d%%  武 器 伤 害 。
链 锯 会 切 割 目 标 ，在 5 回 合 内 造 成 %d%%  武 器 伤 害 
这 个 技 能 不 使 用 弹 药 ]])
		:format(100*t.getMultiple(self, t), 50*t.getMultiple(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_HOOK_SHELL",
	name = "钩链弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 或 某 处 
如 果 你 的 目 标 是 一 个 生 物 ，他 们 被 拉 向 你 %d 码 
如 果 你 的 目 标 是 一 个 空 地 ，你 会 被 拉 向 空 地 %d 码 
这 个 技 能 不 使 用 弹 药 ]])
		:format(t.distance(self, t), t.distance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MAGNETIC_SHELL",
	name = "磁性弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 正 常 武 器 伤 害 。
目 标 将 磁 化  %d  回 合 。这 降 低 了 他 们 的 闪 避 和 疲 劳 %d  。
这 个 技 能 不 使 用 弹 药 
技 能 效 果 随 蒸 汽 强 度 增 加 。]])
		:format(t.duration(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SHELL",
	name = "伏特弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 100%% 闪 电 武 器 伤 害 。
这 将 释 放 强 大 的 电 流 ，打 击 周 围 %d 的 敌 人 。
每 个 闪 电 球 造 成 %0.2f 的 闪 电 伤 害 
这 个 技 能 不 使 用 弹 药 
闪 电 球 伤 害 随 蒸 汽 强 度 增 加 。]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ANTIMAGIC_SHELL",
	name = "反魔弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 100%% 武 器 伤 害 。
造 成 %0.2f 奥 术 燃 烧 。
这 个 技 能 不 使 用 弹 药 。
奥 术 燃 烧 伤 害 取 决 于 蒸 汽 强 度 。]])
		:format(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_BOTANICAL_SHELL",
	name = "植物弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 100%% 自 然 武 器 伤 害 。
将 释 放 孢 子 生 长 成 半 径 %d 的 苔 藓 %d 回 合 。
每 回 合 苔 藓 造 成  %0.2f  自 然 伤 害 对 半 径 内 的 每 一 个 敌 人 。
这 种 苔 藓 有 吸 血 特 性 ，  伤 害 的 %d%%  治 愈 使 用 者 。  
这 个 技 能 不 使 用 弹 药 
苔 藓 伤 害 随 蒸 汽 强 度 增 加 。]])
		:format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_CORROSIVE_SHELL",
	name = "腐蚀弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 %d%% 酸 性 武 器 伤 害 。
释 放 的 酸 也 会 腐 蚀 的 目 标 ，降 低 其 命 中 ，闪 避 和 护 甲 %d  。
这 个 技 能 不 使 用 弹 药 。
腐 蚀 强 度 随 蒸 汽 强 度 增 加 。]])
		:format(100*t.getMultiple(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_SHELL",
	name = "毒气弹",
	info = function(self, t)
		return ([[你 使 用 蒸 汽 枪 发 射 特 殊 弹 药 打 击 目 标 造 成 100%% 枯 萎 武 器 伤 害 。
向 目 标 释 放 重 金 属 ，造 成 每 回 合  %0.2f  枯 萎 伤 害 ，并 且 降 低 整 体 速 度 %d%%  %d  回 合 .
这 个 技 能 不 使 用 弹 药 。
枯 萎 伤 害 随 蒸 汽 强 度 增 加 。]])
		:format(damDesc(self, DamageType.BLIGHT, t.getPower(self, t)), t.getPower(self, t)-10, t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MOSS_TREAD",
	name = "苔藓之踏",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[在 %d 回 合 内 ，你 在 行 走 或 站 立 时 放 置 苔 藓 
     每 回 合 自 动 放 置 苔 藓 ，持 续 %d 回 合 。
　 　 每 个 苔 藓 对 站 在 它 上 面 的 每 一 个 敌 人 造 成 %0.2f 自 然 伤 害 。
　 　 这 个 苔 藓 很 厚 ,导 致 粘 住 所 有 踩 过 它 的 敌 人 。
　 　 降 低 移 动 速 度 %d%%  并 且 有 %d%% 机 会 被 定 身 4 回 合 。
     伤 害 随 蒸 汽 强 度 增 加 。]]):
		format(dur*2, dur, damDesc(self, DamageType.NATURE, dam), t.getSlow(self, t), t.getPin(self, t))
	end,}

return _M
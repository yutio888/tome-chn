local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HIGHER_HEAL",
	name = "高贵血统",
	info = function(self, t)
		return ([[召 唤 高 贵 血 统 来 使 你 的 身 体 以 %d 点 每 回 合 的 速 率 恢 复，治 疗 系 数 增 加 %d%% ， 持 续 10 回 合。 
		 受 意 志 影 响， 生 命 恢 复 量 有 额 外 增 益。]]):format(5 + self:getWil() * 0.5, t.getHealMod(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERSEER_OF_NATIONS",
	name = "远见卓识",
	info = function(self, t)
		return ([[虽 然 高 贵 血 统 并 不 意 味 着 统 治 他 人（ 当 然 也 没 有 特 别 的 意 愿 去 那 样 做）， 但 是 他 们 经 常 承 担 更 高 的 义 务。 
		 他 们 的 本 能 使 得 他 们 比 别 人 有 更 强 的 直 觉。 
		 增 加 %d%% 目 盲 免 疫 , 提 高 %d 点 最 大 视 野 范 围 并 提 高 %d 光 照、 夜 视 及 感 应 范 围。
		 技 能 等 级 5 时，每 次 你 命 中 目 标 ， 你 将 获 得 15 格 范 围 内 同 类 型 生 物 感 知 能 力 ， 持 续 5 回 合 。]]):
		format(t.getImmune(self, t) * 100, t.getSight(self, t), t.getESight(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BORN_INTO_MAGIC",
	name = "魔法亲和",
	info = function(self, t)
		local netpower = t.power(self, t)
		return ([[高 等 人 类 们 最 初 是 在 厄 流 纪 前 由 红 衣 主 神 们 创 造 的。 他 们 天 生 具 有 魔 法 天 赋。 
		 提 高 +%d 点 法 术 豁 免 和 %d%% 奥 术 抵 抗。
		 每 次 释 放 伤 害 法 术 时 ， 5 回 合 内 该 伤 害 类 型 获 得 20%% 伤 害 加 成 。 （ 该 效 果 有 冷 却 时 间。）]]):
		format(t.getSave(self, t), netpower)
	end,
}

registerTalentTranslation{
	id = "T_HIGHBORN_S_BLOOM",
	name = "生命绽放",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[激 活 你 的 内 在 潜 力， 以 提 高 你 的 能 力。 
		 在 接 下 来 %d 回 合 中 可 无 消 耗 使 用 技 能。 
		 你 的 能 量 值 仍 需 要 满 足 使 用 这 些 技 能 的 最 低 能 量 需 求， 且 技 能 仍 有 几 率 会 失 败。]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_SHALOREN_SPEED",
	name = "不朽的恩赐",
	info = function(self, t)
		return ([[召 唤 不 朽 的 恩 赐 之 力 来 增 加 你 %d%% 的 基 础 速 度， 持 续 5 回 合。 
		 受 敏 捷 和 魔 法 中 较 高 一 项 影 响 ， 速 度 会 有 额 外 的 提 升。]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_MAGIC_OF_THE_ETERNALS",
	name = "不朽的魔法",
	info = function(self, t)
		return ([[因 为 永 恒 精 灵 的 自 然 魔 法， 现 实 发 生 了 轻 微 的 扭 曲。 
		 提 高 %d%% 的 暴 击 概 率 和 %d%% 暴 击 伤 害。]]):
		format(t.critChance(self, t), t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SECRETS_OF_THE_ETERNALS",
	name = "不朽的秘密",
	info = function(self, t)
		return ([[作 为 埃 亚 尔 仅 存 的 古 老 种 族， 永 恒 精 灵 在 漫 长 的 岁 月 里 学 习 到 如 何 用 他 们 与 生 俱 来 的 精 神 魔 法 保 护 自 己。 
		%d%% 的 概 率 使 自 身 进 入 隐 形 状 态（ %d 点 隐 形 等 级）， 当 承 受 至 少 10%% 总 生 命 值 的 伤 害 时 触 发， 持 续 5 回 合。]]):
		format(t.getChance(self, t), t.getInvis(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TIMELESS",
	name = "超越永恒",
	info = function(self, t)
		return ([[世 界 在 不 断 的 变 老， 而 你 似 乎 永 恒 不 变。 对 于 你 来 说， 时 间 是 不 同 寻 常 的。 
		 减 少 %d 回 合 负 面 状 态 的 持 续 时 间 ， 减 少 技 能 %d 回 合 冷 却 时 间 直 至 冷 却 并 增 加 %d 回 合 增 益 状 态 的 持 续 时 间（ 至 多 延 长 为 剩 余 时 间 的 两 倍）。]]):
		format(t.getEffectBad(self, t), t.getEffectGood(self, t), t.getEffectGood(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THALOREN_WRATH",
	name = "森林之怒",
	info = function(self, t)
		return ([[召 唤 远 古 森 林 之 力， 提 高 %d%% 所 有 伤 害 并 减 少 %d%% 所 承 受 伤 害 5 回 合。 
		 受 意 志 影 响 , 此 效 果 有 额 外 加 成。]]):
		format(t.getPower(self, t), t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSHACKLED",
	name = "潜能爆发",
	info = function(self, t)
		return ([[自 然 精 灵 一 度 自 由 的 生 活 在 他 们 热 爱 的 森 林， 从 不 关 心 外 界 的 事 物。 
		 提 高 物 理 和 精 神 豁 免 +%d 点。]]):
		format(t.getSave(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GUARDIAN_OF_THE_WOOD",
	name = "森林守护",
	info = function(self, t)
		return ([[你 是 森 林 的 一 部 分， 它 保 护 你 免 受 侵 蚀。 
		 提 高 %d%% 疾 病 抵 抗、 %0.1f%% 枯 萎 抵 抗 和 %0.1f%% 所 有 抵 抗。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getBResist(self, t), t.getAllResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_PRIDE",
	name = "自然的骄傲",
	info = function(self, t)
		return ([[自 然 与 你 同 在， 你 可 以 时 刻 感 受 到 森 林 的 召 唤。 
		 召 唤 2 个 精 英 树 人， 持 续 8 回 合。 
		 树 人 的 所 有 抵 抗 取 决 于 你 的 枯 萎 抵 抗， 并 且 可 以 震 慑、 击 退 和 嘲 讽 敌 人。 
		 受 意 志 影 响， 它 们 的 力 量 会 有 额 外 加 成。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_DWARF_RESILIENCE",
	name = "钢筋铁骨",
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召 唤 矮 人 一 族 的 传 奇 血 统 来 增 加 你 +%d 点 护 甲 值， +%d%% 护 甲 硬 度， +%d 点 法 术 豁 免 和 +%d 物 理 豁 免， 持 续 8 回 合。 
		 受 你 的 体 质 影 响， 此 效 果 有 额 外 加 成。]]):
		format(params.armor, params.armor_hardiness, params.physical, params.spell)
	end,
}

registerTalentTranslation{
	id = "T_STONESKIN",
	name = "石化皮肤",
	info = function(self, t)
		return ([[矮 人 皮 肤 是 一 种 复 杂 的 结 构， 它 可 以 在 受 到 打 击 后 自 动 硬 化。 
		当 被 击 打 时 有 15%% 的 概 率 增 加 %d 点 护 甲 值， 持 续 5 回 合， 同 时 无 视 触 发 该 效 果 的 攻 击。
		该 效 果 无 冷 却 时 间 ， 可 重 复 触 发 。]]):
		format(t.armor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POWER_IS_MONEY",
	name = "金钱就是力量",
	info = function(self, t)
		return ([[金 钱 是 矮 人 王 国 的 心 脏， 它 控 制 了 所 有 其 他 决 策。 
		 基 于 你 的 金 币 持 有 量， 增 加 物 理、 精 神 和 法 术 抵 抗。 
		+1 豁 免 值 每 %d 单 位 金 币， 最 大 +%d (当 前 +%d)。]]):
		format(t.getGold(self, t), t.getMaxSaves(self, t), t.getSaves(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STONE_WALKING",
	name = "穿墙术",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[虽 然 矮 人 的 起 源 对 其 他 种 族 来 说 始 终 是 不 解 之 谜， 但 是 很 显 然 他 们 的 起 源 与 石 头 密 不 可 分。 
		 你 可 以 指 定 任 何 一 堵 墙 并 立 刻 穿 过 它， 出 现 在 另 一 侧。 
		 移 动 距 离 最 大 %d 码（ 受 体 质 和 分 类 天 赋 等 级 影 响 有 额 外 加 成）]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_HALFLING_LUCK",
	name = "小不点的幸运",
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召 唤 小 不 点 的 幸 运 和 机 智 来 提 高 你 %d%%  暴 击 率 和 %d  豁 免 5 回 合。 
		 受 灵 巧 影 响， 此 效 果 有 额 外 增 益。]]):
		format(params.crit, params.save)
	end,
}

registerTalentTranslation{
	id = "T_DUCK_AND_DODGE",
	name = "闪避",
	info = function(self, t)
		local threshold = t.getThreshold(self, t)
		local evasion = t.getEvasionChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 强 大 的 人 品 在 关 键 时 刻 总 能 保 你 一 命。 
		每 当 一 次 攻 击 对 你 造 成 %d%% 生 命 值 或 更 多 伤 害 时，你 可 以 获 得 额 外 %d%% 闪 避 率 和 %d 点 闪 避（ 基 于 幸 运 和 其 他 闪 避 相 关 数 值 ）， 持 续 %d 回 合 。]]):
		format(threshold * 100, evasion, t.getDefense(self), duration)
	end,
}

registerTalentTranslation{
	id = "T_MILITANT_MIND",
	name = "英勇",
	info = function(self, t)
		return ([[半 身 人 曾 是 一 个 有 组 织 纪 律 的 种 族， 敌 人 越 多 他 们 越 团 结。 
		 如 果 有 2 个 或 多 个 敌 人 在 你 的 视 野 里， 每 个 敌 人 都 会 使 你 的 所 有 强 度 和 豁 免 提 高 %0.1f 。（ 最 多 5 个 敌 人）]]):
		format(self:getTalentLevel(t) * 1.5)
	end,
}

registerTalentTranslation{
	id = "T_INDOMITABLE",
	name = "不屈意志",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[半 身 人 以 骁 勇 善 战 闻 名 于 世， 他 们 曾 经 在 战 场 上 对 抗 其 他 种 族 上 千 年。 
		 立 刻 移 除 2 种 震 慑、 眩 晕 和 定 身 状 态， 并 使 你 对 震 慑、 眩 晕 和 定 身 免 疫 %d 回 合。 
		 使 用 此 技 能 不 消 耗 回 合。]]):format(duration, count)
	end,
}

registerTalentTranslation{
	id = "T_ORC_FURY",
	name = "兽族之怒",
	info = function(self, t)
		return ([[激 活 你 对 杀 戮 和 破 坏 的 渴 望 ， 尤 其 是 当 你 孤 军 奋 战 之 时 。
		 你 增 加 所 有 伤 害 10 %% + %0.1f%% × 你 视 野 内 敌 人 的 数 量 （ 最 大 5 层 ， %0.1f%% ） ， 持 续 3 回 合 。
		 受 体 质 影 响， 增 益 有 额 外 加 成。]]):
		format(t.getPower(self, t), 10 + t.getPower(self, t) * 5)
	end,
}

registerTalentTranslation{
	id = "T_HOLD_THE_GROUND",
	name = "兽族忍耐",
	info = function(self, t)
		return ([[其 他 种 族 对 兽 族 的 猎 杀 持 续 了 上 千 年， 不 管 是 否 正 义。 他 们 已 经 学 会 忍 受 那 些 会 摧 毁 弱 小 种 族 的 灾 难。 
		当 你 的 生 命 值 降 低 到 50%% 以 下 ， 你 强 大 的 意 志 移 除 你 身 上 最 多 %d 个 精 神 状 态 （ 基 于 技 能 等 级 和 意 志 ） 。 该 效 果 每 12 回 合 最 多 触 发 一 次 。
		额 外 增 加 %d 物 理 和 精 神 豁 免。]]):
		format(t.getDebuff(self, t), t.getSaves(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER",
	name = "杀戮者",
	info = function(self, t)
		return ([[兽 人 们 经 历 了 许 多 次 战 争， 并 获 胜 了 许 多 次。 
		你 陶 醉 于 杀 戮 你 的 敌 人 ， 每 次 杀 死 敌 人 你 将 获 得 %d%% 的 伤 害 抗 性 ， 持 续 2 回 合 。
		增 加 的 抗 性 基 于 你 的 技 能 等 级 和 意 志 。
		被 动 增 加 %d%% 所 有 伤 害 穿 透。]]):
		format(t.getResist(self, t), t.getPen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PRIDE_OF_THE_ORCS",
	name = "兽族荣耀",
	info = function(self, t)
		return ([[呼 唤 兽 族 荣 耀 来 和 敌 人 拼 搏 。 
		 移 除 %d 个 负 面 状 态 并 治 疗 %d 生 命 值 。
		 受 意 志 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(t.remcount(self,t), t.heal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_YEEK_WILL",
	name = "主导意志",
	info = function(self, t)
		return ([[粉 碎 目 标 的 意 志， 使 你 可 以 完 全 控 制 它 的 行 动 %s 回 合。 
		 当 技 能 结 束 时， 你 的 意 志 会 脱 离 而 目 标 会 因 大 脑 崩 溃 而 死 亡。 
		 此 技 能 无 法 用 于 稀 有 怪, bosses 或 不 死 族。 
		 受 你 的 意 志 影 响， 持 续 时 间 有 额 外 加 成。]]):format(t.getduration(self))
	end,
}

registerTalentTranslation{
	id = "T_UNITY",
	name = "强化思维",
	info = function(self, t)
		return ([[你 的 思 维 和 精 神 网 络 变 的 更 加 协 调 并 且 增 强 对 负 面 效 果 的 抵 抗。 
		 增 加 %d%% 混 乱 和 沉 默 抵 抗 并 增 加 你 +%d 点 精 神 豁 免。]]):
		format(100*t.getImmune(self, t), t.getSave(self, t))
	end,
}

registerTalentTranslation{
	id = "T_QUICKENED",
	name = "迅捷",
	info = function(self, t)
		return ([[基 于 “ 精 神 网 络 ”， 夺 心 魔 新 陈 代 谢 很 快， 思 维 很 快 并 且 献 祭 也 很 快。 
		 增 加 %0.1f%% 整 体 速 度。]]):format(100*t.speedup(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WAYIST",
	name = "快速支援",
	info = function(self, t)
		return ([[通 过 夺 心 魔 的 精 神 网 络， 迅 速 召 集 帮 手。 
		 在 你 周 围 召 唤 3 个 夺 心 魔 精 英 ，持 续 6 回 合。]])
	end,
}

registerTalentTranslation{
	id = "T_YEEK_ID",
	name = "维网的力量",
	info = function(self, t)
		return ([[你 将 精 神 与 维 网 链 接 ， 能 暂 时 获 得 你 们 一 族 所 有 的 知 识 ， 让 你 能 鉴 定 所 有 物 品。]])
	end,
}

registerTalentTranslation{
	id = "T_OGRE_WRATH",
	name = "食人魔之怒",
	info = function(self, t)
		return ([[你 进 入 愤 怒 状 态 %d 回 合 ，获 得 20%% 震 慑 和 定 身 免 疫 ，全 体 伤 害 增 加 10%% 。
		 同 时 ，每 当 你 使 用 符 文 或 纹 身 、攻 击 未 命 中 或 伤 害 被 护 盾 等 效 果 削 减 时 ，你 获 得 一 层 食 人 魔 之 怒 效 果 ，持 续 7 回 合 ，效 果 可 叠 加 至 最 多 5 层 。
		 每 层 提 供 20%% 暴 击 伤 害 和 5%% 暴 击 率 。
		 每 次 暴 击 时 减 少 一 层 食 人 魔 之 怒 效 果 。
		 持 续 时 间 受 力 量 加 成 。]]):format(t.getduration(self))
	end,
}

	
registerTalentTranslation{
	id = "T_GRISLY_CONSTITUTION",
	name = "强大体魄",
	info = function(self, t)
		return ([[食 人 魔 的 身 体 对 法 术 和 符 文 亲 和 力 很 强 。
		 增 加 %d 法 术 豁 免 ，增 加 纹 身 和 符 文 的 属 性 加 成 效 果 %d%% 。
		 技 能 等 级 5 时 ，你 的 身 体 变 得 如 此 强 壮 ，能 在 主 手 持 有 双 手 武 器 的 同 时 ，副 手 持 有 其 他 副 手 武 器 。
		 这 样 做 的 话 ，你 的 命中、物 理、 法 术、 精 神 强 度 会 下 降 20%% ，体 型 超 过 'Big'时 ，每 增 加 一 体 型 ，惩 罚 减 少 5%% 。同 时 你 的 武 器 附 加 伤 害 减 少 50%% 。]]):
		format(t.getSave(self, t), t.getMult(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SCAR_SCRIPTED_FLESH",
	name = "血肉伤痕",
	info = function(self, t)
		return ([[每 次 暴 击 时 有 %d%% 几 率 减 少 随 机 一 个 纹 身 或 符 文 1 回 合 冷 却 时 间 ，或 减 少 符 文 紊 乱 或 纹 身 紊 乱 1 回 合 持 续 时 间 。
		 该 效 果 每 回 合 最 多 触 发 一 次 。]]):
		format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WRIT_LARGE",
	name = "符文亲和",
	info = function(self, t)
		return ([[立 刻 解 除 纹 身 紊 乱 和 符 文 紊 乱 。
		 接 下 来 %d 回 合 内 ，你 的 纹 身 和 符 文 冷 却 速 度 加 倍 。
		 技 能 等 级 5 时 ，你 能 解 锁 一 个 新 的 纹 身 位  。]]):
		format(t.getDuration(self, t))
	end,
}


return _M

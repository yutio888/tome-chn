local _M = loadPrevious(...)

registerInscriptionTranslation = function(t)
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.id = "T_"..t.name:upper():gsub("[ ]", "_").."_"..i
		tt.name = tt.display_name or tt.name
		tt.extra_data = {["old_info"] = tt.info}
		tt.info = function(self, t)
			local ret = t.extra_data.old_info(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\n受 你 的 %s 影 响， 此 效 果 按 比 例 加 成。 "):format(s_stat_name[self.stats_def[data.use_stat].name] or self.stats_def[data.use_stat].name)
			end
			return ret
		end
		registerTalentTranslation(tt)
	end
end
function change_infusion_eff(str)
	str = str:gsub("mental"," 精 神 "):gsub("magical"," 魔 法 "):gsub("physical"," 物 理 ")
	return str
end

-----------------------------------------------------------------------
-- Infusions
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Infusion: Regeneration",
	display_name = "纹身：回复",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 治 疗 你 自 己 %d 生 命 值， 持 续 %d 回 合。 ]]):format(data.heal + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治疗 %d; 冷却 %d]]):format(data.heal + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Healing",
	display_name = "纹身：治疗",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 立 即 治 疗 你 %d 生 命 值，然后 去 除 一 个 流 血 或 毒 素 效 果 。]]):format(data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治疗 %d; 冷却 %d]]):format(data.heal + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Wild",
	display_name = "纹身：狂暴",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concatNice(table.keys(data.what), ", ", " 或者 ")
		return ([[激 活 纹 身 解 除 你 %s 效 果 并 减 少 所 有 伤 害 %d%% 持 续 %d 回 合。 
同 时 除 去 对 应 类 型 的 CT 效 果 。		]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[减伤 %d%%; 解除 %s; 持续 %d; 冷却 %d]]):format(data.power + data.inc_stat, what:gsub("physical"," 物理 "):gsub("magical"," 魔法 "):gsub("mental"," 精神 ").." 效果 ", data.dur, data.cooldown)
	end,
}

-- fixedart wild variant
registerInscriptionTranslation{
	name = "Infusion: Primal",
	display_name = "纹身：原初",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 ，你 受 到 的 伤 害 将 部 分 转 化 为 治 疗 （在 伤 害 减 免 之 前 计 算 ）， 转 化 比 例 为 %d%% 。 此 外 ， 每 回 合 减 少 一 个 随 机 负 面 效 果 的 持 续 时 间 %d 回 合 ，持 续 %d 回 合 ]]):
			format(data.power+data.inc_stat*10, (data.reduce or 0) + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[伤 害 吸 收 %d%%; 减 少 %d; 持 续 %d; 冷 却 %d]]):format(data.power + data.inc_stat*10, (data.reduce or 0) + data.inc_stat, data.dur, data.cooldown )
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Movement",
	display_name = "纹身：移动",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 可 以 在 1 个 游 戏 回 合 内 提 升 移 动 速 度 %d%% 。
		同 时 免 疫 眩 晕、 震 慑 和 定 身 效 果。
		除 移 动 以 外 其 他 动 作 会 取 消 这 个 效 果。 
		 注 意： 由 于 你 的 速 度 非 常 快， 游 戏 回 合 会 相 对 很 慢。 ]]):format(data.speed + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d%% 加 速 ; %d 冷 却 ]]):format(data.speed + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Heroism",
	display_name = "纹身：英勇",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local bonus = 1 + (1 - self.life / self.max_life)
		local bonus1 = data.die_at + data.inc_stat * 30 * bonus
		local bonus2 = math.floor(data.dur * bonus)
		return ([[激 活 这 个 纹 身 可 以让你忍受致死的伤害，持续%d回合。
		当 应用 纹 身 激 活 时， 你 的 生 命 值 只 有 在 降 低 到 -%d 生 命 时 才 会 死 亡。
		你 每 失 去 1%% 生 命 值 ， 持 续 时 间 和 生 命 值 下 限 就 会 增 加 1%% 。（目 前 %d 生 命 值， %d 持 续 时 间）
		效 果 结 束 时， 如 果 你 的 生 命 值 在 0 以 下 ， 会 变 为 1 点。 ]]):format(data.dur, data.die_at + data.inc_stat * 30, bonus1, bonus2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[-%d 死 亡 底 线; 持 续 %d; 冷 却 %d]]):format(data.die_at + data.inc_stat * 30, data.dur, data.cooldown)
	end,
}

-- Opportunity cost for this is HUGE, it should not hit friendly, also buffed duration
registerInscriptionTranslation{
	name = "Infusion: Wild Growth",
	display_name = "纹身：野性生长",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local damage = t.getDamage(self, t)
		return ([[从 土 地 中 召 唤 坚 硬 的 藤 蔓， 缠 绕 %d 码 范 围 内 所 有 生 物， 持 续 %d 回 合。 将 其 定 身 并 造 成 每 回 合 %0.2f 物 理 和 %0.2f 自 然 伤 害。 
		 藤 蔓 也 会 生 长 在 你 的 身 边 ， 增 加 %d 护 甲 和 %d%% 护 甲 硬 度 。]]):
		format(self:getTalentRadius(t), data.dur, damDesc(self, DamageType.PHYSICAL, damage)/3, damDesc(self, DamageType.NATURE, 2*damage)/3, data.armor or 50, data.hard or 30)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范围 %d 持续 %d]]):format(self:getTalentRadius(t), data.dur)
	end,
}

-----------------------------------------------------------------------
-- Runes
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Rune: Teleportation",
	display_name = "符文：传送",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 随 机 传 送 %d 码 范 围 内 位 置， 至 少 传 送 15 码 以 外。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d; 冷却 %d]]):format(data.range + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Shielding",
	display_name = "符文：护盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 产 生 一 个 防 护 护 盾， 吸 收 最 多 %d 伤 害 持 续 %d 回 合。 ]]):format((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸 收 %d; 持 续 %d; 冷却 %d ]]):format((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Reflection Shield",
	display_name = "符文：反射盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
		return ([[激 活 这 个 符 文 产 生 一 个 防 御 护 盾， 吸 收 并 反 弹 最 多 %d 伤 害 值， 持 续 %d 回 合。 效 果 与 魔 法 成 比 例 增 长。 ]])
		:format(power, 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end

		return ([[吸 收 并 反 弹 %d 持续 %d ; 冷却 %d]]):format(power, data.dur or 5, data.cd)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Biting Gale",
	display_name = "符文：冰风",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 ， 形 成 一 股 锥 形 寒 风 ， 造 成 %0.2f 寒 冷 伤 害。
			寒 风 会 浸 湿 敌 人 ，减 半 敌 人 的  震 慑 抗 性  ， 并 试 图 冻 结 他 们 %d 回合。
			效 果 可 以 被 抵 抗 ， 但 不 能 被 豁 免]]):
			format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[伤害 %d; 持续 %d; 冷却 %d]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Acid Wave",
	display_name = "符文：酸性冲击波",
	info = function(self, t)
		  local data = self:getInscriptionData(t.short_name)		  
		  return ([[发 射 锥 形 酸 性 冲 击 波 造 成 %0.2f 酸 性 伤 害。
		 酸 性 冲 击 波 会 缴 械 目 标 %d 回 合。
		 效 果 可 以 被 抵 抗 ， 但 不 能 被 豁 免 ]]):
		 format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local pow = data.power
		return ([[伤害 %d; 持续 %d; 冷却 %d]]):format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Manasurge",
	display_name = "符文：魔力",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 对 你 自 己 释 放 法 力 回 复， 增 加 %d%% 回 复 量 持 续 %d 回 合， 并 立 即 回 复 %d 法 力 值。 
			同 时 ， 在 你 休 息 时 增 加 每 回 合 0.5 的 魔 力 回 复。 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ 回 复 %d%% 持 续 %d 回 合 ; %d 法力瞬回; 冷却 %d]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20, data.cooldown)
	end,
}
-- This is mostly a copy of Time Skip :P
registerInscriptionTranslation{
	name = "Rune of the Rift",
	display_name = "符文：时空裂缝",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 时 空 伤 害。 如 果 你 的 目 标 存 活， 则 它 会 被 传 送 %d 回 合 至 未 来。 
		 它 也 能 降 低 你 60 紊 乱 值 ( 如 果 你 拥 有 该 能 量 )。 
		 注 意， 若 与 其 他 时 空 效 果 相 混 合 则 可 能 产 生 无 法 预 料 的 后 果。 ]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
	short_info = function(self, t)
		return ("%0.2f 时 空 伤 害， 从 时 间 中 移 除 %d 回 合 "):format(t.getDamage(self, t), t.getDuration(self, t))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Blink",
	display_name = "符文：闪烁",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[激 活 符 文 ，传 送 到 视 野 内 %d 格 内 的 指 定 位 置 。之 后 ，你 会 脱 离 相 位 %d 回 合 。在 这 种 状 态 下 ，所 有 新 的 负 面 效 果 的 持 续 时 间 减 少 %d%%，你 的 闪 避 增 加 %d ，你 的 全 体 伤 害 抗 性 增 加 %d%%。]]):
			format(data.range + data.inc_stat, t.getDur(self, t), power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[范围 %d; 相位 %d; 冷却 %d]]):format(self:getTalentRange(t), power, data.cooldown )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Ethereal",
	display_name = "符文：虚幻",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[启 动 符 文 ，使 你 变 得 虚 幻 ，持 续  %d  回 合 。
		 在 虚 幻 状 态 下 ，你 造 成 的 伤 害 减 少 %d%%，你 获 得 %d%% 全 体 伤 害 抗 性 ，你 的 移 动 速 度 提 升 %d%% ，你 获 得 隐 形 (强 度  %d)。]]):
			format(t.getDur(self, t),t.getReduction(self, t) * 100, t.getResistance(self, t), t.getMove(self, t), t.getPower(self, t))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[强度 %d; 抗性 %d%%; 移动 %d%%; 持续 %d; 冷却 %d]]):format(t.getPower(self, t), t.getResistance(self, t), t.getMove(self, t), t.getDur(self, t), data.cooldown)
	end,
}
registerInscriptionTranslation{
	name = "Rune: Stormshield",
	display_name = "符文：风暴护盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[启 动 这 个 符 文 ，在 你 的 身 边 召 唤 一 团 保 护 性 的 风 暴 ，持 续 %d 回 合 。
			 当 符 文 生 效 时 ，风 暴 可 以 抵 挡 大 于 %d 的 任 何 伤 害 最 多 %d 次 。]])
				:format(t.getDur(self, t), t.getThreshold(self, t), t.getBlocks(self, t) )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[阈值 %d; 次数 %d; 持续 %d; 冷却 %d]]):format(t.getThreshold(self, t), t.getBlocks(self, t), t.getDur(self, t), data.cooldown  )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Prismatic",
	display_name = "符文：棱彩",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = ""
		for k,v in pairs(data.wards) do
			str = str .. ", " .. v .. " " .. k:lower():gsub("fire","火焰"):gsub("cold","寒冷"):gsub("lightning","闪电"):gsub("blight","枯萎"):gsub("light","光系"):gsub("arcane","暗影"):gsub("physical","物理"):gsub("temporal","时空"):gsub("mind","精神"):gsub("nature","自然"):gsub("acid","酸性")
		end
		str = string.sub(str, 2)
		return ([[激 活 符 文 展 开 一 个 护 盾，在 %d 回 合 内，抵 挡 以 下 类 型 的 伤 害 : %s]]) -- color me
				:format(t.getDur(self, t), str)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = table.concat(table.keys(data.wards), ", ")
		return ([[%d 回合; %s]]):format(t.getDur(self, t), str:lower():gsub("fire","火焰"):gsub("cold","寒冷"):gsub("lightning","闪电"):gsub("blight","枯萎"):gsub("light","光系"):gsub("arcane","暗影"):gsub("physical","物理"):gsub("temporal","时空"):gsub("mind","精神"):gsub("nature","自然"):gsub("acid","酸性") )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Mirror Image",
	display_name = "符文：镜像",
	info = function(self, t)
		return ([[激 活 符 文 ，最 多 召 唤 你 的 3 个 镜 像 ，镜 像 会 嘲 讽 周 围 的 敌 人 。
			 在 半 径 10 范 围 内 每 有 一 个 敌 人 才 能 召 唤 一 个 镜 像 ，第 一 个 镜 像 会 被 召 唤 在 最 近 的 敌 人 旁 边 。
			 镜 像 继 承 你 的 生 命 值 、抗 性 、护 甲 、闪 避 和 护 甲 硬 度 。]])
				:format(t.getInheritance(self, t)*100 )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[持续 %d; 冷却 %d]]):format(t.getDur(self, t), data.cooldown)
	end
}
registerInscriptionTranslation{
	name = "Rune: Shatter Afflictions",
	display_name = "符文: 粉碎痛苦",
	info = function(self, t)
		return ([[激 活 符 文 ，立 刻 清 除 你 身 上 的 负 面 效 果 。
			 清 除 所 有 CT 效 果 ，以 及 物 理 、精 神 和 魔 法 负 面 效 果 各 1 个 。
			 每 清 除 一 个 负 面 效 果 ，你 都 会 获 得 一 个 抵 挡 %d 伤 害 的 护 盾 ，持 续 3 回 合 。]]):format(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸收 %d; 冷却 %d]]):format(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Dissipation",
	display_name = "符文: 耗散",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 ，从 敌 人 身 上 移 除 4 个 正 面 魔 法 持 续 效 果 ，或 从 自 己 身 上 移 除 所 有 魔 法 负 面 效 果 。]]):
		format()
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ ]]):format()
	end,
}

-----------------------------------------------------------------------
-- Taints
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Taint: Devourer",
	display_name = "堕落印记：吞噬",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[对 目 标 激 活 此 印 记， 移 除 其 %d 个 效 果 并 将 其 转 化 为 治 疗 你 每 个 效 果 %d 生 命 值。 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 效 果 / %d 治 疗 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Taint: Purging",
	display_name = "堕落印记: 清除",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 堕 落 印 记 ，清 除 你 身 上 的 物 理 效 果 ，持 续 %d 回 合 。
		 每 一 回 合 ，这 个 印 记 将 会 尝 试 从 你 的 身 上 解 除 一 个 物 理 负 面 效 果 。
		 如 果 它 解 除 了 一 个 负 面 效 果 ，它 的 持 续 时 间 会 增 加 1 回 合 。]])
				:format(t.getDur(self, t) )
	end,
	short_info = function(self, t)
		return ([[%d 回合]]):format(t.getDur(self, t) )
	end,
}

-----------------------------------------------------------------------
-- Legacy:  These inscriptions aren't on the drop tables and are only kept for legacy compatibility and occasionally NPC use
-----------------------------------------------------------------------

registerInscriptionTranslation{
	name = "Infusion: Sun",
	display_name = "纹身：阳光",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[激 活 这 个 纹 身 照 亮 %d 区 域 和 潜 行 单 位， 可 能 使 潜 行 目 标 显 形（ 降 低 %d 潜 行 强 度）。 %s
		 同 时 区 域 内 目 标 也 有 几 率 被 致 盲（ %d 等 级）， 持 续 %d 回 合。 ]]):
		format(data.range, apply/2, apply >= 19 and "\n 这 光 线 是 如 此 强 烈， 以 至 于 能 驱 散 魔 法 造 成 的 黑 暗 " or "", apply, data.turns)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[范 围 %d; 强 度 %d; 持 续 %d%s]]):format(data.range, apply, data.turns, data.power >= 19 and "; 驱 散 黑 暗 " or "")
	end,
}

registerInscriptionTranslation{
	name = "Taint: Telepathy",
	display_name = "堕落印记：感应",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[解 除 你 的 精 神 束 缚 %d 回 合， 感 应 %d 码 范 围 内 的 所 有 生 物 ， 减 少 %d 精 神 豁 免 持 续 10 回 合 并 增 加 %d 点 精 神 强 度。 ]]):format(data.dur, self:getTalentRange(t), 10, 35)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d 码 心 灵 感 应 持 续 %d 回 合 ]]):format(self:getTalentRange(t), data.dur)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Frozen Spear",
	display_name = "符文：冰矛",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 冰 枪， 造 成 %0.2f 冰 冻 伤 害 并 有 一 定 几 率 冻 结 你 的 目 标。 
               	 寒 冰 同 时 会 解 除 你 受 到 的 一 个 负 面 精 神 状 态。 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 寒 冰 伤 害 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Heat Beam",
	display_name = "符文：热能射线",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 射 线， 造 成 %0.2f 火 焰 伤 害 持 续 5 回 合。 
		 高 温 同 时 会 解 除 你 受 到 的 一 个 负 面 物 理 状 态。 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 火 焰 伤 害 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Speed",
	display_name = "符文：速度",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 提 高 整 体 速 度 %d%% 持 续 %d 回 合。 ]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ 提 速 %d%% 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}


registerInscriptionTranslation{
	name = "Rune: Vision",
	display_name = "符文：洞察",
	type = {"inscriptions/runes", 1},
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人 形 怪 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 族 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[激 活 这 个 符 文 可 以 使 你 查 看 周 围 环 境（ %d 有 效 范 围） 使 你 你 查 看 隐 形 生 物（ %d 侦 测 隐 形 等 级） 持 续 %d 回 合。 
		 你 的 精 神 更 加 敏 锐 ， 能 感 知 到 周 围 的 %s  ， 持 续 %d 回 合。 ]]):
		format(data.range, data.power + data.inc_stat, data.dur, kind, data.dur)

	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人 形 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[范 围 %d; 持 续 %d; 感知 %s]]):format(data.range, data.dur, kind)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Phase Door",
	display_name = "符文：相位门",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[激 活 这 个 符 文 会 使 你 在 %d 码 范 围 内 随 机 传 送。 
		 之 后 ， 你 会 出 入 现 实 空 间 % d 回 合 ， 所 有 新 的 负 面 状 态 持 续 时 间 减 少 %d%% ， 闪 避 增 加 %d ， 全 体 伤 害 抗 性 增 加 %d%%。 ]]):
		format(data.range + data.inc_stat, data.dur or 3, power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[范 围 %d; 强 度 %d; 持 续 %d]]):format(data.range + data.inc_stat, power, data.dur or 3)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Controlled Phase Door",
	display_name = "符文：可控相位门",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文， 传 送 至 %d 码 内 的 指 定 位 置。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d]]):format(data.range + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Lightning",
	display_name = "符文：闪电",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat)
		return ([[激 活 这 个 符 文 发 射 一 束 闪 电 打 击 目 标， 造 成 %0.2f 至 %0.2f 闪 电 伤 害。 
		 同 时 会 让 你 进 入 闪 电 形 态 %d 回 合： 受 到 伤 害 时 你 会 瞬 移 到 附 近 的 一  格 并 防 止 此 伤 害 ， 一 回 合 只 能 触 发 一 次。 ]]):
		format(dam / 3, dam, 2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 闪 电 伤 害 ]]):format(damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Insidious Poison",
	display_name = "纹身：下毒",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 会 发 射 一 个 毒 气 弹 造 成 每 回 合 %0.2f 自 然 伤 害 持 续 7 回 合， 并 降 低 目 标 治 疗 效 果 %d%% 。
		 突 然 涌 动 的 自 然 力 量 会 除 去 你 受 到 的 一 个 负 面 魔 法 效 果 。 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 自 然 伤 害， %d%% 治 疗 下 降 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Invisibility",
	display_name = "符文：隐身",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 使 你 变 得 隐 形（ %d 隐 形 等 级） 持 续 %d 回 合。 
		 由 于 你 的 隐 形 使 你 从 现 实 相 位 中 脱 离， 你 的 所 有 伤 害 降 低 40%%。 
		]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[强 度 %d 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}

return _M

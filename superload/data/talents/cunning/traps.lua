local _M = loadPrevious(...)

local trap_range = function(self, t)
	if not self:knowTalent(self.T_TRAP_LAUNCHER) then return 1 end
	return math.floor(self:combatTalentScale(self:getTalentLevel(self.T_TRAP_LAUNCHER), 2, 7, "log")) -- 2@1, 7@5
end

registerTalentTranslation{
	id = "T_TRAP_MASTERY",
	name = "陷阱专精",
	action = function(self, t)
		local nb = t.getNbTraps(self,t)
		local txt = ("准备哪个陷阱? (最多: %d, 最大材质等级 %d)%s"):format(nb, math.min(5, self:getTalentLevelRaw(t)), self.turn_procs.free_trap_mastery and "\n游戏开始: 新准备的陷阱不会进入冷却。" or "\n#YELLOW#新准备的陷阱会进入冷却。#LAST#")
		local traps_dialog = require("mod.dialogs.TrapsSelect").new("选择准备陷阱", self,
		txt, t, nb, trap_mastery_tids)
		local traps_sel, traps_prev = self:talentDialog(traps_dialog)

		local changed = false
		if traps_sel and traps_prev then
			for tid, _ in pairs(traps_prev) do
				if not traps_sel[tid] then
					game.log("#YELLOW_GREEN#分解 %s", self:getTalentFromId(tid).name)
					self:unlearnTalentFull(tid)
					changed = true
				end
			end
			for tid, sel in pairs(traps_sel) do
				if sel and not traps_prev[tid] then
					game.log("#LIGHT_GREEN#准备 %s%s", self:getTalentFromId(tid).name, self.trap_primed == tid and " (normal trigger)" or "")
					self:learnTalent(tid, true, 1, {no_unlearn=true})
					if self.trap_primed == tid then 
						self.trap_primed = nil
					end
					if not self.turn_procs.free_trap_mastery then self:startTalentCooldown(tid) end -- don't cooldown on birth
					changed = true
				end
			end
		end
		if not changed then game.logPlayer(self, "#LIGHT_BLUE#陷阱准备无变化") end
		
		self.turn_procs.free_trap_mastery = false
		self.trap_mastery_ai = {trap_level=math.min(5, self:getTalentLevelRaw(t)), selected=traps_sel or {}} -- for possible AI control later
		return changed
	end,
	info = function(self, t)
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local detect_power = t.getPower(self, t)
		local disarm_power = t.getPower(self, t)*1.25

		local trap_list = traps_getunlocked(self, t)
		local player = game:getPlayer(true)
		local show_traps = {}
		for i, tid in ipairs(trap_list) do
			local known = self:knowTalent(tid)
			-- display info only for traps prepared or known to the player
			if known or game.state:unlockTalentCheck(tid, player) then
				local tr = self:getTalentFromId(tid)
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				known = self.trap_primed ~= tid and known, 
				info = tr.short_info and tr.short_info(self, tr) or "#GREY#(见技能描述)#LAST#"}
			end
		end
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%s材质等级 %d: %s#LAST#\n%s"):format(trap.known and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		self.turn_procs.trap_mastery_tid = nil
		return ([[该 技 能 允 许 你 准 备 %d 个 不 同 的 陷 阱 ， 最 高 材 质 等  级 为 %d 。 （ 使 用 该 技 能 选 择 需 要 准 备  的 陷 阱 。） 
		 已 知 陷 阱 ：
%s

		 准 备 好 的 陷 阱 更 难 被 发 现、 被 解 除 （ %d 点 侦 测 强 度， %d 点 解 除 强 度 ， 基 于 灵 巧）。
		 你 免 疫 自 己 的 陷 阱，陷 阱 可 以 暴 击（使 用 物 理 暴 击 率）。
		 当 陷 阱 消 失 时， 如 果 效 果 未 触 发， 回 复 80%% 体 力 消 耗。
		 你 能 在 世 界 上 学 到 许 多 其 他 陷 阱。]]):
		format(t.getNbTraps(self, t), math.min(5, self:getTalentLevelRaw(t)), trap_descs, detect_power, disarm_power, t.getTrapMastery(self, t), stealth_chance, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LURE",
	name = "诱饵",
	info = function(self, t)
		local t2 = self:getTalentFromId(self.T_TAUNT)
		local rad = t2.radius(self, t)	
		return ([[抛 出 一 个 诱 饵 来 吸 引 %d 码 半 径 内 的 敌 人，持 续 %d 回 合  。
		 诱 饵 有 %d 生 命 ( 基 于 灵 巧)，%d 护 甲 和 %d%% 非 物 理 伤 害 抗 性。 
		 在 等 级 5 时， 当 诱 饵 被 摧 毁 时， 它 会 自 动 触 发 在 它 周 围 2 码 范 围 内 的 陷 阱（ 可 鉴 定 某 些 陷 阱 是 否 能 被 触 发 )。 
		 此 技 能 不 会 打 断 潜 行 状 态。]]):format(rad, t.getDuration(self,t), t.getLife(self, t), t.getArmor(self, t), t.getResist(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TRAP_LAUNCHER",
	name = "高级陷阱放置",
	short_name = "TRAP_LAUNCHER",
	info = function (self,t)
		return ([[你 学 会 放 置 陷 阱 的 新 技 巧 。
		 选 择 一 个 陷 阱 ，你 能 在 %d 格 外 放 置 ，减 少 %d%%消 耗 时 间 ，有 %d%%几 率 不 打 破 潜 行 ]]):format(trap_range(self, t), (1 - t.trapSpeed(self, t))*100, t.trapStealth(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TRAP_PRIMING",
	name = "即爆陷阱",
	info = function (self,t)
		local m_level, trap_list = self:getTalentLevelRaw(t), traps_getunlocked(self, t)
		local mastery = t.getTrapMastery(self, t)
		local instant = "none"
		local show_traps = {}
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local player = game:getPlayer(true)
		for i, tid in pairs(trap_list) do
			local tr = self:getTalentFromId(tid)
			-- show only primable traps that are primed or that the player knows about
			if tr and tr.allow_primed_trigger and tr.trap_mastery_level and (self:knowTalent(tid) or game.state:unlockTalentCheck(tid, player)) then
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				info = tr.short_info and tr.short_info(self, tr) or "#GREY#(see trap description)#LAST#"}
				if tid == self.trap_primed then
					show_traps[#show_traps].instant = true
					instant = tr.name
				end
			end
		end
		self.turn_procs.trap_mastery_tid = nil
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%s材质等级 %d: %s#LAST#\n%s"):format(trap.instant and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		return ([[你 额 外 准 备 一 个 陷 阱 （最 高 材 质 等 级 %d ），带 有 特 殊 的 控 制 机 关 ，能 在 设 置 后 立 刻 生 效 。 (使 用 该 技 能 来 选 择 需 要 准 备 的 陷 阱 。)
		 并 非 所 有 陷 阱 都 能 这 样 准 备 ，每 种 陷 阱 只 有 一 种 改 进 方 式 。
		 已 学 会 的 引 爆 方 式 :
%s 

带 有 特 殊 启 动 机 关 的 陷 阱 强 度 增 加  %+d%% (取 代 陷 阱 专 精 的 加 成 )  ，有 %d%%几 率 不 破 坏 潜 行 。
#YELLOW#当 前 选 择 的 陷 阱 : %s#LAST#]]):
		format(self:getTalentLevelRaw(t), trap_descs, mastery, stealth_chance, instant)
	end,
}
registerTalentTranslation{
	id = "T_SPRINGRAZOR_TRAP",
	name = "刀锋陷阱",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local power = t.getPower(self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 压 力 感 应 陷 阱，触 发 后 爆 炸 形 成 半 径 2 格 的 刀 片 风 暴 ,造 成 %0.2f 物 理 伤 害。被 击 中 的 目 标 的 命 中 、护 甲 和 闪 避 下 降 %d.
		该 陷 阱 可 以 被 设 置 为 直 接 激 活 ， 也 可 以 被 诱 饵 激 活。%s]]):
		format(damDesc(self, DamageType.PHYSICAL, dam), power, instant)
	end,
	short_info = function(self, t)
		return ([[刀 片（范 围2）  %d 物理伤害, 减少命中、护甲 和闪避  %d.]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getPower(self,t))
	end,
}
registerTalentTranslation{
	id = "T_BEAR_TRAP",
	name = "捕熊陷阱",
	info = function (self,t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 一 个压 力 感 应 的 捕 熊 陷 阱 ， 会 捕 获 第 一 个 经 过 的 生 物 ， 造 成 %0.2f 物 理 伤 害 ， 定 身 并 减 速 30%% ，持 续 5 回 合 ， 并 在 期 间 受 到 %0.2f 流 血 伤 害 。 %s]]):format(dam, dam, instant)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[%d 物理伤害，定身、30%%减速, 5回合额外 %d 流血伤害。]]):format(dam, dam)
	end,
}
registerTalentTranslation{
	id = "T_DISARMING_TRAP",
	name = "缴械陷阱",
	info = function(self, t)
		return ([[放 置 一 个 缴 械 陷 阱。 经 过 的 目 标 受 到 %0.2f 点 酸 性 伤 害， 并 被 缴 械 %d 回 合。 ]]):
		format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
	short_info = function(self, t)
		return ([[%d 酸性伤害, 缴械 %d 回合.]]):
		format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PITFALL_TRAP",
	name = "落穴陷阱",
	info = function (self,t)
		return ([[放 置 一 个 压 力 感 应 陷 阱 ，目 标 经 过 时 地 面 将 坍 塌 ，造 成  %0.2f  物 理 伤 害 并 将 其 埋 在 地 下 （暂 时 移 出 游 戏 ） 5  回 合 。
如 果 目 标 抵 抗 被 埋 ，那 么 他 将 被 定 身 （无 视 50%%定 身 免 疫 ）。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
	short_info = function(self, t)
		return ([[%d 物理 伤害 。目标 被移除游戏 或者 定身 5回合。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_FLASH_BANG_TRAP",
	name = "闪光陷阱",
	info = function(self, t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 一 个 闪 光 陷 阱。 产 生 一 个 2 码 范 围 的 爆 炸， 造 成 %0.2f 物 理 伤 害，致 盲 或 眩 晕 目 标 %d 回 合（ 各 50%% 几 率）。
		 该 陷 阱 可 以 被 设 置 为 直 接 激 活 ， 也 可 以 被 诱 饵 激 活。%s]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t), instant)
	end,
	short_info = function(self, t)
		return ([[ 爆炸(半径2) 造成 %d 物理伤害, 50%% 致盲/眩晕 %d 回合。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_BLADESTORM_TRAP",
	name = "剑刃风暴陷阱",
	info = function (self,t)
		return ([[放 置 一 个 陷 阱 ，激 活 后 产 生 致 命 的 剑 刃 风 暴 ，持 续  %d 回 合 。这 个 临 时 的 结 构 体 非 常 坚 韧 ，获 得 你 的 伤 害 加 成 ，每 回 合 自 动 攻 击 相 邻 敌 人 。]]):format(t.getDuration(self,t))
	end,
		short_info = function(self, t)
		return ([[每回合 攻击 周围生物 ，持续 %d 回合。]]):format(t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_BEAM_TRAP",
	name = "射线陷阱",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[放 置 魔 法 陷 阱 ，每 回 合 朝 5 格 内 的 随 机 敌 人 射 出 奥 术 射 线 ，持 续  %d  回 合 ,  造 成  %0.2f  奥 术 伤 害 。
该 陷 阱 需 要 20 魔 法 才 能 准 备 ，消 失 时 不 返 还 体 力 。
#YELLOW#放 置 后 立 刻 激 活 。#LAST#]]):format(dur, damDesc(self, DamageType.ARCANE, dam))
	end,
	short_info = function(self, t)
		return ([[每回合发射 (射程5 )的射线， 造成 %d 奥术伤害. 持续 %d 回合。]]):
		format(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_POISON_GAS_TRAP",
	name = "毒气陷阱",
	info = function(self, t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[ 放 置 一 个 毒 气 陷 阱， 在 3 码 范 围 内 产 生 毒 云 爆 炸， 持 续 4 回 合。 
		 每 回 合 毒 云 对 目 标 造 成 %0.2f 自 然 伤 害， 持 续 5 回 合。 有 25%% 几 率 毒 素 会 被 强 化 为 致 残 、 麻 木 或 者 阴 险 毒 素 。 
		 该 陷 阱 可 以 被 设 置 为 直 接 激 活 ， 也 可 以 被 诱 饵 激 活。%s]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self, t)), instant)
	end,
	short_info = function(self, t)
		return ([[释放 范围 3的 毒气,5回合内 %d 自然伤害， 25%% 几率强化 毒素 效果。]]):format(damDesc(self, DamageType.POISON, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_FREEZING_TRAP",
	name = "冰冻陷阱",
	info = function (self,t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 一 个 陷 阱 ，激 活 后 产 生 半 径 2 的 冰 冻 气 体 ，造 成 %0.2f  寒 冷 伤 害 并 定 身  3  回 合 。
		 冰 冻 气 体 持 续 5 回 合 ，每 回 合 造 成  %0.2f  伤 害 ，有 25%% 几 率 冻 结 。
		 该 陷 阱 可 以 被 设 置 为 直 接 激 活 ， 也 可 以 被 诱 饵 激 活。%s]]):
		format(dam, dam/3, instant)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		return ([[爆炸 (范围 2):  %d 寒冷伤害 并定身 3 回合。范围冻结 (%d 寒冷伤害， 25%% 冻结几率) 5回合。]]):format(dam, dam/3)
	end,
}
registerTalentTranslation{
	id = "T_DRAGONSFIRE_TRAP",
	name = "龙火陷阱",
	info = function (self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[放 置 一 个 压 力 感 应 陷 阱 ，激 活 后 产 生 半 径 2 的 火 云 ,震 慑 敌 人  (每 回 合 %0.2f 火 焰 伤 害  ) 3 回 合 。
		 火 焰 持 续 5 回 合 ，每 回 合 燃 烧 造 成  %0.2f  火 焰 伤 害 。
	 	 该 陷 阱 可 以 被 设 置 为 直 接 激 活 ， 也 可 以 被 诱 饵 激 活。%s]]):
		format(dam/3, dam/2, instant)
	end,
	short_info = function(self, t)
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[爆炸 (范围 2): 震慑 并在3回合内每回合 造成 %d 火焰伤害。范围火焰 (%d 火焰伤害) 持续5 回合。]]):format(dam/3, dam/2)
	end,
}

registerTalentTranslation{
	id = "T_GRAVITIC_TRAP",
	name = "引力陷阱",
	info = function(self, t)
		return ([[ 放 置 一 个 引 力 陷 阱 ，周 围 一 格 有 敌 人 经 过 时 触 发， 将 附 近 5 码 范 围 内 的 敌 人 拉 向 它（成 功 率 受 命 中 或 法 强 影 响 ）。
		 每 回 合 陷 阱 对 所 有 目 标 造 成 %0.2f 时 空 伤 害（基 于 魔 法）。
		 陷 阱 持 续 %d 回 合。
		 陷 阱 可 以 多 次 触 发 ， 需 要 两 回 合 冷 却。
		 该 技 能 不 需 要 高 级 技 能 来 准 备。
		 ]]):
		format(damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)), t.getDuration(self,t))
	end,
	short_info = function(self, t)
		return ([[制造 范围5 的 黑洞，持续 %d 回合。敌对生物受到 %d 时空伤害并被拉过去。 触发范围+1。]]):
		format(t.getDuration(self,t), damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_AMBUSH_TRAP",
	name = "伏击陷阱",
	info = function (self,t)
		return ([[放 置 一 个 魔 法 陷 阱 ，能 召 唤 阴 影 盗 贼 攻 击 目 标 。
召 唤 出 的 盗 贼 永 久 潜 行 ，继 承 你 的 伤 害 加 成 。
杀 死 目 标 或 者 存 在 %d 回 合 后 ，盗 贼 消 失 。]]):
		format(t.getDuration(self,t))
	end,
	short_info = function(self, t)
		return ([[召唤 三名 潜行 盗贼，持续 %d 回合。]]):format(t.getDuration(self,t))
	end,
}
registerTalentTranslation{
	id = "T_PURGING_TRAP",
	name = "净化陷阱",
	info = function (self,t)
		local base = t.getDamage(self,t)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 一 个 陷 阱 ，触 发 后 释 放 半 径 2 的 反 魔 能 量 波 ，吸 取 至 多  %d  法 力 , %d  活 力 , %d  正 能 量 和 %d  负 能 量 ,  并 造 成 至 多  %0.2f  奥 术 伤 害 （基 于 吸 取 能 量 ），  沉 默  %d  回 合 ，并 解 除 至 多 %d 项 正 面 魔 法 状 态 或 者 维 持 技 能 。
		  吸 取 效 果 受 意 志 加 成 ，你 需 要 25 点 意 志 来 使 用 该 技 能 。
		  该 陷 阱 可 以 被 设 置 为 直 接 激 活 ，也 可 以 被 诱 饵 激 活 。 %s ]]):
		format(mana, vim, positive, negative, damDesc(self, DamageType.ARCANE, base), dur, nb, instant)
	end,
	short_info = function(self, t)
		local base = t.getDamage(self,t)
		local mana = base
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		return ([[半径2 反魔: 吸收至多%d 法力, %d 活力, %d 正负能量, 造成 至多%d 奥术伤害。解除 %d 项魔法效果 ，沉默 %d 回合。]]):
		format(base, base/2, base/4, damDesc(self, DamageType.ARCANE, base), nb, dur)
	end,
}
registerTalentTranslation{
	id = "T_EXPLOSION_TRAP",
	name = "爆炸陷阱",
	info = function (self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设 置 完 毕 后 立 刻 激 活。#LAST#" or ""
		return ([[放 置 一 个 简 单 而 有 效 的 陷 阱 ， 激 活 后 触 发 半 径  2 的 爆 炸, 3 回 合 内 造 成 %0.2f 火 焰 伤 害 。
		该 陷 阱 可 以 被 设 置 为 直 接 激 活 ，也 可 以 被 诱 饵 激 活 。 %s]]):
		format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), instant)
	end,
	short_info = function(self, t)
		return ([[爆炸(范围 2) ：3回合内 %d 火焰伤害。]]):
		format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_CATAPULT_TRAP",
	name = "弹射陷阱",
	info = function(self, t)
		return ([[放 置 一 个 弹 射 陷 阱。 击 退 经 过 的 敌 人 %d 码， 并 眩 晕 5 回 合。
		陷 阱 触 发 后 有 %d%% 几 率 自 己 重 置 ， 但 每 回 合 只 能 重 置 一 次。
		]]):
		format(t.getDistance(self, t), t.resetChance(self, t))
	end,
	short_info = function(self, t)
		return ([[击退%d 格，并 眩晕。]]):
		format(t.getDistance(self, t))
	end,
}



registerTalentTranslation{
	id = "T_NIGHTSHADE_TRAP",
	name = "颠茄陷阱",
	info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[放 置 一 个 涂 了 颠 茄 毒 素 的 陷 阱， 造 成 %0.2f 自 然 伤 害 并 震 慑 目 标 4 回 合，并 在 四 回 合 内 受 到 额 外 %0.2f 自 然 伤 害 。]]):
		format(dam, dam/10)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[造成 %d 自然伤害，震慑且每回合造成 %d 自然伤害， 持续4 回合。]]):
		format(dam, dam/10)
	end,
}









return _M

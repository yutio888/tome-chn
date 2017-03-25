local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_ROGUE_S_TOOLS",
	name = "盗贼工具箱",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你 学 会 制 造 并 装 备 一 系 列 工 具 (#YELLOW#等级 %d#WHITE#):

%s
准 备 工 具 套 件 将 重 置 其 等 级 并 使 其 进 入 冷 却 。
]]):format(self:getTalentLevelRaw(t), descs)
	end,
}
registerTalentTranslation{
	id = "T_CUNNING_TOOLS",
	name = "二号工具",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你 学 会 制 造 并 装 备 一 系 列 工 具  (#YELLOW#等级 %d#WHITE#)（第二件）:

%s
准 备 工 具 套 件 将 重 置 其 等 级 并 使 其 进 入 冷 却 。
同 一 种 类 型 的 工 具 一 次 只 能 装 备 一 件 。
]]):format(self:getTalentLevelRaw(t), descs)
	end,
}
registerTalentTranslation{
	id = "T_INTRICATE_TOOLS",
	name = "三号工具",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你 学 会 制 造 并 装 备 一 系 列 工 具  (#YELLOW#等级 %d#WHITE#)（第三件）:

%s
准 备 工 具 套 件 将 重 置 其 等 级 并 使 其 进 入 冷 却 。
同 一 种 类 型 的 工 具 一 次 只 能 装 备 一 件 。
]]):format(self:getTalentLevelRaw(t), descs)
	end,
}
registerTalentTranslation{
	id = "T_MASTER_ARTIFICER",
	name = "强化工具",
	info = function (self,t)
		local tool = "none"
		if self.artifice_tools_mastery then
			tool = self:getTalentFromId(self.artifice_tools_mastery).name
		end
		--- generate a textual list of available artifice tools enhancements
		if not self.artifice_tools then artifice_tools_setup(self, t) end
		local mastery_descs = {}
		for tool_id, m_tid in pairs(artifice_tool_tids) do
			local tool, mt = self:getTalentFromId(tool_id), self:getTalentFromId(m_tid)
			if mt then
				local desc
				local prepped = self.artifice_tools_mastery == tool_id
				if prepped then
					desc = ("#YELLOW#%s (%s)#LAST#\n"):format(tool.name, mt.name)
				else
					desc = ("%s (%s)\n"):format(tool.name, mt.name)
				end
				if mt.short_info then
					desc = desc..mt.short_info(self, mt).."\n"
				else
					desc = desc.."#GREY#(见技能描述)#LAST#\n"
				end
				mastery_descs[#mastery_descs+1] = desc
			end
		end
		mastery_descs = table.concatNice(mastery_descs, "\n\t")
		return ([[你 成 为 工 具 大 师 ， 能 集 中 强 化 一 件 工 具 (#YELLOW#当前选择 %s#LAST#) 来 改 善 其 性 能:

%s
效 果 取 决 于 技 能 等 级。
强 化 工 具 将 使 其 进 入 冷 却。]]):format(tool, mastery_descs)
	end,
}
registerTalentTranslation{
	id = "T_HIDDEN_BLADES",
	name = "隐匿刀锋",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local slot = "not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[你 将 刀 片 隐 藏 在 装 备 中 ， 暴 击 时 ， 刀 片 自 动 弹 出 ，造 成 %d%% 徒 手 武 器 伤 害。
该 技 能 有 冷 却 时 间。 
#YELLOW#准备于: %s#LAST#]]):format(dam*100, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[近 战 暴 击 触 发 额 外 %d%% 伤 害 徒 手 攻 击 ， 4 回 合 冷 却。]]):format(t.getDamage(self, slot_talent)*100)
	end,
}
registerTalentTranslation{
	id = "T_ASSASSINATE",
	name = "暗杀",
	info = function (self,t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleed(self,t) * 100
		return ([[你 用 隐 匿 刀 锋 攻 击 两 次，每 次 造 成 %d%% 徒 手 伤 害。需 要 看 见 目 标 来 使 用 该 技 能 ， 该 技 能 无 视 护 甲 和 物 理 抗 性 。
此 外 ， 你 的 隐 匿 刀 锋 在 5 回合 内 额 外 造 成 %0.1f 流 血 伤 害。]])
		:format(damage, bleed)
	end,
	short_info = function(self, t)
		return ([[你的 隐匿刀锋 会触发流血效果，同时强化暗杀技能， 自动攻击 两次造成 %d%% 徒手伤害， 无视护甲与抗性。 ]]):format(t.getDamage(self, t)*100)
	end,
}
registerTalentTranslation{
	id = "T_ROGUE_S_BREW",
	name = "盗贼佳酿",
	info = function (self,t)
	local heal = t.getHeal(self, t)
	local sta = t.getStam(self, t)
	local cure = t.getCure(self,t)
	local slot = "not prepared"
	for slot_id, tool_id in pairs(self.artifice_tools or {}) do
		if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
	end
	return ([[制 造 强 效 恢 复 药 酒, 使 用 后 回 复 %d 生 命, %d 体 力 并 解 除 %d 项 物 理 负 面 效 果 。该 效 果 受 灵 巧 加 成。
	#YELLOW#准备于: %s#LAST#]]):format(heal, sta, cure, slot)
   end,
   	short_info = function(self, t, slot_talent)
		return ([[准备 药剂， 回复 %d 生命, %d 体力, 解除 %d 项 物理 负面状态。20 回合 冷却。]]):format(t.getHeal(self, slot_talent), t.getStam(self, slot_talent), t.getCure(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_ROGUE_S_BREW_MASTERY",
	name = "佳酿强化",
	info = function (self,t)
		return ([[调 整 配 方 ，8 回 合 内 生 命 底 限 增 加 %d 。]]):format(t.getDieAt(self,t))
	end,
	short_info = function(self, t)
		return ([[调 整 配 方 ，8 回 合 内 生 命 底 限 增 加 %d 。]]):format(t.getDieAt(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SMOKESCREEN",
	name = "烟雾弹",
	info = function (self,t)
		local slot = "not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[扔 出 烟 雾 弹 ，产 生 半 径 %d 的 烟 雾 ，持 续 %d 回 合 。烟 雾 阻 挡 视 野 ，所 有 烟 雾 中 的 敌 人 视 野 下 降 %d 。
		使 用 该 技 能 不 解 除 潜 行 。被 烟 雾 影 响 的 生 物 不 能 阻 止 你 潜 行 。
		#YELLOW#准备于: %s#LAST#]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), t.getSightLoss(self,t), slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[范围 2 的 烟雾弹，持续 %d 回合, 视野 下降 %d 。15回合冷却。]]):format( t.getDuration(self, slot_talent), t.getSightLoss(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_SMOKESCREEN_MASTERY",
	name = "强化烟雾弹",
	info = function (self,t)
		return ([[你 的 烟 雾 弹 中 加 入 了 窒 息 粉 尘 。每 回 合 烟 雾 中 的 敌 人 将 受 到  %0.2f  自 然 伤 害 并 有  50%%  几 率 被 沉 默 。]]):
		format(damDesc(self, DamageType.NATURE, t.getDamage(self,t)))
	end,
	short_info = function(self, t)
		return ([[你 的 烟 雾 弹 中 加 入 了 窒 息 粉 尘 。每 回 合 烟 雾 中 的 敌 人 将 受 到  %0.2f  自 然 伤 害 并 有  50%%  几 率 被 沉 默 。]]):format(t.getDamage(self, t))
	end,

}
registerTalentTranslation{
	id = "T_DART_LAUNCHER",
	name = "飞镖发射器",
	info = function (self,t)
		local dam = t.getDamage(self,t)
		local power = t.getSleepPower(self,t)
		local slot = "not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[从 无 声 发 射 器 中 发 射 毒 镖，造 成 %0.2f 物 理 伤 害，并 催 眠 生 物 4 回合。每 受 到 %d 点 伤 害 ， 睡 眠 时 间 减 少 一 回 合 。
使 用 该 技 能 不 解 除 潜 行 。
#YELLOW#准备于: %s#LAST#]]):
	format(damDesc(self, DamageType.PHYSICAL, dam), power, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[发射毒镖，造成 %0.2f 物理伤害，沉睡4回合。10回合 冷却时间。]]):format(t.getDamage(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_DART_LAUNCHER_MASTERY",
	name = "毒镖强化",
	info = function (self,t)
		return ([[睡 眠 毒 素 无 视 免 疫 ， 且 使 目 标 醒 来 后 减 速 %d%% 4 回 合。]]):
		format(t.getSlow(self, t)*100)
	end,
	short_info = function(self, t)
		return ([[睡 眠 毒 素 无 视 免 疫 ， 且 使 目 标 醒 来 后 减 速 %d%% 4 回 合。]]):format(t.getSlow(self, t)*100)
	end,
}
registerTalentTranslation{
	id = "T_GRAPPLING_HOOK",
	name = "钩爪",
	info = function (self,t)
		local range = t.range(self,t)
		local slot = "not prepared"
		for slot_id, tool_id in pairs(self.artifice_tools or {}) do
			if tool_id == t.id then slot = self:getTalentFromId(slot_id).name break end
		end
		return ([[朝 %d 格 范 围 内 的 目 标 发 射 钩 爪， 如 果 目 标 是 墙 壁 、 目 标 不 能 移 动 或 目 标 体 型 比 你 大，你 将 被 拉 过 去，否 则 将 目 标 拉 过 来。之 后 ， 目 标 将 被 定 身 2 回 合 。
		钩 爪 至 少 要 发 射 到 两 格 外。
#YELLOW#准备于: %s#LAST#]]):
	format(range, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[发射 长度 %d 的 钩爪，将你拉过去 或者将 对面 拉过来。 8 回合冷却。]]):format(t.range(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_GRAPPLING_HOOK_MASTERY",
	name = "钩爪强化",
	info = function (self,t)
		return ([[你 的 钩 爪 上 涂 有 毒 素 且 装 有 尖 刺 ，被 击 中 的 生 物 受 到  %d%%  徒 手 伤 害 ,在 4 回 合 内 受 到  %0.2f  流 血 伤 害 和  %0.2f  自 然 毒 素 伤 害 。]]):
		format(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
	short_info = function(self, t)
		return ([[被 钩 爪 击 中 的 生 物 受 到 %d%%  徒 手 伤 害 ,在 4 回 合 内 受 到  %0.2f  流 血 伤 害 和  %0.2f  自 然 毒 素 伤 害 。]]):format(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
}

return _M
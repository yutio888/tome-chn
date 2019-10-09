local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_ROGUE_S_TOOLS",
	name = "盗贼工具箱",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你学会制造并装备一系列工具 (#YELLOW#等级 %d#WHITE#):

%s
准备工具套件将重置其等级并使其进入冷却。
]]):format(self:getTalentLevelRaw(t), descs)
	end,
}
registerTalentTranslation{
	id = "T_CUNNING_TOOLS",
	name = "二号工具",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你学会制造并装备一系列工具  (#YELLOW#等级 %d#WHITE#)（第二件）:

%s
准备工具套件将重置其等级并使其进入冷却。
同一种类型的工具一次只能装备一件。
]]):format(self:getTalentLevelRaw(t), descs)
	end,
}
registerTalentTranslation{
	id = "T_INTRICATE_TOOLS",
	name = "三号工具",
	info = function (self,t)
		local descs = artifice_tools_get_descs(self, t)
		return ([[你学会制造并装备一系列工具  (#YELLOW#等级 %d#WHITE#)（第三件）:

%s
准备工具套件将重置其等级并使其进入冷却。
同一种类型的工具一次只能装备一件。
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
		return ([[你成为工具大师，能集中强化一件工具 (#YELLOW#当前选择 %s#LAST#) 来改善其性能:

%s
效果取决于技能等级。
强化工具将使其进入冷却。]]):format(tool, mastery_descs)
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
		return ([[你将刀片隐藏在装备中，当你对临近目标造成暴击时，刀片自动弹出，造成 %d%% 徒手武器伤害。
该技能有冷却时间。 
#YELLOW#准备于: %s#LAST#]]):format(dam*100, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[近战暴击触发额外 %d%% 伤害徒手攻击， 4 回合冷却。]]):format(t.getDamage(self, slot_talent)*100)
	end,
}
registerTalentTranslation{
	id = "T_ASSASSINATE",
	name = "暗杀",
	info = function (self,t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleed(self,t) * 100
		return ([[你用隐匿刀锋攻击两次，每次造成 %d%% 徒手伤害。需要看见目标来使用该技能，该技能无视护甲和物理抗性。
此外，你的隐匿刀锋在 5 回合内额外造成 %0.1f 流血伤害。]])
		:format(damage, bleed)
	end,
	short_info = function(self, t)
		return ([[你的隐匿刀锋会触发流血效果，同时强化暗杀技能，自动攻击两次造成 %d%% 徒手伤害，无视护甲与抗性。 ]]):format(t.getDamage(self, t)*100)
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
	return ([[制造强效恢复药酒, 使用后回复 %d 生命, %d 体力并解除 %d 项物理负面效果。该效果受灵巧加成。
	#YELLOW#准备于: %s#LAST#]]):format(heal, sta, cure, slot)
   end,
   	short_info = function(self, t, slot_talent)
		return ([[准备药剂，回复 %d 生命, %d 体力, 解除 %d 项物理负面状态。20 回合冷却。]]):format(t.getHeal(self, slot_talent), t.getStam(self, slot_talent), t.getCure(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_ROGUE_S_BREW_MASTERY",
	name = "佳酿强化",
	info = function (self,t)
		return ([[调整配方，8 回合内生命底限增加 %d 。]]):format(t.getDieAt(self,t))
	end,
	short_info = function(self, t)
		return ([[调整配方，8 回合内生命底限增加 %d 。]]):format(t.getDieAt(self, t))
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
		return ([[扔出烟雾弹，产生半径 %d 的烟雾，持续 %d 回合。烟雾阻挡视野，所有烟雾中的敌人视野下降 %d 。
		使用该技能不解除潜行。被烟雾影响的生物不能阻止你潜行。
		#YELLOW#准备于: %s#LAST#]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), t.getSightLoss(self,t), slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[范围 2 的烟雾弹，持续 %d 回合, 视野下降 %d 。15回合冷却。]]):format( t.getDuration(self, slot_talent), t.getSightLoss(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_SMOKESCREEN_MASTERY",
	name = "强化烟雾弹",
	info = function (self,t)
		return ([[你的烟雾弹中加入了窒息粉尘。每回合烟雾中的敌人将受到  %0.2f  自然伤害并有  50%%  几率被沉默。]]):
		format(damDesc(self, DamageType.NATURE, t.getDamage(self,t)))
	end,
	short_info = function(self, t)
		return ([[你的烟雾弹中加入了窒息粉尘。每回合烟雾中的敌人将受到  %0.2f  自然伤害并有  50%%  几率被沉默。]]):format(t.getDamage(self, t))
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
		return ([[从无声发射器中发射毒镖，造成 %0.2f 物理伤害，并催眠生物 4 回合。每受到 %d 点伤害，睡眠时间减少一回合。
使用该技能不解除潜行。
#YELLOW#准备于: %s#LAST#]]):
	format(damDesc(self, DamageType.PHYSICAL, dam), power, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[发射毒镖，造成 %0.2f 物理伤害，沉睡 4 回合。10 回合冷却时间。]]):format(t.getDamage(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_DART_LAUNCHER_MASTERY",
	name = "毒镖强化",
	info = function (self,t)
		return ([[睡眠毒素无视免疫，且使目标醒来后减速 %d%% 4 回合。]]):
		format(t.getSlow(self, t)*100)
	end,
	short_info = function(self, t)
		return ([[睡眠毒素无视免疫，且使目标醒来后减速 %d%% 4 回合。]]):format(t.getSlow(self, t)*100)
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
		return ([[朝 %d 格范围内的目标发射钩爪，如果目标是墙壁、目标不能移动或目标体型比你大，你将被拉过去，否则将目标拉过来。之后，目标将被定身 2 回合。
		钩爪至少要发射到两格外。
#YELLOW#准备于: %s#LAST#]]):
	format(range, slot)
	end,
	short_info = function(self, t, slot_talent)
		return ([[发射长度 %d 的钩爪，将你拉过去或者将对面拉过来。 8 回合冷却。]]):format(t.range(self, slot_talent))
	end,
}
registerTalentTranslation{
	id = "T_GRAPPLING_HOOK_MASTERY",
	name = "钩爪强化",
	info = function (self,t)
		return ([[你的钩爪上涂有毒素且装有尖刺，被击中的生物受到  %d%%  徒手伤害 ,在 4 回合内受到  %0.2f  流血伤害和  %0.2f  自然毒素伤害。]]):
		format(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
	short_info = function(self, t)
		return ([[被钩爪击中的生物受到 %d%%  徒手伤害 ,在 4 回合内受到  %0.2f  流血伤害和  %0.2f  自然毒素伤害。]]):format(t.getDamage(self, t)*100, damDesc(self, DamageType.PHYSICAL, t.getSecondaryDamage(self,t)), damDesc(self, DamageType.NATURE, t.getSecondaryDamage(self,t)))
	end,
}

return _M
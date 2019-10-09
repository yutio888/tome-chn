local _M = loadPrevious(...)
for i = 1, 8 do
registerTalentTranslation{
	id = "T_POSSESSION_TALENT_"..i,
	name = "所有物技能"..i,
	info = function (self,t)
			return ([[附身时，该技能会被替换成身体的其中一个技能。
			该技能的唯一用法是放在热键栏上。]]):
			format()
		end,
	}
end

local function bodies_desc(self)
	if #self.bodies_storage < 1 then return "none" end
	local b_list = ""
	for i, store in ipairs(self.bodies_storage) do
		local body = store.body
		local name = body.name
		if #name > 18 then name = string.sub(name, 1, 15).."..." end
		name = npcCHN:getName(name)
		local in_use = body._in_possession and body:getDisplayString() or " "
		local _, rankcolor = body:TextRank()
		b_list = b_list..("\n%s%s%d)%s#LAST# (#LIGHT_BLUE#等级 %d#LAST#, #LIGHT_RED#生命值:%d/%d#LAST#)"):format(in_use, rankcolor, store.uses, name, body.level, body.life, body.max_life)
	end
	return b_list
end

registerTalentTranslation{
	id = "T_DESTROY_BODY",
	name = "摧毁身体",
	on_pre_use = function(self, t, silent) if #self.bodies_storage == 0 then if not silent then game.logPlayer(self, "You have no stored bodies to delete.") end return false end return true end,
	action = function(self, t)
		package.loaded['mod.dialogs.AssumeForm'] = nil
		self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "destroy"))
		return true
	end,
	info = function(self, t)
		return ([[从你的灵能仓库中丢弃身体。
		拥有的身体 :
		%s]]):
		format(bodies_desc(self))
	end,
}
registerTalentTranslation{
	id = "T_ASSUME_FORM",
	name = "附身",
	info = function (self,t)
		return ([[选择一个身体，附身。
		以这种方式使用的身体可能不会被任何方式治愈。
		你可以随时通过再次使用这个技能来选择退出身体，将其恢复原状，包括任何物理效果。精神 , 魔法和“其他”效果仍然对你有效。
		当生命为 0 时被迫离开身体，冲击对你最大血量造成 %d%% 的损失并减少 50%% 移动速度和 60%% 伤害持续 6 回合。
		技能冷却仅在恢复正常形式时开始冷却。
		附身时仍会获得经验，但不会被应用，直到你离开身体。
		附身时你无法更换装备。
		冷却时间随主宰技能等级提高。
		拥有的身体 :
		%s]]):
		format(self:callTalent(self.T_POSSESS, "getShock"), bodies_desc(self))
	end,
}
registerTalentTranslation{
	id = "T_POSSESS",
	name = "主宰",
	info = function (self,t)
		local fake = {rank=2}
		local rt0, rc0 = self.TextRank(fake)
		fake.rank = 3; local rt3, rc3 = self.TextRank(fake)
		fake.rank = 3.5; local rt5, rc5 = self.TextRank(fake)
		fake.rank = 4; local rt7, rc7 = self.TextRank(fake)
		rc0 = rc0:gsub("normal","普通")
		rc3 = rc3:gsub("elite","精英")
		rc5 = rc5:gsub("unique","史诗")
		rc7 = rc7:gsub("boss","Boss")
		return ([[你对目标投掷一个持续 %d 回合的灵能网。每回合造成 %0.2f 精神伤害。
		如果目标在持续时间内死亡，你会获得它的身体并放入你的灵能仓库中。
		在任何时候，你可以使用附身技能暂时脱离你的身体进入新的身体，继承其优势和弱点。
		灵能仓库有位置时才能使用该技能。

		你可以偷取以下阶级生物的身体 %s%s#LAST# 或者更低。
		等级 3 时最多可偷取 %s%s#LAST#.
		等级 5 时最多可偷取 %s%s#LAST#.
		等级 7 时最多可偷取 %s%s#LAST#.

		你可能只会偷走以下类型的生物的尸体 : #LIGHT_BLUE#%s#LAST#
		当你尝试拥有不同类型的生物时，你可以永久学习此类型，你还可以执行 %d 次。]]):
		format(
			t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDamage(self, t)),
			rc0, rt0, rc3, rt3, rc5, rt5, rc7, rt7,
			table.concat(table.append({"humanoid", "animal"}, table.keys(self.possess_allowed_extra_types or {})), ", "), t.allowedTypesExtraNb(self, t)
		)
	end,
}
registerTalentTranslation{
	id = "T_SELF_PERSISTENCE",
	name = "自我坚持",
	info = function (self,t)
		return ([[当你附身时，你还可以保留自己身体的属性 %d%% 。 (闪避, 暴击, 强度, 豁免, ...)]]):
		format(100 - t.getPossessScale(self, t))
	end,
}
registerTalentTranslation{
	id = "T_IMPROVED_FORM",
	name = "身体改进",
	info = function (self,t)
		return ([[当你附身时，你获得身体 %d%% 的数值 (闪避, 暴击, 强度, 豁免, ...)。
		此外，从身体获得的技能等级最高为 %0.1f.]]):
		format(t.getPossessScale(self, t), t.getMaxTalentsLevel(self, t))
	end,
}
registerTalentTranslation{
	id = "T_FULL_CONTROL",
	name = "完全控制",
	info = function (self,t)
		return ([[附身时，可更好的控制身体 :
		- 在等级 1 时，可额外获得一个技能位
		- 在等级 2 时，可额外获得一个技能位
		- 在等级 3 时，可获得抗性和固定减伤
		- 在等级 4 时，可额外获得一个技能位
		- 在等级 5 时，可获得得所有速度（只有当他们优于你时）
		- 在等级 6 以上时，可额外获得一个技能位
		]]):
		format(t.getNbTalents(self, t))
	end,
}
return _M
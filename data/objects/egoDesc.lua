module(..., package.seeall)
_M.egoDescCHN = {}
function registerEgoTranslation(t)
	local file = "/data/general/objects/egos/" .. t.file .. ".lua"
	print("registerEgoTranslation file: ".. file.. " name:" .. t.name)
	if not _M.egoDescCHN[file] then 
		_M.egoDescCHN[file] = {}
	end
	_M.egoDescCHN[file][t.name] = t
end
function _M.fetchEgoTranslation(file,item)
	print("egoDesc:fetchEgoTranslation, file: " .. file .. " name: " .. item.name)
	if not file then return end
	if not item.name then return end
	local t = _M.egoDescCHN[file]
	if not t then return end
	print("egoDesc:fetchEgoTranslation, found: ".. file)
	t = t[item.name]
	if not t then return end
	print("egoDesc:fetchEgoTranslation, found: ".. item.name)
	
	for k, v in pairs(t) do
		local sf = item
		while k:find("%.") do
			l, _ = k:find("%.")
			sf = sf[k:sub(1, l - 1)]
			k = k:sub(l + 1, k:len() )
		end
		sf[k] = v
	end
	
end
function _M:bindHooks()
	print ("egoDesc:bindHooks")
	local class = require "engine.class"
	class:bindHook("Entity:loadList", function (self,data)
		if data.file:find("egos") then
			print("egoDesc:bindHooks, data", data.file)
			for _, item in ipairs(data.res) do
				_M.fetchEgoTranslation(data.file,item)
			end
		end
	end)
end

registerEgoTranslation{
	file = "ammo",
	name = "barbed ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local dam, hf = special.wound(self.combat, who)
				return ("在5回合内造成 #RED#%d#LAST# 物理伤害并降低 %d%% 治疗效果"):format(dam, hf)
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = " of crippling",
	["combat.special_on_crit.desc"] = "致残目标， 降低30% 精神、施法 和攻击速度",
}

registerEgoTranslation{
	file = "ammo",
	name = "acidic ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local dam = special.acid_splash(who)
				return ("用酸液溅对面一脸，在5回合内造成 #VIOLET#%d#LAST# 酸性伤害并降低 #VIOLET#%d#LAST# 点护甲和命中"):format(dam, math.ceil(dam / 8))
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = "arcing ",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.arc(who)
				return ("#LIGHT_GREEN#25%%#LAST# 几率触发连锁闪电，对另一目标造成 #VIOLET#%d#LAST# 伤害"):format(dam)
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = "elemental ",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.explosion(self.combat, who)
				return ("制造元素爆炸，造成 #VIOLET#%d#LAST# %s 伤害 (1次/回合)"):format(dam, self.combat.elemental_element and self.combat.elemental_element[3]:gsub("cold","寒冷"):gsub("fire","火焰"):gsub("lightning","闪电"):gsub("acid","酸性") or "<随机元素>" )
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = " of wind",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.explosion(who)
				return ("#LIGHT_GREEN#20%%#LAST# 几率制造3格范围的空气爆炸，击退敌人2格并造成 #RED#%d#LAST# 物理伤害"):format(dam)
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = " of grasping",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.damage(who)
				return ("#LIGHT_GREEN#20%%#LAST# 几率制造藤曼固定目标，定身3回合，并造成累计 #YELLOW#%d#LAST# 自然伤害。"):format(dam)
			end,
}

registerEgoTranslation{
	file = "ammo",
	name = "inquisitor's ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local manaburn = special.manaburn(who)
				return ("造成 #YELLOW#%d#LAST# 法力燃烧伤害，并使一个随机法术技能进入 #YELLOW#%d#LAST# 回合冷却（需通过混乱免疫）"):
					format(manaburn or 0, 1 + math.ceil(who:combatMindpower() / 20))
			end,
}
registerEgoTranslation{
	file = "ammo",
	name = "of disruption",
	["combat.special_on_hit.desc"] = function(self, who, special)
				return ("使目标有 10%% 几率施法失败，并且每回合有 10%% 几率取消一项魔法持续技能, 可叠加至 50%%"):format()
			end,
}
registerEgoTranslation{
	file = "ammo",
	name = "psychokinetic ",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.psychokinetic_damage(who)
				return ("#LIGHT_GREEN#20%%#LAST# 几率击退3格，并造成 #YELLOW#%d#LAST# 物理伤害"):format(dam)
			end
}
registerEgoTranslation{
	file = "ammo",
	name = " of amnesia",
	["combat.special_on_hit.desc"] = function(self, who, special)
				return ("#LIGHT_GREEN#50%%#LAST# 几率让1个技能进入 #YELLOW#%d#LAST# 回合冷却 (需通过混乱免疫)"):format(1 + math.ceil(who:combatMindpower() / 20))
			end
}
registerEgoTranslation{
	file = "ammo",
	name = " of torment",
	["combat.special_on_hit.desc"] = "#LIGHT_GREEN#20%#LAST# 几率震慑、致盲、定身、混乱 或 沉默目标 3回合", 
}
registerEgoTranslation{
	file = "mindstars",
	name = "inquisitor's ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local manaburn = special.manaburn(who)
				return ("造成 #YELLOW#%d#LAST# 法力燃烧伤害，并使一个随机法术技能进入 #YELLOW#%d#LAST# 回合冷却（需通过混乱免疫）"):
					format(manaburn or 0, 1 + math.ceil(who:combatMindpower() / 20))
			end,
}
registerEgoTranslation{
	file = "mindstars",
	name = " of disruption",
	["combat.special_on_hit.desc"] = function(self, who, special)
				return ("使目标有 10%% 几率施法失败，并且每回合有 10%% 几率取消一项魔法持续技能, 可叠加至 50%%"):format()
			end,
}
registerEgoTranslation{
	file = "ranged",
	name = " of disruption",
	["combat.special_on_crit.desc"] = "沉默目标",
}

registerEgoTranslation{
	file = "shield",
	name = " of winter",
	["on_block.desc"] = function(self, who, special)
			local dam = special.shield_wintry(who)
			return ("造成 #YELLOW#%d#LAST# 寒冷伤害并冻结 4 格内的敌人，定身3回合 (1次/回合)"):format(dam)
		end,
}

registerEgoTranslation{
	file = "shield",
	name = "windwalling ",
}

registerEgoTranslation{
	file = "shield",
	name = "warded ",
	["special_combat.special_on_hit.desc"] = "减少守护技能1回合冷却时间"
}

registerEgoTranslation{
	file = "shield",
	name = "wrathful ",
	["on_block.desc"] = function(self, who, special)
			local dam = special.shield_wrathful(who)
			return ("对被格挡的敌人 造成 #VIOLET#%d#LAST# 光系和火焰伤害"):format(dam)
		end,
}
registerEgoTranslation{
	file = "shield",
	name = " of crushing",
	["special_combat.special_on_crit.desc"] = "猛击目标，降低精神、施法和攻击速度各 30%",
}
registerEgoTranslation{
	file = "shield",
	name = " of shrapnel",
	["on_block.desc"] = function(self, who, special)
			local dam = special.shield_shrapnel(who)
			return ("使6格内的敌人流血 5 回合，造成累计 #RED#%d#LAST# 物理伤害 (1次/回合)"):format(dam)
		end,
}
registerEgoTranslation{
	file = "shield",
	name = " of earthen fury",
	["special_combat.special_on_hit.desc"] = function(self, who, special)
			local dam = who:combatArmor()
			return ("造成等于护甲值的物理伤害 (%d)"):format(dam)
		end,
}

registerEgoTranslation{
	file = "weapon",
	name = " of crippling",
	["combat.special_on_crit.desc"] = "致残目标， 降低30% 精神、施法 和攻击速度",
}
registerEgoTranslation{
	file = "weapon",
	name = " of evisceration",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local dam, hf = special.wound(self.combat, who)
				return ("在5回合内造成 #RED#%d#LAST# 物理伤害并降低 %d%% 治疗效果"):format(dam, hf)
			end
}

registerEgoTranslation{
	file = "weapon",
	name = "acidic ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local dam = special.acid_splash(who)
				return ("用酸液溅对面一脸，在5回合内造成 #VIOLET#%d#LAST# 酸性伤害并降低 #VIOLET#%d#LAST# 点护甲和命中"):format(dam, math.ceil(dam / 8))
			end,
}

registerEgoTranslation{
	file = "weapon",
	name = "arcing ",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.arc(who)
				return ("#LIGHT_GREEN#25%%#LAST# 几率触发连锁闪电，对另一目标造成 #VIOLET#%d#LAST# 伤害"):format(dam)
			end,
}

registerEgoTranslation{
	file = "weapon",
	name = "elemental ",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.explosion(who)
				return ("制造元素爆炸，造成 #VIOLET#%d#LAST# %s 伤害 (1次/回合)"):format(dam, self.combat.elemental_element and self.combat.elemental_element[3]:gsub("cold","寒冷"):gsub("fire","火焰"):gsub("lightning","闪电"):gsub("acid","酸性") or "<随机元素>" )
			end,
}


registerEgoTranslation{
	file = "weapon",
	name = "inquisitor's ",
	["combat.special_on_crit.desc"] = function(self, who, special)
				local manaburn = special.manaburn(who)
				return ("造成 #YELLOW#%d#LAST# 法力燃烧伤害，并使一个随机法术技能进入 #YELLOW#%d#LAST# 回合冷却（需通过混乱免疫）"):
					format(manaburn or 0, 1 + math.ceil(who:combatMindpower() / 20))
			end,
}
registerEgoTranslation{
	file = "weapon",
	name = " of disruption",
	["combat.special_on_hit.desc"] = function(self, who, special)
				return ("使目标有 10%% 几率施法失败，并且每回合有 10%% 几率取消一项魔法持续技能, 可叠加至 50%%"):format()
			end,
}
registerEgoTranslation{
	file = "weapon",
	name = " of projection",
	["combat.special_on_hit.desc"] = function(self, who, special)
				local targets = self.combat.projection_targets
				return ("朝周围7格范围内随机目标投射至多 %d 次攻击，每次造成 30%% 精神武器伤害 (1次/回合)"):format(targets or 0)
			end,
}
registerEgoTranslation{
	file = "weapon",
	name = " of amnesia",
	["combat.special_on_hit.desc"] = function(self, who, special)
				return ("#LIGHT_GREEN#50%%#LAST# 几率让1个技能进入 #YELLOW#%d#LAST# 回合冷却 (需通过混乱免疫)"):format(1 + math.ceil(who:combatMindpower() / 20))
			end
}
registerEgoTranslation{
	file = "weapon",
	name = " of torment",
	["combat.special_on_hit.desc"] = "#LIGHT_GREEN#20%#LAST# 几率震慑、致盲、定身、混乱 或 沉默目标 3回合", 
}
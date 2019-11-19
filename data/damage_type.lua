--转换伤害类型
function getDamageTypeCHN(type)
	if not type then return end
	return damageTypeCHN[type] or type
end



function itemDamagedesc(data)
	if data:find("random insanity") then return data:gsub("chance to cause","几率"):gsub("random insanity","随机疯狂")
	elseif data:find("random gloom") then return data:gsub("chance to cause","几率"):gsub("random gloom","黑暗光环")
	elseif data:find("damage reduction") then return data:gsub("chance to inflict","几率"):gsub("damage reduction","减少对方伤害")
	elseif data:find("10%% of a turn") then return data:gsub("chance to gain","几率获得"):gsub("10%% of a turn","10%%回合"):gsub("(3/turn limit)","(限制3次/回合)")
	elseif data:find("corrode armour") then return  data:gsub("chance to","几率"):gsub("corrode armour","腐蚀护甲"):gsub("by","")
	elseif data:find("blind") then return  data:gsub("chance to","几率"):gsub("blind","致盲")
	elseif data:find("daze") then return  data:gsub("chance to","几率"):gsub("daze","眩晕"):gsub("at end of turn","于回合结束时")
	elseif data:find("disease") then return  data:gsub("chance to","几率"):gsub("disease","疾病")
	elseif data:find("arcane resource") then return  data:gsub("arcane resource","奥术能量"):gsub("burn","燃烧")
	elseif data:find("Slows") then return  data:gsub("Slows global speed by","整体速度减少")
	elseif data:find("blind") then return  data:gsub("chance to","几率"):gsub("blind","致盲")
	elseif data:find("reduce effective powers") then return  data:gsub("chance to","几率"):gsub("reduce effective powers","降低有效强度"):gsub("by","")
	else return data;
	end
end

--冒号后的属性，物品标题黄字属性及白字属性
damageTypeCHN={}
damageTypeCHN["arcane"] = "奥术"
damageTypeCHN["physical"] = "物理"
damageTypeCHN["fire"] = "火焰"
damageTypeCHN["cold"] = "寒冷"
damageTypeCHN["lightning"] = "闪电"
damageTypeCHN["acid"] = "酸性"
damageTypeCHN["nature"] = "自然"
damageTypeCHN["blight"] = "枯萎"
damageTypeCHN["light"] = "光系"
damageTypeCHN["darkness"] = "暗影"
damageTypeCHN["mind"] = "精神"
damageTypeCHN["winter"] = "寒冬"
damageTypeCHN["temporal"] = "时空"
damageTypeCHN["temporal stun"] = "时空震慑"
damageTypeCHN["dreamforge"] = "梦之熔炉"
damageTypeCHN["crippling poison"] = "致残毒素"
damageTypeCHN["lite"] = "光照"
damageTypeCHN["illumination"] = "侦测潜行"
damageTypeCHN["break stealth"] = "侦测潜行"
damageTypeCHN["silence"] = "沉默"
damageTypeCHN["gloom"] = "黑暗光环"
damageTypeCHN["blindness"] = "致盲"
damageTypeCHN["blinding ink"] = "墨汁致盲"
damageTypeCHN["shadowflame"] = "暗影烈焰"
damageTypeCHN["cold"] = "寒冷"
damageTypeCHN["flameshock"] = "烈焰冲击"
damageTypeCHN["ice"] = "寒冰"
damageTypeCHN["ice storm"] = "冰风暴"
damageTypeCHN["glacial vapour"] = "极寒冰雾"
damageTypeCHN["cold ground"] = "冻足"
damageTypeCHN["freeze"] = "冰冻"
damageTypeCHN["sticky smoke"] = "浓烟"
damageTypeCHN["acid blind"] = "酸性致盲"
damageTypeCHN["acidblind"] = "酸性致盲"
damageTypeCHN["blinding darkness"] = "致盲暗影" 
damageTypeCHN["burning repulsion"] = "灼烧排斥"
damageTypeCHN["darkness repulsion"] = "暗影击退"
damageTypeCHN["fear repulsion"] = "恐惧击退"
damageTypeCHN["poison"] = "毒素"
damageTypeCHN["cleansing fire"] = "火焰净化"
damageTypeCHN["spydric poison"] = "蜘蛛毒素"
damageTypeCHN["insidious poison"] = "阴险毒素"
damageTypeCHN["bleed"] = "流血" 
damageTypeCHN["dig"] = "挖掘"
damageTypeCHN["slow"] = "减速"
damageTypeCHN["time prison"] = "时间囚牢"
damageTypeCHN["confusion"] = "混乱"
damageTypeCHN["% chance of confusion"] = "混乱"
damageTypeCHN["blinding physical"] = "物理致盲"
damageTypeCHN["physical pinning"] = "物理定身"
damageTypeCHN["regressive blight"] = "枯萎退化/经验吸取"
damageTypeCHN["draining blight"] = "枯萎吸收/生命吸取"
damageTypeCHN["vim draining blight"] = "枯萎衰亡/活力吸取"
damageTypeCHN["demonfire"] = "恶魔烈焰"
damageTypeCHN["purging blight"] = "枯萎净化"
damageTypeCHN["holy light"] = "圣光"
damageTypeCHN["healing"] = "治疗"
damageTypeCHN["healing light"] = "治疗之光"
damageTypeCHN["infective blight"] = "枯萎感染"
damageTypeCHN["hindering_blight"] = "枯萎阻碍"
damageTypeCHN["life leech"] = "吸血"
damageTypeCHN["physical stun"] = "物理震慑"
damageTypeCHN["temporal shear"] = "时空切断"
damageTypeCHN["gravity"] = "重力"
damageTypeCHN["gravitypin"] = "重力定身"
damageTypeCHN["repulsion"] = "排斥"
damageTypeCHN["grow"] = "生长"
damageTypeCHN["sanctity"] = "神圣"
damageTypeCHN["defensive darkness"] = "阴影防御"
damageTypeCHN["blazing light"] = "光炽"
damageTypeCHN["prismatic repulsion"] = "防护排斥"
damageTypeCHN["batter"] = "猛击"
damageTypeCHN["mind slow"] = "精神减速"
damageTypeCHN["mind freeze"] = "精神冻结"
damageTypeCHN["implosion"] = "爆裂"
damageTypeCHN["clock"] = "时钟"
damageTypeCHN["wasting temporal"] = "时空耗竭"
damageTypeCHN["stop"] = "静止"
damageTypeCHN["debilitating temporal"] = "时空虚弱"
damageTypeCHN["temporal echo"] = "时空回响"
damageTypeCHN["draining physical"] = "物理吸收"
damageTypeCHN["temporal slow"] = "时空减速"
damageTypeCHN["molten rock"] = "熔岩"
damageTypeCHN["entangle"] = "困惑"
damageTypeCHN["manaworm arcane"] = "法力蠕虫"
damageTypeCHN["arcane blast"] = "奥术爆炸"
damageTypeCHN["circle of death"] = "死亡法阵"
damageTypeCHN["decaying darkness"] = "暗影虚弱"
damageTypeCHN["abyssal darkness"] = "暗影深渊"
damageTypeCHN["Garkul spirit"] = "加库克之魂"
damageTypeCHN["nightmare"] = "噩梦"
damageTypeCHN["weakness"] = "虚弱"
damageTypeCHN["special effect"] = "特效"
damageTypeCHN["bright light"] = "强光"
damageTypeCHN["manaburn arcane"] = "法力燃烧"
damageTypeCHN["gravity pin"] = "重力定身"
damageTypeCHN["fire burn"] = "火焰燃烧"
damageTypeCHN["nature slow"] = "自然减速"
damageTypeCHN["temporal darkness"] = "幽暗虚空"
damageTypeCHN["infective blight"] = "枯萎传染"
damageTypeCHN["blinding"] = "致盲"
damageTypeCHN["blinding light"] = "致盲之光"
damageTypeCHN["dazing lightning"] = "闪电眩晕"
damageTypeCHN["physical bleed"] = "物理流血"
damageTypeCHN["pinning nature"] = "自然定身"
damageTypeCHN["healing nature"] = "自然治疗"
damageTypeCHN["impeding nature"] = "自然障碍"
damageTypeCHN["confounding nature"] = "自然混乱"
damageTypeCHN["cold repulsion"] = "寒冷排斥"
damageTypeCHN["fire repulsion"] = "火焰击退"
damageTypeCHN["regressive temporal"] = "时空退化"
damageTypeCHN["distorting physical"] = "物理扭曲"
damageTypeCHN["natural mucus"] = "自然粘液"
damageTypeCHN["disarming acid"] = "酸性缴械"
damageTypeCHN["bloodspring"] = "血如泉涌"
damageTypeCHN["corrosive acid"] = "腐蚀之酸"
damageTypeCHN["physical repulsion"] = "物理排斥"
damageTypeCHN["slowing ice"] = "冰系减速"
damageTypeCHN["stunning fire"] = "火焰震慑"
damageTypeCHN["phase pulse"] = "相位脉动"
damageTypeCHN["frozen earth"] = "冻结大地"
damageTypeCHN["#YELLOW#Lite Light#LAST# Burst (radius 1)"] = "#YELLOW#光照#LAST#爆发（范围 1）"


damageTypeCHN["item mind gloom"] = "黑暗光环"
damageTypeCHN["item darkness numbing"] = "黑暗麻木"
damageTypeCHN["item temporal energize"] = "时空充能"
damageTypeCHN["item acid corrode"] = "腐蚀护甲"
damageTypeCHN["item light blind"] = "致盲"
damageTypeCHN["item lightning daze"] = "眩晕"
damageTypeCHN["item blight disease"] = "疾病"
damageTypeCHN["item manaburn arcane"] = "法力燃烧"
damageTypeCHN["item nature slow"] = "减速"
damageTypeCHN["% chance of gloom effects"]="%几率黑暗光环"
damageTypeCHN["dark light"] = "黑暗之光"

function getSpecialCombatDesc(type)
	if not type then return end
	if damageSpecialDesc[type] then return damageSpecialDesc[type] end
	return nil
end


damageSpecialDesc = {}
damageSpecialDesc["ITEM_DARKNESS_NUMBING"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 1, 35))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率减少 #YELLOW#%d%%#LAST#伤害 %s  ")
			:format(dam, val, parens)
	end

damageSpecialDesc["ITEM_MIND_EXPOSE"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 1, 45))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率减少 #YELLOW#%d#LAST#%s 闪避和豁免")
			:format(dam, val, parens)
	end

damageSpecialDesc["ITEM_TEMPORAL_ENERGIZE"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率获得 10%% 回合 (3次上限/回合) %s")
			:format(dam, parens)
	end
	
damageSpecialDesc["ITEM_ACID_CORRODE"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and src:combatStatScale(src:combatSpellpower(), 10, 45)+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST#几率减少 #VIOLET#%d%%#LAST#护甲%s ")
			:format(dam, val, parens)
	end
	
damageSpecialDesc["ITEM_BLIGHT_DISEASE"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatSpellpower(), 1, 35))+5 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST#几率减少力量、体质和敏捷各 #VIOLET#%d#LAST# 点 %s ")
			:format(dam, val, parens )
	end

damageSpecialDesc["ITEM_ANTIMAGIC_MANABURN"] = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d#LAST#)"):format(diff)
			end
		end
		return ("* #DARK_ORCHID#%d 法力燃烧 #LAST# %s")
			:format(dam or 0, parens)
	end
	
damageSpecialDesc["ITEM_NATURE_SLOW"] = function(dam, oldDam, src)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		local val = src and math.floor(src:combatStatScale(src:combatMindpower(), 20, 70))+10 or 0
		return ("* #LIGHT_GREEN#%d%%#LAST#几率减速 #YELLOW#%d%%#LAST#%s")
			:format(dam or 0, val, parens)
	end

damageSpecialDesc["ITEM_ANTIMAGIC_SCOURING"] = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率 #ORCHID#减少有效强度#LAST# %d%%%s ")
			:format(dam, 20, parens)
	end
	
damageSpecialDesc["ITEM_LIGHTNING_DAZE"] = 
	function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率在回合结束时 #ROYAL_BLUE#眩晕#LAST# %s")
			:format(dam, parens)
	end
	
damageSpecialDesc["ITEM_LIGHT_BLIND"] = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率#YELLOW#致盲#LAST#%s")
			:format(dam, parens)
	end
	
damageSpecialDesc["ITEM_MIND_GLOOM"] = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率触发 #YELLOW#黑暗光环#LAST#%s")
			:format(dam, parens)
	end

damageSpecialDesc["PESTILENT_BLIGHT"] = function(dam, oldDam)
		parens = ""
		dam = dam or 0
		if oldDam then
			diff = dam - oldDam
			if diff > 0 then
				parens = (" (#LIGHT_GREEN#+%d%%#LAST#)"):format(diff)
			elseif diff < 0 then
				parens = (" (#RED#%d%%#LAST#)"):format(diff)
			end
		end
		return ("* #LIGHT_GREEN#%d%%#LAST# 几率触发 #GREEN#随机枯萎#LAST#%s")
			:format(dam, parens)
	end
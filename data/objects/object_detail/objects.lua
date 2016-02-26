objects={}
objectN = {}
objectU = {}
objectG = {}
objectS = {}
objectW = {}

objectSP = {}

objCHN = {}

require "data-chn123.objects.object_detail.egos"

function objects:addObjects(objects)
	if not objects then return end
	if objects.unique then
		objectU[objects.enName] = objects
	else
		if objects.subtype == "white" or objects.subtype == "red" or objects.subtype == "yellow" or objects.subtype == "green" or objects.subtype == "blue" or objects.subtype == "black" or objects.subtype == "violet" then
			objectG[objects.enName] = objects
		elseif objects.subtype == "infusion" or objects.subtype == "rune" or objects.subtype == "taint" or objects.subtype == "scroll" or objects.subtype == "lore" or objects.subtype == "implant"then
			objectS[#objectS+1] = objects
		elseif objects.subtype == "wand" then
			objectW[#objectW+1] = objects
		elseif objects.sName then
			if not objectN[objects.subtype] then
				objectN[objects.subtype] = {}
			end
				objectN[objects.subtype][objects.sName] = objects
		else
			if not objectSP[objects.subtype] then
				objectSP[objects.subtype] = {}
			end
				objectSP[objects.subtype][objects.enName] = objects
		end
	end
end

function objects:getObjectsChnName(name)
	return name
end

function objects:getObjects(name,desc,subtype,short_name,is_ided,rare,unique)
	if not name then return end

	local o = {}
	--o.name = name:gsub("%(.+","")
	o.name = name
	o.enName = o.name		
	o.chName = ""
	o.unIdedName = ""
	o.desc = desc
	o.is_ided = is_ided
	if type == "seed" or subtype == "demon" then
		o.chName = o.name:gsub("demon seed","恶魔种子"):gsub("level","等级"):gsub("finger","手指"):gsub("body","躯干"):gsub("mainhand","主手"):gsub("offhand","副手"):gsub("fire imp","火魔婴"):gsub("wretchling","酸液树魔"):gsub("quasit","夸塞魔"):gsub("water imp","小水怪"):gsub("dolleg","多累格"):gsub("dúathedlen","多瑟顿"):gsub("uruivellas","乌尔维拉斯"):gsub("thaurhereg","修尔希瑞格"):gsub("daelach","达莱奇"):gsub("wretch titan","腐烂泰坦"):gsub("forge%-giant","锻造巨人"):gsub("champion of Urh'Rok","乌鲁洛克精锐")
		o.desc = [[恶魔之种]]
	elseif subtype == "money" then
        o.chName = o.name:gsub("huge pile of gold pieces", "一大袋金币"):gsub("gold pieces", "一堆金币")
        o.desc = [[发光的不总是金子，是金子不总会发光。]]
	elseif objectU[o.enName] then
		if o.is_ided then
			o.chName = objectU[o.enName].chName
			o.unIdedName = objectU[o.enName].unIdedName
			o.desc = objectU[o.enName].chDesc
		else
			o.chName = objectU[o.enName].unIdedName
			o.unIdedName = objectU[o.enName].unIdedName
			o.desc = objectU[o.enName].chDesc
		end
	else
		if rare then
			o.chName = "稀有" .. (objectSType[subtype] or subtype) .. "★" .. name .. "★"
		elseif unique then
			o.chName = "传奇" .. (objectSType[subtype] or subtype) .. "★" .. name .. "★"
		elseif subtype == "white" or subtype == "red" or subtype == "yellow" or subtype == "green" or subtype == "blue" or subtype == "black" or subtype == "violet" then
			if objectG[o.enName] then
				o.chName = objectG[o.enName].chName
				o.desc = objectG[o.enName].chDesc
			end
		elseif subtype == "infusion" or subtype == "rune" or subtype == "taint" or subtype == "scroll" or subtype == "lore" or subtype == "implant" then
			for i = 1,#objectS do
				if string.find(o.name,objectS[i].enName) then
					local enName = objectS[i].enName
					local chName = objectS[i].chName
					local prefix = o.name:match("(.+)"..enName)
					local suffix = o.name:match(enName.."(.+)")
					
					o.chName = chName
					if egosCHN[suffix] then o.chName = egosCHN[suffix]..chName end
					if egosCHN[prefix] then o.chName = egosCHN[prefix]..o.chName end
					
					o.desc = objectS[i].chDesc
				end
			end
		elseif subtype == "wand" then
			for i = 1,#objectW do
				if o.name:find(objectW[i].enName) then
					local enName = objectW[i].enName
					local chName = objectW[i].chName
					local prefix = o.name:match("(.+)"..enName)
					local suffix = o.name:match(enName.."(.+)")
					
					o.chName = chName
					if egosCHN[suffix] then o.chName = egosCHN[suffix]..chName end
					if egosCHN[prefix] then o.chName = egosCHN[prefix]..o.chName end
					
					o.desc = objectW[i].chDesc
				elseif o.name:find(objectW[i].chName) then
					local chName = objectW[i].chName
					local prefix = o.name:match("(.+)"..chName)
					local suffix = o.name:match(chName.."(.+)")
					
					o.chName = chName
					if egosCHN[suffix] then o.chName = egosCHN[suffix]..chName end
					if egosCHN[prefix] then o.chName = egosCHN[prefix]..o.chName end
					
					o.desc = objectW[i].chDesc
				end
			end
		elseif subtype == "schematic" then
					o.chName = "配方："..tinkerCHN:getname(name:gsub("schematic: ",""))
					o.desc = "配方被工匠用于制作新的发明。"
		else
			if objectSP[subtype] then
				if objectSP[subtype][name] then
					o.chName = objectSP[subtype][name].chName
					o.desc = objectSP[subtype][name].chDesc
				end
			end
			if objectN[subtype] then
				if objectN[subtype][short_name] then
					local enName = objectN[subtype][short_name].enName
					local chName = objectN[subtype][short_name].chName
					
					--法杖变换
					if subtype == "staff" then
						local meta = enName:match("(.+) staff")
						if o.name:find(" magestaff") then
							chName = chName .. "（术士）"
							enName = meta .. " magestaff"
						elseif o.name:find(" starstaff") then
							chName = chName .. "（众星）"
							enName = meta .. " starstaff"
						elseif o.name:find(" vilestaff") then
							chName = chName .. "（邪恶）"
							enName = meta .. " vilestaff"
						end
					end
					
					local prefix = o.name:match("(.+)"..enName)
					if subtype == "shot" and prefix then prefix = prefix:gsub("pouch of ","") 
					elseif subtype == "arrow" and prefix then prefix = prefix:gsub("quiver of ","") end 
					local suffix = o.name:match(enName.."([^()]+)")
					if subtype == "torque" then
						if name:find("portation") then suffix = " of psychoportation"
						elseif name:find("kinetic") then suffix = " of kinetic psionic shield"
						elseif name:find("thermal") then suffix = " of thermal psionic shield"
						elseif name:find("charged") then suffix = " of charged psionic shield"
						elseif name:find("clear mind") then suffix = " of clear mind"
						elseif name:find("mindblast") then suffix = " of mindblast"
						end
						if name:find("quiet") then prefix = "quiet "
						end
					end

					--local unique_name = o.name:match("'(.+)'")
					--if suffix then
						--if unique_name then suffix = suffix:gsub(" '.+","") end
						--suffix = suffix:gsub("%(.+","")
					--end
					
					o.unIdedName = chName
					--if unique_name and not unique_name:find("alchemist") then o.chName = chName .. "（" .. unique_name .. "）"
					--elseif unique then o.chName = chName .. "（" .. o.name:gsub("%(","") .. "）"
					--else o.chName = chName
					--end
					o.chName = chName

					if subtype == "shot" or subtype == "arrow" then o.chName = "一袋"..o.chName end
					if egosCHN[prefix] then o.chName = egosCHN[prefix]..o.chName end
					if egosCHN[suffix] then o.chName = egosCHN[suffix]..o.chName end
					
					--o.chName= name

					local special = o.name:match("([()].+[()])")
					if special then special=special:gsub("Corpses","尸体"):gsub("Nightmares","噩梦"):gsub("Misfortune","不幸"):gsub("Shrouds","屏障"):gsub("Madness","疯狂") end
					if special then o.chName = o.chName..special end
					o.desc = objectN[subtype][short_name].chDesc
				end
			end	
		end
	end
	return o
end

dofile("data-chn123/objects/object_detail/world-artifacts.lua")
dofile("data-chn123/objects/object_detail/2haxes.lua")
dofile("data-chn123/objects/object_detail/2hmaces.lua")
dofile("data-chn123/objects/object_detail/2hswords.lua")
dofile("data-chn123/objects/object_detail/2htridents.lua")
dofile("data-chn123/objects/object_detail/axes.lua")
dofile("data-chn123/objects/object_detail/bows.lua")
dofile("data-chn123/objects/object_detail/brotherhood-artifacts.lua")
dofile("data-chn123/objects/object_detail/cloak.lua")
dofile("data-chn123/objects/object_detail/cloth-armors.lua")
dofile("data-chn123/objects/object_detail/digger.lua")
dofile("data-chn123/objects/object_detail/gauntlets.lua")
dofile("data-chn123/objects/object_detail/gem.lua")
dofile("data-chn123/objects/object_detail/gloves.lua")
dofile("data-chn123/objects/object_detail/heavy-armors.lua")
dofile("data-chn123/objects/object_detail/heavy-boots.lua")
dofile("data-chn123/objects/object_detail/helms.lua")
dofile("data-chn123/objects/object_detail/knifes.lua")
dofile("data-chn123/objects/object_detail/leather-belt.lua")
dofile("data-chn123/objects/object_detail/jewelry.lua")
dofile("data-chn123/objects/object_detail/leather-boots.lua")
dofile("data-chn123/objects/object_detail/leather-caps.lua")
dofile("data-chn123/objects/object_detail/light-armors.lua")
dofile("data-chn123/objects/object_detail/lites.lua")
dofile("data-chn123/objects/object_detail/maces.lua")
dofile("data-chn123/objects/object_detail/massive-armors.lua")
dofile("data-chn123/objects/object_detail/potions.lua")
dofile("data-chn123/objects/object_detail/scrolls.lua")
dofile("data-chn123/objects/object_detail/mummy-wrappings.lua")
dofile("data-chn123/objects/object_detail/quest-artifacts.lua")
dofile("data-chn123/objects/object_detail/shields.lua")
dofile("data-chn123/objects/object_detail/slings.lua")
dofile("data-chn123/objects/object_detail/staves.lua")
dofile("data-chn123/objects/object_detail/swords.lua")
dofile("data-chn123/objects/object_detail/wands.lua")
dofile("data-chn123/objects/object_detail/wizard-hat.lua")
dofile("data-chn123/objects/object_detail/mindstars.lua")
dofile("data-chn123/objects/object_detail/rods.lua")
dofile("data-chn123/objects/object_detail/torques.lua")
dofile("data-chn123/objects/object_detail/totems.lua")
--orc DLC
dofile("data-chn123/objects/object_detail/orc_dlc/inscriptions.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/leather-hats.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/schematics.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/steamgun.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/steamsaw.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers.lua")
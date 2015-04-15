function logCHN:getName(name)
	name = npcCHN:getName(name)
	name = trapCHN:getName(name) 
	if name:find(" from ") then
		local f,e=name:find(" from ")
		local teffect=name:sub(1,f-1)
		local tname = name:gsub(" from ",""):gsub(teffect,"")
		tname = npcCHN:getName(tname)
		tname = trapCHN:getName(tname)
		teffect = timeEffectCHN:getName(teffect)
		name = tname  .."的" .. teffect .."效果"
	else if name:find("'s ") then
		local f,e=name:find("'s ")
		local tname=name:sub(1,f-1)
		local ename=name:sub(e+1,string.len(name))
		tname = npcCHN:getName(tname)
		ename = trapCHN:getName(ename)
		name = tname.."的"..ename
		end
	end
	name = name:gsub("unknown","未知对象"):gsub("something","某物"):gsub("area","区域"):gsub("effect","效果")
		   :gsub("Temporal Restoration Field","时间储能")
		   :gsub("creeping dark","黑暗之雾"):gsub("poisoned deep water","有毒的水"):gsub("unstable sand tunnel","不稳定的沙通道")
	return name
end


local lruCache = require "data-chn123.cache.LruCache"

local cache = lruCache.new(100)

function logCHN:getName(name)
	local hit = cache:get(name)
	if(hit) then
		return hit
	end

	local oldName = name
	name = npcCHN:getNameOld(name)
    if name:find(" from ") then
        local f,e=name:find(" from ")
        local teffect=name:sub(1,f-1)
        local teffectt = teffect
		local tname = name:sub(e + 1,string.len(name))
        local hit2 = cache:get(tname)
        if hit2 then tname = hit2
        else
            local tnamet = tname
            tname = npcCHN:getNameOld(tname)
            cache:set(tnamet, tname)
        end
		tname = trapCHN:getName(tname)
		teffect = timeEffectCHN:getName(teffect)
        if teffect == teffectt and tname == tnamet then
            name = oldName
        else
            name = tname  .."的" .. teffect .."效果"
        end
	else if name:find("'s ") then
		local f,e=name:find("'s ")
		local tname=name:sub(1,f-1)
		local ename=name:sub(e+1,string.len(name))
        local tnamet = tname
		local enamet = ename
        local hit2 = cache:get(tname)
        if hit2 then tname = hit2 else
            tname = npcCHN:getNameOld(tname)
            cache:set(tnamet, tname)
        end
		ename = projectileCHN:getName(ename)
		ename = trapCHN:getName(ename)
		if ename == enamet and tname == tnamet then
			name = oldName
		else
			name = tname.."的"..ename
		end
		end
	end
	name = projectileCHN:getName(name)
	name = trapCHN:getName(name)
	name = name:gsub("unknown","未知对象"):gsub("something","某物"):gsub("area","区域"):gsub("effect","效果")
		   :gsub("Temporal Restoration Field","时间储能")
		   :gsub("creeping dark","黑暗之雾"):gsub("poisoned deep water","有毒的水"):gsub("unstable sand tunnel","不稳定的沙通道")
		   :gsub("Throwing Knife","飞刀"):gsub("Fan of Knives","刀扇"):gsub("worm","蠕虫")

	cache:set(oldName, name)
	return name
end


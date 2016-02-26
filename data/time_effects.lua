timeEffectCHN = {}
effCHN = {}
effName = {}

function timeEffectCHN:newEffect(e)
	if not e then return end
	if not e.id then return end
	effCHN[e.id] = e
	effName[e.enName] = e.chName
end

function timeEffectCHN:getName(e)
	if effName[e] then return effName[e] 
        else return e end
end

dofile("data-chn123/time_effects/magical.lua")
dofile("data-chn123/time_effects/mental.lua")
dofile("data-chn123/time_effects/physical.lua")
dofile("data-chn123/time_effects/other.lua")
dofile("data-chn123/time_effects/floor.lua")
dofile("data-chn123/time_effects/dlc.lua")

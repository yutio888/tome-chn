logCHN = {}
logTableCHN = {}
--logCount = 0

function logCHN:newLog(l)
	if not l then return end
	--if logTableCHN[l.log] then print(l.log .."重复了！") end
	--logCount = logCount + 1
	--print ("LOG总数："..logCount)
	logTableCHN[l.log] = l
end

dofile("data-chn123/logs/chat.lua")
dofile("data-chn123/logs/class.lua")
dofile("data-chn123/logs/damage_type.lua")
dofile("data-chn123/logs/general.lua")
dofile("data-chn123/logs/objects.lua")
dofile("data-chn123/logs/quests.lua")
dofile("data-chn123/logs/talents.lua")
dofile("data-chn123/logs/time_effect_magical.lua")
dofile("data-chn123/logs/time_effect_mental.lua")
dofile("data-chn123/logs/time_effect_other.lua")
dofile("data-chn123/logs/time_effect_physical.lua")
dofile("data-chn123/logs/zones.lua")
dofile("data-chn123/logs/engine.lua")
dofile("data-chn123/logs/traps.lua")
dofile("data-chn123/logs/dlc.lua")

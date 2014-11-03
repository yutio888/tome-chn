talentCHN = {}
talentInfoCHN = {}
function talentCHN:getinfo(id,self,t)
	if talentInfoCHN[id] then 
		return talentInfoCHN[id](self,t)
	end
end

dofile("data-chn123/talents/corruptions/corruptions.lua")
dofile("data-chn123/talents/misc/misc.lua")
dofile("data-chn123/talents/gifts/gifts.lua")
dofile("data-chn123/talents/spells/spells.lua")

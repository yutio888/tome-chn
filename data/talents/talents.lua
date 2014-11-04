t_talent_name = t_talent_name or {}
t_talent_type_name = t_talent_type_name or {}
t_talent_type_description = t_talent_type_description or {}
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

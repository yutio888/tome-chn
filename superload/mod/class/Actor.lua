
local _M = loadPrevious(...)

local old_getEncumberTitleUpdator = _M.getEncumberTitleUpdator

function _M:getEncumberTitleUpdator(title)
	local x = old_getEncumberTitleUpdator(self, title)
	return function()
	 	return x():gsub(self:transmoGetName(), "转化之盒")
		:gsub("Inventory", "背包")
		:gsub("Pickup", "捡拾物品")
		:gsub("Drop object", "丢弃物品")
		:gsub("Wield/wear object", "穿戴物品")
		:gsub("Take off object", "脱下物品")
		:gsub("Use object", "使用物品")
		:gsub("Equipment", "装备")
		:gsub("Encumbrance", "负重")
	end
end

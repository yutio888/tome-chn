local class = require "engine.class"

dofile("data-chn123/objects/change.lua")


local function talentstrans()
	dofile("data-chn123/load_utils.lua")
	dofile("data-chn123/talents/talents.lua")

	local loreC = require "data-chn123.lore"
	loreC:loadDefinition("/data-chn123/lore/lore.lua")

	local achievementC = require "data-chn123.achievements"
	achievementC:loadDefinition("/data-chn123/achievements/achievements.lua")
end
class:bindHook("ToME:load", talentstrans)

class:bindHook("ToME:load", function()
	local InvenUITrans = {}
	InvenUITrans["weapons"] = "各种武器"
	InvenUITrans["armors"] = "各种护甲"
	InvenUITrans["jewelry"] = "戒指与项链"
	InvenUITrans["gems"] = "宝石"
	InvenUITrans["inscriptions"] = "纹身、符文等…"
	InvenUITrans["tinker"] = "配件"
	InvenUITrans["misc"] = "杂项"
	InvenUITrans["quests"] = "剧情物品"
	InvenUITrans["transmo"] = "转化之盒"
	InvenUITrans["all"] = "全部"

	local InventoryUI = require "engine.ui.Inventory"
	local InvenUIOld = InventoryUI.default_tabslist
	InventoryUI.default_tabslist = function(self)
		local tabslist = {}
		tabslist = InvenUIOld(self)
		for i, e in ipairs(tabslist) do
			e.desc = InvenUITrans[e.kind] or e.desc
		end
		return tabslist
	end
end)
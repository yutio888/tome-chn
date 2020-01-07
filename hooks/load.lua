local class = require "engine.class"

dofile("data-chn123/objects/change.lua")

core.display.breakTextAllCharacter(true)

require("data-chn123.escorts").bindHooks()

local function hookLoad()
	dofile("data-chn123/load_utils.lua")
	dofile("data-chn123/talents/talents.lua")

	local loreC = require "data-chn123.lore"
	loreC:loadDefinition("/data-chn123/lore/lore.lua")

	local achievementC = require "data-chn123.achievements"
	achievementC:loadDefinition("/data-chn123/achievements/achievements.lua")

	local ActorResource = require "engine.interface.ActorResource"
	local steam_def = ActorResource.resources_def.steam
	if steam_def then
		steam_def.name = "蒸汽值"
		steam_def.description = "你的蒸汽存量。蒸汽用于驱动各种技术产品。很难提升你的最大蒸汽储量，但蒸汽可以被快速补充。"
	end
	local insanity_def = ActorResource.resources_def.insanity
	if insanity_def then
		insanity_def.name = "疯狂值"
		insanity_def.description = "你的精神的疯狂程度。 这一数值越高，你的技能的冷却时间和所造成的伤害随机性就越大。\n\n伤害和冷却时间将会在 混沌度% 的范围内上下浮动。\n\n浮动的几率和浮动的效果都会随疯狂值提升而上升。"
		insanity_def.status_text = function(act)
			return ("%d%%%% (%d%%%% 混沌度)"):format(act:getInsanity(), act:insanityEffectForce())
		end
	end

end
class:bindHook("ToME:load", hookLoad)

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
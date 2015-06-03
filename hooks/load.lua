local class = require "engine.class"
dofile("data-chn123/objects/change.lua")
local function talentstrans()
	dofile("data-chn123/load_utils.lua")
	dofile("data-chn123/talents/talents.lua")

	local loreC = require "data-chn123.lore"
	loreC:loadDefinition("/data-chn123/lore/lore.lua")
end
class:bindHook("ToME:load", talentstrans)

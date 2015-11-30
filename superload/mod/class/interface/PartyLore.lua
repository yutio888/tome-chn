
local _M = loadPrevious(...)
local loreC = require "data-chn123.lore"
local r = require "data-chn123.rewrite_descriptor"

local slt2 = require "slt2"
local chn123_old_getLore = _M.getLore

function _M:getLore(lore, silent)
	r.rewrite()
	l = chn123_old_getLore(self, lore, silent)
	if l == nil then return nil end
	l.chn_translated = false
	if loreC.loreCHN[l.id] then
		l.name = loreC.loreCHN[l.id].name
		l.lore = loreC.loreCHN[l.id].lore
		if l.template then
			local tpl = slt2.loadstring(l.lore)
			l.lore = slt2.render(tpl, {player=self:findMember{main=true}, self=self})
		end
		l.chn_translated = true
	end
	if l.category == "artifacts" then l.chn_translated = true end
	r.recover()
	return l
end

return _M


local _M = loadPrevious(...)

local slt2 = require "slt2"
local chn123_old_getLore = _M.getLore

function _M:getLore(lore, silent)
	l = chn123_old_getLore(self, lore, silent)
	l.chn_translated = false
	if loreCHN[l.id] then
		l.name = loreCHN[l.id].name
		l.lore = loreCHN[l.id].lore
		if l.template then
			local tpl = slt2.loadstring(l.lore)
			l.lore = slt2.render(tpl, {player=self:findMember{main=true}, self=self})
		end
		l.chn_translated = true
	end
	if l.category == "artifacts" then l.chn_translated = true end
	return l
end

return _M

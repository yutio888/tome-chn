local _M = loadPrevious(...)

local init = _M.init
function _M:init(...)
	init(self, ...)

	game:onTickEnd(function() self:simpleLongPopup(_t"Chinese translation outdated!", _t"Remove the translation addon, then go to Option-Language and select Chinese!", 500) end)
end

return _M
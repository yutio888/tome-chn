require "data-chn123.bignews"

local _M = loadPrevious(...)

local chn123_old_say = _M.say

function _M:say(time, txt, ...)
    local t = bignews_translation[txt] or txt
	return chn123_old_say(self, time, t, ...)
end

local chn123_old_saySimple = _M.saySimple

function _M:saySimple(time, txt, ...)
    local t = bignews_translation[txt] or txt
	return chn123_old_saySimple(self, time, t, ...)
end

return _M

require "data-chn123.bignews"

local _M = loadPrevious(...)

local chn123_old_say = _M.say

function _M:say(time, txt, ...)
	return chn123_old_say(self, time, bigNewsCHN:getLog(txt, ...) )
end

local chn123_old_saySimple = _M.saySimple

function _M:saySimple(time, txt, ...)
	return chn123_old_saySimple(self, time, bigNewsCHN:getLog(txt, ...) )
end

return _M

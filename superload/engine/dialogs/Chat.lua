require "data-chn123.npc_name"

local _M = loadPrevious(...)

local chn123_old_init = _M.init

function _M:init(chat, id)
	local chn123_old_name = chat.npc.name
	chat.npc.name = npcCHN:getName(chat.npc.name)
	chn123_old_init(self, chat, id)
	chat.npc.name = chn123_old_name
end

return _M
-- Banned
-- dangerous, use it carefully or it may damage the save file
module(..., package.seeall, class.make)

local old_descriptor = {}
local rewrite = function(field)
--	old_descriptor[field] = game.player.descriptor[field]
--	game.player.descriptor[field] = s_stat_name[game.player.descriptor[field] ] or game.player.descriptor[field]
end
local recover = function(field)
--	game.player.descriptor[field] = old_descriptor[field]
end
function _M.rewrite()
--	rewrite("race")
--	rewrite("subrace")
--	rewrite("subclass")
end
function _M.recover()
--	recover("race")
--	recover("subrace")
--	recover("subclass")
end
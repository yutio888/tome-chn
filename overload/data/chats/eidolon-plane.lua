-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

if game.zone.from_farportal then

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前的虚无之中站着一个人形的东西。它似乎在盯着你看。*#WHITE#
我是艾德隆，你在这里不受欢迎!
不论你怎样来到这里, #{bold}#不要再来!
快滚!
#{normal}#
.]],
	answers = {
		{"...", action=function() game.level.data.eidolon_exit(false) end},
	}
}


else

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前的虚无之中站着一个人形的东西。它似乎在盯着你看。 *
在你死亡的瞬间我把你带到这里，我是灵魂幻象。
我一直在注视着你，观察你的价值还有你的未来。
你可以在这里休息一会，当你准备好时，我可以送你回到你原来所在的物质世界。
不过不要滥用我给你的帮助，我可不是你的仆人，也许有一天我也会让你死去。
也许你有很多问题要问，不过我不会回答，我可以帮助你，但我不是来给你解释为什么的。]],
	answers = {
		{"谢谢你，我在这里休息一会。"},
		{"谢谢你，我已经准备好回去了。",
			cond=function() return game.level.source_level and not game.level.source_level.no_return_from_eidolon end,
			action=function() game.level.data.eidolon_exit(false) end
		},
		{"谢谢你，不过我回去也是死，能不能送我到别的地方？",
			cond=function() return game.level.source_level and not game.level.source_level.no_return_from_eidolon and (not game.level.source_level.data or not game.level.source_level.data.no_worldport) end,
			action=function() game.level.data.eidolon_exit(true) end
		},
		{"谢谢你，不过我回去也是死，能不能送我到这一层的别的地方？",
			cond=function() return game.level.source_zone and game.level.source_zone.infinite_dungeon end,
			action=function() game.level.data.eidolon_exit("teleport") end
		},
		{"谢谢你，我已经准备好回去了。",
			cond=function() return not game.level.source_level or game.level.source_level.no_return_from_eidolon end,
			jump="jump_error",
		},
		{"谢谢你，但是我厌倦了这样的命运，请让我安息吧。", jump="die"},
	}
}



newChat{ id="jump_error",
	text = [[似乎时间线和空间已经被打乱。。。
我会将你安全送回。]],
	answers = {
		{"多谢。", action=function(npc, player) game:changeLevel(1, "wilderness") end},
	}
}

newChat{ id="die",
	text = [[#LIGHT_GREEN#*它看着你，对你的回答感到不可思议。*#WHITE#
我。。。本来为你有别的安排，但是我不能违背你的意愿，要知道你还有使命没有完成。
你确定吗？]],
	answers = {
		{"请让我死吧。", action=function(npc, player) 
			local src = game.player
			game:getPlayer(true):die(game.player, {special_death_msg=("asked the Eidolon to let %s die in peace"):format(game.player.female and "her" or "him")})
			while game.party:findSuitablePlayer() do
				game.player:die(src, {special_death_msg="brought down by Eidolon"})
			end
		end},		
		{"不，也许还是值得活下去的。"},
	}
}


end
return "welcome"

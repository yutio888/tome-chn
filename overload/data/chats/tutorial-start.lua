-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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
local q = game.player:hasQuest("tutorial")

newChat{ id="welcome",
	text = [[你好，你对哪一个主题比较感兴趣？]],
	answers = {
		{"基本游戏玩法。", 
			action = function(npc, player) 
				game:changeLevel(2, "tutorial") 
				q:choose_basic_gameplay()
				player:setQuestStatus("tutorial", engine.Quest.COMPLETED, "started-basic-gameplay")
			end},
		{"战斗属性。", 
			action = function(npc, player)
				game:changeLevel(3, "tutorial")
				q:choose_combat_stats()
				player:setQuestStatus("tutorial", engine.Quest.COMPLETED, "started-combat-stats")
			end},
		{"没事。"},
		{"没别的东西可以学了么？", 
			jump = "done",
			cond = function(npc, player) return q and q:isCompleted("finished-basic-gameplay") and q:isCompleted("finished-combat-stats") end, 
		},
	}
}


newChat{ id="done",
	text = [[

你已经完成了所有的教程，现在你对ToME4的基本情况应该有所了解了。你现在已经准备好去世界中寻找荣耀和财富，就算遭遇一大群残忍恐怖的怪物你也可以应对了！

在教学过程中，一些怪物为了教学目的被相应地做过修改，不过在真实的埃亚尔世界中，怪物可不会这么简单！

要是你想看看你的按键设置细节，你可以按下#GOLD#Esc键#WHITE#进入游戏菜单检查按键绑定，你可以更改设置直到你满意为止。

如果你第一次接触这个游戏，你会发现你所能选择的种族和职业是有限制的，别担心，许多内容在你的旅行过程中可以被解锁。

现在，勇敢的前进吧，并且记住：#GOLD#玩的开心！#WHITE#
按下 #GOLD#Esc键#WHITE#，选择 #GOLD#保存并退出#WHITE#，然后创建一个新的角色吧！]],
	answers = {
		{"谢谢！"},
	}
}

return "welcome"

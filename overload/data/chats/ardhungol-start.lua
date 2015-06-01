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

if not game.state:isAdvanced() and game.player.level < 20 then
newChat{ id="welcome",
	text = [[你好啊！]],
	answers = {
		{"你好！"},
	}
}
return "welcome"
end

if not game.player:hasQuest("spydric-infestation") then
newChat{ id="welcome",
	text = [[我听说你是来自西部的英雄，你能帮我一个忙吗？]],
	answers = {
		{"也许可以，是什么事情呢？", jump="quest", cond=function(npc, player) return not player:hasQuest("spydric-infestation") end},
		{"我很忙，抱歉。"},
	}
}
else
newChat{ id="welcome",
	text = [[欢迎回来， @playername@.]],
	answers = {
		{"我找到你的丈夫了，他安全回家了么？", jump="done", cond=function(npc, player) return player:isQuestStatus("spydric-infestation", engine.Quest.COMPLETED) end},
		{"我得走了，再见。"},
	}
}
end

newChat{ id="quest",
	text = [[我丈夫，瑞西姆，是一个太阳骑士。他被派去小镇北部清除蜘蛛巢穴阿尔德胡格。
已经三天了，他应该回来了。我有种预感他肯定遇到了麻烦。请帮我找到他！
他应该有阿诺里塞尔给他的魔法石，可以用来开启返回这里的传送门的，到目前为止他还没用过！]],
	answers = {
		{"我会看看我是否能找到他的。", action=function(npc, player) player:grantQuest("spydric-infestation") end},
		{"蜘蛛？呃……抱歉，说不定他现在已经死了。"},
	}
}

newChat{ id="done",
	text = [[是的，他回来了！他说要不是你帮忙他就死定了。]],
	answers = {
		{"小事一桩。", action=function(npc, player)
			player:setQuestStatus("spydric-infestation", engine.Quest.DONE)
			world:gainAchievement("SPYDRIC_INFESTATION", game.player)
			game:setAllowedBuild("divine")
			game:setAllowedBuild("divine_sun_paladin", true)
		end},
	}
}

return "welcome"

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

local function attack(str)
	return function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) npc:doEmote(str, 150) end
end

-----------------------------------------------------------------------
-- Default
-----------------------------------------------------------------------
if not game.player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "slasul-story") then

newChat{ id="welcome",
	text = [[怎么回事？为什么你要闯入我的神庙杀死我的人？
说，要不然你就得死，我是萨拉苏尔，你不应该打乱我的计划。]],
	answers = {
		{"[攻击]", action=attack("这样……去死吧！")},
		{"我是乌克勒姆斯维奇派来的，阻止你试图控制所有水下生物的疯狂计划。", jump="quest"},
	}
}

newChat{ id="quest",
	text = [[我明白了，是那个龙人叫你来的，是他告诉你我疯了，我图谋不轨？
但我们到底谁才是恶魔？我自己，为人们做好事，对任何人都没有伤害，而你，来这里想要杀死我，杀死了我的朋友，现在还想连我一起干掉？
谁才是疯子？]],
	answers = {
		{"你想狡辩动摇的我立场么？这可不起作用，为你犯下的罪恶付出代价吧。", action=attack("如果你拒绝交谈，那么我毫无选择！")},
		{"你说的话让我有点……搞不清楚了，但我为什么要宽恕你？", jump="givequest"},
	}
}

newChat{ id="givequest",
	text = [[宽恕我？#LIGHT_GREEN#*他笑了起来*#WHITE#
别用这种怜悯的态度对我！
我会告诉你我的故事，你们地面上的居民并不了解纳迦，让我告诉你：我们目前的处境并不是我们自己的选择。
当纳鲁大陆沉没时，我们很多人死了，因此我们求助于这间神庙的魔法。它起作用了，它救了我们，但是我们受到了诅咒。在这种可怕的魔法下我们变成了现在这副模样。
要是你不相信我所说的，至少你应该相信这个：夏·图尔只是隐藏了起来，并没有消失，而且它们并不是友善的种族。
现在，那个“水龙”派你来这里，开始派代理人来保护神庙。我只能猜测他的真正目的，肯定不是出于善意。]],
	answers = {
		{"听上去你不像是个疯子，难道乌克勒姆斯维奇说谎了么？", jump="portal_back", action=function(npc, player) player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "slasul-story") end},
		{"我不会被你的谎言所欺骗，你必须为你的牺牲者付出代价！", action=attack("如你所愿。本不应该这样的……")},
	}
}

newChat{ id="portal_back",
	text = [[使用这个传送门，可以把你传送回他的洞穴，去问他事情的真相吧。]],
	answers = {
		{"我会让他的背叛付出代价。", action=function(npc, player)
			player:hasQuest("temple-of-creation"):portal_back() 
			for uid, e in pairs(game.level.entities) do
				if e.faction == "enemies" then e.faction = "temple-of-creation" end
			end
		end},
	}
}

-----------------------------------------------------------------------
-- Coming back later
-----------------------------------------------------------------------
else
newChat{ id="welcome",
	text = [[谢谢你听我说完。]],
	answers = {
		{"那头巨龙在说谎，我能看出来。我准备赐予你力量。", jump="cause", cond=function(npc, player) return player:knowTalent(player.T_LEGACY_OF_THE_NALOREN) and not player:isQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "legacy-naloren") end},
		{"再见，萨拉苏尔。"},
		{"[攻击]", action=attack("这样……去死吧！")},
	}
}

newChat{ id="cause",
	text = [[我希望你能配合。
现在，让我们开始履行同盟仪式。将你的生命与我同享！这样只要你活着，我就永远不死！
作为回报，我会赐予你这柄强大的三叉戟。
]],
	answers = {
		{"我接受你的馈赠。", action=function(npc, player)
			local o = game.zone:makeEntityByName(game.level, "object", "LEGACY_NALOREN", true)
			if o then
				o:identify(true)
				player:addObject(player.INVEN_INVEN, o)
				npc:doEmote("LET US BE BOUND!", 150)
				game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
				game.level.map:particleEmitter(player.x, player.y, 1, "demon_teleport")
				npc.invulnerable = 1
				npc.never_anger = 1
				player:setQuestStatus("temple-of-creation", engine.Quest.COMPLETED, "legacy-naloren")
			end
		end},
		{"听起来有点奇怪，我要考虑一下。"},
	}
}

end

return "welcome"

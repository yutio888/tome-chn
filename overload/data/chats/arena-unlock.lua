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

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个高大的，带着兜帽的人盯着你。*
#WHITE#是的……是的……你看上去的确是一个强力的战士……
有件事交给你， @playerdescriptor.race@。
你看，我是竞技场的代理人，我在寻找一个强力的战士，
给我们的观众带来更棒的表演。你看上去应该够强壮。
你要做的事情，就是击败场上的三个对手，然后你会得到你的奖励。
#LIGHT_GREEN#*你考虑了一会兜帽人给你的这个任务。*
]],
	answers = {
		{"有意思，告诉我更多关于竞技场的事。", jump="more_ex",
			action = function (self, player) self.talked_to = 1 end,
			cond=function(npc, player) return not profile.mod.allow_build.campaign_arena end},
		{"我很强壮！告诉我该做什么？", jump="more",
			action = function (self, player) self.talked_to = 1 end,
			cond=function(npc, player) return profile.mod.allow_build.campaign_arena end},
		{"我没有接受这个人的邀请。", jump="refuse",
		action = function (self, player) self.talked_to = 1 end},
	}
}

newChat{ id="more",
	text = [[#LIGHT_GREEN#*你可以感觉到那张隐藏在兜帽里的脸露出了微笑。*
我可以为你提供钱和荣誉，另外还有一些非常有用的，
通过我的斗士们积累的#YELLOW#战斗经验#WHITE#
……怎么样？想不想加入？
]],
	answers = {
		{"我准备好战斗了，我们走！", jump="accept", action = function (self, player) self.talked_to = 2 end },
		{"我没时间玩游戏，平民。", jump="refuse"},
	}
}

newChat{ id="more_ex",
	text = [[#LIGHT_GREEN#*你可以感觉到那张隐藏在兜帽里的脸露出了微笑。*
竞技场是那些所有勇士们互相战斗的地方。
我们的规模还在扩大，我们需要挑战者……
这和赌博一样，只是你用战斗来代替金钱而已。
你在竞技场上给观众们带来精彩的表演，
作为回报我会给你足够你花几辈子的金钱和荣誉！
要是你能通过我小小的测试……我会#LIGHT_RED#让你在冒险结束后，
有机会进入我们的竞技场#WHITE#
#WHITE#通过战斗你同样能够取得宝贵的#LIGHT_RED#战斗经验#WHITE#。
你意下如何？
]],
	answers = {
		{"我准备好战斗了，我们走！", jump="accept", action = function (self, player) self.talked_to = 2 end },
		{"我没时间玩游戏，平民。", jump="refuse"},
	}
}

newChat{ id="refuse",
	text = [[#LIGHT_GREEN#*那个人失望地叹了口气*#WHITE#
真遗憾，我遇到过你这样的人。
你正是观众最喜欢的那种类型，你有可能获得冠军。
唉，要是你坚持你的选择，那我们以后不会再见面了。
不过，要是你改变主意……
我会#YELLOW#在德斯镇逗留几天。#WHITE#
#WHITE#要是我还在的话，我们可以做笔交易，好好考虑一下吧， @playerdescriptor.race@。
]],
	answers = {
		{"我们会再见面的。[离开]"},
	}
}

newChat{ id="accept",
	text = [[#LIGHT_GREEN#*那个人微笑着答应了*#WHITE#
好极了！一个好的战士总是渴望战斗。
你碰到我们绝对不会觉得遗憾的。
那么，你准备好战斗了么？
]],
	answers = {
		{"听上去很有趣，我准备好了！", jump="go"},
		{"等一下，我还没准备好。", jump="ok"},
	}
}

newChat{ id="go",
	text = "#LIGHT_GREEN#*那个人安静的走开了，他伸手示意你跟着他*",
	answers = {
		{"[跟着他]",
		action = function (self, player)
			self:die()
			player:grantQuest("arena-unlock")
			game:changeLevel(1, "arena-unlock", {direct_switch=true})
			require("engine.ui.Dialog"):simpleLongPopup("Get ready!", "Defeat all three enemies!", 400)
		end
		},
	}
}


newChat{ id="win",
	text = [[#LIGHT_GREEN#*那位平民盗贼从阴影中走了出来*#WHITE#
干得好！ @playerdescriptor.race@！我就知道你有潜力。
#LIGHT_GREEN#*那个盗贼取下了兜帽
#LIGHT_GREEN#，那是一个相当年轻但是饱经战斗的男子。#WHITE#
我的名字叫雷伊。我为竞技场工作，寻找能够提供精彩表演，
而不是三拳两脚就被打败的强力斗士……你的确就是其中一个！
我不会打断你的继续冒险，我自己也是一个冒险家，很久以前是。
但是我们能使你成为冠军，受所有人尊敬还有享不完的荣华富贵。

#LIGHT_GREEN#*你在那个盗贼一起返回了德斯小镇，他和你讨论着在丛林中的冒险经验。
他极大地提高了你的战斗经验(#WHITE#+2 通用技能点数#LIGHT_GREEN#)*
#WHITE#很好， @playername@，我现在必须得走了。
祝你在冒险中好运，记得回来看我们！
]],
	answers = {
		{ "我会的，再见吧。", action = function (self, player) game:onLevelLoad("arena-unlock-1", function()
			local g = game.zone:makeEntityByName(game.level, "terrain", "SAND_UP_WILDERNESS")
			g.change_level = 1
			g.change_zone = "town-derth"
			g.name = "exit to Derth"
			game.zone:addEntity(game.level, g, "terrain", player.x, player.y)

			game.party:reward("Select the party member to receive the +2 generic talent points:", function(player)
				player.unused_generics = player.unused_generics + 2
			end)
			game:setAllowedBuild("campaign_arena", true)
			game.player:setQuestStatus("arena-unlock", engine.Quest.COMPLETED)
			world:gainAchievement("THE_ARENA", game.player)
		end) end},
	}
}

newChat{ id="ok",
	text = "#WHITE#我会的，我会等你……#YELLOW#不过不会很久。",
	answers = {
		{ "再见。"},
	}
}

newChat{ id="back",
	text = [[#LIGHT_GREEN#*那个平民盗贼露出了欢迎的微笑*#WHITE#
欢迎你回来，@playerdescriptor.race@。有没有重新考虑一下你的决定？
]],
	answers = {
		{ "是的，说说细节吧。", jump = "accept", action = function (self, player) self.talked_to = 2 end },
		{ "没有，再见。"},
	}
}

newChat{ id="back2",
	text = [[
	欢迎你回来，@playerdescriptor.race@。你准备好了么？
]],
	answers = {
		{ "走吧。", jump = "go" },
		{ "稍等，我去准备下。"},
	}
}

if npc.talked_to then
	if npc.talked_to == 1 then return "back"
	elseif npc.talked_to >= 2 then return "back2"
	end
else return "welcome" end

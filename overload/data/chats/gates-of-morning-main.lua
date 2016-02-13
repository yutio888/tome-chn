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
	text = [[我能帮你什么忙么？]],
	answers = {
		{"艾伦女士，我终于回家了！[告诉她你的故事。]", jump="return", cond=function(npc, player) return player:hasQuest("start-sunwall") and player:isQuestStatus("start-sunwall", engine.Quest.COMPLETED, "slazish") and not player:isQuestStatus("start-sunwall", engine.Quest.COMPLETED, "return") end, action=function(npc, player) player:setQuestStatus("start-sunwall", engine.Quest.COMPLETED, "return") end},
		{"告诉我更多有关晨曦之门的事。", jump="explain-gates", cond=function(npc, player) return player.faction ~= "sunwall" end},
		{"在我来这里之前，我在马基·埃亚尔遇到了太阳堡垒的成员。你知道这件事么？", jump="sunwall_west", cond=function(npc, player) return game.state.found_sunwall_west and not npc.been_asked_sunwall_west end, action=function(npc, player) npc.been_asked_sunwall_west = true end},
		{"我在搜集法杖的线索，我需要你的帮助。", jump="clues", cond=function(npc, player) return game.state:isAdvanced() and not player:hasQuest("orc-pride") end},
		{"我已经消灭了所有兽人部落的首领。", jump="prides-dead", cond=function(npc, player) return player:isQuestStatus("orc-pride", engine.Quest.COMPLETED) end},
		{"我从灼烧之痕回来，兽人在那里抢走了法杖。", jump="charred-scar", cond=function(npc, player) return player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted() end},
		{"一位濒死的太阳骑士给了我这张地图，关于兽人育种棚。[告诉她整个事情]", jump="orc-breeding-pits", cond=function(npc, player) return player:hasQuest("orc-breeding-pits") and player:isQuestStatus("orc-breeding-pits", engine.Quest.COMPLETED, "wuss-out") and not player:isQuestStatus("orc-breeding-pits", engine.Quest.COMPLETED, "wuss-out-done") end},
		{"抱歉，我得走了!"},
	}
}

newChat{ id="return",
	text = [[@playername@！我们以为你在传送门爆炸的时候死了，幸好我们想错了，你拯救了太阳堡垒。
有关法杖的消息有点麻烦，那么，至少请你休息一会儿吧。]],
	answers = {
		{"我会的，谢谢你，我的女士。", jump="welcome"},
	},
}

newChat{ id="explain-gates",
	text = [[这里主要有两个种族，人类和精灵。
人类在派尔纪便来到了这里。我们的祖先是马德洛普探险队的一部分人员，他们是去调查沉入海底的纳鲁精灵大陆秘密的。他们的船失事沉没，侥幸活下来的人就漂流到了这块大陆。
他们碰到了一群精灵，似乎是这块大陆的原住民，他们成为了朋友并一起生活，创建了太阳堡垒和晨曦之门。
后来兽人来到了这里，从那时开始我们就一直与他们战斗。]],
	answers = {
		{"谢谢你，我的女士。", jump="welcome"},
	},
}

newChat{ id="sunwall_west",
	text = [[啊，那么他们还活着，真是一个好消息……]],
	answers = {
		{"继续。", jump="sunwall_west2"},
		{"呃……事实上……", jump="sunwall_west2", cond=function(npc, player) return game.state.found_sunwall_west_died end},
	},
}

newChat{ id="sunwall_west2",
	text = [[你看到的那些人很可能是伊莫克斯关于远古传送门实验的志愿者。
他是居住在太阳堡垒的一个法师，脾气古怪但是很有能力，他坚信可以创造一个远古传送门达到马基·埃亚尔。
除了他早期的一些尝试获得了一点可疑的结论外，他并不算走运。不过还是很高兴听到他的实验对象还活着的消息，尽管立场上我们不一致，不过毕竟是生活在同一片阳光下的人。

事实上。。。也许你去见伊莫克斯对你没什么好处。他一定会被你拿着的多元水晶球吸引住的。他就住在北面的小屋里。]],
	answers = {
		{"也许我会见见他，谢谢。", jump="welcome"},
	},
}

newChat{ id="prides-dead",
	text = [[我的确已经得到了消息，真令人难以置信，我们和兽人已经战斗的太久了。
他们现在都死了么？仅凭一个 @playerdescriptor.race@ 的力量？我对你的力量非常惊奇。
当你忙于解决那些兽人的时候，我们设法从那个兽人俘虏那里获得了一些线索。
他提起了有关巅峰保护罩的事。似乎那个护罩是受“指令水晶”操控的，那些指令水晶就在兽人各大部落首领的手中。
去把它们都找回来。
他还说想要进入顶层并关闭护罩的唯一通道是“史莱姆通道”，位于某一个兽人部落内，有可能是格鲁希纳克的部落。
]],
	answers = {
		{"谢谢你，我的女士。我会找到那个隧道并设法进去巅峰。", action=function(npc, player)
			player:setQuestStatus("orc-pride", engine.Quest.DONE)
			player:grantQuest("high-peak")
		end},
	},
}

newChat{ id="clues",
	text = [[我真的很想帮助你，不过我们的军队已经十分分散而且薄弱，我们无法直接给你提供军事援助。
但是我尽我所能，告诉你兽人部落的组成结构。
最近我们接到情报说兽人选举了新的领袖，他们很有可能就是抢夺神秘法杖的幕后主使人。
我们相信，他们的力量中心就是巅峰，在这个大陆的中部区域。不过它被某种护罩保护无法进入。
你必须调查兽人部落的各个基地，或许你能找到更多有关巅峰的线索，而且你每杀死一个兽人，我们就少了一个攻击我们的敌人。
已知的兽人部落有：
- 拉克·肖部落，在南部沙漠的西面。
- 加伯特部落，在南部沙漠的群山之中。
- 沃尔部落，在东北方。
- 格鲁希纳克部落，在通往高塔之巅的东部山坡上。]],
-- - A group of corrupted humans live in Eastport on the southern coastline; they have contact with the Pride
	answers = {
		{"我会调查这些地方。", jump="relentless", action=function(npc, player)
			player:setQuestStatus("orc-hunt", engine.Quest.DONE)
			player:grantQuest("orc-pride")
			game.logPlayer(game.player, "Aeryn points to the known locations on your map.")
		end},
	},
}

newChat{ id="relentless",
	text = [[在你出发之前我还有一样东西可以帮助你，我被你的故事所感动，闪耀的群星将赐予你“无尽追踪”的能力。带上这个祝福，不要让任何事物阻碍你的使命。
	#LIGHT_GREEN#*她用冰凉的手触摸了你的额头，你感觉到身上涌现出一股力量。*
	]],
	answers = {
		{"我会将那些兽人赶尽杀绝。", jump="welcome", action=function(npc, player)
			player:learnTalent(player.T_RELENTLESS_PURSUIT, true, 1, {no_unlearn=true})
			game.logPlayer(game.player, "#VIOLET#You have learned the talent Relentless Pursuit.")
		end},
	},
}

newChat{ id="charred-scar",
	text = [[我已经听说了，很多好人为此牺牲了生命，但愿这是值得的。]],
	answers = {
		{"是的，我的女士。他们拖住了敌人，使我能够前进至火山中心。*#LIGHT_GREEN#告诉她发生的事。#WHITE#*", jump="charred-scar-success",
			cond=function(npc, player) return player:isQuestStatus("charred-scar", engine.Quest.COMPLETED, "stopped") end,
		},
		{"恐怕我太迟了，不过我还是带来了有价值的消息。*#LIGHT_GREEN#告诉她发生的事。#WHITE#*", jump="charred-scar-fail",
			cond=function(npc, player) return player:isQuestStatus("charred-scar", engine.Quest.COMPLETED, "not-stopped") end,
		},
	},
}

newChat{ id="charred-scar-success",
	text = [[法师会？我从来没听说过他们。传说部落有了一个新的领袖，看样子现在应该有两个。
感谢你所做的事，你必须进一步搜寻更多的消息，你知道你该去做什么。]],
	answers = {
		{"我会替你的人报仇！", action=function(npc, player)
			player:setQuestStatus("charred-scar", engine.Quest.DONE)
			game:unlockBackground("aeryn", "High Sun Paladin Aeryn")
		end}
	},
}

newChat{ id="charred-scar-fail",
	text = [[法师会？我从来没听说过他们。传说部落有了一个新的领袖，看样子现在应该有两个。
恐怕依他们现在所具有的力量我们更难阻止他们了，不过我们别无选择。]],
	answers = {
		{"我会替你的人报仇！", action=function(npc, player) player:setQuestStatus("charred-scar", engine.Quest.DONE) end}
	},
}

newChat{ id="orc-breeding-pits",
	text = [[太好了！一线希望的曙光终于穿过了黑暗。我会派我最好的军队去那里。多谢你了，@playername@——以此物来表示我们对你的感激。]],
	answers = {
		{"祝你们好运.", action=function(npc, player)
			player:setQuestStatus("orc-breeding-pits", engine.Quest.COMPLETED, "wuss-out-done")
			player:setQuestStatus("orc-breeding-pits", engine.Quest.COMPLETED)

			for i = 1, 5 do
				local ro = game.zone:makeEntity(game.level, "object", {ignore_material_restriction=true, type="gem", special=function(o) return o.material_level and o.material_level >= 5 end}, nil, true)
				if ro then
					ro:identify(true)
					game.logPlayer(player, "艾伦交给你: %s", ro:getName{do_color=true})
					game.zone:addEntity(game.level, ro, "object")
					player:addObject(player:getInven("INVEN"), ro)
				end
			end
		end}
	},
}


return "welcome"

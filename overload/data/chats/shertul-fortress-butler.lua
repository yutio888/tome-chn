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

local has_rod = function(npc, player) return player:findInAllInventoriesBy("define_as", "ROD_OF_RECALL") end
local q = game.player:hasQuest("shertul-fortress")
local ql = game.player:hasQuest("love-melinda")
local set = function(what) return function(npc, player) q:setStatus(q.COMPLETED, "chat-"..what) end end
local isNotSet = function(what) return function(npc, player) return not q:isCompleted("chat-"..what) end end

newChat{ id="welcome",
	text = [[*#LIGHT_GREEN#那个生物慢慢向你走来，你的头顶上响起一个可怕的嗓音。#WHITE#*
欢迎你，主人。]],
	answers = {
		{"你是什么东西？这是什么地方？", jump="what", cond=isNotSet"what", action=set"what"},
		{"主人？我不是你的主……", jump="master", cond=isNotSet"master", action=set"master"},
		{"我不明白，那些文字我看不懂。", jump="understand", cond=isNotSet"understand", action=set"understand"},
		{"我能在这里做什么？", jump="storage", cond=isNotSet"storage", action=set"storage"},
		{"这里还能做什么？", jump="energy", cond=isNotSet"energy", action=set"energy"},
		{"可以帮我升级欺诈斗篷让我可以直接通过而不必装备它么？", jump="permanent-cloak", 
			cond=function(npc, player)
				local cloak = player:findInAllInventoriesBy("define_as", "CLOAK_DECEPTION")
				return not q:isCompleted("permanent-cloak") and q:isCompleted("transmo-chest") and cloak
		end},
		{"你叫我来，是为了远古传送门？", jump="farportal", cond=function() return q:isCompleted("farportal") and not q:isCompleted("farportal-spawn") end},
		{"你叫我来，是关于召回之杖？", jump="recall", cond=function() return q:isCompleted("recall") and not q:isCompleted("recall-done") end},
		{"可以让我的转化之盒自动转化宝石么？", jump="transmo-gems", cond=function(npc, player) return not q:isCompleted("transmo-chest-extract-gems") and q:isCompleted("transmo-chest") and player:knowTalent(player.T_EXTRACT_GEMS) end},
		{"这里是不是有一间训练室？", jump="training", cond=function() return not q:isCompleted("training") end},
		{"你能用魔法改变我装备的外形么?", jump="shimmer", cond=function() return not q:isCompleted("shimmer") end},
		{"你的样子看上去让我不舒服，你可以改变外形么？", jump="changetile", cond=function() return q:isCompleted("recall-done") end},
		{"我到这里来是为了寻求帮助。 #LIGHT_GREEN#[告诉它梅琳达的事]", jump="cure-melinda", cond=function() return ql and ql:isStatus(engine.Quest.COMPLETED, "saved-beach") and not ql:isStatus(engine.Quest.FAILED) and not ql:isStatus(engine.Quest.COMPLETED, "can_come_fortress") end},
		{"[离开]"},
	}
}

newChat{ id="master",
	text = [[*#LIGHT_GREEN#那个生物瞪着你。#WHITE#*
你拿着控制魔杖，你就是我的主人。]],
	answers = {
		{"哦……好吧。", jump="welcome"},
	}
}
newChat{ id="understand",
	text = [[*#LIGHT_GREEN#那个生物瞪着你。#WHITE#*
你拥有魔杖，你就是主人，我是被制造出来和主人对话的。]],
	answers = {
		{"哦……好吧。", jump="welcome"},
	}
}

newChat{ id="what",
	text = [[*#LIGHT_GREEN#那个生物集中精神注视着你，你“看到”了脑海中的影像。
你看到了已被人遗忘的泰坦之战。你看到了夏·图尔军队的阴影。
他们使用魔法、武器和其他东西战斗，他们和众神战斗，将他们击倒、杀死、驱散。
你看到巨大的类似这里的堡垒飘浮在埃亚尔的上空，在阳光之下释放出强大的能量光芒。
你看到众神都被击败、杀死，除了一个。
然后你看到了黑暗，一些不知其名的阴影紧随着出现。

你摇了摇驱散了脑海中的影像，你的眼前慢慢恢复了现实的景象。
#WHITE#*
]],
	answers = {
		{"那是夏·图尔？他们和众神战斗？！", jump="godslayers"},
	}
}

newChat{ id="godslayers",
	text = [[他们曾经是，他们锻造了可怕的武器用于战争，并取得了胜利。]],
	answers = {
		{"他们是胜利了，但是现在他们又在哪里呢？", jump="where"},
	}
}

newChat{ id="where",
	text = [[他们已经消失，我不能告诉你更多了。]],
	answers = {
		{"我是你的主人！", jump="where"},
		{"好吧。", jump="welcome"},
	}
}

newChat{ id="storage",
	text = [[*#LIGHT_GREEN#那个生物瞪着你。#WHITE#*
你是主人，你可以随意使用这个地方。不过，大多数这里的能量已经耗竭，只有一些房间可以使用。
在南面你可以看到储藏室。]],
	answers = {
		{"谢谢。", jump="welcome"},
	}
}

newChat{ id="energy",
	text = [[这个堡垒是弑神者们的移动堡垒，它可以飞行。
它还装备了其他设施：探险传送门，紧急防护场，远程存储……
然而，堡垒已经严重损坏，而且已经休眠了太久了。它的能量几近枯竭。
拿着这个转化之盒。它与堡垒有永久链接，所有放进去的装备都可以使用它分解，转化为堡垒的能量。
不过它还有这样一个副作用：转化物品会产生一种叫做金子的金属，它们对于要塞是没有用的，所以会变成金币返还给你。]],
	answers = {
		{"我知道了，谢谢。", jump="welcome", action=function() q:spawn_transmo_chest() end, cond=function(npc, player) return not player:attr("has_transmo") end},
		{"我已经在我的旅途中找到了一个，它有发挥效用么？", jump="alreadychest", action=function() q:setStatus(q.COMPLETED, "transmo-chest") end, cond=function(npc, player) return player:attr("has_transmo") end},
	}
}

newChat{ id="alreadychest",
	text = [[是的它会，他会和堡垒联系在一起。
完成。]],
	answers = {
		{"谢谢。", jump="welcome"},
	}
}

newChat{ id="farportal",
	text = [[很久以前夏·图尔们使用远古传送门，不仅是为了传送到那些已知的地方，也可以传送的世界未知的角落，甚至是其他世界。
这个堡垒装置有远古传送门，现在已经有足够的能量开启其中的一个了。每次传送都会将你传送到宇宙的一个随机角落，每次耗费30能量。
注意返回的传送门并不是就在你到达的那个地方，你需要自己去寻找。紧急情况下你可以使用召回之杖强制返回，不过这很有可能永久损坏远古传送门。
你可以使用远古传送门了，不过，当心，感觉到传送门房间有异常的东西。]],
	answers = {
		{"我会去检查一下的，谢谢。", action=function() q:spawn_farportal_guardian() end},
	}
}

newChat{ id="recall",
	text = [[你所拥有的召回之杖并不是夏·图尔的产物，不过是基于夏·图尔的知识而制造的。
堡垒现在有足够的能量来升级它的功能，可以使你传送时返回到堡垒来。]],
	answers = {
		{"我喜欢保持原样，不过还是谢谢了。"},
		{"这对我很有用，请帮我升级吧。", action=function() q:upgrade_rod() end},
	}
}

newChat{ id="training",
	text = [[是的，主人。北方是有一间训练室，不过它需要能量。
我需要至少50能量来激活它。]],
	answers = {
		{"算了，以后再说吧。"},
		{"那应该很有用，请帮我吧。", cond=function() return q.shertul_energy >= 50 end, action=function() q:open_training() end},
	}
}

newChat{ id="shimmer",
	text = [[好的主人。反射之镜能满足您的需求，它需要10点能量激活。.]]..(profile:isDonator(1) and "" or "\n#{italic}##CRIMSON#这项特性只对捐赠用户有效。#{normal}#"),
	answers = {
		{"以后再说。"},
		{"非常好，就这么做吧。", cond=function() return q.shertul_energy >= 10 end, action=function() q:open_shimmer() end},
	}
}

newChat{ id="transmo-gems",
	text = [[嗯可以，你似乎掌握了基本的炼金术，我可以使转化之盒自动转化宝石提供能量，
不过这需要耗费25能量值。]],
	answers = {
		{"以后再说。"},
		{"很好，就这么办吧。", cond=function() return q.shertul_energy >= 25 end, action=function() q:upgrade_transmo_gems() end},
	}
}

newChat{ id="changetile",
	text = [[我可以通过堡垒改变我自身的结构以符合主人的口味，不过这得耗费60能量值。]],
	answers = {
		{"请你变成一个女性人类的样子吧？", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = mod.class.Actor.new{
				add_mos={{image = "npc/humanoid_female_sluttymaid.png", display_y=-1, display_h=2}},
--				shader = "shadow_simulacrum",
--				shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
			}
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{"请你变成一个男性人类的样子吧？", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = mod.class.Actor.new{
				image = "invis.png",
				add_mos={{image = "npc/humanoid_male_sluttymaid.png", display_y=-1, display_h=2}},
--				shader = "shadow_simulacrum",
--				shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
			}
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{"请变回原来默认的样子。", cond=function() return q.shertul_energy >= 60 end, action=function(npc, player)
			q.shertul_energy = q.shertul_energy - 60
			npc.replace_display = nil
			npc:removeAllMOs()
			game.level.map:updateMap(npc.x, npc.y)
			game.level.map:particleEmitter(npc.x, npc.y, 1, "demon_teleport")
		end},
		{"好吧，其实你看上去没那么糟，就保持这个样子吧。"},
	}
}

newChat{ id="permanent-cloak",
	text = [[是的主人，我可以耗费10能量来提升斗篷，使你脱下斗篷仍能保持它的特效。
不过，我建议你还是随身携带，以备万一特效被从你身上消除时使用。]],
	answers = {
		{"暂时不用。"},
		{"好，就这么办。", action=function(npc, player)
			local cloak = player:findInAllInventoriesBy("define_as", "CLOAK_DECEPTION")
			cloak.upgraded_cloak = true
			q.shertul_energy = q.shertul_energy - 10
			q:setStatus(engine.Quest.COMPLETED, "permanent-cloak")
		end},
	}
}

newChat{ id="cure-melinda",
	text = [[恶魔的污染么，是的，我有方法帮忙。不过这需要一段时间，目标生物必须在这里住上一段时间。。
她每天至少要在这里呆上8小时。]],
	answers = {
		{"太好了！我马上告诉她。", action=function(npc, player)
		player:setQuestStatus("love-melinda", engine.Quest.COMPLETED, "can_come_fortress")
		end},
	}
}

return "welcome"

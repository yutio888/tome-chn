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

local function remove_materials(npc, player)
	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("Resonating Diamond")
	player:removeObject(gem_inven_id, gem_item, false)
	gem_o:removed()

	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("Blood-Runed Athame")
	player:removeObject(athame_inven_id, athame_item, false)
	athame_o:removed()

	player:incMoney(-100)
end

local function check_materials(npc, player)
	local gem_o, gem_item, gem_inven_id = player:findInAllInventoriesBy("define_as","RESONATING_DIAMOND")
	local athame_o, athame_item, athame_inven_id = player:findInAllInventoriesBy("define_as","ATHAME")
	return gem_o and athame_o and player.money >= 100
end

-----------------------------------------------------------------
-- Main dialog
-----------------------------------------------------------------

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*门上开了一个小洞，一副野蛮的眼睛凝视着你。*#WHITE#
你想干什么， @playerdescriptor.race@?]],
	answers = {
		{"圣骑士艾伦跟我说你能帮助我，我想去马基·埃亚尔。", jump="help", cond=function(npc, player) return game.state:isAdvanced() and not player:hasQuest("west-portal") end},
		{"我找到了血符祭剑，不过还没找到共鸣宝石。", jump="athame", cond=function(npc, player) return player:hasQuest("west-portal") and player:hasQuest("west-portal"):isCompleted("athame") and not player:hasQuest("west-portal"):isCompleted("gem") end},
		{"我找到了共鸣宝石。", jump="complete", cond=function(npc, player) return player:hasQuest("west-portal") and player:hasQuest("west-portal"):isCompleted("gem") end},
		{"抱歉，我得走了！"},
	}
}

-----------------------------------------------------------------
-- Give quest
-----------------------------------------------------------------
newChat{ id="help",
	text = [[呸！她的生活目标就是在浪费我的时间！马基·埃亚尔？怎么不是纳尼亚或者芝加哥？就像送你到小说里的马基·埃亚尔一样简单，走开。
#LIGHT_GREEN#*小洞呯的一声关上了。*#WHITE#]],
	answers = {
		{"我来自马基·埃亚尔，不是么，我有一个从一个兽人尸体上找到的魔法水晶球，看……", jump="offer"},
	}
}

newChat{ id="offer",
	text = [[#LIGHT_GREEN#*小洞打开了。*#WHITE#
你说水晶球？你说你是从马基·埃亚尔来的？你拿到的肯定不是多元水晶球！它已经消失很多年了！]],
	answers = {
		{"[拿出水晶球]", jump="offer2"},
	}
}
newChat{ id="offer2",
	text = [[#LIGHT_GREEN#*他瞪大了眼睛*#WHITE#
艾伦的臭脚丫！真是那个水晶球！在这之后我们可以让你回家，如果……我们也可以给你在熔岩深渊中给你安个家。]],
	answers = {
		{"我能进来了么？", jump="offer3"},
	}
}

newChat{ id="offer3",
	text = [[你认为我会让一个肮脏的 @playerdescriptor.race@ 带着多元水晶球进我家么？
谢了，我的房间已经够乱了。
况且，我没法帮助你，除非你搞到一把血符祭剑来开启这个传送门。
呃……传送门还必须在一块共鸣石头上才能开启。
晨曦之门原来有这么一块共鸣石头可以起作用，不过现在，有一群……嗯……东西占据了那儿。
另外还有一块共鸣宝石，哦，我还要收取100金币费用。]],
	answers = {
		{"我上哪儿去找那些东西。", jump="quest"},
	}
}

newChat{ id="quest",
	text = [[100金币么……你摸摸口袋就有了，血符祭剑和共鸣宝石，我猜那些兽人既然开启过传送门就应该在他们那里能找到，去找找沃尔部落，碰巧我知道一个隐蔽入口去那里，别问我为什么会知道。]],
	answers = {
		{"谢谢你。", action=function(npc, player)
			player:grantQuest("west-portal")
		end},
	}
}


-----------------------------------------------------------------
-- Return athame
-----------------------------------------------------------------
newChat{ id="athame",
	text = [[你当然找不到共鸣宝石，你想想布莱亚弗怎么会放松一秒钟警惕？]],
	answers = {
		{"布莱亚弗？", jump="athame2"},
	}
}
newChat{ id="athame2",
	text = [[布莱亚弗，那条巨型土龙，要不然你认为共鸣宝石在哪里？它本来只是那个栖息地里普通的宝石，经过几个世纪之后布莱亚弗将它的生命活力注入进了这些宝石。你看，它正是睡在一堆矿石和宝石上呢。]],
	answers = {
		{"布莱亚弗的老巢在什么地方？？", jump="athame3"},
	}
}
newChat{ id="athame3",
	text = [[在太阳堡垒的南面，我会在你的地图上给你做个记号。]],
	answers = {
		{"我会带回共鸣宝石。", action=function(npc, player) player:hasQuest("west-portal"):wyrm_lair(player) end},
	}
}

-----------------------------------------------------------------
-- Return gem
-----------------------------------------------------------------
newChat{ id="complete",
	text = [[是么？你弄到了血符祭剑、宝石、还有100块金币？]],
	answers = {
		{"[把血符祭剑、宝石和100块金币给他]", jump="complete2", cond=check_materials, action=remove_materials},
		{"抱歉，我去拿点材料，马上回来。"},
	}
}
newChat{ id="complete2",
	text = [[#LIGHT_GREEN#*门开了，一个衣衫褴褛的精灵走了出来。*#WHITE#
我们去准备制造传送门吧！]],
	answers = {
		{"[跟着他]", action=function(npc, player) player:hasQuest("west-portal"):create_portal(npc, player) end},
	}
}

return "welcome"

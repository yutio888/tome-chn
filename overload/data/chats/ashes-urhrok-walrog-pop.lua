-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

local popup = function(npc, player)
	npc:doEmote("为同胞…复仇", 90, colors.BLUE)
end

newChat{ id="welcome",
	text = [[当那只]]..(kind == "naga" and "娜迦" or "龙")..[[高大的身躯颓然倒下，无数气泡在你的身边浮现，身边的水域扭曲着沸腾，蒸汽笼罩着你的视野。
#AQUAMARINE#"干的不错嘛…愚蠢的闯入者…"#WHITE# 一个低沉的声音响起。
#AQUAMARINE#"挡在我成为海洋霸主的路上的两个障碍已经除去…现在，我只要亲手干掉唯一的获胜者就行了…"#WHITE#
在不远数尺处，你看到无数沸腾的气泡在一个透明的身形旁聚集，在清澈的水中勾勒出那庞大怪物的模糊轮廓。
#AQUAMARINE#"真方便…夏·图尔的魔法现在为我所用…用来击败他们曾经的造物…但是现在…只剩下一个阻碍我的人…波涛之下只剩下一个伟大的战士挡在我的面前…"#WHITE#]],
	answers = {
		{"海洋是你的了！埃亚尔人早就放弃海洋了！", jump="a"},
		{"你就是海洋新的霸主？你想要我干什么？", jump="b"},
		{"污秽的恶魔，埃亚尔的海洋绝不臣服于你！让我终结这邪恶与混沌！", jump="c"},
		{"别吐泡泡了，去死吧，你这水壶怪！你的财宝是我的了！", action=popup},
	}
}

newChat{ id="a",
	text = [[气泡围绕的身形仿佛皱了皱眉头。
#AQUAMARINE#"总有一天我将君临大地…与其到时候再打败你…"#WHITE#
气泡爆发开来，一团热流从恶魔的身边射出。
#AQUAMARINE#"不如现在就做一个了结……"#WHITE#]],
	answers = {
		{"#LIGHT_GREEN#[战斗]#WHITE#", action=popup},
	}
}

newChat{ id="b",
	text = [[你没想到，这团不定形的气泡仿佛皱了皱眉
#AQUAMARINE#"]]..(kind == "naga" and "背叛" or "屠戮")..[[纳鲁精灵…背叛乌尔维斯克…你当我是傻瓜吗…"#WHITE#
一束滚烫的水流从你的身边擦过，消散成一团气泡。
#AQUAMARINE#"你的“忠诚”…还能骗得了谁？"#WHITE#
这团沸腾的气泡膨胀开去，巨大的身形向你冲来。]],
	answers = {
		{"#LIGHT_GREEN#[战斗]#WHITE#", action=popup},
	}
}

newChat{ id="c",
	text = [[他大笑起来，气泡从他的嘴边浮现。
#AQUAMARINE#"所以你又假惺惺地摆出了一副善人的嘴脸，无耻的背叛者？…那他们的尸体又是怎么回事？…还是让我来终结一切吧…烫死还是溺死，你更喜欢哪个呢…"#WHITE#
笑声渐渐消隐，一团滚烫的沸水围绕着巨大的身形，向你冲来！]],
	answers = {
		{"#LIGHT_GREEN#[战斗]#WHITE#", action=popup},
	}
}

return "welcome"
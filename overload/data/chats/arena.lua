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

local entershop = function (self, player)
	local arenashop = game:getStore("ARENA_SHOP")
	arenashop:loadup(game.level, game.zone)
	arenashop:interact(player, "Gladiator's wares")
	arenashop = nil
end

newChat{ id="ryal-entry",
text = [[#LIGHT_GREEN#*一只巨大的骨质巨兽从大门走了进来。
#LIGHT_GREEN#它有着复杂而尖锐的形状，类似一头龙的样子，
#LIGHT_GREEN#但是有着更多的角质物来代替翅膀。
#LIGHT_GREEN#这只巨大的不死生物用不可思议的睿智眼神紧盯着你。
#LIGHT_GREEN#你曾经听说过他。铁塔·瑞尔，你的第一个障碍！
#LIGHT_GREEN#它的眼睛位置有着一团诡异的蓝色火焰
#LIGHT_GREEN#，这只巨大的不死生物咆哮着并展开骨翼向你径直冲来！*
]],
	answers = {
		{"杀了你！！"},
	}
}

newChat{ id="ryal-defeat",
text = [[#LIGHT_GREEN#*在承受数次打击后，这只巨大的不死生物
#LIGHT_GREEN#被你的攻击打垮了*
#LIGHT_GREEN#突然，瑞尔的身体开始恢复！
#LIGHT_GREEN#它再次站了起来，你可以感受到它毫无表情的头骨
#LIGHT_GREEN……满足的盯着你。
#WHITE#呵呵呵……干得好， @playerdescriptor.race@。
#LIGHT_GREEN#*瑞尔缓缓的转身从大门离开，看起来毫发无损。*
]],
	answers = {
		{"真有趣，大怪物！", action=entershop},
		{"……什么？毫发无损？", action=entershop}
	}
}

newChat{ id="fryjia-entry",
text = [[#LIGHT_GREEN#*当一个小女孩安静地走进场内时，风变的异常寒冷。
#LIGHT_GREEN#她看起来年纪很小，有着苍白的肌肤和对比鲜明的黑色长发。
#LIGHT_GREEN#她用异常平静的口吻对你说*#WHITE#
我就是传说中的冰暴弗里嘉。你只要知道这点就行， @playerdescriptor.race@。让我们开始吧。
#LIGHT_GREEN#*在她说话的同时整个竞技场变得寒冷刺骨，
#LIGHT_GREEN#观众们也开始穿上他们最温暖的外套。*]],
	answers = {
		{"来吧！"},
	}
}

newChat{ id="fryjia-defeat",
text = [[#LIGHT_GREEN#*随着你的最后一击，弗里嘉倒下了，无法再战。
#LIGHT_GREEN#她艰难的站起来但是似乎没受到重创。*
#WHITE# 我……我承认我输了。
#LIGHT_GREEN#*观众席一片“唔”的敬畏声。弗里嘉留给你一个背影*
#WHITE# @playerdescriptor.race@。你不是我要找的人……
#LIGHT_GREEN#*留下你在原地思考她到底说了什么，这位小女孩径直走向大门。
#LIGHT_GREEN#当它关上时，你突然发觉刚才女孩的眼睛湿润了。
]],
	answers = {
		{"……", action=entershop},
		{"到……到底是什么？", action=entershop}
	}
}

newChat{ id="riala-entry",
text = [[#LIGHT_GREEN#*大门打开了，进来的是一位风韵十足穿着深红色长袍的女子。
#LIGHT_GREEN#她看着你并对你露齿一笑*
#WHITE# 我的，我的天呐，你是多么强大的一个 @playerdescriptor.race@ 。你能重复一遍你的名字吗， @playername@？我很高兴今天能成为你的对手。
#LIGHT_GREEN#*她轻轻的说着就像是在说一个秘密* #WHITE#你知道吗，很少有人能闯过这里，真的很令人困扰呢。#LIGHT_GREEN#*她咯咯地笑着*#WHITE#
所以！我就是绯红之里雅拉。我来自安格利文。虽然魔法大爆炸有那么一点负面影响，人们还是很享受一些魔法带来的乐趣的！
#LIGHT_GREEN#*她突然拍了下手掌，随即一团火焰绕着她盘旋飞舞！*#WHITE#
弗里嘉跟我提起过你，可怜的家伙，我不会低估一个如此有潜力的对手的#LIGHT_GREEN#*她露出和煦的微笑* WHITE#那么，让我们赶紧开始吧，亲爱的！
我们要展开一场决斗！]],
	answers = {
		{"一起上吧！"},
	}
}

newChat{ id="riala-defeat",
text = [[#LIGHT_GREEN#*随着最后一击，里雅拉倒下了……突然间化为熊熊的火焰！！
#LIGHT_GREEN#你盯着那团熊熊的火焰，满脸不可理解的神情，
#LIGHT_GREEN#直到你听到背后发出的声音*#WHITE#
哦，亲爱的！真是一场精彩的战斗，不是吗？我承认你赢得了胜利。
#LIGHT_GREEN#*她优雅的鞠躬*
弗里嘉是对的：她认为你会成为冠军！
哦，另外请原谅她的行为。当你见到她父亲时你会明白的。
还有，如果你能坚持像这样战斗，你的梦想真的会很快实现的。
所以，这是我的荣幸， @playername@。#LIGHT_GREEN#*她化作一团盘旋的火焰消失不见*]],
	answers = {
		{"我热切期待着！接下来是什么？", action=entershop},
		{"难道我是唯一一个有资格死在这里的吗？", action=entershop}
	}
}

newChat{ id="valfren-entry",
text = [[#LIGHT_GREEN#*你突然发觉天黑了。
#LIGHT_GREEN#你环顾四周寻找你的竞争对手。紧接着你看到了。
#LIGHT_GREEN#站在你面前的，手持战斧身穿重甲的人。
#LIGHT_GREEN#在半秒前那里还空无一人。你退后一步并仔细的打量他，
#LIGHT_GREEN#确认那里真的是一位穿着重甲的人类。你不能看到他的眼睛，
#LIGHT_GREEN#但是你知道他的眼神穿透了你的灵魂*
飞……提……马……尔……
#LIGHT_GREEN#*你突然听到一阵来自四面八方的呢喃声！！
#LIGHT_GREEN#但是，你无法理解这一切！听起来似乎不像是
#LIGHT_GREEN#马基·埃亚尔使用的任何语言！
#LIGHT_GREEN#紧接着……一声震耳欲聋的怒吼……
#LIGHT_GREEN#你感到整个灵魂都在颤抖！！*
]],
	answers = {
		{"#LIGHT_GREEN#*你勇敢的面对黑暗*"},
	}
}

newChat{ id="valfren-defeat",
text = [[#LIGHT_GREEN#*你英勇的打出最后一击！
#LIGHT_GREEN#当光明重归，瓦弗伦彻底垮倒了。
#LIGHT_GREEN#你短暂的闭上眼睛一段时间。当你睁开眼时，你看到了弗里嘉*
爸爸…… #LIGHT_GREEN#*她沉默的站在那儿*#WHITE#你赢了， @playerdescriptor.race@。
你做的很好。准备好你的最终战吧……如果你赢了，我们将为你服务。
祝你好运……
#LIGHT_GREEN#*一阵令人不安的沉默后，瓦弗伦重新动了起来。
#LIGHT_GREEN#他站了起来并和弗里嘉一起离开。在大门口，瓦弗伦回头看着你。
#LIGHT_GREEN#你也看着他，然后他将目光转向竞技场城墙上。
#LIGHT_GREEN#你顺着他的目光……看到了竞技场之主——
#LIGHT_GREEN#*那就是你的目标了。当这一刻来临时，你的心跳不由自主的加快了。*
#LIGHT_GREEN#*竞技场之主自豪的笑着。*
#RED#*当大门关上时，决战将会开始，只有最后一次机会！！*
]],
	answers = {
		{"我将打败你，竞技场之主！！！", action=entershop},
		{"我将代替你成为竞技场之主！！", action=entershop},
		{"金钱和妹子！胜利与荣耀！", action=entershop},
	}
}

newChat{ id="master-entry",
text = [[#LIGHT_GREEN#*最终，竞技场之主步入了竞技场的大门！
#LIGHT_GREEN#当他充满自信的面对你时，观众们大声的呐喊起来！*
我很欣赏你， @playerdescriptor.race@！ 你用力量和勇气一路走来！
现在……是最终的Showtime！
#LIGHT_GREEN#*领主摆好了战斗姿势。观众爆发出一阵欢呼！*
像你一样，我也是一步步走来。我不会轻视任何有潜力的人。
#LIGHT_GREEN#*领主哈哈大笑，你同样摆好了战斗姿势，
#LIGHT_GREEN#并且观众们同样在为你助威，你感到内心充满了力量*
你能听到吗，大家的欢呼声？这就是了。
力量就是荣耀， @playerdescriptor.race@！！
#LIGHT_GREEN#*领主大步向前，进入沙地*
]],
	answers = {
		{"金钱和妹子！胜利与荣耀！！！"},
	}
}

newChat{ id="master-defeat",
text = [[#LIGHT_GREEN#*一场荣耀之战后，领主倒下了！*
哈……哈哈。你做到了， @playerdescriptor.race@……
#LIGHT_GREEN#*竞技场之主，虽败犹荣，他微笑着站了起来。
#LIGHT_GREEN#得到领主的认可后，你拿起了他的武器——
#LIGHT_GREEN#现在躺在血迹斑斑的沙地上。*
观众们！我们今天产生了一位冠军！！
#LIGHT_GREEN#*观众们兴奋地大喊着你的名字*
祝贺你， @playerdescriptor.race@。你现在是领主了。
现在你可以享有胜利者的待遇了。
只要记住一点……像我一样，某天你也可能会被打败……
但同时，这是你的位置！欢迎来到天堂， @playerdescriptor.race@！
#LIGHT_GREEN#*你看到许多协会和军队首领靠近被击败的领主，
#LIGHT_GREEN#提供他许多优厚的条件和待遇。
#LIGHT_GREEN#你开怀大笑，胜利了，从此荣耀将伴随你的一生！
#LIGHT_GREEN#因为即使你在将来的某一天被打败……
#LIGHT_GREEN#你的高大形象仍会长存于人们心中。

#YELLOW#祝贺你！
#YELLOW#你现在是竞技场的新领主了！传奇而荣耀！
#YELLOW#直到某天有人打败你，你将会一直保持竞技场之主的地位！
#YELLOW#当你再玩此模式时，你将会面对现在的这个人物！
]],
	answers = {
		{"妹子！！和！！荣耀！！", action=function(npc, player) player:hasQuest("arena"):win() end},
		{"我再也不需要去什么鬼地窖砍邪教徒了！哦耶！", cond=function(npc, player) if player.female == true then return false else return true end end, action=function(npc, player) player:hasQuest("arena"):win() end},
		{"吾凯旋而归，待岁月流逝，笑群雄谁能挡我！", action=function(npc, player) player:hasQuest("arena"):win() end},
		{"#LIGHT_GREEN#*跳舞*", action=function(npc, player) player:hasQuest("arena"):win() end},
	}
}

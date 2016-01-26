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

local ogretext = ""
if player.descriptor and player.descriptor.subrace == "Ogre" then
	ogretext = "\n\n#{italic}##LIGHT_GREEN#*当你喝下药水，你的符文逐渐燃烧着消失，一股可怕的痛苦感从你的皮肤逐渐渗透到骨骼、肌肉、心脏。在痛苦中，你感到一阵晕眩袭来。醒来后，你发现身上的符文永远消失了。你感到无比疲惫……然而，你终于被自然的力量所净化了。*#{normal}##WHITE#"
end

newChat{ id="welcome",
	text = ([[干的好！你真正证明了那些魔法产生的火焰和风暴根本不是剑与矢的对手！来吧，加入我们的阵营，你已经准备好了。
#LIGHT_GREEN#*他给你一瓶药剂。*#WHITE#
喝下它，这是我们从一种非常稀有的龙身上提取出来的。它会使你拥有反抗魔法和与魔法战斗的能力，不过你以后也不能使用魔法了。%s]]):format(ogretext),
	answers = {
		{"谢谢！我不会再让魔法取得胜利了！ #LIGHT_GREEN#[你喝下了药剂。]", action=function(npc, player) player:setQuestStatus("antimagic", engine.Quest.COMPLETED) end},
	}
}

return "welcome"


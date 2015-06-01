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

local function kill(npc, player)
	player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "killed-aeryn")
	npc.die = nil
	mod.class.NPC.die(npc, player)
end

local function spare(npc, player)
	player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "spared-aeryn")
	npc.die = nil
	game.level:removeEntity(npc)
	game.logPlayer(player, "%s grabs her amulet and disappears in a whirl of arcane energies.", npc.name:capitalize())
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*她倒在你的脚下，快要死了。*#WHITE#
那么，现在你会杀死我然后完成毁灭法阵？]],
	answers = {
		{"你在说什么？你为什么要攻击我？", jump="what"},
		{"说吧，也许我会饶恕你，你为什么要攻击我？", jump="what"},
		{"[杀了她。]", action=kill},
	}
}

newChat{ id="what",
	text = [[你……你不知道？
你进入这个地方几个小时以后，兽人突袭了我们。他们不是单独来的——还有大量恶魔跟随着他们。我们寡不敌众！被彻底击败了！
我的领地已经不复存在！全都是因为你，没能在灼烧之痕阻止他们！你背叛了我们！这么多人为你而死，而你却背叛了我们！
#LIGHT_GREEN#*她开始哭泣……*#WHITE#]],
	answers = {
		{"我知道我所犯下的错误，我会设法弥补。请让我通过这里，我没办法拯救你的人民，但是我不会让他们白白牺牲！", action=spare},
		{"[杀了她。]", action=kill},
	}
}

return "welcome"

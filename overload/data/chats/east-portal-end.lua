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
	text = [[#LIGHT_GREEN#*当你走出传送门时，一个穿着长袍的人正在那里等着你。*
#WHITE#见到你很高兴， @playername@!
我是马雷纳斯，安格利文的传令官。我接到托拉克国王的命令在此等候你，他一直很担心你。
我们已经观察了泰恩一段时间，我们非常高兴地看到你揭露了他的真面目并阻止了他。因此我们非常荣幸地请你回来。
我们已经分析了他关于传送门的研究，如果你把那些相关的部件给我，我就可以立即给你创造一个传送门，就是此时此刻。]],
	answers = {
		{"是的，泰恩的确不是个好人。感谢你的帮助，这些就是传送门的部件。[交给他宝石和祭祀匕首。]", action=function(npc, player) player:hasQuest("east-portal"):create_portal(npc, player) end},
	}
}

return "welcome"

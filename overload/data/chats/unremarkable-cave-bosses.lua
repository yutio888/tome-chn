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

local function attack_krogar(npc, player)
	local fillarel, krogar
	for uid, e in pairs(game.level.entities) do
		if e.define_as == "FILLAREL" and not e.dead then fillarel = e
		elseif e.define_as == "CORRUPTOR" and not e.dead then krogar = e end
	end
	krogar.faction = "enemies"
	fillarel.inc_damage.all = -80
	fillarel:setTarget(krogar)
	krogar:setTarget(filarel)
	game.player:setQuestStatus("strange-new-world", engine.Quest.COMPLETED, "sided-fillarel")
end

local function attack_fillarel(npc, player)
	local fillarel, krogar
	for uid, e in pairs(game.level.entities) do
		if e.define_as == "FILLAREL" and not e.dead then fillarel = e
		elseif e.define_as == "CORRUPTOR" and not e.dead then krogar = e end
	end
	fillarel.faction = "enemies"
	krogar.inc_damage.all = -80
	fillarel:setTarget(krogar)
	krogar:setTarget(filarel)
	game.player:setQuestStatus("strange-new-world", engine.Quest.COMPLETED, "sided-krogar")
end

game.player:grantQuest("strange-new-world")

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个穿着金色长袍的美丽精灵女子站在你面前，看着穿锁甲的兽人。*#WHITE#
菲拉瑞尔：“投降吧，兽人！你不会赢的，我拥有太阳和月亮的神力。”
克罗格： "哈！才过了一个小时了，而你看上去已经很疲惫了，我的女士。"
#LIGHT_GREEN#*当你进入房间时他们注意到了你*#WHITE#
菲拉瑞尔： "你！ @playerdescriptor.race@!帮我干掉这只怪物，要不然给我滚开！"
克罗格： "哦？找人帮忙了？呸，@playerdescriptor.race@，给我干掉这个臭婊子，我会报答你的！"]],
	answers = {
		{"[攻击克罗格]", action=attack_krogar},
--		{"[攻击菲拉瑞尔]", action=attack_fillarel, cond=function(npc, player) return not player:hasQuest("start-sunwall") and config.settings.cheat end},
	}
}
return "welcome"

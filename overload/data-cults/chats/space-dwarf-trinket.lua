-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
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

-- setTextFont("/data/font/mainframe-opto.ttf", 18)

local jump = "default"
if player:attr("undead") then jump = "undead"
elseif player.descriptor and player.descriptor.subrace == "Dwarf" then jump = "dwarf"
elseif player.descriptor and player.descriptor.subrace == "Drem" then jump = "drem"
end

newChat{ id="welcome",
	text = [[#YELLOW_GREEN##{bold}#突然，奇怪的金属的机器发出了哔哔声，然后，开始说话了#{normal}##LAST#
与卫星建立上行链接。启动紧急通信阵列。
当前用户和之前的用户记录不匹配。正在扫描。]],
	answers = {
		{"..啥啥啥？", jump=jump},
	}
}

newChat{ id="dwarf",
	text = [[#YELLOW_GREEN##{bold}#这个机器哔哔了几下，又说了起来。#{normal}##LAST#
	用户的生理学特征符合目标物种，但是在数据库里并没有记录。正在发送信息以供进一步分析。

用户已添加到数据库。我现在是你的私人助理，直到进一步的救援前来之前，我会持续照料你。已启动保护性电磁屏障和实时健康监测程序。]],
	answers = {
		{"目标物种？", jump="end", action=function(npc, player)
			local _, item, inven_id = player:findInAllWornInventoriesByObject(true, npc)
			if inven_id then player:onTakeoff(npc, inven_id, true, true) end
			npc.helper_mode = true
			if inven_id then player:onWear(npc, inven_id, true, true) end
		end},
	}
}

newChat{ id="drem",
	text = [[#YELLOW_GREEN##{bold}#这个机器哔哔了几下，又说了起来。#{normal}##LAST#
由于不明原因，用户的生理特征表现出危险的基因劣化。正在发送信息以供进一步分析。]],
	answers = {
		{"基因？", jump="end"},
	}
}

newChat{ id="undead",
	text = [[#YELLOW_GREEN##{bold}#这个机器哔哔了几下，又说了起来。#{normal}##LAST#
没有检测到生命信号。目标看上去在活动，但没有活着的生物组织。正在发送信息以供进一步分析。]],
	answers = {
		{"看什么看，没见过不死生物啊？", jump="end"},
	}
}

newChat{ id="default",
	text = [[#YELLOW_GREEN##{bold}#这个机器哔哔了几下，又说了起来。#{normal}##LAST#
用户的生理学特征不符合数据库中的任何已知物种。正在发送信息以供进一步分析。]],
	answers = {
		{"数据库？", jump="end"},
	}
}

newChat{ id="end",
	text = [[#YELLOW_GREEN##{bold}#机器发出两下哔哔声，然后完全安静了下来。你再也没法让它再次说话了。#{normal}##LAST#]],
	answers = {
		{"真奇怪…", action=function(npc, player) world:gainAchievement("CULTS_DWARVEN_ORIGIN", game:getPlayer(true), "spacesuit") end},
	}
}

return "welcome"

-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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

local change_inven = function(npc, player)
	local d
	local titleupdator = player:getEncumberTitleUpdator(("Equipment(%s) <=> Inventory(%s)"):format(npc.name:capitalize(), player.name:capitalize()))
	d = require("mod.dialogs.ShowEquipInven").new(titleupdator(), npc, nil, function(o, inven, item, button, event)
		if not o then return end
		local ud = require("mod.dialogs.UseItemDialog").new(event == "button", npc, o, item, inven, function(_, _, _, stop)
			d:generate()
			d:generateList()
			d:updateTitle(titleupdator())
			if stop then game:unregisterDialog(d) end
		end, true, player)
		game:registerDialog(ud)
	end, nil, player)
	game:registerDialog(d)
end

local change_talents = function(npc, player)
	local LevelupDialog = require "mod.dialogs.LevelupDialog"
	local ds = LevelupDialog.new(npc, nil, nil)
	game:registerDialog(ds)
end

local change_tactics = function(npc, player)
	game.party:giveOrders(npc)
end

local change_control = function(npc, player)
	game.party:select(npc)
end

local change_name = function(npc, player)
	local d = require("engine.dialogs.GetText").new("更换傀儡的名字。", "名字", 2, 25, function(name)
		if name then
			npc.name = name.." ("..player.name.." 的仆人)"
			npc.changed = true
		end
	end)
	game:registerDialog(d)
end

local change_appearance = function(npc, player)
	require("mod.dialogs.Birther"):showCosmeticCustomizer(npc, "Golem Cosmetic Options", function()
		npc.golem_appearance_set = true
	end)
end

local ans = {
	{"我想更换你的护甲。", action=change_inven},
	{"我想改变你的技能。", action=change_talents},
	{"我想调整你的策略。", action=change_tactics},
	{"我想直接操控你。", action=change_control},
	{"我想改变你的名字。", cond = function() return golem.sentient_telos == 1 end, jump="name", action=function(npc, player) npc.name = "Telos the Great and Powerful (reluctant follower of "..npc.summoner.name..")" game.log("#ROYAL_BLUE#The golem decides to change it's name to #{bold}#%s#{normal}#.", npc.name) end},
	{"我想改变你的名字。", cond = function() return not golem.sentient_telos end, action=change_name},
	{"你居然能说话?", cond = function() return golem.sentient_telos == 1 end, jump="how_speak"},
	{"我想要改变你的外观 (只能进行一次)。", cond = function(npc, player) return profile:isDonator() and not npc.golem_appearance_set end, action=change_appearance},
	{"没事，走吧."},
}

newChat{ id="how_speak",
	text = [[如果你连说话都不能，就算得到永生还有什么乐趣？任何一个称职的大法师，在准备他们不道德的死后复活计划的时候，都一定会计划好确保在这种状况下也能让别人听到自己的声音。顺带一提，你操纵能量的技术连给我提鞋都不够。虽然我猜，我正在用你的傀儡制作技能来弥补它。]],
	answers = ans
}

newChat{ id="name",
	text = [[改变我的名字？我的名字就是“泰勒斯”，谢谢。当然，如果你叫我“伟大的泰勒斯大人”我也不介意。对，赶紧这么做吧！]],
	answers = ans
}

if golem.sentient_telos == 1 then

newChat{ id="welcome",
	text = [[我是个傀儡。真可笑！
哦，你想要点什么吗？]],
	answers = ans
}

else

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*傀儡用一个单调的声音说：*#WHITE#
是，主人。]],
	answers = ans
}

end
return "welcome"

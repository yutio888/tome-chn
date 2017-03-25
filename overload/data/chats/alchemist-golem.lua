-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

local ans = {
	{"我想更换你的护甲。", action=change_inven},
	{"我想改变你的技能。", action=change_talents},
	{"我想调整你的策略。", action=change_tactics},
	{"我想直接操控你。", action=change_control},
	{"我想改变你的名字。", cond = function() return golem.sentient_telos == 1 end, jump="name", action=function(npc, player) npc.name = "Telos the Great and Powerful (reluctant follower of "..npc.summoner.name..")" game.log("#ROYAL_BLUE#The golem decides to change it's name to #{bold}#%s#{normal}#.", npc.name) end},
	{"我想改变你的名字。", cond = function() return not golem.sentient_telos end, action=change_name},
	{"你居然能说话?", cond = function() return golem.sentient_telos == 1 end, jump="how_speak"},
	{"没事，走吧."},
}

newChat{ id="how_speak",
	text = [[What's the good of immortality if you can't even speak? No archmage worth his salt is going to concoct some immoral life-after-death scheme without including some sort of capacity for making his opinions known. And, by the way, your energy manipulation techniques are on the same level as those of my average pair of shoes. Though I guess you are making up for it with your golem crafting skills.]],
	answers = ans
}

newChat{ id="name",
	text = [[Change my name? I'm quite happy being 'Telos' thankyou. Though I wouldn't mind being 'Telos the Great and Powerful'. Do that actually. Yes!]],
	answers = ans
}

if golem.sentient_telos == 1 then

newChat{ id="welcome",
	text = [[I'm a golem. How droll!
Oh, did you want something?]],
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

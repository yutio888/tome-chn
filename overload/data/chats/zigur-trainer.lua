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

if game.player:isQuestStatus("antimagic", engine.Quest.DONE) then
newChat{ id="welcome",
	text = [[你好我的朋友。]],
	answers = {
		{"再见。"},
	}
}
return "welcome"
end

local sex = game.player.female and "Sister" or "Brother"

local remove_magic = function(npc, player)
	for tid, _ in pairs(player.sustain_talents) do
		local t = player:getTalentFromId(tid)
		if t.is_spell then player:forceUseTalent(tid, {ignore_energy=true}) end
	end

	-- Remove equipment
	for inven_id, inven in pairs(player.inven) do
		for i = #inven, 1, -1 do
			local o = inven[i]
			if o.power_source and o.power_source.arcane then
				game.logPlayer(player, "You cannot use your %s anymore; it is tainted by magic.", o:getName{do_color=true})
				local o = player:removeObject(inven, i, true)
				player:addObject(player.INVEN_INVEN, o)
				player:sortInven()
			end
		end
	end
	player:attr("forbid_arcane", 1)
	player:attr("zigur_follower", 1)
	player.changed = true
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个冷酷的战士站在那里，穿着锁甲和橄榄色的大斗篷，他看上去不那么友善——身上有把带鞘的宝剑。*#WHITE#
我们观察了你很久，我们觉得你很有潜力。
我们看到这看似伟大的魔法技艺一直无法被这片大地所容忍。
我们可以训练你，不过你得保证你的忠诚，不再使用魔法力量，并且准备和魔法战斗到底。
你会挑战几个魔法对手，要是你打败他们，我们就会将我们的技能教给你，今后你也不能再使用魔法和魔法物品。

#LIGHT_RED#注：完成此任务会使该角色永久无法使用由奥术之力灌输而成的物品。取而代之的，是你可以获得一支精神力量的通用技能树——反魔法，同时你可以开启由奥术破坏之力灌输而成物品的隐藏属性。]],
	answers = {
		{"我接受挑战！", cond=function(npc, player) return player.level >= 10 end, jump="testok"},
		{"我接受挑战！", cond=function(npc, player) return player.level < 10 end, jump="testko"},
		{"我没什么兴趣。", jump="ko"},
	}
}

newChat{ id="ko",
	text = [[好吧，不得不说我有点失望，不过这是你自己的选择，再见。]],
	answers = {
		{"再见。"},
	}
}

newChat{ id="testko",
	text = [[啊，你很渴望战斗，但也许你还太年轻，回去等你成长一些再来吧。]],
	answers = {
		{"好吧。"},
	}
}

newChat{ id="testok",
	text = [[很好，在开始之前，我们得确认没有魔法可以帮助你：
- 你不能施放法术也不能使用任何魔法物品
- 你所装备的所有由魔法灌输能量的物品都必须取下。

准备好了么？或者你还要再准备一下？]],
	answers = {
		{"我准备好了。", jump="test", action=remove_magic},
		{"我需要准备一下。"},
	}
}

newChat{ id="test",
	text = [[#VIOLET#*你被两个战士抓了起来，扔进了一个露天角斗场里！*
#LIGHT_GREEN#*你听到斗士们的吼叫声环绕着你！*#WHITE#
你的训练开始了！我们要看到你超越魔法的能力，战斗吧！]],
	answers = {
		{"但那个……[你注意到你的第一个对手已经出现在战场上了]", action=function(npc, player)
			player:grantQuest("antimagic")
			player:hasQuest("antimagic"):start_event()
		end},
	}
}

return "welcome"

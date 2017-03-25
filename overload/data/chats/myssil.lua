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

local p = game.party:findMember{main=true}
if not p:attr("forbid_arcane") or p:attr("forbid_arcane") < 2 then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个半身人女人站在你面前，穿着黑色板甲*#WHITE#
先到导师那里参加对抗奥术魔法的测试，然后再说话。]],
	answers = {
		{"但是……"},
	}
}
return "welcome"
end



newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个半身人女人站在你面前，穿着黑色的钢板甲*#WHITE#
我是守护者米歇尔，欢迎来到伊格。]],
	answers = {
		{"我需要一切可以获得的帮助，不是为我自己，是为了东北部的德斯小镇。", jump="save-derth", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and q:isCompleted("saved-derth") and not q:isCompleted("tempest-entrance") and not q:isStatus(q.DONE) end},
		{"守护者，我已经按您的意思将风暴术士杀死了……", jump="tempest-dead", cond=function(npc, player) local q = player:hasQuest("lightning-overload") return q and q:isCompleted("tempest-entrance") and not q:isCompleted("antimagic-reward") and q:isStatus(q.DONE) end},
		{"再见，守护者。"},
	}
}

newChat{ id="save-derth",
	text = [[是的，我们已经感觉到了那里的堕落气息，我已经派人去驱散那里的乌云，但是真正的威胁并不在那儿。
据我们所知，一个风暴术士，可以操控风暴的元素法师，和这些破坏有关。安格利文的那些懦夫居然袖手旁观。真是堕落！
所以你必须采取行动， @playername@。我会告诉你那个法师所在的位置，在岱卡拉山脉的最高峰。
除掉他。]],
	answers = {
		{"你可以信任我，守护者。", action=function(npc, player)
			player:hasQuest("lightning-overload"):create_entrance()
			game:unlockBackground("myssil", "Protector Myssil")
		end},
	}
}

newChat{ id="tempest-dead",
	text = [[我已经听说了，@playername@。你已经证明了你训练的价值。愿自然赐福于你，伊格勇士 @playername@。
	#LIGHT_GREEN#她将手放到你的身上，你感到自然的力量充斥着你的每个毛孔。
	*#WHITE#这个应该会对你的旅途有所帮助。保重！]],
	answers = {
		{"Thank you, Protector.", action=function(npc, player)
			player:hasQuest("lightning-overload"):create_entrance()
			if player:knowTalentType("wild-gift/fungus") then
				player:setTalentTypeMastery("wild-gift/fungus", player:getTalentTypeMastery("wild-gift/fungus") + 0.1)
			elseif player:knowTalentType("wild-gift/fungus") == false then
				player:learnTalentType("wild-gift/fungus", true)
			else
				player:learnTalentType("wild-gift/fungus", false)
			end
			-- Make sure a previous amulet didnt bug it out
			if player:getTalentTypeMastery("wild-gift/fungus") == 0 then player:setTalentTypeMastery("wild-gift/fungus", 1) end
			game.logPlayer(player, "#00FF00#You gain the fungus talents school.")
			if player:knowTalentType("cunning/trapping") then
				game.party:learnLore("zigur-purging-trap")
			end	
			player:hasQuest("lightning-overload"):setStatus(engine.Quest.COMPLETED, "antimagic-reward")
		end},
	}
}

return "welcome"

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
	text = [[@playername@，欢迎来到我的商店。]],
	answers = {
		{"让我看看你的商品吧。", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"我是来学习法杖格斗的。", jump="training"},
		{"抱歉，我要走了！"},
	}
}

newChat{ id="training",
	text = [[我能教授你法杖格斗(法术/法杖格斗 技能树)。学会基础消耗100金币，想学的更多就得花上500金币。当你学会之后，只要750金币，我就能传授你一些进阶技巧。]],
	answers = {
		{"只学习基础（显示带解锁的技能树）- 100 金币。", action=function(npc, player) -- Normal basic training
			game.logPlayer(player, "商店主人用一小段时间对你介绍了法杖格斗的基础。")
			player:incMoney(-100)
			player:learnTalentType("spell/staff-combat", false)
			if player:getTalentTypeMastery("spell/staff-combat") < 1 then
				player:setTalentTypeMastery("spell/staff-combat", math.min(1.1, player:getTalentTypeMastery("spell/staff-combat") + 0.3))
				game.logPlayer(player, "他对你学习的速度表示惊讶。")
			end
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 100 then return end
			if player:knowTalentType("spell/staff-combat") or player:knowTalentType("spell/staff-combat") == false then return end
			return true
		end},
		{("请教授我需要知道的一切（显示已解锁的技能树）。 - %d 金币。"):format(500),
		action=function(npc, player) --Normal intensive training
			game.logPlayer(player, "商店主人耗费一段时间教给你法杖格斗的全部技巧。")
			player:incMoney(-500)
			player:learnTalentType("spell/staff-combat", true)
			if player:getTalentTypeMastery("spell/staff-combat") < 1 then -- Special case for previously locked category (escort)
				player:setTalentTypeMastery("spell/staff-combat", math.max(1.0, player:getTalentTypeMastery("spell/staff-combat") + 0.3))
			end
			if player:getTalentTypeMastery("spell/staff-combat") > 1 then
				game.logPlayer(player, "他对你的掌握程度表示惊讶，并对你展示了一些额外的技巧。")
			end
			player.changed = true
		end,
		cond=function(npc, player)
			if player.money < 500 then return end
			if player:knowTalentType("spell/staff-combat") then return end
			return true
		end},
		{"我已经学会了，但我想成为一名专家。(增加技能树系数0.2) - 750 金币。", action=function(npc, player) --Enhanced intensive training
			player:incMoney(-750)
			player:learnTalentType("spell/staff-combat", true)
			player:setTalentTypeMastery("spell/staff-combat", player:getTalentTypeMastery("spell/staff-combat") + 0.2)
			game.logPlayer(player, ("商店主人用大量时间向你传授法杖格斗的所有细节%s。"):format(player:getTalentTypeMastery("spell/staff-combat")>1 and ",包括一些秘密流传的机巧。" or ""))
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 750 then return end
			if player:knowTalentType("spell/staff-combat") and player:getTalentTypeMastery("spell/staff-combat") < 1.2 then return true end
		end},
		{"不，谢谢。"},
	}
}

return "welcome"

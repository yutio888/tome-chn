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

local function void_portal_open(npc, player)
	-- Charred scar was successful
	if player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted("stopped") then return false end
	return true
end
local function aeryn_alive(npc, player)
	if game.state:isUniqueDead("High Sun Paladin Aeryn") then return false end

	-- Charred scar was successful
	if player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted("stopped") then return true end

	-- Spared aeryn
	return player:isQuestStatus("high-peak", engine.Quest.COMPLETED, "spared-aeryn")
end
local function aeryn_dead(npc, player) return not aeryn_alive(npc, player) end

local function aeryn_comes(npc, player)
	local x, y = util.findFreeGrid(player.x, player.y, 1, true, {[engine.Map.ACTOR]=true})
	local aeryn = game.zone:makeEntityByName(game.level, "actor", "HIGH_SUN_PALADIN_AERYN")
	if aeryn then
		game.zone:addEntity(game.level, aeryn, "actor", x, y)
		game.player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "aeryn-helps")
		game.logPlayer(player, "High Sun Paladin Aeryn appears next to you!")

		-- The sorcerer focus her first
		for uid, e in pairs(game.level.entities) do
			if e.define_as and (e.define_as == "ELANDAR" or e.define_as == "ARGONIEL") then
				e:setTarget(aeryn)
			end
		end
	end
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*两个魔法师站在你面前，像太阳一样闪闪发光。*#WHITE#
喔～！我们的客人终于来到了这里。看来我们是到了舞会的高潮了，不是么？]],
	answers = {
		{"我不是来和你们聊天的，我是来阻止你们的！", jump="explain"},
		{"你们为什么这么做？你们本来是被期望帮助别人的！", jump="explain"},
	}
}

newChat{ id="explain",
	text = [[唔～但是我们确实一直在帮助人们，我们得出了一个明确的结论，就是普通人根本不能管好自己，只会无休止的争吵、争斗……
自从最后一波兽人入侵之后，人们就不再有别的威胁使他们联合在一起了！]],
	answers = {
		{"所以你们觉得使你们自己成为人们新的威胁？", jump="explain2"},
	}
}

newChat{ id="explain2",
	text = [[我们？哦，不是，我们不过是主人的工具。我们正在筹划他的到来。]],
	answers = {
		{"那他将是……？", jump="explain3"},
	}
}

if void_portal_open(nil, game.player) then
newChat{ id="explain3",
	text = [[造物主，创造这个世界的神，他默默的看着你们在这个大陆上争战不休。
他对这个世界感到非常失望，它现在将要扫清这个世界所有的障碍，然后重新创造它，使它更美好！
法杖的力量使我们吸收了足够的能量来开启虚空传送门召唤他的降临！
已经太晚了！在我们说话的时刻他已经在穿越传送门了！只需几个小时的时间！]],
	answers = {
		{"我要阻止你，世界不会在今天灭亡！", jump="aeryn", switch_npc={name="High Sun Paladin Aeryn"}, action=aeryn_comes, cond=aeryn_alive},
		{"我要阻止你，世界不会在今天灭亡！", cond=aeryn_dead},
	}
}
else
newChat{ id="explain3",
	text = [[造物之主，创造这个世界的神，他默默的看着你们在这个大陆上争战不休。
他对这个世界感到非常失望，它现在将要扫清这个世界所有的障碍，然后重新创造它，使它更好！
法杖的力量使我们吸收了足够的能量开启虚空传送门来召唤他的降临！
你已经无法阻止我们了！]],
	answers = {
		{"我要阻止你，世界不会在今天灭亡！", jump="aeryn", switch_npc={name="High Sun Paladin Aeryn"}, action=aeryn_comes, cond=aeryn_alive},
		{"我要阻止你，世界不会在今天灭亡！", cond=aeryn_dead},
	}
}
end

newChat{ id="aeryn",
	text = [[#LIGHT_GREEN#*空气在你身边回旋，突然高阶太阳骑士艾伦出现了！*#WHITE#
你不是一个人在战斗！我们一起来阻止他们，战斗至最后一刻！]],
	answers = {
		{"很高兴你能协助我，女士！我们来打败这些巫师！"},
	}
}

return "welcome"

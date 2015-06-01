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
	text = [[等等， @playerdescriptor.subclass@！
我看你是个有价值的对手，够强力。我可以看到和感觉到，你对魔法技艺的熟练程度。
我们可是同行。]],
	answers = {
		{"“同行”是什么意思？", jump="quest"},
		{"谁跟你是同行，去死吧！", quick_reply="如此的话。去死吧，把你的能量给我！"},
	}
}

newChat{ id="quest",
	text = [[我们都了解奥术的力量，我们也都渴求力量。我已经发现了很多东西，有很多我可以教你。
这个地方很特别。这里与真理只隔着一层薄薄的面纱，已经被魔法大爆炸永久削弱了。我们可以利用它。
我们可以吸收力量，从这个地方吸取，来强大我们自身，使我们成为魔法的主宰！]],
	answers = {
		{"魔法大爆炸已经给这个世界带来了足够的灾难。魔法必须服务于人，而不是奴役别人。我不会听你的！", quick_reply="如此的话。去死吧，把你的能量给我！"},
		{"那你的建议呢？", jump="quest2"},
	}
}

newChat{ id="quest2",
	text = [[让我们停止这无畏的争斗。你有没有听说过一群叫做伊格兰斯的人？
这些疯子认为魔法不应该存在！他们害怕我们，害怕我们的力量。
让我们联合起来干掉那些笨蛋！]],
	answers = {
		{"魔法必胜！", jump="quest3", action=function(npc, player)
			if npc:isTalentActive(npc.T_DEMON_PLANE) then npc:forceUseTalent(npc.T_DEMON_PLANE, {ignore_energy=true}) end
			if player:isTalentActive(player.T_DEMON_PLANE) then player:forceUseTalent(player.T_DEMON_PLANE, {ignore_energy=true}) end
			if player:hasEffect(player.EFF_DREAMSCAPE) then player:removeEffect(player.EFF_DREAMSCAPE, true) end
		end},
		{"魔法自有它的用处。那些人想错了，不过你比他们错的更离谱。", quick_reply="那么你必须离开……这个世界！死吧！"},
	}
}

newChat{ id="quest3",
	text = [[很好。在你到来之前，我们正准备攻击伊格兰斯在萨希之海南部沙滩的主要训练营地。
和我们一起，去干掉他们！
我会打开去伊格的传送门，然后大屠杀就要开始了！]],
	answers = {
		{"我准备好了！", action=function(npc, player)
			if game.zone.short_name ~= "mark-spellblaze" then return "quest3" end
			npc:disappear()
			player:grantQuest("anti-antimagic")
		end},
	}
}

return "welcome"

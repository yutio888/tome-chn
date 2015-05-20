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

newAchievement{
	name = "Level 10",
	show = "full",
	desc = [[角色达到10级。]],
}
newAchievement{
	name = "Level 20",
	show = "full",
	desc = [[角色达到20级。]],
}
newAchievement{
	name = "Level 30",
	show = "full",
	desc = [[角色达到30级。]],
}
newAchievement{
	name = "Level 40",
	show = "full", huge=true,
	desc = [[角色达到40级。]],
}
newAchievement{
	name = "Level 50",
	show = "full", huge=true,
	desc = [[角色达到50级。]],
}

newAchievement{
	name = "Unstoppable",
	show = "full",
	desc = [[使用生命之血复活。]],
}

newAchievement{
	name = "Utterly Destroyed", id = "EIDOLON_DEATH",
	show = "name",
	desc = [[在死神幻象位面死亡。]],
}

newAchievement{
	name = "Fool of a Took!", id = "HALFLING_SUICIDE",
	show = "name",
	desc = [[选择半身人种族并杀死自己。]],
	can_gain = function(self, who)
		if who.descriptor and who.descriptor.race == "Halfling" then return true end
	end
}

newAchievement{
	name = "Emancipation", id = "EMANCIPATION",
	image = "npc/alchemist_golem.png",
	show = "name", huge=true,
	desc = [[当傀儡杀死BOSS时，炼金术师已死亡。]],
	mode = "player",
	can_gain = function(self, who, target)
		local p = game.party:findMember{main=true}
		if target.rank >= 3.5 and p.dead and p.descriptor.subclass == "Alchemist" and p.alchemy_golem and game.level:hasEntity(p.alchemy_golem) and not p.alchemy_golem.dead then
			return true
		end
	end,
	on_gain = function(_, src, personal)
--		game:setAllowedBuild("construct")
--		game:setAllowedBuild("construct_runic_golem", true)
	end,
}

newAchievement{
	name = "Take you with me", id = "BOSS_REVENGE",
	show = "full", huge=true,
	desc = [[与BOSS同时死亡。]],
	mode = "player",
	can_gain = function(self, who, target)
		local p = game.party:findMember{main=true}
		if target.rank >= 3.5 and p.dead then
			return true
		end
	end,
}

newAchievement{
	name = "Look at me, I'm playing a roguelike!", id = "SELF_CENTERED",
	show = "name",
	desc = [[将自己的数据链接到聊天框。]],
}

newAchievement{
	name = "Fear me not!", id = "FEARSCAPE",
	show = "full",
	desc = [[在恐惧长廊幸存下来。]],
}

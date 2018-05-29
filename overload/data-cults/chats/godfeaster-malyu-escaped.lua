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

local function finish(mode)
	game.state.cults_malyu_reward_mode = mode
	return function(npc, player)
		world:gainAchievement("CULTS_ESCORTED", player)
	end
end

local talent_name = "---"
local cat_name = "---"

local cat_list = {}
for kind, status in pairs(player.talents_types) do if status == true then
	local tt = player:getTalentTypeFrom(kind)
	if tt and tt.generic then cat_list[#cat_list+1] = tt.type end
end end
if #cat_list > 0 then cat_name = rng.table(cat_list) end

local talent_list = {}
for tid, lvl in pairs(player.talents) do
	local t = player:getTalentFromId(tid)
	if not t.generic and not t.is_inscription and t.hide ~= "always" and not t.cant_steal and not t.no_npc_use then
		talent_list[#talent_list+1] = {name=t.name, lvl=lvl}
	end
end
table.sort(talent_list, "lvl")
if #talent_list > 0 then talent_name = rng.table(talent_list).name end

newChat{ id="welcome",
	text = [[#DARK_SEA_GREEN##{italic}#新鲜的空气！#{normal}##LAST#
	干得好！你做的比我想象中的好多了。现在，一般我会得到一个奖励…唔？你为什么这么看着我？很显然，我救了你。冒险者做好事的时候通常会得到奖励。]],
	answers = {
		{"[你决定教她 '"..talent_name.."'.]", jump="talent", action=finish("talent")},
		{"[你决定教她 '"..cat_name.."'.]", jump="category", action=finish("category")},
		{"[你决定增加她的属性]", jump="stats", action=finish("stats")},
		{"[你什么也不给她。]", jump="nothing", action=finish("nothing")},
	}
}

newChat{ id="talent",
	text = [[哦，这个技能很有用！谢谢！]],
	answers = {
		{"那就这样吧，再见！"},
	}
}

newChat{ id="category",
	text = [[太好了！我一直想要学这种东西！]],
	answers = {
		{"那就这样吧，再见！"},
	}
}

newChat{ id="stats",
	text = [[哦，我觉得我的潜能增长了！]],
	answers = {
		{"那就这样吧，再见！"},
	}
}

newChat{ id="nothing",
	text = [[…好吧，就这样吧。祝你一路顺风！]],
	answers = {
		{"你也是！"},
	}
}

return "welcome"

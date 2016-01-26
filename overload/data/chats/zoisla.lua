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

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个娜迦穿过了传送门，看上去她好像级别比较高。*#WHITE#
不！你个蠢货！传送门要完了！]],
	answers = {
		{"那么，我的任务也完成了，臭蛇人！", jump="fool"},
	}
}

newChat{ id="fool",
	text = [[你不明白：它会爆炸！]],
	answers = {
		{"...", action = function(npc, player)
			game:onTickEnd(function()
				game.level:removeEntity(npc)
				game:changeLevel(2, (rng.table{"trollmire","ruins-kor-pul","scintillating-caves","rhaloren-camp","norgos-lair","heart-gloom"}), {direct_switch=true})

				local a = require("engine.Astar").new(game.level.map, player)

				local sx, sy = util.findFreeGrid(player.x, player.y, 20, true, {[engine.Map.ACTOR]=true})
				while not sx do
					sx, sy = rng.range(0, game.level.map.w - 1), rng.range(0, game.level.map.h - 1)
					if game.level.map(sx, sy, engine.Map.ACTOR) or not a:calc(player.x, player.y, sx, sy) then sx, sy = nil, nil end
				end

				game.zone:addEntity(game.level, npc, "actor", sx, sy)
				game.level.map:particleEmitter(player.x, player.y, 1, "teleport_water")
				game.level.map:particleEmitter(sx, sy, 1, "teleport_water")

				game:onLevelLoad("wilderness-1", function(zone, level, data)
					local list = {}
					for i = 0, level.map.w - 1 do for j = 0, level.map.h - 1 do
						local idx = i + j * level.map.w
						if level.map.map[idx][engine.Map.TERRAIN] and level.map.map[idx][engine.Map.TERRAIN].change_zone == data.from then
							list[#list+1] = {i, j}
						end
					end end
					if #list > 0 then
						game.player.wild_x, game.player.wild_y = unpack(rng.table(list))
					end
				end, {from=game.zone.short_name})

				local chat = require("engine.Chat").new("zoisla", npc, player)
				chat:invoke("kill")
			end)
		end},
	}
}

newChat{ id="kill",
	text = [[在爆炸之前，传送门同时把我们两个随机传送了一个地方。
蠢货！你注定要碰到我们，我们 #{bold}#无所不在！#{normal}#
死吧！]],
	answers = {
		{"……", action=function(npc, player) world:gainAchievement("SUNWALL_LOST", player) end},
	}
}

return "welcome"

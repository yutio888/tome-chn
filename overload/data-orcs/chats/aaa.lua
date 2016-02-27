

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*你面前有一个奇怪的三角形设备，似乎是某种自动存储设施。*#WHITE#]],
	answers = {
		{"[接近商店]", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player, npc.name)
		end},
		{"[改写程序，令其迁移至克鲁克部落]", jump="relocate", cond=function() return game.zone.short_name ~= "orcs+town-kruk" end},
		{"[离开]"},
	}
}

newChat{ id="relocate",
	text = [[#LIGHT_GREEN#*你操作了商店设备，执行了迁移程序。*#WHITE#]],
	answers = {
		{"[目的地：克鲁克部落]", action=function(npc, player)
			game.level:removeEntity(npc, true)
			game.state.aaas_for_kruk = game.state.aaas_for_kruk or {}
			game.state.aaas_for_kruk[#game.state.aaas_for_kruk+1] = npc
			game:onLevelLoad("orcs+town-kruk-1", function(zone, level)
				if not game.state.aaas_for_kruk or #game.state.aaas_for_kruk == 0 then return end
				local aaa = table.remove(game.state.aaas_for_kruk)
				local tries = 1000
				while tries > 0 do tries = tries - 1
					local spot = level:pickSpotRemove{type="aaa", subtype="aaa"}
					if spot and not level.map(spot.x, spot.y, level.map.ACTOR) then
						zone:addEntity(level, aaa, "actor", spot.x, spot.y)
						break
					end
				end
			end)
		end},
		{"[离开]"},
	}
}

return "welcome"

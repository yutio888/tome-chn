

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*Several loyal Orcs are eagerly waiting outside the palace to meet you; one steps forward, handing you a set of keys.  The word 'DESTRUCTICUS' is etched into one.*#WHITE#
Chief @playername@!  The Giants are fleeing, and we intercepted a scout carrying this!  We believe they can be used with...  well, you should see for yourself!  Please, come with us to the mountains just south of Kruk Pride!
#LIGHT_GREEN#*This sounds important.  You should probably head there right away!*#WHITE#]],
	answers = {
		{"Lead the way.", action=function(npc, player)
			local spot = game.level:pickSpot{type="questpop", subtype="destructicus"}
			if spot then player:move(spot.x, spot.y + 1, true) end
		end},
	}
}

return "welcome"

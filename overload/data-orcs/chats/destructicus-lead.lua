

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*数名忠诚的兽人在宫殿外焦急地等待着你;其中一名兽人走上前，交给你一串钥匙，上面写着'毁灭号'。*#WHITE#
@playername@首领! 巨人们在逃跑，我们抓住了一名侦查兵，他身上带着这个!我们认为它是用于... 算了，您应该亲自来看看! 请跟我来，在部落南部的山脉里!
#LIGHT_GREEN#*这听起来非常重要，你应该马上过去!*#WHITE#]],
	answers = {
		{"带路吧。", action=function(npc, player)
			local spot = game.level:pickSpot{type="questpop", subtype="destructicus"}
			if spot then player:move(spot.x, spot.y + 1, true) end
		end},
	}
}

return "welcome"

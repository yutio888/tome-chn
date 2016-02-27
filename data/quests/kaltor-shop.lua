questCHN["The Grumpy Shopowner"] = {
	name = "脾气暴躁的店主",
	description = function(desc)
		
		desc = desc:gsub("Kaltor's shop seems to be nearby in the mountain. Maybe it could be interesting to pay him a visit?","卡托尔的店铺似乎就在附近的山中。或许你有兴趣到此一游？")
		desc = desc:gsub("He does sound well armed, though, so be prepared as it is likely very dangerous.","不过，听说他全副武装，所以请做好准备。")
		desc = desc:gsub("So maybe take some time to plan the raid.","如果你想要干掉他，请择时计划一下。")
		desc = desc:gsub("You have disposed of Kaltor, the loot is yours!","你做掉了卡托尔，他的宝藏归你了！")

		return desc
	end}

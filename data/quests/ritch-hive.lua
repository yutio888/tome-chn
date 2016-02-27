questCHN["A Ritch Party"] = {
	name = "里奇派对",
	description = function(desc)
		
		desc = desc:gsub("Our ultimate goal on the mainland is to get rid of the Sunwall once and for all.","我们在大陆上的最终目的是一劳永逸地清除太阳堡垒的威胁。")
		desc = desc:gsub("To do that we will prepare a special surprise to help our final attack.","为此，我们必须为最终的突袭做好准备，给他们一个“惊喜”。")
		desc = desc:gsub("Go to the Ritch Hive in the mountains north of the Erúan desert and collect a big pile of ritch eggs.  About 30 viable eggs should be sufficient.","前去艾露安沙漠北部丘陵中的里奇虫巢，收集大量的里奇虫卵。至少要30个才够。")
		desc = desc:gsub("When you have enough, find a tunnel leading north and use the special sand shredder gloves tinker to open a path under the Gates of Morning.","当你有了足够的里奇虫卵，找到一条向北的隧道，使用特殊的挖沙手套插件来挖出一条通向晨曦之门的道路。")
		desc = desc:gsub("Finally, place the eggs in a protected spot to hatch.  With luck, they will provide a distraction while you later assault the city.","最后，在合适的地方放置这些虫卵来腐化它们。运气好的话，当你之后袭击城市的时候，它们可以大大扰乱敌军。")
		desc = desc:gsub("You have collected enough eggs.","你收集手机了足够多的虫卵")
		desc = desc:gsub("You have tunnelled close enough to the Gates of Morning.#WHITE#","你已经向北挖到晨曦之门的地方。")
		desc = desc:gsub("You have placed the little surprise.","你安排好了了这些小小的“惊喜”。")

		return desc
	end}

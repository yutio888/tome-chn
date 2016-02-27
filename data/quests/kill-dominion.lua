questCHN["This is our land!"] = {
	name = "这是我们的土地！",
	description = function(desc)
		
		desc = desc:gsub("A group of trolls from the Kar'Haïb Dominion is trying to take foot on the mainland.","一群来自卡尔·亥巴自治领的巨魔试图染指这片土地。")
		desc = desc:gsub("With the Sunwall at full force we can not have the luxury of having to fight on both fronts, the Dominion port of the south must be destroyed.","由于太阳堡垒已经全军戒备，我们决不能两面受低。自治领的港口必须被摧毁。")
		desc = desc:gsub("A potent bomb was given to you, you must place it at a weak spot of the tower where it will detonate and destroy the port.","我们给了你一个强力的炸弹，你必须把它放在塔楼的脆弱处，它会爆炸并摧毁港口。")
		desc = desc:gsub("It would be a good idea for you to not be there anymore when the bomb explodes however.","在炸弹爆炸前，你最好提前逃走")
		desc = desc:gsub("You have destroyed the Dominion port, the trolls will not be a problem in the near future.","你已经摧毁了自治领港口，巨魔侵袭的危险短期内不会再出现了。")

		return desc
	end}

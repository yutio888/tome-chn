questCHN["Yeti Reinforcements"] = {
	name = "雪人援军",
	description = function(desc)
		
		desc = desc:gsub("You found a yeti mind control tinker. If you can tame 8 wild yetis and send them back to Kruk Pride they can be trained and sent back to you at your request using a psychoportation beacon.","你找到了一个雪人心灵控制器配件。如果你可以驯服八个野生的雪人并把它们带回克鲁克部落，你使用一个心灵传动装置来召唤他们为你而战。")
		desc = desc:gsub("Wild yetis are mostly found in yeti's caves.","野生雪人主要出现在雪人洞穴。")
		desc = desc:gsub("Captured eight yetis (will be available to summon at level 20).","抓住了八只雪人（你至少需要20级才能召唤他们）")
		desc = desc:gsub("Captured","抓住了")
		desc = desc:gsub("/8 yetis.","/8只雪人")

		return desc
	end}

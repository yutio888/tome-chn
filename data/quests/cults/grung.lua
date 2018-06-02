questCHN["A View From The Gallery"] = 
{
	name = "回廊一瞥",
	description = function(desc)
		
		desc = desc:gsub("You are Grung, a halfling from the Age of Haze.","你是Grung，一名来自阴影纪的半身人。")
		desc = desc:gsub("You must gather food or die but outside there is a terrible war being fought.","你必须收集食物，否则你会死。但是外面正在激烈地交战。")
		desc = desc:gsub("A war between incomprehensible beings for incomprehensible reasons.","那是一场不能理解的存在为了不能理解的理由引发的战争。")
		desc = desc:gsub("All you can hope to do is gather food while avoiding to get crushed.","你唯一能做的，是避免自己卷入战争而被消灭。")
		desc = desc:gsub("You have gathered enough food for a few day for your tribe, go back home now.","你收集到了足够的食物，快回家去")
		desc = desc:gsub("You have came home with the food.","你成功地带回了食物")

		return desc
	end
}


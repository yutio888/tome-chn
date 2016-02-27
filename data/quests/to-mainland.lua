questCHN["You Shall Pass!"] = {
	name = "你必须通过！",
	description = function(desc)
		
		desc = desc:gsub("The Atmos tribe is not our sole problem. The Sunwall as grown in strength since the Scourge from the West came and murdered the other Prides leaders.","气之部族不是我们唯一的问题。自从那个西部来得灾星来到这里并屠杀了我们的部落领袖，太阳堡垒的实力与日俱增。")
		desc = desc:gsub("Our brothers on the mainland lay enslaved, but before we free them you must secure a way to the mainland.","我们在大陆上的兄弟惨遭奴役，为了解放他们我们必须找到一条到达大陆的安全的路。")
		desc = desc:gsub("Go to the sunwall outpost. Show them the wrath of Garkul, show no mercy for they have none for us.","前去太阳堡垒前哨站。让他们领教加库尔的怒火，绝不仁慈，因为他们对我们也不曾仁慈。")
		desc = desc:gsub("You have destroyed the sunwall outpost, and secured a way to the mainland.","你已经摧毁了太阳堡垒前哨站，确保了通向大陆的安全通路。")
		return desc
	end}

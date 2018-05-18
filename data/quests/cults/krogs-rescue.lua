questCHN["Cleaning the trash"]=
{
	name = "清理垃圾",
	description = function(desc)
	
		desc = desc:gsub("Protector Myssil has requested that you go at once to the ruins on the eastern shores of the sea of Sash to rescue a party of Krogs taken by necromancers filth.","守护者米歇尔请求你前往西海岸去拯救被邪恶死灵法师抓住的一群克罗格")
		desc = desc:gsub("Save our people and show the evildoers the wrongness of their way. Permanently.","去拯救人民，并*永久*修正邪恶的错误。")
		desc = desc:gsub("You have killed the necromancers but not in time to save any of the captive Krogs.","你杀死了死灵法师，但没能及时拯救任何人")
		desc = desc:gsub("You have killed the necromancers and saved some of the Krogs.","你杀死了死灵法师，同时拯救了一部分人")
		desc = desc:gsub("You have killed the necromancers and saved all of the Krogs, well done Ziguranth!","你杀死了死灵法师，并拯救了所有人，干得好伊格兰斯！")
		return desc
	end
}

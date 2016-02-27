questCHN["Children of Garkul, Unite!"] = {
	name = "加库尔的子民们，联合起来！",
	description = function(desc)
		
		desc = desc:gsub("All the few remaining orcs of the mainland have been captured by Sunwall and their western allies.","大陆上剩余少数的兽人都被太阳堡垒和他来自西方的盟友抓了起来。")
		desc = desc:gsub("To ensure a future, any future, for our race they must be freed.","为了我们种族的未来，他们必须被解放。")
		desc = desc:gsub("The internment camp is located somewhere to the north. The orcs are subdued into obedience by a powerful #{halfling}# psionic, Mindwall, and guarded by elite Sunwall troops.","他们的拘留营在北部的某处。兽人们的心灵被一个强大的半身人超能力者Mindwall所控制，并被太阳堡垒的精英部队重重把守。")
		desc = desc:gsub("Mindwall must be taken care of and the prides set free.","必须干掉Mindwall，我们的部落才能迎来自由")
		desc = desc:gsub("But #{bold}#BEFORE#{normal}# that you should go and destroy the Sunwall Observatory to the east, as our spies have found a way to resist Mindwall's psionic powers which requries #{italic}#ingredients#{normal}# from there.","但是#{bold}#之前#{normal}#你最好去一趟东部的太阳堡垒观星台。我们的间谍收到线报称，那里获得到的#{italic}#材料#{normal}#有助于找出抵御Mindwall的精神能力的方法。")
		desc = desc:gsub("You have destroyed Mindwall body but he managed to split his mind into many pieces and taken direct control of the subdued orcs. Destroy the pillars in each level four other levels.","你摧毁了Mindwall的身躯，但他找到了一种办法把自己的灵魂分成许多块，分别控制那些被关押的兽人。摧毁其他四个关卡的水晶柱。")
		desc = desc:gsub("You have freed all the Vor Pride orcs.","你解放了沃尔部落的兽人。")
		desc = desc:gsub("You need to have free the Vor Pride orcs.","你必须解放沃尔部落的兽人。")
		desc = desc:gsub("You have freed all the Rak'Shor Pride orcs.","你解放了拉克·肖部落的兽人。")
		desc = desc:gsub("You need to have free the Rak'Shor Pride orcs.","你必须解放拉克·肖部落的兽人。")
		desc = desc:gsub("You have freed all the Gorbat Pride orcs.","你解放了加伯特部落的兽人。")
		desc = desc:gsub("You need to have free the Gorbat Pride orcs.","你必须解放加伯特部落的兽人。")
		desc = desc:gsub("You have freed all the Grushnak Pride orcs.","你解放了格鲁希纳克部落的兽人。")
		desc = desc:gsub("You need to have free the Grushnak Pride orcs.","你必须解放格鲁希纳克部落的兽人。")
		desc = desc:gsub("The Pride is once again free and united.","部落重获自由，更加团结。")

		return desc
	end}

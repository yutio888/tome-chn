questCHN["The Dead God Awaits"] = {
	name = "已死之神的复苏",
	description = function(desc)
		
		desc = desc:gsub("Deep within Eyal you found a huge cavern containing some of the remains of the great dead god Amakthel...","在埃亚尔的深处，你找到了一个巨大的山洞，那里面深埋着已死的巨神阿马克泰尔的遗骸。")
		desc = desc:gsub("Along with what appears to be a living Sher'tul that seems to be trying to resurrect him.","在那里，还有一个活生生的夏·图尔人，它试图复活这尊古神。")
		desc = desc:gsub("It must be stopped at all cost, the Prides only just got their freedom back, you can not allow anything to take it away again!","必须不惜一切代价阻止他的可怕行径，部落的自由来之不易，任何人都无法再次夺走它！")
		desc = desc:gsub("The Sher'tul Priest has been taken care of, Amakthel will keep on sleeping forever now. The Prides and the world are safe.","夏·图尔祭司已经被妥善处置，阿马克泰尔将永久继续沉睡。部落和世界的和平得到了确保。")
		desc = desc:gsub("You have won the game!.","你通关了！")
		desc = desc:gsub("Well done! You have won the Tales of Maj'Eyal: Embers of Rage!","干得不错！你通关了马基·埃亚尔的传说：余烬怒火")
		desc = desc:gsub("You have thwarted the Steam Giants' genocidal plans, and avenged those killed in the attack on Kruk Pride.  Their desperate pact with the High Priest did nothing to stop you; the priest and his god lay dead at your feet, and you have ensured they will #{italic}#stay#{normal}# dead for the foreseeable future.","你挫败了蒸汽巨人灭绝你们的邪恶计划，并为那些在他们残忍袭击中丧生的部落同胞复仇。他们绝望中与夏·图尔祭祀的邪恶契约也未能阻止你，祭祀和他的神在地底逝去，你相信他们将会#{italic}#永远#{normal}#长眠在那里。")
		desc = desc:gsub("The humans, elves, and halflings will not be able to hurt your people again.  By destroying the farportal and denying King Tolak's army its glorious battle, you have ensured the safety of your people from the Allied Kingdoms, and by storming the Gates of Morning you have eliminated the last bearers of the West's hateful aggression in Var'Eyal.","无论是人类、精灵还是半身人再也无法伤害你的族人。你摧毁了远古传送门并在辉煌的战斗中击败了国王托拉克的军队，确保你的人民将不会受到联合王国的侵害。你对晨曦之门的袭击也摧毁了西方在瓦·埃亚尔可恶侵略的最后爪牙。")
		desc = desc:gsub("For now, peace reigns.  You know that this will not last forever.  You may have repelled its vanguard, but the Kar'Haïb Dominion bides its time waiting for a weakness it can exploit; the smugglers' portals from Maj'Eyal remain undiscovered, and while neither you nor King Tolak has any remaining desire to take the other's continent, the fear of invasion will linger in the backs of your minds.","终于，和平降临了。你知道这和平来之不易。虽然你驱散了他们的先锋队，但卡尔·亥巴自治领的巨魔绝不会放弃任何他们可以利用的弱点；走私者在马基·埃亚尔使用的传送门还没有被发现；此外，即使你或托拉克国王放弃了侵入对方领土的念头，对入侵的恐惧仍然在你们的头脑中环绕。")
		desc = desc:gsub("The messages of the Lost City give you cause to remain ever vigilant for the threats they warned of, including their authors, and you wonder what your people will do now that their struggle to escape eradication, one that has defined them for their entire recorded history, has ceased to be a concern.","来自失落之城的消息让你充满警醒，无论是那些他们警告的恐怖威胁，还是他们本身。你想知道，当你的人民所极力摆脱的灭亡威胁：那个镌刻在你们整个历史中的威胁，现在已经不复存在的时候，你们的人民又将何去何从？")
		desc = desc:gsub("Regardless...  You just killed a god and gave your people the first chance to relax in thousands of years.  It's been a pretty good day.","不管怎样…你杀死了一个神，而你的人民在数千年的征战中终于有了放松的机会。多么愉快的一天。")
		desc = desc:gsub("You may continue playing and enjoy the rest of the world.  Your soldiers may want to speak with you outside...","你可以继续游戏，享受这个世界。你的士兵在外面，有些话要说")
		return desc
	end}

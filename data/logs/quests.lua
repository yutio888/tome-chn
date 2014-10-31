logCHN:newLog{
	log = "#AQUAMARINE#With the Mouth death its crawler also falls lifeless on the ground!",
	fct = function()
		return "#AQUAMARINE#当大嘴怪死去时，它的爬虫也毫无生机的倒在了地上！"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#As %s falls you notice that %s seems to shudder in pain!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#AQUAMARINE#当 %s 倒下时你注意到 %s 正在痛苦中发抖！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "A parchment falls to the floor near The Abomination.",
	fct = function()
		return "一张羊皮纸掉落在了憎恶的身边。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#A lumberjack falls to the ground, dead.",
	fct = function()
		return "#LIGHT_RED#一个伐木工人倒在了地上，死了。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Killing your own future self does feel weird, but you know that you can avoid this future. Just do not time travel.",
	fct = function()
		return "#LIGHT_BLUE#杀死未来的自己貌似有点怪异， 不过你知道你可以避免这样的未来， 穿越时空吧。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Your future self kills you! The timestreams are broken by the paradox!",
	fct = function()
		return "#LIGHT_BLUE#你未来的自己杀死了你！时间流被混乱所打破！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#All those events never happened. Except they did, somewhen.",
	fct = function()
		return "#LIGHT_BLUE#所有这些从来没有发生过，除了他们在某个时候干过。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#A foe is summoned to the arena!",
	fct = function()
		return "#VIOLET#一个对手被召唤进了竞技场！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Another foe is summoned to the arena!",
	fct = function()
		return "#VIOLET#又一个对手被召唤进了竞技场！"
	end,
}

logCHN:newLog{
	log = "A stairway out appears at your feet. The Lord says: 'And remember, you are MINE. I will call you.'",
	fct = function()
		return "一道出去的楼梯在你的脚下出现了。 上帝说：“记住，你是我的，我会召唤你。”"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#The merchant thanks you for saving his life. He gives you 8 gold and asks you to meet him again in Last Hope.",
	fct = function()
		return "#LIGHT_BLUE#商人感谢你救了他的命。 他给了你8金币， 邀请你在最后的希望见他。"
	end,
}

logCHN:newLog{
	log = "You should head to the tunnel to Maj'Eyal and explore the world. For the Way.",
	fct = function()
		return "你应该通过通道到达马基埃亚尔，探索这个世界。 为了维网。"
	end,
}

logCHN:newLog{
	log = "He points in the direction of the Riljek forest to the north.",
	fct = function()
		return "他指着北方的里尔约克森林。"
	end,
}
logCHN:newLog{
	log = "He points out the location of grave yard on your map.",
	fct = function()
		return "他在你的地图上指出了墓穴的位置。"
	end,
}
logCHN:newLog{
	log = "#VIOLET#This tome seems to be about the power of gems. Maybe you should bring it to the jeweler in the Gates of Morning.",
	fct = function()
		return "#VIOLET#这本册子似乎描述了关于宝石的力量。 也许应该带给晨曦之门的珠宝匠看看。"
	end,
}

logCHN:newLog{
	log = "Limmir points to the entrance to a cave on your map. This is supposed to be the way to the valley.",
	fct = function()
		return "利米尔在你的地图上指出了山洞的入口。 这是一条通往山谷的路。"
	end,
}

logCHN:newLog{
	log = "You must be near the moonstone to summon Limmir.",
	fct = function()
		return "你必须在月亮石附近召唤利米尔。"
	end,
}

logCHN:newLog{
	log = "You do not have the summoning scroll!",
	fct = function()
		return "你没有召唤卷轴！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#The Blood Master hands you the %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("#LIGHT_BLUE#鲜血领主交给你 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As the apprentice touches the staff he begins to scream, flames bursting out of his mouth. Life seems to be drained away from him, and in an instant he collapses in a lifeless husk.",
	fct = function()
		return "#LIGHT_RED#当学徒触摸这根法杖， 他开始尖叫，火焰从他的嘴里喷射了出来。 他的生命似乎被从他的体内吸取了出来。 瞬间他只剩下一具毫无生机的空壳。"
	end,
}

logCHN:newLog{
	log = "Tannen points to the location of Telmur on your map.",
	fct = function()
		return "泰恩在你的地图上指出了泰尔玛的位置。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you are back in Last Hope.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你回到了最后的希望。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on the outskirts of Last Hope, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你回到了最后的希望的郊外，传送的踪迹再不可寻……"
	end,
}

logCHN:newLog{
	log = "#VIOLET#A portal activates in the distance. You hear the orcs shout, 'The Sorcerers have departed! Follow them!'",
	fct = function()
		return "#VIOLET#远处一个传送门被激活，你听到兽人们吼道： “恶魔法师已经离开！跟上他们！”"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The Sorcerers flee through a portal. As you prepare to follow them, a huge faeros appears to block the way.",
	fct = function()
		return "#VIOLET#恶魔法师从传送门逃跑了，当你准备跟随他们时， 一个巨大的法罗挡住了去路。"
	end,
}

logCHN:newLog{
	log = "A portal opens behind Ukllmswwik.",
	fct = function()
		return "乌克勒姆斯维奇身后开启了一道传送门。"
	end,
}

logCHN:newLog{
	log = "A portal opens to the flooded cave.",
	fct = function()
		return "一个通往淹没的洞穴。"
	end,
}

logCHN:newLog{
	log = "Aeryn explained where the orcs were spotted.",
	fct = function()
		return "艾伦告诉你哪里发现了兽人的踪迹。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#There is a loud crack. The way is open.",
	fct = function()
		return "#LIGHT_BLUE#随着一声巨响，道路被打开了。"
	end,
}

logCHN:newLog{
	log = "Zemekkys points to the location of Vor Armoury on your map.",
	fct = function()
		return "伊莫克斯在你的地图上指出了沃尔军械库的位置。"
	end,
}

logCHN:newLog{
	log = "Zemekkys points to the location of Briagh's lair on your map.",
	fct = function()
		return "伊莫克斯在你的地图上指出了布莱亚弗巢穴的位置。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Zemekkys starts to draw runes on the floor using the athame and gem dust.",
	fct = function()
		return "#VIOLET#伊莫克斯开始用宝石粉末和祭祀匕首在地板上画出符文。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The whole area starts to shake!",
	fct = function()
		return "#VIOLET#整个区域开始颤抖起来！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Zemekkys says: 'The portal is done!'",
	fct = function()
		return "#VIOLET#伊莫克斯说道：“传送门已经开启！”"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As you enter the level you hear a familiar voice.",
	fct = function()
		return "#LIGHT_RED#当你进入地图你听到了一个熟悉的声音。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Fallen Sun Paladin Aeryn: '%s YOU BROUGHT ONLY DESTRUCTION TO THE SUNWALL! YOU WILL PAY!'",
	fct = function(...)
		return ("#LIGHT_RED#太阳骑士艾伦倒下了：“%s 你只会给太阳堡垒带来毁灭！ 你会为此付出代价！”"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s is dead, quest failed!",
	fct = function(...)
		return ("#LIGHT_RED#%s 死了，任务失败了！"):format(...)
	end,
}

logCHN:newLog{
	log = "The elder points to Reknor on your map, to the north on the western side of the Iron Throne.",
	fct = function()
		return "长老在你的地图上指出了瑞库纳的位置， 在钢铁王座西部边境的北部。"
	end,
}

logCHN:newLog{
	log = "#00FFFF#You can feel the power of this staff just by carrying it. This is both ancient and dangerous.",
	fct = function()
		return "#00FFFF#你拿着法杖就可以感受到它的力量。它既古老又危险。"
	end,
}

logCHN:newLog{
	log = "#00FFFF#It should be shown to the wise elders in Last Hope!",
	fct = function()
		return "#00FFFF#应该把它交给最后的希望的智慧长老看看！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#As you come out of the Dreadfell, you encounter a band of orcs!",
	fct = function()
		return "#VIOLET#当你走出恐惧王座，你遭遇了一队兽人！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You wake up after a few hours, surprised to be alive, but the staff is gone!",
	fct = function()
		return "#VIOLET#几小时后你醒来， 很惊讶你还活着， 但是法杖不见了！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Go at once to Last Hope to report those events!",
	fct = function()
		return "#VIOLET#立即前往最后的希望汇报这些事！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You are surprised to still be alive.",
	fct = function()
		return "#VIOLET#你很惊讶你还活着。"
	end,
}

logCHN:newLog{
	log = "She marks the location of Ardhungol on your map.",
	fct = function()
		return "她在你的地图上指出阿尔德胡格的位置。"
	end,
}

logCHN:newLog{
	log = "A portal appears right under you, and Rashim rushes through.",
	fct = function()
		return "一道传送门在你的脚下出现， 拉希姆冲了过去。"
	end,
}


logCHN:newLog{
	log = "#VIOLET#Your rod of recall glows brightly for a moment.",
	fct = function()
		return "#VIOLET#你的召回之杖闪了一下光。"
	end,
}

logCHN:newLog{
	log = "The orb seems to fizzle without the Blood Master.",
	fct = function()
		return "水晶球离开鲜血领主之后发出了吱吱声。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The crowd yells: 'LOSER!'",
	fct = function()
		return "#CRIMSON#人群中吼道：“失败者！”"
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#As you touch the orb your will fills the slave's body. You take full control of his actions!",
	fct = function()
		return "#LIGHT_GREEN#当你触摸水晶球时你的意志进入了奴隶的体内， 你可以完全控制它的行动！"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#A new foe appears in the ring of blood!",
	fct = function()
		return "#CRIMSON#新的对手出现在了鲜血之环！"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The crowd yells: 'BLOOOODDD!'",
	fct = function()
		return "#CRIMSON#人群中吼道：“鲜血！”"
	end,
}

logCHN:newLog{
	log = "This rift in time has been created by the paradox. You dare not enter it; it could make things worse. Another Warden will have to fix your mess.",
	fct = function()
		return "这个时间裂隙是由于混乱造成的。你不敢进入， 事情会变得更糟，另外一个守卫会修复混乱。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The time has come to learn the true nature of your curse.",
	fct = function()
		return "#VIOLET#是时候搞清楚你诅咒的本质了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You find yourself in a dream.",
	fct = function()
		return "#VIOLET#你发现你在一个梦境里。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Your hate surges. You refuse to succumb to death!",
	fct = function()
		return "#VIOLET#你仇恨涌动，你不屈服于死亡！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have discovered a small iron acorn, a link to your past.",
	fct = function()
		return "#VIOLET#你发现了一个小铁橡果，它和你的过去有关。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The merchant caravan from the past has appeared in your dream.",
	fct = function()
		return "#VIOLET#很久以前商队的往事出现在你的梦里。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have begun your hunt for Kyless!",
	fct = function()
		return "#VIOLET#你开始追杀克里斯！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have a marker to the entrance of Kyless' cave!",
	fct = function()
		return "#VIOLET#你在通往克里斯洞穴的入口上有一个记号！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have found the entrance to Kyless' cave!",
	fct = function()
		return "#VIOLET#你找到了通往克里斯洞穴的入口！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have found the entrance to a vault!",
	fct = function()
		return "#VIOLET#你找到了通往一个地下室的入口！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The shadows have noticed you!",
	fct = function()
		return "#VIOLET#阴影注意到了你！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have found Kyless. You must destroy him.",
	fct = function()
		return "#VIOLET#你找到了克里斯，你必须杀死他。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Kyless is dead.",
	fct = function()
		return "#VIOLET#克里斯死了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Berethh lies dead.",
	fct = function()
		return "#VIOLET#贝利斯死了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You can check the ingredients you possess by pressing Escape and selecting 'Show ingredients'.",
	fct = function()
		return "#VIOLET#你现在可以按ESC调出游戏菜单，选择“查看材料”检查自己所拥有的材料。"
	end,
}

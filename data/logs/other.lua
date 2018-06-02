logCHN:newLog{
	log = "#Source# emits dark energies at your feet.",
	fct = "#Source# 朝你脚下喷吐黑暗能量.",
	}

logCHN:newLog{
	log = "#0080FF#On the back of the letter you can just make out a coarsely scrawled and badly faded diagram.#LAST#",
	fct = "#0080FF#在信件背面，你只能看到潦草的涂鸦和严重褪色的图表。#LAST#",
}

logCHN:newLog{
	log = "%s cannot receive items while asleep!",
	fct = function(a)
	    a = npcCHN:getName(a)
	    return ("%s不能在睡眠中接收物品"):format(a)
	    end,
}


logCHN:newLog{
	log = "%s cannot transfer items while asleep!",
	fct = function(a)
	    a = npcCHN:getName(a)
	    return ("%s不能在睡眠中转移物品"):format(a)
	    end,
}

logCHN:newLog{
	log = "You give %s to %s",
	fct = function(a,b)
	    a = npcCHN:getName(a)
	    b = objects:getObjectsChnName(b)
	    return ("你交给%s %s"):format(a,b)
	    end,
}

logCHN:newLog{
	log = "Tooltip %s",
	fct = function(a)
	    return ("提示%s"):format(a:gsub("unlocked","开启"):gsub("locked","关闭"))
	    end,
}

logCHN:newLog{
	log = "starting trap selection dialog",
	fct = "开始选择陷阱",
}

logCHN:newLog{
	log = "#RED#Displaying %s set for %s (equipment NOT switched)",
	fct = "#RED#展示 %s 套装给 %s 看 (装备未切换)",
	}
	
logCHN:newLog{
	log = "You need more skill to prepare this trap.",
	fct = "你需要更多技能等级来使用该陷阱",
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Preparing trap with normal trigger.",
	fct = "#LIGHT_BLUE#准备了常规触发的陷阱",
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You cannot prepare more than %d traps.",
	fct = "#LIGHT_BLUE#你不能准备多于%d个陷阱",
}
logCHN:newLog{
	log = "#LIGHT_BLUE#Warning: You have increased some of your statistics. Talent %s is actually sustained; if it is dependent on one of the stats you changed, you need to re-use it for the changes to take effect.",
	fct = "#LIGHT_BLUE#警告：你的属性有变化。技能%s 是维持技能；如果它基于你某些属性，你可能需要重新开启它。",
}
logCHN:newLog{
	log = "#LIGHT_BLUE#You resurrect! CHEATER!",
	fct = "#LIGHT_BLUE#你复活了！ 作弊者！",
}
logCHN:newLog{
	log = "#YELLOW#Your bones magically knit back together. You are once more able to dish out pain to your foes!",
	fct = "#YELLOW#你的骨头魔法般拼合在一起，你复活了！",
}
logCHN:newLog{
	log = "#YELLOW#Your %s is consumed and disappears! You come back to life!",
	fct = function(a) a =  objects:getObjectsChnName(a) return ("#YELLOW#你的%s被消耗了，你复活了！"):format(a) end,
}
logCHN:newLog{
	log = "You managed to die on the eidolon plane! DIE!",
	fct = "你成功死于艾德隆位面！安息吧！",
}

logCHN:newLog{
	log = "The corrupted lava reanimates %s's corpse!",
	fct = function(a) return("腐化熔岩重新支配了%s的尸体！"):format(npcCHN:getName(a)) end,
}
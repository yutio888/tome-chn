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

logCHN:newLog{
	log = "As your shade dies, the magical veil protecting the stairs out vanishes.",
	fct = function(...)
		return "随着你的阴影的死去， 阻挡出去楼梯的魔法护罩消失了。"
	end,
}

logCHN:newLog{
	log = "%s uses %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 使用了 %s！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#VIOLET#The wormhole absorbs energies and stabilizes. You can now use it to travel.",
	fct = function()
		return "#VIOLET#虫洞吸收了能量变得稳定， 现在你可以使用它来传送了。"
	end,
}

logCHN:newLog{
	log = "%s appears out of the thin air!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从空气中消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#ANTIQUE_WHITE#The Crown of Eternal Night seems to react with the Bindings, you feel tremendous dark power.",
	fct = function()
		return "#ANTIQUE_WHITE#永夜王冠似乎与永夜绷带有某种联系， 你感受到了强大的黑暗力量。"
	end,
}

logCHN:newLog{
	log = "Prox staggers for a moment. A note seems to drop at his feet.",
	fct = function()
		return "普洛克斯蹒跚了几步， 一张纸条似乎掉在了他脚下。"
	end,
}
logCHN:newLog{
	log = "Shax staggers for a moment. A note seems to drop at his feet.",
	fct = function()
		return "夏克斯蹒跚了几步， 一张纸条似乎掉在了他脚下。"
	end,
}
logCHN:newLog{
	log = "#VIOLET#As %s falls you notice a portal appearing.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#VIOLET#当 %s 倒下时你注意到一个传送门出现了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#VIOLET#Your rod of recall shakes, a portal appears beneath you.",
	fct = function()
		return "#VIOLET#你的召唤之杖开始震动， 你的脚下出现了一道传送门。"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#As %s falls all its eyes fall to the ground!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#AQUAMARINE#当 %s 倒下时它的眼睛掉落在了地上。"):format(a)
	end,
}

logCHN:newLog{
	log = "As the assassin dies the magical veil protecting the stairs out vanishes.",
	fct = function()
		return "刺客死后，笼罩离开这里的楼梯的魔法封印消失了。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#%s seems invulnerable, there must be an other way to kill it!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON#%s 似乎无懈可击，一定有什么其他方法可以杀死它！"):format(a)
	end,
}
logCHN:newLog{
	log = "#AQUAMARINE#As #Source# falls you notice that #Target# seems to shudder in pain!",
	fct = function()
		return "#AQUAMARINE#当#Source# 倒下时，你发现#Target#似乎因为痛苦而颤抖!"
	end,
}

logCHN:newLog{
	log = "You receive: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你收到： %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You receive: %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你收到： %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You squeeze Celia's heart in your hand, absorbing part of her soul into your necrotic aura.",
	fct = function()
		return "你把希利娅的心脏放在手中挤压，将她的部分灵魂吸收进你的死灵光环里。"
	end,
}

logCHN:newLog{
	log = "#ANTIQUE_WHITE#You notice a hole that could fit the gem key you found earlier, inserting it reveals the passage to the next level.",
	fct = function()
		return "#ANTIQUE_WHITE#你注意到有一个小孔和你之前找到的宝石钥匙形状很相似， 你插入了钥匙，出现了通往下一层的入口。"
	end,
}

logCHN:newLog{
	log = "#ANTIQUE_WHITE#The way seems closed, maybe you need a key.",
	fct = function()
		return "#ANTIQUE_WHITE#前进的道路被关闭，也许你需要一把钥匙。"
	end,
}

logCHN:newLog{
	log = "#GREY#The cultist looks deep in your eyes. You feel torn apart!",
	fct = function()
		return "#GREY#邪教信徒恶狠狠地盯着你的眼睛，你感到好像要被撕裂一样！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you are back to Maj'Eyal, near the Daikara.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼的功夫你已经回到了马基埃亚尔的岱卡拉附近！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You hear a death cry. '%s I have a messag... ARG!'",
	fct = function(...)
		return ("#LIGHT_RED#你听到了一阵临死的惨叫。“%s 我有消息要告诉你……啊……！”"):format(...)
	end,
}

logCHN:newLog{
	log = "You cannot bring yourself to drop the %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不能丢弃 %s"):format(name)
	end,
}

logCHN:newLog{
	log = "You find a note containing the location of the Orc Prides on Aeryn's body.",
	fct = function()
		return "你在艾伦的尸体上找到了一张纸条，上面写着兽人部落的位置。"
	end,
}

logCHN:newLog{
	log = "The powerful darkness aura you felt wanes away.",
	fct = function()
		return "你感觉到强大的黑暗光环消失了。"
	end,
}

logCHN:newLog{
	log = "The lava burns you!",
	fct = function()
		return "火山的岩浆灼烧着你！"
	end,
}

logCHN:newLog{
	log = "The lava heals you!",
	fct = function()
		return "火山的岩浆治疗了你！"
	end,
}

logCHN:newLog{
	log = "Your %s is magically sorted by the storage room.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你的 %s 被储藏室魔法般整理了。"):format(name)
	end,
}

logCHN:newLog{
	log = "Your %s is magically sorted by the storage room and put in a pile with the others items of the same type.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你的 %s 被储藏室魔法般整理了，同类的东西被整理成一堆。"):format(name)
	end,
}

logCHN:newLog{
	log = "It seems the room has no more space to sort your %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("房间里似乎没有空余的地方给你放 %s 了。"):format(name)
	end,
}

logCHN:newLog{
	log = "#00FFFF#You consume the heart and feel the knowledge of this very old creature fill you!",
	fct = function()
		return "#00FFFF#你感觉到这个古老生物的知识充满了你的内心！"
	end,
}

logCHN:newLog{
	log = "You have %d stat point(s) to spend. Press p to use them.",
	fct = function(...)
		return ("你有 %d 属性点数，按下p来使用。"):format(...)
	end,
}

logCHN:newLog{
	log = "You have %d class talent point(s) to spend. Press p to use them.",
	fct = function(...)
		return ("你有 %d 职业技能点数，按下p来使用。"):format(...)
	end,
}

logCHN:newLog{
	log = "You have %d generic talent point(s) to spend. Press p to use them.",
	fct = function(...)
		return ("你有 %d 通用技能点数，按下p来使用。"):format(...)
	end,
}

logCHN:newLog{
	log = "You are transformed by the heart of the Queen!.",
	fct = function()
		return "你被沙虫女皇之心所转化！"
	end,
}

logCHN:newLog{
	log = "You are transformed by the corrupted heart of the Queen!.",
	fct = function()
		return "你被腐化的沙虫女皇之心所转化！"
	end,
}
logCHN:newLog{
	log = "#00FF00#You gain an affinity for nature. You can now learn new Harmony talents (press p).",
	fct = function()
		return "#00FF00#你获得了与自然的紧密联系， 现在你可以学习新的元素和谐技能（按下p）"
	end,
}
logCHN:newLog{
	log = "#00FF00#You gain an affinity for blight. You can now learn new Vile Life talents (press p).",
	fct = function()
		return "#00FF00#你获得了与自然的紧密联系， 现在你可以学习新的邪恶生命技能（按下p）"
	end,
}
logCHN:newLog{
	log = "#00FFFF#You drink the wyrm bile and feel forever transformed!",
	fct = function()
		return "#00FFFF#你喝下了龙人的胆汁，你感觉你的身体发生了永久变化！"
	end,
}

logCHN:newLog{
	log = "#00FF00#Your stats have changed! (Str %s, Dex %s, Mag %s, Wil %s, Cun %s, Con %s)",
	fct = function(...)
		return ("#00FF00#你的属性发生了变化！（力量 %s，敏捷 %s，魔法 %s，意志 %s，灵巧 %s，体质 %s）"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You use the orb on the portal, shutting it down easily.",
	fct = function()
		return "#LIGHT_BLUE#你在传送门上使用了水晶球，很轻易的关闭了它。"
	end,
}

logCHN:newLog{
	log = "This foe has already been drained.",
	fct = function()
		return "目标已经被吸收。"
	end,
}

logCHN:newLog{
	log = "You brandish the staff, draining your foe.",
	fct = function()
		return "你挥舞着法杖，吸收你的目标。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#An illusion appears around %s, making it appear human.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#一道幻影出现在 %s 身边，使它看起来像一个人类。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#The illusion covering %s disappears",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#笼罩 %s 的幻影消失了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you are back in the lobby.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你回到了大厅。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You feel unenlightened.",
	fct = function()
		return "#VIOLET#你感到很无知。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Shove.",
	fct = function()
		return "#VIOLET#你学会了技能 推挤。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The sound of an ancient door grinding open echoes down the tunnel!",
	fct = function()
		return "#VIOLET#推开古老大门产生的吱呀声音回荡在通道里！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Mana Gale.",
	fct = function()
		return "#VIOLET#你学会了技能 法力风暴"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Telekinetic Punt.",
	fct = function()
		return "#VIOLET#你学会了技能 念力冲撞"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Blink.",
	fct = function()
		return "#VIOLET#你学会了技能 闪现"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Fear.",
	fct = function()
		return "#VIOLET#你学会了技能 恐惧术"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Bleed.",
	fct = function()
		return "#VIOLET#你学会了技能 流血"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You have learned the talent Confusion.",
	fct = function()
		return "#VIOLET#你学会了技能 混乱"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You must achieve Enlightenment before you can pass. Seek ye to the west to discover the ancient art of Shoving Stuff.",
	fct = function()
		return "#VIOLET#你必须完成 地下城启蒙 成就才能通过。 往西部寻找古代宝物： 冲击法杖。"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#You arrive deep under water, at the sea floor, as you look upwards you only see a glimpse of light coming through.",
	fct = function()
		return "#AQUAMARINE#你深入了水下， 在海床上， 当你抬头看时 你看到有道光亮一闪而过。"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#You should be crushed by the pressure, but strangely you feel no discomfort.",
	fct = function()
		return "#AQUAMARINE#你应该被压力所压扁， 不过奇怪的是 你没有感到任何不适。"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#All around you there is only water as far as you can see, except to your left, a giant coral structure. This is probably the temple of Creation.",
	fct = function()
		return "#AQUAMARINE#在你四周除了水你看到的还是水， 除了在你的左边，你看到一个巨大的珊瑚礁建筑，有可能这就是造物者神庙。"
	end,
}

logCHN:newLog{
	log = "The Eidolon Plane seems to not physicaly exists in the same way the normal world does, you can not seem to drop anything here. %s comes back into your backpack.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("艾德隆位面似乎并不在现实世界中真实存在， 似乎你在这里不能丢弃任何东西， %s 又回到了你的手中。"):format(name)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You are sent back to the material plane!",
	fct = function()
		return "#LIGHT_RED#你被传送回现实世界！"
	end,
}

logCHN:newLog{
	log = "You have: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你拥有： %s"):format(name)
	end,
}

logCHN:newLog{
	log = "#00FFFF#You read the tome and learn about ancient forgotten fire magic!",
	fct = function()
		return "#00FFFF#你阅读了那本册子，学会了已被遗忘的古老火系魔法！"
	end,
}

logCHN:newLog{
	log = "#00FFFF#You read the tome and perfect your mastery of fire magic!",
	fct = function()
		return "#00FFFF#你阅读了那本册子，完善了对火系魔法的掌握！"
	end,
}

logCHN:newLog{
	log = "#00FFFF#You read the tome and learn about ancient forgotten ice magic!",
	fct = function()
		return "#00FFFF#你阅读了那本册子，学会了已被遗忘的古老冰系魔法！"
	end,
}

logCHN:newLog{
	log = "#00FFFF#You read the tome and perfect your mastery of ice magic!",
	fct = function()
		return "#00FFFF#你阅读了那本册子，完善了对冰系魔法的掌握！"
	end,
}

logCHN:newLog{
	log = "There is no portal to activate here.",
	fct = function()
		return "这里没有可用的传送门。"
	end,
}

logCHN:newLog{
	log = "The socket seems broken.",
	fct = function()
		return "插槽似乎已经损坏。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As you insert the gem the golem starts to shake. All its systems and magics are reactivating.",
	fct = function()
		return "#LIGHT_RED#当你插入宝石傀儡开始震动。 它的系统和魔法被重新激活了。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Atamathon walks the world again, but without control.",
	fct = function()
		return "#LIGHT_RED#阿塔玛森重新来到了世界，不过它失去了控制。"
	end,
}

logCHN:newLog{
	log = "The rift is too unstable to cross it.",
	fct = function()
		return "裂隙太不稳定而无法穿越。"
	end,
}

logCHN:newLog{
	log = "The portal fizzles.",
	fct = function()
		return "传送门失败了。"
	end,
}

logCHN:newLog{
	log = "#GOLD#Miniboss round starts!!",
	fct = function()
		return "#GOLD#小BOSS回合开始！！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#Boss round starts!!!",
	fct = function()
		return "#VIOLET#BOSS回合开始！！！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#Final round starts!!!!",
	fct = function()
		return "#LIGHT_RED#最后回合开始！！！！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_GREEN#The gates open!",
	fct = function()
		return "#LIGHT_GREEN#门打开了！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#The gates close!",
	fct = function()
		return "#LIGHT_RED#门关上了！"
	end,
}

logCHN:newLog{
	log = "#PURPLE#As the orc greatmother falls you realize you have dealt a crippling blow to the orcs.",
	fct = function()
		return "#PURPLE#当兽人母体倒下时你意识到你对兽人部落造成了致命的打击。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As the Weirdling beast falls it shrieks one last time and the door behind it shatters and explodes, revealing the room behind it. The stair up vanishes!",
	fct = function()
		return "#LIGHT_RED#随着维德林兽的倒下，它发出了最后一身尖叫。它身后的门被炸开， 里面出现了一个房间，楼梯消失了！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot in a strangely familiar zone, right next to a farportal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你发现你到了一个熟悉的地方， 在另一个远古传送门旁边..."
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot in an unfamiliar zone, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你发现你到了一个陌生的地方， 传送门不见了..."
	end,
}

logCHN:newLog{
	log = "#VIOLET#The portal is already broken!",
	fct = function()
		return "#VIOLET#传送门已经被破坏！"
	end,
}

logCHN:newLog{
	log = "#VIOLET#The portal starts to break down, run!",
	fct = function()
		return "#VIOLET#传送门要爆炸了，快跑！"
	end,
}

logCHN:newLog{
	log = "You were not the first here: the corpse was turned into an undead.",
	fct = function()
		return "你不是这里第一个变成亡灵的尸体！"
	end,
}

logCHN:newLog{
	log = "The corpse had a treasure!",
	fct = function()
		return "尸体上有宝物！"
	end,
}

logCHN:newLog{
	log = "#YELLOW#You hear all the doors being shattered into pieces.",
	fct = function()
		return "#YELLOW#你听到所有的门都被打碎了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you are back to the far east.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼功夫你发现你回到了远东大陆。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on an unfamiliar cave, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送门，一眨眼功夫你发现你到达了一个陌生的洞穴，此间毫无传送门的痕迹……"
	end,
}

logCHN:newLog{
	log = "They say that after it has been confirmed orcs still inhabited Reknor, they found a mighty demon there.",
	fct = function()
		return "他们说当兽人占据瑞库纳的事实被确认后，他们还在那发现了一只强大的恶魔。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you are back in Last Hope.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼的功夫你已经回到了最后的希望。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal while it fades away and in the blink of an eye you set foot on hellish land, the heart of a volcano...",
	fct = function()
		return "#VIOLET#你进入了快要消逝的传送漩涡，一眨眼的功夫你便到了危险之地——一座火山的腹地……"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on the Far East, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼的功夫你已经回到了远东大陆，此间毫无传送门的痕迹……"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on the slopes of the Iron Throne, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼的功夫你已经到了钢铁王座附近，此间毫无传送门的痕迹……"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and appear in a large room with other portals and the two wizards.",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，当你反应过来时，你发现你来到了一个有着数个传送门和两名魔导师的巨大房间里。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot in sight of the Gates of Morning, with no trace of the portal...",
	fct = function()
		return "#VIOLET#你进入了传送漩涡，一眨眼的功夫你已经到了晨曦之门的山脚下，此间毫无传送门的痕迹……"
	end,
}

logCHN:newLog{
	log = "#RED#You feel disgusted touching this thing!",
	fct = function()
		return "#RED#当你触摸到这件物品时，你感到一阵恶心！"
	end,
}

logCHN:newLog{
	log = "#YELLOW_GREEN#One of the wall shakes for a moment and then turns into %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#YELLOW_GREEN#一面墙壁颤抖了一会，变成了 %s!"):format(a)
	end,
}

logCHN:newLog{
	log = "#GREEN#You put the heart on the altar. The heart shrivels and shakes, vibrating with new corrupt forces.",
	fct = function()
		return "#GREEN#你将心脏放在祭坛上。心脏跳动、收缩，最终被堕落力量腐化。"
	end,
}

logCHN:newLog{
	log = "#OLIVE_DRAB#You feel the ground shaking from the west.",
	fct =function()
		return "#OLIVE_DRAB#你感觉到西边的大地在震动。"
	end,
}

logCHN:newLog{
	log = "#OLIVE_DRAB#The huge sandworm burrower burrows into the ground and disappears.",
	fct =function()
		return "#OLIVE_DRAB#巨型沙虫挖掘者挖入地下，消失了"
	end,
}
logCHN:newLog{
	log = "#Source# emits dark energies at your feet.",
	fct = function()
		return "#Source# 在你的脚下释放了黑暗的能量。"
	end,
}
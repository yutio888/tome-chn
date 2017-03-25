--celestial/guardian
logCHN:newLog{
	log = "You cannot use Shield of Light without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}

logCHN:newLog{
	log = "You cannot use Brandish without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}

logCHN:newLog{
	log = "You cannot use Retribution without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}
--celestial/eclipse
logCHN:newLog{
	log = "%s's darkness can no longer hold back the light!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的暗影无法再抵御光明！"):format(a)
	end,
}


--celestial/hymns
logCHN:newLog{
	log = "#DARK_GREY#A shroud of shadow dances around %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#DARK_GREY#一个阴影围绕着%s起舞！"):format(a)
	end,
}

logCHN:newLog{
	log = "#DARK_GREY#The shroud of shadows around %s disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#DARK_GREY#围绕着%s起舞的阴影消失了。"):format(a)
	end,
}
--celestial/twilight
logCHN:newLog{
	log = "You can't use Twilight while Darkest Light is active.",
	fct = function()
		return "你不能在 无尽黑暗 激活的情况下施展 黄昏 。"
	end,
}

logCHN:newLog{
	log = "You must sustain the Jumpgate spell to be able to teleport.",
	fct = function()
		return "你必须激活 跃迁之门 才能传送。"
	end,
}

logCHN:newLog{
	log = "Not enough space to summon!",
	fct = function()
		return "没有足够的空间召唤。"
	end,
}

logCHN:newLog{
	log = "Wrong target!",
	fct = function()
		return "目标错误！"
	end,
}

--chronomancy/anomalies

logCHN:newLog{
	log = "Reality has shifted.",
	fct = function()
		return "现实世界发生了变化。"
	end,
}

logCHN:newLog{
	log = "%s has caused a hiccup in the fabric of spacetime.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 造成了时空之网的波动。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has created a bubble of nul time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 制造了时间空白。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has created a bubble of slow time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 制造了时间减速。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has sped up several threads of time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 加速了部分时间线。"):format(a)
	end,
}

logCHN:newLog{
	log = "A temporal storm rages around %s.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 受到一阵时空风暴打击。"):format(a)
	end,
}

logCHN:newLog{
	log = "Some Time Elementals have been attracted by %s's meddling.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 对时空的干扰引来了一些时空元素。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has paused a temporal thread.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 暂停了一条时间线。"):format(a)
	end,
}

logCHN:newLog{
	log = "Matter turns to dust around %s.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 周围的事物变成了尘埃。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has caused a Gravity Spike.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 制造了一个引力漩涡。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has increased local entropy.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 提高了区域熵值。"):format(a)
	end,
}

logCHN:newLog{
	log = "The spell fizzles!",
	fct = function()
		return "法术失败了!"
	end,}

logCHN:newLog{
	log = "%s resists the swap!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了时空交换！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s is drawn in by the gravity spike!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被卷入重力漩涡！"):format(a)
	end,
}


logCHN:newLog{
	log = "#F53CBE#%s's %s is disrupted!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的%s中断了！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "Some innocent bystanders have been pulled out of their timeline.",
	fct = function()
		return "一些无辜的旁观者被拉出了他们的时间线。"
	end,
}

logCHN:newLog{
	log = "Poof!!",
	fct = function()
		return "哇！！"
	end,
}

logCHN:newLog{
	log = "%s has inadvertently weakened several creatures.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 无意中削弱了一些生物。"):format(a)
	end,
}

logCHN:newLog{
	log = "The odds have tilted.",
	fct = function()
		return "几率发生了倾斜。"
	end,
}

--chronomancy/chronomancy
logCHN:newLog{
	log = "Your current failure chance is %d%%, your current anomaly chance is %d%%, and your current backfire chance is %d%%.",
	fct = function(...)
		return ("你当前的失败几率是 %d%% ，你当前的异常几率是 %d%% ，你当前的回火几率是 %d%% 。"):format(...)
	end,
}

--chronomancy/energy
logCHN:newLog{
	log = "%s's %s is disrupted by the Energy Absorption!",
	fct = function(a,...)
		a = npcCHN:getName(a)
		return ("%s 的 %s 被能量吸收所打断！"):format(a,...)
	end,
}

--chronomancy/matter

logCHN:newLog{
	log = "%s has been pulled apart at a molecular level!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被分崩离析！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the quantum spike!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了量子钉刺！"):format(a)
	end,
}

--chronomancy/paradox
logCHN:newLog{
	log = "#LIGHT_BLUE#%s never existed, this never happened!",
	fct = function(...)
		return ("#LIGHT_BLUE#%s 不存在，也不会发生！"):format(...)
	end,
}

logCHN:newLog{
	log = "#LIGHT_STEEL_BLUE#%s tries to remove %sself from existance!",
	fct = function(...)
		return ("#LIGHT_STELL_BLUE#%s试图抹杀%s自己！"):format(...)
	end,
}

--chronomancy/spacetime-weaving
logCHN:newLog{
	log = "%s's space-time folding fizzles!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的时空折叠失败了！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s emerges from a space-time rift!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 从时空虫洞中出现！"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#%s has been yanked back to the tether!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON#%s 被时空锁链拉了回去！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s moves onto the wormhole.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s踏入虫洞"):format(a)
	end,
}

logCHN:newLog{
	log = "You do not have line of sight.",
	fct = function()
		return "你没有视线"
	end,
}

logCHN:newLog{
	log = "%s resists the banishment!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了放逐！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s folds the space between two points.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 折叠了两点之间的空间。"):format(a)
	end,
}

logCHN:newLog{
	log = "You can't place a wormhole entrance here.",
	fct = function()
		return "你不能在这里安置一个虫洞入口。"
	end,
}

logCHN:newLog{
	log = "Pick a valid location.",
	fct = function()
		return "选择一个有效区域。"
	end,
}

logCHN:newLog{
	log = "No exit location could be found.",
	fct = function()
		return "未能找到出口。"
	end,
}

logCHN:newLog{
	log = "%s moves onto the wormhole.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 向虫洞移动。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s tries to enter the wormhole but a violent force pushes it back.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s试图进入虫洞但是一股猛力将其强行推送了回来。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s ignores the wormhole.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s无视了虫洞。"):format(a)
	end,
}

logCHN:newLog{
	log = "Reality asserts itself and forces the wormhole shut.",
	fct = function()
		return "现实世界进行自我调谐强行关闭了虫洞。"
	end,
}

--chronomancy/timetravel

logCHN:newLog{
	log = "%s has moved forward in time!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的时间被向前推移！"):format(a)
	end,
}


logCHN:newLog{
	log = "%s rearranges history.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 修正了历史。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s manipulates the flow of time.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 操纵了时间流。"):format(a)
	end,
}

--corruption/bone
logCHN:newLog{
	log = "%s resists the bone!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了骨魔法！"):format(a)
	end,
}
logCHN:newLog{
	log = "A part of %s's bone shield regenerates.",
	fct = function(a) 
		a = npcCHN:getName(a)
		return ("%s的骨盾重新生成了一片。"):format(a)
	end,
}

logCHN:newLog{
	log = "Your bone shield absorbs the damage!",
	fct = function()
		return "你的骨盾吸收了伤害！"
	end,
}

--corruption/plague
logCHN:newLog{
	log = "%s resists the disease!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了疫病！"):format(a)
	end,
}

--corruption/scourge

logCHN:newLog{
	log = "You cannot use Rend without two weapons!",
	fct = function()
		return "必须装备两把武器！"
	end,
}

logCHN:newLog{
	log = "You cannot use Acid Strike without two weapons!",
	fct = function()
		return "必须装备两把武器！"
	end,
}

logCHN:newLog{
	log = "You cannot use Dark Surprise without two weapons!",
	fct = function()
		return "必须装备两把武器！"
	end,
}

logCHN:newLog{
	log = "%s resists the cut!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了流血！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the darkness.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了暗影。"):format(a)
	end,
}
--corruption/shadowflame

logCHN:newLog{
	log = "This spell cannot be used from within the Fearscape.",
	fct = function()
		return "该技能不能在恐惧长廊使用。"
	end,
}
logCHN:newLog{
	log = "This spell cannot be cast here.",
	fct = function()
		return "该技能不能在这里使用。"
	end,
}

logCHN:newLog{
	log = "The spell fizzles...",
	fct = function()
		return "法术失败了..."
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You are taken to the Fearscape!",
	fct = function()
		return "#LIGHT_RED#你被带到了恐惧长廊！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You are brought back from the Fearscape!",
	fct = function()
		return "#LIGHT_RED#你被带回了恐惧长廊！"
	end,
}

--corruption/vim
logCHN:newLog{
	log = "%s resists the portal!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了传送！"):format(a)
	end,
}

--cunning/ambush

logCHN:newLog{
	log = "%s resists the shadow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了阴影！"):format(a)
	end,
}

logCHN:newLog{
	log = "Not enough space to invoke your shadow!",
	fct = function()
		return "没有足够的空间召唤阴影。"
	end,
}


--cunning/called-shot
logCHN:newLog{
	log = "%s resists being knocked down.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了击退。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the stunning shot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了震慑。"):format(a)
	end,
}


--cunning/dirty
logCHN:newLog{
	log = "#Target# resists the stun and #Source# quickly regains its footing!",
	fct = function()
		return "#Target# 抵抗了震慑，#Source# 迅速恢复过来!"
	end,
}

logCHN:newLog{
	log = "Terrain prevents #Source# from switching places with #Target#.",
	fct = function()
		return "地形阻止了 #Source# 与 #Target#的换位."
	end,
}

--cunning/scoundrel
logCHN:newLog{
	log = "You can not do that currently.",
	fct = function()
		return "目前你不能这样做。"
	end,
}
logCHN:newLog{
	log = "You cannot dash through that!",
	fct = function()
		return "你不能穿过去！"
	end,
}

--cunning/shadow-magic
logCHN:newLog{
	log = "%s is not dazed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 未眩晕！"):format(a)
	end,
}

--cunning/stealth
logCHN:newLog{
	log = "You cannot Stealth with such heavy armour on!",
	fct = function()
		return "你不能在穿戴如此厚重装甲的情况下潜行！"
	end,
}

logCHN:newLog{
	log = "You are being observed too closely to enter Stealth!",
	fct = function()
		return "你不能在周围有怪物注视你的情况下潜行！"
	end,
}

--cunning/trap
logCHN:newLog{
	log = "#CADET_BLUE#Placing %s...",
	fct = function(a)
		if a== "trap" then return "#CADET_BLUE#放置陷阱中"
		else return ("#CADET_BLUE#放置%s中"):format(a)
		end
	end,
}
logCHN:newLog{
	log = "#CADET_BLUE#Your %s has expired.",
	fct = function(a)
		if a== "trap" then return "#CADET_BLUE#你的陷阱消失了"
		else return ("#CADET_BLUE#你的%s消失了"):format(a)
		end
	end,
}

logCHN:newLog{
	log = "%s activates a prepared device.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s激活了一项被准备的装置。"):format(a)
	end,
}

logCHN:newLog{
	log = "You somehow fail to set the trap.",
	fct = function()
		return "你没有成功放置陷阱。"
	end,
}

logCHN:newLog{
	log = "%s resists the flash bang!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了闪光弹！"):format(a)
	end,
}

logCHN:newLog{
	log =  "#Target# is pulled towards #Source#'s gravity trap!",
	fct = function()
		return ("%s被拉向%s的引力陷阱！")
	end,
}

--curse/cursed-aura
logCHN:newLog{
	log = "You cannot use %s without a weapon in your inventory!",
	fct = function(...)
		return ("使用 %s 你的物品栏内必须得有装备！"):format(...)
	end,
}

logCHN:newLog{
	log = "You renew the cursed mark.",
	fct = function()
		return "你更新了诅咒印记。"
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s crumbles to dust.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s化为了灰烬。"):format(a)
	end,
}

--curse/darkness
logCHN:newLog{
	log = "The dark tendrils dissipate.",
	fct = function()
		return "黑暗触须消失了。"
	end,
}

logCHN:newLog{
	log = "The dark tendrils lash at %s.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("黑暗触须攻击了%s。"):format(a)
	end,
}

--curse/sustenance
logCHN:newLog{
	log = "You can only gain sustenance from your foes!",
	fct = function()
		return "你只能从你的目标身上吸取！"
	end,
}

logCHN:newLog{
	log = "You must begin feeding before you can Devour Life.",
	fct = function()
		return "必须先使用吞食技能。"
	end,
}

--curse/endless-hunt
logCHN:newLog{
	log = "#F53CBE#You are having trouble focusing on your prey!",
	fct = function()
		return "#F53CBE#你无法集中注意力在你的目标身上！"
	end,
}

--curse/fears
logCHN:newLog{
	log = "#F53CBE#%s ignores the fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 无视了恐惧！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了恐惧！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s ignores the panic!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s无视惊恐！"):format(a)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s resists the panic!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s抵抗了惊恐！"):format(a)
	end,
}

--curse/force-of-will

logCHN:newLog{
	log = "#Source# was blasted %d spaces into #Target#!",
	fct = function(a)
		return ("#Source# 被推送 %d 格进入 #Target# ！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s was blasted into %s!",
	fct = function()
		return "#Source# 被推送进 #Target ！"
	end,
}

logCHN:newLog{
	log = "%s was smashed back %d spaces!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 被击退 %d 格！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s was smashed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被粉碎！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s was blasted back %d spaces!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 被击退 %d 格！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "You have deflected %d incoming damage!",
	fct = function(...)
		return ("你偏转了 %d 所受伤害。"):format(...)
	end,
}
--curse/gestures
logCHN:newLog{
	log = "You require two free or mindstar-equipped hands to use Gesture of Pain.",
	fct = function()
		return ("你需要空手或双持灵晶来激活痛苦手势。")
	end,
}

logCHN:newLog{
	log = "%s resists the Gesture of Pain.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了痛苦手势。"):format(a)
	end,
}
logCHN:newLog{
	log = "#F53CBE#You revel in attacking a weakened foe! (+%d hate)",
	fct = function()
		return "#F53CBE#你沉醉于折磨虚弱的敌人！ (+%d 仇恨)"
	end,
}

logCHN:newLog{
	log = "#F53CBE##Source# lashes back at #Target#!",
	fct = function()
		return "#F53CBE##Source# 反击 #Target#!"
	end,
}
--curse/gloom
logCHN:newLog{
	log = "#F53CBE#Your heart hardens as a powerful foe enters your gloom! (+%d hate)",
	fct = function(...)
		return ("#F53CBE#当一个强力的敌人进入黑暗光环你的内心变得更加冷酷！（+%d 仇恨）"):format(...)
	end,
}


logCHN:newLog{
	log = "An unseen force begins to swirl around %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("一股无形的力量开始围绕%s旋转！"):format(a)
	end,
}

logCHN:newLog{
	log = "The unseen force around %s subsides.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("围绕%s旋转的无形力量消失了。"):format(a)
	end,
}

--curse/primal-magic
logCHN:newLog{
	log = "Selects a displacement location...",
	fct = function()
		return "选择一个转移目标..."
	end,
}

logCHN:newLog{
	log = "Your attempt to displace fails!",
	fct = function()
		return "你尝试置换术但是失败了！"
	end,
}

--curse/rampage

logCHN:newLog{
	log = "You are already rampaging!",
	fct = function()
		return "你已经在暴走状态！"
	end,
}

logCHN:newLog{
	log = "You must be rampaging to use this talant.",
	fct = function()
		return "只有在暴走状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s slams %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#F53CBE#%s 猛击了 %s ！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#F53CBE#%s resists the stunning blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s抵抗了震慑一击！"):format(a)
	end,
}
logCHN:newLog{
	log = "#F53CBE#Your rampage is invigorated by the collosal slam! (+1 duration)",
	fct = function()
		return "#F53CBE#你的暴走受到鼓舞！（+1 持续时间）。"
	end,
}

logCHN:newLog{
	log = "#F53CBE#Your rampage is invigorated by your firece attack! (+1 duration)",
	fct = function()
		return "#F53CBE#你的暴走被你的猛攻鼓舞！（+1 持续时间）。"
	end,
}

--curse/shadow

logCHN:newLog{
	log = "Your hate is too low to call another shadow!",
	fct = function()
		return "你的仇恨值不足，无法召唤阴影。"
	end,
}

logCHN:newLog{
	log = "#PINK#The shadows converge on #Target#!",
	fct = function()
		return ("#PINK#阴影被集中至 #Target# ！")
	end,
}

logCHN:newLog{
	log = "Their are no shadows to heed the call!",
	fct = function()
		return "没有阴影可以召唤！"
	end,
}

logCHN:newLog{
	log = "#PINK#The shadows form around #Target#!",
	fct = function()
		return ("#PINK#阴影被集中至 #Target# ！")
	end,
}

--curse/slaughter
logCHN:newLog{
	log = "#Source# knocks back #Target#!",
	fct = function()
		return "#Source# 击退了 #Target#！"
	end,
}

logCHN:newLog{
	log = "#Source# blocks #Target#!",
	fct = function()
		return "#Source# 阻挡了 #Target#！"
	end,
}

logCHN:newLog{
	log = "#Source# cleaves through #Target#!",
	fct = function()
		return "#Source# 劈中了#Target#！"
	end,
}

--gift-breathes
logCHN:newLog{
	log = "%s breathes sand!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展沙暴吐息！"):format(a)
	end,
}
logCHN:newLog{
	log = "%s breathes acid!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展酸液吐息！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s breathes lightning!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展闪电吐息！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s breathes poison!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展毒液吐息！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s breathes fire!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展火焰吐息！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s breathes ice!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展寒冰吐息！"):format(a)
	end,
}
--gift/antimagic
logCHN:newLog{
	log = "%s is invigorated by the attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s受到攻击鼓舞！"):format(a)
	end,
}

logCHN:newLog{
	log = "#GREEN#The antimagic shield of %s crumbles.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#GREEN#%s的反魔法护盾消失了。"):format(a)
	end,
}

--gift/call
logCHN:newLog{
	log = "%s meditates on nature.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 进入冥想状态。"):format(a)
	end,
}
--gift/corrosive-blades
logCHN:newLog{
	log = "You somehow fail to set the corrosive seed.",
	fct = function()
		return "你没能设置腐蚀之种。"
	end,
}
--gift/fire-drake

logCHN:newLog{
	log = "%s roars!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发出吼声！"):format(a)
	end,
}
--gift/mucus
logCHN:newLog{
	log = "%s spits slime!",
	fct = function(a)
		a = npcCHN:getName(a)
		return("%s喷射史莱姆！"):format(a)
	end,
}
--gift/sand-drake

logCHN:newLog{
	log = "#Source# tries to swallow #Target#!!",
	fct = function()
		return ("#Source# 试图吞噬 #Target# ！")
	end,
}


logCHN:newLog{
	log = "%s shakes the ground!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 摇晃着大地！"):format(a)
	end,
}

--gift/slime
logCHN:newLog{
	log = "%s releases poisonous spores at %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 向 %s 喷射毒液。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "The skin of %s starts dripping acid.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的皮肤开始滴下酸液。"):format(a)
	end,
}

--gift/storm-drake
logCHN:newLog{
	log = "%s resists the static field!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了静电力场！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is caught in the static field!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s被卷入了静电力场！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the tornado!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s免疫了龙卷风！"):format(a)
	end,
}

--gift/summon
logCHN:newLog{
	log = "You cannot summon; you are suppressed!",
	fct = function()
		return "你不能召唤，你被压制了！"
	end,
}

logCHN:newLog{
	log = "You may not detonate this summon.",
	fct = function()
		return "你无法支配这个召唤兽。"
	end,
}

logCHN:newLog{
	log = "#PINK#You can not summon any more; you have too many summons already (%d). You can increase the limit with higher Cunning(+1 for every 10).",
	fct = function(...)
		return ("#PINK#你不能再召唤更多生物； 你已经召唤了太多了（%d）。 你可以提高灵巧点数来提高召唤上限（每10点增加一个上限）。"):format(...)
	end,
}


logCHN:newLog{
	log = "%s summons a Ritch Flamespitter!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一个里奇之焰！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a 3-headed hydra!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一头三头蛇！"):format(a)
	end,
}



logCHN:newLog{
	log = "%s summons a Rimebark!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一棵雾凇！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a Fire Drake!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一头火龙！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a War Hound!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一头战争猎犬！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a Jelly!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一只果冻怪！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a Minotaur!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一个米诺陶！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons an Stone Golem!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一个岩石傀儡！"):format(a)
	end,
}


logCHN:newLog{
	log = "%s summons a Turtle!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一只乌龟！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons a Spider!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了一只蜘蛛！"):format(a)
	end,
}
--gift/acid-drake
logCHN:newLog{
	log = "%s spits acid!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 喷射了酸液！"):format(a)
	end,
}

--psionic/absorption
logCHN:newLog{
	log = "You may only sustain two shields at once. Shield activation cancelled.",
	fct = function()
		return "你只能同时保持两种护盾效果，激活护盾被取消。"
	end,
}

logCHN:newLog{
	log = "Your spiked kinetic shield crumbles under the damage!",
	fct = function()
		return "你的念力护盾在攻击下消失了！"
	end,
}

logCHN:newLog{
	log = "Your spiked thermal shield crumbles under the damage!",
	fct = function()
		return "你的热能护盾在攻击下消失了！"
	end,
}

logCHN:newLog{
	log = "Your spiked charged shield crumbles under the damage!",
	fct = function()
		return "你的充电护盾在攻击下消失了！"
	end,
}
--psionic/augmented-mobility
logCHN:newLog{
	log = "The target is out of range",
	fct = function()
		return "目标距离太远"
	end,
}


logCHN:newLog{
	log = "%s performs a telekinetically enhanced leap!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了灵能跳跃！"):format(a)
	end,
}

logCHN:newLog{
	log = "You must either have a spiked kinetic shield or be able to spike one. Cancelling charge.",
	fct = function()
		return "你必须拥有念力护盾，冲锋被取消。"
	end,
}

logCHN:newLog{
	log = "You can't move there.",
	fct = function()
		return "你不能移动至那里。"
	end,
}
--psionic/distortion
logCHN:newLog{
	log =  "#Source# pulls #Target# in!",
	fct = function()
		return "#Source#将#Target#拉了进来!"
	end,
}
--psionic/dream-forge
logCHN:newLog{
	log = "#ORANGE#%s forges a dream shield to block the attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#ORANGE#%s 产生了一个梦境屏障来格挡攻击!"):format(a)
	end,
}

logCHN:newLog{
	log = "#ORANGE#%s's dream shield has been strengthened by the attack!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#ORANGE#%s 的梦境屏障被攻击强化了!"):format(a)
	end,
}
logCHN:newLog{
	log = "#GOLD#%s strikes the dreamforge!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#GOLD# %s锤击着梦境熔炉！"):format(a)
	end,
}
logCHN:newLog{
	log = "#GOLD#%s begins breaking dreams!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#GOLD# %s开始破碎梦境！"):format(a)
	end,
}
--psionic/sleeping
logCHN:newLog{
	log = "%s resists the sleep!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了睡眠！"):format(a)
	end,
}
logCHN:newLog{
	log = "You do not have line of sight to this location.",
	fct = function()
		return "你没有这个位置的视野。"
	end,
}
logCHN:newLog{
	log = "The dream walk fizzles!",
	fct = function()
		return "梦境穿梭失败了！"
	end,
}

--psionic/finer-energy-manipulations
logCHN:newLog{
	log = "You reshape your %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你重塑了你的 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "You cannot reshape your %s any further.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不能再重塑 %s 了。"):format(name)
	end,
}
--psionic/mentalism
logCHN:newLog{
	log = "%s's mind is clear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的精神被净化了"):format(a)
	end,
}

logCHN:newLog{
	log = "Not enough space to invoke your spirit!",
	fct = function()
		return "没有空间激发你的灵魂！"
	end,
}

--psionic/nightmare
logCHN:newLog{
	log = "%s resists the nightmare!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了噩梦！"):format(a)
	end,
}
logCHN:newLog{
	log = "#F53CBE#%s's Inner Demon manifests!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#F53CBE#%s的心魔出现了！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the demons!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了心魔！"):format(a)
	end,
}
logCHN:newLog{
	log = "You can't cast this on friendly targets.",
	fct = function()
		return "该技能不能对友军释放。"
	end,
}

--psionic/other
logCHN:newLog{
	log = "%s wears: %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s装备了%s"):format(a,name)
	end,
}

--psionic/projection
logCHN:newLog{
	log = "You may only sustain two auras at once. Aura activation cancelled.",
	fct = function()
		return "你只能同时保持两种光环效果，激活光环被取消。"
	end,
}

logCHN:newLog{
	log = "The aura dissipates without producing a spike.",
	fct = function()
		return "光环没有造成漩涡就消失了。"
	end,
}

--psionic/psychic-assault
logCHN:newLog{
	log = "%s resists the lobotomy!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了脑叶切断！"):format(a)
	end,
}

--psionic/slumber
logCHN:newLog{
	log = "This talent cannot be used from within the Dreamscape.",
	fct = function()
		return "该技能不能在梦境空间中使用。"
	end,
}

logCHN:newLog{
	log = "This talent cannot be used here.",
	fct = function()
		return "该技能不能在此处使用。"
	end,
}

logCHN:newLog{
	log = "Your target must be sleeping in order to enter its dreamscape.",
	fct = function()
		return "要进入梦境空间，目标必须处于睡眠状态。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You are taken to the Dreamscape!",
	fct = function()
		return "#LIGHT_BLUE#你进入了梦境空间！"
	end,
}
logCHN:newLog{
	log = "#LIGHT_BLUE#%s has spawned a dream projection to protect its mind!",
	fct = function(a)
		a = npcCHN:getName(a)
		return("#LIGHT_BLUE#%s产生了一个梦境守卫来保护自己！"):format(a)
	end,
}
logCHN:newLog{
	log = "#LIGHT_BLUE#You are brought back from the Dreamscape!",
	fct = function()
		return "#LIGHT_BLUE#你脱离了梦境空间！"
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#%s writhes in agony as a fragment of its mind is destroyed!",
	fct = function(a)
		a = npcCHN:getName(a)
		return("#LIGHT_RED#%s作为精神碎片被摧毁了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s's mind shatters into %d tiny fragments!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("#LIGHT_RED#%s的精神破碎为%d块碎片！"):format(a,b)
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#%s suffered a %s of self in the Dreamscape!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = b:gsub("potentially fatal loss","致命损伤"):gsub("devastating loss","毁灭性的损伤"):gsub("tremendous loss","严重损伤"):gsub("terrible loss","大量伤害"):gsub("loss","伤害")
		return("#LIGHT_RED#%s在梦境空间中受到了%s！"):format(a,b)
	end,
}

--psionic/solipsism
logCHN:newLog{
	log = "#TAN##Source# mentally dismisses some damage!",
	fct = function()
		return "#TAN##Source# 精神上豁免了部分伤害!"
	end,
}


--spell/explosives
logCHN:newLog{
	log = "You need to ready alchemist gems in your quiver.",
	fct = function()
		return "需要装备炼金宝石。"
	end,
}

logCHN:newLog{
	log = "You need to ready at least two alchemist gems in your quiver.",
	fct = function()
		return "至少需要装备两枚炼金宝石。"
	end,
}
--spell/advances-golemancy
logCHN:newLog{
	log = "Your golem is currently inactive.",
	fct = function()
		return "你的傀儡当前尚未被激活。"
	end,
}

logCHN:newLog{
	log = "Not enough space to supercharge!",
	fct = function()
		return "没有足够的空间来超载傀儡！"
	end,
}

--spell/golem
logCHN:newLog{
	log = "Your golem cannot do that currently.",
	fct = function()
		return "你的傀儡现在不能使用该技能。"
	end,
}

logCHN:newLog{
	log = "You are too close to build up momentum!",
	fct = function()
		return "离开目标太近无法施展！"
	end,
}

logCHN:newLog{
	log = "#Source# provokes #Target# to attack it.",
	fct =function()
		return "#Source#强制#Target#攻击它"
	end,
}

logCHN:newLog{
	log = "%s resists the crushing!",
	fct =function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了压碎"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the dazing blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了眩晕打击！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Target# is pulled toward #Source#!",
	fct = function()
		return "#Target#被拉向#Source#!"
	end,
}

--spell/golemancy
logCHN:newLog{
	log = "Your golem is out of sight; you cannot establish direct control.",
	fct = function()
		return "你的傀儡在视线外，你无法直接控制它。"
	end,
}

logCHN:newLog{
	log = "Not enough space to refit!",
	fct = function()
		return "没有足够的空间改装！"
	end,
}

logCHN:newLog{
	log = "You have been interrupted!",
	fct = function()
		return "你被打断！"
	end,
}

logCHN:newLog{
	log = "You need to ready 2 alchemist gems in your quiver to heal your golem.",
	fct = function()
		return "你至少在你的弹药栏内装备2枚炼金宝石， 才能够修理你的傀儡。"
	end,
}

logCHN:newLog{
	log = "You need to ready 15 alchemist gems in your quiver to heal your golem.",
	fct = function()
		return "你至少在你的弹药栏内装备15枚炼金宝石， 才能够修理你的傀儡。"
	end,
}

logCHN:newLog{
	log = "Not enough space to invoke!",
	fct = function()
		return "没有足够的空间召唤！"
	end,
}

logCHN:newLog{
	log = "#Target# focuses on #Source#.",
	fct = function()
		return "#Target# 将注意力集中到 #Source#。"
	end,
}

--spell/fire-alchemy
logCHN:newLog{
	log = "#FF8000#%s turns into pure flame!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#FF8000#%s完全成为了火焰！"):format(a)
	end,
}

logCHN:newLog{
	log = "#FF8000#The raging fire around %s calms down and disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#FF8000#围绕%s的愤怒火焰沉寂了下来并消失了。"):format(a)
	end,
}

--spell/staff-combat
logCHN:newLog{
	log = "You need a staff to use this spell.",
	fct = function()
		return "你需要一把法杖来施展该技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Blunt Thrust without a staff weapon!",
	fct = function()
		return "你需要一把法杖来施展该技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Blunt Thrust without a two-handed weapon!",
	fct = function()
		return "你需要一把法杖来施展该技能。"
	end,
}

logCHN:newLog{
	log = "%s resists the stunning blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了震慑打击。"):format(a)
	end,
}
--spell/stone-alchemy
logCHN:newLog{
	log = "You create: %s",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你制造了：%s"):format(name)
	end,
}

logCHN:newLog{
	log = "You extract %s from %s",
	fct = function(a,b)
		local name2 = objects:getObjectsChnName(a)
		local name1 = objects:getObjectsChnName(b)
		return ("你从 %s 中提炼了 %s 。"):format(name1,name2)
	end,
}

logCHN:newLog{
	log = "You imbue your %s with %s.",
	fct = function(a,b)
		local name1 = objects:getObjectsChnName(a)
		local name2 = objects:getObjectsChnName(b)
		return ("你在 %s 上安装了 %s 。"):format(name1,name2)
	end,
}

logCHN:newLog{
	log = "You need to ready 5 alchemist gems in your quiver.",
	fct = function()
		return "你至少需要装备5枚炼金宝石。"
	end,
}


--spell/arcane
logCHN:newLog{
	log = "#VIOLET#%s's disruption shield collapses and then explodes in a powerful manastorm!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#VIOLET#%s的干扰护盾破碎并爆炸产生了一股强力的法力风暴！"):format(a)
	end,
}
--spell/aether
logCHN:newLog{
	log = "You somehow fail to set the aether beam.",
	fct = function()
		return "你没能设置以太螺旋。"
	end,
}
--spell/water

logCHN:newLog{
	log = "A #LIGHT_BLUE#wave of icy water#LAST# erupts from the ground!",
	fct = function()
		return "一股 #LIGHT_BLUE#冰冷的水流#LAST# 从地面上涌现!"
	end,
}

logCHN:newLog{
	log = "You are already a Shivgoroth!",
	fct = function(a)
		return "你已经是寒冰元素了！"
	end,
}
--spell/ice
logCHN:newLog{
	log = "%s shatters!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 粉碎了！"):format(a)
	end,
}

--spell/air
logCHN:newLog{
	log = "#0080FF#A furious lightning storm forms around %s!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#0080FF#一道强烈的闪电风暴围绕着%s！"):format(a)
	end,
}

logCHN:newLog{
	log = "#0080FF#The furious lightning storm around %s calms down and disappears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#0080FF#围绕着%s的闪电风暴沉寂了下来并消失了。"):format(a)
	end,
}

--spell/necrosis
logCHN:newLog{
	log = "#GREY#As you turn into a powerful undead you feel your body violently rejecting the Blood of Life.",
	fct = function()
		return "#GREY#当你成为强大的不死生物你感到你的身体强烈的对抗着 生命之血。"
	end,
}

--spell/animus
logCHN:newLog{
	log = "Your husk is out of sight; you cannot establish direct control.",
	fct = function()
		return "你的傀儡在视线外，你无法直接控制它。"
	end,
}

logCHN:newLog{
	log = "#GREY##Source# rips apart the animus of #target# and creates an undead husk.",
	fct = function()
		return "#GREY##Source# 抹杀了 #target# 的灵魂，制造了一个不死傀儡。"
	end,
}

--spell/conveyance
logCHN:newLog{
	log = "Select a target to teleport...",
	fct = function()
		return "选择目标传送..."
	end,
}

logCHN:newLog{
	log = "The targetted phase door fizzles and works randomly!",
	fct = function()
		return "目标传送门故障，随机传送！"
	end,
}

logCHN:newLog{
	log = "The spell fails: no suitable places to teleport to.",
	fct = function()
		return "法术失败：没有合适位置"
	end,
}
--spell/divination
logCHN:newLog{
	log = "#OLIVE_DRAB#Your premonition allows you to raise a shield just in time!",
	fct = function()
		return "#OLIVE_DRAB#你的预知能力是你及时获得一个护盾！"
	end,
}

--technique/2h-weapon

logCHN:newLog{
	log = "You require a two handed weapon to use this talent.",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Death Dance without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Berserker without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Warshout without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Death Blow without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "%s feels the pain of the death blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 感受到了死亡一击的疼痛！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the death blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了死亡一击！"):format(a)
	end,
}
logCHN:newLog{
	log = "You cannot use Stunning Blow without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Sunder Armour without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Sunder Arms without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Blood Frenzy without a two-handed weapon!",
	fct = function()
		return "你需要装备一把双手武器来施展这个技能。"
	end,
}

--technique/weapon-shield
logCHN:newLog{
	log = "You require a weapon and a shield to use this talent.",
	fct = function()
		return "你需要一把武器一个盾牌来施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Shield Pummel without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "%s resists the shield bash!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了盾牌猛击！"):format(a)
	end,
}

logCHN:newLog{
	log = "You cannot use Overpower without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "You cannot use Assault without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "You cannot use Shield Wall without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "You cannot use Repulsion without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "You cannot use Last Stand without a shield!",
	fct = function()
		return "必须装备一面盾牌施展该技能！"
	end,
}

logCHN:newLog{
	log = "You require a shield to use this talent.",
	fct = function()
		return "你需要一面盾牌来施展这个技能。"
	end,
}

--technique/archery

logCHN:newLog{
	log = "%s shoots!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 射击！"):format(a)
	end,
}

logCHN:newLog{
	log = "You require a bow or sling for this talent.",
	fct = function()
		return "你需要一把弓或者投石索来施放这个技能。"
	end,
}

logCHN:newLog{
	log = "You must have a quiver or pouch equipped.",
	fct = function()
		return "你必须装备弹药。"
	end,
}

logCHN:newLog{
	log = "Your %s is full.",
	fct = function(...)
		return "你的弹药满了"
	end,
}
logCHN:newLog{
	log = "You cannot use Aim without a bow or sling!",
	fct = function()
		return "你需要一把弓或者投石索来施放这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Rapid Shot without a bow or sling!",
	fct = function()
		return "你需要一把弓或者投石索来施放这个技能。"
	end,
}

logCHN:newLog{
	log = "%s resists the stunning shot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了震慑！"):format(a)
	end,
}
logCHN:newLog{
	log = "You must wield a sling!",
	fct = function()
		return "你必须装备投石索！"
	end,
}

logCHN:newLog{
	log = "You require a sling for this talent.",
	fct = function()
		return "你需要一把投石索来施放这个技能。"
	end,
}
logCHN:newLog{
	log = "%s stands firm!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 稳稳站在原地！"):format(a)
	end,
}
logCHN:newLog{
	log = "You require a bow for this talent.",
	fct = function()
		return "你需要一把弓来施展这个技能。"
	end,
}
logCHN:newLog{
	log = "You must wield a bow!",
	fct = function()
		return "你必须装备一把弓！"
	end,
}
--technique/excellence
logCHN:newLog{
	log = "#Source# shoots down '#Target#'.",
	fct = function()
		return "#Source# 击落了#Target#。"
	end,
}

logCHN:newLog{
	log = "%s %s the attack!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if b:find("intercepts") then b = "拦截了" end
		if b:find("fail to intercept") then b = "没能拦截" end
		return ("%s %s攻击"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s resists the strangling shot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了沉默！"):format(a)
	end,
}
--technique/acrobatic
logCHN:newLog{
	log = "You must have an empty space to land in.",
	fct = function()
		return "你需要空地来着陆。"
	end,
}
logCHN:newLog{
	log = "You need someone adjacent to vault over.",
	fct = function()
		return "你需要身边有生物来撑杆跳。"
	end,
}
logCHN:newLog{
	log = "You must have an empty space to roll to.",
	fct = function()
		return "你需要有空位来滚动。"
	end,
}

--technique/buckler-traning
logCHN:newLog{
	log = "You require a ranged weapon and a shield to use this talent.",
	fct = function()
		return "你必须装备一把远程武器和一面盾牌。"
	end,
}

logCHN:newLog{
	log = "#ORCHID##Source# follows up with a countershot.#LAST#",
	fct = function()
		return "#ORCHID##Source# 启动了反击射击.#LAST#。"
	end,
}



--technique/dualweapon

logCHN:newLog{
	log = "You require two weapons to use this talent.",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Precision without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You require two weapons to use this talent.",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Momentum without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Dual Strike without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "%s resists the stunning strike!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了震慑打击！"):format(a)
	end,
}
logCHN:newLog{
	log = "You cannot use Flurry without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Sweep without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Whirlwind without dual wielding!",
	fct = function()
		return "你只有在双持状态下才能使用这个技能。"
	end,
}
--technique/unarmed-discipline
logCHN:newLog{
	log = "#Source# slams #Target# into the ground!",
	fct = function()
		return"#Source将#Target#掀翻在地！"
	end,
}

logCHN:newLog{
	log = "#Source# throws #Target# to the ground!",
	fct = function()
		return "#Source#将#Target#扔到地上！"
	end,
}
logCHN:newLog{
	log = "#Source# misses a defensive throw against #Target#!",
	fct = function()
		return "#Source# 对#Target#的反击没有命中!"
	end,
}
--technique/pugilisim
logCHN:newLog{
	log = "%s throws two quick punches.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 进行了两次快速攻击。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s lashes out with a spinning backhand.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了旋风打击。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s lashes out with a flurry of fists.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了流星拳。"):format(a)
	end,
}
--technique/finishing-moves
logCHN:newLog{
	log = "%s throws a finishing uppercut.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了终结技上钩拳。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s throws a concussive punch.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了终结技金刚碎。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s throws a body shot.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了终结技崩拳。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s throws a wild haymaker!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了终结技收割之刃。"):format(a)
	end,
}


logCHN:newLog{
	log = "%s resists the body shot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了崩拳！"):format(a)
	end,
}
--technique/bloodthirst
logCHN:newLog{
	log = "%s resists the terror!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了恐惧！"):format(a)
	end,
}

--technique/combat-techniques
logCHN:newLog{
	log = "%s rushes out!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发起冲锋！"):format(a)
	end,
}

--technique/conditioning
logCHN:newLog{
	log = "%s is not intimidated!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 不受威吓！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has recovered!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 已经恢复！"):format(a)
	end,
}
--technique/superiority
logCHN:newLog{
	log = "%s is called to battle!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被拉进战斗！"):format(a)
	end,
}
--technique/thuggery
logCHN:newLog{
	log = "%s resists the headblow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了铁头功！"):format(a)
	end,
}

--uber
logCHN:newLog{
	log = "%s's draconic body hardens and heals!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的龙族之躯硬化并恢复了生命！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#%s slows from critical velocity!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#%s 从临界速度减慢!"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#%s reaches critical velocity!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#%s 达到了临界速度!"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#%s fiery attack invokes a cleansing flame!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#CRIMSON#%s 的火焰引发了净化能量！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#%s's unbreakable will shrugs off the effect!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_BLUE#%s 的坚定意志豁免了此效果！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE##Source# punishes #Target# for casting a spell!",
	fct = function()
		return "#LIGHT_BLUE##Source# 惩罚了 #Target# 的施法!"
	end,}
--misc/npc
logCHN:newLog{
	log = "%s hurls lightning at %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s向%s释放闪电！"):format(a,b)
	end,
}

--misc/race
logCHN:newLog{
	log = "%s resists the mental assault!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了精神攻击！"):format(a)
	end,
}
--misc/inscription

logCHN:newLog{
	log = "Your negative mana regeneration rate is unaffected by the rune.",
	fct = function()
		return "你的负法力回复率不受符文影响。"
	end,
}

logCHN:newLog{
	log = "Your nonexistant mana regeneration rate is unaffected by the rune.",
	fct = function()
		return "你的法力回复率不受符文影响。"
	end,
}

logCHN:newLog{
	log ="%s is immune!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 免疫了!"):format(a)
	end,
}

--misc/object
logCHN:newLog{
	log = "%s's animating magic is disrupted! ",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的魔法被干扰了!"):format(a)
	end,
}

logCHN:newLog{
	log = "You require a digger to dig.",
	fct = function()
		return "挖掘需要装备锄头。"
	end,
}

logCHN:newLog{
	log = "You overdose on the honeyroot sap!",
	fct = function()
		return "你嗑药过量，混乱了！"
	end,
}
--misc/misc
logCHN:newLog{
	log = "#F53CBE#An elite foe has fallen to your hate! (+%d hate)",
	fct = function(...)
		return ("#F53CBE#一位精英敌人被你的仇恨吞噬! (+%d 仇恨)"):format(...)
	end,
}

logCHN:newLog{
	log = "#F53CBE#You have taken the life of an experienced foe! (+%d hate)",
	fct = function(...)
		return ("#F53CBE#你杀死了一位身经百战的敌人！ (+%d 仇恨)"):format(...)
	end,
}

logCHN:newLog{
	log = "#F53CBE#Your hate has conquered a great adversary! (+%d hate)",
	fct = function(...)
		return ("#F53CBE#你战胜了一个强大的对手！ (+%d 仇恨)"):format(...)
	end,
}

logCHN:newLog{
	log = "There are creatures that could be watching you; you cannot take the risk.",
	fct = function()
		return "有生物可以看见你，你不能冒这个险。"
	end,
}


logCHN:newLog{
	log = "#{bold}#%s decays into a pile of ash!#{normal}#",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#{bold}#%s变成了一堆灰烬。#{normal}#"):format(a)
	end,
}

logCHN:newLog{
	log = "#GREEN#%s absorbs part of the blow. %s is closer to nature.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#GREEN#%s吸收了部分攻击，%s更加贴近自然了。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s holds on to its sanity.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s保持了神智清醒。"):format(a)
	end,
}

logCHN:newLog{
	log = "The scent of blood sends the %ss into a frenzy!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("鲜血的气味使得%s们变得狂热！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the void!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了虚空！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the worm rot!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了腐肉虫！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the blindness blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了致盲一击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了攻击！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the constriction!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了重构！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s summons %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 召唤了 %s ！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s resists the grab!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了抓取！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is cured!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被治愈！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s spawns one of its tentacles!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 产生了一只触手！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is pulled in!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被拉了进去！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s spawns a slimy crawler!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 产出了一只黏糊糊的爬虫！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the shove!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了推挤！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is knocked back by the gale!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被大风吹了回来！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s remains firmly planted in the face of the gale!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 在大风中依然稳稳站立！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is knocked back by the telekinetic blow!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被念力打击击退！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s holds its ground!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 站稳在了原地！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is teleported a short distance!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 传送了一小段距离！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s resists the teleportation!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 抵抗了传送！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s retreats in terror!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 在恐惧中撤退！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s shakes off the fear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 豁免了恐惧！"):format(a)
	end,
}

logCHN:newLog{
	log = "You are too injured to use this talent.",
	fct = function()
		return "你严重受伤无法使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You can not use your %s anymore.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("你不能再使用 %s "):format(name)
	end,
}

logCHN:newLog{
	log = "You cannot do that without a telekinetically-wielded melee weapon.",
	fct = function()
		return "你必须在用念力控制一把近战武器时才能施展这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot do that without a weapon in your hands.",
	fct = function()
		return "你必须装备一把武器施展该技能。"
	end,
}

logCHN:newLog{
	log = "The fabric of spacetime ripples and your spell backfires!!",
	fct = function()
		return "时空之网产生波动，你的法术回火了！！"
	end,
}

logCHN:newLog{
	log = "The timeline is too fractured right now to use this ability.",
	fct = function()
		return "时间线断裂，当前无法使用这个技能。"
	end,
}

logCHN:newLog{
	log = "You cannot use Eldricth Blow without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}

logCHN:newLog{
	log = "You cannot use Eldricth Fury without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}

logCHN:newLog{
	log = "You cannot use Eldritch Slam without a shield!",
	fct = function()
		return "必须装备一面盾牌！"
	end,
}

--message mode
logCHN:newLog{
	log = "%s crawls poison onto %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 爪击 %s 并使其中毒。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s crawls acid onto %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 爪击 %s 并使其受到酸性伤害。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s releases blinding spores at %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 向 %s 喷射毒液使其致盲。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s releases poisonous spores at %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 向 %s 喷射毒液。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s bites poison into %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 撕咬 %s 并使其中毒。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s diseases %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 传染疫病至 %s 。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s projects ink!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 喷射墨汁。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s rushes out, claws sharp and ready!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发起冲锋，它亮出了锋利的爪子！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s seems to search the ground...",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 似乎在地面上搜寻着什么..."):format(a)
	end,
}

logCHN:newLog{
	log = "%s is caught in a web!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 被困在了网中！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s howls",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发出了低吼"):format(a)
	end,
}

logCHN:newLog{
	log = "%s shrieks.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 发出了尖叫声。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s explodes! %s is enveloped in searing light.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 爆炸了！ %s 笼罩在灼热的光亮中。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s explodes! %s is enveloped in frost.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 爆炸了！ %s 被冻结。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s casts Elemental Bolt!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 打出一发元素箭！"):format(a)
	end,
}

logCHN:newLog{
	log = "A volcano erupts!",
	fct = function()
		return "一座火山开始喷发！"
	end,
}

logCHN:newLog{
	log = "In a frenzy %s bites at %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("在狂热中 %s 咬了 %s 一口！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s leaps forward in a frenzy!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("在狂热中%s 向前跳了一步！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s tries to bite %s with razor sharp teeth!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 用它锋利的牙齿撕咬 %s ！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s shows %s the madness of the void.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 向 %s 展现了虚空疯狂。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s summons void shards.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 召唤了虚空碎片。"):format(a)
	end,
}


logCHN:newLog{
	log = "%s has shrugged off %d damage and is ready for more.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 无视了 %d 伤害，似乎仍意犹未尽。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s uses Warshout.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了战争怒吼。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s uses Warsqueak.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 施展了战争喷吐。"):format(a)
	end,
}

logCHN:newLog{
	log = "You somehow fail to set the trap.",
	fct = function()
		return "你没能设置陷阱。"
	end,
}



logCHN:newLog{
	log = "#ORCHID#%s cleverly deflects the attack with %s shield!#LAST#",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#ORCHID#%s 用他的盾牌机智地躲避了攻击!#LAST#"):format(a)
	end,
}


logCHN:newLog{
	log = "%s resists the silence!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s抵抗了沉默！"):format(a)
	end,
}


--[[
logCHN:newLog{
	log = "%s dives in the sand!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 跳向沙中!"):format(a)
	end,
}
logCHN:newLog{
	log = "%s stings with her ovipositor!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 用产卵管扎了一下!"):format(a)
	end,
}
logCHN:newLog{
	log = "%s enters a deep slumber.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 进入沉睡."):format(a)
	end,
}
logCHN:newLog{
	log = "%s spawns a tentacle near %s.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s 在%s附近召唤触手."):format(b)
	end,
}
logCHN:newLog{
	log = "%s rockets forward!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 冲向前去!"):format(a)
	end,
}
logCHN:newLog{
	log = "%s breathes a wave of darkness!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 呼出一片黑暗!"):format(a)
	end,
}]]
logCHN:newLog{
	log = "%s tessellates %s cloak!",
	fct = function(a)
		a = npcCHN:getName(a,b)
		return ("%s 镶嵌了披风!"):format(a)
	end,
}
logCHN:newLog{
	log = "%s weaves %s cloak!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 编织起披风!"):format(a)
	end,
}
logCHN:newLog{
	log = "%s strafes with %s steamguns!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 使用蒸汽枪扫射"):format(a)
	end,
}
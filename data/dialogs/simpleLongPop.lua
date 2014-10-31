simpleLongDlg = {}

simpleLongDlg["Celia"] = function()
	local str = [["当你挥出最后一击后，你迅速的挖出赛利亚的心脏为巫妖
仪式做准备。小心的用魔法环绕它来保持它的跳动。"]]
	return "赛利亚",str
end

simpleLongDlg["Mausoleum"] = function()
	local str = [[当你蹑手蹑脚的进入时，你踩到了某个机关，身后落下了
一块巨石堵住了所有的退路。空气又闷又热，并且在这封闭的
空间里，你仿佛被活埋在棺材里一样。

使你感到不安的是一种恐惧感，一种超过畏惧的恐惧感。大厅
的门就在前方，你能感受到门后潜藏的怨恨和邪恶能量。在转
角的尽头你看到黑色的大门下面透出昏暗的灯光，并且你能模
糊的感受到其他的门受牵制于这扇大门——顺从，谦卑并且奴役……

你听到一个女人的哭泣，时不时还夹杂着一声痛苦的哀嚎和尖
叫。声音在密室里回荡并且通过黑暗传入了你的大脑，提醒你
所犯的每一项罪过。内疚、恐怖和害怕如潮水般袭来，它们每
个都紧紧抓住了你的灵魂。你唯一的想法便是逃离此地，不择
一切手段。]]
	return "陵墓",str
end

simpleLongDlg["Danger..."] = function(str)
		if str:find("After walking many hours, ") then
		str = [[在行走了几个小时后，你终于到达了终点。你站在了你能
看到的最高峰位置。
风暴在你的头顶肆虐。]]
	elseif str:find("You step out on unfamiliar grounds.") then
		str = [[你进入了一个不熟悉的地方。你几乎站在了你能看到的最
高峰位置。
风暴在你的头顶肆虐。]]
	elseif str:find("As you arrive in Derth you notice") then
		str = [[当你到达德斯镇时你注意到小镇上空有一大团黑压压的乌
云。你听到小镇广场上传来的尖叫声。]]
	else
		str= [[你上次过来时，这个洞穴里满是你杀死的兽人尸体。现在，
更多的尸体铺在了地上，呈烧焦状态并且散发着糊味。桔色
的昏暗灯光照亮了洞穴延伸的东面。]]
	end
	return "危险……", str
end

simpleLongDlg["Back and there again"] = function(str)
		if str:find("A careful examination") then
		str = [[仔细检查恶魔的身体会发现一个血符文祭祀匕首和一块
共鸣宝石，尽管它们都沾上了烟尘和鲜血，但看起来仍完好
无损。]]
	else
		str = [[当阴影消退，你没有找到任何《关于力场翻转与回复的
可能性研究》标题的文本。你必须回到泰恩那。]]
	end
	return "穿越回来", str
end

simpleLongDlg["Melinda"] = function()
	return "米琳达", [[这个女人似乎从镣铐中释放了出来。她蹒跚着脚步，她赤
裸的身躯滴落着鲜血。“请带我离开这里！”]]
end

simpleLongDlg["Crypt"] = function()
	return "地下室", [[这个女人发出了一声刺耳欲聋的尖叫声，当她的胃被黑色
的爪子撕裂时突然转为恐怖的惊叫。一个铁塔般的恶魔站了
起来，将她的血肉撕裂，并且代替她临终惨叫的是一声恐怖
的怒吼。]]
end

simpleLongDlg["Unknown Sher'Tul Fortress"] = function()
	return "未知夏·图尔堡垒",[[随着突然的震动，你发现你自己……某些地方变的熟悉了。
那光滑的墙壁和温暖的灯光提醒你这是你的堡垒。不过它仍
然有所不同。背后有着轻柔的颂歌声，你感觉整个身体轻飘
飘的，几乎像羽毛一样，似乎你轻轻的移动都能跃至半空。
你有着一种奇异的感觉——你似乎不在马基·埃亚尔了……
在你的前方你感到了某种可怕和完美，恐慌和奇妙感充满了
你身心的每个角落。]]
end

simpleLongDlg["Fortress Shadow"] = function(str)
		if str == "Master, you have sent enough energy to improve your rod of recall. Please return to the fortress." then
		str = "主人，你已经传送了足够多升级回城之杖的能量。请返回堡垒。"
	else
		str = [[主人，你已经传送了足够多激活传送门的能量。
然而似乎在那个房间里有异常的骚动，请尽快返回堡垒。]]
	end
	return "堡垒之影",str
end

simpleLongDlg["Clear sky"] = function(str)
		if str == "It seems the Ziguranth have kept their word.Derth is free of the storm cloud." then
		str = [[似乎伊格兰斯们遵守了他们的诺言。
德斯镇的风暴威胁解除了。]]
	else
		str = [[似乎法师们遵守了他们的诺言。
德斯镇的风暴威胁解除了。]]
	end
	return "清理天空",str
end

simpleLongDlg["Get ready!"] = function(str)
	if str == "Defeat all three enemies!" then
	str = "击败三个敌人！"
	end
	return "准备好了！", str
end

simpleLongDlg["Transmogrification Chest"] = function()
	str = [[这个盒子是伊克格的延伸，任何放进盒子里的物品都可以
被传送至堡垒，由核心控制并将其转化为能量。
这个盒子的副产品是金币，而金币对于堡垒来说是无用的，
所以它会返回给你。

当你持有这个盒子时，你经过的所有地面上的物品都会被自
动捡起，并且在你离开当前层时会全部转化。
要取出物品，只要进入物品栏将它们移入包裹即可。
盒子里的物品不会占用你的负重。]]
	return "转化之盒",str
end

simpleLongDlg["Impossible"] = function(str)
	str = str:gsub("You cannot learn this talent%(s%): ","你不可以学习此技能： ")
	str = str:gsub("You cannot unlearn this talent because of talent%(s%): ","你不可以学习此技能因为技能： ")
	str = str:gsub("You can not unlearn this talent because of talent%(s%): ","你不可以遗忘此技能因为技能： ")
	str = str:gsub("You cannot unlearn this category because of: ","你不可以遗忘此技能树因为： ")
	return "不可能", str
end

simpleLongDlg["Point Zero"] = function()
	str = [[这个裂隙将你带回到了零点圣域——紊乱能量的发源地。
一只时空污秽魔正在攻击圣域，附近所有的守卫都在攻击
它。]]
	return "零点圣域",str
end

simpleLongDlg["Yiilkgur"] = function(str)
	if str:find("This level seems to be removed from the rest of the ruins.")
	then 
		str = [[这个区域似乎独立于世，空气清新，天空晴朗。
你听到远处传来魔法的撞击声。]]
	else 
		str = [[当你进入熟悉的堡垒时，你发现一只橙色的小猫
不知怎么跟着你进来了。
它似乎就是你不久前喂过的那一只]]
	end
	return "伊克格", str
end

simpleLongDlg["Level 50!"] = function()
	return "等级50！", [[你达到了#LIGHT_GREEN#等级 50#WHITE#, 祝贺你！
这个等级很特殊，你可以得到额外的#LIGHT_GREEN#10#WHITE#点属性点,#LIGHT_GREEN#3#WHITE#点职业技能点和#LIGHT_GREEN#3#WHITE#点通用技能点。
现在，勇敢的向前并取得最终的胜利吧！”]]
end

simpleLongDlg["BOOM!"] = function()
	return "爆炸！", [[当你走过岱卡拉时，你发现岱卡拉中心的火山正在爆发。
你看到碎屑从火山中心不断喷发，虽然没有什么危害，不过让你印象深刻。]]
end

simpleLongDlg["Ambush"] = function(str)
	if str:find("the staff is gone") then
		str = [[几个小时以后，你醒了过来，惊讶地发现自己还活着，不过法杖已经不见了！#VIOLET#立刻返回最后的希望报告这件事！]]
	else str = [[令人惊讶，你竟然活了下来！#VIOLET#立刻返回最后的希望报告这件事！]] end
	return "伏击",str
end

simpleLongDlg["Lush Forest"] = function()
	return "茂密森林",[[突然你想起来，很久以前某人曾对你提起过一个坐落于冰冷北方的奇怪森林。]]
end

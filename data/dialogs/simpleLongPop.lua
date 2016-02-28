simpleLongDlg = {}
simpleLongDlg["Cave Detonator"] = function()
	local str = "你安装了炸弹。220回合后将爆炸。你需要在爆炸前离开。\n使用 #{bold}##GOLD#回归之杖#LAST##{normal}#!"
	return "洞穴引爆",str
end
simpleLongDlg["Sewer Detonator"] = function()
	local str= "你安装了炸弹。100回合后将爆炸。你需要在爆炸前离开。\n使用 #{bold}##GOLD#回归之杖#LAST##{normal}#!"
		return "引爆",str
end
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
		str = [[仔细检查恶魔的身体会发现一把血符祭剑和一块共鸣宝石，
尽管它们都沾上了烟尘和鲜血，但看起来仍完好无损。]]
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
	str = str:gsub("You cannot unlearn this talent because of talent%(s%): ","你不可以遗忘此技能因为技能： ")
	str = str:gsub("You can not unlearn this talent because of talent%(s%): ","你不可以遗忘此技能因为技能： ")
	str = str:gsub("You cannot unlearn this category because of: ","你不可以遗忘此技能树因为： ")
	str = str:gsub("not enough stat","属性点不足")
	str = str:gsub("not enough levels","等级不足")
    str = str:gsub("missing dependency","需求技能未满足")
    str = str:gsub("unknown talent type","未知的技能类型")
    str = str:gsub("not enough talents of this type known","技能树中已学习技能不足")
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
		str = [[几个小时以后，你醒了过来，惊讶地发现自己还活着，不过
        法杖已经不见了！#VIOLET#立刻返回最后的希望报告这件事！]]
	else str = [[令人惊讶，你竟然活了下来！#VIOLET#立刻返回最后的希望报告这件事！]] end
	return "伏击",str
end

simpleLongDlg["Lush forest"] = function()
	return "茂密森林",[[突然你想起来，很久以前某人曾对你提起过一个坐落于冰冷
    北方的奇怪森林。]]
end

simpleLongDlg["Conclave Vault"] = function()
	return "孔克雷夫地下实验室",[[在你到达地图上坐标所指的位置时，你惊奇地发现地上有一
个巨大的裂谷，深邃的谷底中闪烁着金属的光泽，那是一扇
古老的大门。看起来，魔法大爆炸的强大力量所造成的地震
正好将地面切裂，让本来在爆炸中被毁的，通向孔克雷夫古
老遗迹的通道重现人间。你小心地从裂谷上攀爬而下，站在
门前。]]
end

simpleLongDlg["Tannen's Tower"] = function() 
	return "泰恩之塔",[[
	当你爬上楼梯，你看到泰恩正和他的龙傀儡站在一起，手中拿
	着一张羊皮纸。在他阅读的时候，他的眉头紧皱，汗如雨下，
	不断来回踱步着。当他攥起纸条试图放进口袋里的时候，他突
	然望见了你，如同一只受惊吓的猫一样向后跳了几步。“不！
	不是现在！你根本不懂，现在是生死攸关的时刻！”他从长袍
	中拿出一把彩色的小瓶子，身旁龙傀儡站了起来，眼睛放射出
	光芒，金属的响声如同真龙的吼叫一般，让你印象深刻。
	]]
end

simpleLongDlg["Deep slumber..."] = function(str)
	local msg = str
	if str == [[The noxious fumes have invaded all your body, you suddenty fall into a deep slumber...
... you feel weak ...
... you feel unimportant ...
... you feel like ... food ...
You feel like running away!]] then
		msg = [[有毒的气息渗入你的全身，渐渐地，你缓缓陷入沉眠之中…
…你感觉自己很虚弱…
…你感觉自己很渺小…
…你感觉自己…就像是猎物…
你感觉你必须赶紧逃跑！]]
	elseif str == [[As your mind-mouse enters the dream portal you suddenly wake up.
You feel good!]] then
		msg = [[当梦中的老鼠进入了梦境传送门之时，你突然醒来。
你感觉神清气爽！]]
	elseif str == [[The noxious fumes have invaded all your body, you suddenty fall into a deep slumber...
... you feel you forgot something ...
... you feel lost ...
... you feel sad ...
You forgot your wife! Find her!]] then
		msg = [[有毒的气息渗入你的全身，渐渐地，你缓缓陷入沉眠之中…
…你感觉自己忘了什么…
…你感觉自己处在迷失之中…
…你感觉自己很沮丧…
你忘了你的妻子！快找到她！]]
	elseif str == [[As you enter the dream portal you suddenly wake up.
You feel good!]] then
		msg = [[当你进入了梦境传送门之时，你突然醒来。
你感觉神清气爽！]]
	elseif str == [[As you die in a dream you suddenly wake up.
Posionous fumes take their toll on your body!]] then
		msg = [[当你在梦中死去时，你突然醒来。
呛在有毒的烟雾中让你浑身不适！]]
	end
	return "沉眠", msg
end

simpleLongDlg["Lake of Nur"] = function()
	return "纳尔湖", [[当你进入下一层时你感受到了一股奇异的屏障试图隔离湖水。
然而奇异的屏障似乎被破坏了，下一层也已经被水淹没。]]
end

simpleLongDlg["Screenshot taken"] = function(str)
	str = str:gsub("Screenshot should appear in your Steam client's #LIGHT_GREEN#Screenshots Library#LAST#.\nAlso available on disk: ", "截图已经保存在你Steam客户端中的#LIGHT_GREEN#截图展柜#LAST#\n文件也存放在硬盘上的：")
	return "截图已保存", str
end

simpleLongDlg["Cultist"] = function(str)
	str = str:gsub("A terrible shout thunders across the level: 'Come my darling, come, I will be ssssooo *nice* to you!'","一个恐怖的声音突然自空中传来：“来吧，亲爱的，来吧，我将会好好的“疼”你的。” ")
		:gsub("You should flee from this level!","你必须逃离此地！")
	return "邪教徒", str
end

simpleLongDlg["Onslaught"] = function()
	return "围攻", [[你从不死族的围攻中幸存了下来，你注意到周围墙上有一条
你不曾注意的向上爬的道路]]
end

simpleLongDlg["Cursed Fate"] = function(str)
	str = str:gsub(" lies defiled at your feet. An aura of hatred surrounds you and you now feel truly cursed. You have gained the Cursed Aura talent tree and 1 point in Defiling Touch, but at the cost of 2 Willpower.", " 。一 个 诅 咒 光 环 笼 罩 了 你， 你 感 到 自 己 被 诅 咒 了。 你 获 得 了 诅 咒 光 环 技 能 树 和 等 级 1 的 诅 咒 之 触， 但 是 需 永 久 消 耗 2 点 意 志。")
	str = str:gsub("The ", "你 的 脚 下 躺 着 受 诅 咒 的 ")
	return "被诅咒的命运", str
end

simpleLongDlg["Mouse Gestures"] = function()
	return "鼠标手势",[[
你开始试着绘制鼠标手势了！
鼠标手势可以让你用鼠标动作来完成释放技能或是键盘操作。
你只需要#{bold}#右击并拖动#{normal}#就可以绘制鼠标手势。
默认情况下，鼠标手势没有绑定到任何操作。如果你需要使用
鼠标手势，你可以在浏览“按键绑定”并添加，它可以为你的
冒险旅程提供帮助。

手势动作以颜色编码，以让你更好地显示你目前做出的动作：
#15ed2f##{italic}#绿色#{normal}##LAST#: 向上拖动
#1576ed##{italic}#蓝色#{normal}##LAST#: 向下拖动
#ed1515##{italic}#红色#{normal}##LAST#: 向左拖动
#d6ed15##{italic}#黄色#{normal}##LAST#: 向右拖动

如果你不希望看到手势动作，请在游戏设置的UI栏设置关闭它。]]
end

simpleLongDlg["Welcome to #CRIMSON#Ashes of Urh'Rok"] = function()
	local races = {"人类", "精灵", "矮人", "半身人"}
	if profile.mod.allow_build.yeek then races[#races+1] = "夺心魔" end
	return "欢迎来到 #CRIMSON#乌鲁洛克之烬", ([[
感谢您购买了#CRIMSON#乌鲁洛克之烬#WHITE#，《马基埃亚尔的传说》的第一个
扩展包。

若要开始一段与恶魔共舞的毁灭旅程，请您选择毁灭使者（堕落
系）作为您的职业，选择%s
作为你的职业。

恶魔之力，毁灭一切！
]]):format(table.concatNice(races, '、', '或'))
end
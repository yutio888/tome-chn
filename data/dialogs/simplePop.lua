simplePopDlg = {}
simplePopDlg["Sewer Detonator"] = function()
	return "引爆", "你需要找到结构弱点才能安装炸弹。"
end
simplePopDlg["Caves..."] = function()
	return "洞穴...","当你走进洞穴时，你发现这里已经被魔法力量扭曲了，使其变得规整而曲折。"
end

simplePopDlg["Lake of Nur"] = function(str)
	if str == "You descend into the submerged ruins. The walls look extremely ancient, yet you feel power within this place." then
		str = "你进入了水中的废墟。这些墙看起来十分古老，但你仍旧可以感受到此处的能量。"
	else
		str = "当你进入下一层时你感受到了一股奇异的屏障隔离了湖水。你听到了可怕的尖叫。"
	end
	return "纳尔湖",str
end

simplePopDlg["Screams"] = function()
	return "尖叫", "你听到了不远处的尖叫声。"
end

simplePopDlg["Back and there again"] = function(str)
	if str == "As the annoying imp falls a portal appears under its corpse." then
		str = "当这只讨厌的小恶魔被击败后，一个传送门从它的尸体下露了出来。"
	else
		str = "一道传送门出现在塔中间！"
	end
	return "穿越回来",str
end

simplePopDlg["Infinite Dungeon"] = function()
	return "无尽地下城", "你不应该去那里，那里没有回头路。也许等你做完了该做的事之后你可以来这里试一试。"
end

simplePopDlg["Strange Orb"] = function(str)
	if str == "The orb seems to react badly to your touch, there is a high shriek!" then
		str = "这只水晶球在你的触摸下反应很糟，你听到了一声尖叫！"
	elseif str == "The orb glows brightly. There is a loud crack coming from the northern central chamber." then
		str = "水晶球闪耀着光芒。来自北部中心的地区传出了一声巨大的破裂声。"
	elseif str == "The orb glows brightly." then
		str = "水晶球闪耀着光芒。"
	elseif str == "The orb looks inactive." then
		str = "水晶球看起来对你不起反应"
	end
	return "奇特的水晶球", str	
end

simplePopDlg["Guardian"] = function()
	return "地城守卫", "你听到了魔力开关被触动的声音。"
end

simplePopDlg["Exploratory Farportal"] = function(str)
	if str == "The farportal seems to be inactive" then
		str = "这扇传送门看起来未激活。"
	elseif str == "The fortress does not have enough energy to power a trip through the portal." then
		str = "堡垒没有足够的能量来完成一次传送。"
	else str = "传送门损坏并且再也不能使用了。"
	end
	return "探索传送门", str	
end

simplePopDlg["Yiilkgur"] = function()
	return "伊克格", "这一层似乎远离了那些剩余的地下城。空气新鲜，阳光明媚。你听到了远处劈啪作响的魔法能量声。"
end

simplePopDlg["Telmur"] = function()
	return "泰尔玛", "当你到达塔下时，你发现它已经整个被摧毁了，只留有塔基存在。"
end

simplePopDlg["Orc Breeding Pit"] = function()
	return "兽人育种棚", "你来到了一个小型地下建筑前。那里有着许多兽人，当他们注意到你时，他们叫道“保护母亲们！”"
end

simplePopDlg["Temporal Rift"] = function(str)
	if str == "Space and time distort and lose meaning as you pass through the rift. This place is alien." then
		str = "当你穿过裂隙时，时空扭曲且停滞了。这个地方似乎在外太空。"
	elseif str == "This looks like Maj'Eyal's forest but it looks strangely distorted, beware..." then
		str = "这里看起来像是马基·埃亚尔的丛林，但它看起来被诡异的扭曲过，当心……"
	elseif str == "As you pass the rift you see what seems to be the Daikara mountains, yet they are not." then
		str = "当你经过裂隙时你看到了像是岱卡拉山脉的情景，尽管它们不是。"
	else
		str = "此处的和平被打破了。"
	end
	return "时空裂隙", str
end

simplePopDlg["Crypt"] = function(str)
	if str == "You hear an eerie chanting echoing from a distance." then
		str = "你听到远方传来的念诵回响声。"
	elseif str == "The chanting grows louder. You hear a sudden high-pitched scream." then
		str = "念诵声增大了。你突然听到一声尖叫。"
	else str = "你不能放弃米琳达！"
	end
	return "地穴",str	
end

simplePopDlg["Farportal"] = function()
	return "远程传送门", "传送门似乎未激活。"
end

simplePopDlg["Tannen's Tower"] = function()
	return "泰恩之塔", "传送门将你送到了这座高塔的一个小房间里。你必须逃离！"
end
simplePopDlg["Thanks"] = function(str)
	str = str:gsub("You saved all of us, ", "你救了我们所有人")
	str = str:gsub("You saved most of us", "你救了我们大多数人")
	str = str:gsub("please take this has a reward. (They give you", "请把这个带走作为礼物。(他们给了你")
	str = str:gsub("The remaining lumberjacks collect some gold to thanks you","幸存的伐木工们搜集了一些金币来感谢你")
	return "谢谢",str
end

simplePopDlg["Fortress Shadow"] = function()
	str = str:gsub("The energy is too low. It needs to be at least ", "能量太低了。至少需要")
	str = str:gsub("%.", "点能量。")
	return "堡垒之影", ""
end

simplePopDlg["Lichform"] = function()
	return "巫妖转生", "死亡的奥秘之门向你打开！“巫妖转生”技能解锁！"
end

simplePopDlg["Hidden treasure"] = function()
	return "隐藏的宝藏", "通向宝藏的路在东边。但是请当心，死亡常常相伴。"
end

simplePopDlg["Grand Corruptor"] = function()
	return "高阶堕落者", "#LIGHT_GREEN#高阶堕落者注视着你。你感到知识在你的心中流淌。你现在可以控制一些堕落能量了。"
end

simplePopDlg["Not enough money"] = function(str)
	if str:find("gold, you need more gold.") then
		str = str:gsub("This costs","这将耗费")
		str = str:gsub("gold, you need more gold.","金币，你需要更多金币。")
	elseif str:find("Limmir") then
		str = "利米尔的附魔需要更多金币。"
	elseif str == "You do not have enough gold!" then
		str = "你没有足够的金币！"
	else
		str = str:gsub("This costs","这将耗费")
		str = str:gsub("gold.","金币。")
	end
	return "金币不足",str
end

simplePopDlg["Lichform"] = function(str)
	str = str:gsub("You have mastered the lesser arts of overcoming death, but your true goal is before you: the true immortality of Lichform!","你在对抗死亡的过程中初窥门径，但是你的真正目标还很遥远——成为一位不朽的巫妖！")
	str = str:gsub("#GREY#You feel your life slip away, only to be replaced by pure arcane forces! Your flesh starts to rot on your bones, and your eyes fall apart as you are reborn into a Lich!","#GREY#你觉得你的生命在不断流失，取而代之的是纯粹的神秘力量！肉体腐烂的只剩骨头，眼睛也崩落不见，你终于转生成了巫妖！")
	return "巫妖转生",str
end

simplePopDlg["Cursed Fate"] = function(str)
	str = str:gsub("The","这个")
	str = str:gsub("returns to normal and your hate subsides.","变回正常，你的仇恨消弭了。")
	return "被诅咒的命运",str
end

simplePopDlg["Demonic Orb of Many Ways"] = function()
	return "恶魔多元水晶球", "它看起来不像你之前用过的多元水晶球。泰恩肯定替换掉了水晶球，这个骗子！"
end

simplePopDlg["Transmogrification Chest"] = function(str)
	if str == "When you close the inventory window, all items in the chest will be transmogrified." then
		str = "当你关闭物品栏窗口，盒子里的所有物品都会自动转化掉。"
	else
		str  = "你的盒子或地上没有任何要转化的物品。"
	end
	return "转化之盒", str
end

simplePopDlg["Long tunnel"] = function(str)
	if str == "As you enter the tunnel you feel a strange compulsion to go backward." then
		str = "在你试图进入隧道时，有种奇怪的力量把你推了回去。"
	elseif str == "You cannot abandon the yeeks of Rel to the dangers that lie within the island." then
		str = "在清除这座岛上夺心魔们仍然面对的危险之前，你不能离开这座岛。"
	end
	return "绵长隧道", str
end

simplePopDlg["Ambush!"] = function()
	return "埋伏！", "你中埋伏了！"
end


simplePopDlg["Item not found"] = function(str)
	str = str:gsub("You do not have any","你没有任何的")
	return "物品未找到",str
end

simplePopDlg["Running..."] = function()
	return "奔跑中……", "你正在自动探索，按任意键停止。"
end

simplePopDlg["Automatic use enabled"] = function(str)
	str = str:gsub("will now be used as often as possible automatically.","将会在允许的条件下自动使用。")
	return "自动使用开启", str
end

simplePopDlg["Automatic use disabled"] = function(str)
	str = str:gsub("will not be automatically used.","将不会自动使用。")
	return "自动使用关闭", str
end

simplePopDlg["Impossible"] = function(str)
	if str == "You must wear this object to use it!" then
		str = "你必须穿上这件物品来使用它！"
	elseif str == "You cannot take out more points!" then
		str = "你不能遗忘更多属性点！"
	elseif str == "You do not know this talent!" then
		str = "你不会此技能！"
	elseif str == "You cannot unlearn talents!" then
		str = "你不能遗忘此技能！"
	elseif str == "You cannot unlearn talents!" then
		str = "你不能遗忘此技能！"
	elseif str == "You can only improve a category mastery once!" then
		str = "你只能升级一次技能树！"
	elseif str == "You cannot take out more points!" then
		str = "你不能遗忘更多属性点！"
	elseif str == "You cannot unlearn this category!" then
		str = "你不能遗忘该技能树！"
	elseif str == "You do not know this category!" then
		str = "你没有学会该技能树！"
	elseif str == "You cannot unlearn this talent!" then
		str = "你不能遗忘该技能！"
	end
	return "不可能", str
end

simplePopDlg["Character dump complete"] = function(str)
	str = str:gsub("File:","文件：")
	return "角色存储完成",str
end

simplePopDlg["Thank you"] = function()
	return "谢谢你", "谢谢你，一个支付页面将会在你的浏览器中打开。"
end

----levelup dialog

simplePopDlg["Not enough stat points"] = function()
	return "没有足够的属性点", "你没有任何剩余的属性点了！"
end

simplePopDlg["Stat is at the maximum for your level"] = function()
	return "已达到当前等级的最高属性", "只有升级后才可以继续提升该属性！"
end

simplePopDlg["Stat is at the maximum"] = function()
	return "已达到最高属性", "你不能继续提升该属性！"
end

simplePopDlg["Not enough class talent points"] = function()
	return "职业技能点不足", "你没有足够的职业技能点！"
end

simplePopDlg["Cannot learn talent"] = function()
	return "不能学习", "条件不足！"
end

simplePopDlg["Already known"] = function()
	return "已学会", "你已完全掌握此技能！"
end

simplePopDlg["Not enough generic talent points"] = function()
	return "通用技能点不足", "你没有足够的通用技能点！"
end

simplePopDlg["Not enough talent category points"] = function()
	return "技能树解锁点不足", "你没有足够的技能树解锁点！"
end

simplePopDlg["Too low level"] = function(str)
	str = str:gsub("This talent tree only provides talents starting at level","该技能树只能在等级")
	str = str:gsub(". Learning it now would be useless.","学习。现在无法学习它。")
	return "等级太低", str
end

simplePopDlg["sealed door"] = function(str)
	if str == "This door seems to have been sealed off, you need to find a way to open it." then
		str = "这扇门已被封印，你得想办法打开它。"
	elseif str == "This door seems to have been sealed off. You need to find a way to open it." then
		str = "这扇门已被封印，你得想办法打开它。"
	elseif str == "This door seems to be sealed." then
		str = "这扇门已被封印。"
	end
	return "封印的门",str
end

simplePopDlg["open door"] = function()
	return "打开的门","这扇门已被封印，你需要想办法关闭它。"
end

simplePopDlg["Curse!"] = function()
	return "诅咒！", "这具棺材是一个陷阱，一股强烈的诅咒笼罩了你（检查你的技能）。"
end

simplePopDlg["Resting..."] = function()
	return "休息...", "你正在休息...按下Enter中止。"
end

simplePopDlg["A Second Vault"] = function()
	return "另一处宝藏", "你认出这是通向另一处宝藏的门户。你可以听到门的另一边有拖曳的脚步声和沉重的呼吸声。"
end

simplePopDlg["Hotkey not defined"] = function()
	return "热键未绑定", "你可以按M键，按对应说明绑定热键。"
end

simplePopDlg["Not enough gold"] = function()
	return "金币不足", "你没有足够的金币！"
end

simplePopDlg["Rod of Recall"] = function()
	return "回归之杖", "你找到了一根回归之杖，你可以用它快速的离开当前区域，回到大地图。"
end

simplePopDlg["Inscriptions"] = function()
	return "纹身", "你已经解锁了所有的纹身槽。"
end

simplePopDlg["Ground is shaking"] = function()
	return "地震了！", "你感到脚下的大地震颤了起来，但是几秒钟后这种感觉消失了……"
end

simplePopDlg["Weaver Queen"] = function()
	return "织网蛛后", "当你杀死织网蛛后时，你注意到某根时间线曾控制着她。这根线似乎来自某个裂隙。"
end

simplePopDlg["Weird Pedestal"] = function(str)
	str = str:gsub("As you inspect it a shadow materializes near you, and suddenly it is no more a shadow!","当你检查这个基座时，一团阴影出现在你身旁，突然间它凝成了实体！")
	str = str:gsub("You hear a terrible voice saying 'Their lives are mine! I am coming!'","你听到一个可怕而低沉的声音：“他们的生死由吾掌控！吾即将降临！”")
	return "怪异的基座", str
end

simplePopDlg["Forsaken Crypt"] = function()
	return "遗弃地穴", "你听到吱吱声和骨骼摩擦的回声……前方似乎有死亡在等待着你，还是逃吧！"
end

simplePopDlg["Fall..."] = function()
	return "跌落……", "当你试图挖掘地上的坟墓时，坟墓突然裂开，你发现自己落到了一座阴森的洞穴里，通道两边有火把点亮四周。"
end

simplePopDlg["Cultist"] = function(str)
	str = str:gsub("The cultist's soul seems to be absorbed by the strange stone he was guarding. You feel like something is about to happen...","邪教徒的灵魂似乎被其守卫的奇异石头所吸收。你感觉似乎要出大事了……")
	return "邪教徒",str
end

simplePopDlg["Strange Pedestal"] = function()
	return "奇怪的基座","这个基座看起来很奇怪，你能看到上面雕刻着宝石的空位"
end

simplePopDlg["Sludgenest"] = function()
	return "淤泥巢穴","似乎从墙壁里出来的史莱姆会随时间变强"
end

simplePopDlg["Meteor!"] = function()
	return "陨石！","你正匆匆赶路时，你注意到一块巨大的石头正从天而降，在你的身旁坠落！"
end

simplePopDlg["Thunderstorm"] = function()
	return "暴风雨","当你进入这个区域时，你感觉到一股暴风雨在你的头顶盘旋。小心！"
end

simplePopDlg["Snowstorm"] = function()
	return "暴风雪","当你进入这个区域时，你感觉到一股暴风雪在你的头顶盘旋。小心！"
end

simplePopDlg["Legacy of the Naloren"] = function()
	return "纳鲁精灵的遗产","萨拉苏斯很高兴了解你的忠诚，你最好再回去见见他。"
end

simplePopDlg["Murgol Lair"] = function()
	return "穆格尔巢穴", "当你进入巢穴时你听到了打斗的兵器撞击声。似乎已经有人入侵了这里。"
end

simplePopDlg["Fumes"] = function()
	return "烟雾", "当心灵蠕虫倒下时，弥漫的烟气似乎不再侵袭你的心灵了。"
end

simplePopDlg["Rumbling..."] = function()
	return "隆隆之声", "大地震颤起来，远处好像有一个巨大的东西正搅动着大地。"
end

simplePopDlg["Screenshot taken"] = function(str)
	str = str:gsub("File: ", "文件存放位置：")
	return "截图已保存", str
end
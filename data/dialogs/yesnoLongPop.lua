yesnoLongPopDlg = {}

yesnoLongPopDlg["Open the coffin"] = function()
	local str = [[一些富有人家在埋葬尸体时有时会用一些财宝陪葬。
然而他们为了保护棺材同样也施予了强大的诅咒，
你确定要打开么？]]
	return "打开棺材",str
end


yesnoLongPopDlg["Infinite Dungeon"] = function()
	local str = [[你已经完成了你的伟大使命，不过当你进入无尽地下城之后就永远不能再回来，你只有不断的前进直到你光荣地死去。]]
	return "无尽地下城",str
end

yesnoLongPopDlg["Strange Orb"] = function(str)
	str = str:gsub("The orb seems to drip water.","水晶球似乎在滴水。")
	str = str:gsub("The orb is covered in dust.","水晶球覆盖着尘埃。")
	str = str:gsub("The orb is floating in the air.","水晶球漂浮在空中。")
	str = str:gsub("Small seeds seem to be growing inside the orb.","水晶球里面似乎生长着微小的种子。")
	str = str:gsub("The orb swirls with magical energies.","水晶球内有魔法能量的漩涡。")
	str = str:gsub("Flames burst out of the orb.","水晶球迸发出火焰。")
	str = str:gsub("Do you touch it?","你要触摸它么？")

	str = str:gsub("The orb seems to absorb all light.","水晶球似乎吸收了一切光明。")
		 :gsub("The orb is drips with thick blood.","水晶球正在滴血。")
		 :gsub("The orb is icy to the touch.","水晶球摸上去刺骨冰寒。")
		 :gsub("Time seems to slow down around the orb.","水晶球周围的时间减慢了。")
		 :gsub("Your mind is filled with strange thoughts as you approach the orb.","水晶球令你的思维有些紊乱。")
		 :gsub("The orb seems to corrupt all it touches.","水晶球似乎能腐蚀一切。")
	return "奇怪的水晶球",str
end




yesnoLongPopDlg["Force a recall"] = function()
	return "强行召回",[[堡垒阴影警告你如果在没有找到返回传送门的情况下尝试强行召回可能会永久破坏远古探索传送门。]]
end


yesnoLongPopDlg["Warning"] = function()
	return "警告",[[你不能在世界地图上丢弃物品。
如果你丢下，它会永久消失。]]
end
yesnoLongPopDlg["Crack in the floor"] = function()
	return "地板上的洞",[[地板上有个大洞，你觉得你能跳下去。]]
end


yesnoLongPopDlg["Automatic use"] = function(str)
	str = str:gsub("%- requires a turn to use","· 需要一回合使用")
	str = str:gsub("%- requires a target, your last hostile one will be automatically used","· 需要一个目标，你最后的一个敌对目标会被设定为默认目标")
	str = str:gsub("%- will only trigger if no enemies are visible","· 只有当视野内没有敌人时才会触发")
	str = str:gsub("%- will only auto use when no saturation effect exists","· 只有当没有纹身饱和效果时才会自动使用")
	str = str:gsub("%- will automatically target you if a target is required","· 当需要指定目标时会自动以你为目标")
	str = str:gsub("%- will only trigger if enemies are visible and adjacent","· 只有当视野内有相邻的敌人时才会触发")
	str = str:gsub("%- will only trigger if enemies are visible","· 只有当视野内有敌人时才会触发")
	str = str:gsub("Are you sure%?","你确定么？")
	return "自动使用",str
end

yesnoLongPopDlg["Exploration mode"] = function()
	local str = [[探索模式提供给角色无限的生命数。
马基埃亚尔的故事是一款非常耐玩的游戏，你需要不断的从错误中学习。（同样从死亡的错误中学习）我觉得这款游戏可能不会被所有人接受并且在接受了许多建议后，我决定开放探索模式给捐赠者，因为它允许喜欢这款游戏的玩家能全面的体验这款游戏。不过要注意的是，无限的生命并不意味着难度的减少，仅仅意味着你可以有着无限多的尝试次数。
如果你喜欢这类游戏并且你觉得这款游戏很好，你可以考虑捐赠。这会帮助延长这款游戏的寿命。尽管这只是我自娱自乐所做的一款游戏，如果它还能帮助我分担一点养家糊口的压力的话，我就谢天谢地，不会再抱怨现实的诸多压力了。
你可能需要一个在线账号来激活此模式。如果你已经捐赠，你只要重启游戏便可以获得此模式。
捐赠者也可以使用自定义贴图来DIY他们的角色。]]
	return "探索模式",str
end


yesnoLongPopDlg["Custom tiles"] = function()
	local str = [[添加自定义角色贴图模式是为了对所有ToME捐赠者表示感谢。
你可以从近180个（以后还会添加）图标中选择一个你喜欢的角色个性贴图，从特殊的人形生物到各种奇怪的贴图都有。

如果你喜欢这类游戏并且你觉得这款游戏很好，你可以考虑捐赠。这会帮助延长这款游戏的寿命。尽管这只是我自娱自乐所做的一款游戏，如果它还能帮助我分担一点养家糊口的压力的话，我就谢天谢地，不会再抱怨现实的诸多压力了。
你可能需要一个在线账号来激活此模式。如果你已经捐赠，你只要重启游戏便可以获得此模式。
捐赠者也可以在游戏选项中激活探索模式获得无限的生命数。
]]
	return "自定义角色贴图",str
end

yesnoLongPopDlg["Antimagic"] = function()
	return "反魔",[[喝下这支药剂，可以使你获得反魔技能，代价则是不能使用符文、法术类技能或奥术物品。]]
end

yesnoLongPopDlg["High Peak"] = function()
	return "巅峰",[[当你站在楼梯上时，你能感觉到这是一次不能回头的战斗，非生既死，一旦进去就不能回来。
现在进去么？]]
end

yesnoLongPopDlg["Strange Pedestal"] = function(str)
	str = str:gsub("The pedestal seems to react to something in your bag. After some tests you notice it is the","这个基座似乎对你包里的东西有反应。经过测试后，你发现是")
		 :gsub("Do you wish to use the orb on the pedestal?","你想使用这个水晶吗？")
	return "奇怪的基座",str
end

yesnoLongPopDlg["Alter of Dreams"] = function()
	return "梦境祭坛",[[你感觉你能通过它进入梦境。不过，进入梦境后的死亡
将会让你的身体一并死亡。
确定要进入梦境么？]]
end

yesnoLongPopDlg["Encounter"] = function ()
	return "遭遇", "你发现了一个古老地窖的入口，里面笼罩着恐怖的恶魔气息，仅仅站在门口你就已经感受到了它的威胁。\n你听到里面传来了模糊的女人的哭声。", "进入地窖", "悄悄离开"
end

yesnoLongPopDlg["Cursed Fate"] = function(str)
	str = str:gsub(" lying nearby catches your attention. What draws you to it is not the thing itself, but something burning inside you. You feel contempt for it and all worldly things. This feeling is not new but the power of it overwhelms you. You reach out to touch the object, to curse it, to defile it. And you notice it begin to change. The colors of it begin to fade and are replaced with an insatiable hate. For a moment you hesitate. You know you must choose to resist this manifestation of your curse now and forever, or fall further into your madness.", [[引起了你的注意。吸引你的并不是物体本身，而是在你心底熊熊燃烧的憎恨之火。你对它充满着憎恨，正如你憎恨着世间万物一般。对你而言，这种感觉已经相当的熟悉，但是这一次，这股憎恨已经快要支配你了。你伸出手拾起了它 , 发自内心地诅咒它、污染它。紧接着，你发现它发生了变化。它的光泽开始暗淡，继而充斥着无尽的憎恨。那一瞬间，你犹豫了。你知道命运的抉择正放在面前，要么从今天起抵抗身上的诅咒，并与之对抗终身；要么继续放纵自我，任由诅咒带你堕入这疯狂的深渊。]])
	str = str:gsub("The ", "地上的 ")
	return "被诅咒的命运", str, "将你的憎恨释放到物品上", "压制你的憎恨之意"
end

yesnoLongPopDlg["#LIGHT_RED#Intense fight"] = function()
	return "#LIGHT_RED#激烈的战斗", "当你向前走去，你看到了维网中的另外一位成员，并收到了一个清晰的灵能信号：\n#{italic}##UMBER#快跑！我已经死定了，但你还可以救你自己！#{normal}#", "紧急启动回归之杖", "留下来继续战斗！"
end
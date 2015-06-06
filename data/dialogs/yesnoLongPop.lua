yesnoLongPopDlg = {}

yesnoLongPopDlg["Open the coffin"] = function()
	local str = [[一些富有人家在埋葬尸体时有时会用一些财宝陪葬。
然而他们为了保护棺材同样也施予了强大的诅咒，
你确定要打开么？]]
	return "打开棺材",str
end


yesnoLongPopDlg["Infinite Dungeon"] = function()
	local str = [[你已经完成了你的伟大使命，不过当你进入无尽地下城
	之后就永远不能再回来， 你只有不断的前进直到你光荣地死去。]]
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
	return "强行召回",[[堡垒阴影警告你如果在没有找到返回传送门的情况下尝试强
行召回可能会永久破坏远古探索传送门。]]
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
马基埃亚尔的故事是一款非常耐玩的游戏，你需要不断的
从错误中学习。（同样从死亡的错误中学习）我觉得这款游
戏可能不会被所有人接受并且在接受了许多建议后，我决定
开放探索模式给捐赠者，因为它允许喜欢这款游戏的玩家能
全面的体验这款游戏。不过要注意的是，无限的生命并不意
味着难度的减少，仅仅意味着你可以有着无限多的尝试次数。
如果你喜欢这类游戏并且你觉得这款游戏很好，你可以考虑
捐赠。这会帮助延长这款游戏的寿命。尽管这只是我自娱自
乐所做的一款游戏，如果它还能帮助我分担一点养家糊口的
压力的话，我就谢天谢地，不会再抱怨现实的诸多压力了。
你可能需要一个在线账号来激活此模式。如果你已经捐赠，
你只要重启游戏便可以获得此模式。
捐赠者也可以使用自定义贴图来DIY他们的角色。]]
	return "探索模式",str
end


yesnoLongPopDlg["Custom tiles"] = function()
	local str = [[添加自定义角色贴图模式是为了对所有ToME捐赠者表示感谢。
你可以从近180个（以后还会添加）图标中选择一个你喜欢
的角色个性贴图，从特殊的人形生物到各种奇怪的贴图都有。

如果你喜欢这类游戏并且你觉得这款游戏很好，你可以考虑
捐赠。这会帮助延长这款游戏的寿命。尽管这只是我自娱自
乐所做的一款游戏，如果它还能帮助我分担一点养家糊口的
压力的话，我就谢天谢地，不会再抱怨现实的诸多压力了。
你可能需要一个在线账号来激活此模式。如果你已经捐赠，
你只要重启游戏便可以获得此模式。
捐赠者也可以在游戏选项中激活探索模式获得无限的生命数。
]]
	return "自定义角色贴图",str
end

yesnoLongPopDlg["Antimagic"] = function()
	return "反魔",[[喝下这支药剂，可以使你获得反魔技能，代价则是不能使
用符文、法术类技能或奥术物品。]]
end

yesnoLongPopDlg["High Peak"] = function()
	return "巅峰",[[当你站在楼梯上时，你能感觉到这是一次不能回头的战斗
，非生既死，一旦进去就不能回来。
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
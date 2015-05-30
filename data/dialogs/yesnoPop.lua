yesnoPopDlg = {}

yesnoPopDlg["Back and there again"] = function(str)
	local title,text
	title = "穿越回来"
	if str == "Enter the portal back to Maj'Eyal? (Warning loot Draebor first)" then
		text = "进入传送门回到马基埃亚尔？（警告 ）"
	elseif str == "Do you want to travel in the farportal? You can not know where you will end up." then
		text = "你想穿过远古传送门么？你可不知道它会把你送到哪里。"
	else
		text = "进入传送门回到马基埃亚尔？"
	end
	return title,text
end

yesnoPopDlg["Tutorial Lobby Portal"] = function()
	return "传送至大厅","你要进入传送门返回教学大厅么？"
end

yesnoPopDlg["Temporal Rift"] = function()
	return "时空裂隙","你确定要进去么？没人知道这会把你带到哪里， 你也无法知道你是否还能设法返回。"
end

yesnoPopDlg["Atamathon"] = function(str)
	local o = str:match("It seems that your (.+) is made to fit inside the empty eye socket of Atamathon. This is probably very unwise.")
	local key = o:gsub("%d+%*",""):gsub("#[^#]+#","")
	if objCHN[key] then
		o = o:gsub(objCHN[key].enName,objCHN[key].chName)
	end
	str = o .." 的外形看上去似乎可以安装到阿塔玛森的空眼窝内， 但也许这样做并不明智。"
	return "阿塔玛森",str
end

yesnoPopDlg["Danger..."] = function()
	return "危险...","这条路通往食人魔巢穴，一路上到处都是血迹，你确定要进去么？"
end

yesnoPopDlg["Recharge?"] = function(str)
	str = str:gsub("This will cost you ","您将花费")
	str = str:gsub(" gold."," 金币。")
	return "充能？",str
end

yesnoPopDlg["Imbue cost"] = function(str)
	str = str:gsub("This will cost you ","这将花费你 ")
	str = str:gsub(" gold, do you accept%?"," 金币，你接受么？")
	str = str:gsub("You need to use ","你需要花费 ")
	str = str:gsub(" gold for the plating, do you accept%?"," 金币来完成打造，你接受么？")
	return "镀造花费",str
end



yesnoPopDlg["Transmogrification Chest"] = function(str)
	str = str:gsub("Transmogrify all ","转化所有 ")
	str = str:gsub(" item%(s%) on the floor%?"," 地板上的物品么？")
	str = str:gsub(" item%(s%) in your chest%?"," 盒子内的物品么？")
	return "转化之盒",str
end

yesnoPopDlg["Save and exit game?"] = function()
	return "保存并退出？","保存并退出当前游戏么？"
end
yesnoPopDlg["Save and go back to main menu?"] = function()
	return "保存并返回主菜单？","保存并返回主菜单么？"
end
yesnoPopDlg["Buy"] = function(str)
	local a,b,c =str:match("Buy (%d+) (.+) for (.+) gold")
	local key = b:gsub("%d+%*",""):gsub("#[^#]+#","")
	if objCHN[key] then
		b = b:gsub(objCHN[key].enName,objCHN[key].chName)
	end
	str = "花费 " .. c .. " 金币购买" .. a .. "个 " .. b .. " 吗？"
	return "购买",str
end

yesnoPopDlg["Sell"] = function(str)
	local a,b,c =str:match("Sell (%d+) (.+) for (.+) gold")
	local key = b:gsub("%d+%*",""):gsub("#[^#]+#","")
	if objCHN[key] then
		b = b:gsub(objCHN[key].enName,objCHN[key].chName)
	end
	str = "出售" .. a .. "个 " .. b .. " 以换取 " .. c .. " 金币吗？"
	return "出售",str
end

yesnoPopDlg["Transmogrify"] = function(str)
	local a = str:match("Really transmogrify (.+)")
	local key = a:gsub("%d+%*",""):gsub("#[^#]+#","")
	if objCHN[key] then
		a = a:gsub(objCHN[key].enName,objCHN[key].chName)
	end
	str = "真的要转化 " .. a .." ？"
	return "转化",str
end

yesnoPopDlg["Ego"] = function()
	return "个性物品","制作一个个性物品么（假如可以的话）？"
end

yesnoPopDlg["Overwrite character?"] = function()
	return "覆盖角色？","已经有一个叫这个名字的角色了， 你想覆盖这个角色吗？"
end

yesnoPopDlg["Target yourself?"] = function()
	return "以自己为目标？","你确定要以自己为目标吗？"
end

yesnoPopDlg["Really cancel "] = function()
	return "真的要取消","真的要取消"
end

yesnoPopDlg["huge loose rock"] = function()
	return "巨大的松动石头","这个石头是松动的，你认为你可以将其挪开。"
end

yesnoPopDlg["Glowing Chest"] = function()
	return "闪亮的宝箱","打开宝箱吗？"
end

yesnoPopDlg["sealed door"] = function()
	return "封印的门","这扇门被封印了，你觉得你可以打开它。"
end

yesnoPopDlg["Inscriptions"] = function(str)
	str = str:gsub("You can learn","您可以解锁")
	str = str:gsub("new slot%(s%). Do you wish to buy one with one category point?","个新的纹身槽。你希望用1个技能树解锁点解锁1个纹身槽吗")
	return "纹身",str
end

yesnoPopDlg["Weird Pedestal"] = function()
	return "怪异的基座","你想要检查基座吗？"
end

yesnoPopDlg["Exploratory Farportal"] = function()
	return "异度传送门","你想穿过远古传送门么？你可不知道它会把你送到哪里。"
end

yesnoPopDlg["Grave"] = function()
	return "墓穴","你想要挖掘这个坟墓吗？"
end

yesnoPopDlg["Coral Portal"] = function()
	return "珊瑚传送门","你想破坏传送门还是进去？"
end

yesnoPopDlg["Fearscape Portal"] = function()
	return "恐惧空间传送门","你想破坏传送门还是进去？"
end

yesnoPopDlg["Heart of the Sandworm Queen"] = function()
	return "沙虫女王之心","这似乎与沙虫女王之心有反应，你感觉你能腐化它。"
end

yesnoPopDlg["Encounter"] = function(str)
	if str == "You find a hidden trap door, and hear cries for help from within..." then
		return "遭遇", "你发现了一个隐藏地下室的入口，你听到从里面传来了呼救声...","进入通道", "悄悄离开"
	elseif str == "You find an entrance to an old crypt. An aura of terrible evil emanates from this place. You feel threatened just standing there.\nYou hear the muffled cries of a woman coming from inside." then
		return "遭遇", "你发现了一个古老地窖的入口，里面笼罩着恐怖的恶魔气息，仅仅站在门口你就已经感受到了它的威胁。\n你听到里面传来了模糊的女人的哭声。", "进入地窖", "悄悄离开"
	end
end

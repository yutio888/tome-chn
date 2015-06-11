simpleWaiterDlg = {}
simpleWaiterDlg["Saving entity"] = function()
	return "保存物品","保存中，请稍等"
end
simpleWaiterDlg["Saving zone"] = function()
	return "保存地城","保存中，请稍等"
end
simpleWaiterDlg["Saving level"] = function()
	return "保存楼层","保存中，请稍等"
end
simpleWaiterDlg["Saving game"] = function()
	return "保存游戏","保存中，请稍等"
end
simpleWaiterDlg["Loading world"] = function()
	return "载入世界","载入中，请稍等"
end
simpleWaiterDlg["Loading entity"] = function()
	return "载入物品","载入中，请稍等"
end
simpleWaiterDlg["Loading zone"] = function()
	return "载入地城","载入中，请稍等"
end
simpleWaiterDlg["Loading level"] = function()
	return "载入楼层","载入中，请稍等"
end
simpleWaiterDlg["Loading game"] = function()
	return "载入游戏","载入中，请稍等"
end
simpleWaiterDlg["Saving..."] = function()
	return "保存中...","保存中，请稍等"
end
simpleWaiterDlg["Generating level"] = function()
	return "生成楼层","生成中，请稍等"
end
simpleWaiterDlg["Login in..."] = function()
	return "登陆中...","登陆中，请稍等"
end
simpleWaiterDlg["Login..."] = function()
	return "登陆中...","登陆中，请稍等"
end
simpleWaiterDlg["Registering..."] = function()
	return "注册中...","注册中，请稍等"
end
simpleWaiterDlg["Registering character"] = function()
	return "正在注册角色","正在在 http://te4.org/ 上注册角色。"
end
simpleWaiterDlg["Retrieving data from the server"] = function()
	return "正在从服务器取回数据","请稍等…"
end
simpleWaiterDlg["Requesting..."] = function()
	return "正在请求…","正在请求用户数据，请稍等…"
end
simpleWaiterDlg["Chronomancy"] = function(str)
	if str == "Folding the space time structure..." then
		str = "正在折叠时空的结构…"
	elseif str == "Unfolding the space time structure..." then
		str = "正在展开时空的结构…"
	end
	return "时空法术",str
end
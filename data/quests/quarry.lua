questCHN["Hunter, Quarry"] = {
	name = "石匠与猎人",
	description = function(desc)
		
		desc = desc:gsub("The Steam Quarry is a strategic zone for the Atmos tribe, it provides them with much of their energy needs.","蒸汽采石场是气之部族的重要战略设施，为他们供应能量。")
		desc = desc:gsub("If you are to assault the Palace of Fumes you need to cut that supply off. Destroy the three giant steam valves to make the Palace vulnerable.","如果你想要进攻烟雾宫殿你必须切断他们的供应。摧毁三个巨大的蒸汽阀来破坏宫殿的防御。")
		desc = desc:gsub("The first valve has been destroyed.","第一个蒸汽阀已被摧毁。")
		desc = desc:gsub("The second valve has been destroyed.","第二个蒸汽阀已被摧毁。")
		desc = desc:gsub("The third valve has been destroyed.","第三个蒸汽阀已被摧毁。")

		return desc
	end}

projectileCHN = {}
projectileCHN["Dust Storm"] = "尘土风暴"
projectileCHN["Blazing Fire"] = "燃烧之炎"
projectileCHN["Sphere of Destruction"] = "毁灭之球"
projectileCHN["Tornado"] = "龙卷风"
projectileCHN["bouncing slime"] = "弹跳的史莱姆球"
projectileCHN["Hammer Toss"] = "回旋投掷"
projectileCHN["huge boulder"] = "巨石"
projectileCHN["Judgement"] = "裁决"
projectileCHN["Polarity Bolt"] = "极性之箭"
projectileCHN["Temporal Bolt"] = "时空之箭"
projectileCHN["firestorm"] = "火焰风暴"

function projectileCHN:getName(s)
	return projectileCHN[s] or s
end
function getTooltipProjectileCHN(desc)
	if not desc then return end
	for i = 1,#desc do
		if type(desc[i]) == "string" then
			if projectileCHN[desc[i]] then
				desc[i] = projectileCHN[desc[i]]
			else
				desc[i] = npcCHN:getName(desc[i])
				if string.find(desc[i], "Projectile: ") then 
					desc[i] = desc[i]:gsub("Projectile: ","抛射物： ")
				elseif string.find(desc[i], "Origin: ") then 
					desc[i] = desc[i]:gsub("Origin: ","发射者： ")
				elseif string.find(desc[i], "Speed: ") then 
					desc[i] = desc[i]:gsub("Speed: ","飞行速度： "):gsub("southeast","东南"):gsub("southwest","西南"):gsub("northeast","东北"):gsub("northwest","西北")
													 :gsub("south","南"):gsub("east","东"):gsub("west","西"):gsub("north","北")		
				elseif string.find(desc[i], "Affect origin chance: ") then 
					desc[i] = desc[i]:gsub("Affect origin chance: ","伤害发射者的概率： ")
				elseif string.find(desc[i], "Affect origin's friends chance: ") then 
					desc[i] = desc[i]:gsub("Affect origin's friends chance: ","伤害发射者友军的概率： ")
				end
			end
		end
	end

	return desc
end



local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}
local metalschn = {"铁质", "钢铁", "矮人钢", "蓝锆石", "沃瑞坦"}
local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}
local simplechn = {"粗糙", "良好", "精制", "大师", "完美"}
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." focus lens",
	chName = simplechn[i].." 聚焦镜片",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." toxic cannister launcher",
	chName = metalschn[i].." 毒弹发射器",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." viral needlegun",
	chName = metalschn[i].." 病毒枪",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." razor edge",
	chName = metalschn[i].." 尖锐刀片",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." armour reinforcement",
	chName = metalschn[i].." 护甲强化",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." crystal edge",
	chName = metalschn[i].." 尖锐水晶",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

-- Note, this makes stat swapping very easy.  Probably for the best as its less annoying than Heroism.
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." crystal plating",
	chName = metalschn[i].." 水晶板甲片",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." spike attachment",
	chName = metalschn[i].." 附着尖刺",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." silver filigree",
	chName = metalschn[i].." 银质花边",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." back support",
	chName = metalschn[i].." 背部支撑",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." grounding strap",
	chName = metalschn[i].." 接地导线",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}
local metalschn = {"铁质", "钢铁", "矮人钢", "蓝锆石", "沃瑞坦"}
local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}
local simplechn = {"粗糙", "良好", "精制", "大师", "完美"}
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." focus lens",
	chName = simplechn[i].." focus lens",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." toxic cannister launcher",
	chName = metalschn[i].." toxic cannister launcher",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." viral needlegun",
	chName = metalschn[i].." viral needlegun",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." razor edge",
	chName = metalschn[i].." razor edge",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." armour reinforcement",
	chName = metalschn[i].." armour reinforcement",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." crystal edge",
	chName = metalschn[i].." crystal edge",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

-- Note, this makes stat swapping very easy.  Probably for the best as its less annoying than Heroism.
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." crystal plating",
	chName = metalschn[i].." crystal plating",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." spike attachment",
	chName = metalschn[i].." spike attachment",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." silver filigree",
	chName = metalschn[i].." silver filigree",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." back support",
	chName = metalschn[i].." back support",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." grounding strap",
	chName = metalschn[i].." grounding strap",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

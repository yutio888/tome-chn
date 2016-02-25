local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}
local simplechn = {"粗糙", "良好", "精制", "大师", "完美"}
local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}
local metalschn = {"铁质", "钢铁", "矮人钢", "蓝锆石", "沃瑞坦"}
-- On crit, no proc limit
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." lightning coil",
	chName = simplechn[i].." lightning coil",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." mana coil",
	chName = simplechn[i].." mana coil",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." shocking touch",
	chName = metalschn[i].." shocking touch",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." deflection field",
	chName = metalschn[i].." deflection field",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." galvanic retributor",
	chName = metalschn[i].." galvanic retributor",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." gauss accelerator",
	chName = metalschn[i].." gauss accelerator",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." voltaic sentry",
	chName = metalschn[i].." voltaic sentry",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." mental stimulator",
	chName = metalschn[i].." mental stimulator",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." power distributor",
	chName = metalschn[i].." power distributor",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." white light emitter",
	chName = metalschn[i].." white light emitter",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

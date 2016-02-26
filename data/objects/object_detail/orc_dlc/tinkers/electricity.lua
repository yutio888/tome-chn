local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}
local simplechn = {"粗糙", "良好", "精制", "大师", "完美"}
local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}
local metalschn = {"铁质", "钢铁", "矮人钢", "蓝锆石", "沃瑞坦"}
-- On crit, no proc limit
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." lightning coil",
	chName = simplechn[i].." 闪电线圈",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = simple[i].." mana coil",
	chName = simplechn[i].." 魔力线圈",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." shocking touch",
	chName = metalschn[i].." 电击之触装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." deflection field",
	chName = metalschn[i].." 折射力场仪",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." galvanic retributor",
	chName = metalschn[i].." 电力反击装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." shocking edge",
	chName = metalschn[i].." 电击之刃",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end
for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." voltaic sentry",
	chName = metalschn[i].." 伏特守卫装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." mental stimulator",
	chName = metalschn[i].." 精神刺激装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." power distributor",
	chName = metalschn[i].." 能量分配装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

for i = 1, 5 do
objects:addObjects({
	subtype = "steamtech",
	enName = metals[i].." white light emitter",
	chName = metalschn[i].." 白光发射装置",
	chDesc = "插件能装在常规装备上，用蒸汽能量强化它们!",
})
end

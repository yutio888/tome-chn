local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SWALLOW",
	name = "吞噬",
	info = function(self, t)
		return ([[对目标造成 %d%% 自然武器伤害。 
		 如果这个攻击将目标的生命值降低到其最大生命值的一定比例以下（基于技能等级和两者体型大小）或杀死了它，你会吞噬它，立刻将其杀死，并根据其等级恢复生命值和失衡值。
		 对方会与你的物理强度进行豁免对抗，以防被吞噬。
		同时，这个技能还能被动提升你的物理和精神暴击率 %d%% 。
		每点土龙系的天赋可以使你增加物理抵抗 0.5%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。

		基于你目前的体型，吞噬的生命值上限如下所示：
		微小:  %d%%
		矮小:  %d%%
		中等:  %d%%
		高大:  %d%%
		庞大:  %d%%
		巨型:  %d%%]]):
		format(100 * t.getDamage(self, t), t.getPassiveCrit(self, t),
			t.maxSwallow(self, t, 1),
			t.maxSwallow(self, t, 2),
			t.maxSwallow(self, t, 3),
			t.maxSwallow(self, t, 4),
			t.maxSwallow(self, t, 5),
			t.maxSwallow(self, t, 6))
	end,
}

registerTalentTranslation{
	id = "T_QUAKE",
	name = "地震",
	message = "@Source@ 震动大地!",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你猛踩大地，在 %d 码范围内造成地震。 
		 在地震范围内的怪物会受到 %d%% 武器伤害并被击退 3 码。 
		 在地震范围内的地形也会受到影响。 
		 每点土龙系的天赋可以使你增加物理抵抗 0.5%% 。]]):format(radius, dam*100)
	end,
}

registerTalentTranslation{
	id = "T_BURROW",
	name = "土遁",
	info = function(self, t)
		return ([[允许你钻进墙里，持续 %d 回合。
		 你强大的挖掘能力让你能挖掘敌人的防御弱点；处于该状态下时你获得 %d 护甲穿透和 %d%% 物理抗性穿透。
         在技能等级 5 时，这个技能变成瞬发。冷却时间随技能等级升高而降低。
		 每点土龙系的天赋可以使你增加物理抵抗 0.5%% 。]]):format(t.getDuration(self, t), t.getPenetration(self, t), t.getPenetration(self, t) / 2)
	end,
}

registerTalentTranslation{
	id = "T_SAND_BREATH",
	name = "沙瀑吐息",
	message = "@Source@ 呼出沙尘!",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你在前方 %d 码锥形范围内喷出流沙。此范围内的目标会受到 %0.2f 物理伤害并被致盲 %d 回合。 
		 受力量影响，伤害有额外加成。技能暴击率基于精神暴击值计算，致盲几率基于你的精神强度。
		 每点土龙系的天赋可以使你增加物理抵抗 0.5%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}


return _M

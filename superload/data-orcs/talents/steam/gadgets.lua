local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_AUTOLOADER",
	name = "自动填弹器",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local ammo = t.getReload(self,t)
		local dam = t.getDamage(self,t)
		local perc = t.getPercentInc(self,t)*100
		return ([[你将武器连接到蒸汽机，使用它们来为你的武器填充弹药，并强化武器的能力。
		每当你使用蒸汽枪射击的时候，有 %d%% 的几率填充一枚重装武器的弹药。
		每当你使用重装武器射击的时候，会填充 %d 枚弹药。
		这一技能也会在你使用蒸汽枪或重装武器的时候提升武器伤害 %d%% ，提升物理强度 30 。]]):
		format(chance, ammo, perc)
	end,
}

registerTalentTranslation{
	id = "T_EXOSKELETON",
	name = "机械外骨骼",
	info = function(self, t)
		return ([[当前机械外骨骼生命值： %d / %d
		你制造一台蒸汽驱动的机械外骨骼，可以装载在你平常的护甲外面，增强你的防御能力。机械外骨骼具有 %d 生命值，你受到的所有伤害的 50%% 会转移到它身上。
		你的机械外骨骼每回合会修复 5%% 的最大生命值，每当你消耗蒸汽的时候，他也会修复相当于蒸汽值消耗 %d%% 的生命值。
		外骨骼的最大生命值受蒸汽强度加成。]]):format((self.exoskeleton_absorb or 0),t.getMaxDamage(self,t),t.getMaxDamage(self,t), t.getSteamHeal(self,t))
	end,
}

registerTalentTranslation{
	id = "T_HYPERVISION_GOGGLES",
	name = "强化视觉护目镜",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local rad = self:getTalentRadius(t)
		local power = t.getPower(self,t)
		local detect = t.getDetection(self,t)
		return ([[强化你的视觉，持续 %d 回合。你将能看到半径 %d 码范围内的所有目标，该效果可以穿墙。当护目镜激活的时候，你也能注意到敌人防御上的弱点，增加你的抗性穿透 %d%% 。
此外，护目镜会被动地增加你 %d 潜行、隐形和陷阱侦测能力。]]):format(dur, rad, power, detect)
	end,
}

registerTalentTranslation{
	id = "T_AED",
	name = "电击除颤器",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local life = t.getLife(self,t)
		local dam = t.getDamage(self,t)
		return ([[准备好一个防御性的设备，其电力可以持续 5 回合。
当你的生命值降到 0 点以下的时候，电击除颤器会启动，把你救活，取消这一致死的攻击，恢复 %d 点生命值，并在半径 %d 码范围内造成 %0.2f 闪电伤害，震慑目标 3 回合。
如果电击除颤器没有启动，其冷却时间会减少 15 回合。
生命值恢复量和伤害受蒸汽强度加成。]]):format(life, rad, damDesc(self, DamageType.LIGHTNING, dam))
	end,
}

return _M
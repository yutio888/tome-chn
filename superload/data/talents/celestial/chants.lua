local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHANT_OF_FORTITUDE",
	name = "坚韧赞歌",
	info = function(self, t)
		local saves = t.getResists(self, t)
		local life = t.getLifePct(self, t)
		return ([[颂赞日之荣耀，使你获得 %d 精神豁免，并增加 %0.1f%% 最大生命值（当前加成： %d ）。
		同时只能激活一种赞歌。
		效果受法术强度加成。
		]]):
		format(saves, life*100, life*self.max_life)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_FORTRESS",
	name = "防御赞歌",
	info = function (self,t)
		local physicalresistance = t.getPhysicalResistance(self, t)
		local saves = t.getResists(self, t)
		return ([[颂赞日之荣耀，使你获得 %d 物理抗性， %d 物理豁免， %d 护甲与 15%% 护甲硬度。
		同时只能激活一种赞歌。
		效果受法术强度加成。]]):
		format(physicalresistance, saves, physicalresistance)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_RESISTANCE",
	name = "元素赞歌",
	info = function(self, t)
		local resists = t.getResists(self, t)
		local saves = t.getSpellResists(self, t)
		local range = -t.getDamageChange(self, t)
		return ([[颂赞日之荣耀，使你获得 %d 火焰、闪电、酸性和寒冷抗性， %d 法术豁免，并减少三格外敌人对你造成的伤害 %d%% 。
		同时只能激活一种赞歌。
		效果受法术强度加成。]]):
		format(resists, saves, range)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_LIGHT",
	name = "光明赞歌",
	info = function(self, t)
		local damageinc = t.getLightDamageIncrease(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local lite = t.getLite(self, t)
		return ([[颂赞日之荣耀，使你获得光系与火系充能，造成 %d%% 点额外伤害。 
		此外它提供你光之护盾，对任何攻击你的目标造成 %0.1f 光系伤害。 
		你的光照范围同时增加 %d 码。 
		同时只能激活 1 个圣歌，另外此赞歌消耗能量较少。 
		效果受法术强度加成。]]):
		format(damageinc, damDesc(self, DamageType.LIGHT, damage), lite)
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ACOLYTE",
	name = "赞歌入门",
	info = function (self,t)
		local ret = ""
		local old1 = self.talents[self.T_CHANT_OF_FORTITUDE]
		local old2 = self.talents[self.T_CHANT_OF_FORTRESS]
		local old3 = self.talents[self.T_CHANT_OF_RESISTANCE]
		self.talents[self.T_CHANT_OF_FORTITUDE] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_FORTRESS] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_RESISTANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_CHANT_OF_FORTITUDE)
			local t2 = self:getTalentFromId(self.T_CHANT_OF_FORTRESS)
			local t3 = self:getTalentFromId(self.T_CHANT_OF_RESISTANCE)
			ret = ([[你学会了三种防御赞歌，以此咏唱对太阳的赞颂：
		坚韧赞歌：增加 %d 精神豁免， %d%% 最大生命值 
		堡垒赞歌：增加 %d 物理豁免， %d 物理抗性， %d 护甲， 15%% 护甲硬度 
		元素赞歌：增加 %d 法术豁免， %d%% 火焰 /寒冷 /闪电 /酸性抗性，减少三格外敌人对你造成的伤害 %d%% 。
		你同时只能激活一种赞歌。]]):
			format(t1.getResists(self, t1), t1.getLifePct(self, t1)*100, t2.getResists(self, t2), t2.getPhysicalResistance(self, t2), t2.getPhysicalResistance(self, t2), t3.getSpellResists(self, t3), t3.getResists(self, t3), t3.getDamageChange(self, t3))
		end)
		self.talents[self.T_CHANT_OF_FORTITUDE] = old1
		self.talents[self.T_CHANT_OF_FORTRESS] = old2
		self.talents[self.T_CHANT_OF_RESISTANCE] = old3
		return ret
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ILLUMINATE",
	name = "初现光芒",
	info = function (self,t)
		return ([[咏唱赞歌让你沐浴在光明中，你的体力与法力每回合回复 %0.2f , 并对所有近战攻击你的敌人造成 %0.2f 光属性伤害。
		效果受法术强度加成。]]):format(t.getBonusRegen(self, t), damDesc(self, DamageType.LIGHT, t.getDamageOnMeleeHit(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ADEPT",
	name = "赞歌专家",
	info = function (self,t)
		return ([[咏唱赞歌的娴熟技艺让光明得以扩散，增加 %d 光照半径。
		每次你咏唱新的赞歌时，你将解除自身所有 CT 效果，并解除 %d 项相应类型的负面状态。
		坚韧赞歌：解除精神负面状态 
		堡垒赞歌：解除物理负面状态 
		元素赞歌：解除魔法负面状态 ]]):format(t.getBonusLight(self, t), t.getDebuffCures(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CHANT_RADIANT",
	name = "辉耀绽放",
	info = function (self,t)
		return ([[咏唱赞歌歌颂太阳的热情达到了顶峰。
		你的赞歌现在让你的火焰与光系伤害增加 %d%% 。当你被武器攻击击中的时候，你恢复 %0.1f 点正能量。该效果最多每回合触发 %d 次。
		效果受法术强度加成。]]):format(t.getLightDamageIncrease(self, t), t.getPos(self, t), t.getTurnLimit(self, t))
	end,
}
return _M

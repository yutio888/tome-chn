local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HYMN_OF_SHADOWS",
	name = "暗影圣诗",
	info = function (self,t)
		return ([[赞颂月之荣耀，使你获得暗影之灵敏。
		 移动速度增加 %d%% ，施法速度增加 %d%%
		 同时只能激活一种圣诗。
		 效果受法术强度加成。]]):
		 format(t.moveSpeed(self, t), t.castSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_DETECTION",
	name = "侦查圣诗",
	info = function(self, t)
		local invis = t.getSeeInvisible(self, t)
		local stealth = t.getSeeStealth(self, t)
		return ([[赞美月之荣耀，使你能察觉潜行单位（ +%d 侦测等级）和隐形单位（ +%d 侦测等级）。 
		 你攻击不可见目标时无惩  罚，同时暴击造成 %d%% 额外伤害。 
		 同时只能激活 1 个圣诗。 
		 受法术强度影响，侦测等级和伤害有额外加成。]]):
		format(stealth, invis, t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_PERSEVERANCE",
	name = "坚毅圣诗",
	info = function(self, t)
		local immunities = t.getImmunities(self, t)
		return ([[赞美月之荣耀，增加你 %d%% 震慑、致盲和混乱抵抗。 
		 同时只能激活 1 个圣诗。 ]]):
		format(100 * (immunities))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_MOONLIGHT",
	name = "月光圣诗",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local drain = t.getNegativeDrain(self, t)
		return ([[赞美月之荣耀，在技能激活时，在你身边产生一片跟随你的影之舞。 
		 每回合随机向附近 5 码半径范围内的 %d 个敌人发射暗影射线，造成 1 到 %0.2f 伤害。 
		 这个强大法术的每道射线会消耗 %0.1f 负能量，如果能量值过低则不会发射射线。 
		 受法术强度影响，伤害有额外加成。]]):
		format(targetcount, damDesc(self, DamageType.DARKNESS, damage), drain)
	end,
}
registerTalentTranslation{
	id = "T_HYMN_ACOLYTE",
	name = "圣诗入门",
	info = function (self,t)
		local ret = ""
		local old1 = self.talents[self.T_HYMN_OF_SHADOWS]
		local old2 = self.talents[self.T_HYMN_OF_DETECTION]
		local old3 = self.talents[self.T_HYMN_OF_PERSEVERANCE]
		self.talents[self.T_HYMN_OF_SHADOWS] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_DETECTION] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_HYMN_OF_SHADOWS)
			local t2 = self:getTalentFromId(self.T_HYMN_OF_DETECTION)
			local t3 = self:getTalentFromId(self.T_HYMN_OF_PERSEVERANCE)
			ret = ([[你学会了三种防御圣诗，以此咏唱对月亮的赞颂：
		 暗影圣诗：增加 %d%% 移动速度和 %d%%  施法速度。
		 侦察圣诗：增加 %d 潜行侦察， %d 隐身侦察， %d%% 暴击伤害 
		 坚毅圣诗：增加 %d%% 震慑、混乱、致盲抗性。
		 你同时只能激活一种赞歌。]]):
		 	format(t1.moveSpeed(self, t1), t1.castSpeed(self, t1), t2.getSeeStealth(self, t2), t2.getSeeInvisible(self, t2), t2.critPower(self, t2), t3.getImmunities(self, t3)*100)
		end)
		self.talents[self.T_HYMN_OF_SHADOWS] = old1
		self.talents[self.T_HYMN_OF_DETECTION] = old2
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = old3
		return ret
	end,
}
registerTalentTranslation{
	id = "T_HYMN_INCANTOR",
	name = "暗影临近",
	info = function (self,t)
		return ([[圣诗让暗影集中在你身边，你的黑暗伤害增加  %d%% ，并对所有近战攻击你的敌人造成 %0.2f 暗属性伤害。
		效果受法术强度加成。]]):format(t.getDarkDamageIncrease(self, t), damDesc(self, DamageType.DARKNESS, t.getDamageOnMeleeHit(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_HYMN_ADEPT",
	name = "圣诗专家",
	info = function (self,t)
		return ([[咏唱圣诗的娴熟技艺让黑暗不再阻碍你的视线，增加 %d 暗视半径。
		 每次你结束旧的圣诗时，你将获得圣诗提供的增益效果。
		 暗影圣诗：增加 %d%% 移动速度，持续 1 回合。 
		 侦察圣诗：隐身 ( %d 强度) 持续 %d 回合。 
		 坚毅圣诗：护盾 ( %d 强度) 持续 %d 回合。]]):format(t.getBonusInfravision(self, t), t.getSpeed(self, t), 
		 t.invisPower(self, t), t.invisDur(self, t), t.shieldPower(self, t), t.shieldDur(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
}
registerTalentTranslation{
	id = "T_HYMN_NOCTURNALIST",
	name = "暗夜流光",
	info = function (self,t)
		return ([[咏唱圣诗歌颂月亮的热情达到了顶峰。
		你的圣诗自动产生阴影射线攻击周围 5 格内至多 %d 个敌人，造成 1 到  %0.2f 伤害，同时有 20%% 几率触发  致盲效果。
		这项效果每产生一发射线并击中至少一个目标将抽取 %0.1f 负能量，能量过低时无法产生射线。
		效果受法术强度加成。]]):format(t.getTargetCount(self, t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNegativeDrain(self, t))
	end,
}
local _M = loadPrevious(...)

registerInscriptionTranslation = function(t)
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.id = "T_"..t.name:upper():gsub("[ ]", "_").."_"..i
		tt.name = tt.display_name or tt.name
		tt.extra_data = {["old_info"] = tt.info}
		tt.info = function(self, t)
			local ret = t.extra_data.old_info(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\n受你的 %s 影响，此效果按比例加成。 "):format(s_stat_name[self.stats_def[data.use_stat].name] or self.stats_def[data.use_stat].name)
			end
			return ret
		end
		registerTalentTranslation(tt)
	end
end
function change_infusion_eff(str)
	str = str:gsub("mental"," 精神 "):gsub("magical"," 魔法 "):gsub("physical"," 物理 ")
	return str
end

-----------------------------------------------------------------------
-- Infusions
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Infusion: Regeneration",
	display_name = "纹身：回复",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活纹身治疗你自己 %d 生命值，持续 %d 回合。 ]]):format(data.heal + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治疗 %d; 冷却 %d]]):format(data.heal + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Healing",
	display_name = "纹身：治疗",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活纹身立即治疗你 %d 生命值，然后去除一个流血或毒素效果。]]):format(data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治疗 %d; 冷却 %d]]):format(data.heal + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Wild",
	display_name = "纹身：狂暴",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concatNice(table.keys(data.what), ", ", " 或者 ")
		return ([[激活纹身解除你 %s 效果并减少所有伤害 %d%% 持续 %d 回合。 
同时除去对应类型的 CT 效果。		]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[减伤 %d%%; 解除 %s; 持续 %d; 冷却 %d]]):format(data.power + data.inc_stat, what:gsub("physical"," 物理 "):gsub("magical"," 魔法 "):gsub("mental"," 精神 ").." 效果 ", data.dur, data.cooldown)
	end,
}

-- fixedart wild variant
registerInscriptionTranslation{
	name = "Infusion: Primal",
	display_name = "纹身：原初",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个纹身，你受到的伤害将部分转化为治疗（在伤害减免之前计算），转化比例为 %d%% 。此外，每回合减少一个随机负面效果的持续时间 %d 回合，持续 %d 回合 ]]):
			format(data.power+data.inc_stat*10, (data.reduce or 0) + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[伤害吸收 %d%%; 减少 %d; 持续 %d; 冷却 %d]]):format(data.power + data.inc_stat*10, (data.reduce or 0) + data.inc_stat, data.dur, data.cooldown )
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Movement",
	display_name = "纹身：移动",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个纹身可以在 1 个游戏回合内提升移动速度 %d%% 。
		同时免疫眩晕、震慑和定身效果。
		除移动以外其他动作会取消这个效果。 
		 注意：由于你的速度非常快，游戏回合会相对很慢。 ]]):format(data.speed + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d%% 加速 ; %d 冷却 ]]):format(data.speed + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Heroism",
	display_name = "纹身：英勇",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local bonus = 1 + (1 - self.life / self.max_life)
		local bonus1 = data.die_at + data.inc_stat * 30 * bonus
		local bonus2 = math.floor(data.dur * bonus)
		return ([[激活这个纹身可以让你忍受致死的伤害，持续%d回合。
		当应用纹身激活时，你的生命值只有在降低到 -%d 生命时才会死亡。
		你每失去 1%% 生命值，持续时间和生命值下限就会增加 1%% 。（目前 %d 生命值， %d 持续时间）
		效果结束时，如果你的生命值在 0 以下，会变为 1 点。 ]]):format(data.dur, data.die_at + data.inc_stat * 30, bonus1, bonus2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[-%d 死亡底线; 持续 %d; 冷却 %d]]):format(data.die_at + data.inc_stat * 30, data.dur, data.cooldown)
	end,
}

-- Opportunity cost for this is HUGE, it should not hit friendly, also buffed duration
registerInscriptionTranslation{
	name = "Infusion: Wild Growth",
	display_name = "纹身：野性生长",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local damage = t.getDamage(self, t)
		return ([[从土地中召唤坚硬的藤蔓，缠绕 %d 码范围内所有生物，持续 %d 回合。将其定身并造成每回合 %0.2f 物理和 %0.2f 自然伤害。 
		 藤蔓也会生长在你的身边，增加 %d 护甲和 %d%% 护甲硬度。]]):
		format(self:getTalentRadius(t), data.dur, damDesc(self, DamageType.PHYSICAL, damage)/3, damDesc(self, DamageType.NATURE, 2*damage)/3, data.armor or 50, data.hard or 30)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范围 %d 持续 %d]]):format(self:getTalentRadius(t), data.dur)
	end,
}

-----------------------------------------------------------------------
-- Runes
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Rune: Teleportation",
	display_name = "符文：传送",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文随机传送 %d 码范围内位置，至少传送 15 码以外。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范围 %d; 冷却 %d]]):format(data.range + data.inc_stat, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Shielding",
	display_name = "符文：护盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文产生一个防护护盾，吸收最多 %d 伤害持续 %d 回合。 ]]):format((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸收 %d; 持续 %d; 冷却 %d ]]):format((data.power + data.inc_stat) * (100 + (self:attr("shield_factor") or 0)) / 100, data.dur, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Reflection Shield",
	display_name = "符文：反射盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
		return ([[激活这个符文产生一个防御护盾，吸收并反弹最多 %d 伤害值，持续 %d 回合。效果与魔法成比例增长。 ]])
		:format(power, 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end

		return ([[吸收并反弹 %d 持续 %d ; 冷却 %d]]):format(power, data.dur or 5, data.cd)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Biting Gale",
	display_name = "符文：冰风",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文，形成一股锥形寒风，造成 %0.2f 寒冷伤害。
			寒风会浸湿敌人，减半敌人的  震慑抗性  ，并试图冻结他们 %d 回合。
			效果可以被抵抗，但不能被豁免]]):
			format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[伤害 %d; 持续 %d; 冷却 %d]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), data.dur, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Acid Wave",
	display_name = "符文：酸性冲击波",
	info = function(self, t)
		  local data = self:getInscriptionData(t.short_name)		  
		  return ([[发射锥形酸性冲击波造成 %0.2f 酸性伤害。
		 酸性冲击波会缴械目标 %d 回合。
		 效果可以被抵抗，但不能被豁免 ]]):
		 format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local pow = data.power
		return ([[伤害 %d; 持续 %d; 冷却 %d]]):format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Manasurge",
	display_name = "符文：魔力",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文对你自己释放法力回复，增加 %d%% 回复量持续 %d 回合，并立即回复 %d 法力值。 
			同时，在你休息时增加每回合 0.5 的魔力回复。 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ 回复 %d%% 持续 %d 回合 ; %d 法力瞬回; 冷却 %d]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20, data.cooldown)
	end,
}
-- This is mostly a copy of Time Skip :P
registerInscriptionTranslation{
	name = "Rune of the Rift",
	display_name = "符文：时空裂缝",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造成 %0.2f 时空伤害。如果你的目标存活，则它会被传送 %d 回合至未来。 
		 它也能降低你 60 紊乱值 ( 如果你拥有该能量 )。 
		 注意，若与其他时空效果相混合则可能产生无法预料的后果。 ]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
	short_info = function(self, t)
		return ("%0.2f 时空伤害，从时间中移除 %d 回合 "):format(t.getDamage(self, t), t.getDuration(self, t))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Blink",
	display_name = "符文：闪烁",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[激活符文，传送到视野内 %d 格内的指定位置。之后，你会脱离相位 %d 回合。在这种状态下，所有新的负面效果的持续时间减少 %d%%，你的闪避增加 %d ，你的全体伤害抗性增加 %d%%。]]):
			format(data.range + data.inc_stat, t.getDur(self, t), power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = data.power + data.inc_stat * 3
		return ([[范围 %d; 相位 %d; 冷却 %d]]):format(self:getTalentRange(t), power, data.cooldown )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Ethereal",
	display_name = "符文：虚幻",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[启动符文，使你变得虚幻，持续  %d  回合。
		 在虚幻状态下，你造成的伤害减少 %d%%，你获得 %d%% 全体伤害抗性，你的移动速度提升 %d%% ，你获得隐形 (强度  %d)。]]):
			format(t.getDur(self, t),t.getReduction(self, t) * 100, t.getResistance(self, t), t.getMove(self, t), t.getPower(self, t))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[强度 %d; 抗性 %d%%; 移动 %d%%; 持续 %d; 冷却 %d]]):format(t.getPower(self, t), t.getResistance(self, t), t.getMove(self, t), t.getDur(self, t), data.cooldown)
	end,
}
registerInscriptionTranslation{
	name = "Rune: Stormshield",
	display_name = "符文：风暴护盾",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[启动这个符文，在你的身边召唤一团保护性的风暴，持续 %d 回合。
			 当符文生效时，风暴可以抵挡大于 %d 的任何伤害最多 %d 次。]])
				:format(t.getDur(self, t), t.getThreshold(self, t), t.getBlocks(self, t) )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[阈值 %d; 次数 %d; 持续 %d; 冷却 %d]]):format(t.getThreshold(self, t), t.getBlocks(self, t), t.getDur(self, t), data.cooldown  )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Prismatic",
	display_name = "符文：棱彩",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = ""
		for k,v in pairs(data.wards) do
			str = str .. ", " .. v .. " " .. k:lower():gsub("fire","火焰"):gsub("cold","寒冷"):gsub("lightning","闪电"):gsub("blight","枯萎"):gsub("light","光系"):gsub("arcane","暗影"):gsub("physical","物理"):gsub("temporal","时空"):gsub("mind","精神"):gsub("nature","自然"):gsub("acid","酸性")
		end
		str = string.sub(str, 2)
		return ([[激活符文展开一个护盾，在 %d 回合内，抵挡以下类型的伤害 : %s]]) -- color me
				:format(t.getDur(self, t), str)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local str = table.concat(table.keys(data.wards), ", ")
		return ([[%d 回合; %s]]):format(t.getDur(self, t), str:lower():gsub("fire","火焰"):gsub("cold","寒冷"):gsub("lightning","闪电"):gsub("blight","枯萎"):gsub("light","光系"):gsub("arcane","暗影"):gsub("physical","物理"):gsub("temporal","时空"):gsub("mind","精神"):gsub("nature","自然"):gsub("acid","酸性") )
	end,
}

registerInscriptionTranslation{
	name = "Rune: Mirror Image",
	display_name = "符文：镜像",
	info = function(self, t)
		return ([[激活符文，最多召唤你的 3 个镜像，镜像会嘲讽周围的敌人。
			 在半径 10 范围内每有一个敌人才能召唤一个镜像，第一个镜像会被召唤在最近的敌人旁边。
			 镜像继承你的生命值、抗性、护甲、闪避和护甲硬度。]])
				:format(t.getInheritance(self, t)*100 )
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[持续 %d; 冷却 %d]]):format(t.getDur(self, t), data.cooldown)
	end
}
registerInscriptionTranslation{
	name = "Rune: Shatter Afflictions",
	display_name = "符文: 粉碎痛苦",
	info = function(self, t)
		return ([[激活符文，立刻清除你身上的负面效果。
			 清除所有 CT 效果，以及物理、精神和魔法负面效果各 1 个。
			 每清除一个负面效果，你都会获得一个抵挡 %d 伤害的护盾，持续 3 回合。]]):format(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸收 %d; 冷却 %d]]):format(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100, data.cooldown)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Dissipation",
	display_name = "符文: 耗散",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文，从敌人身上移除 4 个正面魔法持续效果，或从自己身上移除所有魔法负面效果。]]):
		format()
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ ]]):format()
	end,
}

-----------------------------------------------------------------------
-- Taints
-----------------------------------------------------------------------
registerInscriptionTranslation{
	name = "Taint: Devourer",
	display_name = "堕落印记：吞噬",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[对目标激活此印记，移除其 %d 个效果并将其转化为治疗你每个效果 %d 生命值。 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 效果 / %d 治疗 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Taint: Purging",
	display_name = "堕落印记: 清除",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个堕落印记，清除你身上的物理效果，持续 %d 回合。
		 每一回合，这个印记将会尝试从你的身上解除一个物理负面效果。
		 如果它解除了一个负面效果，它的持续时间会增加 1 回合。]])
				:format(t.getDur(self, t) )
	end,
	short_info = function(self, t)
		return ([[%d 回合]]):format(t.getDur(self, t) )
	end,
}

-----------------------------------------------------------------------
-- Legacy:  These inscriptions aren't on the drop tables and are only kept for legacy compatibility and occasionally NPC use
-----------------------------------------------------------------------

registerInscriptionTranslation{
	name = "Infusion: Sun",
	display_name = "纹身：阳光",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[激活这个纹身照亮 %d 区域和潜行单位，可能使潜行目标显形（降低 %d 潜行强度）。 %s
		 同时区域内目标也有几率被致盲（ %d 等级），持续 %d 回合。 ]]):
		format(data.range, apply/2, apply >= 19 and "\n 这光线是如此强烈，以至于能驱散魔法造成的黑暗 " or "", apply, data.turns)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[范围 %d; 强度 %d; 持续 %d%s]]):format(data.range, apply, data.turns, data.power >= 19 and "; 驱散黑暗 " or "")
	end,
}

registerInscriptionTranslation{
	name = "Taint: Telepathy",
	display_name = "堕落印记：感应",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[解除你的精神束缚 %d 回合，感应 %d 码范围内的所有生物，减少 %d 精神豁免持续 10 回合并增加 %d 点精神强度。 ]]):format(data.dur, self:getTalentRange(t), 10, 35)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范围 %d 码心灵感应持续 %d 回合 ]]):format(self:getTalentRange(t), data.dur)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Frozen Spear",
	display_name = "符文：冰矛",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文发射一束冰枪，造成 %0.2f 冰冻伤害并有一定几率冻结你的目标。 
               	 寒冰同时会解除你受到的一个负面精神状态。 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 寒冰伤害 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Heat Beam",
	display_name = "符文：热能射线",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文发射一束射线，造成 %0.2f 火焰伤害持续 5 回合。 
		 高温同时会解除你受到的一个负面物理状态。 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 火焰伤害 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Rune: Speed",
	display_name = "符文：速度",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文提高整体速度 %d%% 持续 %d 回合。 ]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ 提速 %d%% 持续 %d 回合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}


registerInscriptionTranslation{
	name = "Rune: Vision",
	display_name = "符文：洞察",
	type = {"inscriptions/runes", 1},
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人形怪 "
                kind=kind:gsub("demon"," 恶魔 "):gsub("animal"," 动物 "):gsub("undead"," 不死族 "):gsub("dragon"," 龙 "):gsub("horror"," 恐魔 "):gsub("humanoid","人形怪")
		return ([[激活这个符文可以使你查看周围环境（ %d 有效范围）使你你查看隐形生物（ %d 侦测隐形等级）持续 %d 回合。 
		 你的精神更加敏锐，能感知到周围的 %s  ，持续 %d 回合。 ]]):
		format(data.range, data.power + data.inc_stat, data.dur, kind, data.dur)

	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人形 "
                kind=kind:gsub("demon"," 恶魔 "):gsub("animal"," 动物 "):gsub("undead"," 不死 "):gsub("dragon"," 龙 "):gsub("horror"," 恐魔 "):gsub("humanoid","人形怪")
		return ([[范围 %d; 持续 %d; 感知 %s]]):format(data.range, data.dur, kind)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Phase Door",
	display_name = "符文：相位门",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[激活这个符文会使你在 %d 码范围内随机传送。 
		 之后，你会出入现实空间 % d 回合，所有新的负面状态持续时间减少 %d%% ，闪避增加 %d ，全体伤害抗性增加 %d%%。 ]]):
		format(data.range + data.inc_stat, data.dur or 3, power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[范围 %d; 强度 %d; 持续 %d]]):format(data.range + data.inc_stat, power, data.dur or 3)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Controlled Phase Door",
	display_name = "符文：可控相位门",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文，传送至 %d 码内的指定位置。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范围 %d]]):format(data.range + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Lightning",
	display_name = "符文：闪电",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat)
		return ([[激活这个符文发射一束闪电打击目标，造成 %0.2f 至 %0.2f 闪电伤害。 
		 同时会让你进入闪电形态 %d 回合：受到伤害时你会瞬移到附近的一  格并防止此伤害，一回合只能触发一次。 ]]):
		format(dam / 3, dam, 2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 闪电伤害 ]]):format(damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat))
	end,
}

registerInscriptionTranslation{
	name = "Infusion: Insidious Poison",
	display_name = "纹身：下毒",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个纹身会发射一个毒气弹造成每回合 %0.2f 自然伤害持续 7 回合，并降低目标治疗效果 %d%% 。
		 突然涌动的自然力量会除去你受到的一个负面魔法效果。 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 自然伤害， %d%% 治疗下降 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
}

registerInscriptionTranslation{
	name = "Rune: Invisibility",
	display_name = "符文：隐身",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激活这个符文使你变得隐形（ %d 隐形等级）持续 %d 回合。 
		 由于你的隐形使你从现实相位中脱离，你的所有伤害降低 40%%。 
		]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[强度 %d 持续 %d 回合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}

return _M

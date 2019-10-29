local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_METATEMPORAL_SPINNER",
	name = "相位旋转",
	info = function(self, t)
		return ([[你把奥术和时空能量注入一把蒸汽链锯，让他在你的手中飞速旋转。（无视装备需求）
		这把链锯旋转的速度是那么快，它扰乱了你周围的时空。最多增加你 %d 的法术强度， %d 的法术暴击率，和 %0.1f 的法力值恢复（基于蒸汽链锯的材质等级）
		任何对你的近战攻击都会触发一次必定命中的自动的蒸汽链锯反击，造成 %d%% 超自然（奥术和时空）武器伤害。
		这把蒸汽链锯使用意志提供伤害加成，但你不能使用它来格挡。
		增加蒸汽链锯的武器伤害 %d%%。
		如果你激活了以太之体，所有科技法术：超自然系的技能都可以在以太之体状况下使用，并且它们所造成的伤害会被转换成纯净的以太伤害。

		#{italic}#当你第一次学会这一技能的时候，如果你还没有掌握蒸汽链锯的配方，你还会同时学会这一配方。#{normal}#
		]]):format(t.getSpellpower(self, t, 5), t.getSpellCrit(self, t, 5), t.getRegen(self, t, 5), t.getRetaliationDamage(self, t) * 100, t.getPercentInc(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_REALITY_BREACH",
	name = "现实割裂",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local slow = t.getSlow(self, t)
		local proj = t.getProj(self, t)
		return ([[让你的链锯以难以置信的速度飞速旋转，撕裂周围的现实，在你面前产生一条宽度为 3 的射线。
		所有被射线击中的生物将会受到 %0.2f 超自然伤害，并且进入脱离现实的状态。它们的整体速度降低 %d%% ，发射的一切抛射物也会被减速 %d%% ，持续 4 回合。
		技能等级 3 时，射线范围内的所有抛射物也会被立刻摧毁。
		技能等级 5 时，这一射线的力量是如此强大，所有被击中的生物都会被击退 3 码。
		这一切裂是如此强大，射线必定会达到可能的最大射程才会停止。
		伤害受法术强度加成。]]):format(damDesc(self, DamageType.ARCANE, damage) + damDesc(self, DamageType.TEMPORAL, damage), 100 * slow, proj)
	end,
}

registerTalentTranslation{
	id  = "T_ETHEREAL_STEAM",
	name = "虚幻蒸汽",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local radius = self:getTalentRadius(t)
		return ([[你通过以太，接触视野内所有被现实割裂和时间凝固技能减速的生物。
		对于每一个目标，你会和它之间建立一条注入奥术能量的蒸汽组成的连接，持续 %d 回合。
		每当目标使用一个技能，你的一个法术的冷却时间都会减少 1 回合。
		在每一个回合，被连接的生物以及所有连接线上的生物，都会受到 %0.2f 超自然伤害。
		伤害受法术强度加成。]]):format(t.getDur(self, t), damDesc(self, DamageType.ARCANE, damage) + damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_METAPHASIC_PULSE",
	name = "相位脉动",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		return ([[在你的蒸汽连接中释放出纯净的以太能量，对每一个目标施放一次小型的现实割裂。
		所有被击中的目标会受到 %0.2f 超自然伤害，并且已有的蒸汽连接的持续时间会增加 %d 回合。（每次施放最多影响一个生物）
		技能等级 5 时，这一以太冲击是如此强大，目标身上的任何临时增益效果的持续时间都会被缩短 %d 回合。]])
		:format(damDesc(self, DamageType.ARCANE, damage) + damDesc(self, DamageType.TEMPORAL, damage), t.getDur(self, t), t.getReduce(self, t))
	end,
}

return _M
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SEARING_LIGHT",
	name = "灼热之矛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		return ([[你 祈 祷 太 阳 之 力 形 成 1 个 灼 热 的 长 矛 造 成 %d 点 伤 害 并 在 地 上 留 下 一 个 光 斑， 每 回 合 对 其 中 的 目 标 造 成 %d 光 系 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), damDesc(self, DamageType.LIGHT, damageonspot))
	end,
}

registerTalentTranslation{
	id = "T_SUN_FLARE",
	name = "日珥闪耀",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getRes(self, t)
		local resdur = t.getResDuration(self, t)
		return ([[祈 祷 太 阳 之 力， 在 %d 码 半 径 范 围 内 致 盲 目 标， 持 续 %d 回 合 并 照 亮 你 的 周 围 区 域。
		所有受影响的敌人将会受到%0.2f光系伤害。
		在等级3是，你将获得%d%%的光系、暗影和火焰伤害抗性，持续%d回合。
		受法术强度影响，伤害和抗性有额外加成。]]):
		format(radius, duration, damDesc(self, DamageType.LIGHT, damage), res, resdur )

   end,
}

registerTalentTranslation{
	id = "T_FIREBEAM",
	name = "阳炎喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[汲 取 太 阳 之 力 向 目 标 射 出 一 束 太 阳 真 火，射向最远的敌人，对这条 直 线上的所有 敌 人 造 成 %0.2f 火 焰 伤 害。 
		这一技能将会每隔一个回合自动额外触发一次，共额外触发2次。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNBURST",
	name = "日炎爆发",
	info = function(self, t)
		return ([[射出一团猛烈的日光，你的光系伤害加成将会增加你暗影伤害加成的 %d%% ，持续 %d 回合，并对半径 %d 内最多 %d 个敌人造成 %0.2f 点光系伤害。]]):
			format(t.getPower(self, t)*100, t.getDuration(self, t), self:getTalentRadius(t), t.getTargetCount(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

return _M

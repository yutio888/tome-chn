local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEALTH",
	name = "潜行",
	info = function(self, t)
		local stealthpower = t.getStealthPower(self, t) + (self:attr("inc_stealth") or 0)
		local radius, rad_dark = t.getRadius(self, t, true)
		xs = rad_dark ~= radius and (" (在黑暗地格范围为 %d )"):format(rad_dark) or ""
		return ([[进入潜行模式（潜行点数 %d ，基于灵巧），让你更难被侦测到。
		如果成功（每回合都重新检查），敌人将不会知道你在哪里，或者根本不会注意到你。
		潜行将光照半径减小至 0，增加3点夜视能力，并且不能在装备重甲或板甲时使用。
		如果敌人在半径 %d %s 内，你不能进入潜行。
		除非特别说明，任何非瞬间非移动技能均会打破潜行。

		即使不知道你位置的敌人，仍然会猜测你可能在的位置。
		在潜行时，敌人无法分享有关你位置的信息，并且会一直相信你还在那里。]]):
		format(stealthpower, radius, xs)
	end,
}

registerTalentTranslation{
	id = "T_SHADOWSTRIKE",
	name = "影袭",
	info = function(self, t)
		local multiplier = t.getMultiplier(self, t)*100
		local dur = t.getDuration(self, t)
		return ([[你充分发挥潜行优势。
		潜行状态下攻击时，如果直到命中前你的目标都没有发现你，你的攻击将自动暴击。（即使目标注意到你，你的法术和精神攻击也会暴击。）
		对于看不见你的目标，暴击伤害增加 %d%% 。（你必须能够看到你的目标，并且伤害奖励随距离降低：3 格内保持满额，到 10 格时降低为 0 ）、
		此外，由于任何原因脱离潜行后，暴击伤害奖励会持续存在 %d 回合（不受范围限制）。]]):format(multiplier, dur)
	end,
}

registerTalentTranslation{
	id = "T_SOOTHING_DARKNESS",
	name = "黑暗亲和",
	info = function(self, t)
		return ([[你对黑暗和阴影有特殊的亲和力。
		站在黑暗地格中，激活潜行的最小范围限制降低 %d 。
		当潜行时，你增加 %0.1f 的生命回复速度（基于灵巧），同时你也增加 %0.1f 的体力回复速度。该回复效果在退出潜行后仍能保持 %d 回合，并且生命回复速度是正常的五倍。]]):
		format(t.getRadius(self, t, true), t.getLife(self,t), t.getStamina(self,t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_DANCE",
	name = "暗影之舞",
	info = function (self,t)
		return ([[你对潜行的精通让你能够随时从视野中消失。
		你自动进入潜行模式，在 %d 回合内，你的行动不会使你主动显形。]]):
		format(t.getDuration(self, t))
	end,
}




return _M

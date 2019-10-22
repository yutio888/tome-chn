local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIRTY_FIGHTING",
	name = "卑劣攻击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self,t)
		return ([[你攻击目标的敏感部位，造成 %d%% 徒手伤害。如果攻击命中，目标身受重创，物理豁免减少 %d ，震慑、致盲、混乱、定身免疫降低为原来的 50%% ，持续 %d 回合。
该效果无视豁免。]]):
		format(100 * damage, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_BACKSTAB",
	name = "背刺",
	info = function(self, t)
		local dam = t.getDamageBoost(self, t)
		local chance = t.getDisableChance(self,t)
		return ([[你机智地利用敌人的伤残，每项伤残效果增加 %d%%伤害，最多 %d%%。
伤残效果包括：震慑、致盲、眩晕、定身、缴械、致残和沉默。
此外，每项伤残效果使你的近战攻击有 %d%%几率（最多叠加至 %d%%）附加额外效果（不会重复）：缴械、致残（25%%强度）或者定身 2 回合。
附加效果成功率受命中加成。]]):
		format(dam, dam*3, chance, chance*3)
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_POWDER",
	name = "致盲粉",
	info = function (self,t)
		local accuracy = t.getAcc(self,t)
		local speed = t.getSlow(self,t)
		local duration = t.getDuration(self, t)
		return ([[撒出致盲粉，致盲前方 %d 格锥形范围内的敌人。受影响的敌人命中减少  %d  ，移动速度减少  %d%%  ，持续  %d  回合。
		效果成功率受命中加成。]]):format(self:getTalentRadius(t), accuracy, speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TWIST_THE_KNIFE",
	name = "扭曲刀刃",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local dur = t.getDuration(self, t)
		local nb = t.getDebuffs(self, t)
		return ([[攻击敌人造成  %d%%  武器伤害，并延长对方身上至多  %d  项负面效果持续时间  %d  回合。每延长一项负面效果，相应减少一项正面效果持续时间。]]):
		format(100 * damage, nb, dur)
	end,
}



return _M

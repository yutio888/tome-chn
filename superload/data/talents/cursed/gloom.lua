local _M = loadPrevious(...)

local function gloomTalentsMindpower(self)
	return self:combatScale(self:getTalentLevel(self.T_GLOOM) + self:getTalentLevel(self.T_WEAKNESS) + self:getTalentLevel(self.T_DISMAY) + self:getTalentLevel(self.T_SANCTUARY), 1, 1, 20, 20, 0.75)
end

registerTalentTranslation{
	id = "T_GLOOM",
	name = "黑暗光环",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[一个 3 码 半 径 范 围 的 可 怕 黑 暗 光 环 围 绕 你 , 影 响 附 近 的 敌 人。 在每个回合结束时，光 环 内 的 每 一 个 目 标必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 减 速30%%、 震 慑或 混 乱(30%%)， 持 续 %d 回 合。 
		几率受精神速度影响。
		这个能力是与生俱来的，激活或停止不消耗任何能量。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计：%d）。]]):format(chance, duration, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_WEAKNESS",
	name = "黑暗衰竭",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local incDamageChange = t.getIncDamageChange(self, t)
		local hateBonus = t.getHateBonus(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在 黑 暗 光 环 里 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 恐 惧 而 虚 弱 持 续 %d 回 合， 降 低 %d%% 伤 害， 你 对 被 削 弱 目 标 的 首 次 近 战 攻 击 能 获 得 %d 点 仇 恨 值。 
		几率受精神速度影响。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计：%d）。]]):format(chance, duration, -incDamageChange, hateBonus, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_MINDROT",
	name = "思维腐蚀",
	info = function(self, t)
		return ([[每个回合，所有在你黑暗光环内的敌人都会受到%0.2f精神伤害和%0.2f暗影伤害。
		伤害受精神强度和精神速度影响。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计：%d）。]]):format(damDesc(self, DamageType.MIND, t.getDamage(self, t) * 0.5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) * 0.5), gloomTalentsMindpower(self))
	end,
}

registerTalentTranslation{
	id = "T_SANCTUARY",
	name = "庇护光环",
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[你 的 黑 暗 光 环 成 为 独 立 于 外 界 的 避 难 所， 任 何 光 环 外 的 目 标 对 你 的 伤 害 降 低 %d%% 。 
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计：%d）。]]):format(-damageChange, mindpowerChange)
	end,
}



return _M

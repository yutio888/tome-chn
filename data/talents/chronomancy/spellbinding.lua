local Talents = require "engine.interface.ActorTalents"
Talents.talents_def.T_EMPOWER.name = "能量增幅"
Talents.talents_def.T_EMPOWER.info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强 化 指 定 的 时 空 系 法 术 ，施 放 指 定 技 能 时 法 术 强 度 增 加  %d%%  。
		 每 个 技 能 只 能 附 加 一 种 时 空 增 效 系 效 果 。		 
		 当 前 强 化 法 术 ： %s ]]):
		format(power, talent)
	end

Talents.talents_def.T_EXTENSION.name = "法术延展"
Talents.talents_def.T_EXTENSION.info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强 化 指 定 的 时 空 系 法 术 ，延 展 指 定 法 术 的 持 续 时 间  %d%%  。
		 每 个 技 能 只 能 附 加 一 种 时 空 增 效 系 效 果 。				 
		 当 前 强 化 法 术 ： %s ]]):
		format(power, talent)
	end

Talents.talents_def.T_MATRIX.name = "矩阵加速"
Talents.talents_def.T_MATRIX.info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强 化 指 定 的 时 空 系 法 术 ， 减 少 指 定 法 术 的 冷 却 时 间 %d%% 。
		每 个 技 能 只 能 附 加 一 种 时 空 增 效 系 效 果。	
		当 前 强 化 法 术： %s]]):
		format(power, talent)
	end

Talents.talents_def.T_QUICKEN.name = "迅捷施法"
Talents.talents_def.T_QUICKEN.info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强 化 指 定 的 时 空 系 法 术 ，减 少 指 定 法 术 的 施 放 速 度  %d%% 。
		 每 个 技 能 只 能 附 加 一 种 时 空 增 效 系 效 。
		 
		 当 前 强 化 法 术 ： %s  ]]):
		format(power, talent)
	end

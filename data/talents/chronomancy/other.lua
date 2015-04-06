local Talents = require "engine.interface.ActorTalents"
local getParadoxModifier = function (self)
	local paradox = self:getParadox()
	local pm = util.bound(math.sqrt(paradox / 300), 0.5, 1.5)
	return pm
end
local getParadoxSpellpower = function(self, t, mod, add)
	local pm = getParadoxModifier(self)
	local mod = mod or 1

	-- Empower?
	local p = self:isTalentActive(self.T_EMPOWER)
	if p and p.talent == t.id then
		pm = pm + self:callTalent(self.T_EMPOWER, "getPower")
	end

	local spellpower = self:combatSpellpower(mod * pm, add)
	return spellpower
end
Talents.talents_def.T_SPACETIME_TUNING.name = "时空协调"
Talents.talents_def.T_SPACETIME_TUNING.info = function(self, t)
		local tune = t.getTuning(self, t)
		local preference = self.preferred_paradox
		local sp_modifier = getParadoxModifier(self, t) * 100
		local spellpower = getParadoxSpellpower(self, t)
		local after_will, will_modifier, sustain_modifier = self:getModifiedParadox()
		local anomaly = self:paradoxFailChance()
		return ([[设 置 自 己 的 紊 乱 值。
		休 息 或 等 待 时 ， 你 每 回 合 将 自 动 调 节 %d 点 紊 乱 值 趋 向 于 你 的 设 定 值。
		你 的 紊 乱 值 会 修 正 所 有 时 空 法 术 的 持 续 时 间 和 法 术 强度。
		设 定 的 紊 乱 值:  %d
		紊 乱 值 修 正 率:  %d%%
		时 空 法 术 强 度:  %d
		意 志 修 正 数 值: -%d
		紊 乱 维 持 数 值: +%d
		修 正 后 紊 乱 值:  %d
		当 前 异 常 几 率:  %d%%]]):format(tune, preference, sp_modifier, spellpower, will_modifier, sustain_modifier, after_will, anomaly)
	end
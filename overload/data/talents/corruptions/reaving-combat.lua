-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newTalent{
	name = "Corrupted Strength",
	type = {"corruption/reaving-combat", 1},
	mode = "passive",
	points = 5,
	vim = 8,
	require = str_corrs_req1,
	-- called by _M:getOffHandMult function in mod\class\interface\Combat.lua
	getoffmult = function(self,t) return self:combatTalentLimit(t, 1, 0.53, 0.69) end, -- limit <100%
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then
			self:attr("allow_any_dual_weapons", 1)
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:attr("allow_any_dual_weapons", -1)
		end
	end,
	info = function(self, t)
		return ([[允 许 你 双 持 单 手 武 器 并 使 副 手 武 器 伤 害 增 加 至 %d%% 。 
		 同 时 每 释 放 1 个 法 术（ 消 耗 1 回 合） 会 给 予 近 战 范 围 内 的 1 个 随 机 目 标 一 次 附 加 攻 击， 造 成 %d%% 枯 萎 伤 害。]]):
		format(100*t.getoffmult(self,t), 100 * self:combatTalentWeaponDamage(t, 0.5, 1.1))
	end,
}

newTalent{
	name = "Bloodlust",
	type = {"corruption/reaving-combat", 2},
	mode = "passive",
	require = str_corrs_req2,
	points = 5,
	-- _M:combatSpellpower references effect in mod\class\interface\Combat.lua
	-- Effect is refreshed in function _M:onTakeHit(value, src) in mod\class\Actor.lua
	-- getParams called in definition of EFF_BLOODLUST in data\timed_effects\magical.lua
	getParams = function(self, t) -- returns maxSP per turn, max duration
		return self:combatTalentScale(t, 1, 5, 0.75), math.floor(self:combatTalentScale(t, 2, 6))
	end,
	info = function(self, t)
		local SPbonus, maxDur = t.getParams(self, t)
		return ([[当 你 对 敌 人 造 成 伤 害 时， 你 进 入 嗜 血 状 态， 每 伤 害 1 个 目 标 增 加 1 点 法 术 强 度，并 延 长 现 有 状 态 1 回 合。  
		 此 技 能 每 回 合 最 多 使 你 增 加 共 计 +%d 点 法 术 强 度，且 总 计 最 多 增 加 +%d 点 法 术 强 度。
		 嗜 血 状 态 持 续 %d 回 合， 每 经 过 一 个 未 造 成 伤 害 的 回 合， 法 术 强 度 加 成 下 降 %0.1f%% 。]]):
		format(SPbonus, SPbonus*6, maxDur, 100/maxDur)
	end,
}

newTalent{
	name = "Carrier",
	type = {"corruption/reaving-combat", 3},
	mode = "passive",
	require = str_corrs_req3,
	points = 5,
	getDiseaseImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.20, 0.75) end, -- Limit < 100%
	-- called by _M:attackTargetWith in mod.class.interface.Combat.lua
	getDiseaseSpread = function(self, t) return self:combatTalentLimit(t, 100, 5, 20) end, --Limit < 100%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "disease_immune", t.getDiseaseImmune(self, t))
	end,
	info = function(self, t)
		return ([[你 增 加 %d%% 疾 病 抵 抗 并 有 %d%% 概 率 在 近 战 时 散 播 你 目 标 身 上 现 有 的 疾 病。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getDiseaseSpread(self, t))
	end,
}

newTalent{
	name = "Acid Blood",
	type = {"corruption/reaving-combat", 4},
	mode = "passive",
	require = str_corrs_req4,
	points = 5,
	do_splash = function(self, t, target)
		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 5, 30))
		local atk = self:combatTalentSpellDamage(t, 15, 35)
		local armor = self:combatTalentSpellDamage(t, 15, 40)
		if self:getTalentLevel(t) >= 3 then
			target:setEffect(target.EFF_ACID_SPLASH, 5, {src=self, dam=dam, atk=atk, armor=armor})
		else
			target:setEffect(target.EFF_ACID_SPLASH, 5, {src=self, dam=dam, atk=atk})
		end
	end,
	info = function(self, t)
		return ([[你 的 血 液 变 成 酸 性 混 合 物。 当 你 受 伤 害 时， 攻 击 者 会 受 到 酸 性 溅 射。 
		 每 回 合 溅 射 会 造 成 %0.2f 酸 性 伤 害， 持 续 5 回 合。 
		 同 时 减 少 攻 击 者 %d 点 命 中。 
		 在 等 级 3 时， 酸 性 溅 射 会 减 少 目 标 %d 点 护 甲 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 5, 30)), self:combatTalentSpellDamage(t, 15, 35), self:combatTalentSpellDamage(t, 15, 40))
	end,
}

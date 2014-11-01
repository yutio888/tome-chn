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
	name = "Arcane Combat",
	type = {"technique/magical-combat", 1},
	mode = "sustained",
	points = 5,
	require = techs_req1,
	sustain_stamina = 20,
	no_energy = true,
	cooldown = 5,
	tactical = { BUFF = 2 },
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (1 + self:getCun(9, true)), 100, 20, 0, 70, 50) end, -- Limit < 100%
	do_trigger = function(self, t, target)
		if self.x == target.x and self.y == target.y then return nil end

		local chance = t.getChance(self, t)
		if self:hasShield() then chance = chance * 0.75
		elseif self:hasDualWeapon() then chance = chance * 0.5
		end

		if rng.percent(chance) then
			local spells = {}
			local fatigue = (100 + 2 * self:combatFatigue()) / 100
			local mana = self:getMana() - 1
			if self:knowTalent(self.T_FLAME) and not self:isTalentCoolingDown(self.T_FLAME)and mana > self:getTalentFromId(self.T_FLAME).mana * fatigue then spells[#spells+1] = self.T_FLAME end
			if self:knowTalent(self.T_LIGHTNING) and not self:isTalentCoolingDown(self.T_LIGHTNING)and mana > self:getTalentFromId(self.T_LIGHTNING).mana * fatigue then spells[#spells+1] = self.T_LIGHTNING end
			if self:knowTalent(self.T_EARTHEN_MISSILES) and not self:isTalentCoolingDown(self.T_EARTHEN_MISSILES)and mana > self:getTalentFromId(self.T_EARTHEN_MISSILES).mana * fatigue then spells[#spells+1] = self.T_EARTHEN_MISSILES end
			local tid = rng.table(spells)
			if tid then
				local l = self:lineFOV(target.x, target.y)
				l:set_corner_block()
				local lx, ly, is_corner_blocked = l:step(true)
				local target_x, target_y = lx, ly
				-- Check for terrain and friendly actors
				while lx and ly and not is_corner_blocked and core.fov.distance(self.x, self.y, lx, ly) <= 10 do
					local actor = game.level.map(lx, ly, engine.Map.ACTOR)
					if actor and (self:reactionToward(actor) >= 0) then
						break
					elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
						target_x, target_y = lx, ly
						break
					end
					target_x, target_y = lx, ly
					lx, ly = l:step(true)
				end
				print("[ARCANE COMBAT] autocast ",self:getTalentFromId(tid).name)
				local old_cd = self:isTalentCoolingDown(self:getTalentFromId(tid))
				self:forceUseTalent(tid, {ignore_energy=true, force_target={x=target_x, y=target_y, __no_self=true}})
				-- Do not setup a cooldown
				if not old_cd then
					self.talents_cd[tid] = nil
				end
				self.changed = true
			end
		end
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[允 许 你 使 用 近 战 武 器 附 魔 法 术。 在 你 每 次 的 近 战 攻 击 中 都 有 %d%% 概 率 附 加 一 次 火 球 术、 闪 电 术 或 岩 石 飞 弹 。 
		当 双 持 或 持 有 盾 牌 时， 此 效 果 对 每 一 个 武 器 均 可 触 发， 但 触 发 概 率 减 少。 
		通 过 这 种 方 式 触 发 的 法 术 不 会 造 成 对 应 技 能 进 入 CD 状 态， 但 是 只 有 在 对 应 技 能 未 冷 却 时 才 可 以 触 发。 
		受 灵 巧 影 响， 触 发 概 率 有 额 外 加 成。 ]]):
		format(t.getChance(self, t))
	end,
}

newTalent{
	name = "Arcane Cunning",
	type = {"technique/magical-combat", 2},
	mode = "passive",
	points = 5,
	require = techs_req2,
	-- called by _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	info = function(self, t)
		return ([[你 额 外 增 加 相 当 于 你 %d%% 灵 巧 值 的 法 术 强 度。]]):
		format(t.getSpellpower(self,t))
	end,
}

newTalent{
	name = "Arcane Feed",
	type = {"technique/magical-combat", 3},
	mode = "sustained",
	points = 5,
	cooldown = 5,
	sustain_stamina = 20,
	require = techs_req3,
	range = 10,
	tactical = { BUFF = 2 },
	getManaRegen = function(self, t) return self:combatTalentScale(t, 1/7, 5/7, 0.75) end,
	getCritChance = function(self, t) return self:combatTalentScale(t, 2.5, 11, 0.75) end,
	activate = function(self, t)
		local power = t.getManaRegen(self, t)
		local crit = t.getCritChance(self, t)
		return {
			regen = self:addTemporaryValue("mana_regen", power),
			pc = self:addTemporaryValue("combat_physcrit", crit),
			sc = self:addTemporaryValue("combat_spellcrit", crit),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.regen)
		self:removeTemporaryValue("combat_physcrit", p.pc)
		self:removeTemporaryValue("combat_spellcrit", p.sc)
		return true
	end,
	info = function(self, t)
		return ([[当 技 能 激 活 时， 每 回 合 恢 复 %0.2f 法 力 值 并 提 高 %d%% 物 理 及 法 术 爆 击 几 率。]]):format(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

newTalent{
	name = "Arcane Destruction",
	type = {"technique/magical-combat", 4},
	mode = "passive",
	points = 5,
	require = techs_req4,
	-- called by _M:combatPhysicalpower in mod.class.interface.Combat.lua
	getSPMult = function(self, t) return self:combatTalentScale(t, 1/7, 5/7) end,
	info = function(self, t)
		return ([[通 过 你 的 武 器 来 传 送 原 始 的 魔 法 伤 害。 增 加 %d 点 物 理 强 度。 
		每 当 你 近 战 攻 击 暴 击 时， 你 会 释 放 一 个 半 径 为 2 码 的 火 属 性、 电 属 性 或 奥 术 属 性 的 魔 法 球， 造 成 %0.2f 的 伤 害。 
		受 法 术 强 度 影 响， 增 益 按 比 例 加 成。]]):
		format(self:combatSpellpower() * t.getSPMult(self, t), self:combatSpellpower() * 2)
	end,
}


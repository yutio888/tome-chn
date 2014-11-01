-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

-- Edge TODO: Sounds, Particles, Talent Icons; Trance of Focus; Deep Trance

local function cancelTrances(self)
	local trances = {self.T_TRANCE_OF_CLARITY, self.T_TRANCE_OF_PURITY, self.T_TRANCE_OF_FOCUS}
	for i, t in ipairs(trances) do
		if self:isTalentActive(t) then
			self:forceUseTalent(t, {ignore_energy=true})
		end
	end
end

newTalent{
	name = "Trance of Purity",
	type = {"psionic/trance", 1},
	points = 5,
	require = psi_wil_req1,
	cooldown = 12,
	tactical = { BUFF = 2 },
	mode = "sustained",
	sustain_psi = 20,
	getSavingThrows = function(self, t) return self:combatTalentMindDamage(t, 5, 50) end,
	getPurgeChance = function(self, t) return 50 - math.min(30, self:combatTalentMindDamage(t, 0, 30)) end,
	activate = function(self, t)
		local effs = {}
		local chance = 100
		
		-- go through all timed effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type ~= "other" and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end
		
		-- Check chance to remove effects and purge them if possible
		while chance > 0 and #effs > 0 do
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" and rng.percent(chance) then
				self:removeEffect(eff[2])
				chance = chance - t.getPurgeChance(self, t)
			end
		end
	
		-- activate sustain
		cancelTrances(self)
		local power = t.getSavingThrows(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			phys = self:addTemporaryValue("combat_physresist", power),
			spell = self:addTemporaryValue("combat_spellresist", power),
			mental = self:addTemporaryValue("combat_mentalresist", power),
		--	particle = self:addParticles(Particles.new("golden_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
	--	self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_physresist", p.phys)
		self:removeTemporaryValue("combat_spellresist", p.spell)
		self:removeTemporaryValue("combat_mentalresist", p.mental)
		return true
	end,
	info = function(self, t)
		local purge = t.getPurgeChance(self, t)
		local saves = t.getSavingThrows(self, t)
		return ([[激 活 以 清 除 负 面 状 态（ 100％ 清 除 第 一 状 态， -%d%% 几 率 清 除 后 续 状 态）。 当 此 技 能 激 活 时， 你 的 所 有 豁 免 值 增 加 %d 。 
		 受 精 神 强 度 影 响， 净 化 几 率 和 豁 免 增 益 按 比 例 加 成。 
		 同 一 时 间 只 有 一 种 迷 幻 系 技 能 可 以 激 活。]]):format(purge, saves)
	end,
}

newTalent{
	short_name = "TRANCE_OF_WELL_BEING",
	name = "Trance of Well-Being",
	type = {"psionic/trance", 2},
	points = 5,
	require = psi_wil_req2,
	cooldown = 12,
	tactical = { BUFF = 2 },
	mode = "sustained",
	sustain_psi = 20,
	getHeal = function(self, t) return self:combatTalentMindDamage(t, 20, 340) end,
	getHealingModifier = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getLifeRegen = function(self, t) return self:combatTalentMindDamage(t, 10, 50) / 10 end,
	activate = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:mindCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
	
		cancelTrances(self)	
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			heal_mod = self:addTemporaryValue("healing_factor", t.getHealingModifier(self, t)/100),
			regen = self:addTemporaryValue("life_regen", t.getLifeRegen(self, t)),
		}

		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
			ret.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			ret.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
		
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle1)
		self:removeParticles(p.particle2)
		self:removeTemporaryValue("healing_factor", p.heal_mod)
		self:removeTemporaryValue("life_regen", p.regen)
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local healing_modifier = t.getHealingModifier(self, t)
		local regen = t.getLifeRegen(self, t)
		return ([[激 活 以 治 疗 你 %0.2f 生 命 值。 当 此 技 能 激 活 时， 你 的 治 疗 量 会 增 加 %d%% ， 同 时 你 的 生 命 回 复 会 提 高 %0.2f 点。 
		 受 精 神 强 度 影 响， 增 益 按 比 例 加 成。 
		 同 一 时 间 只 有 一 种 迷 幻 系 技 能 可 以 激 活。]]):format(heal, healing_modifier, regen)
	end,
}

newTalent{
	name = "Trance of Focus",
	type = {"psionic/trance", 3},
	points = 5,
	require = psi_wil_req3,
	cooldown = 12,
	tactical = { BUFF = 2 },
	mode = "sustained",
	sustain_psi = 20,
	getCriticalPower = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getCriticalChance = function(self, t) return self:combatTalentMindDamage(t, 4, 12) end,
	activate = function(self, t)
		self:setEffect(self.EFF_TRANCE_OF_FOCUS, 10, {t.getCriticalPower(self, t)})
		
		cancelTrances(self)	
		local power = t.getCriticalChance(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			phys = self:addTemporaryValue("combat_physcrit", power),
			spell = self:addTemporaryValue("combat_spellcrit", power),
			mental = self:addTemporaryValue("combat_mindcrit", power),
		}
		
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physcrit", p.phys)
		self:removeTemporaryValue("combat_spellcrit", p.spell)
		self:removeTemporaryValue("combat_mindcrit", p.mental)
		return true
	end,
	info = function(self, t)
		local power = t.getCriticalPower(self, t)
		local chance = t.getCriticalChance(self, t)
		return ([[激 活 以 增 加 你 %d%% 暴 击 伤 害， 持 续 10 回 合。 当 此 技 能 激 活 时， 你 的 暴 击 率 会 增 加 +%d%% 。 
		 受 精 神 强 度 影 响， 增 益 按 比 例 加 成。 
		 同 一 时 间 只 有 一 种 迷 幻 系 技 能 可 以 激 活。]]):format(power, chance)
	end,
}

newTalent{
	name = "Deep Trance",
	type = {"psionic/trance", 4},
	points = 5,
	require = psi_wil_req4,
	mode = "passive",
	info = function(self, t)
		return ([[当 你 穿 戴 由 超 能 力、 自 然 或 反 魔 力 量 灌 注 的 装 备 时， 你 增 加 %d%% " 当 使 用 或 装 备 时 :" 的 增 益 属 性。 
		 注 意 此 技 能 不 会 改 变 装 备 属 性， 它 的 效 果 只 作 用 于 你 自 身。（ 此 技 能 的 增 益 也 不 会 在 装 备 描 述 上 反 映 出 来）。]]):format(1)
	end,
}
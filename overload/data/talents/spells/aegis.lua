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
	name = "Arcane Reconstruction", short_name = "HEAL",
	type = {"spell/aegis", 1},
	require = spells_req1,
	points = 5,
	mana = 25,
	cooldown = 16,
	use_only_arcane = 2,
	tactical = { HEAL = 2 },
	getHeal = function(self, t) return 40 + self:combatTalentSpellDamage(t, 10, 520) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:spellCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 你 的 身 体 充 满 奥 术 能 量， 将 其 重 组 为 原 始 状 态， 治 疗 %d 点 生 命 值。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

newTalent{
	name = "Shielding",
	type = {"spell/aegis", 2},
	require = spells_req2,
	points = 5,
	mode = "sustained",
	sustain_mana = 40,
	use_only_arcane = 2,
	cooldown = 14,
	tactical = { BUFF = 2 },
	getDur = function(self, t) return self:getTalentLevel(t) >= 5 and 1 or 0 end,
	getShield = function(self, t) return 20 + self:combatTalentSpellDamage(t, 5, 400) / 10 end,
	activate = function(self, t)
		local dur = t.getDur(self, t)
		local shield = t.getShield(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {
			shield = self:addTemporaryValue("shield_factor", shield),
			dur = self:addTemporaryValue("shield_dur", dur),
		}
		self:checkEncumbrance()
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("shield_factor", p.shield)
		self:removeTemporaryValue("shield_dur", p.dur)
		return true
	end,
	info = function(self, t)
		local shield = t.getShield(self, t)
		local dur = t.getDur(self, t)
		return ([[使 你 的 周 身 围 绕 着 强 烈 的 奥 术 能 量。 
		 你 的 每 个 伤 害 护 盾、 时 间 护 盾、 转 移 护 盾、 干 扰 护 盾 的 强 度 上 升 %d%% 。 
		 在 等 级 5 时， 它 会 增 加 1 回 合 所 有 护 盾 的 持 续 时 间。 
		 受 法 术 强 度 影 响， 护 盾 强 度 有 额 外 加 成。]]):
		format(shield, dur)
	end,
}

newTalent{
	name = "Arcane Shield",
	type = {"spell/aegis", 3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	use_only_arcane = 2,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getShield = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 5, 500), 100, 20, 0, 55.4, 354) end,	 -- Limit < 100%
	activate = function(self, t)
		local shield = t.getShield(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {
			shield = self:addTemporaryValue("arcane_shield", shield),
		}
		self:checkEncumbrance()
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("arcane_shield", p.shield)
		return true
	end,
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[使 你 的 周 身 围 绕 着 保 护 性 的 奥 术 能 量。 
		 每 当 你 获 得 一 个 直 接 治 疗 时（ 非 持 续 恢 复 效 果） 你 会 自 动 获 得 一 个 护 盾， 护 盾 强 度 为 治 疗 量 的 %d%% ， 持 续 3 回 合。 
		 受 法 术 强 度 影 响， 护 盾 强 度 有 额 外 加 成。]]):
		format(shield)
	end,
}

newTalent{
	name = "Aegis",
	type = {"spell/aegis", 4},
	require = spells_req4,
	points = 5,
	mana = 50,
	cooldown = 25,
	use_only_arcane = 2,
	no_energy = true,
	tactical = { HEAL = 2 },
	getShield = function(self, t) return 40 + self:combatTalentSpellDamage(t, 5, 500) / 10 end,
	getNumEffects = function(self, t) return math.max(1,math.floor(self:combatTalentScale(t, 3, 7, "log"))) end,
	on_pre_use = function(self, t)
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.on_aegis then return true end
		end
		if self:isTalentActive(self.T_DISRUPTION_SHIELD) then return true end
	end,
	action = function(self, t)
		local target = self
		local shield = t.getShield(self, t)
		local effs = {}

		-- Go through all spell effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.on_aegis then
				effs[#effs+1] = {id=eff_id, e=e, p=p}
			end
		end

		for i = 1, t.getNumEffects(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)
			eff.e.on_aegis(self, eff.p, shield)
		end

		if self:isTalentActive(self.T_DISRUPTION_SHIELD) then
			self:setEffect(self.EFF_MANA_OVERFLOW, math.ceil(self:combatTalentScale(t, 3, 7)), {power=shield})
		end

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[释 放 奥 术 能 量 充 满 当 前 保 护 你 的 魔 法 护 盾， 进 一 步 强 化 它， 提 高 %d%% 最 大 伤 害 吸 收 值。 
		 它 会 影 响 最 多 %d 种 护 盾 效 果。 
		 可 被 充 能 的 护 盾 有： 伤 害 护 盾， 时 间 护 盾， 转 移 护 盾 和 干 扰 护 盾。 
		 受 法 术 强 度 影 响， 充 能 强 度 有 额 外 加 成。]]):
		format(shield, t.getNumEffects(self, t))
	end,
}

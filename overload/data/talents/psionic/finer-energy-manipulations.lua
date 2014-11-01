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


newTalent{
	name = "Realign",
	type = {"psionic/finer-energy-manipulations", 1},
	require = psi_cun_req1,
	points = 5,
	psi = 15,
	cooldown = 15,
	tactical = { HEAL = 2, CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.type == "physical" then
				nb = nb + 1
			end
		end
		return nb
	end },
	getHeal = function(self, t) return 40 + self:combatTalentMindDamage(t, 20, 290) end,
	is_heal = true,
	numCure = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, "log"))
	end,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:mindCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		
		local effs = {}
		-- Go through all temporary effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type == "physical" and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.numCure(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
				known = true
			end
		end
		if known then
			game.logSeen(self, "%s is cured!", self.name:capitalize())
		end
		
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local cure = t.numCure(self, t)
		return ([[用 你 的 精 神 力 量  重 组 并 调 整 你 的 身 体 ， 移 除 最 多 %d 负 面 物 理 状 态  并 治 愈 %d 生 命。
		受 精 神 强 度 影 响，治 疗 量 有 额 外 加 成。]]):
		format(cure, heal)
	end,
}

newTalent{
	name = "Reshape Weapon/Armour", image = "talents/reshape_weapon.png",
	type = {"psionic/finer-energy-manipulations", 2},
	require = psi_cun_req2,
	cooldown = 1,
	psi = 0,
	points = 5,
	no_npc_use = true,
	no_unlearn_last = true,
	boost = function(self, t)
		return math.floor(self:combatTalentMindDamage(t, 5, 20))
	end,
	arm_boost = function(self, t)
		return math.floor(self:combatTalentMindDamage(t, 5, 20))
	end,
	fat_red = function(self, t)
		return math.floor(self:combatTalentMindDamage(t, 2, 10))
	end,
	action = function(self, t)
		local ret = self:talentDialog(self:showInventory("Reshape which weapon or armor?", self:getInven("INVEN"),
			function(o)
				return not o.quest and (o.type == "weapon" and o.subtype ~= "mindstar") or (o.type == "armor" and (o.slot == "BODY" or o.slot == "OFFHAND" )) and not o.fully_reshaped --Exclude fully reshaped?
			end
			, function(o, item)
			if o.combat then
				local atk_boost = t.boost(self, t)
				local dam_boost = atk_boost
				if (o.old_atk or 0) < atk_boost or (o.old_dam or 0) < dam_boost then
					if not o.been_reshaped then
						o.orig_atk = (o.combat.atk or 0)
						o.orig_dam = (o.combat.dam or 0)
					elseif o.been_reshaped == true then --Update items affected by older versions of this talent
						o.name = o.name:gsub("reshaped ", "", 1)
						o.orig_atk = o.combat.atk - (o.old_atk or 0)
						o.orig_dam = o.combat.dam - (o.old_dam or 0)
					end
					o.combat.atk = o.orig_atk + atk_boost
					o.combat.dam = o.orig_dam + dam_boost
					o.old_atk = atk_boost
					o.old_dam = dam_boost
					game.logPlayer(self, "You reshape your %s.", o:getName{do_colour=true, no_count=true})
					o.special = true
					o.been_reshaped = "reshaped("..tostring(atk_boost)..","..tostring(dam_boost)..") "
					self:talentDialogReturn(true)
				else
					game.logPlayer(self, "You cannot reshape your %s any further.", o:getName{do_colour=true, no_count=true})
				end
			else
				local armour = t.arm_boost(self, t)
				local fat = t.fat_red(self, t)
				if (o.old_fat or 0) < fat or o.wielder.combat_armor < (o.orig_arm or 0) + armour then
					o.wielder = o.wielder or {}
					if not o.been_reshaped then
						o.orig_arm = (o.wielder.combat_armor or 0)
						o.orig_fat = (o.wielder.fatigue or 0)
					end
					o.wielder.combat_armor = o.orig_arm
					o.wielder.fatigue = o.orig_fat
					o.wielder.combat_armor = (o.wielder.combat_armor or 0) + armour
					o.wielder.fatigue = (o.wielder.fatigue or 0) - fat
					if o.wielder.fatigue < 0 and not (o.orig_fat < 0) then
						o.wielder.fatigue = 0
					elseif o.wielder.fatigue < 0 and o.orig_fat < 0 then
						o.wielder.fatigue = o.orig_fat
					end
					o.old_fat = fat
					game.logPlayer(self, "You reshape your %s.", o:getName{do_colour=true, no_count=true})
					o.special = true
					if o.orig_name then o.name = o.orig_name end --Fix name for items affected by older versions of this talent
					o.been_reshaped = "reshaped["..tostring(armour)..","..tostring(o.wielder.fatigue-o.orig_fat).."%] "
					self:talentDialogReturn(true)
				else
					game.logPlayer(self, "You cannot reshape your %s any further.", o:getName{do_colour=true, no_count=true})
				end
			end
		end))
		if not ret then return nil end
		return true
	end,
	info = function(self, t)
		local weapon_boost = t.boost(self, t)
		local arm = t.arm_boost(self, t)
		local fat = t.fat_red(self, t)
		return ([[操 纵 力 量 从 分 子 层 面 重 组 、平 衡 、磨 砺 一 件 武 器 、盔 甲 或 者 盾 牌 （灵 晶 不 能 被 调 整 因 为 他 们 已 经 是 完 美 的 自 然 形 态 ）
		永 久 提 高 武 器 %d 命 中 和 伤 害 或 者 盔 甲 %d 护 甲 ，同 时 减 少 %d 疲 劳 。
		该 技 能 效 果 受 精 神 强 度 影 响，且 不 能 对  同 一 件 物 品 重 复 使 用。]]):
		format(weapon_boost, arm, fat)
	end,
}

newTalent{
	name = "Matter is Energy",
	type = {"psionic/finer-energy-manipulations", 3},
	require = psi_cun_req3,
	cooldown = 50,
	psi = 0,
	points = 5,
	no_npc_use = true,
	energy_per_turn = function(self, t)
		return self:combatTalentMindDamage(t, 10, 40)
	end,
	action = function(self, t)
		local ret = self:talentDialog(self:showInventory("Use which gem?", self:getInven("INVEN"), function(gem) return gem.type == "gem" and gem.material_level and not gem.unique end, function(gem, gem_item)
			self:removeObject(self:getInven("INVEN"), gem_item)
			local amt = t.energy_per_turn(self, t)
			local dur = 3 + 2*(gem.material_level or 0)
			self:setEffect(self.EFF_PSI_REGEN, dur, {power=amt})
			self:setEffect(self.EFF_CRYSTAL_BUFF, dur, {name=gem.name, gem=gem.define_as, effects=gem.wielder})
			self:talentDialogReturn(true)
		end))
		if not ret then return nil end
		return true
	end,
	info = function(self, t)
		local amt = t.energy_per_turn(self, t)
		return ([[任 何 优 秀 的 心 灵 杀 手 都 知 道 ，物 质 就 是 能 量 。遗 憾 的 是 ，大 多 数 物 质 由 于 分 子 成 分 的 复 杂 性 无 法 转 换 。然 而 ，宝 石 有 序 的 晶 体 结 构 使 得 部 分 物 质 转 化 为 能 量 成 为 可 能 。
		这 个 技 能 消 耗 一 个 宝 石 ，在 5~13 回 合 内 ，每 回 合 获 得 %d 能 量 ，持 续 回 合 取 决 于 所 用 的 宝 石 品 质 。
		在 持 续 时 间 内 同 时 获 得 一 个 共 振 领 域 提 供 宝 石 的 效 果 ]]):
		format(amt)
	end,
}

newTalent{
	name = "Resonant Focus",
	type = {"psionic/finer-energy-manipulations", 4},
	require = psi_cun_req4,
	mode = "passive",
	points = 5,
	bonus = function(self,t) return self:combatTalentScale(t, 10, 40) end,
	on_learn = function(self, t)
		if self:isTalentActive(self.T_BEYOND_THE_FLESH) then
			if self.__to_recompute_beyond_the_flesh then return end
			self.__to_recompute_beyond_the_flesh = true
			game:onTickEnd(function()
				self.__to_recompute_beyond_the_flesh = nil
				local t = self:getTalentFromId(self.T_BEYOND_THE_FLESH)
				self:forceUseTalent(t.id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true})
				if t.on_pre_use(self, t) then self:forceUseTalent(t.id, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, talent_reuse=true}) end
			end)
		end
	end,
	info = function(self, t)
		local inc = t.bonus(self,t)
		return ([[通 过 小 心 的 同 步 你 的 精 神 和 灵 能 聚 焦 的 共 振 频 率 ，强 化 灵 能 聚 焦 的 效 果 
		对 于 武 器 ，提 升 你 的 意 志 和 灵 巧 来 代 替 力 量 和 敏 捷 的 百 分 比 ，从 60%%  到  %d%%.
		对 于 灵 晶 ，提 升 %d%% 将 敌 人 抓 取 过 来 的几 率 .
		对 于 宝 石 ，提 升 %d 额 外 全 属 性。]]):
		format(60+inc, inc, math.ceil(inc/5))
	end,
}

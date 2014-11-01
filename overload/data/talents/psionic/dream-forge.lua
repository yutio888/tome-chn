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

local Object = require "mod.class.Object"

newTalent{
	name = "Forge Shield",
	type = {"psionic/dream-forge", 1},
	points = 5, 
	require = psi_wil_high1,
	cooldown = 12,
	sustain_psi = 50,
	mode = "sustained",
	tactical = { DEFEND = 2, },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 5, 30) end,
	getDuration = function(self,t) return math.floor(self:combatTalentScale(t, 1, 2)) end,
	doForgeShield = function(type, dam, t, self, src)
		-- Grab our damage threshold
		local dam_threshold = self.max_life * 0.15
		if self:knowTalent(self.T_SOLIPSISM) then
			local t = self:getTalentFromId(self.T_SOLIPSISM)
			local ratio = t.getConversionRatio(self, t)
			local psi_percent =  self:getMaxPsi() * t.getConversionRatio(self, t)
			dam_threshold = (self.max_life * (1 - ratio) + psi_percent) * 0.15
		end

		local dur = t.getDuration(self,t)
		local blocked
		local amt = dam
		local eff = self:hasEffect(self.EFF_FORGE_SHIELD)
		if not eff and dam > dam_threshold then
			self:setEffect(self.EFF_FORGE_SHIELD, dur, {power=t.getPower(self, t), number=1, d_types={[type]=true}})
			amt = util.bound(dam - t.getPower(self, t), 0, dam)
			blocked = t.getPower(self, t)
			game.logSeen(self, "#ORANGE#%s forges a dream shield to block the attack!", self.name:capitalize())
		elseif eff and eff.d_types[type] then
			amt = util.bound(dam - eff.power, 0, dam)
			blocked = eff.power
		elseif eff and dam > dam_threshold * (1 + eff.number) then
			eff.number = eff.number + 1
			eff.d_types[type] = true
			amt = util.bound(dam - eff.power, 0, dam)
			blocked = eff.power
			game.logSeen(self, "#ORANGE#%s's dream shield has been strengthened by the attack!", self.name:capitalize())
		end

		if blocked then
			print("[Forge Shield] blocked", math.min(blocked, dam), DamageType.dam_def[type].name, "damage")
		end
		
		if amt == 0 and src.life then src:setEffect(src.EFF_COUNTERSTRIKE, 1, {power=t.getPower(self, t), no_ct_effect=true, src=self, nb=1}) end
		return amt
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local ret ={
		}
		if self:knowTalent(self.T_FORGE_ARMOR) then
			local t = self:getTalentFromId(self.T_FORGE_ARMOR)
			ret.def = self:addTemporaryValue("combat_def", t.getDefense(self, t))
			ret.armor = self:addTemporaryValue("combat_armor", t.getArmor(self, t))
			ret.psi = self:addTemporaryValue("psi_regen_when_hit", t.getPsiRegen(self, t))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.def then self:removeTemporaryValue("combat_def", p.def) end
		if p.armor then self:removeTemporaryValue("combat_armor", p.armor) end
		if p.psi then self:removeTemporaryValue("psi_regen_when_hit", p.psi) end
	
		return true	
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[当 你 将 要 承 受 一 次 超 过 15％ 最 大 生 命 值 的 攻 击 时， 你 会 锻 造 一 个 熔 炉 屏 障 来 保 护 自 己， 减 少 %0.2f 点 所 有 该 类 型 攻 击 伤 害 于 下 %d 回 合。 
		 熔 炉 屏 障 能 够 同 时 格 挡 多 种 类 型 的 伤 害， 但 是 每 一 种 已 拥 有 的 格 挡 类 型 会 使 伤 害 临 界 点 上 升 15％。
		 如 果 你 完 全 格 挡 了 某 一 攻 击 者 的 伤 害， 则 此 攻 击 者 受 到 持 续 1 回 合 的 反 击 DEBUFF（ 200％ 普 通 近 身 或 远 程 伤 害）。 
		 在 等 级 5 时， 格 挡 效 果 将 持 续 2 回 合。 
		 受 精 神 强 度 影 响， 格 挡 值 按 比 例 加 成。]]):format(power, dur)
	end,
}

newTalent{
	name = "Forge Bellows",
	type = {"psionic/dream-forge", 2},
	points = 5, 
	require = psi_wil_high2,
	cooldown = 24,
	psi = 30,
	tactical = { ATTACKAREA = { FIRE = 2, MIND = 2}, ESCAPE = 2, },
	range = 0,
	radius = function(self, t) return math.min(7, 2 + math.ceil(self:getTalentLevel(t)/2)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), friendlyfire=false, radius = self:getTalentRadius(t), talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	getBlastDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 100) end,
	getForgeDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 10) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local blast_damage = self:mindCrit(t.getBlastDamage(self, t))
		local forge_damage = self:mindCrit(t.getForgeDamage(self, t))
		
		-- Do our blast first
		self:project(tg, x, y, DamageType.DREAMFORGE, {dam=blast_damage, dist=math.ceil(tg.radius/2)})
		
		-- Now build our Barrier
		self:project(tg, x, y, function(px, py, tg, self)
			local oe = game.level.map(px, py, Map.TERRAIN)
			if rng.percent(50) or not oe or oe:attr("temporary") or game.level.map:checkAllEntities(px, py, "block_move") then return end
			
			local e = Object.new{
				old_feat = oe,
				type = oe.type, subtype = oe.subtype,
				name = npcCHN:getName(self.name).."的熔炉屏障",
				image = "terrain/lava/lava_mountain5.png",
				display = '#', color=colors.RED, back_color=colors.DARK_GREY,
				shader = "shadow_simulacrum",
				shader_args = { color = {0.6, 0.0, 0.0}, base = 0.9, time_factor = 1500 },
				always_remember = true,
				desc = "a summoned wall of mental energy",
				type = "wall",
				can_pass = {pass_wall=1},
				does_block_move = true,
				show_tooltip = true,
				block_move = true,
				block_sight = true,
				temporary = t.getDuration(self, t),
				x = px, y = py,
				canAct = false,
				dam = forge_damage,
				radius = self:getTalentRadius(t),
				act = function(self)
					local tg = {type="ball", range=0, friendlyfire=false, radius = 1, talent=t, x=self.x, y=self.y,}
					self.summoner.__project_source = self
					self.summoner:project(tg, self.x, self.y, engine.DamageType.DREAMFORGE, self.dam)
					self.summoner.__project_source = nil
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
						game.level:removeEntity(self)
						game.level.map:updateMap(self.x, self.y)
						game.nicer_tiles:updateAround(game.level, self.x, self.y)
					end
				end,
				dig = function(src, x, y, old)
					game.level:removeEntity(old)
					return nil, old.old_feat
				end,
				summoner_gain_exp = true,
				summoner = self,
			}
			e.tooltip = mod.class.Grid.tooltip
			game.level:addEntity(e)
			game.level.map(px, py, Map.TERRAIN, e)
			game.nicer_tiles:updateAround(game.level, px, py)
			game.level.map:updateMap(px, py)
		end)
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local blast_damage = t.getBlastDamage(self, t)/2
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local forge_damage = t.getForgeDamage(self, t)/2
		return ([[将 梦 之 熔 炉 的 风 箱 打 开， 朝 向 你 的 四 周， 对 锥 形 范 围 内 敌 人 造 成 %0.2f 精 神 伤 害， %0.2f 燃 烧 伤 害 并 造 成 击 退 效 果。 锥 型 范 围 的 半 径 为 %d 码 。
		 空 旷 的 地 面 有 50％ 几 率 转 化 为 持 续 %d 回 合 的 熔 炉 外 壁。 熔 炉 外 壁 阻 挡 移 动， 并 对 周 围 敌 人 造 成 %0.2f 的 精 神 伤 害 和 %0.2f 的 火 焰 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 和 击 退 几 率 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.MIND, blast_damage), damDesc(self, DamageType.FIRE, blast_damage), radius, duration, damDesc(self, DamageType.MIND, forge_damage), damDesc(self, DamageType.FIRE, forge_damage))
	end,
}

newTalent{
	name = "Forge Armor",
	type = {"psionic/dream-forge", 3},
	points = 5,
	require = psi_wil_high3,
	mode = "passive",
	getArmor = function(self, t) return self:combatTalentMindDamage(t, 1, 15) end,
	getDefense = function(self, t) return self:combatTalentMindDamage(t, 1, 15) end,
	getPsiRegen = function(self, t) return self:combatTalentMindDamage(t, 1, 10) end,
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local defense = t.getDefense(self, t)
		local psi = t.getPsiRegen(self, t)
		return([[你 的 熔 炉 屏 障 技 能 现 在 可 以 增 加 你 %d 点 护 甲， %d 点 闪 避， 并 且 当 你 被 近 战 或 远 程 攻 击 击 中 时 给 予 你 %0.2f 超 能 力 值。 
		 受 精 神 强 度 影 响， 增 益 按 比 例 加 成。]]):format(armor, defense, psi)
	end,
}

newTalent{
	name = "Dreamforge",
	type = {"psionic/dream-forge", 4},
	points = 5, 
	require = psi_wil_high4,
	cooldown = 12,
	sustain_psi = 50,
	mode = "sustained",
	no_sustain_autoreset = true,
	tactical = { ATTACKAREA = { FIRE = 2, MIND = 2}, DEBUFF = 2, },
	range = 0,
	radius = function(self, t) return math.min(5, 1 + math.ceil(self:getTalentLevel(t)/3)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius = self:getTalentRadius(t), talent=t}
	end,
	getDamage = function(self, t) return math.ceil(self:combatTalentMindDamage(t, 5, 30)) end,
	getPower = function(self, t) return math.floor(self:combatTalentMindDamage(t, 5, 25)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 5, 25) end, --Limit < 100%
	getFailChance = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 5, 25), 67, 0, 0, 16.34, 16.34) end, -- Limit to <67%
	
	doForgeStrike = function(self, t, p)
		-- If we moved reset the forge
		if self.x ~= p.x or self.y ~= p.y or p.new then
			p.x = self.x; p.y=self.y; p.radius=0; p.damage=0; p.power=0; p.new = nil;
		-- Otherwise we strike the forge
		elseif not self.resting then
			local max_radius = self:getTalentRadius(t)
			local max_damage = t.getDamage(self, t)
			local power = t.getPower(self, t)
			p.radius = math.min(p.radius + 1, max_radius)

			if p.damage < max_damage then
				p.radius = math.min(p.radius + 1, max_radius)
				p.damage = math.min(max_damage/4 + p.damage, max_damage)
				game.logSeen(self, "#GOLD#%s strikes the dreamforge!", self.name:capitalize())
			elseif p.power == 0 then
				p.power = power
				game.logSeen(self, "#GOLD#%s begins breaking dreams!", self.name:capitalize())
				game:playSoundNear(self, "talents/lightning_loud")
			end
			local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=p.radius, talent=t}
			-- Spell failure handled under "DREAMFORGE" damage type in data\damage_types.lua and transferred to "BROKEN_DREAM" effect in data\timed_effects\mental.lua
			self:project(tg, self.x, self.y, engine.DamageType.DREAMFORGE, {dam=self:combatMindCrit(p.damage), power=p.power, fail=t.getFailChance(self,t), dur=p.dur, chance=p.chance, do_particles=true })
		end
	end,
	activate = function(self, t)
		local ret ={
			x = self.x, y=self.y, radius=0, damage=0, power=0, new = true, dur=t.getDuration(self, t), chance=t.getChance(self, t)
		}
		game:playSoundNear(self, "talents/devouringflame")
		return ret
	end,
	deactivate = function(self, t, p)
		return true	
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)/2
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local fail = t.getFailChance(self,t)
		return ([[你 将 脑 海 里 锻 造 的 冲 击 波 向 四 周 释 放。 
		 每 回 合 当 你 保 持 静 止， 你 将 会 锤 击 梦 之 熔 炉， 对 周 围 敌 人 造 成 精 神 和 燃 烧 伤 害。 
		 此 效 果 将 递 增 5 个 回 合， 直 至 %d 码 最 大 范 围， %0.2f 最 大 精 神 伤 害 和 %0.2f 最 大 燃 烧 伤 害。 
		 此 刻， 你 将 会 打 破 那 些 听 到 熔 炉 声 的 敌 人 梦 境， 减 少 它 们 %d 精 神 豁 免， 并 且 由 于 敲 击 熔 炉 的 
		 巨 大 回 声， 它 们 将 获 得 一 个 %d%% 的 法 术 失 败 率， 持 续 %d 回 合。 
		 梦 境 破 碎 有 %d%% 几 率 对 你 的 敌 人 产 生 锁 脑 效 果。 
		 受 精 神 强 度 影 响， 伤 害 和 梦 境 打 破 效 果 按 比 例 加 成。]]):
		format(radius, damDesc(self, DamageType.MIND, damage), damDesc(self, DamageType.FIRE, damage), power, fail, duration, chance)
	end,
}

-- ToME -  Tales of Maj'Eyal
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
	name = "Dust to Dust",
	type = {"chronomancy/matter",1},
	require = chrono_req1,
	points = 5,
	paradox = 5,
	cooldown = 3,
	tactical = { ATTACKAREA = {TEMPORAL = 1, PHYSICAL = 1} },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 230)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		self:project(tg, x, y, DamageType.MATTER, self:spellCrit(t.getDamage(self, t)))
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "matter_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 束 射 线 将 目 标 化 为 灰 烬， 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage / 2), damDesc(self, DamageType.PHYSICAL, damage / 2))
	end,
}

newTalent{
	name = "Carbon Spikes",
	type = {"chronomancy/matter", 2},
	require = chrono_req2, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_paradox = 100,
	cooldown = 12,
	tactical = { BUFF =2, DEFEND = 2 },
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 10, 100) end,
	getArmor = function(self, t) return math.ceil (self:combatTalentSpellDamage(t, 20, 50)) end,
	do_carbonRegrowth = function(self, t)
		local maxspikes = t.getArmor(self, t)
		if self.carbon_armor < maxspikes then
			self.carbon_armor = self.carbon_armor + 1
		end
	end,
	do_carbonLoss = function(self, t)
		if self.carbon_armor >= 1 then
			self.carbon_armor = self.carbon_armor - 1
		else
			-- Deactivate without loosing energy
			self:forceUseTalent(self.T_CARBON_SPIKES, {ignore_energy=true})
		end
	end,
	activate = function(self, t)
		local power = t.getArmor(self, t)
		self.carbon_armor = power
		game:playSoundNear(self, "talents/spell_generic")
		return {
			armor = self:addTemporaryValue("carbon_spikes", power),
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.BLEED]=t.getDamageOnMeleeHit(self, t)}),			
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("carbon_spikes", p.armor)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self.carbon_armor = nil
		return true
	end,
	info = function(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local armor = t.getArmor(self, t)
		return ([[脆 弱 的 碳 化 钉 刺 从 你 的 肉 体、 衣 服 和 护 甲 中 伸 出 来， 增 加 %d 点 护 甲 值。 同 时， 在 6 回 合 内 对 攻 击 者 造 成 总 计 %0.2f 点 流 血 伤 害。 
		 每 次 你 受 到 攻 击 时， 护 甲 增 益 效 果 减 少 1 点。 每 回 合 会 自 动 回 复 1 点 护 甲 增 益 至 初 始 效 果。 
		 如 果 护 甲 增 益 降 到 1 点 以 下， 则 技 能 会 被 中 断， 效 果 结 束。 
		 受 法 术 强 度 影 响， 护 甲 增 益 和 流 血 伤 害 有 额 外 加 成。]]):
		format(armor, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

newTalent{
	name = "Destabilize",
	type = {"chronomancy/matter", 3},
	require = chrono_req3,
	points = 5,
	cooldown = 10,
	paradox = 15,
	range = 10,
	tactical = { ATTACK = 2 },
	requires_target = true,
	direct_hit = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 60)*getParadoxModifier(self, pm) end,
	getExplosion = function(self, t) return self:combatTalentSpellDamage(t, 20, 230)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_TEMPORAL_DESTABILIZATION, 10, {src=self, dam=t.getDamage(self, t), explosion=self:spellCrit(t.getExplosion(self, t))})
			game.level.map:particleEmitter(target.x, target.y, 1, "entropythrust")
		end)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[使 目 标 所 处 的 时 空 出 现 裂 隙， 每 回 合 造 成 %0.2f 时 空 伤 害， 持 续 10 回 合。 
		 如 果 目 标 在 被 标 记 时 死 亡， 则 会 产 生 4 码 半 径 范 围 的 时 空 爆 炸， 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 伤 害。 
		 如 果 目 标 在 持 续 期 间 死 亡， 则 爆 炸 产 生 的 所 有 伤 害 会 转 化 为 时 空 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), damDesc(self, DamageType.TEMPORAL, explosion/2), damDesc(self, DamageType.PHYSICAL, explosion/2))
	end,
}

newTalent{
	name = "Quantum Spike",
	type = {"chronomancy/matter", 4},
	require = chrono_req4,
	points = 5,
	paradox = 20,
	cooldown = 4,
	tactical = { ATTACK = {TEMPORAL = 1, PHYSICAL = 1} },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 300)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		
		-- bonus damage on targets with temporal destabilization
		local damage = t.getDamage(self, t)
		if target then 
			if target:hasEffect(target.EFF_TEMPORAL_DESTABILIZATION) or target:hasEffect(target.EFF_CONTINUUM_DESTABILIZATION) then
				damage = damage * 1.5
			end
		end
		
		
		self:project(tg, x, y, DamageType.MATTER, self:spellCrit(damage))
		game:playSoundNear(self, "talents/arcane")
		
		-- Try to insta-kill
		if target then
			if target:checkHit(self:combatSpellpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("instakill") and target.life > 0 and target.life < target.max_life * 0.2 then
				-- KILL IT !
				game.logSeen(target, "%s has been pulled apart at a molecular level!", target.name:capitalize())
				target:die(self)
			elseif target.life > 0 and target.life < target.max_life * 0.2 then
				game.logSeen(target, "%s resists the quantum spike!", target.name:capitalize())
			end
		end
		
		-- if we kill it use teleport particles for larger effect radius
		if target and target.dead then
			game.level.map:particleEmitter(x, y, 1, "teleport")
		else
			game.level.map:particleEmitter(x, y, 1, "entropythrust")
		end
		
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 试 图 将 目 标 分 离 为 分 子 状 态， 造 成 %0.2f 时 空 伤 害 和 %0.2f 物 理 伤 害 , 技 能 结 束 后 若 目 标 生 命 值 不 足 20%% 则 会 被 立 刻 杀 死。 
		 量 子 钉 刺 对 受 时 空 紊 乱 和 / 或 连 续 紊 乱 的 目 标 会 多 造 成 50％ 的 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}


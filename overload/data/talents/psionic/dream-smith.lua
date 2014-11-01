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

-- Dream-Forge Hammer
function useDreamHammer(self)
	local combat = {
		talented = "dream",
		sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2},

		wil_attack = true,
		damrange = 1.5,
		physspeed = 1, 
		dam = 16,
		apr = 0,
		atk = 0,
		physcrit = 0,
		dammod = {wil=1.2},
		melee_project = {},
	}
	if self:knowTalent(self.T_DREAM_HAMMER) then
		local t = self:getTalentFromId(self.T_DREAM_HAMMER)
		combat.dam = 16 + t.getBaseDamage(self, t)
		combat.apr = 0 + t.getBaseApr(self, t)
		combat.physcrit = 0 + t.getBaseCrit(self, t)
		combat.atk = 0 + t.getBaseAtk(self, t)
	end
	if self:knowTalent(self.T_HAMMER_TOSS) then
		local t = self:getTalentFromId(self.T_HAMMER_TOSS)
		combat.atk = t.getAttackTotal(self, t)
	end
	if self:knowTalent(self.T_FORGE_ECHOES) then
		local t = self:getTalentFromId(self.T_FORGE_ECHOES)
		combat.melee_project = { [engine.DamageType.DREAMFORGE] = t.getProject(self, t) }
	end
	return combat
end

newTalent{
	name = "Dream Smith's Hammer",
	short_name = "DREAM_HAMMER",
	type = {"psionic/dream-smith", 1},
	points = 5, 
	require = psi_wil_req1,
	cooldown = 6,
	psi = 5,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.4, 2.1) end,
	getBaseDamage = function(self, t) return self:combatTalentMindDamage(t, 0, 60) end,
	getBaseAtk = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	getBaseApr = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	getBaseCrit = function(self, t) return self:combatTalentMindDamage(t, 0, 20) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})
		
		-- Reset Dream Smith talents
		if hit then
			local trigger_discharge = false
			local nb = self:getTalentLevel(t) >= 5 and 2 or 1
			for tid, cd in pairs(self.talents_cd) do
				local tt = self:getTalentFromId(tid)
				if tt.type[1]=="psionic/dream-smith" and nb > 0 then
					self.talents_cd[tid] = 0
					trigger_discharge = true
					nb = nb - 1
				end
			end
			if hit and trigger_discharge then
				if rng.percent(50) then
					game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
				else
					game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
				end
				game:playSoundNear(self, "talents/heal")
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local weapon_damage = useDreamHammer(self).dam
		local weapon_range = useDreamHammer(self).dam * useDreamHammer(self).damrange
		local weapon_atk = useDreamHammer(self).atk
		local weapon_apr = useDreamHammer(self).apr
		local weapon_crit = useDreamHammer(self).physcrit
		return ([[在 梦 境 熔 炉 中 将 武 器 锻 造 成 一 柄 巨 锤 砸 向 附 近 某 个 目 标， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 它 会 使 梦 境 锻 造 系 的 某 个 随 机 技 能 冷 却 完 毕。 
		 在 等 级 5 时， 此 技 能 会 使 2 个 随 机 技 能 冷 却 完 毕。 
		 受 精 神 强 度 影 响， 武 器 的 基 础 攻 击 力、 命 中、 护 甲 穿 透 和 暴 击 率 按 比 例 加 成。 

		 当 前 梦 之 巨 锤 属 性： 
		 攻 击 力 : %0.2f - %0.2f
		 加 成 属 性 : 120％ 意 志 
		 伤 害 类 型 : 物 理 
		 此 武 器 的 命 中 率 基 于 意 志 计 算。 
		 命 中 加 成 : +%d
		 护 甲 穿 透 : +%d
		 物 理 暴 击 率 : +%d]]):format(damage * 100, weapon_damage, weapon_range, weapon_atk, weapon_apr, weapon_crit)
	end,
}

newTalent{
	name = "Hammer Toss",
	type = {"psionic/dream-smith", 2},
	points = 5, 
	require = psi_wil_req2,
	cooldown = 8,
	psi = 10,
	tactical = { ATTACKAREA = { weapon = 2 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	requires_target = true,
	proj_speed = 10,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), selffire=false, talent=t, display={display='', particle="arrow", particle_args={tile="shockbolt/object/dream_hammer"}, trail="firetrail"}}
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getAttack = function(self, t) return self:getTalentLevel(t) * 10 end, -- Used for the talent display
	getAttackTotal = function(self, t)
		local base_atk = 0
		if self:knowTalent(self.T_DREAM_HAMMER) then
			local t = self:getTalentFromId(self.T_DREAM_HAMMER)
			base_atk = 0 + t.getBaseAtk(self, t)
		end
		return base_atk + t.getAttack(self, t)
	end,
	getDreamHammer = function(self, t) return useDreamHammer(self) end, -- To prevent upvalue issues
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		
		print("[Dream Hammer Throw] Projection from", self.x, self.y, "to", x, y)
		self:projectile(tg, x, y, function(px, py, tg, self)
			local tmp_target = game.level.map(px, py, engine.Map.ACTOR)
			if tmp_target and tmp_target ~= self then
				local t = self:getTalentFromId(self.T_HAMMER_TOSS)
				self:attackTargetWith(tmp_target, t.getDreamHammer(self, t), nil, t.getDamage(self, t))
			end
			if x == px and y == py and self and self.x and self.y then
				print("[Dream Hammer Return] Projection from", x, y, "to", self.x, self.y)
				local tgr = tg
				tgr.name = "Hammer Toss"
				tgr.x, tgr.y = px, py
				self:projectile(tgr, self.x, self.y, function(px, py, tgr, self)
					local tmp_target = game.level.map(px, py, engine.Map.ACTOR)
					local t = self:getTalentFromId(self.T_HAMMER_TOSS)
					if tmp_target and tmp_target ~= self then
						self:attackTargetWith(tmp_target, t.getDreamHammer(self, t), nil, t.getDamage(self, t))
					end
				end)
			end
		end)
		
		game:playSoundNear(self, "talents/warp")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local attack_bonus = t.getAttack(self, t)
		return ([[将 你 的 梦 之 巨 锤 扔 向 远 处， 对 沿 途 所 有 敌 方 单 位 造 成 %d%% 武 器 伤 害。 在 到 达 目 标 点 后， 梦 之 巨 锤 会 自 动 返 回， 再 次 对 沿 途 目 标 造 成 伤 害。 
		 学 习 此 技 能 会 增 加 梦 之 巨 锤 %d 点 命 中。]]):format(damage * 100, attack_bonus)
	end,
}

newTalent{
	name = "Dream Crusher",
	type = {"psionic/dream-smith", 3},
	points = 5, 
	require = psi_wil_req3,
	cooldown = 12,
	psi = 10,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getMasteryDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	getStun = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})
		
		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStun(self, t), {apply_power=self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the stunning blow!", target.name:capitalize())
			end
			if rng.percent(50) then
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
			elseif hit then
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
			end
			game:playSoundNear(self, "talents/lightning_loud")
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local power = t.getMasteryDamage(self, t)
		local percent = t.getPercentInc(self, t)
		local stun = t.getStun(self, t)		
		return ([[用 你 的 梦 之 巨 锤 碾 碎 敌 人， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 则 目 标 会 被 震 慑 %d 回 合。 
		 受 精 神 强 度 影 响， 震 慑 几 率 有 额 外 加 成。 
		 学 习 此 技 能 会 增 加 %d 点 你 使 用 梦 之 巨 锤 时 的 物 理 强 度， 同 时 使 梦 之 巨 锤 造 成 的 所 有 伤 害 提 升 %d%% 。]]):format(damage * 100, stun, power, percent * 100)
	end,
}

newTalent{
	name = "Forge Echoes",
	type = {"psionic/dream-smith", 4},
	points = 5, 
	require = psi_wil_req4,
	cooldown = 24,
	psi = 20,
	tactical = { ATTACKAREA = { weapon = 3 } },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false }
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.5) end,
	getProject = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, useDreamHammer(self), nil, t.getDamage(self, t))
		game.level.map:particleEmitter(target.x, target.y, 1, "dreamhammer", {tile="shockbolt/object/dream_hammer", tx=target.x, ty=target.y, sx=self.x, sy=self.y})
		
		-- Forge Echoe
		if hit then
			local tg = self:getTalentTarget(t)
			self:project(tg, target.x, target.y, function(px, py, tg, self)
				local tmp_target = game.level.map(px, py, Map.ACTOR)
				if tmp_target and tmp_target ~= self and tmp_target ~= target then
					local hit = self:attackTargetWith(tmp_target, useDreamHammer(self), DamageType.DREAMFORGE, t.getDamage(self, t))
					if hit and rng.percent(50) then
						game.level.map:particleEmitter(tmp_target.x, tmp_target.y, 1, "generic_discharge", {rm=225, rM=255, gm=0, gM=0, bm=0, bM=0, am=35, aM=90})
					elseif hit then
						game.level.map:particleEmitter(tmp_target.x, tmp_target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=0, bM=0, am=35, aM=90})
					end
				end
			end)
			game:playSoundNear(self, "talents/echo")
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local project = t.getProject(self, t) /2
		return ([[用 梦 之 巨 锤 对 目 标 挥 出 强 力 的 一 击， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 挥 击 所 产 生 的 回 音 会 伤 害 %d 码 范 围 内 的 所 有 目 标。 
		 学 习 此 技 能 会 使 你 的 梦 之 巨 锤 附 加 %0.2f 精 神 伤 害 和 %0.2f 燃 烧 伤 害。 
		 受 精 神 强 度 影 响， 梦 之 巨 锤 附 加 的 精 神 伤 害 和 燃 烧 伤 害 按 比 例 加 成。]]):format(damage * 100, radius, damDesc(self, DamageType.MIND, project), damDesc(self, DamageType.FIRE, project))
	end,
}
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
	name = "Dual Weapon Training",
	type = {"technique/dualweapon-training", 1},
	mode = "passive",
	points = 5,
	require = techs_dex_req1,
	-- called by  _M:getOffHandMult in mod\class\interface\Combat.lua
	-- This talent could probably use a slight buff at higher talent levels after diminishing returns kick in
	getoffmult = function(self,t)
		return	self:combatTalentLimit(t, 1, 0.65, 0.85)-- limit <100%
	end,
	info = function(self, t)
		return ([[副 手 武 器 伤 害 增 加 至 %d%% 。]]):format(100 * t.getoffmult(self,t))
	end,
}

newTalent{ -- Note: classes: Temporal Warden, Rogue, Shadowblade, Marauder
	name = "Dual Weapon Defense",
	type = {"technique/dualweapon-training", 2},
	mode = "passive",
	points = 5,
	require = techs_dex_req2,
	-- called by _M:combatDefenseBase in mod.class.interface.Combat.lua
	getDefense = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 45.7, 500) end,
	getDeflectChance = function(self, t) --Chance to parry with an offhand weapon, kicks in for TL > 5
		return self:combatTalentLimit(math.max(0, self:getTalentLevel(t)-5), 100, 16.7, 50)
	end,
	getDeflectPercent = function(self, t) -- Percent of offhand weapon damage used to deflect
		return math.max(0, self:combatTalentLimit(self:getTalentLevel(t)-5, 100, 10, 40))
	end,
	getDamageChange = function(self, t, fake)
		local dam,_,weapon = 0,self:hasDualWeapon()
		if not weapon or weapon.subtype=="mindstar" and not fake then return 0 end
		if weapon then
			dam = self:combatDamage(weapon.combat) * self:getOffHandMult(weapon.combat)
		end
		return t.getDeflectPercent(self, t) * dam/100
	end,
	-- deflect count handled in physical effect "DUAL_WEAPON_DEFENSE" in mod.data.timed_effects.physical.lua
	-- buff refreshed each turn in mod.class.Actor.lua _M:actBase
	getDeflects = function(self, t, fake)
		if not self:hasDualWeapon() and not fake then return 0 end
		return self:combatStatScale("cun", 0, 2.25)
	end,
	-- Called by _M:attackTargetWith in mod.class.interface.Combat.lua
	doDeflect = function(self, t)
		local eff = self:hasEffect(self.EFF_DUAL_WEAPON_DEFENSE)
		if not eff then return 0 end
		local deflected = 0
		if rng.percent(self.tempeffect_def.EFF_DUAL_WEAPON_DEFENSE.deflectchance(self, eff)) then
			deflected = eff.dam
		end
		eff.deflects = eff.deflects -1
		if eff.deflects <=0 then self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) end
		return deflected
	end,
	on_unlearn = function(self, t)
		self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE)
	end,
	info = function(self, t)
		local xs = ([[  当 技 能 等 级 超 过 5 时 ， 你 能 用 副 手 武 器 挡 住 近 战 攻 击（ 灵 晶 除 外） 。 
		 你 现 在 有 %d%% 的 概 率 偏 移 至 多 %d 点 伤 害 （ 你 副 手 伤 害 的 %d%%） ， 每 回 合 至 多 触 发 %0.1f 次 （ 基 于 你 的 灵 巧）。 ]]):
		format(t.getDeflectChance(self,t),t.getDamageChange(self, t, true), t.getDeflectPercent(self,t), t.getDeflects(self, t, true))
		return ([[你 已 经 学 会 用 你 的 武 器 招 架 攻 击。 当 你 双 持 时， 增 加 %d 点 近 身 闪 避。 
		受 敏 捷 影 响， 闪 避 增 益 按 比 例 加 成。%s]]):format(t.getDefense(self, t),xs)
	end,
}

newTalent{
	name = "Precision",
	type = {"technique/dualweapon-training", 3},
	mode = "sustained",
	points = 5,
	require = techs_dex_req3,
	no_energy = true,
	cooldown = 10,
	sustain_stamina = 20,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getApr = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 25, 500, 0.75) end,
	activate = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Precision without dual wielding!")
			return nil
		end

		return {
			apr = self:addTemporaryValue("combat_apr",t.getApr(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_apr", p.apr)
		return true
	end,
	info = function(self, t)
		return ([[你 已 经 学 会 打 击 弱 点 位 置， 双 持 时 增 加 你 %d 点 护 甲 穿 透。 
		受 敏 捷 影 响， 护 甲 穿 透 有 额 外 加 成。 ]]):format(t.getApr(self, t))
	end,
}

newTalent{
	name = "Momentum",
	type = {"technique/dualweapon-training", 4},
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 50,
	require = techs_dex_req4,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if self:hasArcheryWeapon() or not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two melee weapons to use this talent.") end return false end return true end,
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.11, 0.40, 0.75) end,
	activate = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Momentum without dual wielding melee weapons!")
			return nil
		end

		return {
			combat_physspeed = self:addTemporaryValue("combat_physspeed", t.getSpeed(self, t)),
			stamina_regen = self:addTemporaryValue("stamina_regen", -6),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.combat_physspeed)
		self:removeTemporaryValue("stamina_regen", p.stamina_regen)
		return true
	end,
	info = function(self, t)
		return ([[当 你 双 持 武 器 时， 增 加 %d%% 攻 击 速 度， 快 速 消 耗 体 力 （ -6 体 力 / 回 合）。  ]]):format(t.getSpeed(self, t)*100)
	end,
}

------------------------------------------------------
-- Attacks
------------------------------------------------------
newTalent{
	name = "Dual Strike",
	type = {"technique/dualweapon-attack", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 15,
	require = techs_dex_req1,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = { stun = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getStunDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Dual Strike without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- First attack with offhand
		local speed, hit = self:attackTargetWith(target, offweapon.combat, nil, self:getOffHandMult(offweapon.combat, self:combatTalentWeaponDamage(t, 0.7, 1.5)))

		-- Second attack with mainhand
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStunDuration(self, t), {apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the stunning strike!", target.name:capitalize())
			end

			-- Attack after the stun, to benefit from backstabs
			self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 0.7, 1.5))
		end

		return true
	end,
	info = function(self, t)
		return ([[用 副 手 武 器 造 成 %d%% 伤 害。 
		如 果 攻 击 命 中， 目 标 将 会 被 震 慑 %d 回 合 并 且 你 会 使 用 主 武 器 对 目 标 造 成 %d%% 伤 害。 
		受 命 中 影 响， 震 慑 概 率 有 额 外 加 成。 ]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.7, 1.5), t.getStunDuration(self, t), 100 * self:combatTalentWeaponDamage(t, 0.7, 1.5))
	end,
}

newTalent{
	name = "Flurry",
	type = {"technique/dualweapon-attack", 2},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 15,
	require = techs_dex_req2,
	requires_target = true,
	tactical = { ATTACK = { weapon = 4 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Flurry without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.4, 1.0), true)

		return true
	end,
	info = function(self, t)
		return ([[对 目 标 进 行 快 速 的 连 刺， 每 把 武 器 进 行 3 次 打 击， 每 次 打 击 造 成 %d%% 的 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.0))
	end,
}

-- This is a good candidate for replacement if someone has a clever idea
-- A.  Its boring
-- B.  Its pretty bad
-- D.  I think we should solidify 2H as generally the best at multitarget hits, so having 1 less AoE than 2H Assault would be good
newTalent{
	name = "Sweep",
	type = {"technique/dualweapon-attack", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 30,
	require = techs_dex_req3,
	requires_target = true,
	tactical = { ATTACKAREA = { weapon = 1, cut = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	cutdur = function(self,t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	cutPower = function(self, t)
		local main, off = self:hasDualWeapon()
		if main then
			-- Damage based on mainhand weapon and dex with an assumed 8 turn cut duration
			return self:combatTalentScale(t, 1, 1.7) * self:combatDamage(main.combat)/8 + self:getDex()/2
		else 
			return 0
		end
	end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Sweep without dual wielding!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local dir = util.getDir(x, y, self.x, self.y)
		if dir == 5 then return nil end
		local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
		local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
		local lt, rt = game.level.map(lx, ly, Map.ACTOR), game.level.map(rx, ry, Map.ACTOR)

		local hit
		hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
		if hit and target:canBe("cut") then target:setEffect(target.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end

		if lt then
			hit = self:attackTarget(lt, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
			if hit and lt:canBe("cut") then lt:setEffect(lt.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end
		end

		if rt then
			hit = self:attackTarget(rt, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
			if hit and rt:canBe("cut") then rt:setEffect(rt.EFF_CUT, t.cutdur(self, t), {power=t.cutPower(self, t), src=self}) end
		end
		print(x,y,target)
		print(lx,ly,lt)
		print(rx,ry,rt)

		return true
	end,
	info = function(self, t)
		return ([[对 你 正 前 方 锥 形 范 围 的 敌 人 造 成 %d%% 武 器 伤 害 并 使 目 标 进 入 流 血 状 态， 每 回 合 造 成 %d 点 伤 害， 持 续 %d 回 合。
		 受 主 手 武 器 伤 害 和 敏 捷 影 响， 流 血 伤 害 有 额 外 加 成。 ]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), damDesc(self, DamageType.PHYSICAL, t.cutPower(self, t)), t.cutdur(self, t))
	end,
}

newTalent{
	name = "Whirlwind",
	type = {"technique/dualweapon-attack", 4},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 30,
	require = techs_dex_req4,
	tactical = { ATTACKAREA = { weapon = 2 } },
	range = 0,
	radius = 1,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon, offweapon = self:hasDualWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Whirlwind without dual wielding!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1.2, 1.9), true)
			end
		end)

		self:addParticles(Particles.new("meleestorm2", 1, {}))

		return true
	end,
	info = function(self, t)
		return ([[挥 砍 一 周， 用 2 把 武 器 对 你 周 围 的 所 有 敌 人 造 成 %d%% 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9))
	end,
}


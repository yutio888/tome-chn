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

-- Default archery attack
newTalent{
	name = "Shoot",
	type = {"technique/archery-base", 1},
	no_energy = "fake",
	hide = true,
	innate = true,
	points = 1,
	cooldown = 0,
	stamina = function(self, t)
		if not self:hasArcheryWeapon("sling") or not self:isTalentActive("T_SKIRMISHER_BOMBARDMENT") then return nil end

		local b = self:getTalentFromId("T_SKIRMISHER_BOMBARDMENT")
		return b.shot_stamina(self, b)
	end,
	range = archery_range,
	message = "@Source@ shoots!",
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	no_unlearn_last = true,
	use_psi_archery = function(self, t)
		local inven = self:getInven("PSIONIC_FOCUS")
		if not inven then return false end
		local pf_weapon = inven[1]
		if pf_weapon and pf_weapon.archery then
			return true
		else
			return false
		end
	end,
	action = function(self, t)
		-- Most of the time use the normal shoot.
		if not self:hasArcheryWeapon("sling") or not self:isTalentActive("T_SKIRMISHER_BOMBARDMENT") then
			local targets = self:archeryAcquireTargets(nil, {one_shot=true})
			if not targets then return end
			self:archeryShoot(targets, t, nil, {use_psi_archery = t.use_psi_archery(self, t)})
			return true
		end

		local weapon, ammo, offweapon = self:hasArcheryWeapon()
		if not weapon then return nil end
		local infinite = ammo.infinite or self:attr("infinite_ammo")
		if not ammo or (ammo.combat.shots_left <= 0 and not infinite) then
			game.logPlayer(self, "You do not have enough ammo left!")
			return nil
		end

		-- Bombardment.
		local weapon = self:hasArcheryWeapon("sling")
		local bombardment = self:getTalentFromId("T_SKIRMISHER_BOMBARDMENT")
		local shots = bombardment.bullet_count(self, bombardment)
		local mult = bombardment.damage_multiplier(self, bombardment)

		-- Do targeting.
		local old_target_forced = game.target.forced
		local tg = {type = "bolt", range = archery_range(self),	talent = t}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return end
		game.target.forced = {x, y, target}

		-- Fire all shots.
		local i
		for i = 1, shots do
			local targets = self:archeryAcquireTargets(nil, {no_energy=true, one_shot=true})
			if not targets then break end
			self:archeryShoot(targets, t, nil, {mult=mult, use_psi_archery = t.use_psi_archery(self, t)})
		end

		local speed = self:combatSpeed(weapon)
		self:useEnergy(game.energy_to_act * (speed or 1))

		game.target.forced = old_target_forced

		return i ~= 1
	end,
	info = function(self, t)
		return ([[使 用 你 的 弓 或 投 石 索 射 击！]])
	end,
}

newTalent{
	name = "Reload",
	type = {"technique/archery-base", 1},
	cooldown = 2,
	innate = true,
	points = 1,
	tactical = { AMMO = 2 },
	no_energy = true,
	no_reload_break = true,
	no_break_stealth = true,
	on_pre_use = function(self, t, silent)
		local q = self:hasAmmo()
		if not q then if not silent then game.logPlayer(self, "You must have a quiver or pouch equipped.") end return false end
		if q.combat.shots_left >= q.combat.capacity then return false end
		return true 
	end,
	no_unlearn_last = true,
	action = function(self, t)
		if self.resting then return end
		local ret = self:reload()
		if ret then
			self:setEffect(self.EFF_RELOAD_DISARMED, 1, {})
		end
		return true
	end,
	info = function(self, t)
		return ([[快 速 装 填 %d 弹 药 ( 由 技 能 和 物 品 决 定)。
		不 消 耗 时 间 ， 但 你 会 被 视 为 缴 械 两 回 合 。
		装 填 不 打 破 潜 行。]])
		:format(self:reloadRate())
	end,
}

newTalent{
	name = "Steady Shot",
	type = {"technique/archery-training", 1},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 3,
	stamina = 8,
	require = techs_dex_req1,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1.1, 2.2)})
		return true
	end,
	info = function(self, t)
		return ([[稳 固 的 射 击， 造 成 %d%% 基 础 伤 害。]]):format(self:combatTalentWeaponDamage(t, 1.1, 2.2) * 100)
	end,
}

newTalent{
	name = "Aim",
	type = {"technique/archery-training", 2},
	mode = "sustained",
	points = 5,
	require = techs_dex_req2,
	cooldown = 8,
	sustain_stamina = 20,
	no_energy = true,
	tactical = { BUFF = 2 },
	no_npc_use = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	getCombatVals = function(self, t)
		local vals = {speed = -self:combatTalentLimit(t, 0.5, 0.05, 0.25), -- Limit < 50% speed loss
			crit =  self:combatScale(self:getTalentLevel(t) * self:getDex(10, true), 7, 0, 57, 50),
			atk = self:combatScale(self:getTalentLevel(t) * self:getDex(10, true), 4, 0, 54, 50),
			dam = self:combatScale(self:getTalentLevel(t) * self:getDex(10, true), 4, 0, 54, 50),
			apr = self:combatScale(self:getTalentLevel(t) * self:getDex(10, true), 3, 0, 53, 50)}
		return vals
	end,
	activate = function(self, t)
		local weapon = self:hasArcheryWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Aim without a bow or sling!")
			return nil
		end

		if self:isTalentActive(self.T_RAPID_SHOT) then self:forceUseTalent(self.T_RAPID_SHOT, {ignore_energy=true}) end
		local vals = t.getCombatVals(self, t)
		return {
			speed = self:addTemporaryValue("combat_physspeed", vals.speed),
			crit = self:addTemporaryValue("combat_physcrit", vals.crit),
			atk = self:addTemporaryValue("combat_dam", vals.atk),
			dam = self:addTemporaryValue("combat_atk", vals.dam),
			apr = self:addTemporaryValue("combat_apr", vals.apr),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("combat_apr", p.apr)
		self:removeTemporaryValue("combat_atk", p.atk)
		self:removeTemporaryValue("combat_dam", p.dam)
		return true
	end,
	info = function(self, t)
		local vals = t.getCombatVals(self, t)
		return ([[你 进 入 心 如 止 水 的 状 态， 专 注 瞄 准， 增 加 你 %d 点 物 理 强 度， %d 点 命 中， %d 点 护 甲 穿 透， %d%% 暴 击 率， 但 是 减 少 你 %d%% 射 速。 
		受 敏 捷 影 响， 此 效 果 有 额 外 加 成。]]):
		format(vals.dam, vals.atk, vals.apr, vals.crit, -vals.speed * 100)
	end,
}

newTalent{
	name = "Rapid Shot",
	type = {"technique/archery-training", 3},
	mode = "sustained",
	points = 5,
	require = techs_dex_req3,
	cooldown = 8,
	sustain_stamina = 20,
	no_energy = true,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	getCombatVals = function(self, t)
		local vals = {speed = self:combatTalentScale(t, 0.1, 0.5, 0.75),
			crit = -self:combatTalentScale(t, 10.4, 20),
			atk = -self:combatTalentScale(t, 10.4, 20, 0.75),
			dam = -self:combatTalentScale(t, 10.4, 20, 0.75)
			}
		return vals
	end,
	activate = function(self, t)
		local weapon = self:hasArcheryWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Rapid Shot without a bow or sling!")
			return nil
		end

		if self:isTalentActive(self.T_AIM) then self:forceUseTalent(self.T_AIM, {ignore_energy=true}) end
		local vals = t.getCombatVals(self, t)
		return {
			speed = self:addTemporaryValue("combat_physspeed", vals.speed),
			atk = self:addTemporaryValue("combat_dam", vals.atk),
			dam = self:addTemporaryValue("combat_atk", vals.dam),
			crit = self:addTemporaryValue("combat_physcrit", vals.crit),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("combat_dam", p.dam)
		self:removeTemporaryValue("combat_atk", p.atk)
		return true
	end,
	info = function(self, t)
		local vals = t.getCombatVals(self, t)
		return ([[你 转 换 成 一 种 流 畅 和 快 速 的 射 击 姿 势， 增 加 你 %d%% 射 击 速 度 但 减 少 %d 点 命 中， %d 物 理 强 度 和 %d%% 暴 击 率。]]):
		format(vals.speed*100, vals.atk, vals.dam, vals.crit)
	end,
}

newTalent{
	name = "Relaxed Shot",
	type = {"technique/archery-training", 4},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 14,
	require = techs_dex_req4,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 }, STAMINA = 1 },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 0.5, 1.1)})
		self:incStamina(12 + self:getTalentLevel(t) * 8)
		return true
	end,
	info = function(self, t)
		return ([[你 未 尽 全 力 射 出 一 支 箭， 造 成 %d%% 伤 害。 
		这 个 短 暂 的 放 松 允 许 你 回 复 %d 体 力。]]):format(self:combatTalentWeaponDamage(t, 0.5, 1.1) * 100, 12 + self:getTalentLevel(t) * 8)
	end,
}

-------------------------------- Utility -----------------------------------

newTalent{
	name = "Flare",
	type = {"technique/archery-utility", 1},
	no_energy = "fake",
	points = 5,
	cooldown = 15,
	stamina = 15,
	range = archery_range,
	radius = function(self, t)
		local rad = 1
		if self:getTalentLevel(t) >= 3 then rad = rad + 1 end
		if self:getTalentLevel(t) >= 5 then rad = rad + 1 end
		return rad
	end,
	require = techs_dex_req1,
	tactical = { ATTACKAREA = { FIRE = 2 }, DISABLE = { blind = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", x=x, y=y, radius=self:getTalentRadius(t), range=self:getTalentRange(t)}
	end,
	archery_onreach = function(self, t, x, y)
		local tg = self:getTalentTarget(t)
		self:project(tg, x, y, DamageType.LITE, 1)
		if self:getTalentLevel(t) >= 3 then
			tg.selffire = false
			self:project(tg, x, y, DamageType.BLINDPHYSICAL, 3)
		end
		game.level.map:particleEmitter(x, y, tg.radius, "ball_light", {radius=tg.radius})
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 0.5, 1.2), damtype=DamageType.FIRE})
		return true
	end,
	info = function(self, t)
		local rad = 1
		if self:getTalentLevel(t) >= 3 then rad = rad + 1 end
		if self:getTalentLevel(t) >= 5 then rad = rad + 1 end
		return ([[你 射 出 一 支 燃 烧 的 箭 矢 造 成 %d%% 火 焰 伤 害 并 照 亮 %d 码 半 径。 
		在 等 级 3 时， 会 有 概 率 致 盲 目 标 3 回 合。]]):
		format(self:combatTalentWeaponDamage(t, 0.5, 1.2) * 100, rad)
	end,
}

newTalent{
	name = "Crippling Shot",
	type = {"technique/archery-utility", 2},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
	require = techs_dex_req2,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = 1 },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	archery_onhit = function(self, t, target, x, y)
		target:setEffect(target.EFF_SLOW, 7, {power=util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4), apply_power=self:combatAttack()})
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.5)})
		return true
	end,
	info = function(self, t)
		return ([[你 射 出 一 支 致 残 矢， 造 成 %d%% 伤 害 并 减 少 目 标 %d%% 速 度 持 续 7 回 合。 
		受 命 中 影 响， 伤 害 和 命 中 率 有 额 外 加 成。 ]]):format(self:combatTalentWeaponDamage(t, 1, 1.5) * 100, util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4) * 100)
	end,
}

newTalent{
	name = "Pinning Shot",
	type = {"technique/archery-utility", 3},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
	require = techs_dex_req3,
	range = archery_range,
	tactical = { ATTACK = { weapon = 1 }, DISABLE = { pin = 2 } },
	requires_target = true,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 5.5)) end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, t.getDur(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists!", target.name:capitalize())
		end
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1, 1.4)})
		return true
	end,
	info = function(self, t)
		return ([[你 射 出 一 支 束 缚 之 箭 对 目 标 造 成 %d%% 伤 害 并 束 缚 目 标 %d 回 合。 
		受 你 敏 捷 影 响， 定 身 概 率 有 额 外 加 成。]])
		:format(self:combatTalentWeaponDamage(t, 1, 1.4) * 100,
		t.getDur(self, t))
	end,
}

newTalent{
	name = "Scatter Shot",
	type = {"technique/archery-utility", 4},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 14,
	stamina = 15,
	require = techs_dex_req4,
	range = archery_range,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	tactical = { ATTACKAREA = { weapon = 2 }, DISABLE = { stun = 3 } },
	requires_target = true,
	target = function(self, t)
		local weapon, ammo = self:hasArcheryWeapon()
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), display=self:archeryDefaultProjectileVisual(weapon, ammo)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	getStunDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("stun") then
			target:setEffect(target.EFF_STUNNED, t.getStunDur(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the stunning shot!", target.name:capitalize())
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local targets = self:archeryAcquireTargets(tg, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, tg, {mult=self:combatTalentWeaponDamage(t, 0.5, 1.5)})
		return true
	end,
	info = function(self, t)
		return ([[你 在 %d 码 半 径 区 域 内 射 出 多 支 呈 环 形 分 布 的 箭 矢， 造 成 %d%% 伤 害 并 震 慑 你 的 目 标 %d 回 合。 
		受 命 中 影 响， 震 慑 概 率 有 额 外 加 成。]])
		:format(self:getTalentRadius(t), self:combatTalentWeaponDamage(t, 0.5, 1.5) * 100, t.getStunDur(self,t))
	end,
}

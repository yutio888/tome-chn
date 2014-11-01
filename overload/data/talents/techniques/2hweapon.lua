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
	name = "Death Dance",
	type = {"technique/2hweapon-offense", 1},
	require = techs_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 30,
	tactical = { ATTACKAREA = { weapon = 3 } },
	range = 0,
	radius = 1,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Death Dance without a two-handed weapon!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1.4, 2.1))
			end
		end)

		self:addParticles(Particles.new("meleestorm", 1, {}))

		return true
	end,
	info = function(self, t)
		return ([[原 地 旋 转， 伸 展 你 的 武 器， 伤 害 你 周 围 所 有 的 目 标， 造 成 %d%% 武 器 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 1.4, 2.1))
	end,
}

newTalent{
	name = "Berserker",
	type = {"technique/2hweapon-offense", 2},
	require = techs_req2,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_stamina = 40,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getDam = function(self, t) return self:combatScale(self:getStr(7, true) * self:getTalentLevel(t), 5, 0, 40, 35)end,
	getAtk = function(self, t) return self:combatScale(self:getDex(7, true) * self:getTalentLevel(t), 5, 0, 40, 35) end ,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.17, 0.5) end,
	activate = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Berserker without a two-handed weapon!")
			return nil
		end

		return {
			armor = self:addTemporaryValue("combat_armor", -10),
			stun = self:addTemporaryValue("stun_immune", t.getImmune(self, t)),
			pin = self:addTemporaryValue("pin_immune", t.getImmune(self, t)),
			dam = self:addTemporaryValue("combat_dam", t.getDam(self, t)),
			atk = self:addTemporaryValue("combat_atk", t.getAtk(self, t)),
			def = self:addTemporaryValue("combat_def", -10),
		}
	end,

	deactivate = function(self, t, p)
		self:removeTemporaryValue("stun_immune", p.stun)
		self:removeTemporaryValue("pin_immune", p.pin)
		self:removeTemporaryValue("combat_def", p.def)
		self:removeTemporaryValue("combat_armor", p.armor)
		self:removeTemporaryValue("combat_atk", p.atk)
		self:removeTemporaryValue("combat_dam", p.dam)
		return true
	end,
	info = function(self, t)
		return ([[进 入 狂 暴 的 战 斗 状 态， 以 减 少 10 点 闪 避 和 10 点 护 甲 的 代 价 增 加 %d 点 命 中 和 %d 点 物 理 强 度。 
		开 启 狂 暴 时 你 无 人 能 挡， 增 加 %d%% 震 慑 和 定 身 抵 抗。 
		受 敏 捷 影 响， 命 中 有 额 外 加 成； 
		受 力 量 影 响， 物 理 强 度 有 额 外 加 成。]]):
		format( t.getAtk(self, t), t.getDam(self, t), t.getImmune(self, t)*100)
	end,
}

newTalent{
	name = "Warshout",
	type = {"technique/2hweapon-offense",3},
	require = techs_req3,
	points = 5,
	random_ego = "attack",
	message = function(self) if self.subtype == "rodent" then return "@Source@ uses Warsqueak." else return "@Source@ uses Warshout." end end ,
	stamina = 30,
	cooldown = 18,
	tactical = { ATTACKAREA = { confusion = 1 }, DISABLE = { confusion = 3 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Warshout without a two-handed weapon!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.CONFUSION, {
			dur=t.getDuration(self, t),
			dam=50+self:getTalentLevelRaw(t)*10,
			power_check=function() return self:combatPhysicalpower() end,
			resist_check=self.combatPhysicalResist,
		})
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "directional_shout", {life=8, size=3, tx=x-self.x, ty=y-self.y, distorion_factor=0.1, radius=self:getTalentRadius(t), nb_circles=8, rm=0.8, rM=1, gm=0.4, gM=0.6, bm=0.1, bM=0.2, am=1, aM=1})
		return true
	end,
	info = function(self, t)
		return ([[在 你 的 正 前 方 大 吼 形 成 %d 码 半 径 的 扇 形 战 争 怒 吼。 任 何 在 其 中 的 目 标 会 被 混 乱 %d 回 合。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Death Blow",
	type = {"technique/2hweapon-offense", 4},
	require = techs_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 15,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Death Blow without a two-handed weapon!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local inc = self.stamina / 2
		if self:getTalentLevel(t) >= 4 then
			self.combat_dam = self.combat_dam + inc
		end
		self.turn_procs.auto_phys_crit = true
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3))

		if self:getTalentLevel(t) >= 4 then
			self.combat_dam = self.combat_dam - inc
			self:incStamina(-self.stamina / 2)
		end
		self.turn_procs.auto_phys_crit = nil

		-- Try to insta-kill
		if hit then
			if target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 5 - self:getTalentLevel(t) / 2) and target:canBe("instakill") and target.life > 0 and target.life < target.max_life * 0.2 then
				-- KILL IT !
				game.logSeen(target, "%s feels the pain of the death blow!", target.name:capitalize())
				target:die(self)
			elseif target.life > 0 and target.life < target.max_life * 0.2 then
				game.logSeen(target, "%s resists the death blow!", target.name:capitalize())
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[试 图 施 展 一 次 致 命 打 击， 造 成 %d%% 武 器 伤 害， 本 次 攻 击 自 动 变 成 暴 击。 
		如 果 打 击 后 目 标 生 命 值 低 于 20%% 则 有 可 能 直 接 杀 死。 
		在 等 级 4 时 会 消 耗 剩 余 的 耐 力 值 的 一 半 并 增 加 100%% 所 消 耗 耐 力 值 的 伤 害。 
		受 物 理 强 度 影 响， 目 标 即 死 的 概 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}

-----------------------------------------------------------------------------
-- Cripple
-----------------------------------------------------------------------------
newTalent{
	name = "Stunning Blow",
	type = {"technique/2hweapon-cripple", 1},
	require = techs_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 8,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Stunning Blow without a two-handed weapon!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1, 1.5))

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the stunning blow!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 会 震 慑 %d 回 合。 
		受 物 理 强 度 影 响， 震 慑 概 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Sunder Armour",
	type = {"technique/2hweapon-cripple", 2},
	require = techs_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 12,
	requires_target = true,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getShatter = function(self, t) return self:combatTalentLimit(t, 100, 10, 85) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	getArmorReduc = function(self, t) return self:combatTalentScale(t, 5, 25, 0.75) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Sunder Armour without a two-handed weapon!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1, 1.5))

		-- Try to Sunder !
		if hit then
			target:setEffect(target.EFF_SUNDER_ARMOUR, t.getDuration(self, t), {power=t.getArmorReduc(self,t), apply_power=self:combatPhysicalpower()})

			if rng.percent(t.getShatter(self, t)) then
				local effs = {}

				-- Go through all shield effects
				for eff_id, p in pairs(target.tmp) do
					local e = target.tempeffect_def[eff_id]
					if e.status == "beneficial" and e.subtype and e.subtype.shield then
						effs[#effs+1] = {"effect", eff_id}
					end
				end

				for i = 1, 1 do
					if #effs == 0 then break end
					local eff = rng.tableRemove(effs)

					if eff[1] == "effect" then
						game.logSeen(self, "#CRIMSON#%s shatters %s shield!", self.name:capitalize(), target.name)
						target:removeEffect(eff[2])
					end
				end
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 护 甲 和 豁 免 会 减 少 %d 持 续 %d 回 合。 
		同 时， 如 果 目 标 被 临 时 伤 害 护 盾 保 护 ， 有 %d%% 几 率 使 之 破 碎。
		受 物 理 强 度 影 响， 护 甲 减 值 有 额 外 增 加。 ]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5),t.getArmorReduc(self, t), t.getDuration(self, t), t.getShatter(self, t))
	end,
}

newTalent{
	name = "Sunder Arms",
	type = {"technique/2hweapon-cripple", 3},
	require = techs_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 12,
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Sunder Arms without a two-handed weapon!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1, 1.5))

		-- Try to Sunder !
		if hit then
			target:setEffect(target.EFF_SUNDER_ARMS, t.getDuration(self, t), {power=3*self:getTalentLevel(t), apply_power=self:combatPhysicalpower()})
		end

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 武 器 攻 击 目 标 并 造 成 %d%% 伤 害。 如 果 此 次 攻 击 命 中， 则 目 标 命 中 会 减 少 %d 持 续 %d 回 合。 
		受 物 理 强 度 影 响， 命 中 减 值 有 额 外 加 成。 ]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Blood Frenzy",
	type = {"technique/2hweapon-cripple", 4},
	require = techs_req4,
	points = 5,
	mode = "sustained",
	cooldown = 15,
	sustain_stamina = 70,
	no_energy = true,
	tactical = { BUFF = 1 },
	do_turn = function(self, t)
		if self.blood_frenzy > 0 then
			self.blood_frenzy = math.max(self.blood_frenzy - 2, 0)
		end
	end,
	on_pre_use = function(self, t, silent) if not self:hasTwoHandedWeapon() then if not silent then game.logPlayer(self, "You require a two handed weapon to use this talent.") end return false end return true end,
	bonuspower = function(self,t) return self:combatTalentScale(t, 2, 10, 0.5, 0, 2) end, -- called by _M:die function in mod.class.Actor.lua
	activate = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Blood Frenzy without a two-handed weapon!")
			return nil
		end
		self.blood_frenzy = 0
		return {
			regen = self:addTemporaryValue("stamina_regen", -2),
		}
	end,
	deactivate = function(self, t, p)
		self.blood_frenzy = nil
		self:removeTemporaryValue("stamina_regen", p.regen)
		return true
	end,
	info = function(self, t)
		return ([[进 入 血 之 狂 暴 状 态， 快 速 消 耗 体 力（ -4 体 力 / 回 合）。 每 次 你 在 血 之 狂 暴 状 态 下 杀 死 一 个 敌 人， 你 可 以 获 得 %d 物 理 强 度 增 益。 
		每 回 合 增 益 减 2。]]):
		format(t.bonuspower(self,t))
	end,
}


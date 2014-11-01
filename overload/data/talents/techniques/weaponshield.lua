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

----------------------------------------------------------------------
-- Offense
----------------------------------------------------------------------

newTalent{
	name = "Shield Pummel",
	type = {"technique/shield-offense", 1},
	require = techs_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 8,
	requires_target = true,
	tactical = { ATTACK = 1, DISABLE = { stun = 3 } },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	getStunDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Pummel without a shield!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attackTargetWith(target, shield.special_combat, nil, self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
		local speed, hit = self:attackTargetWith(target, shield.special_combat, nil, self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getStunDuration(self, t), {apply_power=self:combatAttackStr()})
			else
				game.logSeen(target, "%s resists the shield bash!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[连 续 使 用 2 次 盾 牌 攻 击 敌 人 并 分 别 造 成 %d%% 和 %d%% 盾 牌 伤 害。
		如 果 此 技 能 连 续 命 中 目 标 2 次 则 目 标 会 被 震 慑 %d 回 合。
		受 命 中 和 力 量 影 响， 震 慑 几 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		100 * self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		t.getStunDuration(self, t))
	end,
}

newTalent{
	name = "Riposte",
	type = {"technique/shield-offense", 2},
	require = techs_req2,
	mode = "passive",
	points = 5,
	getDurInc = function(self, t)  -- called in effect "BLOCKING" in mod.data\timed_effects\physical.lua
		return math.ceil(self:combatTalentScale(t, 0.15, 1.15))
	end,
	getCritInc = function(self, t)
		return self:combatTalentIntervalDamage(t, "dex", 10, 50)
	end,
	info = function(self, t)
		local inc = t.getDurInc(self, t)
		return ([[通 过 以 下 方 法 提 高 你 的 反 击 能 力：
		当 出 现 不 完 全 格 挡 时 也 可 以 进 行 反 击。
		增 加 攻 击 者 反 击DEBUFF的 持 续 时 间 %d。
		你 对 可 反 击 目 标 的 反 击 次 数 增 加 %d 次。
		增 加 %d%% 反 击 暴 击 率。
		受 敏 捷 影 响， 此 暴 击 率 按 比 例 加 成。]]):format(inc, inc, t.getCritInc(self, t))
	end,
}

newTalent{
	name = "Shield Slam",
	type = {"technique/shield-offense", 3},
	require = techs_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	stamina = 15,
	requires_target = true,
	getShieldDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.1, 0.8, self:getTalentLevel(self.T_SHIELD_EXPERTISE)) end,
	tactical = { ATTACK = 2}, -- is there a way to make this consider the free Block?
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Slam without a shield!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local damage = t.getShieldDamage(self, t)
		self:forceUseTalent(self.T_BLOCK, {ignore_energy=true, ignore_cd = true, silent = true})
		
		self:attackTargetWith(target, shield.special_combat, nil, damage)
		self:attackTargetWith(target, shield.special_combat, nil, damage)
		self:attackTargetWith(target, shield.special_combat, nil, damage)

		return true
	end,
	info = function(self, t)
		local damage = t.getShieldDamage(self, t)*100
		return ([[用 盾 牌 拍 击 目 标 3 次， 造 成 %d%% 武 器 伤 害 ， 然 后 迅 速 进 入 格 挡 状 态。
		该 格 挡 不 占 用 盾 牌 的 格 挡 技 能 CD。]])
		:format(damage)
	end,
}

newTalent{
	name = "Assault",
	type = {"technique/shield-offense", 4},
	require = techs_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 16,
	requires_target = true,
	tactical = { ATTACK = 4 },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Assault without a shield!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- First attack with shield
		local speed, hit = self:attackTargetWith(target, shield.special_combat, nil, self:combatTalentWeaponDamage(t, 1, 1.5, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Second & third attack with weapon
		if hit then
			self.turn_procs.auto_phys_crit = true
			self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.5), true)
			self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.5), true)
			self.turn_procs.auto_phys_crit = nil
		end

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 盾 牌 攻 击 目 标 并 造 成 %d%% 伤 害， 如 果 此 次 攻 击 命 中， 那 么 你 将 会 发 动 2 次 武 器 暴 击， 每 击 分 别 造 成 %d%% 基 础 伤 害。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.5, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), 100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}


----------------------------------------------------------------------
-- Defense
----------------------------------------------------------------------
newTalent{
	name = "Shield Wall",
	type = {"technique/shield-defense", 1},
	require = techs_req1,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 30,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	getarmor = function(self,t) return self:combatScale((1+self:getDex(4))*self:getTalentLevel(t), 5, 0, 30, 25, 0.375) + self:combatTalentScale(self:getTalentLevel(self.T_SHIELD_EXPERTISE), 1, 5, 0.75) end, -- Scale separately with talent level and talent level of Shield Expertise
	getDefense = function(self, t)
		return self:combatScale((1 + self:getDex(4, true)) * self:getTalentLevel(t), 6.4, 1.4, 30, 25) + self:combatTalentScale(self:getTalentLevel(self.T_SHIELD_EXPERTISE), 2, 10, 0.75)
	end,
	stunKBresist = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.50) end, -- Limit <100%
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Shield Wall without a shield!")
			return nil
		end
		return {
			stun = self:addTemporaryValue("stun_immune", t.stunKBresist(self, t)),
			knock = self:addTemporaryValue("knockback_immune", t.stunKBresist(self, t)),
			dam = self:addTemporaryValue("inc_damage", {[DamageType.PHYSICAL]=-20}),
			def = self:addTemporaryValue("combat_def", t.getDefense(self, t)),
			armor = self:addTemporaryValue("combat_armor", t.getarmor(self,t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_def", p.def)
		self:removeTemporaryValue("combat_armor", p.armor)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("stun_immune", p.stun)
		self:removeTemporaryValue("knockback_immune", p.knock)
		return true
	end,
	info = function(self, t)
		return ([[进 入 防 御 姿 态， 提 高 %d 闪 避 和 %d 护 甲 值（ 但 会 减 少 你 20%% 物 理 伤 害）。 
		受 敏 捷 影 响， 闪 避 和 护 甲 值 增 益 有 额 外 加 成。 
		另 外 它 同 时 也 会 提 供 震 慑 和 击 退 抗 性（ %d%% ）。]]):
		format(t.getDefense(self, t), t.getarmor(self, t), 100*t.stunKBresist(self, t))
	end,
}

newTalent{
	name = "Repulsion",
	type = {"technique/shield-defense", 2},
	require = techs_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 30,
	tactical = { ESCAPE = { knockback = 2 }, DEFEND = { knockback = 0.5 } },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	range = 0,
	radius = 1,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDuration = function(self, t) return math.floor(self:combatStatScale("str", 3.8, 11)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Repulsion without a shield!")
			return nil
		end

		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target then
				if target:checkHit(self:combatAttack(shield.special_combat), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then --Deprecated checkHit call
					target:knockback(self.x, self.y, t.getDist(self, t))
					if target:canBe("stun") then target:setEffect(target.EFF_DAZED, t.getDuration(self, t), {}) end
				else
					game.logSeen(target, "%s resists the knockback!", target.name:capitalize())
				end
			end
		end)

		self:addParticles(Particles.new("meleestorm2", 1, {radius=2}))

		return true
	end,
	info = function(self, t)
		return ([[使 你 的 敌 人 聚 集 在 你 的 盾 牌 上， 然 后 将 你 的 力 量 集 中 于 一 点， 猛 力 地 推 开 他 们 %d 码 距 离。 
		此 外 所 有 怪 物 被 击 退 时 也 会 被 眩 晕 %d 回 合。 
		受 技 能 等 级 影 响， 距 离 有 额 外 加 成； 受 力 量 影 响， 眩 晕 持 续 时 间 有 额 外 加 成。]]):format(t.getDist(self, t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Shield Expertise",
	type = {"technique/shield-defense", 3},
	require = techs_req3,
	mode = "passive",
	points = 5,
	on_learn = function(self, t)
		self.combat_physresist = self.combat_physresist + 4
		self.combat_spellresist = self.combat_spellresist + 2
	end,
	on_unlearn = function(self, t)
		self.combat_physresist = self.combat_physresist - 4
		self.combat_spellresist = self.combat_spellresist - 2
	end,
	info = function(self, t)
		return ([[当 你 用 盾 牌 攻 击 时 提 高 你 的 伤 害 和 闪 避， 并 提 高 法 术 豁 免（ +%d ） 和 物 理 豁 免（ +%d ）。]]):format(2 * self:getTalentLevelRaw(t), 4 * self:getTalentLevelRaw(t))
	end,
}

newTalent{
	name = "Last Stand",
	type = {"technique/shield-defense", 4},
	require = techs_req4,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 50,
	tactical = { DEFEND = 3 },
	no_npc_use = true,
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	lifebonus = function(self,t, base_life) -- Scale bonus with max life
		return self:combatTalentStatDamage(t, "con", 30, 500) + (base_life or self.max_life) * self:combatTalentLimit(t, 1, 0.02, 0.10) -- Limit <100% of base life
	end,
	getDefense = function(self, t) return self:combatScale(self:getDex(4, true) * self:getTalentLevel(t), 5, 0, 25, 20) end,
	activate = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Last Stand without a shield!")
			return nil
		end
		local hp = t.lifebonus(self,t)
		local ret = {
			base_life = self.max_life,
			max_life = self:addTemporaryValue("max_life", hp),
			def = self:addTemporaryValue("combat_def", t.getDefense(self, t)),
			nomove = self:addTemporaryValue("never_move", 1),
			dieat = self:addTemporaryValue("die_at", -hp),
			extra_life = self:addTemporaryValue("life", hp), -- Avoid healing effects
		}
--		if not self:attr("talent_reuse") then
--			self:heal(hp)
--		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_def", p.def)
		self:removeTemporaryValue("max_life", p.max_life)
		self:removeTemporaryValue("never_move", p.nomove)
		self:removeTemporaryValue("die_at", p.dieat)
		self:removeTemporaryValue("life", p.extra_life)
		return true
	end,
	info = function(self, t)
		local hp = self:isTalentActive(self.T_LAST_STAND)
		if hp then
			hp = t.lifebonus(self, t, hp.base_life)
		else
			hp = t.lifebonus(self,t)
		end
		return ([[在 走 投 无 路 的 局 面 下， 你 鼓 舞 自 己， 提 高 %d 点 闪 避 和 %d 点 当 前 及 最 大 生 命 值 ， 但 是 这 会 使 你 无 法 移 动。 
		你 的 坚 守 让 你 集 中 精 力 于 对 手 的 每 一 次 进 攻， 让 你 能 承 受 原 本 致 命 的 伤 害。 你 只 有 在 生 命 值 下 降 到 -%d 时 才 会 死 亡。 但 是 当 你 生 命 值 降 到 0 时， 你 无 法 看 到 你 还 剩 多 少 生 命 值。 
		受 敏 捷 影 响， 闪 避 增 益 有 额 外 加 成； 
		受 体 质 和 最 大 生 命 值 影 响， 生 命 值 增 益 有 额 外 加 成。]]):
		format(t.getDefense(self, t), hp, hp)
	end,
}


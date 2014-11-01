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
	name = "Guided Shot",
	type = {"psionic/psi-archery", 1},
	require = psi_cun_high1,
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	psi = 10,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	range = archery_range,
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "You require a bow for this talent.") end return false end return true end,
	shot_boost = function(self, t) return self:combatTalentScale(t, 40, 80, 0.75) end,
	use_psi_archery = function(self, t)
		local pf_weapon = self:getInven("PSIONIC_FOCUS")[1]
		if pf_weapon and pf_weapon.archery then
			return true
		else
			return false
		end
	end,
	action = function(self, t)
		local inc = t.shot_boost(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {atk = inc, crit_chance = inc, use_psi_archery = t.use_psi_archery(self,t)})
		return true
	end,
	info = function(self, t)
		return ([[射 出 一 支 导 引 箭 精 确 的 飞 向 敌 人。 造 成 普 通 伤 害， 但 是 命 中 和 暴 击 率 提 高 %d 。]]):format(t.shot_boost(self, t))
	end,
}

newTalent{
	name = "Augmented Shot",
	type = {"psionic/psi-archery", 2},
	no_energy = "fake",
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 15,
	require = psi_cun_high2,
	range = archery_range,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "You require a bow for this talent.") end return false end return true end,
	apr_boost = function(self, t) return math.floor(self:combatTalentScale(t, 20, 60)) end,
	dam_mult = function(self, t)
		return self:combatTalentWeaponDamage(t, 1.5, 2.5)
	end,
	use_psi_archery = function(self, t)
		local pf_weapon = self:getInven("PSIONIC_FOCUS")[1]
		if pf_weapon and pf_weapon.archery then
			return true
		else
			return false
		end
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=t.dam_mult(self, t), apr = t.apr_boost(self, t), use_psi_archery = t.use_psi_archery(self,t)})
		return true
	end,
	info = function(self, t)
		return ([[使 用 精 神 超 能 力 值 以 增 强 弓 的 耐 久 和 张 力， 使 射 出 的 箭 具 有 无 与 伦 比 的 威 力。 增 加 %d 点 护 甲 穿 透 并 造 成 %d%% 伤 害。]]):format(t.apr_boost(self, t), t.dam_mult(self, t) * 100)
	end,
}

newTalent{
	name = "Thought-quick Shot",
	type = {"psionic/psi-archery", 3},
	require = psi_cun_high3,
	no_energy = true,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t)
		return math.ceil(math.max(18 - 2 * self:getTalentLevel(t), 5))
	end,
	psi = 20,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	range = archery_range,
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "You require a bow for this talent.") end return false end return true end,
	use_psi_archery = function(self, t)
		local pf_weapon = self:getInven("PSIONIC_FOCUS")[1]
		if pf_weapon and pf_weapon.archery then
			return true
		else
			return false
		end
	end,
	action = function(self, t)
		local old = self.energy.value
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {use_psi_archery = t.use_psi_archery(self,t)})
		self.energy.value = old
		return true
	end,
	info = function(self, t)
		return ([[用 飞 翔 的 思 绪 射 出 一 支 箭 矢。 此 攻 击 不 消 耗 回 合 数。 随 着 技 能 等 级 提 高， 冷 却 时 间 缩 短。]])
	end,
}

newTalent{
	name = "Masterful Telekinetic Archery",
	type = {"psionic/psi-archery", 4},
	require = psi_cun_high4,
	points = 5,
	psi = 30,
	cooldown = 50,
	range = archery_range,
	direct_hit = true,
	tactical = { BUFF = 3 },
	duration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	do_tkautoshoot = function(self, t)
		if game.zone.wilderness then return end

		local targnum = 1
		if self:hasEffect(self.EFF_PSIFRENZY) then targnum = self:callTalent(self.T_FRENZIED_PSIFIGHTING, "getTargNum")  end
		local speed, hit = nil, false
		local sound, sound_miss = nil, nil
		--dam = self:getTalentLevel(t)
		local target
		local minDistance = 9999
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
				tgts[#tgts+1] = a
				local distance = core.fov.distance(self.x, self.y, a.x, a.y)
				if (not target or distance < minDistance) and self:hasLOS(a.x, a.y) then
					target = a
					minDistance = distance
				end
			end
		end end


		--local tg = {type="hit", range=10, talent=t}
		for i = 1, targnum do
			if #tgts <= 0 then break end

			local a, id = rng.table(tgts)
			--local a, id = tgts[i]
			--local targets = self:archeryAcquireTargets(target)
			table.remove(tgts, id)
			local weapon, ammo = self:hasArcheryWeapon()
			local targets = {}
			local am
			if not ammo.infinite then
					if ammo.combat.shots_left <= 0 then return nil end -- Bug fix
					ammo.combat.shots_left = ammo.combat.shots_left - 1
					am = ammo
			else
				am = ammo
			end
			if am then
				targets = {{x=a.x, y=a.y, ammo=am.combat}}
			end

			if self:getInven(self.INVEN_PSIONIC_FOCUS) then
				for i, o in ipairs(self:getInven(self.INVEN_PSIONIC_FOCUS)) do
					if o.combat and o.archery then
						print("[PSI ATTACK] attacking with", o.name)
						self:archeryShoot(targets, t, nil, {use_psi_archery = true})
						--local s, h = self:attackTargetWith(a, o.combat, nil, 1)
						--speed = math.max(speed or 0, s)
						--hit = hit or h
						--if hit and not sound then sound = o.combat.sound
						--elseif not hit and not sound_miss then sound_miss = o.combat.sound_miss end
						if not o.combat.no_stealth_break then break_stealth = true end
						self:breakStepUp()
					end
				end
			else
				return nil
			end

		end
		--return hit
	end,
	action = function (self, t)
		if not self:getInven("PSIONIC_FOCUS") then return end
		local tkweapon = self:getInven("PSIONIC_FOCUS")[1]
		if type(tkweapon) == "boolean" then tkweapon = nil end
		if not tkweapon or not tkweapon.archery then
			game.logPlayer(self, "You cannot do that without a telekinetically-wielded bow.")
			return nil
		end
		self:setEffect(self.EFF_MASTERFUL_TELEKINETIC_ARCHERY, t.duration(self, t), {power=1})
		return true
	end,
	info = function(self, t)
		local duration = t.duration(self, t)
		local atk = 0
		local dam = 0
		local apr = 0
		local crit = 0
		local speed = 1
		local inven = self:getInven("PSIONIC_FOCUS")
		local o = inven and inven[1]
		if type(o) == "boolean" then o = nil end
		if not o then
			return ([[你 暂 时 分 出 一 部 分 精 神 去 控 制 念 动 之 弓。 它 会 在 %d 回 合 内 自 动 攻 击 1 个 目 标。 
		 念 动 弓 使 用 意 志 和 灵 巧 来 代 替 力 量 和 敏 捷 决 定 攻 击。 
		 你 暂 时 还 没 有 装 备 任 何 念 动 武 器。]]):format(duration)
		end
		if o.type == "weapon" then
			self:attr("use_psi_combat", 1)
			atk = self:combatAttack(o.combat)
			dam = self:combatDamage(o.combat)
			apr = self:combatAPR(o.combat)
			crit = self:combatCrit(o.combat)
			speed = self:combatSpeed(o.combat)
			self:attr("use_psi_combat ", -1)
		end
		return ([[你 暂 时 分 出 一 部 分 精 神 去 控 制 念 动 之 弓。 它 会 在 %d 回 合 内 自 动 攻 击 1 个 目 标。 
		 念 动 弓 使 用 意 志 和 灵 巧 来 代 替 力 量 和 敏 捷 决 定 攻 击。 
		 战 斗 属 性： 
		 命 中： %d
		 伤 害： %d
		 护 甲 穿 透： %d
		 暴 击 率： %0.2f
		 攻 击 速 度： %0.2f]]):
		format(duration, atk, dam, apr, crit, speed)
	end,
}

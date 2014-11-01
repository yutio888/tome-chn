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
local function aura_strength(self, t)
	return self:combatTalentMindDamage(t, 10, 40)
end

local function aura_spike_strength(self, t)
	return aura_strength(self, t) * 10
end

local function aura_mastery(self, t)
	return 9 + self:getTalentLevel(t)
end

local function aura_range(self, t)
	-- Spiked ability
	if self:isTalentActive(t.id) then
		if type(t.getSpikedRange) == "function" then return t.getSpikedRange(self, t) end
		return t.getSpikedRange
	-- Normal ability
	else
		if type(t.getNormalRange) == "function" then return t.getNormalRange(self, t) end
		return t.getNormalRange
	end
end

local function aura_radius(self, t)
	-- Spiked ability
	if self:isTalentActive(t.id) then
		if type(t.getSpikedRadius) == "function" then return t.getSpikedRadius(self, t) end
		return t.getSpikedRadius
	-- Normal ability
	else
		if type(t.getNormalRadius) == "function" then return t.getNormalRadius(self, t) end
		return t.getNormalRadius
	end
end

local function aura_target(self, t)
	-- Spiked ability
	if self:isTalentActive(t.id) then
		if type(t.getSpikedTarget) == "function" then return t.getSpikedTarget(self, t) end
		return t.getSpikedTarget
	-- Normal ability
	else
		if type(t.getNormalTarget) == "function" then return t.getNormalTarget(self, t) end
		return t.getNormalTarget
	end
end

newTalent{
	name = "Kinetic Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req1, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	tactical = { ATTACKAREA = { PHYSICAL = 2 } },
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_THERMAL_AURA) and self:isTalentActive(self.T_CHARGED_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t) return 6 end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t)
		return 0
	end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_TELEKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="beam", nolock=true, range=t.getSpikedRange(self, t), talent=t}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	requires_target = function(self, t)
		-- Spiked ability
		if self:isTalentActive(t.id) and self:getPsi() > t.getSpikeCost(self, t) then
			return true
		-- Normal ability
		else
			return false
		end
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)
	end,
	getKnockback = function(self, t)
		return 3 + math.floor(self:getTalentLevel(t))
	end,
	do_kineticaura = function(self, t)
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-dam/mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.PHYSICAL).projector(self, tx, ty, DamageType.PHYSICAL, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local k_dam = t.getAuraStrength(self, t)
		DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, k_dam)
	end,
	activate = function(self, t)
		self.energy.value = self.energy.value + game.energy_to_act * self:combatMindSpeed()
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = t.getSpikedTarget(self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local actor = game.level.map(x, y, Map.ACTOR)
		--if core.fov.distance(self.x, self.y, x, y) == 1 and not actor then return true end
		if core.fov.distance(self.x, self.y, x, y) == 0 then return true end
		self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(0.8*dam, dam)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "matter_beam", {tx=x-self.x, ty=y-self.y})
		self:incPsi(-cost)

		return true
	end,

	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将 你 周 围 的 空 气 充 满 能 量 力 场 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 者 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 物 理 伤 害 。
		 动 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 就 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 物 理 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 动 能 会 释 放 为 一 个 射 程 为 %d 的 射 线 ，击 打 目 标 ，造 成 高 达 %d 的 物 理 伤 害 ，并 击 飞 他 们 。
		 #{bold}#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal}#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam), mast, damDesc(self, DamageType.PHYSICAL, dam), spikecost, t.getSpikedRange(self, t),
		damDesc(self, DamageType.PHYSICAL, spikedam))
	end,
}

newTalent{
	name = "Thermal Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req2, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_KINETIC_AURA) and self:isTalentActive(self.T_CHARGED_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t)
		return 0
	end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t) return 6 end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_PYROKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="cone", range=t.getSpikedRange(self, t), radius=t.getSpikedRadius(self, t), selffire=false, talent=t}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	requires_target = function(self, t)
		-- Spiked ability
		if self:isTalentActive(t.id) and self:getPsi() > t.getSpikeCost(self, t) then
			return true
		-- Normal ability
		else
			return false
		end
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	do_thermalaura = function(self, t)
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-dam/mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.FIRE).projector(self, tx, ty, DamageType.FIRE, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local t_dam = t.getAuraStrength(self, t)
		DamageType:get(DamageType.FIRE).projector(self, target.x, target.y, DamageType.FIRE, t_dam)
	end,
	activate = function(self, t)
		self.energy.value = self.energy.value + game.energy_to_act * self:combatMindSpeed()
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		--if self:isTalentActive(self.T_CONDUIT) then return true end
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = t.getSpikedTarget(self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local actor = game.level.map(x, y, Map.ACTOR)
		--if core.fov.distance(self.x, self.y, x, y) == 1 and not actor then return true end
		if core.fov.distance(self.x, self.y, x, y) == 0 then return true end
		self:project(tg, x, y, DamageType.FIREBURN, self:mindCrit(rng.avg(0.8*dam, dam)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/fire")
		self:incPsi(-cost)
		return true
	end,

	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local rad = t.getSpikedRadius(self,t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将 你 周 围 的 空 气 充 满 火 炉 般 的 热 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 火 焰 伤 害 。
		 热 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 火 焰 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 热 能 会 释 放 为 一 个 范 围 为 %d 的 锥 形 冲 击 。范 围 内 的 任 意 目 标 在 数 轮 中 受 到 高 达 %d 的 火 焰 伤 害 。
		#{bold}#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal}#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.FIRE, dam), mast, damDesc(self, DamageType.FIRE, dam), spikecost, rad,
		damDesc(self, DamageType.FIRE, spikedam))
	end,
}

newTalent{
	name = "Charged Aura",
	type = {"psionic/projection", 1},
	require = psi_wil_req3, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_psi = 10,
	remove_on_zero = true,
	cooldown = 10,
	tactical = { ATTACKAREA = { LIGHTNING = 2 } },
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(self.T_KINETIC_AURA) and self:isTalentActive(self.T_THERMAL_AURA) then
			if not silent then game.logSeen(self, "You may only sustain two auras at once. Aura activation cancelled.") end
			return false
		end
		return true
	end,
	range = aura_range,
	radius = aura_radius,
	target = aura_target,
	getSpikedRange = function(self, t) return 6 end,
	getNormalRange = function(self, t)
		return 0
	end,
	getSpikedRadius = function(self, t)
		return 10
	end,
	getNormalRadius = function(self, t)
		if self:hasEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS) then return 2 end
		return 1
	end,
	getSpikedTarget = function(self, t)
		return {type="ball", range=t.getSpikedRange(self, t), radius=t.getSpikedRadius(self, t), friendlyfire=false}
	end,
	getNormalTarget = function(self, t)
		return {type="ball", range=t.getNormalRange(self, t), radius=t.getNormalRadius(self, t), selffire=false, friendlyfire=false}
	end,
	requires_target = function(self, t)
		-- Spiked ability
		if self:isTalentActive(t.id) and self:getPsi() > t.getSpikeCost(self, t) then
			return true
		-- Normal ability
		else
			return false
		end
	end,
	getSpikeCost = function(self, t)
		return t.sustain_psi*2/3
	end,
	getAuraStrength = function(self, t)
		return aura_strength(self, t)
	end,
	getAuraSpikeStrength = function(self, t)
		return aura_spike_strength(self, t)
	end,
	getNumSpikeTargets = function(self, t)
		return 1 + math.floor(0.5*self:getTalentLevel(t))
	end,
	do_chargedaura = function(self, t)
		local mast = aura_mastery(self, t)
		local dam = t.getAuraStrength(self, t)
		local tg = t.getNormalTarget(self, t)
		self:project(tg, self.x, self.y, function(tx, ty)
			local act = game.level.map(tx, ty, engine.Map.ACTOR)
			if act then
				self:incPsi(-dam/mast)
				self:breakStepUp()
			end
			DamageType:get(DamageType.LIGHTNING).projector(self, tx, ty, DamageType.LIGHTNING, dam)
		end)
	end,
	do_combat = function(self, t, target) -- called by  _M:attackTargetWith in mod.class.interface.Combat.lua
		local c_dam = t.getAuraStrength(self, t)
		DamageType:get(DamageType.LIGHTNING).projector(self, target.x, target.y, DamageType.LIGHTNING, c_dam)
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/thunderstorm")
			self.energy.value = self.energy.value + game.energy_to_act * self:combatMindSpeed()
		return {}
	end,
	deactivate = function(self, t, p)
		if self:attr("save_cleanup") then return true end
		local dam = t.getAuraSpikeStrength(self, t)
		local cost = t.getSpikeCost(self, t)
		--if self:isTalentActive(self.T_CONDUIT) then return true end
		if self:getPsi() <= cost then
			game.logPlayer(self, "The aura dissipates without producing a spike.")
			return true
		end

		local tg = {type="bolt", nolock=true, range=self:getTalentRange(t), talent=t}
		local fx, fy = self:getTarget(tg)
		if not fx or not fy then return nil end
		if core.fov.distance(self.x, self.y, fx, fy) == 0 then return true end

		local nb = t.getNumSpikeTargets(self, t)
		local affected = {}
		local first = nil
		--Here's the part where deactivating the aura fires off a huge chain lightning
		self:project(tg, fx, fy, function(dx, dy)
			print("[Chain lightning] targetting", fx, fy, "from", self.x, self.y)
			local actor = game.level.map(dx, dy, Map.ACTOR)
			if actor and not affected[actor] then
				ignored = false
				affected[actor] = true
				first = actor

				print("[Chain lightning] looking for more targets", nb, " at ", dx, dy, "radius ", 10, "from", actor.name)
				self:project({type="ball", friendlyfire=false, x=dx, y=dy, radius=self:getTalentRange(t), range=0}, dx, dy, function(bx, by)
					local actor = game.level.map(bx, by, Map.ACTOR)
					if actor and not affected[actor] and self:reactionToward(actor) < 0 then
						print("[Chain lightning] found possible actor", actor.name, bx, by, "distance", core.fov.distance(dx, dy, bx, by))
						affected[actor] = true
					end
				end)
				return true
			end
		end)

		if not first then return true end
		local targets = { first }
		affected[first] = nil
		local possible_targets = table.listify(affected)
		print("[Chain lightning] Found targets:", #possible_targets)
		for i = 2, nb do
			if #possible_targets == 0 then break end
			local act = rng.tableRemove(possible_targets)
			targets[#targets+1] = act[1]
		end

		local sx, sy = self.x, self.y
		for i, actor in ipairs(targets) do
			local tgr = {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t, x=sx, y=sy}
			print("[Chain lightning] jumping from", sx, sy, "to", actor.x, actor.y)
			self:project(tgr, actor.x, actor.y, DamageType.LIGHTNING_DAZE, {power_check=self:combatMindpower(), dam=self:mindCrit(rng.avg(0.8*dam, dam)), daze=50})
			game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning", {tx=actor.x-sx, ty=actor.y-sy, nb_particles=150, life=6})
			sx, sy = actor.x, actor.y
		end
		game:playSoundNear(self, "talents/lightning")
		self:incPsi(-cost)
		return true
	end,

	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		local nb = t.getNumSpikeTargets(self, t)
		return ([[将 你 周 围 的 空 气 充 满 噼 啪 响 的 电 能 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 宝 石 或 灵 晶 ，会 对 所 有 接 近 的 目 标 造 成 %0.1f 的 闪 电 伤 害 。
		 电 能 光 环 造 成 的 伤 害 会 吸 收 能 量 ，每 造 成 %0.1f 点 伤 害 吸 收 一 点 能 量 。
		 如 果 你 的 灵 能 武 器 槽 佩 戴 的 是 武 器 ，每 次 攻 击 附 加 %0.1f 的 闪 电 伤 害 。
		 当 关 闭 该 技 能 时 ，如 果 你 拥 有 最 少 %d 点 能 量 ，巨 大 的 电 能 会 释 放 为 在 最 多 %d 个 邻 近 目 标 间 跳 跃 的 闪 电 ，对 每 个 目 标 造 成 %0.1f 的 闪 电 伤 害 ，且 50%%的 概 率 令 他 们 眩 晕 。
		#{bold}#激 活 光 环 是 不 消 耗 时 间 的 ，但 是 关 闭 它 则 需 要 消 耗 时 间 。#{normal}#
		 如 果 要 关 闭 光 环 且 不 发 射 射 线 ，关 闭 它 并 选 择 你 自 己 为 目 标 。伤 害 随 着 精 神 强 度 而 增 长 。]]):
		format(damDesc(self, DamageType.LIGHTNING, dam), mast, damDesc(self, DamageType.LIGHTNING, dam), spikecost, nb, damDesc(self, DamageType.LIGHTNING, spikedam))
	end,
}

newTalent{
	name = "Frenzied Focus",
	type = {"psionic/projection", 4},
	require = psi_wil_req4,
	cooldown = 20,
	psi = 30,
	points = 5,
	tactical = { ATTACK = { PHYSICAL = 3 } },
	getTargNum = function(self,t)
		return math.ceil(self:combatTalentScale(t, 1.0, 3.0, "log"))
	end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 10, 200))
	end,
	duration = function(self,t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		self:setEffect(self.EFF_PSIFRENZY, t.duration(self,t), {power=t.getTargNum(self,t), damage=t.getDamage(self,t)})
		return true
	end,
	info = function(self, t)
		local targets = t.getTargNum(self,t)
		local dur = t.duration(self,t)
		return ([[超 载 你 的 心 灵 聚 焦 %d 轮 ，造 成 特 殊 效 果 。
		 心 灵 传 动 武 器 进 入 狂 怒 中 ，每 轮 最 多 攻 击 %d 个 目 标 ，同 时 增 加 %d 格 攻 击 范 围 。
		 灵 晶 和 宝 石 会 对 一 个 距 离 6 以 内 的 随 机 敌 人 发 射 一 个 能 量 球 ，造 成 每 轮 %0.1f 的 伤 害 。伤 害 类 型 取 决 于 宝 石 的 颜 色 。伤 害 随 着 精 神 强 度 增 长 。]]):
		format(dur, targets, targets, t.getDamage(self,t))
	end,
}

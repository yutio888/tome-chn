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
	name = "Weapon Folding",
	type = {"chronomancy/spacetime-folding", 1},
	mode = "sustained",
	require = temporal_req1,
	sustain_paradox = 75,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 25) end,
	getParadoxReduction = function(self, t) return self:combatTalentScale(t, 0.6, 2.5, 0.75) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local paradox_reduction = t.getParadoxReduction(self, t)
		return ([[将 你 的 武 器（ 或 弹 药） 折 叠 一 次， 造 成 %0.2f 点 额 外 时 空 伤 害（ 弹 药 则 是 %0.2f ）， 每 次 攻 击 降 低 紊 乱 值 %0.1f （ 弹 药 则 是 %0.1f ）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.TEMPORAL, damage), damDesc(self, DamageType.TEMPORAL, damage * 2), paradox_reduction, paradox_reduction * 2)
	end,
}

newTalent{
	name = "Swap",
	type = {"chronomancy/spacetime-folding", 2},
	require = temporal_req2,
	points = 5,
	paradox = 5,
	cooldown = 10,
	tactical = { DISABLE = 2, },
	requires_target = true,
	direct_hit = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getConfuseDuration = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 3, 7)) end,
	getConfuseEfficency = function(self, t) return math.min(50, self:getTalentLevelRaw(t) * 10) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		tx, ty = checkBackfire(self, tx, ty)
		if tx then
			local _ _, tx, ty = self:canProject(tg, tx, ty)
			if tx then
				target = game.level.map(tx, ty, Map.ACTOR)
				if not target then return nil end
			end
		end
		
		-- checks for spacetime mastery hit bonus
		local power = self:combatSpellpower()
		if self:knowTalent(self.T_SPACETIME_MASTERY) then
			power = self:combatSpellpower() * (1 + self:callTalent(self.T_SPACETIME_MASTERY, "getPower"))
		end
		
		if target:canBe("teleport") and self:checkHit(power, target:combatSpellResist() + (target:attr("continuum_destabilization") or 0)) then
			target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
			-- first remove the target so the destination tile is empty
			game.level.map:remove(target.x, target.y, Map.ACTOR)
			local px, py 
			px, py = self.x, self.y
			if self:teleportRandom(tx, ty, 0) then
				-- return the target at the casters old location
				game.level.map(px, py, Map.ACTOR, target)
				self.x, self.y, target.x, target.y = target.x, target.y, px, py
				game.level.map:particleEmitter(target.x, target.y, 1, "temporal_teleport")
				game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
				target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
				-- confuse them
				self:project(tg, target.x, target.y, DamageType.CONFUSION, { dur = t.getConfuseDuration(self, t), dam = t.getConfuseEfficency(self, t),	})
			else
				-- return the target without effect
				game.level.map(target.x, target.y, Map.ACTOR, target)
				game.logSeen(self, "The spell fizzles!")
			end
		else
			game.logSeen(target, "%s resists the swap!", target.name:capitalize())
		end

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getConfuseDuration(self, t)
		local power = t.getConfuseEfficency(self, t)
		return ([[你 控 制 时 间 的 流 动 来 使 你 和 %d 码 范 围 内 的 某 个 怪 物 交 换 位 置。 目 标 会 混 乱（ %d%% 强 度） %d 回 合。 
		 受 法 术 强 度 影 响， 法 术 命 中 率 有 额 外 加 成。]]):format (range, power, duration)
	end,
}

newTalent{
	name = "Displace Damage",
	type = {"chronomancy/spacetime-folding", 3},
	mode = "sustained",
	require = temporal_req3,
	sustain_paradox = 125,
	cooldown = 10,
	tactical = { BUFF = 2 },
	points = 5,
	no_energy = true,
	-- called by _M:onTakeHit function in mod\class\Actor.lua to perform the damage displacment
	getchance = function(self, t) return self:combatTalentLimit(t, 50, 10, 30) end, -- Limit < 50%
	getrange = function(self, t) return math.max(2, math.floor(self:combatTalentScale(t, 2, 10.1, "log", 0, 2))) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[空 间 在 你 身 边 折 叠， 使 你 有 %d%% 的 概 率 转 移 一 半 伤 害 到 %d 码 范 围 内 随 机 1 个 敌 人 身 上。
		]]):format(t.getchance(self, t), t.getrange(self, t))
	end,
}

newTalent{
	name = "Temporal Wake",
	type = {"chronomancy/spacetime-folding", 4},
	require = temporal_req4,
	points = 5,
	random_ego = "attack",
	paradox = 10,
	cooldown = 10,
	tactical = { ATTACK = {TEMPORAL = 1}, CLOSEIN = 2 },
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 230) * getParadoxModifier(self, pm) end,
	range = function(self, t) return math.ceil(self:combatTalentScale(t, 2.3, 4.3)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then game.logSeen(self, "You can't move there.") return nil	end
		x, y = checkBackfire(self, x, y)
		local _ _, x, y = self:canProject(tg, x, y)
		
		-- indirect fire after the teleport from the x, y to our old starting spot would be best here 
		-- but checking for no_teleport we can make an educated guess rather or not the teleport will work
		if not game.level.map.attrs(x, y, "no_teleport") then
			local y = y
			if game.level.data.no_teleport_south and y  > self.y then 
				y = self.y
			end
			local dam = self:spellCrit(t.getDamage(self, t))
			self:project(tg, x, y, DamageType.TEMPORALSTUN, dam)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "temporal_lightning", {tx=x-self.x, ty=y-self.y})
			game:playSoundNear(self, "talents/lightning")
		end
		
		-- since we're using a precise teleport we'll look for a free grid first
		local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
		if tx and ty then
			if not self:teleportRandom(tx, ty, 0) then
				game.logSeen(self, "The spell fizzles!")
			end
		end
		
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[暴 力 地 折 叠 你 和 另 外 一 个 点 之 间 的 空 间。 你 传 送 到 目 标 地 点 并 留 下 1 个 时 空 陷 阱 对 路 径 上 的 所 有 目 标 造 成 %0.2f 时 空 伤 害 并 震 慑 目 标 4 回 合。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成； 受 技 能 等 级 影 响， 射 程 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

--[=[newTalent{
	name = "Kinetic Folding",
	type = {"chronomancy/spacetime-folding", 4},
	require = temporal_req4,
	points = 5,
	paradox = 10,
	cooldown = 12,
	tactical = { ATTACK = 2 },
	range = 10,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	on_pre_use = function(self, t, silent) if not self:hasDualWeapon() then if not silent then game.logPlayer(self, "You require two weapons to use this talent.") end return false end return true end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.9) * getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			self:attackTarget(target, nil, t.getDamage(self, t), true)
		else
			return
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 暂 时 折 叠 你 和 目 标 间 的 空 间， 同 时 用 2 把 武 器 对 其 造 成 %d%% 武 器 伤 害。 
		 受 紊 乱 值 影 响， 伤 害 按 比 例 加 成。]]):
		format (damage*100)
	end,
}]=]

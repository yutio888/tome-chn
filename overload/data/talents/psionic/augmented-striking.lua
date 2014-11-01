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
	name = "Kinetic Strike",
	type = {"psionic/augmented-striking", 1},
	require = psi_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	psi = 10,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 200) end,
	getDur = function(self, t) return self:combatTalentScale(t, 2.0, 6.0) end,
	action = function(self, t)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed")then
			game.logPlayer(self, "You cannot do that without a weapon in your hands.")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local dam = self:mindCrit(t.getDam(self, t))
		local dur = t.getDur(self, t)

		local hit = self:attackTarget(target, DamageType.PHYSICAL, self:combatTalentWeaponDamage(t, 0.5, 3.0), true)
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, dur, {apply_power=self:combatMindpower()})
			else
				game.logSeen(target, "%s resists the pin!", target.name:capitalize())
			end
			if target:attr("frozen") then
				DamageType:get(DamageType.PHYSICAL).projector(self, x, y, DamageType.PHYSICAL, dam)
			end
		end
		
		if self:hasEffect(self.EFF_TRANSCENDENT_TELEKINESIS) then
			local dir = util.getDir(x, y, self.x, self.y)
			if dir == 5 then return nil end
			local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
			local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
			local lt, rt = game.level.map(lx, ly, Map.ACTOR), game.level.map(rx, ry, Map.ACTOR)

			local hit
			if lt then
				hit = self:attackTarget(lt, DamageType.PHYSICAL, self:combatTalentWeaponDamage(t, 0.5, 3.0), true)		
				if hit then
					if lt:canBe("pin") then
						lt:setEffect(lt.EFF_PINNED, dur, {apply_power=self:combatMindpower()})
					else
						game.logSeen(lt, "%s resists the pin!", lt.name:capitalize())
					end
					if target:attr("frozen") then
						DamageType:get(DamageType.PHYSICAL).projector(self, x, y, DamageType.PHYSICAL, dam)
					end
				end
			end

			if rt then
				hit = self:attackTarget(rt, DamageType.PHYSICAL, self:combatTalentWeaponDamage(t, 0.5, 3.0), true)
				if hit then
					if rt:canBe("pin") then
						rt:setEffect(rt.EFF_PINNED, dur, {apply_power=self:combatMindpower()})
					else
						game.logSeen(rt, "%s resists the pin!", rt.name:capitalize())
					end
					if target:attr("frozen") then
						DamageType:get(DamageType.PHYSICAL).projector(self, x, y, DamageType.PHYSICAL, dam)
					end
				end
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[聚 焦 动 能 打 击 敌 人 造 成 %d%% 武 器 伤 害 
		敌 人 将 被 这 次 攻 击 的 力 量 定 身 %d 回 合 。
		任 何 处 于 冻 结 状 态 的 目 标 受 到 额 外 %0.2f 物 理 伤 害。
		额 外 伤 害 受 精 神 强 度 加 成 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}


newTalent{
	name = "Thermal Strike",
	type = {"psionic/augmented-striking", 1},
	require = psi_wil_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	psi = 10,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { COLD = 2 } },
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 200) end,
	getDur = function(self, t) return self:combatTalentScale(t, 2.0, 6.0) end,
	action = function(self, t)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed")then
			game.logPlayer(self, "You cannot do that without a weapon in your hands.")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local dam = self:mindCrit(t.getDam(self, t))
		local dur = t.getDur(self, t)

		local hit = self:attackTarget(target, DamageType.COLD, self:combatTalentWeaponDamage(t, 0.5, 2.0), true)
		if hit then
			if self:hasEffect(self.EFF_TRANSCENDENT_PYROKINESIS) then
				local tg = {type="ball", range=1, radius=1, friendlyfire=false}
				self:project(tg, x, y, DamageType.COLD, dam)
				self:project(tg, x, y, DamageType.FREEZE, {dur=dur, hp=dam})
				game.level.map:particleEmitter(x, y, tg.radius, "iceflash", {radius=1})
			else
				DamageType:get(DamageType.COLD).projector(self, x, y, DamageType.COLD, dam)
				DamageType:get(DamageType.FREEZE).projector(self, x, y, DamageType.FREEZE, {dur=dur, hp=dam})
			end

			if target:hasEffect(target.EFF_PINNED) and target:hasEffect(target.EFF_FROZEN) then
				local freeze = function(x, y)
					for i = -1, 1 do for j = -1, 1 do if game.level.map:isBound(x + i, y + j) then
						local oe = game.level.map(x + i, y + j, Map.TERRAIN)
						if oe and not oe:attr("temporary") and not game.level.map:checkAllEntities(x + i, y + j, "block_move") and not oe.special then
							local e = Object.new{
								old_feat = oe,
								name = "ice wall", image = "npc/iceblock.png",
								desc = "a summoned, transparent wall of ice",
								type = "wall",
								display = '#', color=colors.LIGHT_BLUE, back_color=colors.BLUE,
								always_remember = true,
								can_pass = {pass_wall=1},
								does_block_move = true,
								show_tooltip = true,
								block_move = true,
								block_sight = false,
								temporary = 3,
								x = x + i, y = y + j,
								canAct = false,
								act = function(self)
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
							game.level.map(x + i, y + j, Map.TERRAIN, e)
						end
					end end end
				end
				freeze(self.x, self.y)
				freeze(target.x, target.y)
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[聚 焦 热 能 打 击 敌 人 造 成 %d%% 寒 冷 武 器 伤 害 .
		之 后，一 股 寒 冰 能 量 将 爆 发 并 吞 噬 他 们 ，造 成 额 外 %0.1f 寒 冷 伤 害 并 冻 结 他 们 %d 回 合 。
		如 果 被 冻 结 的 目 标 已 经 被 定 身  ， 则 会 在 周 围 爆 发 寒 冰 能 量  ， 组 成 冰 墙 ，持 续 3 回 合。
		爆 发 的 寒 冷 伤 害 受 精 神 强 度 加 成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.COLD, t.getDam(self, t)), t.getDur(self, t))
	end,
}

newTalent{
	name = "Charged Strike",
	type = {"psionic/augmented-striking", 1},
	require = psi_wil_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	psi = 10,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { LIGHTNING = 2 } },
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 200) end,
	getDur = function(self, t) return self:combatTalentScale(t, 2.0, 6.0) end,
	action = function(self, t)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed")then
			game.logPlayer(self, "You cannot do that without a weapon in your hands.")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local dam = self:mindCrit(t.getDam(self, t))
		local dur = t.getDur(self, t)

		local hit = self:attackTarget(target, DamageType.LIGHTNING, self:combatTalentWeaponDamage(t, 0.5, 2.0), true)
		if hit then
			if self:hasEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS) then
				tg = {type="bolt", range=self:getTalentRange(t), talent=t}
				local fx, fy = x, y
				if not fx or not fy then return nil end

				local nb = 4
				local affected = {}
				local first = nil

				self:project(tg, fx, fy, function(dx, dy)
					print("[Chain lightning] targetting", fx, fy, "from", self.x, self.y)
					local actor = game.level.map(dx, dy, Map.ACTOR)
					if actor and not affected[actor] then
						affected[actor] = true
						first = actor

						print("[Chain lightning] looking for more targets", nb, " at ", dx, dy, "radius ", 3, "from", actor.name)
						self:project({type="ball", selffire=false, x=dx, y=dy, radius=3, range=0}, dx, dy, function(bx, by)
							local actor = game.level.map(bx, by, Map.ACTOR)
							if actor and not affected[actor] and self:reactionToward(actor) < 0 then
								print("[Chain lightning] found possible actor", actor.name, bx, by, "distance", core.fov.distance(dx, dy, bx, by))
								affected[actor] = true
							end
						end)
						return true
					end
				end)

				if not first then return end
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
					local tgr = {type="beam", range=self:getTalentRange(t), selffire=false, talent=t, x=sx, y=sy}
					print("[Chain lightning] jumping from", sx, sy, "to", actor.x, actor.y)
					self:project(tgr, actor.x, actor.y, DamageType.LIGHTNING, dam)
					actor:setEffect(actor.EFF_SHOCKED, dur, {apply_power=self:combatMindpower()})
					if core.shader.active() then game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning_beam", {tx=actor.x-sx, ty=actor.y-sy}, {type="lightning"})
					else game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning_beam", {tx=actor.x-sx, ty=actor.y-sy})
					end

					sx, sy = actor.x, actor.y
				end
			else
				DamageType:get(DamageType.LIGHTNING).projector(self, x, y, DamageType.LIGHTNING, dam)
				local actor = game.level.map(x, y, Map.ACTOR)
				if actor then
					actor:setEffect(actor.EFF_SHOCKED, dur, {apply_power=self:combatMindpower()})
				end
			end

			if target:hasEffect(target.EFF_PINNED) and self:isTalentActive(self.T_CHARGED_SHIELD) then
				local t = self:getTalentFromId(self.T_CHARGED_SHIELD)
				local cs = self:isTalentActive(self.T_CHARGED_SHIELD)
				t.shieldAbsorb(self, t, cs, damDesc(self, DamageType.LIGHTNING, dam) * 1.5)
			end

			if target:hasEffect(target.EFF_FROZEN) then
				target:removeEffect(target.EFF_FROZEN)
				game.level.map:particleEmitter(target.x, target.y, 2, "generic_ball", {img="particles_images/smoke_whispery_bright", size={8,20}, life=16, density=10, radius=2})
				self:project({type="ball", radius=2, range=1}, target.x, target.y, function(px, py)
					local act = game.level.map(px, py, Map.ACTOR)
					if not act or act == self or act == target then return end
					act:knockback(target.x, target.y, 3)
				end)
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[聚 焦 充 能 打 击 敌 人 造 成 %d%% 闪 电 武 器 伤 害 。
		之 后 ，从 武 器 释 放 一 股 能 量 ，造 成 额 外 %0.2f  闪 电 伤 害 并 减 半 他 们 的 震 慑 和 定 身 免 疫 %d 回 合 
		如 果 电 能 护 盾 开 启 ， 并 且 目 标 已 被 定 身 ， 则 护 盾 吸 收 量  增 加%0.2f.
		如 果 目 标 被 冻 结，冰 块 会 粉 碎 ， 击 退 半 径 2 以 内 的 所 有 生 物。
		释 放 的 伤 害 受 精 神 强 度 加 成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getDur(self, t), 1.5 * damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)))

	end,
}

newTalent{
	name = "Psi Tap",
	type = {"psionic/augmented-striking", 4},
	mode = "passive",
	points = 5,
	require = psi_wil_req4,
	getPsiRecover = function(self, t) return self:combatTalentScale(t, 1.0, 3.0) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "psi_regen_on_hit", t.getPsiRecover(self, t))
		self:talentTemporaryValue(p, "combat_apr", t.getPsiRecover(self, t)*3)
	end,
	info = function(self, t)
		return ([[用 灵 能 强 化 武  器 ， 获 得 %d 护 甲 穿 透，同 时 吸 取 每 次 武 器 攻 击 中 剩 余 的 的 能 量 ，每 次 武 器 命 中 时 获 得 %0.1f  点 超 能 力 值。]]):format(t.getPsiRecover(self, t)*3, t.getPsiRecover(self, t))
	end,
}


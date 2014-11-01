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

getRelentless = function(self, cd)
	local cd = 1
	if self:knowTalent(self.T_RELENTLESS_STRIKES) then
		local t = self:getTalentFromId(self.T_RELENTLESS_STRIKES)
		cd = 1 - t.getCooldownReduction(self, t)
	end
		return cd
	end,

newTalent{
	name = "Striking Stance",
	type = {"technique/unarmed-other", 1},
	mode = "sustained",
	hide = true,
	points = 1,
	cooldown = 12,
	tactical = { BUFF = 2 },
	type_no_req = true,
	no_npc_use = true, -- They dont need it since it auto switches anyway
	no_unlearn_last = true,
	getAttack = function(self, t) return self:getDex(25, true) end,
	getDamage = function(self, t) return self:combatStatScale("dex", 5, 35) end,
	getFlatReduction = function(self, t) return math.min(35, self:combatStatScale("str", 1, 30, 0.75)) end,
	-- 13 Strength = 2, 20 = 5, 30 = 9, 40 = 12, 50 = 16, 55 = 17, 70 = 22, 80 = 25
	activate = function(self, t)
		cancelStances(self)
		local ret = {
			atk = self:addTemporaryValue("combat_atk", t.getAttack(self, t)),
			flat = self:addTemporaryValue("flat_damage_armor", {all = t.getFlatReduction(self, t)})
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_atk", p.atk)
		self:removeTemporaryValue("flat_damage_armor", p.flat)
		return true
	end,
	info = function(self, t)
		local attack = t.getAttack(self, t)
		local damage = t.getDamage(self, t)
		return ([[增 加 你 %d 命 中。 你 攻 击 系 技 能 ( 拳 术、 终 结 技 ) 伤 害 增 加 %d%% , 同 时 减 少 %d 受 到 的 伤 害。
		受 敏 捷 影 响， 伤 害 按 比 例 加 成 。受 力 量 影 响，伤 害 减 免 有 额 外 加 成。 ]]):
		format(attack, damage, t.getFlatReduction(self, t))
	end,
}

newTalent{
	name = "Double Strike",  -- no stamina cost attack that will replace the bump attack under certain conditions
	type = {"technique/pugilism", 1},
	require = techs_dex_req1,
	points = 5,
	random_ego = "attack",
	--cooldown = function(self, t) return math.ceil(3 * getRelentless(self, cd)) end,
	cooldown = 3,
	message = "@Source@ 进行了两次快速攻击。",
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 0.8) + getStrikingStyle(self, dam) end,
	-- Learn the appropriate stance
	on_learn = function(self, t)
		if not self:knowTalent(self.T_STRIKING_STANCE) then
			self:learnTalent(self.T_STRIKING_STANCE, true, nil, {no_unlearn=true})
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:unlearnTalent(self.T_STRIKING_STANCE)
		end
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- force stance change
		if target and not self:isTalentActive(self.T_STRIKING_STANCE) then
			self:forceUseTalent(self.T_STRIKING_STANCE, {ignore_energy=true, ignore_cd = true})
		end

		-- breaks active grapples if the target is not grappled
		local grappled
		if target:isGrappled(self) then
			grappled = true
		else
			self:breakGrapples()
		end

		local hit1 = false
		local hit2 = false

		hit1 = self:attackTarget(target, nil, t.getDamage(self, t), true)
		hit2 = self:attackTarget(target, nil, t.getDamage(self, t), true)

		-- build combo points
		local combo = false

		if self:getTalentLevel(t) >= 4 then
			combo = true
		end

		if combo then
			if hit1 then
				self:buildCombo()
			end
			if hit2 then
				self:buildCombo()
			end
		elseif hit1 or hit2 then
			self:buildCombo()
		end

		return true

	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对 目 标 进 行 2 次 快 速 打 击， 每 次 打 击 造 成 %d%% 伤 害 并 使 你 的 姿 态 切 换 为 攻 击 姿 态， 如 果 你 已 经 在 攻 击 姿 态 且 此 技 能 已 就 绪， 那 么 此 技 能 会 自 动 取 代 你 的 普 通 攻 击 ( 并 触 发 冷 却 )。 
		任 何 一 次 打 击 都 会 使 你 获 得 1 点 连 击 点。 在 等 级 4 或 更 高 等 级 时 若 2 次 打 击 都 命 中 你 可 以 获 得 2 点 连 击 点。]])
		:format(damage)
	end,
}



newTalent{
	 name = "Spinning Backhand",
	type = {"technique/pugilism", 2},
	require = techs_dex_req2,
	points = 5,
	random_ego = "attack",
	--cooldown = function(self, t) return math.ceil(12 * getRelentless(self, cd)) end,
	cooldown = 8,
	stamina = 12,
	range = function(self, t) return math.ceil(2 + self:combatTalentScale(t, 2.2, 4.3)) end, -- being able to use this over rush without massive investment is much more fun
	chargeBonus = function(self, t, dist) return self:combatScale(dist, 0.15, 1, 0.50, 5) end,
	message = "@Source@ lashes out with a spinning backhand.",
	tactical = { ATTACKAREA = { weapon = 2 }, CLOSEIN = 1 },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.0, 1.7) + getStrikingStyle(self, dam) end,
	on_pre_use = function(self, t) return not self:attr("never_move") end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		-- bonus damage for charging
		local charge = t.chargeBonus(self, t, (core.fov.distance(self.x, self.y, x, y) - 1))
		local damage = t.getDamage(self, t) + charge

		-- do the rush
		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		local tx, ty = self.x, self.y
		while lx and ly do
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		local hit1 = false
		local hit2 = false
		local hit3 = false

		-- do the backhand
		if core.fov.distance(self.x, self.y, x, y) == 1 then
			-- get left and right side
			local dir = util.getDir(x, y, self.x, self.y)
			local lx, ly = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).left)
			local rx, ry = util.coordAddDir(self.x, self.y, util.dirSides(dir, self.x, self.y).right)
			local lt, rt = game.level.map(lx, ly, Map.ACTOR), game.level.map(rx, ry, Map.ACTOR)

			hit1 = self:attackTarget(target, nil, damage, true)

			--left hit
			if lt then
				hit2 = self:attackTarget(lt, nil, damage, true)
			end
			--right hit
			if rt then
				hit3 = self:attackTarget(rt, nil, damage, true)
			end

		end

		-- remove grappls
		self:breakGrapples()

		-- build combo points
		local combo = false

		if self:getTalentLevel(t) >= 4 then
			combo = true
		end

		if combo then
			if hit1 then
				self:buildCombo()
			end
			if hit2 then
				self:buildCombo()
			end
			if hit3 then
				self:buildCombo()
			end
		elseif hit1 or hit2 or hit3 then
			self:buildCombo()
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local charge =t.chargeBonus(self, t, t.range(self, t)-1)*100
		return ([[对 你 面 前 的 敌 人 使 用 一 次 旋 风 打 击， 造 成 %d%% 伤 害。 
		如 果 你 离 目 标 较 远， 旋 转 时 你 会 自 动 前 行， 根 据 移 动 距 离 增 加 至 多 %d%% 伤 害。 
		此 次 攻 击 会 移 除 任 何 你 正 在 维 持 的 抓 取 效 果 并 增 加 1 点 连 击 点。 
		在 等 级 4 或 更 高 时， 你 每 次 连 击 均 会 获 得 1 点 连 击 点。 ]])
		:format(damage, charge)
	end,
}

newTalent{
	name = "Axe Kick", 
	type = {"technique/pugilism", 3},
	require = techs_dex_req3,
	points = 5,
	stamina = 20,
	random_ego = "attack",
	cooldown = function(self, t)
		return 20
	end,
	getDuration = function(self, t)
		return self:combatTalentLimit(t, 5, 1, 4)
	end,
	message = "@Source@ 抬起腿，施展了毁灭性的斧踢绝技。",
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 2) + getStrikingStyle(self, dam) end, -- low damage scaling, investment gets the extra CP
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		local hit1 = false
		
		hit1 = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hit1 and target:canBe("confusion") then
			target:setEffect(target.EFF_DELIRIOUS_CONCUSSION, t.getDuration(self, t), {})
		end
		
		-- build combo points
		if hit1 then
			self:buildCombo()
			self:buildCombo()
		end
		return true

	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[ 施 展 一 次 毁 灭 性 的 的 踢 技 ，造 成 %d%% 伤 害 。
		 如 果 攻 击 命 中 ， 对 方 的 大 脑 受  到 伤 害 ，不 能 使 用 技 能 ， 持 续 %d 回 合 ， 同 时 你 获 得 2连 击 点。 ]])
		:format(damage, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Flurry of Fists",
	type = {"technique/pugilism", 4},
	require = techs_dex_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 16,
	stamina = 15,
	message = "@Source@ lashes out with a flurry of fists.",
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.3, 1) + getStrikingStyle(self, dam) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		local hit1 = false
		local hit2 = false
		local hit3 = false

		hit1 = self:attackTarget(target, nil, t.getDamage(self, t), true)
		hit2 = self:attackTarget(target, nil, t.getDamage(self, t), true)
		hit3 = self:attackTarget(target, nil, t.getDamage(self, t), true)

		--build combo points
		local combo = false

		if self:getTalentLevel(t) >= 4 then
			combo = true
		end

		if combo then
			if hit1 then
				self:buildCombo()
			end
			if hit2 then
				self:buildCombo()
			end
			if hit3 then
				self:buildCombo()
			end
		elseif hit1 or hit2 or hit3 then
			self:buildCombo()
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[对 目 标 造 成 3 次 快 速 打 击， 每 击 造 成 %d%% 伤 害。 
		此 攻 击 使 你 得 到 1 点 连 击 点。 
		在 等 级 4 或 更 高 时， 你 每 次 连 击 都 可 以 获 得 1 点 连 击 点。]])
		:format(damage)
	end,
}

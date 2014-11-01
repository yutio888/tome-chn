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
	name = "Transcendent Telekinesis",
	type = {"psionic/kinetic-mastery", 1},
	require = psi_wil_high1,
	points = 5,
	psi = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 10, 30) end,
	getPenetration = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 10, 20), 100, 4.2, 4.2, 13.4, 13.4) end, -- Limit < 100%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 30, 5, 10)) end, --Limit < 30
	action = function(self, t)
		self:setEffect(self.EFF_TRANSCENDENT_TELEKINESIS, t.getDuration(self, t), {power=t.getPower(self, t), penetration = t.getPenetration(self, t)})
		self:removeEffect(self.EFF_TRANSCENDENT_PYROKINESIS)
		self:removeEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS)
		self:alterTalentCoolingdown(self.T_KINETIC_LEECH, -1000)
		self:alterTalentCoolingdown(self.T_KINETIC_STRIKE, -1000)
		self:alterTalentCoolingdown(self.T_KINETIC_AURA, -1000)
		self:alterTalentCoolingdown(self.T_KINETIC_SHIELD, -1000)
		self:alterTalentCoolingdown(self.T_MINDLASH, -1000)
		return true
	end,
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 动 能 突 破 极 限， 增 加 你 的 物 理 伤 害 %d%% ， 物 理 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 动 能 护 盾， 动 能 吸 取， 动 能 光 环 和 心 灵 鞭 笞 的 冷 却 时 间。
		根 据 情 况， 动 能 光 环 获 得 其 中 一 种 强 化： 动 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 动 能 光 环 的 伤 害 加 成。
		你 的 动 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		心 灵 鞭 笞 附 带 震 慑 效 果。
		动 能 吸 取 会 使 敌 人 进 入 睡 眠。
		动 能 打 击 会 对 相 邻 的 两 个 敌 人 进 行 攻 击。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 卓 越 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t))
	end,
}

newTalent{
	name = "Kinetic Surge", image = "talents/telekinetic_throw.png",
	type = {"psionic/kinetic-mastery", 2},
	require = psi_wil_high2,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 20,
	tactical = { CLOSEIN = 2, ATTACK = { PHYSICAL = 2 }, ESCAPE = 2 },
	range = function(self, t) return self:combatTalentLimit(t, 10, 6, 9) end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 20, 180))
	end,
	getKBResistPen = function(self, t) return self:combatTalentLimit(t, 100, 25, 45) end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false, talent=t} end,
	action = function(self, t)
		local tg = {type="hit", range=1, nowarning=true }
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
				
		if self:reactionToward(target) < 0 then
			local tg = self:getTalentTarget(t)
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end

			if target:canBe("knockback") or rng.percent(t.getKBResistPen(self, t)) then
				self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam) --Direct Damage
				
				local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
				if tx and ty then
					local ox, oy = target.x, target.y
					target:move(tx, ty, true)
					if config.settings.tome.smooth_move > 0 then
						target:resetMoveAnim()
						target:setMoveAnim(ox, oy, 8, 5)
					end
				end
				self:project(tg, target.x, target.y, DamageType.SPELLKNOCKBACK, dam/2) --AOE damage
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, math.floor(self:getTalentRange(t) / 2), {apply_power=self:combatMindpower()})
				else
					game.logSeen(target, "%s resists the stun!", target.name:capitalize())
				end
			else --If the target resists the knockback, do half damage to it.
				target:logCombat(self, "#YELLOW##Source# resists #Target#'s throw!")
				self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam/2)
			end
		else
			local tg = {type="beam", range=self:getTalentRange(t), nolock=true, talent=t, display={particle="bolt_earth", trail="earthtrail"}}
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end
			if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end

			for i = 1, math.floor(self:getTalentRange(t) / 2) do
				self:project(tg, x, y, DamageType.DIG, 1)
			end
			self:project(tg, x, y, DamageType.MINDKNOCKBACK, dam)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
			game:playSoundNear(self, "talents/lightning")

			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, engine.Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			local tx, ty = self.x, self.y
			while lx and ly do
				if is_corner_blocked or block_actor(_, lx, ly) then break end
				tx, ty = lx, ly
				lx, ly, is_corner_blocked = l:step()
			end

			--self:move(tx, ty, true)
			local fx, fy = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not fx then
				self:move(fx, fy, true)
			end
			return true
		end
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[
		使 用 你 的 念 动 力 增 强 你 的 力 量， 使 你 能 够 举 起 一 个 相 邻 的 敌 人 或 者 你 自 己 并 投 掷 到 半 径 %d 范 围 的 任 意 位 置。 
		敌 人 落 地 时 受 到 %0.1f 物 理 伤 害， 并 被 震 慑 %d 回 合。 落 点 周 边 半 径 2 格 内 的 所 有 其 他 单 位 受 到 %0.1f 物 理 伤 害 并 被 从 你 身 边 被 退。
		这 个 技 能 无 视 被 投 掷 目 标 %d%% 的 击 退 抵 抗， 如 果 目 标 抵 抗 击 退， 只 受 到 一 半 伤 害。
		
		对 你 自 己 使 用 时 ， 击 退 线 路 上 所 有 目 标 并 造 成  %0.1f 物 理 伤 害 。
		同 时 能 破 坏 至 多 %d 面 墙 壁。
		受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		受 精 神 强 度 和 力 量 影 响， 投 掷 距 离 有 额 外 加 成。]]):
		format(range, dam, math.floor(range/2), dam/2, t.getKBResistPen(self, t), dam, math.floor(range/2))
	end,
}

newTalent{
	name = "Deflect Projectiles",
	type = {"psionic/kinetic-mastery", 3},
	require = psi_wil_high3, 
	points = 5,
	mode = "sustained", no_sustain_autoreset = true,
	sustain_psi = 25,
	cooldown = 10,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5, "log")) end, 
	radius = 10,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), selffire=false, talent=t}
	end,
	getEvasion = function(self, t) return self:combatTalentLimit(t, 100, 17, 45), self:getTalentLevel(t) >= 4 and 2 or 1 end, -- Limit chance <100%
	activate = function(self, t)
		local chance, spread = t.getEvasion(self, t)
		return {
			chance = self:addTemporaryValue("projectile_evasion", chance),
			spread = self:addTemporaryValue("projectile_evasion_spread", spread),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("projectile_evasion", p.chance)
		self:removeTemporaryValue("projectile_evasion_spread", p.spread)
		if self:attr("save_cleanup") then return true end
	
		local tg = self:getTalentTarget(t)
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRadius(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local i = 0
			local p = game.level.map(x, y, Map.PROJECTILE+i)
			while p do
				if p.project and p.project.def.typ.source_actor ~= self then
					p.project.def.typ.line_function = core.fov.line(p.x, p.y, tx, ty)
				end
				
				i = i + 1
				p = game.level.map(x, y, Map.PROJECTILE+i)
			end
		end end

		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "shout", {additive=true, life=10, size=3, distorion_factor=0.0, radius=self:getTalentRadius(t), nb_circles=4, rm=0.8, rM=1, gm=0, gM=0, bm=0.8, bM=1.0, am=0.4, aM=0.6})
		
		return true
	end,
	info = function(self, t)
		local chance, spread = t.getEvasion(self, t)
		return ([[你 学 会 分 配 一 部 分 注 意 力， 用 精 神 力 击 落、 抓 取 或 偏 斜 飞 来 的 发 射 物。 
		所 有 以 你 为 目 标 的 发 射 物 有 %d%% 的 几 率 落 在 半 径 %d 格 范 围 内 的 其 他 地 点。
		如 果 你 愿 意， 你 可 以 使 用 精 神 力 来 抓 住 半 径 10 格 内 的 所 有 发 射 物， 并 投 回 以 你 为 中 心 半 径 %d 格 内 的 任 意 地 点， 这 么 做 会 打 断 你 的 集 中 力， 并 使 这 个 持 续 技 能 进入 冷 却。
		要 想 这 样 做 ， 取 消 该 持 续 技 即 可。]]):
		format(chance, spread, self:getTalentRange(t))
	end,
}

newTalent{
	name = "Implode",
	type = {"psionic/kinetic-mastery", 4},
	require = psi_wil_high4,
	points = 5,
	random_ego = "attack",
	cooldown = 20,
	psi = 35,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = 2 },
	range = 5,
	getDuration = function (self, t)
		return math.ceil(self:combatTalentMindDamage(t, 2, 6))
	end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 66, 132))
	end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=0, selffire=false, talent=t} end,
	action = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.IMPLOSION, {dur=dur, dam=dam})
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(self.EFF_PSIONIC_BIND, dur, {power=1, apply_power=self:combatMindpower()})
		end
		return true
	end,
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[用 粉 碎 骨 头 的  力 量 紧 紧 锁 住 目 标 ， 定 身 并 减 速 目 标 50%%， 持 续  %d 回 合 ， 每 回 合 造 成 %0.1f 物 理 伤 害。
		受 精 神 强 度 影 响， 持 续 时 间 和 伤 害 有 额 外 加 成。]]):format(dur, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

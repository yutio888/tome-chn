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
	name = "Mind Storm",
	type = {"psionic/discharge", 1},
	points = 5, 
	require = psi_wil_high1,
	sustain_feedback = 0,
	mode = "sustained",
	cooldown = 12,
	tactical = { ATTACKAREA = {MIND = 2}},
	requires_target = true,
	proj_speed = 10,
	range = 7,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t, friendlyfire=false, friendlyblock=false, display={particle="discharge_bolt", trail="lighttrail"}}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 100) end,
	getTargetCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getOverchargeRatio = function(self, t) return self:combatTalentLimit(t, 10, 19, 15) end, -- Limit >10
	doMindStorm = function(self, t, p)
		local tgts = {}
		local tgts_oc = {}
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
				tgts_oc[#tgts_oc+1] = a
			end
		end end	
		
		local wrath = self:hasEffect(self.EFF_FOCUSED_WRATH)
		
		-- Randomly take targets
		local tg = self:getTalentTarget(t)
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 or self:getFeedback() < 5 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			-- Divert the Bolt?
			if wrath then
				self:projectile(tg, wrath.target.x, wrath.target.y, DamageType.MIND, self:mindCrit(t.getDamage(self, t), nil, wrath.power))
			else
				self:projectile(tg, a.x, a.y, DamageType.MIND, self:mindCrit(t.getDamage(self, t)))
			end
			self:incFeedback(-5)
		end
		
		-- Randomly take overcharge targets
		local tg = self:getTalentTarget(t)
		if p.overcharge >= 1 then
			for i = 1, math.min(p.overcharge, t.getTargetCount(self, t)) do
				if #tgts_oc <= 0 then break end
				local a, id = rng.table(tgts_oc)
				table.remove(tgts_oc, id)
				-- Divert the Bolt?
				if wrath then
					self:projectile(tg, wrath.target.x, wrath.target.y, DamageType.MIND, self:mindCrit(t.getDamage(self, t), nil, wrath.power))
				else
					self:projectile(tg, a.x, a.y, DamageType.MIND, self:mindCrit(t.getDamage(self, t)))
				end
			end
		end
			
		p.overcharge = 0
		
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/thunderstorm")
		local ret = {
			overcharge = 0,
			particles = self:addParticles(Particles.new("ultrashield", 1, {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90, radius=0.2, density=15, life=28, instop=10}))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particles)
		return true
	end,
	info = function(self, t)
		local targets = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local charge_ratio = t.getOverchargeRatio(self, t)
		return ([[用 你 的 潜 意 识 渗 透 周 围 的 环 境。 当 此 技 能 激 活 时， 每 回 合 你 会 射 出 %d 个 超 能 力 值 球 造 成 %0.2f 精 神 伤 害（ 每 个 敌 方 单 位 只 承 受 一 次 超 能 力 值 球 攻 击）。 每 个 超 能 力 值 球 消 耗 5 点 反 馈 值。 
		 当 获 得 的 反 馈 值 超 出 最 大 值 时， 你 会 产 生 额 外 的 超 能 力 值 球（ 每 超 出 %d 反 馈 值 产 生 1 个 超 能 力 值 球）， 但 是 每 回 合 产 生 的 额 外 超 能 力 值 球 数 量 不 会 超 过 %d 。 
		 此 技 能 运 用 了 灵 能 通 道， 所 以 当 你 移 动 时 会 中 断 此 技 能。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(targets, damDesc(self, DamageType.MIND, damage), charge_ratio, targets)
	end,
}

newTalent{
	name = "Feedback Loop",
	type = {"psionic/discharge", 2},
	points = 5, 
	require = psi_wil_high2,
	cooldown = 24,
	tactical = { FEEDBACK = 2 },
	no_break_channel = true,
	getDuration = function(self, t, fake)
		local tl = self:getTalentLevel(t)
		if not fake then
			local wrath = self:hasEffect(self.EFF_FOCUSED_WRATH)
			tl = self:mindCrit(tl, nil, wrath and wrath.power or 0)
		end
		return math.floor(self:combatTalentLimit(tl, 24, 3.5, 9.5))  -- Limit <24
	end,
	on_pre_use = function(self, t, silent) if self:getFeedback() <= 0 then if not silent then game.logPlayer(self, "You have no feedback to start a feedback loop!") end return false end return true end,
	action = function(self, t)
		local wrath = self:hasEffect(self.EFF_FOCUSED_WRATH)
		self:setEffect(self.EFF_FEEDBACK_LOOP, t.getDuration(self, t), {})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t, true)
		return ([[激 活 以 逆 转 你 的 反 馈 值 衰 减， 持 续 %d 回 合。 此 技 能 激 活 时 可 产 生 暴 击 效 果， 效 果 为 增 加 技 能 持 续 时 间。 
		 你 必 须 在 反 馈 值 非 空 的 时 候 才 能 使 用 此 技 能（ 否 则 没 有 衰 减）。 
		 受 精 神 强 度 影 响， 反 馈 值 的 最 大 增 加 值 按 比 例 加 成。]]):format(duration)
	end,
}

newTalent{
	name = "Backlash",
	type = {"psionic/discharge", 3},
	points = 5, 
	require = psi_wil_high3,
	mode = "passive",
	range = 7,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 75) end,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	doBacklash = function(self, target, value, t)
		if self.turn_procs.psi_backlash and self.turn_procs.psi_backlash[target.uid] then return nil end
		self.turn_procs.psi_backlash = self.turn_procs.psi_backlash or {}
		self.turn_procs.psi_backlash[target.uid] = true
		self.no_backlash_loops = true
		if core.fov.distance(self.x, self.y,target.x, target.y) > self:getTalentRange(t) then return nil end
		local tg = self:getTalentTarget(t)
		local a = game.level.map(target.x, target.y, Map.ACTOR)
		if not a or self:reactionToward(a) >= 0 then return nil end
		local damage = math.min(value, t.getDamage(self, t))
		-- Divert the Backlash?
		local wrath = self:hasEffect(self.EFF_FOCUSED_WRATH)
		if damage > 0 then
			if wrath then
				self:project(tg, wrath.target.x, wrath.target.y, DamageType.MIND, self:mindCrit(damage, nil, wrath.power), nil, true) -- No Martyr loops
				game.level.map:particleEmitter(wrath.target.x, wrath.target.y, 1, "generic_discharge", {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90})
			else
				self:project(tg, a.x, a.y, DamageType.MIND, self:mindCrit(damage), nil, true) -- No Martyr loops
				game.level.map:particleEmitter(a.x, a.y, 1, "generic_discharge", {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90})
			end
		end
		self.no_backlash_loops = nil
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local damage = t.getDamage(self, t)
		return ([[你 的 潜 意 识 会 报 复 那 些 伤 害 你 的 人。 
		 当 攻 击 者 在 %d 码 范 围 内 时， 你 会 对 目 标 造 成 伤 害， 伤 害 值 为 因 承 受 此 攻 击 而 获 得 的 反 馈 数 值 （但 不 超 过 %0.2f）。
		 此 效 果 每 回 合 对 同 一 生 物 最 多 只 能 触 发 1 次。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(range, damDesc(self, DamageType.MIND, damage))
	end,
}

newTalent{
	name = "Focused Wrath",   
	type = {"psionic/discharge", 4},
	points = 5, 
	require = psi_wil_high4,
	feedback = 25,
	cooldown = 12,
	tactical = { ATTACK = {MIND = 2}},
	range = 7,
	getCritBonus = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t)}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 12, 3, 7)) end, -- Limit <12
	direct_hit = true,
	requires_target = true,
	no_break_channel = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		_, x, y = self:canProject(tg, x, y)
		local target = x and game.level.map(x, y, engine.Map.ACTOR) or nil
		if not target or target == self then return nil end
		
		self:setEffect(self.EFF_FOCUSED_WRATH, t.getDuration(self, t), {target=target, power=t.getCritBonus(self, t)/100})

		game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90})
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local crit_bonus = t.getCritBonus(self, t)
		return ([[将 注 意 力 集 中 于 单 体 目 标， 将 所 有 攻 击 性 灵 能 脉 冲 系 技 能 射 向 目 标， 持 续 %d 回 合。 当 此 技 能 激 活 时， 所 有 灵 能 脉 冲 系 技 能 增 加 %d%% 暴 击 伤 害。 
		 如 果 目 标 死 亡， 则 该 技 能 提 前 中 断。 
		 受 精 神 强 度 影 响， 暴 击 增 益 效 果 按 比 例 加 成。]]):format(duration, crit_bonus)
	end,
}
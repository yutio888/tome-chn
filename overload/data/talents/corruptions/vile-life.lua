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
	name = "Blood Splash",
	type = {"corruption/vile-life", 1},
	require = corrs_req1,
	points = 5,
	mode = "passive",
	heal = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	callbackOnCrit = function(self, t)
		if self.turn_procs.blood_splash_on_crit then return end
		self.turn_procs.blood_splash_on_crit = true

		self:heal(t.heal(self, t), self)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, circleDescendSpeed=3.5}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, circleDescendSpeed=3.5}))
		end
	end,
	callbackOnKill = function(self, t)
		if self.turn_procs.blood_splash_on_kill then return end
		self.turn_procs.blood_splash_on_kill = true

		self:heal(t.heal(self, t), self)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, circleDescendSpeed=3.5}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, circleDescendSpeed=3.5}))
		end
	end,
	info = function(self, t)
		return ([[制 造 痛 苦 和 死 亡 让 你 充 满 活 力。
		每 次 暴 击 时 回 复 %d 生 命。
		每 次 杀 死 生 物 时 回 复 %d 生 命。
		每 个 效 果 每 回 合 只 能 触 发 一 次。]]):
		format(t.heal(self, t), t.heal(self, t))
	end,
}

newTalent{
	name = "Elemental Discord",
	type = {"corruption/vile-life", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 20,
	vim = 30,
	mode = "sustained",
	tactical = { BUFF = 2 },
	getFire = function(self, t) return self:combatTalentSpellDamage(t, 10, 400) end,
	getCold = function(self, t) return self:combatTalentSpellDamage(t, 10, 500) end,
	getLightning = function(self, t) return math.floor(self:combatTalentLimit(t, 8, 3, 5)) end,
	getAcid = function(self, t) return math.floor(self:combatTalentLimit(t, 8, 2, 5)) end,
	getNature = function(self, t) return self:combatTalentLimit(t, 60, 15, 45) end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, tmp, no_martyr)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if not src.setEffect then return end
		if not p.last_turn[type] or game.turn - p.last_turn[type] < 100 then return end

		if type == DamageType.FIRE then
			src:setEffect(src.EFF_BURNING, 5, {src=self, apply_power=self:combatSpellpower(), power=t.getFire(self, t) / 5})
		elseif type == DamageType.COLD then
			src:setEffect(src.EFF_FROZEN, 3, {apply_power=self:combatSpellpower(), hp=t.getCold(self, t)})
		elseif type == DamageType.ACID then
			src:setEffect(src.EFF_BLINDED, t.getAcid(self, t), {apply_power=self:combatSpellpower()})
		elseif type == DamageType.LIGHTNING then
			src:setEffect(src.EFF_DAZED, t.getLightning(self, t), {apply_power=self:combatSpellpower()})
		elseif type == DamageType.NATURE then
			src:setEffect(src.EFF_SLOW, 4, {apply_power=self:combatSpellpower(), power=t.getNature(self, t) / 100})
		end
		p.last_turn[type] = game.turn
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		return {
			last_turn = { 
				[DamageType.FIRE] = game.turn - 100,
				[DamageType.COLD] = game.turn - 100,
				[DamageType.ACID] = game.turn - 100,
				[DamageType.LIGHTNING] = game.turn - 100,
				[DamageType.NATURE] = game.turn - 100,
			},
		}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[ 每 次 受 到 元 素 伤 害 时 对 造 成 伤 害 的 生 物 触 发 以 下 效 果：
		- 火 焰：灼 烧 目 标 5 回 合 ，造 成 %0.2f 火 焰 伤 害 。
		- 寒 冷：冻 结 目 标 3 回 合 ，冰 块 强 度 %d 。
		- 酸 性：致 盲 %d 回 合 。
		- 闪 电：眩 晕 %d 回 合 。
		- 自 然：减 速 %d%% 四 回 合。
		每 种 伤 害 类 型 的 效 果 每 10 回 合 只 能 触 发 一 次。]]):
		format(
			damDesc(self, DamageType.FIRE, t.getFire(self, t)),
			t.getCold(self, t),
			t.getAcid(self, t),
			t.getLightning(self, t),
			t.getNature(self, t)
		)
	end,
}

newTalent{
	name = "Healing Inversion",
	type = {"corruption/vile-life", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 15,
	vim = 16,
	range = 5,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getPower = function(self,t) return self:combatLimit(self:combatTalentSpellDamage(t, 4, 100), 100, 0, 0, 18.1, 18.1) end, -- Limit to <100%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_HEALING_INVERSION, 5, {apply_power=self:combatSpellpower(), power=t.getPower(self, t)})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[你 操 控 目 标 的 活 力 ， 临 时 将 所 有 治 疗 转 化 为 伤 害 。 
		5 回 合 内 目 标 受 到 的 所 有 治 疗 将 变 成 %d%% 治 疗 量 的 枯 萎 伤 害 。
		效 果 受 法 术 强 度 加 成 。]]):format(t.getPower(self,t))
	end,
}

newTalent{
	name = "Vile Transplant",
	type = {"corruption/vile-life", 4},
	require = corrs_req4,
	points = 5,
	cooldown = 10,
	vim = 18,
	direct_hit = true,
	requires_target = true,
	range = 1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4, "log")) end,
	getDam = function(self, t) return self:combatTalentLimit(t, 2, 10, 5) end, --Limit < 10% life/effect
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end

			local list = {}
			local nb = t.getNb(self, t)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if (e.type == "physical" or e.type == "magical") and e.status == "detrimental" then
					list[#list+1] = eff_id
				end
			end

			local dam = t.getDam(self, t) * self.life / 100
			while #list > 0 and nb > 0 do
				if self:checkHit(self:combatSpellpower(), target:combatSpellResist(), 0, 95, 5) then
					local eff_id = rng.tableRemove(list)
					local p = self.tmp[eff_id]
					local e = self.tempeffect_def[eff_id]
					local effectParam = self:copyEffect(eff_id)
					effectParam.src = self
						
					target:setEffect(eff_id, p.dur, effectParam)
					self:removeEffect(eff_id)
					local dead, val = self:takeHit(dam, self, {source_talent=t})
					target:heal(val, self)
					game:delayedLogMessage(self, target, "vile_transplant"..e.desc, ("#CRIMSON##Source# transfers an effect (%s) to #Target#!"):format(e.desc))
				end
				nb = nb - 1
			end
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, g=100, r=100, a=90, limit_life=8, appear=8, speed=2, img="blight_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[你 将 至 多 %d 个 物 理 与 魔 法 负 面 状 态 转 移 给 附 近 的 一 个 生 物 。
		每 转 移 一 个 负 面 状 态 ， 你 将 失 去 %0.1f%% 剩 余 生 命 值 ， 该 生 物 将 受 到 等 量 治 疗。
		转 移 成 功 率 受 法 术 强 度 影 响 。]]):
		format(t.getNb(self, t), t.getDam(self, t))
	end,
}

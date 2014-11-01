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
	name = "Repulsion Blast",
	type = {"chronomancy/gravity",1},
	require = chrono_req1,
	points = 5,
	paradox = 5,
	cooldown = 4,
	tactical = { ATTACKAREA = {PHYSICAL = 2}, ESCAPE = 2 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4.5, 6.5)) end,
	requires_target = true,
	direct_hit = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 170)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.REPULSION, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "gravity_breath", {radius=tg.radius, tx=x-self.x, ty=y-self.y, allow=core.shader.allow("distort")})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 %d 码 锥 形 半 径 范 围 内 释 放 一 股 爆 炸 性 的 重 力 冲 击 波， 造 成 %0.2f 物 理 伤 害 并 击 退 范 围 内 目 标。 对 定 身 状 态 目 标 额 外 造 成 50%% 伤 害。 
		 这 股 爆 炸 性 冲 击 波 可 能 会 对 目 标 造 成 多 次 伤 害， 这 取 决 于 攻 击 半 径 和 击 退 效 果。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Gravity Spike",
	type = {"chronomancy/gravity", 2},
	require = chrono_req2,
	points = 5,
	paradox = 10,
	cooldown = 6,
	tactical = { ATTACKAREA = {PHYSICAL = 2}, DISABLE = 2 },
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.7)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 170)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		x, y = checkBackfire(self, x, y)
		local grids = self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
			if tx and ty and target:canBe("knockback") then
				target:move(tx, ty, true)
				game.logSeen(target, "%s is drawn in by the gravity spike!", target.name:capitalize())
			end
		end)
		self:project (tg, x, y, DamageType.GRAVITY, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(x, y, tg.radius, "gravity_spike", {radius=tg.radius, allow=core.shader.allow("distort")})

		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 %d 码 半 径 范 围 内 制 造 1 次 重 力 钉 刺， 将 所 有 目 标 拉 到 法 术 中 心， 造 成 %0.2f 物 理 伤 害。 对 定 身 状 态 目 标 额 外 造 成 50%% 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Repulsion Field",
	type = {"chronomancy/gravity",3},
	require = chrono_req3,
	points = 5,
	paradox = 15,
	cooldown = 14,
	tactical = { ATTACKAREA = {PHYSICAL = 2}, ESCAPE = 2 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 8, 80)*getParadoxModifier(self, pm) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	direct_hit = true,
	requires_target = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.REPULSION, t.getDamage(self, t),
			tg.radius,
			5, nil,
			engine.MapEffect.new{color_br=200, color_bg=120, color_bb=0, effect_shader="shader_images/paradox_effect.png"},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			tg.selffire
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 用 %d 码 半 径 范 围 的 重 力 吸 收 光 环 围 绕 自 己， 击 退 所 有 单 位 并 造 成 %0.2f 物 
		 理 伤 害。 此 效 果 持 续 %d 回 合。 对 定 身 状 态 目 标 额 外 造 成 50%% 伤 害。 
		 这 股 爆 炸 性 冲 击 波 可 能 会 对 目 标 造 成 多 次 伤 害， 这 取 决 于 攻 击 半 径 和 击 退 效 果。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		 format(radius, damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

newTalent{
	name = "Gravity Well",
	type = {"chronomancy/gravity", 4},
	require = chrono_req4,
	points = 5,
	paradox = 20,
	cooldown = 24,
	tactical = { ATTACKAREA = {PHYSICAL = 2}, DISABLE = 2 },
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 80)*getParadoxModifier(self, pm) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local duration = t.getDuration(self,t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		x, y = checkBackfire(self, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, duration,
			DamageType.GRAVITYPIN, dam,
			radius,
			5, nil,
			{type="gravity_well"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[增 加 此 处 重 力， 造 成 %0.2f 物 理 伤 害 并 且 每 回 合 有 概 率 将 %d 码 半 径 范 围 目 标 定 身 %d 回 合。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), radius, duration)
	end,
}

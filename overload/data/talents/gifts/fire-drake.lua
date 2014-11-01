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
	name = "Bellowing Roar",
	type = {"wild-gift/fire-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	message = "@Source@ roars!",
	equilibrium = 3,
	cooldown = 20,
	range = 0,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	tactical = { DEFEND = 1, DISABLE = { confusion = 3 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.PHYSICAL, self:mindCrit(self:combatTalentStatDamage(t, "str", 40, 400)))
		self:project(tg, self.x, self.y, DamageType.CONFUSION, {
			dur=3,
			dam=40 + 6 * self:getTalentLevel(t),
			power_check=function() return self:combatPhysicalpower() end,
			resist_check=self.combatPhysicalResist,
		})
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "shout", {additive=true, life=10, size=3, distorion_factor=0.5, radius=self:getTalentRadius(t), nb_circles=8, rm=0.8, rM=1, gm=0, gM=0, bm=0.1, bM=0.2, am=0.4, aM=0.6})
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 发 出 一 声 咆 哮 使 %d 码 半 径 范 围 内 的 敌 人 陷 入 彻 底 的 混 乱， 持 续 3 回 合。 
		 如 此 强 烈 的 咆 哮 使 你 的 敌 人 受 到 %0.2f 物 理 伤 害。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%%。]]):format(radius, self:combatTalentStatDamage(t, "str", 40, 400))
	end,
}

newTalent{
	name = "Wing Buffet",
	type = {"wild-gift/fire-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	equilibrium = 7,
	cooldown = 10,
	range = 0,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	tactical = { DEFEND = { knockback = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.PHYSKNOCKBACK, {dam=self:mindCrit(self:combatTalentStatDamage(t, "str", 15, 90)), dist=4})
		game:playSoundNear(self, "talents/breath")

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {life=18, x=bx, y=by, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		return ([[你 召 唤 一 股 %d 码 半 径 范 围 的 强 风 击 退 敌 人 4 码， 对 目 标 造 成 %d 点 伤 害。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%%。]]):format(self:getTalentRadius(t), self:combatTalentStatDamage(t, "str", 15, 90))
	end,
}

newTalent{
	name = "Devouring Flame",
	type = {"wild-gift/fire-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	equilibrium = 10,
	cooldown = 35,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	range = 10,
	radius = 2,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t)
		return self:combatTalentStatDamage(t, "wil", 15, 120)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local dam = self:mindCrit(t.getDamage(self, t))
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, duration,
			DamageType.FIRE, dam,
			radius,
			5, nil,
			{type="inferno"},
			nil, true
		)
		game:playSoundNear(self, "talents/devouringflame")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[你 喷 出 一 片 火 焰， 范 围 内 的 目 标 每 回 合 会 受 到 %0.2f 火 焰 伤 害（ 影 响 半 径 %d ）， 持 续 %d 回 合。 
		 受 意 志 影 响， 伤 害 有 额 外 加 成， 技 能 可 暴 击。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%%。]]):format(damDesc(self, DamageType.FIRE, dam), radius, duration)
	end,
}

newTalent{
	name = "Fire Breath",
	type = {"wild-gift/fire-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes fire!",
	tactical = { ATTACKAREA = { FIRE = 2 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIREBURN, {dam=self:mindCrit(self:combatTalentStatDamage(t, "str", 30, 550)), dur=3, initial=70})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})

		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {life=18, x=bx, y=by, fade=-0.006, deploy_speed=14}))
		end
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 火 焰。 此 范 围 内 的 目 标 会 在 3 回 合 内 受 到 %0.2f 火 焰 伤 害。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成， 暴 击 几 率 基 于 你 的 精 神 暴 击 率。 
		 每 点 火 龙 系 的 技 能 可 以 使 你 增 加 火 焰 抵 抗 1%%。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 550)))
	end,
}

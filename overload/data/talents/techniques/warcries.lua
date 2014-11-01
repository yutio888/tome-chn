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
	name = "Shattering Shout",
	type = {"technique/warcries", 1},
	require = techs_req_high1,
	points = 5,
	cooldown = 7,
	stamina = 20,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	requires_target = true,
	tactical = { ATTACKAREA = { PHYSICAL = 2 } },
	getdamage = function(self,t) return self:combatScale(self:getTalentLevel(t) * self:getStr(), 60, 10, 267, 500)  end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.PHYSICAL, t.getdamage(self,t))
		if self:getTalentLevel(t) >= 5 then
			self:project(tg, x, y, function(px, py)
				local proj = game.level.map(px, py, Map.PROJECTILE)
				if not proj then return end
				proj:terminate(x, y)
				game.level:removeEntity(proj, true)
				proj.dead = true
				self:logCombat(proj, "#Source# shatters '#Target#'.")
			end)
		end
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "directional_shout", {life=8, size=2, tx=x-self.x, ty=y-self.y, distorion_factor=0.1, radius=self:getTalentRadius(t), nb_circles=8, rm=0.8, rM=1, gm=0.8, gM=1, bm=0.1, bM=0.2, am=0.6, aM=0.8})
		return true
	end,
	info = function(self, t)
		return ([[一 次 强 有 力 的 怒 吼， 在 你 前 方 锥 形 区 域 内 造 成 %0.2f 物 理 伤 害（ 有 效 半 径 %d 码）。
		等 级 5 时 ， 怒 吼 变 得 如 此 强 烈 ， 范 围 内 的 抛 射 物 会 被 击 落。
		受 力 量 影 响， 伤 害 有 额 外 加 成。 ]])
		:format(damDesc(self, DamageType.PHYSICAL, t.getdamage(self,t)), t.radius(self,t))
	end,
}

newTalent{
	name = "Second Wind",
	type = {"technique/warcries", 2},
	require = techs_req_high2,
	points = 5,
	cooldown = 50,
	no_energy = true,
	tactical = { STAMINA = 2 },
	getRestore = function(self, t) return self:combatTalentLimit(t, 100, 27, 55) end,
	action = function(self, t)
		self:incStamina(t.getRestore(self, t)*self.max_stamina/ 100)
		return true
	end,
	info = function(self, t)
		return ([[做 一 次 深 呼 吸 并 恢 复 %d%% 体 力 值。]]):
		format(t.getRestore(self, t))
	end,
}

newTalent{
	name = "Battle Shout",
	type = {"technique/warcries", 3},
	require = techs_req_high3,
	points = 5,
	cooldown = 30,
	stamina = 5,
	tactical = { DEFEND = 2, BUFF = 1 },
	getdur = function(self,t) return math.floor(self:combatTalentLimit(t, 30, 7, 15)) end, -- Limit to < 30
	getPower = function(self, t) return self:combatTalentLimit(t, 50, 11, 25) end, -- Limit to < 50%
	action = function(self, t)
		self:setEffect(self.EFF_BATTLE_SHOUT, t.getdur(self,t), {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[当 你 鼓 舞 后， 提 高 你 %0.1f%% 生 命 值 和 体 力 值 上 限 持 续 %d 回 合。
		效 果 结 束 时 ， 增 加 的 生 命 和 体 力 会 消 失。]]):
		format(t.getPower(self, t), t.getdur(self, t))
	end,
}

newTalent{
	name = "Battle Cry",
	type = {"technique/warcries", 4},
	require = techs_req_high4,
	points = 5,
	cooldown = 30,
	stamina = 40,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	requires_target = true,
	tactical = { DISABLE = 2 },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_BATTLE_CRY, 7, {power=7 * self:getTalentLevel(t), apply_power=self:combatPhysicalpower()})
		end)
		game.level.map:particleEmitter(self.x, self.y, self:getTalentRadius(t), "directional_shout", {life=12, size=5, tx=x-self.x, ty=y-self.y, distorion_factor=0.1, radius=self:getTalentRadius(t), nb_circles=8, rm=0.8, rM=1, gm=0.8, gM=1, bm=0.1, bM=0.2, am=0.6, aM=0.8})
		return true
	end,
	info = function(self, t)
		return ([[你 的 怒 喝 会 减 少 %d 码 半 径 范 围 内 敌 人 的 意 志， 减 少 它 们 %d 闪 避， 持 续 7 回 合。 
		同 时， 所 有 的 闪 避 加 成 会 被 取 消。
		受 物 理 强 度 影 响， 命 中 率 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), 7 * self:getTalentLevel(t))
	end,
}

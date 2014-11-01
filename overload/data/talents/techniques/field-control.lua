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
	name = "Disengage",
	type = {"technique/field-control", 1},
	require = techs_dex_req1,
	points = 5,
	random_ego = "utility",
	cooldown = 12,
	stamina = 20,
	range = 7,
	tactical = { ESCAPE = 2 },
	requires_target = true,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		self:knockback(target.x, target.y, t.getDist(self, t))
		return true
	end,
	info = function(self, t)
		return ([[跳 离 你 的 目 标 %d 码。 ]]):format(t.getDist(self, t))
	end,
}

newTalent{
	name = "Track",
	type = {"technique/field-control", 2},
	require = techs_dex_req2,
	points = 5,
	random_ego = "utility",
	stamina = 20,
	cooldown = 20,
	radius = function(self, t) return math.floor(self:combatScale(self:getCun(10, true) * self:getTalentLevel(t), 5, 0, 55, 50)) end,
	no_npc_use = true,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		self:setEffect(self.EFF_SENSE, 3 + self:getTalentLevel(t), {
			range = rad,
			actor = 1,
		})
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[感 受 你 周 围 %d 码 半 径 范 围 敌 人 的 踪 迹， 持 续 %d 回 合。 
		受 灵 巧 影 响， 半 径 有 额 外 加 成。 ]]):format(rad, 3 + self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Heave",
	type = {"technique/field-control", 3},
	require = techs_dex_req3,
	points = 5,
	random_ego = "defensive",
	cooldown = 15,
	stamina = 5,
	tactical = { ESCAPE = { knockback = 1 }, DISABLE = { knockback = 3 } },
	requires_target = true,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- Try to knockback !
		local can = function(target)
			if target:checkHit(math.max(self:combatAttack(), self:combatPhysicalpower()), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then -- Deprecated Checkhit call
				return true
			else
				game.logSeen(target, "%s resists the knockback!", target.name:capitalize())
			end
		end

		if can(target) then 
			target:knockback(self.x, self.y, t.getDist(self, t), can)
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatPhysicalpower())
		end

		return true
	end,
	info = function(self, t)
		return ([[一 次 强 力 的 前 踢 使 你 的 目 标 被 击 退 %d 码。 
		如 果 有 另 外 一 个 怪 物 挡 在 路 上， 它 也 会 被 推 开。 
		受 敏 捷 或 物 理 强 度（ 取 较 大 值） 影 响， 击 退 概 率 有 额 外 加 成。 ]])
		:format(t.getDist(self, t))
	end,
}

newTalent{
	name = "Slow Motion",
	type = {"technique/field-control", 4},
	require = techs_dex_req4,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	range = 10,
	sustain_stamina = 80,
	tactical = { BUFF = 2 },
	activate = function(self, t)
		return {
			slow_projectiles = self:addTemporaryValue("slow_projectiles", math.min(90, 15 + self:getDex(10, true) * self:getTalentLevel(t))),
		}
	end,

	deactivate = function(self, t, p)
		self:removeTemporaryValue("slow_projectiles", p.slow_projectiles)
		return true
	end,
	info = function(self, t)
		return ([[你 敏 捷 的 身 手 允 许 你 看 见 飞 来 的 抛 射 物（ 法 术、 箭 矢 ……）， 减 慢 它 们 %d%% 速 度。]]):
		format(math.min(90, 15 + self:getDex(10, true) * self:getTalentLevel(t)))
	end,
}


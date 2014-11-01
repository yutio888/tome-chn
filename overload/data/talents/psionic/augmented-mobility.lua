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
	name = "Skate",
	type = {"psionic/augmented-mobility", 1},
	require = psi_wil_req1,
	points = 5,
	mode = "sustained",
	cooldown = 0,
	sustain_psi = 10,
	no_energy = true,
	tactical = { BUFF = 2 },
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.2, 0.5, 0.75) end,
	getKBVulnerable = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.8) end,
	activate = function(self, t)
		return {
			speed = self:addTemporaryValue("movement_speed", t.getSpeed(self, t)),
			knockback = self:addTemporaryValue("knockback_immune", -t.getKBVulnerable(self, t))
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("movement_speed", p.speed)
		self:removeTemporaryValue("knockback_immune", p.knockback)
		return true
	end,
	info = function(self, t)
		return ([[用 念 力 使 自 己 漂 浮 。
		这 使 你 能 在 战 斗 中 快 速 滑 行 ，增 加 你 的 移 动 速 度 %d%% 。
		它 同 样 使 你 更 容 易 被 推 开 (-%d%%  击 退 抗 性 )。]]): 
		format(t.getSpeed(self, t)*100, t.getKBVulnerable(self, t)*100) 
	end,
}

newTalent{
	name = "Quick as Thought",
	type = {"psionic/augmented-mobility", 2},
	require = psi_wil_req2,
	points = 5,
	random_ego = "utility",
	cooldown = 20,
	psi = 30,
	no_energy = true,
	getDuration = function(self, t) return math.floor(self:combatLimit(self:combatMindpower(0.1), 10, 4, 0, 6, 6)) end, -- Limit < 10
	speed = function(self, t) return self:combatTalentScale(t, 0.1, 0.4, 0.75) end,
	getBoost = function(self, t)
		return self:combatScale(self:combatTalentMindDamage(t, 20, 60), 0, 0, 50, 100, 0.75)
	end,
	action = function(self, t)
		self:setEffect(self.EFF_QUICKNESS, t.getDuration(self, t), {power=t.speed(self, t)})
		self:setEffect(self.EFF_CONTROL, t.getDuration(self, t), {power=t.getBoost(self, t)})
		return true
	end,
	info = function(self, t)
		local inc = t.speed(self, t)
		local percentinc = 100 * inc
		local boost = t.getBoost(self, t)
		return ([[用 灵 能 围 绕 你 的 躯 体 ，通 过 思 想 直 接 高 效 控 制 身 体 ，而 不 是 通 过 神 经 和 肌 肉 。
		增 加 %d 命 中  、%0.1f%% 暴 击 率 和 %d%% 攻 击 速 度， 持 续  %d  回 合。 
		受 精 神 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(boost, 0.5*boost, percentinc, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Mindhook",
	type = {"psionic/augmented-mobility", 3},
	require = psi_wil_req3,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 18, 10)) end, -- Limit to >5
	psi = 10,
	points = 5,
	tactical = { CLOSEIN = 2 },
	range = function(self, t) return self:combatTalentLimit(t, 10, 3, 7) end, -- Limit base range to 10
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, engine.Map.ACTOR)
		if not target then
			game.logPlayer(self, "The target is out of range")
			return
		end
		target:pull(self.x, self.y, tg.range)
		target:setEffect(target.EFF_DAZED, 1, {apply_power=self:combatMindpower()})
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[用 灵 能 将 远 处 的 敌 人 抓 过 来。
		至 多 对 半 径 %d 的 敌 人 有 效 。
		范 围 和 冷 却 时 间 受 技 能 等 级 影 响 。]]):
		format(range)
	end,
}

newTalent{
	name = "Telekinetic Leap",
	type = {"psionic/augmented-mobility", 4},
	require = psi_wil_req4,
	cooldown = 15,
	psi = 10,
	points = 5,
	tactical = { CLOSEIN = 2 },
	range = function(self, t)
		return math.floor(self:combatTalentLimit(t, 10, 2, 7.5)) -- Limit < 10
	end,
	action = function(self, t)
		local tg = {default_target=self, type="ball", nolock=true, pass_terrain=false, nowarning=true, range=self:getTalentRange(t), radius=0, requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end

		local fx, fy = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
		if not fx then
			return
		end
		self:move(fx, fy, true)

		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[使 用 灵 能  ，精  准 地 跳 向 %d 码 外 的 地 点。]]):
		format(range)
	end,
}

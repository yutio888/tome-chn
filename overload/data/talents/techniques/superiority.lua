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
	name = "Juggernaut",
	type = {"technique/superiority", 1},
	require = techs_req_high1,
	points = 5,
	random_ego = "attack",
	cooldown = 40,
	stamina = 50,
	no_energy = true,
	tactical = { DEFEND = 2 },
	critResist = function(self, t) return self:combatTalentScale(t, 8, 20, 0.75) end,
	getResist = function(self, t) return self:combatTalentScale(t, 15, 35) end,
	action = function(self, t)
		self:setEffect(self.EFF_JUGGERNAUT, 20, {power=t.getResist(self, t), crits=t.critResist(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[专 注 于 战 斗 并 忽 略 你 所 承 受 的 攻 击。 
		增 加 物 理 伤 害 减 免 %d%% 同 时 有 %d%% 几 率 摆 脱 暴 击 伤 害 ， 持 续 20 回 合。]]):
		format(t.getResist(self,t), t.critResist(self, t))
	end,
}

newTalent{
	name = "Onslaught",
	type = {"technique/superiority", 2},
	require = techs_req_high2,
	points = 5,
	mode = "sustained",
	cooldown = 10,
	no_energy = true,
	sustain_stamina = 10,
	tactical = { BUFF = 2 },
	range = function(self,t) return math.floor(self:combatTalentLimit(t, 10, 1, 5)) end, -- Limit KB range to <10
	activate = function(self, t)
		return {
			onslaught = self:addTemporaryValue("onslaught", t.range(self,t)), 
			stamina = self:addTemporaryValue("stamina_regen", -1),
		}
	end,

	deactivate = function(self, t, p)
		self:removeTemporaryValue("onslaught", p.onslaught)
		self:removeTemporaryValue("stamina_regen", p.stamina)
		return true
	end,
	info = function(self, t)
		return ([[采 取 一 个 猛 攻 姿 态， 当 你 经 过 你 的 敌 人 时， 你 会 将 前 方 弧 形 范 围 内 的 敌 人 全 部 击 退。（ 上 限 %d 码）。 
		这 个 姿 态 会 快 速 减 少 体 力 值（ -1 体 力 / 回 合）。]]):
		format(t.range(self, t))
	end,
}

newTalent{
	name = "Battle Call",
	type = {"technique/superiority", 3},
	require = techs_req_high3,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	stamina = 30,
	tactical = { CLOSEIN = 2 },
	range = 0,
	radius = function(self, t)
		return math.floor(self:combatTalentScale(t, 3, 7))
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local tx, ty = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if tx and ty and target:canBe("teleport") then
				target:move(tx, ty, true)
				game.logSeen(target, "%s is called to battle!", target.name:capitalize())
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[挑 衅 你 周 围 %d 码 半 径 范 围 内 的 敌 人 进 入 战 斗， 使 它 们 立 刻 进 入 近 战 状 态。]]):format(t.radius(self,t))
	end,
}

newTalent{
	name = "Shattering Impact",
	type = {"technique/superiority", 4},
	require = techs_req_high4,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_stamina = 40,
	tactical = { BUFF = 2 },
	weaponDam = function(self, t) return (self:combatTalentLimit(t, 1, 0.38, 0.6)) end, -- Limit < 100% weapon damage
	--Note: Shattering impact effect handled in mod.class.interface.Combat.lua : _M:attackTargetWith
	activate = function(self, t)
		return {
			dam = self:addTemporaryValue("shattering_impact", t.weaponDam(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("shattering_impact", p.dam)
		return true
	end,
	info = function(self, t)
		return ([[用 尽 全 身 的 力 量 挥 舞 武 器， 造 成 震 荡 波 冲 击 你 周 围 的 所 有 敌 人， 对 每 个 敌 人 造 成 %d%% 基 础 武 器 伤 害。
		一 回 合 至 多 产 生 一 次 冲 击 波 ， 第 一 个 目 标 不 会 受 到 额 外 伤 害。
		每 次 震 荡 攻 击 消 耗 8 点 体 力。]]):
		format(100*t.weaponDam(self, t))
	end,
}

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
	name = "Congeal Time",
	type = {"spell/temporal",1},
	require = spells_req1,
	points = 5,
	random_ego = "utility",
	mana = 10,
	cooldown = 30,
	tactical = { DISABLE = 2 },
	reflectable = true,
	proj_speed = 2,
	range = 6,
	direct_hit = true,
	requires_target = true,
	getSlow = function(self, t) return math.min(self:getTalentLevel(t) * 0.08, 0.6) end,
	getProj = function(self, t) return math.min(90, 5 + self:combatTalentSpellDamage(t, 5, 700) / 10) end,
	action = function(self, t)
		local tg = {type="beam", range=self:getTalentRange(t), talent=t, display={particle="bolt_arcane"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.CONGEAL_TIME, {
			slow = 1 - 1 / (1 + t.getSlow(self, t)),
			proj = t.getProj(self, t),
		}, {type="manathrust"})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local proj = t.getProj(self, t)
		return ([[制 造 一 个 扭 曲 时 间 的 力 场， 减 少 目 标 %d%% 的 整 体 速 度， 目 标 所 释 放 的 抛 射 物 减 速 %d%% ， 持 续 7 回 合。]]):
		format(100 * slow, proj)
	end,
}

newTalent{
	name = "Time Shield",
	type = {"spell/temporal", 2},
	require = spells_req2,
	points = 5,
	mana = 25,
	cooldown = 18,
	tactical = { DEFEND = 2 },
	range = 10,
	no_energy = true,
	getMaxAbsorb = function(self, t) return 50 + self:combatTalentSpellDamage(t, 50, 450) end,
	getDuration = function(self, t) return util.bound(5 + math.floor(self:getTalentLevel(t)), 5, 15) end,
	getTimeReduction = function(self, t) return 25 + util.bound(15 + math.floor(self:getTalentLevel(t) * 2), 15, 35) end,
	action = function(self, t)
		self:setEffect(self.EFF_TIME_SHIELD, t.getDuration(self, t), {power=t.getMaxAbsorb(self, t), dot_dur=5, time_reducer=t.getTimeReduction(self, t)})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		local time_reduc = t.getTimeReduction(self,t)
		return ([[这 个 复 杂 的 法 术 在 施 法 者 周 围 立 刻 制 造 一 个 时 间 屏 障， 吸 收 你 受 到 的 伤 害。 
		 一 旦 达 到 最 大 伤 害 吸 收 值（ %d ） 或 持 续 时 间（ %d 回 合） 结 束， 存 储 的 能 量 会 治 疗 你， 持 续 5 回合 ，每 回 合 回 复 总 吸 收 伤 害 的 10%% ( 强 化 护 盾 技 能 会 影 响 该 系 数 )。   
		 当 激 活 时 光 之 盾 时， 所 有 新 获 得 的 负 面 魔 法、 物 理 和 精 神 效 果 都 会 减 少 %d%% 回 合 的 持 续 时 间。 
		 受 法 术 强 度 影 响， 最 大 吸 收 值 有 额 外 加 成。 ]]):
		format(maxabsorb, duration, time_reduc)
	end,
}

newTalent{
	name = "Time Prison",
	type = {"spell/temporal", 3},
	require = spells_req3,
	points = 5,
	random_ego = "utility",
	mana = 100,
	cooldown = 40,
	tactical = { DISABLE = 1, ESCAPE = 3, PROTECT = 3 },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.03) * self:getTalentLevel(t), 4, 0, 12, 8)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.TIME_PRISON, t.getDuration(self, t), {type="manathrust"})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[将 目 标 从 时 光 的 流 动 中 移 出， 持 续 %d 回 合。 
		 在 此 状 态 下， 目 标 不 能 动 作 也 不 能 被 伤 害。 
		 对 于 目 标 来 说， 时 间 是 静 止 的， 技 能 无 法 冷 却， 也 没 有 能 量 回 复 … … 
		 受 法 术 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(duration)
	end,
}

newTalent{
	name = "Essence of Speed",
	type = {"spell/temporal",4},
	require = spells_req4,
	points = 5,
	mode = "sustained",
	sustain_mana = 250,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getHaste = function(self, t) return self:combatTalentScale(t, 0.09, 0.45, 0.75) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local power = t.getHaste(self, t)
		return {
			speed = self:addTemporaryValue("global_speed_add", power),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("global_speed_add", p.speed)
		return true
	end,
	info = function(self, t)
		local haste = t.getHaste(self, t)
		return ([[增 加 施 法 者 %d%% 整 体 速 度。]]):
		format(100 * haste)
	end,
}

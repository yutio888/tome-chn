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
	name = "Meditation",
	type = {"wild-gift/call", 1},
	require = gifts_req1,
	points = 5,
	message = "@Source@ meditates on nature.",
	mode = "sustained",
	cooldown = 20,
	range = 10,
	no_npc_use = true,
	no_energy = true,
	on_learn = function(self, t)
		self.equilibrium_regen_on_rest = (self.equilibrium_regen_on_rest or 0) - 0.5
	end,
	on_unlearn = function(self, t)
		self.equilibrium_regen_on_rest = (self.equilibrium_regen_on_rest or 0) + 0.5
	end,
	activate = function(self, t)
		local ret = {}
		
		local boost = 1 + (self.enhance_meditate or 0)

		local pt = (2 + self:combatTalentMindDamage(t, 20, 120) / 10) * boost
		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
		
		if self:knowTalent(self.T_EARTH_S_EYES) then
			local te = self:getTalentFromId(self.T_EARTH_S_EYES)
			self:talentTemporaryValue(ret, "esp_all", 1)
			self:talentTemporaryValue(ret, "esp_range", te.radius_esp(self, te) - 10)
		end

		game:playSoundNear(self, "talents/heal")
		self:talentTemporaryValue(ret, "equilibrium_regen", -pt)
		self:talentTemporaryValue(ret, "combat_mentalresist", save)
		self:talentTemporaryValue(ret, "healing_factor", heal / 100)
		self:talentTemporaryValue(ret, "numbed", 50)
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local boost = 1 + (self.enhance_meditate or 0)
		
		local pt = (2 + self:combatTalentMindDamage(t, 20, 120) / 10) * boost
		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
		local rest = 0.5 * self:getTalentLevelRaw(t)
		return ([[你 进 入 冥 想， 与 大 自 然 进 行 沟 通。 
		 冥 想 时 每 回 合 你 能 回 复 %d 失 衡 值， 你 的 精 神 豁 免 提 高 %d ， 你 的 治 疗 效 果 提 高 %d%% 。 
		 冥 想 时 你 无 法 集 中 精 力 攻 击， 你 造 成 的 伤 害 减 少 50％。 
		 另 外， 你 在 休 息 时（ 即 使 未 开 启 冥 想） 会 自 动 进 入 冥 想 状 态， 使 你 每 回 合 能 回 复 %d 点 失 衡 值。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(pt, save, heal, rest)
	end,
}

newTalent{ short_name = "NATURE_TOUCH",
	name = "Nature's Touch",
	type = {"wild-gift/call", 2},
	require = gifts_req2,
	random_ego = "defensive",
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	range = 1,
	requires_target = true,
	tactical = { HEAL = 2 },
	is_heal = true,
	action = function(self, t)
		local tg = {default_target=self, type="hit", nowarning=true, range=self:getTalentRange(t), first_target="friend"}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		if not target:attr("undead") then
			target:attr("allow_on_heal", 1)
			target:heal(self:mindCrit(20 + self:combatTalentMindDamage(t, 20, 500)), self)
			target:attr("allow_on_heal", -1)
			if core.shader.active(4) then
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[对 你 自 己 或 某 个 目 标 注 入 大 自 然 的 能 量， 治 疗 %d 点 生 命 值（ 对 不 死 族 无 效）。 
		 受 精 神 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(20 + self:combatTalentMindDamage(t, 20, 500))
	end,
}

newTalent{
	name = "Earth's Eyes",
	type = {"wild-gift/call", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "utility",
	equilibrium = 3,
	cooldown = 10,
	radius = function(self, t) return math.ceil(self:combatTalentScale(t, 6.1, 11.5)) end,
	radius_esp = function(self, t) return math.floor(self:combatTalentScale(t, 3.5, 5.5)) end,
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		self:magicMap(self:getTalentRadius(t), self.x, self.y)
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local radius_esp = t.radius_esp(self, t)
		return ([[利 用 你 与 大 自 然 的 联 系， 你 可 以 查 看 自 身 周 围 %d 码 半 径 范 围 的 区 域。 
		 同 时， 当 你 处 于 冥 想 状 态 时， 你 还 可 以 查 看 自 身 周 围 %d 码 半 径 范 围 中 怪 物 的 位 置。]]):
		format(radius, radius_esp)
	end,
}

newTalent{
	name = "Nature's Balance",
	type = {"wild-gift/call", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 20,
	cooldown = 50,
	range = 10,
	tactical = { BUFF = 2 },
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return self:getTalentLevel(t) end,
	action = function(self, t)
		local nb = t.getTalentCount(self, t)
		local maxlev = t.getMaxLevel(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[2] <= maxlev and tt.type[1]:find("^wild%-gift/") then
				tids[#tids+1] = tid
			end
		end
		for i = 1, nb do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self.changed = true
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[你 与 大 自 然 间 的 深 刻 联 系， 使 你 能 够 立 刻 冷 却 %d 个 技 能 层 次 不 超 过 %d 的 自 然 系 技 能。]]):
		format(t.getTalentCount(self, t), t.getMaxLevel(self, t))
	end,
}


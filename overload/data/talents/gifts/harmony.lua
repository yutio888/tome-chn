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
	name = "Waters of Life",
	type = {"wild-gift/harmony", 1},
	require = gifts_req1,
	points = 5,
	cooldown = 30,
	equilibrium = 10,
	tactical = { HEAL=2 },
	no_energy = true,
	on_pre_use = function(self, t)
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.disease or e.subtype.poison then
				return true
			end
		end
		return false
	end,
	is_heal = true,
	getdur = function(self,t) return math.floor(self:combatTalentLimit(t, 30, 6, 10)) end, -- limit to <30
	action = function(self, t)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.disease or e.subtype.poison then
				nb = nb + 1
			end
		end
		self:heal(self:mindCrit(nb * self:combatTalentStatDamage(t, "wil", 20, 60)), self)
		self:setEffect(self.EFF_WATERS_OF_LIFE, t.getdur(self,t), {})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[生 命 之 水 流 过 你 的 身 体， 净 化 你 身 上 的 毒 素 或 疾 病 效 果。 
		 在 %d 回 合 内 所 有 的 毒 素 或 疾 病 效 果 都 无 法 伤 害 却 能 治 疗 你。 
		 当 此 技 能 激 活 时， 你 身 上 每 有 1 种 毒 素 或 疾 病 效 果， 恢 复 %d 点 生 命。 
		 受 意 志 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(t.getdur(self,t), self:combatTalentStatDamage(t, "wil", 20, 60))
	end,
}

newTalent{
	name = "Elemental Harmony",
	type = {"wild-gift/harmony", 2},
	require = gifts_req2,
	points = 5,
	mode = "sustained",
	sustain_equilibrium = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	-- The effect "ELEMENTAL_HARMONY" is defined in data\timed_effects\physical.lua and the duration applied in setDefaultProjector function in data\damagetypes.lua	
	duration = function(self,t) return math.floor(self:combatTalentScale(t, 6, 10, "log"))  end,
	fireSpeed = function(self, t) return self:combatTalentScale(t, 0.1 + 1/16, 0.1 + 5/16, 0.75) end,
	activate = function(self, t)
		return {
			tmpid = self:addTemporaryValue("elemental_harmony", self:getTalentLevel(t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("elemental_harmony", p.tmpid)
		return true
	end,
	info = function(self, t)
		local power = self:getTalentLevel(t)
		local turns = t.duration(self, t)
		local fire = 100 * t.fireSpeed(self, t)
		local cold = 3 + power * 2
		local lightning = math.floor(power)
		local acid = 5 + power * 2
		local nature = 5 + power * 1.4
		return ([[通 过 自 然 协 调 与 元 素 们 成 为 朋 友。 每 当 你 被 某 种 元 素 攻 击 时， 你 可 以 获 得 对 应 效 果， 持 续 %d 回 合。 每 %d 回 合 只 能 触 发 一 次。 
		 火 焰： +%d%% 全 部 速 度 
		 寒 冷： +%d 护 甲 值 
		 闪 电： +%d 所 有 属 性 
		 酸 液： +%0.2f 生 命 回 复 
		 自 然： +%d%% 所 有 抵 抗]]):
		format(turns, turns, fire, cold, lightning, acid, nature)
	end,
}

newTalent{
	name = "One with Nature",
	type = {"wild-gift/harmony", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 15,
	cooldown = 30,
	no_energy = true,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t) return self:hasEffect(self.EFF_INFUSION_COOLDOWN) end,
	action = function(self, t)
		self:removeEffect(self.EFF_INFUSION_COOLDOWN)
		local tids = {}
		local nb = self:getTalentLevelRaw(t)
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[1] == "inscriptions/infusions" and self:isTalentCoolingDown(tt) then tids[#tids+1] = tid end
		end
		for i = 1, nb do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = self.talents_cd[tid] - (1 + math.floor(self:getTalentLevel(t) / 2))
			if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
		end
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local turns = 1 + math.floor(self:getTalentLevel(t) / 2)
		local nb = self:getTalentLevelRaw(t)
		return ([[与 自 然 交 流， 移 除 纹 身 类 技 能 饱 和 效 果 并 减 少 %d 种 纹 身 %d 回 合 冷 却 时 间。]]):
		format(nb, turns)
	end,
}

newTalent{
	name = "Healing Nexus",
	type = {"wild-gift/harmony", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 24,
	cooldown = 20,
	range = 10,
	tactical = { DISABLE = 3, HEAL = 0.5 },
	direct_hit = true,
	requires_target = true,
	range = 0,
	radius = function(self, t) return 1 + self:getTalentLevelRaw(t) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=true, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_HEALING_NEXUS, 3 + self:getTalentLevelRaw(t), {src=self, pct=0.4 + self:getTalentLevel(t) / 10, eq=5 + self:getTalentLevel(t)})
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_acid", {radius=tg.radius})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[在 你 的 身 旁 %d 码 半 径 范 围 内 流 动 着 一 波 自 然 能 量， 所 有 被 击 中 的 敌 人 都 会 受 到 治 疗 转 移 的 效 果， 持 续 %d 回 合。 
		 当 此 技 能 激 活 时， 所 有 对 敌 人 的 治 疗 都 会 转 移 到 你 身 上， 继 承 %d%% 治 疗 价 值。（ 敌 人 不 受 到 治 疗） 
		 每 次 治 疗 转 移 同 时 会 回 复 %d 点 自 然 失 衡 值。]]):
		format(self:getTalentRadius(t), 3 + self:getTalentLevelRaw(t), (0.4 + self:getTalentLevel(t) / 10) * 100, 5 + self:getTalentLevel(t))
	end,
}

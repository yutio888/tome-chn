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
	name = "Energy Decomposition",
	type = {"chronomancy/energy",1},
	mode = "sustained",
	require = chrono_req1,
	points = 5,
	sustain_paradox = 75,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getAbsorption = function(self, t) return self:combatTalentSpellDamage(t, 5, 150) end, -- Increase shield strength
	on_damage = function(self, t, damtype, dam)
		if not DamageType:get(damtype).antimagic_resolve then return dam end
		local absorb = t.getAbsorption(self, t)
		-- works like armor with 30% hardiness for projected energy effects
		dam = math.max(dam * 0.3 - absorb, 0) + (dam * 0.7)
		print("[PROJECTOR] after static reduction dam", dam)
		return dam
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			particle = self:addParticles(Particles.new("temporal_focus", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local absorption = t.getAbsorption(self, t)
		return ([[减 少 30%% 所 有 能 量 伤 害（ 精 神 和 物 理 伤 害 除 外）， 最 多 减 少 %d 点 伤 害。 
		 受 法 术 强 度 影 响， 减 伤 值 按 比 例 加 成。]]):format(absorption)
	end,
}

newTalent{
	name = "Entropic Field",
	type = {"chronomancy/energy",2},
	mode = "sustained",
	require = chrono_req2,
	points = 5,
	sustain_paradox = 100,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getPower = function(self, t) return math.min(90, 10 + (self:combatTalentSpellDamage(t, 10, 50))) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			particle = self:addParticles(Particles.new("time_shield", 1)),
			phys = self:addTemporaryValue("resists", {[DamageType.PHYSICAL]=t.getPower(self, t)/2}),
			proj = self:addTemporaryValue("slow_projectiles", t.getPower(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("resists", p.phys)
		self:removeTemporaryValue("slow_projectiles", p.proj)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[制 造 一 个 领 域 围 绕 自 己， 减 少 所 有 抛 射 物 %d%% 的 速 度 并 增 加 %d%% 物 理 伤 害 抵 抗。 
		 受 法 术 强 度 影 响， 效 果 按 比 例 加 成。]]):format(power, power / 2)
	end,
}

newTalent{
	name = "Energy Absorption",
	type = {"chronomancy/energy", 3},
	require = chrono_req3,
	points = 5,
	paradox = 10,
	cooldown = 10,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	range = 6,
	getTalentCount = function(self, t)
		return 1 + math.floor(self:combatTalentScale(math.max(1, self:getTalentLevel(t) * getParadoxModifier(self, pm)), 0.5, 2.5, "log"))
	end,
	getCooldown = function(self, t) return math.ceil(self:combatTalentScale(t, 1, 2.6)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		tx, ty = checkBackfire(self, tx, ty)
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target then return end

		if not self:checkHit(self:combatSpellpower(), target:combatSpellResist()) then
			game.logSeen(target, "%s resists!", target.name:capitalize())
			return true
		end

		local tids = {}
		for tid, lev in pairs(target.talents) do
			local t = target:getTalentFromId(tid)
			if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end

		local count = 0
		local cdr = t.getCooldown(self, t)

		for i = 1, t.getTalentCount(self, t) do
			local t = rng.tableRemove(tids)
			if not t then break end
			target.talents_cd[t.id] = cdr
			game.logSeen(target, "%s's %s is disrupted by the Energy Absorption!", target.name:capitalize(), t.name)
			count = count + 1
		end

		if count >= 1 then
			local tids = {}
			for tid, _ in pairs(self.talents_cd) do
				local tt = self:getTalentFromId(tid)
				if tt.type[1]:find("^chronomancy/") then
					tids[#tids+1] = tid
				end
			end
			for i = 1, count do
				if #tids == 0 then break end
				local tid = rng.tableRemove(tids)
				self.talents_cd[tid] = self.talents_cd[tid] - cdr
			end
		end
		target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
		game.level.map:particleEmitter(tx, ty, 1, "generic_charge", {rm=10, rM=110, gm=10, gM=50, bm=20, bM=125, am=25, aM=255})
		game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=200, rM=255, gm=200, gM=255, bm=200, bM=255, am=125, aM=125})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local cooldown = t.getCooldown(self, t)
		return ([[你 吸 取 并 得 到 目 标 的 能 量 ， 将 对 方 至 多 %d 个 技 能 打 入 冷 却 。 每 有 一 个 技 能 被 打 入 冷 却 ， 你 的 一 个 时 空 系 技 能 的 冷 却 减 少 %d 个 回 合 。
		 受 紊 乱 值 影 响， 受 影 响 的 技 能 数 目 按 比 例 加 成。]]):
		format(talentcount, cooldown, cooldown)
	end,
}

newTalent{
	name = "Redux",
	type = {"chronomancy/energy",4},
	require = chrono_req4,
	points = 5,
	paradox = 20,
	cooldown = 12,
	tactical = { BUFF = 2 },
	no_energy = true,
	getMaxLevel = function(self, t) return self:getTalentLevel(t) end,
	action = function(self, t)
		-- effect is handled in actor postUse
		self:setEffect(self.EFF_REDUX, 5, {})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[复 制 5 回 合 内 释 放 的 下 1 个 时 空 系 主 动 技 能（ 最 大 天 赋 等 级 %0.1f ）， 复 制 的 技 能 将 在 此 技 能 释 放 后 的 下 一 回 合 释 放。 
		 紊 乱 值 会 在 被 复 制 的 技 能 释 放 时 消 耗 且 二 次 施 法 仍 需 消 耗 1 回 合。 
		 此 技 能 不 需 要 施 法 时 间。]]):
		format(maxlevel)
	end,
}

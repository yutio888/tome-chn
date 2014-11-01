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
	name = "Static History",
	type = {"chronomancy/timetravel", 1},
	require = chrono_req1,
	points = 5,
	message = "@Source@ rearranges history.",
	cooldown = 24,
	tactical = { PARADOX = 2 },
	getDuration = function(self, t)
		local duration = math.floor(self:combatTalentScale(t, 1.5, 3.5))
		if self:knowTalent(self.T_PARADOX_MASTERY) then
			duration = duration + self:callTalent(self.T_PARADOX_MASTERY, "stabilityDuration")
		end
		return duration
	end,
	getReduction = function(self, t) return self:combatTalentSpellDamage(t, 20, 200) end,
	action = function(self, t)
		self:incParadox (- t.getReduction(self, t))
		game:playSoundNear(self, "talents/spell_generic")
		self:setEffect(self.EFF_SPACETIME_STABILITY, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local reduction = t.getReduction(self, t)
		local duration = t.getDuration(self, t)
		return ([[通 过 微 调 历 史， 你 减 少 %d 点 紊 乱 值 并 暂 时 稳 定 时 间 线； 允 许 你 使 用 时 空 系 技 能 时 不 会 失 败（ 走 火 和 变 异 仍 会 出 现）， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 紊 乱 值 有 额 外 减 少。]]):
		format(reduction, duration)
	end,
}

newTalent{
	name = "Time Skip",
	type = {"chronomancy/timetravel",2},
	require = chrono_req2,
	points = 5,
	cooldown = 6,
	paradox = 5,
	tactical = { ATTACK = {TEMPORAL = 1}, DISABLE = 2 },
	range = 6,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 250) * getParadoxModifier(self, pm) end,
	getDuration = function(self, t) return 2 + math.ceil(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 0.3, 2.3)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end

		if target:attr("timetravel_immune") then
			game.logSeen(target, "%s is immune!", target.name:capitalize())
			return
		end

		local power = self:combatSpellpower() * (1 + self:callTalent(self.T_SPACETIME_MASTERY, "getPower"))
		local hit = self:checkHit(power, target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
		if not hit then game.logSeen(target, "%s resists!", target.name:capitalize()) return true end
		self:project(tg, x, y, DamageType.TEMPORAL, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(x, y, 1, "temporal_thrust")
		game:playSoundNear(self, "talents/arcane")
		if target.dead or target.player then return true end
		target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		
		-- Replace the target with a temporal instability for a few turns
		local oe = game.level.map(target.x, target.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return true end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = "temporal instability", image = oe.image, add_mos = {{image="object/temporal_instability.png"}},
			display = '&', color=colors.LIGHT_BLUE,
			temporary = t.getDuration(self, t),
			canAct = false,
			target = target,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				-- return the rifted actor
				if self.temporary <= 0 then
					game.level.map(self.target.x, self.target.y, engine.Map.TERRAIN, self.old_feat)
					game.nicer_tiles:updateAround(game.level, self.target.x, self.target.y)
					game.level:removeEntity(self)
					local mx, my = util.findFreeGrid(self.target.x, self.target.y, 20, true, {[engine.Map.ACTOR]=true})
					local old_levelup = self.target.forceLevelup
					self.target.forceLevelup = function() end
					game.zone:addEntity(game.level, self.target, "actor", mx, my)
					self.target.forceLevelup = old_levelup
				end
			end,
			summoner_gain_exp = true, summoner = self,
		}
		
		game.logSeen(target, "%s has moved forward in time!", target.name:capitalize())
		game.level:removeEntity(target, true)
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN, e)
		game.nicer_tiles:updateAround(game.level, x, y)
		game.level.map:updateMap(x, y)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[如 果 目 标 法 术 豁 免 判 定 失 败， 则 造 成 %0.2f 时 空 伤 害。 如 果 目 标 仍 活 着， 则 会 被 移 出 时 间 %d 回 合。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成； 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 值 按 比 例 加 成。]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
}

newTalent{
	name = "Echoes From The Past",
	type = {"chronomancy/timetravel", 3},
	require = chrono_req3,
	points = 5,
	paradox = 10,
	cooldown = 6,
	tactical = { ATTACKAREA = {TEMPORAL = 2} },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return (self:combatTalentSpellDamage(t, 18, 160)*getParadoxModifier(self, pm)) end,
	getPercent = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 1, 10), 0.5, .1, 0, 0.1575, 5.75) end, -- Limit to <50%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.TEMPORAL, self:spellCrit(t.getDamage(self, t)))
		self:project(tg, self.x, self.y, DamageType.TEMPORAL_ECHO, t.getPercent(self, t))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_temporal", {radius=tg.radius})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local percent = t.getPercent(self, t) * 100
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[在 你 周 围 %d 码 半 径 范 围 内 制 造 1 个 时 空 回 响。 目 标 会 受 到 %0.2f 时 空 伤 害 和 %d%% 总 损 失 生 命 值 的 额 外 时 空 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 比 例 和 伤 害 按 比 例 加 成。]]):
		format(radius, damDesc(self, DamageType.TEMPORAL, damage), percent)
	end,
}

newTalent{
	name = "Temporal Reprieve",
	type = {"chronomancy/timetravel", 4},
	require = chrono_req4,
	points = 5,
	paradox = 20,
	cooldown = 50,
	tactical = { BUFF = 0.5, CURE = 0.5 },
	message = "@Source@ manipulates the flow of time.",
	getCooldownReduction = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 2, 6)) end,
	action = function(self, t)
		-- update cooldowns
		for tid, cd in pairs(self.talents_cd) do
			self.talents_cd[tid] = cd - t.getCooldownReduction(self, t)
		end

		local target = self
		local todel = {}
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.type ~= "other" then
				p.dur = p.dur - t.getCooldownReduction(self, t)
				if p.dur <= 0 then todel[#todel+1] = eff end
			end
		end
		while #todel > 0 do
			target:removeEffect(table.remove(todel))
		end

		return true
	end,
	info = function(self, t)
		local reduction = t.getCooldownReduction(self, t)
		return ([[控 制 时 间 的 流 动， 减 少 所 有 技 能 %d 回 合 冷 却 时 间 并 减 少 大 部 分 状 态 效 果（ 无 论 好 坏） %d 回 合 持 续 时 间。 
		 受 紊 乱 值 影 响， 效 果 按 比 例 加 成。]]):
		format(reduction, reduction)
	end,
}

--[=[
newTalent{
	name = "Door to the Past",
	type = {"chronomancy/timetravel", 4},
	require = chrono_req4, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	sustain_paradox = 150,
	cooldown = 25,
	no_npc_use = true,
	getAnomalyCount = function(self, t) return math.ceil(self:getTalentLevel(t)) end,
	on_learn = function(self, t)
		if not self:knowTalent(self.T_REVISION) then
			self:learnTalent(self.T_REVISION, nil, nil, {no_unlearn=true})
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:unlearnTalent(self.T_REVISION)
		end
	end,
	do_anomalyCount = function(self, t)
		if self.dttp_anomaly_count == 0 then
			-- check for anomaly
			if not game.zone.no_anomalies and not self:attr("no_paradox_fail") and self:paradoxAnomalyChance() then
				-- Random anomaly
				local ts = {}
				for id, t in pairs(self.talents_def) do
					if t.type[1] == "chronomancy/anomalies" then ts[#ts+1] = id end
				end
				if not silent then game.logPlayer(self, "Your Door to the Past has caused an anomaly!") end
				self:forceUseTalent(rng.table(ts), {ignore_energy=true})
			end
			-- reset count
			self.dttp_anomaly_count = t.getAnomalyCount(self, t)
		else
			self.dttp_anomaly_count = self.dttp_anomaly_count - 1
		end
	end,
	activate = function(self, t)
		if checkTimeline(self) == true then
			return
		end

		-- set the counter
		self.dttp_anomaly_count = t.getAnomalyCount(self, t)

		game:playSoundNear(self, "talents/arcane")
		return {
			game:onTickEnd(function()
				game:chronoClone("revision")
			end),
			particle = self:addParticles(Particles.new("temporal_aura", 1)),
		}
	end,
	deactivate = function(self, t, p)
		if game._chronoworlds then game._chronoworlds = nil end
		self.dttp_anomaly_count = nil
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local count = t.getAnomalyCount(self, t)
		return ([[这 个 强 大 的 法 术 允 许 你 标 记 一 个 时 间 点， 你 可 以 使 用 时 空 校 正 返 回 ( 学 习 此 技 能 后 会 自 动 习 得 )。 维 持 这 样 一 个 传 送 门 会 打 断 时 空 的 连 续 性， 并 且 每 隔 %d 回 合 可 能 会 触 发 一 个 变 异 ( 基 于 你 当 前 的 变 异 几 率 )。  
		这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。 
		技 能 等 级 的 提 升 会 增 加 鉴 定 变 异 的 回 合 间 隔。]]):
		format(count)
	end,
}

newTalent{
	name = "Revision",
	type = {"chronomancy/other", 1},
	type_no_req = true,
	points = 1,
	message = "@Source@ revises history.",
	cooldown = 50,
	paradox = 25,
	no_npc_use = true,
	on_pre_use = function(self, t, silent) if not self:isTalentActive(self.T_DOOR_TO_THE_PAST) then if not silent then game.logPlayer(self, "Door to the Past must be active to use this talent.") end return false end return true end,
	no_unlearn_last = true,
	action = function(self, t)

		-- Prevent Revision After Death
		if game._chronoworlds == nil then
			game.logPlayer(game.player, "#LIGHT_RED#Your spell fizzles.")
			return
		end

		game:onTickEnd(function()
			if not game:chronoRestore("revision", true) then
				game.logSeen(self, "#LIGHT_RED#The spell fizzles.")
				return
			end
			game.logPlayer(game.player, "#LIGHT_BLUE#You unfold the spacetime continuum to a previous state!")

			-- Manualy start the cooldown of the "old player"
			game.player:startTalentCooldown(t)
			game.player:incParadox(t.paradox * (1 + (game.player.paradox / 300)))
			game.player:forceUseTalent(game.player.T_DOOR_TO_THE_PAST, {ignore_energy=true})
			-- remove anomaly count
			if self.dttp_anomaly_count then self.dttp_anomaly_count = nil end
			if game._chronoworlds then game._chronoworlds = nil end
		end)

		return true
	end,
	info = function(self, t)
		return ([[使 用 时 空 校 正 会 将 你 传 送 到 先 前 标 记 的 时 间 点。]])
		:format()
	end,
}]=]

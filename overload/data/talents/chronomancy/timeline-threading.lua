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
	name = "Gather the Threads",
	type = {"chronomancy/timeline-threading", 1},
	require = chrono_req_high1,
	points = 5,
	paradox = 5,
	cooldown = 12,
	tactical = { BUFF = 2 },
	getThread = function(self, t) return self:combatTalentScale(t, 7, 30, 0.75) end,
	getReduction = function(self, t) return self:combatTalentScale(t, 3.6, 15, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_GATHER_THE_THREADS, 5, {power=t.getThread(self, t), reduction=t.getReduction(self, t)})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local primary = t.getThread(self, t)
		local reduction = t.getReduction(self, t)
		return ([[你 开 始 从 其 他 时 间 线 搜 集 能 量， 初 始 增 加 %0.2f 法 术 强 度 并 且 每 回 合 逐 渐 增 加 %0.2f 法 术 强 度。 
		 此 效 果 会 因 为 使 用 技 能 而 中 断， 否 则 此 技 能 会 在 5 回 合 后 结 束。 
		 当 此 技 能 激 活 时， 每 回 合 你 的 紊 乱 值 会 降 低 %d 点。 
		 此 技 能 不 会 打 断 时 空 调 谐， 激 活 时 空 调 谐 技 能 也 同 样 不 会 打 断 此 技 能。]]):format(primary + (primary/5), primary/5, reduction)
	end,
}

newTalent{
	name = "Rethread",
	type = {"chronomancy/timeline-threading", 2},
	require = chrono_req_high2,
	points = 5,
	paradox = 5,
	cooldown = 4,
	tactical = { ATTACK = {TEMPORAL = 2} },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 200)*getParadoxModifier(self, pm) end,
	getReduction = function(self, t) return self:combatTalentScale(t, 1.2, 5, 0.75) end,
	action = function(self, t)
		local tg = {type="beam", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y, t.paradox)
		x, y = checkBackfire(self, x, y)
		self:project(tg, x, y, DamageType.RETHREAD, {dam=self:spellCrit(t.getDamage(self, t)), reduction = t.getReduction(self, t)})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "temporalbeam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local reduction = t.getReduction(self, t)
		return ([[你 重 组 时 间 线 的 同 时 引 发 时 空 能 量， 发 射 一 束 射 线 造 成 %0.2f 伤 害。 
		 受 影 响 目 标 会 被 震 慑、 致 盲、 定 身 或 混 乱 3 回 合。 
		 每 一 个 被 时 空 重 组 攻 击 的 敌 人 会 减 少 你 %0.1f 点 紊 乱 值。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), reduction)
	end,
}

newTalent{
	name = "Temporal Clone",
	type = {"chronomancy/timeline-threading", 3},
	require = chrono_req_high3,
	points = 5,
	cooldown = 30,
	paradox = 15,
	tactical = { ATTACK = 2, DISABLE = 2 },
	requires_target = true,
	range = 6,
	no_npc_use = true,
	getDuration = function(self, t) -- limit < cooldown (30)
		return math.floor(self:combatTalentLimit(self:getTalentLevel(t)* getParadoxModifier(self, pm), t.cooldown, 4, 8))
	end,
	getSize = function(self, t) return 2 + math.ceil(self:getTalentLevelRaw(t) / 2 ) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		if not tx or not ty then return nil end
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target or self:reactionToward(target) >= 0 then return end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local allowed = t.getSize(self, t)

		if target.rank >= 3.5 or -- No boss
			target:reactionToward(self) >= 0 or -- No friends
			target.size_category > allowed
			then
			game.logSeen(target, "%s resists!", target.name:capitalize())
			return true
		end

		local m = target:cloneFull{
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			exp_worth = 0, -- bug fix
			summon_time = t.getDuration(self, t),
			ai_target = {actor=target},
			ai = "summoned", ai_real = target.ai,
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil
		
		m.energy.value = 0
		m.life = m.life
		m.forceLevelup = function() end
		-- Handle special things
		m.on_die = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		if m.talents.T_SUMMON then m.talents.T_SUMMON = nil end
		if m.talents.T_MULTIPLY then m.talents.T_MULTIPLY = nil end

		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "temporal_teleport")

		-- force target to attack double
		local a = game.level.map(tx, ty, Map.ACTOR)
		if a and self:reactionToward(a) < 0 then
			a:setTarget(m)
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local allowed = t.getSize(self, t)
		local size = "gargantuan"
		if allowed < 4 then
			size = "medium"
		elseif allowed < 5 then
			size = "big"
		elseif allowed < 6 then
			size = "huge"
		end
		return ([[你 复 制 目 标， 从 其 他 时 间 线 上 召 唤 出 %s 体 积 的 复 制 体， 持 续 %d 回 合。 
		 复 制 体 和 目 标 会 立 刻 被 迫 互 相 战 斗。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成。]]):
		format(size, duration)
	end,
}

newTalent{
	name = "See the Threads",
	type = {"chronomancy/timeline-threading", 4},
	require = chrono_req_high4,
	points = 5,
	paradox = 50,
	cooldown = 50,
	no_npc_use = true,
	no_energy = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 5, 9)) end,
	action = function(self, t)
		if checkTimeline(self) == true then
			return
		end
		self:setEffect(self.EFF_SEE_THREADS, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 可 以 探 索 3 种 未 来， 每 个 未 来 允 许 你 探 索 %d 回 合。 
		 当 此 技 能 结 束 时， 你 要 选 定 某 个 未 来。 注 意 在 此 期 间 的 死 亡 仍 然 是 致 命 的。 
		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。 
		 此 技 能 不 需 要 施 法 时 间。]])
		:format(duration)
	end,
}

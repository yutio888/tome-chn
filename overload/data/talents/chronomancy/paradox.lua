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
	name = "Paradox Mastery",
	type = {"chronomancy/paradox", 1},
	mode = "passive",
	require = chrono_req_high1,
	points = 5,
	-- Static history bonus handled in timetravel.lua, backfire calcs performed by _M:getModifiedParadox function in mod\class\Actor.lua	
	WilMult = function(self, t) return self:combatTalentScale(t, 0.15, 0.5) end,
	stabilityDuration = function(self, t) return math.floor(self:combatTalentScale(t, 0.4, 2.7, "log")) end,
	getResist = function(self, t) return self:combatTalentScale(t, 10, 35) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists", {[DamageType.TEMPORAL] = t.getResist(self, t)})
	end,
	info = function(self, t)
		return ([[你 学 会 精 确 掌 控 时 空 并 抵 抗 异 常 状 态。 增 加 你 %d%% 时 空 抵 抗， 延 长 静 态 历 史 的 稳 定 效 果 持 续 时 间 %d 回 合。 同 时 在 鉴 定 法 术 失 败、 变 异 和 走 火 增 加 %d%% 点 意 志。]]):
		format(t.getResist(self, t), t.stabilityDuration(self, t), t.WilMult(self, t) * 100)
	end,
}

newTalent{
	name = "Cease to Exist",
	type = {"chronomancy/paradox", 2},
	require = chrono_req_high2,
	points = 5,
	cooldown = 24,
	paradox = 20,
	range = 10,
	tactical = { ATTACK = 2 },
	requires_target = true,
	direct_hit = true,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t)*getParadoxModifier(self, pm), 5, 9)) end,
	getPower = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) * getParadoxModifier(self, pm) end,
	-- Resistance reduction handled under CEASE_TO_EXIST in data\timed_effects\magical.lua
	getPower = function(self, t)
		return self:combatLimit(self:combatTalentSpellDamage(t, 10, 50) * getParadoxModifier(self, pm), 100, 0, 0, 32.9, 32.9) -- Limit < 100%
	end,
	do_instakill = function(self, t)
		-- search for target because it's ID will change when the chrono restore takes place
		local tg = false
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a:hasEffect(a.EFF_CEASE_TO_EXIST) then
				tg = a
			end
		end end
		
		if tg then
			game:onTickEnd(function()
				tg:removeEffect(tg.EFF_CEASE_TO_EXIST)
				game.logSeen(tg, "#LIGHT_BLUE#%s never existed, this never happened!", tg.name:capitalize())
				tg:die(self)
			end)
		end
	end,
	action = function(self, t)
		-- check for other chrono worlds
		if checkTimeline(self) == true then
			return
		end
		
		-- get our target
		local tg = {type="hit", range=self:getTalentRange(t)}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target then return end

		if target == self then
			game.logSeen(self, "#LIGHT_STEEL_BLUE#%s tries to remove %sself from existance!", self.name, string.his_her(self))
			self:incParadox(400)
			game.level.map:particleEmitter(self.x, self.y, 1, "ball_temporal", {radius=1, tx=self.x, ty=self.y})
			return true
		end
		
		-- does the spell hit?  if not nothing happens
		if not self:checkHit(self:combatSpellpower(), target:combatSpellResist()) then
			game.logSeen(target, "%s resists!", target.name:capitalize())
			return true
		end
	
		-- Manualy start cooldown before the chronoworld is made
		game.player:startTalentCooldown(t)
		
		-- set up chronoworld next, we'll load it when the target dies in class\actor
		game:onTickEnd(function()
			game:chronoClone("cease_to_exist")
		end)
			
		target:setEffect(target.EFF_CEASE_TO_EXIST, t.getDuration(self,t), {power=t.getPower(self, t)})
				
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return ([[在 接 下 来 的 %d 回 合 内 你 试 图 将 目 标 移 出 时 间 线。 它 将 减 少 %d%% 抵 抗， 若 你 在 持 续 时 间 内 杀 了 它， 则 会 返 回 最 初 释 放 技 能 的 时 间 点， 目 标 会 被 杀 死。 
		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成； 受 紊 乱 值 和 法 术 强 度 影 响， 抵 抗 惩 罚 有 额 外 加 成。]])
		:format(duration, power)
	end,
}

newTalent{
	name = "Fade From Time",
	type = {"chronomancy/paradox", 3},
	require = chrono_req_high3,
	points = 5,
	paradox = 10,
	cooldown = 24,
	tactical = { DEFEND = 2, CURE = 2 },
	getResist = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) * getParadoxModifier(self, pm) end,
	getdurred = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 50) * getParadoxModifier(self, pm), 100, 0, 0, 32.9, 32.9) end, -- Limit < 100%
	action = function(self, t)
		-- fading managed by FADE_FROM_TIME effect in mod.data.timed_effects.other.lua
		self:setEffect(self.EFF_FADE_FROM_TIME, 10, {power=t.getResist(self, t), durred=t.getdurred(self,t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local resist = t.getResist(self, t)
		local dur = t.getdurred(self,t)
		return ([[你 将 部 分 身 体 移 出 时 间 线， 持 续 10 回 合.
		 增 加 你 %d%% 所 有 伤 害 抵 抗， 减 少 %d%% 负 面 状 态 持 续 时 间 并 减 少 20%% 你 造 成 的 伤 害。 
		 抵 抗 加 成、 状 态 减 少 值 和 伤 害 惩 罚 会 随 法 术 持 续 时 间 的 增 加 而 逐 渐 减 少。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 效 果 按 比 例 加 成。]]):
		format(resist, dur)
	end,
}

newTalent{
	name = "Paradox Clone",
	type = {"chronomancy/paradox", 4},
	require = chrono_req_high4,
	points = 5,
	paradox = 25,
	cooldown = 50,
	tactical = { ATTACK = 1, DISABLE = 2 },
	range = 2,
	requires_target = true,
	no_npc_use = true,
	getDuration = function(self, t)	return math.floor(self:combatTalentLimit(self:getTalentLevel(t)*getParadoxModifier(self, pm), 50, 4, 8)) end, -- Limit <50
	getModifier = function(self, t) return rng.range(t.getDuration(self,t)*2, t.getDuration(self, t)*4) end,
	action = function (self, t)
		if checkTimeline(self) == true then
			return
		end

		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		if not tx or not ty then return nil end
		
		local x, y = util.findFreeGrid(tx, ty, 2, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local sex = game.player.female and "she" or "he"
		local m = require("mod.class.NPC").new(self:cloneFull{
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			exp_worth = 0,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			ai_tactic = resolvers.tactic("ranged"), ai_state = { talent_in=1, ally_compassion=10},
			desc = [[The real you... or so ]]..sex..[[ says.]]
		})
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil
		
		m.energy.value = 0
		m.player = nil
		m.puuid = nil
		m.max_life = m.max_life
		m.life = util.bound(m.life, 0, m.max_life)
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.can_talk = nil
		m.on_takehit = nil
		m.no_inventory_access = true
		m.clone_on_hit = nil
		m.remove_from_party_on_death = true
		
		-- Remove some talents
		local tids = {}
		for tid, _ in pairs(m.talents) do
			local t = m:getTalentFromId(tid)
			if t.no_npc_use then tids[#tids+1] = t end
		end
		for i, t in ipairs(tids) do
			m.talents[t.id] = nil
		end
		
		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "temporal_teleport")
		game:playSoundNear(self, "talents/teleport")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="no",
				type="minion",
				title="Paradox Clone",
				orders = {target=true},
			})
		end

		self:setEffect(self.EFF_IMMINENT_PARADOX_CLONE, t.getDuration(self, t) + t.getModifier(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 召 唤 未 来 的 自 己 和 你 一 起 战 斗， 持 续 %d 回 合。 当 技 能 结 束 后， 在 未 来 的 某 个 时 间 点， 你 会 被 拉 回 到 过 去， 协 助 你 自 己 战 斗。 
		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成。]]):format(duration)
	end,
}

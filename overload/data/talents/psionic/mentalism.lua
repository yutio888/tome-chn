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

local Map = require "engine.Map"

newTalent{
	name = "Psychometry",
	type = {"psionic/mentalism", 1},
	points = 5, 
	require = psi_wil_req1,
	mode = "passive",
	getPsychometryCap = function(self, t) return self:getTalentLevelRaw(t)/2 end,
	getMaterialMult = function(self,t) return math.max(.5,self:combatTalentLimit(t, 5, 0.15, 0.5)) end, -- Limit to <5 x material level
	updatePsychometryCount = function(self, t)
		-- Update psychometry power
		local psychometry_count = 0
		for inven_id, inven in pairs(self.inven) do
			if inven.worn then
				for item, o in ipairs(inven) do
					if o and item and o.power_source and (o.power_source.psionic or o.power_source.nature or o.power_source.antimagic) then
						psychometry_count = psychometry_count + math.min((o.material_level or 1) * t.getMaterialMult(self,t), t.getPsychometryCap(self, t))
					end
				end
			end
		end
		self:attr("psychometry_power", psychometry_count, true)
	end,
	on_learn = function(self, t)
		t.updatePsychometryCount(self, t)
	end,	
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self.psychometry_power = nil
		else
			t.updatePsychometryCount(self, t)
		end
	end,
	info = function(self, t)
		local max = t.getPsychometryCap(self, t)
		return ([[与 你 装 备 着 的 超 能 力、 自 然 和 反 魔 超 能 力 值 所 制 造 的 物 品  产 生 共 鸣， 增 加 你 %0.2f 点 或 %d%% 物 品 材 质 等 级 数 值（ 取 较 小 值） 的 物 理 和 精 神 强 度。 
		 此 效 果 可 以 叠 加， 并 且 适 用 于 所 有 符 合 条 件 的 已 穿 戴 装 备。]]):format(max, 100*t.getMaterialMult(self,t))
	end,
}

newTalent{
	name = "Mental Shielding",
	type = {"psionic/mentalism", 2},
	points = 5,
	require = psi_wil_req2,
	psi = 15,
	cooldown = function(self, t) return math.max(10, 20 - self:getTalentLevelRaw(t) * 2) end,
	tactical = { BUFF = 1, CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.type == "mental" then
				nb = nb + 1
			end
		end
		return nb
	end,},
	no_energy = true,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local effs = {}
		local count = t.getRemoveCount(self, t)

		-- Go through all mental effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type == "mental" and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
				count = count - 1
			end
		end
		
		if count >= 1 then
			self:setEffect(self.EFF_CLEAR_MIND, 6, {power=count})
		end
		
		game.logSeen(self, "%s's mind is clear!", self.name:capitalize())
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[净 化 你 当 前 所 有 的 精 神 状 态， 并 在 接 下 来 的 6 回 合 内 免 疫 新 增 的 精 神 状 态。 最 多 一 共（ 净 化 和 免 疫） 能 影 响 %d 种 精 神 状 态。 
		 此 技 能 使 用 时 不 消 耗 回 合。]]):format(count)
	end,
}

newTalent{
	name = "Projection",
	type = {"psionic/mentalism", 3},
	points = 5, 
	require = psi_wil_req3,
	psi = 20,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 17.5, 9.5)) end, -- Limit >0
	no_npc_use = true, -- this can be changed if the AI is improved.  I don't trust it to be smart enough to leverage this effect.
	getPower = function(self, t) return math.ceil(self:combatTalentMindDamage(t, 5, 40)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 14)) end,
	action = function(self, t)
		if self:attr("is_psychic_projection") then return true end
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke your spirit!")
			return
		end
		
		local m = self:cloneFull{
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			subtype = "ghost", is_psychic_projection = 1,
			name = "Projection of "..self.name,
			desc = [[A ghostly figure.]],
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil
		m._rst_full = true

		m.energy.value = 0
		m.player = nil
		m.max_life = m.max_life
		m.life = util.bound(m.life, 0, m.max_life)
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.puuid = nil
		m.on_takehit = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		m.exp_worth = 0
		m.no_inventory_access = true
		m.can_change_level = false
		m.remove_from_party_on_death = true
		for i = 1, 10 do
			m:unlearnTalent(m.T_AMBUSCADE)	-- no recurssive projections
			m:unlearnTalent(m.T_PROJECTION)		
			m:unlearnTalent(m.T_THOUGHT_FORMS)
		end
				
		m.can_pass = {pass_wall=70}
		m.no_breath = 1
		m.invisible = (m.invisible or 0) + t.getPower(self, t)/2
		m.see_invisible = (m.see_invisible or 0) + t.getPower(self, t)
		m.see_stealth = (m.see_stealth or 0) + t.getPower(self, t)
		m.lite = 0
		m.infravision = (m.infravision or 0) + 10
		m.avoid_pressure_traps = 1
		
		
		-- Connection to the summoner functions
		local summon_time = t.getDuration(self, t)
		--summoner takes hit
		m.on_takehit = function(self, value, src) self.summoner:takeHit(value, src) return value end
		--pass actors targeting us back to the summoner to prevent super cheese
		m.on_die = function(self)
			local tg = {type="ball", radius=10}
			self:project(tg, self.x, self.y, function(tx, ty)
				local target = game.level.map(tx, ty, Map.ACTOR)
				if target and target.ai_target.actor == self then
					target.ai_target.actor = self.summoner
				end
			end)
		end				
		
		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(m.x, m.y, 1, "generic_teleport", {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=35, aM=90})
		game:playSoundNear(self, "talents/teleport")
	
		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="full",
				type = m.type, subtype="ghost",
				title="Projection of "..self.name,
				temporary_level=1,
				orders = {target=true},
				on_control = function(self)
					self.summoner.projection_ai = self.summoner.ai
					self.summoner.ai = "none"
				end,
				on_uncontrol = function(self)
					game:onTickEnd(function() 
						self.summoner.ai = self.summoner.projection_ai
						self.energy.value = 0
						self.summon_time = 0
						game.party:removeMember(self)
						game.level.map:particleEmitter(self.summoner.x, self.summoner.y, 1, "generic_teleport", {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=35, aM=90})
					end)
				end,
			})
		end
		game:onTickEnd(function() 
			game.party:setPlayer(m)
			self:resetCanSeeCache()
		end)
		
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[激 活 此 技 能 可 以 使 你 的 灵 魂 出 窍， 持 续 %d 回 合。 在 此 效 果 下， 你 处 于 隐 形 状 态（ +%d 强 度）， 并 且 可 以 看 到 隐 形 和 潜 行 单 位（ +%d 侦 查 强 度）， 还 可 以 穿 过 墙 体， 并 且 无 需 呼 吸。 
		 你 受 到 的 所 有 伤 害 都 会 与 身 体 共 享， 当 你 处 于 此 形 态 下 你 只 能 对 “ 鬼 魂 ” 类 怪 物 造 成 伤 害， 或 者 通 过 激 活 一 种 精 神 通 道 来 造 成 伤 害。 
		 注： 后 一 种 情 况 下 只 能 造 成 精 神 伤 害。 
		 要 回 到 你 的 身 体 里， 只 需 释 放 灵 魂 体 的 控 制 即 可。]]):format(duration, power/2, power)
	end,
}

newTalent{
	name = "Mind Link",
	type = {"psionic/mentalism", 4},
	points = 5, 
	require = psi_wil_req4,
	sustain_psi = 50,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 44, 12)) end, -- Limit >0
	tactical = { BUFF = 2, ATTACK = {MIND = 2}},
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getBonusDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 30) end,
	activate = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target or target == self then return end
		
		target:setEffect(target.EFF_MIND_LINK_TARGET, 10, {power=t.getBonusDamage(self, t), src=self, range=self:getTalentRange(t)*2})
		
		game.level.map:particleEmitter(self.x, self.y, 1, "generic_discharge", {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=35, aM=90})
		game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=35, aM=90})
		game:playSoundNear(self, "talents/echo")
		
		local ret = {
			target = target,
			esp = self:addTemporaryValue("esp", {[target.type] = 1}),
		}
		
		-- Update for ESP
		game:onTickEnd(function() 
			self:resetCanSeeCache()
		end)
		
		return ret
	end,
	deactivate = function(self, t, p)
		-- Break 'both' mind links if we're projecting
		if self:attr("is_psychic_projection") and self.summoner:isTalentActive(self.summoner.T_MIND_LINK) then
			self.summoner:forceUseTalent(self.summoner.T_MIND_LINK, {ignore_energy=true})
		end
		self:removeTemporaryValue("esp", p.esp)

		return true
	end,
	info = function(self, t)
		local damage = t.getBonusDamage(self, t)
		local range = self:getTalentRange(t) * 2
		return ([[用 精 神 通 道 连 接 目 标。 当 精 神 通 道 连 接 时， 你 对 其 造 成 的 精 神 伤 害 增 加 %d%% ， 同 时 你 可 以 感 知 与 目 标 同 种 类 型 的 单 位。 
		 在 同 一 时 间 内 只 能 激 活 一 条 精 神 通 道， 当 目 标 死 亡 或 超 出 范 围（ %d 码） 时， 通 道 中 断。 
		 受 精 神 强 度 影 响， 精 神 伤 害 按 比 例 加 成。]]):format(damage, range)
	end,
}


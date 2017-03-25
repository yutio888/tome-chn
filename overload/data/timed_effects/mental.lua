-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"
local Astar = require "engine.Astar"

newEffect{
	name = "SILENCED", image = "effects/silenced.png",
	desc = "Silenced",
	long_desc = function(self, eff) return "目 标 被 沉 默， 无 法 施 法 和 使 用 语 言 类 技 能。" end,
	type = "mental",
	subtype = { silence=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is silenced!", "+Silenced" end,
	on_lose = function(self, err) return "#Target# is not silenced anymore.", "-Silenced" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("silence", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("silence", eff.tmpid)
	end,
}

newEffect{
	name = "SUMMON_CONTROL", image = "talents/summon_control.png",
	desc = "Summon Control",
	long_desc = function(self, eff) return ("减 少 %d%% 所 受 伤 害， 延 长 召 唤 时 间 %d 。"):format(eff.res, eff.incdur) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { res=10, incdur=10 },
	activate = function(self, eff)
		eff.resid = self:addTemporaryValue("resists", {all=eff.res})
		eff.durid = self:addTemporaryValue("summon_time", eff.incdur)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resid)
		self:removeTemporaryValue("summon_time", eff.durid)
	end,
	on_timeout = function(self, eff)
		eff.dur = self.summon_time
	end,
}

newEffect{
	name = "CONFUSED", image = "effects/confused.png",
	desc = "Confused",
	long_desc = function(self, eff) return ("目 标 陷 入 混 乱， 随 机 行 动（ %d%% 概 率） 不 能 完 成 复 杂 的 动 作。"):format(eff.power) end,
	type = "mental",
	subtype = { confusion=true },
	status = "detrimental",
	parameters = { power=50 },
	on_gain = function(self, err) return "#Target# wanders around!", "+Confused" end,
	on_lose = function(self, err) return "#Target# seems more focused.", "-Confused" end,
	activate = function(self, eff)
		eff.power = math.floor(math.max(eff.power - (self:attr("confusion_immune") or 0) * 100, 10))
		eff.power = util.bound(eff.power, 0, 50)
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
		if eff.power <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "DOMINANT_WILL", image = "talents/yeek_will.png",
	desc = "Mental Domination",
	long_desc = function(self, eff) return ("目 标 的 心 智 被 扰 乱， 身 体 被 %s 所 奴 役。"):format(eff.src.name:capitalize()) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target#'s mind is shattered." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=-15})
		self.ai_state = self.ai_state or {}
		eff.oldstate = {
			faction = self.faction,
			ai_state = table.clone(self.ai_state, true),
			remove_from_party_on_death = self.remove_from_party_on_death,
			no_inventory_access = self.no_inventory_access,
			move_others = self.move_others,
			summoner = self.summoner,
			summoner_gain_exp = self.summoner_gain_exp,
			ai = self.ai,
		}
		self.faction = eff.src.faction
		
		self.ai_state.tactic_leash = 100
		self.remove_from_party_on_death = true
		self.no_inventory_access = true
		self.move_others = true
		self.summoner = eff.src
		self.summoner_gain_exp = true
		if self.dead then return end
		game:onTickEnd(function()
			game.party:addMember(self, {
				control="full",
				type="thrall",
				title="Thrall",
				orders = {leash=true, follow=true},
				on_control = function(self)
					self:hotkeyAutoTalents()
				end,
				leave_level = function(self, party_def) -- Cancel control and restore previous actor status.
					local eff = self:hasEffect(self.EFF_DOMINANT_WILL)
					local uid = self.uid
					eff.survive_domination = true
					self:removeTemporaryValue("inc_damage", eff.pid)
					game.party:removeMember(self)
					self:replaceWith(require("mod.class.NPC").new(self))
					self.uid = uid
					__uids[uid] = self
					self.faction = eff.oldstate.faction
					self.ai_state = eff.oldstate.ai_state
					self.ai = eff.oldstate.ai
					self.remove_from_party_on_death = eff.oldstate.remove_from_party_on_death
					self.no_inventory_access = eff.oldstate.no_inventory_access
					self.move_others = eff.oldstate.move_others
					self.summoner = eff.oldstate.summoner
					self.summoner_gain_exp = eff.oldstate.summoner_gain_exp
					self:removeEffect(self.EFF_DOMINANT_WILL)
				end,
			})
		end)
	end,
	deactivate = function(self, eff)
		if eff.survive_domination then
			game.logSeen(self, "%s's mind recovers from the domination.",self.name:capitalize())
		else
			game.logSeen(self, "%s collapses.",self.name:capitalize())
			self:die(eff.src)
		end
	end,
}

newEffect{
	name = "BATTLE_SHOUT", image = "talents/battle_shout.png",
	desc = "Battle Shout",
	long_desc = function(self, eff) return ("增 加 %d%% 生 命 值 和 体 力 值 上 限。 当 效 果 结 束 后 ， 增 加 的 生 命 和 体 力 会 消 失。 "):format(eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		local lifeb = self.max_life * eff.power/100
		local stamb = self.max_stamina * eff.power/100
		eff.max_lifeID = self:addTemporaryValue("max_life", lifeb) --Avoid healing effects
		eff.lifeID = self:addTemporaryValue("life",lifeb)
		eff.max_stamina = self:addTemporaryValue("max_stamina", stamb)
		self:incStamina(stamb)
		eff.stamina = stamb
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("life", eff.lifeID)
		self:removeTemporaryValue("max_life", eff.max_lifeID)
		self:removeTemporaryValue("max_stamina", eff.max_stamina)
		self:incStamina(-eff.stamina)
	end,
}

newEffect{
	name = "BATTLE_CRY", image = "talents/battle_cry.png",
	desc = "Battle Cry",
	long_desc = function(self, eff) return ("目 标 的 防 御 意 识 被 战 斗 怒 吼 所 扰 乱， 降 低 %d 闪 避 值。"):format(eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s will is shattered.", "+Battle Cry" end,
	on_lose = function(self, err) return "#Target# regains some of its will.", "-Battle Cry" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
		self:effectTemporaryValue(eff, "no_evasion", 1)
		self:effectTemporaryValue(eff, "blind_fighted", 1)
	end,
}

newEffect{
	name = "WILLFUL_COMBAT", image = "talents/willful_combat.png",
	desc = "Willful Combat",
	long_desc = function(self, eff) return ("目 标 投 入 所 有 战 斗 意 志， 提 升 %d 物 理 强 度。"):format(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# lashes out with pure willpower." end,
	on_lose = function(self, err) return "#Target#'s willpower rush ends." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "GLOOM_WEAKNESS", image = "effects/gloom_weakness.png",
	desc = "Gloom Weakness",
	long_desc = function(self, eff) return ("黑 暗 降 低 目 标 造 成 的 伤 害 %d%% 。"):format(-eff.incDamageChange) end,
	type = "mental",
	subtype = { gloom=true },
	status = "detrimental",
	parameters = { atk=10, dam=10 },
	on_gain = function(self, err) return "#F53CBE##Target# is weakened by the gloom." end,
	on_lose = function(self, err) return "#F53CBE##Target# is no longer weakened." end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_weakness", 1))
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all = eff.incDamageChange})
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "GLOOM_SLOW", image = "effects/gloom_slow.png",
	desc = "Slowed by the gloom",
	long_desc = function(self, eff) return ("降 低 目 标 整 体 速 度 %d%% 。"):format(eff.power * 100) end,
	type = "mental",
	subtype = { gloom=true, slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#F53CBE##Target# moves reluctantly!", "+Slow" end,
	on_lose = function(self, err) return "#Target# overcomes the gloom.", "-Slow" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_slow", 1))
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "GLOOM_STUNNED", image = "effects/gloom_stunned.png",
	desc = "Stunned by the gloom",
	long_desc = function(self, eff) return ("目 标 被 震 慑， 伤 害 降 低 70％， 治 疗 效 果 降 低 50％， 随 机 技 能 进 入 CD， 移 动 速 度 降 低 50％。 在 震 慑 时 技 能 停 止 冷 却。"):format() end,
	type = "mental",
	subtype = { gloom=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# is stunned with fear!", "+Stunned" end,
	on_lose = function(self, err) return "#Target# overcomes the gloom.", "-Stunned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))

		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.tcdid = self:addTemporaryValue("no_talents_cooldown", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1 -- Just set cooldown to 1 since cooldown does not decrease while stunned
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)

		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("no_talents_cooldown", eff.tcdid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
	end,
}

newEffect{
	name = "GLOOM_CONFUSED", image = "effects/gloom_confused.png",
	desc = "Confused by the gloom",
	long_desc = function(self, eff) return ("目 标 陷 入 混 乱， 随 机 行 动（ %d%% 概 率） 不 能 完 成 复 杂 动 作。"):format(eff.power) end,
	type = "mental",
	subtype = { gloom=true, confusion=true },
	status = "detrimental",
	parameters = { power = 10 },
	on_gain = function(self, err) return "#F53CBE##Target# is lost in despair!", "+Confused" end,
	on_lose = function(self, err) return "#Target# overcomes the gloom.", "-Confused" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_confused", 1))
		eff.power = math.floor(math.max(eff.power - (self:attr("confusion_immune") or 0) * 100, 10))
		eff.power = util.bound(eff.power, 0, 50)
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
		if eff.power <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player then self:updateMainShader() end
	end,
}

newEffect{
	name = "DISMAYED", image = "talents/dismay.png",
	desc = "Dismayed",
	long_desc = function(self, eff) return ("目 标 惊 慌 失 措， 下 一 次 对 该 目 标 的 近 战 攻 击 会 造 成 暴 击。") end,
	type = "mental",
	subtype = { gloom=true, confusion=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# is dismayed!", "+Dismayed" end,
	on_lose = function(self, err) return "#Target# overcomes the dismay", "-Dismayed" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("dismayed", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "STALKER", image = "talents/stalk.png",
	desc = "Stalking",
	display_desc = function(self, eff)
		return ([[追 踪 %d/%d +%d ]]):format(eff.target.life, eff.target.max_life, eff.bonus)
	end,
	long_desc = function(self, eff)
		local t = self:getTalentFromId(self.T_STALK)
		local effStalked = eff.target:hasEffect(eff.target.EFF_STALKED)
		local desc = ([[追 踪 %s ， 等 级 %d: +%d 命 中， +%d%% 近 战 伤 害， +%0.2f 仇 恨 / 回 合 攻 击 回 复。]]):format(
			eff.target.name, eff.bonus, t.getAttackChange(self, t, eff.bonus), t.getStalkedDamageMultiplier(self, t, eff.bonus) * 100 - 100, t.getHitHateChange(self, t, eff.bonus))
		if effStalked and effStalked.damageChange and effStalked.damageChange > 0 then
			desc = desc..("猎 捕 伤 害 加 成： %d%% 。"):format(effStalked.damageChange)
		end
		return desc
	end,
	type = "mental",
	subtype = { veil=true },
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		self:logCombat(eff.target, "#F53CBE##Target# 正被 #Source#追踪!")
	end,
	deactivate = function(self, eff)
		self:logCombat(eff.target, "#F53CBE##Target# 不再被 #Source#追踪.")
	end,
	on_timeout = function(self, eff)
		if not eff.target or eff.target.dead or not eff.target:hasEffect(eff.target.EFF_STALKED) then
			self:removeEffect(self.EFF_STALKER)
		end
	end,
}

newEffect{
	name = "STALKED", image = "effects/stalked.png",
	desc = "Stalked",
	long_desc = function(self, eff)
		local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
		if not effStalker then return "被追踪。" end
		local t = self:getTalentFromId(eff.src.T_STALK)
		local desc = ([[目 标 被 %s 追 踪。 追 踪 等 级 %d: +%d 命 中， +%d%% 近 战 伤 害， +%0.2f 仇 恨 / 回 合 攻 击 回 复。]]):format(
			eff.src.name, effStalker.bonus, t.getAttackChange(eff.src, t, effStalker.bonus), t.getStalkedDamageMultiplier(eff.src, t, effStalker.bonus) * 100 - 100, t.getHitHateChange(eff.src, t, effStalker.bonus))
		if eff.damageChange and eff.damageChange > 0 then
			desc = desc..(" 猎 捕 伤 害 加 成： %d%% 。"):format(eff.damageChange)
		end
		return desc
	end,
	type = "mental",
	subtype = { veil=true },
	status = "detrimental",
	parameters = {},
	activate = function(self, eff)
		local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
		if not effStalker then game:onTickEnd(function() self:removeEffect(self.EFF_STALKED, true, true) end) return end
		eff.particleBonus = effStalker.bonus
		eff.particle = self:addParticles(Particles.new("stalked", 1, { bonus = eff.particleBonus }))
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		if eff.damageChangeId then self:removeTemporaryValue("inc_damage", eff.damageChangeId) end
	end,
	on_timeout = function(self, eff)
		if not eff.src or eff.src.dead or not eff.src:hasEffect(eff.src.EFF_STALKER) then
			self:removeEffect(self.EFF_STALKED)
		else
			local effStalker = eff.src:hasEffect(eff.src.EFF_STALKER)
			if eff.particleBonus ~= effStalker.bonus then
				eff.particleBonus = effStalker.bonus
				self:removeParticles(eff.particle)
				eff.particle = self:addParticles(Particles.new("stalked", 1, { bonus = eff.particleBonus }))
			end
		end
	end,
	updateDamageChange = function(self, eff)
		if eff.damageChangeId then
			self:removeTemporaryValue("inc_damage", eff.damageChangeId)
			eff.damageChangeId = nil
		end
		if eff.damageChange and eff.damageChange > 0 then
			eff.damageChangeId = eff.target:addTemporaryValue("inc_damage", {all=eff.damageChange})
		end
	end,
}

newEffect{
	name = "BECKONED", image = "talents/beckon.png",
	desc = "Beckoned",
	long_desc = function(self, eff)
		local message = ("目 标 被 %s 诱 惑 并 响 应 其 呼 唤， 每 回 合 有 %d%% 概 率 向 召 唤 者 移 动。"):format(eff.src.name, eff.chance)
		if eff.spellpowerChangeId and eff.mindpowerChangeId then
			message = message..(" (法 术 强 度： %d ， 精 神 强 度： %d "):format(eff.spellpowerChange, eff.mindpowerChange)
		end
		return message
	end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = { speedChange=0.5 },
	on_gain = function(self, err) return "#Target# has been beckoned.", "+Beckoned" end,
	on_lose = function(self, err) return "#Target# is no longer beckoned.", "-Beckoned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("beckoned", 1))

		eff.spellpowerChangeId = self:addTemporaryValue("combat_spellpower", eff.spellpowerChange)
		eff.mindpowerChangeId = self:addTemporaryValue("combat_mindpower", eff.mindpowerChange)
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end

		if eff.spellpowerChangeId then
			self:removeTemporaryValue("combat_spellpower", eff.spellpowerChangeId)
			eff.spellpowerChangeId = nil
		end
		if eff.mindpowerChangeId then
			self:removeTemporaryValue("combat_mindpower", eff.mindpowerChangeId)
			eff.mindpowerChangeId = nil
		end
	end,
	on_timeout = function(self, eff)
	end,
	do_act = function(self, eff)
		if eff.src.dead then
			self:removeEffect(self.EFF_BECKONED)
			return
		end
		if not self:enoughEnergy() then return nil end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.chance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the beckoning.", self.name:capitalize())
		else
			eff.timer = eff.timer + eff.chance
		end

		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local distance = self.x and eff.src.x and core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) or 1000
			if math.floor(distance) > 1 and distance <= eff.range then
				-- in range but not adjacent

				-- add debuffs
				if not eff.spellpowerChangeId then eff.spellpowerChangeId = self:addTemporaryValue("combat_spellpower", eff.spellpowerChange) end
				if not eff.mindpowerChangeId then eff.mindpowerChangeId = self:addTemporaryValue("combat_mindpower", eff.mindpowerChange) end

				-- custom pull logic (adapted from move_dmap; forces movement, pushes others aside, custom particles)

				if not self:attr("never_move") then
					local source = eff.src
					local moveX, moveY = source.x, source.y -- move in general direction by default
					if not self:hasLOS(source.x, source.y) then
						local a = Astar.new(game.level.map, self)
						local path = a:calc(self.x, self.y, source.x, source.y)
						if path then
							moveX, moveY = path[1].x, path[1].y
						end
					end

					if moveX and moveY then
						local old_move_others, old_x, old_y = self.move_others, self.x, self.y
						self.move_others = true
						local old = rawget(self, "aiCanPass")
						self.aiCanPass = mod.class.NPC.aiCanPass
						mod.class.NPC.moveDirection(self, moveX, moveY, false)
						self.aiCanPass = old
						self.move_others = old_move_others
						if old_x ~= self.x or old_y ~= self.y then
							game.level.map:particleEmitter(self.x, self.y, 1, "beckoned_move", {power=power, dx=self.x - source.x, dy=self.y - source.y})
						end
					end
				end
			else
				-- adjacent or out of range..remove debuffs
				if eff.spellpowerChangeId then
					self:removeTemporaryValue("combat_spellpower", eff.spellpowerChangeId)
					eff.spellpowerChangeId = nil
				end
				if eff.mindpowerChangeId then
					self:removeTemporaryValue("combat_mindpower", eff.mindpowerChangeId)
					eff.mindpowerChangeId = nil
				end
			end
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		eff.resistChance = (eff.resistChance or 0) + math.min(100, math.max(0, dam / self.max_life * 100))
		if rng.percent(eff.resistChance) then
			game.logSeen(self, "#F53CBE#%s is jolted to attention by the damage and is no longer being beckoned.", self.name:capitalize())
			self:removeEffect(self.EFF_BECKONED)
		end

		return dam
	end,
}

newEffect{
	name = "OVERWHELMED", image = "talents/frenzy.png",
	desc = "Overwhelmed",
	long_desc = function(self, eff) return ("目 标 被 强 力 的 攻 击 所 压 制， 减 少 %d 攻 击。"):format( -eff.attackChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { damageChange=0.1 },
	on_gain = function(self, err) return "#Target# has been overwhelmed.", "+Overwhelmed" end,
	on_lose = function(self, err) return "#Target# is no longer overwhelmed.", "-Overwhelmed" end,
	activate = function(self, eff)
		eff.attackChangeId = self:addTemporaryValue("combat_atk", eff.attackChange)
		eff.particle = self:addParticles(Particles.new("overwhelmed", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.attackChangeId)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "HARASSED", image = "talents/harass_prey.png",
	desc = "Harassed",
	long_desc = function(self, eff) return ("目 标 被 追 踪 至 疲 倦， 伤 害 减 低 %d%% 。"):format( -eff.damageChange ) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = { damageChange=0.1 },
	on_gain = function(self, err) return "#Target# has been harassed.", "+Harassed" end,
	on_lose = function(self, err) return "#Target# is no longer harassed.", "-Harassed" end,
	activate = function(self, eff)
		eff.damageChangeId = self:addTemporaryValue("inc_damage", {all=eff.damageChange})
		eff.particle = self:addParticles(Particles.new("harassed", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.damageChangeId)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "DOMINATED", image = "talents/dominate.png",
	desc = "Dominated",
	long_desc = function(self, eff) return (" 目 标 被 支 配 。 不 能 移 动 并 减 少 %d 护 甲 和 %d 闪 避 。 %s 对 目 标 的 攻 击 增 加 %d%% 抗 性 穿 透。 "):format(-eff.armorChange, -eff.defenseChange, eff.src.name:capitalize(), eff.resistPenetration) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	on_gain = function(self, err) return "#F53CBE##Target# has been dominated!", "+Dominated" end,
	on_lose = function(self, err) return "#F53CBE##Target# is no longer dominated.", "-Dominated" end,
	parameters = { armorChange = -3, defenseChange = -3, physicalResistChange = -0.1 },
	activate = function(self, eff)
		eff.neverMoveId = self:addTemporaryValue("never_move", 1)
		eff.armorId = self:addTemporaryValue("combat_armor", eff.armorChange)
		eff.defenseId = self:addTemporaryValue("combat_def", eff.armorChange)

		eff.particle = self:addParticles(Particles.new("dominated", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.neverMoveId)
		self:removeTemporaryValue("combat_armor", eff.armorId)
		self:removeTemporaryValue("combat_def", eff.defenseId)

		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "FEED", image = "talents/feed.png",
	desc = "Feeding",
	long_desc = function(self, eff) return ("%s 正 在 吞 食 %s 。"):format(npcCHN:getName(self.name), npcCHN:getName(eff.target.name)) end,
	type = "mental",
	subtype = { psychic_drain=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff, ed)
		eff.src = self

		-- hate
		if eff.hateGain and eff.hateGain > 0 then
			eff.hateGainId = self:addTemporaryValue("hate_regen", eff.hateGain)
		end

		-- health
		if eff.constitutionGain and eff.constitutionGain > 0 then
			eff.constitutionGainId = self:addTemporaryValue("inc_stats", { [Stats.STAT_CON] = eff.constitutionGain })
		end
		if eff.lifeRegenGain and eff.lifeRegenGain > 0 then
			eff.lifeRegenGainId = self:addTemporaryValue("life_regen", eff.lifeRegenGain)
		end

		-- power
		if eff.damageGain and eff.damageGain > 0 then
			eff.damageGainId = self:addTemporaryValue("inc_damage", {all=eff.damageGain})
		end

		-- strengths
		if eff.resistGain and eff.resistGain > 0 then
			local gainList = {}
			for id, resist in pairs(eff.target.resists) do
				if resist > 0 and id ~= "all" then
					gainList[id] = eff.resistGain * 0.01 * resist
				end
			end

			eff.resistGainId = self:addTemporaryValue("resists", gainList)
		end

		eff.target:setEffect(eff.target.EFF_FED_UPON, eff.dur, { src = eff.src, target = eff.target, constitutionLoss = -eff.constitutionGain, lifeRegenLoss = -eff.lifeRegenGain, damageLoss = -eff.damageGain, resistLoss = -eff.resistGain })

		ed.updateFeed(self, eff)
	end,
	deactivate = function(self, eff)
		-- hate
		if eff.hateGainId then self:removeTemporaryValue("hate_regen", eff.hateGainId) end

		-- health
		if eff.constitutionGainId then self:removeTemporaryValue("inc_stats", eff.constitutionGainId) end
		if eff.lifeRegenGainId then self:removeTemporaryValue("life_regen", eff.lifeRegenGainId) end

		-- power
		if eff.damageGainId then self:removeTemporaryValue("inc_damage", eff.damageGainId) end

		-- strengths
		if eff.resistGainId then self:removeTemporaryValue("resists", eff.resistGainId) end

		if eff.particles then
			-- remove old particle emitter
			game.level.map:removeParticleEmitter(eff.particles)
			eff.particles = nil
		end

		eff.target:removeEffect(eff.target.EFF_FED_UPON, false, true)
	end,
	updateFeed = function(self, eff)
		local source = eff.src
		local target = eff.target

		if source.dead or target.dead or not game.level:hasEntity(source) or not game.level:hasEntity(target) or not source:hasLOS(target.x, target.y) or core.fov.distance(self.x, self.y, target.x, target.y) > (eff.range or 10) then
			source:removeEffect(source.EFF_FEED)
			if eff.particles then
				game.level.map:removeParticleEmitter(eff.particles)
				eff.particles = nil
			end
			return
		end

		-- update particles position
		if not eff.particles or eff.particles.x ~= source.x or eff.particles.y ~= source.y or eff.particles.tx ~= target.x or eff.particles.ty ~= target.y then
			if eff.particles then
				game.level.map:removeParticleEmitter(eff.particles)
			end
			-- add updated particle emitter
			local dx, dy = target.x - source.x, target.y - source.y
			eff.particles = Particles.new("feed_hate", math.max(math.abs(dx), math.abs(dy)), { tx=dx, ty=dy })
			eff.particles.x = source.x
			eff.particles.y = source.y
			eff.particles.tx = target.x
			eff.particles.ty = target.y
			game.level.map:addParticleEmitter(eff.particles)
		end
	end
}

newEffect{
	name = "FED_UPON", image = "effects/fed_upon.png",
	desc = "Fed Upon",
	long_desc = function(self, eff) return ("%s 被 %s 吞 食。"):format(self.name:capitalize(), eff.src.name) end,
	type = "mental",
	subtype = { psychic_drain=true },
	status = "detrimental",
	remove_on_clone = true,
	no_remove = true,
	parameters = { },
	activate = function(self, eff)
		-- health
		if eff.constitutionLoss and eff.constitutionLoss < 0 then
			eff.constitutionLossId = self:addTemporaryValue("inc_stats", { [Stats.STAT_CON] = eff.constitutionLoss })
		end
		if eff.lifeRegenLoss and eff.lifeRegenLoss < 0 then
			eff.lifeRegenLossId = self:addTemporaryValue("life_regen", eff.lifeRegenLoss)
		end

		-- power
		if eff.damageLoss and eff.damageLoss < 0 then
			eff.damageLossId = self:addTemporaryValue("inc_damage", {all=eff.damageLoss})
		end

		-- strengths
		if eff.resistLoss and eff.resistLoss < 0 then
			local lossList = {}
			for id, resist in pairs(self.resists) do
				if resist > 0 and id ~= "all" then
					lossList[id] = eff.resistLoss * 0.01 * resist
				end
			end

			eff.resistLossId = self:addTemporaryValue("resists", lossList)
		end
	end,
	deactivate = function(self, eff)
		-- health
		if eff.constitutionLossId then self:removeTemporaryValue("inc_stats", eff.constitutionLossId) end
		if eff.lifeRegenLossId then self:removeTemporaryValue("life_regen", eff.lifeRegenLossId) end

		-- power
		if eff.damageLossId then self:removeTemporaryValue("inc_damage", eff.damageLossId) end

		-- strengths
		if eff.resistLossId then self:removeTemporaryValue("resists", eff.resistLossId) end

		if eff.target == self and eff.src:hasEffect(eff.src.EFF_FEED) then
			eff.src:removeEffect(eff.src.EFF_FEED)
		end
	end,
	on_timeout = function(self, eff)
		-- no_remove prevents targets from dispelling feeding, make sure this gets removed if something goes wrong
		if eff.dur <= 0 or eff.src.dead then
			self:removeEffect(eff.src.EFF_FED_UPON, false, true)
		end
	end,
}

newEffect{
	name = "AGONY", image = "talents/agony.png",
	desc = "Agony",
	long_desc = function(self, eff) return ("%s 陷 入 挣 扎， 遭 受 %d 至 %d 伤 害 持 续 %d 回 合。"):format(self.name:capitalize(), eff.damage / eff.duration, eff.damage, eff.duration) end,
	type = "mental",
	subtype = { pain=true, psionic=true },
	status = "detrimental",
	parameters = { damage=10, mindpower=10, range=10, minPercent=10 },
	on_gain = function(self, err) return "#Target# is writhing in agony!", "+Agony" end,
	on_lose = function(self, err) return "#Target# is no longer writhing in agony.", "-Agony" end,
	activate = function(self, eff)
		eff.power = 0
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
	on_timeout = function(self, eff)
		eff.turn = (eff.turn or 0) + 1

		local damage = math.floor(eff.damage * (eff.turn / eff.duration))
		if damage > 0 then
			DamageType:get(DamageType.MIND).projector(eff.src, self.x, self.y, DamageType.MIND, { dam=damage, crossTierChance=25 })
			game:playSoundNear(self, "talents/fire")
		end

		if self.dead then
			if eff.particle then self:removeParticles(eff.particle) end
			return
		end

		if eff.particle then self:removeParticles(eff.particle) end
		eff.particle = nil
		eff.particle = self:addParticles(Particles.new("agony", 1, { power = 10 * eff.turn / eff.duration }))
	end,
}

newEffect{
	name = "HATEFUL_WHISPER", image = "talents/hateful_whisper.png",
	desc = "Hateful Whisper",
	long_desc = function(self, eff) return ("%s 听 到 了 憎 恨 私 语。"):format(self.name:capitalize()) end,
	type = "mental",
	subtype = { madness=true, psionic=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target# has heard the hateful whisper!", "+Hateful Whisper" end,
	on_lose = function(self, err) return "#Target# no longer hears the hateful whisper.", "-Hateful Whisper" end,
	activate = function(self, eff)
		if not eff.src.dead and eff.src:knowTalent(eff.src.T_HATE_POOL) then
			eff.src:incHate(eff.hateGain)
		end
		DamageType:get(DamageType.MIND).projector(eff.src, self.x, self.y, DamageType.MIND, { dam=eff.damage, crossTierChance=25 })

		if self.dead then
			-- only spread on activate if the target is dead
			if eff.jumpCount > 0 then
				eff.jumpCount = eff.jumpCount - 1
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			end
		else
			eff.particle = self:addParticles(Particles.new("hateful_whisper", 1, { }))
		end

		game:playSoundNear(self, "talents/fire")

		eff.firstTurn = true
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
	on_timeout = function(self, eff)
		if self.dead then return false end

		if eff.firstTurn then
			-- pause a turn before infecting others
			eff.firstTurn = false
		elseif eff.jumpDuration > 0 then
			-- limit the total duration of all spawned effects
			eff.jumpDuration = eff.jumpDuration - 1

			if eff.jumpCount > 0 then
				-- guaranteed jump
				eff.jumpCount = eff.jumpCount - 1
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			elseif rng.percent(eff.jumpChance) then
				-- per turn chance of a jump
				self.tempeffect_def[self.EFF_HATEFUL_WHISPER].doSpread(self, eff)
			end
		end
	end,
	doSpread = function(self, eff)
		local targets = {}
		local grids = core.fov.circle_grids(self.x, self.y, eff.jumpRange, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, game.level.map.ACTOR)
				if a and eff.src:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
					if not a:hasEffect(a.EFF_HATEFUL_WHISPER) then
						targets[#targets+1] = a
					end
				end
			end
		end

		if #targets > 0 then
			local target = rng.table(targets)
			target:setEffect(target.EFF_HATEFUL_WHISPER, eff.duration, {
				src = eff.src,
				duration = eff.duration,
				damage = eff.damage,
				mindpower = eff.mindpower,
				jumpRange = eff.jumpRange,
				jumpCount = 0, -- secondary effects do not get automatic spreads
				jumpChance = eff.jumpChance,
				jumpDuration = eff.jumpDuration,
				hateGain = eff.hateGain
			})

			game.level.map:particleEmitter(target.x, target.y, 1, "reproach", { dx = self.x - target.x, dy = self.y - target.y })
		end
	end,
}

newEffect{
	name = "MADNESS_SLOW", image = "effects/madness_slowed.png",
	desc = "Slowed by madness",
	long_desc = function(self, eff) return ("目 标 因 疯 狂 降 低 整 体 速 度 %d%% ， 同 时 降 低 精 神 抵 抗 %d%% 。"):format(eff.power * 100, -eff.mindResistChange) end,
	type = "mental",
	subtype = { madness=true, slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#F53CBE##Target# slows in the grip of madness!", "+Slow" end,
	on_lose = function(self, err) return "#Target# overcomes the madness.", "-Slow" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_slow", 1))
		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "MADNESS_STUNNED", image = "effects/madness_stunned.png",
	desc = "Stunned by madness",
	long_desc = function(self, eff) return ("疯 狂 震 慑 目 标， 降 低 70％ 伤 害、 降 低 50％ 治 疗 效 果， 降 低 %d%% 精 神 抵 抗， 随 机 使 技 能 进 入 CD 并 降 低 50％ 移 动 速 度。 震 慑 时 技 能 不 能 冷 却。"):format(eff.mindResistChange) end,
	type = "mental",
	subtype = { madness=true, stun=true },
	status = "detrimental",
	parameters = {mindResistChange = -10},
	on_gain = function(self, err) return "#F53CBE##Target# is stunned by madness!", "+Stunned" end,
	on_lose = function(self, err) return "#Target# overcomes the madness", "-Stunned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))

		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.tcdid = self:addTemporaryValue("no_talents_cooldown", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1 -- Just set cooldown to 1 since cooldown does not decrease while stunned
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)

		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("no_talents_cooldown", eff.tcdid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
	end,
}

newEffect{
	name = "MADNESS_CONFUSED", image = "effects/madness_confused.png",
	desc = "Confused by madness",
	long_desc = function(self, eff) return ("疯 狂 使 目 标 混 乱， 降 低 目 标 %d%% 精 神 抵 抗， 使 目 标 随 机 行 动（ %d%% 概 率） 且 不 能 完 成 复 杂 动 作。"):format(eff.mindResistChange, eff.power) end,
	type = "mental",
	subtype = { madness=true, confusion=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#F53CBE##Target# is lost in madness!", "+Confused" end,
	on_lose = function(self, err) return "#Target# overcomes the madness", "-Confused" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("gloom_confused", 1))
		eff.mindResistChangeId = self:addTemporaryValue("resists", { [DamageType.MIND]=eff.mindResistChange })
		eff.power = math.floor(math.max(eff.power - (self:attr("confusion_immune") or 0) * 100, 10))
		eff.power = util.bound(eff.power, 0, 50)
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.mindResistChangeId)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("confused", eff.tmpid)
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "MALIGNED", image = "talents/getsture_of_malice.png",
	desc = "Maligned",
	long_desc = function(self, eff) return ("目 标 被 恶 性 感 染， 所 有 抵 抗 降 低 %d%% 。"):format(-eff.resistAllChange) end,
	type = "mental",
	subtype = { curse=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# has been maligned!", "+Maligned" end,
	on_lose = function(self, err) return "#Target# is no longer maligned.", "-Maligned" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("maligned", 1))
		eff.resistAllChangeId = self:addTemporaryValue("resists", { all=eff.resistAllChange })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistAllChangeId)
		self:removeParticles(eff.particle)
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
}

local function updateFearParticles(self)
	local hasParticles = false
	if self:hasEffect(self.EFF_PARANOID) then hasParticles = true end
	if self:hasEffect(self.EFF_DISPAIR) then hasParticles = true end
	if self:hasEffect(self.EFF_TERRIFIED) then hasParticles = true end
	if self:hasEffect(self.EFF_DISTRESSED) then hasParticles = true end
	if self:hasEffect(self.EFF_HAUNTED) then hasParticles = true end
	if self:hasEffect(self.EFF_TORMENTED) then hasParticles = true end

	if not self.fearParticlesId and hasParticles then
		self.fearParticlesId = self:addParticles(Particles.new("fear_blue", 1))
	elseif self.fearParticlesId and not hasParticles then
		self:removeParticles(self.fearParticlesId)
		self.fearParticlesId = nil
	end
end

newEffect{
	name = "PARANOID", image = "effects/paranoid.png",
	desc = "Paranoid",
	long_desc = function(self, eff) return ("目 标 被 妄 想 纠 缠， 有 %d%% 概 率 以 物 理 攻 击 附 近 任 一 目 标， 不 分 敌 我， 被 攻 击 者 也 可 能 陷 入 妄 想。"):format(eff.attackChance) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# becomes paranoid!", "+Paranoid" end,
	on_lose = function(self, err) return "#Target# is no longer paranoid", "-Paranoid" end,
	activate = function(self, eff)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	do_act = function(self, eff)
		if not self:enoughEnergy() then return nil end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.attackChance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the paranoia.", self.name:capitalize())
		else
			eff.timer = eff.timer + eff.attackChance
		end
		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local start = rng.range(0, 8)
			for i = start, start + 8 do
				local x = self.x + (i % 3) - 1
				local y = self.y + math.floor((i % 9) / 3) - 1
				if (self.x ~= x or self.y ~= y) then
					local target = game.level.map(x, y, Map.ACTOR)
					if target then
						self:logCombat(target, "#F53CBE##Source# attacks #Target# in a fit of paranoia.")
						if self:attackTarget(target, nil, 1, false) and target ~= eff.src then
							if not target:canBe("fear") then
								game.logSeen(target, "#F53CBE#%s ignores the fear!", target.name:capitalize())
							elseif not target:checkHit(eff.mindpower, target:combatMentalResist()) then
								game.logSeen(target, "%s resists the fear!", target.name:capitalize())
							else
								target:setEffect(target.EFF_PARANOID, eff.duration, {src=eff.src, attackChance=eff.attackChance, mindpower=eff.mindpower, duration=eff.duration })
							end
						end
						return
					end
				end
			end
		end
	end,
}

newEffect{
	name = "DISPAIR", image = "effects/despair.png",
	desc = "Despair",
	long_desc = function(self, eff) return ("目 标 陷 入 绝 望， 所 有 伤 害 降 低 %d%% 。"):format(-eff.resistAllChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# is in despair!", "+Despair" end,
	on_lose = function(self, err) return "#Target# is no longer in despair", "-Despair" end,
	activate = function(self, eff)
		eff.damageId = self:addTemporaryValue("resists", { all=eff.resistAllChange })
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.damageId)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
}

newEffect{
	name = "TERRIFIED", image = "effects/terrified.png",
	desc = "Terrified",
	long_desc = function(self, eff) return ("目 标 陷 入 惊 恐， 施 展 技 能 和 发 动 攻 击 时 有 %d%% 概 率 失 败。"):format(eff.actionFailureChance) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# becomes terrified!", "+Terrified" end,
	on_lose = function(self, err) return "#Target# is no longer terrified", "-Terrified" end,
	activate = function(self, eff)
		eff.terrifiedId = self:addTemporaryValue("terrified", eff.actionFailureChance)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		eff.terrifiedId = self:removeTemporaryValue("terrified", eff.terrifiedId)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
}

newEffect{
	name = "DISTRESSED", image = "effects/distressed.png",
	desc = "Distressed",
	long_desc = function(self, eff) return ("目 标 陷 入 痛 苦， 降 低 所 有 豁 免 %d 。"):format(-eff.saveChange) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# becomes distressed!", "+Distressed" end,
	on_lose = function(self, err) return "#Target# is no longer distressed", "-Distressed" end,
	activate = function(self, eff)
		eff.physicalId = self:addTemporaryValue("combat_physresist", eff.saveChange)
		eff.mentalId = self:addTemporaryValue("combat_mentalresist", eff.saveChange)
		eff.spellId = self:addTemporaryValue("combat_spellresist", eff.saveChange)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physresist", eff.physicalId)
		self:removeTemporaryValue("combat_mentalresist", eff.mentalId)
		self:removeTemporaryValue("combat_spellresist", eff.spellId)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
}

newEffect{
	name = "HAUNTED", image = "effects/haunted.png",
	desc = "Haunted",
	long_desc = function(self, eff) return ("目 标 被 死 亡 的 恐 惧 纠 缠， 所 有 现 存 和 新 产 生 的 恐 惧 效 果 造 成 %d 精 神 伤 害。"):format(eff.damage) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {damage=10},
	on_gain = function(self, err) return "#F53CBE##Target# becomes haunted!", "+Haunted" end,
	on_lose = function(self, err) return "#Target# is no longer haunted", "-Haunted" end,
	activate = function(self, eff)
		for e, p in pairs(self.tmp) do
			local def = self.tempeffect_def[e]
			if def.subtype and def.subtype.fear then
				if not self.dead then
					game.logSeen(self, "#F53CBE#%s is struck by fear of the %s effect.", self.name:capitalize(), def.desc)
					eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.MIND, { dam=eff.damage,alwaysHit=true,criticals=false,crossTierChance=0 })
				end
			end
		end
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	on_setFearEffect = function(self, e)
		local eff = self:hasEffect(self.EFF_HAUNTED)
		game.logSeen(self, "#F53CBE#%s is struck by fear of the %s effect.", self.name:capitalize(), util.getval(e.desc, self, e))
		eff.src:project({type="hit", x=self.x,y=self.y}, self.x, self.y, DamageType.MIND, { dam=eff.damage,alwaysHit=true,criticals=false,crossTierChance=0 })
	end,
}

newEffect{
	name = "TORMENTED", image = "effects/tormented.png",
	desc = "Tormented",
	long_desc = function(self, eff) return ("目 标 的 精 神 受 到 折 磨， 产 生 %d 幽 灵 攻 击 目 标， 每 一 个 幽 灵 造 成 %d 精 神 伤 害 直 至 其 消 失。"):format(eff.count, eff.damage) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {count=1, damage=10},
	on_gain = function(self, err) return "#F53CBE##Target# becomes tormented!", "+Tormented" end,
	on_lose = function(self, err) return "#Target# is no longer tormented", "-Tormented" end,
	activate = function(self, eff)
		updateFearParticles(self)
	end,
	deactivate = function(self, eff)
		updateFearParticles(self)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	npcTormentor = {
		name = "tormentor",
		display = "h", color=colors.DARK_GREY, image="npc/horror_eldritch_nightmare_horror.png",
		blood_color = colors.BLACK,
		desc = "A vision of terror that wracks the mind.",
		type = "horror", subtype = "eldritch",
		rank = 2,
		size_category = 2,
		body = { INVEN = 10 },
		no_drops = true,
		autolevel = "summoner",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=10, dex=20, wil=20, con=10, cun=30 },
		infravision = 10,
		can_pass = {pass_wall=20},
		resists = { all = 100, [DamageType.MIND]=-100 },
		no_breath = 1,
		fear_immune = 1,
		blind_immune = 1,
		infravision = 10,
		see_invisible = 80,
		max_life = resolvers.rngavg(50, 80),
		combat_armor = 1, combat_def = 50,
		combat = { dam=1 },
		resolvers.talents{
		},
		on_act = function(self)
			local target = self.ai_target.actor
			if not target or target.dead then
				self:die()
			else
				game.logSeen(self, "%s is tormented by a vision!", target.name:capitalize())
				self:project({type="hit", x=target.x,y=target.y}, target.x, target.y, engine.DamageType.MIND, { dam=self.tormentedDamage,alwaysHit=true,crossTierChance=75 })
				self:die()
			end
		end,
	},
	on_timeout = function(self, eff)
		if eff.src.dead then return true end

		-- tormentors per turn are pre-calculated in a table, but ordered, so take a random one
		local count = rng.tableRemove(eff.counts)
		for c = 1, count do
			local start = rng.range(0, 8)
			for i = start, start + 8 do
				local x = self.x + (i % 3) - 1
				local y = self.y + math.floor((i % 9) / 3) - 1
				if game.level.map:isBound(x, y) and not game.level.map(x, y, Map.ACTOR) then
					local def = self.tempeffect_def[self.EFF_TORMENTED]
					local m = require("mod.class.NPC").new(def.npcTormentor)
					m.faction = eff.src.faction
					m.summoner = eff.src
					m.summoner_gain_exp = true
					m.summon_time = 3
					m.tormentedDamage = eff.damage
					m:resolve() m:resolve(nil, true)
					m:forceLevelup(self.level)
					m:setTarget(self)

					game.zone:addEntity(game.level, m, "actor", x, y)

					break
				end
			end
		end
	end,
}

newEffect{
	name = "PANICKED", image = "talents/panic.png",
	desc = "Panicked",
	long_desc = function(self, eff) return ("目 标 对 %s 感 到 恐 慌， 使 其 有 %d%% 概 率 因 为 害 怕 而 逃 跑。"):format(eff.src.name, eff.chance) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# becomes panicked!", "+Panicked" end,
	on_lose = function(self, err) return "#Target# is no longer panicked", "-Panicked" end,
	activate = function(self, eff)
		eff.particlesId = self:addParticles(Particles.new("fear_violet", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particlesId)

		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		tInstillFear.endEffect(self, tInstillFear)
	end,
	do_act = function(self, eff)
		if not self:enoughEnergy() then return nil end
		if eff.src.dead then return true end

		-- apply periodic timer instead of random chance
		if not eff.timer then
			eff.timer = rng.float(0, 100)
		end
		if not self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
			eff.timer = eff.timer + eff.chance * 0.5
			game.logSeen(self, "#F53CBE#%s struggles against the panic.", self.name:capitalize())
		else
			eff.timer = eff.timer + eff.chance
		end
		if eff.timer > 100 then
			eff.timer = eff.timer - 100

			local distance = core.fov.distance(self.x, self.y, eff.src.x, eff.src.y)
			if distance <= eff.range then
				-- in range
				if not self:attr("never_move") then
					local sourceX, sourceY = eff.src.x, eff.src.y

					local bestX, bestY
					local bestDistance = 0
					local start = rng.range(0, 8)
					for i = start, start + 8 do
						local x = self.x + (i % 3) - 1
						local y = self.y + math.floor((i % 9) / 3) - 1

						if x ~= self.x or y ~= self.y then
							local distance = core.fov.distance(x, y, sourceX, sourceY)
							if distance > bestDistance
									and game.level.map:isBound(x, y)
									and not game.level.map:checkAllEntities(x, y, "block_move", self)
									and not game.level.map(x, y, Map.ACTOR) then
								bestDistance = distance
								bestX = x
								bestY = y
							end
						end
					end

					if bestX then
						self:move(bestX, bestY, false)
						game.logPlayer(self, "#F53CBE#You panic and flee from %s.", eff.src.name)
					else
						self:logCombat(eff.src, "#F53CBE##Source# panics but fails to flee from #Target#.")
						self:useEnergy(game.energy_to_act * self:combatMovementSpeed(bestX, bestY))
					end
				end
			end
		end
	end,
}

newEffect{
	name = "QUICKNESS", image = "effects/quickness.png",
	desc = "Quick",
	long_desc = function(self, eff) return ("增 加 %d%% 整 体 速 度。"):format(eff.power * 100) end,
	type = "mental",
	subtype = { telekinesis=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Quick" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Quick" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "PSIFRENZY", image = "talents/frenzied_focus.png",
	desc = "Frenzied Focus",
	long_desc = function(self, eff) return ("使 念 力 控 制 武 器 每 回 合 攻 击 %d 个 目 标。"):format(eff.power) end,
	type = "mental",
	subtype = { telekinesis=true, frenzy=true },
	status = "beneficial",
	parameters = {dam=10},
	on_gain = function(self, err) return "#Target# enters a frenzy!", "+Frenzy" end,
	on_lose = function(self, err) return "#Target# is no longer frenzied.", "-Frenzy" end,
}

newEffect{
	name = "KINSPIKE_SHIELD", image = "talents/kinetic_shield.png",
	desc = "Spiked Kinetic Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and ", nature" or "")..(tl>=6 and ", temporal" or "")
		return ("目 标 施 放 一 个 念 力 护 盾 吸 收 %d/%d 物 理 或 酸 性 伤 害。"):format(self.kinspike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A powerful kinetic shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The powerful kinetic shield around #target# crumbles.", "-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("kinspike_shield", eff.power)
		self.kinspike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={1, 0, 0.3, 0.6}, auraColor={1, 0, 0.3, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=0, b=0.3, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("kinspike_shield", eff.tmpid)
		self.kinspike_shield_absorb = nil
	end,
}
newEffect{
	name = "THERMSPIKE_SHIELD", image = "talents/thermal_shield.png",
	desc = "Spiked Thermal Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and ", light" or "")..(tl>=6 and ", arcane" or "")
		return ("目 标 施 放 一 个 热 能 护 盾 吸 收 %d/%d 热 能 伤 害。"):format(self.thermspike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A powerful thermal shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The powerful thermal shield around #target# crumbles.", "-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("thermspike_shield", eff.power)
		self.thermspike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={0.3, 1, 1, 0.6}, auraColor={0.3, 1, 1, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0.3, g=1, b=1, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("thermspike_shield", eff.tmpid)
		self.thermspike_shield_absorb = nil
	end,
}
newEffect{
	name = "CHARGESPIKE_SHIELD", image = "talents/charged_shield.png",
	desc = "Spiked Charged Shield",
	long_desc = function(self, eff)
		local tl = self:getTalentLevel(self.T_ABSORPTION_MASTERY)
		local xs = (tl>=3 and ", darkness" or "")..(tl>=6 and ", mind" or "")
	return ("目 标 施 放 一 个 充 电 护 盾 吸 收 %d/%d 闪 电 或 枯 萎 伤 害。"):format(self.chargespike_shield_absorb, eff.power, xs)
	end,
	type = "mental",
	subtype = { telekinesis=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A powerful charged shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The powerful charged shield around #target# crumbles.", "-Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("chargespike_shield", eff.power)
		self.chargespike_shield_absorb = eff.power

		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={0.8, 1, 0.2, 0.6}, auraColor={0.8, 1, 0.2, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0.8, g=1, b=0.2, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("chargespike_shield", eff.tmpid)
		self.chargespike_shield_absorb = nil
	end,
}

newEffect{
	name = "CONTROL", image = "talents/perfect_control.png",
	desc = "Perfect control",
	long_desc = function(self, eff) return ("分 别 目 标 提 高 目 标 %d 攻 击 强 度 和 %d%% 暴 击 率。"):format(eff.power, 0.5*eff.power) end,
	type = "mental",
	subtype = { telekinesis=true, focus=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.attack = self:addTemporaryValue("combat_atk", eff.power)
		eff.crit = self:addTemporaryValue("combat_physcrit", 0.5*eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.attack)
		self:removeTemporaryValue("combat_physcrit", eff.crit)
	end,
}

newEffect{
	name = "PSI_REGEN", image = "talents/matter_is_energy.png",
	desc = "Matter is energy",
	long_desc = function(self, eff) return ("宝 石 缓 慢 转 化， 每 回 合 产 生 %0.2f 能 量。"):format(eff.power) end,
	type = "mental",
	subtype = { psychic_drain=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "Energy starts pouring from the gem into #Target#.", "+Energy" end,
	on_lose = function(self, err) return "The flow of energy from #Target#'s gem ceases.", "-Energy" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("psi_regen", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("psi_regen", eff.tmpid)
	end,
}

newEffect{
	name = "MASTERFUL_TELEKINETIC_ARCHERY", image = "talents/masterful_telekinetic_archery.png",
	desc = "Telekinetic Archery",
	long_desc = function(self, eff) return ("你 的 念 动 弓 箭 每 回 合 会 向 最 近 目 标 自 动 射 击。") end,
	type = "mental",
	subtype = { telekinesis=true },
	status = "beneficial",
	parameters = {dam=10},
	on_gain = function(self, err) return "#Target# enters a telekinetic archer's trance!", "+Telekinetic archery" end,
	on_lose = function(self, err) return "#Target# is no longer in a telekinetic archer's trance.", "-Telekinetic archery" end,
}

newEffect{
	name = "WEAKENED_MIND", image = "talents/taint__telepathy.png",
	desc = "Receptive Mind",
	long_desc = function(self, eff) return ("降 低 精 神 豁 免 %d 并 增 加 精 神 强 度 %d."):format(eff.save, eff.power) end,
	type = "mental",
	subtype = { morale=true },
	status = "detrimental",
	parameters = { power=10, save=10 },
	activate = function(self, eff)
		eff.mindid = self:addTemporaryValue("combat_mentalresist", -eff.save)
		eff.powdid = self:addTemporaryValue("combat_mindpower", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.mindid)
		self:removeTemporaryValue("combat_mindpower", eff.powdid)
	end,
}

newEffect{
	name = "VOID_ECHOES", image = "talents/echoes_from_the_void.png",
	desc = "Void Echoes",
	long_desc = function(self, eff) return ("目 标 收 到 虚 空 的 回 声， 每 回 合 进 行 精 神 豁 免 检 定， 失 败 则 在 造 成 原 伤 害 的 同 时 附 加 %0.2f 精 神 伤 害。"):format(eff.power) end,
	type = "mental",
	subtype = { madness=true, psionic=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is being driven mad by the void.", "+Void Echoes" end,
	on_lose = function(self, err) return "#Target# has survived the void madness.", "-Void Echoes" end,
	on_timeout = function(self, eff)
		local drain = DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.power) / 2
		self:incMana(-drain)
		self:incVim(-drain * 0.5)
		self:incPositive(-drain * 0.25)
		self:incNegative(-drain * 0.25)
		self:incStamina(-drain * 0.65)
		self:incHate(-drain * 0.2)
		self:incPsi(-drain * 0.2)
	end,
}

newEffect{
	name = "WAKING_NIGHTMARE", image = "talents/waking_nightmare.png",
	desc = "Waking Nightmare",
	long_desc = function(self, eff) return ("目 标 陷 入 清 醒 状 态 的 噩 梦 之 中， 每 回 合 造 成 %0.2f 暗 影 伤 害， 并 有 %d%% 概 率 受 到 一 个 随 机 不 良 效 果。"):format(eff.dam, eff.chance) end,
	type = "mental",
	subtype = { nightmare=true, darkness=true },
	status = "detrimental",
	parameters = { chance=10, dam = 10 },
	on_gain = function(self, err) return "#F53CBE##Target# is lost in a nightmare.", "+Night Terrors" end,
	on_lose = function(self, err) return "#Target# is free from the nightmare.", "-Night Terrors" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src or self, self.x, self.y, DamageType.DARKNESS, eff.dam)
		local chance = eff.chance
		if self:attr("sleep") then chance = 100-(100-chance)/2 end -- Half normal chance to avoid effect
		if rng.percent(chance) then
			-- Pull random effect
			chance = rng.range(1, 3)
			if chance == 1 then
				if self:canBe("blind") then
					self:setEffect(self.EFF_BLINDED, 3, {})
				end
			elseif chance == 2 then
				if self:canBe("stun") then
					self:setEffect(self.EFF_STUNNED, 3, {})
				end
			elseif chance == 3 then
				if self:canBe("confusion") then
					self:setEffect(self.EFF_CONFUSED, 3, {power=50})
				end
			end
			game.logSeen(self, "#F53CBE#%s succumbs to the nightmare!", self.name:capitalize())
		end
	end,
}

newEffect{
	name = "INNER_DEMONS", image = "talents/inner_demons.png",
	desc = "Inner Demons",
	long_desc = function(self, eff) return ("目 标 内 心 深 处 的 恶 魔 被 召 唤， 每 回 合 有 %d%% 概 率 出 现， 如 果 施 法 者 被 杀 死 或 者 法 术 豁 免 则 该 效 果 会 提 前 结 束。"):format(eff.chance) end,
	type = "mental",
	subtype = { nightmare=true },
	status = "detrimental",
	remove_on_clone = true,
	parameters = {chance=0},
	on_gain = function(self, err) return "#F53CBE##Target# is plagued by inner demons!", "+Inner Demons" end,
	on_lose = function(self, err) return "#Target# is freed from the demons.", "-Inner Demons" end,
	on_timeout = function(self, eff)
		if eff.src.dead or not game.level:hasEntity(eff.src) then eff.dur = 0 return true end
		local t = eff.src:getTalentFromId(eff.src.T_INNER_DEMONS)
		local chance = eff.chance
		if self:attr("sleep") then chance = 100-(100-chance)/2 end -- Half normal chance not to manifest
		if rng.percent(chance) then
			if self:attr("sleep") or self:checkHit(eff.src:combatMindpower(), self:combatMentalResist(), 0, 95, 5) then
				t.summon_inner_demons(eff.src, self, t)
			else
				eff.dur = 0
			end
		end
	end,
}

newEffect{
	name = "PACIFICATION_HEX", image = "talents/pacification_hex.png",
	desc = "Pacification Hex",
	long_desc = function(self, eff) return ("目 标 受 邪 术 影 响， 每 回 合 有 %d%% 概 率 眩 晕 3 回 合。"):format(eff.chance) end,
	type = "mental",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = {chance=10, power=10},
	on_gain = function(self, err) return "#Target# is hexed!", "+Pacification Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Pacification Hex" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if not self:hasEffect(self.EFF_DAZED) and rng.percent(eff.chance) and self:canBe("stun") then
			self:setEffect(self.EFF_DAZED, 3, {})
			if not self:checkHit(eff.power, self:combatSpellResist(), 0, 95, 15) then eff.dur = 0 end
		end
	end,
	activate = function(self, eff)
		if self:canBe("stun") then
			self:setEffect(self.EFF_DAZED, 3, {})
		end
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.5, a=225, appear=8, speed=0, img="pacification_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
}

newEffect{
	name = "BURNING_HEX", image = "talents/burning_hex.png",
	desc = "Burning Hex",
	long_desc = function(self, eff) return ("目 标 受 邪 术 影 响， 每 次 施 放 技 能 都 会 受 到 %0.2f 火 焰 伤 害, 技 能 冷 却 延 长 %s 再 延 长 1 回 合 。"):
		format(eff.dam, eff.power and ("%d%%"):format((eff.power-1)*100) or "")
	end,
	type = "mental",
	subtype = { hex=true, fire=true },
	status = "detrimental",
	-- _M:getTalentCooldown(t) in mod.class.Actor.lua references this table to compute cooldowns
	parameters = {dam=10, power = 1},
	on_gain = function(self, err) return "#Target# is hexed!", "+Burning Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Burning Hex" end,
}

newEffect{
	name = "EMPATHIC_HEX", image = "talents/empathic_hex.png",
	desc = "Empathic Hex",
	long_desc = function(self, eff) return ("目 标 受 邪 术 影 响， 使 其 造 成 的 伤 害 发 生 偏 转， 所 有 其 造 成 的 伤 害 有 %d%% 会 反 弹 给 自 己。"):format(eff.power) end,
	type = "mental",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is hexed!", "+Empathic Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Empathic hex" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("martyrdom", eff.power)
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {toback=true, shader=true, oversize=0.5, a=225, appear=8, speed=0, img="empathic_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self:removeTemporaryValue("martyrdom", eff.tmpid)
	end,
}

newEffect{
	name = "DOMINATION_HEX", image = "talents/domination_hex.png",
	desc = "Domination Hex",
	long_desc = function(self, eff) return ("目 标 受 邪 术 影 响， 暂 时 改 变 阵 营 至 %s 。"):format(engine.Faction.factions[eff.faction].name) end,
	type = "mental",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is hexed!", "+Domination Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Domination hex" end,
	activate = function(self, eff)
		self:setTarget() -- clear ai target
		eff.olf_faction = self.faction
		self.faction = eff.src.faction
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=1, a=225, appear=8, speed=0, img="domination_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self.faction = eff.olf_faction
	end,
}


newEffect{
	name = "DOMINATE_ENTHRALL", image = "talents/yeek_will.png",
	desc = "Enthralled",
	long_desc = function(self, eff) return ("目 标 被 迷 惑， 暂 时 改 变 了 其 阵 营。 ") end,-- to %s.")--:format(engine.Faction.factions[eff.faction].name) end,
	type = "mental",
	subtype = { dominate=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is entralled.", "+Enthralled" end,
	on_lose = function(self, err) return "#Target# is free from the domination.", "-Enthralled" end,
	activate = function(self, eff)
		eff.olf_faction = self.faction
		self.faction = eff.src.faction
	end,
	deactivate = function(self, eff)
		self.faction = eff.olf_faction
	end,
}

newEffect{
	name = "HALFLING_LUCK", image = "talents/halfling_luck.png",
	desc = "Halflings's Luck",
	long_desc = function(self, eff) return ("目 标 的 好 运 和 机 智 提 高 %d%%  暴 击 率 和 %d 豁 免。"):format(eff.crit, eff.save) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { crit=10, save=10 },
	on_gain = function(self, err) return "#Target# seems more aware." end,
	on_lose = function(self, err) return "#Target#'s awareness returns to normal." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_generic_crit", eff.crit)
		self:effectTemporaryValue(eff, "combat_physresist", eff.save)
		self:effectTemporaryValue(eff, "combat_spellresist", eff.save)
		self:effectTemporaryValue(eff, "combat_mentalresist", eff.save)
	end,
}

newEffect{
	name = "ATTACK", image = "talents/perfect_strike.png",
	desc = "Attack",
	long_desc = function(self, eff) return ("目 标 的 攻 击 命 中 提 高 %d 。"):format(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# aims carefully." end,
	on_lose = function(self, err) return "#Target# aims less carefully." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_atk", eff.power)
		eff.bid = self:addTemporaryValue("blind_fight", 1)
		self:effectParticles(eff, {type="perfect_strike", args={radius=1}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.tmpid)
		self:removeTemporaryValue("blind_fight", eff.bid)
	end,
}

newEffect{
	name = "DEADLY_STRIKES", image = "talents/deadly_strikes.png",
	desc = "Deadly Strikes",
	long_desc = function(self, eff) return ("目 标 护 甲 穿 透 提 高 %d 。"):format(eff.power) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# aims carefully." end,
	on_lose = function(self, err) return "#Target# aims less carefully." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_apr", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_apr", eff.tmpid)
	end,
}

newEffect{
	name = "FRENZY", image = "effects/frenzy.png",
	desc = "Frenzy",
	long_desc = function(self, eff) return ("提 升 整 体 速 度 %d%% 并 提 高 物 理 暴 击 率 %d%% 。 \n 另 外 目 标 会 持 续 攻 击 直 到 其 攻 击 点 数 达 到 -%d%% 。"):format(eff.power * 100, eff.crit, eff.dieat * 100) end,
	type = "mental",
	subtype = { frenzy=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# goes into a killing frenzy.", "+Frenzy" end,
	on_lose = function(self, err) return "#Target# calms down.", "-Frenzy" end,
	on_merge = function(self, old_eff, new_eff)
		-- use on merge so reapplied frenzy doesn't kill off creatures with negative life
		old_eff.dur = new_eff.dur
		old_eff.power = new_eff.power
		old_eff.crit = new_eff.crit
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
		eff.critid = self:addTemporaryValue("combat_physcrit", eff.crit)
		eff.dieatid = self:addTemporaryValue("die_at", -self.max_life * eff.dieat)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeTemporaryValue("combat_physcrit", eff.critid)
		self:removeTemporaryValue("die_at", eff.dieatid)

		-- check negative life first incase the creature has healing
		if self.life <= (self.die_at or 0) then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), "Falls dead!", {255,0,255})
			game.logSeen(self, "%s dies when its frenzy ends!", self.name:capitalize())
			self:die(self)
		end
	end,
}

newEffect{
	name = "BLOODBATH", image = "talents/bloodbath.png",
	desc = "Bloodbath",
	long_desc = function(self, eff) return ("目 标 被 战 斗 激 励 提 升 生 命 上 限 %d%% 、 提 升 生 命 回 复 %0.2f 、 提 升 体 力 回 复 %0.2f 。"):format(eff.hp, eff.cur_regen or eff.regen, eff.cur_regen/5 or eff.regen/5) end,
	type = "mental",
	subtype = { frenzy=true, heal=true },
	status = "beneficial",
	parameters = { hp=10, regen=10, max=50 },
	on_gain = function(self, err) return nil, "+Bloodbath" end,
	on_lose = function(self, err) return nil, "-Bloodbath" end,
	on_merge = function(self, old_eff, new_eff)
		if old_eff.cur_regen + new_eff.regen < new_eff.max then	game.logSeen(self, "%s's blood frenzy intensifies!", self.name:capitalize()) end
		new_eff.templife_id = old_eff.templife_id
		self:removeTemporaryValue("max_life", old_eff.life_id)
		self:removeTemporaryValue("life_regen", old_eff.life_regen_id)
		self:removeTemporaryValue("stamina_regen", old_eff.stamina_regen_id)
		new_eff.particle1 = old_eff.particle1
		new_eff.particle2 = old_eff.particle2

		-- Take the new values, dont heal, otherwise you get a free heal each crit .. which is totaly broken
		local v = new_eff.hp * self.max_life / 100
		new_eff.life_id = self:addTemporaryValue("max_life", v)
		new_eff.cur_regen = math.min(old_eff.cur_regen + new_eff.regen, new_eff.max)
		new_eff.life_regen_id = self:addTemporaryValue("life_regen", new_eff.cur_regen)
		new_eff.stamina_regen_id = self:addTemporaryValue("stamina_regen", new_eff.cur_regen/5)
		return new_eff
	end,
	activate = function(self, eff)
		local v = eff.hp * self.max_life / 100
		eff.life_id = self:addTemporaryValue("max_life", v)
		eff.templife_id = self:addTemporaryValue("life",v) -- Prevent healing_factor affecting activation
		eff.cur_regen = eff.regen
		eff.life_regen_id = self:addTemporaryValue("life_regen", eff.regen)
		eff.stamina_regen_id = self:addTemporaryValue("stamina_regen", eff.regen /5)
		game.logSeen(self, "%s revels in the spilt blood and grows stronger!",self.name:capitalize())

		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)

		self:removeTemporaryValue("max_life", eff.life_id)
		self:removeTemporaryValue("life_regen", eff.life_regen_id)
		self:removeTemporaryValue("stamina_regen", eff.stamina_regen_id)
		
		self:removeTemporaryValue("life",eff.templife_id) -- remove extra hps to prevent excessive heals at high level
		game.logSeen(self, "%s no longer revels in blood quite so much.",self.name:capitalize())
	end,
}

newEffect{
	name = "BLOODRAGE", image = "talents/bloodrage.png",
	desc = "Bloodrage",
	long_desc = function(self, eff) return ("由 于 紧 张 的 战 斗， 目 标 力 量 属 性 增 加 %d 。"):format(eff.cur_inc) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { inc=1, max=10 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("inc_stats", old_eff.tmpid)
		old_eff.cur_inc = math.min(old_eff.cur_inc + new_eff.inc, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = old_eff.cur_inc})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_inc = eff.inc
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = eff.inc})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "INCREASED_LIFE", image = "effects/increased_life.png",
	desc = "Increased Life",
	long_desc = function(self, eff) return ("目 标 生 命 上 限 增 加 %d 。"):format(eff.life) end,
	type = "mental",
	subtype = { frenzy=true, heal=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# gains extra life.", "+Life" end,
	on_lose = function(self, err) return "#Target# loses extra life.", "-Life" end,
	parameters = { life = 50 },
	activate = function(self, eff)
		self.max_life = self.max_life + eff.life
		self.life = self.life + eff.life
		self.changed = true
	end,
	deactivate = function(self, eff)
		self.max_life = self.max_life - eff.life
		self.life = self.life - eff.life
		self.changed = true
		if self.life <= 0 then
			self.life = 1
			self:setEffect(self.EFF_STUNNED, 3, {})
			game.logSeen(self, "%s's increased life fades, leaving it stunned by the loss.", self.name:capitalize())
		end
	end,
}

newEffect{
	name = "GESTURE_OF_GUARDING", image = "talents/gesture_of_guarding.png",
	desc = "Guarded",
	long_desc = function(self, eff)
		local xs = ""
		local dam, deflects = eff.dam, eff.deflects
		if deflects < 1 then -- Partial deflect has reduced effectiveness
			dam = dam*math.max(0,deflects)
			deflects = 1
		end
		if self:isTalentActive(self.T_GESTURE_OF_PAIN) then xs = ("，并 有 %d%% 几 率 让 对 方 处 于 被 反 击 状 态 " ):format(self:callTalent(self.T_GESTURE_OF_GUARDING,"getCounterAttackChance")) end
		return ("防 御 近 战 伤 害 ： 减 少 %d 点 伤 害 ， 剩 余 次 数 %0.1f%s."):format(dam, deflects, xs)
	end,
	charges = function(self, eff) return "#LIGHT_GREEN#"..math.ceil(eff.deflects) end,
	type = "mental",
	subtype = { curse=true },
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {dam = 1, deflects = 1},
	activate = function(self, eff)
		eff.dam = self:callTalent(self.T_GESTURE_OF_GUARDING,"getDamageChange")
		eff.deflects = self:callTalent(self.T_GESTURE_OF_GUARDING,"getDeflects")
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RAMPAGE", image = "talents/rampage.png",
	desc = "Rampaging",
	long_desc = function(self, eff)
		local desc = ("目 标 进 入 暴 走 状 态！ (+%d%% 移 动 速 度， +%d%% 攻 击 速 度"):format(eff.movementSpeedChange * 100, eff.combatPhysSpeedChange * 100)
		if eff.physicalDamageChange > 0 then
			desc = desc..(", +%d%% 物 理 伤 害， +%d 物 理 豁 免， +%d 精 神 豁 免"):format(eff.physicalDamageChange, eff.combatPhysResistChange, eff.combatMentalResistChange)
		end
		if eff.damageShieldMax > 0 then
			desc = desc..(", %d/%d 本 回 合 无 视 伤 害"):format(math.max(0, eff.damageShieldMax - eff.damageShield), eff.damageShieldMax)
		end
		desc = desc..")"
		return desc
	end,
	type = "mental",
	subtype = { frenzy=true, speed=true, evade=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#F53CBE##Target# begins rampaging!", "+Rampage" end,
	on_lose = function(self, err) return "#F53CBE##Target# is no longer rampaging.", "-Rampage" end,
	activate = function(self, eff)
		if eff.movementSpeedChange or 0 > 0 then eff.movementSpeedId = self:addTemporaryValue("movement_speed", eff.movementSpeedChange) end
		if eff.combatPhysSpeedChange or 0 > 0 then eff.combatPhysSpeedId = self:addTemporaryValue("combat_physspeed", eff.combatPhysSpeedChange) end
		if eff.physicalDamageChange or 0 > 0 then eff.physicalDamageId = self:addTemporaryValue("inc_damage", { [DamageType.PHYSICAL] = eff.physicalDamageChange }) end
		if eff.combatPhysResistChange or 0 > 0 then eff.combatPhysResistId = self:addTemporaryValue("combat_physresist", eff.combatPhysResistChange) end
		if eff.combatMentalResistChange or 0 > 0 then eff.combatMentalResistId = self:addTemporaryValue("combat_mentalresist", eff.combatMentalResistChange) end

		if not self:addShaderAura("rampage", "awesomeaura", {time_factor=5000, alpha=0.7}, "particles_images/bloodwings.png") then
			eff.particle = self:addParticles(Particles.new("rampage", 1))
		end
	end,
	deactivate = function(self, eff)
		if eff.movementSpeedId then self:removeTemporaryValue("movement_speed", eff.movementSpeedId) end
		if eff.combatPhysSpeedId then self:removeTemporaryValue("combat_physspeed", eff.combatPhysSpeedId) end
		if eff.physicalDamageId then self:removeTemporaryValue("inc_damage", eff.physicalDamageId) end
		if eff.combatPhysResistId then self:removeTemporaryValue("combat_physresist", eff.combatPhysResistId) end
		if eff.combatMentalResistId then self:removeTemporaryValue("combat_mentalresist", eff.combatMentalResistId) end

		self:removeShaderAura("rampage")
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		-- restore damage shield
		if eff.damageShieldMax and eff.damageShield ~= eff.damageShieldMax and not self.dead then
			eff.damageShieldUsed = (eff.damageShieldUsed or 0) + eff.damageShieldMax - eff.damageShield
			game.logSeen(self, "%s豁免了%d伤害，仍意犹未尽。", npcCHN:getName(self.name), eff.damageShieldMax - eff.damageShield)
			eff.damageShield = eff.damageShieldMax

			if eff.damageShieldBonus and eff.damageShieldUsed >= eff.damageShieldBonus and eff.actualDuration < eff.maxDuration then
				eff.actualDuration = eff.actualDuration + 1
				eff.dur = eff.dur + 1
				eff.damageShieldBonus = nil

				game.logPlayer(self, "#F53CBE##F53CBE#你的猛攻强化了你的暴走！（+1持续时间）。")
			end
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		if not eff.damageShieldMax or eff.damageShield <= 0 then return dam end

		local absorb = math.min(eff.damageShield, dam)
		eff.damageShield = eff.damageShield - absorb

		--game.logSeen(self, "%s shrugs off %d damage.", self.name:capitalize(), absorb)

		return dam - absorb
	end,
	do_postUseTalent = function(self, eff)
		if eff.dur > 0 then
			eff.dur = eff.dur - 1

			game.logPlayer(self, "#F53CBE#你感受到你的暴走开始减速。（-1持续时间）。")
		end
	end,
}

newEffect{
	name = "PREDATOR", image = "effects/predator.png",
	desc = "Predator",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	long_desc = function(self, eff)
		local desc = ([[目 标 正 在 猎 捕 以 下 类 型 生 物： %s / %s 附 带 %d%% 效 果。 击 杀： %d / %d ， 伤 害： %+d%% / %+d%% ]]):format(eff.type, eff.subtype, (eff.effectiveness * 100) or 0, eff.typeKills, eff.subtypeKills, (eff.typeDamageChange * 100) or 0, (eff.subtypeDamageChange * 100) or 0)
		if eff.subtypeAttackChange or 0 > 0 then
			desc = desc..([[， 命 中： %+d / %+d ， 震 慑： -- / %0.1f%% ， 运 筹 帷 幄： %0.1f%% / %0.1f%%]]):format(eff.typeAttackChange or 0, eff.subtypeAttackChange or 0, eff.subtypeStunChance or 0, eff.typeOutmaneuverChance or 0, eff.subtypeOutmaneuverChance or 0)
		end
		return desc
	end,
	type = "mental",
	subtype = { predator=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, eff) return ("#Target# begins hunting %s / %s."):format(eff.type, eff.subtype) end,
	on_lose = function(self, eff) return ("#Target# is no longer hunting %s / %s."):format(eff.type, eff.subtype) end,
	activate = function(self, eff)
		local e = self.tempeffect_def[self.EFF_PREDATOR]
		e.updateEffect(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	addKill = function(self, target, e, eff)
		if target.type == eff.type then
			local isSubtype = (target.subtype == eff.subtype)
			if isSubtype then
				eff.subtypeKills = eff.subtypeKills + 1
				eff.killExperience = eff.killExperience + 1
			else
				eff.typeKills = eff.typeKills + 1
				eff.killExperience = eff.killExperience + 0.25
			end

			e.updateEffect(self, eff)

			-- apply hate bonus
			if isSubtype and self:knowTalent(self.T_HATE_POOL) then
				self:incHate(eff.hateBonus)
				game.logPlayer(self, "#F53CBE#猎物的死亡增加了你的仇恨。(+%d 仇恨)", eff.hateBonus)
			end

			-- apply mimic effect
			if isSubtype and self:knowTalent(self.T_MIMIC) then
				local tMimic = self:getTalentFromId(self.T_MIMIC)
				self:setEffect(self.EFF_MIMIC, 1, { target = target, maxIncrease = math.ceil(tMimic.getMaxIncrease(self, tMimic) * eff.effectiveness) })
			end
		end
	end,
	updateEffect = function(self, eff)
		local tMarkPrey = self:getTalentFromId(self.T_MARK_PREY)
		eff.maxKillExperience = tMarkPrey.getMaxKillExperience(self, tMarkPrey)
		eff.effectiveness = math.min(1, eff.killExperience / eff.maxKillExperience)
		eff.subtypeDamageChange = tMarkPrey.getSubtypeDamageChange(self, tMarkPrey) * eff.effectiveness
		eff.typeDamageChange = tMarkPrey.getTypeDamageChange(self, tMarkPrey) * eff.effectiveness

		local tAnatomy = self:getTalentFromId(self.T_ANATOMY)
		if tAnatomy and self:getTalentLevelRaw(tAnatomy) > 0 then
			eff.subtypeAttackChange = tAnatomy.getSubtypeAttackChange(self, tAnatomy) * eff.effectiveness
			eff.typeAttackChange = tAnatomy.getTypeAttackChange(self, tAnatomy) * eff.effectiveness
			eff.subtypeStunChance = tAnatomy.getSubtypeStunChance(self, tAnatomy) * eff.effectiveness
		else
			eff.subtypeAttackChange = 0
			eff.typeAttackChange = 0
			eff.subtypeStunChance = 0
		end

		local tOutmaneuver = self:getTalentFromId(self.T_OUTMANEUVER)
		if tOutmaneuver and self:getTalentLevelRaw(tOutmaneuver) > 0 then
			eff.typeOutmaneuverChance = tOutmaneuver.getTypeChance(self, tOutmaneuver) * eff.effectiveness
			eff.subtypeOutmaneuverChance = tOutmaneuver.getSubtypeChance(self, tOutmaneuver) * eff.effectiveness
		else
			eff.typeOutmaneuverChance = 0
			eff.subtypeOutmaneuverChance = 0
		end

		eff.hateBonus = tMarkPrey.getHateBonus(self, tMarkPrey)
	end,
}

newEffect{
	name = "OUTMANEUVERED", image = "talents/outmaneuver.png",
	desc = "Outmaneuvered",
	long_desc = function(self, eff)
		local desc = ("目 标 受 到 运 筹 帷 幄 效 果， (%d%% 物 理 抗 性，"):format(eff.physicalResistChange)
		local first = true
		for id, value in pairs(eff.incStats) do
			if not first then desc = desc..", " end
			first = false
			desc = desc..("%+d %s"):format(value, Stats.stats_def[id].name:capitalize())
		end
		desc = desc..")"
		return desc
	end,
	type = "mental",
	subtype = { predator=true },
	status = "detrimental",
	on_gain = function(self, eff) return "#Target# is outmaneuvered." end,
	on_lose = function(self, eff) return "#Target# is no longer outmaneuvered." end,
	addEffect = function(self, eff)
		if eff.physicalResistId then self:removeTemporaryValue("resists", eff.physicalResistId) end
		eff.physicalResistId = self:addTemporaryValue("resists", { [DamageType.PHYSICAL]=eff.physicalResistChange })

		local maxId
		local maxValue = 0
		for id, def in ipairs(self.stats_def) do
			if def.id ~= self.STAT_LCK then
				local value = self:getStat(id, nil, nil, false)
				if value > maxValue then
					maxId = id
					maxValue = value
				end
			end
		end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) end
		eff.incStats = eff.incStats or {}
		eff.incStats[maxId] = (eff.incStats[maxId] or 0) - eff.statReduction
		eff.incStatsId = self:addTemporaryValue("inc_stats", eff.incStats)
		game.logSeen(self, ("%s has lost %d %s."):format(self.name:capitalize(), eff.statReduction, Stats.stats_def[maxId].name:capitalize()))
	end,
	activate = function(self, eff)
		self.tempeffect_def[self.EFF_OUTMANEUVERED].addEffect(self, eff)
	end,
	deactivate = function(self, eff)
		if eff.physicalResistId then self:removeTemporaryValue("resists", eff.physicalResistId) end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) end
	end,
	on_merge = function(self, old_eff, new_eff)
		-- spread old effects over new duration
		old_eff.physicalResistChange = math.min(50, new_eff.physicalResistChange + (old_eff.physicalResistChange * old_eff.dur / new_eff.dur))
		for id, value in pairs(old_eff.incStats) do
			old_eff.incStats[id] = math.ceil(value * old_eff.dur / new_eff.dur)
		end
		old_eff.dur = new_eff.dur

		-- add new effect
		self.tempeffect_def[self.EFF_OUTMANEUVERED].addEffect(self, old_eff)

		return old_eff
	end,
}

newEffect{
	name = "MIMIC", image = "talents/mimic.png",
	desc = "Mimic",
	long_desc = function(self, eff)
		if not eff.incStatsId then return "目 标 无 相 转 生 前 一 个 杀 死 的 生 物（ 无 增 益）" end

		local desc = "目 标 无 相 转 生 前 一 个 杀 死 的 生 物("
		local first = true
		for id, value in pairs(eff.incStats) do
			if not first then desc = desc..", " end
			first = false
			desc = desc..("%+d %s"):format(value, Stats.stats_def[id].name:capitalize())
		end
		desc = desc..")"
		return desc
	end,
	type = "mental",
	subtype = { predator=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = { },
	on_lose = function(self, eff) return "#Target# is no longer mimicking a previous victim." end,
	activate = function(self, eff)
		-- old version used difference from target stats and self stats; new version just uses target stats
		local sum = 0
		local values = {}
		for id, def in ipairs(self.stats_def) do
			if def.id and def.id ~= self.STAT_LCK then
				--local diff = eff.target:getStat(def.id, nil, nil, true) - self:getStat(def.id, nil, nil, true)
				local diff = eff.target:getStat(def.id, nil, nil, false)
				if diff > 0 then
					table.insert(values, { def.id, diff })
					sum = sum + diff
				end
			end
		end

		if sum > 0 then
			eff.incStats = {}
			if sum <= eff.maxIncrease then
				-- less than maximum; apply all stat differences
				for i, value in ipairs(values) do
					eff.incStats[value[1]] = value[2]
				end
			else
				-- distribute stats based on fractions and calculate what the remainder will be
				local sumIncrease = 0
				for i, value in ipairs(values) do
					value[2] = eff.maxIncrease * value[2] / sum
					sumIncrease = sumIncrease + math.floor(value[2])
				end
				local remainder = eff.maxIncrease - sumIncrease

				-- sort on fractional amount for distributing the remainder points
				table.sort(values, function(a,b) return a[2] % 1 > b[2] % 1 end)

				-- convert fractions to stat increases and apply remainder
				for i, value in ipairs(values) do
					eff.incStats[value[1]] = math.floor(value[2]) + (i <= remainder and 1 or 0)
				end
			end
			eff.incStatsId = self:addTemporaryValue("inc_stats", eff.incStats)
		end

		if not eff.incStatsId then
			self:logCombat(eff.target, "#Source# 正在无相转生#Target#. (无增益).")
		else
			local desc = "#Source# 正在无相转生#Target#. ("
			local first = true
			for id, value in pairs(eff.incStats) do
				if not first then desc = desc..", " end
				first = false
				desc = desc..("%+d %s"):format(value, Stats.stats_def[id].name:capitalize())
			end
			desc = desc..")"
			self:logCombat(eff.target, desc)
		end
	end,
	deactivate = function(self, eff)
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) end
		eff.incStats = nil
	end,
	on_merge = function(self, old_eff, new_eff)
		if old_eff.incStatsId then self:removeTemporaryValue("inc_stats", old_eff.incStatsId) end
		old_eff.incStats = nil
		old_eff.incStatsId = nil

		self.tempeffect_def[self.EFF_MIMIC].activate(self, new_eff)

		return new_eff
	end
}

newEffect{
	name = "ORC_FURY", image = "talents/orc_fury.png",
	desc = "Orcish Fury",
	long_desc = function(self, eff) return ("目 标 进 入 具 有 破 坏 力 的 愤 怒 状 态， 提 升 %d%% 伤 害。"):format(eff.power) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# enters a state of bloodlust." end,
	on_lose = function(self, err) return "#Target# calms down." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid)
	end,
}

newEffect{
	name = "ORC_TRIUMPH", image = "talents/skirmisher.png",
	desc = "Orcish Triumph",
	long_desc = function(self, eff) return ("你 的 胜 利 增 加 了 你 %d%%  全 体 伤 害 抗 性 。"):format(eff.resists) end,
	type = "mental",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { resists=10 },
	on_gain = function(self, err) return "#Target# roars triumphantly." end, -- Too spammy?
	on_lose = function(self, err) return "#Target# is no longer inspired." end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.resists})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "INTIMIDATED",
	desc = "Intimidated",
	long_desc = function(self, eff) return ("目 标 的 斗 志 受 到 削 弱， 降 低 攻 击 强 度、 精 神 强 度 和 法 术 强 度 %d 。"):format(eff.power) end,
	type = "mental",
	subtype = { fear=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target#'s morale has been lowered.", "+Intimidated" end,
	on_lose = function(self, err) return "#Target# has regained its confidence.", "-Intimidated" end,
	parameters = { power=1 },
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", -eff.power)
		eff.spellid = self:addTemporaryValue("combat_spellpower", -eff.power)
		eff.mindid = self:addTemporaryValue("combat_mindpower", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_mindpower", eff.mindid)
	end,
}

newEffect{
	name = "BRAINLOCKED",
	desc = "Brainlocked",
	long_desc = function(self, eff) return ("随 机 使 一 个 技 能 无 法 使 用。 该 状 态 下 所 有 技 能 停 止 冷 却。"):format() end,
	type = "mental",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return nil, "+Brainlocked" end,
	on_lose = function(self, err) return nil, "-Brainlocked" end,
	activate = function(self, eff)
		eff.tcdid = self:addTemporaryValue("no_talents_cooldown", 1)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		for i = 1, 1 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self.talents_cd[t.id] = 1
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("no_talents_cooldown", eff.tcdid)
	end,
}

newEffect{
	name = "FRANTIC_SUMMONING", image = "talents/frantic_summoning.png",
	desc = "Frantic Summoning",
	long_desc = function(self, eff) return ("降 低 召 唤 耗 时 %d%% 。"):format(eff.power) end,
	type = "mental",
	subtype = { summon=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# starts summoning at high speed.", "+Frantic Summoning" end,
	on_lose = function(self, err) return "#Target#'s frantic summoning ends.", "-Frantic Summoning" end,
	parameters = { power=20 },
	activate = function(self, eff)
		eff.failid = self:addTemporaryValue("no_equilibrium_summon_fail", 1)
		eff.speedid = self:addTemporaryValue("fast_summons", eff.power)

		-- Find a cooling down summon talent and enable it
		local list = {}
		for tid, dur in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t.is_summon then
				list[#list+1] = t
			end
		end
		if #list > 0 then
			local t = rng.table(list)
			self.talents_cd[t.id] = nil
			if self.onTalentCooledDown then self:onTalentCooledDown(t.id) end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("no_equilibrium_summon_fail", eff.failid)
		self:removeTemporaryValue("fast_summons", eff.speedid)
	end,
}

newEffect{
	name = "WILD_SUMMON", image = "talents/wild_summon.png",
	desc = "Wild Summon",
	long_desc = function(self, eff) return ("%d%% 概 率 提 升 召 唤 能 力。"):format(eff.chance) end,
	type = "mental",
	subtype = { summon=true },
	status = "beneficial",
	parameters = { chance=100 },
	activate = function(self, eff)
		eff.tid = self:addTemporaryValue("wild_summon", eff.chance)
	end,
	on_timeout = function(self, eff)
		eff.chance = eff.chance or 100
		eff.chance = math.floor(eff.chance * 0.66)
		self:removeTemporaryValue("wild_summon", eff.tid)
		eff.tid = self:addTemporaryValue("wild_summon", eff.chance)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_summon", eff.tid)
	end,
}

newEffect{
	name = "LOBOTOMIZED", image = "talents/psychic_lobotomy.png",
	desc = "Lobotomized (confused)",
	long_desc = function(self, eff) return ("目 标 的 精 神 判 断 力 严 重 受 损， 每 回 合 (%d%% 概 率) 随 机 动 作 并 降 低 灵 巧 %d 。"):format(eff.confuse, eff.power/2) end,
	type = "mental",
	subtype = { confusion=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target# higher mental functions have been imparied.", "+Lobotomized" end,
	on_lose = function(self, err) return "#Target#'s regains its senses.", "-Lobotomized" end,
	parameters = { power=1, confuse=10, dam=1 },
	activate = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, {dam=eff.dam, alwaysHit=true})
		eff.confuse = math.floor(math.max(eff.confuse - (self:attr("confusion_immune") or 0) * 100, 10))
		eff.confuse = util.bound(eff.confuse, 0, 50) -- Confusion cap of 50%
		eff.tmpid = self:addTemporaryValue("confused", eff.confuse)
		eff.cid = self:addTemporaryValue("inc_stats", {[Stats.STAT_CUN]=-eff.power/2})
		if eff.power <= 0 then eff.dur = 0 end
		eff.particles = self:addParticles(engine.Particles.new("generic_power", 1, {rm=100, rM=125, gm=100, gM=125, bm=100, bM=125, am=200, aM=255}))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("confused", eff.tmpid)
		self:removeTemporaryValue("inc_stats", eff.cid)
		if eff.particles then self:removeParticles(eff.particles) end
		if self == game.player and self.updateMainShader then self:updateMainShader() end
	end,
}

newEffect{
	name = "PSIONIC_SHIELD", image = "talents/kinetic_shield.png",
	desc = "Psionic Shield",
	--display_desc = function(self, eff) return eff.kind:capitalize().." Psionic Shield" end,
	long_desc = function(self, eff) return ("减 少 受 到 的 %s 伤 害 %d 。"):format(eff.what, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=10, kind="kinetic" },
	activate = function(self, eff)
	if eff.kind == "kinetic" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.PHYSICAL] = eff.power,
				[DamageType.ACID] = eff.power,
				[DamageType.NATURE] = eff.power,
				[DamageType.TEMPORAL] = eff.power,
			})
			eff.what = "物理、自然、酸性、时空"
		elseif eff.kind == "thermal" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.FIRE] = eff.power, 
				[DamageType.COLD] = eff.power,
				[DamageType.LIGHT] = eff.power,
				[DamageType.ARCANE] = eff.power,
				})
			eff.what = "火焰、寒冷、光系、奥术"
		elseif eff.kind == "charged" then
			eff.sid = self:addTemporaryValue("flat_damage_armor", {
				[DamageType.LIGHTNING] = eff.power, 
				[DamageType.BLIGHT] = eff.power,
				[DamageType.MIND] = eff.power,
				[DamageType.DARKNESS] = eff.power,
				})
			eff.what = "闪电、枯萎、精神、黑暗"
		end
	end,
	deactivate = function(self, eff)
		if eff.sid then
			self:removeTemporaryValue("flat_damage_armor", eff.sid)
		end
	end,
}

newEffect{
	name = "CLEAR_MIND", image = "talents/mental_shielding.png",
	desc = "Clear Mind",
	long_desc = function(self, eff) return ("使 接 下 来 的 %d 种 负 面 精 神 BUFF 无 效。"):format(self.clear_mind_immune) end,
	type = "mental",
	subtype = { psionic=true, },
	status = "beneficial",
	parameters = { power=2 },
	activate = function(self, eff)
		self.clear_mind_immune = eff.power
		eff.particles = self:addParticles(engine.Particles.new("generic_power", 1, {rm=0, rM=0, gm=100, gM=180, bm=180, bM=255, am=200, aM=255}))
	end,
	deactivate = function(self, eff)
		self.clear_mind_immune = nil
		self:removeParticles(eff.particles)
	end,
}

newEffect{
	name = "RESONANCE_FIELD", image = "talents/resonance_field.png",
	desc = "Resonance Field",
	long_desc = function(self, eff) return ("目 标 被 超 能 领 域 包 围， 吸 收 50%% 所 有 伤 害（ 最 多 %d/%d ）。"):format(self.resonance_field_absorb, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A psychic field forms around #target#.", "+Resonance Shield" end,
	on_lose = function(self, err) return "The psychic field around #target# crumbles.", "-Resonance Shield" end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		self.resonance_field_absorb = eff.power
		eff.sid = self:addTemporaryValue("resonance_field", eff.power)
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1}, {type="shield", time_factor=-8000, llpow=1, aadjust=7, color={1, 1, 0}}))
		--	eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, color={1, 1, 0}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=1, b=0, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self.resonance_field_absorb = nil
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("resonance_field", eff.sid)
	end,
}

newEffect{
	name = "MIND_LINK_TARGET", image = "talents/mind_link.png",
	desc = "Mind Link",
	long_desc = function(self, eff) return ("目 标 遭 到 精 神 入 侵， 提 升 它 受 到 %s 的 精 神 伤 害 %d%% 。"):format(eff.src.name:capitalize(), eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "detrimental",
	parameters = {power = 1, range = 5},
	remove_on_clone = true, decrease = 0,
	on_gain = function(self, err) return "#Target#'s mind has been invaded!", "+Mind Link" end,
	on_lose = function(self, err) return "#Target# is free from the mental invasion.", "-Mind Link" end,
	on_timeout = function(self, eff)
		-- Remove the mind link when appropriate
		local p = eff.src:isTalentActive(eff.src.T_MIND_LINK)
		if not p or p.target ~= self or eff.src.dead or not game.level:hasEntity(eff.src) or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > eff.range then
			self:removeEffect(self.EFF_MIND_LINK_TARGET)
		end
	end,
}

newEffect{
	name = "FEEDBACK_LOOP", image = "talents/feedback_loop.png",
	desc = "Feedback Loop",
	long_desc = function(self, eff) return "目 标 吸 收 反 馈。" end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power = 1 },
	on_gain = function(self, err) return "#Target# is gaining feedback.", "+Feedback Loop" end,
	on_lose = function(self, err) return "#Target# is no longer gaining feedback.", "-Feedback Loop" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("ultrashield", 1, {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90, radius=0.2, density=15, life=28, instop=40}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "FOCUSED_WRATH", image = "talents/focused_wrath.png",
	desc = "Focused Wrath",
	long_desc = function(self, eff) return ("目 标 的 潜 意 识 集 中 在 %s 。"):format(eff.target.name:capitalize()) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power = 1 },
	on_gain = function(self, err) return "#Target#'s subconscious has been focused.", "+Focused Wrath" end,
	on_lose = function(self, err) return "#Target#'s subconscious has returned to normal.", "-Focused Wrath" end,
	on_timeout = function(self, eff)
		if not eff.target or eff.target.dead or not game.level:hasEntity(eff.target) then
			self:removeEffect(self.EFF_FOCUSED_WRATH)
		end
	end,
}

newEffect{
	name = "SLEEP", image = "talents/sleep.png",
	desc = "Sleep",
	long_desc = function(self, eff) return ("目 标 陷 入 沉 睡 无 法 动 作， 每 受 到 %d 伤 害 缩 短 1 回 合 持 续 时 间。"):format(eff.power) end,
	type = "mental",
	subtype = { sleep=true },
	status = "detrimental",
	parameters = { power=1, insomnia=1, waking=0, contagious=0 },
	on_gain = function(self, err) return "#Target# has been put to sleep.", "+Sleep" end,
	on_lose = function(self, err) return "#Target# is no longer sleeping.", "-Sleep" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		elseif eff.contagious > 0 and eff.dur > 1 then
			local t = eff.src:getTalentFromId(eff.src.T_SLEEP)
			t.doContagiousSleep(eff.src, self, eff, t)
		end
		if eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "SLUMBER", image = "talents/slumber.png",
	desc = "Slumber",
	long_desc = function(self, eff) return ("目 标 陷 入 沉 睡 无 法 动 作， 每 受 到 %d 伤 害 缩 短 1 回 合 持 续 时 间。"):format(eff.power) end,
	type = "mental",
	subtype = { sleep=true },
	status = "detrimental",
	parameters = { power=1, insomnia=1, waking=0 },
	on_gain = function(self, err) return "#Target# is in a deep sleep.", "+Slumber" end,
	on_lose = function(self, err) return "#Target# is no longer sleeping.", "-Slumber" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", time_factor=6000, aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		elseif eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "NIGHTMARE", image = "talents/nightmare.png",
	desc = "Nightmare",
	long_desc = function(self, eff) return ("目 标 陷 入 噩 梦， 每 回 合 遭 受 %0.2f 精 神 伤 害 并 无 法 活 动。 每 受 到 %d 伤 害 缩 短 1 回 合 持 续 时 间。"):format(eff.dam, eff.power) end,
	type = "mental",
	subtype = { nightmare=true, sleep=true },
	status = "detrimental",
	parameters = { power=1, dam=0, insomnia=1, waking=0},
	on_gain = function(self, err) return "#F53CBE##Target# is lost in a nightmare.", "+Nightmare" end,
	on_lose = function(self, err) return "#Target# is free from the nightmare.", "-Nightmare" end,
	on_timeout = function(self, eff)
		local dream_prison = false
		if eff.src and eff.src.isTalentActive and eff.src:isTalentActive(eff.src.T_DREAM_PRISON) then
			local t = eff.src:getTalentFromId(eff.src.T_DREAM_PRISON)
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.src:getTalentRange(t) then
				dream_prison = true
			end
		end
		if dream_prison then
			eff.dur = eff.dur + 1
			if not eff.particle then
				if core.shader.active(4) then
					eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield2", size_factor=1.25}, {type="shield", aadjust=5, color={0, 1, 1}}))
				else
					eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=0, g=1, b=1, a=1}))
				end
			end
		else
			-- Store the power for later
			local real_power = eff.temp_power or eff.power
			-- Temporarily spike the temp_power so the nightmare doesn't break it
			eff.temp_power = 10000
			DamageType:get(DamageType.DARKNESS).projector(eff.src or self, self.x, self.y, DamageType.DARKNESS, eff.dam)
			-- Set the power back to its baseline
			eff.temp_power = real_power
		end
		if eff.particle and not dream_prison then
			self:removeParticles(eff.particle)
		end
		-- Incriment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
	end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.sid)
		if not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.waking > 0 then
			local t = eff.src:getTalentFromId(self.T_RESTLESS_NIGHT)
			t.doRestlessNight(eff.src, self, eff.waking)
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "RESTLESS_NIGHT", image = "talents/restless_night.png",
	desc = "Restless Night",
	long_desc = function(self, eff) return ("不 安 的 睡 眠 造 成 虚 弱， 每 回 合 造 成 %0.2f 精 神 伤 害。"):format(eff.power) end,
	type = "mental",
	subtype = { psionic=true},
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# had a restless night.", "+Restless Night" end,
	on_lose = function(self, err) return "#Target# has recovered from poor sleep.", "-Restless Night" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.MIND).projector(eff.src or self, self.x, self.y, DamageType.MIND, eff.power)
	end,
}

newEffect{
	name = "INSOMNIA", image = "effects/insomnia.png",
	desc = "Insomnia",
	long_desc = function(self, eff) return ("目 标 清 醒 并 获 得 %d%% 沉 睡 效 果 抵 抗。 "):format(eff.cur_power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=0 },
	on_gain = function(self, err) return "#Target# is suffering from insomnia.", "+Insomnia" end,
	on_lose = function(self, err) return "#Target# is no longer suffering from insomnia.", "-Insomnia" end,
	on_merge = function(self, old_eff, new_eff)
		-- Add the durations on merge
		local dur = old_eff.dur + new_eff.dur
		old_eff.dur = math.min(10, dur)
		old_eff.cur_power = old_eff.power * old_eff.dur
		-- Need to remove and re-add the effect
		self:removeTemporaryValue("sleep_immune", old_eff.sid)
		old_eff.sid = self:addTemporaryValue("sleep_immune", old_eff.cur_power/100)
		return old_eff
	end,
	on_timeout = function(self, eff)
		-- Insomnia only ticks when we're awake
		if self:attr("sleep") and self:attr("sleep") > 0 then
			eff.dur = eff.dur + 1
		else
			-- Deincrement the power
			eff.cur_power = eff.power * eff.dur
			self:removeTemporaryValue("sleep_immune", eff.sid)
			eff.sid = self:addTemporaryValue("sleep_immune", eff.cur_power/100)
		end
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power * eff.dur
		eff.sid = self:addTemporaryValue("sleep_immune", eff.cur_power/100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep_immune", eff.sid)
	end,
}

newEffect{
	name = "SUNDER_MIND", image = "talents/sunder_mind.png",
	desc = "Sundered Mind",
	long_desc = function(self, eff) return ("目 标 的 精 神 能 力 被 削 弱， 精 神 豁 免 降 低 %d 。"):format(eff.cur_power or eff.power) end,
	type = "mental",
	subtype = { psionic=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target#'s mental functions have been impaired.", "+Sundered Mind" end,
	on_lose = function(self, err) return "#Target# regains its senses.", "-Sundered Mind" end,
	parameters = { power=10 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_mentalresist", old_eff.sunder)
		old_eff.cur_power = old_eff.cur_power + new_eff.power
		old_eff.sunder = self:addTemporaryValue("combat_mentalresist", -old_eff.cur_power)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.sunder = self:addTemporaryValue("combat_mentalresist", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.sunder)
	end,
}

newEffect{
	name = "BROKEN_DREAM", image = "effects/broken_dream.png",
	desc = "Broken Dream",
	long_desc = function(self, eff) return ("目 标 的 梦 境 被 破 坏， 降 低 精 神 豁 免 %d 并 降 低 施 法 成 功 率 %d%% 。"):format(eff.power, eff.fail) end,
	type = "mental",
	subtype = { psionic=true, morale=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target#'s dreams have been broken.", "+Broken Dream" end,
	on_lose = function(self, err) return "#Target# regains hope.", "-Broken Dream" end,
	parameters = { power=10, fail=10 },
	activate = function(self, eff)
		eff.silence = self:addTemporaryValue("spell_failure", eff.fail)
		eff.sunder = self:addTemporaryValue("combat_mentalresist", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("spell_failure", eff.silence)
		self:removeTemporaryValue("combat_mentalresist", eff.sunder)
	end,
}

newEffect{
	name = "FORGE_SHIELD", image = "talents/block.png",
	desc = "Forge Shield",
	long_desc = function(self, eff)
		local e_string = ""
		if eff.number == 1 then
			e_string = DamageType.dam_def[next(eff.d_types)].name
		else
			local list = table.keys(eff.d_types)
			for i = 1, #list do
				list[i] = DamageType.dam_def[list[i]].name
			end
			e_string = table.concat(list, ", ")
		end
		local function tchelper(first, rest)
		  return first:upper()..rest:lower()
		end
		return ("吸 收 %d 下 一 次 可 格 挡 的 伤 害， 当 前 格 挡 %s 。"):format(eff.power, e_string:gsub("(%a)([%w_']*)", tchelper))
	end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
		damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1}, {type="shield", time_factor=-8000, llpow=1, aadjust=7, color={1, 0.5, 0}}))
		else
			eff.particle = self:addParticles(Particles.new("generic_shield", 1, {r=1, g=0.5, b=0.0, a=1}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "HIDDEN_RESOURCES", image = "talents/hidden_resources.png",
	desc = "Hidden Resources",
	long_desc = function(self, eff) return "目 标 不 消 耗 任 何 能 量。" end,
	type = "mental",
	subtype = { willpower=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target#'s focuses.", "+Hidden Ressources" end,
	on_lose = function(self, err) return "#Target#'s loses some focus.", "-Hidden Ressources" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "force_talent_ignore_ressources", 1)
	end,
}

newEffect{
	name = "SPELL_FEEDBACK", image = "talents/spell_feedback.png",
	desc = "Spell Feedback",
	long_desc = function(self, eff) return ("目 标 有 %d%% 几 率 施 法 失 败。"):format(eff.power) end,
	type = "mental",
	subtype = { nature=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target# is surrounded by antimagic forces.", "+Spell Feedback" end,
	on_lose = function(self, err) return "#Target#'s antimagic forces vanishes.", "-Spell Feedback" end,
	parameters = { power=40 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "spell_failure", eff.power)
	end,
}

newEffect{
	name = "MIND_PARASITE", image = "talents/mind_parasite.png",
	desc = "Mind Parasite",
	long_desc = function(self, eff) return ("目 标 被 精 神 寄 生 虫 感 染 ， 每 次 使 用 技 能 时 有 %d%% 几 率 让 %d 个 随 机 技 能 进 入 %d 回 合 的 冷 却."):format(eff.chance, eff.nb, eff.turns) end,
	type = "mental",
	subtype = { nature=true, mind=true },
	status = "detrimental",
	on_gain = function(self, err) return "#Target# is infected with a mind parasite.", "+Mind Parasite" end,
	on_lose = function(self, err) return "#Target# is free from the mind parasite.", "-Mind Parasite" end,
	parameters = { chance=40, nb=1, turns=2 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use", eff.chance)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use_nb", eff.nb)
		self:effectTemporaryValue(eff, "random_talent_cooldown_on_use_turns", eff.turns)
	end,
}

newEffect{
	name = "MINDLASH", image = "talents/mindlash.png",
	desc = "Mindlash",
	long_desc = function(self, eff) return ("重 复 使 用 精 神 鞭 笞 十 分 消 耗 能 量 ， 会 增 加 每 次 的 超 能 力 值 消 耗 （ 现 在 %d%%）"):format(eff.power * 100) end,
	type = "mental",
	subtype = { mind=true },
	status = "detrimental",
	parameters = {  },
	on_merge = function(self, old_eff, new_eff)
		new_eff.power = old_eff.power + 1
		return new_eff
	end,
	activate = function(self, eff)
		eff.power = 2
	end,
}

newEffect{
	name = "SHADOW_EMPATHY", image = "talents/shadow_empathy.png",
	desc = "Shadow Empathy",
	long_desc = function(self, eff) return ("%d%% 的 总 伤 害 被 转 移 至 随 机 某 个 阴 影。"):format(eff.power) end,
	type = "mental",
	subtype = { mind=true, shield=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "shadow_empathy", eff.power)
		eff.particle = self:addParticles(Particles.new("darkness_power", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "SHADOW_DECOY", image = "talents/shadow_decoy.png",
	desc = "Shadow Decoy",
	long_desc = function(self, eff) return ("随 机 的 一 个 阴 影 将 吸 收 一 次 你 受 到 的 致 命 伤 害 ,   并 给 你 带 来 一 个 %d 的 临 时 盾."):format(eff.power) end,
	type = "mental",
	subtype = { mind=true, shield=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.power)
		self:effectParticles(eff, {type="darkness_power"})
		if core.shader.active() then
			self:effectParticles(eff, {type="circle", args={shader=true, oversize=1.5, a=225, appear=8, speed=0, img="shadow_decoy_aura", base_rot=0, radius=0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}



newEffect{
	name = "CRYSTAL_BUFF", image = "talents/stone_touch.png",
	desc = "Crystal Resonance",
	--Might consider adding the gem properties to this tooltip
	long_desc = function(self, eff) return ("宝 石 的 能 量 与 你 产 生 共 振。") end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# glints with a crystaline aura", "+Crystal Resonance" end,
	on_lose = function(self, err) return "#Target# is no longer glinting.", "-Crystal Resonance" end,
	activate = function(self, eff)
		for a, b in pairs(eff.effects) do
			self:effectTemporaryValue(eff, a, b)
		end
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "WEAPON_WARDING", image = "talents/warding_weapon.png",
	desc = "Weapon Warding",
	long_desc = function(self, eff) return ("目 标 正 使 用 念 力 武 器 进 行 防 御 ， 能 格 挡 下 一 次 近 战 攻 击 并 自 动 反 击。")end,
	type = "mental",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	do_block = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed") then return end

		self:removeEffect(self.EFF_WEAPON_WARDING)
		if self:getInven(self.INVEN_PSIONIC_FOCUS) then
			local t = self:getTalentFromId(self.T_WARDING_WEAPON)
			for i, o in ipairs(self:getInven(self.INVEN_PSIONIC_FOCUS)) do
				if o.combat and not o.archery then
					self:logCombat(target, "#CRIMSON##Source# 格挡了 #Target# 的攻击，并用念力武器进行反击!#LAST#", string.his_her(self))
					self:attackTargetWith(target, o.combat, nil, t.getWeaponDamage(self, t))
				end
			end
			if self:getTalentLevelRaw(t) >= 3 and target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, 3, {apply_power=self:combatMindpower()})
			end
		end
		return true
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "THOUGHTSENSE", image = "talents/thought_sense.png",
	desc = "Thought Sense",
	long_desc = function(self, eff) return ("探 测 周 围 的 思 维 ， 揭 示 半 径 %d 以 内 的 怪 物 位 置 ， 并 增 加 你 的 闪 避 %d 点 。"):format(eff.range, eff.def) end,
	type = "mental",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "detect_range", eff.range)
		self:effectTemporaryValue(eff, "detect_actor", 1)
		self:effectTemporaryValue(eff, "combat_def", eff.def)
		game.level.map.changed = true
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.5, a=225, appear=8, speed=0, img="thoughtsense", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
}

newEffect{
	name = "STATIC_CHARGE", image = "talents/static_net.png",
	desc = "Static Charge",
	long_desc = function(self, eff) return ("你 使 用 了 静 电 充 能 ， 下 一 次 近 战 攻 击 将 造  成 额 外 %d 点 闪 电 伤 害 。"):format(eff.power) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.power = new_eff.power + old_eff.power
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("hand1", true) if h1x then eff.particle1 = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.3, a=185, appear=8, speed=0, img="transcend_electro", base_rot=0, radius=0, x=h1x, y=h1y})) end
			local h2x, h2y = self:attachementSpot("hand2", true) if h2x then eff.particle2 = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.3, a=185, appear=8, speed=0, img="transcend_electro", base_rot=0, radius=0, x=h2x, y=h2y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle1 then self:removeParticles(eff.particle1) end
		if eff.particle2 then self:removeParticles(eff.particle2) end
	end,
}

newEffect{
	name = "HEART_STARTED", image = "talents/heartstart.png",
	desc = "Heart Started",
	long_desc = function(self, eff) return ("一 股 超 能 力 正 维 持 你 的 心 脏 跳 动 ， 令 你 能 在 %+d 生 命 下 存 活。"):format(-eff.power) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "TRANSCENDENT_TELEKINESIS", image = "talents/transcendent_telekinesis.png",
	desc = "Transcendent Telekinesis",
	long_desc = function(self, eff) return ("你 的 动 能 操 控 能 力 超 越 了 极 限，增 加 %d%% 物 理 伤 害 与 %d%% 物 理 抗 性 穿 透 ， 同 时 你 的 动 能 效 果 得 到 强 化。"):format(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { physical=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.PHYSICAL]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.PHYSICAL]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_tele", radius=0}))
		self:callTalent(self.T_KINETIC_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_KINETIC_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "TRANSCENDENT_PYROKINESIS", image = "talents/transcendent_pyrokinesis.png",
	desc = "Transcendent Pyrokinesis",
	long_desc = function(self, eff) return ("你 的 热 能 操 控 能 力 超 越 了 极 限，增 加 %d%% 火 焰 /寒 冷 伤 害 与 %d%% 火 焰 / 寒 冷 抗 性 穿 透 ， 同 时 你 的 热 能 效 果 得 到 强 化。"):format(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { fire=true, cold=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0, weaken = 0},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=eff.power, [DamageType.COLD]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.FIRE]=eff.penetration, [DamageType.COLD]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_pyro", radius=0}))
		self:callTalent(self.T_THERMAL_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_THERMAL_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "TRANSCENDENT_ELECTROKINESIS", image = "talents/transcendent_electrokinesis.png",
	desc = "Transcendent Electrokinesis",
	long_desc = function(self, eff) return ("你 的 电 能 操 控 能 力 超 越 了 极 限，增 加 %d%% 闪 电 伤 害 与 %d%% 闪 电 抗 性 穿 透 ， 同 时 你 的 电 能 效 果 得 到 强 化。"):format(eff.power, eff.penetration) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = { power=10, penetration = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=eff.power})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.LIGHTNING]=eff.penetration})
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, oversize=1.7, a=155, appear=8, speed=0, img="transcend_electro", radius=0}))
		self:callTalent(self.T_CHARGED_SHIELD, "adjust_shield_gfx", true)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:callTalent(self.T_CHARGED_SHIELD, "adjust_shield_gfx", false)
	end,
}

newEffect{
	name = "PSI_DAMAGE_SHIELD", image = "talents/barrier.png",
	desc = "Psionic Damage Shield",
	long_desc = function(self, eff) return ("目 标 被 超 能 力 护 盾 保 护 ， 吸 收 %d/%d 伤 害 直 至 破 碎。"):format(self.damage_shield_absorb, eff.power) end,
	type = "mental",
	subtype = { psionic=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A psionic shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The psionic shield around #target# crumbles.", "-Shield" end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_DAMAGE_SHIELD)
		eff.tmpid = self:addTemporaryValue("damage_shield", eff.power)
		if eff.reflect then eff.refid = self:addTemporaryValue("damage_shield_reflect", eff.reflect) end
		--- Warning there can be only one time shield active at once for an actor
		self.damage_shield_absorb = eff.power
		self.damage_shield_absorb_max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {a=eff.shield_transparency or 1, size_factor=1.4, img="shield3"}, {type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor=colors.hex1alpha"9fe836a0", auraColor=colors.hex1alpha"36bce8da"}))
		else
			eff.particle = self:addParticles(Particles.new("damage_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("damage_shield", eff.tmpid)
		if eff.refid then self:removeTemporaryValue("damage_shield_reflect", eff.refid) end
		self.damage_shield_absorb = nil
		self.damage_shield_absorb_max = nil
	end,
}

newEffect{
	name = "UNSEEN_FORCE", desc = "Unseen Force",
	image="talents/unseen_force.png",
	long_desc = function(self, eff)
		local hits = (eff.extrahit > 0 and "从 "..eff.hits.." 到 "..(eff.hits + 1)) or ""..eff.hits
		return ("一 股 无 形 的 力 量 撞 击 着 这 个 生 物 周 围 5 码 内 的 %s 个 目 标 "..
		"每 回 合 造 成 %d 伤 害 并 击 退 %d 码 。"):format(hits, eff.damage, eff.knockback) end,
	type = "mental",
	subtype = {psionic=true},
	status = "beneficial",
	activate = function(self, eff)
		game.logSeen(self, "An unseen force begins to swirl around %s!", self.name)
		eff.particles = self:addParticles(Particles.new("force_area", 1, { radius = self:getTalentRange(self.T_UNSEEN_FORCE) }))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particles)
		game.logSeen(self, "The unseen force around %s subsides.", self.name)
	end,
	on_timeout = function(self, eff)
		local targets = {}
		local tmp = {}
		local grids = core.fov.circle_grids(self.x, self.y, 5, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, Map.ACTOR)
				if a and self:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
					targets[#targets+1] = a
				end
			end
		end

		if #targets > 0 then
			local hitCount = eff.hits
			if rng.percent(eff.extrahit) then hitCount = hitCount + 1 end

			local t = self:getTalentFromId(self.T_WILLFUL_STRIKE)
			-- Randomly take targets
			local sample = rng.tableSample(targets, hitCount)
			for _, target in ipairs(sample) do
				t.forceHit(self, t, target, target.x, target.y, eff.damage, eff.knockback, 7, 0.6, 10, tmp)
			end
		end
	end,
}

newEffect{
	name = "PSIONIC_MAELSTROM", image = "talents/psionic_maelstrom.png",
	desc = "Psionic Maelstrom",
	long_desc = function(self, eff) return ("这 个 生 物 站 在 强 大 的 灵 能 风 暴 中 心 。"):format() end,
	type = "mental",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	activate = function(self, eff)
		eff.dir = 0--rng.range(0, 7)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		local tg = {type="beam", range=4, selffire=false}
		local x, y
		if eff.kinetic then
			x = self.x+math.modf(4*math.sin(math.pi*eff.dir/4))
			y = self.y+math.modf(4*math.cos(math.pi*eff.dir/4))
			self:project(tg, x, y, engine.DamageType.PHYSICAL, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "matter_beam", {tx=x-self.x, ty=y-self.y})
		end
		if eff.charged then
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+4)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+4)/4))
			self:project(tg, x, y, engine.DamageType.LIGHTNING, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning_beam", {tx=x-self.x, ty=y-self.y}, {type="lightning"})
			else game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning_beam", {tx=x-self.x, ty=y-self.y})
			end
		end
		if eff.thermal then
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+2)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+2)/4))
			self:project(tg, x, y, engine.DamageType.FIRE, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "flamebeam", {tx=x-self.x, ty=y-self.y})
			x = self.x+math.modf(4*math.sin(math.pi*(eff.dir+6)/4))
			y = self.y+math.modf(4*math.cos(math.pi*(eff.dir+6)/4))
			self:project(tg, x, y, engine.DamageType.COLD, eff.dam, nil)
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "ice_beam", {tx=x-self.x, ty=y-self.y})
		end
		eff.dir = eff.dir+1
	end,
}

newEffect{
	name = "CAUGHT_LIGHTNING", image = "talents/transcendent_electrokinesis.png",
	desc = "Caught Lightning",
	long_desc = function(self, eff) return ("闪 电 捕 捉 器 捕 获 了 能 量 ，增 加 %d%% 闪 电 伤 害 与 %d 全 属 性 。"):format((eff.dur+1)*5, eff.dur+1) end,
	type = "mental",
	subtype = { lightning=true },
	status = "beneficial",
	parameters = {  },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.min(old_eff.dur + new_eff.dur, 10)
		return old_eff
	end,
	activate = function(self, eff)
		eff.lightning = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING]=eff.dur*5})
		eff.stats = self:addTemporaryValue("inc_stats", { 
			[Stats.STAT_STR] = eff.dur,
			[Stats.STAT_DEX] = eff.dur,
			[Stats.STAT_CON] = eff.dur,
			[Stats.STAT_MAG] = eff.dur,
			[Stats.STAT_WIL] = eff.dur,
			[Stats.STAT_CUN] = eff.dur,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.lightning)
		self:removeTemporaryValue("inc_stats", eff.stats)
	end,
	on_timeout = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.lightning)
		self:removeTemporaryValue("inc_stats", eff.stats)
		eff.lightning = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING]=eff.dur*5})
		eff.stats = self:addTemporaryValue("inc_stats", { 
			[Stats.STAT_STR] = eff.dur,
			[Stats.STAT_DEX] = eff.dur,
			[Stats.STAT_CON] = eff.dur,
			[Stats.STAT_MAG] = eff.dur,
			[Stats.STAT_WIL] = eff.dur,
			[Stats.STAT_CUN] = eff.dur,
		})
	end,
}

newEffect{
	name = "EXPOSE_WEAKNESS", image = "talents/expose_weakness.png",
	desc = "Exploiting Weaknesses",
	long_desc = function(self, eff)
		local bonuses = {}
		if eff.bonus_accuracy > 0 then table.insert(bonuses, ("have %+d accuracy"):format(eff.bonus_accuracy)) end
		if eff.bonus_power > 0 then table.insert(bonuses, ("deal %+0.1f damage"):format(eff.bonus_power)) end
		if eff.bonus_pen > 0 then table.insert(bonuses, ("have %+d%% resistance penetration"):format(eff.bonus_pen)) end
		if #bonuses > 0 then bonuses = table.concatNice(bonuses, ", ", " and ") else bonuses = "are not affected" end
		return ("You are focused on weaknesses you have found in your target's defences.  Your melee attacks against %s %s."):format(eff.target and eff.target.name:capitalize() or "noone", bonuses)
	end,
	type = "mental",
	subtype = { tactical=true},
	status = "beneficial",
	parameters = {power=10, hardiness=10, penetration=10, accuracy=0, find_weakness=true},
	on_gain = function(self, eff) return ("#Target# #GOLD#focuses on weaknesses#LAST# in %s's defenses!"):format(eff.target and eff.target.name:capitalize() or self:his_her().." target"), "+Expose Weakness" end,
	on_lose = function(self, eff) return "#Target#'s attacks are less focused.", "-Expose Weakness" end,
	on_timeout = function(self, eff)
		eff.find_weakness = false
		if not eff.target or eff.target.dead or not game.level:hasEntity(eff.target) then
			self:removeEffect(eff.effect_id)
		end
	end,
	activate = function(self, eff)
		eff.bonus_power = 0
		eff.bonus_accuracy = 0
		eff.bonus_pen = 0
	end,
	deactivate = function(self, eff)
	end,
	-- pre attack: assign bonuses already set up  Note: This is post rescaleCombatStats (i.e. applied directly)
	callbackOMeleeAttackBonuses = function(self, eff, hd)
		if not eff.find_weakness then
			hd.atk = hd.atk + eff.bonus_accuracy
			hd.dam = hd.dam + eff.bonus_power
		end
	end,
	-- after attack, accumulate weakness bonuses (1 turn only) based on combat result
	callbackOnMeleeAttack = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam)
		if eff.find_weakness then -- compile bonuses
			if hitted then
				eff.bonus_power = eff.bonus_power + eff.power
				eff.bonus_pen = eff.bonus_pen + eff.penetration
			else -- missed, add accuracy
				eff.bonus_accuracy = eff.bonus_accuracy + eff.accuracy
			end
		end
	end,
}
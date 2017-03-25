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
local Combat = require "mod.class.interface.Combat"

newEffect{
	name = "FLASH_SHIELD", image = "talents/flash_of_the_blade.png",
	desc = "Protected by the Sun",
	long_desc = function(self, eff) return "阳 光 保 护 着 目 标。" end,
	type = "other",
	subtype = { },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# whirls around and a radiant shield surrounds them!", "+Divine Shield" end,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "cancel_damage_chance", 100)
	end,
	deactivate = function(self, eff)

	end,
}

-- type other because this is a core defensive mechanic in debuff form, it should not interact with saves
newEffect{
	name = "ABSORPTION_STRIKE", image = "talents/absorption_strike.png",
	desc = "Absorption Strike",
	long_desc = function(self, eff) return ("目 标 的 光 明 被 吸 收 了 ， 减 少 光 系 抗 性 %d%% 和 伤 害 %d%%。"):format(eff.power, eff.numb) end,
	type = "other",
	subtype = { sun=true, },
	status = "detrimental",
	parameters = { power = 10, numb = 1 },
	on_gain = function(self, err) return "#Target# is drained from light!", "+Absorption Strike" end,
	on_lose = function(self, err) return "#Target#'s light is back.", "-Absorption Strike" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHT]=-eff.power})
		self:effectTemporaryValue(eff, "numbed", eff.numb)
	end,
}

-- Design:  Temporary immobility in exchange for a large stat buff.
newEffect{
	name = "TREE_OF_LIFE", image = "shockbolt/object/artifact/tree_of_life.png",
	desc = "You have taken root!",
	long_desc = function(self, eff) return "你 扎 根 了 ， 增 加 生 命 ， 护 甲 和 硬 度 ， 但 不 能 移 动 。" end,
	type = "other",
	subtype = { nature=true },
	--status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#LIGHT_BLUE##Target# takes root.", "+Pinned" end,
	on_lose = function(self, err) return "#LIGHT_BLUE##Target# is no longer a badass tree.", "-Pinned" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
		self:effectTemporaryValue(eff, "max_life", 300)
		self:effectTemporaryValue(eff, "combat_armor", 20)
		self:effectTemporaryValue(eff, "combat_armor_hardiness", 20)
		
		self.replace_display = mod.class.Actor.new{
			image="invis.png", 
			add_mos = {{image = "npc/giant_treant_wrathroot.png", 
			display_y = -1, 
			display_h = 2}},
        }
		
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

	end,
	deactivate = function(self, eff)
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "INFUSION_COOLDOWN", image = "effects/infusion_cooldown.png",
	desc = "Infusion Saturation",
	long_desc = function(self, eff) return ("你 使 用 纹 身 的 次 数 越 多， 纹 身 冷 却 时 间 越 长 (+%d 冷 却 时 间 )。"):format(eff.power) end,
	type = "other",
	subtype = { infusion=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "RUNE_COOLDOWN", image = "effects/rune_cooldown.png",
	desc = "Runic Saturation",
	long_desc = function(self, eff) return ("你 使 用 符 文 的 次 数 越 多， 符 文 冷 却 时 间 越 长 (+%d 冷 却 时 间 )。"):format(eff.power) end,
	type = "other",
	subtype = { rune=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "TAINT_COOLDOWN", image = "effects/tainted_cooldown.png",
	desc = "Tainted",
	long_desc = function(self, eff) return ("你 使 用 堕 落 印 记 的 次 数 越 多， 堕 落 印 记 的 冷 却 时 间 越 长 (+%d 冷 却 时 间 )。"):format(eff.power) end,
	type = "other",
	subtype = { taint=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { power=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		return old_eff
	end,
}

newEffect{
	name = "TIME_PRISON", image = "talents/time_prison.png",
	desc = "Time Prison",
	long_desc = function(self, eff) return "目 标 被 移 出 时 间 线， 不 能 行 动 也 不 能 受 到 伤 害， 该 生 物 的 时 间 停 止。" end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	tick_on_timeless = true,
	parameters = {},
	on_gain = function(self, err) return "#Target# is removed from time!", "+Out of Time" end,
	on_lose = function(self, err) return "#Target# is returned to normal time.", "-Out of Time" end,
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("invulnerable", 1)
		eff.sid = self:addTemporaryValue("time_prison", 1)
		eff.tid = self:addTemporaryValue("no_timeflow", 1)
		eff.imid = self:addTemporaryValue("status_effect_immune", 1)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="arcanegeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=3000, noup=2.0}))
			eff.particle1.toback = true
			eff.particle2 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="arcanegeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=3000, noup=1.0}))
		else
			eff.particle1 = self:addParticles(Particles.new("time_prison", 1))
		end
		self.energy.value = 0
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.iid)
		self:removeTemporaryValue("time_prison", eff.sid)
		self:removeTemporaryValue("no_timeflow", eff.tid)
		self:removeTemporaryValue("status_effect_immune", eff.imid)
		if eff.particle1 then self:removeParticles(eff.particle1) end
		if eff.particle2 then self:removeParticles(eff.particle2) end
	end,
}

newEffect{
	name = "TIME_SHIELD", image = "talents/time_shield.png",
	desc = "Time Shield",
	long_desc = function(self, eff) return ("目 标 被 一 层 扭 曲 时 空 的 护 盾 所 包 围， 吸 收 %d/%d 伤 害 并 将 伤 害 向 后 推 移。 当 激 活 时， 所 有 新 获 得 的 状 态 持 续 时 间 都 会 减 少 %d%%。"):format(self.time_shield_absorb, eff.power, eff.time_reducer) end,
	type = "other",
	subtype = { time=true, shield=true },
	status = "beneficial",
	parameters = { power=10, dot_dur=5, time_reducer=20 },
	on_gain = function(self, err) return "The very fabric of time alters around #target#.", "+Time Shield" end,
	on_lose = function(self, err) return "The fabric of time around #target# stabilizes to normal.", "-Time Shield" end,
	on_aegis = function(self, eff, aegis)
		self.time_shield_absorb = self.time_shield_absorb + eff.power * aegis / 100
		if core.shader.active(4) then
			self:removeParticles(eff.particle)
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1.2, scrollingSpeed=-2, time_factor=4000, bubbleColor={1, 1, 0.3, 1.0}, auraColor={1, 0.8, 0.2, 1}}))
		end		
	end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		if self:attr("shield_factor") then eff.power = eff.power * (100 + self:attr("shield_factor")) / 100 end
		if self:attr("shield_dur") then eff.dur = eff.dur + self:attr("shield_dur") end
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.time_reducer)
		eff.tmpid = self:addTemporaryValue("time_shield", eff.power)
		--- Warning there can be only one time shield active at once for an actor
		self.time_shield_absorb = eff.power
		self.time_shield_absorb_max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield3"}, {type="shield", shieldIntensity=0.1, horizontalScrollingSpeed=-0.2, verticalScrollingSpeed=-1, time_factor=2000, color={1, 1, 0.3}}))
		else
			eff.particle = self:addParticles(Particles.new("time_shield_bubble", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", eff.durid)

		self:removeParticles(eff.particle)

		-- Time shield ends, setup a restoration field if needed
		if eff.power - self.time_shield_absorb > 0 then
			local val = (eff.power - self.time_shield_absorb) / eff.dot_dur / 2
			if self:attr("shield_factor") then val = val * (100 + self:attr("shield_factor")) / 100 end
			print("Time shield restoration field", eff.power - self.time_shield_absorb, val)
			self:setEffect(self.EFF_TIME_DOT, eff.dot_dur, {power=val})
		end

		self:removeTemporaryValue("time_shield", eff.tmpid)
		self.time_shield_absorb = nil
		self.time_shield_absorb_max = 0
	end,
}

newEffect{
	name = "TIME_DOT",
	desc = "Temporal Restoration Field",
	long_desc = function(self, eff) return ("时 间 的 扭 曲 制 造 了 一 个 能 量 场， 每 回 合 治 疗 目 标 %d 点."):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "The powerful time-altering energies generate a restoration field on #target#.", "+时间储能" end,
	on_lose = function(self, err) return "The fabric of time around #target# returns to normal.", "-时间储能" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("time_shield", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		self:heal(eff.power, eff)
	end,
}

newEffect{
	name = "GOLEM_OFS",
	desc = "Golem out of sight",
	long_desc = function(self, eff) return "傀 儡 在 炼 金 术 视 线 以 外， 你 将 失 去 对 它 的 控 制！" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#LIGHT_RED##Target# is out of sight of its master; direct control will break!", "+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#You lost sight of your golem for too long; direct control is broken!")
				game.player:runStop("golem out of sight")
				game.player:restStop("golem out of sight")
				game.party:setPlayer(self.summoner)
			end)
		end
	end,
}

newEffect{
	name = "AMBUSCADE_OFS", image = "talents/ambuscade.png",
	desc = "Shadow out of sight",
	long_desc = function(self, eff) return "阴 影 在 视 线 以 外， 你 将 失 去 对 它 的 控 制！" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#LIGHT_RED##Target# is out of sight of its master; direct control will break!", "+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#你 视 野 内 失 去 阴 影 的 痕 迹 过 久，它 消 失 了!")
				game.player:runStop("shadow out of sight")
				game.player:restStop("shadow out of sight")
				game.party:setPlayer(self.summoner)
			end)
		end
	end,
}

newEffect{
	name = "HUSK_OFS", image = "talents/animus_purge.png",
	desc = "Husk out of sight",
	long_desc = function(self, eff) return "傀 儡 在 视 线 以 外， 你 将 失 去 对 它 的 控 制！" end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#LIGHT_RED##Target# is out of sight of its master; direct control will break!", "+Out of sight" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		if game.player ~= self then return true end

		if eff.dur <= 1 then
			game:onTickEnd(function()
				game.logPlayer(self, "#LIGHT_RED#你 视 野 内 失 去 傀 儡 的 痕 迹 过 久，它 消 失 了!")
				game.player:runStop("husk out of sight")
				game.player:restStop("husk out of sight")
				game.party:setPlayer(self.summoner)
				self:die(self)
			end)
		end
	end,
}

newEffect{
	name = "CONTINUUM_DESTABILIZATION",
	desc = "Continuum Destabilization",
	long_desc = function(self, eff) return ("目 标 受 时 空 操 纵 的 影 响， 提 升 抵 抗 (+%d)。"):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# looks a little pale around the edges.", "+Destabilized" end,
	on_lose = function(self, err) return "#Target# is firmly planted in reality.", "-Destabilized" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the continuum_destabilization
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- Need to remove and re-add the continuum_destabilization
		self:removeTemporaryValue("continuum_destabilization", old_eff.effid)
		old_eff.effid = self:addTemporaryValue("continuum_destabilization", old_eff.power)
		return old_eff
	end,
	activate = function(self, eff)
		eff.effid = self:addTemporaryValue("continuum_destabilization", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("continuum_destabilization", eff.effid)
	end,
}

newEffect{
	name = "SUMMON_DESTABILIZATION",
	desc = "Summoning Destabilization",
	long_desc = function(self, eff) return ("目 标 召 唤 的 生 物 越 多， 施 放 召 唤 技 能 所 需 时 间 越 长 (+%d turns)。"):format(eff.power) end,
	type = "other", -- Type "other" so that nothing can dispel it
	subtype = { miscellaneous=true },
	status = "detrimental",
	parameters = { power=10 },
	no_stop_enter_worlmap = true,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the destabilizations
		old_eff.dur = new_eff.dur
		old_eff.power = old_eff.power + new_eff.power
		-- Need to remove and re-add the talents CD
		self:removeTemporaryValue("talent_cd_reduction", old_eff.effid)
		old_eff.effid = self:addTemporaryValue("talent_cd_reduction", { [self.T_SUMMON] = -old_eff.power })
		return old_eff
	end,
	activate = function(self, eff)
		eff.effid = self:addTemporaryValue("talent_cd_reduction", { [self.T_SUMMON] = -eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_cd_reduction", eff.effid)
	end,
}

newEffect{
	name = "DAMAGE_SMEARING", image = "talents/damage_smearing.png",
	desc = "Damage Smearing",
	long_desc = function(self, eff) return ("过 去 受 到 的 伤 害 被 转 化 为 每 回 合 %0.2f 时 空 伤 害 。"):format(eff.dam) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#Target# is taking damage received in the past!", "+Smeared" end,
	on_lose = function(self, err) return "#Target# stops taking damage received in the past.", "-Smeared" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.dam * old_eff.dur
		local newdam = new_eff.dam * new_eff.dur
		new_eff.dam = (olddam + newdam) / new_eff.dur
		return new_eff
	end,
	on_timeout = function(self, eff)
		local dead, val = self:takeHit(eff.dam, self, {special_death_msg="was smeared across all space and time"})

		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):format(DamageType:get(DamageType.TEMPORAL).text_color or "#aaaaaa#", math.ceil(val), DamageType:get(DamageType.TEMPORAL).name), false)
	end,
}

newEffect{
	name = "SEE_THREADS", image = "talents/see_the_threads.png",
	desc = "See the Threads",
	long_desc = function(self, eff) return ("你 可 以 从 三 条 时 间 线 中 选 择 一 条 进 入。 ( 当 前 时 间 线 : %d)。"):format(eff.thread) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10, defense=0, crits=0 },
	remove_on_clone = true,
	activate = function(self, eff)
		eff.thread = 1
		eff.max_dur = eff.dur
		game:onTickEnd(function()
			game:chronoClone("see_threads_base")
		end)
		
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crits)
		self:effectTemporaryValue(eff, "combat_def", eff.defense)
	end,
	deactivate = function(self, eff)
		-- clone protection
		if self ~= game.player then
			return
		end
		
		game:onTickEnd(function()

			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#The see the threads spell fizzles and cancels, leaving you in this timeline.")
				return
			end

			if eff.thread < 3 then
				local worlds = game._chronoworlds

				-- Clone but not the subworlds
				game._chronoworlds = nil
				local clone = game:chronoClone()

				-- Restore the base world and resave it
				game._chronoworlds = worlds
				game:chronoRestore("see_threads_base", true)

				-- Setup next thread
				local eff = game.player:hasEffect(game.player.EFF_SEE_THREADS)
				eff.thread = eff.thread + 1
				game.logPlayer(game.player, "#LIGHT_BLUE#You unfold the space time continuum to the start of the time threads!")

				game._chronoworlds = worlds
				game:chronoClone("see_threads_base")

				-- Add the previous thread
				game._chronoworlds["see_threads_"..(eff.thread-1)] = clone
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "rewrite_universe")
				return
			else
				game._chronoworlds.see_threads_base = nil
				local chat = Chat.new("chronomancy-see-threads", {name="See the Threads"}, self, {turns=eff.max_dur})
				chat:invoke()
			end
		end)
	end,
}

newEffect{
	name = "IMMINENT_PARADOX_CLONE",
	desc = "Imminent Paradox Clone",
	long_desc = function(self, eff) return "效 果 结 束 时， 你 将 被 传 送 回 过 去。" end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { power=10 },
	activate = function(self, eff)
			game:onTickEnd(function()
			game:chronoClone("paradox_past")
		end)
	end,
	deactivate = function(self, eff)
		local t = self:getTalentFromId(self.T_PARADOX_CLONE)
		local base = t.getDuration(self, t) - 2
		game:onTickEnd(function()
			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#You've altered your destiny and will not be pulled into the past.")
				return
			end

			local worlds = game._chronoworlds
			-- save the players health so we can reload it
			local oldplayer = game.player

			-- Clone but not the subworlds
			game._chronoworlds = nil
			local clone = game:chronoClone()
			game._chronoworlds = worlds

			-- Move back in time, but keep the paradox_future world stored
			game:chronoRestore("paradox_past", true)
			game._chronoworlds = game._chronoworlds or {}
			game._chronoworlds["paradox_future"] = clone
			game.logPlayer(self, "#LIGHT_BLUE#You've been pulled into the past!")
			-- pass health and resources into the new timeline
			game.player.life = oldplayer.life
			for i, r in ipairs(game.player.resources_def) do
				game.player[r.short_name] = oldplayer[r.short_name]
			end

			-- Hack to remove the IMMINENT_PARADOX_CLONE effect in the past
			-- Note that we have to use game.player now since self refers to self from the future!
			game.player.tmp[self.EFF_IMMINENT_PARADOX_CLONE] = nil

			-- Setup the return effect
			game.player:setEffect(self.EFF_PARADOX_CLONE, base, {})
		end)
	end,
}

newEffect{
	name = "PARADOX_CLONE", image = "talents/paradox_clone.png",
	desc = "Paradox Clone",
	long_desc = function(self, eff) return "你 被 传 送 回 过 去。" end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { power=10 },
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		-- save the players rescources so we can reload it
		local oldplayer = game.player
		game:onTickEnd(function()
			game:chronoRestore("paradox_future")
			-- Reload the player's health and resources
			game.logPlayer(game.player, "#LIGHT_BLUE#You've been returned to the present!")
			game.player.life = oldplayer.life
			for i, r in ipairs(game.player.resources_def) do
				game.player[r.short_name] = oldplayer[r.short_name]
			end
		end)
	end,
}

newEffect{
	name = "MILITANT_MIND", image = "talents/militant_mind.png",
	desc = "Militant Mind",
	long_desc = function(self, eff) return ("提 高 你 %d 点 物 理 强 度、 物 理 豁 免、 法 术 强 度、 法 术 豁 免、 精 神 强 度 和 精 神 豁 免。"):format(eff.power) end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", eff.power)
		eff.spellid = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.mindid = self:addTemporaryValue("combat_mindpower", eff.power)
		eff.presid = self:addTemporaryValue("combat_physresist", eff.power)
		eff.sresid = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.mresid = self:addTemporaryValue("combat_mentalresist", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_mindpower", eff.mindid)
		self:removeTemporaryValue("combat_physresist", eff.presid)
		self:removeTemporaryValue("combat_spellresist", eff.sresid)
		self:removeTemporaryValue("combat_mentalresist", eff.mresid)
	end,
}

newEffect{
	name = "SEVER_LIFELINE", image = "talents/sever_lifeline.png",
	desc = "Sever Lifeline",
	long_desc = function(self, eff) return ("目 标 的 生 命 线 被 切 断， 效 果 结 束 时 对 目 标 造 成 %0.2f 时 空 伤 害。"):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = {power=10000},
	on_gain = function(self, err) return "#Target#'s lifeline is being severed!", "+Sever Lifeline" end,
	deactivate = function(self, eff)
		if not eff.src or eff.src.dead then return end
		if not eff.src:hasLOS(self.x, self.y) then return end
		if eff.dur >= 1 then return end
		DamageType:get(DamageType.TEMPORAL).projector(eff.src, self.x, self.y, DamageType.TEMPORAL, eff.power)
	end,
}

newEffect{
	name = "FADE_FROM_TIME", image = "talents/fade_from_time.png",
	desc = "Fade From Time",
	long_desc = function(self, eff) return ("目 标 暂 时 被 从 时 间 线 中 移 除， 造 成 的 伤 害 减 少 %d%% ， 减 少 受 到 伤 害 %d%% ， 并 减 少 %d%% 回 合 所 有 不 良 效 果 持 续 时 间。"):
	format(math.min(20,eff.dur * 2 + 2), eff.cur_power or eff.power, eff.cur_dur or eff.durred) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 ,durred = 15 },
	on_gain = function(self, err) return "#Target# has partially removed itself from the timeline.", "+Fade From Time" end,
	on_lose = function(self, err) return "#Target# has returned fully to the timeline.", "-Fade From Time" end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("inc_damage", old_eff.dmgid)
		self:removeTemporaryValue("resists", old_eff.rstid)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", old_eff.durid)		
		old_eff.cur_power = (new_eff.power)
		old_eff.cur_dur = new_eff.durred
		old_eff.dmgid = self:addTemporaryValue("inc_damage", {all = - old_eff.dur * 2})
		old_eff.rstid = self:addTemporaryValue("resists", {all = old_eff.cur_power})
		old_eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", old_eff.cur_dur)
		old_eff.dur = old_eff.dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		local current = eff.power * eff.dur/10
		local currentdur = eff.durred * eff.dur/10
		self:setEffect(self.EFF_FADE_FROM_TIME, 1, {power = current, durred=currentdur})
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.rstid = self:addTemporaryValue("resists", { all = eff.power})
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.durred)
		eff.dmgid = self:addTemporaryValue("inc_damage", {all = -20})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", eff.durid)
		self:removeTemporaryValue("resists", eff.rstid)
		self:removeTemporaryValue("inc_damage", eff.dmgid)
	end,
	}

newEffect{
	name = "SHADOW_VEIL", image = "talents/shadow_veil.png",
	desc = "Shadow Veil",
	long_desc = function(self, eff) return ("你 融 入 暗 影 并 被 其 支 配， 当 你 笼 罩 在 阴 影 里 时 你 对 所 有 状 态 免 疫， 并 减 少 %d%% 所 受 伤 害， 每 回 合 你 可 以 闪 到 1 个 附 近 的 敌 人 身 边 (半 径 %d)， 对 其 造 成 %d%% 暗 影 武 器 伤 害。 当 此 技 能 激 活 时 除 非 死 亡 否 则 无 法 被 打 断， 且 你 无 法 控 制 你 的 角 色。"):format(eff.res, eff.range, eff.dam * 100) end,
	type = "other",
	subtype = { darkness=true },
	status = "beneficial",
	parameters = { res=10, dam=1.5, range=5},
	on_gain = function(self, err) return "#Target# is covered in a veil of shadows!", "+Assail" end,
	on_lose = function(self, err) return "#Target# is no longer covered by shadows.", "-Assail" end,
	activate = function(self, eff)
		eff.sefid = self:addTemporaryValue("negative_status_effect_immune", 1)
		eff.resid = self:addTemporaryValue("resists", {all=eff.res})
	end,
	on_timeout = function(self, eff)
		local maxdist = self:callTalent(self.T_SHADOW_VEIL,"getBlinkRange")
		self.never_act = true
		repeat
			local acts = {}
			local act

			self:doFOV() -- update actors seen
			for i = 1, #self.fov.actors_dist do
				act = self.fov.actors_dist[i]
				if act and self:reactionToward(act) < 0 and not act.dead and self:isNear(act.x,act.y,maxdist) then
					local sx, sy = util.findFreeGrid(act.x, act.y, 1, true, {[engine.Map.ACTOR]=true})
					if sx then acts[#acts+1] = {act, sx, sy} end
				end
			end
			if #acts == 0 then self.never_act = nil return end

			act = rng.table(acts)
			self:move(act[2], act[3], true)
			game.level.map:particleEmitter(act[2], act[3], 1, "dark")
			self:attackTarget(act[1], DamageType.DARKNESS, eff.dam) -- Attack *and* use energy
		until self.energy.value < 0  -- keep blinking and attacking until out of energy (since on_timeout is only once per turn)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("negative_status_effect_immune", eff.sefid)
		self:removeTemporaryValue("resists", eff.resid)
		self.never_act = nil
	end,
}

newEffect{
	name = "ZERO_GRAVITY", image = "effects/zero_gravity.png",
	desc = "Zero Gravity",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("这 里 没 有 重 力， 你 漂 浮 在 空 中。 移 动 速 度 下 降 三 倍， 所 有 近 战 攻 击 或 射 击 有 一 定 几 率 击 退 目 标。 负 重 上 限 大 幅 增 加。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { spacetime=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	on_merge = function(self, old_eff, new_eff)
		return old_eff
	end,
	activate = function(self, eff)
		eff.encumb = self:addTemporaryValue("max_encumber", self:getMaxEncumbrance() * 20),
		self:checkEncumbrance()
		game.logPlayer(self, "#LIGHT_BLUE#You enter a zero gravity zone, beware!")
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("max_encumber", eff.encumb)
		self:checkEncumbrance()
	end,
}

newEffect{
	name = "CURSE_OF_CORPSES",
	desc = "Curse of Corpses",
	short_desc = "Corpses",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {Penalty = 1},
	getResistsUndead = function(eff, level) return -2 * level * (eff.Penalty or 1) end,
	getIncDamageUndead = function(level) return 2 + level * 2 end,
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getStrChange = function(level) return level end,
	getMagChange = function(level) return level end,
	getCorpselightRadius = function(level) return math.floor(level + 1) end,
	getReprieveChance = function(level) return Combat:combatLimit(level-4, 100, 35, 0, 50, 5)  end, -- Limit < 100%
	display_desc = function(self, eff) return ([[Curse of Corpses (power %0.1f)]]):format(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[一 个 死 亡 的 光 环 笼 罩 着 你.
#CRIMSON# 惩 罚 : #WHITE# 死 亡 恐 惧： %+d%% 对 亡 灵 的 伤 害 抵 抗。 
#CRIMSON# 强 度 1+: %s 死 亡 力 量： %+d%% 对 亡 灵 的 伤 害 加 成。 
#CRIMSON# 强 度 2+: %s%+d 幸 运 , %+d 力 量 , %+d 魔 法 
#CRIMSON# 强 度 3+: %s 尸 光： 每 个 你 杀 死 的 目 标 都 留 下 一 道 踪 迹， %d 格 范 围 的 一 个 诡 异 的 光 环。 
#CRIMSON# 强 度 4+: %s 死 缓： 你 杀 死 的 人 形 生 物 有 %d%% 几 率 变 成 食 尸 鬼 并 替 你 作 战 持 续 6 回 合。]]):format(
		def.getResistsUndead(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getIncDamageUndead(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getStrChange(math.max(level, 2)), def.getMagChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getCorpselightRadius(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getReprieveChance(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Fear of Death
		eff.resistsUndeadId = self:addTemporaryValue("resists_actor_type", { ["undead"] = def.getResistsUndead(eff,level) })

		-- level 1: Power over Death
		if bonusLevel < 1 then return end
		eff.incDamageUndeadId = self:addTemporaryValue("inc_damage_actor_type", { ["undead"] = def.getIncDamageUndead(level) })

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_STR] = def.getStrChange(level),
			[Stats.STAT_MAG] = def.getMagChange(level),
		})

		-- level 3: Corpselight
		-- level 4: Reprieve from Death
	end,
	deactivate = function(self, eff)
		if eff.resistsUndeadId then self:removeTemporaryValue("resists_actor_type", eff.resistsUndeadId) eff.resistsUndeadId = nil end
		if eff.incDamageUndeadId then self:removeTemporaryValue("inc_damage_actor_type", eff.incDamageUndeadId) eff.incDamageUndeadId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	doCorpselight = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES]
			local tg = {type="ball", 10, radius=def.getCorpselightRadius(eff.level), talent=t}
			self:project(tg, target.x, target.y, DamageType.LITE, 1)
			game.logSeen(target, "#F53CBE#%s's remains glow with a strange light.", target.name:capitalize())
		end
	end,
	npcWalkingCorpse = {
		name = "walking corpse",
		display = "z", color=colors.GREY, image="npc/undead_ghoul_ghoul.png",
		type = "undead", subtype = "ghoul",
		desc = [[This corpse was recently alive but moves as though it is just learning to use its body.]],
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		no_drops = true,
		autolevel = "ghoul",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=14, dex=12, mag=10, con=12 },
		rank = 2,
		size_category = 3,
		infravision = 10,
		resolvers.racial(),
		resolvers.tmasteries{ ["technique/other"]=1, },
		open_door = true,
		blind_immune = 1,
		see_invisible = 2,
		undead = 1,
		max_life = resolvers.rngavg(90,100),
		combat_armor = 2, combat_def = 7,
		resolvers.talents{
			T_STUN={base=1, every=10, max=5},
			T_BITE_POISON={base=1, every=10, max=5},
			T_ROTTING_DISEASE={base=1, every=10, max=5},
		},
		combat = { dam=resolvers.levelup(10, 1, 1), atk=resolvers.levelup(5, 1, 1), apr=3, dammod={str=0.6} },
	},
	doReprieveFromDeath = function(self, eff, target)
		local def = self.tempeffect_def[self.EFF_CURSE_OF_CORPSES]
		if math.min(eff.unlockLevel, eff.level) >= 4 and target.type == "humanoid" and rng.percent(def.getReprieveChance(eff.level)) then
			if not self:canBe("summon") then return end

			game:onTickEnd(function()
				local x, y = util.findFreeGrid(target.x, target.y,1)
				if not x then return end
				local m = require("mod.class.NPC").new(def.npcWalkingCorpse)
				m.faction = self.faction
				m.summoner = self
				m.summoner_gain_exp = true
				m.summon_time = 6
				m:resolve() m:resolve(nil, true)
				m:forceLevelup(math.max(1, self.level - 2))
				game.zone:addEntity(game.level, m, "actor", x, y)
				-- Add to the party
				if self.player then
					m.remove_from_party_on_death = true
					game.party:addMember(m, {control="no", type="summon", title="Summon"})
				end

				game.level.map:particleEmitter(x, y, 1, "slime")

				game.logSeen(m, "#F53CBE#The corpse of the %s pulls itself up to fight for you.", target.name)
				game:playSoundNear(who, "talents/slime")
			end)
			return true
		else
			return false
		end
	end,
}

newEffect{
	name = "CURSE_OF_MADNESS",
	desc = "Curse of Madness",
	short_desc = "Madness",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {Penalty = 1},
	getMindResistChange = function(eff, level) return -level * 3 * (eff.Penalty or 1) end,
	getConfusionImmuneChange = function(eff, level) return -level * 0.04 * (eff.Penalty or 1) end,
	getCombatCriticalPowerChange = function(level) return level * 3 end,
	-- called by _M:getOffHandMult in mod.class.interface.Combat.lua
	getOffHandMultChange = function(level) return Combat:combatTalentLimit(level, 50, 4, 20) end, -- Limit < 50%
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getDexChange = function(level) return -1 + level * 2 end,
	getManiaDamagePercent = function(level) 
		return Combat:combatLimit(level - 4, 5, 13, 1, 8, 5) -- Limit > 5%
	end,
	display_desc = function(self, eff) return ([[Curse of Madness (power %0.1f)]]):format(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[你 觉 得 你 对 现 实 失 去 控 制。
#CRIMSON# 惩 罚 : #WHITE# 扰 乱 心 智： %+d%% 精 神 抵 抗 , %+d%% 混 乱 免 疫 
#CRIMSON# 强 度 1+: %s 接 触 束 缚： %+d%% 暴 击 伤 害， %+d%% 副 手 武 器 伤 害。 
#CRIMSON# 强 度 2+: %s%+d 幸 运， %+d 敏 捷 
#CRIMSON# 强 度 3+: %s 反 间： 当 你 受 到 混 乱 效 果， 任 何 近 身 攻 击 你 或 你 攻 击 的 目 标 也 会 陷 入 混 乱。 
#CRIMSON# 强 度 4+: %s 狂 热： 每 次 你 一 回 合 lose more than %0.1f%% of your life， 你 的 一 个 技 能 冷 却 时 间 减 少 1 回 合。]]):format(
		def.getMindResistChange(eff, level), def.getConfusionImmuneChange(eff, level) * 100,
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getCombatCriticalPowerChange(math.max(level, 1)), def.getOffHandMultChange(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getDexChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#",
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getManiaDamagePercent(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS], eff.level, math.min(eff.unlockLevel, eff.level)

		-- reset stored values
		eff.last_life = self.life

		-- penalty: Fractured Sanity
		eff.mindResistId = self:addTemporaryValue("resists", { [DamageType.MIND] = def.getMindResistChange(eff, level) })
		eff.confusionImmuneId = self:addTemporaryValue("confusion_immune", def.getConfusionImmuneChange(eff, level) )

		-- level 1: Twisted Mind
		if bonusLevel < 1 then return end
		eff.getCombatCriticalPowerChangeId = self:addTemporaryValue("combat_critical_power", def.getCombatCriticalPowerChange(level) )

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_DEX] = def.getDexChange(level),
		})

		-- level 3: Conspirator
		-- level 4: Mania
	end,
	deactivate = function(self, eff)
		if eff.mindResistId then self:removeTemporaryValue("resists", eff.mindResistId) eff.mindResistId = nil end
		if eff.confusionImmuneId then self:removeTemporaryValue("confusion_immune", eff.confusionImmuneId) eff.confusionImmuneId = nil end
		if eff.getCombatCriticalPowerChangeId then self:removeTemporaryValue("combat_critical_power", eff.getCombatCriticalPowerChangeId) eff.getCombatCriticalPowerChangeId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
	end,
	on_timeout = function(self, eff)
		-- mania
		if math.min(eff.unlockLevel, eff.level) >= 4 and eff.life ~= eff.last_life then
			-- occurs pretty close to actual cooldowns in Actor.Act
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MADNESS]
			if not self:attr("stunned") and eff.last_life and 100 * (eff.last_life - self.life) / self.max_life >= def.getManiaDamagePercent(eff.level) then
				-- perform mania
				local list = {}
				for tid, cd in pairs(self.talents_cd) do
					if cd and cd > 0 then
						list[#list + 1] = tid
					end
				end
				if #list == 0 then return end

				local tid = rng.table(list)
				local t = self:getTalentFromId(tid)

				self.changed = true
				self.talents_cd[tid] = self.talents_cd[tid] - 1
				if self.talents_cd[tid] <= 0 then
					self.talents_cd[tid] = nil
					if self.onTalentCooledDown then self:onTalentCooledDown(tid) end
				end
				game.logSeen(self, "#F53CBE#%s's mania hastens %s.", self.name:capitalize(), t.name)
			end
			eff.last_life = self.life
		end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	doConspirator = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 and self:attr("confused") and target:canBe("confusion") then
			target:setEffect(target.EFF_CONFUSED, 3, {power=50})
			self:logCombat(target, "#F53CBE##Source# spreads confusion to #Target#.")
		end
	end,
}


newEffect{
	name = "CURSE_OF_SHROUDS",
	desc = "Curse of Shrouds",
	short_desc = "Shrouds",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {Penalty = 1},
	getShroudIncDamageChange = function(eff, level) return -(4 + level * 2) * (eff.Penalty or 1) end,
	getResistsDarknessChange = function(level) return level * 4 end,
	getResistsCapDarknessChange = function(level) return Combat:combatTalentLimit(level, 30, 4, 12) end, -- Limit < 30%
	getSeeInvisible = function(level) return 2 + level * 2 end,
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getConChange = function(level) return -1 + level * 2 end,
	getShroudResistsAllChange = function(level) return (level - 1) * 5 end,
	display_desc = function(self, eff) return ([[Curse of Shrouds (power %0.1f)]]):format(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS], eff.level, math.min(eff.unlockLevel, eff.level)
		return ([[一 道 黑 暗 屏 障 降 临 在 你 的 面 前。
#CRIMSON# 惩 罚 : #WHITE# 虚 弱 屏 障： 小 概 率 被 包 裹 在 虚 弱 屏 障 内 ( 降 低 所 造 成 伤 害 %d%%) 持 续 4 回 合。 
#CRIMSON# 强 度 1+: %s 暗 夜 行 者： %+d 暗 影 抵 抗， %+d%% 最 大 暗 影 抵 抗， %+d 看 破 隐 形 强 度 
#CRIMSON# 强 度 2+: %s%+d 幸 运， %+d 体 质 
#CRIMSON# 强 度 3+: %s 穿 越 屏 障： 你 的 身 形 在 移 动 时 消 失， 移 动 后 1 回 合 减 少 %d%% for 所 受 伤 害。 
#CRIMSON# 强 度 4+: %s 死 亡 屏 障： 每 一 次 杀 死 目 标 可 以 让 你 笼 罩 在 一 个 屏 障 内， 减 少 %d%% 所 受 伤 害 持 续 3 回 合。]]):format(
		-def.getShroudIncDamageChange(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getResistsDarknessChange(math.max(level, 1)), def.getResistsCapDarknessChange(math.max(level, 1)), def.getSeeInvisible(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getConChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getShroudResistsAllChange(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getShroudResistsAllChange(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Shroud of Weakness

		-- level 1: Nightwalker
		if bonusLevel < 1 then return end
		eff.resistsDarknessId = self:addTemporaryValue("resists", { [DamageType.DARKNESS] = def.getResistsDarknessChange(level) })
		eff.resistsCapDarknessId = self:addTemporaryValue("resists_cap", { [DamageType.DARKNESS]= def.getResistsCapDarknessChange(level) })
		eff.seeInvisibleId = self:addTemporaryValue("see_invisible", def.getSeeInvisible(level))

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_CON] = def.getConChange(level),
		})

		-- level 3: Shroud of Passing
		-- level 4: Shroud of Death
	end,
	deactivate = function(self, eff)
		if eff.resistsDarknessId then self:removeTemporaryValue("resists", eff.resistsDarknessId) eff.resistsDarknessId = nil end
		if eff.resistsCapDarknessId then self:removeTemporaryValue("resists_cap", eff.resistsCapDarknessId) eff.resistsCapDarknessId = nil end
		if eff.seeInvisibleId then self:removeTemporaryValue("see_invisible", eff.seeInvisibleId) eff.seeInvisibleId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end

		if self:hasEffect(self.EFF_SHROUD_OF_WEAKNESS) then self:removeEffect(self.EFF_SHROUD_OF_WEAKNESS) end
		if self:hasEffect(self.EFF_SHROUD_OF_PASSING) then self:removeEffect(self.EFF_SHROUD_OF_PASSING) end
		if self:hasEffect(self.EFF_SHROUD_OF_DEATH) then self:removeEffect(self.EFF_SHROUD_OF_DEATH) end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	on_timeout = function(self, eff)
		-- Shroud of Weakness
		if rng.chance(100) then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			self:setEffect(self.EFF_SHROUD_OF_WEAKNESS, 4, { power=def.getShroudIncDamageChange(eff, eff.level) })
		end
	end,
	doShroudOfPassing = function(self, eff)
		-- called after energy is used; eff.moved may be set from movement
		local effShroud = self:hasEffect(self.EFF_SHROUD_OF_PASSING)
		if math.min(eff.unlockLevel, eff.level) >= 3 and eff.moved then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			if not effShroud then self:setEffect(self.EFF_SHROUD_OF_PASSING, 1, { power=def.getShroudResistsAllChange(eff.level) }) end
		else
			if effShroud then self:removeEffect(self.EFF_SHROUD_OF_PASSING) end
		end
		eff.moved = false
	end,
	doShroudOfDeath = function(self, eff)
		if math.min(eff.unlockLevel, eff.level) >= 4 and not self:hasEffect(self.EFF_SHROUD_OF_DEATH) then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS]
			self:setEffect(self.EFF_SHROUD_OF_DEATH, 3, { power=def.getShroudResistsAllChange(eff.level) })
		end
	end,
}

newEffect{
	name = "SHROUD_OF_WEAKNESS",
	desc = "Shroud of Weakness",
	long_desc = function(self, eff) return ("目 标 笼 罩 在 一 个 虚 弱 屏 障 内。 ( 减 少 造 成 伤 害 %d%%)。"):format(-eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	no_stop_enter_worlmap = true,
	no_stop_resting = true,
	parameters = { power=10 },
	activate = function(self, eff)
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all = eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "SHROUD_OF_PASSING",
	desc = "Shroud of Passing",
	long_desc = function(self, eff) return ("笼 罩 在 一 个 屏 障 内 使 目 标 身 形 逐 渐 消 失 (+%d%% 全 抗 )。"):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	decrease = 0,
	parameters = { power=10 },
	activate = function(self, eff)
		eff.resistsId = self:addTemporaryValue("resists", { all = eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistsId)
	end,
}

newEffect{
	name = "SHROUD_OF_DEATH",
	desc = "Shroud of Death",
	long_desc = function(self, eff) return ("笼 罩 在 一 个 屏 障 内 使 目 标 身 形 逐 渐 消 失 (+%d%% 全 抗 )。 "):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.resistsId = self:addTemporaryValue("resists", { all = eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistsId)
	end,
}

newEffect{
	name = "CURSE_OF_NIGHTMARES",
	desc = "Curse of Nightmares",
	short_desc = "Nightmares",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {Penalty = 1},
	-- called by _M:combatMentalResist in mod.class.interface.Combat.lua
	getVisionsReduction = function(eff, level)
		return Combat:combatTalentLimit(level, 100, 9, 25) * (eff.Penalty or 1) -- Limit < 100%
	end,
	getResistsPhysicalChange = function(level) return 1 + level end,
	getResistsCapPhysicalChange = function(level) return Combat:combatTalentLimit(level, 30, 1, 5) end, -- Limit < 30%
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getWilChange = function(level) return -1 + level * 2 end,
	getBaseSuffocateAirChange = function(level) return Combat:combatTalentLimit(level, 50, 4, 16) end, -- Limit < 50 to take >2 hits to kill most monsters
	getSuffocateAirChange = function(level) return Combat:combatTalentLimit(level, 10, 0, 7) end, -- Limit < 10
	getNightmareChance = function(level) return Combat:combatTalentLimit(math.max(0, level-3), 25, 3, 10) end, -- Limit < 25%
	getNightmareRadius = function(level) return 5 + (level - 4) * 2 end,
	display_desc = function(self, eff)
		if math.min(eff.unlockLevel, eff.level) >= 4 then
			return ([[Curse of Nightmares (power %0.1f): %d%%]]):format(eff.level, eff.nightmareChance or 0)
		else
			return ([[Curse of Nightmares (power %0.1f)]]):format(eff.level)
		end
	end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES], eff.level, math.min(eff.unlockLevel, eff.level)

		return ([[你 的 脑 海 中 充 斥 恐 怖 景 象。
#CRIMSON# 惩 罚 : #WHITE# 扰 乱 幻 象： 当 鉴 定 时， 你 的 精 神 豁 免 有 20％ 概 率 减 少 %d%% 
#CRIMSON# 强 度 1+: %s 从 现 实 消 失： %+d 物 理 抵 抗， %+d 物 理 抵 抗 上 限 
#CRIMSON# 强 度 2+: %s%+d 幸 运， %+d 意 志 
#CRIMSON# 强 度 3+: %s 你 将 恐 怖 输 注 进 那 些 虚 弱、 非 精 英 目 标， 扼 制 近 身 攻 击 你 或 你 攻 击 的 目 标。 等 级 3 及 以 上 时 损 失 %d 空 气， 每 升 一 级 再 额 外 损 失 %d 空 气。 
#CRIMSON# 强 度 4+: %s 每 次 受 到 目 标 攻 击 有 概 率 (当 前 %d%%) 触 发 一 个 范 围 为 %d 码 的 噩 梦（ 有 减 速 效 果、 憎 恨 私 语 和 召 唤 梦 魇） 持 续 8 回 合。  触 发 几 率  在 每 次 你 受 到 打 击 时 提 高，同 时 随 时 间 下 降。]]):format(
		def.getVisionsReduction(eff, level),
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getResistsPhysicalChange(math.max(level, 1)), def.getResistsCapPhysicalChange(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getWilChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getBaseSuffocateAirChange(math.max(level, 3)), def.getSuffocateAirChange(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", eff.nightmareChance or 0, def.getNightmareRadius(math.max(level, 4)), def.getNightmareChance(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Plagued by Visions

		-- level 1: Removed from Reality
		if bonusLevel < 1 then return end
		eff.resistsPhysicalId = self:addTemporaryValue("resists", { [DamageType.PHYSICAL]= def.getResistsPhysicalChange(level) })
		eff.resistsCapPhysicalId = self:addTemporaryValue("resists_cap", { [DamageType.PHYSICAL]= def.getResistsCapPhysicalChange(level) })

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_WIL] = def.getWilChange(level),
		})

		-- level 3: Suffocate
		-- level 4: Nightmare
	end,
	deactivate = function(self, eff)
		if eff.resistsPhysicalId then self:removeTemporaryValue("resists", eff.resistsPhysicalId); eff.resistsPhysicalId =  nil end
		if eff.resistsCapPhysicalId then self:removeTemporaryValue("resists_cap", eff.resistsCapPhysicalId) eff.resistsCapPhysicalId =  nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId =  nil end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	doSuffocate = function(self, eff, target)
		if math.min(eff.unlockLevel, eff.level) >= 3 then
			if target and target.rank <= 2 and target.level <= self.level - 3 and not target:attr("no_breath") and not target:attr("invulnerable") then
				local def = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES]
				local airLoss = def.getBaseSuffocateAirChange(eff.level) + Combat:combatTalentScale(self.level - target.level - 3, 1, 5) * def.getSuffocateAirChange(eff.level)
				game.logSeen(self, "#F53CBE#%s begins to choke from a suffocating curse. (-%d air)", target.name, airLoss)
				target:suffocate(airLoss, self, "suffocated from a curse")
			end
		end
	end,
	npcTerror = {
		name = "terror",
		display = "h", color=colors.DARK_GREY, image="npc/horror_eldritch_nightmare_horror.png",
		blood_color = colors.BLUE,
		desc = "A formless terror that seems to cut through the air, and its victims, like a knife.",
		type = "horror", subtype = "eldritch",
		rank = 2,
		size_category = 2,
		body = { INVEN = 10 },
		no_drops = true,
		autolevel = "warrior",
		level_range = {1, nil}, exp_worth = 0,
		ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_ghoul", },
		stats = { str=16, dex=20, wil=15, con=15 },
		infravision = 10,
		can_pass = {pass_wall=20},
		resists = {[DamageType.LIGHT] = -50, [DamageType.DARKNESS] = 100},
		silent_levelup = true,
		no_breath = 1,
		fear_immune = 1,
		blind_immune = 1,
		infravision = 10,
		see_invisible = 80,
		max_life = resolvers.rngavg(50, 80),
		combat_armor = 1, combat_def = 10,
		combat = { dam=resolvers.levelup(resolvers.rngavg(15,20), 1, 1.1), atk=resolvers.rngavg(5,15), apr=5, dammod={str=1} },
		resolvers.talents{
		},
	},
	on_timeout = function(self, eff) -- Chance for nightmare fades over time
		if eff.nightmareChance then eff.nightmareChance = math.max(0, eff.nightmareChance-1) end
	end,
	callbackOnHit = function(self, eff, cb)	game:onTickEnd(function()
		if math.min(eff.unlockLevel, eff.level) >= 4 then
			-- build chance for a nightmare
			local def = self.tempeffect_def[self.EFF_CURSE_OF_NIGHTMARES]
			eff.nightmareChance = (eff.nightmareChance or 0) + def.getNightmareChance(eff.level)


			-- invoke the nightmare
			if rng.percent(eff.nightmareChance) then
				local radius = def.getNightmareRadius(eff.level)

				-- make sure there is at least one creature to torment
				local seen = false
				core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, radius,
					function(_, x, y) return game.level.map:opaque(x, y) end,
					function(_, x, y)
						local actor = game.level.map(x, y, game.level.map.ACTOR)
						if actor and actor ~= self and self:reactionToward(actor) < 0 then seen = true end
					end, nil)
				if not seen then return false end

				-- start the nightmare: slow, hateful whisper, random Terrors (minor horrors)
				eff.nightmareChance = 0
				game.level.map:addEffect(self,
					self.x, self.y, 8,
					DamageType.NIGHTMARE, 1,
					radius,
					5, nil,
					engine.MapEffect.new{alpha=100, color_br=134, color_bg=60, color_bb=134, effect_shader="shader_images/darkness_effect.png"},
					function(e)
						-- attempt one summon per turn
						if not e.src:canBe("summon") then return end

						local def = e.src.tempeffect_def[e.src.EFF_CURSE_OF_NIGHTMARES]

						-- random location nearby..not too picky and these things can move through walls but won't start there
						local locations = {}
						local grids = core.fov.circle_grids(e.x, e.y, e.radius, true)
						for lx, yy in pairs(grids) do for ly, _ in pairs(grids[lx]) do
							if not game.level.map:checkAllEntities(lx, ly, "block_move") then
								locations[#locations+1] = {lx, ly}
							end
						end end
						if #locations == 0 then return true end
						local location = rng.table(locations)

						local m = require("mod.class.NPC").new(def.npcTerror)
						m.faction = e.src.faction
						m.summoner = e.src
						m.summoner_gain_exp = true
						m.summon_time = 3
						m:resolve() m:resolve(nil, true)
						m:forceLevelup(e.src.level)

						-- Add to the party
						if e.src.player then
							m.remove_from_party_on_death = true
							game.party:addMember(m, {control="no", type="nightmare", title="Nightmare"})
						end

						game.zone:addEntity(game.level, m, "actor", location[1], location[2])

						return true
					end,
					false, false)

				game.logSeen(self, "#F53CBE#The air around %s grows cold and terrifying shapes begin to coalesce. A nightmare has begun.", self.name:capitalize())
				game:playSoundNear(self, "talents/cloud")
			end
		end
	end) end,
}


newEffect{
	name = "CURSE_OF_MISFORTUNE",
	desc = "Curse of Misfortune",
	short_desc = "Misfortune",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	no_stop_enter_worlmap = true,
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {Penalty = 1},
	getMoneyMult = function(eff, level) return Combat:combatTalentLimit(level, 1, 0.15, 0.35) * (eff.Penalty or 1)end, -- Limit < 1 bug fix
	
	getCombatDefChange = function(level) return level * 2 end,
	getCombatDefRangedChange = function(level) return level end,
	getLckChange = function(eff, level)
		if eff.unlockLevel >= 5 or level <= 2 then return -1 end
		if level <= 3 then return -2 else return -3 end
	end,
	getCunChange = function(level) return -1 + level * 2 end,
	getDeviousMindChange = function(level) return Combat:combatTalentLimit(math.max(1,level-3), 100, 35, 55) end, -- Limit < 100%
	getUnfortunateEndChance = function(level) return Combat:combatTalentLimit(math.max(1, level-3), 100, 30, 40) end, -- Limit < 50%
	getUnfortunateEndIncrease = function(level) return Combat:combatTalentLimit(math.max(1, level-3), 50, 30, 40) end, -- Limit < 50%
	display_desc = function(self, eff) return ([[Curse of Misfortune (power %0.1f)]]):format(eff.level) end,
	long_desc = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE], eff.level, math.min(eff.unlockLevel, eff.level)

		return ([[重 伤 和 毁 灭 追 随 着 你。
#CRIMSON# 惩 罚 : #WHITE# 霉 运： 在 你 的 旅 途 中 找 到 的 金 币 减 少。 
#CRIMSON# 强 度 1+: %s 错 失 良 机： %+d 闪 避， +%d 远 程 防 御 
#CRIMSON# 强 度 2+: %s%+d 幸 运， %+d 灵 巧 
#CRIMSON# 强 度 3+: %s 狡 猾 意 识： 你 对 他 人 的 阴 险 计 划 能 够 有 一 定 感 知 力 (+%d%% 概 率 避 免 陷 阱 )。 
#CRIMSON# 强 度 4+: %s 厄 运 终 结： 如 果 提 高 后 的 伤 害 足 够 终 结 对 手 的 话， 有 %d%% 概 率 使 你 提 高 %d%% 伤 害。]]):format(
		bonusLevel >= 1 and "#WHITE#" or "#GREY#", def.getCombatDefChange(math.max(level, 1)), def.getCombatDefRangedChange(math.max(level, 1)),
		bonusLevel >= 2 and "#WHITE#" or "#GREY#", def.getLckChange(eff, math.max(level, 2)), def.getCunChange(math.max(level, 2)),
		bonusLevel >= 3 and "#WHITE#" or "#GREY#", def.getDeviousMindChange(math.max(level, 3)),
		bonusLevel >= 4 and "#WHITE#" or "#GREY#", def.getUnfortunateEndChance(math.max(level, 4)), def.getUnfortunateEndIncrease(math.max(level, 4)))
	end,
	activate = function(self, eff)
		local def, level, bonusLevel = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE], eff.level, math.min(eff.unlockLevel, eff.level)

		-- penalty: Lost Fortune
		eff.moneyValueMultiplierId = self:addTemporaryValue("money_value_multiplier", -def.getMoneyMult(eff, level))

		-- level 1: Missed Shot
		if bonusLevel < 1 then return end
		eff.combatDefId = self:addTemporaryValue("combat_def", def.getCombatDefChange(level))
		eff.combatDefRangedId = self:addTemporaryValue("combat_def_ranged", def.getCombatDefRangedChange(level))

		-- level 2: stats
		if bonusLevel < 2 then return end
		eff.incStatsId = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_LCK] = def.getLckChange(eff, level),
			[Stats.STAT_CUN] = def.getCunChange(level),
		})

		-- level 3: Devious Mind
		if bonusLevel < 3 then return end
		eff.trapAvoidanceId = self:addTemporaryValue("trap_avoidance", def.getDeviousMindChange(level))

		-- level 4: Unfortunate End
	end,
	deactivate = function(self, eff)
		if eff.moneyValueMultiplierId then self:removeTemporaryValue("money_value_multiplier", eff.moneyValueMultiplierId) eff.moneyValueMultiplierId = nil end
		if eff.combatDefId then self:removeTemporaryValue("combat_def", eff.combatDefId) eff.combatDefId = nil end
		if eff.combatDefRangedId then self:removeTemporaryValue("combat_def_ranged", eff.combatDefRangedId) eff.combatDefRangedId = nil end
		if eff.incStatsId then self:removeTemporaryValue("inc_stats", eff.incStatsId) eff.incStatsId = nil end
		if eff.trapAvoidanceId then self:removeTemporaryValue("trap_avoidance", eff.trapAvoidanceId) eff.trapAvoidanceId = nil end
	end,
	on_merge = function(self, old_eff, new_eff) return old_eff end,
	
	-- called by default projector in mod.data.damage_types.lua
	doUnfortunateEnd = function(self, eff, target, dam)
		if math.min(eff.unlockLevel, eff.level) >=4 then
			local def = self.tempeffect_def[self.EFF_CURSE_OF_MISFORTUNE]
			if target.life - dam > 0 and rng.percent(def.getUnfortunateEndChance(eff.level)) then
				local multiplier = 1 + def.getUnfortunateEndIncrease(eff.level) / 100
				if target.life - dam * multiplier <= 0 then
					-- unfortunate end! note that this does not kill if target.die_at < 0
					dam = dam * multiplier
					if target.life - dam <= target.die_at then
						game.logSeen(target, "#F53CBE#%s suffers an unfortunate end.", target.name:capitalize())
					else
						game.logSeen(target, "#F53CBE#%s suffers an unfortunate blow.", target.name:capitalize())
					end
				end
			end
		end

		return dam
	end,
}

newEffect{
	name = "PROB_TRAVEL_UNSTABLE", image = "talents/probability_travel.png",
	desc = "Unstable Probabilites",
	long_desc = function(self, eff) return "目 标 最 近 通 过 使 用 时 空 旅 行 穿 越 了 墙 壁。" end,
	type = "other",
	subtype = { time=true, space=true },
	status = "detrimental",
	parameters = {},
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("prob_travel_deny", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("prob_travel_deny", eff.iid)
	end,
}

newEffect{
	name = "HEIGHTEN_FEAR", image = "talents/heighten_fear.png",
	desc = "Heighten Fear",
	long_desc = function(self, eff) return ("目 标 处 于 恐 惧 加 深 的 状 态 中。 如 果 他 们 在 %d 回 合 中 还 处 于 此 射 程 中（ 或 %d）， 并 且 处 于 该 恐 惧 (%s) 的 范 围 内， 他 们 将 会 被 灌 输 新 的 恐 惧。"):
	format(eff.turns_left, eff.range, eff.src.name) end,
	type = "other",
	subtype = { fear=true },
	status = "detrimental",
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = { },
	on_merge = function(self, old_eff, new_eff)
		old_eff.src = new_eff.src
		old_eff.range = new_eff.range

		return old_eff
	end,
	on_timeout = function(self, eff)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		if tInstillFear.hasEffect(eff.src, tInstillFear, self) then
			if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) <= eff.range and self:hasLOS(eff.src.x, eff.src.y) then
				eff.turns_left = eff.turns_left - 1
			end
			if eff.turns_left <= 0 then
				eff.turns_left = eff.turns
				if rng.percent(eff.chance or 100) then
					eff.chance = (eff.chance or 100) - 10
					game.logSeen(self, "%s succumbs to heightening fears!", self.name:capitalize())
					tInstillFear.applyEffect(eff.src, tInstillFear, self)
				else
					game.logSeen(self, "%s feels a little less afraid!", self.name:capitalize())
				end
			end
		else
			-- no more fears
			self:removeEffect(self.EFF_HEIGHTEN_FEAR, false, true)
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CURSED_FORM", image = "talents/seethe.png",
	desc = "Cursed Form",
	type = "other",
	subtype = { curse=true },
	status = "beneficial",
	decrease = 0,
	no_remove = true,
	cancel_on_level_change = true,
	parameters = {},
	long_desc = function(self, eff)
		local desc = "目 标 的 诅 咒 之 体 对 其 所 承 受 的 苦 难 做 出 了 回 应。"
		if (eff.incDamageChange or 0) > 0 then
			desc = desc..(" 目 标 造 成 的 所 有 伤 害 增 加 %d%%。"):format(eff.incDamageChange)
		end
		if (eff.statChange or 0) > 0 then
			desc = desc..(" 力 量 和 意 志 增 加 %d 。 每 回 合 有 %d%% 免 疫 疾 病 和 毒 素 效 果。"):format(eff.statChange, eff.neutralizeChance)
		end
		return desc
	end,
	activate = function(self, eff)
		-- first on_timeout is ignored because it is applied immediately
		eff.firstHit = true
		eff.increase = 1
		self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)

		game.level.map:particleEmitter(self.x, self.y, 1, "cursed_form", {power=eff.increase})
	end,
	deactivate = function(self, eff)
		if eff.incDamageId then
			self:removeTemporaryValue("inc_damage", eff.incDamageId)
			eff.incDamageId = nil
		end
		if eff.incStatsId then
			self:removeTemporaryValue("inc_stats", eff.incStatsId)
			eff.incStatsId = nil
		end
	end,
	do_onTakeHit = function(self, eff, dam)
		eff.hit = true
	end,
	updateEffect = function(self, eff)
		local tSeethe = self:getTalentFromId(self.T_SEETHE)
		local tGrimResolve = self:getTalentFromId(self.T_GRIM_RESOLVE)
		if tSeethe then
			eff.incDamageChange = tSeethe.getIncDamageChange(self, tSeethe, eff.increase)
		end
		if tGrimResolve then
			eff.statChange = tGrimResolve.getStatChange(self, tGrimResolve, eff.increase)
			eff.neutralizeChance = tGrimResolve.getNeutralizeChance(self, tGrimResolve)
		end

		if eff.incDamageId then
			self:removeTemporaryValue("inc_damage", eff.incDamageId)
			eff.incDamageId = nil
		end
		if eff.incDamageChange > 0 then
			eff.incDamageId = self:addTemporaryValue("inc_damage", {all = eff.incDamageChange})
		end
		if eff.incStatsId then
			self:removeTemporaryValue("inc_stats", eff.incStatsId)
			eff.incStatsId = nil
		end
		if eff.statChange > 0 then
			eff.incStatsId = self:addTemporaryValue("inc_stats", { [Stats.STAT_STR] = eff.statChange, [Stats.STAT_WIL] = eff.statChange })
		end
	end,
	on_timeout = function(self, eff)
		if eff.firstHit then
			eff.firstHit = nil
			eff.hit = false
		elseif eff.hit then
			if eff.increase < 5 then
				eff.increase = eff.increase + 1
				self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)

				game.level.map:particleEmitter(self.x, self.y, 1, "cursed_form", {power=eff.increase})
			end
			eff.hit = false
		else
			eff.increase = eff.increase - 1
			if eff.increase == 0 then
				self:removeEffect(self.EFF_CURSED_FORM, false, true)
			else
				self.tempeffect_def[self.EFF_CURSED_FORM].updateEffect(self, eff)
			end
		end
		if (eff.statChange or 0)>0 and eff.neutralizeChance then -- Remove poisons/disease (w/Grim Resolve)
			local efdef
			for efid, ef in pairs(self.tmp) do
				efdef = self.tempeffect_def[efid]
				if efdef.subtype and (efdef.subtype.poison or efdef.subtype.disease) and rng.percent(eff.neutralizeChance) then
					self:removeEffect(efid)
				end
			end
		end
	end,
}

newEffect{
	name = "FADED", image = "talents/shadow_fade.png",
	desc = "Faded",
	long_desc = function(self, eff) return "目 标 逐 渐 隐 匿 无 形， 并 且 不 再 受 到 伤 害。" end,
	type = "other",
	subtype = { },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# fades!", "+Faded" end,
	parameters = {},
	activate = function(self, eff)
		eff.iid = self:addTemporaryValue("invulnerable", 1)
		eff.imid = self:addTemporaryValue("status_effect_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.iid)
		self:removeTemporaryValue("status_effect_immune", eff.imid)
	end,
	on_timeout = function(self, eff)
		-- always remove
		return true
	end,
}

-- Borrowed Time and the Borrowed Time stun effect
newEffect{
	name = "HIGHBORN_S_BLOOM", image = "talents/highborn_s_bloom.png",
	desc = "Highborn's Bloom",
	long_desc = function(self, eff) return "目 标 使 用 技 能 时 不 再 消 耗 能 量。" end,
	type = "other",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("zero_resource_cost", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("zero_resource_cost", eff.tmpid)
	end,
}

newEffect{
	name = "VICTORY_RUSH_ZIGUR", image = "talents/arcane_destruction.png",
	desc = "Victory Rush",
	long_desc = function(self, eff) return "胜 利 的 激 励 使 目 标 刀 枪 不 入。" end,
	type = "other",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("invulnerable", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("invulnerable", eff.tmpid)
	end,
}

newEffect{
	name = "SOLIPSISM", image = "talents/solipsism.png",
	desc = "Solipsism",
	long_desc = function(self, eff) return ("目 标 进 入 唯 我 状 态 并 且 被 自 己 的 思 维 所 干 扰 (-%d%% 整 体 速 度 )。"):format(eff.power * 100) end,
	type = "other",
	subtype = { psionic=true },
	status = "detrimental",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "CLARITY", image = "talents/clarity.png",
	desc = "Clarity",
	long_desc = function(self, eff) return ("目 标 对 这 个 世 界 有 着 更 加 清 晰 的 认 识 (+%d%% 整 体 速 度 )。"):format(eff.power * 100) end,
	type = "other",
	subtype = { psionic=true },
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = { },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "DREAMSCAPE", image = "talents/dreamscape.png",
	desc = "Dreamscape",
	long_desc = function(self, eff) return ("目 标 进 入 了 %s 的 梦 境， 并 且 增 加 %d%% 所 有 伤 害。"):format(eff.target.name, eff.power) end,
	type = "other",
	subtype = { psionic=true },
	status = "beneficial",
	parameters = { power=1, projections_killed=0 },
	on_timeout = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
		-- Dreamscape doesn't cooldown in the dreamscape
		self.talents_cd[self.T_DREAMSCAPE] = self.talents_cd[self.T_DREAMSCAPE] + 1
		
		-- Spawn a copy every other turn
		local spawn_time = 2
		if eff.dur%spawn_time == 0 then
		
			-- Fine space
			local x, y = util.findFreeGrid(eff.target.x, eff.target.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			
			-- Create a clone for later spawning
			local m = require("mod.class.NPC").new(eff.target:cloneFull{
				shader = "shadow_simulacrum",
				shader_args = { color = {0.0, 1, 1}, base = 0.6 },
				no_drops = true, keep_inven_on_death = false,
				faction = eff.target.faction,
				summoner = eff.target, summoner_gain_exp=true,
				ai_target = {actor=nil},
				ai = "summoned", ai_real = "tactical",
				ai_state = eff.target.ai_state or { ai_move="move_complex", talent_in=1 },
				name = eff.target.name.."'s dream projection",
			})
			
			-- Change some values; most of this is typical clone protection stuff
			m.ai_state.ally_compassion = 10
			m:removeAllMOs()
			m.make_escort = nil
			m.on_added_to_level = nil
			m._rst_full = true
			m.forceLevelup = function() end
			m.on_acquire_target = nil
			m.seen_by = nil
			m.can_talk = nil
			m.puuid = nil
			m.on_takehit = nil
			m.exp_worth = 0
			m.no_inventory_access = true
			m.clone_on_hit = nil
			m.player = nil
			m.energy.value = 0
			m.max_life = m.max_life
			m.life = util.bound(m.life, 0, m.max_life)
			m.remove_from_party_on_death = true
			if not eff.target:attr("lucid_dreamer") then
				m.inc_damage.all = (m.inc_damage.all or 0) - 50
			end
			
			-- special stuff
 			m.is_psychic_projection = true
			m.lucid_dreamer = 1
			
			-- Remove some talents
			local tids = {}
			for tid, _ in pairs(m.talents) do
				local t = m:getTalentFromId(tid)
				if (t.no_npc_use and not t.allow_temporal_clones) or t.remove_on_clone then tids[#tids+1] = t end
			end
			for i, t in ipairs(tids) do
				if t.mode == "sustained" and m:isTalentActive(t.id) then m:forceUseTalent(t.id, {ignore_energy=true, silent=true}) end
				m:unlearnTalentFull(t.id)
			end
			
			-- remove imprisonment
			m.invulnerable = m.invulnerable - 1
			m.time_prison = m.time_prison - 1
			m.no_timeflow = m.no_timeflow - 1
			m.status_effect_immune = m.status_effect_immune - 1
			m:removeParticles(eff.particle)
			m:removeTimedEffectsOnClone()

			-- track number killed
			m.on_die = function(self, who)
				local p = (who and who:hasEffect(who.EFF_DREAMSCAPE)) or (who and who.summoner and who.summoner:hasEffect(who.summoner.EFF_DREAMSCAPE))
				if p then -- For the rare instance we die after the effect ends but before the dreamscape instance closes
					p.projections_killed = p.projections_killed + 1
					game.logSeen(p.target, "#LIGHT_RED#%s writhes in agony as a fragment of its mind is destroyed!", p.target.name:capitalize())
				end
			end

			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
			game.logSeen(eff.target, "#LIGHT_BLUE#%s has spawned a dream projection to protect its mind!", eff.target.name:capitalize())

			if game.party:hasMember(eff.target) then
				game.party:addMember(m, {
					control="full",
					type="projection",
					title="Dream Self",
					orders = {target=true},
				})
				if eff.target == game.player then
					game.party:setPlayer(m)
					m:resetCanSeeCache()
				end
			end
		end
		
		-- Try to insure the AI isn't attacking the invulnerable actor
		if self.ai_target and self.ai_target.actor and self.ai_target.actor:attr("invulnerable") then
			self:setTarget(nil)
		end
		
		-- End the effect early if we've killed enough projections
		if eff.projections_killed/10 >= eff.target.life/eff.target.max_life then
			game:onTickEnd(function()
				eff.target:die(self)
				game.logSeen(eff.target, "#LIGHT_RED#%s's mind shatters into %d tiny fragments!", eff.target.name:capitalize(), eff.target.max_life)
				eff.projections_killed = 0 -- clear this out to prevent closing messages
			end)
		end
	end,
	activate = function(self, eff)
		-- Make the target invulnerable
		eff.iid = eff.target:addTemporaryValue("invulnerable", 1)
		eff.sid = eff.target:addTemporaryValue("time_prison", 1)
		eff.tid = eff.target:addTemporaryValue("no_timeflow", 1)
		eff.imid = eff.target:addTemporaryValue("status_effect_immune", 1)
		eff.target.energy.value = 0

		-- Make the invader deadly
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.did = self:addTemporaryValue("lucid_dreamer", 1)
	end,
	deactivate = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
		
		-- Remove the target's invulnerability
		eff.target:removeTemporaryValue("invulnerable", eff.iid)
		eff.target:removeTemporaryValue("time_prison", eff.sid)
		eff.target:removeTemporaryValue("no_timeflow", eff.tid)
		eff.target:removeTemporaryValue("status_effect_immune", eff.imid)

		-- Remove the invaders damage bonus
		self:removeTemporaryValue("inc_damage", eff.pid)
		self:removeTemporaryValue("lucid_dreamer", eff.did)
		
		-- Return from the dreamscape
		game:onTickEnd(function()
			-- Collect objects
			local objs = {}
			for i = 0, game.level.map.w - 1 do for j = 0, game.level.map.h - 1 do
				for z = game.level.map:getObjectTotal(i, j), 1, -1 do
					objs[#objs+1] = game.level.map:getObject(i, j, z)
					game.level.map:removeObject(i, j, z)
				end
			end end

			local oldzone = game.zone
			local oldlevel = game.level
			local zone = game.level.source_zone
			local level = game.level.source_level

			if not self.dead then
				oldlevel:removeEntity(self)
				level:addEntity(self)
			end

			game.zone = zone
			game.level = level
			game.zone_name_s = nil

			local x1, y1 = util.findFreeGrid(eff.x, eff.y, 20, true, {[Map.ACTOR]=true})
			if x1 then
				if not self.dead then
					self:move(x1, y1, true)
					self.on_die, self.dream_plane_on_die = self.dream_plane_on_die, nil
					game.level.map:particleEmitter(x1, y1, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					self.x, self.y = x1, y1
				end
			end
			local x2, y2 = util.findFreeGrid(eff.tx, eff.ty, 20, true, {[Map.ACTOR]=true})
			if not eff.target.dead then
				if x2 then
					eff.target:move(x2, y2, true)
					eff.target.on_die, eff.target.dream_plane_on_die = eff.target.dream_plane_on_die, nil
				end
				if oldlevel:hasEntity(eff.target) then oldlevel:removeEntity(eff.target) end
				level:addEntity(eff.target)
			else
				eff.target.x, eff.target.y = x2, y2
			end

			-- Add objects back
			for i, o in ipairs(objs) do
				if self.dead then
					game.level.map:addObject(eff.target.x, eff.target.y, o)
				else
					game.level.map:addObject(self.x, self.y, o)
				end
			end

			-- Remove all npcs in the dreamscape
			for uid, e in pairs(oldlevel.entities) do
				if e ~= self and e ~= eff.target and e.die then e:die() end
			end

			-- Reload MOs
			game.level.map:redisplay()
			game.level.map:recreate()
			game.uiset:setupMinimap(game.level)
			game.nicer_tiles:postProcessLevelTilesOnLoad(game.level)

			game.logPlayer(game.player, "#LIGHT_BLUE#You are brought back from the Dreamscape!")

			-- Apply Dreamscape hit
			if eff.projections_killed > 0 then
				local kills = eff.projections_killed
				eff.target:takeHit(eff.target.max_life/10 * kills, self)
				eff.target:setEffect(eff.target.EFF_BRAINLOCKED, kills, {})

				local loss = "loss"
				if kills >= 10 then loss = "potentially fatal loss" elseif kills >=8 then loss = "devastating loss" elseif kills >=6 then loss = "tremendous loss" elseif kills >=4 then loss = "terrible loss" end
				game.logSeen(eff.target, "#LIGHT_RED#%s suffered a %s of self in the Dreamscape!", eff.target.name:capitalize(), loss)
			end
		end)
	end,
}

newEffect{
	name = "REVISIONIST_HISTORY", image = "talents/revisionist_history.png",
	desc = "Revisionist History",
	long_desc = function(self, eff) return " 该 效 果 持 续 时 你 可 以 改 变 现 实 历 史 使 其 不 会 发 生。" end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_REVISIONIST_HISTORY)
			if pos then
				self.hotkey[pos] = {"talent", self.T_REVISIONIST_HISTORY_BACK}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_REVISIONIST_HISTORY_BACK, true, 1, {no_unlearn=true})
		self.hotkey = ohk
		self:startTalentCooldown(self.T_REVISIONIST_HISTORY)
	end,
	deactivate = function(self, eff)
		if eff.back_in_time then game:onTickEnd(function()
			-- Update the shader of the original player
			self:updateMainShader()
			if game._chronoworlds == nil then
				game.logSeen(self, "#LIGHT_RED#The spell fizzles.")
				self:startTalentCooldown(self.T_REVISIONIST_HISTORY)
				return
			end
			game.logPlayer(game.player, "#LIGHT_BLUE#You go back in time to rewrite history!")
			game:chronoRestore("revisionist_history", true)
			game._chronoworlds = nil
			game.player.talents_cd[self.T_REVISIONIST_HISTORY] = nil
			game.player:startTalentCooldown(self.T_REVISIONIST_HISTORY)
		end) else
			game._chronoworlds = nil
			game.player.talents_cd[self.T_REVISIONIST_HISTORY] = nil
			self:startTalentCooldown(self.T_REVISIONIST_HISTORY)

			if self.hotkey and self.isHotkeyBound then
				local pos = self:isHotkeyBound("talent", self.T_REVISIONIST_HISTORY_BACK)
				if pos then
					self.hotkey[pos] = {"talent", self.T_REVISIONIST_HISTORY}
				end
			end

			self:unlearnTalent(self.T_REVISIONIST_HISTORY_BACK, 1, nil, {no_unlearn=true})
		end
	end,
}

newEffect{
	name = "ZONE_AURA_FIRE",
	desc = "Oil mist",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 火 焰 伤 害， -10% 火 焰 抗 性， -10% 护 甲 值， -2 可 视 范 围。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.FIRE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=10})
		self:effectTemporaryValue(eff, "sight", -2)
		self:effectTemporaryValue(eff, "combat_armor", -math.ceil(self:combatArmor() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_COLD",
	desc = "Grave chill",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 寒 冰 伤 害， -10% 寒 冰 抗 性， -10% 物 理 豁 免， -20% 混 乱 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.COLD]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.COLD]=10})
		self:effectTemporaryValue(eff, "confusion_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_physresist", -math.ceil(self:combatPhysicalResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_LIGHTNING",
	desc = "Static discharge",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 闪 电 伤 害， -10% 闪 电 抗 性， -10% 物 理 强 度， -20% 震 慑 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHTNING]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=10})
		self:effectTemporaryValue(eff, "stun_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_dam", -math.ceil(self:combatPhysicalpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ACID",
	desc = "Noxious fumes",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 酸 性 伤 害， -10% 酸 性 抗 性， -10% 闪 避， -20% 缴 械 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.ACID]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ACID]=10})
		self:effectTemporaryValue(eff, "disarm_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_def", -math.ceil(self:combatDefense(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_DARKNESS",
	desc = "Echoes of the void",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 暗 影 伤 害， -10% 暗 影 抗 性， -10% 精 神 豁 免， -20% 恐 惧 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.DARKNESS]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.DARKNESS]=10})
		self:effectTemporaryValue(eff, "fear_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_mentalresist", -math.ceil(self:combatMentalResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_MIND",
	desc = "Eerie silence",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 精 神 伤 害， -10% 精 神 抗 性， -10% 法 术 强 度， -20% 沉 默 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.MIND]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.MIND]=10})
		self:effectTemporaryValue(eff, "silence_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_spellpower", -math.ceil(self:combatSpellpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_LIGHT",
	desc = "Aura of light",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return (" 围 效 果： +10% 光 系 伤 害， -10% 光 系 抗 性， -10% 命 中， -20% 致 盲 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHT]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHT]=10})
		self:effectTemporaryValue(eff, "blind_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_atk", -math.ceil(self:combatAttack() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ARCANE",
	desc = "Aether residue",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 奥 术 伤 害， -10% 奥 术 抗 性， -10% 护 甲 强 度， -20% 石 化 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.ARCANE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ARCANE]=10})
		self:effectTemporaryValue(eff, "stone_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_armor_hardiness", -math.ceil(self:combatArmorHardiness() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_TEMPORAL",
	desc = "Impossible geometries",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 时 空 伤 害， -10% 时 空 抗 性， -10% 法 术 豁 免， -20% 定 身 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.TEMPORAL]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.TEMPORAL]=10})
		self:effectTemporaryValue(eff, "pin_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_spellresist", -math.ceil(self:combatSpellResist(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_PHYSICAL",
	desc = "Uncontrolled anger",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 物 理 伤 害 , -10% 物 理 抵 抗 , -10% 精 神 强 度 , -20% 击 退 免 疫。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.PHYSICAL]=10})
		self:effectTemporaryValue(eff, "knockback_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_mindpower", -math.ceil(self:combatMindpower() * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_BLIGHT",
	desc = "Miasma",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 枯 萎 伤 害， -10% 枯 萎 抗 性， -20% 治 疗 加 成， -20% 疾 病 抗 性。 ") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.BLIGHT]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.BLIGHT]=10})
		self:effectTemporaryValue(eff, "disease_immune", -0.2)
		self:effectTemporaryValue(eff, "healing_factor", -0.2)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_NATURE",
	desc = "Slimy floor",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("范 围 效 果： +10% 自 然 伤 害， -10% 自 然 抗 性， -10% 远 程 闪 避， -20% 毒 素 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.NATURE]=-10})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=10})
		self:effectTemporaryValue(eff, "poison_immune", -0.2)
		self:effectTemporaryValue(eff, "combat_def_ranged", -math.ceil(self:combatDefenseRanged(true) * 0.1))
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "VAULTED", image = "talents/time_prison.png",
	desc = "In Vault",
	long_desc = function(self, eff) return "目 标 陷 入 迷 宫， 不 能 做 任 何 动 作 直 到 走 出 迷 宫 为 止。" end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { vault=true },
	status = "neutral",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "dont_act", 1)
		self:effectTemporaryValue(eff, "no_timeflow", 1)
		self:effectTemporaryValue(eff, "status_effect_immune", 1)
		self.energy.value = 0
	end,
	deactivate = function(self, eff) --wake up vaulted npcs in LOS
	  self:computeFOV(5, nil, 
		function(x, y, dx, dy, sqdist)
			local act = game.level.map(x, y, Map.ACTOR)
			if act then
				act:removeEffect(act.EFF_VAULTED, true, true)
			end
		end, true, false, false)
	end,
}

newEffect{
	name = "CAUTERIZE", image = "talents/cauterize.png",
	desc = "Cauterize",
	long_desc = function(self, eff) return ("你 的 躯 体 开 始 灼 烧， 每 回 合 受 到 %0.2f 伤 害。"):format(eff.dam) end,
	type = "other",
	subtype = { fire=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#CRIMSON##Target# is wreathed in flames on the brink of death!", "+Cauterize" end,
	on_lose = function(self, err) return "#CRIMSON#The flames around #target# vanish.", "-Cauterize" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.dam = old_eff.dam + new_eff.dam
		return old_eff
	end,
	activate = function(self, eff)
		self.life = self.old_life or 10
		eff.invulnerable = true
		eff.particle1 = self:addParticles(Particles.new("inferno", 1))
		eff.particle2 = self:addParticles(Particles.new("inferno", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
	on_timeout = function(self, eff)
		if eff.invulnerable then
			eff.dur = eff.dur + 1
			return
		end
		local dead, val = self:takeHit(eff.dam, self, {special_death_msg="burnt to death by cauterize"})

		local srcname = self.x and self.y and game.level.map.seens(self.x, self.y) and self.name:capitalize() or "Something"
		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):format(DamageType:get(DamageType.FIRE).text_color or "#aaaaaa#", math.ceil(val), DamageType:get(DamageType.FIRE).name), false)
	end,
}

newEffect{
	name = "EIDOLON_PROTECT", image = "shockbolt/npc/unknown_unknown_the_eidolon.png",
	desc = "Protected by the Eidolon",
	long_desc = function(self, eff) return "目 标 受 到 艾 德 隆 保 护， 没 有 生 物 可 以 伤 害 它（ 自 残 除 外……） " end,
	zone_wide_effect = true,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { eidolon=true },
	status = "neutral",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "invulnerable_others", 1)
	end,
	deactivate = function(self, eff)
	end,
}


newEffect{
	name = "CLOAK_OF_DECEPTION", image = "shockbolt/object/artifact/black_cloak.png",
	desc = "Cloak of Deception",
	long_desc = function(self, eff) return "目 标 受 到 欺 诈 斗 篷 的 效 果 影 响， 使 它 看 上 去 像 活 着 一 样。" end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { undead=true },
	status = "neutral",
	parameters = {},
	on_gain = function(self, err) return ("#LIGHT_BLUE#An illusion appears around #Target# making %s appear human."):format(self:him_her()), "+CLOAK OF DECEPTION" end,
	on_lose = function(self, err) return "#LIGHT_BLUE#The illusion covering #Target# disappears.", "-CLOAK OF DECEPTION" end,
	activate = function(self, eff)
		self.old_faction_cloak = self.faction
		self.faction = "allied-kingdoms"
		if self.descriptor and self.descriptor.race and self:attr("undead") then self.descriptor.fake_race = "Human" end
		if self.descriptor and self.descriptor.subrace and self:attr("undead") then self.descriptor.fake_subrace = "Cornac" end
		if self.player then engine.Map:setViewerFaction(self.faction) end
	end,
	deactivate = function(self, eff)
		self.faction = self.old_faction_cloak
		if self.descriptor and self.descriptor.race and self:attr("undead") then self.descriptor.fake_race = nil end
		if self.descriptor and self.descriptor.subrace and self:attr("undead") then self.descriptor.fake_subrace = nil end
		if self.player then engine.Map:setViewerFaction(self.faction) end
	end,
}

newEffect{
	name = "SUFFOCATING",
	desc = "Suffocating",
	long_desc = function(self, eff) return ("你 正 在 窒 息 ! 每 回 合 按 比 例 损 失 生 命 ， 且 越 来 越 多 （ 现 在 %d%% ）"):format(eff.dam) end,
	type = "other",
	subtype = { suffocating=true },
	status = "detrimental",
	decrease = 0, no_remove = true,
	parameters = { dam=20 },
	on_gain = function(self, err) return "#Target# is suffocating!", "+SUFFOCATING" end,
	on_lose = function(self, err) return "#Target# can breathe again.", "-Suffocating" end,
	on_timeout = function(self, eff)
		if self.air > self.air_regen then -- We must be over our natural regen
			self:removeEffect(self.EFF_SUFFOCATING, false, true)
			return
		end

		-- Bypass all shields & such
		local old = self.onTakeHit
		self.onTakeHit = nil
		mod.class.interface.ActorLife.takeHit(self, self.max_life * eff.dam / 100, self, {special_death_msg="suffocated to death"})
		eff.dam = util.bound(eff.dam + 5, 20, 100)
		self.onTakeHit = old
	end,
}

newEffect{
	name = "ANTIMAGIC_DISRUPTION",
	desc = "Antimagic Disruption",
	long_desc = function(self, eff) return ("你 的 奥 术 能 量 被 反 魔 装 备 干 扰. "):format() end,
	type = "other",
	subtype = { antimagic=true },
	no_stop_enter_worlmap = true,
	status = "detrimental",
	decrease = 0, no_remove = true,
	parameters = { },
	on_timeout = function(self, eff)
		if not self:attr("has_arcane_knowledge") or not self:attr("spellpower_reduction") then
			self:removeEffect(self.EFF_ANTIMAGIC_DISRUPTION, true, true)
		end
	end,
}

newEffect{
	name = "SWIFT_HANDS_CD", image = "talents/swift_hands.png",
	desc = "Swift Hands",
	long_desc = function(self, eff) return "这 回 合 你 切 换 了 物 品 ， 没 有 消 耗 时 间 ." end,
	type = "other",
	subtype = { prodigy=true },
	status = "neutral",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "quick_wear_takeoff_disable", 1)
	end,
}

newEffect{
	name = "HUNTER_PLAYER", image = "talents/hunted_player.png",
	desc = "Hunter!",
	long_desc = function(self, eff) return "知 道 你 在 哪 里!" end,
	type = "other",
	subtype = { madness=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		if not self.ai_state then return end
		self:effectTemporaryValue(eff, {"ai_state","ai_move"}, "move_astar")
		self:setTarget(eff.src)
	end,
}

newEffect{
	name = "THROUGH_THE_CROWD", image = "talents/through_the_crowd.png",
	desc = "Through The Crowd",
	long_desc = function(self, eff) return ("增 加 物 理 、 法 术 、 精 神 豁 免 %d 点,增 加 整 体 速 度 %d%% 。"):format(eff.power * 10, util.bound(eff.power, 0, 5) * 3) end,
	type = "other",
	subtype = { miscellaneous=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.presid = self:addTemporaryValue("combat_physresist", eff.power * 10)
		eff.sresid = self:addTemporaryValue("combat_spellresist", eff.power * 10)
		eff.mresid = self:addTemporaryValue("combat_mentalresist", eff.power * 10)
		eff.speedid = self:addTemporaryValue("global_speed_add", util.bound(eff.power, 0, 5) * 0.03)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physresist", eff.presid)
		self:removeTemporaryValue("combat_spellresist", eff.sresid)
		self:removeTemporaryValue("combat_mentalresist", eff.mresid)
		self:removeTemporaryValue("global_speed_add", eff.speedid)
	end,
}

newEffect{
	name = "RELOAD_DISARMED", image = "talents/disarm.png",
	desc = "Reloading",
	long_desc = function(self, eff) return "目 标 装 填 弹 药 中。" end,
	type = "other",
	subtype = { disarm=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is disarmed!", "+Disarmed" end,
	on_lose = function(self, err) return "#Target# rearms.", "-Disarmed" end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_COUNTER_ATTACKING) -- Cannot parry or counterattack while disarmed
		self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) 
		eff.tmpid = self:addTemporaryValue("disarmed", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("disarmed", eff.tmpid)
	end,
}

newEffect{
	name = "SPACETIME_TUNING", image = "talents/spacetime_tuning.png",
	desc = "Spacetime Tuning",
	long_desc = function(self, eff) return ("调 整 紊 乱 值 ， 每 回 合 调 整 %d 点。"):format(eff.power) end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10},
	on_gain = function(self, err) return "#Target# retunes the fabric of spaceime.", "+Spacetime Tuning" end,
	on_timeout = function(self, eff)
		local dox = self:getParadox() - self.preferred_paradox
		local fix = math.min( math.abs(dox), eff.power )
		self:incParadox(fix)
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=2.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=1.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "TIME_STOP", image = "talents/time_stop.png",
	desc = "Time Stop",
	long_desc = function(self, eff)
		return ("目 标 停 止 了 时 间 ， 期 间 造 成 的 伤 害 减 少 %d%%。"):format(eff.power)
	end,
	charges = function(self, eff)
		local charges = math.floor(self.energy.value/1000) - 1
		if charges <= 0 then
			self:removeEffect(self.EFF_TIME_STOP)
		end
		return charges
	end,
	type = "other",
	subtype = {time=true},
	status = "detrimental",
	parameters = {power=50},
	remove_on_clone = true,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "generic_damage_penalty", eff.power)
		self:effectTemporaryValue(eff, "timestopping", 1)
		self.no_leave_control = true
		core.display.pauseAnims(true)
		
		-- clone protection
		if self.player then
			self:updateMainShader()
		end
	end,
	deactivate = function(self, eff)
		self.no_leave_control = false
		core.display.pauseAnims(false)
		
		-- clone protection
		if self == game.player then
			self:updateMainShader()
		end
	end,
}

newEffect{
	name = "TEMPORAL_REPRIEVE", image = "talents/temporal_reprieve.png",
	desc = "Temporal Reprieve",
	long_desc = function(self, eff) return ("目 标 被 传 送 至 安 全 位 置。"):format() end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=1 },
	on_timeout = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		-- Clone protection
		if not self.on_die then return end
		-- Return from the reprieve
		game:onTickEnd(function()
			-- Collect objects
			local objs = {}
			for i = 0, game.level.map.w - 1 do for j = 0, game.level.map.h - 1 do
				for z = game.level.map:getObjectTotal(i, j), 1, -1 do
					objs[#objs+1] = game.level.map:getObject(i, j, z)
					game.level.map:removeObject(i, j, z)
				end
			end end

			local oldzone = game.zone
			local oldlevel = game.level
			local zone = game.level.source_zone
			local level = game.level.source_level

			if not self.dead then
				oldlevel:removeEntity(self)
				level:addEntity(self)
			end

			game.zone = zone
			game.level = level
			game.zone_name_s = nil

			local x1, y1 = util.findFreeGrid(eff.x, eff.y, 20, true, {[Map.ACTOR]=true})
			if x1 then
				if not self.dead then
					self:move(x1, y1, true)
					self.on_die, self.temporal_reprieve_on_die = self.temporal_reprieve_on_die, nil
					game.level.map:particleEmitter(x1, y1, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					self.x, self.y = x1, y1
				end
			end

			-- Add objects back
			for i, o in ipairs(objs) do
				game.level.map:addObject(self.x, self.y, o)
			end

			-- Remove all npcs in the reprieve
			for uid, e in pairs(oldlevel.entities) do
				if e ~= self and e.die then e:die() end
			end

			-- Reload MOs
			game.level.map:redisplay()
			game.level.map:recreate()
			game.uiset:setupMinimap(game.level)
			game.nicer_tiles:postProcessLevelTilesOnLoad(game.level)

			game.logPlayer(game.player, "#STEEL_BLUE#You are brought back from your repreive!")

		end)
	end,
}

newEffect{
	name = "TEMPORAL_FUGUE", image = "talents/temporal_fugue.png",
	desc = "Temporal Fugue",
	long_desc = function(self, eff) return "目 标 将 伤 害 和 复 制 体 共 享。" end,
	type = "other",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=10 },
	decrease = 0,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if src ~= self and src:hasEffect(src.EFF_TEMPORAL_FUGUE) then
			-- Find our clones
			for i = 1, #eff.targets do
				local target = eff.targets[i]
				if target == self then dam = 0 end
			end
		end
		return {dam=dam}
	end,
	callbackOnHit = function(self, eff, cb, src)
		if cb.value <= 0 then return cb.value end
		
		local clones = {}
		-- Find our clones
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if not target.dead and game.level:hasEntity(target) then
				clones[#clones+1] = target
			end
		end
		
		-- Split the damage
		if #clones > 0 and not self.turn_procs.temporal_fugue_damage then
			self.turn_procs.temporal_fugue_damage = true
			cb.value = cb.value/#clones
			game:delayedLogMessage(self, nil, "fugue_damage", "#STEEL_BLUE##Source# shares damage with %s fugue clones!", string.his_her(self))
			for i = 1, #clones do
				local target = clones[i]
				if target ~= self then
					target.turn_procs.temporal_fugue_damage = true
					target:takeHit(cb.value, src)
					game:delayedLogDamage(src or self, self, 0, ("#STEEL_BLUE#(%d shared)#LAST#"):format(cb.value), nil)
					target.turn_procs.temporal_fugue_damage = nil
				end
			end
			
			self.turn_procs.temporal_fugue_damage = nil
		end
		
		-- If we're the last clone remove the effect
		if #clones <= 0 then
			self:removeEffect(self.EFF_TEMPORAL_FUGUE)
		end
		
		return cb.value
	end,
	on_timeout = function(self, eff)
		-- Temporal Fugue does not cooldown while active
		if self.talents_cd[self.T_TEMPORAL_FUGUE] then
			self.talents_cd[self.T_TEMPORAL_FUGUE] = self.talents_cd[self.T_TEMPORAL_FUGUE] + 1
		end
	
		local alive = false
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if target ~=self and not target.dead then
				alive = true
				break
			end
		end
		if not alive then
			self:removeEffect(self.EFF_TEMPORAL_FUGUE)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "generic_damage_penalty", 66)
	end,
}

newEffect{
	name = "DRACONIC_WILL", image = "talents/draconic_will.png",
	desc = "Draconic Will",
	long_desc = function(self, eff) return "目 标 免 疫 负 面效 果." end,
	type = "other",
	subtype = { nature=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target#'s skin hardens.", "+Draconic Will" end,
	on_lose = function(self, err) return "#Target#'s skin is back to normal.", "-Draconic Will" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "REALITY_SMEARING", image = "talents/reality_smearing.png",
	desc = "Reality Smearing",
	long_desc = function(self, eff) return ("过 去 受 到 的 伤 害 被 转 化 为 每 回 合 %0.2f 点 紊 乱。"):format(eff.paradox) end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { paradox=10 },
	on_gain = function(self, err) return "#Target# converts damage into paradox.", "+Smearing" end,
	on_lose = function(self, err) return "#Target# stops converting damage to paradox..", "-Smearing" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local oldparadox = old_eff.paradox * old_eff.dur
		local newparadox = new_eff.paradox * new_eff.dur
		old_eff.paradox = (oldparadox + newparadox) / new_eff.dur
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		self:incParadox(eff.paradox)
	end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="transparent_cylinder", scrollingSpeed=0.0002, density=15, radius=1.6, growSpeed=0.004, img="continuum_01_5"})
		else
			eff.particle1 = self:addParticles(Particles.new("time_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "AEONS_STASIS",
	desc = "Aeons Stasis",
	long_desc = function(self, eff) return "目标处于静态时空中。" end,
	type = "other", decrease = 0, no_remove = true,
	subtype = { temporal=true },
	status = "beneficial",
	on_lose = function(self, err) return "#Target#'s is back to the normal timeflow.", "-Aeons Stasis" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "status_effect_immune", 1)
		self:effectTemporaryValue(eff, "invulnerable", 1)
		self:effectTemporaryValue(eff, "cant_be_moved", 1)
		self.never_act = true
		eff.old_faction = self.faction
		self.faction = "neutral"
	end,
	deactivate = function(self, eff)
		self.faction = eff.old_faction
		self.never_act = nil
		self:disappear(self)
		local e = game.zone:makeEntity(game.level, "actor", {type="giant", subtype="ogre", special_rarity="special_rarity"}, nil, true)
		local x, y = util.findFreeGrid(self.x, self.y, 10, true, {[Map.ACTOR]=true})
		if e and x then
			game.zone:addEntity(game.level, e, "actor", x, y)

			local og = game.level.map(x, y, Map.TERRAIN)
			if not og or (not og.special and not og.change_level) then
				local g = game.zone.grid_list[self.to_vat]
				if g then game.zone:addEntity(game.level, g, "terrain", x, y) end
			end
			
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
			game.level.map:particleEmitter(x, y, 1, "goosplosion")
		end
	end,
	on_timeout = function(self, eff)
		if eff.timeout then
			eff.timeout = eff.timeout - 1
			if eff.timeout <= 0 then
				self:removeEffect(self.EFF_AEONS_STASIS, nil, true)
			end
		end
	end,
}

newEffect{
	name = "UNSTOPPABLE", image = "talents/unstoppable.png",
	desc = "Unstoppable",
	long_desc = function(self, eff) return ("目 标 无 可 阻 挡 ！ 拒 绝 死 亡 ， 效 果 结 束 时 回 复 %d 生 命(每 杀 一 个 怪 回 复 %d%% 最 大 生 命 )。"):format(eff.kills * eff.hp_per_kill * self.max_life / 100, eff.hp_per_kill) end,
	type = "other",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { hp_per_kill=2 },
	activate = function(self, eff)
		eff.kills = 0
		eff.tmpid = self:addTemporaryValue("unstoppable", 1)
		eff.healid = self:addTemporaryValue("no_life_regen", 1)
		eff.nohealid = self:addTemporaryValue("no_healing", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("unstoppable", eff.tmpid)
		self:removeTemporaryValue("no_life_regen", eff.healid)
		self:removeTemporaryValue("no_healing", eff.nohealid)
		self:heal(eff.kills * eff.hp_per_kill * self.max_life / 100, eff)
	end,
}

newEffect{
	name = "2H_PENALTY", image = "talents/unstoppable.png",
	desc = "Hit Penalty",
	long_desc = function(self, eff) return ("目 标 单 手 使 用 双 手 武 器 ， 物 理 、 法 术 、 精 神 强 度 下 降 %d%% ( 受 体 型 影 响 )；同 时 副 手附  加伤 害 减 少 50%%。"):format(20 - math.min(self.size_category - 4, 4) * 5) end,
	type = "other", decrease = 0, no_remove = true,
	subtype = { combat=true, penalty=true },
	status = "detrimental",
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "hit_penalty_2h", 1)
	end,
}

newEffect{
	name = "TWIST_FATE", image = "talents/twist_fate.png",
	desc = "Twist Fate",
	long_desc = function(self, eff) 
		local t = self:getTalentFromId(eff.talent)
		return 
		([[当 前 异 常： %s
		
		%s]]):format(t.name or "none", t.info(self, t) or "none")
	end,
	type = "other",
	subtype = { time=true },
	status = "detrimental",
	parameters = { paradox=0, twisted=false },
	on_gain = function(self, err) return nil, "+Twist Fate" end,
	on_lose = function(self, err) return nil, "-Twist Fate" end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="fast_sphere", appear=10, radius=1.6, twist=30, density=30, growSpeed=0.004, scrollingSpeed=-0.004, img="continuum_01_3"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		if not game.zone.wilderness and not self.dead then
			if not eff.twisted then
				self:forceUseTalent(eff.talent, {force_target=self, ignore_energy=true})
				-- manually use energy
				local anom = self:getTalentFromId(eff.talent)
				self:useEnergy(self:getTalentSpeed(anom) * game.energy_to_act)
				
				game:playSoundNear(self, "talents/dispel")
				self:incParadox(-eff.paradox)
			end
		end
	end,
}

-- Dummy effect for particles
newEffect{
	name = "WARDEN_S_TARGET", image = "talents/warden_s_focus.png",
	desc = "Warden's Focus Target",
	long_desc = function(self, eff) return ("%s 被 选 为 目 标."):format(eff.src.name) end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {},
	remove_on_clone = true, decrease = 0,
	on_gain = function(self, err) return nil, "+Warden's Focus" end,
	on_lose = function(self, err) return nil, "-Warden's Focus" end,
	on_timeout = function(self, eff)
		local p = eff.src:hasEffect(eff.src.EFF_WARDEN_S_FOCUS)
		if not p or p.target ~= self or eff.src.dead or not game.level:hasEntity(eff.src) or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 10 then
			self:removeEffect(self.EFF_WARDEN_S_TARGET)
		end
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={299/255, 0/255, 0/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={229/255, 0/255, 0/255, 1}, circleColor={0.8,0,0,0.8}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "DEATH_DREAM", image = "talents/sleep.png",
	desc = "Death in a Dream",
	type = "other", subtype={mind=true},
	status = "detrimental",
	long_desc = function(self, eff) return ("目 标 吸 入 有 毒 的 催 眠 气 体 ， 每 回 合 损 失 %d 生 命 。"):format(eff.power) end,
	on_timeout = function(self, eff)
		local dead, val = self:takeHit(eff.power, self, {special_death_msg="killed in a dream"})
		game:delayedLogDamage(eff, self, val, ("%s%d %s#LAST#"):format(DamageType:get(DamageType.MIND).text_color or "#aaaaaa#", math.ceil(val), "睡梦"), false)
	end,
}

newEffect{
	name = "ZONE_AURA_GORBAT",
	desc = "Natural Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : +20 精 神 强 度 , +2 生 命 恢 复 , -1 失 衡 值 / 回 合, -20% 抗 性 穿 透。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_mindpower", 20)
		self:effectTemporaryValue(eff, "life_regen", 2)
		self:effectTemporaryValue(eff, "equilibrium_regen", -1)
		self:effectTemporaryValue(eff, "resists_pen", {all=-20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_VOR",
	desc = "Sorcerous Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : +20 魔 法 , +2 法 力 回 复 , -20 命 中, -20 潜 行 强 度 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stats", {[Stats.STAT_MAG] = 20})
		self:effectTemporaryValue(eff, "mana_regen", 2)
		self:effectTemporaryValue(eff, "combat_atk", -20)
		self:effectTemporaryValue(eff, "inc_stealth", -20)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_GRUSHNAK",
	desc = "Disciplined Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : +20 闪 避, +20 全 豁 免 , -20 法 术 强 度 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_def", 20)
		self:effectTemporaryValue(eff, "combat_physresist", 20)
		self:effectTemporaryValue(eff, "combat_spellresist", 20)
		self:effectTemporaryValue(eff, "combat_mentalresist", 20)
		self:effectTemporaryValue(eff, "combat_spellpower", -20)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_RAKSHOR",
	desc = "Sinister Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : +10% 暴 击 几 率 , +20% 暴 击 伤 害 , -20% 自 然 枯 萎 抗 性 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physcrit", 10)
		self:effectTemporaryValue(eff, "combat_spellcrit", 10)
		self:effectTemporaryValue(eff, "combat_mindcrit", 10)
		self:effectTemporaryValue(eff, "combat_critical_power", 20)
		self:effectTemporaryValue(eff, "resists", {[DamageType.NATURE]=-20, [DamageType.BLIGHT]=-20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_UNDERWATER",
	desc = "Underwater Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 :  空 气 值 随 时 间 损 失 ， 空 气 用 光 后 将 损 失 生 命 。 寻 找 气 泡 来 回 复 空 气 值。 水 同 时 令 震 慑 免 疫 和 火 焰 伤 害 下 降 10% ，同 时 增 加 10% 寒 冷 伤 害 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stun_immune", -0.1)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.COLD]=10, [DamageType.FIRE]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_FEARSCAPE",
	desc = "Fearscape Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 :  恐 惧 空 间 的 火 焰 将 增 加 10% 火 焰 和 枯 萎 伤 害 ，同 时 减 少 20% 击 退 抗 性。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "knockback_immune", -0.2)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.BLIGHT]=10, [DamageType.FIRE]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_OUT_OF_TIME",
	desc = "Out of Time Zone",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : 你 似 乎 处 于 通 常 时 空 之 外 。 +10% 物 理 抗 性 ， -10% 时 空 抗 性  , -20% 传 送 免 疫 .") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "teleport_immune", -0.2)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=10, [DamageType.TEMPORAL]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_SPELLBLAZE",
	desc = "Spellblaze Aura",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : 魔 法 大 爆 炸 的 火 焰 仍 在 燃 烧 ， -10% 火 焰 、 枯 萎 、 奥 术 抗 性 , +10% 寒 冷 抗 性 。 警 告 ：强 大 的 魔 法 能 量 可 能 干 扰 传 送 法 术 ！ ") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.FIRE]=-10, [DamageType.ARCANE]=-10, [DamageType.BLIGHT]=-10, [DamageType.COLD]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_CALDERA",
	desc = "Heady Scent",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 :  强 烈 的 气 味 充 满 了 空 气 ， 让 你 感 觉 困 倦 。  倒 计 时 结 束 时 ， 你 将 进 入 梦 境 。-10% 精 神 抗 性 ，-20% 睡 眠 免 疫 ， +10% 自 然 伤 害 .") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "sleep_immune", -0.2)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=10})
		self:effectTemporaryValue(eff, "resists", {[DamageType.MIND]=-10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_THUNDERSTORM",
	desc = "Thunderstorm",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 :  强 大 的 雷 暴 在 你 头 顶 轰 鸣。 +10% 闪 电 伤 害 ， -10% 震 慑 免 疫 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stun_immune", -0.1)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHTNING]=10})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_ABASHED",
	desc = "Abashed Expanse",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) return ("地 图 效 果 : 你 的 相 位 之 门 法 术 在 这 里 极 其 容 易 施 展 ， 不 论 等 级 如 何 ，都 能 指 定 位 置 。") end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "detrimental",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ZONE_AURA_CHALLENGE",
	desc = "Challenge",
	no_stop_enter_worlmap = true,
	long_desc = function(self, eff) if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return "???" else return self:hasQuest(eff.id_challenge_quest).name end end,
	decrease = 0, no_remove = true,
	type = "other",
	subtype = { aura=true },
	status = "neutral",
	zone_wide_effect = true,
	parameters = {},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_exit_level", self)
	end,
	callbackOnKill = function(self, eff, who, death_note)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_kill_foe", self, who)
	end,
	callbackOnActBase = function(self, eff)
		if not eff.id_challenge_quest or not self:hasQuest(eff.id_challenge_quest) then return end
		self:hasQuest(eff.id_challenge_quest):check("on_act_base", self)
	end,
}

newEffect{
	name = "THROWING_KNIVES", image = "talents/throwing_knives.png",
	desc = "Throwing Knives",  decrease = 0,
	display_desc = function(self, eff) return eff.stacks.." Knives" end,
	long_desc = function(self, eff) return ("Has %d throwing knives prepared:\n\n%s"):format(eff.stacks, self:callTalent(self.T_THROWING_KNIVES, "knivesInfo")) end,
	type = "other",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { stacks=1, max_stacks=6 },
	charges = function(self, eff) return eff.stacks end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.max_stacks = new_eff.max_stacks
		old_eff.stacks = util.bound(old_eff.stacks + new_eff.stacks, 0, new_eff.max_stacks)
		return old_eff
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

--while strictly speaking these fit better as physical effects, the ability for a mob to layer 3 different physical debuffs on a player with one swing and block off clearing stuns via wild infusions is not good. bad enough that they can bleed/poison

newEffect{
	name = "SCOUNDREL", image = "talents/scoundrel.png",
	desc = "Scoundrel's Strategies",
	long_desc = function(self, eff) return ("The target is suffering from disabling wounds, reducing their critical strike chance by %d%%."):
		format( eff.power ) end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = { power=1 },
	activate = function(self, eff)
		eff.cur_pcrit = -eff.power
		eff.cur_scrit = -eff.power
		eff.cur_mcrit = -eff.power

		eff.pcritid = self:addTemporaryValue("combat_physcrit", eff.cur_pcrit)
		eff.scritid = self:addTemporaryValue("combat_spellcrit", eff.cur_scrit)
		eff.mcritid = self:addTemporaryValue("combat_mindcrit", eff.cur_mcrit)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physcrit", eff.pcritid)
		self:removeTemporaryValue("combat_spellcrit", eff.scritid)
		self:removeTemporaryValue("combat_mindcrit", eff.mcritid)
	end,
}

newEffect{
	name = "FUMBLE", image = "talents/fumble.png",
	desc = "Fumble",
	long_desc = function(self, eff) return ("The target is suffering from distracting wounds, and has a %d%% chance to fail to use a talent and injure itself for %d physical damage."):
		format( eff.power*eff.stacks, eff.dam ) end,
	charges = function(self, eff) return eff.stacks end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	charges = function(self, eff) return eff.stacks or 1 end,
	parameters = { power=1, dam=10, stacks = 0, max_stacks=10 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		
		local stackCount = old_eff.stacks + new_eff.stacks
		if stackCount >= old_eff.max_stacks then 
			stackCount = old_eff.max_stacks
		end
		
		self:removeTemporaryValue("scoundrel_failure", old_eff.failid)
		old_eff.failid = self:addTemporaryValue("scoundrel_failure", old_eff.cur_fail*stackCount)
		
		old_eff.stacks = stackCount
		
		return old_eff
		
	end,
	activate = function(self, eff)
		eff.cur_fail = eff.power
		eff.failid = self:addTemporaryValue("scoundrel_failure", eff.cur_fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("scoundrel_failure", eff.failid)
	end,
	callbackOnTalentDisturbed = function(self, eff, t)
		if self:attr("scoundrel_failure") then
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam)
			self:removeEffect(self.EFF_FUMBLE)
		end
	end,
}


newEffect{
	name = "TOUCH_OF_DEATH", image = "talents/touch_of_death.png",
	desc = "Touch of Death",
	long_desc = function(self, eff) return ("The target is taking %0.2f physical damage each turn. If they die while under this effect, they will explode!"):format(eff.dam) end,
	type = "other", --extending this would be very bad
	subtype = {  },
	status = "detrimental",
	parameters = { dur=4, dam=10, power=20, radius=1, combo=1 },
	on_gain = function(self, err) return "#Target# is mortally wounded!", "+Touch of Death!" end,
	on_lose = function(self, err) return "#Target# overcomes the touch of death.", "-Touch of Death" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam)
		eff.dam = eff.dam * (1 + eff.mult)
	end,
	on_die = function(self, eff)
		eff.src:buildCombo()
		eff.src:buildCombo()
		eff.src:buildCombo()
		eff.src:buildCombo()
		local tg = {type="ball", radius=eff.radius, selffire=false, x=self.x, y=self.y}
		local dam = self.max_life * eff.power / self.rank
		eff.src:project(tg, self.x, self.y, DamageType.PHYSICAL, dam, {type="bones"})
		game.logSeen(eff.src, "#LIGHT_RED#%s explodes into a shower of gore!", self.name:capitalize())
		self:removeEffect(self.EFF_TOUCH_OF_DEATH)
	end,
}

newEffect{
	name = "MARKED", image = "talents/master_marksman.png",
	desc = "Marked",
	long_desc = function(self, eff) return ("Target is marked, leaving them vulnerable to marked shots."):format() end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Marked!" end,
	on_lose = function(self, err) return nil, "-Marked" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("circle", 1, {base_rot=1, oversize=1.0, a=200, appear=8, speed=0, img="marked", radius=0}))
		self:effectTemporaryValue(eff, "marked", 1)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
--	on_die = function(self,eff)
--		if eff.src and eff.src:knowTalent(eff.src.T_FIRST_BLOOD) then eff.src:incStamina(eff.src:callTalent(eff.src.T_FIRST_BLOOD, "getStamina")) end
--	end,
}

newEffect{
	name = "FLARE",
	desc = "Flare", image = "talents/flare_raz.png",
	long_desc = function(self, eff) return ("The target is lit up by a flare, reducing its stealth and invisibility power by %d, defense by %d and removing all evasion bonus from being unseen."):format(eff.power, eff.power) end,
	type = "other",
	subtype = { sun=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return nil, "+Illumination" end,
	on_lose = function(self, err) return nil, "-Illumination" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stealth", -eff.power)
		if self:attr("invisible") then self:effectTemporaryValue(eff, "invisible", -eff.power) end
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
		self:effectTemporaryValue(eff, "blind_fighted", 1)
	end,
}

newEffect{
	name = "PIN_DOWN",
	desc = "Pinned Down", image = "talents/pin_down.png",
	long_desc = function(self, eff) return ("The next Steady Shot or Shoot has 100%% chance to be a critical hit and mark."):format() end,
	type = "other",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {power = 1},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}
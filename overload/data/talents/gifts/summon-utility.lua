-- FIXME this is the 166-summoner-fix, remove it for 1.6.7!
-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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
	name = "Taunt",
	type = {"technique/other",1},
	points = 1,
	cooldown = 5,
	requires_target = false,
	tactical = { PROTECT = 10 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
		self:project(tg, self.x, self.y, function(tx, ty)
			local a = game.level.map(tx, ty, Map.ACTOR)
			if a then
				a:setTarget(self)
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[Forces all hostile foes in radius %d to attack you.]]):format(self:getTalentRadius(t))
	end,
}


newTalent{
	name = "Shell Shield",
	type = {"technique/other",1},
	points = 5,
	cooldown = 10,
	tactical = { DEFEND = 2 },
	resistPower = function(self, t) return self:combatTalentScale(t, 41, 69) end,
	getDuration = function(self, t)	return math.ceil(self:combatTalentScale(t, 4.7, 7.5)) end,
	action = function(self, t)
		self:setEffect(self.EFF_SHELL_SHIELD, t.getDuration(self, t), {power=t.resistPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[Under the cover of your shell, gain %d%% all resistance for %d turns]]):format(t.resistPower(self, t), t.getDuration(self, t))
	end,
}

newTalent{ short_name="SPIDER_WEB",
	name = "Web",
	type = {"wild-gift/other",1},
	points = 5,
	equilibrium = 5,
	cooldown = 3,
	range=7,
	tactical = { DISABLE = { pin = 2 } },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if target and target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[Spread a web and throw it toward your target. If caught, it won't be able to move for %d turns.]]):format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Turtle",
	type = {"wild-gift/summon-utility", 1},
	require = gifts_req1,
	random_ego = "attack",
	points = 5,
	message = "@Source@ summons a Turtle!",
	equilibrium = 2,
	cooldown = 10,
	range = 5,
	radius = 5, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { DEFEND = 2, PROTECT = 2 }, -- handle healing?
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y, ignore_nullify_all_friendlyfire=true}
		local shellShielding = self:callTalent(self.T_DETONATE,"shellShielding")
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:setEffect(target.EFF_SHELL_SHIELD, 5, {power=self:mindCrit(shellShielding)})
		end, nil, {type="flame"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 5, 0, 10, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{
			con=15 + (fake and mp or self:mindCrit(mp)) * 2.1 * self:combatTalentScale(t, 0.2, 1, 0.75),
			wil = 18,
			dex=10 + self:combatTalentScale(t, 2, 10, 0.75)
		}
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y, ignore_nullify_all_friendlyfire=true}
		local healing = self:callTalent(self.T_GRAND_ARRIVAL,"amtHealing")
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:attr("allow_on_heal", 1)
			target:heal(healing, m)
			target:attr("allow_on_heal", -1)
			if core.shader.active(4) then
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=true,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				target:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
		end)
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = self.ai_target.actor
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "animal", subtype = "turtle",
			display = "R", color=colors.GREEN, image = "npc/summoner_turtle.png",
			name = "turtle", faction = self.faction,
			desc = [[]],
			autolevel = "none",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},
			ai_tactic = resolvers.tactic"default",
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = 100,
			life_rating = 14,
			infravision = 10,

			combat_armor = 10, combat_def = 0,
			combat = { dam=1, atk=1, },

			wild_gift_detonate = t.id,

			resolvers.talents{
				[self.T_TAUNT]=self:getTalentLevelRaw(t),
				[self.T_SHELL_SHIELD]=self:getTalentLevelRaw(t),
			},

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.talents{ [self.T_BATTLE_CALL]=self:getTalentLevelRaw(t) }
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		m:forceUseTalent(m.T_TAUNT, {ignore_energy=true})

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[Summon a Turtle for %d turns to distract your foes. Turtles are resilient, but not very powerful. However, they will periodically force any foes to attack them, and can protect themselves with their shell.
		It will get %d Constitution, %d Dexterity and 18 willpower.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Constitution will increase with your Mindpower.]])
		:format(t.summonTime(self, t), incStats.con, incStats.dex)
	end,
}

newTalent{
	name = "Spider",
	type = {"wild-gift/summon-utility", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = "@Source@ summons a Spider!",
	equilibrium = 5,
	cooldown = 10,
	range = 5,
	radius = 5, -- used by the the AI as additional range to the target
	requires_target = true,
	is_summon = true,
	target = SummonTarget,
	onAIGetTarget = onAIGetTargetSummon,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { ATTACK = {NATURE = 1}, DISABLE = { pin = 1 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "You cannot summon; you are suppressed!") return end
		return not checkMaxSummon(self, silent)
	end,
	on_pre_use_ai = aiSummonPreUse,
	on_detonate = function(self, t, m)
		local knockbackDist = self:callTalent(self.T_DETONATE,"spiderKnockback")
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.FEARKNOCKBACK, {dist=knockbackDist, x=m.x, y=m.y}, {type="acid"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_PINNED, check_immune="pin", dur=duration, p={}}, {type="slime"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), 5, 0, 10, 5)) + self:callTalent(self.T_RESILIENCE, "incDur") end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{
			dex=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75),
			wil = 18,
			str=10 + self:combatTalentScale(t, 2, 10, 0.75),
			con=10
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = self.ai_target.actor
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "animal", subtype = "spider",
			display = "S", color=colors.LIGHT_DARK, image = "npc/spiderkin_spider_giant_spider.png",
			name = "giant spider", faction = self.faction,
			desc = [[]],
			autolevel = "none",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, ally_compassion=10},
			ai_tactic = resolvers.tactic"ranged",
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = 50,
			life_rating = 10,
			infravision = 10,

			combat_armor = 0, combat_def = 0,
			combat = { dam=resolvers.rngavg(20,25), atk=16, apr=9, damtype=DamageType.NATURE, dammod={dex=1.2} },

			wild_gift_detonate = t.id,

			resolvers.talents{
				[self.T_SPIDER_WEB]=self:getTalentLevelRaw(t),
				[self.T_SPIT_POISON]=self:getTalentLevelRaw(t),
			},

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.inscription("INFUSION:_INSIDIOUS_POISON", {cooldown=12, range=6, heal_factor=60, power=self:getTalentLevel(t) * 60})
		end
		m.is_nature_summon = true
		setupSummon(self, m, x, y)

		if self:knowTalent(self.T_RESILIENCE) then
			local incLife = self:callTalent(self.T_RESILIENCE, "incLife") + 1
			m.max_life = m.max_life * incLife
			m.life = m.max_life
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[Summon a Spider for %d turns to harass your foes. Spiders can poison your foes and throw webs to pin them to the ground.
		It will get %d Dexterity, %d Strength, 18 Willpower and %d Constitution.
		Your summons inherit some of your stats: increased damage%%, resistance penetration %%, stun/pin/confusion/blindness resistance, armour penetration.
		Their Dexterity will increase with your Mindpower.]])
		:format(t.summonTime(self, t), incStats.dex, incStats.str, incStats.con)
	end,
}

newTalent{
	name = "Frantic Summoning",
	type = {"wild-gift/summon-utility", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 5,
	cooldown = 25,
	no_energy = true,
	on_pre_use_ai = aiSummonPreUse,
	aiSummonGrid = aiSummonGridRanged,
	tactical = { BUFF = 0.2 },
	getReduc = function(self, t) return self:combatTalentLimit(t, 100, 25, 75)  end, -- Limit <100%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 2.7, 5.6)) end, -- Limit <25
	action = function(self, t)
		self:setEffect(self.EFF_FRANTIC_SUMMONING, t.getDuration(self, t), {power=t.getReduc(self, t)})
		return true
	end,
	info = function(self, t)
		local reduc = t.getReduc(self, t)
		return ([[You focus yourself on nature, allowing you to summon natural creatures much faster (%d%% of a normal summon time) and with no chance to fail from high equilibrium for %d turns.
		When activating this power, a random summoning talent will come off cooldown.
		Each time you summon, the duration of the frantic summoning effect will reduce by 1.]]):
		format(100 - reduc, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Pheromones",
	short_name = "SUMMON_CONTROL", --Backwards compatibility
	type = {"wild-gift/summon-utility", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 7,
	cooldown = 10,
	tactical = { DISABLE = 2 },
	no_energy = true,
	requires_target = true,
	range = 10,
	direct_hit = true,
	getRad = function(self, t) return self:combatTalentScale(t, 3, 7) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5.5)) end,
	getDamage = function(self, t) return 10 + self:combatTalentMindDamage(t, 10, 25) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTargetLimited(tg)
		if not target or target == self then return nil

		else
			target:setEffect(target.EFF_SUMMON_CONTROL, t.getDur(self, t), {range=t.getRad(self,t), src=self, power=t.getDamage(self,t)})
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[Mark a creature with pheromones, signalling to all of your summons within %d tiles to shift aggression towards the marked creature for %d turns. Marked targets will receive %d%% increased damage from your summons and your summons will change target to it.
		The increased damage from your summons will increase with your Mindpower]]):format(t.getRad(self,t), t.getDur(self,t), t.getDamage(self,t))
	end,
}

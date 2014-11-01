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
	name = "War Hound",
	type = {"wild-gift/summon-melee", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	message = "@Source@ 召唤了战争猎犬!",
	equilibrium = 3,
	cooldown = 15,
	range = 5,
	requires_target = true,
	is_summon = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.PHYSICAL, self:mindCrit(self:combatTalentMindDamage(t, 30, 250)), {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_LOWER_PHYSICAL_RESIST, dur=duration, p={power=self:combatTalentMindDamage(t, 15, 70)}})
		game.level.map:particleEmitter(m.x, m.y, tg.radius, "shout", {size=4, distorion_factor=0.3, radius=tg.radius, life=30, nb_circles=8, rm=0.8, rM=1, gm=0.8, gM=1, bm=0.1, bM=0.2, am=0.6, aM=0.8})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 5, 0, 10, 5)) end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{ 
			str=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			dex=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			con=15 + self:callTalent(self.T_RESILIENCE, "incCon")
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "没有足够的召唤空间！")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "animal", subtype = "canine",
			display = "C", color=colors.LIGHT_DARK, image = "npc/summoner_wardog.png",
			name = "war hound", faction = self.faction,
			desc = [[]],
			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=5, },
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			level_range = {self.level, self.level}, exp_worth = 0,
			global_speed_base = 1.2,

			max_life = resolvers.rngavg(25,50),
			life_rating = 6,
			infravision = 10,

			combat_armor = 2, combat_def = 4,
			combat = { dam=self:getTalentLevel(t) * 10 + rng.avg(12,25), atk=10, apr=10, dammod={str=0.8} },

			wild_gift_detonate = t.id,

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.talents{ [self.T_TOTAL_THUGGERY]=self:getTalentLevelRaw(t) }
		end
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 战 争 猎 犬 来 攻 击 敌 人， 持 续 %d 回 合。 
		 战 争 猎 犬 是 非 常 好 的 基 础 近 战 单 位。 
		 它 拥 有 %d 点 力 量， %d 点 敏 捷 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 猎 犬 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.dex, incStats.con)
	end,
}

newTalent{
	name = "Jelly",
	type = {"wild-gift/summon-melee", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = "@Source@ 召唤了果冻怪!",
	equilibrium = 2,
	cooldown = 10,
	range = 5,
	requires_target = true,
	is_summon = true,
	tactical = { ATTACK = { NATURE = 1 }, EQUILIBRIUM = 1, },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.SLIME, self:mindCrit(self:combatTalentMindDamage(t, 30, 200)), {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_LOWER_NATURE_RESIST, dur=duration, p={power=self:combatTalentMindDamage(t, 15, 70)}}, {type="flame"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 5, 0, 10, 5)) end,
	incStats = function(self, t, fake)
		local mp = self:combatMindpower()
		return{ 
			con=10 + (fake and mp or self:mindCrit(mp)) * 1.8 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(self:getTalentLevel(self.T_RESILIENCE), 3, 15, 0.75),
			str=10 + self:combatTalentScale(t, 2, 10, 0.75)
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "没有足够的召唤空间！")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "immovable", subtype = "jelly", image = "npc/jelly-darkgrey.png",
			display = "j", color=colors.BLACK,
			desc = "A strange blob on the dungeon floor.",
			name = "black jelly",
			autolevel = "none", faction=self.faction,
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			resists = { [DamageType.LIGHT] = -50 },
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=5, },
			level_range = {self.level, self.level}, exp_worth = 0,

			max_life = resolvers.rngavg(25,50),
			life_rating = 15,
			infravision = 10,

			combat_armor = 1, combat_def = 1,
			never_move = 1,

			combat = { dam=8, atk=15, apr=5, damtype=DamageType.ACID, dammod={str=0.7} },

			wild_gift_detonate = t.id,

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target},

			on_takehit = function(self, value, src)
				local p = value * 0.10
				if self.summoner and not self.summoner.dead then
					self.summoner:incEquilibrium(-p)
					self:logCombat(self.summoner, "#GREEN##Source# 吸收了部分伤害。 #Target# 更亲近自然了。")
				end
				return value - p
			end,
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.talents{ [self.T_SWALLOW]=self:getTalentLevelRaw(t) }
		end
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 果 冻 怪 来 攻 击 敌 人， 持 续 %d 回 合。 
		 果 冻 怪 不 会 移 动。 
		 它 拥 有 %d 点 体 质 和 %d 点 力 量。 
		 每 当 果 冻 怪 受 到 伤 害 时， 你 降 低 等 同 于 它 受 到 伤 害 值 的 10％ 失 衡 值。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 果 冻 怪 的 体 质 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.str)
       end,
}

newTalent{
	name = "Minotaur",
	type = {"wild-gift/summon-melee", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	message = "@Source@ 召唤了米诺陶!",
	equilibrium = 10,
	cooldown = 15,
	range = 5,
	is_summon = true,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = { confusion = 1, stun = 1 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.BLEED, self:mindCrit(self:combatTalentMindDamage(t, 30, 350)), {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		local slowdown = self:combatLimit(self:combatTalentMindDamage(t, 5, 500), 1, 0.1, 0, 0.47 , 369) -- Limit speed loss to <100%
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_SLOW_MOVE, dur=duration, p={power=slowdown}}, {type="flame"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 2, 0, 7, 5)) end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{ 
			str=25 + (fake and mp or self:mindCrit(mp)) * 2.1 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			dex=10 + (fake and mp or self:mindCrit(mp)) * 1.8 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			con=10 + self:combatTalentScale(t, 2, 10, 0.75) + self:callTalent(self.T_RESILIENCE, "incCon"),
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "没有足够的召唤空间！")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "giant", subtype = "minotaur",
			display = "H",
			name = "minotaur", color=colors.UMBER, resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/giant_minotaur_minotaur.png", display_h=2, display_y=-1}}},

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

			max_stamina = 100,
			life_rating = 13,
			max_life = resolvers.rngavg(50,80),
			infravision = 10,

			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, },
			global_speed_base=1.2,
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			desc = [[It is a cross between a human and a bull.]],
			resolvers.equip{ {type="weapon", subtype="battleaxe", auto_req=true}, },
			level_range = {self.level, self.level}, exp_worth = 0,

			combat_armor = 13, combat_def = 8,
			resolvers.talents{ [Talents.T_WARSHOUT]=3, [Talents.T_STUNNING_BLOW]=3, [Talents.T_SUNDER_ARMOUR]=2, [Talents.T_SUNDER_ARMS]=2, },

			wild_gift_detonate = t.id,

			faction = self.faction,
			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self,t),
			ai_target = {actor=target}
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.talents{ [self.T_RUSH]=self:getTalentLevelRaw(t) }
		end
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 米 诺 陶 来 攻 击 敌 人， 持 续 %d 回 合。 米 诺 陶 不 会 呆 很 长 时 间， 但 是 它 们 会 造 成 极 大 伤 害。 
		 它 拥 有 %d 点 力 量， %d 点 体 质 和 %d 点 敏 捷。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 米 诺 陶 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self,t), incStats.str, incStats.con, incStats.dex)
	end,
}

newTalent{
	name = "Stone Golem",
	type = {"wild-gift/summon-melee", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	message = "@Source@ 召唤了岩石傀儡!",
	equilibrium = 15,
	cooldown = 20,
	range = 5,
	is_summon = true,
	tactical = { ATTACK = { PHYSICAL = 3 }, DISABLE = { knockback = 1 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.PHYSKNOCKBACK, {dam=self:mindCrit(self:combatTalentMindDamage(t, 30, 150)), dist=4}, {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		local duration = self:callTalent(self.T_GRAND_ARRIVAL,"effectDuration")
		self:project(tg, m.x, m.y, DamageType.TEMP_EFFECT, {foes=true, eff=self.EFF_DAZED, check_immune="stun", dur=duration, p={}}, {type="flame"})
	end,
	requires_target = true,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 5, 0, 10, 5)) end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{ 
			str=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			dex=15 + (fake and mp or self:mindCrit(mp)) * 1.9 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:combatTalentScale(t, 2, 10, 0.75),
			con=10 + self:combatTalentScale(t, 2, 10, 0.75) + self:callTalent(self.T_RESILIENCE, "incCon"),
		}
	end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "没有足够的召唤空间！")
			return
		end

		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "golem", subtype = "stone",
			display = "g",
			name = "stone golem", color=colors.WHITE, image = "npc/summoner_golem.png",

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

			max_stamina = 800,
			life_rating = 13,
			max_life = resolvers.rngavg(50,80),
			infravision = 10,

			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, },
			stats = {str=0, dex=0, con=0, cun=0, wil=0, mag=0},
			inc_stats = t.incStats(self, t),
			desc = [[It is a massive animated statue.]],
			level_range = {self.level, self.level}, exp_worth = 0,

			combat_armor = 25, combat_def = -20,
			combat = { dam=25 + self:getWil(), atk=20, apr=5, dammod={str=0.9} },
			resolvers.talents{ [Talents.T_UNSTOPPABLE]=3, [Talents.T_STUN]=3, },

			poison_immune=1, cut_immune=1, fear_immune=1, blind_immune=1,

			wild_gift_detonate = t.id,

			faction = self.faction,
			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.summonTime(self, t),
			ai_target = {actor=target},
			resolvers.sustains_at_birth(),
		}
		if self:attr("wild_summon") and rng.percent(self:attr("wild_summon")) then
			m.name = m.name.." (wild summon)"
			m[#m+1] = resolvers.talents{ [self.T_SHATTERING_IMPACT]=self:getTalentLevelRaw(t) }
		end
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召 唤 1 只 岩 石 傀 儡 来 攻 击 敌 人， 持 续 %d 回 合。 岩 石 傀 儡 是 可 怕 的 敌 人 并 且 不 可 阻 挡。 
		 它 有 %d 点 力 量， %d 点 体 质 和 %d 点 敏 捷。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 傀 儡 的 力 量 和 敏 捷 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con, incStats.dex)
	end,
}

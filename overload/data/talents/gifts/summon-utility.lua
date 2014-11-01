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
	name = "Taunt",
	type = {"technique/other",1},
	points = 1,
	cooldown = 5,
	requires_target = false,
	tactical = { PROTECT = 2 },
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
		return ([[强 制 %d 码 范 围 内 的 所 有 敌 对 目 标 攻 击 你。]]):format(self:getTalentRadius(t))
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
		return ([[隐 藏 在 你 的 甲 壳 下， 增 加 %d%% 全 体 伤 害 抗 性 ， 持 续 %d 回 合。]]):format(t.resistPower(self, t), t.getDuration(self, t))
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
		return ([[朝 你 的 目 标 投 掷 一 个 网， 若 目 标 被 击 中 则 被 困 在 原 地 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Turtle",
	type = {"wild-gift/summon-utility", 1},
	require = gifts_req1,
	random_ego = "attack",
	points = 5,
	message = "@Source@ 召唤了乌龟!",
	equilibrium = 2,
	cooldown = 10,
	range = 5,
	is_summon = true,
	requires_target = true,
	tactical = { DEFEND = 2, PROTECT = 2 },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:setEffect(target.EFF_SHELL_SHIELD, 4, {power=self:mindCrit(self:combatTalentMindDamage(t, 10, 35))})
		end, nil, {type="flame"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 5, 0, 10, 5)) end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{ 
			con=15 + (fake and mp or self:mindCrit(mp)) * 2.1 * self:combatTalentScale(t, 0.2, 1, 0.75) + self:callTalent(self.T_RESILIENCE, "incCon"),
			wil = 18,
			dex=10 + self:combatTalentScale(t, 2, 10, 0.75),
		}
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y, ignore_nullify_all_friendlyfire=true}
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:attr("allow_on_heal", 1)
			target:heal(30 + self:combatTalentMindDamage(t, 10, 350), m)
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
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召 唤 1 只 乌 龟 来 吸 引 敌 人 攻 击， 持 续 %d 回 合。 
		 乌 龟 具 有 很 强 的 生 命 力， 并 不 能 造 成 很 多 伤 害。 
		 然 而， 它 们 会 周 期 性 的 嘲 讽 敌 人 并 用 龟 壳 保 护 自 己。
		 它 拥 有 %d 点 体 质， %d 点 敏 捷 和 18 点 意 志。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 乌 龟 的 体 质 有 额 外 加 成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.dex)
	end,
}

newTalent{
	name = "Spider",
	type = {"wild-gift/summon-utility", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = "@Source@ 召唤了蜘蛛!",
	equilibrium = 5,
	cooldown = 10,
	range = 5,
	is_summon = true,
	tactical = { ATTACK = 1, DISABLE = { pin = 2 } },
	on_pre_use = function(self, t, silent)
		if not self:canBe("summon") and not silent then game.logPlayer(self, "你无法召唤，你被干扰了！") return end
		return not checkMaxSummon(self, silent)
	end,
	requires_target = true,
	on_detonate = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) >= 0 then return end
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, 3, {apply_power=self:mindCrit(self:combatMindpower())})
			end
		end, nil, {type="flame"})
	end,
	on_arrival = function(self, t, m)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t, x=m.x, y=m.y}
		self:project(tg, m.x, m.y, DamageType.FEARKNOCKBACK, {dist=1+self:getTalentLevelRaw(t), x=m.x, y=m.y}, {type="acid"})
	end,
	summonTime = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t) + self:getTalentLevel(self.T_RESILIENCE), 5, 0, 10, 5)) end,
	incStats = function(self, t,fake)
		local mp = self:combatMindpower()
		return{ 
			dex=15 + (fake and mp or self:mindCrit(mp)) * 2 * self:combatTalentScale(t, 0.2, 1, 0.75),
			wil = 18,
			str=10 + self:combatTalentScale(t, 2, 10, 0.75),
			con=10 + self:callTalent(self.T_RESILIENCE, "incCon")
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
		setupSummon(self, m, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召 唤 1 只 蜘 蛛 来 扰 乱 敌 人， 持 续 %d 回 合。 
		 蜘 蛛 可 以 使 敌 人 中 毒 并 向 目 标 撒 网， 将 目 标 固 定 在 地 上。 
		 它 拥 有 %d 点 敏 捷， %d 点 力 量， 18 点 意 志 和 %d 点 体 质。 
		 你 的 召 唤 物 继 承 你 部 分 属 性： 增 加 百 分 比 伤 害、 震 慑 / 定 身 / 混 乱 / 致 盲 抵 抗 和 护 甲 穿 透。 
		 受 精 神 强 度 影 响， 蜘 蛛 的 敏 捷 有 额 外 加 成。]])
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
	requires_target = true,
	no_energy = true,
	tactical = { BUFF = 0.2 },
	getReduc = function(self, t) return self:combatTalentLimit(t, 100, 25, 75)  end, -- Limit <100%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 2.7, 5.6)) end, -- Limit <25
	action = function(self, t)
		self:setEffect(self.EFF_FRANTIC_SUMMONING, t.getDuration(self, t), {power=t.getReduc(self, t)})
		return true
	end,
	info = function(self, t)
		local reduc = t.getReduc(self, t)
		return ([[你 专 注 于 自 然， 使 你 的 召 唤 速 度 提 升（ %d%% 的 正 常 召 唤 时 间）， 并 且 即 使 在 高 自 然 失 衡 值 下 也 不 会 失 败， 持 续 %d 回 合。 
		 当 此 技 能 激 活 时， 某 个 随 机 的 召 唤 天 赋 会 冷 却。 
		 每 次 你 进 行 召 唤， 疯 狂 召 唤 的 效 果 会 减 少 1 回 合。]]):
		format(100 - reduc, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Summon Control",
	type = {"wild-gift/summon-utility", 4},
	require = gifts_req4,
	mode = "passive",
	points = 5,
	-- Effects implemented in setupsummon function in data\talents\gifts\gifts.lua
	lifetime = function(self,t)	return math.floor(self:combatTalentScale(t, 5, 17, "log", 0, 4)) end,
	DamReduc = function(self,t)
		return self:combatLimit(self:getCun(7, true) * self:getTalentLevelRaw(t), 100, 0, 0, 35, 35) --Limit < 100%
	end,
	info = function(self, t)
		return ([[允 许 你 直 接 控 制 任 一 召 唤 兽。 
		 召 唤 兽 会 出 现 在 界 面 上， 1 次 单 击 就 可 以 使 你 切 换 控 制。 
		 同 时 你 可 以 用 Ctrl+Tab 进 行 切 换。 
		 当 控 制 召 唤 兽 时， 你 的 召 唤 兽 会 增 加 存 在 时 间 %d 回 合 并 减 少 %d%% 所 承 受 伤 害。 
		 受 灵 巧 影 响， 伤 害 减 免 有 额 外 加 成。]]):format(t.lifetime(self,t), t.DamReduc(self,t))
	end,
}

-- ToME - Tales of Middle-Earth
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
	short_name = "SHADOW_FADE",
	name = "Fade",
	type = {"spell/other",1},
	points = 5,
	cooldown = function(self, t)
		return math.max(3, 8 - self:getTalentLevelRaw(t))
	end,
	action = function(self, t)
		self:setEffect(self.EFF_FADED, 1, {})
		return true
	end,
	info = function(self, t)
		return ([[你 从 视 线 中 消 失 并 无 敌， 直 到 下 一 回 合 开 始。]])
	end,
}

newTalent{
	short_name = "SHADOW_PHASE_DOOR",
	name = "Phase Door",
	type = {"spell/other",1},
	points = 5,
	range = 10,
	tactical = { ESCAPE = 2 },
	is_teleport = true,
	action = function(self, t)
		local x, y, range
		if self.ai_state.shadow_wall then
			x, y, range = self.ai_state.shadow_wall_target.x, self.ai_state.shadow_wall_target.y, 1
		elseif self.ai_target.x and self.ai_target.y then
			x, y, range = self.ai_target.x, self.ai_target.y, 1
		else
			x, y, range = self.summoner.x, self.summoner.y, self.ai_state.location_range
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
		self:teleportRandom(x, y, range)
		game.level.map:particleEmitter(x, y, 1, "teleport_in")
		return true
	end,
	info = function(self, t)
		return ([[小 范 围 内 将 你 传 送 一 段 距 离。]])
	end,
}

newTalent{
	short_name = "SHADOW_BLINDSIDE",
	name = "Blindside",
	type = {"spell/other", 1},
	points = 5,
	random_ego = "attack",
	range = 10,
	requires_target = true,
	tactical = { CLOSEIN = 2 },
	action = function(self, t)
		local tg = {type="hit", pass_terrain = true, range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local start = rng.range(0, 8)
		for i = start, start + 8 do
			local x = target.x + (i % 3) - 1
			local y = target.y + math.floor((i % 9) / 3) - 1
			if game.level.map:isBound(x, y)
					and self:canMove(x, y)
					and not game.level.map.attrs(x, y, "no_teleport") then
				game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
				self:move(x, y, true)
				game.level.map:particleEmitter(x, y, 1, "teleport_in")
				local multiplier = self:combatTalentWeaponDamage(t, 0.9, 1.9)
				self:attackTarget(target, nil, multiplier, true)
				return true
			end
		end

		return false
	end,info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.9, 1.9)
		return ([[你 以 难 以 置 信 的 速 度 闪 现 至 附 近 %d 码 的 一 个 目 标 身 边 并 造 成 %d%% 伤 害。]]):format(self:getTalentRange(t), multiplier * 100)
	end,
}

newTalent{
	short_name = "SHADOW_LIGHTNING",
	name = "Shadow Lightning",
	type = {"spell/other", 1},
	require = { },
	points = 5,
	random_ego = "attack",
	range = 1,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 200) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用 闪 电 打 击 目 标 造 成 %0.2f 到 %0.2f 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

newTalent{
	short_name = "SHADOW_FLAMES",
	name = "Shadow Flames",
	type = {"spell/other", 1},
	require = { },
	points = 5,
	random_ego = "attack",
	range = 6,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 140) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.FIRE, dam)
		game.level.map:particleEmitter(x, y, 1, "flame")
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用 火 焰 灼 烧 你 的 目 标 造 成 %0.2f 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIREBURN, damage))
	end,
}

newTalent{
	short_name = "SHADOW_REFORM",
	name = "Reform",
	type = {"spell/other", 1},
	require = { },
	points = 5,
	getChance = function(self, t)
		return 50 --10 + self:getMag() * 0.25 + self:getTalentLevel(t) * 2
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[当 阴 影 受 到 伤 害 或 被 杀 死， 有 %d%% 几 率 重 组 并 免 受 伤 害。]]):format(chance)
	end,
}

local function createShadow(self, level, tCallShadows, tShadowWarriors, tShadowMages, duration, target)
	local npc = require("mod.class.NPC").new{
		type = "undead", subtype = "shadow",
		name = "shadow",
		desc = [[]],
		display = 'b', color=colors.BLACK,

		never_anger = true,
		summoner = self,
		summoner_gain_exp=true,
		summon_time = duration,
		faction = self.faction,
		size_category = 2,
		rank = 2,
		autolevel = "none",
		level_range = {level, level},
		exp_worth=0,
		hate_regen = 1,
		avoid_traps = 1,
		is_doomed_shadow = true,

		max_life = resolvers.rngavg(3,12), life_rating = 5,
		stats = { -- affected by stat limits
			str=math.floor(self:combatScale(level, 5, 0, 55, 50, 0.75)),
			dex=math.floor(self:combatScale(level, 10, 0, 85, 50, 0.75)),
			mag=math.floor(self:combatScale(level, 10, 0, 85, 50, 0.75)),
			wil=math.floor(self:combatScale(level, 5, 0, 55, 50, 0.75)),
			cun=math.floor(self:combatScale(level, 5, 0, 40, 50, 0.75)),
			con=math.floor(self:combatScale(level, 5, 0, 40, 50, 0.75)),
		},
		combat_armor = 0, combat_def = 3,
		combat = {
			dam=math.floor(self:combatScale(level, 1.5, 1, 75, 50, 0.75)),
			atk=10 + level,
			apr=8,
			dammod={str=0.5, dex=0.5}
		},
		mana = 100,
		spellpower = tShadowMages and tShadowMages.getSpellpowerChange(self, tShadowMages) or 0,
		summoner_hate_per_kill = self.hate_per_kill,
		resolvers.talents{
			[self.T_SHADOW_PHASE_DOOR]=tCallShadows.getPhaseDoorLevel(self, tCallShadows),
			[self.T_SHADOW_BLINDSIDE]=tCallShadows.getBlindsideLevel(self, tCallShadows),
			[self.T_HEAL]=tCallShadows.getHealLevel(self, tCallShadows),
			[self.T_DOMINATE]=tShadowWarriors and tShadowWarriors.getDominateLevel(self, tShadowWarriors) or 0,
			[self.T_SHADOW_FADE]=tShadowWarriors and tShadowWarriors.getFadeLevel(self, tShadowWarriors) or 0,
			[self.T_SHADOW_LIGHTNING]=tShadowMages and tShadowMages.getLightningLevel(self, tShadowMages) or 0,
			[self.T_SHADOW_FLAMES]=tShadowMages and tShadowMages.getFlamesLevel(self, tShadowMages) or 0,
			[self.T_SHADOW_REFORM]=tShadowMages and tShadowMages.getReformLevel(self, tShadowMages) or 0,
		},

		undead = 1,
		no_breath = 1,
		stone_immune = 1,
		confusion_immune = 1,
		fear_immune = 1,
		teleport_immune = 1,
		disease_immune = 1,
		poison_immune = 1,
		stun_immune = 1,
		blind_immune = 1,
		see_invisible = 80,
		resists = { [DamageType.LIGHT] = -100, [DamageType.DARKNESS] = 100 },
		resists_pen = { all=25 },

		ai = "shadow",
		ai_state = {
			summoner_range = 10,
			actor_range = 8,
			location_range = 4,
			target_time = 0,
			target_timeout = 10,
			focus_on_target = false,
			shadow_wall = false,
			shadow_wall_time = 0,

			blindside_chance = 15,
			phasedoor_chance = 5,
			close_attack_spell_chance = 0,
			far_attack_spell_chance = 0,
			can_reform = false,
			dominate_chance = 0,

			feed_level = 0
		},
		ai_target = {
			actor=target,
			x = nil,
			y = nil
		},

		healSelf = function(self)
			self:useTalent(self.T_HEAL)
		end,
		closeAttackSpell = function(self)
			return self:useTalent(self.T_SHADOW_LIGHTNING)
		end,
		farAttackSpell = function(self)
			if self:knowTalent(self.T_EMPATHIC_HEX) and not self:isTalentCoolingDown(self.T_EMPATHIC_HEX) and rng.percent(50) then
				return self:useTalent(self.T_EMPATHIC_HEX)
			else
				return self:useTalent(self.T_SHADOW_FLAMES)
			end
		end,
		dominate = function(self)
			return self:useTalent(self.T_DOMINATE)
		end,
		feed = function(self)
			if self.summoner:knowTalent(self.summoner.T_SHADOW_MAGES) then
				local tShadowMages = self.summoner:getTalentFromId(self.summoner.T_SHADOW_MAGES)
				self.ai_state.close_attack_spell_chance = tShadowMages.getCloseAttackSpellChance(self.summoner, tShadowMages)
				self.ai_state.far_attack_spell_chance = tShadowMages.getFarAttackSpellChance(self.summoner, tShadowMages)
				self.ai_state.can_reform = self.summoner:getTalentLevel(tShadowMages) >= 5
			else
				self.ai_state.close_attack_spell_chance = 0
				self.ai_state.far_attack_spell_chance = 0
				self.ai_state.can_reform = false
			end

			if self.ai_state.feed_temp1 then self:removeTemporaryValue("combat_atk", self.ai_state.feed_temp1) end
			self.ai_state.feed_temp1 = nil
			if self.ai_state.feed_temp2 then self:removeTemporaryValue("inc_damage", self.ai_state.feed_temp2) end
			self.ai_state.feed_temp2 = nil
			if self.summoner:knowTalent(self.summoner.T_SHADOW_WARRIORS) then
				local tShadowWarriors = self.summoner:getTalentFromId(self.summoner.T_SHADOW_WARRIORS)
				self.ai_state.feed_temp1 = self:addTemporaryValue("combat_atk", tShadowWarriors.getCombatAtk(self.summoner, tShadowWarriors))
				self.ai_state.feed_temp2 = self:addTemporaryValue("inc_damage", {all=tShadowWarriors.getIncDamage(self.summoner, tShadowWarriors)})
				self.ai_state.dominate_chance = tShadowWarriors.getDominateChance(self.summoner, tShadowWarriors)
			else
				self.ai_state.dominate_chance = 0
			end
		end,
		onTakeHit = function(self, value, src)
			if self:knowTalent(self.T_SHADOW_FADE) and not self:isTalentCoolingDown(self.T_SHADOW_FADE) then
				self:forceUseTalent(self.T_SHADOW_FADE, {ignore_energy=true})
			end

			return mod.class.Actor.onTakeHit(self, value, src)
		end,
	}
	self:attr("summoned_times", 1)
	return npc
end

newTalent{
	name = "Call Shadows",
	type = {"cursed/shadows", 1},
	mode = "sustained",
	no_energy = true,
	require = cursed_cun_req1,
	points = 5,
	cooldown = 10,
	hate = 0,
	tactical = { BUFF = 5 },
	getLevel = function(self, t) return self.level end,
	getMaxShadows = function(self, t)
		return math.min(4, math.max(1, math.floor(self:getTalentLevel(t) * 0.55)))
	end,
	getPhaseDoorLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getBlindsideLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getHealLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		-- unsummon the shadows
		for _, e in pairs(game.level.entities) do
			if e.summoner and e.summoner == self and e.subtype == "shadow" then
				e.summon_time = 0
			end
		end

		return true
	end,
	do_callShadows = function(self, t)
		if not self.shadows then
			self.shadows = {
				remainingCooldown = 0
			}
		end

		if game.zone.wilderness then return false end

		self.shadows.remainingCooldown = self.shadows.remainingCooldown - 1
		if self.shadows.remainingCooldown > 0 then return false end
		self.shadows.remainingCooldown = 10

		local shadowCount = 0
		for _, e in pairs(game.level.entities) do
			if e.summoner and e.summoner == self and e.subtype == "shadow" then shadowCount = shadowCount + 1 end
		end

		if shadowCount >= t.getMaxShadows(self, t) then
			return false
		end

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 8, true, {[Map.ACTOR]=true})
		if not x then
			return false
		end

		-- use hate
		if self.hate < 6 then
			-- not enough hate..just wait for another try
			game.logPlayer(self, "Your hate is too low to call another shadow!", deflectDamage)
			return false
		end
		self:incHate(-6)

		local level = t.getLevel(self, t)
		local tShadowWarriors = self:knowTalent(self.T_SHADOW_WARRIORS) and self:getTalentFromId(self.T_SHADOW_WARRIORS) or nil
		local tShadowMages = self:knowTalent(self.T_SHADOW_MAGES) and self:getTalentFromId(self.T_SHADOW_MAGES) or nil

		local shadow = createShadow(self, level, t, tShadowWarriors, tShadowMages, 1000, nil)

		shadow:resolve()
		shadow:resolve(nil, true)
		shadow:forceLevelup(level)
		game.zone:addEntity(game.level, shadow, "actor", x, y)
		shadow:feed()
		game.level.map:particleEmitter(x, y, 1, "teleport_in")

		shadow.no_party_ai = true
		shadow.unused_stats = 0
		shadow.unused_talents = 0
		shadow.unused_generics = 0
		shadow.unused_talents_types = 0
		shadow.no_points_on_levelup = true
		if game.party:hasMember(self) then
			shadow.remove_from_party_on_death = true
			game.party:addMember(shadow, { control="no", type="summon", title="Summon"})
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local maxShadows = t.getMaxShadows(self, t)
		local level = t.getLevel(self, t)
		local healLevel = t.getHealLevel(self, t)
		local blindsideLevel = t.getBlindsideLevel(self, t)
		return ([[当 此 技 能 激 活 时， 你 可 以 召 唤 %d 个 等 级 %d 的 阴 影 帮 助 你 战 斗。 每 个 阴 影 需 消 耗 6 点 仇 恨 值 召 唤。 
		 阴 影 是 脆 弱 的 战 士， 它 们 能 够： 使 用 奥 术 重 组 治 疗 自 己（ 等 级 %d ）， 使 用 灵 异 打 击 突 袭 目 标（ 等 级 %d ）， 使 用 相 位 之 门 进 行 传 送。]]):format(maxShadows, level, healLevel, blindsideLevel)
	end,
}

newTalent{
	name = "Shadow Warriors",
	type = {"cursed/shadows", 2},
	mode = "passive",
	require = cursed_cun_req2,
	points = 5,
	getIncDamage = function(self, t)
		return math.floor((math.sqrt(self:getTalentLevel(t)) - 0.5) * 35)
	end,
	getCombatAtk = function(self, t)
		return math.floor((math.sqrt(self:getTalentLevel(t)) - 0.5) * 23)
	end,
	getDominateLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getFadeLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getDominateChance = function(self, t)
		if self:getTalentLevelRaw(t) > 0 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	on_learn = function(self, t)
		if game and game.level and game.level.entities then
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					e:feed(t)
				end
			end
		end

		return { }
	end,
	on_unlearn = function(self, t, p)
		if game and game.level and game.level.entities then
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					e:feed(t)
				end
			end
		end

		return true
	end,
	info = function(self, t)
		local combatAtk = t.getCombatAtk(self, t)
		local incDamage = t.getIncDamage(self, t)
		local dominateChance = t.getDominateChance(self, t)
		local dominateLevel = t.getDominateLevel(self, t)
		local fadeCooldown = math.max(3, 8 - self:getTalentLevelRaw(t))
		return ([[将 仇 恨 注 入 你 的 阴 影， 强 化 他 们 的 攻 击。 他 们 获 得 %d%% 额 外 命 中 和 %d%% 额 外 伤 害 加 成。 
		 他 们 疯 狂 的 攻 击 可 以 令 他 们 控 制 对 手， 提 高 控 制 目 标 的 所 有 伤 害 4 回 合（ 等 级 %d， %d%% 几 率 1 码 范 围）。 
		 它 们 同 时 拥 有 消 隐 的 能 力， 免 疫 所 有 伤 害 直 到 下 一 回 合 开 始（ %d 回 合 冷 却 时 间）。]]):format(combatAtk, incDamage, dominateLevel, dominateChance, fadeCooldown)
	end,
}

newTalent{
	name = "Shadow Mages",
	type = {"cursed/shadows", 3},
	mode = "passive",
	require = cursed_cun_req3,
	points = 5,
	getCloseAttackSpellChance = function(self, t)
		if math.floor(self:getTalentLevel(t)) > 0 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	getFarAttackSpellChance = function(self, t)
		if math.floor(self:getTalentLevel(t)) >= 3 then
			return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) -- Limit < 100%
		else
			return 0
		end
	end,
	getLightningLevel = function(self, t)
		return self:getTalentLevelRaw(t)
	end,
	getFlamesLevel = function(self, t)
		if self:getTalentLevel(t) >= 3 then
			return self:getTalentLevelRaw(t)
		else
			return 0
		end
	end,
	getReformLevel = function(self, t)
		if self:getTalentLevel(t) >= 5 then
			return self:getTalentLevelRaw(t)
		else
			return 0
		end
	end,
	canReform = function(self, t)
		return t.getReformLevel(self, t) > 0
	end,
	getSpellpowerChange = function(self, t) return math.floor(self:combatTalentScale(t, 3, 15, 0.75)) end,
	on_learn = function(self, t)
		if game and game.level and game.level.entities then
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					e:feed(t)
				end
			end
		end

		return { }
	end,
	on_unlearn = function(self, t, p)
		if game and game.level and game.level.entities then
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					e:feed(t)
				end
			end
		end

		return true
	end,
	info = function(self, t)
		local closeAttackSpellChance = t.getCloseAttackSpellChance(self, t)
		local farAttackSpellChance = t.getFarAttackSpellChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local lightningLevel = t.getLightningLevel(self, t)
		local flamesLevel = t.getFlamesLevel(self, t)
		return ([[灌 输 魔 力 给 你 的 阴 影 使 它 们 学 会 可 怕 的 法 术。 你 的 阴 影 获 得 %d 点 法 术 强 度 加 成。 
		 你 的 阴 影 可 以 用 闪 电 术 攻 击 附 近 的 目 标（ 等 级 %d ， %d%% 几 率 1 码 范 围）。 
		 等 级 3 时 你 的 阴 影 可 以 远 距 离 使 用 火 焰 术 灼 烧 你 的 敌 人（ 等 级 %d ， %d%% 几 率 2 到 6 码 范 围）。 
		 等 级 5 时 你 的 阴 影 在 被 击 倒 时 有 一 定 几 率 重 组 并 重 新 加 入 战 斗（ 50%% 几 率）。]]):format(spellpowerChange, lightningLevel, closeAttackSpellChance, flamesLevel, farAttackSpellChance)
	end,
}

newTalent{
	name = "Focus Shadows",
	type = {"cursed/shadows", 4},
	require = cursed_cun_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	hate = 0,
	range = 6,
	requires_target = true,
	tactical = { ATTACK = 2 },
	getDefenseDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4.4, 10.1)) end,
	getBlindsideChance = function(self, t) return self:combatTalentLimit(t, 100, 40, 80) end, -- Limit < 100%
	action = function(self, t)
		local range = self:getTalentRange(t)
		local target = { type="hit", range=range, nowarning=true }
		local x, y, target = self:getTarget(target)
		if not x or not y or not target or core.fov.distance(self.x, self.y, x, y) > range then return nil end

		if self:reactionToward(target) < 0 then
			-- attack the target
			local blindsideChance = t.getBlindsideChance(self, t)
			local shadowCount = 0
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					-- reset target and set to focus
					e.ai_target.x = nil
					e.ai_target.y = nil
					e.ai_target.actor = target
					e.ai_target.focus_on_target = true
					e.ai_target.blindside_chance = blindsideChance

					shadowCount = shadowCount + 1
				end
			end

			if shadowCount > 0 then
				self:logCombat(target, "#PINK#阴影集中到#Target#附近!")
				return true
			else
				game.logPlayer(self, "Their are no shadows to heed the call!")
				return false
			end
		else
			-- defend the target
			local defenseDuration = t.getDefenseDuration(self, t)
			local shadowCount = 0
			for _, e in pairs(game.level.entities) do
				if e.summoner and e.summoner == self and e.subtype == "shadow" then
					e.ai_state.shadow_wall = true
					e.ai_state.shadow_wall_target = target
					e.ai_state.shadow_wall_time = defenseDuration

					shadowCount = shadowCount + 1
				end
			end

			if shadowCount > 0 then
				self:logCombat(target, "#PINK#阴影集中到#Target#附近!")
				return true
			else
				game.logPlayer(self, "Their are no shadows to heed the call!")
				return false
			end
		end
	end,
	info = function(self, t)
		local defenseDuration = t.getDefenseDuration(self, t)
		local blindsideChance = t.getBlindsideChance(self, t)
		return ([[将 你 的 阴 影 聚 集 至 单 一 目 标。 如 果 目 标 为 友 善 则 保 护 目 标 %d 回 合。 如 目 标 为 敌 对 则 有 %d%% 几 率 使 用 灵 异 打 击 攻 击 目 标。 
		 该 技 能 不 消 耗 任 何 能 量。]]):format(defenseDuration, blindsideChance)
	end,
}


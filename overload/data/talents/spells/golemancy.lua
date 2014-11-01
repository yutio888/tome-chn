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
local Chat = require "engine.Chat"

function getGolem(self)
	if game.level:hasEntity(self.alchemy_golem) then
		return self.alchemy_golem, self.alchemy_golem
	elseif self:hasEffect(self.EFF_GOLEM_MOUNT) then
		return self, self.alchemy_golem
	end
end

local function makeGolem(self)
	self:attr("summoned_times", 100)
	local g = require("mod.class.NPC").new{
		type = "construct", subtype = "golem",
		display = 'g', color=colors.WHITE, image = "npc/alchemist_golem.png",
		moddable_tile = "runic_golem",
		moddable_tile_nude = 1,
		moddable_tile_base = resolvers.generic(function() return "base_0"..rng.range(1, 5)..".png" end),
--		level_range = {1, 50}, exp_worth=0,
		level_range = {1, self.max_level}, exp_worth=0,
		life_rating = 13,
		never_anger = true,
		save_hotkeys = true,

		combat = { dam=10, atk=10, apr=0, dammod={str=1} },

		body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, BODY=1, GEM=2 },
		canWearObjectCustom = function(self, o)
			if o.type ~= "gem" then return end
			if not self.summoner then return "Golem has no master" end
			if not self.summoner:knowTalent(self.summoner.T_GEM_GOLEM) then return "Master must know the Gem Golem talent" end
			if not o.material_level then return "impossible to use this gem" end
			if o.material_level > self.summoner:getTalentLevelRaw(self.summoner.T_GEM_GOLEM) then return "Master's Gem Golem talent too low for this gem" end
		end,
		equipdoll = "alchemist_golem",
		infravision = 10,
		rank = 3,
		size_category = 4,

		resolvers.talents{
			[Talents.T_ARMOUR_TRAINING]=3,
			[Talents.T_GOLEM_ARMOUR]=1,
			[Talents.T_WEAPON_COMBAT]=1,
			[Talents.T_MANA_POOL]=1,
			[Talents.T_STAMINA_POOL]=1,
			[Talents.T_GOLEM_KNOCKBACK]=1,
			[Talents.T_GOLEM_DESTRUCT]=1,
		},

		resolvers.equip{ id=true,
			{type="weapon", subtype="battleaxe", autoreq=true, id=true, ego_chance=-1000},
			{type="armor", subtype="heavy", autoreq=true, id=true, ego_chance=-1000}
		},

		talents_types = {
			["golem/fighting"] = true,
			["golem/arcane"] = true,
		},
		talents_types_mastery = {
			["technique/combat-training"] = 0.3,
			["golem/fighting"] = 0.3,
			["golem/arcane"] = 0.3,
		},
		forbid_nature = 1,
		inscription_restrictions = { ["inscriptions/runes"] = true, },
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}),

		hotkey = {},
		hotkey_page = 1,
		move_others = true,

		ai = "tactical",
		ai_state = { talent_in=1, ai_move="move_astar", ally_compassion=10 },
		ai_tactic = resolvers.tactic"tank",
		stats = { str=14, dex=12, mag=12, con=12 },

		-- No natural exp gain
		gainExp = function() end,
		forceLevelup = function(self) if self.summoner then return mod.class.Actor.forceLevelup(self, self.summoner.level) end end,

		-- Break control when losing LOS
		on_act = function(self)
			if game.player ~= self then return end
			if not self.summoner.dead and not self:hasLOS(self.summoner.x, self.summoner.y) then
				if not self:hasEffect(self.EFF_GOLEM_OFS) then
					self:setEffect(self.EFF_GOLEM_OFS, 8, {})
				end
			else
				if self:hasEffect(self.EFF_GOLEM_OFS) then
					self:removeEffect(self.EFF_GOLEM_OFS)
				end
			end
		end,

		on_can_control = function(self, vocal)
			if not self:hasLOS(self.summoner.x, self.summoner.y) then
				if vocal then game.logPlayer(game.player, "Your golem is out of sight; you cannot establish direct control.") end
				return false
			end
			return true
		end,

		unused_stats = 0,
		unused_talents = 0,
		unused_generics = 0,
		unused_talents_types = 0,

		no_points_on_levelup = function(self)
			self.unused_stats = self.unused_stats + 2
			if self.level >= 2 and self.level % 3 == 0 then self.unused_talents = self.unused_talents + 1 end
		end,

		keep_inven_on_death = true,
--		no_auto_resists = true,
		open_door = true,
		cut_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		poison_immune = 1,
		disease_immune = 1,
		stone_immune = 1,
		see_invisible = 30,
		no_breath = 1,
		can_change_level = true,
	}

	if self.alchemist_golem_is_drolem then
		g.image="invis.png"
		g.add_mos = {{image="npc/construct_golem_drolem.png", display_h=2, display_y=-1}}
		g.moddable_tile = nil
		g:learnTalentType("golem/drolem", true)
	end

	return g
end

newTalent{
	name = "Interact with the Golem", short_name = "INTERACT_GOLEM",
	type = {"spell/golemancy-base", 1},
	require = spells_req1,
	points = 1,
	mana = 10,
	no_energy = true,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		if not self.alchemy_golem then return end

		local on_level = false
		for x = 0, game.level.map.w - 1 do for y = 0, game.level.map.h - 1 do 
			local act = game.level.map(x, y, Map.ACTOR)
			if act and act == self.alchemy_golem then on_level = true break end
		end end

		-- talk to the golem
		if game.level:hasEntity(self.alchemy_golem) and on_level then
			local chat = Chat.new("alchemist-golem", self.alchemy_golem, self, {golem=self.alchemy_golem, player=self})
			chat:invoke()
		end
		return true
	end,
	info = function(self, t)
		return ([[和 你 的 傀 儡 交 互， 检 查 它 的 物 品、 技 能 等。]]):
		format()
	end,
}

newTalent{
	name = "Refit Golem",
	type = {"spell/golemancy-base", 1},
	autolearn_talent = "T_INTERACT_GOLEM",
	require = spells_req1,
	points = 1,
	cooldown = 20,
	mana = 10,
	no_npc_use = true,
	no_unlearn_last = true,
	getHeal = function(self, t)
		if not self.alchemy_golem then return 0 end
		local ammo = self:hasAlchemistWeapon()

		--	Heal fraction of max life for higher levels
		local healbase = 44+self.alchemy_golem.max_life*self:combatTalentLimit(self:getTalentLevel(self.T_GOLEM_POWER),0.2, 0.008, 0.033) -- Add up to 20% of max life to heal
		return healbase + self:combatTalentSpellDamage(self.T_GOLEM_POWER, 15, 550, ((ammo and ammo.alchemist_power or 0) + self:combatSpellpower()) / 2) --I5
	end,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 and not self.innate_alchemy_golem then
			t.invoke_golem(self, t)
			if self:knowTalent(self.T_BLIGHTED_SUMMONING) then
				local golem = self.alchemy_golem
				golem:learnTalentType("corruption/reaving-combat", true)
				golem:learnTalent(golem.T_CORRUPTED_STRENGTH, true, 3)
			end
		end
	end,
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 0 and self.alchemy_golem and not self.innate_alchemy_golem then
			if game.party:hasMember(self) and game.party:hasMember(self.alchemy_golem) then game.party:removeMember(self.alchemy_golem) end
			self.alchemy_golem:disappear()
			self.alchemy_golem = nil
		end
	end,
	invoke_golem = function(self, t)
		self.alchemy_golem = game.zone:finishEntity(game.level, "actor", makeGolem(self))
		if game.party:hasMember(self) then
			game.party:addMember(self.alchemy_golem, {
				control="full", type="golem", title="Golem", important=true,
				orders = {target=true, leash=true, anchor=true, talents=true, behavior=true},
			})
		end
		if not self.alchemy_golem then return end
		self.alchemy_golem.faction = self.faction
		self.alchemy_golem.name = "golem (servant of "..self.name..")"
		self.alchemy_golem.summoner = self
		self.alchemy_golem.summoner_gain_exp = true

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "没有足够的空间来改装!")
			return
		end
		game.zone:addEntity(game.level, self.alchemy_golem, "actor", x, y)
	end,
	action = function(self, t)
		if not self.alchemy_golem then
			t.invoke_golem(self, t)
			return
		end

		local wait = function()
			local co = coroutine.running()
			local ok = false
			self:restInit(20, "refitting", "refitted", function(cnt, max)
				if cnt > max then ok = true end
				coroutine.resume(co)
			end)
			coroutine.yield()
			if not ok then
				game.logPlayer(self, "你被干扰了!")
				return false
			end
			return true
		end

		local ammo = self:hasAlchemistWeapon()

		local on_level = false
		for x = 0, game.level.map.w - 1 do for y = 0, game.level.map.h - 1 do 
			local act = game.level.map(x, y, Map.ACTOR)
			if act and act == self.alchemy_golem then on_level = true break end
		end end

		if game.level:hasEntity(self.alchemy_golem) and on_level and self.alchemy_golem.life >= self.alchemy_golem.max_life then
			-- nothing
			return nil
		-- heal the golem
		elseif ((game.level:hasEntity(self.alchemy_golem) and on_level) or self:hasEffect(self.EFF_GOLEM_MOUNT)) and self.alchemy_golem.life < self.alchemy_golem.max_life then
			if not ammo or ammo:getNumber() < 2 then
				game.logPlayer(self, "你需要两个炼金宝石来治疗你的傀儡。")
				return
			end
			for i = 1, 2 do self:removeObject(self:getInven("QUIVER"), 1) end
			self.alchemy_golem:attr("allow_on_heal", 1)
			self.alchemy_golem:heal(t.getHeal(self, t), self)
			self.alchemy_golem:attr("allow_on_heal", -1)
			if core.shader.active(4) then
				self.alchemy_golem:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
				self.alchemy_golem:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, ize_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			end

		-- resurrect the golem
		elseif not self:hasEffect(self.EFF_GOLEM_MOUNT) then
			if not ammo or ammo:getNumber() < 15 then
				game.logPlayer(self, "你需要15个炼金宝石来治疗你的傀儡。")
				return
			end
			if not wait() then return end
			for i = 1, 15 do self:removeObject(self:getInven("QUIVER"), 1) end

			self.alchemy_golem.dead = nil
			if self.alchemy_golem.life < 0 then self.alchemy_golem.life = self.alchemy_golem.max_life / 3 end

			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "没有足够的空间来改装!")
				return
			end
			game.zone:addEntity(game.level, self.alchemy_golem, "actor", x, y)
			self.alchemy_golem:setTarget(nil)
			self.alchemy_golem.ai_state.tactic_leash_anchor = self
			self.alchemy_golem:removeAllEffects()
		end

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[与 你 的 傀 儡 进 行 交 互： 
		- 如 果 它 被 摧 毁， 你 将 耗 费 一 些 时 间 重 新 安 装 傀 儡（ 需 要 15 个 炼 金 宝 石）。 
		- 如 果 它 还 存 活， 你 可 以 修 整 它 使 其 恢 复 %d 生 命 值。（ 耗 费 2 个 炼 金 宝 石）。 法 术 强 度、 炼 金 宝 石 和 强 化 傀 儡 技 能 都 会 影 响 治 疗 量。]]):
		format(heal)
	end,
}

newTalent{
	name = "Golem Power",
	type = {"spell/golemancy", 1},
	mode = "passive",
	require = spells_req1,
	points = 5,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 and not self.innate_alchemy_golem then
			self:learnTalent(self.T_REFIT_GOLEM, true)
		end

		self.alchemy_golem:learnTalent(Talents.T_WEAPON_COMBAT, true, nil, {no_unlearn=true})
		self.alchemy_golem:learnTalent(Talents.T_STAFF_MASTERY, true, nil, {no_unlearn=true})
		self.alchemy_golem:learnTalent(Talents.T_KNIFE_MASTERY, true, nil, {no_unlearn=true})
		self.alchemy_golem:learnTalent(Talents.T_WEAPONS_MASTERY, true, nil, {no_unlearn=true})
		self.alchemy_golem:learnTalent(Talents.T_EXOTIC_WEAPONS_MASTERY, true, nil, {no_unlearn=true})
	end,
	on_unlearn = function(self, t)
		self.alchemy_golem:unlearnTalent(Talents.T_WEAPON_COMBAT, nil, nil, {no_unlearn=true})
		self.alchemy_golem:unlearnTalent(Talents.T_STAFF_MASTERY, nil, nil, {no_unlearn=true})
		self.alchemy_golem:unlearnTalent(Talents.T_KNIFE_MASTERY, nil, nil, {no_unlearn=true})
		self.alchemy_golem:unlearnTalent(Talents.T_WEAPONS_MASTERY, nil, nil, {no_unlearn=true})
		self.alchemy_golem:unlearnTalent(Talents.T_EXOTIC_WEAPONS_MASTERY, nil, nil, {no_unlearn=true})

		if self:getTalentLevelRaw(t) == 0 and not self.innate_alchemy_golem then
			self:unlearnTalent(self.T_REFIT_GOLEM)
		end
	end,
	info = function(self, t)
		if not self.alchemy_golem then return "提 高 傀 儡 的 武 器 熟 练 度， 增 加 它 的 命 中、  物 理 强 度 和 伤 害。" end
		local rawlev = self:getTalentLevelRaw(t)
		local olda, oldd = self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY]
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = 1 + rawlev, rawlev
		local ta, td = self:getTalentFromId(Talents.T_WEAPON_COMBAT), self:getTalentFromId(Talents.T_WEAPONS_MASTERY)
		local attack = ta.getAttack(self.alchemy_golem, ta)
		local power = td.getDamage(self.alchemy_golem, td)
		local damage = td.getPercentInc(self.alchemy_golem, td)
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = olda, oldd
		return ([[提 高 傀 儡 的 武 器 熟 练 度， 增 加 它 %d 点 命 中、 %d 物 理 强 度 和 %d%% 伤 害。]]):
		format(attack, power, 100 * damage)
	end,
}

newTalent{
	name = "Golem Resilience",
	type = {"spell/golemancy", 2},
	mode = "passive",
	require = spells_req2,
	points = 5,
	on_learn = function(self, t)
		self.alchemy_golem:learnTalent(Talents.T_THICK_SKIN, true, nil, {no_unlearn=true})
		self.alchemy_golem:learnTalent(Talents.T_GOLEM_ARMOUR, true, nil, {no_unlearn=true})
		self.alchemy_golem.healing_factor = (self.alchemy_golem.healing_factor or 1) + 0.1
	end,
	on_unlearn = function(self, t)
		self.alchemy_golem:unlearnTalent(Talents.T_THICK_SKIN, nil, nil, {no_unlearn=true})
		self.alchemy_golem:unlearnTalent(Talents.T_GOLEM_ARMOUR, nil, nil, {no_unlearn=true})
		self.alchemy_golem.healing_factor = (self.alchemy_golem.healing_factor or 1) - 0.1
	end,
	info = function(self, t)
		if not self.alchemy_golem then return " 提 高 傀 儡 护 甲 熟 练 度 和 伤 害 抵 抗。 " end
		local rawlev = self:getTalentLevelRaw(t)
		local oldh, olda = self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR]
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = rawlev, 1 + rawlev
		local th, ta, ga = self:getTalentFromId(Talents.T_THICK_SKIN), self:getTalentFromId(Talents.T_ARMOUR_TRAINING), self:getTalentFromId(Talents.T_GOLEM_ARMOUR)
		local res = th.getRes(self.alchemy_golem, th)
		local heavyarmor = ta.getArmor(self.alchemy_golem, ta) + ga.getArmor(self.alchemy_golem, ga)
		local hardiness = ta.getArmorHardiness(self.alchemy_golem, ta) + ga.getArmorHardiness(self.alchemy_golem, ga)
		local crit = ta.getCriticalChanceReduction(self.alchemy_golem, ta) + ga.getCriticalChanceReduction(self.alchemy_golem, ga)
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = oldh, olda

		return ([[提 高 傀 儡 护 甲 熟 练 度 和 伤 害 抵 抗。 
		 增 加 %d%% 所 有 伤 害 抵 抗； 增 加 %d 点 护 甲 和 %d%% 护 甲 韧 性； 当 装 备 1 件 锁 甲 或 板 甲 时， 减 少 %d%% 被 暴 击 率； 增 加 %d%% 治 疗 效 果。 
		 傀 儡 可 以 使 用 所 有 类 型 的 护 甲， 包 括 板 甲。]]):
		format(res, heavyarmor, hardiness, crit, rawlev * 10)
	end,
}

newTalent{
	name = "Invoke Golem",
	type = {"spell/golemancy",3},
	require = spells_req3,
	points = 5,
	mana = 10,
	cooldown = 20,
	no_npc_use = true,
	getPower = function(self, t) return self:combatTalentSpellDamage(t, 15, 50) end,
	action = function(self, t)
		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		golem:setEffect(golem.EFF_MIGHTY_BLOWS, 5, {power=t.getPower(self, t)})
		if golem == mover then
			golem:move(x, y, true)
		end
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你 将 傀 儡 拉 到 你 身 边， 使 它 暂 时 性 增 加 %d 点 近 战 物 理 强 度， 持 续 5 回 合。]]):
		format(power)
	end,
}

newTalent{
	name = "Golem Portal",
	type = {"spell/golemancy",4},
	require = spells_req4,
	points = 5,
	mana = 40,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 14, 10, true)) end, -- Limit to > 0
	action = function(self, t)
		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		local chance = math.min(100, self:getTalentLevelRaw(t) * 15 + 25)
		local px, py = self.x, self.y
		local gx, gy = golem.x, golem.y

		self:move(gx, gy, true)
		golem:move(px, py, true)
		self:move(gx, gy, true)
		golem:move(px, py, true)
		game.level.map:particleEmitter(px, py, 1, "teleport")
		game.level.map:particleEmitter(gx, gy, 1, "teleport")

		for uid, e in pairs(game.level.entities) do
			if e.getTarget then
				local _, _, tgt = e:getTarget()
				if e:reactionToward(self) < 0 and tgt == self and rng.percent(chance) then
					e:setTarget(golem)
					golem:logCombat(e, "#Target# 集中精神于 #Source#.")
				end
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[使 用 此 技 能 后， 你 和 傀 儡 将 会 交 换 位 置。 
		 你 的 敌 人 会 被 混 乱， 那 些 之 前 攻 击 你 的 敌 人 将 有 %d%% 概 率 转 而 攻 击 傀 儡。]]):
		format(math.min(100, self:getTalentLevelRaw(t) * 15 + 25))
	end,
}

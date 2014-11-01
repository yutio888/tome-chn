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

-- Thought Forms really only differ in the equipment they carry, the talents they have, and stat weights
-- cancelThoughtForms is in psionic.lua since it's used a few other places
-- Here we'll use a few functions to build them.

-- Build our tile from the summoners tile
local function buildTile(e) 
	if e.summoner.female then
		e.female = true
	end
	e.image = e.summoner.image
	e.moddable_tile = e.summoner.moddable_tile and e.summoner.moddable_tile or nil
	e.moddable_tile_base = e.summoner.moddable_tile_base and e.summoner.moddable_tile_base or nil
	e.moddable_tile_ornament = e.summoner.moddable_tile_ornament and e.summoner.moddable_tile_ornament or nil
	if e.summoner.image == "invis.png" and e.summoner.add_mos then
		local summoner_image, summoner_h, summoner_y = e.summoner.add_mos[1].image or nil, e.summoner.add_mos[1].display_h or nil, e.summoner.add_mos[1].display_y or nil
		if summoner_image and summoner_h and summoner_y then
			e.add_mos = {{image=summoner_image, display_h=summoner_h, display_y=summoner_y}}
		end
	end
end

-- Set up our act function so we don't run all over the map
local function setupAct(self)
	self.on_act = function(self)
		local tid = self.summoning_tid
		if not game.level:hasEntity(self.summoner) or self.summoner.dead or not self.summoner:isTalentActive(tid) then
			self:die(self)
		end
		if game.level:hasEntity(self.summoner) and core.fov.distance(self.x, self.y, self.summoner.x, self.summoner.y) > 10 then
			local Map = require "engine.Map"
			local x, y = util.findFreeGrid(self.summoner.x, self.summoner.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				return
			end
			-- Clear it's targeting on teleport
			self:setTarget(nil)
			self:move(x, y, true)
			game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})
		end
	end
end

-- And our die function to make sure our sustain is disabled properly
local function setupDie(self)
	self.on_die = function(self)
		local tid = self.summoning_tid
		game:onTickEnd(function() 
			if self.summoner:isTalentActive(tid) then
				self.summoner:forceUseTalent(tid, {ignore_energy=true})
			end
			if self.summoner:isTalentActive(self.summoner.T_OVER_MIND) then
				self.summoner:forceUseTalent(self.summoner.T_OVER_MIND, {ignore_energy=true})
			end
		end)
		-- Pass our summoner back as the target if we're controlled...  to prevent super cheese.
		if game.player == self then
			local tg = {type="ball", radius=10}
			self:project(tg, self.x, self.y, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if target and target.ai_target.actor == self then
					target:setTarget(self.summoner)
				end
			end)
		end
	end
end

-- Build our thought-form
function setupThoughtForm(self, m, x, y, t)
	-- Set up some basic stuff
	m.display = "p"
	m.blood_color = colors.YELLOW
	m.type = "thought-form"
	m.subtype = "thought-form"
	m.summoner_gain_exp=true
	m.faction = self.faction
	m.no_inventory_access = true
	m.rank = 2
	m.size_category = 3
	m.infravision = 10
	m.lite = 1
	m.no_breath = 1
	m.move_others = true

	-- Less tedium
	m.life_regen = 1
	m.stamina_regen = 1

	-- Make sure we don't gain anything from leveling
	m.autolevel = "none"
	m.unused_stats = 0
	m.unused_talents = 0
	m.unused_generics = 0
	m.unused_talents_types = 0
	m.exp_worth = 0
	m.no_points_on_levelup = true
	m.silent_levelup = true
	m.level_range = {self.level, self.level}

	-- Try to use stored AI talents to preserve tweaking over multiple summons
	m.ai_talents = self.stored_ai_talents and self.stored_ai_talents[m.name] or {}
	m.save_hotkeys = true

	-- Inheret some attributes
	if self:getTalentLevel(self.T_OVER_MIND) >=5 then
		m.inc_damage.all = (m.inc_damage.all) or 0 + (self.inc_damage.all or 0) + (self.inc_damage[engine.DamageType.MIND] or 0)
	end
	if self:getTalentLevel(self.T_OVER_MIND) >=3 then
		local save_bonus = self:combatMentalResist(fake)
		m:attr("combat_physresist", save_bonus)
		m:attr("combat_mentalresist", save_bonus)
		m:attr("combat_spellresist", save_bonus)
	end

	-- Add them to the party
	if game.party:hasMember(self) then
		m.remove_from_party_on_death = true
		game.party:addMember(m, {
			control="no",
			type="thought-form",
			title="thought-form",
			orders = {target=true, leash=true, anchor=true, talents=true},
		})
	end
	
	-- Build our act and die functions
	m.summoning_tid = t.id
	setupAct(m); setupDie(m)
	
	-- Add the thought-form to the level
	m:resolve() m:resolve(nil, true)
	m:forceLevelup(self.level)
	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0
	if self.name == "thought-forged bowman" then
		m.ai_tactic.safe_range = 2
	end
end

-- Thought-forms
newTalent{
	name = "Thought-Form: Bowman",
	short_name = "TF_BOWMAN",
	type = {"psionic/other", 1},
	points = 5, 
	require = psi_wil_req1,
	sustain_psi = 20,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = 24,
	range = 10,
	no_unlearn_last = true,
	getStatBonus = function(self, t) 
		local t = self:getTalentFromId(self.T_THOUGHT_FORMS)
		return t.getStatBonus(self, t)
	end,
	activate = function(self, t)
		cancelThoughtForms(self, t.id)
		
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end
		
		-- Do our stat bonuses here so we only roll for crit once	
		local stat_bonus = math.floor(self:mindCrit(t.getStatBonus(self, t)))
	
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			name = "thought-forged bowman", summoner = self,
			color=colors.SANDY_BROWN, shader = "shadow_simulacrum",
			shader_args = { color = {0.8, 0.8, 0.8}, base = 0.8, time_factor = 4000 },
			desc = [[A thought-forged bowman.  It appears ready for battle.]],
			body = { INVEN = 10, MAINHAND = 1, BODY = 1, QUIVER=1, HANDS = 1, FEET = 1},

			ai = "summoned", ai_real = "tactical",
			ai_state = { ai_move="move_complex", talent_in=3, ally_compassion=10 },
			ai_tactic = resolvers.tactic("ranged"),
			
			max_life = resolvers.rngavg(100,110),
			life_rating = 12,
			combat_armor = 0, combat_def = 0,
			stats = { mag=self:getMag(), wil=self:getWil(), cun=self:getCun()},
			inc_stats = {
				str = stat_bonus / 2,
				dex = stat_bonus,
				con = stat_bonus / 2,
			},
			
			resolvers.generic(function(e) buildTile(e) end), -- Make a moddable tile
			resolvers.talents{ 
				[Talents.T_WEAPON_COMBAT]= math.ceil(self.level/10),
				[Talents.T_BOW_MASTERY]= math.ceil(self.level/10),
				
				[Talents.T_CRIPPLING_SHOT]= math.ceil(self.level/10),
				[Talents.T_STEADY_SHOT]= math.ceil(self.level/10),
				[Talents.T_RAPID_SHOT]= math.ceil(self.level/10),
				
				[Talents.T_PSYCHOMETRY]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_BIOFEEDBACK]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_LUCID_DREAMER]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
			},
			resolvers.equip{
				{type="weapon", subtype="longbow", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="ammo", subtype="arrow", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="light", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="hands", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="feet", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
			},
			resolvers.sustains_at_birth(),
			
			-- Hack to make sure we top off ammo after every battle
			on_move = function(self)
				if game.player ~= self then
					local a = self:hasAmmo()
					if not a then print("[Thought-Form Bowman Ammo] - ERROR, NO AMMO") end
					if a and a.combat.shots_left < a.combat.capacity and not self.ai_target.actor and not self:hasEffect(self.EFF_RELOADING) then
						self:forceUseTalent(self.T_RELOAD, {})
					end
				end
			end,
		}

		setupThoughtForm(self, m, x, y, t)
		game:playSoundNear(self, "talents/spell_generic")
		
		local ret = {
			summon = m
		}
		if self:knowTalent(self.T_TF_UNITY) then
			local t = self:getTalentFromId(self.T_TF_UNITY)
			ret.speed = self:addTemporaryValue("combat_mindspeed", t.getSpeedPower(self, t)/100)
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.summon and p.summon.summoner == self then
			p.summon:die(p.summon)
		end
		if p.speed then self:removeTemporaryValue("combat_mindspeed", p.speed) end
		return true
	end,
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 身 穿 皮 甲 的 精 神 体 弓 箭 手。 当 精 神 体 弓 箭 手 到 达 对 应 等 级 时 可 习 得 弓 术 掌 握、 强 化 命 中、 稳 固 射 击、 致 残 射 击 和 急 速 射 击， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat/2, stat, stat/2)
	end,
}

newTalent{
	name = "Thought-Form: Warrior",
	short_name = "TF_WARRIOR",
	type = {"psionic/other", 1},
	points = 5, 
	require = psi_wil_req1,
	sustain_psi = 20,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = 24,
	range = 10,
	no_unlearn_last = true,
	getStatBonus = function(self, t) 
		local t = self:getTalentFromId(self.T_THOUGHT_FORMS)
		return t.getStatBonus(self, t)
	end,
	activate = function(self, t)
		cancelThoughtForms(self, t.id)
		
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end
		
		-- Do our stat bonuses here so we only roll for crit once		
		local stat_bonus = math.floor(self:mindCrit(t.getStatBonus(self, t)))
	
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			name = "thought-forged warrior", summoner = self, 
			color=colors.ORANGE, shader = "shadow_simulacrum",
			shader_args = { color = {0.8, 0.8, 0.8}, base = 0.8, time_factor = 4000 },
			desc = [[A thought-forged warrior wielding a massive hammer and clad in heavy armor.  It appears ready for battle.]],
			body = { INVEN = 10, MAINHAND = 1, BODY = 1, HANDS = 1, FEET = 1},
		
			ai = "summoned", ai_real = "tactical",
			ai_state = { ai_move="move_complex", talent_in=3, ally_compassion=10 },
			ai_tactic = resolvers.tactic("melee"),
			
			max_life = resolvers.rngavg(100,110),
			life_rating = 15,
			combat_armor = 0, combat_def = 0,
			stats = { mag=self:getMag(), wil=self:getWil(), cun=self:getCun()},
			inc_stats = {
				str = stat_bonus,
				dex = stat_bonus / 2,
				con = stat_bonus / 2,
			},

			resolvers.generic(function(e) buildTile(e) end), -- Make a moddable tile
			resolvers.talents{ 
				[Talents.T_ARMOUR_TRAINING]= 2,
				[Talents.T_WEAPON_COMBAT]= math.ceil(self.level/10),
				[Talents.T_WEAPONS_MASTERY]= math.ceil(self.level/10),
				
				[Talents.T_RUSH]= math.ceil(self.level/10),
				[Talents.T_DEATH_DANCE]= math.ceil(self.level/10),
				[Talents.T_BERSERKER]= math.ceil(self.level/10),

				[Talents.T_PSYCHOMETRY]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_BIOFEEDBACK]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_LUCID_DREAMER]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
			},
			resolvers.equip{
				{type="weapon", subtype="battleaxe", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="heavy", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="hands", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="feet", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
			},
			resolvers.sustains_at_birth(),
		}

		setupThoughtForm(self, m, x, y, t)

		game:playSoundNear(self, "talents/spell_generic")
		
		local ret = {
			summon = m
		}
		if self:knowTalent(self.T_TF_UNITY) then
			local t = self:getTalentFromId(self.T_TF_UNITY)
			ret.power = self:addTemporaryValue("combat_mindpower", t.getOffensePower(self, t))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.summon and p.summon.summoner == self then
			p.summon:die(p.summon)
		end
		if p.power then self:removeTemporaryValue("combat_mindpower", p.power) end
		return true
	end,
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 手 持 战 斧 的 精 神 体 狂 战 士。 当 精 神 体 狂 战 士 到 达 对 应 等 级 时 可 习 得 武 器 掌 握、 强 化 命 中、 嗜 血、 死 亡 之 舞 和 冲 锋， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat, stat/2, stat/2)
	end,
}

newTalent{
	name = "Thought-Form: Defender",
	short_name = "TF_DEFENDER",
	type = {"psionic/other", 1},
	points = 5, 
	require = psi_wil_req1,
	sustain_psi = 20,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = 24,
	range = 10,
	no_unlearn_last = true,
	getStatBonus = function(self, t) 
		local t = self:getTalentFromId(self.T_THOUGHT_FORMS)
		return t.getStatBonus(self, t)
	end,
	activate = function(self, t)
		cancelThoughtForms(self, t.id)
		
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end
		
		-- Do our stat bonuses here so we only roll for crit once	
		local stat_bonus = math.floor(self:mindCrit(t.getStatBonus(self, t)))
	
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			name = "thought-forged defender", summoner = self,
			color=colors.GOLD, shader = "shadow_simulacrum", 
			shader_args = { color = {0.8, 0.8, 0.8}, base = 0.8, time_factor = 4000 },
			desc = [[A thought-forged defender clad in massive armor.  It wields a sword and shield and appears ready for battle.]],
			body = { INVEN = 10, MAINHAND = 1, OFFHAND = 1, BODY = 1, HANDS = 1, FEET = 1},
			
			ai = "summoned", ai_real = "tactical",
			ai_state = { ai_move="move_complex", talent_in=3, ally_compassion=10 },
			ai_tactic = resolvers.tactic("tank"),
			
			max_life = resolvers.rngavg(100,110),
			life_rating = 15,
			combat_armor = 0, combat_def = 0,
			stats = { mag=self:getMag(), wil=self:getWil(), cun=self:getCun()},
			inc_stats = {
				str = stat_bonus / 2,
				dex = stat_bonus / 2,
				con = stat_bonus,
			},
			
			resolvers.generic(function(e) buildTile(e) end), -- Make a moddable tile
			resolvers.talents{ 
				[Talents.T_ARMOUR_TRAINING]= 2 + math.ceil(self.level/20),
				[Talents.T_WEAPON_COMBAT]= math.ceil(self.level/10),
				[Talents.T_WEAPONS_MASTERY]= math.ceil(self.level/10),
				
				[Talents.T_SHIELD_PUMMEL]= math.ceil(self.level/10),
				[Talents.T_SHIELD_WALL]= math.ceil(self.level/10),
				

				[Talents.T_PSYCHOMETRY]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_BIOFEEDBACK]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),
				[Talents.T_LUCID_DREAMER]= math.floor(self:getTalentLevel(self.T_TRANSCENDENT_THOUGHT_FORMS)),

			},
			resolvers.equip{
				{type="weapon", subtype="longsword", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="shield", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="massive", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="hands", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
				{type="armor", subtype="feet", autoreq=true, forbid_power_source={arcane=true}, not_properties = {"unique"} },
			},
			resolvers.sustains_at_birth(),
		}

		setupThoughtForm(self, m, x, y, t)

		game:playSoundNear(self, "talents/spell_generic")
		
		local ret = {
			summon = m
		}
		if self:knowTalent(self.T_TF_UNITY) then
			local t = self:getTalentFromId(self.T_TF_UNITY)
			ret.resist = self:addTemporaryValue("resists", {all= t.getDefensePower(self, t)})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.summon and p.summon.summoner == self then
			p.summon:die(p.summon)
		end
		if p.resist then self:removeTemporaryValue("resists", p.resist) end
		return true
	end,
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 手 持 剑 盾 的 精 神 体 盾 战 士。 当 精 神 体 盾 战 士 到 达 对 应 等 级 时 可 习 得 护 甲 掌 握、 武 器 掌 握、 强 化 命 中、 盾 牌 连 击 和 盾 墙， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat/2, stat/2, stat)
	end,
}

newTalent{
	name = "Thought-Forms",
	short_name = "THOUGHT_FORMS",
	type = {"psionic/thought-forms", 1},
	points = 5, 
	require = psi_wil_req1,
	mode = "passive",
	range = 10,
	getStatBonus = function(self, t) return self:combatTalentMindDamage(t, 5, 50) end,
	on_learn = function(self, t)
		if self:getTalentLevel(t) >= 1 and not self:knowTalent(self.T_TF_BOWMAN) then
			self:learnTalent(self.T_TF_BOWMAN, true)
		end
		if self:getTalentLevel(t) >= 3 and not self:knowTalent(self.T_TF_WARRIOR) then
			self:learnTalent(self.T_TF_WARRIOR, true)
		end
		if self:getTalentLevel(t) >= 5 and not self:knowTalent(self.T_TF_DEFENDER) then
			self:learnTalent(self.T_TF_DEFENDER, true)
		end
	end,	
	on_unlearn = function(self, t)
		if self:getTalentLevel(t) < 1 and self:knowTalent(self.T_TF_BOWMAN) then
			self:unlearnTalent(self.T_TF_BOWMAN)
		end
		if self:getTalentLevel(t) < 3 and self:knowTalent(self.T_TF_WARRIOR) then
			self:unlearnTalent(self.T_TF_WARRIOR)
		end
		if self:getTalentLevel(t) < 5 and self:knowTalent(self.T_TF_DEFENDER) then
			self:unlearnTalent(self.T_TF_DEFENDER)
		end
	end,
	info = function(self, t)
		local bonus = t.getStatBonus(self, t)
		local range = self:getTalentRange(t)
		return([[你 从 脑 海 里 召 唤 出 一 位 强 大 的 守 护 者。 
		 你 的 守 护 者 主 属 性 会 增 加 %d ， 他 的 两 项 副 属 性 会 增 加 %d ， 同 时 他 的 力 量、 灵 巧 和 意 志 属 性 等 同 于 你 的 属 性 值。 
		 在 等 级 1 时， 你 会 召 唤 出 身 着 皮 甲 的 弓 箭 手 大 师； 
		 在 等 级 3 时， 你 会 召 唤 出 手 持 双 手 武 器 的 精 英 狂 战 士； 
		 在 等 级 5 时， 你 会 召 唤 出 手 持 剑 盾 的 精 英 盾 战 士。 
		 精 神 体 只 能 存 在 于 %d 码 范 围 内， 若 超 出 此 范 围， 则 精 神 体 会 回 到 你 身 边。 
		 在 同 一 时 间 内 只 有 一 种 具 象 之 弧 可 以 激 活。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(bonus, bonus/2, range)
	end,
}

newTalent{
	name = "Transcendent Thought-Forms",
	short_name = "TRANSCENDENT_THOUGHT_FORMS",
	type = {"psionic/thought-forms", 2},
	points = 5, 
	require = psi_wil_req2,
	mode = "passive",
	info = function(self, t)
		local level = math.floor(self:getTalentLevel(t))
		return([[你 的 精 神 体 习 得 技 能 等 级 为 %d 的 清 晰 梦 境、 生 物 反 馈 和 共 鸣 之 心。]]):format(level)
	end,
}

newTalent{
	name = "Over Mind",
	type = {"psionic/thought-forms", 3},
	points = 5, 
	require = psi_wil_req3,
	sustain_psi = 50,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = 24,
	no_npc_use = true,
	getControlBonus = function(self, t) return self:combatTalentMindDamage(t, 5, 50) end,
--	getRangeBonus = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	on_pre_use = function(self, t, silent) if not game.party:findMember{type="thought-form"} then if not silent then game.logPlayer(self, "You must have an active Thought-Form to use this talent!") end return false end return true end,
	activate = function(self, t)
		-- Find our thought-form
		local target = game.party:findMember{type="thought-form"}
		
		-- Modify the control permission
		local old_control = game.party:hasMember(target).control
		game.party:hasMember(target).control = "full"
				
		-- Store life bonus and heal value
		local life_bonus = target.max_life * (t.getControlBonus(self, t)/100)
		
		-- Switch on TickEnd so every thing applies correctly
		game:onTickEnd(function() 
			game.level.map:particleEmitter(self.x, self.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})
			game.party:hasMember(target).on_control = function(self)
				self.summoner.over_mind_ai = self.summoner.ai
				self.summoner.ai = "none"
				self:hotkeyAutoTalents()
			end
			game.party:hasMember(target).on_uncontrol = function(self)
				self.summoner.ai = self.summoner.over_mind_ai
				if self.summoner:isTalentActive(self.summoner.T_OVER_MIND) then
					self.summoner:forceUseTalent(self.summoner.T_OVER_MIND, {ignore_energy=true})
				end
				game.level.map:particleEmitter(self.x, self.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})
				game.level.map:particleEmitter(self.summoner.x, self.summoner.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})
			end
			game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=225, rM=255, gm=225, gM=255, bm=225, bM=255, am=35, aM=90})
			game.party:setPlayer(target)
			self:resetCanSeeCache()
		end)
		
		game:playSoundNear(self, "talents/teleport")
			
		local ret = {
			target = target, old_control = old_control,
			life = target:addTemporaryValue("max_life", life_bonus),
			speed = target:addTemporaryValue("combat_physspeed", t.getControlBonus(self, t)/100),
			damage = target:addTemporaryValue("inc_damage", {all=t.getControlBonus(self, t)}),
			target:heal(life_bonus, self),
		}
		
		return ret
	end,
	deactivate = function(self, t, p)
		if p.target then
			p.target:removeTemporaryValue("max_life", p.life)
			p.target:removeTemporaryValue("inc_damage", p.damage)
			p.target:removeTemporaryValue("combat_physspeed", p.speed)
		
			if game.party:hasMember(p.target) then
				game.party:hasMember(p.target).control = old_control
			end
		end
		return true
	end,
	info = function(self, t)
		local bonus = t.getControlBonus(self, t)
--		local range = t.getRangeBonus(self, t)
		return ([[直 接 控 制 当 前 的 精 神 体， 增 加 其 %d%% 伤 害、 攻 速 以 及 最 大 生 命 值， 但 是 此 时 你 的 身 体 会 处 于 比 较 脆 弱 的 状 态。 
		 在 等 级 1 时， 你 的 守 护 者 所 获 得 的 任 何 反 馈 值 也 会 传 递 给 你。 
		 在 等 级 3 时， 你 的 守 护 者 会 获 得 所 有 豁 免 的 增 益 效 果， 数 值 等 同 你 精 神 豁 免 的 大 小。 
		 在 等 级 5 时， 它 们 会 获 得 伤 害 增 益， 增 益 值 基 于 你 的 额 外 精 神 伤 害。 
		 等 级 3 的 增 益 为 被 动 效 果， 无 论 此 技 能 是 否 激 活 均 有 效。 
		 受 精 神 强 度 影 响， 增 益 效 果 有 额 外 加 成。]]):format(bonus)
	end,
}

newTalent{
	name = "Thought-Form Unity",
	short_name = "TF_UNITY",
	type = {"psionic/thought-forms", 4},
	points = 5, 
	require = psi_wil_req4,
	mode = "passive",
	getSpeedPower = function(self, t) return self:combatTalentMindDamage(t, 5, 15) end,
	getOffensePower = function(self, t) return self:combatTalentMindDamage(t, 10, 30) end,
	getDefensePower = function(self, t) return self:combatTalentMindDamage(t, 1, 10) end,
	info = function(self, t)
		local offense = t.getOffensePower(self, t)
		local defense = t.getDefensePower(self, t)
		local speed = t.getSpeedPower(self, t)
		return([[现 在， 当 具 象 之 弧： 弓 箭 手 激 活 时， 你 提 升 %d%% 精 神 速 度； 
		 当 具 象 之 弧： 狂 战 士 激 活 时， 你 提 升 %d 精 神 强 度； 
		 当 具 象 之 弧： 盾 战 士 激 活 时， 你 提 升 %d%% 所 有 抵 抗。 
		 受 精 神 强 度 影 响， 增 益 效 果 按 比 例 加 成。]]):format(speed, offense, defense, speed)
	end,
}
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
	name = "Shadow Tunnel",
	type = {"spell/shades",1},
	require = spells_req_high1,
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 20,
	range = 10,
	tactical = { DEFEND = 2 },
	requires_target = true,
	getChance = function(self, t) return 20 + self:combatTalentSpellDamage(t, 15, 60) end,
	action = function(self, t)
		local list = {}
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion then list[#list+1] = act end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion then list[#list+1] = act end
			end
		end

		local empower = necroEssenceDead(self)
		for i, m in ipairs(list) do
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if x and y then
				m:move(x, y, true)
				game.level.map:particleEmitter(x, y, 1, "summon")
			end
			m:setEffect(m.EFF_EVASION, 5, {chance=t.getChance(self, t)})
			if empower then
				m:heal(m.max_life * 0.3)
				if core.shader.active(4) then
					m:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
					m:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
				end
			end
		end
		if empower then empower() end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[用 一 片 黑 暗 笼 罩 你 的 亡 灵 随 从。 
		 黑 暗 会 传 送 他 们 到 你 身 边 并 使 他 们 增 加 %d%% 闪 避， 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 闪 避 率 有 额 外 加 成。]]):
		format(chance)
	end,
}

newTalent{
	name = "Curse of the Meek",
	type = {"spell/shades",2},
	require = spells_req_high2,
	points = 5,
	mana = 50,
	cooldown = 30,
	range = 10,
	tactical = { DEFEND = 3 },
	action = function(self, t)
		local nb = math.ceil(self:getTalentLevel(t))
		for i = 1, nb do
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if x and y then
				local NPC = require "mod.class.NPC"
				local m = NPC.new{
					type = "humanoid", display = "p",
					color=colors.WHITE,

					combat = { dam=resolvers.rngavg(1,2), atk=2, apr=0, dammod={str=0.4} },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					lite = 3,

					life_rating = 10,
					rank = 2,
					size_category = 3,

					autolevel = "warrior",
					stats = { str=12, dex=8, mag=6, con=10 },
					ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, },
					level_range = {1, 3},

					max_life = resolvers.rngavg(30,40),
					combat_armor = 2, combat_def = 0,

					summoner = self,
					summoner_gain_exp=false,
					summon_time = 8,
				}

				m.level = 1
				local race = 5 -- rng.range(1, 5)
				if race == 1 then
					m.name = "human farmer"
					m.subtype = "human"
					m.image = "npc/humanoid_human_human_farmer.png"
					m.desc = [[A weather-worn human farmer, looking at a loss as to what's going on.]]
				elseif race == 2 then
					m.name = "halfling gardener"
					m.subtype = "halfling"
					m.desc = [[A rugged halfling gardener, looking quite confused as to what he's doing here.]]
					m.image = "npc/humanoid_halfling_halfling_gardener.png"
				elseif race == 3 then
					m.name = "shalore scribe"
					m.subtype = "shalore"
					m.desc = [[A scrawny elven scribe, looking bewildered at his surroundings.]]
					m.image = "npc/humanoid_shalore_shalore_rune_master.png"
				elseif race == 4 then
					m.name = "dwarven lumberjack"
					m.subtype = "dwarf"
					m.desc = [[A brawny dwarven lumberjack, looking a bit upset at his current situation.]]
					m.image = "npc/humanoid_dwarf_lumberjack.png"
				elseif race == 5 then
					m.name = "cute bunny"
					m.type = "vermin" m.subtype = "rodent"
					m.desc = [[It is so cute!]]
					m.image = "npc/vermin_rodent_cute_little_bunny.png"
				end
				m.faction = self.faction
				m.no_necrotic_soul = true

				m:resolve() m:resolve(nil, true)
				m:forceLevelup(self.level)
				game.zone:addEntity(game.level, m, "actor", x, y)
				game.level.map:particleEmitter(x, y, 1, "summon")
				m:setEffect(m.EFF_CURSE_HATE, 100, {src=self})
				m.on_die = function(self, src)
					local p = self.summoner:isTalentActive(self.summoner.T_NECROTIC_AURA)
					if p and src and src.reactionToward and src:reactionToward(self) < 0 and rng.percent(70) then
						self.summoner:incSoul(1)
						self.summoner.changed = true
					end
				end
			end
		end
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[通 过 阴 影， 从 安 全 地 区 召 唤 %d 个 无 害 生 物。 
		 这 些 生 物 会 受 到 仇 恨 诅 咒， 吸 引 附 近 所 有 的 敌 人 的 攻 击。 
		 若 这 些 生 物 被 敌 人 杀 死， 你 有 70%% 概 率 增 加 1 个 灵 魂。]]):
		format(math.ceil(self:getTalentLevel(t)))
	end,
}

newTalent{
	name = "Forgery of Haze",
	type = {"spell/shades",3},
	require = spells_req_high3,
	points = 5,
	mana = 70,
	cooldown = 30,
	range = 10,
	tactical = { ATTACK = 2, },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 30, 4, 8.1)) end, -- Limit <30
	getHealth = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 20, 500), 1.0, 0.2, 0, 0.58, 384) end,  -- Limit health < 100%
	getDam = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 500), 1.40, 0.4, 0, 0.76, 361) end,  -- Limit damage < 140%
	action = function(self, t)
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end

		local m = require("mod.class.NPC").new(self:cloneFull{
			shader = "shadow_simulacrum",
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			name = "Forgery of Haze ("..self.name..")",
			desc = [[A dark shadowy shape whose form resembles yours.]],
		})
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil

		m.energy.value = 0
		m.player = nil
		m.max_life = m.max_life * t.getHealth(self, t)
		m.life = util.bound(m.life, 0, m.max_life)
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.can_talk = nil
		m.puuid = nil
		m.on_takehit = nil
		m.exp_worth = 0
		m.no_inventory_access = true
		m.clone_on_hit = nil
		m:unlearnTalentFull(m.T_CREATE_MINIONS)
		m:unlearnTalentFull(m.T_FORGERY_OF_HAZE)
		m.remove_from_party_on_death = true
		m.inc_damage.all = ((100 + (m.inc_damage.all or 0)) * t.getDam(self, t)) - 100

		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="no",
				type="minion",
				title="Forgery of Haze",
				orders = {target=true},
			})
		end

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[你 使 用 暗 影 复 制 自 己， 生 成 一 个 分 身， 持 续 %d 回 合。 
		 你 的 分 身 继 承 你 的 天 赋 和 属 性， 继 承 %d%% 生 命 值 和 %d%% 伤 害。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100)
	end,
}

newTalent{
	name = "Frostdusk",
	type = {"spell/shades",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getDarknessDamageIncrease = function(self, t) return self:getTalentLevelRaw(t) * 2 end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 17, 50, true) end,  -- Limit to < 100%
	getAffinity = function(self, t) return self:combatTalentLimit(t, 100, 10, 50) end, -- Limit < 100%
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local ret = {
			dam = self:addTemporaryValue("inc_damage", {[DamageType.DARKNESS] = t.getDarknessDamageIncrease(self, t), [DamageType.COLD] = t.getDarknessDamageIncrease(self, t)}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.DARKNESS] = t.getResistPenalty(self, t)}),
			affinity = self:addTemporaryValue("damage_affinity", {[DamageType.DARKNESS] = t.getAffinity(self, t)}),
		}
		local particle
		if core.shader.active(4) then
			ret.particle1 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="spinningwinds_black"}, {type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=2.0, verticalIntensityAdjust=-3.0}))
			ret.particle1.toback = true
			ret.particle2 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="spinningwinds_black"}, {type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=1.0, verticalIntensityAdjust=-3.0}))
		else
			ret.particle1 = self:addParticles(Particles.new("ultrashield", 1, {rm=0, rM=0, gm=0, gM=0, bm=10, bM=100, am=70, aM=180, radius=0.4, density=60, life=14, instop=20}))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		if p.particle1 then self:removeParticles(p.particle1) end
		if p.particle2 then self:removeParticles(p.particle2) end
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		self:removeTemporaryValue("damage_affinity", p.affinity)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getDarknessDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local affinity = t.getAffinity(self, t)
		return ([[ 让 幽 暗 极 冰 围 绕 你， 增 加 你 %d%% 所 有 的 暗 影 系 和 冰 冷 系 伤 害 并 无 视 目 标 %d%% 暗 影 抵 抗。 
		 此 外， 你 受 到 的 所 有 暗 影 伤 害 可 治 疗 你。 治 疗 量 为 %d%% 暗 影 伤 害 值。]])
		:format(damageinc, ressistpen, affinity)
	end,
}

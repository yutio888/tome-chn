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

local minions_list = {
	bone_giant = {
		type = "undead", subtype = "giant",
		blood_color = colors.GREY,
		display = "K",
		combat = { dam=resolvers.levelup(resolvers.mbonus(45, 20), 1, 1), atk=15, apr=10, dammod={str=0.8} },
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		infravision = 10,
		life_rating = 12,
		max_stamina = 90,
		rank = 2,
		size_category = 4,
		autolevel = "warrior",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=2, },
		stats = { str=20, dex=52, mag=16, con=16 },
		resists = { [DamageType.PHYSICAL] = 20, [DamageType.BLIGHT] = 20, [DamageType.COLD] = 50, },
		open_door = 1,
		no_breath = 1,
		confusion_immune = 1,
		poison_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		stun_immune = 1,
		see_invisible = resolvers.mbonus(15, 5),
		undead = 1,
		name = "bone giant", color=colors.WHITE,
		desc = [[A towering creature, made from the bones of dozens of dead bodies. It is covered by an unholy aura.]],
		resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_bone_giant.png", display_h=2, display_y=-1}}},
		max_life = resolvers.rngavg(100,120),
		level_range = {1, nil}, exp_worth = 0,
		combat_armor = 20, combat_def = 0,
		on_melee_hit = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		resolvers.talents{ T_BONE_ARMOUR={base=3, every=10, max=5}, T_STUN={base=3, every=10, max=5}, },
	},
	h_bone_giant = {
		type = "undead", subtype = "giant",
		blood_color = colors.GREY,
		display = "K",
		combat = { dam=resolvers.levelup(resolvers.mbonus(45, 20), 1, 1), atk=15, apr=10, dammod={str=0.8} },
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		infravision = 10,
		life_rating = 12,
		max_stamina = 90,
		rank = 2,
		size_category = 4,
		autolevel = "warrior",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=2, },
		stats = { str=20, dex=52, mag=16, con=16 },
		resists = { [DamageType.PHYSICAL] = 20, [DamageType.BLIGHT] = 20, [DamageType.COLD] = 50, },
		open_door = 1,
		no_breath = 1,
		confusion_immune = 1,
		poison_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		stun_immune = 1,
		see_invisible = resolvers.mbonus(15, 5),
		undead = 1,
		name = "heavy bone giant", color=colors.RED,
		desc = [[A towering creature, made from the bones of hundreds of dead bodies. It is covered by an unholy aura.]],
		resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_heavy_bone_giant.png", display_h=2, display_y=-1}}},
		level_range = {1, nil}, exp_worth = 0,
		max_life = resolvers.rngavg(100,120),
		combat_armor = 20, combat_def = 0,
		on_melee_hit = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		resolvers.talents{ T_BONE_ARMOUR={base=3, every=10, max=5}, T_THROW_BONES={base=4, every=10, max=7}, T_STUN={base=3, every=10, max=5}, },
	},
	e_bone_giant = {
		type = "undead", subtype = "giant",
		blood_color = colors.GREY,
		display = "K",
		combat = { dam=resolvers.levelup(resolvers.mbonus(45, 20), 1, 1), atk=15, apr=10, dammod={str=0.8} },
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		infravision = 10,
		life_rating = 12,
		max_stamina = 90,
		rank = 2,
		size_category = 4,
		autolevel = "warrior",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=2, },
		stats = { str=20, dex=52, mag=16, con=16 },
		resists = { [DamageType.PHYSICAL] = 20, [DamageType.BLIGHT] = 20, [DamageType.COLD] = 50, },
		open_door = 1,
		no_breath = 1,
		confusion_immune = 1,
		poison_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		stun_immune = 1,
		see_invisible = resolvers.mbonus(15, 5),
		undead = 1,
		name = "eternal bone giant", color=colors.GREY,
		desc = [[A towering creature, made from the bones of hundreds of dead bodies. It is covered by an unholy aura.]],
		resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_eternal_bone_giant.png", display_h=2, display_y=-1}}},
		level_range = {1, nil}, exp_worth = 0,
		max_life = resolvers.rngavg(100,120),
		combat_armor = 40, combat_def = 20,
		on_melee_hit = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(15, 5)},
		autolevel = "warriormage",
		resists = {all = 50},
		resolvers.talents{ T_BONE_ARMOUR={base=5, every=10, max=7}, T_STUN={base=3, every=10, max=5}, T_SKELETON_REASSEMBLE=5, },
	},
	r_bone_giant = {
		type = "undead", subtype = "giant",
		blood_color = colors.GREY,
		display = "K",
		combat = { dam=resolvers.levelup(resolvers.mbonus(45, 20), 1, 1), atk=15, apr=10, dammod={str=0.8} },
		body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
		infravision = 10,
		life_rating = 12,
		max_stamina = 90,
		rank = 2,
		size_category = 4,
		autolevel = "warrior",
		ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=2, },
		stats = { str=20, dex=52, mag=16, con=16 },
		resists = { [DamageType.PHYSICAL] = 20, [DamageType.BLIGHT] = 20, [DamageType.COLD] = 50, },
		open_door = 1,
		no_breath = 1,
		confusion_immune = 1,
		poison_immune = 1,
		blind_immune = 1,
		fear_immune = 1,
		stun_immune = 1,
		see_invisible = resolvers.mbonus(15, 5),
		undead = 1,
		name = "runed bone giant", color=colors.RED,
		desc = [[A towering creature, made from the bones of hundreds of dead bodies, rune-etched and infused with hateful sorceries.]],
		resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_runed_bone_giant.png", display_h=2, display_y=-1}}},
		level_range = {1, nil}, exp_worth = 0,
		rank = 3,
		max_life = resolvers.rngavg(100,120),
		combat_armor = 20, combat_def = 40,
		melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(15, 15)},
		autolevel = "warriormage",
		resists = {all = 30},
		resolvers.talents{
			T_BONE_ARMOUR={base=5, every=10, max=7},
			T_STUN={base=3, every=10, max=5},
			T_SKELETON_REASSEMBLE=5,
			T_ARCANE_POWER={base=4, every=5, max = 8},
			T_MANATHRUST={base=4, every=5, max = 10},
			T_MANAFLOW={base=5, every=5, max = 10},
			T_STRIKE={base=4, every=5, max = 12},
			T_INNER_POWER={base=4, every=5, max = 10},
			T_EARTHEN_MISSILES={base=5, every=5, max = 10},
		},
		resolvers.sustains_at_birth(),
	},
}

newTalent{
	name = "Undead Explosion",
	type = {"spell/advanced-necrotic-minions",1},
	require = spells_req_high1,
	points = 5,
	mana = 30,
	cooldown = 10,
	tactical = { ATTACKAREA = { BLIGHT = 2 } },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	range = 8,
	requires_target = true,
	no_npc_use = true,
	getDamage = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 20, 70), 90, 0, 0, 25, 25) end, -- Limit to 50% life
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend"}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or not target.summoner == self or not target.necrotic_minion then return nil end

		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, friendlyfire=not rng.percent(self:getTalentLevelRaw(self.T_DARK_EMPATHY) * 0.2)}
		local dam = target.max_life * t.getDamage(self, t) / 100
		target:die()
		target:project(tg, target.x, target.y, DamageType.BLIGHT, dam)
		game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_acid", {radius=tg.radius})

		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		return ([[亡 灵 随 从 只 是 工 具。 你 可 以 残 忍 地 引 爆 它 们。 
		 使 目 标 单 位 爆 炸 并 造 成 枯 萎 伤 害， 伤 害 为 它 最 大 生 命 值 的 %d%% ,半 径 为 %d 。 
		 注 意！ 别 站 在 爆 炸 范 围 内！( 除 非 你 学 会 了 黑 暗 共 享， 这 样 你 有 %d%% 几 率 无 视 伤 害。)]]):
		format(t.getDamage(self, t),t.radius(self,t), self:getTalentLevelRaw(self.T_DARK_EMPATHY) * 20)
	end,
}

newTalent{
	name = "Assemble",
	type = {"spell/advanced-necrotic-minions",2},
	require = spells_req_high2,
	points = 5,
	mana = 90,
	cooldown = 25,
	tactical = { ATTACK = 10 },
	requires_target = true,
	on_pre_use = function(self, t)
		local nb = 0
		local nbgolem = 0
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					if act.subtype ~= "giant" then nb = nb + 1
					else nbgolem = nbgolem + 1 end
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					if act.subtype ~= "giant" then nb = nb + 1
					else nbgolem = nbgolem + 1 end
				end
			end
		end
		if nb < 3 then return false end
		local maxgolem = 1
		if necroEssenceDead(self, true) then maxgolem = 2 end
		if nbgolem >= maxgolem then return false end
		return true
	end,
	getLevel = function(self, t) return math.floor(self:combatScale(self:getTalentLevel(t), -6, 0.9, 2, 5)) end, -- -6 @ 1, +2 @ 5, +5 @ 8
	action = function(self, t)
		local nbgolem = 0
		local make_golem = function()
			local list = {}
			nbgolem = 0
			if game.party and game.party:hasMember(self) then
				for act, def in pairs(game.party.members) do
					if act.summoner and act.summoner == self and act.necrotic_minion then
						if act.subtype ~= "giant" then list[#list+1] = act
						else nbgolem = nbgolem + 1 end
					end
				end
			else
				for uid, act in pairs(game.level.entities) do
					if act.summoner and act.summoner == self and act.necrotic_minion then
						if act.subtype ~= "giant" then list[#list+1] = act
						else nbgolem = nbgolem + 1 end
					end
				end
			end
			if #list < 3 then return end

			rng.tableRemove(list):die(self)
			rng.tableRemove(list):die(self)
			rng.tableRemove(list):die(self)

			local kind = ({"bone_giant","bone_giant","h_bone_giant","h_bone_giant","e_bone_giant"})[util.bound(math.floor(self:getTalentLevel(t)), 1, 5)]
			if self:getTalentLevel(t) >= 6 and rng.percent(20) then kind = "r_bone_giant" end

			local minion = require("mod.class.NPC").new(minions_list[kind])
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if minion and x and y then
				local lev = t.getLevel(self, t)
				necroSetupSummon(self, minion, x, y, lev, true)
				nbgolem = nbgolem + 1
			end
		end

		local empower = necroEssenceDead(self)
		for i = 1, empower and 2 or 1 do
			make_golem()
			if nbgolem >= (empower and 2 or 1) then break end
		end

		if nbgolem >= 2 and empower then empower() end

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[将 3 个 单 位 组 合 成 1 个 骨 巨 人。 
		 在 等 级 1 时 它 可 以 制 造 1 个 骨 巨 人。 
		 在 等 级 3 时 它 可 以 制 造 1 个 重 型 骨 巨 人。 
		 在 等 级 5 时 它 可 以 制 造 1 个 不 朽 骨 巨 人。 
		 在 等 级 6 时 它 可 以 有 20%% 几 率 制 造 1 个 符 文 骨 巨 人。 
		 在 同 一 时 间 只 能 激 活 %s。]]):
		format(necroEssenceDead(self, true) and "2 个 骨 巨 人" or "1 个 骨 巨 人")
	end,
}

newTalent{
	name = "Sacrifice",
	type = {"spell/advanced-necrotic-minions",3},
	require = spells_req_high3,
	points = 5,
	mana = 5,
	cooldown = 25,
	tactical = { DEFEND = 1 },
	requires_target = true,
	on_pre_use = function(self, t)
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					if act.subtype == "giant" then return true end
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					if act.subtype == "giant" then return true end
				end
			end
		end
		return false
	end,
	getTurns = function(self, t) return math.floor(4 + self:combatTalentSpellDamage(t, 8, 20)) end,
	getPower = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 22.5, 16.5)) end, -- Limit >10%
	action = function(self, t)
		local list = {}
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion and act.subtype == "giant" then list[#list+1] = act end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion and act.subtype == "giant" then list[#list+1] = act end
			end
		end
		if #list < 1 then return end

		rng.tableRemove(list):die(self)

		self:setEffect(self.EFF_BONE_SHIELD, t.getTurns(self, t), {power=t.getPower(self, t)})

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[牺 牲 1 个 骨 巨 人。 使 用 它 的 骨 头， 你 可 以 制 造 一 个 临 时 的 骨 盾， 格 挡 超 过 你 总 生 命 值 的 %d%% 的 任 何 伤 害。 
		 此 效 果 持 续 %d 回 合。]]):
		format(t.getPower(self, t), t.getTurns(self, t))
	end,
}

newTalent{
	name = "Minion Mastery",
	type = {"spell/advanced-necrotic-minions",4},
	require = spells_req_high4,
	points = 5,
	mode = "passive",
	info = function(self, t)
		return ([[你 召 唤 的 每 个 亡 灵 单 位 有 概 率 进 阶:%s]]):
		format(self:callTalent(self.T_CREATE_MINIONS,"MinionChancesDesc")
		:gsub("Degenerated skeleton warrior","堕 落 骷 髅 战 士"):gsub("Skeleton warrior","骷 髅 战 士"):gsub("Armoured skeleton warrior","装 甲 骷 髅 战 士")
		:gsub("Skeleton archer","骷 髅 弓 箭 手"):gsub("Skeleton master archer","精 英 骷 髅 弓 箭 手"):gsub("Skeleton mage","骷 髅 法 师")
		:gsub("Ghoul","食 尸 鬼"):gsub("Ghast","妖 鬼"):gsub("king","王")
		:gsub("Vampire","吸 血 鬼"):gsub("Master vampire","精 英 吸 血 鬼"):gsub("Grave wight","坟 墓 尸 妖")
		:gsub("Barrow wight","古 墓 尸 妖"):gsub("Dread","梦靥"):gsub("Lich","巫妖")
		)
	end,
}

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

local Object = require "engine.Object"
local Dialog = require "engine.ui.Dialog"

local curses_detrimental
local curses_beneficial
local curses_weapon

newTalent{
	name = "Defiling Touch",
	type = {"cursed/cursed-aura", 1},
	require = cursed_lev_req1,
	points = 5,
	cooldown = 0,
	no_energy = true,
	no_npc_use = true,
	--no_unlearn_last = true,
	-- list of all curses
	getCurses = function(self, t)
		return { self.EFF_CURSE_OF_CORPSES, self.EFF_CURSE_OF_MADNESS, self.EFF_CURSE_OF_MISFORTUNE, self.EFF_CURSE_OF_NIGHTMARES, self.EFF_CURSE_OF_SHROUDS }
	end,
	cursePenalty = function(self, t)
		return self:combatTalentLimit(math.max(1, self:getTalentLevel(t)-4), 0, 1, 0.64)
	end,
	-- tests whether or not an item can be cursed (takes into account current talent level unless ignoreLevel = true)
	canCurseItem = function(self, t, item, level)
		if not item:wornInven() then return false end

		-- Godslayers are far too powerful to be affected
		if item.godslayer then return false end
		if item.no_curses then return false end

		-- possible slots:
		-- body, head, feet, hands, cloak, belt (armor)
		-- mainhand (weapon), offhand (weapon/armor;shield), psionic (weapon)
		-- finger (X2), neck (jewelry)
		-- lite (lite), tool (tool), quiver (ammo), gem (alchemist-gem)
		level = level or self:getTalentLevel(t)
		if level >= 1 and item.type == "weapon" then return true end
		if level >= 2 and item.type == "armor" and (item.slot == "BODY" or item.slot == "CLOAK")  then return true end
		if level >= 3 and item.type == "armor" and (item.slot == "HEAD" or item.slot == "OFFHAND")  then return true end
		if level >= 4 and item.type == "armor" and (item.slot == "HANDS" or item.slot == "FEET" or item.slot == "BELT")  then return true end
		if level >=6 and item.type == "jewelry" and item.slot == "FINGER" then return true end
		if level >=7 and item.type == "jewelry" and item.slot == "NECK" then return true end
		if level >=8 and item.type == "lite" and item.slot == "LITE" then return true end
		if level >=9 and (item.type == "charm" or item.type == "tool") and item.slot == "TOOL" then return true end
		if level >=10 and item.slot == "QUIVER" and (item.type == "alchemist-gem" or item.type == "ammo")  then return true end

		return false
	end,
	-- curses an item
	curseItem = function(self, t, item)
		if item.curse then return end
		if not t.canCurseItem(self, t, item) then return end

		-- apply the curse
		if item.define_as == "CLOAK_DECEPTION" then
			-- cloak of deception is always Corpses..
			item.curse = self.EFF_CURSE_OF_CORPSES
		else
			local curses = t.getCurses(self, t)
			item.curse = rng.table(curses)
		end

		local def = self.tempeffect_def[item.curse]
		item.special = true
		local chndesc = def.short_desc:gsub("Madness","疯狂"):gsub("Misfortune","厄运"):gsub("Shrouds","屏障"):gsub("Corpses","尸体"):gsub("Nightmare","噩梦")
		item.add_name = (item.add_name or "").." ("..def.short_desc..")"
	end,
	-- curses all items on the floor
	curseFloor = function(self, t, x, y)
		local i = 1
		local item = game.level.map:getObject(x, y, i)
		while item do
			t.curseItem(self, t, item)

			i = i + 1
			item = game.level.map:getObject(x, y, i)
		end
	end,
	-- curses all items in inventory
	curseInventory = function(self, t)
		for id, inven in pairs(self.inven) do
			for i, item in ipairs(inven) do
				t.curseItem(self, t, item)
			end
		end
	end,
	-- sets a cursed aura (+2 curse bonus)
	setCursedAura = function(self, t, curse)
		self.cursed_aura = curse
		t.updateCurses(self, t)
	end,
	-- gets the name of the currently set cursed aura
	getCursedAuraName = function(self, t)
		if not self.cursed_aura then
			return "None"
		else
			return self.tempeffect_def[self.cursed_aura].desc
		end
	end,
	on_onWear = function(self, t, o)
		t.updateCurses(self, t)
	end,
	on_onTakeOff = function(self, t, o)
		t.updateCurses(self, t)
	end,

	-- chooses whether the player accepts the cursed aura tree when a cursable item is found. only offered once for Afflicted classes
	chooseCursedAuraTree = function(self, t)
		local choose = false
		local x, y, i = self.x, self.y, 1
		local item = game.level.map:getObject(x, y, i)
		while item and not choose do
			if t.canCurseItem(self, t, item, 1) then
				choose = true
			else
				i = i + 1
				item = game.level.map:getObject(x, y, i)
			end
		end

		if choose then
			game.player:runStop()
			game.player:restStop()

			-- don't bother the player when there is an enemy near
			local grids = core.fov.circle_grids(self.x, self.y, 10, true)
			for x, yy in pairs(grids) do
				for y, _ in pairs(grids[x]) do
					local actor = game.level.map(x, y, Map.ACTOR)
					if actor and self:reactionToward(actor) < 0 and self:hasLOS(actor.x, actor.y) then
						choose = false
					end
				end
			end

			if choose then
				self.chooseCursedAuraTree = nil
				Dialog:yesnoLongPopup(
					"诅咒命运",
					("地 上 的 %s 引 起 了 你 的 注 意。 吸 引 你 的 并 不 是 物 体 本 身， 而 是 在 你 心 底 熊 熊 燃 烧 的 憎 恨 之 火。 你 对 它 充 满 着 憎 恨， 正 如 你 憎 恨 着 世 间 万 物 一 般。 对 你 而 言， 这 种 感 觉 已 经 相 当 的 熟 悉， 但 是 这 一 次， 这 股 憎 恨 已 经 快 要 支 配 你 了。 你 伸 出 手 拾 起 了 它 , 发 自 内 心 地 诅 咒 它、 污 染 它。 紧 接 着， 你 发 现 它 发 生 了 变 化。 它 的 光 泽 开 始 暗 淡， 继 而 充 斥 着 无 尽 的 憎 恨。 那 一 瞬 间， 你 犹 豫 了。 你 知 道 命 运 的 抉 择 正 放 在 面 前， 要 么 从 今 天 起 抵 抗 身 上 的 诅 咒， 并 与 之 对 抗 终 身； 要 么 继 续 放 纵 自 我， 任 由 诅 咒 带 你 堕 入 这 疯 狂 的 深 渊。"):format(item.name),
					300,
					function(ret)
						if ret then
							Dialog:simpleLongPopup("诅咒命运", ("你 的 脚 下 躺 着 受 诅 咒 的 %s 。 一 个 诅 咒 光 环 笼 罩 了 你， 你 感 到 自 己 被 诅 咒 了。 你 获 得 了 诅 咒 光 环 技 能 树 和 等 级 1 的 诅 咒 之 触， 但 是 需 永 久 消 耗 2 点 意 志。"):format(item.name), 300)
							self:learnTalentType("cursed/cursed-aura", true)
							self:learnTalent(self.T_DEFILING_TOUCH, true, 1, {no_unlearn=true})
							self.inc_stats[self.STAT_WIL] = self.inc_stats[self.STAT_WIL] - 2
							self:onStatChange(self.STAT_WIL, -2)
							t.curseItem(self, t, item)
							t.curseInventory(self, t)
							t.curseFloor(self, t, self.x, self.y)
							t.updateCurses(self, t, false)
						else
							Dialog:simplePopup("诅咒命运", ("那 件 %s 恢 复 了 正 常 并 且 你 的 憎 恨 之 意 也 渐 渐 平 息 了。"):format(item.name))
						end
					end,
					"将 你 的 憎 恨 释 放 到 物 品 上",
					"压 制 你 的 憎 恨 之 意")
			end
		end
	end,
	-- updates the state of all curse effects
	updateCurses = function(self, t, forceUpdateEffects)
		local curses = t.getCurses(self, t)
		local itemCounts = {}
		local armorCount = 0

		-- count curses in worn items, but only if we can still curse that type of item
		for id, inven in pairs(self.inven) do
			if self.inven_def[id].is_worn then
				for i, item in ipairs(inven) do
					if item.curse and t.canCurseItem(self, t, item) then
						if item.type == "armor" then armorCount = armorCount + 1 end

						itemCounts[item.curse] = (itemCounts[item.curse] or 0) + 1
					end
				end
			end
		end

		-- add cursed aura
		if self.cursed_aura then
			itemCounts[self.cursed_aura] = (itemCounts[self.cursed_aura] or 0) + 2
		end

		-- update cursed effect levels
		local tDarkGifts = self:getTalentFromId(self.T_DARK_GIFTS)
		for i, curse in ipairs(curses) do
			local eff = self:hasEffect(curse)
			local level = itemCounts[curse] and (itemCounts[curse] + self:callTalent(self.T_DARK_GIFTS, "curseBonusLevel")) or 0
			local penalty = t.cursePenalty(self, t)
			local currentLevel = eff and eff.level or 0
			local currentPenalty = eff and eff.Penalty or 1
			--print("* curse:", self.tempeffect_def[curse].desc, currentLevel, "->", level, eff)
			if currentLevel ~= level or currentPenalty ~= penalty or forceUpdateEffects then
				if eff then
					self:removeEffect(curse, false, true)
				end

				-- preserve the old eff values when re-starting the effect
				if level > 0 then
					if not eff then
						eff = { def = self.tempeffect_def[curse] }
					end
					eff.level = level
					eff.Penalty = penalty
					eff.BonusPower = BonusPower
					eff.unlockLevel = math.min(5, tDarkGifts and self:getTalentLevelRaw(tDarkGifts) or 0)
					self:setEffect(curse, 1, eff)
				end

				self.changed = true
			end
		end
	end,
	passives = function(self, t, p) -- force update on talent mastery changes
	end,
	on_learn = function(self, t)
		t.curseInventory(self, t)
		t.curseFloor(self, t, self.x, self.y)
		t.updateCurses(self, t)
	end,
	on_unlearn = function(self, t)
		-- turn off cursed aura (which gets disabled, but does not turn off)
		t.setCursedAura(self, t, nil)
	end,
	on_pre_use = function(self, t, silent)
		return self:getTalentLevelRaw(t) >= 5
	end,
	-- selects a new cursed aura (+2 curse bonus)
	action = function(self, t)
		local cursedAuraSelect = require("mod.dialogs.CursedAuraSelect").new(self)
		game:registerDialog(cursedAuraSelect)
	end,
	info = function(self, t)
		return ([[
		你 的 诅 咒 之 触 弥 漫 于 你 附 近 的 所 有 东 西， 给 予 找 到 的 每 个 物 品 1 个 随 机 诅 咒。 当 你 穿 戴 1 件 诅 咒 装 备 时， 你 增 加 那 种 诅 咒 的 效 果。 最 初 诅 咒 是 有 害 的， 但 是 当 装 备 多 件 物 品 并 且 学 到 黑 暗 礼 物 时， 诅 咒 会 变 的 非 常 有 益。 
		等 级 1 —— 诅 咒 武 器
		等 级 2 —— 诅 咒 盔 甲 和 斗 篷
		等 级 3 —— 诅 咒 盾 牌 和 头 盔
		等 级 4 —— 诅 咒 手 套 、 靴 子 和 腰 带
		等 级 6 —— 诅 咒 戒 指
		等 级 7 —— 诅 咒 项 链
		等 级 8 —— 诅 咒 灯 具
		等 级 9 —— 诅 咒 工 具 / 图 腾 / 项 圈 /魔 棒
		等 级 10 ——诅 咒 弹 药
		在 等 级 5 时， 你 可 以 激 活 此 技 能 形 成 1 个 光 环， 增 加 2 级 你 选 择 的 诅 咒 效 果( 当 前 %s)。 
		同 时 ， 技 能 等 级 在 5 以 上 时 会 减 轻 诅 咒 的 负 面 效 果（ 现 在 减 少 %d%% ） ]]):
		format(t.getCursedAuraName(self, t), (1-t.cursePenalty(self, t))*100)
	end,
}

newTalent{
	name = "Dark Gifts",
	type = {"cursed/cursed-aura", 2},
	mode = "passive",
	require = cursed_lev_req2,
	no_unlearn_last = true,
	points = 5,
	curseBonusLevel = function(self, t)
		return self:combatTalentScale(math.max(0,self:getTalentLevel(t)-5), 1, 2.5) 
	end,
	on_learn = function(self, t)
		local tDefilingTouch = self:getTalentFromId(self.T_DEFILING_TOUCH)
		tDefilingTouch.updateCurses(self, tDefilingTouch, true)
	end,
	on_unlearn = function(self, t)
		local tDefilingTouch = self:getTalentFromId(self.T_DEFILING_TOUCH)
		tDefilingTouch.updateCurses(self, tDefilingTouch, true)
	end,
	info = function(self, t)
		local level = math.min(4, self:getTalentLevelRaw(t))
		local xs = t.curseBonusLevel(self,t)
		return ([[你 的 诅 咒 带 来 黑 暗 的 礼 物。 解 锁 所 有 诅 咒 第 %d 层 效 果， 并 允 许 你 在 诅 咒 达 到 该 等 级 时 获 得 此 效 果。 
		 在 等 级 5 时， 因 诅 咒 带 来 的 幸 运 惩 罚 降 到 1。
		 等 级 5 以 上 时 增 加 诅 咒 效 果 （ 当 前 增 加 %0.1f ）]]):
		format(level, xs)
	end,
}

newTalent{
	name = "Ruined Earth",
	type = {"cursed/cursed-aura", 3},
	require = cursed_lev_req3,
	points = 5,
	cooldown = 30,
	range = function(self, t)
		return math.min(8, 2 + math.floor(self:getTalentLevel(t)))
	end,
	random_ego = "defensive",
	tactical = { DEFEND = 2 },
	getDuration = function(self, t)
		return math.min(8, 3 + math.floor(self:getTalentLevel(t)))
	end,
	getIncDamage = function(self, t)
		return math.floor(math.min(60, 22 + (math.sqrt(self:getTalentLevel(t)) - 1) * 23))
	end,
	getPowerPercent = function(self, t)
		return math.floor((math.sqrt(self:getTalentLevel(t)) - 1) * 20)
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local incDamage = t.getIncDamage(self, t)

		-- project first to immediately start the effect
		local tg = {type="ball", radius=range}
		self:project(tg, self.x, self.y, DamageType.WEAKNESS, { incDamage=incDamage, dur=3 })

		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.WEAKNESS, { incDamage=incDamage, dur=3 },
			range,
			5, nil,
			engine.MapEffect.new{alpha=100, color_br=120, color_bg=120, color_bb=120, effect_shader="shader_images/darkness_effect.png"}
		)

		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local incDamage = t.getIncDamage(self, t)

		return ([[诅 咒 你 周 围 %d 码 半 径 范 围 的 大 地， 持 续 %d 回 合。 
		 任 何 站 在 大 地 上 的 目 标 将 会 被 虚 弱， 减 少 它 们 %d%% 的 伤 害。]]):format(range, duration, incDamage)
	end,
}

newTalent{
	name = "Cursed Sentry",
	type = {"cursed/cursed-aura", 4},
	require = cursed_lev_req4,
	points = 5,
	cooldown = 40,
	range = 5,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 8, 16))	end,
	getAttackSpeed = function(self, t) return self:combatTalentScale(t, 0.6, 1.4) end,
	action = function(self, t)
		local inven = self:getInven("INVEN")
		local found = false
		for i, obj in pairs(inven) do
			if type(obj) == "table" and obj.type == "weapon" then
				found = true
				break
			end
		end
		if not found then
			game.logPlayer(self, "You cannot use %s without a weapon in your inventory!", t.name)
			return false
		end

		-- select the location
		local range = self:getTalentRange(t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, x, y = self:canProject(tg, tx, ty)
		if game.level.map(x, y, Map.ACTOR) or game.level.map:checkEntity(x, y, game.level.map.TERRAIN, "block_move") then return nil end

		-- select the item
		local d = self:showInventory("Which weapon will be your sentry?", inven, function(o) return o.type == "weapon" end, nil)
		d.action = function(o, item) self:talentDialogReturn(true, o, item) return false end
		local ret, o, item = self:talentDialog(d)
		if not ret then return nil end

		local result = self:removeObject(inven, item)

		local NPC = require "mod.class.NPC"
		local sentry = NPC.new {
			type = "construct", subtype = "weapon",
			display = o.display, color=o.color, image = o.image, blood_color = colors.GREY,
			name = "animated "..o:getName(), -- bug fix
			faction = self.faction,
			desc = "A weapon imbued with a living curse. It seems to be searching for its next victim.",
			faction = self.faction,
			body = { INVEN = 10, MAINHAND=1, QUIVER=1 },
			rank = 2,
			size_category = 1,

			autolevel = o.combat.wil_attack and "summoner" or "warrior",
			ai = "summoned", ai_real = "tactical", ai_state = { talent_in=1, },

			max_life = 50 + self.max_life*self:combatTalentLimit(t, 1, 0.04, 0.17),  -- Add % of summoner's life < 100%
			life_rating = 3,
			stats = o.combat.wil_attack and {wil= 20, cun = 20, mag=10, con=10} or {str=20, dex=20, mag=10, con=10},
			combat = { dam=1, atk=1, apr=1 },
			combat_armor = math.max(100,50 + self.level),
			combat_armor_hardiness = math.min(70,5*self:getTalentLevel(t)),
			combat_def = math.max(50,self.level),
			inc_damage = table.clone(self.inc_damage or {}, true),
			resists_pen = table.clone(self.resists_pen or {}, true),
			
			combat_physspeed = t.getAttackSpeed(self, t),
			infravision = 10,

			resists = { all = self:combatTalentLimit(t, 100, 71, 75), },
			cut_immune = 1,
			blind_immune = 1,
			fear_immune = 1,
			poison_immune = 1,
			disease_immune = 1,
			stone_immune = 1,
			see_invisible = 30,
			no_breath = 1,
			disarm_immune = 1,
			never_move = 1,
			no_drops = true, -- remove to drop the weapon

			resolvers.talents{
				[Talents.T_WEAPON_COMBAT]={base=1, every=10},
				[Talents.T_WEAPONS_MASTERY]={base=1, every=10},
				[Talents.T_KNIFE_MASTERY]={base=1, every=10},
				[Talents.T_EXOTIC_WEAPONS_MASTERY]={base=1, every=10},
				[Talents.T_STAFF_MASTERY]={base=1, every=10},
				[Talents.T_BOW_MASTERY]={base=1, every=10},
				[Talents.T_SLING_MASTERY]={base=1, every=10},
				[Talents.T_PSIBLADES]=o.combat.wil_attack and {base=1, every=10},
				[Talents.T_SHOOT]=1,
			},
			o.combat.wil_attack and resolvers.sustains_at_birth(),
			summoner = self,
			summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			summon_quiet = true,

			on_die = function(self, who)
				game.logSeen(self, "#F53CBE#%s crumbles to dust.", self.name:capitalize())
			end,
		}

		sentry:resolve()
		sentry:resolve(nil, true)
		sentry:forceLevelup(self.level)

		-- Auto alloc some stats to be able to wear it
		if rawget(o, "require") and rawget(o, "require").stat then
			for s, v in pairs(rawget(o, "require").stat) do
				if sentry:getStat(s) < v then
					sentry.unused_stats = sentry.unused_stats - (v - sentry:getStat(s))
					sentry:incStat(s, v - sentry:getStat(s))
				end
			end
		end

		result = sentry:wearObject(o, true, false)
		if o.archery then
			local qo = nil
			if o.archery == "bow" then qo = game.zone:makeEntity(game.level, "object", {type="ammo", subtype="arrow"}, nil, true)
			elseif o.archery == "sling" then qo = game.zone:makeEntity(game.level, "object", {type="ammo", subtype="shot"}, nil, true)
			end
			if qo then sentry:wearObject(qo, true, false) end
		end


		game.zone:addEntity(game.level, sentry, "actor", x, y)

		sentry.no_party_ai = true
		sentry.unused_stats = 0
		sentry.unused_talents = 0
		sentry.unused_generics = 0
		sentry.unused_talents_types = 0
		sentry.no_points_on_levelup = true
		if game.party:hasMember(self) then
			sentry.remove_from_party_on_death = true
			game.party:addMember(sentry, { control="no", type="summon", title="Summon"})
		end

		game:playSoundNear(self, "talents/spell_generic")

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local attackSpeed = t.getAttackSpeed(self, t)*100

		return ([[将 部 分 活 性 诅 咒 能 量 灌 输 到 你 背 包 里 的 1 把 武 器 上， 使 其 悬 浮 在 空 中。 这 个 类 似 于 诅 咒 护 卫 的 武 器 会 自 动 攻 击 附 近 的 敌 人， 持 续 %d 回 合。 
		 当 诅 咒 结 束 时， 武 器 会 化 为 灰 烬。 攻 击 速 度： %d%% ]]):format(duration, attackSpeed)
	end,
}

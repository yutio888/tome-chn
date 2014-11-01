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

newTalentType{ type="technique/horror", name = "horror techniques", hide = true, description = "Physical talents of the various horrors of the world." }
newTalentType{ type="psionic/horror", name = "horror techniques", hide = false, description = "Psionic talents of the various horrors of the world." }
newTalentType{ type="wild-gift/horror", name = "horror techniques", hide = false, description = "Psionic talents of the various horrors of the world." }
newTalentType{ no_silence=true, is_spell=true, type="spell/horror", name = "horror spells", hide = true, description = "Spell talents of the various horrors of the world." }
newTalentType{ no_silence=true, is_spell=true, type="corruption/horror", name = "horror spells", hide = true, description = "Spell talents of the various horrors of the world." }
newTalentType{ type="other/horror", name = "horror powers", hide = true, description = "Unclassified talents of the various horrors of the world." }

local oldTalent = newTalent
local newTalent = function(t) if type(t.hide) == "nil" then t.hide = true end return oldTalent(t) end
-- Bloated Horror Powers
-- Ideas; Mind Shriek (confusion, plus mental damge each turn), Hallucination (Clones that die on hit if the target makes a mental save)

-- Devourer Powers
newTalent{
	name = "Frenzied Bite",
	type = {"technique/horror", 3},
	points = 5,
	cooldown = 12,
	stamina = 24,
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { cut = 2 } },
	message = "In a frenzy @Source@ bites at @Target@!",
	on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_FRENZY) then return false end return true end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.7) end,
	getBleedDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.5, 3) end,
	getHealingPenalty = function(self, t) return self:combatTalentLimit(t, 100, 15, 50) end, -- Limit to <100%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)
		if hit then
			if target:canBe("cut") then
				target:setEffect(target.EFF_DEEP_WOUND, 5, {src=self, heal_factor=t.getHealingPenalty(self, t), power=t.getBleedDamage(self, t)/5, apply_power=self:combatPhysicalpower()})
			end
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local heal_penalty = t.getHealingPenalty(self, t)
		return ([[撕 咬 目 标 造 成 %d%% 武 器 伤 害。 减 少 目 标 治 疗 效 果 %d%% 并 造 成 %d%% 武 器 伤 害 的 流 血 伤 害 持 续 5 回 合。 
		 只 有 在 狂 乱 状 态 下 可 以 使 用。]]):format(damage, heal_penalty, bleed)
	end,
}

newTalent{
	name = "Frenzied Leap", -- modified ghoulish leap, only usable while in a frenzy
	type = {"technique/horror", 1},
	points = 5,
	cooldown = 5,
	tactical = { CLOSEIN = 3 },
	direct_hit = true,
	message = "@Source@ leaps forward in a frenzy!",
	range = function(self, t) return math.floor(self:combatTalentScale(t, 2.4, 10)) end,
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_FRENZY) or self:attr("encased_in_ice") or self:attr("never_move") then return false end return true end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		local tx, ty, _ = lx, ly
		while lx and ly do
			if is_corner_blocked or block_actor(_, lx, ly) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		-- Find space
		if block_actor(_, tx, ty) then return nil end
		local fx, fy = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not fx then
			return
		end
		self:move(fx, fy, true)

		return true
	end,
	info = function(self, t)
		return ([[跳 向 范 围 内 目 标。 只 有 在 狂 乱 状 态 下 可 以 使 用。]])
	end,
}

newTalent{
	name = "Gnashing Teeth",
	type = {"technique/horror", 1},
	points = 5,
	cooldown = 3,
	stamina = 8,
	message = "@Source@ tries to bite @Target@ with razor sharp teeth!",
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 1) end,
	getBleedDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.5) end,
	-- Limit crit, speed increase, -health to <100%
	getPower = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "con", 10, 50), 1, 0, 0, 0.357, 35.7) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	do_devourer_frenzy = function(self, target, t)
		game.logSeen(self, "The scent of blood sends the %ss into a frenzy!", self.name:capitalize())
		-- frenzy devourerers
		local tg = {type="ball", range=0, radius=3, selffire=true, talent=t}
		self:project(tg, target.x, target.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			local reapplied = false
			if target then
				local actor_frenzy = false
				if target.name == "devourer" then
					actor_frenzy = true
				end
				if actor_frenzy then
					-- silence the apply message if the target already has the effect
					for eff_id, p in pairs(target.tmp) do
						local e = target.tempeffect_def[eff_id]
						if e.name == "Frenzy" then
							reapplied = true
						end
					end
					target:setEffect(target.EFF_FRENZY, t.getDuration(self, t), {crit = t.getPower(self, t)*100, power=t.getPower(self, t), dieat=t.getPower(self, t)}, reapplied)
				end
			end
		end)
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hit and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 5, {power=t.getBleedDamage(self, t), src=self, apply_power=self:combatPhysicalpower()})
			t.do_devourer_frenzy(self, target, t)
		else
			game.logSeen(target, "%s resists the cut!", target.name:capitalize())
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local power = t.getPower(self, t) *100
		return ([[ 咬 伤 目 标 ， 造 成 %d%% 武 器 伤 害 ， 可 能 让 目 标 进 入 流 血 状 态 ， 在 五 回 合 内 造 成 %d%% 武 器 伤 害 。 
		 如 果 目 标 进 入 流 血 状 态 ， 吞 噬 者 会 进 入 狂 热 状 态 %d 回 合 （ 也 会 让 周 围 的 其 他 吞 噬 者 进 入 狂 热 状 态 ） 。
		 狂 热 状 态 会 增 加 整 体 速 度 %d%% , 物 理 暴 击 率 %d%% , 同 时 降 至 -%d%% 生 命 时 才 会 死 去 。]]):
		format(damage, bleed, t.getDuration(self, t), power, power, power)
	end,
}

-- Nightmare Horror Powers
newTalent{
	name = "Abyssal Shroud",
	type = {"spell/horror", 1},
	points = 5,
	cooldown = 10,
	mana = 30,
	cooldown = 12,
	tactical = { ATTACKAREA = { DARKNESS = 2 }, DISABLE = 3 },
	range = 6,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 40) end,
	getDarknessPower = function(self, t) return self:combatTalentSpellDamage(t, 15, 40) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	getLiteReduction = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.ABYSSAL_SHROUD, {dam=t.getDamage(self, t), power=t.getDarknessPower(self, t), lite=t.getLiteReduction(self, t)},
			self:getTalentRadius(t),
			5, nil,
			{type="circle_of_death"},
			nil, false
		)

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local light_reduction = t.getLiteReduction(self, t)
		local darkness_resistance = t.getDarknessPower(self, t)
		return ([[制 造 一 个 3 码 范 围 的 黑 暗 深 渊 持 续 %d 回 合。 深 渊 会 造 成 每 回 合 %0.2f 黑 暗 伤 害 并 降 低 %d 光 照 范 围， 同 时 使 其 中 生 物 的 暗 影 抵 抗 减 少 %d%% 。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, (damage)), light_reduction, darkness_resistance)
	end,
}
-- Temporal Stalker Powers
-- Ideas; Damage Shift >:)  Give more temporal effects, especially Warden effects, raise AP and add Temporal Damage on hit to mimic weapon folding, give invis rune
-- Void Horror Powers
newTalent{
	name = "Echoes From The Void",
	type = {"other/horror", 1},
	points = 5,
	message = "@Source@ shows @Target@ the madness of the void.",
	cooldown = 10,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { MIND = 4 } },
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 100) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		if target:canBe("fear") then
			target:setEffect(target.EFF_VOID_ECHOES, 6, {src=self, power=t.getDamage(self, t), apply_power=self:combatMindpower()})
			target:crossTierEffect(target.EFF_VOID_ECHOES, self:combatMindpower())
		else
			game.logSeen(target, "%s resists the void!", target.name:capitalize())
		end

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 释 放 虚 空 的 混 乱， 使 目 标 每 回 合 强 制 进 行 精 神 豁 免 鉴 定， 持 续 6 回 合， 未 通 过 豁 免 则 在 原 伤 害 基 础 上 造 成 %0.2f 精 神 伤 害（ 由 精 神 和 自 然 伤 害 基 础 伤 害 决 定）。]]):
		format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

newTalent{
	name = "Void Shards",
	type = {"other/horror", 1},
	points = 5,
	message = "@Source@ summons void shards.",
	cooldown = 20,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { TEMPORAL = 3, PHYSICAL = 1 } },
	requires_target = true,
	is_summon = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 50) end,
	getExplosion = function(self, t) return self:combatTalentMindDamage(t, 20, 200) end,
	getSummonTime = function(self, t) return math.floor(self:combatTalentScale(t, 7, 11)) end,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end

		if self:getTalentLevel(t) < 5 then self:setEffect(self.EFF_SUMMON_DESTABILIZATION, 500, {power=5}) end

		for i = 1, self:getTalentLevelRaw(t) do
		-- Find space
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				break
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "horror", subtype = "temporal",
				display = "h", color=colors.GREY, image = "npc/horror_temporal_void_horror.png",
				name = "void shard", faction = self.faction,
				desc = [[It looks like a small hole in the fabric of spacetime.]],
				stats = { str=22, dex=20, wil=15, con=15 },

				--level_range = {self.level, self.level},
				exp_worth = 0,
				max_life = resolvers.rngavg(5,10),
				life_rating = 2,
				rank = 2,
				size_category = 1,

				autolevel = "summoner",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, ai_move="move_snake" },
				combat_armor = 1, combat_def = 1,
				combat = { dam=resolvers.levelup(resolvers.mbonus(40, 15), 1, 1.2), atk=15, apr=15, dammod={wil=0.8}, damtype=DamageType.TEMPORAL },
				on_melee_hit = { [DamageType.TEMPORAL] = resolvers.mbonus(20, 10), },

				infravision = 10,
				no_breath = 1,
				fear_immune = 1,
				stun_immune = 1,
				confusion_immune = 1,
				silence_immune = 1,

				ai_target = {actor=target}
			}

			m.faction = self.faction
			m.summoner = self
			m.summoner_gain_exp=true
			m.summon_time = t.getSummonTime(self, t)

			m:resolve() m:resolve(nil, true)
			m:forceLevelup(self.level)
			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "summon")
			m:setEffect(m.EFF_TEMPORAL_DESTABILIZATION_START, 2, {src=self, dam=t.getDamage(self, t), explosion=self:spellCrit(t.getExplosion(self, t))})

		end
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local number = self:getTalentLevelRaw(t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[召 唤 %d 个 虚 空 碎 片。 碎 片 会 进 入 不 稳 定 状 态， 造 成 每 回 合 %0.2f 时 空 伤 害 持 续 5 回 合。 它 们 在 不 稳 定 状 态 下 死 亡 会 发 生 爆 炸 造 成 4 码 范 围 %0.2f 时 空 和 %0.2f 物 理 伤 害。]]):
		format(number, damDesc(self, DamageType.TEMPORAL, (damage)), damDesc(self, DamageType.TEMPORAL, (explosion/2)), damDesc(self, DamageType.PHYSICAL, (explosion/2)))
	end,
}

-- Worm that Walks Powers
newTalent{
	name = "Worm Rot",
	type = {"corruption/horror", 1},
	points = 5,
	cooldown = 8,
	vim = 10,
	range = 6,
	requires_target = true,
	tactical = { ATTACK = { ACID = 1, BLIGHT = 1 }, DISABLE = 4 },
	getBurstDamage = function(self, t) return self:combatTalentSpellDamage(t, 30, 300) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	proj_speed = 6,
	spawn_carrion_worm = function (self, target, t)
		local x, y = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
		if not x then return nil end

		local worm = {type="vermin", subtype="worms", name="carrion worm mass"}
		local list = mod.class.NPC:loadList("/data/general/npcs/vermin.lua")
		local m = list.CARRION_WORM_MASS:clone()
		if not m then return nil end

		m:resolve() m:resolve(nil, true)
		m.faction = self.faction
		game.zone:addEntity(game.level, m, "actor", x, y)
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			if target:canBe("disease") then
				target:setEffect(target.EFF_WORM_ROT, t.getDuration(self, t), {src=self, dam=t.getDamage(self, t), burst=t.getBurstDamage(self, t), rot_timer = 5, apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the worm rot!", target.name:capitalize())
			end
			game.level.map:particleEmitter(px, py, 1, "slime")
		end)
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local burst = t.getBurstDamage(self, t)
		return ([[使 目 标 感 染 腐 肉 寄 生 幼 虫 持 续 %d 回 合。 每 回 合 会 移 除 目 标 一 个 物 理 增 益 效 果 并 造 成 %0.2f 酸 系 和 %0.2f 枯 萎 伤 害。 
		 如 果 5 回 合 后 未 被 清 除 则 幼 虫 会 孵 化 造 成 %0.2f 酸 系 伤 害， 移 除 这 个 效 果 但 是 会 在 目 标 处 成 长 为 一 条 成 熟 的 腐 肉 虫。]]):
		format(duration, damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.ACID, (burst)))
	end,
}
-------------------------------------------
-- THE PUREQUESTION HORRORS AND ALL THAT --
-------------------------------------------

--Bladed Horror Talents
newTalent{
	name = "Knife Storm",
	type = {"psionic/horror",1},
	points = 5,
	random_ego = "attack",
	psi = 25,
	cooldown = 20,
	tactical = { ATTACKAREA = { PHYSICAL = 2, stun = 1 } },
	range = 0,
	radius = 3,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 85) end,
	getDuration = function(self, t) return
		math.floor(self:combatScale(self:combatMindpower(0.05) + self:getTalentLevel(t)/2, 3, 0, 8.33, 5.33))
	end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.PHYSICALBLEED, t.getDamage(self, t),
			3,
			5, nil,
			{type="knifestorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/icestorm")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[ 召 唤 旋 转 剑 刃 风 暴 将 敌 人 切 成 碎 片 ， 对 进 入 风 暴 的 敌 人 造 成 %d 点 物 理 伤 害 并 令 其 流 血 %d 回 合 。 
		 受 精 神 强 度 影 响 ， 伤 害 和 流 血 持 续 时 间 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

newTalent{
	name = "Psionic Pull",
	type = {"psionic/horror", 1},
	points = 5,
	cooldown = 6,
	psi = 35,
	tactical = { DISABLE = 2 },
	range = 0,
	radius = function(self, t)
		return 5
	end,
	target = function(self, t)
		return {type="ball", range=0, friendlyfire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tgts = {}
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if self:reactionToward(target) < 0 and not tgts[target] then
				tgts[target] = true
				local ox, oy = target.x, target.y
				target:pull(self.x, self.y, 2)
				self:project({type="hit", range=10, friendlyfire=false, talent=t}, target.x, target.y, engine.DamageType.PHYSICAL, self:mindCrit(self:combatTalentMindDamage(t, 20, 120)))
				if target.x ~= ox or target.y ~= oy then game.logSeen(target, "%s is pulled in!", target.name:capitalize()) end
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[将 5 码 范 围 内 的 目 标 拉 向 你 并 造 成 %d 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 120)))
	end,
}

newTalent{
	name = "Razor Knife",
	type = {"psionic/horror", 1},
	points = 5,
	psi = 18,
	cooldown = 8,
	range = 7,
	random_ego = "attack",
	tactical = { ATTACK = {PHYSICAL = 2} },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.PHYSICAL, self:mindCrit(self:combatTalentMindDamage(t, 20, 200)), {type="bones"})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[对 一 条 直 线 目 标 发 射 一 把 锋 利 的 刀 刃 造 成 %0.2f 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 200)))
	end,
}

--Oozing Horror Talents
newTalent{
	name = "Slime Wave",
	type = {"wild-gift/horror",1},
	points = 5,
	random_ego = "attack",
	equilibrium = 25,
	cooldown = 10,
	tactical = {ATTACKAREA = { NATURE=2 } },
	direct_hit = true,
	range = 0,
	requires_target = true,
	radius = function(self, t)
		return 1 + 0.5 * t.getDuration(self, t)
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 90) end,
	getDuration = function(self, t) return 9 + self:combatTalentMindDamage(t, 6, 7) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.SLIME, {dam=t.getDamage(self, t), power=0.15, x=self.x, y=self.y},
			1,
			5, nil,
			MapEffect.new{color_br=30, color_bg=200, color_bb=60, effect_shader="shader_images/retch_effect.png"},
			function(e)
				e.radius = e.radius + 0.5
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 1 码 范 围 内 形 成 一 个 史 莱 姆 墙， 每 隔 2 回 合 范 围 会 扩 大， 直 至 %d 码， 造 成 %0.2f 史 莱 姆 伤 害 持 续 %d 回 合。 
		 受 精 神 强 度 影 响， 伤 害 及 持 续 时 间 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), duration)
	end,
}

newTalent{
	name = "Tentacle Grab",
	type = {"wild-gift/horror",1},
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	range = 6,
	tactical = { DISABLE = 1, CLOSEIN = 3 },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 70) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		local target = game.level.map(x, y, engine.Map.ACTOR)
		if not x or not y or not target then return nil end
		local crit = self:mindCrit(1)

		if target:canBe("pin") and self:checkHit(self:combatMindpower(), target:combatPhysicalResist()) then
			target:setEffect(target.EFF_GRAPPLED, t.getDuration(self, t), {src=self, power=t.getDamage(self, t)/2 * crit})
			self:project(tg, x, y, function(px, py)

				target:pull(self.x, self.y, tg.range)

				if not target:attr("no_breath") and not target:attr("undead") and target:canBe("silence") then
					target:setEffect(target.EFF_STRANGLE_HOLD, t.getDuration(self, t), {src=self, power=t.getDamage(self, t) * crit, damtype="SLIME"})
				else
					target:setEffect(target.EFF_CRUSHING_HOLD, t.getDuration(self, t), {src=self, power=t.getDamage(self, t) * crit, damtype="SLIME"})
				end
			end)
		else
			game.logSeen(target, "%s resists the grab!", target.name:capitalize())
		end
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[抓 住 一 个 目 标 并 将 其 拉 至 身 边， 并 抓 取 %d 回 合。 
		 同 时 每 回 合 造 成 %0.2f 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(duration, damDesc(self, DamageType.SLIME, damage))
	end,
}

newTalent{
	short_name = "OOZE_SPIT", image = "talents/slime_spit.png",
	name = "Ooze Spit",
	type = {"wild-gift/horror", 1},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	equilibrium = 4,
	cooldown = 30,
	tactical = { ATTACK = { NATURE = 2} },
	range = 10,
	direct_hit = true,
	proj_speed = 8,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), display={particle="bolt_arcane"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.SLIME, self:mindCrit(self:combatTalentStatDamage(t, "wil", 30, 290)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 液 造 成 %0.2f 自 然 伤 害 并 降 低 其 30%% 移 动 速 度 持 续 3 回 合。 
		 受 敏 捷 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "dex", 30, 290)))
	end,
}

newTalent{
	short_name = "OOZE_ROOTS",
	name = "Slime Roots",
	type = {"wild-gift/horror", 1},
	points = 5,
	random_ego = "utility",
	equilibrium = 5,
	cooldown = 20,
	tactical = { CLOSEIN = 2 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	radius = function(self, t)
		return 1-- util.bound(4 - self:getTalentLevel(t) / 2, 1, 4)
	end,
	is_teleport = true,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=range, radius=radius, requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the self coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, 1, "slime")
		self:teleportRandom(x, y, self:getTalentRadius(t))
		game.level.map:particleEmitter(self.x, self.y, 1, "slime")

		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		return ([[变 成 史 莱 姆 遁 入 地 下， 并 在 %d 至 %d 范 围 内 重 新 出 现。]]):format(range, radius)
	end,
}


--Ak'Gishil
newTalent{
	name = "Animate Blade",
	type = {"spell/horror", 1},
	cooldown = 1,
	range = 10,
	direct_hit = true,
	tactical = { ATTACK = 2 },
	action = function(self, t)
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		-- Find an actor with that filter
		local m = false
		local no_inven = true
		local list = mod.class.NPC:loadList("/data/general/npcs/horror.lua")
		if self.is_akgishil and rng.percent(3) and not self.summoned_distort then
			m = list.DISTORTED_BLADE:clone()
			self.summoned_distort=1
			no_inven = false
		else
			m = list.ANIMATED_BLADE:clone()
		end
		if m then
			m.exp_worth = 0
			m:resolve()
			m:resolve(nil, true)
			if no_inven then m:forgetInven(m.INVEN_INVEN) end

			m.summoner = self
			m.summon_time = 1000
			if not self.is_akgishil then
				m.summon_time = 15
				m.ai_real = m.ai
				m.ai = "summoned"
			end

			if self:knowTalent(self.T_BLIGHTED_SUMMONING) then
				m.blighted_summon_talent = self.T_RUIN
				m:incIncStat("mag", self:getMag())
				m.summon_time=20
			end
			game.zone:addEntity(game.level, m, "actor", x, y)
		end

		return true
	end,
	info = function(self, t)
		return ([[划 破 空 间， 从 异 次 元 召 唤 出 一 把 虚 空 利 刃， 持 续 10 回 合。]])
	end,
}

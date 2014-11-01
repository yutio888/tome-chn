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

local Object = require "mod.class.Object"

-- race & classes
newTalentType{ type="technique/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="chronomancy/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="spell/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ no_silence=true, is_spell=true, type="corruption/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ is_nature=true, type="wild-gift/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ type="psionic/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ type="other/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ type="undead/other", name = "other", hide = true, description = "Talents of the various entities of the world." }
newTalentType{ type="undead/keepsake", name = "keepsake shadow", generic = true, description = "Keepsake shadows's innate abilities." }

local oldTalent = newTalent
local newTalent = function(t) if type(t.hide) == "nil" then t.hide = true end return oldTalent(t) end

-- Multiply!!!
newTalent{
	name = "Multiply",
	type = {"other/other", 1},
	cooldown = 3,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = 3 },
	action = function(self, t)
		if not self.can_multiply or self.can_multiply <= 0 then print("no more multiply") return nil end

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then print("no free space") return nil end

		-- Find a place around to clone
		self.can_multiply = self.can_multiply - 1
		local a
		if self.clone_base then a = self.clone_base:clone() else a = self:clone() end
		a.can_multiply = a.can_multiply - 1
		a.energy.val = 0
		a.exp_worth = 0.1
		a.inven = {}
		a.x, a.y = nil, nil
		a:removeAllMOs()
		a:removeTimedEffectsOnClone()
		if a.can_multiply <= 0 then a:unlearnTalent(t.id) end

		print("[MULTIPLY]", x, y, "::", game.level.map(x,y,Map.ACTOR))
		print("[MULTIPLY]", a.can_multiply, "uids", self.uid,"=>",a.uid, "::", self.player, a.player)
		game.zone:addEntity(game.level, a, "actor", x, y)
		a:check("on_multiply", self)
		return true
	end,
	info = function(self, t)
		return ([[复 制 你 自 身！]])
	end,
}

newTalent{
	short_name = "CRAWL_POISON",
	name = "Poisonous Crawl",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ crawls poison onto @target@.",
	cooldown = 5,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[爪 击 你 的 目 标 造 成 %d%% 毒 素 伤 害 并 使 目 标 中 毒。]]):
		format(100*t.getMult(self, t))
	end,
}

newTalent{
	short_name = "CRAWL_ACID",
	name = "Acidic Crawl",
	points = 5,
	type = {"technique/other", 1},
	message = "@Source@ crawls acid onto @target@.",
	cooldown = 2,
	range = 1,
	tactical = { ATTACK = { ACID = 2 } },
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.ACID, self:combatTalentWeaponDamage(t, 1, 1.8), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[爪 击 你 的 目 标 并 附 带 酸 性 效 果。]])
	end,
}

newTalent{
	short_name = "SPORE_BLIND",
	name = "Blinding Spores",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ releases blinding spores at @target@.",
	cooldown = 2,
	range = 1,
	tactical = { DISABLE = { blind = 2 } },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, DamageType.LIGHT, self:combatTalentWeaponDamage(t, 1, 1.8), true)

		-- Try to blind !
		if hit then
			if target:canBe("blind") then
				target:setEffect(target.EFF_BLINDED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the blindness blow!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[喷 射 目 标 并 使 目 标 致 盲 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

newTalent{
	short_name = "SPORE_POISON",
	name = "Poisonous Spores",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ releases poisonous spores at @target@.",
	cooldown = 2,
	range = 1,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	requires_target = true,
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self.combat_apr = self.combat_apr + 1000
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true)
		self.combat_apr = self.combat_apr - 1000
		return true
	end,
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 液， 造 成 %d%% 伤 害 并 使 其 中 毒。]]):
		format(100 * t.getMult(self, t))
	end,
}

newTalent{
	name = "Stun",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { stun = 2 } },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to stun !
		if hit then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the stunning blow!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害。 如 果 攻 击 命 中 则 可 震 慑 目 标 %d 回 合。 
		 受 物 理 强 度 影 响， 震 慑 几 率 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Disarm",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { disarm = 2 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		if hit and target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			target:crossTierEffect(target.EFF_DISARMED, self:combatPhysicalpower())
		else
			game.logSeen(target, "%s resists the blow!", target.name:capitalize())
		end

		return true
	end,
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 并 试 图 缴 械 目 标 %d 回 合。 
		 受 物 理 强 度 影 响， 缴 械 几 率 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Constrict",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = { stun = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 15, 52)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to constrict !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_CONSTRICTED, t.getDuration(self, t), {src=self, power=1.5 * self:getTalentLevel(t), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the constriction!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 则 可 令 目 标 进 入 压 迫 状 态 %d 回 合。 
		 受 物 理 强 度 影 响， 压 迫 强 度 有 额 外 加 成]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Knockback",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { ATTACK = 1, DISABLE = { knockback = 2 } },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1.5, 2), true)

		-- Try to knockback !
		if hit then
			if target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 5 - self:getTalentLevel(t) / 2) and target:canBe("knockback") then
				target:knockback(self.x, self.y, 4)
				target:crossTierEffect(target.EFF_OFFBALANCE, self:combatPhysicalpower())
			else
				game.logSeen(target, "%s resists the knockback!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[使 用 武 器 打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 则 可 击 退 目 标。 
		 受 物 理 强 度 影 响， 击 退 几 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 1.5, 2))
	end,
}

newTalent{
	short_name = "BITE_POISON",
	name = "Poisonous Bite",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ bites poison into @target@.",
	cooldown = 5,
	range = 1,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	requires_target = true,
	getMult = function(self, t) return self:combatTalentScale(t, 3, 7, "log") end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attackTarget(target, DamageType.POISON, t.getMult(self, t), true)
		return true
	end,
	info = function(self, t)
		return ([[撕 咬 目 标， 造 成 %d%% 伤 害 并 使 其 中 毒。]]):format(100 * t.getMult(self, t))
	end,
}

newTalent{
	name = "Summon",
	type = {"wild-gift/other", 1},
	cooldown = 1,
	range = 10,
	equilibrium = 18,
	direct_hit = true,
	requires_target = true,
	tactical = { ATTACK = 2 },
	is_summon = true,
	action = function(self, t)
		if not self:canBe("summon") then game.logPlayer(self, "You cannot summon; you are suppressed!") return end

		local filters = self.summon or {{type=self.type, subtype=self.subtype, number=1, hasxp=true, lastfor=20}}
		if #filters == 0 then return end
		local filter = rng.table(filters)

		-- Apply summon destabilization
		if self:getTalentLevel(t) < 5 then self:setEffect(self.EFF_SUMMON_DESTABILIZATION, 500, {power=5}) end

		for i = 1, filter.number do
			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 10, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				break
			end

			-- Find an actor with that filter
			filter = table.clone(filter)
			filter.max_ood = filter.max_ood or 2
			local m = game.zone:makeEntity(game.level, "actor", filter, nil, true)
			if m then
				if not filter.hasxp then m.exp_worth = 0 end
				m:resolve()

				if not filter.no_summoner_set then
					m.summoner = self
					m.summon_time = filter.lastfor
				end
				if not m.hard_faction then m.faction = self.faction end

				if not filter.hasloot then m:forgetInven(m.INVEN_INVEN) end

				game.zone:addEntity(game.level, m, "actor", x, y)

				self:logCombat(m, "#Source# summons #Target#!")

				-- Apply summon destabilization
				if self:hasEffect(self.EFF_SUMMON_DESTABILIZATION) then
					m:setEffect(m.EFF_SUMMON_DESTABILIZATION, 500, {power=self:hasEffect(self.EFF_SUMMON_DESTABILIZATION).power})
				end

				-- Learn about summoners
				if game.level.map.seens(self.x, self.y) then
					game:setAllowedBuild("wilder_summoner", true)
				end
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[召 唤 随 从。]])
	end,
}

newTalent{
	name = "Rotting Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = "@Source@ diseases @target@.",
	requires_target = true,
	tactical = { ATTACK = { BLIGHT = 2 }, DISABLE = { disease = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to rot !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_ROTTING_DISEASE, t.getDuration(self, t), {src=self, dam=self:getStr() / 3 + self:getTalentLevel(t) * 2, con=math.floor(4 + target:getCon() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %d 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 体 质。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,self:getStr() / 3 + self:getTalentLevel(t) * 2),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Decrepitude Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = "@Source@ diseases @target@.",
	tactical = { ATTACK = { BLIGHT = 2 }, DISABLE = { disease = 1 } },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to rot !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_DECREPITUDE_DISEASE, t.getDuration(self, t), {src=self, dam=self:getStr() / 3 + self:getTalentLevel(t) * 2, dex=math.floor(4 + target:getDex() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %d 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 敏 捷。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,self:getStr() / 3 + self:getTalentLevel(t) * 2),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Weakness Disease",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 8,
	message = "@Source@ diseases @target@.",
	requires_target = true,
	tactical = { ATTACK = { BLIGHT = 2 }, DISABLE = { disease = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 13, 25)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.5, 1), true)

		-- Try to rot !
		if hit then
			if target:canBe("disease") then
				target:setEffect(target.EFF_WEAKNESS_DISEASE, t.getDuration(self, t), {src=self, dam=self:getStr() / 3 + self:getTalentLevel(t) * 2, str=math.floor(4 + target:getStr() * 0.1), apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[打 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 使 目 标 感 染 疾 病， 造 成 每 回 合 %d 枯 萎 伤 害 持 续 %d 回 合 并 降 低 其 力 量。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,self:getStr() / 3 + self:getTalentLevel(t) * 2),t.getDuration(self, t))
	end,
}

newTalent{
	name = "Mind Disruption",
	type = {"spell/other", 1},
	points = 5,
	cooldown = 10,
	mana = 16,
	range = 10,
	direct_hit = true,
	requires_target = true,
	tactical = { DISABLE = { confusion = 3 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.CONFUSION, {dur=t.getDuration(self, t), dam=50+self:getTalentLevelRaw(t)*10}, {type="manathrust"})
		return true
	end,
	info = function(self, t)
		return ([[试 图 使 目 标 混 乱 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Water Bolt",
	type = {"spell/other", },
	points = 5,
	mana = 10,
	cooldown = 3,
	range = 10,
	reflectable = true,
	tactical = { ATTACK = { COLD = 1 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 12, 0, 78.25, 265, 0.67) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.COLD, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[浓 缩 周 围 的 水 份 形 成 水 弹 攻 击 目 标 造 成 %0.1f 冰 冻 伤 害。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

-- Crystal Flame replacement
newTalent{
	name = "Flame Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_fire", trail="firetrail"}}
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 180) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = nil

			self:projectile(tg, x, y, DamageType.FIREBURN, self:spellCrit(t.getDamage(self, t)), function(self, tg, x, y, grids)
				game.level.map:particleEmitter(x, y, 1, "flame")
				if self:attr("burning_wake") then
					game.level.map:addEffect(self, x, y, 4, engine.DamageType.INFERNO, self:attr("burning_wake"), 0, 5, nil, {type="inferno"}, nil, self:spellFriendlyFire())
				end
			end)

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释 放 火 焰 箭 ， 在 3 回 合 内 对 目 标 造 成 %0.2f 点 伤 害。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

-- Crystal Ice Shards replacement
-- Very slow, moderate damage, freezes
newTalent{
	name = "Ice Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 6,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 140) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = self:project(tg, x, y, function(px, py)
			local actor = game.level.map(px, py, Map.ACTOR)
			if actor and actor ~= self then
				local tg2 = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="arrow", particle_args={tile="particles_images/ice_shards"}}}
				self:projectile(tg2, px, py, DamageType.ICE, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
			end
		end)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释 放 寒 冰 箭 ， 对 目 标 造 成 %0.2f 点 冰 冻 伤 害。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, damage))
	end,
}

-- Crystal Soul Rot replacement
-- Slower projectile, higher damage, crit bonus
newTalent{
	name = "Blight Bolt",
	type = {"spell/other",1},
	points = 1,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { BLIGHT = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 10,
	requires_target = true,
	getCritChance = function(self, t) return self:combatTalentScale(t, 7, 25, 0.75) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 140) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.BLIGHT, self:spellCrit(self:combatTalentSpellDamage(t, 1, 140), t.getCritChance(self, t)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[释 放 枯 萎 箭 ， 对 目 标 造 成 %0.2f 点 枯 萎 伤 害。
		该 法 术 的 暴 击 率 增 加 %0.2f%%。
		受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 1, 180)), t.getCritChance(self, t))
	end,
}

newTalent{
	name = "Water Jet",
	type = {"spell/other", },
	points = 5,
	mana = 10,
	cooldown = 8,
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	tactical = { DISABLE = { stun = 2 }, ATTACK = { COLD = 1 } },
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 12, 0, 65, 265, 0.67) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.COLDSTUN, self:spellCrit(t.getDamage(self, t)), {type="freeze"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[浓 缩 周 围 的 水 份 喷 射 目 标 造 成 %0.1f 冰 冻 伤 害 并 震 慑 目 标 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Void Blast",
	type = {"spell/other", },
	points = 5,
	mana = 3,
	cooldown = 2,
	tactical = { ATTACK = { ARCANE = 7 } },
	range = 10,
	reflectable = true,
	requires_target = true,
	proj_speed = 2,
	target = function(self, t) return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_void", trail="voidtrail"}} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.VOID_BLAST, self:spellCrit(self:combatTalentSpellDamage(t, 15, 240)), {type="voidblast"})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[施 放 虚 空 能 量 形 成 爆 炸 气 旋 向 目 标 缓 慢 移 动， 对 途 径 目 标 造 成 %0.2f 奥 术 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.ARCANE, self:combatTalentSpellDamage(t, 15, 240)))
	end,
}

newTalent{
	name = "Restoration",
	type = {"spell/other", 1},
	points = 5,
	mana = 30,
	cooldown = 15,
	tactical = { CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.poison or e.subtype.disease then nb = nb + 1 end
		end
		return nb
	end },
	getCureCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local target = self
		local effs = {}

		-- Go through all spell effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.poison or e.subtype.disease then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getCureCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local curecount = t.getCureCount(self, t)
		return ([[召 唤 自 然 的 力 量 治 愈 你 的 身 体， 移 除 %d 个 毒 素 和 疫 病 不 良 效 果（ 等 级 3）。]]):
		format(curecount)
	end,
}

newTalent{
	name = "Regeneration",
	type = {"spell/other", 1},
	points = 5,
	mana = 30,
	cooldown = 10,
	tactical = { HEAL = 2 },
	getRegeneration = function(self, t) return 5 + self:combatTalentSpellDamage(t, 5, 25) end,
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	action = function(self, t)
		self:setEffect(self.EFF_REGENERATION, 10, {power=t.getRegeneration(self, t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local regen = t.getRegeneration(self, t)
		return ([[召 唤 自 然 的 力 量 治 愈 你 的 身 体， 每 回 合 回 复 %d 生 命 值 持 续 10 回 合。 
		 受 魔 法 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(regen)
	end,
}

newTalent{
	name = "Grab",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	stamina = 8,
	require = { stat = { str=12 }, },
	requires_target = true,
	tactical = { DISABLE = { pin = 2 }, ATTACK = { PHYSICAL = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.8, 1.4), true)

		-- Try to pin !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the grab!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[攻 击 目 标 造 成 %d%% 伤 害， 如 果 攻 击 命 中 可 定 身 目 标 %d 回 合。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.4), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Blinding Ink",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ projects ink!",
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRadius(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	tactical = { DISABLE = { blind = 2 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLINDING_INK, t.getDuration(self, t))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_dark", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[向 目 标 喷 射 黑 色 墨 汁， 致 盲 目 标 持 续 %d 回 合。]]):format(duration)
	end,
}

newTalent{
	name = "Spit Poison",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 1, poison = 1} },
	getDamage = function(self, t)
		return self:combatScale(math.max(self:getStr(), self:getDex())*self:getTalentLevel(t), 20, 0, 420, 500)
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local s = math.max(self:getDex(), self:getStr())
		self:project(tg, x, y, DamageType.POISON, t.getDamage(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[向 目 标 喷 射 毒 液 造 成 共 计 %0.2f 毒 素 伤 害， 持 续 6 回 合。 
		 受 力 量 或 敏 捷（ 取 较 高 值） 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}

newTalent{
	name = "Spit Blight",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 10,
	requires_target = true,
	tactical = { ATTACK = { BLIGHT = 2 } },
	getDamage = function(self, t)
		return self:combatScale(self:getMag()*self:getTalentLevel(t), 20, 0, 420, 500)
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLIGHT, t.getDamage(self,t), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[喷 吐 目 标 造 成 %0.2f 枯 萎 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):format(t.getDamage(self,t))
	end,
}

newTalent{
	name = "Rushing Claws",
	type = {"wild-gift/other", 1},
	message = "@Source@ rushes out, claws sharp and ready!",
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	tactical = { DISABLE = 2, CLOSEIN = 3 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "You cannot do that currently.") return end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local l = self:lineFOV(x, y, block_actor)
		local lx, ly, is_corner_blocked = l:step()
		local tx, ty = self.x, self.y
		while lx and ly do
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then break end
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
		end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) == 1 and target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, 5, {})
		end

		return true
	end,
	info = function(self, t)
		return ([[快 速 向 目 标 冲 锋， 并 使 用 爪 子 将 目 标 定 身 5 回 合。 
		 至 少 距 离 目 标 2 码 以 外 才 能 施 放。]])
	end,
}

newTalent{
	name = "Throw Bones",
	type = {"undead/other", 1},
	points = 5,
	cooldown = 6,
	range = 10,
	radius = 2,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	getDamage = function(self, t) return self:combatScale(self:getStr()*self:getTalentLevel(t), 20, 0, 420, 500) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.BLEED, t.getDamage(self, t), {type="archery"})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		return ([[向 目 标 投 掷 白 骨 造 成 %0.2f 物 理 流 血 伤 害。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Lay Web",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	message = "@Source@ seems to search the ground...",
	range = 10,
	requires_target = true,
	tactical = { DISABLE = { stun = 1, pin = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local dur = t.getDuration(self,t)
		local trap = mod.class.Trap.new{
			type = "web", subtype="web", id_by_type=true, unided_name = "sticky web",
			display = '^', color=colors.YELLOW, image = "trap/trap_spiderweb_01_64.png",
			name = "sticky web", auto_id = true,
			detect_power = 6 * self:getTalentLevel(t), disarm_power = 10 * self:getTalentLevel(t), --Trap Params
			level_range = {self.level, self.level},
			message = "@Target@ is caught in a web!",
			pin_dur = dur,
			temporary = dur * 5,
			summoner = self,
			faction = false,
			canAct = false,
			energy = {value=0},
			x=self.x,
			y=self.y,
			canTrigger = function(self, x, y, who)
				if who.type == "spiderkin" then return false end
				return mod.class.Trap.canTrigger(self, x, y, who)
			end,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then
						game.level.map:remove(self.x, self.y, engine.Map.TRAP)
					end
					game.level:removeEntity(self)
				end
			end,
			triggered = function(self, x, y, who)
				if who:canBe("stun") and who:canBe("pin") then
					who:setEffect(who.EFF_PINNED, self.pin_dur, {apply_power=self.disarm_power + 5})
				else
					game.logSeen(who, "%s resists!", who.name:capitalize())
				end
				return true, true
			end
			}
		game.level:addEntity(trap)
		game.zone:addEntity(game.level, trap, "trap", self.x, self.y)
		trap:setKnown(self, true)
		return true
	end,
	info = function(self, t)
		return ([[投 掷 一 个 隐 形 的 蜘 蛛 网， 困 住 所 有 经 过 它 的 非 蜘 蛛 生 物 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Darkness",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 4,
	cooldown = 6,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.7, 5.3)) end,
	direct_hit = true,
	tactical = { DISABLE = 3 },
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	darkPower = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local g = engine.Entity.new{name="darkness", show_tooltip=true, block_sight=true, always_remember=false, unlit=t.darkPower(self, t)}
			game.level.map(px, py, Map.TERRAIN+1, g)
			game.level.map.remembers(px, py, false)
			game.level.map.lites(px, py, false)
		end, nil, {type="dark"})
		self:teleportRandom(self.x, self.y, 5)
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[制 造 黑 暗， 阻 挡 所 有 光 线（ 强 度 %d 范 围 %d 码）， 并 能 使 你 传 送 一 小 段 距 离。 
		 受 敏 捷 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.darkPower(self, t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Throw Boulder",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 3,
	range = 10,
	radius = 1,
	direct_hit = true,
	tactical = { DISABLE = { knockback = 3 }, ATTACK = {PHYSICAL = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDam = function(self, t) return self:combatScale(self:getStr() * self:getTalentLevel(t), 12, 0, 262, 500) end,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.PHYSKNOCKBACK, {dist=t.getDist(self, t), dam=self:mindCrit(t.getDam(self, t))}, {type="archery"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[向 目 标 投 掷 一 块 巨 大 的 石 头， 造 成 %0.2f 伤 害 并 将 其 击 退 %d 码。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t))
	end,
}

newTalent{
	name = "Howl",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 10,
	message = "@Source@ howls",
	range = 10,
	tactical = { ATTACK = 3 },
	direct_hit = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		for i = self.x - rad, self.x + rad do for j = self.y - rad, self.y + rad do if game.level.map:isBound(i, j) then
			local actor = game.level.map(i, j, game.level.map.ACTOR)
			if actor and not actor.player then
				if self:reactionToward(actor) >= 0 then
					local tx, ty, a = self:getTarget()
					if a then
						actor:setTarget(a)
					end
				else
					actor:setTarget(self)
				end
			end
		end end end
		return true
	end,
	info = function(self, t)
		return ([[呼 唤 同 伴 回 援（ 范 围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Shriek",
	type = {"wild-gift/other", },
	points = 5,
	equilibrium = 5,
	cooldown = 10,
	message = "@Source@ shrieks.",
	range = 10,
	direct_hit = true,
	tactical = { ATTACK = 3 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local rad = self:getTalentRadius(t)
		for i = self.x - rad, self.x + rad do for j = self.y - rad, self.y + rad do if game.level.map:isBound(i, j) then
			local actor = game.level.map(i, j, game.level.map.ACTOR)
			if actor and not actor.player then
				if self:reactionToward(actor) >= 0 then
					local tx, ty, a = self:getTarget()
					if a then
						actor:setTarget(a)
					end
				else
					actor:setTarget(self)
				end
			end
		end end end
		return true
	end,
	info = function(self, t)
		return ([[呼 唤 同 伴（ 范 围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Crush",
	type = {"technique/other", 1},
	require = techs_req1,
	points = 5,
	cooldown = 6,
	stamina = 12,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 1 }, DISABLE = { stun = 2 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local weapon = self:hasTwoHandedWeapon()
		if not weapon then
			game.logPlayer(self, "You cannot use Crush without a two-handed weapon!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1, 1.4))

		-- Try to pin !
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the crushing!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[对 目 标 的 腿 部 进 行 重 击， 造 成 %d%% 武 器 伤 害， 如 果 攻 击 命 中， 则 目 标 无 法 移 动， 持 续 %d 回 合。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.4), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Silence",
	type = {"psionic/other", 1},
	points = 5,
	cooldown = 10,
	psi = 5,
	range = 7,
	direct_hit = true,
	requires_target = true,
	tactical = { DISABLE = { silence = 3 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SILENCE, {dur=t.getDuration(self, t)}, {type="mind"})
		return true
	end,
	info = function(self, t)
		return ([[施 放 念 力 攻 击 沉 默 目 标 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Telekinetic Blast",
	type = {"wild-gift/other", 1},
	points = 5,
	cooldown = 2,
	equilibrium = 5,
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	tactical = { ATTACK = { MIND = 2 }, ESCAPE = { knockback = 2 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(self:combatTalentMindDamage(t, 10, 170)), {type="mind"})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[施 放 念 力 攻 击 击 退 目 标 并 造 成 %0.2f 物 理 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:combatTalentMindDamage(t, 10, 170))
	end,
}

newTalent{
	name = "Blightzone",
	type = {"corruption/other", 1},
	points = 5,
	cooldown = 13,
	vim = 27,
	range = 10,
	radius = 4,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACKAREA = { BLIGHT = 2 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = self:combatTalentSpellDamage(t, 4, 65)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, duration,
			DamageType.BLIGHT, dam,
			self:getTalentRadius(t),
			5, nil,
			{type="blightzone"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		return ([[蒸 腾 目 标 区 域（ 4 码 范 围） 造 成 每 回 合 %0.2f 枯 萎 伤 害 持 续 %d 回 合。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, engine.DamageType.BLIGHT, self:combatTalentSpellDamage(t, 5, 65)), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Invoke Tentacle",
	type = {"wild-gift/other", 1},
	cooldown = 1,
	range = 10,
	direct_hit = true,
	tactical = { ATTACK = 3 },
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		if not tx or not ty then return nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 3, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		-- Find an actor with that filter
		local list = mod.class.NPC:loadList("/data/general/npcs/horror.lua")
		local m = list.GRGGLCK_TENTACLE:clone()
		if m then
			m.exp_worth = 0
			m:resolve()
			m:resolve(nil, true)

			m.summoner = self
			m.summon_time = 10
			if not self.is_grgglck then
				m.ai_real = m.ai
				m.ai = "summoned"
			end

			game.zone:addEntity(game.level, m, "actor", x, y)

			game.logSeen(self, "%s spawns one of its tentacles!", self.name:capitalize())
		end

		return true
	end,
	info = function(self, t)
		return ([[召 唤 触 须 攻 击 目 标。]])
	end,
}

newTalent{
	name = "Explode",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ explodes! @target@ is enveloped in searing light.",
	cooldown = 1,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { LIGHT = 1 } },
	getDamage = function(self, t) return self:combatScale(self:combatSpellpower() * self:getTalentLevel(t), 0, 0, 66.25 , 265, 0.67) end,
	action = function(self, t)
		local tg = {type="bolt", range=1}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:project(tg, x, y, DamageType.LIGHT, t.getDamage(self, t), {type="light"})
		game.level.map:particleEmitter(self.x, self.y, 1, "ball_fire", {radius = 1, r = 1, g = 0, b = 0})
		self:die(self)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[使 目 标 爆 炸 并 放 出 耀 眼 光 芒 造 成 %d 伤 害。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}

newTalent{
	name = "Will o' the Wisp Explode",
	type = {"technique/other", 1},
	points = 5,
	message = "@Source@ explodes! @target@ is enveloped in frost.",
	cooldown = 1,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { COLD = 1 } },
	action = function(self, t)
		local tg = {type="bolt", range=1}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:project(tg, x, y, DamageType.COLD, self.will_o_wisp_dam or 1)
		game.level.map:particleEmitter(self.x, self.y, 1, "ball_ice", {radius = 1, r = 1, g = 0, b = 0})
		self:die(self)
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[爆 炸。]])
	end,
}

newTalent{
	name = "Elemental bolt",
	type = {"spell/other", 1},
	points = 5,
	mana = 10,
	message = "@Source@ casts Elemental Bolt!",
	cooldown = 3,
	range = 10,
	proj_speed = 2,
	requires_target = true,
	tactical = { ATTACK = 2 },
	getDamage = function(self, t) return self:combatScale(self:getMag() * self:getTalentLevel(t), 0, 0, 450, 500) end,
	action = function(self, t)
		local tg = {type = "bolt", range = 20, talent = t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
			local elem = rng.table{
				{DamageType.ACID, "acid"},
				{DamageType.FIRE, "flame"},
				{DamageType.COLD, "freeze"},
				{DamageType.LIGHTNING, "lightning_explosion"},
				{DamageType.NATURE, "slime"},
				{DamageType.BLIGHT, "blood"},
				{DamageType.LIGHT, "light"},
				{DamageType.ARCANE, "manathrust"},
				{DamageType.DARKNESS, "dark"},
			}
		tg.display={particle="bolt_elemental", trail="generictrail"}
		self:projectile(tg, x, y, elem[1], t.getDamage(self, t), {type=elem[2]})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[发 射 一 枚 随 机 元 素 属 性 的 魔 法 飞 弹 缓 慢 飞 行 攻 
		 击 目 标 造 成 %d 伤 害， 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDamage(self, t))
	end,
}

newTalent{
	name = "Volcano",
	type = {"spell/other", 1},
	points = 5,
	mana = 10,
	message = "A volcano erupts!",
	cooldown = 20,
	range = 10,
	proj_speed = 2,
	requires_target = true,
	tactical = { ATTACK = { FIRE = 1, PHYSICAL = 1 } },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	nbProj = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 80) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), nolock=true, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end

		local oe = game.level.map(x, y, Map.TERRAIN)
		if not oe or oe:attr("temporary") then return end

		local e = Object.new{
			old_feat = oe,
			type = oe.type, subtype = oe.subtype,
			name = "raging volcano", image = oe.image, add_mos = {{image = "terrain/lava/volcano_01.png"}},
			display = '&', color=colors.LIGHT_RED, back_color=colors.RED,
			always_remember = true,
			temporary = t.getDuration(self, t),
			x = x, y = y,
			canAct = false,
			nb_projs = t.nbProj(self, t),
			dam = t.getDamage(self, t),
			act = function(self)
				local tgts = {}
				local grids = core.fov.circle_grids(self.x, self.y, 5, true)
				for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
					local a = game.level.map(x, y, engine.Map.ACTOR)
					if a and self.summoner:reactionToward(a) < 0 then tgts[#tgts+1] = a end
				end end

				-- Randomly take targets
				local tg = {type="bolt", range=5, x=self.x, y=self.y, talent=self.summoner:getTalentFromId(self.summoner.T_VOLCANO), display={image="object/lava_boulder.png"}}
				for i = 1, self.nb_projs do
					if #tgts <= 0 then break end
					local a, id = rng.table(tgts)
					table.remove(tgts, id)

					self.summoner:projectile(tg, a.x, a.y, engine.DamageType.MOLTENROCK, self.dam, {type="flame"})
					game:playSoundNear(self, "talents/fire")
				end

				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
					game.level:removeEntity(self)
					game.level.map:updateMap(self.x, self.y)
					game.nicer_tiles:updateAround(game.level, self.x, self.y)
				end
			end,
			summoner_gain_exp = true,
			summoner = self,
		}
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN, e)
		game.nicer_tiles:updateAround(game.level, x, y)
		game.level.map:updateMap(x, y)
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[召 唤 一 个 小 型 火 山 持 续 %d 回 合。 每 回 合 它 会 朝 你 的 目 标 喷 射 %d 熔 岩， 造 成 %0.2f 火 焰 伤 害 和 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDuration(self, t), t.nbProj(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,
}

newTalent{
	name = "Speed Sap",
	type = {"chronomancy/other", 1},
	points = 5,
	paradox = 10,
	cooldown = 8,
	tactical = {
		ATTACK = { TEMPORAL = 10 },
		DISABLE = 10,
	},
	range = 3,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220)*getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		self:project(tg, x, y, DamageType.WASTING, self:spellCrit(t.getDamage(self, t)))
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(target.EFF_SLOW, 3, {power=0.3})
			self:setEffect(self.EFF_SPEED, 3, {power=0.3})
		end
		local _ _, x, y = self:canProject(tg, x, y)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[降 低 目 标 30%% 速 度 并 在 3 回 合 内 造 成 %d 时 空 伤 害。]]):format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

newTalent{
	name = "Dredge Frenzy",
	type = {"chronomancy/other", 1},
	points = 5,
	cooldown = 12,
	tactical = {
		BUFF = 4,
	},
	direct_hit = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=true, talent=t}
	end,
	getPower = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 50), 1, 0, 0, 0.329, 32.9) end, -- Limit < 100
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			local reapplied = false
			if target then
				local actor_frenzy = false
				if target.dredge then
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

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_light", {radius=tg.radius})
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		local range = t.radius(self,t)
		local power = t.getPower(self,t) * 100
		return ([[使 %d 码 内 的 挖 掘 魔 陷 入 狂 乱 %d 回 合。
		狂 乱 会 使 其 全 体 速 度 上 升 %d%%, 物 理 暴 击 提 升 %d%%, 生 命 值 直 至 -%d%% 才 会 死 亡。]]):		
		format(range, t.getDuration(self, t), power, power, power)
	end,
}

newTalent{
	name = "Sever Lifeline",
	type = {"chronomancy/other", 1},
	points = 5,
	paradox = 1,
	cooldown = 20,
	tactical = {
		ATTACK = 1000,
	},
	range = 10,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 220) * 10000 *getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		target:setEffect(target.EFF_SEVER_LIFELINE, 4, {src=self, power=t.getDamage(self, t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[引 导 法 术 离 断 目 标 的 生 命 线， 如 果 4 回 合 之 后 目 标 仍 然 在 视 线 内 则 会 立 即 死 亡。]])
	end,
}

newTalent{
	name = "Call of Amakthel",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 2,
	tactical = { DISABLE = 2 },
	range = 0,
	radius = function(self, t)
		return 10
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), friendlyfire=false, radius=self:getTalentRadius(t), talent=t}
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
				target:pull(self.x, self.y, 1)
				if target.x ~= ox or target.y ~= oy then game.logSeen(target, "%s is pulled in!", target.name:capitalize()) end
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[将 所 有 敌 人 拉 至 身 边。]])
	end,
}

newTalent{
	name = "Gift of Amakthel",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 6,
	tactical = { ATTACK = 2 },
	range = 10,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self.x, self.y
		if not tx or not ty then return nil end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 3, true, {[Map.ACTOR]=true})
		if not x then	
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end

		-- Find an actor with that filter
		local m = game.zone:makeEntityByName(game.level, "actor", "SLIMY_CRAWLER")
		if m then
			m.exp_worth = 0
			m.summoner = self
			m.summon_time = 10
			game.zone:addEntity(game.level, m, "actor", x, y)
			local target = game.level.map(tx, ty, Map.ACTOR)
			m:setTarget(target)

			game.logSeen(self, "%s spawns a slimy crawler!", self.name:capitalize())
		end

		return true
	end,
	info = function(self, t)
		return ([[召 唤 一 只 黏 糊 糊 的 爬 虫。]])
	end,
}

newTalent{
	short_name = "STRIKE",
	name = "Strike",
	type = {"spell/other", 1},
	points = 5,
	random_ego = "attack",
	mana = 18,
	cooldown = 6,
	tactical = {
		ATTACK = { PHYSICAL = 1 },
		DISABLE = { knockback = 2 },
		ESCAPE = { knockback = 2 },
	},
	range = 10,
	reflectable = true,
	proj_speed = 6,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 8, 230) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_earth", trail="earthtrail"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.SPELLKNOCKBACK, self:spellCrit(t.getDamage(self, t)))
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 一 个 石 拳 造 成 %0.2f 物 理 伤 害 并 击 退 目 标。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

newTalent{
	name = "Corrosive Vapour",
	type = {"spell/other",1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 20,
	cooldown = 8,
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 8,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.ACID, t.getDamage(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="vapour"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码 半 径 范 围 内 升 起 一 片 腐 蚀 性 的 酸 雾， 造 成 %0.2f 毒 系 伤 害， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, damage), duration)
	end,
}

newTalent{
	name = "Manaflow",
	type = {"spell/other", 1},
	points = 5,
	mana = 0,
	cooldown = 25,
	tactical = { MANA = 3 },
	getManaRestoration = function(self, t) return 5 + self:combatTalentSpellDamage(t, 10, 20) end,
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_MANASURGE) end,
	action = function(self, t)
		self:setEffect(self.EFF_MANASURGE, 10, {power=t.getManaRestoration(self, t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local restoration = t.getManaRestoration(self, t)
		return ([[将 自 己 包 围 在 法 力 的 河 水 中， 每 回 合 回 复 %d 点 法 力 值， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 法 力 回 复 有 额 外 加 成。]]):
		format(restoration)
	end,
}
newTalent{
	name = "Infernal Breath", image = "talents/flame_of_urh_rok.png",
	type = {"spell/other",1},
	random_ego = "attack",
	cooldown = 20,
	tactical = { ATTACK = { FIRE = 1 }, HEAL = 1, },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DEMONFIRE, self:spellCrit(self:combatTalentStatDamage(t, "str", 30, 350)))

		game.level.map:addEffect(self,
				self.x, self.y, 4,
				DamageType.DEMONFIRE, self:spellCrit(self:combatTalentStatDamage(t, "str", 30, 70)),
				tg.radius,
				{delta_x=x-self.x, delta_y=y-self.y}, 55,
				{type="dark_inferno"},
				nil, true
		)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breathe")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[对 %d 码 范 围 吐 出 黑 暗 之 火。 所 有 非 恶 魔 生 物 受 到 %0.2f 火 焰 伤 害， 并 在 接 下 来 继 续 造 成 每 回 合 %0.2f 的 持 续 火 焰 伤 害。 恶 魔 则 会 治 疗 同 等 数 值 的 生 命 值。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 350)), damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 70)))
	end,
}

newTalent{
	name = "Frost Hands", image = "talents/shock_hands.png",
	type = {"spell/other", 3},
	points = 5,
	mode = "sustained",
	cooldown = 10,
	sustain_mana = 40,
	tactical = { BUFF = 2 },
	getIceDamage = function(self, t) return self:combatTalentSpellDamage(t, 3, 20) end,
	getIceDamageIncrease = function(self, t) return self:combatTalentSpellDamage(t, 5, 14) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/ice")
		return {
			dam = self:addTemporaryValue("melee_project", {[DamageType.ICE] = t.getIceDamage(self, t)}),
			per = self:addTemporaryValue("inc_damage", {[DamageType.COLD] = t.getIceDamageIncrease(self, t)}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("melee_project", p.dam)
		self:removeTemporaryValue("inc_damage", p.per)
		return true
	end,
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[将 你 的 双 手 笼 罩 在 寒 冰 之 中 每 次 近 战 攻 击 造 成 %d 冰 冷 伤 害， 并 提 高 %d%% 冰 冷 伤 害。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

newTalent{
	name = "Meteor Rain",
	type = {"spell/other", 3},
	points = 5,
	cooldown = 30,
	mana = 70,
	tactical = { ATTACKAREA = { FIRE=2, PHYSICAL=2 } },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 250) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 3.3, 4.8, "log")) end,
	radius = 2,
	range = 5,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local terrains = t.terrains or mod.class.Grid:loadList("/data/general/grids/lava.lua")
		t.terrains = terrains -- cache

		local meteor = function(src, x, y, dam)
			game.level.map:particleEmitter(x, y, 10, "meteor", {x=x, y=y}).on_remove = function(self)
				local x, y = self.args.x, self.args.y
				game.level.map:particleEmitter(x, y, 10, "ball_fire", {radius=2})
				game:playSoundNear(game.player, "talents/fireflash")

				local grids = {}
				for i = x-1, x+1 do for j = y-1, y+1 do
					local oe = game.level.map(i, j, Map.TERRAIN)
					if oe and not oe:attr("temporary") and
					(core.fov.distance(x, y, i, j) < 1 or rng.percent(40)) and (game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "dig") or game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "grow")) then
						local g = terrains.LAVA_FLOOR:clone()
						g:resolve() g:resolve(nil, true)
						game.zone:addEntity(game.level, g, "terrain", i, j)
						grids[#grids+1] = {x=i,y=j,oe=oe}
					end
				end end
				for i = x-1, x+1 do for j = y-1, y+1 do
					game.nicer_tiles:updateAround(game.level, i, j)
				end end
				for _, spot in ipairs(grids) do
					local i, j = spot.x, spot.y
					local g = game.level.map(i, j, Map.TERRAIN)
					g.temporary = 8
					g.x = i g.y = j
					g.canAct = false
					g.energy = { value = 0, mod = 1 }
					g.old_feat = spot.oe
					g.useEnergy = mod.class.Trap.useEnergy
					g.act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
							game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
							game.level:removeEntity(self)
							game.nicer_tiles:updateAround(game.level, self.x, self.y)
						end
					end
					game.level:addEntity(g)
				end

				src:project({type="ball", radius=2, selffire=false}, x, y, engine.DamageType.FIRE, dam/2)
				src:project({type="ball", radius=2, selffire=false}, x, y, engine.DamageType.PHYSICAL, dam/2)
				if core.shader.allow("distort") then game.level.map:particleEmitter(x, y, 2, "shockwave", {radius=2}) end
				game:getPlayer(true):attr("meteoric_crash", 1)
			end
		end

		local grids = {}
		self:project(tg, x, y, function(px, py) grids[#grids+1] = {x=px, y=py} end)

		for i = 1, t.getNb(self, t) do
			local g = rng.tableRemove(grids)
			if not g then break end
			meteor(self, g.x, g.y, t.getDamage(self, t))
		end

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[使 用 奥 术 力 量 召 唤 %d 个 陨 石， 冲 击 地 面 对 2 码 范 围 内 造 成 %0.2f 火 焰 和 %0.2f 物 理 伤 害。 
		 被 击 中 的 地 面 同 时 形 成 熔 岩 持 续 8 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

newTalent{
	name = "Heal", short_name = "HEAL_NATURE", image = "talents/heal.png",
	type = {"wild-gift/other", 1},
	points = 5,
	equilibrium = 10,
	cooldown = 16,
	tactical = { HEAL = 2 },
	getHeal = function(self, t) return 40 + self:combatTalentMindDamage(t, 10, 520) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:mindCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 身 体 吸 收 自 然 能 量， 治 疗 %d 生 命 值。 
		 受 精 神 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

newTalent{
	name = "Call Lightning", image = "talents/lightning.png",
	type = {"wild-gift/other", 1},
	points = 5,
	equi = 4,
	cooldown = 3,
	tactical = { ATTACK = 2 },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 350) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 股 强 烈 的 闪 电 束 造 成 %0.2f 至 %0.2f 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

newTalent{
	short_name = "KEEPSAKE_FADE",
	name = "Fade",
	type = {"undead/keepsake",1},
	points = 5,
	cooldown = function(self, t)
		return math.max(3, 8 - self:getTalentLevelRaw(t))
	end,
	action = function(self, t)
		self:setEffect(self.EFF_FADED, 1, {})
		return true
	end,
	info = function(self, t)
		return ([[你 淡 出 视 野， 使 你 隐 形 至 下 一 回 合。]])
	end,
}

newTalent{
	short_name = "KEEPSAKE_PHASE_DOOR",
	name = "Phase Door",
	type = {"undead/keepsake",1},
	points = 5,
	range = 10,
	tactical = { ESCAPE = 2 },
	is_teleport = true,
	action = function(self, t)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
		self:teleportRandom(self.x, self.y, self:getTalentRange(t))
		game.level.map:particleEmitter(x, y, 1, "teleport_in")
		return true
	end,
	info = function(self, t)
		return ([[在 小 范 围 内 传 送 你。]])
	end,
}

newTalent{
	short_name = "KEEPSAKE_BLINDSIDE",
	name = "Blindside",
	type = {"undead/keepsake", 1},
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
	end,
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 1.1, 1.9)
		return ([[你 以 难 以 分 辨 的 速 度 闪 现 到 %d 码 范 围 内 的 某 个 目 标 面 前， 造 成 %d%% 伤 害。]]):format(self:getTalentRange(t), multiplier)
	end,
}

newTalent{
	name = "Suspended", image = "talents/arcane_feed.png",
	type = {"other/other", 1},
	points = 1,
	mode = "sustained",
	cooldown = 10,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "invulnerable", 1)
		self:talentTemporaryValue(ret, "status_effect_immune", 1)
		self:talentTemporaryValue(ret, "dazed", 1)
		return ret
	end,
	deactivate = function(self, t, p)
		game.logSeen("#VIOLET#%s is freed from the suspended state!", self.name:capitalize())
		return true
	end,
	info = function(self, t)
		return ([[除 非 受 到 伤 害， 否 则 目 标 无 法 行 动。]])
	end,
}


newTalent{
	name = "Frost Grab",
	type = {"spell/other", 1},
	points = 5,
	mana = 19,
	cooldown = 8,
	range = 10,
	tactical = { DISABLE = 1, CLOSEIN = 3 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 5, 140))

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			target:pull(self.x, self.y, tg.range)

			DamageType:get(DamageType.COLD).projector(self, target.x, target.y, DamageType.COLD, dam)
			target:setEffect(target.EFF_SLOW_MOVE, t.getDuration(self, t), {apply_power=self:combatSpellpower(), power=0.5})
		end)
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		return ([[抓 住 目 标 并 使 其 传 送 至 你 身 边， 冰 冻 目 标 使 其 移 动 速 度 50%% 持 续 %d 回 合。
		冰 同 时 也 会 造 成 %0.2f 冰 冷 伤 害。
		伤 害 受 你 的 法 术 强 度 加 成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentSpellDamage(t, 5, 140)))
end,
}


newTalent{
	name = "Body Shot",
	type = {"technique/other", 1},
	points = 5,
	cooldown = 10,
	stamina = 10,
	message = "@Source@ throws a body shot.",
	tactical = { ATTACK = { weapon = 2 }, DISABLE = { stun = 2 } },
	requires_target = true,
	--on_pre_use = function(self, t, silent) if not self:hasEffect(self.EFF_COMBO) then if not silent then game.logPlayer(self, "You must have a combo going to use this ability.") end return false end return true end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.1, 1.8) + getStrikingStyle(self, dam) end,
	getDuration = function(self, t, comb) return math.ceil(self:combatTalentScale(t, 1, 5) * (0.25 + comb/5)) end,
	getDrain = function(self, t) return self:combatTalentScale(t, 2, 10, 0.75) * self:getCombo(combo) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- breaks active grapples if the target is not grappled
		if not target:isGrappled(self) then
			self:breakGrapples()
		end

		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hit then
			-- try to daze
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, t.getDuration(self, t, self:getCombo(combo)), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the body shot!", target.name:capitalize())
			end

			target:incStamina(- t.getDrain(self, t))

		end

		self:clearCombo()

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local drain = self:getTalentLevel(t) * 2
		local daze = t.getDuration(self, t, 0)
		local dazemax = t.getDuration(self, t, 5)
		return ([[A对 目 标 的 身 体 发 出 强 烈 的 一 击， 造 成 %d%% 伤 害， 每 点 连 击 点 消 耗 %d 目 标 体 力 并 眩 晕 目 标 %d 到 %d 回 合（ 由 你 的 连 击 点 数 决 定）。 
		受 物 理 强 度 影 响， 眩 晕 概 率 有 额 外 加 成。 
		使 用 此 技 能 会 消 耗 当 前 所 有 连 击 点。]])
		:format(damage, drain, daze, dazemax)
	end,
}

newTalent{
	name = "Relentless Strikes",
	type = {"technique/other", 1},
	points = 5,
	mode = "passive",
	getStamina = function(self, t) return self:combatTalentScale(t, 1/4, 5/4, 0.75) end,
	getCooldownReduction = function(self, t) return self:combatTalentLimit(t, 0.67, 0.09, 1/3) end,  -- Limit < 67%
	info = function(self, t)
		local stamina = t.getStamina(self, t)
		local cooldown = t.getCooldownReduction(self, t)
		return ([[减 少 你 所 有 拳 术 系 技 能 %d%% 冷 却 时 间。 每 当 你 获 得 1 点 连 击 点， 你 可 以 回 复 %0.2f 体 力。 
		注 意： 在 技 能 消 耗 体 力 之 前 和 连 击 点 出 现 之 后 的 时 间 里 才 会 回 复 体 力。]])
		:format(cooldown * 100, stamina)
	end,
}

newTalent{
	name = "Combo String",
	type = {"technique/other", 1},
	mode = "passive",
	points = 5,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 0.3, 2.3)) end,
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (5 + self:getCun(5, true)), 100, 0, 0, 50, 50) end, -- Limit < 100%
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[当 获 得 1 个 连 击 点 时 有 %d%% 概 率 
		额 外 获 得 1 个 连 击 点。 
		此 外 你 的 连 击 点 持 续 时 间 会 延 长 %d 回 合。 
		受 灵 巧 影 响， 额 外 连 击 点 获 得 概 率 有 额 外 加 成。]]):
		format(chance, duration)
	end,
}

newTalent{
	name = "Steady Mind",
	type = {"technique/other", 1},
	mode = "passive",
	points = 5,
	getDefense = function(self, t) return self:combatTalentStatDamage(t, "dex", 5, 35) end,
	getMental = function(self, t) return self:combatTalentStatDamage(t, "cun", 5, 35) end,
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local saves = t.getMental(self, t)
		return ([[大 量 的 训 练 使 你 能 保 持 清 醒 的 头 脑， 增 加 %d 近 身 闪 避 和 %d 精 神 豁 免。 
		受 敏 捷 影 响， 闪 避 按 比 例 加 成； 
		受 灵 巧 影 响， 精 神 豁 免 按 比 例 加 成。]]):
		format(defense, saves)
	end,
}

newTalent{
	name = "Maim",
	type = {"technique/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 10,
	tactical = { ATTACK = { PHYSICAL = 2 }, DISABLE = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDamage = function(self, t) return self:combatTalentPhysicalDamage(t, 10, 100) * getUnarmedTrainingBonus(self) end,
	getMaim = function(self, t) return self:combatTalentPhysicalDamage(t, 5, 30) end,
	-- Learn the appropriate stance
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local grappled = false

		-- breaks active grapples if the target is not grappled
		if target:isGrappled(self) then
			grappled = true
		else
			self:breakGrapples()
		end

		-- end the talent without effect if the target is to big
		if self:grappleSizeCheck(target) then
			return true
		end

		-- start the grapple; this will automatically hit and reapply the grapple if we're already grappling the target
		local hit = self:startGrapple (target)
		-- deal damage and maim if appropriate
		if hit then
			if grappled then
				self:project(target, x, y, DamageType.PHYSICAL, self:physicalCrit(t.getDamage(self, t), nil, target, self:combatAttack(), target:combatDefense()))
				target:setEffect(target.EFF_MAIMED, t.getDuration(self, t), {power=t.getMaim(self, t)})
			else
				self:project(target, x, y, DamageType.PHYSICAL, self:physicalCrit(t.getDamage(self, t), nil, target, self:combatAttack(), target:combatDefense()))
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local maim = t.getMaim(self, t)
		return ([[抓 取 目 标 并 给 予 其 %0.2f 物 理 伤 害。 
		如 果 目 标 已 被 抓 取， 则 目 标 会 被 致 残， 减 少 %d 伤 害 和 30%% 整 体 速 度 持 续 %d 回 合。 
		抓 取 效 果 受 你 已 有 的 抓 取 技 能 影 响。 
		受 物 理 强 度 影 响， 伤 害 按 比 例 加 成。 ]])
		:format(damDesc(self, DamageType.PHYSICAL, (damage)), maim, duration)
	end,
}

newTalent{
	name = "Bloodrage",
	type = {"technique/other", 1},
	points = 5,
	mode = "passive",
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	on_kill = function(self, t)
		self:setEffect(self.EFF_BLOODRAGE, t.getDuration(self, t), {max=math.floor(self:getTalentLevel(t) * 6), inc=2})
	end,
	info = function(self, t)
		return ([[每 当 你 让 一 个 敌 人 扑 街， 你 会 漏 出 一 股 汹 涌 的 霸 气， 增 加 你 2 点 力 量， 上 限 %d ， 持 续 %d 回 合。]]):
		format(math.floor(self:getTalentLevel(t) * 6), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Martyrdom",
	type = {"spell/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 22,
	positive = 25,
	tactical = { DISABLE = 2 },
	range = 6,
	reflectable = true,
	requires_target = true,
	getReturnDamage = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 15, 1, 40, 2.24) end, -- Limit <100%
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		game:playSoundNear(self, "talents/spell_generic")
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			target:setEffect(self.EFF_MARTYRDOM, 10, {src = self, power=t.getReturnDamage(self, t), apply_power=self:combatSpellpower()})
		else
			return
		end
		return true
	end,
	info = function(self, t)
		local returndamage = t.getReturnDamage(self, t)
		return ([[指 定 目 标 成 为 殉 难 者， 持 续 10 回 合。 当 殉 难 者 造 成 伤 害 时， 它 也 会 受 到 %d%% 它 自 己 造 成 的 伤 害。]]):
		format(returndamage)
	end,
}

newTalent{
	name = "Overpower",
	type = {"technique/other", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	stamina = 22,
	requires_target = true,
	tactical = { ATTACK = 2, ESCAPE = { knockback = 1 }, DISABLE = { knockback = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a weapon and a shield to use this talent.") end return false end return true end,
	action = function(self, t)
		local shield = self:hasShield()
		if not shield then
			game.logPlayer(self, "You cannot use Overpower without a shield!")
			return nil
		end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		-- First attack with weapon
		self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3), true)
		-- Second attack with shield
		self:attackTargetWith(target, shield.special_combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
		-- Third attack with shield
		local speed, hit = self:attackTargetWith(target, shield.special_combat, nil, self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))

		-- Try to stun !
		if hit then
			if target:checkHit(self:combatAttack(shield.special_combat), target:combatPhysicalResist(), 0, 95, 5 - self:getTalentLevel(t) / 2) and target:canBe("knockback") then
				target:knockback(self.x, self.y, 4)
			else
				game.logSeen(target, "%s resists the knockback!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[用 你 的 武 器 和 盾 牌 压 制 目 标 并 分 别 造 成 %d%% 武 器 和 %d%% 2 次 盾 牌 反 击 伤 害。
		如 果 上 述 攻 击 命 中， 那 么 目 标 会 被 击 退。
		受 命 中 影 响， 击 退 的 概 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
	end,
}

newTalent{
	name = "Perfect Control",
	type = {"psionic/other", 1},
	cooldown = 50,
	psi = 15,
	points = 5,
	tactical = { BUFF = 2 },
	getBoost = function(self, t)
		return self:combatScale(self:getTalentLevel(t)*self:combatStatTalentIntervalDamage(t, "combatMindpower", 1, 9), 15, 0, 49, 34)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 50, 6, 10)) end, -- Limit < 50
	action = function(self, t)
		self:setEffect(self.EFF_CONTROL, t.getDuration(self, t), {power= t.getBoost(self, t)})
		return true
	end,
	info = function(self, t)
		local boost = t.getBoost(self, t)
		local dur = t.getDuration(self, t)
		return ([[用 灵 能 围 绕 你 的 身 体， 通 过 思 想 高 效 控 制 身 体， 允 许 你 不 使 用 肌 肉 和 神 经 操 纵 身 体。 
		 增 加 %d 点 命 中 和 %0.2f%% 暴 击 概 率， 持 续 %d 回 合。]]):
		format(boost, 0.5*boost, dur)
	end,
}

newTalent{
	name = "Shattering Charge",
	type = {"psionic/other", 1},
--	require = psi_wil_req4,
	points = 5,
	psi = 40,
	cooldown = 12,
	tactical = { CLOSEIN = 2, ATTACK = { PHYSICAL = 2 } },
	range = function(self, t) return self:combatTalentLimit(t, 10, 6, 9) end,
	direct_hit = true,
	requires_target = true,
	getDam = function(self, t) return self:combatTalentMindDamage(t, 20, 180) end,
	action = function(self, t)
		if self:getTalentLevelRaw(t) < 5 then
			local tg = {type="beam", range=self:getTalentRange(t), nolock=true, talent=t}
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end
			if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end
			if self:hasLOS(x, y) and not game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
				local dam = self:mindCrit(t.getDam(self, t))
				self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(2*dam/3, dam, 3)))
				--local _ _, x, y = self:canProject(tg, x, y)
				game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
				game:playSoundNear(self, "talents/lightning")
				--self:move(x, y, true)
				local fx, fy = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
				if fx then
					self:move(fx, fy, true)
				end
			else
				game.logSeen(self, "You can't move there.")
				return nil
			end
			return true
		else
			local tg = {type="beam", range=self:getTalentRange(t), nolock=true, talent=t, display={particle="bolt_earth", trail="earthtrail"}}
			local x, y = self:getTarget(tg)
			if not x or not y then return nil end
			if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end
			local dam = self:mindCrit(t.getDam(self, t))

			for i = 1, self:getTalentRange(t) do
				self:project(tg, x, y, DamageType.DIG, 1)
			end
			self:project(tg, x, y, DamageType.MINDKNOCKBACK, self:mindCrit(rng.avg(2*dam/3, dam, 3)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
			game:playSoundNear(self, "talents/lightning")

			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, engine.Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			local tx, ty = self.x, self.y
			while lx and ly do
				if is_corner_blocked or block_actor(_, lx, ly) then break end
				tx, ty = lx, ly
				lx, ly, is_corner_blocked = l:step()
			end

			--self:move(tx, ty, true)
			local fx, fy = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if fx then
				self:move(fx, fy, true)
			end
			return true
		end
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDam(self, t))
		return ([[You expend massive amounts of energy to launch yourself across %d squares at incredible speed. All enemies in your path will be knocked flying and dealt between %d and %d Physical damage. 
		At talent level 5, you can batter through solid walls.]]):
		format(range, 2*dam/3, dam)
	end,
}

newTalent{
	name = "Telekinetic Throw",
	type = {"psionic/other", 1},
--	require = psi_wil_high2,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 20,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	range = function(self, t) return math.floor(self:combatStatScale("str", 1, 5) + self:combatMindpower()/20) end,
	getDamage = function (self, t)
		return math.floor(self:combatTalentMindDamage(t, 10, 170))
	end,
	getKBResistPen = function(self, t) return self:combatTalentLimit(t, 100, 25, 45) end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=2, selffire=false, talent=t} end,
	action = function(self, t)
		local tg = {type="hit", range=1}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		
		if target:canBe("knockback") or rng.percent(t.getKBResistPen(self, t)) then
			self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam) --Direct Damage
			
		local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
		if tx and ty then
			local ox, oy = target.x, target.y
			target:move(tx, ty, true)
			if config.settings.tome.smooth_move > 0 then
				target:resetMoveAnim()
				target:setMoveAnim(ox, oy, 8, 5)
			end
		end
		self:project(tg, target.x, target.y, DamageType.SPELLKNOCKBACK, dam/2) --AOE damage
		if target:canBe("stun") then
			target:setEffect(target.EFF_STUNNED, 4, {apply_power=self:combatMindpower()})
		else
			game.logSeen(target, "%s resists the stun!", target.name:capitalize())
		end
		else --If the target resists the knockback, do half damage to it.
			target:logCombat(self, "#YELLOW##Source# resists #Target#'s throw!")
			self:project({type="hit", range=tg.range}, target.x, target.y, DamageType.PHYSICAL, dam/2)
		end
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[Use your telekinetic power to enhance your strength, allowing you to pick up an adjacent enemy and hurl it anywhere within radius %d. 
		Upon landing, your target takes %0.1f Physical damage and is stunned for 4 turns.  All other creatures within radius 2 of the landing point take %0.1f Physical damage and are knocked away from you.
		This talent ignores %d%% of the knockback resistance of the thrown target, which takes half damage if it resists being thrown.
		The damage improves with your Mindpower and the range increases with both Mindpower and Strength.]]):
		format(range, dam, dam/2, t.getKBResistPen(self, t))
	end,
}


newTalent{
	name = "Reach",
	type = {"psionic/other", 1},
	mode = "passive",
	points = 5,
	rangebonus = function(self,t) return math.max(0, self:combatTalentScale(t, 3, 10)) end,
	info = function(self, t)
		local inc = t.rangebonus(self,t)
		local gtg = self:getTalentLevel(self.T_GREATER_TELEKINETIC_GRASP) >=5 and 1 or 0
		local add = getGemLevel(self)*t.rangebonus(self, t)
		return ([[使 用 意 念 控 制 的 宝 石 或 灵 晶 作 为 增 幅， 扩 展 意 念 接 触 范 围， 增 加 多 种 技 能 %0.1f%% ～ %0.1f%% 射 程。 增 幅 取 决 于 用 来 增 幅 的 宝 石 品 质 ( 现 在 %0.1f%%)。]]):
		format(inc*(1+gtg), inc*(5+gtg), add)
	end,
}

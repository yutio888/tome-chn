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

------------------------------------------------------------------
-- Melee
------------------------------------------------------------------

newTalent{
	name = "Knockback", short_name = "GOLEM_KNOCKBACK",
	type = {"golem/fighting", 1},
	require = techs_req1,
	points = 5,
	cooldown = 10,
	range = 5,
	stamina = 5,
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), min_range=2}
	end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.6) end,
	tactical = { DEFEND = { knockback = 2 }, DISABLE = { knockback = 1 } },
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "Your golem cannot do that currently.") return end

		local tg = self:getTalentTarget(t)
		local olds = game.target.source_actor
		game.target.source_actor = self
		local x, y, target = self:getTarget(tg)
		game.target.source_actor = olds
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		if self.ai_target then self.ai_target.target = target end

		if core.fov.distance(self.x, self.y, x, y) > 1 then
			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then
				game.logPlayer(self, "You are too close to build up momentum!")
				return
			end
			local tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
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
		end

		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) > 1 then return true end
		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

		-- Try to knockback !
		if hit then
			if target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then -- Deprecated call to checkhitold
				target:knockback(self.x, self.y, 3)
				target:crossTierEffect(target.EFF_OFFBALANCE, self:combatPhysicalpower())
			else
				game.logSeen(target, "%s resists the knockback!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 将 其 击 退 并 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 击 退 几 率 有 额 外 加 成。]]):format(100 * damage)
	end,
}

newTalent{
	name = "Taunt", short_name = "GOLEM_TAUNT",
	type = {"golem/fighting", 2},
	require = techs_req2,
	points = 5,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 18, 10, true)) end, -- Limit to > 0
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 0.5, 2.5)) end,
	stamina = 5,
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), friendlyfire=false}
	end,
	tactical = { PROTECT = 3 },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local olds = game.target.source_actor
		game.target.source_actor = self
		local x, y = self:getTarget(tg)
		game.target.source_actor = olds
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			if self:reactionToward(target) < 0 then
				if self.ai_target then self.ai_target.target = target end
				target:setTarget(self)
				self:logCombat(target, "#Source# 驱使 #Target# 攻击它。")
			end
		end)
		return true
	end,
	info = function(self, t)
		return ([[你 的 傀 儡 嘲 讽 %d 码 半 径 范 围 的 敌 人， 强 制 他 们 攻 击 傀 儡。]]):format(self:getTalentRadius(t)) 
	end,
}

newTalent{
	name = "Crush", short_name = "GOLEM_CRUSH",
	type = {"golem/fighting", 3},
	require = techs_req3,
	points = 5,
	cooldown = 10,
	range = 5,
	stamina = 5,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.6) end,
	getPinDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	tactical = { ATTACK = { PHYSICAL = 0.5 }, DISABLE = { pin = 2 } },
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "Your golem cannot do that currently.") return end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local olds = game.target.source_actor
		game.target.source_actor = self
		local x, y, target = self:getTarget(tg)
		game.target.source_actor = olds
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		if self.ai_target then self.ai_target.target = target end

		if core.fov.distance(self.x, self.y, x, y) > 1 then
			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then
				game.logPlayer(self, "You are too close to build up momentum!")
				return
			end
			local tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
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
		end

		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) > 1 then return true end
		local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

		-- Try to pin
		if hit then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, t.getPinDuration(self, t), {apply_power=self:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists the crushing!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getPinDuration(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 将 其 推 倒 在 地 持 续 %d 回 合， 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 定 身 几 率 有 加 成。]]):
		format(duration, 100 * damage)
	end,
}

newTalent{
	name = "Pound", short_name = "GOLEM_POUND",
	type = {"golem/fighting", 4},
	require = techs_req4,
	points = 5,
	cooldown = 15,
	range = 5,
	radius = 2,
	stamina = 5,
	requires_target = true,
	target = function(self, t)
		return {type="ballbolt", radius=self:getTalentRadius(t), friendlyfire=false, range=self:getTalentRange(t)}
	end,
	getGolemDamage = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.4, 1.1)
	end,
	getDazeDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	tactical = { ATTACKAREA = { PHYSICAL = 0.5 }, DISABLE = { daze = 3 } },
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "Your golem cannot do that currently.") return end

		local tg = self:getTalentTarget(t)
		local olds = game.target.source_actor
		game.target.source_actor = self
		local x, y, target = self:getTarget(tg)
		game.target.source_actor = olds
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		if core.fov.distance(self.x, self.y, x, y) > 1 then
			local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
			local l = self:lineFOV(x, y, block_actor)
			local lx, ly, is_corner_blocked = l:step()
			if is_corner_blocked or game.level.map:checkAllEntities(lx, ly, "block_move", self) then
				game.logPlayer(self, "You are too close to build up momentum!")
				return
			end
			local tx, ty = lx, ly
			lx, ly, is_corner_blocked = l:step()
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
		end

		if self.ai_target then self.ai_target.target = target end

		-- Attack & daze
		tg.type = "ball"
		self:project(tg, self.x, self.y, function(xx, yy)
			if xx == self.x and yy == self.y then return end
			local target = game.level.map(xx, yy, Map.ACTOR)
			if target and self:attackTarget(target, nil, t.getGolemDamage(self, t), true) then
				if target:canBe("stun") then
					target:setEffect(target.EFF_DAZED, t.getDazeDuration(self, t), {apply_power=self:combatPhysicalpower()})
				else
					game.logSeen(target, "%s resists the dazing blow!", target.name:capitalize())
				end
			end
		end)

		return true
	end,
	info = function(self, t)
		local duration = t.getDazeDuration(self, t)
		local damage = t.getGolemDamage(self, t)
		return ([[你 的 傀 儡 冲 向 目 标， 践 踏 周 围 2 码 范 围， 眩 晕 所 有 目 标 %d 回 合 并 造 成 %d%% 伤 害。 
		 受 技 能 等 级 影 响， 眩 晕 几 率 有 额 外 加 成。]]):
		format(duration, 100 * damage)
	end,
}


------------------------------------------------------------------
-- Arcane
------------------------------------------------------------------

newTalent{
	name = "Eye Beam", short_name = "GOLEM_BEAM",
	type = {"golem/arcane", 1},
	require = spells_req1,
	points = 5,
	cooldown = 3,
	range = 7,
	mana = 10,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 320) end,
	tactical = { ATTACK = { FIRE = 1, COLD = 1, LIGHTNING = 1 } },
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		if self.x == x and self.y == y then return nil end

		-- We will always project the beam as far as possible
		local l = self:lineFOV(x, y)
		l:set_corner_block()
		local lx, ly, is_corner_blocked = l:step(true)
		local target_x, target_y = lx, ly
		-- Check for terrain and friendly actors
		while lx and ly and not is_corner_blocked and core.fov.distance(self.x, self.y, lx, ly) <= tg.range do
			local actor = game.level.map(lx, ly, engine.Map.ACTOR)
			if actor and (self:reactionToward(actor) >= 0) then
				break
			elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
				target_x, target_y = lx, ly
				break
			end
			target_x, target_y = lx, ly
			lx, ly = l:step(true)
		end
		x, y = target_x, target_y

		local typ = rng.range(1, 3)

		if typ == 1 then
			self:project(tg, x, y, DamageType.FIRE, self:spellCrit(t.getDamage(self, t)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
		elseif typ == 2 then
			self:project(tg, x, y, DamageType.LIGHTNING, self:spellCrit(t.getDamage(self, t)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		else
			self:project(tg, x, y, DamageType.COLD, self:spellCrit(t.getDamage(self, t)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "icebeam", {tx=x-self.x, ty=y-self.y})
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从 你 的 眼 睛 中 发 射 一 束 光 束， 造 成 %0.2f 火 焰 伤 害， %0.2f 冰 冷 伤 害 或 %0.2f 闪 电 伤 害。 
		 受 傀 儡 的 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.COLD, damage), damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

newTalent{
	name = "Reflective Skin", short_name = "GOLEM_REFLECTIVE_SKIN",
	type = {"golem/arcane", 2},
	require = spells_req2,
	points = 5,
	mode = "sustained",
	cooldown = 70,
	range = 10,
	sustain_mana = 30,
	requires_target = true,
	tactical = { DEFEND = 1, SURROUNDED = 3, BUFF = 1 },
	getReflect = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 12, 40), 100, 20, 0, 46.5, 26.5) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		self:addShaderAura("reflective_skin", "awesomeaura", {time_factor=5500, alpha=0.6, flame_scale=0.6}, "particles_images/arcaneshockwave.png")
		local ret = {
			tmpid = self:addTemporaryValue("reflect_damage", (t.getReflect(self, t)))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("reflective_skin")
		self:removeTemporaryValue("reflect_damage", p.tmpid)
		return true
	end,
	info = function(self, t)
		return ([[你 的 傀 儡 皮 肤 闪 烁 着 艾 尔 德 里 奇 能 量。 
		 所 有 对 其 造 成 的 伤 害 有 %d%% 被 反 射 给 攻 击 者。 
		 傀 儡 仍 然 受 到 全 部 伤 害。 
		 受 傀 儡 的 法 术 强 度 影 响， 伤 害 反 射 值 有 额 外 加 成。]]):
		format(t.getReflect(self, t))
	end,
}

newTalent{
	name = "Arcane Pull", short_name = "GOLEM_ARCANE_PULL",
	type = {"golem/arcane", 3},
	require = spells_req3,
	points = 5,
	cooldown = 15,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3.5, 5.5)) end,
	mana = 20,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	tactical = { ATTACKAREA = { ARCANE = 2 }, CLOSEIN = 1 },
	getDamage = function(self, t)
		return self:combatTalentSpellDamage(t, 12, 120)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tgts = {}
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target then
				tgts[#tgts+1] = {actor=target, sqdist=core.fov.distance(self.x, self.y, px, py)}
			end
		end)
		table.sort(tgts, "sqdist")
		for i, target in ipairs(tgts) do
			target.actor:pull(self.x, self.y, tg.radius)
			self:logCombat(target.actor, "#Target# 被拉向 #Source#!")
			DamageType:get(DamageType.ARCANE).projector(self, target.actor.x, target.actor.y, DamageType.ARCANE, t.getDamage(self, t))
		end
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你 的 傀 儡 将 %d 码 范 围 内 的 敌 人 牵 引 至 身 边， 并 造 成 %0.2f 奥 术 伤 害。]]):
		format(rad, dam)
	end,
}

newTalent{
	name = "Molten Skin", short_name = "GOLEM_MOLTEN_SKIN",
	type = {"golem/arcane", 4},
	require = spells_req4,
	points = 5,
	mana = 60,
	cooldown = 15,
	range = 0,
	radius = 3,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	action = function(self, t)
		local duration = 5 + self:getTalentLevel(t)
		local dam = self:combatTalentSpellDamage(t, 12, 120)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.GOLEM_FIREBURN, dam,
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, alpha=85, color_br=200, color_bg=60, color_bb=30, effect_shader="shader_images/fire_effect.png"},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		self:setEffect(self.EFF_MOLTEN_SKIN, duration, {power=30 + self:combatTalentSpellDamage(t, 12, 60)})
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		return ([[使 傀 儡 的 皮 肤 变 成 灼 热 岩 浆， 发 出 的 热 量 可 以 将 3 码 范 围 内 的 敌 人 点 燃， 在 3 回 合 内 每 回 合 造 成 %0.2f 灼 烧 伤 害 持 续 %d 回 合。 
		 灼 烧 可 叠 加， 他 们 在 火 焰 之 中 持 续 时 间 越 长 受 到 伤 害 越 高。 
		 此 外 傀 儡 获 得 %d%% 火 焰 抵 抗。 
		 熔 岩 皮 肤 不 能 影 响 傀 儡 的 主 人。 
		 受 法 术 强 度 影 响， 伤 害 和 抵 抗 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 120)), 5 + self:getTalentLevel(t), 30 + self:combatTalentSpellDamage(t, 12, 60))
	end,
}

newTalent{
	name = "Self-destruction", short_name = "GOLEM_DESTRUCT",
	type = {"golem/golem", 1},
	points = 1,
	range = 0,
	radius = 4,
	no_unlearn_last = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACKAREA = { FIRE = 3 } },
	no_npc_use = true,
	on_pre_use = function(self, t)
		return self.summoner and self.summoner.dead
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.FIRE, 50 + 10 * self.level)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_fire", {radius=tg.radius})
		game:playSoundNear(self, "talents/fireflash")
		self:die(self)
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[傀 儡 引 爆 自 己， 摧 毁 傀 儡 并 产 生 一 个 火 焰 爆 炸， %d 码 有 效 范 围 内 造 成 %0.2f 火 焰 伤 害。 
		 这 个 技 能 只 有 傀 儡 的 主 人 死 亡 时 能 够 使 用。]]):format(rad, damDesc(self, DamageType.FIRE, 50 + 10 * self.level))
	end,
}

-- Compensate for changes to Armour Training by introducing a new golem skill
newTalent{
	name = "Armour Configuration", short_name = "GOLEM_ARMOUR",
	type = {"golem/golem", 1},
	mode = "passive",
	points = 6,
	no_unlearn_last = true,
	getArmorHardiness = function(self, t) return self:getTalentTypeMastery("technique/combat-training") * (self:getTalentLevelRaw(t) * 5 - 15) end,
	getArmor = function(self, t) return self:getTalentTypeMastery("technique/combat-training") * (self:getTalentLevelRaw(t) * 1.4 - 4.2) end,
	getCriticalChanceReduction = function(self, t) return self:getTalentTypeMastery("technique/combat-training") * (self:getTalentLevelRaw(t) * 1.9 - 5.7) end,
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local critreduce = t.getCriticalChanceReduction(self, t)
		local dir = self:getTalentLevelRaw(t) >= 3 and "In" or "De"
		return ([[傀 儡 学 会 重 新 组 装 重 甲 和 板 甲， 以 便 更 加 适 用 于 傀 儡。 
		 当 装 备 重 甲 或 板 甲 时， %s 增 加 护 甲 强 度 %d 点 , 护 甲 韧 性 %d%%， 并 且 减 少 %d%% 暴 击 伤 害。]]):
		format(dir, armor, hardiness, critreduce)
	end,
}

newTalent{
	name = "Poison Breath", short_name = "DROLEM_POISON_BREATH", image = "talents/poison_breath.png",
	type = {"golem/drolem",1},
	require = spells_req_high1,
	points = 5,
	mana = 25,
	cooldown = 8,
	message = "@Source@ breathes poison!",
	tactical = { ATTACKAREA = { NATURE = 1, poison = 1 } },
	range = 0,
	radius = 5,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.POISON, {dam=self:spellCrit(self:combatTalentStatDamage(t, "mag", 30, 460)), apply_power=self:combatSpellpower()})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_slime", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[ 对 你 的 敌 人 喷 吐 毒 雾 ， 在 几 个 回 合 内 造 成 %d 点 伤 害 。 受 魔 法 影 响 ， 伤 害 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "mag", 30, 460)))
	end,
}

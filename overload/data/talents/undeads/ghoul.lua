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
	name = "Ghoul",
	type = {"undead/ghoul", 1},
	mode = "passive",
	require = undeads_req1,
	points = 5,
	statBonus = function(self, t) return self:combatTalentScale(t, 2, 10, 0.75) end,
	getMaxDamage = function(self, t) return math.max(50, 100 - self:getTalentLevelRaw(t) * 10) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_STR]=t.statBonus(self, t)})
		self:talentTemporaryValue(p, "inc_stats", {[self.STAT_CON]=t.statBonus(self, t)})
		self:talentTemporaryValue(p, "flat_damage_cap", {all=t.getMaxDamage(self, t)})
	end,
	info = function(self, t)
		return ([[增 强 食 尸 鬼 的 身 体， 增 加 %d 点 力 量 和 体 质。
		你 的 身 体 对 伤 害 抗 性 极 高， 任 何 一 次 伤 害 不 会 让 你 失 去 超 过 %d%% 最 大 生 命。]])
		:format(t.statBonus(self, t), t.getMaxDamage(self, t))
	end,
}

newTalent{
	name = "Ghoulish Leap",
	type = {"undead/ghoul", 2},
	require = undeads_req2,
	points = 5,
	tactical = { CLOSEIN = 3 },
	direct_hit = true,
	cooldown = function(self, t) return math.max(10, 22 - self:getTalentLevelRaw(t) * 2) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5, 10, 0.5, 0, 1)) end,
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), nolock=true}
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
		return ([[跳 向 你 的 目 标。]])
	end,
}

newTalent{
	name = "Retch",
	type = {"undead/ghoul",3},
	require = undeads_req3,
	points = 5,
	cooldown = 25,
	tactical = { ATTACK = { BLIGHT = 1 }, HEAL = 1 },
	range=1,
	requires_target = true,
	getduration = function(self, t) return self:combatTalentScale(t, 7, 15, 0.5) end,
	getPurgeChance = function(self, t) return self:combatTalentLimit(t, 100, 5, 25) end, -- Limit < 100%
	-- status effect removal handled in mod.data.damage_types (type = "RETCH")
	action = function(self, t)
		local duration = t.getduration(self, t)
		local radius = 3
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		local tg = {type="ball", range=self:getTalentRange(t), radius=radius}
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.RETCH, dam,
			radius,
			5, nil,
			MapEffect.new{color_br=30, color_bg=180, color_bb=60, effect_shader="shader_images/retch_effect.png"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local dam = 10 + self:combatTalentStatDamage(t, "con", 10, 60)
		return ([[向 你 周 围 的 空 地 上 呕 吐， 治 疗 任 何 在 这 空 地 上 的 不 死 族 并 伤 害 敌 方 单 位。 
		 持 续 %d 回 合 并 造 成 %d 点 枯 萎 伤 害 或 治 疗 %d 点 生 命 值。
		 呕 吐 范 围 内 的 生 物 有 %d%% 概 率 失 去 一 项 物 理 效 果 。 
		 不 死 族 解 除 负 面 效 果 ， 其 他 生 物 失 去 正 面 效 果。]]):format(t.getduration(self, t), damDesc(self, DamageType.BLIGHT, dam), dam * 1.5, t.getPurgeChance(self, t))
	end,
}

newTalent{
	name = "Gnaw",
	type = {"undead/ghoul", 4},
	require = undeads_req4,
	points = 5,
	cooldown = 15,
	tactical = { ATTACK = {BLIGHT = 2} },
	range = 1,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentScale(t, 0.28, 0.62) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getDiseaseDamage = function(self, t) return self:combatTalentStatDamage(t, "con", 5, 50) end,
	getStatDamage = function(self, t) return self:combatTalentStatDamage(t, "con", 5, 20) end,
	spawn_ghoul = function (self, target, t)
		local x, y = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
		if not x then return nil end

		local list = mod.class.NPC:loadList("/data/general/npcs/ghoul.lua")
		local m = list.GHOUL:clone()
		if not m then return nil end

		m:resolve() m:resolve(nil, true)
		m.ai = "summoned"
		m.ai_real = "dumb_talented_simple"
		m.faction = self.faction
		m.summoner = self
		m.summoner_gain_exp = true
		m.summon_time = 20
		m.exp_worth = 0
		m.no_drops = true
		if self:knowTalent(self.T_BLIGHTED_SUMMONING) then 
			m:incIncStat("mag", self:getMag()) 
			m.blighted_summon_talent = self.T_REND
		end
		self:attr("summoned_times", 1)
		
		game.zone:addEntity(game.level, m, "actor", target.x, target.y)
		game.level.map:particleEmitter(target.x, target.y, 1, "slime")
		game:playSoundNear(target, "talents/slime")
		m:logCombat(target, "A #GREY##Source##LAST# rises from the corpse of #Target#.")
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		-- Damage Stats?
		local str_damage, con_damage, dex_damage = 0
		if self:getTalentLevel(t) >=2 then str_damage = t.getStatDamage(self, t) end
		if self:getTalentLevel(t) >=3 then dex_damage = t.getStatDamage(self, t) end
		if self:getTalentLevel(t) >=4 then con_damage = t.getStatDamage(self, t) end
		
		-- Ghoulify??
		local ghoulify = 0
		if self:getTalentLevel(t) >=5 then ghoulify = 1 end
		
		if hitted then
			if target:canBe("disease") then
				if target.dead and ghoulify > 0 then
					t.spawn_ghoul(self, target, t)
				end
				target:setEffect(target.EFF_GHOUL_ROT, t.getDuration(self,t), {src=self, apply_power=self:combatPhysicalpower(), dam=t.getDiseaseDamage(self, t), str=str_damage, con=con_damage, dex=dex_damage, make_ghoul=ghoulify})
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local disease_damage = t.getDiseaseDamage(self, t)
		local stat_damage = t.getStatDamage(self, t)
		return ([[撕 咬 你 的 目 标 造 成 %d%% 伤 害。 
		如 果 你 的 攻 击 命 中， 目 标 会 感 染 食 尸 鬼 腐 烂 疫 病 持 续 %d 回 合。 
		食 尸 鬼 腐 烂 疫 病 每 回 合 造 成 %0.2f 枯 萎 伤 害。 
		等 级 2 时 食 尸 鬼 腐 烂 疫 病 还 能 降 低 %d 点 力 量； 
		等 级 3 时 降 低 %d 点 敏 捷； 
		等 级 4 时 降 低 %d 点 体 质； 
		等 级 5 时 目 标 被 杀 死 时 会 变 成 你 的 食 尸 鬼 傀 儡。 
		受 体 质 影 响， 枯 萎 伤 害 及 属 性 减 益 按 比 例 加 成。 ]]):
		format(100 * damage, duration, damDesc(self, DamageType.BLIGHT, disease_damage), stat_damage, stat_damage, stat_damage)
	end,
}


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

isOnMucus = function(map, x, y)
	for i, e in ipairs(map.effects) do
		if e.damtype == DamageType.MUCUS and e.grids[x] and e.grids[x][y] then return true end
	end
end

newTalent{
	name = "Mucus",
	type = {"wild-gift/mucus", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 0,
	cooldown = 20,
	no_energy = true,
	tactical = { BUFF = 2, EQUILIBRIUM = 2,
		ATTACKAREA = function(self, t)
			if self:getTalentLevel(t)>=4 then return {NATURE = 1 } end
		end
	},
	getDur = function(self, t) return math.floor(self:combatTalentLimit(t, 20, 4, 6.5)) end, -- Limit < 20
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	-- note meditation recovery: local pt = 2 + self:combatTalentMindDamage(t, 20, 120) / 10 = O(<1)
	getEqui = function(self, t) return self:combatTalentMindDamage(t, 2, 8) end,
	-- Called by MUCUS effect in mod.data.timed_effects.physical.lua
	trigger = function(self, t, x, y, rad, eff) -- avoid stacking on map tile
		local oldmucus = eff and eff[x] and eff[x][y] -- get previous mucus at this spot
		if not oldmucus or oldmucus.duration <= 0 then -- make new mucus
			local mucus=game.level.map:addEffect(self,
				x, y, t.getDur(self, t),
				DamageType.MUCUS, {dam=t.getDamage(self, t), self_equi=t.getEqui(self, t), equi=1, bonus_level = 0},
				rad,
				5, nil,
				{zdepth=6, type="mucus"},
				nil, true
			)
			if eff then
				eff[x] = eff[x] or {}
				eff[x][y]=mucus
			end
		else
			if oldmucus.duration > 0 then -- Enhance existing mucus
				oldmucus.duration = t.getDur(self, t)
				oldmucus.dam.bonus_level = oldmucus.dam.bonus_level + 1
				oldmucus.dam.self_equi = oldmucus.dam.self_equi + 1
				oldmucus.dam.dam = t.getDamage(self, t) * (1+ self:combatTalentLimit(oldmucus.dam.bonus_level, 1, 0.25, 0.7)) -- Limit < 2x damage
			end
		end
	end,
	action = function(self, t)
		local dur = t.getDur(self, t)
		self:setEffect(self.EFF_MUCUS, dur, {})
		return true
	end,
	info = function(self, t)
		local dur = t.getDur(self, t)
		local dam = t.getDamage(self, t)
		local equi = t.getEqui(self, t)
		return ([[你 开 始 在 你 经 过 或 站 立 的 地 方 滴 落 粘 液， 持 续 %d 回 合。 
		 粘 液 每 回 合 自 动 放 置 ， 持 续 %d 回 合 。
		 在 等 级 4 时， 粘 液 会 扩 展 到 1 码 半 径 范 围。 
		 粘 液 会 使 所 有 经 过 的 敌 人 中 毒， 每 回 合 造 成 %0.1f 自 然 伤 害， 持 续 5 回 合（ 可 叠 加）。 
		 站 在 自 己 的 粘 液 上 时 ， 你 每 回 合 回 复 %0.1f 失 衡 值 。
		 每 个 经 过 粘 液 的 友 方 单 位， 每 回 合 将 和 你 一 起 回 复 1 点 失 衡 值。  
		 受 精 神 强 度 影 响， 伤 害 和 失 衡 值 回 复 有 额 外 加 成。 
		 在 同 样 的 位 置 站 在 更 多 的 粘 液 上 会 强 化 粘 液 效 果 ， 增 加 1 回 合 持 续 时 间 。]]):
		format(dur, dur, damDesc(self, DamageType.NATURE, dam), equi)
	end,
}

newTalent{
	name = "Acid Splash",
	type = {"wild-gift/mucus", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 10,
	cooldown = 10,
	range = 7,
	radius = function(self, t) return 2 + (self:getTalentLevel(t) >= 5 and 1 or 0) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false} end,
	tactical = { ATTACKAREA = { ACID = 2, NATURE = 1 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 220) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local grids, px, py = self:project(tg, x, y, DamageType.ACID, self:mindCrit(t.getDamage(self, t)))
		if self:knowTalent(self.T_MUCUS) then
			self:callTalent(self.T_MUCUS, nil, px, py, tg.radius, self:hasEffect(self.EFF_MUCUS))
		end
		game.level.map:particleEmitter(px, py, tg.radius, "acidflash", {radius=tg.radius, tx=px, ty=py})

		local tgts = {}
		for x, ys in pairs(grids) do for y, _ in pairs(ys) do
			local target = game.level.map(x, y, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
		end end

		if #tgts > 0 then
			if game.party:hasMember(self) then
				for act, def in pairs(game.party.members) do
					local target = rng.table(tgts)
					if act.summoner and act.summoner == self and act.is_mucus_ooze then
						act.inc_damage.all = (act.inc_damage.all or 0) - 50
						act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
						act.inc_damage.all = (act.inc_damage.all or 0) + 50
					end
				end
			else
				for _, act in pairs(game.level.entities) do
					local target = rng.table(tgts)
					if act.summoner and act.summoner == self and act.is_mucus_ooze then
						act.inc_damage.all = (act.inc_damage.all or 0) - 50
						act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
						act.inc_damage.all = (act.inc_damage.all or 0) + 50
					end
				end
			end
		end


		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 召 唤 大 自 然 的 力 量， 将 %d 码 半 径 范 围 内 的 地 面 转 化 为 酸 性 淤 泥 区， 对 所 有 目 标 造 成 %0.1f 酸 性 伤 害 并 在 区 域 内 制 造 粘 液。 
		 同 时 如 果 你 有 任 何 粘 液 软 泥 怪 存 在， 则 会 向 视 线 内 的 某 个 被 淤 泥 击 中 的 随 机 目 标 释 放 史 莱 姆 喷 吐（ 较 低 强 度）。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, dam))
	end,
}

newTalent{ short_name = "MUCUS_OOZE_SPIT", 
	name = "Slime Spit", image = "talents/slime_spit.png",
	type = {"wild-gift/other",1},
	points = 5,
	equilibrium = 2,
	mesage = "@Source@ spits slime!",
	range = 6,
	direct_hit = true,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 2 } },
	action = function(self, t)
		local tg = {type="beam", range=self:getTalentRange(t), talent=t, selffire=false, friendlyfire=false}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SLIME, self:mindCrit(self:combatTalentMindDamage(t, 8, 110)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "ooze_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[喷 射 一 道 射 线 造 成 %0.2f 史 莱 姆 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.SLIME, self:combatTalentMindDamage(t, 8, 80)))
	end,
}

newTalent{
	name = "Living Mucus",
	type = {"wild-gift/mucus", 3},
	require = gifts_req3,
	points = 5,
	mode = "passive",
	getMax = function(self, t) return math.floor(math.max(1, self:combatStatScale("cun", 0.5, 5))) end,
	getChance = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 5, 300), 50, 12.6, 26, 32, 220) end, -- Limit < 50% --> 12.6 @ 36, 32 @ 220
	getSummonTime = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	-- by MUCUS damage type in mod.data.damage_types.lua
	spawn = function(self, t)
		local notok, nb, sumlim = checkMaxSummon(self, true, 1, "is_mucus_ooze")
		if notok or nb >= t.getMax(self, t) or not self:canBe("summon") then return end

		local ps = {}
		for i, e in ipairs(game.level.map.effects) do
			if e.damtype == DamageType.MUCUS then
				for x, ys in pairs(e.grids) do for y, _ in pairs(ys) do
					if self:canMove(x, y) then ps[#ps+1] = {x=x, y=y} end
				end end
			end
		end
		if #ps == 0 then return end
		local p = rng.table(ps)

		local m = mod.class.NPC.new{
			type = "vermin", subtype = "oozes",
			display = "j", color=colors.GREEN, image = "npc/vermin_oozes_green_ooze.png",
			name = "mucus ooze",
			faction = self.faction,
			desc = "It's made from mucus and it's oozing.",
			sound_moam = {"creatures/jelly/jelly_%d", 1, 3},
			sound_die = {"creatures/jelly/jelly_die_%d", 1, 2},
			sound_random = {"creatures/jelly/jelly_%d", 1, 3},
			body = { INVEN = 10 },
			autolevel = "wildcaster",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
			stats = { str=10, dex=10, mag=3, con=self:combatTalentScale(t, 0.8, 4, 0.75), wil=self:combatStatScale("wil", 10, 100, 0.75), cun=self:combatStatScale("cun", 10, 100, 0.75) },
			global_speed_base = 0.7,
			combat = {sound="creatures/jelly/jelly_hit"},
			combat_armor = 1, combat_def = 1,
			rank = 1,
			size_category = 3,
			infravision = 10,
			cut_immune = 1,
			blind_immune = 1,

			resists = { [DamageType.LIGHT] = -50, [DamageType.COLD] = -50 },
			fear_immune = 1,

			blood_color = colors.GREEN,
			level_range = {self.level, self.level}, exp_worth = 0,
			max_life = 30,

			combat = { dam=5, atk=0, apr=5, damtype=DamageType.POISON },

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true, is_mucus_ooze = true,
			summon_time = t.getSummonTime(self, t),
			max_summon_time = math.floor(self:combatTalentScale(t, 6, 10)),
		}
		m:learnTalent(m.T_MUCUS_OOZE_SPIT, true, self:getTalentLevelRaw(t))
		setupSummon(self, m, p.x, p.y)
		return true
	end,
	on_crit = function(self, t)
		if game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act.summon_time = util.bound(act.summon_time + 2, 1, act.max_summon_time)
				end
			end
		else
			for _, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act.summon_time = util.bound(act.summon_time + 2, 1, act.max_summon_time)
				end
			end
		end
	end,
	info = function(self, t)
		return ([[你 的 粘 液 有 了 自 己 的 感 知。 每 回 合 有 %d%% 几 率， 随 机 一 个 滴 有 你 的 粘 液 的 码 子 会 产 生 一 只 粘 液 软 泥 怪。 
		 粘 液 软 泥 怪 会 存 在 %d 回 合 ，会 向 任 何 附 近 的 敌 人 释 放 史 莱 姆 喷 吐。 
		 同 时 场 上 可 存 在 %d 只 粘 液 软 泥 怪。 ( 基 于 你 的 灵 巧 值 )
		 每 当 你 造 成 一 次 精 神 暴 击， 你 的 所 有 粘 液 软 泥 怪 的 存 在 时 间 会 延 长 2 回 合。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(t.getChance(self, t), t.getSummonTime(self, t), t.getMax(self, t))
	end,
}

newTalent{
	name = "Oozewalk",
	type = {"wild-gift/mucus", 4},
	require = gifts_req4,
	points = 5,
	cooldown = 7,
	equilibrium = 10,
	range = 10,
	tactical = { CLOSEIN = 2 },
	getNb = function(self, t) return math.ceil(self:combatTalentScale(t, 1.1, 2.9, "log")) end,
	getEnergy = function(self,t)
		local tl = math.max(0, self:getTalentLevel(t) - 1.8)
		return 1-tl/(tl + 2.13)
	end,
	on_pre_use = function(self, t)
		return game.level and game.level.map and isOnMucus(game.level.map, self.x, self.y)
	end,
	action = function(self, t)
		local tg = {type="hit", nolock=true, pass_terrain=true, nowarning=true, range=self:getTalentRange(t), requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)
		if not x then return nil end
		if not isOnMucus(game.level.map, x, y) then return nil end
		if not self:canMove(x, y) then return nil end

		local energy = 1 - t.getEnergy(self, t)
		self.energy.value = self.energy.value + game.energy_to_act * self.energy.mod * energy

		self:removeEffectsFilter(function(t) return t.type == "physical" or t.type == "magical" end, t.getNb(self, t))

		game.level.map:particleEmitter(self.x, self.y, 1, "slime")
		self:move(x, y, true)
		game.level.map:particleEmitter(self.x, self.y, 1, "slime")

		return true
	end,
	info = function(self, t)
		local nb = t.getNb(self, t)
		local energy = t.getEnergy(self, t)
		return ([[你 暂 时 性 的 和 粘 液 融 为 一 体， 净 化 你 身 上 %d 物 理 或 魔 法 效 果。 
		 然 后， 你 可 以 闪 现 到 视 野 内 任 何 有 粘 液 覆 盖 的 区 域。
		 此 技 能 消 耗 %d%% 回 合。 
		 只 有 当 你 站 在 粘 液 区 时 才 能 使 用。]]):
		format(nb, (energy) * 100)
	end,
}

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
	name = "Mitosis",
	type = {"wild-gift/ooze", 1},
	require = gifts_req1,
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_equilibrium = 10,
	tactical = { BUFF = 2,
		EQUILIBRIUM = function(self, t)
			if self:knowTalent(self.T_REABSORB) then return 1 end
		end
	},
	getMaxHP = function(self, t) return
		50 + self:combatTalentMindDamage(t, 30, 250) + self.max_life * self:combatTalentLimit(t, 0.25, .025, .1)
	end,
	getMax = function(self, t) local _, _, max = checkMaxSummon(self, true) return math.min(max, math.max(1, math.floor(self:combatTalentLimit(t, 6, 1, 3.1)))) end, --Limit < 6
	getChance = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "cun", 10, 400), 100, 20, 0, 61, 234) end, -- Limit < 100%
	getOozeResist = function(self, t) return self:combatTalentLimit(t, 70, 15, 30) end, --Limit < 70%
	getSummonTime = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	-- called in mod.class.Actor.onTakeHit
	spawn = function(self, t, life)
		-- check summoning limits
		if checkMaxSummon(self, true) or not self:canBe("summon") then return end
		local _, nb = checkMaxSummon(self, true, nil, "bloated_ooze")
		if nb >= t.getMax(self, t) then	return end

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "You try to split, but there is no free space close enough to summon!")
			return
		end

		local m = mod.class.NPC.new{
			type = "vermin", subtype = "oozes",
			display = "j", color=colors.GREEN, image = "npc/vermin_oozes_bloated_ooze.png",
			name = "bloated ooze",
			desc = "It's made from your own flesh and it's oozing.",
			sound_moam = {"creatures/jelly/jelly_%d", 1, 3},
			sound_die = {"creatures/jelly/jelly_die_%d", 1, 2},
			sound_random = {"creatures/jelly/jelly_%d", 1, 3},
			body = { INVEN = 10 },
			autolevel = "tank",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
			stats = { wil=10, dex=10, mag=3, str=self:combatStatScale("wil", 10, 50, 0.75), con=self:combatStatScale("con", 10, 100, 0.75), cun=self:combatStatScale("cun", 10, 100, 0.75)},
			global_speed_base = 0.5,
			combat = {sound="creatures/jelly/jelly_hit"},
			combat_armor = self:combatTalentScale(t, 5, 25),
			combat_def = self:combatTalentScale(t, 5, 25, 0.75),
			rank = 1,
			size_category = 3,
			infravision = 10,
			cut_immune = 1,
			blind_immune = 1,
			bloated_ooze = 1,
			resists = { all = t.getOozeResist(self, t)},
			resists_cap = table.clone(self.resists_cap),
			fear_immune = 1,
			blood_color = colors.GREEN,
			level_range = {self.level, self.level}, exp_worth = 0,
			max_life = 30,
			life_regen = 0.1*life,
			faction = self.faction,
			combat = { dam=5, atk=self:combatStatScale("cun", 10, 100, 0.75), apr=5, damtype=DamageType.POISON },

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true,
			summon_time = t.getSummonTime(self, t),
			max_summon_time = math.floor(self:combatTalentScale(t, 6, 10)),
			resolvers.sustains_at_birth(),
		}
		setupSummon(self, m, x, y)
		m.max_life = math.min(life, t.getMaxHP(self, t))
		m.life = m.max_life
		if self:isTalentActive(self.T_ACIDIC_SOIL) then
			m.life_regen = m.life_regen + self:callTalent(self.T_ACIDIC_SOIL, "getRegen")
		end

		game:playSoundNear(self, "talents/spell_generic2")

		return true
	end,
	activate = function(self, t)
		return {equil_regen = self:knowTalent(self.T_REABSORB) and self:addTemporaryValue("equilibrium_regen", -self:callTalent(self.T_REABSORB, "equiRegen"))}
	end,
	deactivate = function(self, t, p)
		if p.equil_regen then self:removeTemporaryValue("equilibrium_regen", p.equil_regen) end
		return true
	end,
	info = function(self, t)
		local xs = self:knowTalent(self.T_REABSORB) and ([[同 时， 当 这 个 技 能 开 启 时 ， 每 回 合 回 复 %0.1f 点 失 衡 值 。
		]]):format(self:callTalent(self.T_REABSORB, "equiRegen")) or ""
		return ([[你 的 身 体 构 造 变 的 像 软 泥 怪 一 样。 
		 当 你 受 到 攻 击 时， 你 有 几 率 分 裂 出 一 个 浮 肿 软 泥 怪， 其 生 命 值 为 你 所 承 受 的 伤 害 值 的 两 倍（ 最 大 %d）。 
		 分 裂 几 率 为 你 损 失 生 命 百 分 比 的 %0.2f 倍。
		 你 所 承 受 的 所 有 伤 害 会 在 你 和 浮 肿 软 泥 怪 间 均 摊。 
		 你 同 时 最 多 只 能 拥 有 %d 只 浮 肿 软 泥 怪（ 基 于 你 的 灵 巧 值 和 技 能 等 级 ）。
		 浮 肿 软 泥 怪 对 非 均 摊 的伤 害 的 抗 性 很 高（ 50%% 对 全 部 伤 害 的 抗 性 ）,同 时 生 命 回 复 快。
		 受 精 神 强 度 影 响， 最 大 生 命 值 有 额 外 加 成。 
		 受 灵 巧 影 响， 几 率 有 额 外 加 成。]]):
		format(t.getMaxHP(self, t), t.getChance(self, t)*3/100, t.getMax(self, t), t.getSummonTime(self, t), t.getOozeResist(self, t))
	end,
}

newTalent{
	name = "Reabsorb",
	type = {"wild-gift/ooze", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 10,
	cooldown = 15,
	tactical = { PROTECT = 2, ATTACKAREA = { ARCANE = 1 } },
	getDam = function(self, t) return self:combatTalentMindDamage(t, 15, 200) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	on_pre_use = function(self, t)
		if not game.level or not self.x or not self.y then return false end
		for _, coor in pairs(util.adjacentCoords(self.x, self.y)) do
			local act = game.level.map(coor[1], coor[2], Map.ACTOR)
			if act and act.summoner == self and act.bloated_ooze then
				return true
			end
		end
		return false
	end,
	equiRegen = function(self, t) return 0.2 + self:combatTalentMindDamage(t, 0, 1.4) end,
	action = function(self, t)
		local possibles = {}
		for _, coor in pairs(util.adjacentCoords(self.x, self.y)) do
			local act = game.level.map(coor[1], coor[2], Map.ACTOR)
			if act and act.summoner == self and act.bloated_ooze then
				possibles[#possibles+1] = act
			end
		end
		if #possibles == 0 then return end

		local act = rng.table(possibles)
		act:die(self)

		self:setEffect(self.EFF_PAIN_SUPPRESSION, t.getDuration(self, t), {power=40})
		local tg = {type="ball", radius=3, range=0, talent=t, selffire=false, friendlyfire=false}
		self:project(tg, self.x, self.y, DamageType.MANABURN, self:mindCrit(t.getDam(self, t)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "acidflash", {radius=tg.radius})

		return true
	end,
	info = function(self, t)
		return ([[ 你 随 机 吸 收 一 个 紧 靠 你 的 浮 肿 软 泥 怪， 获 得 40%% 对 全 部 伤 害 的 抗 性， 持 续 %d 个 回 合。 
		 同 时 你 会 释 放 一 股 反 魔 能 量， 在 %d 半 径 内 造 成 %0.2f 点 法 力 燃 烧 伤 害。 
		 如 果 有 丝 分 裂 技 能 开 启 ， 每 回 合 你 将 回 复 %0.1f 点 失 衡 值 。
		 受 精 神 强 度 影 响， 伤 害 、 持 续 时 间 和 失 衡 值 回 复 有 额 外 加 成。 ]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.ARCANE, t.getDam(self, t)),	3, t.equiRegen(self, t))
	end,
}

newTalent{
	name = "Call of the Ooze",
	type = {"wild-gift/ooze", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 5,
	cooldown = 20,
	tactical = { ATTACK = { PHYSICAL = 1, ACID = 2 } },
	getMax = function(self, t) local _, _, max = checkMaxSummon(self, true) return math.min(max, self:callTalent(self.T_MITOSIS, "getMax"), math.max(1, math.floor(self:combatTalentScale(t, 0.5, 2.5)))) end,
	getModHP = function(self, t) return self:combatTalentLimit(t, 1, 0.46, 0.7) end, --  Limit < 1
	getLife = function(self, t) return self:callTalent(self.T_MITOSIS, "getMaxHP")*t.getModHP(self, t) end,
	getWepDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.7, 1.8) end,
	on_pre_use = function(self, t)
		local _, nb = checkMaxSummon(self, true, nil, "bloated_ooze")
		return nb < t.getMax(self, t)
	end,
	action = function(self, t)
		local ot = self:getTalentFromId(self.T_MITOSIS)
		local _, cur_nb, max = checkMaxSummon(self, true, nil, "bloated_ooze")
		local life = t.getLife(self, t)
		for i = cur_nb + 1, t.getMax(self, t) do
			ot.spawn(self, ot, life)
		end

		local list = {}
		if game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.bloated_ooze then list[#list+1] = act end
			end
		else
			for _, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then list[#list+1] = act	end
			end
		end

		local tg = {type="ball", radius=self.sight}
		local grids = self:project(tg, self.x, self.y, function() end)
		local tgts = {}
		for x, ys in pairs(grids) do for y, _ in pairs(ys) do
			local target = game.level.map(x, y, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
		end end

		while #tgts > 0 and #list > 0 do
			local ooze = rng.tableRemove(list)
			local target = rng.tableRemove(tgts)

			local tx, ty = util.findFreeGrid(target.x, target.y, 10, true, {[Map.ACTOR]=true})
			if tx then
				local ox, oy = ooze.x, ooze.y
				ooze:move(tx, ty, true)
				if config.settings.tome.smooth_move > 0 then
					ooze:resetMoveAnim()
					ooze:setMoveAnim(ox, oy, 8, 5)
				end
				if core.fov.distance(tx, ty, target.x, target.y) <= 1 then
					target:setTarget(ooze)
					self:attackTarget(target, DamageType.ACID, t.getWepDamage(self, t), true)
				end
			end
		end

		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[立 刻 召 集 所 有 的 浮 肿 软 泥 怪 来 战 斗， 如 果 现 有 浮 肿 软 泥 怪 数 目 比 最 大 值 小， 最 多 可 以 制 造 %d 个 浮 肿 软 泥 怪， 每 一 个 的 生 命 值 不 能 超 过 有 丝 分 裂 技 能 允 许 的 生 命 最 大 值 的 %d%% 。 
		 每 一 个 浮 肿 软 泥 怪 将 被 传 送 到 其 视 野 内 的 敌 人 附 近，并 吸 引 其 注 意 力 。 
		 利 用 这 一 形 势， 你 将 对 浮 肿 软 泥 怪 面 对 的 敌 人 各 造 成 一 次 近 战 酸 性 伤 害， 数 值 为 武 器 伤 害 的 %d%% 。 ]]):
		format(t.getMax(self, t), t.getLife(self, t), t.getModHP(self, t)*100, t.getWepDamage(self, t) * 100)
	end,
}

newTalent{
	name = "Indiscernible Anatomy",
	type = {"wild-gift/ooze", 4},
	require = gifts_req4,
	points = 5,
	mode = "passive",
	--compare to lethality: self:combatTalentScale(t, 7.5, 25, 0.75)
	critResist = function(self, t) return self:combatTalentScale(t, 15, 50, 0.75) end,
	immunities = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.7) end, -- Limit < 100% immunities
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "blind_immune", t.immunities(self, t))
		self:talentTemporaryValue(p, "poison_immune", t.immunities(self, t))
		self:talentTemporaryValue(p, "disease_immune", t.immunities(self, t))
		self:talentTemporaryValue(p, "cut_immune", t.immunities(self, t))
		self:talentTemporaryValue(p, "ignore_direct_crits", t.critResist(self, t))
	end,
	info = function(self, t)
		return ([[ 你 身 体 里 的 内 脏 全 都 融 化 在 一 起， 隐 藏 了 你 的 要 害 部 位。 
		 所 有 直 接 对 你 的 暴 击 伤 害（ 物 理、 精 神、 法 术） 的 暴 击 加 成 减 少 %d%% （ 不 会 少 于 普 通 伤 害） 。 
		 你 将 额 外 获 得 %d%% 的 疾 病、 毒 素、 切 割 和 目 盲 免 疫。 ]]):
		format(t.critResist(self, t), 100*t.immunities(self, t))
	end,
}


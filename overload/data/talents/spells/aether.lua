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

local basetrap = function(self, t, x, y, dur, add)
	local Trap = require "mod.class.Trap"
	local trap = {
		id_by_type=true, unided_name = "trap",
		display = '^',
		faction = self.faction,
		summoner = self, summoner_gain_exp = true,
		temporary = dur,
		x = x, y = y,
		canAct = false,
		energy = {value=0},
		act = function(self)
			self:realact()
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
				game.level:removeEntity(self, true)
			end
		end,
	}
	table.merge(trap, add)
	return Trap.new(trap)
end

newTalent{
	name = "Aether Beam",
	type = {"spell/aether", 1},
	require = spells_req_high1,
	mana = 20,
	points = 5,
	cooldown = 12,
	use_only_arcane = 1,
	direct_hit = true,
	range = 6,
	requires_target = true,
	tactical = { ATTACKAREA = { ARCANE = 2 }, DISABLE = { silence = 1 } },
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 150) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if game.level.map(x, y, Map.TRAP) then game.logPlayer(self, "You somehow fail to set the aether beam.") return nil end
		if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then game.logPlayer(self, "You somehow fail to set the aether beam.") return nil end

		local t = basetrap(self, t, x, y, 44, {
			type = "aether", name = "aether beam", color=colors.VIOLET, image = "trap/aether_beam.png",
			dam = self:spellCrit(t.getDamage(self, t)),
			triggered = function(self, x, y, who) return true, true end,
			combatSpellpower = function(self) return self.summoner:combatSpellpower() end,
			rad = 3,
			energy = {value=0, mod=16},
			detect_power = self:combatSpellpower() / 2,
			disarm_power = self:combatSpellpower() / 2,
			on_added = function(self, level, x, y)
				self.x, self.y = x, y
				local tries = {}
				local list = {i=1}
				local sa = rng.range(0, 359)
				local dir = rng.percent(50) and 1 or -1
				for a = sa, sa + 359 * dir, dir do
					local rx, ry = math.floor(math.cos(math.rad(a)) * self.rad), math.floor(math.sin(math.rad(a)) * self.rad)
					if not tries[rx] or not tries[rx][ry] then
						tries[rx] = tries[rx] or {}
						tries[rx][ry] = true
						list[#list+1] = {x=rx+x, y=ry+y}
					end
				end
				self.list = list
				self.on_added = nil
			end,
			disarmed = function(self, x, y, who)
				game.level:removeEntity(self, true)
			end,
			realact = function(self)
				if game.level.map(self.x, self.y, engine.Map.TRAP) ~= self then game.level:removeEntity(self, true) return end

				local x, y = self.list[self.list.i].x, self.list[self.list.i].y
				self.list.i = util.boundWrap(self.list.i + 1, 1, #self.list)

				local tg = {type="beam", x=self.x, y=self.y, range=self.rad, selffire=self.summoner:spellFriendlyFire()}
				self.summoner.__project_source = self
				self.summoner:project(tg, x, y, engine.DamageType.ARCANE_SILENCE, {dam=self.dam, chance=25}, nil)
				self.summoner:project(tg, self.x, self.y, engine.DamageType.ARCANE, self.dam/10, nil)
				self.summoner.__project_source = nil
				local _ _, x, y = self:canProject(tg, x, y)
				game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "mana_beam", {tx=x-self.x, ty=y-self.y})
			end,
		})
		t:identify(true)

		t:resolve() t:resolve(nil, true)
		t:setKnown(self, true)
		game.level:addEntity(t)
		game.zone:addEntity(game.level, t, "trap", x, y)
		game.level.map:particleEmitter(x, y, 1, "summon")

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 凝 聚 以 太 能 量， 释 放 出 一 个 以 太 螺 旋， 对 周 围 目 标 造 成 %0.2f 奥 术 伤 害 并 且 有 25％ 几 率 沉 默 目 标。 
		 以 太 螺 旋 每 回 合 也 会 对 中 心 点 造 成 10％ 的 伤 害（ 但 是 不 会 沉 默 目 标）。 
		 螺 旋 会 以 难 以 置 信 的 速 度 旋 转。（ 1600％ 基 础 速 度） 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

newTalent{
	name = "Aether Breach",
	type = {"spell/aether", 2},
	require = spells_req_high2,
	points = 5,
	random_ego = "attack",
	mana = 50,
	cooldown = 8,
	use_only_arcane = 1,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = 7,
	radius = 2,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 3 then return true else return false end end,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
		return tg
	end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 3.3, 4.7)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 180) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)

		local list = {}
		self:project(tg, x, y, function(px, py) list[#list+1] = {x=px, y=py} end)

		self:setEffect(self.EFF_AETHER_BREACH, t.getNb(self, t), {src=self, x=x, y=y, radius=tg.radius, list=list, level=game.zone.short_name.."-"..game.level.level, dam=self:spellCrit(t.getDamage(self, t))})

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[撕 裂 位 面， 暂 时 产 生 通 往 以 太 空 间 的 裂 隙， 在 目 标 区 域 造 成 %d 个 随 机 魔 法 爆 炸。 
		 每 个 爆 炸 在 2 码 范 围 内 造 成 %0.2f 奥 术 伤 害， 并 且 每 回 合 只 能 触 发 一 次 爆 炸。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.ARCANE, damage))
	end,
}

newTalent{
	name = "Aether Avatar",
	type = {"spell/aether", 3},
	require = spells_req_high3,
	points = 5,
	mana = 60,
	cooldown = function(self, t)
		local rcd = math.ceil(self:combatTalentLimit(t, 15, 37, 25)) -- Limit > 15
		return self:attr("arcane_cooldown_divide") and rcd * self.arcane_cooldown_divide or rcd 
	end,
	range = 10,
	direct_hit = true,
	use_only_arcane = 1,
	requires_target = true,
	no_energy = true,
	tactical = { BUFF = 2 },
	getNb = function(self, t) return math.floor(self:combatTalentLimit(t, 15, 5, 9)) end, -- Limit duration < 15	
	action = function(self, t)
		self:setEffect(self.EFF_AETHER_AVATAR, t.getNb(self, t), {})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[你 的 身 体 与 以 太 能 量 相 融， 持 续 %d 回 合。 
		 当 此 技 能 激 活 时， 你 只 能 使 用 奥 术 系 或 以 太 系 技 能， 同 时， 2 系 技 能 的 冷 却 时 间 减 为 三 分 之 一  ， 你 的 奥 术 伤 害 增 加 25％， 并 且 你 可 以 随 时 开 启 干 扰 护 盾， 你 的 法 力 最 大 值 增 加 33％。]]):
		format(t.getNb(self, t))
	end,
}

newTalent{
	name = "Pure Aether",
	type = {"spell/aether",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	sustain_mana = 50,
	cooldown = 30,
	use_only_arcane = 1,
	tactical = { BUFF = 2 },
	getDamageIncrease = function(self, t) return self:getTalentLevelRaw(t) * 2 end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 17, 50, true) end, -- Limit < 100%	
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")

		local particle
		local ret = {
			dam = self:addTemporaryValue("inc_damage", {[DamageType.ARCANE] = t.getDamageIncrease(self, t)}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.ARCANE] = t.getResistPenalty(self, t)}),
		}
		if core.shader.active(4) then
			ret.particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, rotation=0, radius=2, img="arcanegeneric", a=0.7}, {type="sunaura", time_factor=5000}))
--			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", hide_center=0, time_factor=1700, zoom=0.3, npow=1, color1={0.6, 0.3, 0.8, 1}, color2={0.8, 0, 0.8, 1}, xy={self.x, self.y}}))
		else
			ret.particle = self:addParticles(Particles.new("ultrashield", 1, {rm=180, rM=220, gm=10, gM=50, bm=190, bM=220, am=120, aM=200, radius=0.4, density=100, life=8, instop=20}))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[纯 净 的 以 太 能 量 环 绕 着 你， 增 加 %d%% 奥 术 伤 害 并 且 无 视 目 标 %d%% 奥 术 抵 抗。 
		 在 等 级 5 时， 允 许 你 在 以 太 之 体 的 形 态 下 使 用 防 护 系 技 能。]])
		:format(damageinc, ressistpen)
	end,
}

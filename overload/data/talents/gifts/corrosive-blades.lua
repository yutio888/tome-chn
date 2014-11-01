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
	name = "Acidbeam",
	type = {"wild-gift/corrosive-blades", 1},
	require = gifts_req_high1,
	points = 5,
	equilibrium = 4,
	cooldown = 3,
	tactical = { ATTACKAREA = {ACID=2} },
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	range = 10,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 290) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.ACID_DISARM, dam)
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "ooze_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在 你 的 心 灵 利 刃 里 充 填 酸 性 能 量， 延 展 攻 击 范 围, 形 成 一 道 射 线， 造 成 %0.1f 点 酸 性 缴 械 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ACID, dam))
	end,
}

newTalent{
	name = "Corrosive Nature",
	type = {"wild-gift/corrosive-blades", 2},
	require = gifts_req_high2,
	points = 5,
	mode = "passive",
	getResist = function(self, t) return self:combatTalentMindDamage(t, 10, 40) end,
	-- called in data.timed_effects.physical.lua for the CORROSIVE_NATURE effect
	getAcidDamage = function(self, t, level)
		return self:combatTalentScale(t, 5, 15, 0.75)*math.min(5, level or 1)^0.5/2.23
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 5, "log")) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists", {[DamageType.ACID]=t.getResist(self, t)})
	end,
	info = function(self, t)
		return ([[ 你 的 酸 性 抗 性 增 加 %d%%。
		 当 你 造 成 自 然 伤 害 时 ， 你 的 酸 性 伤 害 增 加 %0.1f%%， 持 续 %d 回 合。
		 伤 害 加 成 能 够 积 累 到 最 多 4 倍 （ 1 回 合 至 多 触 发 1 次 ） ， 最 大 值 %0.1f%%。
		 受 精 神 强 度 影 响 ， 抗 性 和 伤 害 加 成 有 额 外 加 成 。]]):
		format(t.getResist(self, t), t.getAcidDamage(self, t, 1), t.getDuration(self, t), t.getAcidDamage(self, t, 5))
	end,
}

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
		inc_damage = table.clone(self.inc_damage or {}, true),
		act = function(self)
			self:useEnergy()
			self.temporary = self.temporary - 1
			if self.temporary <= 0 then
				if game.level.map(self.x, self.y, engine.Map.TRAP) == self then	game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
				game.level:removeEntity(self)
			end
		end,
	}
	table.merge(trap, add)
	return Trap.new(trap)
end

newTalent{
	name = "Corrosive Seeds",
	type = {"wild-gift/corrosive-blades", 3},
	require = gifts_req_high3,
	points = 5,
	cooldown = 12,
	range = 8,
	equilibrium = 10,
	radius = function() return 2 end,
	direct_hit = true,
	requires_target = true,
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	tactical = { ATTACKAREA = { ACID = 2 }, DISABLE = { knockback = 1 } },
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t} end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 290) end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 12, 5, 8)) end, -- Limit < 12
	getNb = function(self, t) local l = self:getTalentLevel(t) 
		if l < 3 then return 2
		elseif l < 5 then return 3
		else return 4
		end
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		if game.level.map(x, y, Map.TRAP) then game.logPlayer(self, "You somehow fail to set the corrosive seed.") return nil end

		local tg = {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t)}
		local grids = {}
		self:project(tg, x, y, function(px, py) 
			if not ((px == x and py == y) or game.level.map:checkEntity(px, py, Map.TERRAIN, "block_move") or game.level.map(px, py, Map.TRAP)) then grids[#grids+1] = {x=px, y=py} end
		end)
		for i = 1, t.getNb(self, t) do
			local spot = i == 1 and {x=x, y=y} or rng.tableRemove(grids)
			if not spot then break end
			local t = basetrap(self, t, spot.x, spot.y, t.getDuration(self, t), {
				type = "seed", name = "corrosive seed", color=colors.VIOLET, image = "trap/corrosive_seeds.png",
				disarm_power = self:combatMindpower(),
				dam = self:mindCrit(t.getDamage(self, t)),
				triggered = function(self, x, y, who) return true, true end,
				combatMindpower = function(self) return self.summoner:combatMindpower() end,
				disarmed = function(self, x, y, who)
					game.level:removeEntity(self, true)
				end,
				knockx = self.x, knocky = self.y,
				triggered = function(self, x, y, who)
					self:project({type="ball", selffire=false, friendlyfire=false, x=x,y=y, radius=1}, x, y, engine.DamageType.WAVE, {x=self.knockx, y=self.knocky, st=engine.DamageType.ACID, dam=self.dam, dist=3, power=self:combatMindpower()})
					game.level.map:particleEmitter(x, y, 2, "acidflash", {radius=1, tx=x, ty=y})
					return true, true
				end,
			})
			t:identify(true)
			t:resolve() t:resolve(nil, true)
			t:setKnown(self, true)
			game.level:addEntity(t)
			game.zone:addEntity(game.level, t, "trap", spot.x, spot.y)
			game.level.map:particleEmitter(spot.x, spot.y, 1, "summon")
		end

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		return ([[ 你 集 中 精 神 于 某 块 半 径 2 的 区 域， 制 造 出 %d 个 腐 蚀 之 种。 
		 第 一 个 种 子 会 产 生 于 中 心 处 ， 其 他 的 会 随 机 出 现。
		 当 一 个 生 物 走 过 腐 蚀 之 种 时， 会 在 半 径 1 的 区 域 内 引 发 一 场 爆 炸， 击 退 对 方 并 造 成 %0.1f 点 酸 性 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成]]):
		format(nb, t.getDuration(self, t), damDesc(self, DamageType.ACID, dam))
	end,
}

newTalent{
	name = "Acidic Soil",
	type = {"wild-gift/corrosive-blades", 4},
	require = gifts_req_high4,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 15,
	cooldown = 30,
	tactical = { BUFF = 2 },
	on_pre_use = function(self, t)
		local main, off = self:hasPsiblades(true, true)
		return main and off
	end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 15, 50) end, -- Limit < 100%
	getRegen = function(self, t) return self:combatTalentMindDamage(t, 10, 75) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local particle
		if core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=5, npow=2, time_factor=9000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
		else
			particle = self:addParticles(Particles.new("master_summoner", 1))
		end
		return {
			resist = self:addTemporaryValue("resists_pen", {[DamageType.ACID] = t.getResistPenalty(self, t)}),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local regen = t.getRegen(self, t)
		return ([[ 你 的 周 围 充 满 了 自 然 力 量， 忽 略 目 标 %d%% 的 酸 性 伤 害 抵 抗。 
		 同 时 酸 性 能 量 会 治 疗 你 的 浮 肿 软 泥 怪， 增 加 他 们 每 回 合 %0.1f 的 生 命 回 复。]])
		:format(ressistpen, regen)
	end,
}

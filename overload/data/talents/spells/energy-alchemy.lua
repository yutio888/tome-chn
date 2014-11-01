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

newTalent{
	name = "Lightning Infusion",
	type = {"spell/energy-alchemy", 1},
	mode = "sustained",
	require = spells_req_high1,
	sustain_mana = 30,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
	activate = function(self, t)
		cancelAlchemyInfusions(self)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.LIGHTNING] = t.getIncrease(self, t)})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[ 将 闪 电 能 量 填 充 至 炼 金 炸 弹 ， 能 眩 晕 敌 人 。
		 你 造 成 的 闪 电 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

newTalent{
	name = "Dynamic Recharge",
	type = {"spell/energy-alchemy", 2},
	require = spells_req_high2,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 20, 75)) end,
	getNb = function(self, t) return self:getTalentLevel(t) <= 6 and 1 or 2 end,
	applyEffect = function(self, t, golem)
		local tids = table.keys(golem.talents_cd)
		local did_something = false
		local nb = t.getNb(self, t)
		for _, tid in ipairs(tids) do
			if golem.talents_cd[tid] > 0 and rng.percent(t.getChance(self, t)) then
				golem.talents_cd[tid] = golem.talents_cd[tid] - nb
				if golem.talents_cd[tid] <= 0 then golem.talents_cd[tid] = nil end
				did_something = true
			end
		end
		if did_something then
			game.logSeen(golem, "%s is energized by the attack, reducing some talent cooldowns!", golem.name:capitalize())
		end
	end,
	info = function(self, t)
		return ([[ 当 闪 电 充 能 开 启 时 ， 你 的 炸 弹 会 给 傀 儡 充 能 。
		 你 的 傀 儡  的 所 有 冷 却 中 技 能 有 %d%% 概 率 减 少 %d 回 合 冷 却 时 间。]]):
		format(t.getChance(self, t), t.getNb(self, t))
	end,
}

newTalent{
	name = "Thunderclap",
	type = {"spell/energy-alchemy",3},
	require = spells_req_high3,
	points = 5,
	mana = 40,
	cooldown = 12,
	requires_target = true,
	tactical = { DISABLE = { disarm = 1 }, ATTACKAREA={PHYSICAL=1, LIGHTNING=1} },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 8)) end,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.03) * self:getTalentLevel(t), 2, 0, 7, 8)) end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 250) / 2 end,
	action = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		if not ammo then
			game.logPlayer(self, "You need to ready alchemist gems in your quiver.")
			return
		end

		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		ammo = self:removeObject(self:getInven("QUIVER"), 1)
		if not ammo then return end

		local dam = self:spellCrit(t.getDamage(self, t))
		local affected = {}
		self:project(tg, x, y, function(px, py)
			local actor = game.level.map(px, py, Map.ACTOR)
			if not actor or affected[actor] then return end
			affected[actor] = true

			DamageType:get(DamageType.PHYSICAL).projector(self, px, py, DamageType.PHYSICAL, dam)
			DamageType:get(DamageType.LIGHTNING).projector(self, px, py, DamageType.LIGHTNING, dam)
			if actor:canBe("disarm") then
 				actor:setEffect(actor.EFF_DISARMED, t.getDuration(self, t), {src=self, apply_power=self:combatSpellpower()})
 			end
 			if actor:canBe("knockback") then
  				actor:knockback(self.x, self.y, 3)
  				actor:crossTierEffect(actor.EFF_OFFBALANCE, self:combatSpellpower())
  			end
		end, dam)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "gravity_breath", {radius=tg.radius, tx=x-self.x, ty=y-self.y, allow=core.shader.allow("distort")})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 粉 碎 一 颗 炼 金 宝 石 ， 制 造 一 次 闪 电 霹 雳 ， 在 半 径 %d 的 锥 形 区 域 内 造 成 %0.2f 点 物 理 伤 害 和 %0.2f 点 闪 电 伤 害。
		 范 围 内 的 生 物 将 会 被 击 退 并 被 缴 械 %d 回 合 。
		 受 法 术 强 度 影 响 ， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Living Lightning",
	type = {"spell/energy-alchemy",4},
	require = spells_req_high4,
	mode = "sustained",
	cooldown = 40,
	sustain_mana = 100,
	points = 5,
	range = function(self, t) return math.ceil(self:combatTalentLimit(t, 6, 1, 3)) end,
	tactical = { BUFF=1 },
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.05, 0.15, 0.90) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 70) end,
	getTurn = function(self, t) return util.bound(50 + self:combatTalentSpellDamage(t, 5, 500) / 10, 50, 160) end,
	callbackOnActBase = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 6, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, selffire=self:spellFriendlyFire()}
		for i = 1, 1 do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.LIGHTNING, self:spellCrit(t.getDamage(self, t)))
			if core.shader.active() then game.level.map:particleEmitter(a.x, a.y, tg.radius, "ball_lightning_beam", {radius=1, tx=x, ty=y}, {type="lightning"})
			else game.level.map:particleEmitter(a.x, a.y, tg.radius, "ball_lightning_beam", {radius=1, tx=x, ty=y}) end
			game:playSoundNear(self, "talents/lightning")
		end
	end,
	callbackOnAct = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		if not p.last_life then p.last_life = self.life end
		local min = self.max_life * 0.2
		if self.life <= p.last_life - min then
			game.logSeen(self, "#LIGHT_STEEL_BLUE#%s is energized by all the damage taken!", self.name:capitalize())
			self.energy.value = self.energy.value + (t.getTurn(self, t) * game.energy_to_act / 100)
		end
		p.last_life = self.life
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/lightning")
		local ret = {name = self.name:capitalize().."'s "..t.name}
		self:talentTemporaryValue(ret, "movement_speed", t.getSpeed(self, t))
		ret.last_life = self.life

		if core.shader.active(4) then
			ret.particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {z=5, rotation=0, radius=1.4, img="alchie_lightning"}, {type="lightningshield", time_factor = 4000, ellipsoidalFactor = {1.7, 1.4}}))
		end

		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dam = t.getDamage(self, t)
		local turn = t.getTurn(self, t)
		local range = self:getTalentRange(t)
		return ([[ 将 闪 电 能 量 填 充 到 身 体 中 ， 增 加 %d%% 移 动 速 度 。
		 每 回 合 半 径 %d 内 的 一 个 生 物 将 会 被 闪 电 击 中 ， 造 成 %0.2f 点 闪 电 伤 害 。
		 每 次 你 的 回 合 开 始 时 ， 如 果 自 从 上 个 回 合 结 束 你 受 到 超 过 20%% 最 大 生 命 值 的 伤 害， 你 将 获 得 %d%% 个 额 外 回 合 。
		 受 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成 。]]):
		format(speed, range, damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), turn)
	end,
}

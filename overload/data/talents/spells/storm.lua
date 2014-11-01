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
	name = "Nova",
	type = {"spell/storm",1},
	require = spells_req_high1,
	points = 5,
	mana = 12,
	cooldown = 8,
	tactical = { ATTACKAREA = { LIGHTNING = 2 }, DISABLE = { stun = 1 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.7, 5.5)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 170) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, self.x, self.y, DamageType.LIGHTNING_DAZE, {daze=75, dam=rng.avg(dam / 3, dam, 3)})

		if core.shader.active(4) then
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "shader_ring", {radius=tg.radius*2, life=8}, {type="sparks"})
		else
			local x, y = self.x, self.y
			-- Lightning ball gets a special treatment to make it look neat
			local sradius = (tg.radius + 0.5) * (engine.Map.tile_w + engine.Map.tile_h) / 2
			local nb_forks = 16
			local angle_diff = 360 / nb_forks
			for i = 0, nb_forks - 1 do
				local a = math.rad(rng.range(0+i*angle_diff,angle_diff+i*angle_diff))
				local tx = x + math.floor(math.cos(a) * tg.radius)
				local ty = y + math.floor(math.sin(a) * tg.radius)
				game.level.map:particleEmitter(x, y, tg.radius, "lightning", {radius=tg.radius, grids=grids, tx=tx-x, ty=ty-y, nb_particles=25, life=8})
			end
		end

		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local dam = damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t))
		local radius = self:getTalentRadius(t)
		return ([[一 圈 闪 电 从 你 身 上 放 射 出 来， 在 %d 码 范 围 内 对 目 标 造 成 %0.2f ～ %0.2f 闪 电 伤 害 并 有 75%% 概 率 眩 晕 敌 人。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, dam / 3, dam)
	end,
}

newTalent{
	name = "Shock",
	type = {"spell/storm",2},
	require = spells_req_high2,
	points = 5,
	mana = 8,
	cooldown = 4,
	tactical = { ATTACK = { LIGHTNING = 2 }, DISABLE = { stun = 1 } },
	range = 10,
	requires_target = true,
	reflectable = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 200) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_lightning", trail="lightningtrail"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = t.getDamage(self, t)
		self:projectile(tg, x, y, DamageType.LIGHTNING_DAZE, {shock=5, daze=100, dam=self:spellCrit(rng.avg(dam / 3, dam, 3))}, {type="lightning_explosion"})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 个 闪 电 球 对 目 标 造 成 %0.2f ～ %0.2f 闪 电 伤 害 并 眩 晕 目 标 3 回 合。 
		 如 果 目 标 免 疫 了 眩 晕 ， 则 5 回 合 内 震 慑 和 定 身 抗 性 减 半。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage/3), damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

newTalent{
	name = "Hurricane",
	type = {"spell/storm",3},
	require = spells_req_high3,
	points = 5,
	mode = "sustained",
	sustain_mana = 100,
	cooldown = 30,
	tactical = { DISABLE = 2, BUFF = 2 },
	range = 10,
	direct_hit = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 150) end,
	getChance = function(self, t) return 30 + self:getTalentLevel(t) * 5 end,
	getRadius = function(self, t)
			local radius = 2
			if self:getTalentLevel(t) >= 3 then radius = 3 end
			return radius
		end,
	do_hurricane = function(self, t, target)
		if not rng.percent(t.getChance(self, t)) then return end

		target:setEffect(target.EFF_HURRICANE, 10, {src=self, dam=t.getDamage(self, t), radius=t.getRadius(self, t) })
		game:playSoundNear(self, "talents/thunderstorm")
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local chance = t.getChance(self, t)
		local radius = t.getRadius(self, t)
		return ([[每 次 你 的 闪 电 法 术 眩 晕 目 标 时， 它 会 有 %d%% 的 概 率 发 生 连 锁 反 应， 生 成 一 个 围 绕 目 标 %d 码 半 径 范 围 的 飓 风， 持 续 10 回 合。 
		 每 回 合 该 单 位 附 近 的 所 有 生 物 会 承 受 %0.2f ～ %0.2f 闪 电 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(chance, radius, damage / 3, damage)
	end,
}

newTalent{
	name = "Tempest",
	type = {"spell/storm",4},
	require = spells_req_high4,
	points = 5,
	mode = "sustained",
	tactical = { BUFF = 2 },
	sustain_mana = 50,
	cooldown = 30,
	getLightningDamageIncrease = function(self, t) return self:getTalentLevelRaw(t) * 2 end,
	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 100, 17, 50) end,
	getDaze = function(self, t) return self:getTalentLevel(t) * 9 end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/thunderstorm")
		local particle
		if core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="lightningshield"}, {type="lightningshield"}))
		else
			particle = self:addParticles(Particles.new("tempest", 1))
		end
		return {
			dam = self:addTemporaryValue("inc_damage", {[DamageType.LIGHTNING] = t.getLightningDamageIncrease(self, t)}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.LIGHTNING] = t.getResistPenalty(self, t)}),
			daze = self:addTemporaryValue("lightning_daze_tempest", t.getDaze(self, t)),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		self:removeTemporaryValue("lightning_daze_tempest", p.daze)
		return true
	end,
	info = function(self, t)
		local damageinc = t.getLightningDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local daze = t.getDaze(self, t)
		return ([[在 你 周 围 生 成 一 股 风 暴， 增 加 你 %d%% 闪 电 伤 害 并 无 视 目 标 %d%% 闪 电 抵 抗。 
		 你 的 闪 电 术 和 连 锁 闪 电 同 时 会 增 加 %d%% 眩 晕 几 率， 并 且 闪 电 风 暴 也 会 增 加 %d%% 眩 晕 几 率。]])
		:format(damageinc, ressistpen, daze, daze / 2)
	end,
}

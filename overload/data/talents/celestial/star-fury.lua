-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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
	name = "Moonlight Ray",
	type = {"celestial/star-fury", 1},
	require = divi_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 3,
	negative = 10,
	tactical = { ATTACK = {DARKNESS = 2} },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 14, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "shadow_beam", {tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 月 光 的 力 量 形 成 阴 影 射 线， 对 目 标 造 成 %0.2f 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Shadow Blast",
	type = {"celestial/star-fury", 2},
	require = divi_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	negative = 15,
	tactical = { ATTACKAREA = {DARKNESS = 2} },
	range = 5,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=self:spellFriendlyFire()}
	end,
	getDamageOnSpot = function(self, t) return self:combatTalentSpellDamage(t, 4, 40) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 110) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.8, 6)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		local grids = self:project(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)), {type="shadow"})
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.DARKNESS, t.getDamageOnSpot(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="shadow_zone", overlay_particle={zdepth=6, only_one=true, type="circle", args={oversize=0.7, a=60, appear=8, speed=-0.5, img="moon_circle", radius=self:getTalentRadius(t)}}},
			nil, self:spellFriendlyFire()
		)

		game.level.map:particleEmitter(x, y, tg.radius, "shadow_flash", {radius=tg.radius, grids=grids, tx=x, ty=y})

		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		local duration = t.getDuration(self, t)
		return ([[引 起 一 片 暗 影 爆 炸， 对 目 标 造 成 %0.2f 点 暗 影 伤 害， 并 在 3 码 半 径 范 围 的 区 域 内 每 回 合 造 成 %0.2f 暗 影 伤 害， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage),damDesc(self, DamageType.DARKNESS, damageonspot),duration)
	end,
}

newTalent{
	name = "Twilight Surge",
	type = {"celestial/star-fury",3},
	require = divi_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 7,
	negative = -20,
	positive = -10,
	tactical = { ATTACKAREA = {LIGHT = 1, DARKNESS = 1} },
	range = 0,
	radius = 2,
	direct_hit = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, selffire=false}
	end,
	getLightDamage = function(self, t) return 10 + self:combatSpellpower(0.2) * self:combatTalentScale(t, 1, 5) end,
	getDarknessDamage = function(self, t) return 10 + self:combatSpellpower(0.2) * self:combatTalentScale(t, 1, 5) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, DamageType.LIGHT, self:spellCrit(t.getLightDamage(self, t)))
		self:project(tg, self.x, self.y, DamageType.DARKNESS, self:spellCrit(t.getDarknessDamage(self, t)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "shadow_flash", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y})

		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local lightdam = t.getLightDamage(self, t)
		local darknessdam = t.getDarknessDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[一 股 汹 涌 的 光 暗 狂 潮 围 绕 着 你， 在 你 周 围 %d 码 半 径 内 造 成 %0.2f 光 系 和 %0.2f 暗 影 范 围 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.LIGHT, lightdam), damDesc(self, DamageType.DARKNESS, darknessdam))
	end,
}

newTalent{
	name = "Starfall",
	type = {"celestial/star-fury", 4},
	require = divi_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	negative = 20,
	tactical = { ATTACKAREA = {DARKNESS = 2}, DISABLE = 2 },
	range = 6,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=self:spellFriendlyFire(), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 170) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = self:project(tg, x, y, DamageType.DARKSTUN, self:spellCrit(t.getDamage(self, t)))

		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if core.shader.active() then
			game.level.map:particleEmitter(x, y, tg.radius, "starfall", {radius=tg.radius, tx=x, ty=y})
		else
			game.level.map:particleEmitter(x, y, tg.radius, "shadow_flash", {radius=tg.radius, grids=grids, tx=x, ty=y})
			game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, a=60, limit_life=16, appear=8, speed=-0.5, img="darkness_celestial_circle", radius=self:getTalentRadius(t)})
		end
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[你 摇 落 星 辰， 震 慑 %d 码 半 径 范 围 内 所 有 目 标 4 回 合， 并 造 成 %0.2f 暗 影 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

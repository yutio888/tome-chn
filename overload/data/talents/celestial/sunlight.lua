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
	name = "Searing Light",
	type = {"celestial/sunlight", 1},
	require = divi_req1,
	random_ego = "attack",
	points = 5,
	cooldown = 6,
	positive = -16,
	range = 7,
	tactical = { ATTACK = {LIGHT = 2} },
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 6, 160) end,
	getDamageOnSpot = function(self, t) return self:combatTalentSpellDamage(t, 6, 80) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)), {type="light"})

		local _ _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, 4,
			DamageType.LIGHT, t.getDamageOnSpot(self, t),
			0,
			5, nil,
			{type="light_zone"},
			nil, self:spellFriendlyFire()
		)

		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageonspot = t.getDamageOnSpot(self, t)
		return ([[你 祈 祷 太 阳 之 力 形 成 1 个 灼 热 的 长 矛 造 成 %0.2f 点 伤 害 并 在 地 上 留 下 一 个 光 斑， 每 回 合 对 其 中 的 目 标 造 成 %0.2f 光 系 伤 害， 持 续 4 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), damageonspot)
	end,
}

newTalent{
	name = "Sun Flare",
	type = {"celestial/sunlight", 2},
	require = divi_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 22,
	positive = -15,
	tactical = { ATTACKAREA = {LIGHT = 1}, DISABLE = 2 },
	direct_hit = true,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 80) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		-- Temporarily turn on "friendlyfire" to lite all tiles
		tg.selffire = true
		tg.radius = tg.radius * 2
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		tg.radius = tg.radius / 2
		tg.selffire = false
		local grids = self:project(tg, self.x, self.y, DamageType.BLIND, t.getDuration(self, t))
		if self:getTalentLevel(t) >= 3 then
			self:project(tg, self.x, self.y, DamageType.LIGHT, t.getDamage(self, t))
		end
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y, max_alpha=80})
		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[祈 祷 太 阳 之 力， 在 %d 码 半 径 范 围 内 致 盲 目 标， 持 续 %d 回 合 并 照 亮 你 的 周 围 区 域（ 有 效 范 围 %d 码）。 
		 等 级 3 时 它 会 同 时 造 成 %0.2f 光 系 伤 害（ %d 码 有 效 范 围）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, duration, radius * 2, damDesc(self, DamageType.LIGHT, damage), radius)
   end,
}

newTalent{
	name = "Firebeam",
	type = {"celestial/sunlight",3},
	require = divi_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 7,
	positive = -20,
	tactical = { ATTACK = {FIRE = 2}  },
	range = 7,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 200) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIRE, self:spellCrit(t.getDamage(self, t)))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "light_beam", {tx=x-self.x, ty=y-self.y})

		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[汲 取 太 阳 之 力 向 目 标 射 出 一 束 太 阳 真 火， 对 一 条 直 线 的 敌 人 造 成 %0.2f 火 焰 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

newTalent{
	name = "Sunburst",
	type = {"celestial/sunlight", 4},
	require = divi_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	positive = -20,
	tactical = { ATTACKAREA = {LIGHT = 2} },
	range = 0,
	radius = 3,
	direct_hit = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 160) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)))

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y})

		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 片 耀 眼 的 日 光， 对 你 周 围 的 敌 人 造 成 %0.2f 光 系 伤 害（ 有 效 半 径 %d 码）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.LIGHT, damage), radius)
	end,
}

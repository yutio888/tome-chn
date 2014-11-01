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

local isFF = function(self)
	if self:getTalentLevel(self.T_INVOKE_DARKNESS) >= 5 then return false
	else return true
	end
end

newTalent{
	name = "Invoke Darkness",
	type = {"spell/nightfall",1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 12,
	cooldown = 4,
	tactical = { ATTACK = { DARKNESS = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 3 then return true else return false end end,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), friendlyfire=isFF(self), talent=t, display={particle="bolt_dark", trail="darktrail"}}
		if self:getTalentLevel(t) >= 3 then tg.type = "beam" end
		if necroEssenceDead(self, true) then tg.radius, tg.range = tg.range, 0 tg.type = "cone" tg.cone_angle = 25 end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local empower = necroEssenceDead(self)
		if empower then
			self:project(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_shadow", {radius=tg.radius, tx=x-self.x, ty=y-self.y, spread=20})
			empower()
		elseif self:getTalentLevel(t) < 3 then
			self:projectile(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)), function(self, tg, x, y, grids)
				game.level.map:particleEmitter(x, y, 1, "dark")
			end)
		else
			self:project(tg, x, y, DamageType.DARKNESS, self:spellCrit(t.getDamage(self, t)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "shadow_beam", {tx=x-self.x, ty=y-self.y})
		end

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 出 一 片 黑 暗， 对 目 标 造 成 %0.2f 暗 影 伤 害。 
		 在 等 级 3 时， 它 会 生 成 暗 影 射 线。 
		 在 等 级 5 时， 你 的 黑 夜 降 临 系 法 术 不 会 再 伤 害 亡 灵 随 从。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Circle of Death",
	type = {"spell/nightfall",2},
	require = spells_req2,
	points = 5,
	mana = 45,
	cooldown = 18,
	tactical = { ATTACKAREA = { DARKNESS = 2 }, DISABLE = { confusion = 1.5, blind = 1.5 } },
	range = 6,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 40) end,
	getDuration = function(self, t) return 5 end,
	getBaneDur = function(self,t) return math.floor(self:combatTalentScale(t, 4.5, 6.5)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.CIRCLE_DEATH, {dam=self:spellCrit(t.getDamage(self, t)), dur=t.getBaneDur(self,t), ff=isFF(self)},
			self:getTalentRadius(t),
			5, nil,
			{type="circle_of_death", overlay_particle={zdepth=6, only_one=true, type="circle", args={oversize=1, a=100, appear=8, speed=-0.05, img="necromantic_circle", radius=self:getTalentRadius(t)}}},
--			{zdepth=6, only_one=true, type="circle", args={oversize=1, a=130, appear=8, speed=-0.03, img="arcane_circle", radius=self:getTalentRadius(t)}},
			nil, false
		)

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从 地 上 召 唤 出 持 续 5 回 合 的 黑 暗 之 雾。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。 
		 任 何 生 物 走 进 去 都 会 吸 入 混 乱 毒 素 或 致 盲 毒 素。 
		 对 1 个 生 物 每 次 只 能 产 生 1 种 毒 素 效 果。 
		 毒 素 效 果 持 续 %d 回 合 并 造 成 %0.2f 暗 影 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getBaneDur(self,t), damDesc(self, DamageType.DARKNESS, damage))
	end,
}

newTalent{
	name = "Fear the Night",
	type = {"spell/nightfall",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 40,
	cooldown = 12,
	direct_hit = true,
	tactical = { ATTACKAREA = { DARKNESS = 2 }, DISABLE = { knockback = 2 }, ESCAPE = { knockback = 1 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	target = function(self, t) return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=isFF(self), talent=t} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DARKKNOCKBACK, {dist=4, dam=self:spellCrit(t.getDamage(self, t))})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_dark", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 前 方 锥 形 范 围 内 造 成 %0.2f 暗 影 伤 害（ %d 码 半 径 范 围）。 
		 任 何 受 影 响 的 怪 物 须 进 行 一 次 精 神 豁 免 鉴 定， 否 则 会 被 击 退 4 码 以 外。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Rigor Mortis",
	type = {"spell/nightfall",4},
	require = spells_req4,
	points = 5,
	mana = 60,
	cooldown = 20,
	tactical = { ATTACKAREA = 3 },
	range = 7,
	radius = 1,
	direct_hit = true,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=isFF(self), talent=t, display={particle="bolt_dark", trail="darktrail"}} end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 280) end,
	getMinion = function(self, t) return 10 + self:combatTalentSpellDamage(t, 10, 30) end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3.6, 6.3)) end,
	getSpeed = function(self, t) return math.min(self:getTalentLevel(t) * 0.065, 0.5) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.RIGOR_MORTIS, {dam=self:spellCrit(t.getDamage(self, t)), minion=t.getMinion(self, t), speed=t.getSpeed(self, t), dur=t.getDur(self, t)}, {type="dark"})
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dur = t.getDur(self, t)
		local minion = t.getMinion(self, t)
		return ([[发 射 1 个 黑 暗 之 球 在 范 围 内 造 成 %0.2f 暗 影 系 伤 害（ %d 码 半 径）。 
		 被 击 中 的 目 标 将 会 感 染 尸 僵 症 并 减 少 整 体 速 度： %d%% 。 
		 亡 灵 随 从 对 这 些 目 标 额 外 造 成 伤 害： %d%% 。 
		 此 效 果 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 你 的 伤 害 和 亡 灵 随 从 的 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t), speed, minion, dur)
	end,
}

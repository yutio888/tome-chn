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
	name = "Flame",
	type = {"spell/fire",1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 12,
	cooldown = 3,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 10,
	reflectable = true,
	proj_speed = 20,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_fire", trail="firetrail"}}
		if self:getTalentLevel(t) >= 5 then tg.type = "beam" end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 25, 290) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local grids = nil
		if self:getTalentLevel(t) < 5 then
			self:projectile(tg, x, y, DamageType.FIREBURN, self:spellCrit(t.getDamage(self, t)), function(self, tg, x, y, grids)
				game.level.map:particleEmitter(x, y, 1, "flame")
				if self:attr("burning_wake") then
					game.level.map:addEffect(self, x, y, 4, engine.DamageType.INFERNO, self:attr("burning_wake"), 0, 5, nil, {type="inferno"}, nil, self:spellFriendlyFire())
				end
			end)
		else
			grids = self:project(tg, x, y, DamageType.FIREBURN, self:spellCrit(t.getDamage(self, t)))
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
		end

		if self:attr("burning_wake") and grids then
			for px, ys in pairs(grids) do
				for py, _ in pairs(ys) do
					game.level.map:addEffect(self, px, py, 4, engine.DamageType.INFERNO, self:attr("burning_wake"), 0, 5, nil, {type="inferno"}, nil, self:spellFriendlyFire())
				end
			end
		end

		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 一 个 火 球， 使 目 标 进 入 灼 烧 状 态 并 在 3 回 合 内 造 成 %0.2f 火 焰 伤 害。 
		 在 等 级 5 时， 火 焰 会 有 穿 透 效 果。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

newTalent{
	name = "Flameshock",
	type = {"spell/fire",2},
	require = spells_req2,
	points = 5,
	random_ego = "attack",
	mana = 30,
	cooldown = 18,
	tactical = { ATTACK = { FIRE = 1 }, DISABLE = { stun = 3 }, CURE = function(self, t, target)
		if self:attr("burning_wake") and self:attr("cleansing_flame") then
			return 1
		end
	end },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8, 0.5, 0, 0, true)) end,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 250) end,
	getStunDuration = function(self, t) return self:combatTalentScale(t, 3, 7, 0.5, 0, 0, true) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FLAMESHOCK, {dur=t.getStunDuration(self, t), dam=self:spellCrit(t.getDamage(self, t))})

		if self:attr("burning_wake") then
			game.level.map:addEffect(self,
				self.x, self.y, 4,
				DamageType.INFERNO, self:attr("burning_wake"),
				tg.radius,
				{delta_x=x-self.x, delta_y=y-self.y}, 55,
				{type="inferno"},
				nil, self:spellFriendlyFire()
			)
		end
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_fire", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local stunduration = t.getStunDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 前 方 制 造 一 片 %d 码 半 径 锥 形 范 围 的 火 焰。 
		 任 何 在 此 范 围 的 目 标 会 被 燃 烧 的 火 焰 震 慑 ， 共 受 到 %0.2f 点 火 焰 伤 害，持 续 %d 回 合。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage), stunduration)
	end,
}

newTalent{
	name = "Fireflash",
	type = {"spell/fire",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 40,
	cooldown = 8,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	range = 7,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, 0.5, 0, 0, true)) end,
	proj_speed = 4,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=self:spellFriendlyFire(), talent=t, display={particle="bolt_fire", particle_args={size_factor=1.5}, trail="firetrail"}, sound_stop="talents/fireflash"}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 280) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.FIRE, self:spellCrit(t.getDamage(self, t)), function(self, tg, x, y, grids)
			game.level.map:particleEmitter(x, y, tg.radius, "fireflash", {radius=tg.radius, proj_x=x, proj_y=y, src_x=self.x, src_y=self.y})
			if self:attr("burning_wake") then
				game.level.map:addEffect(self,
					x, y, 4,
					engine.DamageType.INFERNO, self:attr("burning_wake"),
					tg.radius,
					5, nil,
					{type="inferno"},
					nil, tg.selffire
				)
			end
		end)
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向 你 的 目 标 发 射 一 枚 爆 裂 火 球， 造 成 %0.2f 火 焰 伤 害， 有 效 范 围 %d 码。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius)
	end,
}

newTalent{
	name = "Inferno",
	type = {"spell/fire",4},
	require = spells_req4,
	points = 5,
	random_ego = "attack",
	mana = 100,
	cooldown = 30,
	tactical = { ATTACKAREA = { FIRE = 3 } },
	range = 10,
	radius = 5,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 15, 80) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.INFERNO, t.getDamage(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="inferno"},
			nil, self:spellFriendlyFire()
		)

		game:playSoundNear(self, "talents/devouringflame")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向 地 上 释 放 一 片 火 焰， 每 回 合 可 对 敌 我 双 方 造 成 %0.2f 火 焰 伤 害， 半 径 %d 码， 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius, duration)
	end,
}


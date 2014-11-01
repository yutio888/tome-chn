-- ToME - Tales of Middle-Earth
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

local function combatTalentDamage(self, t, min, max)
	return self:combatTalentSpellDamage(t, min, max, (self.level + self:getMag()) * 1.2)
end

local function combatPower(self, t, multiplier)
	return (self.level + self:getMag()) * (multiplier or 1)
end

newTalent{
	name = "Arcane Bolts",
	type = {"cursed/primal-magic", 1},
	require = cursed_mag_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	hate =  8,
	range = 6,
	proj_speed = 4,
	tactical = { ATTACK = { ARCANE = 2 } },
	getDamage = function(self, t)
		return combatTalentDamage(self, t, 0, 125)
	end,
	fireArcaneBolt = function(self, t)
		-- find nearest target
		local target
		local minDistance = 9999
		local targets = {}
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local actor = game.level.map(x, y, Map.ACTOR)
				if actor and self:reactionToward(actor) < 0 then
					local distance = core.fov.distance(self.x, self.y, actor.x, actor.y)
					if (not target or distance < minDistance) and self:hasLOS(actor.x, actor.y) then
						target = actor
						minDistance = distance
					end
				end
			end
		end

		if not target then return end
		if self.dead then
			self.arcaneBolts = nil
			return
		end

		local x, y = target.x, target.y
		local tg = {type="bolt", range=range, talent=t, display={particle="bolt_fire", trail="firetrail"}}
		self:projectile(tg, target.x, target.y, DamageType.ARCANE, self.arcaneBolts.damage, nil)

		game:playSoundNear(self, "talents/fire")
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local damage = t.getDamage(self, t)

		--local tg = {type="bolt", range=range, talent=t, display={particle="bolt_fire", trail="firetrail"}}
		--local x, y, target = self:getTarget(tg)
		--if not x or not y or not target or core.fov.distance(self.x, self.y, x, y) > range then return nil end

		self.arcaneBolts = { damage = damage, range = range, duration = 4 }

		return true
	end,
	do_arcaneBolts = function(self, t)
		t.fireArcaneBolt(self, t)

		if self.arcaneBolts then
			self.arcaneBolts.duration = self.arcaneBolts.duration - 1
			if self.arcaneBolts.duration <= 0 then self.arcaneBolts = nil end
		end
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[连 续 4 个 回 合 向 你 最 近 目 标 发 射 奥 术 能 量 弹， 造 成 %d 伤 害。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.ARCANE, damage))
	end,
}

newTalent{
	name = "Displace",
	type = {"cursed/primal-magic", 2},
	require = cursed_mag_req2,
	points = 5,
	random_ego = "utility",
	no_energy = true,
	cooldown = function(self, t) return 20 - math.floor(self:getTalentLevel(t) * 1.5) end,
	hate = 5,
	range = 3,
	tactical = { ESCAPE = function(self, t, target)
		return 2 * self:canBe("teleport")
	end },
	action = function(self, t)
		local x, y = self.x, self.y
		local range = self:getTalentRange(t)
		game.logPlayer(self, "Selects a displacement location...")
		local tg = {type="ball", nolock=true, pass_terrain=false, nowarning=true, range=range, radius=0}
		x, y = self:getTarget(tg)
		if not x or not self:hasLOS(x, y) then return nil end

		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)

		if not self:canMove(x, y) or (self.x == x and self.y == y) then return nil end
		if not self:canBe("teleport") or game.level.map.attrs(x, y, "no_teleport") then
			game.logSeen(self, "Your attempt to displace fails!")
			return true
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
		self:move(x, y, true)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport_in")

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[瞬 间 将 你 移 动 至 视 线 内 3 码 以 外。]])
	end,
}

newTalent{
	name = "Primal Skin",
	type = {"cursed/primal-magic", 3},
	require = cursed_mag_req3,
	points = 5,
	mode = "passive",
	points = 5,
	getArmor = function(self, t) return combatTalentDamage(self, t, 4, 40) end,
	info = function(self, t)
		local armor = t.getArmor(self, t)
		return ([[魔 法 渗 透 进 你 的 皮 肤， 增 加 你 的 物 理 抗 性， 提 高 你 的 护 甲 值 %d 。 
		 受 魔 法 影 响， 增 益 效 果 有 额 外 加 成。]]):format(armor)
	end,
}

newTalent{
	name = "Vaporize",
	type = {"cursed/primal-magic", 4},
	require = cursed_mag_req4,
	points = 5,
	random_ego = "attack",
	hate = 30,
	cooldown = 30,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = 10,
	proj_speed = 20,
	requires_target = true,
	no_npc_use = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_arcane", trail="arcanetrail"}}
		return tg
	end,
	getDamage = function(self, t) return combatTalentDamage(self, t, 0, 800) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ARCANE, t.getDamage(self, t), {type="vaporize"})

		local _ _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, 8,
			DamageType.ARCANE, 5,
			0,
			5, nil,
			{type="light_zone"},
			nil, self:spellFriendlyFire()
		)

		tg = {type="hit", range=10}
		self:project(tg, self.x, self.y, DamageType.CONFUSION, {
			dur = 4,
			dam = 75
		})

		game:playSoundNear(self, "talents/fireflash")

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[蒸 腾 你 的 目 标 造 成 %d 伤 害。 
		 这 个 魔 法 难 以 驾 驭， 如 果 施 放 失 败 你 会 被 混 乱 4 回 合。 
		 受 魔 法 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, damage))
	end,
}

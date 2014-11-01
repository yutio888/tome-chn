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
	name = "Celerity",
	type = {"chronomancy/speed-control", 1},
	require = chrono_req1,
	points = 5,
	mode = "passive",
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.15, 0.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "movement_speed", t.getSpeed(self, t))
	end,
	info = function(self, t)
		return ([[增 加 %d%% 移 动 速 度 并 且 切 换 武 器（ 默 认 快 捷 键 q） 不 再 消 耗 回 合。]]):
		format(t.getSpeed(self, t)*100)
	end,
}

newTalent{
	name = "Stop",
	type = {"chronomancy/speed-control",2},
	require = chrono_req2,
	points = 5,
	paradox = 10,
	cooldown = 12,
	tactical = { ATTACKAREA = 1, DISABLE = 3 },
	range = 6,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=self:spellFriendlyFire(), talent=t}
	end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 2.3, 4.3)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 170)  * getParadoxModifier(self, pm) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		x, y = checkBackfire(self, x, y)
		local grids = self:project(tg, x, y, DamageType.STOP, t.getDuration(self, t))
		self:project(tg, x, y, DamageType.TEMPORAL, self:spellCrit(t.getDamage(self, t)))

		game.level.map:particleEmitter(x, y, tg.radius, "temporal_flash", {radius=tg.radius, tx=x, ty=y})
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 时 空 伤 害（ %d 码 有 效 半 径 范 围） 并 试 图 震 慑 所 有 目 标 %d 回 合。 
		 受 紊 乱 值 影 响， 震 慑 持 续 时 间 按 比 例 加 成； 受 紊 乱 值 和 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(damage, radius, duration)
	end,
}

newTalent{
	name = "Slow",
	type = {"chronomancy/speed-control", 3},
	require = chrono_req3,
	points = 5,
	paradox = 15,
	cooldown = 24,
	tactical = { ATTACKAREA = {TEMPORAL = 2}, DISABLE = 2 },
	range = 6,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.25, 3.25))	end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getSlow = function(self, t) return math.min((10 + (self:combatTalentSpellDamage(t, 10, 50) * getParadoxModifier(self, pm))) / 100, 0.6) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 60) * getParadoxModifier(self, pm) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		x, y = checkBackfire(self, x, y)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.CHRONOSLOW, {dam=t.getDamage(self, t), slow=t.getSlow(self, t)},
			self:getTalentRadius(t),
			5, nil,
			{type="temporal_cloud"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[在 %d 码 半 径 范 围 内 制 造 1 个 时 间 扭 曲 力 场， 持 续 %d 回 合。 同 时 减 少 %d%% 目 标 整 体 速 度， 持 续 3 回 合， 当 目 标 处 于 此 范 围 内 时 每 回 合 造 成 %0.2f 时 空 伤 害。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 减 速 效 果 和 伤 害 有 额 外 加 成。]]):
		format(radius, duration, 100 * slow, damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

newTalent{
	name = "Haste",
	type = {"chronomancy/speed-control", 4},
	require = chrono_req4,
	points = 5,
	paradox = 20,
	cooldown = 24,
	tactical = { BUFF = 2, CLOSEIN = 2, ESCAPE = 2 },
	no_energy = true,
	getPower = function(self, t) return self:combatScale(self:combatTalentSpellDamage(t, 20, 80) * getParadoxModifier(self, pm), 0, 0, 0.57, 57, 0.75) end,
	do_haste_double = function(self, t, x, y)
		-- Find space
		local tx, ty = util.findFreeGrid(x, y, 0, true, {[Map.ACTOR]=true})
		if not tx then
			return
		end
				
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "figment", subtype = "temporal",
			display = "@", color=colors.LIGHT_STEEL_BLUE,
			name = "Afterimage", faction = self.faction, image = "npc/undead_ghost_kor_s_fury.png",
			desc = [[An afterimage created by someone using the Haste spell.]],
			autolevel = "none",
			ai = "summoned", ai_real = "dumb_talented", ai_state = { talent_in=1, },
			level_range = {1, 1}, exp_worth = 0,

			max_life = self.max_life,
			life_rating = 0,
			never_move = 1,

			summon_time = 2,
		}
		
		m.life = self.life
		m.combat = nil
		m.never_anger = true
		m:resolve() m:resolve(nil, true)
		m:forceLevelup(self.level)
		m.on_takehit = function(self, value, src)
			self:die(src)
			return value
		end,
				
		game.zone:addEntity(game.level, m, "actor", x, y)
		m:removeAllMOs()
		game.level.map:updateMap(x, y)
	end,
	action = function(self, t)
		self:setEffect(self.EFF_HASTE, 4, {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[在 下 面 4 个 回 合 内 增 加 %d%% 整 体 速 度。 
		 当 你 在 此 状 态 下 移 动 时， 你 的 身 后 会 留 下 1 个 持 续 2 回 合 的 残 影 吸 引 敌 人 攻 击。 
		 受 紊 乱 值 和 法 术 强 度 影 响， 速 度 增 益 按 比 例 加 成。]]):format(100 * power)
	end,
}

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
	name = "Curse of Defenselessness",
	type = {"corruption/curses", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 20,
	vim = 20,
	range = 10,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CURSE_DEFENSELESSNESS, 10, {power=self:combatTalentSpellDamage(t, 30, 60), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(tx, ty, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 它 %d 点 闪 避 和 所 有 豁 免， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(self:combatTalentSpellDamage(t, 30, 60))
	end,
}

newTalent{
	name = "Curse of Impotence",
	type = {"corruption/curses", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 20,
	vim = 20,
	range = 10,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	imppower = function(self,t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 30),100, 0, 0, 19.36, 19.36) end, -- Limit to <100%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CURSE_IMPOTENCE, 10, {power=t.imppower(self,t), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(tx, ty, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_02", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 它 %d%% 所 有 伤 害， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 值 有 额 外 减 少。]]):format(t.imppower(self,t))
	end,
}

newTalent{
	name = "Curse of Death",
	type = {"corruption/curses", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 20,
	vim = 20,
	range = 10,
	tactical = { ATTACK = {DARKNESS = 2}, DISABLE = 1 },
	direct_hit = true,
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CURSE_DEATH, 10, {src=self, dam=self:combatTalentSpellDamage(t, 10, 70), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(tx, ty, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_03", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[诅 咒 目 标， 中 断 任 何 自 然 治 疗。 每 回 合 造 成 %0.2f 暗 影 伤 害， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.DARKNESS, self:combatTalentSpellDamage(t, 10, 70)))
	end,
}

newTalent{
	name = "Curse of Vulnerability",
	type = {"corruption/curses", 4},
	require = corrs_req4,
	points = 5,
	cooldown = 20,
	vim = 20,
	range = 10,
	tactical = { DISABLE = 2 },
	requires_target = true,
	direct_hit = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CURSE_VULNERABILITY, 7, {power=self:combatTalentSpellDamage(t, 10, 40), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(tx, ty, 1, "circle", {base_rot=0, oversize=0.7, a=130, limit_life=8, appear=8, speed=0, img="curse_gfx_04", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 其 %d%% 所 有 抵 抗， 持 续 7 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(self:combatTalentSpellDamage(t, 10, 40))
	end,
}

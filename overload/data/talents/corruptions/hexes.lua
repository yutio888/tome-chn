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
	name = "Pacification Hex",
	type = {"corruption/hexes", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 20,
	vim = 30,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getchance = function(self,t)
		return self:combatLimit(self:combatTalentSpellDamage(t, 30, 50), 100, 0, 0, 36.8, 36.8) -- Limit <100%
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_PACIFICATION_HEX, 20, {power=self:combatSpellpower(), chance=t.getchance(self,t), apply_power=self:combatSpellpower()})
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, a=90, limit_life=8, appear=8, speed=2, img="blight_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 眩 晕 它 和 2 码 球 形 范 围 内 的 一 切， 持 续 3 回 合。 同 时， 每 回 合 有 %d%% 概 率 再 次 眩 晕 目 标， 持 续 20 回 合。 
		 受 法 术 强 度 影 响， 概 率 有 额 外 加 成。]]):format(t.getchance(self,t))
	end,
}

newTalent{
	name = "Burning Hex",
	type = {"corruption/hexes", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 20,
	vim = 30,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getCDincrease = function(self, t) return self:combatTalentScale(t, 0.15, 0.5) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_BURNING_HEX, 20, {src=self, dam=self:spellCrit(self:combatTalentSpellDamage(t, 4, 90)), power=1 + t.getCDincrease(self, t), apply_power=self:combatSpellpower()})
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, g=100, b=100, a=90, limit_life=8, appear=8, speed=2, img="blight_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 诅 咒 它 和 2 码 球 形 范 围 内 的 一 切， 持 续 20 回 合。 每 次 受 影 响 的 对 象 消 耗 资 源 （ 体 力、 法 力、 活 力 等 ） 时，将 会 受 到 %0.2f 点 火 焰 伤 害。 
		 同 时， 对 方 使 用 的 技 能 的 冷 却 时 间 延 长 %d%% +1 个 回 合。  
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 4, 90)), t.getCDincrease(self, t)*100)
	end,
}

newTalent{
	name = "Empathic Hex",
	type = {"corruption/hexes", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 20,
	vim = 30,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	recoil = function(self,t) return self:combatLimit(self:combatTalentSpellDamage(t, 4, 20), 100, 0, 0, 12.1, 12.1) end, -- Limit to <100%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_EMPATHIC_HEX, 20, {power=t.recoil(self,t), apply_power=self:combatSpellpower()})
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, r=100, b=100, a=90, limit_life=8, appear=8, speed=2, img="blight_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 诅 咒 目 标 和 2 码 球 形 范 围 内 的 一 切。 每 当 目 标 造 成 伤 害 时， 它 们 也 会 受 到 %d%% 相 同 伤 害， 持 续 20 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.recoil(self,t))
	end,
}

newTalent{
	name = "Domination Hex",
	type = {"corruption/hexes", 4},
	require = corrs_req4,
	points = 5,
	cooldown = 20,
	vim = 30,
	range = 10,
	no_npc_use = true,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			if target:canBe("instakill") then
				target:setEffect(target.EFF_DOMINATION_HEX, t.getDuration(self, t), {src=self, apply_power=self:combatSpellpower(), faction = self.faction})
			end
		end)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {oversize=0.7, g=100, r=100, a=90, limit_life=8, appear=8, speed=2, img="blight_circle", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[对 目 标 施 放 邪 术， 使 它 成 为 你 的 奴 隶， 持 续 %d 回 合。 
		 如 果 你 对 目 标 造 成 伤 害， 则 目 标 会 脱 离 诅 咒。]]):format(t.getDuration(self, t))
	end,
}

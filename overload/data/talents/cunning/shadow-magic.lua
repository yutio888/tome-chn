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
	name = "Shadow Combat",
	type = {"cunning/shadow-magic", 1},
	mode = "sustained",
	points = 5,
	require = cuns_req1,
	sustain_stamina = 20,
	mana = 0,
	cooldown = 5,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return 2 + self:combatTalentSpellDamage(t, 2, 50) end,
	getManaCost = function(self, t) return 2 end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local manacost = t.getManaCost(self, t)
		return ([[在 你 的 武 器 上 注 入 一 股 黑 暗 的 能 量， 每 次 攻 击 会 造 成 %.2f 暗 影 伤 害 并 消 耗 %.2f 点 法 力。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), manacost)
	end,
}

newTalent{
	name = "Shadow Cunning",
	type = {"cunning/shadow-magic", 2},
	mode = "passive",
	points = 5,
	require = cuns_req2,
	-- called in _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		return ([[你 的 充 分 准 备 提 高 了 你 的 魔 法 运 用 能 力。 增 加 相 当 于 你 %d%% 灵 巧 的 法 术 强 度。]]):
		format(spellpower)
	end,
}

newTalent{
	name = "Shadow Feed",
	type = {"cunning/shadow-magic", 3},
	mode = "sustained",
	points = 5,
	cooldown = 5,
	sustain_stamina = 40,
	require = cuns_req3,
	range = 10,
	tactical = { BUFF = 2 },
	getManaRegen = function(self, t) return self:combatTalentScale(t, 1.5/5, 1, 0.75) / (1 - t.getAtkSpeed(self, t)/100) end, -- scale with atk speed bonus to allow enough mana for one shadow combat proc per turn at talent level 5 
	getAtkSpeed = function(self, t) return self:combatTalentScale(t, 2.2, 11, 0.75) end,
	activate = function(self, t)
		local speed = t.getAtkSpeed(self, t)/100
		return {
			regen = self:addTemporaryValue("mana_regen", t.getManaRegen(self, t)),
			ps = self:addTemporaryValue("combat_physspeed", speed),
			ss = self:addTemporaryValue("combat_spellspeed", speed),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.regen)
		self:removeTemporaryValue("combat_physspeed", p.ps)
		self:removeTemporaryValue("combat_spellspeed", p.ss)
		return true
	end,
	info = function(self, t)
		local manaregen = t.getManaRegen(self, t)
		return ([[你 学 会 从 暗 影 中 汲 取 能 量。 
		 当 此 技 能 激 活 时， 每 回 合 回 复 %0.2f 法 力 值。 
		 同 时， 你 的 攻 击 速 度 和 施 法 速 度 获 得 %0.1f%% 的 提 升。]]):
		format(manaregen, t.getAtkSpeed(self, t))
	end,
}

newTalent{
	name = "Shadowstep",
	type = {"cunning/shadow-magic", 4},
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	stamina = 30,
	require = cuns_req4,
	tactical = { CLOSEIN = 2, DISABLE = { stun = 1 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	direct_hit = true,
	requires_target = true,
	getDuration = function(self, t) return math.min(5, 2 + math.ceil(self:getTalentLevel(t) / 2)) end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.2, 2.5) end,
	action = function(self, t)
		if self:attr("never_move") then game.logPlayer(self, "You cannot do that currently.") return end

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return nil end
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end
		if game.level.map.attrs(x, y, "no_teleport") then
			if not game.level.map.seens(x, y) or not self:hasLOS(x, y) then return nil end
		else
			if not game.level.map.seens(x, y) then return nil end
		end

		local tx, ty = util.findFreeGrid(x, y, 20, true, {[engine.Map.ACTOR]=true})
		self:move(tx, ty, true)

		-- Attack ?
		if target and target.x and core.fov.distance(self.x, self.y, target.x, target.y) == 1 then
			self:attackTarget(target, DamageType.DARKNESS, t.getDamage(self, t), true)
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, t.getDuration(self, t), {})
			else
				game.logSeen(target, "%s is not dazed!", target.name:capitalize())
			end
		end
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[通 过 阴 影 突 袭 你 的 目 标， 眩 晕 它 %d 回 合 并 用 你 所 有 武 器 对 目 标 造 成 %d%% 暗 影 武 器 伤 害。 
		 被 眩 晕 的 目 标 受 到 显 著 伤 害 ， 但 任 何 对 目 标 的 伤 害 会 解 除 眩 晕。 
		 当 你 使 用 暗 影 突 袭 时， 目 标 必 须 在 视 野 范 围 内。]]):
		format(duration, t.getDamage(self, t) * 100)
	end,
}


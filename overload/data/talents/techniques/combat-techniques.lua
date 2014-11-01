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

----------------------------------------------------
-- Active techniques
----------------------------------------------------
newTalent{
	name = "Rush",
	type = {"technique/combat-techniques-active", 1},
	message = "@Source@ 发起冲锋！",
	require = techs_strdex_req1,
	points = 5,
	random_ego = "attack",
	stamina = function(self, t) return self:knowTalent(self.T_STEAMROLLER) and 2 or 22 end,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 36, 20)) end, --Limit to >0
	tactical = { ATTACK = { weapon = 1, stun = 1 }, CLOSEIN = 3 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", self) end
		local linestep = self:lineFOV(x, y, block_actor)
		
		local tx, ty, lx, ly, is_corner_blocked 
		repeat  -- make sure each tile is passable
			tx, ty = lx, ly
			lx, ly, is_corner_blocked = linestep:step()
		until is_corner_blocked or not lx or not ly or game.level.map:checkAllEntities(lx, ly, "block_move", self)
		if not tx or core.fov.distance(self.x, self.y, tx, ty) < 1 then
			game.logPlayer(self, "You are too close to build up momentum!")
			return
		end
		if not tx or not ty or core.fov.distance(x, y, tx, ty) > 1 then return nil end

		local ox, oy = self.x, self.y
		self:move(tx, ty, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end
		-- Attack ?
		if core.fov.distance(self.x, self.y, x, y) == 1 then
			if self:knowTalent(self.T_STEAMROLLER) then
				target:setEffect(target.EFF_STEAMROLLER, 2, {src=self})
				self:setEffect(self.EFF_STEAMROLLER_USER, 2, {buff=20})
			end

			if self:attackTarget(target, nil, 1.2, true) and target:canBe("stun") then
				-- Daze, no save
				target:setEffect(target.EFF_DAZED, 3, {})
			end
		end

		return true
	end,
	info = function(self, t)
		return ([[快 速 冲 向 你 的 目 标， 如 果 目 标 被 撞 到， 那 么 你 将 获 得 一 次 无 消 耗 的 攻 击， 伤 害 为 120% 基 础 武 器 伤 害。 
		如 果 此 次 攻 击 命 中， 那 么 目 标 会 被 眩 晕 3 回 合。 
		你 必 须 从 至 少 2 码 以 外 开 始 冲 锋。]])
	end,
}

newTalent{
	name = "Precise Strikes",
	type = {"technique/combat-techniques-active", 2},
	mode = "sustained",
	points = 5,
	require = techs_strdex_req2,
	cooldown = 30,
	sustain_stamina = 30,
	tactical = { BUFF = 1 },
	getAtk = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getDex(), 4, 0, 37, 500) end,
	getCrit = function(self, t)
		local dex = self:combatStatScale("dex", 10/25, 100/25, 0.75)
		return (self:combatTalentScale(t, dex, dex*5, 0.5, 4))
	end,
	activate = function(self, t)
		return {
			speed = self:addTemporaryValue("combat_physspeed", -0.10),
			atk = self:addTemporaryValue("combat_atk", t.getAtk(self, t)),
			crit = self:addTemporaryValue("combat_physcrit", t.getCrit(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physspeed", p.speed)
		self:removeTemporaryValue("combat_physcrit", p.crit)
		self:removeTemporaryValue("combat_atk", p.atk)
		return true
	end,
	info = function(self, t)
		return ([[你 集 中 精 神 攻 击， 减 少 你 %d%% 攻 击 速 度 并 增 加 你 %d 点 命 中 和 %d%% 暴 击 率。 
		受 敏 捷 影 响， 此 效 果 有 额 外 加 成。]]):
		format(10, t.getAtk(self, t), t.getCrit(self, t))
	end,
}

newTalent{
	name = "Perfect Strike",
	type = {"technique/combat-techniques-active", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 25,
	stamina = 10,
	require = techs_strdex_req3,
	no_energy = true,
	tactical = { ATTACK = 4 },
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 2, 6)) end, -- Limit < 25
	getAtk = function(self, t) return self:combatTalentScale(t, 40, 100, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_ATTACK, t.getDuration(self, t), {power = t.getAtk(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[你 已 经 学 会 专 注 你 的 攻 击 来 命 中 目 标， 增 加 %d 命 中 并 使 你 在 攻 击 你 看 不 见 的 目 标 时 不 再 受 到 额 外 惩 罚， 持 续 %d 回 合。]]):format(t.getAtk(self, t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Blinding Speed",
	type = {"technique/combat-techniques-active", 4},
	points = 5,
	random_ego = "utility",
	cooldown = 55,
	stamina = 25,
	no_energy = true,
	require = techs_strdex_req4,
	tactical = { BUFF = 2, CLOSEIN = 2, ESCAPE = 2 },
	getSpeed = function(self, t) return self:combatTalentScale(t, 0.14, 0.45, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_SPEED, 5, {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[通 过 严 格 的 训 练 你 已 经 学 会 在 短 时 间 内 爆 发 你 的 速 度， 提 高 你 %d%% 速 度 5 回 合。]]):format(100*t.getSpeed(self, t))
	end,
}

----------------------------------------------------
-- Passive techniques
----------------------------------------------------
newTalent{
	name = "Quick Recovery",
	type = {"technique/combat-techniques-passive", 1},
	require = techs_strdex_req1,
	mode = "passive",
	points = 5,
	getStamRecover = function(self, t) return self:combatTalentScale(t, 0.6, 2.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "stamina_regen", t.getStamRecover(self, t))
	end,
	info = function(self, t)
		return ([[你 专 注 于 战 斗， 使 得 你 可 以 更 快 的 回 复 体 力（ +%0.1f 体 力 / 回 合）。]]):format(t.getStamRecover(self, t))
	end,
}

newTalent{
	name = "Fast Metabolism",
	type = {"technique/combat-techniques-passive", 2},
	require = techs_strdex_req2,
	mode = "passive",
	points = 5,
	getRegen = function(self, t) return self:combatTalentScale(t, 3, 7.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "life_regen", t.getRegen(self, t))
	end,
	info = function(self, t)
		return ([[你 专 注 于 战 斗， 使 你 可 以 更 快 的 回 复 生 命 值（ +%0.1f 生 命 值 / 回 合）。]]):format(t.getRegen(self, t))
	end,
}

newTalent{
	name = "Spell Shield",
	type = {"technique/combat-techniques-passive", 3},
	require = techs_strdex_req3,
	mode = "passive",
	points = 5,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellresist", self:getTalentLevel(t) * 9)
	end,
	info = function(self, t)
		return ([[严 格 的 训 练 使 得 你 对 某 些 法 术 效 果 具 有 更 高 的 抗 性（ +%d 法 术 豁 免）。]]):format(self:getTalentLevel(t) * 9)
	end,
}

newTalent{
	name = "Unending Frenzy",
	type = {"technique/combat-techniques-passive", 4},
	require = techs_strdex_req4,
	mode = "passive",
	-- called by mod.class.Actor:die
	getStamRecover = function(self, t) return self:combatTalentScale(t, 5, 20, 0.5) end, -- Lower scaling than other recovery talents because it effectively scales with character speed and can trigger more than once a turn
	points = 5,
	info = function(self, t)
		return ([[你 陶 醉 在 敌 人 的 死 亡 中， 每 杀 死 一 个 敌 人 回 复 %d 体 力 值。]]):format(t.getStamRecover(self, t))
	end,
}


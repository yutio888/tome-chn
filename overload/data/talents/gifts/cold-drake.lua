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

local Object = require "mod.class.Object"

newTalent{
	name = "Ice Claw",
	type = {"wild-gift/cold-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	equilibrium = 3,
	cooldown = 7,
	range = 1,
	tactical = { ATTACK = { COLD = 2 } },
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	damagemult = function(self, t) return self:combatTalentScale(t, 1.525, 2.025) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attackTarget(target, (self:getTalentLevel(t) >= 4) and DamageType.ICE or DamageType.COLD, t.damagemult(self, t), true)
		return true
	end,
	info = function(self, t)
		return ([[你 召 唤 强 大 的 冰 龙 之 爪， 造 成 %d%% 寒 冷 武 器 伤 害。 
		 等 级 4 时， 攻 击 化 为 纯 粹 的 极 冰， 有 一 定 几 率 冻 结 目 标。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%%。]]):format(100 * t.damagemult(self, t))
	end,
}

newTalent{
	name = "Icy Skin",
	type = {"wild-gift/cold-drake", 2},
	require = gifts_req2,
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_equilibrium = 30,
	range = 10,
	tactical = { ATTACK = { COLD = 1 }, DEFEND = 2 },
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "wil", 10, 700) / 10 end,
	getArmor = function(self, t) return self:combatTalentStatDamage(t, "wil", 6, 600) / 10 end,
	activate = function(self, t)
		return {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.COLD]=t.getDamage(self, t)}),
			armor = self:addTemporaryValue("combat_armor", t.getArmor(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("combat_armor", p.armor)
		return true
	end,
	info = function(self, t)
		return ([[你 的 皮 肤 覆 盖 了 一 层 极 冰， 对 所 有 攻 击 你 的 目 标 造 成 %0.2f 寒 冷 伤 害 并 增 加 %d 点 护 甲 值。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%%。 
		 受 意 志 影 响， 伤 害 和 护 甲 按 比 例 加 成。]]):format(damDesc(self, DamageType.COLD, t.getDamage(self, t)), t.getArmor(self, t))
	end,
}

newTalent{
	name = "Ice Wall",
	type = {"wild-gift/cold-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "defensive",
	equilibrium = 10,
	cooldown = 30,
	range = 10,
	tactical = { DISABLE = 2 },
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	getLength = function(self, t) return 1 + math.floor(self:combatTalentScale(t, 3, 7)/2)*2 end,
	action = function(self, t)
		local halflength = math.floor(t.getLength(self,t)/2)
		local block = function(_, lx, ly)
			return game.level.map:checkAllEntities(lx, ly, "block_move")
		end
		local tg = {type="wall", range=self:getTalentRange(t), halflength=halflength, talent=t, halfmax_spots=halflength+1, block_radius=block}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end

		self:project(tg, x, y, function(px, py, tg, self)
			local oe = game.level.map(px, py, Map.TERRAIN)
			if not oe or oe.special then return end
			if not oe or oe:attr("temporary") or game.level.map:checkAllEntities(px, py, "block_move") then return end
			local e = Object.new{
				old_feat = oe,
				name = "ice wall", image = "npc/iceblock.png",
				desc = "a summoned, transparent wall of ice",
				type = "wall",
				display = '#', color=colors.LIGHT_BLUE, back_color=colors.BLUE,
				always_remember = true,
				can_pass = {pass_wall=1},
				does_block_move = true,
				show_tooltip = true,
				block_move = true,
				block_sight = false,
				temporary = 4 + self:getTalentLevel(t),
				x =px, y = py,
				canAct = false,
				act = function(self)
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
						game.level:removeEntity(self)
						game.level.map:updateMap(self.x, self.y)
						game.nicer_tiles:updateAround(game.level, self.x, self.y)
					end
				end,
				dig = function(src, x, y, old)
					game.level:removeEntity(old)
					return nil, old.old_feat
				end,
				summoner_gain_exp = true,
				summoner = self,
			}
			e.tooltip = mod.class.Grid.tooltip
			game.level:addEntity(e)
			game.level.map(px, py, Map.TERRAIN, e)
		--	game.nicer_tiles:updateAround(game.level, px, py)
		--	game.level.map:updateMap(px, py)
		end)
		return true
	end,
	info = function(self, t)
		return ([[召 唤 一 个 长 度 为 %d 的 冰 墙 持 续 %d 回 合。 冰 墙 是 透 明 的。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%%。]]):format(3 + math.floor(self:getTalentLevel(t) / 2) * 2, t.getDuration(self, t))
	end,
}

newTalent{
	name = "Ice Breath",
	type = {"wild-gift/cold-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes ice!",
	tactical = { ATTACKAREA = { COLD = 2 }, DISABLE = { stun = 1 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ICE, self:mindCrit(self:combatTalentStatDamage(t, "str", 30, 430)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_cold", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="icewings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		return ([[向 前 方 %d 码 范 围 施 放 一 个 锥 形 冰 冻 吐 息， 范 围 内 所 有 目 标 受 到 %0.2f 寒 冷 伤 害， 并 有 25%% 几 率 被 冻 结 数 回 合（ 敌 人 等 级 较 高 时 冰 冻 时 间 缩 短）。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。 
		 每 一 点 冰 龙 系 技 能 同 时 也 能 增 加 你 的 寒 冷 抵 抗 1%%。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.COLD, self:combatTalentStatDamage(t, "str", 30, 430)))
	end,
}


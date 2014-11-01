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
	name = "Slime Spit",
	type = {"wild-gift/slime", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	equilibrium = 4,
	cooldown = 5,
	tactical = { ATTACK = { NATURE = 2}, DISABLE = 1 },
	range = 10,
	proj_speed = 6,
	requires_target = true,
	getTargetCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	bouncePercent = function(self, t) return self:combatTalentLimit(t, 100, 50, 60) end, --Limit < 100%
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), selffire=false, talent=t, display={particle="bolt_slime"}, name = t.name, speed = t.proj_speed}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.BOUNCE_SLIME, {nb=t.getTargetCount(self, t), dam=self:mindCrit(self:combatTalentMindDamage(t, 30, 250)), bounce_factor=t.bouncePercent(self, t)/100}, {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[向 你 的 目 标 喷 吐 酸 液 造 成 %0.1f 自 然 伤 害 并 减 速 目 标 30%%  3 回 合。 
		 酸 液 球 可 弹 射 到 附 近 的 某 个 敌 方 单 位 %d 次。 
		 弹 射 距 离 最 多 为 6 码 ， 同 时 每 弹 一 次 会 减 少 %0.1f%% 伤 害 。
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 30, 250)), t.getTargetCount(self, t), 100-t.bouncePercent(self, t))
	end,
}

newTalent{
	name = "Poisonous Spores",
	type = {"wild-gift/slime", 2},
	require = gifts_req2,
	random_ego = "attack",
	points = 5,
	message = "@Source@ releases poisonous spores at @target@.",
	equilibrium = 2,
	cooldown = 10,
	range = 10,
	tactical = { ATTACKAREA = { NATURE = 2 }, DISABLE = 1 },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 2.7)) end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 30, 390) end,
	critPower = function(self, t) return self:combatTalentMindDamage(t, 10, 40) end,
	requires_target = true,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t), 0, t.critPower(self, t)/100)
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and self:reactionToward(target) < 0 and target:canBe("poison") then
				local poison = rng.table{target.EFF_SPYDRIC_POISON, target.EFF_INSIDIOUS_POISON, target.EFF_CRIPPLING_POISON, target.EFF_NUMBING_POISON}
				target:setEffect(poison, 10, {src=self, power=dam/10, 
				reduce=self:combatTalentLimit(t, 100, 12, 20), 
				fail=math.ceil(self:combatTalentLimit(t, 100, 6, 10)),
				heal_factor=self:combatTalentLimit(t, 100, 24, 40)})
			end
		end, 0, {type="slime"})

		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[向 %d 码 半 径 范 围 释 放 毒 性 孢 子， 使 范 围 内 的 敌 方 单 位 感 染 随 机 类 型 的 毒 素， 造 成 %0.1f 自 然 伤 害， 持 续 10 回 合。
		这 个 攻 击 能 够 暴 击 ， 造 成 额 外 %d%% 暴 击 伤 害。
		受 精 神 强 度 影 响 ， 伤 害 和 暴 击 加 成 有 额 外 加 成。 ]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.critPower(self, t))
	end,
}

-- Boring, but disarm was way too far
-- Now that we have melee retaliation damage shown in tooltips its a little safer to raise the damage on this
newTalent{
	name = "Acidic Skin",
	type = {"wild-gift/slime", 3},
	require = gifts_req3,
	points = 5,
	mode = "sustained",
	message = "The skin of @Source@ starts dripping acid.",
	sustain_equilibrium = 3,
	cooldown = 30,
	range = 1,
	requires_target = false,
	tactical = { DEFEND = 1 },
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 7, 15) end, -- Limit < 100%
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local power = t.getDamage(self, t)
		return {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.ACID_DISARM]={dam=power, chance=t.getChance(self, t)}}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		return true
	end,
	info = function(self, t)
		return ([[你 的 皮 肤 浸 泡 着 酸 液， 对 所 有 攻 击 你 的 目 标 造 成 %0.1f 酸 性 伤 害， 并 有 %d%% 几 率 缴 械 目 标 3 回 合。
		 受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getChance(self, t))
	end,
}

newTalent{
	name = "Slime Roots",
	type = {"wild-gift/slime", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "utility",
	equilibrium = 5,
	cooldown = 20,
	tactical = { CLOSEIN = 2, ESCAPE = 1 },
	requires_target = true,
	range = function(self, t)
		return math.floor(self:combatTalentScale(t,4.5,6.5))
	end,
	radius = function(self, t)
		return util.bound(4 - self:getTalentLevel(t) / 2, 1, 4)
	end,
	getNbTalents = function(self, t)
		if self:getTalentLevel(t) < 4 then return 1
		elseif self:getTalentLevel(t) < 7 then return 2
		else return 3
		end
	end,
	is_teleport = true,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=range, radius=radius, requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the self coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _, x, y = self:canProject(tg, x, y)
		if not x then return nil end
		local oldx, oldy = self.x, self.y
		if not self:teleportRandom(x, y, self:getTalentRadius(t)) then return nil end
		game.level.map:particleEmitter(oldx, oldy, 1, "slime")
		game.level.map:particleEmitter(self.x, self.y, 1, "slime")

		local nb = t.getNbTalents(self, t)
		local list = {}
		for tid, cd in pairs(self.talents_cd) do 
			local tt = self:getTalentFromId(tid)
			if tt.mode ~= "passive" and not tt.uber then list[#list+1] = tid end
		end
		while #list > 0 and nb > 0 do
			self.talents_cd[rng.tableRemove(list)] = nil
			nb = nb - 1
		end
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local talents = t.getNbTalents(self, t)
		return ([[你 延 伸 史 莱 姆 触 手 进 入 地 下 ， 然 后 在 %d 码 范 围 内 的 指 定 位 置 出 现（ %d 码 误 差）。
		 释 放 此 技 能 会 导 致 你 的 身 体 结 构 发 生 轻 微 的 改 变， 使 %d 个 技 能 冷 却 完 毕。]]):format(range, radius, talents)
	end,
}



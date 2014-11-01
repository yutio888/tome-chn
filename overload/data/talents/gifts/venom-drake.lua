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
	name = "Acidic Spray",
	type = {"wild-gift/venom-drake", 1},
	require = gifts_req1,
	points = 5,
	random_ego = "attack",
	message = "@Source@ spits acid!",
	equilibrium = 3,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 3, 6.9, 5.5)) end, -- Limit >=3
	tactical = { ATTACK = { ACID = 2 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5.5, 7.5)) end,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 5 then return true else return false end end,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		if self:getTalentLevel(t) >= 5 then tg.type = "beam" end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 25, 250) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID_DISARM, self:mindCrit(t.getDamage(self, t)), nil)
		local _ _, x, y = self:canProject(tg, x, y)
		if tg.type == "beam" then
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "acidbeam", {tx=x-self.x, ty=y-self.y})
		else
			game.level.map:particleEmitter(x, y, 1, "acid")
		end
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向 你 的 敌 人 喷 出 一 团 酸 雾。 
		 目 标 会 受 到 %0.2f 点 基 于 精 神 强 度 的 酸 性 伤 害。 
		 受 到 攻 击 的 敌 人 有 25％ 几 率 被 缴 械 3 回 合， 因 为 酸 雾 将 他 们 的 武 器 给 腐 蚀 了。 
		 在 等 级 5 时， 这 团 酸 雾 可 以 穿 透 一 条 线 上 的 敌 人。 
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%%。]]):format(damDesc(self, DamageType.ACID, damage))
	end,
}

newTalent{
	name = "Corrosive Mist",
	type = {"wild-gift/venom-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	equilibrium = 15,
	cooldown = 25,
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 0,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 70) end,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatMindpower(0.04) + self:getTalentLevel(t)/2, 6, 0, 7.67, 5.67)) end,
	getCorrodeDur = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.8)) end,
	getAtk = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	getArmor = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	getDefense = function(self, t) return self:combatTalentMindDamage(t, 2, 20) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	action = function(self, t)
		local damage = self:mindCrit(t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local armor = t.getArmor(self, t)
		local defense = t.getDefense(self, t)
		local actor = self
		local radius = self:getTalentRadius(t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.ACID_CORRODE, {dam=damage, dur=cordur, atk=atk, armor=armor, defense=defense}, 
			radius,
			5, nil,
			{type="acidstorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local radius = self:getTalentRadius(t)
		return ([[吐 出 一 股 浓 厚 的 酸 雾， 每 回 合 造 成 %0.2f 酸 性 伤 害， 范 围 为 %d 码 半 径， 持 续 %d 回 合， 技 能 可 暴 击。 
		 在 这 团 酸 雾 里 的 敌 人 会 被 腐 蚀， 持 续 %d 回 合， 降 低 他 们 %d 点 命 中、 护 甲 和 闪 避。 
		 受 精 神 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成； 受 技 能 等 级 影 响， 范 围 有 额 外 加 成。 
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%%。]]):format(damDesc(self, DamageType.ACID, damage), radius, duration, cordur, atk)
	end,
}

newTalent{
	name = "Dissolve",
	type = {"wild-gift/venom-drake", 3},
	require = gifts_req3,
	points = 5,
	random_ego = "attack",
	equilibrium = 10,
	cooldown = 12,
	range = 1,
	tactical = { ATTACK = { ACID = 2 } },
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		self:attackTarget(target, (self:getTalentLevel(t) >= 2) and DamageType.ACID_BLIND or DamageType.ACID, self:combatTalentWeaponDamage(t, 0.1, 0.60), true)
		self:attackTarget(target, (self:getTalentLevel(t) >= 4) and DamageType.ACID_BLIND or DamageType.ACID, self:combatTalentWeaponDamage(t, 0.1, 0.60), true)
		self:attackTarget(target, (self:getTalentLevel(t) >= 6) and DamageType.ACID_BLIND or DamageType.ACID, self:combatTalentWeaponDamage(t, 0.1, 0.60), true)
		self:attackTarget(target, (self:getTalentLevel(t) >= 8) and DamageType.ACID_BLIND or DamageType.ACID, self:combatTalentWeaponDamage(t, 0.1, 0.60), true)
		return true
	end,
	info = function(self, t)
		return ([[你 对 敌 人 挥 出 暴 风 般 的 酸 性 攻 击。 你 对 敌 人 造 成 四 次 酸 性 伤 害。 每 击 造 成 %d%% 点 伤 害。 
		 每 拥 有 2 个 天 赋 等 级， 你 的 其 中 一 次 攻 击 就 会 成 附 带 致 盲 的 酸 性 攻 击， 若 击 中 则 有 25%% 几 率 致 盲 目 标。
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%%。]]):format(100 * self:combatTalentWeaponDamage(t, 0.1, 0.6))
	end,
}

newTalent{
	name = "Corrosive Breath",
	type = {"wild-gift/venom-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes acid!",
	tactical = { ATTACKAREA = { ACID = 2 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID_DISARM, self:mindCrit(self:combatTalentStatDamage(t, "str", 30, 420)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_acid", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="acidwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		return ([[向 前 方 %d 码 范 围 施 放 一 个 锥 形 酸 雾 吐 息， 范 围 内 所 有 目 标 受 到 %0.2f 酸 性 伤 害， 并 有 25%% 几 率 被 缴 械 3 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%%。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "str", 30, 420)))
	end,
}
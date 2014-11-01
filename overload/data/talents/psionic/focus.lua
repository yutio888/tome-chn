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
	name = "Mindlash",
	type = {"psionic/focus", 1},
	require = psi_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 3,
	psi = 10,
	tactical = { AREAATTACK = { PHYSICAL = 2} },
	range = function(self,t) return self:combatTalentScale(t, 4, 6) end,
	getDamage = function (self, t)
		return self:combatTalentMindDamage(t, 10, 240)
	end,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		
		self:project(tg, x, y, function(px, py)
			DamageType:get(DamageType.PHYSICAL).projector(self, px, py, DamageType.PHYSICAL, dam)
			local act = game.level.map(px, py, Map.ACTOR)
			if not act then return end
			act:setEffect(act.EFF_OFFBALANCE, 2, {apply_power=self:combatMindpower()})
			if self:hasEffect(self.EFF_TRANSCENDENT_TELEKINESIS) then
				local act = game.level.map(px, py, engine.Map.ACTOR)
				if act and act:canBe("stun") then
					act:setEffect(act.EFF_STUNNED, 2, {apply_power=self:combatMindpower()})
				end
			end
		end, {type="mindsear"})
		game:playSoundNear(self, "talents/spell_generic")
		
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[汇 聚 能 量 形 成 一 道 光 束 鞭 笞 敌 人  ，造 成 %d 点 物 理 伤 害 并 使 他 们 失 去 平 衡 两 轮 （-15%% 全 局 速 度 ）。
		受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成 。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

newTalent{
	name = "Pyrokinesis",
	type = {"psionic/focus", 2},
	require = psi_wil_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	psi = 20,
	tactical = { ATTACK = { FIRE = 2 } },
	range = 0,
	radius = function(self,t) return self:combatTalentScale(t, 4, 6) end,
	getDamage = function (self, t)
		return self:combatTalentMindDamage(t, 20, 450)
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false}
	end,
	action = function(self, t)
		local dam = self:mindCrit(t.getDamage(self, t))
		local tg = self:getTalentTarget(t)
		if self:hasEffect(self.EFF_TRANSCENDENT_PYROKINESIS) then
			self:project(tg, self.x, self.y, DamageType.FLAMESHOCK, {dur=6, dam=dam, apply_power=self:combatMindpower()})
		else
			self:project(tg, self.x, self.y, DamageType.FIREBURN, {dur=6, initial=0, dam=dam})
		end
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "fireflash", {radius=tg.radius})
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[对 %d 范 围 内 的 所 有 敌 人 ， 用 意 念 使 组 成 其 身 体 的 分 子 活 化  并 引 燃 他 们 ， 在 6 回 合 内 造 成 %0.1f 火 焰 伤 害 。]]):
		format(radius, damDesc(self, DamageType.FIREBURN, dam))
	end,
}

newTalent{
	name = "Brain Storm",
	type = {"psionic/focus", 3},
	points = 5, 
	require = psi_wil_req3,
	psi = 15,
	cooldown = 10,
	range = function(self,t) return self:combatTalentScale(t, 3, 5) end,
	radius = function(self,t) return self:combatTalentScale(t, 2, 3) end,
	tactical = { DISABLE = 2, ATTACKAREA = { LIGHTNING = 2 } },
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 290) end,
	action = function(self, t)		
		local tg = {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		
		local dam=t.getDamage(self, t)
		
		self:project(tg, x, y, DamageType.BRAINSTORM, self:mindCrit(dam))
		
		-- Lightning ball gets a special treatment to make it look neat
		local sradius = (tg.radius + 0.5) * (engine.Map.tile_w + engine.Map.tile_h) / 2
		local nb_forks = 16
		local angle_diff = 360 / nb_forks
		for i = 0, nb_forks - 1 do
			local a = math.rad(rng.range(0+i*angle_diff,angle_diff+i*angle_diff))
			local tx = x + math.floor(math.cos(a) * tg.radius)
			local ty = y + math.floor(math.sin(a) * tg.radius)
			game.level.map:particleEmitter(x, y, tg.radius, "temporal_lightning", {radius=tg.radius, grids=grids, tx=tx-x, ty=ty-y, nb_particles=25, life=8})
		end

		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[念 力 电 离 空 气 ，将 等 离 子 体 球 掷 向 敌 人 。
		等 离 子 球 会 因 碰 撞 而 爆 炸 ，造 成 半 径 为 %d 的 %0.1f 闪 电 伤 害 。
		此 技 能 将 施 加 锁 脑 状 态 。
		受 精 神 强 度 影 响，伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.LIGHTNING, dam) )
	end,
}

newTalent{
	name = "Iron Will", image = "talents/iron_will.png",
	type = {"psionic/focus", 4},
	require = psi_wil_req4,
	points = 5,
	mode = "passive",
	stunImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.10, 0.40) end,
	cureChance = function(self, t) return self:combatTalentLimit(t, 1, 0.10, 0.30) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "stun_immune", t.stunImmune(self, t))
	end,
	callbackOnActBase = function(self, t)
		if not rng.percent(t.cureChance(self, t)*100) then return end
	
		local effs = {}
		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.type == "mental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end
		
		if #effs > 0 then
			local eff = rng.tableRemove(effs)
			self:removeEffect(eff[2])
			game.logSeen(self, "%s has recovered!", self.name:capitalize())
		end
	end,
	info = function(self, t)
		return ([[ 钢 铁 意 志 提 高 %d%% 震 慑 免 疫， 并 使 得 你 每 回 合 有 %d%% 的 几 率 从 随 机 一 个 精  神 效 果 中 恢 复。]]):
		format(t.stunImmune(self, t)*100, t.cureChance(self, t)*100)
	end,
}

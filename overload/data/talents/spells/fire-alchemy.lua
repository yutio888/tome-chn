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
local Object = require "engine.Object"

newTalent{
	name = "Flame Infusion", short_name = "FIRE_INFUSION",
	type = {"spell/fire-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 30,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
	activate = function(self, t)
		cancelAlchemyInfusions(self)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.FIRE] = t.getIncrease(self, t)})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[给 炼 金 炸 弹 附 加 火 焰 能 量, 使 敌 人 进 入 灼 烧 状 态
		此 外， 你 造 成 的 所 有 火 焰 伤 害 增 加 %d%%。]]):
		format(daminc)
	end,
}

newTalent{
	name = "Smoke Bomb",
	type = {"spell/fire-alchemy", 2},
	require = spells_req2,
	points = 5,
	mana = function(self, t) return util.bound(math.ceil(82 - self:getTalentLevel(t) * 10), 10, 100) end,
	cooldown = 34,
	range = 6,
	direct_hit = true,
	tactical = { DISABLE = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.03) * self:getTalentLevel(t), 2, 0, 10, 8)) end,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=2, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local heat = nil
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target:hasEffect(target.EFF_BURNING) then heat = target:hasEffect(target.EFF_BURNING) end
		end)

		if not heat then
			self:project(tg, x, y, function(px, py)
				local e = Object.new{
					block_sight=true,
					temporary = t.getDuration(self, t),
					x = px, y = py,
					canAct = false,
					act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
							game.level.map:remove(self.x, self.y, engine.Map.TERRAIN+2)
							game.level:removeEntity(self)
							game.level.map:redisplay()
						end
					end,
					summoner_gain_exp = true,
					summoner = self,
				}
				game.level:addEntity(e)
				game.level.map(px, py, Map.TERRAIN+2, e)
			end, nil, {type="dark"})
		else
			self:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, Map.ACTOR)
				if target and not target:hasEffect(target.EFF_BURNING) and self:reactionToward(target) < 0 then
					target:setEffect(target.EFF_BURNING, heat.dur + math.ceil(t.getDuration(self, t)/3), {src=self, power=heat.power}) 
				end
			end)
		end
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[投 掷 一 枚 烟 雾 弹， 遮 住 一 条 直 线 的 视 野。 %d 回 合 后 烟 雾 会 消 失。 
		 若 烟 雾 中 存 在 处 于 引 燃 状 态 的 生 物， 则 会 将 烟 雾 消 耗 一 空 并 在 所 有 目 标 身 上 附 加 引 燃 效 果， 持 续 时 间 增 加 %d 回 合。 
		 受 法 术 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(duration, math.ceil(duration / 3))
	end,
}

newTalent{
	name = "Fire Storm",
	type = {"spell/fire-alchemy",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 70,
	cooldown = 20,
	range = 0,
	radius = 3,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire=false}
	end,
	tactical = { ATTACKAREA = { FIRE = 2 } },
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.05) + self:getTalentLevel(t), 5, 0, 12.67, 7.66)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 120) end,
	action = function(self, t)
		-- Add a lasting map effect
		local ef = game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.FIRE_FRIENDS, t.getDamage(self, t),
			3,
			5, nil,
			{type="firestorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			0, 0
		)
		ef.name = "firestorm"
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[制 造 一 片 激 烈 的 火 焰 风 暴， 每 回 合 对 施 法 者 周 围 3 码 范 围 内 的 目 标 造 成 %0.2f 火 焰 伤 害， 持 续 %d 回 合。 
		 你 精 确 的 操 控 火 焰 风 暴， 阻 止 它 伤 害 你 的 队 友。 
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), duration)
	end,
}


newTalent{
	name = "Body of Fire",
	type = {"spell/fire-alchemy",4},
	require = spells_req4,
	mode = "sustained",
	cooldown = 40,
	sustain_mana = 250,
	points = 5,
	proj_speed = 2.4,
	range = 6,
	tactical = { ATTACKAREA = { FIRE = 3 } },
	getFireDamageOnHit = function(self, t) return self:combatTalentSpellDamage(t, 5, 25) end,
	getResistance = function(self, t) return self:combatTalentSpellDamage(t, 5, 45) end,
	getFireDamageInSight = function(self, t) return self:combatTalentSpellDamage(t, 15, 70) end,
	getManaDrain = function(self, t) return -0.1 * self:getTalentLevelRaw(t) end,
	do_fire = function(self, t)
		if self:getMana() <= 0 then
			self:forceUseTalent(t.id, {ignore_energy=true})
			return
		end

		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(t), true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_fire"}, friendlyblock=false, friendlyfire=false}
		for i = 1, math.floor(self:getTalentLevel(t)) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:projectile(table.clone(tg), a.x, a.y, DamageType.FIRE, self:spellCrit(t.getFireDamageInSight(self, t)), {type="flame"})
			game:playSoundNear(self, "talents/fire")
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/fireflash")
		game.logSeen(self, "#FF8000#%s turns into pure flame!", self.name:capitalize())
		self:addShaderAura("body_of_fire", "awesomeaura", {time_factor=3500, alpha=1, flame_scale=1.1}, "particles_images/wings.png")
		return {
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.FIRE]=t.getFireDamageOnHit(self, t)}),
			res = self:addTemporaryValue("resists", {[DamageType.FIRE] = t.getResistance(self, t)}),
			drain = self:addTemporaryValue("mana_regen", t.getManaDrain(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("body_of_fire")
		game.logSeen(self, "#FF8000#The raging fire around %s calms down and disappears.", self.name)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		self:removeTemporaryValue("resists", p.res)
		self:removeTemporaryValue("mana_regen", p.drain)
		return true
	end,
	info = function(self, t)
		local onhitdam = t.getFireDamageOnHit(self, t)
		local insightdam = t.getFireDamageInSight(self, t)
		local res = t.getResistance(self, t)
		local manadrain = t.getManaDrain(self, t)
		return ([[将 你 的 身 体 转 化 为 纯 净 的 火 焰， 增 加 你 %d%% 火 焰 抵 抗。 对 任 何 攻 击 你 的 怪 物 造 成 %0.2f 火 焰 伤 害 并 向 附 近 目 标 每 回 合 随 机 射 出 %d 个 缓 慢 移 动 的 火 焰 球， 每 个 火 球 造 成 %0.2f 火 焰 伤 害。 
		 当 此 技 能 激 活 时， 每 回 合 消 耗 %0.2f 法 力 值。 
		 受 法 术 强 度 影 响， 伤 害 和 火 焰 抵 抗 有 额 外 加 成。]]):
		format(res,onhitdam, math.floor(self:getTalentLevel(t)), insightdam,-manadrain)
	end,
}

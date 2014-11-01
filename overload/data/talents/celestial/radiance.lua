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

function radianceRadius(self)
	if self:hasEffect(self.EFF_RADIANCE_DIM) then
		return 1
	else
		return self:getTalentRadius(self:getTalentFromId(self.T_RADIANCE))
	end
end

newTalent{
	name = "Radiance",
	type = {"celestial/radiance", 1},
	mode = "passive",
	require = divi_req1,
	points = 5,
	radius = function(self, t) return self:combatTalentScale(t, 3, 7) end,
	getResist = function(self, t) return self:combatTalentLimit(t, 100, 25, 75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "radiance_aura", radianceRadius(self))
		self:talentTemporaryValue(p, "blind_immune", t.getResist(self, t) / 100)
	end,
	info = function(self, t)
		return ([[你 的 体 内 充 满 了 阳 光 ， 你 的 身 体  会 发 光 ，半 径 %d。
		 你 的 眼 睛 适 应 了 光 明 ， 获 得 %d%% 目 盲 免 疫 。
		 光 照 超 过 你 的 灯 具 时 取 代 之  ， 不 与 灯 具 叠 加 光 照 。
		]]):
		format(radianceRadius(self), t.getResist(self, t))
	end,
}

newTalent{
	name = "Illumination",
	type = {"celestial/radiance", 2},
	require = divi_req2,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return 15 + self:combatTalentSpellDamage(t, 1, 100) end,
	getDef = function(self, t) return 5 + self:combatTalentSpellDamage(t, 1, 35) end,
	callbackOnActBase = function(self, t)
		local radius = radianceRadius(self)
		local grids = core.fov.circle_grids(self.x, self.y, radius, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do local target = game.level.map(x, y, Map.ACTOR) if target and self ~= target then
			if (self:reactionToward(target) < 0) then
				target:setEffect(target.EFF_ILLUMINATION, 1, {power=t.getPower(self, t), def=t.getDef(self, t)})
				local ss = self:isTalentActive(self.T_SEARING_SIGHT)
				if ss then
					local dist = core.fov.distance(self.x, self.y, target.x, target.y) - 1
					local coeff = math.max(0.1, 1 - (0.1*dist)) -- 10% less damage per distance
					DamageType:get(DamageType.LIGHT).projector(self, target.x, target.y, DamageType.LIGHT, ss.dam * coeff)
					if ss.daze and rng.percent(ss.daze) and target:canBe("stun") then
						target:setEffect(target.EFF_DAZED, 3, {apply_power=self:combatSpellpower()})
					end
				end
		end
		end end end		
	end,
	info = function(self, t)
		return ([[你 的 光 辉 让 你 能 看 见 平 时 看 不 见 的 东 西 。
		 所 有 在 你 光 辉 范 围 内 的 敌 人 减 少 %d 点 潜 行 和 隐 身 强 度 ， 减 少 %d 闪 避 ， 同 时 不 可 见 带 来 的 闪 避 加 成 无 效 。 
		 效 果 受 法 强 加 成。]]):
		format(t.getPower(self, t), t.getDef(self, t))
	end,
}

-- This doesn't work well in practice.. Its powerful but it leads to cheesy gameplay, spams combat logs, maybe even lags
-- It can stay like this for now but may be worth making better
newTalent{
	name = "Searing Sight",
	type = {"celestial/radiance",3},
	require = divi_req3,
	mode = "sustained",
	points = 5,
	cooldown = 15,
	range = function(self) return radianceRadius(self) end,
	tactical = { ATTACKAREA = {LIGHT=1} },
	sustain_positive = 10,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 35) end,
	getDaze = function(self, t) return self:combatTalentLimit(t, 35, 5, 20) end,
	updateParticle = function(self, t)
		local p = self:isTalentActive(self.T_SEARING_SIGHT)
		if not p then return end
		self:removeParticles(p.particle)
		p.particle = self:addParticles(Particles.new("circle", 1, {toback=true, oversize=1, a=20, appear=4, speed=-0.2, img="radiance_circle", radius=self:getTalentRange(t)}))
	end,
	activate = function(self, t)
		local daze = nil
		if self:getTalentLevel(t) >= 4 then daze = t.getDaze(self, t) end
		return {
			particle = self:addParticles(Particles.new("circle", 1, {toback=true, oversize=1, a=20, appear=4, speed=-0.2, img="radiance_circle", radius=self:getTalentRange(t)})),
			dam=t.getDamage(self, t),
			daze=daze,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		return ([[ 你 的 光 辉 变 得 如 此 强 烈 ， 所 有 受 到 照 射 的 敌 人 都 会 被 灼 伤 ， 受 到 %0.1f 点 光 系 伤 害 ( 随 距 离 减 少)。
		 等 级 4 时， 有 %d%% 几 率 眩 晕 目 标 3 回 合。
		 伤 害 受 法 强 加 成 。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getDaze(self, t))
	end,
}

newTalent{
	name = "Judgement",
	type = {"celestial/radiance", 4},
	require = divi_req4,
	points = 5,
	cooldown = 25,
	positive = 20,
	tactical = { ATTACKAREA = {LIGHT = 2} },
	radius = function(self) return radianceRadius(self) end,
	range = function(self) return radianceRadius(self) end,
	getMoveDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 40) end,
	getExplosionDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 150) end,
	action = function(self, t)

		local tg = {type="ball", range=self:getTalentRange(t), radius = self:getTalentRadius(t), selffire = false, friendlyfire = false, talent=t}


		local movedam = self:spellCrit(t.getMoveDamage(self, t))
		local dam = self:spellCrit(t.getExplosionDamage(self, t))

		self:project(tg, self.x, self.y, function(tx, ty)
			local target = game.level.map(tx, ty, engine.Map.ACTOR)
			if not target then return end

			local proj = require("mod.class.Projectile"):makeHoming(
				self,
				{particle="bolt_light", trail="lighttrail"},
				{speed=1, name="Judgement", dam=dam, movedam=movedam},
				target,
				self:getTalentRange(t),
				function(self, src)
					local DT = require("engine.DamageType")
					DT:get(DT.JUDGEMENT).projector(src, self.x, self.y, DT.JUDGEMENT, self.def.movedam)
				end,
				function(self, src, target)
					local DT = require("engine.DamageType")
					local grids = src:project({type="ball", radius=1, x=self.x, y=self.y}, self.x, self.y, DT.JUDGEMENT, self.def.dam)	
					game.level.map:particleEmitter(self.x, self.y, 1, "sunburst", {radius=1, grids=grids, tx=self.x, ty=self.y})
					game:playSoundNear(self, "talents/lightning")
				end
			)
			game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
		end)
		
		-- EFF_RADIANCE_DIM does nothing by itself its just used by radianceRadius
		self:setEffect(self.EFF_RADIANCE_DIM, 5, {})

		return true
	end,
	info = function(self, t)
		return ([[向 光 辉 覆 盖 的 敌 人 发 射 光 明 球 ， 每 个 球 会 缓 慢 移 动 ， 直 到 命 中 ， 同 时 对 路 径 上 的 障 碍 物 造  成%d 点 光 系 伤 害。
		 当 击 中 目 标 时 ， 球 体 会 爆 炸 ， 造 成 %d 点 光 系 伤 害 ， 同 时 50%% 的 伤 害 会 治 疗 你 。
		 使 用 这 项 技 能 会 让 光 辉 照 明 范 围 减 少 至 1 ， 持 续 5 回 合 。]]):
		format(t.getMoveDamage(self, t), t.getExplosionDamage(self, t))
	end,
}


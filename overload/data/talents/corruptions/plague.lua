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
	name = "Virulent Disease",
	type = {"corruption/plague", 1},
	require = corrs_req1,
	points = 5,
	vim = 8,
	cooldown = 3,
	random_ego = "attack",
	tactical = { ATTACK = {BLIGHT = 2} },
	requires_target = true,
	no_energy = true,
	range = function(self, t) return 5 end, -- Instant cast should not do thousands of damage at long range.  This is still too powerful, though
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local diseases = {{self.EFF_WEAKNESS_DISEASE, "str"}, {self.EFF_ROTTING_DISEASE, "con"}, {self.EFF_DECREPITUDE_DISEASE, "dex"}}
		local disease = rng.table(diseases)

		-- Try to rot !
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			if target:canBe("disease") then
				local str, dex, con = not target:hasEffect(self.EFF_WEAKNESS_DISEASE) and target:getStr() or 0, not target:hasEffect(self.EFF_DECREPITUDE_DISEASE) and target:getDex() or 0, not target:hasEffect(self.EFF_ROTTING_DISEASE) and target:getCon() or 0

				if str >= dex and str >= con then
					disease = {self.EFF_WEAKNESS_DISEASE, "str"}
				elseif dex >= str and dex >= con then
					disease = {self.EFF_DECREPITUDE_DISEASE, "dex"}
				elseif con > 0 then
					disease = {self.EFF_ROTTING_DISEASE, "con"}
				end

				target:setEffect(disease[1], 6, {src=self, dam=self:spellCrit(7 + self:combatTalentSpellDamage(t, 6, 45)), [disease[2]]=self:combatTalentSpellDamage(t, 5, 35), apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
			game.level.map:particleEmitter(px, py, 1, "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		return ([[射 出 一 个 疾 病 之 球， 目 标 会 随 机 感 染 一 种 疾 病， 每 回 合 受 到 %0.2f 枯 萎 伤 害， 持 续 6 回 合。 同 时， 减 少 目 标 某 种 物 理 属 性（ 力 量、 体 质 或 敏 捷） %d 点。 三 种 疾 病 可 叠 加。 
		 剧 毒 瘟 疫 通 常 会 使 目 标 感 染 其 目 前 所 没 有 的 一 种 疾 病， 并 且 会 使 目 标 感 染 大 幅 度 衰 竭 其 主 属 性 的 疾 病。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, 7 + self:combatTalentSpellDamage(t, 6, 65)), self:combatTalentSpellDamage(t, 5, 35))
	end,
}

newTalent{
	name = "Cyst Burst",
	type = {"corruption/plague", 2},
	require = corrs_req2,
	points = 5,
	vim = 18,
	cooldown = 9,
	range = 7,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	tactical = { ATTACK = function(self, t, target)
		-- Count the number of diseases on the target
		local val = 0
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.disease then
				val = val + 1
			end
		end
		return val
	end },
	requires_target = true,
	target = function(self, t)
		-- Target trying to combine the bolt and the ball disease spread
		return {type="ballbolt", radius=self:getTalentRadius(t), range=self:getTalentRange(t)}
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 15, 85))
		local diseases = {}

		-- Try to rot !
		local source = nil
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.subtype.disease then
					diseases[#diseases+1] = {id=eff_id, params=p}
				end
			end

			if #diseases > 0 then
				DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, dam * #diseases)
				game.level.map:particleEmitter(px, py, 1, "slime")
			end
			source = target
		end)

		if #diseases > 0 then
			self:project({type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t)}, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target or target == source or target == self or (self:reactionToward(target) >= 0) then return end

				for _, disease in ipairs(diseases) do
					if disease.id == self.EFF_WEAKNESS_DISEASE or disease.id == self.EFF_DECREPITUDE_DISEASE or disease.id == self.EFF_ROTTING_DISEASE or disease.id == self.EFF_EPIDEMIC then
						target:setEffect(disease.id, 6, {src=self, dam=disease.params.dam, str=disease.params.str, dex=disease.params.dex, con=disease.params.con, heal_factor=disease.params.heal_factor, resist=disease.params.resist, apply_power=self:combatSpellpower()})
					end
				end
			end)
			game.level.map:particleEmitter(x, y,self:getTalentRadius(t), "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=self:getTalentRadius(t)})
		end
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		return ([[使 目 标 的 疾 病 爆 发， 每 种 疾 病 造 成 %0.2f 枯 萎 伤 害。 
		 同 时 会 向 %d 码 半 径 范 围 内 任 意 敌 人 散 播 衰 老、 虚 弱、 腐 烂 或 传 染 性 疾 病。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 85)), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Catalepsy",
	type = {"corruption/plague", 3},
	require = corrs_req3,
	points = 5,
	vim = 20,
	cooldown = 15,
	range = 8,
	tactical = { DISABLE = function(self, t, target)
		-- Make sure the target has a disease
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.disease then
				return 2
			end
		end
	end },
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return (100 + self:combatTalentSpellDamage(t, 0, 50)) / 100 end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.7)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=t.getRadius(self, t)}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local source = nil
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			-- List all diseases
			local diseases = {}
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.subtype.disease then
					diseases[#diseases+1] = {id=eff_id, params=p}
				end
			end
			-- Make them EXPLODE !!!
			for i, d in ipairs(diseases) do
				target:removeEffect(d.id)
				DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, d.params.dam * d.params.dur * t.getDamage(self, t))
			end

			if #diseases > 0 and target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatSpellpower()})
			elseif #diseases > 0 then
				game.logSeen(target, "%s resists the stun!", target.name:capitalize())
			end
		end)
		game.level.map:particleEmitter(x, y, t.getRadius(self, t), "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="blight_circle", radius=t.getRadius(self, t)})
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[所 有 %d 码 球 形 范 围 内 感 染 疾 病 的 目 标 进 入 僵 硬 状 态， 震 慑 它 们 %d 回 合 并 立 即 爆 发 %d%% 剩 余 所 有 疾 病 伤 害。]]):
		format(radius, duration, damage * 100)
	end,
}

newTalent{
	name = "Epidemic",
	type = {"corruption/plague", 4},
	require = corrs_req4,
	points = 5,
	vim = 20,
	cooldown = 13,
	range = 8,
	radius = 2,
	tactical = { ATTACK = {BLIGHT = 2} },
	requires_target = true,
	healloss = function(self,t) return self:combatTalentLimit(t, 100, 44, 60) end, -- Limit < 100%
	disfact = function(self,t) return self:combatTalentLimit(t, 100, 36, 60) end, -- Limit < 100%
	-- Desease spreading handled in mod.data.damage_types.lua for BLIGHT
	spreadFactor = function(self, t) return self:combatTalentLimit(t, 0.05, 0.35, 0.17) end, -- Based on previous formula: 256 damage gave 100% chance (1500 hps assumed)
	
	do_spread = function(self, t, carrier, dam)
		if not dam or type(dam) ~= "number" then return end
		if not rng.percent(100*dam/(t.spreadFactor(self, t)*carrier.max_life)) then return end
		game.logSeen(self, "The diseases of %s spread!", self.name)
		-- List all diseases
		local diseases = {}
		for eff_id, p in pairs(carrier.tmp) do
			local e = carrier.tempeffect_def[eff_id]
			if e.subtype.disease then
				diseases[#diseases+1] = {id=eff_id, params=p}
			end
		end

		if #diseases == 0 then return end
		self:project({type="ball", radius=self:getTalentRadius(t)}, carrier.x, carrier.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target or target == carrier or target == self then return end

			local disease = rng.table(diseases)
			local params = disease.params
			params.src = self
			local disease_spread = {
				src=self, dam=disease.params.dam, str=disease.params.str, dex=disease.params.dex, con=disease.params.con, apply_power=self:combatSpellpower(),
				heal_factor=disease.params.heal_factor, burst=disease.params.burst, rot_timer=disease.params.rot_timer, resist=disease.params.resist, make_ghoul=disease.params.make_ghoul,
			}
			if target:canBe("disease") then
				target:setEffect(disease.id, 6, disease_spread)
			else
				game.logSeen(target, "%s resists the disease!", target.name:capitalize())
			end
			game.level.map:particleEmitter(px, py, 1, "slime")
		end)
	end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		-- Try to rot !
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target or (self:reactionToward(target) >= 0) then return end
			target:setEffect(self.EFF_EPIDEMIC, 6, {src=self, dam=self:spellCrit(self:combatTalentSpellDamage(t, 15, 70)), heal_factor=t.healloss(self,t), resist=t.disfact(self,t), apply_power=self:combatSpellpower()})
			game.level.map:particleEmitter(px, py, 1, "circle", {oversize=0.7, a=200, limit_life=8, appear=8, speed=-2, img="disease_circle", radius=0})
		end)
		game:playSoundNear(self, "talents/slime")

		return true
	end,
	info = function(self, t)
		return ([[使 目 标 感 染 1 种 传 染 性 极 强 的 疾 病， 每 回 合 造 成 %0.2f 伤 害， 持 续 6 回 合。 
		 如 果 目 标 受 到 非 疾 病 造 成 的 任 何 枯 萎 伤 害， 则 感 染 者 会 自 动 向 周 围 2 码 球 形 范 围 目 标 散 播 一 种 随 机 疾 病。
		 疾 病 传 播 概 率 受 造 成 的 枯 萎 伤 害 影 响， 且 当 枯 萎 伤 害 超 过 最 大 生 命 值 35%% 时 必 定 传 播 。
		 任 何 感 染 疾 病 单 位 同 时 会 减 少 %d%% 治 疗 效 果 和 %d%% 疾 病 免 疫。 
		 传 染 病 是 一 种 极 强 的 疾 病， 以 至 于 它 可 以 完 全 忽 略 目 标 的 疾 病 免 疫。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成； 受 枯 萎 伤 害 影 响， 传 染 疾 病 的 概 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 70)), 40 + self:getTalentLevel(t) * 4, 30 + self:getTalentLevel(t) * 6)
	end,
}

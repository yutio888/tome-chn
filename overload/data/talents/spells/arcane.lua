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
	name = "Arcane Power",
	type = {"spell/arcane", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 25,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	use_only_arcane = 1,
	getSpellpowerIncrease = function(self, t) return self:combatTalentScale(t, 5, 20, 0.75) end,
	getArcaneResist = function(self, t) return 5 + self:combatTalentSpellDamage(t, 10, 500) / 18 end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		return {
			power = self:addTemporaryValue("combat_spellpower", t.getSpellpowerIncrease(self, t)),
			res = self:addTemporaryValue("resists", {[DamageType.ARCANE] = t.getArcaneResist(self, t)}),
			particle = self:addParticles(Particles.new("arcane_power", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_spellpower", p.power)
		self:removeTemporaryValue("resists", p.res)
		return true
	end,
	info = function(self, t)
		return ([[你 对 魔 法 的 理 解 使 你 进 入 精 神 集 中 状 态， 增 加 %d 点 法 术 强 度 和 %d%% 奥 术 抗 性 。]]):
		format(t.getSpellpowerIncrease(self, t), t.getArcaneResist(self, t))
	end,
}

newTalent{
	name = "Manathrust",
	type = {"spell/arcane", 2},
	require = spells_req2,
	points = 5,
	random_ego = "attack",
	mana = 10,
	cooldown = 3,
	use_only_arcane = 1,
	tactical = { ATTACK = { ARCANE = 2 } },
	range = 10,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 3 then return true else return false end end,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		if self:getTalentLevel(t) >= 3 then tg.type = "beam" end
		return tg
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 230) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ARCANE, self:spellCrit(t.getDamage(self, t)), nil)
		local _ _, x, y = self:canProject(tg, x, y)
		if tg.type == "beam" then
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "mana_beam", {tx=x-self.x, ty=y-self.y})
		else
			game.level.map:particleEmitter(x, y, 1, "manathrust")
		end
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 出 一 个 强 大 的 奥 术 之 球 对 目 标 造 成 %0.2f 奥 术 伤 害。 
		 在 等 级 3 时， 它 会 有 穿 透 效 果。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, damage))
	end,
}

newTalent{
	name = "Arcane Vortex",
	type = {"spell/arcane", 3},
	require = spells_req3,
	points = 5,
	mana = 35,
	cooldown = 12,
	use_only_arcane = 1,
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	tactical = { ATTACK = { ARCANE = 2 } },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 340) / 6 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if not target then return nil end

		target:setEffect(target.EFF_ARCANE_VORTEX, 6, {src=self, dam=t.getDamage(self, t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[在 目 标 身 上 放 置 一 个 持 续 6 回 合 的 奥 术 漩 涡。 
		 每 回 合， 奥 术 漩 涡 会 随 机 寻 找 视 野 内 的 另 一 个 敌 人， 并 且 释 放 一 次 奥 术 射 线， 对 一 条 线 上 的 所 有 敌 人 造 成 %0.2f 奥 术 伤 害。 
		 若 没 有 发 现 其 他 敌 人， 则 目 标 会 承 受 150％ 额 外 奥 术 伤 害。 
		 若 目 标 死 亡， 则 奥 术 漩 涡 爆 炸 并 释 放 所 有 的 剩 余 奥 术 伤 害， 在 2 码 半 径 范 围 内 形 成 奥 术 爆 炸。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

newTalent{
	name = "Disruption Shield",
	type = {"spell/arcane",4},
	require = spells_req4, no_sustain_autoreset = true,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_mana = 10,
	use_only_arcane = 1,
	no_energy = true,
	tactical = { MANA = 3, DEFEND = 2, },
	getManaRatio = function(self, t) return math.max(3 - self:combatTalentSpellDamage(t, 10, 200) / 100, 0.5) * (100 - util.bound(self:attr("shield_factor") or 0, 0, 70)) / 100 end,
	getArcaneResist = function(self, t) return 50 + self:combatTalentSpellDamage(t, 10, 500) / 10 end,
	-- Note: effects handled in mod.class.Actor:onTakeHit function
	getMaxDamage = function(self, t) -- Compute damage limit
		local max_dam = self.max_mana
		for i, k in pairs(self.sustain_talents) do -- Add up sustain costs to get total mana pool size
			max_dam = max_dam + (tonumber(self.talents_def[i].sustain_mana) or 0)
		end
		return max_dam * 2 -- Maximum damage is 2x total mana pool
	end,
	on_pre_use = function(self, t) return (self:getMana() / self:getMaxMana() <= 0.25) or self:hasEffect(self.EFF_AETHER_AVATAR) or self:attr("disruption_shield") end,
	explode = function(self, t, dam)
		game.logSeen(self, "#VIOLET#%s's disruption shield collapses and then explodes in a powerful manastorm!", self.name:capitalize())
		dam = math.min(dam, t.getMaxDamage(self, t)) -- Damage cap
		-- Add a lasting map effect
		self:setEffect(self.EFF_ARCANE_STORM, 10, {power=t.getArcaneResist(self, t)})
		game.level.map:addEffect(self,
			self.x, self.y, 10,
			DamageType.ARCANE, dam / 10,
			3,
			5, nil,
			{type="arcanestorm", only_one=true},
			function(e) e.x = e.src.x e.y = e.src.y return true end,
			true
		)
	end,
	damage_feedback = function(self, t, p, src)
		if p.particle and p.particle._shader and p.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			p.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			p.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	iconOverlay = function(self, t, p)
		local val = self.disruption_shield_absorb or 0
		if val <= 0 then return "" end
		local fnt = "buff_font_small"
		if val >= 1000 then fnt = "buff_font_smaller" end
		return tostring(math.ceil(val)), fnt
	end,
	activate = function(self, t)
		local power = t.getManaRatio(self, t)
		self.disruption_shield_absorb = 0
		game:playSoundNear(self, "talents/arcane")

		local particle
		if core.shader.active(4) then
--			particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="shield6"}, {type="shield", ellipsoidalFactor=1.05, shieldIntensity=0.1, time_factor=-2500, color={0.8, 0.1, 1.0}, impact_color = {0, 1, 0}, impact_time=800}))
			particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1, scrollingSpeed=-1, time_factor=12000, bubbleColor={0.8, 0.1, 1.0, 1.0}, auraColor={0.85, 0.3, 1.0, 1}}))
		else
			particle = self:addParticles(Particles.new("disruption_shield", 1))
		end

		return {
			shield = self:addTemporaryValue("disruption_shield", power),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("disruption_shield", p.shield)
		self.disruption_shield_absorb = nil
		return true
	end,
	info = function(self, t)
		return ([[使 周 身 围 绕 着 奥 术 能 量， 阻 止 任 何 伤 害 并 回 复 法 力 值。 
		 每 受 到 1 点 伤 害 得 到 %0.2f 点 法 力 值（ 奥 术 护 盾 影 响 此 系 数）。 
		 如 果 你 的 法 力 值 因 为 该 护 盾 而 回 复 过 多， 则 它 会 中 断 并 在 3 码 半 径 范 围 内 释 放 一 股 持 续 10 回 合 的 致 命 奥 术 风 暴， 每 回 合 造 成 10%% 已 吸 收 伤 害 值, 最 多 造 成 共 计 %d 点 伤 害。  
		 当 奥 术 风 暴 激 活 时， 你 同 样 会 增 加 %d%% 奥 术 抵 抗。 
		 只 有 在 法 力 值 低 于 25％ 时 方 可 使 用。 
		 受 法 术 强 度 影 响， 每 点 伤 害 可 回 复 更 少 法 力 值。]]):
		format(t.getManaRatio(self, t), t.getMaxDamage(self, t), t.getArcaneResist(self, t))
	end,
}

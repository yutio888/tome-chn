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
	name = "Bone Spear",
	type = {"corruption/bone", 1},
	require = corrs_req1,
	points = 5,
	vim = 13,
	cooldown = 4,
	range = 10,
	random_ego = "attack",
	tactical = { ATTACK = {PHYSICAL = 2} },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.PHYSICAL, self:spellCrit(self:combatTalentSpellDamage(t, 20, 200)))
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.range, "bone_spear", {tx=x - self.x, ty=y - self.y})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[对 一 条 线 上 的 目 标 释 放 1 根 骨 矛， 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 20, 200)))
	end,
}

newTalent{
	name = "Bone Grab",
	type = {"corruption/bone", 2},
	require = corrs_req2,
	points = 5,
	vim = 28,
	cooldown = 15,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 4, 9)) end,
	tactical = { DISABLE = 1, CLOSEIN = 3 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 5, 140))

		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			target:pull(self.x, self.y, tg.range)

			DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, dam)
			if target:canBe("pin") then
				target:setEffect(target.EFF_BONE_GRAB, t.getDuration(self, t), {apply_power=self:combatSpellpower()})
			else
				game.logSeen(target, "%s resists the bone!", target.name:capitalize())
			end
		end)
		game:playSoundNear(self, "talents/arcane")

		return true
	end,
	info = function(self, t)
		return ([[抓 住 目 标 并 传 送 到 你 的 身 边， 从 地 上 冒 出 一 根 骨 刺 将 其 定 在 那， 持 续 %d 回 合。 
		 骨 刺 同 时 也 会 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 5, 140)))
	end,
}

newTalent{
	name = "Bone Nova",
	type = {"corruption/bone", 3},
	require = corrs_req3,
	points = 5,
	vim = 25,
	cooldown = 12,
	tactical = { ATTACKAREA = {PHYSICAL = 2} },
	random_ego = "attack",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.PHYSICAL, self:spellCrit(self:combatTalentSpellDamage(t, 8, 180)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "circle", {oversize=1.1, a=255, limit_life=8, grow=true, speed=0, img="bone_nova", radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		return ([[向 所 有 方 向 射 出 骨 矛， 对 %d 码 范 围 内 所 有 敌 人 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 8, 180)))
	end,
}

newTalent{
	name = "Bone Shield",
	type = {"corruption/bone", 4},
	points = 5,
	mode = "sustained", no_sustain_autoreset = true,
	require = corrs_req4,
	cooldown = 30,
	sustain_vim = 50,
	tactical = { DEFEND = 4 },
	direct_hit = true,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	getRegen = function(self, t) return math.max(math.floor(30 / t.getNb(self, t)), 3) end,
	callbackOnRest = function(self, t)
		local nb = t.getNb(self, t)
		local p = self.sustain_talents[t.id]
		if not p or p.nb < nb then return true end
	end,
	callbackOnActBase = function(self, t)
		local p = self.sustain_talents[t.id]
		p.next_regen = (p.next_regen or 1) - 1
		if p.next_regen <= 0 then
			p.next_regen = p.between_regens or 10

			if p.nb < t.getNb(self, t) then
				p.nb = p.nb + 1
				if p.adv_gfx then
					if p.particles[1] and p.particles[1]._shader and p.particles[1]._shader.shad then
						p.particles[1]._shader.shad:resetClean()
						p.particles[1]._shader:setResetUniform("chargesCount", util.bound(p.nb, 0, 10))
						p.particles[1].shader.chargesCount = util.bound(p.nb, 0, 10)
					end
				else
					p.particles[#p.particles+1] = self:addParticles(Particles.new("bone_shield", 1))
				end
				game.logSeen(self, "A part of %s's bone shield regenerates.", self.name)
			end
		end
	end,
	absorb = function(self, t, p)
		if not p.nb or p.nb <= 0 then return end

		p.nb = p.nb - 1
		if p.adv_gfx then
			if p.particles[1] and p.particles[1]._shader and p.particles[1]._shader.shad then
				p.particles[1]._shader.shad:resetClean()
				p.particles[1]._shader:setResetUniform("chargesCount", util.bound(p.nb, 0, 10))
				p.particles[1].shader.chargesCount = util.bound(p.nb, 0, 10)
			end
		else
			local pid = table.remove(p.particles)
			self:removeParticles(pid)
		end

		game.logPlayer(self, "Your bone shield absorbs the damage!")
		return true
	end,
	activate = function(self, t)
		local nb = t.getNb(self, t)

		local adv_gfx = core.shader.allow("adv") and true or false
		local ps = {}
		if adv_gfx then
			ps[1] = self:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, a=0.5, rotation=0, radius=1.5, img="bone_shield"}, {type="boneshield"}))
			ps[1]._shader.shad:resetClean()
			ps[1]._shader:setResetUniform("chargesCount", util.bound(nb, 0, 10))
			ps[1].shader.chargesCount = util.bound(nb, 0, 10)
		else
			for i = 1, nb do ps[#ps+1] = self:addParticles(Particles.new("bone_shield", 1)) end
		end

		game:playSoundNear(self, "talents/spell_generic2")
		return {
			adv_gfx = adv_gfx,
			particles = ps,
			nb = nb,
			next_regen = t.getRegen(self, t),
			between_regens = t.getRegen(self, t),
		}
	end,
	deactivate = function(self, t, p)
		for i, particle in ipairs(p.particles) do self:removeParticles(particle) end
		return true
	end,
	info = function(self, t)
		return ([[制 造 1 圈 白 骨 护 盾 围 绕 你。 每 个 护 盾 能 完 全 吸 收 1 次 攻 击。 
		 当 前 最 多 可 制 造 %d 个 护 盾。
		 每 %d 个 回 合 会 自 动 补 充 一 个 骨 盾。 ]]):
		format(t.getNb(self, t), t.getRegen(self, t))
	end,
}

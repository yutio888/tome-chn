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
	name = "Illuminate",
	type = {"spell/phantasm",1},
	require = spells_req1,
	random_ego = "utility",
	points = 5,
	mana = 5,
	cooldown = 14,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	tactical = { DISABLE = function(self, t)
			if self:getTalentLevel(t) >= 3 then
				return 2
			end
			return 0
		end,
		ATTACKAREA = function(self, t)
			if self:getTalentLevel(t) >= 4 then
				return { LIGHT = 2 }
			end
			return 0
		end,
	},
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 28, 180) end,
	getBlindPower = function(self, t) if self:getTalentLevel(t) >= 5 then return 4 else return 3 end end,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), selffire=true, radius=self:getTalentRadius(t), talent=t}
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y, max_alpha=80})
		if self:getTalentLevel(t) >= 3 then
			tg.selffire= false
			self:project(tg, self.x, self.y, DamageType.BLIND, t.getBlindPower(self, t))
		end
		if self:getTalentLevel(t) >= 4 then
			tg.selffire= false
			self:project(tg, self.x, self.y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local turn = t.getBlindPower(self, t)
		local dam = t.getDamage(self, t)
		return ([[制 造 一 个 发 光 的 球 体， 照 亮 %d 码 半 径 范 围 区 域。 
		 在 等 级 3 时， 它 同 时 可 以 致 盲 看 到 它 的 人（ 施 法 者 除 外） %d 回 合。 
		 在 等 级 4 时， 它 会 造 成 %0.2f 点 光 系 伤 害。]]):
		format(radius, turn, damDesc(self, DamageType.LIGHT, dam))
	end,
}

newTalent{
	name = "Blur Sight",
	type = {"spell/phantasm", 2},
	mode = "sustained",
	require = spells_req2,
	points = 5,
	sustain_mana = 30,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getDefense = function(self, t) return self:combatScale(self:getTalentLevel(t)*self:combatSpellpower(), 0, 0, 28.6, 267, 0.75) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			particle = self:addParticles(Particles.new("phantasm_shield", 1)),
			def = self:addTemporaryValue("combat_def", t.getDefense(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("combat_def", p.def)
		return true
	end,
	info = function(self, t)
		local defence = t.getDefense(self, t)
		return ([[施 法 者 的 形 象 变 的 模 糊 不 清， 增 加 %d 点 闪 避。 
		 受 法 术 强 度 影 响， 闪 避 有 额 外 加 成。]]):
		format(defence)
	end,
}

newTalent{
	name = "Phantasmal Shield",
	type = {"spell/phantasm", 3},
	mode = "sustained",
	require = spells_req3,
	points = 5,
	sustain_mana = 20,
	cooldown = 10,
	tactical = { BUFF = 2 },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 120) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			particle = self:addParticles(Particles.new("phantasm_shield", 1)),
			onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.LIGHT]=t.getDamage(self, t)}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("on_melee_hit", p.onhit)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[施 法 者 被 幻 象 护 盾 所 包 围。 若 你 受 到 近 战 打 击， 此 护 盾 会 对 攻 击 者 造 成 %d 点 光 系 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage))
	end,
}

newTalent{
	name = "Invisibility",
	type = {"spell/phantasm", 4},
	mode = "sustained",
	require = spells_req4,
	points = 5,
	sustain_mana = 150,
	cooldown = 30,
	tactical = { ESCAPE = 2, DEFEND = 2 },
	getInvisibilityPower = function(self, t) return self:combatTalentSpellDamage(t, 10, 50) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local ret = {
			invisible = self:addTemporaryValue("invisible", t.getInvisibilityPower(self, t)),
			invisible_damage_penalty = self:addTemporaryValue("invisible_damage_penalty", 0.7),
			drain = self:addTemporaryValue("mana_regen", -2),
		}
		if not self.shader then
			ret.set_shader = true
			self.shader = "invis_edge"
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
		self:resetCanSeeCacheOf()
		return ret
	end,
	deactivate = function(self, t, p)
		if p.set_shader then
			self.shader = nil
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
		self:removeTemporaryValue("invisible", p.invisible)
		self:removeTemporaryValue("invisible_damage_penalty", p.invisible_damage_penalty)
		self:removeTemporaryValue("mana_regen", p.drain)
		self:resetCanSeeCacheOf()
		return true
	end,
	info = function(self, t)
		local invisi = t.getInvisibilityPower(self, t)
		return ([[施 法 者 从 视 线 中 淡 出， 额 外 增 加 %d 点 隐 形 强 度。 
		 注 意： 你 必 须 取 下 装 备 中 的 灯 具， 否 则 你 仍 然 会 被 轻 易 发 现。 
		 由 于 你 变 的 不 可 见， 你 脱 离 了 相 位 现 实。 你 的 所 有 攻 击 降 低 70%% 伤 害。 
		 当 此 技 能 激 活 时， 它 会 持 续 消 耗 你 的 法 力（ 2 法 力 / 回 合）。 
		 受 法 术 强 度 影 响， 隐 形 强 度 有 额 外 加 成。]]):
		format(invisi)
	end,
}

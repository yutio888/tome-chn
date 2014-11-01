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
	name = "Blood Spray",
	type = {"corruption/blood", 1},
	require = corrs_req1,
	points = 5,
	cooldown = 7,
	vim = 24,
	tactical = { ATTACKAREA = {BLIGHT = 2} },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getChance = function(self, t) return self:combatTalentLimit(t, 100, 30, 70) end, -- Limit < 100%
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.CORRUPTED_BLOOD, {
			dam = self:spellCrit(self:combatTalentSpellDamage(t, 10, 190)),
			disease_chance = t.getChance(self, t),
			disease_dam = self:spellCrit(self:combatTalentSpellDamage(t, 10, 220)) / 6,
			disease_power = self:combatTalentSpellDamage(t, 10, 20),
			dur = 6,
		})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_blood", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[你 从 自 身 射 出 堕 落 之 血， 对 前 方 %d 码 半 径 锥 形 范 围 敌 人 造 成 %0.2f 枯 萎 伤 害。 
		 每 个 受 影 响 的 单 位 有 %d%% 概 率 感 染 1 种 随 机 疾 病， 受 到 %0.2f 枯 萎 伤 害， 并 且 随 机 弱 化 目 标 体 质、 力 量 和 敏 捷 中 的 一 项 属 性， 持 续 6 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 190)), t.getChance(self, t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 220)))
	end,
}

newTalent{
	name = "Blood Grasp",
	type = {"corruption/blood", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 5,
	vim = 20,
	range = 10,
	proj_speed = 20,
	tactical = { ATTACK = {BLIGHT = 2}, HEAL = 2 },
	requires_target = true,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_blood"}}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.DRAINLIFE, {dam=self:spellCrit(self:combatTalentSpellDamage(t, 10, 290)), healfactor=0.5}, {type="blood"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[释 放 一 个 堕 落 血 球， 造 成 %0.2f 枯 萎 伤 害 并 恢 复 你 一 半 伤 害 值 的 生 命。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 290)))
	end,
}

newTalent{
	name = "Blood Boil",
	type = {"corruption/blood", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 12,
	vim = 30,
	tactical = { ATTACKAREA = {BLIGHT = 2}, DISABLE = 2 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.BLOOD_BOIL, self:spellCrit(self:combatTalentSpellDamage(t, 28, 190)))
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "circle", {oversize=1, a=180, appear=8, limit_life=8, speed=-3, img="blood_circle", radius=tg.radius})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[使 你 周 围 %d 码 半 径 范 围 内 的 敌 人 鲜 血 沸 腾， 造 成 %0.2f 枯 萎 伤 害 并 减 少 目 标 20%% 速 度。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 190)))
	end,
}

newTalent{
	name = "Blood Fury",
	type = {"corruption/blood", 4},
	mode = "sustained",
	require = corrs_req4,
	points = 5,
	sustain_vim = 60,
	cooldown = 30,
	tactical = { BUFF = 2 },
	on_crit = function(self, t)
		self:setEffect(self.EFF_BLOOD_FURY, 5, {power=self:combatTalentSpellDamage(t, 10, 30)})
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {
			per = self:addTemporaryValue("combat_spellcrit", self:combatTalentSpellDamage(t, 10, 14)),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_spellcrit", p.per)
		return true
	end,
	info = function(self, t)
		return ([[专 注 于 你 带 来 的 腐 蚀， 提 高 你 %d%% 法 术 暴 击 率。 
		 每 当 你 的 法 术 打 出 暴 击 时， 你 进 入 嗜 血 状 态 5 回 合， 增 加 你 %d%% 枯 萎 和 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 暴 击 率 和 伤 害 有 额 外 加 成。]]):
		format(self:combatTalentSpellDamage(t, 10, 14), self:combatTalentSpellDamage(t, 10, 30))
	end,
}

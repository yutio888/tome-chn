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
	name = "Circle of Shifting Shadows",
	type = {"celestial/circles", 1},
	require = divi_req_high1,
	points = 5,
	cooldown = 20,
	negative = 10,
	no_energy = true,
	tactical = { DEFEND = 2, ATTACKAREA = {DARKNESS = 1} },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 30) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.SHIFTINGSHADOWS, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, oversize=0, img="darkness_celestial_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/darkness_effect.png"},
			nil, self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 创 造 一 个 %d 码 半 径 范 围 的 阵 法， 它 会 提 高 你 %d 近 身 闪 避 并 对 周 围 目 标 造 成 %0.2f 暗 影 伤 害。 
		 阵 法 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。  ]]):
		format(radius, damage, (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

newTalent{
	name = "Circle of Blazing Light",
	type = {"celestial/circles", 2},
	require = divi_req_high2,
	points = 5,
	cooldown = 20,
	positive = 10,
	no_energy = true,
	tactical = { DEFEND = 2, ATTACKAREA = {FIRE = 0.5, LIGHT = 0.5} },
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 2, 15) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		local radius = self:getTalentRadius(t)
		local tg = {type="ball", range=0, selffire=true, radius=radius, talent=t}
		self:project(tg, self.x, self.y, DamageType.LITE, 1)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.BLAZINGLIGHT, self:spellCrit(t.getDamage(self, t)),
			radius,
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, img="sun_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/sunlight_effect.png"},
			nil, self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 的 法 阵， 它 会 照 亮 范 围 区 域， 每 回 合 增 加 %d 正 能 量 并 造 成 %0.2f 光 系 伤 害 和 %0.2f 火 焰 伤 害。 
		 阵 法 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(radius, 1 + (damage / 4), (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.FIRE, damage)), duration)
	end,
}

newTalent{
	name = "Circle of Sanctity",
	type = {"celestial/circles", 3},
	require = divi_req_high3,
	points = 5,
	cooldown = 20,
	positive = 10,
	negative = 10,
	no_energy = true,
	tactical = { DEFEND = 2, ATTACKAREA = 1 },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.SANCTITY, 1,
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, img="sun_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/sunlight_effect.png"},
			nil, self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 范 围 的 法 阵， 当 你 在 法 阵 内， 它 会 使 你 免 疫 沉 默 效 果 并 沉 默 此 范 围 内 的 敌 人。 
		 阵 法 持 续 %d 回 合。]]):
		format(radius, duration)
	end,
}

newTalent{
	name = "Circle of Warding",
	type = {"celestial/circles", 4},
	require = divi_req_high4,
	points = 5,
	cooldown = 20,
	positive = 10,
	negative = 10,
	no_energy = true,
	tactical = { DEFEND = 2, ATTACKAREA = {LIGHT = 0.5, DARKNESS = 0.5} },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 2, 20)  end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, self:spellCrit(t.getDuration(self, t)),
			DamageType.WARDING, self:spellCrit(t.getDamage(self, t)),
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{zdepth=6, overlay_particle={zdepth=6, only_one=true, type="circle", args={appear=8, oversize=0, img="moon_circle", radius=self:getTalentRadius(t)}}, color_br=255, color_bg=255, color_bb=255, effect_shader="shader_images/moonlight_effect.png"},
			nil, self:spellFriendlyFire(true)
		)
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 你 的 脚 下 制 造 一 个 %d 码 半 径 范 围 的 法 阵， 它 会 减 慢 %d%% 抛 射 物 速 度 并 将 除 你 外 的 其 他 生 物 推 出 去。 
		 同 时， 每 回 合 对 目 标 造 成 %0.2f 光 系 伤 害 和 %0.2f 暗 影 伤 害。 
		 法 阵 持 续 %d 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(radius, damage*5, (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}


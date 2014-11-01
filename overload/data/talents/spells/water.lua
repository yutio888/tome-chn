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
	name = "Glacial Vapour",
	type = {"spell/water",1},
	require = spells_req1,
	points = 5,
	random_ego = "attack",
	mana = 12,
	cooldown = 8,
	tactical = { ATTACKAREA = { COLD = 2 } },
	range = 8,
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.GLACIAL_VAPOUR, t.getDamage(self, t),
			self:getTalentRadius(t),
			5, nil,
			{type="ice_vapour"},
			nil, self:spellFriendlyFire()
		)
		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码 半 径 范 围 内 升 起 一 片 寒 冷 的 冰 雾， 每 回 合 造 成 %0.2f 冰 冷 伤 害， 持 续 %d 回 合。 
		 处 于 湿 润 状 态 的 生 物 承 受 额 外 30%%伤 害， 并 有 15%% 几 率 被 冻 结。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

newTalent{
	name = "Freeze",
	type = {"spell/water", 2},
	require = spells_req2,
	points = 5,
	random_ego = "attack",
	mana = 14,
	cooldown = function(self, t)
		local mod = 1
		if self:attr("freeze_next_cd_reduce") then mod = 1 - self.freeze_next_cd_reduce self:attr("freeze_next_cd_reduce", -self.freeze_next_cd_reduce) end
		return math.floor(self:combatTalentLimit(t, 20, 8, 12, true)) * mod
	end, -- Limit cooldown <20
	tactical = { ATTACK = { COLD = 1 }, DISABLE = { stun = 3 } },
	range = 10,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 12, 180) * t.cooldown(self,t) / 6 end, -- Gradually increase burst potential with c/d
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not x or not y then return nil end

		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.COLD, dam, {type="freeze"})
		self:project(tg, x, y, DamageType.FREEZE, {dur=t.getDuration(self, t), hp=70 + dam * 1.5})

		if target and self:reactionToward(target) >= 0 then
			self:attr("freeze_next_cd_reduce", 0.5)
		end

		game:playSoundNear(self, "talents/water")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[凝 聚 周 围 的 水 冻 结 目 标 %d 回 合 并 对 其 造 成 %0.2f 伤 害。 
		 如 果 目 标 为 友 好 生 物 ， 冷 却 时 间 减 半。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.getDuration(self, t), damDesc(self, DamageType.COLD, damage))
	end,
}

newTalent{
	name = "Tidal Wave",
	type = {"spell/water",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 10,
	tactical = { ESCAPE = { knockback = 2 }, ATTACKAREA = { COLD = 0.5, PHYSICAL = 0.5 }, DISABLE = { knockback = 1 } },
	direct_hit = true,
	range = 0,
	requires_target = true,
	radius = function(self, t)
		return 1 + 0.5 * t.getDuration(self, t)
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 90) end,
	getDuration = function(self, t) return 3 + self:combatTalentSpellDamage(t, 5, 5) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.WAVE, {dam=t.getDamage(self, t), x=self.x, y=self.y, apply_wet=5},
			1,
			5, nil,
			MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader="shader_images/water_effect1.png"},
--			MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader={"shader_images/water_effect1.png","shader_images/water_effect2.png", max=6}},
			function(e)
				e.radius = e.radius + 0.5
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[以 施 法 者 为 中 心， 在 1 码 半 径 范 围 内 生 成 一 股 巨 浪， 每 回 合 增 加 1 码 半 径 范 围， 最 大 %d 码。 
		 对 目 标 造 成 %0.2f 冰 冷 伤 害 和 %0.2f 物 理 伤 害， 同 时 击 退 目 标， 持 续 %d 回 合。 
		 所 有 受 影 响 的 生 物 进 入 湿 润 状 态 ， 震 慑 抗 性 减 半。
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.COLD, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

newTalent{
	name = "Shivgoroth Form",
	type = {"spell/water",4},
	require = spells_req4,
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 20,
	tactical = { BUFF = 3, ATTACKAREA = { COLD = 0.5, PHYSICAL = 0.5 }, DISABLE = { knockback = 1 } },
	direct_hit = true,
	range = 10,
	no_energy = true,
	requires_target = true,
	getDuration = function(self, t) return 4 + math.ceil(self:getTalentLevel(t)) end,
	getPower = function(self, t) return util.bound(50 + self:combatTalentSpellDamage(t, 50, 450), 0, 500) / 500 end,
	on_pre_use = function(self, t, silent) if self:attr("is_shivgoroth") then if not silent then game.logPlayer(self, "You are already a Shivgoroth!") end return false end return true end,
	on_unlearn = function(self, t)
		if self:getTalentLevel(t) == 0 then
			self:removeEffect(self.EFF_SHIVGOROTH_FORM, true, true)
		end
	end,
	action = function(self, t)
		self:setEffect(self.EFF_SHIVGOROTH_FORM, t.getDuration(self, t), {power=t.getPower(self, t), lvl=self:getTalentLevelRaw(t)})
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你 吸 收 周 围 的 寒 冰 围 绕 你， 将 自 己 转 变 为 纯 粹 的 冰 元 素 — — 西 码 罗 斯， 持 续 %d 回 合。 
		 转 化 成 元 素 后， 你 不 需 要 呼 吸 并 获 得 等 级 %d 的 冰 雪 风 暴， 所 有 冰 冷 伤 害 可 对 你 产 生 治 疗， 治 疗 量 基 于 伤 害 值 的 %d%% 。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100)
	end,
}

newTalent{
	name = "Ice Storm",
	type = {"spell/other",1},
	points = 5,
	random_ego = "attack",
	mana = 25,
	cooldown = 20,
	tactical = { ATTACKAREA = { COLD = 2, stun = 1 } },
	range = 0,
	radius = 3,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 90) end,
	getDuration = function(self, t) return 5 + self:combatSpellpower(0.05) + self:getTalentLevel(t) end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.ICE_STORM, t.getDamage(self, t),
			3,
			5, nil,
			{type="icestorm", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/icestorm")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[召 唤 一 股 激 烈 的 暴 风 雪 围 绕 着 施 法 者， 在 3 码 范 围 内 每 回 合 对 目 标 造 成 %0.2f 冰 冷 伤 害， 持 续 %d 回 合。 
		 它 有 25%% 概 率 冰 冻 受 影 响 目 标。 
		 如 果 目 标 处 于 湿 润 状 态 ， 伤 害 增 加 30%%， 同 时 冻 结 率 上 升 至 50%%。
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}
